declare function collidefleets() as short
declare function movefleets() as short
declare function makefleet(f as _fleet) as _fleet
declare function makepatrol() as _fleet
declare function makemerchantfleet() as _fleet
declare function makepiratefleet(modifier as short=0) as _fleet
declare function updatetargetlist()as short
declare function bestpilotinfleet(f as _fleet) as short
declare function addfleets(target as _fleet, source as _fleet) as _fleet    
declare function piratecrunch(f as _fleet) as _fleet
declare function clearfleetlist() as short
declare function countfleet(ty as short) as short
declare function meetfleet(f as short, player as _ship)as _ship
declare function debug_printfleet(f as _fleet) as string
declare function fleetbattle(byval red as _fleet,byval blue as _fleet) as _fleet
declare function scorefleet(byval f as _fleet) as integer
declare function makequestfleet(a as short) as _fleet
declare function makealienfleet() as _fleet


function meetfleet(f as short, player as _ship)as _ship
    static lastturncalled as integer
    dim as short aggr,roll,frd,des,dialog,a,total,cloak,x,y
    dim question(2,4) as string
    if findbest(25,-1)>0 then cloak=5
    if player.turn>lastturncalled+2 and fleet(f).ty>0 and player.dead=0 and just_run=0 then
            
        question(1,1)="A Merchant Convoy hails us. Attack anyway? (y/n)"
        question(2,1)="A Merchant Concoy. Their Escorts are on intercept course! Stay and fight? (y/n)"
        
        question(1,2)="A fleet without friend foe signature. Attack them? (y/n)"
        question(2,2)="An unidentified sensor blip. Engage? (y/n)"
        
        question(1,3)="A company battleship on anti pirate patrol. They hail us. Attack anyway? (y/n)"
        question(2,3)="A company battleship hails us 'Pirate Vessel stand down and prepare to be boareded.' Stay and fight? (y/n)"
        
        question(1,4)="A huge, fast ship on an intercept course! Shall we engage? (y/n)"
        question(2,4)="A huge, fast ship on an intercept course! Shall we engage? (y/n)"
        if fleet(f).ty=1 or fleet(f).ty=3 then
            aggr=player.merchant_agr
            dialog=fleet(f).ty
        else
            aggr=player.pirate_agr
            dialog=2
        endif
        if fleet(f).ty=5 then 
            dialog=4
            aggr=100
        endif
        roll=rnd_range(1,20)+aggr
        if roll>100 then 
            frd=2 'tries to attack
        else
            frd=1 'tries to talk
        endif
        des=askyn(question(frd,dialog))
        if des=0 then
            if frd=2 then
                if rnd_range(1,6)+rnd_range(1,6)+player.pilot+cloak>10 then
                    dprint "you got away"
                else
                    dprint "they are closing in"
                    des=-1
                endif
            else
                dprint "you return the greeting"
            endif
        endif
        if des=-1 then 
            if dialog=2 then 'pirate
                player.merchant_agr=player.merchant_agr-65/disnbase(player.c)
                player.pirate_agr=player.pirate_agr+65/dispbase(player.c)
            else
                player.merchant_agr=player.merchant_agr+65/disnbase(player.c)
                player.pirate_agr=player.pirate_agr-65/dispbase(player.c)
            endif
            for a=1 to 5
                basis(10).inv(a).v=0
                basis(10).inv(a).p=0
            next
            fleet(f)=unload_f(fleet(f),10)
            player=spacecombat(player,fleet(f),spacemap(player.c.x,player.c.y))
            if player.dead=0 and fleet(f).flag>0 then player.questflag(fleet(f).flag)=2
            if player.dead>0 and fleet(f).ty=5 then player.dead=21
            for a=1 to 5
                total=total+basis(10).inv(a).v
            next 
            'dprint ""&total
            if total>0 and player.dead=0 then trading(10)
            if player.dead=-1 then player.dead=0
            if player.dead>0 then
                for a=1 to 128
                    if crew(a).hpmax>0 then player.deadredshirts+=1
                next
                if fleet(f).ty=2 then
                    player.dead=5
                else 
                    player.dead=13
                endif
            endif
            fleet(f).ty=0
            cls
        endif
        lastturncalled=player.turn
        
    endif
    show_stars(1)
    displayship
    return player
end function


function fleetbattle(byval red as _fleet,byval blue as _fleet) as _fleet
    dim as integer rscore,bscore
    do
    rscore=scorefleet(red)
    bscore=scorefleet(blue)
    rscore=rscore+rnd_range(1,6)
    bscore=bscore+rnd_range(1,6)
    if abs(bscore-rscore)<10 then
        red.mem(rnd_range(1,15))=empty_ship
        blue.mem(rnd_range(1,15))=empty_ship
    endif
    loop until abs(bscore-rscore)>=10 or rscore<10 or bscore<10
    if rscore>bscore then
        return red
    else
        return blue
    endif
end function

function scorefleet(byval f as _fleet) as integer
    dim as integer a,b,scr
    for a=1 to 15
        scr=scr+f.mem(a).hull
        scr=scr+f.mem(a).shieldmax
        scr=scr+f.mem(a).engine
        scr=scr+f.mem(a).sensors
        scr=scr+f.mem(a).gunner
        for b=1 to 25
            scr=scr+f.mem(a).weapons(b).dam
        next
    next
    return scr
end function
        
function collidefleets() as short
    dim as short a,b,c    
    for a=1 to lastfleet
        for b=a to lastfleet
            if b<>a then
                if distance(fleet(a).c,fleet(b).c)<2 and fleet(a).ty>0 and fleet(b).ty>0 then
                    c=c+1
                    if show_npcs=1 then dprint a &" meets " & b
                    if show_npcs=1 then dprint (debug_printfleet(fleet(a)) &":" &debug_printfleet(fleet(b)))
                    if fleet(a).ty<>fleet(b).ty then
                        if fightmatrix(fleet(a).ty,fleet(b).ty)=1 then    '
                            if fleet(a).ty=1 and fleet(b).ty=2 then 
                                patrolmod=patrolmod+1
                                if rnd_range(1,100)<10 and lastdrifting<128 then
                                    lastdrifting+=1                                    
                                    lastplanet+=1
                                    drifting(lastdrifting).x=fleet(a).c.x
                                    drifting(lastdrifting).y=fleet(a).c.y
                                    drifting(lastdrifting).s=rnd_range(1,16)
                                    drifting(lastdrifting).m=lastplanet
                                    makedrifter(drifting(lastdrifting))
                                    planets(lastplanet).darkness=0
                                    planets(lastplanet).depth=1
                                    planets(lastplanet).atmos=4
                                    planets(lastplanet).mon=32
                                    planets(lastplanet).mon2=33
                                    planets(lastplanet).flavortext="No hum from the engines is heard as you enter the " &shiptypes(drifting(a).s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
                                endif
                            endif
                            if fleet(a).ty=2 and fleet(b).ty=1 then 
                                patrolmod=patrolmod+1
                                if rnd_range(1,100)<10 and lastdrifting<128 then
                                    lastdrifting+=1                                    
                                    lastplanet+=1
                                    drifting(lastdrifting).x=fleet(a).c.x
                                    drifting(lastdrifting).y=fleet(a).c.y
                                    drifting(lastdrifting).s=rnd_range(1,16)
                                    drifting(lastdrifting).m=lastplanet
                                    makedrifter(drifting(lastdrifting))
                                    planets(lastplanet).darkness=0
                                    planets(lastplanet).depth=1
                                    planets(lastplanet).atmos=4
                                    planets(lastplanet).mon=32
                                    planets(lastplanet).mon2=33
                                    planets(lastplanet).flavortext="No hum from the engines is heard as you enter the " &shiptypes(drifting(a).s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
                                endif
                            endif
                            fleet(a)=fleetbattle(fleet(a),fleet(b))
                            fleet(b).ty=0
                        endif
                    else
                        if fleet(a).ty=2 and distance(fleet(a).c,fleet(b).c)<1 then fleet(a)=addfleets(fleet(a),fleet(b))
                    endif
                    if show_npcs=1 then dprint debug_printfleet(fleet(a)) &":" &debug_printfleet(fleet(b))
                endif
            endif
        next
    next
    return 0
end function

function movefleets() as short
    dim as short a,roll,direction
    a=0
    for a=1 to lastfleet
        updatetargetlist()
        roll=rnd_range(1,6)+rnd_range(1,6)+bestpilotinfleet(fleet(a))
        if roll>7 then
            'move towards target
            direction=nearest(targetlist(fleet(a).t),fleet(a).c)
        else
            'move random
            direction=5
        endif
        if show_npcs=1 and fleet(a).ty>0 then
            color 0,0
            locate fleet(a).c.y+1,fleet(a).c.x+1
            print "   "
        endif
        fleet(a).c=movepoint(fleet(a).c,direction,,1)
        if show_npcs=1 then
            color fleet(a).ty+10,0
            locate fleet(a).c.y+1,fleet(a).c.x+1
            print "F"&a 
        endif
        
        'Check if reached target (for targetnumbers 1-7)
        if fleet(a).c.x=targetlist(fleet(a).t).x and fleet(a).c.y=targetlist(fleet(a).t).y and fleet(a).t<7 then
            if fleet(a).ty=1 then fleet(a)=merctrade(fleet(a))
            fleet(a).t=fleet(a).t+1 'Pirates have targetnumbers 8 or 9, they will never see this
            if fleet(a).t>lastwaypoint then fleet(a).t=0
        endif
    next
    return 0
end function

function makefleet(f as _fleet) as _fleet
    dim as short roll
    roll=rnd_range(1,6)
    if countfleet(1)<countfleet(2) or player.merchant_agr>player.pirate_agr then 
        f=makemerchantfleet
    else
        if _easy=1 or player.turn>250 then 
            f=makepiratefleet
        else
            f=makepatrol
        endif
    endif
    if roll+patrolmod>10 then 
        if show_npcs=1 then dprint roll &":" &patrolmod
        f=makepatrol
        patrolmod=0
        makepat=makepat+1
    endif
    if frac(player.turn/100)=0 and player.turn>1000 then f=makealienfleet
    return f 
end function

function makequestfleet(a as short) as _fleet
    dim f as _fleet
    dim as short b
    b=rnd_range(1,_NoPB)
    if a=1 then
        f.ty=4
        f.t=8 'All pirates start with target 9 (random point)
        f.c=map(piratebase(b)).c
        f.mem(1)=makeship(8)
        f.flag=15'the infamous anne bonny
    endif
    if a=2 then
        f.ty=4
        f.t=8 'All pirates start with target 9 (random point)
        f.c=map(piratebase(b)).c
        f.mem(1)=makeship(10) 'the infamous black corsair
        f.mem(2)=makeship(2)
        f.mem(3)=makeship(2)
        f.flag=16
    endif
    if a=3 then
        f.ty=4
        f.t=8 'All pirates start with target 9 (random point)
        f.c=map(piratebase(b)).c
        f.mem(1)=makeship(30) 'the infamous anne bonny
        f.mem(2)=makeship(2)
        f.mem(3)=makeship(2)
        f.flag=17
    endif
    if a=4 then
        f.ty=4
        f.t=8 'All pirates start with target 9 (random point)
        f.c=map(piratebase(b)).c
        f.mem(1)=makeship(31) 'the infamous anne bonny
        f.mem(2)=makeship(2)
        f.mem(3)=makeship(2)
        f.mem(4)=makeship(2)
        f.flag=18
    endif
    if a=5 then
        f.ty=4
        f.t=8 'All pirates start with target 9 (random point)
        f.c=map(piratebase(b)).c
        f.mem(1)=makeship(32) 'the infamous anne bonny
        f.mem(2)=makeship(2)
        f.mem(3)=makeship(2)
        f.flag=19
    endif
    
    return f
end function

function makepatrol() as _fleet
    dim f as _fleet
    f.ty=3
    f.mem(1)=makeship(9)
    f.mem(2)=makeship(7)
    f.mem(3)=makeship(7)'one company battleship
    if rnd_range(1,100)>75 then f.mem(4)=makeship(9)
    if rnd_range(1,100)>45 then f.mem(5)=makeship(7)
    return f
end function

function makemerchantfleet() as _fleet
    dim f as _fleet
    dim text as string
    dim as short a,b
    f.ty=1
    a=rnd_range(1,2)
    for b=1 to a
        f.mem(b)=makeship(6) 'merchantmen
        text=text &f.mem(b).icon
    next
    if rnd_range(1,100)>80-makepat*2 then
        for b=a+1 to a+2
            if rnd_range(1,100)<45+makepat then
                f.mem(b)=makeship(7) 'escorts
                text=text &f.mem(b).icon
            else
                f.mem(b)=makeship(12)
            endif
        next
    endif
    if show_NPCs=1 then dprint ""&a &":"& b &":"& text
    return f
end function 

function makepiratefleet(modifier as short=0) as _fleet
    dim f as _fleet
    dim as short maxroll,r,a
    
    dim as short b,c
    do
        b=rnd_range(0,_NoPB+1)
        if b>_NoPB then b=0
        c=c+1
    loop until piratebase(b)>0 or c>500
    if c>500 then return f
    f.ty=2
    f.t=9 'All pirates start with target 9 (random point)
    f.c=map(piratebase(b)).c
    maxroll=player.turn/120
    if maxroll>60 then maxroll=60
    for a=1 to rnd_range(1,2)+maxroll/20    
        r=rnd_range(1,maxroll)+modifier
        f.mem(a)=makeship(2)
        if r>15 then f.mem(a)=makeship(3)
        if r>35 then f.mem(a)=makeship(4)
        if r>45 then f.mem(a)=makeship(5)
   next a
    return f
end function

function makealienfleet() as _fleet
    dim f as _fleet
    f.ty=5
    f.mem(0)=makeship(11)
    f.c=map(sysfrommap(specialplanet(9))).c
    return f
end function

function addfleets(byref target as _fleet,byref source as _fleet) as _fleet
    dim as short a,b
    dim text as string
    ' Find last ship of target
    do
        a=a+1
        text=text & target.mem(a).icon
    loop until target.mem(a).hull=0 or a>14
    if a<15 then
        do 
            b=b+1
            target.mem(a)=source.mem(b)
            text=text & target.mem(a).icon
 
            a=a+1
        loop until a>14 or b>14
        source=empty_fleet
    endif
    if target.ty=2 then target=piratecrunch(target)
    
    if show_NPCs=1 then dprint text
    return target
end function

function piratecrunch(fl as _fleet) as _fleet
    'Turns pirates into bigger ship. 3 F=1C 3C=1D 3D=1B
    dim r as _fleet
    dim as short ss,ts,a,i
    dim as string w,search(3)
    dim as short f,c,d,b,counter
    
    dim p as short
    do
        b=rnd_range(0,_NoPB+1)
        if b>_NoPB then b=0
        c=c+1
    loop until piratebase(b)>0 or c>500
    if c>500 then return r
    p=b
    c=0
    b=0
    for a=0 to 10
        if fl.mem(a).icon="F" then f=f+1
        if fl.mem(a).icon="C" then c=c+1
        if fl.mem(a).icon="D" then d=d+1
    next
    if f<=5 and c<=4 and d<=3 then 
        r=fl
    else
        do 
            counter=counter+1
            if f>5 then
                f=f-5
                c=c+1
            endif
            if c>4 then
                c=c-4
                d=d+1
            endif
            if d>3 then
                d=d-3
                b=b+1
            endif
        loop until (f<=3 and c<=3 and d<=3) or counter>15
        for a=1 to f
            r.mem(a)=makeship(2)
        next
        for a=f+1 to f+c
            r.mem(a)=makeship(3)
        next
        for a=f+c+1 to f+c+d
            r.mem(a)=makeship(4)
        next
        if b>1 then r.mem(b+c+d+1)=makeship(5)
    endif
    r.ty=2
    r.c=map(piratebase(p)).c
    r.t=8
    return r
end function

function clearfleetlist() as short
    dim as short a,b,c
    do
    c=0
    countpatrol=0
    for a=1 to lastfleet
        if fleet(a).ty=3 then countpatrol=countpatrol+1
        if fleet(a).ty=0 then
            c=c+1
            fleet(a)=fleet(lastfleet)
            lastfleet=lastfleet-1
        endif
    next
    loop until c=0
    return 0
end function

function bestpilotinfleet(f as _fleet) as short
    dim as short a,r
    for a=1 to 15
        if f.mem(a).pilot>r then r=f.mem(a).pilot
    next
    return r
end function

function countfleet(ty as short) as short
    dim as short a,r
    for a=1 to lastfleet
        if fleet(a).ty=ty then r=r+1
    next
    return r
end function

function updatetargetlist()as short
    static lastcalled as short
    dim b as short
    b=rnd_range(0,_NoPB+1)
    if b>_NoPB then b=0
    if piratebase(b)<0 then return 0
    targetlist(8).x=player.c.x
    targetlist(8).y=player.c.y
    if frac(lastcalled/25)=0 then
    targetlist(9).x=map(piratebase(b)).c.x-30+rnd_range(0,60)
    targetlist(9).y=map(piratebase(b)).c.y-10+rnd_range(0,20)
    'targetlist(9)=fleet(rnd_range(1,lastfleet)).c
    endif
    lastcalled=lastcalled+1
    return 0
end function

function makemonster(a as short,awayteam as _monster,map as short,spawnmask()as cords,lsp as short ,x as short=0,y as short=0,mslot as short=0) as _monster    
    dim enemy as _monster
    dim as short b,c,l,mapo,g,r
    dim as single easy
    static ti(11) as string
    static ch(11) as short
    static ad(11) as single
    if a=0 then
        if _debug=1 then dprint "ERROR: Making monster 0",14,14
        return enemy
    endif
    ti(0)="avian"
    ti(1)="arachnide"
    ti(2)="insect"
    ti(3)="mammal"
    ti(4)="reptile"
    ti(5)="snake"
    ti(6)="humanoid"
    ti(7)="cephalopod"
    ti(8)="centipede"
    ti(9)="amphibian"
    ti(10)="gastropod"
    ti(11)="fish"
    ad(0)=1
    ad(1)=0
    ad(2)=0
    ad(3)=3
    ad(4)=3
    ad(5)=1
    ad(6)=2
    ad(7)=1
    ad(8)=1
    ad(9)=1
    ad(10)=1
    
    ch(0)=66
    ch(1)=65
    ch(2)=73
    ch(3)=77
    ch(4)=82
    ch(5)=asc("s")
    ch(6)=asc("h")
    ch(7)=asc("q")
    ch(8)=asc("c")
    ch(9)=asc("f")
    ch(10)=asc("g")
    ch(11)=asc("f")
    
    b=(awayteam.hp\3)+1 'HD size
    b=b+planets(map).depth
    if b<5 then b=5
    if b>12 then b=12
    
    c=(awayteam.hp\12)+1 'Times rolled
    if c<1 then c=1
    if c>13 then c=13
     'maxpossible
    l=rnd_range(0,lsp)
    if x=0 then x=spawnmask(l).x
    if y=0 then y=spawnmask(l).y
    enemy.c.x=x
    enemy.c.y=y    
        
    enemy.made=a 'saves how the critter was made for respawning
    'a=1 Standard critter
    'a=2 Powerful standard critter
    'a=3 Pirate band
    'a=4 Plantmonster
    'a=5 Fighting leaf
    'a=6 Merry pirate band
    'a=7 Defense bots
    'a=8 Vault defense bots
    'a=10 Seewead breeder
    'a=15 Awayteam
    if a=1 or a=24 then 'standard critter
        'Postion
        
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)
        
        'Behavior
        enemy.aggr=rnd_range(0,2)
        enemy.respawns=1
        enemy.diet=rnd_range(1,3) '1 predator, 2 herbivore, 3 scavenger
        enemy.move=(rnd_range(0,5)+rnd_range(0,4)+rnd_range(0,enemy.weapon))/10
        if enemy.move<=0.7 then enemy.move=0.7
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then
            if a=1 or rnd_range(1,100)>66 then
                enemy.stuff(2)=1 'Vögel können fliegen
                enemy.stuff(1)=1
            endif
        endif
        'Looks
        enemy.cmmod=rnd_range(1,2)
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.lang=-1
        enemy.diet=1
        enemy.atcost=rnd_range(7,10)/10
        enemy.intel=rnd_range(1,5)
        if a=1 then enemy.intel=enemy.intel+rnd_range(1,3)
        if rnd_range(1,15)<enemy.intel then enemy.aggr=1
        if enemy.intel=6 and rnd_range(1,100)<33 then
            enemy.range=3
            enemy.sight=3
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="shoots bows and arrows"
            enemy.scol=4
            enemy.atcost=rnd_range(6,8)/10
            if rnd_range(1,100)<15 then placeitem(makeitem(94),x,y,map,mslot)
            if rnd_range(1,100)<55 then placeitem(makeitem(91),x,y,map,mslot)
        endif
        if enemy.intel>=7 and rnd_range(1,100)<33  then
            enemy.range=4
            enemy.sight=4
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="fires a primitive handgun"
            enemy.scol=7
            enemy.atcost=rnd_range(5,7)/10
            if rnd_range(1,100)<15 then placeitem(makeitem(94),x,y,map,mslot)
            if rnd_range(1,100)<15 then placeitem(makeitem(94),x,y,map,mslot)
            if rnd_range(1,100)<55 then placeitem(makeitem(92),x,y,map,mslot)
        endif
        g=rnd_range(0,10)
        if a=24 and rnd_range(1,100)>50 then g=11
        enemy.tile=ch(g)
        enemy.sprite=261+g
        if g=1 then enemy.stuff(2)=1 'Spinnen klettern
        if g=6 then enemy.intel=enemy.intel+1
        if g=9 or a=24 then enemy.stuff(1)=1
        if g=10 then enemy.move=enemy.move-0.3
        if rnd_range(1,100)<25-enemy.intel then enemy.disease=rnd_range(1,15)
        mapo=2*(c+ad(g))*b
        for l=1 to c+ad(g)
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hpmax=enemy.hp
        'enemy.col=rnd_range(2,5)
        enemy.col=rnd_range(90,122)
        enemy.sdesc=ti(g)
        enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)
        if a=24 then enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,1,planets(map).depth)
        if instr(enemy.ldesc,"horn")>0 then enemy.weapon=enemy.weapon+1
        if instr(enemy.ldesc,"spiked")>0 then enemy.weapon=enemy.weapon+1
        if instr(enemy.ldesc,"stinger")>0 then 
            enemy.weapon=enemy.weapon+1
            enemy.atcost=enemy.atcost-0.2
        endif
        if instr(enemy.ldesc,"exoskeleton")>0 then enemy.armor=1
        if instr(enemy.ldesc,"chitin")>0 then enemy.armor=2
        if enemy.hp>mapo*0.8 then enemy.col=10
        if enemy.weapon>0 then enemy.col=12
        if enemy.hp>mapo*0.8 and enemy.weapon>0 then enemy.col=13
        if rnd_range(1,15)<planets(map).depth then
            enemy.breedson=rnd_range(0,5+planets(map).depth)
        endif
        if enemy.breedson=0 and enemy.aggr=0 and enemy.intel<4 and rnd_range(1,100)<33 then
            enemy.hp=enemy.hp+rnd_range(1,b)+rnd_range(1,b)
            enemy.hpmax=enemy.hp
            enemy.invis=2
            enemy.aggr=0
            enemy.weapon+=2
            enemy.move=enemy.move+.4
            enemy.atcost=enemy.atcost-0.2
            enemy.diet=1
        endif
        if enemy.armor=0 then 
            enemy.tile=asc(lcase(chr(enemy.tile)))
        else
            enemy.tile=asc(ucase(chr(enemy.tile)))
        endif
        'enemy.invis=2
    endif
    
    if a=2 then 'Powerful standard critter
        'Postion
        
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to c+1+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,b)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=1
        enemy.biomod=1.5
        enemy.diet=1
        enemy.move=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        
        enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.atcost=rnd_range(6,8)/10
        if enemy.move<=0.9 then enemy.move=0.9
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.stuff(2)=1 'Vögel können fliegen
            enemy.stuff(1)=1
            g=1
            enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            enemy.hasoxy=1
            select case planets(map).temp
                   case is>200
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.move=0.6
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.move=0.4
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.move=0.5
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                enemy.biomod=2.2
                for l=0 to rnd_range(2,5)
                    if rnd_range(1,100)<33 then placeitem(makeitem(99,-4,5),x,y,map,mslot)
                next
            endif
            If planets(map).depth>0 then
                enemy.stuff(5)=1
                enemy.track=4
                enemy.weapon=5
                enemy.move=0.3
                enemy.armor=2
                enemy.col=7
                enemy.tile=asc("W")
                enemy.track=4
                enemy.sdesc="stoneworm"
                enemy.sprite=275
                enemy.ldesc="This creature slowly digs through the stone, gnawing at it with metal teeth. It's thick skin is embedded with rocks and stones for protection."
            endif
        endif
                
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        if enemy.tile=22 then enemy.stuff(1)=1 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=3 or a=7 then'Pirate band
         '7 Non agressive
        'Postion
        enemy.c.x=x
        enemy.c.y=y
        enemy.atcost=rnd_range(7,9)/10
        enemy.hasoxy=1
            
        'Fighting Stats
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(2,b)
        next
        enemy.hp=enemy.hp+5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.move=(rnd_range(0,4)+rnd_range(0,3)+rnd_range(0,enemy.weapon))/10
        if enemy.move<=0.5 then enemy.move=.6
        enemy.stuff(1)=rnd_range(0,1)
        enemy.stuff(2)=rnd_range(0,1)
        'Looks
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("P")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        r=rnd_range(1,10)
        if r<5 then
            enemy.col=192
            enemy.sdesc="pirate band"
        endif
        if r>4 and r<9 then 
            enemy.col=186
            enemy.sdesc="pirate shipcrew"
            enemy.armor=1
            enemy.weapon=enemy.weapon+1
            enemy.move=.8
            for l=0 to rnd_range(1,2)
                if rnd_range(1,100)<33 then placeitem(rnd_item(20),x,y,map,mslot)
            next
        endif
        if r>8 then
            enemy.col=108  
            enemy.sdesc="pirate elite troopers"
            enemy.armor=2
            enemy.weapon=enemy.weapon+2
            enemy.hp=enemy.hp+rnd_range(1,6)
            enemy.swhat="shoot plasmarifles "
            enemy.scol=20
            enemy.move=.9
            enemy.atcost=rnd_range(5,7)/10
            for l=0 to rnd_range(1,2)
                if rnd_range(1,100)<33 then placeitem(rnd_item(20),x,y,map,mslot)
            next
        endif
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
        for l=0 to rnd_range(1,4)
            if rnd_range(1,100)<33 then placeitem(rnd_item(20),x,y,map,mslot)
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=9
        if player.pirate_agr>0 or a=3 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
    endif
    
    if a=4 then 'Plantmonster 
            
        enemy.c.x=x
        enemy.c.y=y
        enemy.move=-1
        
        enemy.weapon=rnd_range(0,1)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,b)+rnd_range(1,b))*(enemy.weapon+1)
        
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.biomod=1.2
        enemy.tile=ASC("P")
        enemy.sprite=277
        enemy.col=4
        enemy.scol=4
        enemy.atcost=rnd_range(6,8)/10
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="shoots a volley of sharp thorns"
        enemy.sdesc="Plantmonster"
        enemy.ldesc="A squat brownish trunk, 1.5 to 2m high, covered by dark green leaves. Extremly long vines are used to gather food for this immobile creature"
    endif
    
    if a=5 then 'apollo
        enemy.lang=4
        enemy.c.x=x
        enemy.c.y=y
        enemy.weapon=4
        enemy.range=1.5
        enemy.hp=rnd_range(20,35)
        enemy.armor=2
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.move=1.5
        enemy.tile=ASC("H")
        enemy.sprite=278
        enemy.col=14
        enemy.scol=11
        enemy.atcost=rnd_range(3,4)/10
        for l=1 to 5
            enemy.stuff(l)=1
        next
        enemy.hasoxy=1
            
        enemy.sight=7
        enemy.biomod=2
        enemy.respawns=0
        enemy.dhurt="hurt"
        enemy.dkill="dies"   
        enemy.swhat="shoots a lightning bolt "
        enemy.sdesc="Apollo"
        enemy.ldesc="3 Meters tall, a mountain of muscles, lightning strikes wherever he points"
    endif
    
    if a=6 then 'Fighting leaf
        'Postion
        enemy.c.x=x
        enemy.c.y=y
        
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=0
        
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(8,10)
        
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.move=0.9
        enemy.stuff(2)=1 
        enemy.stuff(1)=1
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="leaf"
        enemy.ldesc="four prehensile leafs lift this small creature in the air. A dark red, woody appendege drips poison" 
        enemy.lang=-1
        enemy.biomod=0.5
        enemy.atcost=.1
        enemy.tile=ASC("o")
        enemy.sprite=279
        enemy.col=10
    endif
    
    if a=8 then 'robots
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shots a disintegrator beam "
        enemy.scol=12
        enemy.armor=2
        enemy.respawns=0
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
            
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.hp=5+enemy.hp+b+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.move=0.9
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)/10
        if rnd_range(1,100)<33 then
            enemy.move=1.6
            enemy.col=11
            enemy.sdesc="fast robot"
            enemy.sight=enemy.sight+3
            enemy.armor=0
            enemy.sprite=281
            enemy.atcost=rnd_range(4,6)/10
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        endif
        if rnd_range(1,100)<23 then
            enemy.move=.6
            enemy.col=20
            enemy.sdesc="armored robot"
            enemy.sight=enemy.sight+3
            enemy.armor=5
            enemy.sprite=282
            enemy.atcost=rnd_range(8,10)/10
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        endif
        for l=0 to rnd_range(1,4)
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        next           
    endif
    
    if a=9 then 'Vault bots
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It wobbly floats, obviously using some sort of antigrav."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
            
        enemy.atcost=rnd_range(6,8)/10
        for l=1 to c+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.hp=15+enemy.hp+b+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)-2+awayteam.weapon
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon+1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.move=0.7
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        if rnd_range(1,100)<33 then
            enemy.move=1.6
            enemy.col=11
            enemy.sdesc="fast robot"
            enemy.sight=enemy.sight+3
            enemy.armor=0
            enemy.sprite=280
            enemy.atcost=rnd_range(3,4)/10
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        endif
        if rnd_range(1,100)<23 then
            enemy.move=.6
            enemy.col=20
            enemy.sdesc="armored robot"
            enemy.sight=enemy.sight+3
            enemy.armor=5
            enemy.weapon=enemy.weapon+1
            enemy.range=1.5
            enemy.atcost=rnd_range(7,9)/10
            enemy.sprite=282
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        endif
        for l=0 to rnd_range(2,6)
            if rnd_range(1,100)<33 then placeitem(makeitem(96,rnd_range(1,3),-3),x,y,map,mslot)
        next
    endif
            
    if a=10 then 'seeweed
    'Postion
        enemy.c.x=x
        enemy.c.y=y
        enemy.made=10
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=0
        
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(8,10)
        enemy.biomod=0.5
        'Behavior
        enemy.aggr=1
        enemy.respawns=1
        enemy.breedson=12
        enemy.move=0.3
        enemy.stuff(2)=0 
        enemy.stuff(1)=1
        enemy.atcost=rnd_range(6,8)/10
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Seawead"
        enemy.ldesc="growing upwards from the bottom of the ocean, this seawead grows incredibly fast. It lazily brushes around, leaving acidburns on any fish or flesh it touches. obviously a carnivorous plant"
        
        enemy.tile=Asc("o")
        enemy.sprite=283
        enemy.col=10
    endif
     
    if a=11 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.made=11
        enemy.hp=rnd_range(1,c)+rnd_range(1,c)+rnd_range(1,c)+50        
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.armor=3
        enemy.weapon=2
        enemy.move=1.5
        enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=1.5
        enemy.aggr=0
        enemy.tile=Asc("W")
        enemy.sprite=284
        enemy.col=14
        enemy.atcost=rnd_range(3,5)/10
        enemy.sight=4
        enemy.hasoxy=1
            
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Sandworm"
        enemy.ldesc="At first a wave in the sand, and then a huge maw opens to devour whatever tresspasses in his domain." 
    endif
        
    if a=12 then 'Spiders
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        enemy.hp=rnd_range(1,c)+8
        enemy.atcost=rnd_range(6,8)/10
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
    
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.move=0.8
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.sprite=285
        enemy.col=4
    endif
    
    if a=13 then 'invisibles
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="????"
        enemy.ldesc="Something is here. But you cant see anything."
        enemy.dhurt="hurt"
        enemy.dkill="silent"
        enemy.sight=4
        enemy.breedson=3
        enemy.invis=1
        enemy.range=1.5
        enemy.biomod=1.3
        enemy.atcost=rnd_range(9,12)/10
        enemy.weapon=1
        enemy.hp=rnd_range(1,b)
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.biomod=1.5
        enemy.hpmax=enemy.hp
        enemy.move=0.8
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.col=4
    endif
        
    if a=14 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=5
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)/10
        enemy.hasoxy=1
            
        enemy.tile=Asc("C")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.stuff(1)=0
        enemy.col=5
        enemy.aggr=1
    endif
    
    if a=15 then
        enemy.made=15
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=35
        enemy.sdesc="awayteam"
        enemy.ldesc="another freelancer team"
        enemy.lang=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=3
        enemy.aggr=1
        enemy.hasoxy=1
            
        enemy.diet=4 'Resources
        enemy.pumod=60
        enemy.atcost=rnd_range(6,8)/10
        for l=1 to 5
            enemy.stuff(l)=1
        next
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=9
        enemy.move=.6
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            if rnd_range(1,100)<33 then placeitem(rnd_item(21),x,y,map,mslot,0)
            if rnd_range(1,100)<15 then placeitem(makeitem(96),x,y,map,mslot,0)
        next
    endif
    
    if a=16 then 'Powerful standard critter
        'Postion
        enemy.c.x=x
        enemy.c.y=y
        
        'Fighting Stats
        enemy.range=2.5
        enemy.swhat="spits acid"
        enemy.scol=10
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        enemy.atcost=rnd_range(6,8)/10
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(2,b)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.respawns=1
        enemy.move=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        if enemy.move<=0.9 then enemy.move=.9
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.stuff(2)=1 'Vögel können fliegen
            enemy.stuff(1)=1
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        if enemy.tile=22 then enemy.stuff(1)=1 'Spinnen klettern
        enemy.col=6
        enemy.sdesc=ti(g)
        enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)
        enemy.sprite=270+g
        enemy.biomod=2.3
    endif
        
    
    if a=17 then 'Plantmonster             
        enemy.c.x=x
        enemy.c.y=y
        enemy.move=-1
        enemy.atcost=rnd_range(8,12)/10
        
        enemy.weapon=rnd_range(1,2)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,c)+rnd_range(1,c))*(enemy.weapon)
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.biomod=1.4
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.tile=80
        enemy.col=7
        enemy.scol=15
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="shoots a volley of sharp stones"
        enemy.sdesc="Stonemonster"
        enemy.ldesc="a 3m tall stalactite, yet obviously alive. roots run across the floor, some of them connecting to the carcasses of other cave dwellers."
        enemy.sprite=288
    endif
    
    if a=18 then 'cave breedworm
        'Postion
        enemy.c.x=x
        enemy.c.y=y
        enemy.atcost=rnd_range(7,9)/10
        
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to c+planets(map).depth
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)
        enemy.biomod=0.2
        'Behavior
        enemy.aggr=0
        enemy.respawns=1
        enemy.move=(rnd_range(0,4)+rnd_range(0,3)+rnd_range(0,enemy.weapon))/10
        if enemy.move<=0.5 then enemy.move=.6
        if enemy.tile=22 then enemy.stuff(2)=1 'Spinnen klettern
        enemy.stuff(1)=0
        enemy.stuff(2)=0
        enemy.stuff(3)=0
        enemy.stuff(4)=0
        enemy.stuff(5)=0
        'Looks
        enemy.cmmod=rnd_range(1,2)
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.tile=119
        enemy.sprite=289
        enemy.col=54
        enemy.sdesc="slimy worm"
        enemy.ldesc="A huge slimy worm. It seems to breed by splitting in the middle, and grows very very fast."
        enemy.breedson=rnd_range(2,8+planets(map).depth)        
        if enemy.breedson>6 then
            enemy.col=96
            enemy.armor=0
            enemy.hp=1
            enemy.hpmax=1
        endif
    endif
    
    if a=19 then 'Vault bots
        enemy.sdesc="????"
        enemy.ldesc="the air shimmers showing some kind of cloaking device."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.atcost=rnd_range(3,5)/10
        enemy.armor=2
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
            
        r=rnd_range(1,6)
        if r<4 then
            enemy.invis=1
            enemy.c.x=x
            enemy.c.y=y
            enemy.hp=rnd_range(1,c)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
            for l=1 to c
                enemy.hp=enemy.hp+rnd_range(1,b)
            next
    
            enemy.weapon=rnd_range(4,6)-3+awayteam.weapon
            if enemy.weapon<0 then enemy.weapon=0
            enemy.range=enemy.weapon-1
            if enemy.range<1.5 then enemy.range=1.5
            enemy.tile=28
            enemy.move=0.7
        endif
        if r=5 then
            enemy.hp=rnd_range(1,c)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
            for l=1 to c
                enemy.hp=enemy.hp+rnd_range(1,b)
            next
            enemy.atcost=.2
            enemy.sdesc="living energy"
            enemy.ldesc="a pulsating shimmer in the air, it moves through the metal walls as if they were not there, only getting slightly more solid before it fires."
            enemy.weapon=rnd_range(4,6)-3+awayteam.weapon
            if enemy.weapon<0 then enemy.weapon=0
            enemy.range=enemy.weapon-1
            if enemy.range<1.5 then enemy.range=1.5
            enemy.tile=asc("Z")
            enemy.col=rnd_range(192,197)
            enemy.move=4
            enemy.stuff(5)=1
        endif
        if r=6 then
            enemy.hp=30+rnd_range(1,c)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
            for l=1 to c
                enemy.hp=enemy.hp+rnd_range(1,b)
            next
            enemy.sdesc="bladebot"
            enemy.weapon=10
            enemy.atcost=1.2
            enemy.tile=ASC("R")
            enemy.armor=8
            enemy.move=0.5
            enemy.col=219
            enemy.ldesc="A massive ball of metal on tracks, 5 arms end in massive blades, so thin they are almost invisible."
            enemy.range=1.5
            enemy.sight=4
        endif
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
    endif
            
    
    if a=20 then 'Lizardmen
        enemy.c.x=x
        enemy.c.y=y
        enemy.atcost=rnd_range(6,8)/10
        enemy.sdesc="armed reptile"
        if rnd_range(1,100)<50 then
            enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a blue helmet, and wields an obviously human made Gauss gun!"
            enemy.lang=6
            enemy.sprite=290
            enemy.faction=1
        else
            enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a red helmet, and wields an obviously human made Gauss gun!"
            enemy.lang=7
            enemy.sprite=291
            enemy.faction=2
        endif
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.aggr=1
        enemy.biomod=1
        enemy.cmmod=2
        enemy.sight=3
        enemy.range=3.5
        enemy.weapon=2
        enemy.swhat="shoots its gaussgun!"
        enemy.scol=11
        enemy.hp=rnd_range(1,b)
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
    
        enemy.hpmax=enemy.hp
        enemy.move=0.8
        enemy.aggr=1
        enemy.tile=Asc("R")
        enemy.col=14
        if rnd_range(1,100)<66 then placeitem(makeitem(7),x,y,map,mslot)
           
    endif  
    
    if a=21 then 'Spiders
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.atcost=rnd_range(6,8)/10
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        enemy.hp=rnd_range(1,c)+8
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.sprite=274
        enemy.hpmax=enemy.hp
        enemy.move=0.8
        enemy.aggr=0
        enemy.biomod=1.45
        enemy.tile=Asc("A")
        if rnd_range(1,100)>55 then
            enemy.tile=Asc("I")
            enemy.col=8
            enemy.armor=3
            enemy.sdesc="Beetle"
            enemy.ldesc="A huge beetle with mandibles strong enough to sever a limb. By some curious coincidence it's carapace shows a marking resembling a human skull." 
            enemy.sprite=275
        endif
        if rnd_range(1,100)<20 then enemy.invis=2
        if rnd_range(1,100)>66 then
            enemy.tile=asc("w")
            enemy.col=15
            enemy.armor=0
            enemy.weapon=0
            enemy.hp=rnd_range(1,15)+5
            enemy.breedson=15
            enemy.sdesc="worm"
            enemy.ldesc="a swarm of slimy pale white worms with sharp teeth and 4 compound eyes on a ridge above its maw."
            enemy.invis=0
        endif
        
        if rnd_range(1,100)>66 then
            enemy.tile=asc("w")
            enemy.col=14
            enemy.armor=1
            enemy.weapon=1
            enemy.hp=rnd_range(1,15)+25
            enemy.sdesc="worm"
            enemy.ldesc="a swarm of slimy pale yellow worms with sharp teeth and 4 compound eyes on a ridge above its maw. Bone spikes portrude from their backs."
            enemy.invis=0
        endif
        enemy.col=8
        if rnd_range(1,100)>85 then enemy.invis=2
    endif
    
    if a=22 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="centipede"
        enemy.ldesc="a 3m long centipede. It only uses its lower 12 legs for movement. It's upper body is erect and its 12 arms end in slender 3 fingered hands. It has a single huge compound eye at the top of its head. It has 2 mouths, one for eating and one for breathing and talking. It is a herbivour." 
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=3
        enemy.range=1.5
        enemy.weapon=1
        enemy.hp=rnd_range(1,c)+8
        for l=1 to c
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.cmmod=8
        enemy.atcost=rnd_range(6,8)/10
        enemy.hpmax=enemy.hp
        enemy.move=0.8
        enemy.aggr=1
        enemy.diet=2
        enemy.biomod=3
        enemy.col=7
        enemy.tile=Asc("c")
        enemy.lang=8
        enemy.intel=9
        enemy.sprite=280
        
    endif
            
    if a=23 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=35
        enemy.sdesc="thug"
        enemy.ldesc="an armed band of thugs"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=3
        enemy.atcost=rnd_range(6,8)/10
        enemy.aggr=0
        enemy.diet=1 'Resources
        enemy.pumod=60
        enemy.hasoxy=1
            
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+b+c
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=asc("@")
        enemy.sprite=277
        
        enemy.col=75
        enemy.move=1
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            if rnd_range(1,100)<33 then placeitem(rnd_item(20),x,y,map,mslot)
        next
    endif   
    
    'a=24 is taken for fish
    
    if a=25 or a=26 or a=37 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="insectoid"
        enemy.ldesc="an insect with 6 legs, compound eyes and long feelers. They are between 1 and 3 m long and can stand on their hindlegs to use theif front legs for manipulation. Their colourfull carapace seems to signifiy some caste system."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        'enemy.intel=4
        enemy.biomod=1
        enemy.atcost=rnd_range(3,6)/10
        enemy.cmmod=3
        enemy.aggr=1'Resources
        enemy.pumod=60
        enemy.col=rnd_range(36,41)
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+enemy.col/2
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("i")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(108,113)
        enemy.move=1
        enemy.hasoxy=1
            
        enemy.lang=-11
        if a=26 then enemy.lang=-13
        if a=25 and rnd_range(1,100)<25 then
            enemy.col=12
            enemy.weapon=2
            enemy.armor=2
            if rnd_range(1,150)<25 then enemy.lang=-12
        endif
        if a=37 then enemy.lang=-17
        enemy.respawns=1
    endif
    
    if a=27 then
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        
        enemy.atcost=rnd_range(6,8)/10
        enemy.stuff(4)=1
        enemy.aggr=0
        enemy.sight=4
        enemy.move=.5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        r=rnd_range(1,4)
        enemy.hasoxy=1
            
        
        if r=1 then
            enemy.sdesc="floater"
            enemy.ldesc="A circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity." 
            enemy.hp=rnd_range(30,100)+rnd_range(30,100)
            enemy.armor=3
            enemy.weapon=1
            enemy.range=3
            enemy.swhat="shoots lightning bolts"
            enemy.scol=11
            enemy.tile=asc("F")
            enemy.col=138
        endif
        if r=2 then
            enemy.sdesc="cloudshark"
            enemy.ldesc="A large tube shaped creatures with wide maws and sharp teeth!"
            enemy.hp=rnd_range(1,20)+rnd_range(1,20)+10
            enemy.armor=1
            enemy.weapon=1
            enemy.move=1.2
            enemy.range=1.5
            enemy.tile=asc("S")
            enemy.col=205
        endif
        if r=3 then
            enemy.hp=rnd_range(2,18)+rnd_range(2,8)
            enemy.range=1.5
            enemy.weapon=2
            enemy.move=.3
            enemy.tile=asc("9")
            enemy.sdesc="floating mushroom"
            enemy.ldesc="a 30 cm big ball with long tentacles that connect it to the platform. It has a rim around the middle with 5 openings through wich it shoots hot gas jets to propell and defend itself."
            enemy.breedson=18
            
            enemy.atcost=1.1
            enemy.col=200
        endif
        if r=4 then
            enemy.sdesc="hydrogen worm"
            enemy.ldesc="A giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
            enemy.hp=rnd_range(30,100)+rnd_range(30,100)+20
            enemy.armor=4
            enemy.weapon=4
            enemy.range=1.5
            enemy.tile=asc("W")
            enemy.col=121
            
        endif
        
        if r=5 then
            enemy.hp=rnd_range(2,18)+rnd_range(2,8)+c+b
            enemy.range=3.5
            enemy.weapon=2
            enemy.move=1.3
            enemy.sdesc="cloud"
            enemy.ldesc="several mulitcolored gas clouds. They seem to be moving towards you and are held together by static electricity."
            enemy.tile=176
            enemy.col=205
            enemy.swhat="shoots lightning bolts"
            enemy.scol=11
        endif
        enemy.hpmax=enemy.hp
    endif
    
    if a=28 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="citizen"
        enemy.ldesc="a dazed looking human pioneer"
        enemy.lang=14
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=-1
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.tile=Asc("C")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.atcost=1.2
        enemy.stuff(1)=0
        enemy.col=5
        enemy.move=.8
        enemy.aggr=1
        enemy.hasoxy=1
            
    endif
    
    if a=29 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=1.1
        enemy.armor=7
        enemy.hasoxy=1
            
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=14+rnd_range(2,5)+rnd_range(2,5)
        enemy.stuff(1)=0
        enemy.col=rnd_range(101,113)
        enemy.aggr=0
        enemy.move=1.8
        if rnd_range(1,100)<20 then
            enemy.tile=asc("@")
            enemy.sdesc="crystal hybrid"
            enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is covered in the torn remains of a starship uniform. The half covered head looks like a grotesque helmet."
            enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
            enemy.armor=3
            enemy.atcost=0.7
            enemy.move=0.9
            enemy.range=rnd_range(1,4)+0.5
            if enemy.range<=2.5 then
                enemy.scol=11
                enemy.swhat="shoots gauss guns"
                if rnd_range(1,100)<33 then placeitem(makeitem(5),x,y,map,mslot)
            else
                enemy.scol=12
                enemy.swhat="shoots lasers"
                if rnd_range(1,100)<33 then placeitem(makeitem(7),x,y,map,mslot)
            endif
        endif
        enemy.hp=enemy.hpmax
    endif
    
    
    if a=30 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="starcreature"
        enemy.ldesc="This creature resembles are giant see star with 5 legs bent downwards ending in 7 fingered hands. It uses them for walking as well as for fine manipulating. The top of it's body features 3 eye stalks with compound eyes. A tube under its body ends in a maw with sharp teeth."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=3
        enemy.atcost=rnd_range(6,8)/10
        enemy.aggr=1'Resources
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+b+c
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("x")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(108,113)
        enemy.move=1
        enemy.lang=-10
        enemy.respawns=1
    endif
    
    if a=31 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=1.1
        enemy.armor=7
        enemy.hasoxy=1
            
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=14+rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=enemy.hpmax
        enemy.stuff(1)=0
        enemy.col=rnd_range(101,113)
        enemy.aggr=0
        enemy.move=1.8
        if rnd_range(1,100)>planets(map).depth*15 then
            enemy.tile=asc("@")
            enemy.sdesc="crystal hybrid"
            enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is still bare. You can see the torn uniform of a scout ship security team member."
            enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
            enemy.armor=3
            enemy.atcost=0.7
            enemy.move=0.9
            enemy.range=rnd_range(1,4)+0.5
            if enemy.range<=2.5 then
                enemy.scol=11
                enemy.swhat="shoots gauss guns"
                if rnd_range(1,100)<33 then placeitem(makeitem(5),x,y,map,mslot)
            else
                enemy.scol=12
                enemy.swhat="shoots lasers"
                if rnd_range(1,100)<33 then placeitem(makeitem(7),x,y,map,mslot)
            endif
        endif
        enemy.hp=enemy.hpmax
    endif

    if a=32 then
        enemy.made=32
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=35
        enemy.sdesc="crewmember"
        enemy.ldesc="a member of the crew of this ship"
        enemy.lang=16
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=3
        enemy.aggr=1
        enemy.diet=0
        enemy.hasoxy=1
            
        enemy.pumod=60
        enemy.atcost=rnd_range(6,8)/10
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.move=.6
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            if rnd_range(1,100)<15 then placeitem(rnd_item(20),x,y,map,mslot)
        next
    endif
    
    if a=33 then
        enemy.made=32
        enemy.c.x=x
        enemy.c.y=y
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        b=rnd_range(1,100)
        if b<20 then
            c=rnd_range(3,9)
            enemy.ldesc="a dead member of the crew of this ship. He has a " & makeitem(c).desig &" between his legs, firm in his hands. His head is missing."
            placeitem(makeitem(c),x,y,map,mslot)
        endif
        if b>19 and b<50 then
            enemy.ldesc="This crewmember suffocated in his spacesuit."
        endif
        if b>49 and b<60 then
            enemy.ldesc="A crewmember lying dead in a corner."
        endif
        if b>59 and b<70 then
            enemy.ldesc="This crewmember took off his helmet. His head is covered in ice."
        endif
        if b>69 and b<80 then
            enemy.ldesc="This crewmember suffocated in his spacesuit."
        endif
        if b>79 then
            enemy.ldesc="This crewmember suffocated in his spacesuit. His oxygen tank is missing"
        endif
    endif
    
    if a=34 then
        enemy.hp=rnd_range(2,25)
        enemy.hpmax=enemy.hp
        enemy.tile=asc("9")
        enemy.col=26
        enemy.sdesc="crawling mushroom"
        enemy.ldesc="a huge mushroom with a prehensile rootsystem"
        enemy.biomod=1.2
        enemy.move=.2
        enemy.atcost=.8
        enemy.range=2.5
        enemy.sight=3.5
        enemy.weapon=1
        enemy.swhat="shoots acidic spores."
        enemy.scol=10
        enemy.breedson=25
    endif
    
    if a=35 then 'Powerful standard critter
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to c+1+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,b)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon+10
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=0
        enemy.biomod=1.5
        enemy.diet=1
        enemy.move=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        enemy.invis=2
        enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        enemy.atcost=.5
        enemy.atcost=rnd_range(6,8)/10
        if enemy.move<=0.9 then enemy.move=0.9
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.stuff(2)=1 'Vögel können fliegen
            enemy.stuff(1)=1
            g=1
            enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        if enemy.tile=22 then enemy.stuff(1)=1 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=36 then
        if rnd_range(1,100)<25 then
            enemy.hp=1
            enemy.hpmax=1
            enemy.aggr=0
            enemy.move=2.3
            enemy.atcost=99
            enemy.breedson=5
            enemy.tile=asc("o")
            enemy.col=39
            enemy.biomod=1
            enemy.sight=5
            enemy.hasoxy=1
            
            enemy.sdesc="batlike creature"
            enemy.ldesc="a small creature with 3 eyes, no mouth or legs, using 2 skin wings to fly"
        else
            enemy.aggr=0
            enemy.hp=20+rnd_range(1,b)*c
            enemy.hpmax=enemy.hp
            enemy.move=.5
            enemy.atcost=.8
            enemy.breedson=2
            enemy.weapon=3
            enemy.armor=3
            enemy.sight=3
            enemy.range=1.5
            enemy.biomod=1
            enemy.hasoxy=1
            
            enemy.tile=asc("j")
            enemy.col=208
            enemy.sdesc="blob"
            enemy.ldesc="A huge pale amorphous mass wobbles towards you trying to engulf you. It's skin is covered in a highly corrosive substance"
        endif
    endif
    
    '37=aliens on generation ship
    
    if a=38 then
        if mslot=1 then
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.tile=asc("Q")
        enemy.col=192
        enemy.aggr=0
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="bouncing ball"
        enemy.ldesc="a orange ball. It has several yellow eyespots, and moves by jumping and bouncing. It has two yellow birdlike claws at the lower end. It appears to be hollow, with no recognizable organs. How exactly it is alive is a mystery."        
        enemy.biomod=5.2
        enemy.move=1.2
        enemy.atcost=.3
        enemy.range=2.5
        enemy.sight=3.5
        enemy.hasoxy=1
            
        enemy.weapon=0
        enemy.scol=192
        else
        enemy.made=32
        enemy.c.x=x
        enemy.c.y=y
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        enemy.ldesc="crewmember, on his uniform is a name tag identifying him as 'Sgt. Pinback'"
        endif
    endif
    
    
    if a=39 then
        enemy.hasoxy=1
            
        if rnd_range(1,100)<66 then
            enemy.c.x=x
            enemy.c.y=y
            enemy.sdesc="citizen"
            enemy.ldesc="a friendly human pioneer"
            enemy.lang=18
            enemy.dhurt="hurt"
            enemy.dkill="dies"
            enemy.cmmod=5
            enemy.pumod=5
            enemy.sight=4
            enemy.range=1.5
            enemy.atcost=rnd_range(6,12)/10
            enemy.tile=Asc("C")
            enemy.sprite=286
            enemy.hpmax=4
            enemy.hp=4
            enemy.stuff(1)=0
            enemy.col=5
            enemy.aggr=1
        else
            enemy.c.x=x
            enemy.c.y=y
            enemy.sight=5
            enemy.sdesc="armed citizen"
            enemy.ldesc="a gruff human pioneer hardened by living away from civilization"
            enemy.lang=18
            enemy.dhurt="hurt"
            enemy.dkill="dies"
            enemy.cmmod=3
            enemy.aggr=1
            enemy.pumod=6
            enemy.atcost=rnd_range(6,8)/10
            for l=1 to 5
                enemy.stuff(l)=1
            next
            enemy.range=rnd_range(1,4)+0.5
            if enemy.range<=2.5 then
                enemy.scol=11
                enemy.swhat="shoots gauss guns"
            else
                enemy.scol=12
                enemy.swhat="shoots lasers"
            endif
            enemy.hp=rnd_range(2,5)+rnd_range(2,5)
            enemy.hpmax=enemy.hp
            enemy.armor=rnd_range(1,3)
            enemy.weapon=rnd_range(1,3)
            enemy.tile=asc("C")
            enemy.sprite=287
            enemy.col=89
            enemy.move=.6
            enemy.respawns=0
            
        endif
    endif
        
    if a=40 then 'zombies
        enemy.hasoxy=1
            
        enemy.made=40
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=35
        enemy.sdesc="fast miner"
        enemy.ldesc="a miner in a spacesuit with an empty expression on his face. He moves increadibly fast!"
        enemy.lang=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=3
        enemy.aggr=0
        enemy.diet=1
        enemy.pumod=60
        enemy.atcost=.3
        enemy.disease=17
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+b+c+a
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=9
        enemy.move=2.6
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            if rnd_range(1,100)<33 then placeitem(rnd_item(21),x,y,map,mslot)
            if rnd_range(1,100)<15 then placeitem(makeitem(96),x,y,map,mslot)
        next
    endif
    
    
    if a=41 then 'Powerful standard critter
        'Postion
        
        g=rnd_range(0,4)
        enemy.tile=ch(g)
        enemy.sdesc=ti(g)
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to c+1+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,b)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=1
        enemy.biomod=1.5
        enemy.diet=1
        enemy.move=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        
        enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.atcost=rnd_range(6,8)/10
        if enemy.move<=0.9 then enemy.move=0.9
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.stuff(2)=1 'Vögel können fliegen
            enemy.stuff(1)=1
            g=1
            enemy.ldesc=randomcritterdescription(g,enemy.hp,enemy.stuff(2),enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            select case planets(map).temp
                   case is>200
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.move=0.6
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.move=0.4
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.move=0.5
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                enemy.biomod=2.2
                for l=0 to rnd_range(2,5)
                    if rnd_range(1,100)<33 then placeitem(makeitem(99,-4,5),x,y,map,mslot)
                next
            endif
            If planets(map).depth>0 then
                enemy.stuff(5)=1
                enemy.track=4
                enemy.weapon=5
                enemy.move=0.3
                enemy.armor=2
                enemy.col=7
                enemy.tile=asc("W")
                enemy.track=4
                enemy.sdesc="stoneworm"
                enemy.sprite=275
                enemy.ldesc="This creature slowly digs through the stone, gnawing at it with metal teeth. It's thick skin is embedded with rocks and stones for protection."
            endif
        endif
        
            
                
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.sdesc="mutated "&enemy.sdesc
        enemy.ldesc="mutated "&enemy.ldesc
        enemy.disease=16
        if enemy.tile=22 then enemy.stuff(1)=1 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=42 then        
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="amphibious cephalopod"
        enemy.ldesc="A cephalopod with 9 arms, 3 end in big suction cups, with serrated edges that also serve as fingers. 3 others end in beaked mouths and 3 end in fins. It's saucer shaped body has 9 small eyes, spaced evenly along the rim. It's body is about 0.5m wide and its tentacles are 1m long."  
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=3
        enemy.atcost=rnd_range(6,8)/10
        enemy.aggr=1
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+b+c
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("Q")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(180,185)
        enemy.move=1
        enemy.lang=-19
        enemy.respawns=1
    endif
    
    if a=43 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 0.5m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=3
        enemy.atcost=rnd_range(6,8)/10
        enemy.aggr=1
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("h")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(102,107)
        enemy.move=1
        enemy.lang=-20
        enemy.respawns=1
    endif
    
    
    if a=44 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 1m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups. It has horns and a spiked tail."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1.2
        enemy.cmmod=3
        enemy.atcost=rnd_range(6,8)/10
        enemy.aggr=0
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=10
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("H")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(102,107)
        enemy.move=1
        enemy.respawns=0
    endif
    
    if a=45 then
        enemy.c.x=x
        enemy.c.y=y
        enemy.sight=3
        enemy.sdesc="tree"
        enemy.ldesc="a small tree or big bush with a cone shaped trunk, and a wide surface root system. It has several small openings and a few flexible branches near the top that end in big blue globes. It is obviously capable of moving slowly!"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=4
        enemy.cmmod=3
        enemy.atcost=rnd_range(1,4)/10
        enemy.aggr=1
        enemy.lang=-21
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=10+rnd_range(1,b)+rnd_range(1,c)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,3)
        enemy.tile=asc("T")
        enemy.sprite=277
        enemy.cmmod=3
        enemy.col=2
        enemy.move=.1
        enemy.respawns=1
        enemy.biomod=4
        
        if mslot=1 then
            enemy.c.x=x
            enemy.c.y=y
            enemy.biomod=0
            enemy.sdesc="Ted Rofes, the shipsdoctor. "
            enemy.ldesc="Ted Rofes, the shipsdoctor."
            enemy.lang=22
            enemy.dhurt="hurt"
            enemy.dkill="dies"
            enemy.cmmod=5
            enemy.pumod=5
            enemy.sight=4
            enemy.range=1.5
            enemy.atcost=rnd_range(6,12)/10
            enemy.tile=Asc("@")
            enemy.sprite=286
            enemy.hpmax=4
            enemy.hp=4
            enemy.stuff(1)=0
            enemy.col=5
            enemy.aggr=1
        endif
    endif
        
        
    if a=46 then 'Vault bots
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=1
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)/10
        for l=1 to c+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,b)
        next
        enemy.hp=15+enemy.hp+b+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)-3+awayteam.weapon
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.move=0.7
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.move=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)/10
        enemy.sprite=282
        for b=0 to rnd_range(1,6)+rnd_range(1,6)
            if rnd_range(1,100)<33 then placeitem(makeitem(94),x,y,map,mslot)
        next
    endif
    
    if planets(map).atmos=1 and planets(map).depth=0 then enemy.hasoxy=1
    
    if easy_fights=1 then
        enemy.armor=0
        enemy.weapon=0
        enemy.hp=1
    endif
    
    if _easy=0 and enemy.hp>0 then
        easy=player.turn/500
        if easy>1 then easy=1
        enemy.hp=enemy.hp*easy
        if enemy.hp<1 then enemy.hp=1
        enemy.hpmax=enemy.hp
    endif
    
    return enemy
end function

function makecorp(a as short) as _station
    dim basis as _station
    if a=0 then a=rnd_range(1,4)
    if a=1 then
        basis.repname="Eridiani Explorations"
        basis.mapmod=1.8
        basis.biomod=1
        basis.resmod=1.5
        basis.pirmod=1
    endif
    if a=2 then
        basis.repname="Smith Heavy Industries"
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.75
        basis.pirmod=0.95
    endif
    if a=3 then 
        basis.repname="Triax Traders Its."
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.55
        basis.pirmod=1.1
    endif
    if a=4 then
        basis.repname="Omega Bioengineering"
        basis.mapmod=1
        basis.biomod=1.5
        basis.resmod=1.5
        basis.pirmod=1
    endif
    return basis 
end function

function makeship(a as short) as _ship
dim p as _ship
dim as short c,b

    if a=1 then
        'players ship    
        p.c=basis(0).c
        p.sensors=1
        p.hull=5
        p.hulltype=10
        p.fuel=100
        p.fuelmax=100
        p.fueluse=1
        p.money=500
        p.pilot=1
        p.gunner=1
        p.science=1
        p.doctor=1
        p.engine=1
        p.weapons(1)=makeweapon(1)
        p.pirate_agr=100
        p.merchant_agr=0
        p.lastvisit.s=-1
        p.turn=0
        
    endif
    
    if a=2 then
        'pirate fighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.pilot=1
        p.gunner=3
        p.engine=5
        p.desig="Pirate Fighter"
        p.icon="F"
        p.money=200
        p.weapons(1)=makeweapon(7)
        p.col=12
        p.bcol=0
        p.mcol=14
    endif
    if a=3 then
        'pirate Cruiser
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=10
        p.pilot=1
        p.gunner=4
        p.engine=4
        p.desig="Pirate Cruiser"
        p.icon="C"
        p.money=1000
        p.weapons(3)=makeweapon(7)       
        p.weapons(1)=makeweapon(7)
        p.weapons(2)=makeweapon(2)
        p.col=12
        p.bcol=0
        p.mcol=14
    endif
    
    if a=4 then
        'pirate Destroyer
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=15
        p.shieldmax=1
        p.shield=1
        p.pilot=2
        p.gunner=5
        p.engine=3
        p.desig="Pirate Destroyer"
        p.icon="D"
        p.money=3000
        
        p.weapons(1)=makeweapon(8)
        p.weapons(2)=makeweapon(3)
        p.weapons(3)=makeweapon(1)
        p.weapons(4)=makeweapon(8)       
        
        p.col=12
        p.bcol=0
        p.mcol=14
    endif
    if a=5 then
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.shieldmax=2
        p.shield=2
        p.pilot=1
        p.gunner=6
        p.engine=2
        p.desig="Pirate Battleship"
        p.icon="B"
        p.money=5000
        p.ecm=1
               
        p.weapons(1)=makeweapon(9)
        p.weapons(2)=makeweapon(9)
        p.weapons(3)=makeweapon(4)
        p.weapons(4)=makeweapon(3)
        p.weapons(5)=makeweapon(3)
        p.weapons(6)=makeweapon(9)
        
        p.col=12
        p.bcol=0
        p.mcol=14
    endif
    if a=6 then
        c=rnd_range(1,10)
        if c<5 then                
            p.hull=3
            p.shieldmax=0
            p.shield=0
            
            p.sensors=2
            p.pilot=1
            p.gunner=1
            p.engine=2
        
            for b=1 to 3
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="light transport"
            p.icon="t"
        endif
        if c>4 then
                    
            p.hull=8
            p.shieldmax=0
            p.shield=0
            
            p.sensors=3
            p.pilot=1
            p.gunner=1
            p.engine=3
        
            for b=1 to 4
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="heavy transport"
            p.weapons(1)=makeweapon(1)
            p.icon="T"
        endif
        if c>7 then
            p.hull=12
            p.shieldmax=1
            p.shield=1            
            
            p.sensors=3
            p.pilot=1
            p.gunner=2
            p.engine=3
        
            for b=1 to 5
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(0)=makeweapon(2)
            p.desig="merchantman"
            p.icon="m"
        endif
        if c=10 then 
                    
            p.hull=15
            p.shieldmax=2
            p.shield=2
            
            p.sensors=4
            p.pilot=1
            p.gunner=2
            p.engine=4
        
            for b=1 to 6
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(0)=makeweapon(2)
            p.weapons(0)=makeweapon(2)
            p.desig="armed merchantman"
            p.icon="M"
        endif
        'Merchant
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.weapons(0)=makeweapon(1)
        
        p.money=0
        p.security=20
        p.shiptype=1
        p.col=10
        p.bcol=0
        p.mcol=12
    endif
    
    if a=7 then
        'Escort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=2
        p.shieldmax=1
        p.shield=1
        p.pilot=4
        p.gunner=3
        p.engine=2
        p.weapons(3)=makeweapon(7)
        p.weapons(1)=makeweapon(1)
        p.weapons(2)=makeweapon(1)
        p.desig="Escort"
        p.icon="E"
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
    endif

    if a=8 then
        'The dreaded Anne Bonny
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=30
        p.shieldmax=3
        p.shield=3
        p.pilot=1
        p.gunner=7
        p.engine=3
        p.desig="Anne Bonny"
        p.icon="A"
        p.money=15000
        p.ecm=2
        p.weapons(6)=makeweapon(9)       
        p.weapons(1)=makeweapon(9)
        p.weapons(2)=makeweapon(10)
        p.weapons(3)=makeweapon(5)
        p.weapons(4)=makeweapon(5)
        p.weapons(5)=makeweapon(5)
        p.col=8
        p.bcol=0
        p.mcol=10
    endif
    if a=9 then
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.shield=2
        p.pilot=1
        p.gunner=4
        p.engine=3
        p.desig="Company Battleship"
        p.icon="U"
        p.money=0
        p.ecm=1
        p.weapons(4)=makeweapon(7)       
        p.weapons(1)=makeweapon(7)
        p.weapons(2)=makeweapon(7)
        p.weapons(3)=makeweapon(3)
        p.col=10
        p.bcol=0
        p.mcol=12
    endif
    
    if a=10 then
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.shieldmax=3
        p.shield=3
        p.pilot=1
        p.gunner=5
        p.engine=3
        p.desig="Black Corsair"
        p.icon="D"
        p.money=8000
        p.ecm=1
        
        p.weapons(6)=makeweapon(7)       
        p.weapons(1)=makeweapon(7)
        p.weapons(2)=makeweapon(7)
        p.weapons(3)=makeweapon(3)
        p.weapons(4)=makeweapon(3)
        p.weapons(5)=makeweapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
    endif
    
    if a=11 then
        'Alien scoutship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=6
        p.hull=15
        p.shieldmax=4
        p.shield=4
        p.pilot=4
        p.gunner=3
        p.engine=5
        p.desig="Alien Scoutship"
        p.icon="8"
        p.ecm=2
        p.weapons(1)=makeweapon(66)
        p.weapons(2)=makeweapon(3)
        p.weapons(2)=makeweapon(3)
        p.col=7
        p.bcol=0
        p.mcol=14
    endif
    
    if a=12 then
        'pirate fighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.pilot=1
        p.gunner=1
        p.engine=4
        p.desig="Fighter"
        p.icon="F"
        p.weapons(1)=makeweapon(7)
        p.col=10
        p.bcol=0
        p.mcol=14
    endif
    
    if a=21 then
        'Spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=10
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.gunner=5
        p.icon="S"
        p.desig="crystal spider"
        p.col=11
        p.mcol=1
        p.weapons(1)=makeweapon(101)
    endif
    
    if a=22 then
        'Sphere
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=12
        p.hulltype=-1
        p.engine=0
        p.sensors=15
        p.gunner=5
        p.icon="Q"
        p.desig="living sphere"
        p.col=8
        p.mcol=1
        p.weapons(1)=makeweapon(101)
        p.weapons(2)=makeweapon(102)
        p.weapons(3)=makeweapon(102)
    endif
    
    if a=23 then
        'cloud
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=15
        p.hulltype=-1
        p.engine=4
        p.sensors=2
        p.gunner=2
        p.icon=chr(176)
        p.desig="symbiotic cloud"
        p.col=14
        p.mcol=1
        p.weapons(1)=makeweapon(101)
        p.weapons(2)=makeweapon(101)
    endif
    
    
    if a=24 then
        'Spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=4
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.gunner=3
        p.icon="W"
        p.desig="hydrogen worm"
        p.col=121
        p.mcol=1
        p.weapons(1)=makeweapon(101)
    endif
    
    
    if a=25 then
        'Spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=12
        p.c=movepoint(p.c,5)
        p.hull=18
        p.hulltype=-1
        p.engine=5
        p.sensors=4
        p.gunner=4
        p.icon=chr(176)
        p.desig="living plasma"
        p.col=11
        p.mcol=14
        p.weapons(1)=makeweapon(101)
    endif
    
    if a=26 then
        'Spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=8
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.gunner=2
        p.icon="J"
        p.desig="starjellyfish"
        p.col=11
        p.mcol=14
        p.weapons(1)=makeweapon(101)
        p.weapons(2)=makeweapon(101)
        p.weapons(3)=makeweapon(101)
    endif
    
    
    if a=27 then
        'Spacespider
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=2
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.gunner=2
        p.icon="S"
        p.desig="cloudshark"
        p.col=205
        p.mcol=1
        p.weapons(1)=makeweapon(101)
    endif
    
    if a=28 then
        'Spacespider
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.gunner=2
        p.icon="O"
        p.desig="Gasbubble"
        p.col=203
        p.mcol=1
        p.weapons(1)=makeweapon(103)
    endif
    
    
    if a=29 then
        'Spacespider
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.gunner=2
        p.icon="F"
        p.desig="Floater"
        p.col=138
        p.mcol=1
        p.weapons(1)=makeweapon(104)
        p.weapons(2)=makeweapon(104)
    endif
    
    if a=30 then
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=15
        p.shieldmax=2
        p.shield=2
        p.pilot=1
        p.gunner=5
        p.engine=2
        p.desig="Hussar"
        p.icon="C"
        p.money=5000
        p.ecm=1
        p.weapons(2)=makeweapon(7)
        p.weapons(3)=makeweapon(3)
        p.weapons(4)=makeweapon(3)
        p.weapons(5)=makeweapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
    endif
    
    if a=31 then
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=1
        p.shield=1
        p.pilot=1
        p.gunner=4
        p.engine=3
        p.desig="Adder"
        p.icon="F"
        p.money=2500
        p.ecm=1
        p.weapons(1)=makeweapon(7)
        p.weapons(2)=makeweapon(7)
        p.col=4
        p.bcol=0
        p.mcol=14
    endif
    
    if a=32 then
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=2
        p.shield=2
        p.pilot=1
        p.gunner=4
        p.engine=2
        p.desig="Black Widow"
        p.icon="F"
        p.money=2500
        p.ecm=1
        p.weapons(1)=makeweapon(8)
        p.weapons(2)=makeweapon(13)
        p.col=4
        p.bcol=0
        p.mcol=14
    endif
    
    
    return p
end function

function debug_printfleet(f as _fleet) as string
    dim text as string
    dim a as short
    for a=1 to 15
        text=text &f.mem(a).icon
    next
    return text
end function
