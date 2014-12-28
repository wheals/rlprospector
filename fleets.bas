function merctrade(byref f as _fleet) as short
    dim as short st,a,debug
    debug=1
    st=-1
    for a=0 to 2
        if f.c.x=basis(a).c.x and f.c.y=basis(a).c.y then st=a
    next
    if st<>-1 then
        if show_NPCs then dprint "fleet is trading at "&st+1 &"."
        f=unload_f(f,st)
        f=load_f(f,st)
        f=refuel_f(f,st)
    endif
    return 0
end function

function refuel_f(f as _fleet, st as short) as _fleet
    'Refuels a fleet at a space station
    dim as short demand,ships,a,debug
    debug=1
    for a=0 to 15
        if f.mem(a).hull>0 then ships+=1
    next
    demand=cint(f.fuel*ships/30)
    basis(st).inv(9).v-=demand
    if basis(st).inv(9).v<0 then basis(st).inv(9).v=0
    if debug=1 and _debug=1 then dprint ships &" ships refueling "&demand &" fuel, on base " & basis(st).inv(9).v
    f.fuel=0
    return f
end function

function load_f(f as _fleet, st as short) as _fleet
    dim as short curship,curgood,buylevel,vol,suc,a
    dim loaded(8) as short
    dim text as string
    buylevel=11
    do
        vol=0
        for a=1 to 5
            vol=vol+basis(st).inv(a).v
        next
        if vol>0 then
            for a=1 to 8
                if basis(st).inv(a).v>buylevel and curship<16 then
                    do 
                        suc=load_s(f.mem(curship),a,st)
                        if suc=-1 then 
                            curship=curship+1
                        else
                            'save what was loaded
                            loaded(a)=loaded(a)+1
                        endif
                    loop until suc<>-1 or curship>=15
                endif
            next
        endif
        buylevel=buylevel-1
    loop until vol<5 or buylevel<3 or curship>=15
    if basis(st).spy=1 then
        for a=1 to 4
            if loaded(a)>0 then text=text & loaded(a) &" tons of "& goodsname(a)
            if loaded(a)>0 and loaded(a+1)>0 then text=text &", "
        next
        if loaded(5)>0 then text=text & loaded(a) &" tons of "& goodsname(a) &"."
        if player.landed.m=0 then dprint "We have a transmission from station "&st+1 &". A trader just left with "&text &".",15    
    endif
    
    return f
end function

function unload_f(f as _fleet, st as short) as _fleet
    dim as short a
    for a=1 to 15
        f.mem(a)=unload_s(f.mem(a),st)
    next
    return f
end function

function unload_s(s as _ship,st as short) as _ship    
    dim as short a,b,c,d,e,f,t
    
    for a=1 to 25
        if s.cargo(a).x>1 then
            if st<=2 then companystats(basis(st).company).profit+=1
            t=s.cargo(a).x-1 'type of cargo
            basis(st).inv(t).v=basis(st).inv(t).v+1  
            s.cargo(a).x=1
            'dprint "sold " &t
        endif
    next
    return s
end function

function load_s(s as _ship, good as short, st as short) as short
    dim as short bay,result,a
    for a=1 to 25
        if s.cargo(a).x=1 and bay=0 then bay=a
    next
    if bay=0 then result=-1
    if bay>0 then
        result=bay
        basis(st).inv(good).v=basis(st).inv(good).v-1
        s.cargo(bay).x=s.cargo(bay).x+good
        'dprint "bought " &good &" stored in "& bay &" Inv:"& basis(st).inv(good).v 
    endif
    return result
end function

function friendly_pirates(f as short) as short
    dim as short a,b,i,mo,lastbay,r
    for i=1 to 10
        if player.cargo(i).x>=1 then lastbay+=1
    next
    a=menu(bg_ship,"The pirate fleet hails you, demanding you drop all your cargo/Tell them you have no cargo/Drop some cargo/Drop all cargo/Offer money/Try to flee/Attack","",0,16)
    select case a
    case 1
        if getnextfreebay=1 or player.cargo(1).x<=0 then
            'Really has no cargo
            dprint "You convince them that you don't have cargo, and they leave.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            if rnd_range(1,10)<fleet(f).mem(1).sensors*10-player.equipment(se_CargoShielding) then
                dprint "They don't believe you!",c_red
                fleet(f).con(15)+=1
                r=1
            else
                dprint "They believe you and agree to leave you alone.",c_gre
                fleet(f).con(15)-=1
                r=0
            endif
            'lying
        endif
    case 2
        do
            b=menu(bg_ship,cargobay("Drop(" &mo & "Cr. dropped)/",0))
            if b>=1 or b<=lastbay then
                mo+=player.cargo(i).y
                player.cargo(i).x=1
                player.cargo(i).y=0
            endif
        loop until b=-1 or b>lastbay
        if rnd_range(1,mo)<fleet(f).con(1)+mo/3 or getnextfreebay=1 then
            dprint "They are satisfied.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            dprint "They don't think it's enough!",c_red
            fleet(f).con(15)-=1
            r=1
        endif
    case 3
        for i=1 to 10
            if player.cargo(i).x>1 then 
                player.cargo(i).x=1
                player.cargo(i).y=0
            endif
        next
        dprint "They are satisfied and leave.",c_gre
        fleet(f).con(15)+=1
        r=0
    case 4
        dprint "How much do you offer?"
        mo=getnumber(0,player.money,0)
        if mo>player.money/20+rnd_range(1,player.money/10)+rnd_range(1,player.money/10) then 
            paystuff(mo)
            dprint "They agree to leave you alone.",c_gre
            fleet(f).con(15)+=1
            r=0
        else
            dprint "They don't think it's enough!",c_red
            fleet(f).con(15)-=1
            r=1
        endif
    case 5
        fleet(f).con(15)-=1
        r=1
    case 6
        fleet(f).con(15)-=2
        r=1
    end select
    if r=1 then
        factionadd(0,2,15)
    else
        factionadd(0,2,-5)
    endif
    return r
end function

    
function meet_fleet(f as short)as short
    static lastturncalled as integer
    dim as short aggr,roll,frd,des,dialog,q,a,total,cloak,x,y
    dim question as string
    dim fname(10) as string
    gen_fname(fname())
    if findbest(25,-1)>0 then cloak=5
    if fleet(f).ty=10 then 
        lastturncalled=player.turn 
        eris_does
        return 0
    endif
    if player.turn>lastturncalled+250 and fleet(f).ty>0 and player.dead=0 and just_run=0 then
        if fleet(f).fighting=0 then
            if faction(0).war(fleet(f).ty)+rnd_range(1,10)>90 and fleet(f).ty<>1 then 'Merchants never attack 
                q=1
            else
                q=0
            endif
            if q=1 and f>5 then
                question="There is "&add_a_or_an(fname(fleet(f).ty),0) &" on an attack vector. Do you want to engage? (y/n)"
                if fleet(f).ty=2 and fleet(f).con(15)<rnd_range(1,20) then
                    'Friendly pirates
                    q=friendly_pirates(f)
                    lastturncalled=player.turn
                    display_stars(1)
                    display_ship
                    if q=0 then return 0
                endif
            endif
            if q=0 and f>5 then 
                if fleet(f).ty<>1 then
                    question="There is "&add_a_or_an(fname(fleet(f).ty),0) &" hailing us."
                else
                    question="There is a merchant fleet on our screens." 'Merchants don't attack, but they don't hail either
                endif
            endif
            if q=1 then
                des=askyn(question)
            else
                dprint question
                return f
            endif
            if des=0 then
                if q=1 then
                    if skill_test(player.pilot(location)+cloak-fleet(f).count,st_hard) then
                        dprint "You got away!",c_gre
                    else
                        dprint "They are closing in..."
                        des=-1
                    endif
                else
                    dprint "you return the greeting"
                endif
            endif
            if des=-1 then
                factionadd(0,fleet(f).ty,15)
                playerfightfleet(f)
            endif
        else
            join_fight(f)
        endif
    endif
    
    lastturncalled=player.turn
    display_stars(1)
    display_ship
    return 0
        
end function

function gen_fname(fname() as string) as short
    fname(1)="merchant convoy"
    fname(2)="pirate fleet"
    fname(3)="company patrol"
    fname(4)="pirate fleet"
    fname(5)="huge fast ship"
    fname(6)=civ(0).n &" fleet"
    fname(7)=civ(1).n &" fleet"
    fname(8)="space station"
    return 0
end function


function join_fight(f as short) as short
    dim as string q,fname(10)
    dim as short f2,des,faggr,f2aggr,i,debug,fty,f2ty,side 
    f2=fleet(f).fighting
    gen_fname(fname())
    fty=fleet(f).ty
    f2ty=fleet(f2).ty
    if f<=6 then fty=8
    if f2<=6 then f2ty=8
    dprint add_a_or_an(fname(fty),1) &" and "& add_a_or_an(fname(f2ty),0) &" are fighting here."
    q="On which side do you want to join the fight?/"& fname(fty) &f &":"&fty &"/" & fname(f2ty)  &f2 &":"&f2ty  & "/Ignore fight"
    des=menu(bg_ship,q,"",0,18,1) 
    if des=3 or des=-1 then return 0
    if des=1 then 'aggr1=On PCs side
        faggr=1
        f2aggr=0
        side=fty
    else
        faggr=0
        f2aggr=1
        side=f2ty
    endif
'    fname(0)=""
'    fname(1)=""
    for i=1 to 14
        if fleet(f).mem(i).hull>0 then fleet(f).mem(i).aggr=faggr
        if fleet(f2).mem(i).hull>0 then fleet(f2).mem(i).aggr=f2aggr
        if fleet(f).mem(i).hull>0 then fname(0)=fname(0)&fleet(f).mem(i).aggr
        if fleet(f2).mem(i).hull>0 then fname(1)=fname(1)&fleet(f2).mem(i).aggr
    next
    if faggr=1 then
        factionadd(0,fleet(f2).ty,15)
        factionadd(0,fleet(f).ty,-25)
    else
        factionadd(0,fleet(f).ty,15)
        factionadd(0,fleet(f2).ty,-25)
    endif
    dprint "You join the fight on the side of the "&fname(side) &".",c_yel
    fleet(f)=add_fleets(fleet(f),fleet(f2))
    playerfightfleet(f)
    if player.dead=0 then
        dprint "The " & fname(side) & " hails your ship and thank you for your help in the battle.",c_gre
        fleet(f).ty=side
    endif
    return 0
end function


function playerfightfleet(f as short) as short
    dim as short a,total,f2,e,ter,x,y
    dim text as string
    dim fname(10) as string
    gen_fname(fname()) 
    
    for a=1 to 9
        basis(10).inv(a).v=0
        basis(10).inv(a).p=0
    next
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if spacemap(x,y)<>0 then ter+=1
            endif
        next
    next
    if fleet(f).ty=ft_ancientaliens then alliance(0)=1 'From now on we can build alliances
    spacecombat(fleet(f),spacemap(player.c.x,player.c.y)+ter)
    if player.dead=0 and fleet(f).flag>0 then player.questflag(fleet(f).flag)=2
    for a=1 to 8
        total=total+basis(10).inv(a).v
    next 
    'dprint ""&total
    if total>0 and player.dead=0 then trading(10)
    if player.dead=-1 then player.dead=0
    if player.dead>0 then
        for a=1 to 128
            if crew(a).hpmax>0 then player.deadredshirts+=1
        next
        if f<=5 then player.dead=36
'        if fleet(f).ty=2 then player.dead=5
'        if fleet(f).ty=4 then player.dead=5
'        if fleet(f).ty=1 then player.dead=13
'        if fleet(f).ty=3 then player.dead=13
'        if fleet(f).ty=5 then player.dead=31
'        if fleet(f).ty=6 then player.dead=32
'        if fleet(f).ty=7 then player.dead=33
        
    endif
    if _debug>0 then dprint "PD:"&player.dead
    fleet(f).ty=0
    return 0
end function


function fleet_battle(byref red as _fleet,byref blue as _fleet) as short
    dim as integer rscore,bscore
    dim as short i,f,t,j,debug,dam
    debug=1
    'Only one side shoots, collide fleets calls both alternately
    for i=1 to 15
        if red.mem(i).hull>0 and rnd_range(1,6)<5 then 'exits and has Initiative
            rscore+=1
            for f=1 to 25
                if red.mem(i).weapons(f).dam>0 and skill_test(red.mem(i).gunner(0),st_average) then
                    t=getship(blue)
                    if t>0 then
                        dam=red.mem(i).weapons(f).dam-blue.mem(t).shieldmax
                        if dam>0 then 
                            blue.mem(t).hull=blue.mem(t).hull-red.mem(i).weapons(f).dam
                            if blue.mem(t).hull<=0 and blue.mem(t).bounty>0 then bountyquest(blue.mem(t).bounty).status=3
                            if debug=1 and _debug=1 then dprint blue.mem(i).desig &"hit "&red.mem(t).desig &" for " &dam &" damage"
                        endif
                    endif
                endif
            next
        endif
    next
    for i=1 to 15
        if blue.mem(i).hull>0 then bscore+=1
    next
    if bscore>0 then return 0
    return -1
end function

function getship(f as _fleet) as short
    dim as short i,c
    dim as short m(15)
    for i=1 to 15
        if f.mem(i).hull>0 then
            c+=1
            m(c)=i
        endif
    next
    if c=0 then return -1
    return m(rnd_range(1,c))
end function

function collide_fleets() as short
    dim as short f1,f2
    for f1=1 to lastfleet
        for f2=1 to lastfleet
            if f1<>f2 and distance(fleet(f1).c,fleet(f2).c)<2 and fleet(f1).ty<>fleet(f2).ty then
                if fleet(f1).fighting<>0 then 'They already are in battle
                    if fleet_battle(fleet(f1),fleet(fleet(f1).fighting))=-1 then
                        'F1 has won
                        resolve_fight(fleet(f1).fighting)
                        battleslost(fleet(fleet(f1).fighting).ty,fleet(f1).ty)+=1
                        fleet(f1).fighting=0
                    endif
                else
                    decide_if_fight(f1,f2)
                endif
            endif
        next
    next
    
    return 0
end function

function resolve_fight(f2 as short) as short
    if f2<5 then
        basis(f2-1).c.x=-1 'Destroy station f2-1 by moving it off the map
        fleet(f2).ty=0 'Delete fleet for basis f2-1
    endif
    
    if rnd_range(1,100)<=2 and lastdrifting<128 then 'Add drifting debris
        If fleet(f2).ty=1 then
            lastdrifting+=1                                    
            lastplanet+=1
            drifting(lastdrifting).x=fleet(f2).c.x
            drifting(lastdrifting).y=fleet(f2).c.y
            drifting(lastdrifting).s=rnd_range(1,16)
            drifting(lastdrifting).m=lastplanet
            make_drifter(drifting(lastdrifting))
            planets(lastplanet).darkness=0
            planets(lastplanet).depth=1
            planets(lastplanet).atmos=4
            planets(lastplanet).mon_template(1)=makemonster(32,lastplanet)
            planets(lastplanet).mon_template(2)=makemonster(33,lastplanet)
            planets_flavortext(lastplanet)="No hum from the engines is heard as you enter the " &shiptypes(drifting(lastdrifting).s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        
        endif
    endif
    if fleet(f2).ty=1 or fleet(f2).ty=3 then patrolmod+=1
    fleet(f2).ty=0
    return 0
end function

function decide_if_fight(f1 as short,f2 as short) as short
    'Decides if f1 and f2 should start a fight
    dim as byte fighting,aggr1,aggr2 ,debug
    
    
    fighting=0
    if fleet(f1).ty<0 or fleet(f2).ty<0 or fleet(f1).ty>7 or fleet(f2).ty>7 then return 0
    aggr1=faction(fleet(f1).ty).war(fleet(f2).ty)
    aggr2=faction(fleet(f2).ty).war(fleet(f1).ty)
    
    if fleet(f1).ty=6 then aggr1+=civ(0).aggr+civ(0).inte
    if fleet(f1).ty=7 then aggr1+=civ(1).aggr+civ(1).inte
    if fleet(f2).ty=6 then aggr2+=civ(0).aggr+civ(0).inte
    if fleet(f2).ty=7 then aggr2+=civ(1).aggr+civ(1).inte
    
    aggr1+=rnd_range(1,10)
    aggr2+=rnd_range(1,10)
    
    if aggr1>=100 or aggr2>=100 then fighting=1
    
    'Eris always annihilates fleets that aren't space stations
    if (fleet(f1).ty=10 and f2<=5) then fleet(f2).ty=0 
    if (fleet(f2).ty=10 and f1<=5) then fleet(f1).ty=0 
    if debug=1 and _debug=1 then dprint "f1:"&aggr1 &"F2:"&aggr2
    'Ancient aliens attack everything
    if fleet(f1).ty=5 and fleet(f2).ty<>5 and player.questflag(3)=0 then fighting=1
    if fleet(f2).ty=5 and fleet(f1).ty<>5 and player.questflag(3)=0 then fighting=1
    
    if f1<=5 or f2<=5 and player.turn<262980 then fighting=0 'Spacestations aren't attcked before 6 months
    
    if fighting=1 then
        if debug=1 and _debug=1 then dprint "fight initiated between " &fleet(f1).ty &" and "&fleet(f2).ty
        fleet(f1).fighting=f2
        fleet(f2).fighting=f1
        fleet(f1).con(2)=f2
        fleet(f2).con(2)=f1
        if f1<3 then basis(f1).lastfight=f2
        if f2<3 then basis(f2).lastfight=f1
    endif
    return 0
end function

function set_fleet(fl as _fleet) as short
    dim as short i,f
    clearfleetlist
    lastfleet+=1
    if lastfleet>ubound(fleet) then
        lastfleet-=1
        for i=1 to lastfleet
            if fleet(i).ty=0 then f=i
        next
        if f=0 then f=rnd_range(6,lastfleet)
    else
        f=lastfleet
    endif
    fleet(f)=fl
    return f
end function

function makequestfleet(a as short) as _fleet
    dim f as _fleet
    dim as short b,c,i,e
    dim as _cords p1
    b=random_pirate_system
    if b<0 then
        p1.x=rnd_range(0,sm_x)
        p1.y=rnd_range(0,sm_y)
    else
        p1=map(b).c
    endif
    f.c=p1
    if a=5 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(8)
        f.flag=15'the infamous anne bonny
    endif
    if a=4 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(10) 'the infamous black corsair
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=16
    endif
    if a=3 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(30) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=17
    endif
    if a=2 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(31) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.mem(4)=make_ship(2)
        f.flag=18
    endif
    if a=1 then
        f.ty=4
        f.t=0 'All pirates start with target 9 (random point)
        f.mem(1)=make_ship(32) 'the infamous anne bonny
        f.mem(2)=make_ship(2)
        f.mem(3)=make_ship(2)
        f.flag=19
    endif
    'Company ships
    if a=6 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(34)
        f.c=basis(rnd_range(0,2)).c
    endif    
    if a=7 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(35)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=8 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(36)
        f.mem(2)=make_ship(12)
        f.mem(3)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=9 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(37)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.c=basis(rnd_range(0,2)).c
    endif
    if a=10 then
        f.ty=2
        f.t=0
        f.mem(1)=make_ship(38)
        f.mem(2)=make_ship(7)
        f.mem(3)=make_ship(7)
        f.mem(4)=make_ship(12)
        f.mem(5)=make_ship(12)
        f.c=basis(rnd_range(0,2)).c
    endif
    e=0
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function makepatrol() as _fleet
    dim f as _fleet
    f.ty=3
    f.mem(1)=make_ship(9)
    f.mem(2)=make_ship(7)
    f.mem(3)=make_ship(7)'one company battleship
    if rnd_range(1,100+player.turn/10000)>75 then f.mem(4)=make_ship(9)
    if rnd_range(1,100+player.turn/10000)>45 then f.mem(5)=make_ship(7)
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    return f
end function

function makemerchantfleet() as _fleet
    dim f as _fleet
    dim text as string
    dim as short a,b,debug
    f.ty=1
    a=rnd_range(1,3)
    for b=1 to a
        f.mem(b)=make_ship(6) 'merchantmen
        text=text &f.mem(b).icon
    next
    if rnd_range(1,100)>80-makepat*2 then
        for b=a+1 to a+2
            if rnd_range(1,100)<45+makepat then
                f.mem(b)=make_ship(7) 'escorts
                text=text &f.mem(b).icon
            else
                f.mem(b)=make_ship(12)
            endif
        next
    endif
    f.c=targetlist(firstwaypoint)
    f.t=firstwaypoint+1
    if show_NPCs=1 then dprint ""&a &":"& b &":"& text
    return f
end function 

function makepiratefleet(modifier as short=0) as _fleet
    dim f as _fleet
    dim as short maxroll,r,a
    
    dim as short b,c
    b=random_pirate_system
    f.ty=2
    f.con(15)=rnd_range(1,15)-rnd_range(1,10)-player.turn/10000 'Friendlyness
    f.t=0 'All pirates start with target 9 (random point)
    f.c=map(b).c
    maxroll=player.turn/15000'!
    if maxroll>60 then maxroll=60
    for a=1 to rnd_range(0,1)+cint(maxroll/20)    
        r=rnd_range(1,maxroll)+modifier
        f.mem(a)=make_ship(2)
        if r>15 then f.mem(a)=make_ship(3)
        if r>35 then f.mem(a)=make_ship(4)
        if r>45 then f.mem(a)=make_ship(5)
   next a
    return f
end function

function makealienfleet() as _fleet
    dim f as _fleet
    dim as short i,e,sys
    f.ty=5
    f.mem(1)=make_ship(11)
    sys=sysfrommap(specialplanet(29))
    if sys<0 then sys=sysfrommap(specialplanet(30))
    if sys<0 then sys=rnd_range(0,laststar)
    f.c=map(sys).c
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function makecivfleet(slot as short) as _fleet
    dim f as _fleet
    dim as short s,p,i,e
    f.ty=6+slot
    s=civ(slot).phil
    if civ(slot).phil=2 and rnd_range(1,100)<50 then s=s+rnd_range(1,2)
    if civ(slot).phil=3 and rnd_range(1,100)<33 then s=s+rnd_range(2,8)
    if s<1 then s=1
    for p=1 to s
        if rnd_range(0,100)<55-civ(slot).phil*5 then
            f.mem(p)=civ(slot).ship(0)
        else
            f.mem(p)=civ(slot).ship(1)
        endif
        f.mem(p).c=rnd_point
    next
    f.c=civ(slot).home
    f.t=3+(slot*4)
    
    for i=1 to 15
        if f.mem(i).engine/f.mem(i).hull<e then e=f.mem(i).engine/f.mem(i).hull
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f
end function

function civfleetdescription(f as _fleet) as string
    dim t as string
    dim as short slot,nos,a
    slot=f.ty-6
    if slot<0 or slot>1 then return ""
    for a=1 to 15
        if f.mem(a).hull>0 then nos+=1
    next
    if nos=1 then t="a single "
    if nos>1 and nos<4 then t="a small group of "
    if nos>=4 and nos<8 then t="a group of "
    if nos>=8 then t="a fleet of "
    't=t &"("&slot &")"
    if f.mem(1).hull<=2 then t=t &" tiny "
    if f.mem(1).hull>2 and f.mem(1).hull<5 then t=t &" small "
    if f.mem(1).hull>10 and f.mem(1).hull<15 then t=t &" big "
    if f.mem(1).hull>15 then t=t &" huge "
    if nos=1 then
        t=t &" ship "
    else
        t=t &" ships "
    endif
    if civ(slot).contact=1 then
        if nos=1 then
            t=t &" It's configuration is "&civ(slot).n &"."
        else
            t=t &" They are "&civ(slot).n &"."
        endif
    else
        if nos=1 then
            t=t &"It's configuration is alien, but it seems to be "
            if civ(slot).inte=1 then t=t &"an explorer."
            if civ(slot).inte=2 then t=t &"a trader."
            if civ(slot).inte=3 then t=t &"a warship."
        else
            t=t &"their configuration is alien but they seem to be "
            if civ(slot).inte=1 then t=t &"explorers."
            if civ(slot).inte=2 then t=t &"traders."
            if civ(slot).inte=3 then t=t &"warships."
        endif
    endif
    if show_NPCs then t=t &slot
    return t
end function

function add_fleets(byref target as _fleet,byref source as _fleet) as _fleet
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
    'if target.ty=2 then target=piratecrunch(target)
    
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
    b=random_pirate_system
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
            r.mem(a)=make_ship(2)
        next
        for a=f+1 to f+c
            r.mem(a)=make_ship(3)
        next
        for a=f+c+1 to f+c+d
            r.mem(a)=make_ship(4)
        next
        if b>1 then r.mem(b+c+d+1)=make_ship(5)
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
    for a=3 to lastfleet
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
        if f.mem(a).pilot(0)>r then r=f.mem(a).pilot(0)
    next
    return r
end function

function countfleet(ty as short) as short
    dim as short a,r
    for a=3 to lastfleet
        if fleet(a).ty=ty then r=r+1
    next
    return r
end function

function update_targetlist()as short
    static lastcalled as short
    dim as short b,piratesys
    piratesys=random_pirate_system
    if piratesys<0 then return 0
    targetlist(1).x=player.c.x
    targetlist(1).y=player.c.y
    if frac(lastcalled/25)=0 then
        targetlist(0).x=map(piratesys).c.x-30+rnd_range(0,60)
        targetlist(0).y=map(piratesys).c.y-10+rnd_range(0,20)
        targetlist(2)=map(piratesys).c
        targetlist(3).x=rnd_range(0,sm_x)
        targetlist(3).y=rnd_range(0,sm_y)
        targetlist(4).x=rnd_range(0,sm_x)
        targetlist(4).y=rnd_range(0,sm_y)
        targetlist(5).x=rnd_range(0,sm_x)
        targetlist(5).y=rnd_range(0,sm_y)
        
        targetlist(7).x=rnd_range(0,sm_x)
        targetlist(7).y=rnd_range(0,sm_y)
        targetlist(8).x=rnd_range(0,sm_x)
        targetlist(8).y=rnd_range(0,sm_y)
        targetlist(9).x=rnd_range(0,sm_x)
        targetlist(9).y=rnd_range(0,sm_y)
    endif
    if civ(0).inte=2 or 1=1 then
        if civ(0).knownstations(0)=1 then targetlist(3)=basis(0).c
        if civ(0).knownstations(1)=1 then targetlist(4)=basis(1).c
        if civ(0).knownstations(2)=1 then targetlist(5)=basis(2).c
    endif
    targetlist(6)=civ(0).home
    if civ(1).inte=2 or 1=1 then
        if civ(1).knownstations(0)=1 then targetlist(7)=basis(0).c
        if civ(1).knownstations(1)=1 then targetlist(8)=basis(1).c
        if civ(1).knownstations(2)=1 then targetlist(9)=basis(2).c
    endif
    targetlist(10)=civ(1).home
    lastcalled=lastcalled+1
    return 0
end function

function move_fleets() as short
    dim as short a,b,c,roll,direction,freecargo,s
    a=0
    if lastfleet>255 then lastfleet=255
    for a=6 to lastfleet
        update_targetlist()
        if fleet(a).ty=1 and fleet(a).con(1)=1 then fleet(a).c=player.c 
        if fleet(a).e.tick=-1 then
            if fleet(a).fighting=0 then
                if fleet(a).ty=2 then
                    freecargo=0
                    for b=1 to 15
                        if fleet(a).mem(b).hull>0 then 
                            for c=1 to 10
                                if fleet(a).mem(b).cargo(c).x=1 then freecargo+=1
                            next
                        endif
                    next
                    if freecargo=0 then fleet(a).t=0
                endif
                if skill_test(bestpilotinfleet(fleet(a)),st_veryeasy) or (fleet(a).ty=1 or fleet(a).ty=3) then
                    'move towards target
                    if fleet(a).t>=0 and fleet(a).t<=4068 then
                        direction=nearest(targetlist(fleet(a).t),fleet(a).c)
                    else 
                        fleet(a).t=0
                        direction=5
                    endif
                else
                    'move random
                    direction=5
                endif
                fleet(a).c=movepoint(fleet(a).c,direction,,1)
                fleet(a).add_move_cost
            
                fleet(a).fuel+=1
                if fleet(a).ty=10 then
                    if spacemap(fleet(a).c.x,fleet(a).c.y)<0 and rnd_range(1,100)<10 then spacemap(fleet(a).c.x,fleet(a).c.y)=0
                    if spacemap(fleet(a).c.x,fleet(a).c.y)>1 and rnd_range(1,100)<10 then spacemap(fleet(a).c.x,fleet(a).c.y)=0
                    if fleet(a).c.x=targetlist(fleet(a).t).x and fleet(a).c.y=targetlist(fleet(a).t).y then
                        eris_finds_apollo
                    endif
                endif
                'Check if reached target 
                if fleet(a).c.x=targetlist(fleet(a).t).x and fleet(a).c.y=targetlist(fleet(a).t).y then
                    if fleet(a).ty>5 and fleet(a).ty<8 then
                        if civ(fleet(a).ty-6).inte=2 then
                            merctrade(fleet(a))
                        endif
                        if fleet(a).c.x=civ(fleet(a).ty-6).home.x and fleet(a).c.y=civ(fleet(a).ty-6).home.y then
                            fleet(a)=unload_f(fleet(a),11)
                            fleet(a)=load_f(fleet(a),11)
                        endif
                    endif
                    if fleet(a).con(1)=0 then
                        fleet(a).t+=1 
                    else
                        fleet(a).t=1
                    endif
                    if fleet(a).t>=lastwaypoint and (fleet(a).ty=1 or fleet(a).ty=3) then fleet(a).t=firststationw
                    if (fleet(a).ty=2 or fleet(a).ty=4) and fleet(a).t>2 then fleet(a).t=0
                    if fleet(a).ty=6 and fleet(a).t>6 then fleet(a).t=3
                    if fleet(a).ty=7 and fleet(a).t>10 then fleet(a).t=7
                endif
                
                for s=0 to 2
                    
                    if fleet(a).ty=1 or fleet(a).ty=3 then
                        if fleet(a).c.x=basis(s).c.x and fleet(a).c.y=basis(s).c.y then merctrade(fleet(a))
                    endif
                    if fleet(a).ty<>3 and fleet(a).ty<>1 then 'No Merchant or Patrol
                        if distance(fleet(a).c,basis(s).c)<12 then
                            basis(s).lastsighting=a
                            basis(s).lastsightingdis=fix(distance(fleet(a).c,basis(s).c))
                            basis(s).lastsightingturn=player.turn
                        endif
                    endif
                    if fleet(a).ty>5 and fleet(a).ty<8 then
                        if distance(fleet(a).c,basis(s).c)<fleet(a).mem(1).sensors then 
                            civ(fleet(a).ty-6).knownstations(s)=1
                            if show_npcs then dprint civ(fleet(a).ty-6).n &"has discovered station "&s+1
                        endif
                    endif
                next
                
                
            endif
        endif
    next
    return 0
end function

function make_fleet() as _fleet
    dim as short roll,i,e,debug
    dim as _fleet f
    roll=rnd_range(1,6)
    if (countfleet(1)<countfleet(2) or faction(0).war(1)>faction(0).war(2)) or (debug=1 and _debug=1) then 
        f=makemerchantfleet
    else
        if configflag(con_easy)=1 or player.turn>25000 then 
            if random_pirate_system>0 then f=makepiratefleet
        else
            f=makepatrol
        endif
    endif
    if roll+patrolmod>10 and debug=0 and _debug=1 then 
        if show_npcs=1 then dprint roll &":" &patrolmod
        f=makepatrol
        patrolmod=0
        makepat=makepat+1
    endif
    e=999
    for i=1 to 15
        if f.mem(i).movepoints(0)<e and f.mem(i).movepoints(0)>0 then e=f.mem(i).movepoints(0)
    next
    f.mem(0).engine=e
    if f.mem(0).engine<1 then f.mem(0).engine=1
    return f 
end function
