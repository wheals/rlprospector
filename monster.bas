function setmonster(enemy as _monster,map as short,spawnmask()as _cords,lsp as short,x as short=0,y as short=0,mslot as short=0,its as short=0) as _monster    
    dim as short l,c
    if x=0 and y=0 then
        do
            l=rnd_range(1,lsp)
            c+=1
        loop until vismask(spawnmask(l).x,spawnmask(l).y)=0 or c=500
    endif
    if x=0 then x=spawnmask(l).x
    if y=0 then y=spawnmask(l).y
    enemy.c.x=x
    enemy.c.y=y  
    
    select case rnd_range(1,100)
    case 1 to 25
        enemy.hpmax=cint(enemy.hpmax*1.1)
    case 75 to 100
        enemy.hpmax=cint(enemy.hpmax*.9)
    end select
    
    if enemy.hpmax<0 then enemy.hpmax=1
    if enemy.hp>0 then enemy.hp=enemy.hpmax
    if its>0 then
        for l=0 to 8
            if rnd_range(1,100)<enemy.itemch(l) and enemy.items(l)<>0 then
                if enemy.items(l)>0 then
                    placeitem(make_item(enemy.items(l)),x,y,map,mslot,0)
                else
                    placeitem(rnd_item(-enemy.items(l)),x,y,map,mslot,0)
                endif
            endif
        next
    endif
    if enemy.allied<>0 then
        if rnd_range(1,100)<faction(0).war(enemy.allied) then
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
    endif
    return enemy
end function

function monster2crew(m as _monster) as _crewmember
    dim c as _crewmember
    c.icon=Chr(m.tile)
    c.hpmax=m.hpmax/5
    c.hp=c.hpmax
    if m.pumod>4 then
        c.equips=1
    else
        c.equips=0
    endif
    return c
end function

function count_diet(slot as short,diet as short) as short
    dim as short i,c
    for i=1 to 16
        if planets(slot).mon_template(i).diet=diet and planets(slot).mon_noamin(i)>0 then c=c+(planets(slot).mon_noamax(i)+planets(slot).mon_noamin(i))/2
    next
    return c
end function

function randomcritterdescription(enemy as _monster, spec as short,weight as short,movetype as short,byref pumod as byte,diet as byte,water as short,depth as short) as _monster

    dim as string text
    dim as string heads(4),eyes(4),mouths(4),necks(4),bodys(4),Legs(8),Feet(4),Arms(4),Hands(4),skin(7),wings(4),horns(4),tails(5)
    dim as short a,w1,w2
    dim as short limbsbyspec(12),eyesbyspec(12)
    dim as short noeyes,nolimbs,add,nolegs,noarms,armor,roll
    if water=1 then
        w1=4
        w2=1
    endif

    if weight<=0 then weight=1
    
    limbsbyspec(1)=2
    limbsbyspec(2)=8
    limbsbyspec(3)=6
    limbsbyspec(4)=4
    limbsbyspec(5)=4
    limbsbyspec(6)=0
    limbsbyspec(7)=2
    limbsbyspec(8)=10
    limbsbyspec(9)=50
    limbsbyspec(10)=4
    limbsbyspec(11)=0
    limbsbyspec(12)=6

    eyesbyspec(1)=2
    eyesbyspec(2)=8
    eyesbyspec(3)=4
    eyesbyspec(4)=2
    eyesbyspec(5)=2
    eyesbyspec(6)=2
    eyesbyspec(7)=2
    eyesbyspec(8)=2
    eyesbyspec(9)=6
    eyesbyspec(10)=2
    eyesbyspec(11)=2
    eyesbyspec(12)=2



    add=2-rnd_range(1,4)
    nolimbs=rnd_range(limbsbyspec(spec),limbsbyspec(spec)+add)
    if frac(nolimbs/2)<>0 then nolimbs=nolimbs+1
    add=2-rnd_range(1,4)
    noeyes=rnd_range(eyesbyspec(spec),eyesbyspec(spec)+add)
    noeyes=noeyes-depth
    if depth=0 and noeyes<2 then noeyes=2
    heads(1)="round"
    heads(2)="elongated"
    heads(3)="cone shaped"
    heads(4)="flat"

    horns(1)="short horns"
    horns(2)="long horns"
    horns(3)="curved horns"
    horns(4)="antlers"

    eyes(1)="pit eye"
    eyes(2)="compound eye"
    eyes(3)="lens eye"
    eyes(4)="eye spot"

    mouths(1)="elongated mouth"
    mouths(2)="small mouth"
    mouths(3)="big mouth"
    mouths(4)="trunk"

    necks(1)=""
    necks(2)="long"
    necks(3)="short"
    necks(4)="thick"

    bodys(1)="wide"
    bodys(2)="long"
    bodys(3)="thick"
    bodys(4)="thin"

    arms(1)="long arms"
    arms(2)="short arms"
    arms(3)="thick arms"
    arms(4)="tentacles"

    legs(1)="thin legs"
    legs(2)="short legs"
    legs(3)="tubular legs"
    legs(4)="tentacles"
    legs(5)="broad fins"
    legs(6)="long fins"
    legs(7)="legs with webbed feet"
    legs(8)="skin sacks for water jets"

    skin(1)=" fur"
    skin(2)=" scales"
    skin(3)=" leathery skin"
    skin(4)=" an exoskeleton"
    skin(5)=" a chitin shell"
    skin(6)=" feathers"
    skin(7)=" scales"

    wings(4)=" Skin flaps"
    wings(3)=" leather wings"
    wings(2)=" feathered wings"
    wings(1)=" an inflatable skin sack"

    tails(1)="prehensile tail"
    tails(2)="short tail"
    tails(3)="long tail"
    tails(4)="spiked tail"
    tails(5)="prehensile tail with a stinger"

    text=add_a_or_an(species(spec),1) &" with " & add_a_or_an(heads(rnd_range(1,4)),0) &" head, with "
    if noeyes>1 then text=text & noeyes &" "&eyes(rnd_range(1,4))&"s"
    if noeyes=1 then text=text & noeyes &" "&eyes(rnd_range(1,4))
    if noeyes=0 then text=text &" no eyes"
    if rnd_range(1,10)<7+w2 then
        text=text & " and " &add_a_or_an(mouths(rnd_range(1,4)),0)
    else
        text=text &", "&rnd_range(1,2)*2 &" "& horns(rnd_range(1,4)) & " and " &add_a_or_an(mouths(rnd_range(1,4)),0)
        enemy.weapon=enemy.weapon+1
    endif
    if spec<>8 then
        text=text &". "&add_a_or_an(necks(rnd_range(1,4)),1) &" neck leads to " & add_a_or_an(bodys(rnd_range(1,4)),0) &" body, with "
    else
        text=text &". It has "& add_a_or_an(bodys(rnd_range(1,4)),0) &" body, with "
    endif
    nolegs=rnd_range(1,6)*2
    if nolegs>nolimbs then
        nolegs=nolimbs
        nolimbs=0
    else
        nolimbs=nolimbs-nolegs
    endif

    noarms=rnd_range(1,6)
    if nolimbs=0 then noarms=0
    if noarms>nolimbs then noarms=nolimbs

    if pumod<0 and noarms=0 then noarms=2
    pumod=noarms
    if noarms>0 then
        text=text & noarms &" "& arms(rnd_range(1,4))
    else
        text=text &"no arms"
    endif

    if nolegs>0 then
        text=text & " and " & nolegs &" "&legs(rnd_range(1,4)+w1)
    else
        text=text & " and no legs"
    endif

    armor=rnd_range(1,6)+w2
    text=text &". Its whole body is covered in"&skin(armor)&"."
    if armor=1 then enemy.col=rnd_range(204,209)
    if armor=2 then
        enemy.col=rnd_range(1,3)
        if enemy.col=1 then enemy.col=78
        if enemy.col=2 then enemy.col=114
        if enemy.col=3 then enemy.col=120
    endif
    if armor=3 then enemy.col=rnd_range(90,94)
    if armor=4 then enemy.col=rnd_range(156,159)
    if armor=5 then
        enemy.col=rnd_range(215,217)
        enemy.armor+=1
    endif
    if armor=6 then
        enemy.col=rnd_range(74,77)
        enemy.armor+=2
    endif

    if armor>6 then armor=6
    enemy.ti_no=800+13*(spec-1)
    enemy.ti_no+=(armor-1)*2

    if rnd_range(1,6)<3 then
        if rnd_range(1,6)<3 then
            roll=rnd_range(1,3)
            if roll>1 then
                text=text &" It has " & roll &" "&tails(rnd_range(1,5))&"s."
            else
                text=text &" It has "&add_a_or_an(tails(rnd_range(1,5)),0)&"."
            endif
            enemy.weapon=enemy.weapon+1
        else
            roll=rnd_range(1,5)
            text=text &" It has "&add_a_or_an(tails(roll),0)&"."
            if roll=4 then enemy.weapon=enemy.weapon+1
            if roll=5 then
                enemy.weapon=enemy.weapon+1
                enemy.atcost=enemy.atcost-2
                if enemy.atcost<0 then enemy.atcost=2
            endif
        endif
    endif

    text=text &" It weighs appr. "&(weight*rnd_range(1,8)*rnd_range(1,10)) &" Kg."

    if movetype=mt_fly then
        if rnd_range(1,100)<66 then
            text= text &" It flies using "&wings(rnd_range(1,3)) &"."
        else
            text= text &" It flies using "&rnd_range(1,3) & " pairs of "&wings(rnd_range(2,4)) &"."
        endif
    endif
    if diet=1 then text=text &" It is a predator."
    if diet=2 then
        if rnd_range(1,100)<66 then
            text=text &" It is a herbivore."
        else
            text=text &" It is an omnivore"
        endif
    endif
    if diet=3 then text=text &" It is a scavenger."
    enemy.ldesc=text
    return enemy
end function


function makemonster(a as short, map as short, forcearms as byte=0) as _monster
    dim enemy as _monster
    dim as short d,e,l,mapo,g,r,ahp,debug,prettybonus,tastybonus
    dim as single easy
    static ch(12) as short
    static ad(12) as single
    dim as string prefix
    debug=55
    if a=0 then
        if debug=1 and _debug=1 then dprint "ERROR: Making monster 0",14
        return enemy
    endif
    
    enemy.made=a
    enemy.dhurt="hurt"
    enemy.dkill="dies"
        
    ad(1)=1
    ad(2)=0
    ad(3)=0
    ad(4)=3
    ad(5)=3
    ad(6)=1
    ad(7)=2
    ad(8)=1
    ad(9)=1
    ad(10)=1
    ad(11)=1
    
    ch(1)=66
    ch(2)=65
    ch(3)=73
    ch(4)=77
    ch(5)=asc("l")
    ch(6)=asc("s")
    ch(7)=asc("h")
    ch(8)=asc("q")
    ch(9)=asc("c")
    ch(10)=asc("f")
    ch(11)=asc("g")
    ch(12)=asc("f")
    for g=0 to 128
        if crew(g).hp>0 then ahp=ahp+1
    next
    
    'b=(ahp\12)+1 'HD size
'    'b=b+planets(map).depth
'    if b<2 then b=2
'    if b>8 then b=8
'    
'    c=(ahp\15)+1 'Times rolled
'    if c<1 then c=1
'    if c>10 then c=10
'     'maxpossible
'        
    enemy.made=a 'saves how the critter was made for respawning
    
    if a=1 or a=24 then 'standard critter
        if _debug>0 and debug=55 then a=24
        'Postion
        if planets(map).atmos=1 then enemy.hasoxy=1
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        
        enemy.sight=rnd_range(3,6)
        
        enemy.nocturnal=0
        if planets(map).rot>0 and planets(map).depth=0 then
            if rnd_range(1,100)<66 then
                enemy.nocturnal=rnd_range(1,2)
            endif
        endif
        'Behavior
        enemy.aggr=rnd_range(0,2)
        enemy.respawns=1
        d=rnd_range(1,8) '1 predator, 2 herbivore, 3 scavenger
      
        if d=8 then enemy.diet=3
        if d<5 then enemy.diet=2
        if d>=5 and d<8 then enemy.diet=1
        if enemy.diet=1 and debug=1 and _debug=1 then dprint "Rate:" &(count_diet(map,1)+1)& ":" &(count_diet(map,2)+1)& "="& (count_diet(map,1)+1)/(count_diet(map,2)+1)
        if enemy.diet=1 and (count_diet(map,1)+1)/(count_diet(map,2)+1)<=.25 then enemy.diet=2 'Need 3 herbivoures at least to support one carni
        if enemy.diet=3 and (count_diet(map,3)+1)/(count_diet(map,1)+1)<=.25 then enemy.diet=2 'Need 3 carni at least to support one scav
        enemy.speed=rnd_range(0,5)+rnd_range(0,4)+rnd_range(0,enemy.weapon)
        enemy.speed=enemy.speed/(planets(map).grav+.1)
        if enemy.speed<1 then enemy.speed=1
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then
            if a=1 or rnd_range(1,100)>66 then
                enemy.movetype=mt_fly
            endif
        endif
        'Looks
        enemy.cmmod=rnd_range(1,2)+enemy.diet*3
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.lang=-1
        enemy.atcost=rnd_range(7,10)
        enemy.intel=rnd_range(1,5)
        if a=1 then enemy.intel=enemy.intel+rnd_range(1,3)
        if rnd_range(1,15)<enemy.intel then enemy.aggr=1
        if enemy.intel=6 and rnd_range(1,100)<33 then
            enemy.range=3
            enemy.sight=3
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="shoots bows and arrows"
            enemy.scol=4
            enemy.atcost=rnd_range(6,8)
            enemy.items(1)=94
            enemy.itemch(1)=15
            enemy.items(2)=91
            enemy.itemch(2)=55
        endif
        if enemy.intel>=7 and rnd_range(1,100)<33  then
            enemy.range=4
            enemy.sight=4
            enemy.pumod=-1 'gives 2 arms minimum
            enemy.swhat="fires a primitive handgun"
            enemy.scol=7
            enemy.atcost=rnd_range(5,7)
            enemy.items(1)=94
            enemy.itemch(1)=15
            enemy.items(2)=94
            enemy.itemch(2)=15
            enemy.items(2)=92
            enemy.itemch(2)=55
        endif
        if forcearms>0 then enemy.pumod=-1 '2 arms minimum
        g=rnd_range(1,11)
        if a=24 then g=12
        enemy.tile=ch(g)
        enemy.sprite=260+g
        if g=2 then enemy.movetype=mt_climb 'Spinnen klettern
        if g=12 then enemy.movetype=mt_hover 'Fish
        if g=7 then enemy.intel=enemy.intel+1
        if g=10 or a=24 then enemy.movetype=mt_climb
        if g=11 then enemy.speed+=3
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<15-enemy.intel*2 then enemy.disease=rnd_range(1,15)
        
        enemy.hp=enemy.hp+rnd_range(1,5)+rnd_range(1,ad(g))+rnd_range(1,1+planets(map).depth)
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hp=enemy.hp*planets(map).grav
        enemy.hpmax=enemy.hp
        
        
        enemy.sdesc=species(g)
        enemy=randomcritterdescription(enemy,g,enemy.hp/planets(map).grav,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)
        if a=24 then enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,1,planets(map).depth)
        if rnd_range(1,15)<planets(map).depth then
            enemy.breedson=rnd_range(0,5+planets(map).depth)
        endif
        if enemy.breedson=0 and enemy.aggr=0 and enemy.intel<4 and rnd_range(1,100)<33 then
            enemy.hp=enemy.hp+rnd_range(1,4)+rnd_range(1,2)
            enemy.hpmax=enemy.hp
            enemy.invis=2
            enemy.aggr=0
            enemy.weapon+=2
            enemy.speed-=4
            if enemy.speed<1 then enemy.speed=1
            enemy.atcost=enemy.atcost-2
            enemy.diet=1
        endif
        if planets(map).atmos>=14 and enemy.weapon>0 and rnd_range(1,100)=100 then enemy.specialattack=SA_corrodes
        if enemy.weapon>2 then enemy.col=12
        if enemy.hp>9 then 
            enemy.tile=asc(ucase(chr(enemy.tile)))
            enemy.hpmax=enemy.hpmax+rnd_range(1,2)
            enemy.hp=enemy.hpmax
        else
            enemy.tile=asc(lcase(chr(enemy.tile)))
            if enemy.ti_no<>0 and enemy.ti_no<1000 then enemy.ti_no+=1
        endif
        if enemy.ti_no<1000 and forcearms<>0 then
            if enemy.ti_no>=930 and enemy.ti_no<942 then enemy.ti_no=942
            if enemy.ti_no>=917 and enemy.ti_no<929 then enemy.ti_no=929
            if enemy.ti_no>=904 and enemy.ti_no<916 then enemy.ti_no=916
            if enemy.ti_no>=891 and enemy.ti_no<903 then enemy.ti_no=903
            if enemy.ti_no>=879 and enemy.ti_no<890 then enemy.ti_no=890
            if enemy.ti_no>=864 and enemy.ti_no<878 then enemy.ti_no=878
            if enemy.ti_no>=852 and enemy.ti_no<864 then enemy.ti_no=864
            if enemy.ti_no>=839 and enemy.ti_no<851 then enemy.ti_no=851
            if enemy.ti_no>=826 and enemy.ti_no<838 then enemy.ti_no=838
            if enemy.ti_no>=813 and enemy.ti_no<825 then enemy.ti_no=825
            if enemy.ti_no>=800 and enemy.ti_no<812 then enemy.ti_no=812
        endif
        enemy.sdesc=enemy.sdesc
        'enemy.invis=2
        if enemy.hpmax>20 then prefix="giant"
        if enemy.hpmax>10 and enemy.hpmax<21 then prefix= "huge"
        if enemy.hpmax>10 then prefix=""
        if enemy.weapon>2 then 
            if prefix="" then
                prefix=prefix &"vicious"
            else 
                prefix=prefix &" ,vicious"
            endif
        endif
        if prefix<>"" then prefix=prefix &" "
        enemy.sdesc=prefix &enemy.sdesc
        if enemy.ti_no=0 then enemy.ti_no=g+1001
        if rnd_range(1,50)<enemy.hpmax then enemy.stunres=rnd_range(1,4)
    endif
    
    if a=2 then 'Powerful standard critter
        'Postion
        g=rnd_range(1,5)
        enemy.tile=ch(g)
        enemy.sdesc=species(g)
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        enemy.hp=10+rnd_range(5,15)+rnd_range(5,ad(g))*5+rnd_range(1,1+planets(map).depth)
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        'Behavior
        enemy.aggr=0
        enemy.intel=rnd_range(1,4)
        enemy.respawns=1
        enemy.biomod=1.5
        enemy.stunres=rnd_range(3,6)
        enemy.diet=1
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))
        
        
        enemy.ti_no=g+750
        
        enemy.atcost=rnd_range(6,8)
        if enemy.speed<=1 then enemy.speed=1
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            enemy.hasoxy=1
            enemy.stunres=7
            select case planets(map).temp
            case is>200
                    enemy.ti_no=1051
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.speed=8
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.ti_no=1052
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.speed=9
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    enemy.ti_no=1053
                    
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.speed=4
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                for l=0 to rnd_range(2,5)
                    enemy.items(l)=99
                    enemy.itemch(l)=33
                next
                enemy.biomod=2.2
            endif
            If planets(map).depth>0 then
                enemy.stunres=8
                enemy.ti_no=1054
                enemy.movetype=mt_dig
                enemy.track=4
                enemy.weapon=5
                enemy.speed=4
                enemy.armor=4
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
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=1 or a=2 or a=24 then 'Tasty and pretty for random critters
        if a=24 then prettybonus=5
        select case rnd_range(1,100)+prettybonus*5
        case 50 to 75
            enemy.pretty=rnd_range(1,10)
        case 76 to 95
            enemy.pretty=rnd_range(5,10)
        case 96 to 100
            enemy.pretty=rnd_range(8,10)
        end select
        if is_gardenworld(map) then tastybonus=3
        if enemy.diet=0 then tastybonus+=1 'Herbivoures are usually better eating
        select case rnd_range(1,100)+tastybonus*5
        case 50 to 75
            enemy.tasty=rnd_range(1,10)
        case 76 to 95
            enemy.tasty=rnd_range(5,10)
        case is >96
            enemy.tasty=rnd_range(8,10)
        end select
    endif
    
    if a=3 or a=7 then'Pirate band
         '7 Non agressive
        'Postion
        enemy.intel=5
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.faction=2
        enemy.ti_no=a+1010
        'Fighting Stats
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=enemy.hp+rnd_range(4,10)
        enemy.hp=enemy.hp+5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.allied=2
        enemy.enemy=1
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=(rnd_range(0,6)+rnd_range(0,6)+rnd_range(0,enemy.weapon))
        if enemy.speed<=4 then enemy.speed=4
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.faction=2
    endif
    
    if a=4 then 'Plantmonster 
            
        enemy.ti_no=1014
        enemy.speed=-1
        
        enemy.weapon=rnd_range(0,1)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,3)+rnd_range(1,3))*(enemy.weapon+1)
        
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.biomod=1.2
        enemy.tile=ASC("P")
        enemy.sprite=277
        enemy.ti_no=1014
        enemy.col=4
        enemy.scol=4
        enemy.atcost=rnd_range(6,8)
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="shoots a volley of sharp thorns"
        enemy.sdesc="Plantmonster"
        enemy.ldesc="A squat brownish trunk, 1.5 to 2m high, covered by dark green leaves. Extremly long vines are used to gather food for this immobile creature"
    endif
    
    if a=5 then 'apollo
        enemy.ti_no=1015
        enemy.lang=4
        enemy.weapon=4
        enemy.range=1.5
        enemy.hp=rnd_range(50,60)
        enemy.armor=2
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=12
        enemy.tile=ASC("H")
        enemy.sprite=278
        enemy.col=14
        enemy.scol=11
        enemy.atcost=rnd_range(3,4)
        enemy.movetype=mt_ethereal
        enemy.hasoxy=1
        enemy.stunres=4
        enemy.intel=5
        enemy.sight=7
        enemy.biomod=2
        enemy.respawns=0
        enemy.teleportrange=10
        enemy.items(1)=303
        enemy.itemch(1)=75
        enemy.dhurt="hurt"
        enemy.dkill="dies"   
        enemy.swhat="shoots a lightning bolt "
        enemy.sdesc="Apollo"
        enemy.ldesc="3 Meters tall, a mountain of muscles, lightning strikes wherever he points"
    endif
    
    if a=6 then 'Fighting leaf
        enemy.ti_no=1016
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=0
        enemy.hp=1
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(8,10)
        'Behavior
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=14
        enemy.movetype=mt_fly
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="leaf"
        enemy.ldesc="four prehensile leafs lift this small creature in the air. A dark red, woody appendege drips poison" 
        enemy.lang=-1
        enemy.biomod=0.5
        enemy.atcost=2
        enemy.tile=ASC("o")
        enemy.sprite=279
        enemy.col=10
    endif
    
    if a=8 then
        enemy.stunres=10
        enemy.ti_no=1018
        enemy.faction=5 'robots
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
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=5+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next       
        enemy.faction=5    
    endif
    
    if a=9 then
        enemy.stunres=10
        enemy.ti_no=1019
        enemy.faction=5 'Vault bots
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
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,5+planets(a).depth)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon+1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=139
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        for l=0 to rnd_range(2,6)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next
        enemy.faction=5
    endif
            
    if a=10 then 'seeweed
        enemy.ti_no=1020
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
        enemy.speed=2
        enemy.movetype=mt_climb
        enemy.atcost=rnd_range(6,8)
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Seawead"
        enemy.ldesc="growing upwards from the bottom of the ocean, this seawead grows incredibly fast. It lazily brushes around, leaving acidburns on any fish or flesh it touches. obviously a carnivorous plant"
        enemy.tile=Asc("o")
        enemy.sprite=283
        enemy.col=10
    endif
     
    if a=11 then 'Sandworm
        enemy.stunres=8
        enemy.ti_no=1021
        enemy.made=11
        enemy.hp=50        
        for l=1 to 8
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.armor=3
        enemy.weapon=2
        enemy.speed=14
        enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=1.5
        enemy.aggr=0
        enemy.tile=Asc("W")
        enemy.sprite=284
        enemy.col=14
        enemy.atcost=rnd_range(3,5)
        enemy.sight=4
        enemy.hasoxy=1
        enemy.track=179
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sdesc="Sandworm"
        enemy.ldesc="At first a wave in the sand, and then a huge maw opens to devour whatever tresspasses in his domain." 
    endif
        
    if a=12 then  'Hunting Spider
        enemy.ti_no=1022
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        enemy.hp=rnd_range(1,3)+8
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=12
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.sprite=285
        enemy.col=4
    endif
    
    if a=13 then 'Invisibles
        enemy.ti_no=1023
        enemy.sdesc="????"
        enemy.ldesc="Something is here. But you cant see anything."
        enemy.dhurt="hurt"
        enemy.dkill="silent"
        enemy.sight=4
        enemy.breedson=3
        enemy.invis=1
        enemy.range=1.5
        enemy.biomod=1.3
        enemy.atcost=rnd_range(9,12)
        enemy.weapon=1
        enemy.hp=rnd_range(1,3)
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.biomod=1.5
        enemy.hpmax=enemy.hp
        enemy.speed=16
        enemy.aggr=0
        enemy.tile=Asc("A")
        enemy.col=4
    endif
        
    if a=14 or a=88 then
        enemy.faction=8 'Citizen
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.allied=1
        enemy.enemy=2
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.intel=5
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        enemy.speed=9
        if a=88 then 
            enemy.faction=8
            enemy.allied=0
            enemy.aggr=1
            enemy.lang=34
        endif
        if _debug>0 then enemy.teleportrange=10
    endif
    
    if a=15 then
        enemy.ti_no=1026
        enemy.faction=1 'Enemy Awayteam
        enemy.made=15
        enemy.sdesc="awayteam"
        enemy.ldesc="another freelancer team"
        enemy.lang=5
        enemy.intel=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.allied=1
        enemy.enemy=2
        enemy.aggr=1
        enemy.hasoxy=1
        enemy.diet=4 'Resources
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=mt_fly
        enemy.atcost=rnd_range(6,8)
        
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
        enemy.speed=8
        enemy.respawns=0
        enemy.items(1)=-RI_weaponsarmor
        enemy.itemch(1)=99
        enemy.items(2)=96
        enemy.itemch(2)=25
        enemy.items(3)=-RI_weaponsarmor
        enemy.itemch(3)=88
        enemy.items(3)=96
        enemy.itemch(3)=25
        enemy.items(4)=-RI_weaponsarmor
        enemy.itemch(4)=77
        enemy.items(5)=96
        enemy.itemch(5)=66
    
    endif
    
    if a=16 then 'Spitting Critter
        g=rnd_range(1,5)
        enemy.ti_no=1001+g
        enemy.range=2.5
        enemy.swhat="spits acid"
        enemy.scol=10
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(2,8)
        next
        enemy.hp=enemy.hp+rnd_range(1,2)+enemy.weapon
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)+2
        enemy.armor=1
        enemy.aggr=0
        enemy.respawns=1
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)-rnd_range(0,enemy.weapon))
        if enemy.speed<=1 then enemy.speed=1
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.movetype=mt_fly
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.tile=ch(g)
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
        enemy.sdesc=species(g)
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)
        enemy.sprite=269+g
        enemy.biomod=2.3
    endif
        
    
    if a=17 then 'Stone Monster
        enemy.ti_no=1026
        enemy.speed=-1
        enemy.atcost=rnd_range(8,12)
        enemy.weapon=rnd_range(1,2)
        enemy.range=2+enemy.weapon
        enemy.hp=(rnd_range(1,3)+rnd_range(1,3))*(enemy.weapon)
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
    
    if a=18 then 'Breedworm
        enemy.ti_no=1027
        enemy.atcost=rnd_range(7,9)
        enemy.range=1.5
        enemy.weapon=rnd_range(1,5)-3+planets(map).depth
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 1+planets(map).depth
            enemy.hp=enemy.hp+rnd_range(1,2)
        next
        enemy.hp=enemy.hp+rnd_range(0,2)+enemy.weapon+planets(map).depth
        enemy.hpmax=enemy.hp
        enemy.sight=rnd_range(3,6)
        enemy.biomod=0.2
        'Behavior
        enemy.aggr=0
        enemy.respawns=1
        enemy.speed=(rnd_range(0,4)+rnd_range(0,3)-rnd_range(0,enemy.weapon))
        if enemy.speed<=1 then enemy.speed=1
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
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
    
    if a=19 then 'Invisible bot
        enemy.ti_no=1028
        enemy.faction=5
        enemy.sdesc="????"
        enemy.ldesc="the air shimmers showing some kind of cloaking device."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.atcost=rnd_range(3,5)
        enemy.armor=2
        enemy.lang=-3
        enemy.sight=5
        enemy.hasoxy=1
        enemy.invis=1
        enemy.hp=rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.weapon=rnd_range(4,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.tile=28
        enemy.speed=13
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
    endif
            
    
    if a=20 then 'bluecap
        enemy.ti_no=1029
        enemy.atcost=rnd_range(6,8)
        enemy.sdesc="armed reptile"
        enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a blue helmet, and wields an obviously human made Gauss gun!"
        enemy.lang=6
        enemy.sprite=290
        enemy.faction=8
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.aggr=1
        enemy.biomod=1
        enemy.cmmod=5
        enemy.intel=5
        enemy.sight=3
        enemy.range=3.5
        enemy.weapon=2
        enemy.swhat="shoots its gaussgun!"
        enemy.scol=11
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hpmax=enemy.hp
        enemy.speed=10
        enemy.aggr=1
        enemy.tile=Asc("L")
        enemy.col=47
        enemy.items(0)=7
        enemy.itemch(0)=66
    endif  

 
    if a=21 OR a=66 or a=67 or a=68 or a=69 then 'Tombspider 
        enemy.ti_no=1030
        enemy.sdesc="Spider"
        enemy.ldesc="A huge hunting spider. They seem to have found a taste for human flesh"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.atcost=rnd_range(6,8)
        enemy.sight=1
        enemy.range=1.5
        enemy.weapon=2
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.sprite=274
        enemy.hpmax=enemy.hp
        enemy.speed=12
        enemy.aggr=0
        enemy.biomod=1.45
        enemy.tile=Asc("A")
        if a=66 then 'Tombworm
            enemy.ti_no=1031
            enemy.tile=Asc("I")
            enemy.col=8
            enemy.armor=3
            enemy.sdesc="Beetle"
            enemy.ldesc="A huge beetle with mandibles strong enough to sever a limb. By some curious coincidence it's carapace shows a marking resembling a human skull." 
            enemy.sprite=275
        endif
        if a=67 then enemy.invis=2 'Hiding TOmbspider
        if a=68 then 'Tombworm
            enemy.ti_no=1032
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
        if a=69 then 'Tombworm
            enemy.ti_no=1033
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
    endif
    
    if a=22 then 'Intelligent Centipede
        enemy.ti_no=1034
        enemy.sdesc="centipede"
        enemy.ldesc="a 3m long centipede. It only uses its lower 12 legs for movement. It's upper body is erect and its 12 arms end in slender 3 fingered hands. It has a single huge compound eye at the top of its head. It has 2 mouths, one for eating and one for breathing and talking. It is a herbivore." 
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=3
        enemy.range=1.5
        enemy.weapon=1
        for l=1 to 2
            enemy.hp=enemy.hp+rnd_range(1,10)
        next
        enemy.cmmod=8
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.speed=6
        enemy.aggr=1
        enemy.intel=5
        enemy.diet=2
        enemy.biomod=3
        enemy.col=7
        enemy.tile=Asc("c")
        enemy.lang=8
        enemy.intel=9
        enemy.sprite=280
        
    endif
            
    if a=23 then 'Casino Thug
        enemy.ti_no=1512
        enemy.sight=35
        enemy.sdesc="thug"
        enemy.ldesc="an armed band of thugs"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=0
        enemy.diet=0 
        enemy.pumod=60
        enemy.hasoxy=1
        enemy.intel=5
        
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
        enemy.armor=rnd_range(0,1)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=asc("H")
        enemy.sprite=277
        enemy.col=18
        enemy.speed=8
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
    endif   
    
    'a=24 is taken for fish
    
    if a=25 or a=26 or a=37 or a=80 then 'Intelligent Insectoids
        if a=25 then enemy.ti_no=1036
        if a=26 then enemy.ti_no=1037
        if a=37 or a=80 then enemy.ti_no=1038
        enemy.faction=9
        enemy.sight=3
        enemy.sdesc="insectoid"
        enemy.ldesc="an insect with 6 legs, compound eyes and long feelers. They are between 1 and 3 m long and can stand on their hindlegs to use theif front legs for manipulation. Their colourfull carapace seems to signifiy some caste system."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        'enemy.intel=4
        enemy.biomod=1
        enemy.atcost=rnd_range(3,6)
        enemy.cmmod=6
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
        enemy.speed=6
        enemy.hasoxy=1
        enemy.lang=-11
        if a=26 then enemy.lang=-13
        if a=25 then
            enemy.col=12
            enemy.weapon=2
            enemy.armor=2
            if rnd_range(1,150)<25 then enemy.lang=-12
        endif
        if a=37 then enemy.lang=-17
        if a=80 then enemy.lang=-12
        if _debug>0 then enemy.lang=12
        enemy.respawns=1
    endif
    
    if a=27 then 'Living Plasma
        enemy.ti_no=1039
        enemy.stunres=9
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_ethereal
        enemy.aggr=0
        enemy.sight=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.hp=rnd_range(2,18)+rnd_range(2,8)
        enemy.range=3.5
        enemy.weapon=2
        enemy.speed=18
        enemy.sdesc="cloud"
        enemy.ldesc="several mulitcolored gas clouds. They seem to be moving towards you and are held together by static electricity."
        enemy.tile=176
        enemy.col=205
        enemy.swhat="shoots lightning bolts"
        enemy.scol=11
        enemy.hpmax=enemy.hp
    endif
    
    if a=28 then 'Slaved Citizen
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a dazed looking human pioneer"
        enemy.lang=14
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=2
        enemy.pumod=5
        enemy.intel=1
        enemy.sight=4
        enemy.range=1.5
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.atcost=12
        enemy.col=23
        enemy.speed=6
        enemy.aggr=1
        enemy.hasoxy=1
    endif
    
    if a=29 then 'Living crystal
        enemy.stunres=9
        enemy.ti_no=1041
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        enemy.pumod=5
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=11
        enemy.armor=7
        enemy.hasoxy=1
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=24+rnd_range(2,5)+rnd_range(2,5)
        enemy.col=236
        enemy.aggr=0
        enemy.speed=7
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif
    
    
    if a=30 then
        enemy.ti_no=1042
        enemy.sight=3
        enemy.sdesc="starcreature"
        enemy.ldesc="This creature resembles are giant starfish with 5 legs bent downwards ending in 7 fingered hands. It uses them for walking as well as for fine manipulating. The top of it's body features 3 eye stalks with compound eyes. A tube under its body ends in a maw with sharp teeth."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=6
        enemy.intel=5
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=1'Resources
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(1,4)+rnd_range(1,4)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("x")
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(108,113)
        enemy.speed=8
        enemy.lang=-10
        enemy.respawns=1
    endif
    
    if a=31 then
        enemy.ti_no=1043
        enemy.sdesc="living crystal"
        enemy.ldesc="This being resembles an insect. 3 meters high, 6 legs and 5 arms and a tiny head. Underneath it's transparent crystaline shell you see pink flesh and blue veins."
        enemy.lang=15
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=0
        
        enemy.intel=5
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=4
        enemy.atcost=11
        enemy.armor=7
        enemy.hasoxy=1
        enemy.tile=Asc("*")
        enemy.sprite=180
        enemy.hpmax=44+rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=enemy.hpmax
        enemy.col=236
        enemy.aggr=0
        enemy.speed=7
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif

    if a=32 then
        enemy.ti_no=1044
        enemy.faction=1
        enemy.made=32
        enemy.sight=35
        enemy.sdesc="crewmember"
        enemy.ldesc="a member of the crew of this ship"
        enemy.lang=16
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.intel=5
        enemy.aggr=1
        enemy.diet=0
        enemy.allied=1
        enemy.enemy=2
        enemy.hasoxy=1
        enemy.pumod=60
        enemy.atcost=rnd_range(6,8)
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
        enemy.tile=Asc("H")
        enemy.sprite=287
        enemy.col=53
        enemy.speed=10
        enemy.respawns=0
        for l=0 to rnd_range(2,6)
            enemy.items(l)=20
            enemy.itemch(l)=15
        next
    endif
    
    if a=33 then
        enemy.ti_no=1045 'Dead Crewmembers
        enemy.made=32
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        enemy.ldesc="crewmember"
        e=rnd_range(1,100)
'        if e<20 then
'            d=rnd_range(3,9)
'            enemy.ldesc="A dead member of the crew of this ship. He has a " & make_item(d).desig &" between his legs, firm in his hands. His head is missing."
'            enemy.items(0)=d
'            enemy.itemch(0)=100
'        endif
'        if e>19 and e<50 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit."
'        endif
'        if e>49 and e<60 then
'            enemy.ldesc="A crewmember lying dead in a corner."
'        endif
'        if e>59 and e<70 then
'            enemy.ldesc="This crewmember took off his helmet. His head is covered in ice."
'        endif
'        if e>69 and e<80 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit."
'        endif
'        if e>79 then
'            enemy.ldesc="This crewmember suffocated in his spacesuit. His oxygen tank is missing"
'        endif
    endif
    
    if a=34 then 'Mushroom
        enemy.ti_no=1046
        enemy.hp=rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.tile=asc("9")
        enemy.col=26
        enemy.sdesc="crawling mushroom"
        enemy.ldesc="a huge mushroom with a prehensile rootsystem"
        enemy.biomod=1.2
        enemy.speed=2
        enemy.atcost=8
        enemy.range=2.5
        enemy.sight=3.5
        enemy.weapon=1
        enemy.swhat="shoots acidic spores."
        enemy.scol=10
        enemy.breedson=25
    endif
    
    if a=35 then
        g=rnd_range(0,4)
        enemy.ti_no=1001+g 'Powerful standard critter
        enemy.tile=ch(g)
        enemy.sdesc=species(g)
        enemy.sprite=261+g
        'Fighting Stats
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 5+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,6)
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
        enemy.speed=rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon)
        if enemy.speed>19 then enemy.speed=19
        if enemy.speed<1 then enemy.speed=1
        enemy.invis=2
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        enemy.atcost=5
        enemy.atcost=rnd_range(6,8)
        if rnd_range(1,100)<(planets(map).atmos-1)*10/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        endif
        'Looks
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=36 then
        enemy.ti_no=1047
        enemy.hp=1
        enemy.hpmax=1
        enemy.aggr=0
        enemy.speed=16
        enemy.atcost=99
        enemy.breedson=1
        enemy.tile=asc("o")
        enemy.col=39
        enemy.biomod=1
        enemy.sight=5
        enemy.hasoxy=1
        enemy.sdesc="batlike creature"
        enemy.ldesc="a small creature with 3 eyes, no mouth or legs, using 2 skin wings to fly"
        enemy.faction=9
    endif
    
    '37=aliens on generation ship
    
    if a=38 then 'Bouncy Ball
        enemy.ti_no=1048
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
        enemy.speed=8
        enemy.atcost=5
        enemy.range=2.5
        enemy.sight=3.5
        enemy.hasoxy=1
        enemy.weapon=0
        enemy.scol=192
    endif
    
    
    if a=39 then 'Citizen
        enemy.ti_no=-1
        enemy.faction=8
        enemy.hasoxy=1
        enemy.sdesc="tourist"
        enemy.ldesc="a visitior of the ditch"
        enemy.lang=41
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.allied=1
        enemy.intel=5
        enemy.enemy=2
        enemy.pumod=5
        enemy.sight=4
        enemy.speed=8
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        enemy.faction=1
    endif
        
    if a=40 then 'zombies
        enemy.ti_no=1050
        enemy.hasoxy=1
        enemy.made=40
        enemy.sight=35
        enemy.sdesc="fast miner"
        enemy.ldesc="a miner in a spacesuit with an empty expression on his face. He moves increadibly fast!"
        enemy.lang=5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=4
        enemy.aggr=0
        enemy.diet=1
        enemy.pumod=60
        enemy.atcost=3
        enemy.disease=17
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
        endif
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)+5
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(1,3)
        enemy.weapon=rnd_range(1,3)
        enemy.tile=64
        enemy.sprite=287
        enemy.col=20
        enemy.speed=15
        enemy.respawns=0
        for l=0 to rnd_range(2,6) step 2
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
            enemy.items(l+1)=96
            enemy.itemch(l+1)=15
        next
    endif
    
    
    if a=41 then 'Powerful space standard critter
        enemy.ti_no=1001+g
        g=rnd_range(1,5)
        enemy.tile=ch(g)
        enemy.sdesc=species(g)
        enemy.sprite=261+g
        enemy.range=1.5
        enemy.weapon=rnd_range(1,4)-2
        if enemy.weapon<0 then enemy.weapon=0
        for l=1 to 6+ad(g)
            enemy.hp=enemy.hp+rnd_range(3,6)
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
        enemy.speed=(rnd_range(1,5)+rnd_range(1,5)+rnd_range(0,enemy.weapon))/10
        
        enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        
        enemy.atcost=rnd_range(6,8)
        if enemy.speed>19 then enemy.speed=19
        if rnd_range(1,100)<(planets(map).atmos-1)*3/planets(map).grav then 
            enemy.movetype=mt_fly
            g=1
            enemy=randomcritterdescription(enemy,g,enemy.hp,enemy.movetype,enemy.pumod,enemy.diet,0,planets(map).depth)        
        else
            if rnd_range(1,100)<33 then
            select case planets(map).temp
                   case is>200
                    enemy.ti_no=1051
                    enemy.armor=2
                    enemy.col=12
                    enemy.tile=asc("W")
                    enemy.sprite=272
                    enemy.track=45
                    enemy.speed=12
                    enemy.sdesc="fireworm"
                    enemy.range=2.5
                    enemy.swhat="spits molten rock"
                    enemy.ldesc="A huge worm. It's biochemistry silicon based, wich allows it to live in extremely high heat. It's body is made of rock, and molten sulfur is used as blood."
                   case is<-150
                    enemy.ti_no=1052
                
                    enemy.armor=2
                    enemy.col=11
                    enemy.tile=asc("W")
                    enemy.sprite=273
                    enemy.track=26
                    enemy.speed=10
                    enemy.sdesc="ammoniaworm"
                    enemy.ldesc="A huge worm. It's biochemistry is ammonia based, allowing it to survive in very low temperatures. It slithers leaving an ammonia track."
                   
                   case else
                    enemy.ti_no=1053
                
                    enemy.armor=2
                    enemy.col=4
                    enemy.tile=asc("W")
                    enemy.sprite=274
                    enemy.track=4
                    enemy.speed=6
                    enemy.sdesc="earthworm"
                    enemy.ldesc="A huge worm. It has no eyes and a huge maw. Feelers run alongside its body, with wich it touches the ground sensing the vibrations its prey causes." 
                end select
                enemy.biomod=2.2
                for l=0 to rnd_range(2,5)
                    enemy.items(l)=99
                    enemy.itemch(l)=33
                next
            endif
            If planets(map).depth>0 then
                enemy.ti_no=1054
                enemy.movetype=mt_dig
                enemy.track=4
                enemy.weapon=5
                enemy.speed=4
                enemy.armor=2
                enemy.col=7
                enemy.tile=asc("W")
                enemy.track=4
                enemy.sdesc="stoneworm"
                enemy.sprite=275
                enemy.ldesc="This creature slowly digs through the stone, gnawing at it with metal teeth. It's thick skin is embedded with rocks and stones for protection."
            endif
        endif
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.lang=-1
        enemy.sdesc="mutated "&enemy.sdesc
        enemy.ldesc="mutated "&enemy.ldesc
        enemy.disease=16
        if enemy.tile=22 then enemy.movetype=mt_climb 'Spinnen klettern
        enemy.col=6
    endif
    
    if a=42 then 'Intelligent Cephalopods  
        enemy.ti_no=1055     
        enemy.sight=3
        enemy.sdesc="amphibious cephalopod"
        enemy.ldesc="A cephalopod with 9 arms, 3 end in big suction cups, with serrated edges that also serve as fingers. 3 others end in beaked mouths and 3 end in fins. It's saucer shaped body has 9 small eyes, spaced evenly along the rim. It's body is about 0.5m wide and its tentacles are 1m long."  
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=5
        enemy.atcost=rnd_range(6,8)
        enemy.aggr=1
        enemy.pumod=60
        enemy.range=rnd_range(1,4)+0.5
        enemy.hp=rnd_range(2,5)+rnd_range(2,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,1)
        enemy.tile=asc("Q")
        enemy.movetype=mt_hover
        enemy.sprite=277
        enemy.cmmod=15
        enemy.col=rnd_range(180,185)
        enemy.speed=14
        enemy.lang=-19
        enemy.respawns=1
    endif
    
    if a=43 then 'Mushrroompickers
        enemy.ti_no=1056     
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 0.5m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
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
        enemy.speed=8
        enemy.lang=-20
        enemy.respawns=1
    endif
    
    if a=44 then 'Cavemonster
        enemy.ti_no=1057     
        enemy.sight=3
        enemy.sdesc="small humanoid"
        enemy.ldesc="a 1m high humaoid, with long arms and legs, and green, scaly skin. It's very light and thin, and its fingers end in sucking cups. It has horns and a spiked tail."
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=3
        enemy.biomod=1.2
        enemy.cmmod=6
        enemy.atcost=rnd_range(6,8)
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
        enemy.speed=14
        enemy.respawns=0
    endif
    
    if a=45 then 'Scentient Tree
        enemy.ti_no=1058     
        enemy.sight=3
        enemy.sdesc="tree"
        enemy.ldesc="a small tree or big bush with a cone shaped trunk, and a wide surface root system. It has several small openings and a few flexible branches near the top that end in big blue globes. It is obviously capable of moving slowly!"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.intel=4
        enemy.atcost=rnd_range(1,4)
        enemy.aggr=1
        enemy.lang=-21
        enemy.pumod=-60
        enemy.range=1.5
        enemy.hp=10+rnd_range(1,5)+rnd_range(1,5)
        enemy.hpmax=enemy.hp
        enemy.armor=rnd_range(0,3)
        enemy.tile=asc("T")
        enemy.sprite=277
        enemy.cmmod=6
        enemy.col=2
        enemy.speed=4
        enemy.respawns=1
        enemy.biomod=4
        enemy.faction=9
    endif
        
    if a=46 then 'Defense bots
        enemy.stunres=10
        enemy.ti_no=1059     
        enemy.faction=5
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
        enemy.atcost=rnd_range(6,8)
        for l=1 to 5+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=50+enemy.hp+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.faction=5
        
        if rnd_range(1,100)<15 then enemy.teleportrange=rnd_range(3,6)
    endif
    
    if a=47 then 'Sgt Pinback
        enemy.ti_no=1060     
        enemy.made=47
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.hp=0
        enemy.tile=64
        enemy.sprite=287
        enemy.col=53
        enemy.respawns=0
        enemy.sdesc="crewmember"
        enemy.ldesc="crewmember, on his uniform is a name tag identifying him as 'Sgt. Pinback'"
    endif
    
    if a=48 then 'Ted ROfes
        'enemy.ti_no=1061
        enemy.ti_no=1511
        enemy.biomod=0
        enemy.sdesc="Ted Rofes, the shipsdoctor. "
        enemy.ldesc="Ted Rofes, the shipsdoctor."
        enemy.lang=22
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=10
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.speed=10
        enemy.col=9
        enemy.aggr=1
        enemy.faction=9
        enemy.respawns=0
    endif
    
    if a=49 then 'Pirate Ship Crew
        enemy.ti_no=1062
        enemy.faction=2
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=rnd_range(0,5)+5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.speed=(rnd_range(0,4)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<=5 then enemy.speed=6
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.allied=2
        enemy.intel=5
        enemy.enemy=2
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.col=186
        enemy.sdesc="pirate shipcrew"
        enemy.armor=1
        enemy.weapon=enemy.weapon+1
        enemy.speed=10
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.respawns=0
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
        enemy.faction=2
    endif
    
    if a=50 then 'Pirate elite band
        enemy.ti_no=1063
        enemy.faction=2
        enemy.atcost=rnd_range(7,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=rnd_range(10,15)+15+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.allied=2
        enemy.enemy=2
        enemy.respawns=0
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        enemy.biomod=0
        enemy.col=rnd_range(17,19)
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=276
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.col=192
        enemy.sdesc="pirate band"
        enemy.ldesc="a squad of pirates, armed to the teeth and ready to fight"        
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=6
        enemy.lang=9
        enemy.col=108  
        enemy.sdesc="pirate elite troop"
        enemy.armor=2
        enemy.weapon=enemy.weapon+2
        enemy.hp=enemy.hp+rnd_range(1,6)
        enemy.swhat="shoot plasmarifles "
        enemy.scol=20
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.atcost=rnd_range(5,7)
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next           
        
        if faction(0).war(2)>=100 then 
            enemy.aggr=0
        else
            enemy.aggr=1
        endif
    endif
    
    if a=51 then 'Defensebot
        enemy.stunres=10
        enemy.ti_no=1064
        enemy.faction=5
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
            
        for l=1 to 6
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=18
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next  
        enemy.speed=18
        enemy.col=11
        enemy.sdesc="fast robot"
        enemy.sight=enemy.sight+3
        enemy.armor=0
        enemy.sprite=281
        enemy.atcost=rnd_range(4,6)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
        
        if rnd_range(1,100)<10 then enemy.teleportrange=rnd_range(5,8)
    endif
    
    if a=52 then 'Defensebot
        enemy.stunres=10
        enemy.ti_no=1065
        enemy.faction=5
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
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.biomod=0
        enemy.weapon=rnd_range(1,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=18
        enemy.tile=asc("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=280
        enemy.atcost=rnd_range(6,8)
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=33
        next  
        enemy.speed=14
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.armor=5
        enemy.sprite=282
        enemy.atcost=rnd_range(8,10)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
        
        if rnd_range(1,100)<10 then enemy.teleportrange=rnd_range(3,6)
    endif
        
    if a=53 then 'Fast Bot
        enemy.stunres=10
        enemy.ti_no=1066
        enemy.faction=5
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
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.speed=16
        enemy.col=11
        enemy.sdesc="fast robot"
        enemy.sight=enemy.sight+3
        enemy.armor=0
        enemy.sprite=280
        enemy.atcost=rnd_range(3,4)
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
        
        if rnd_range(1,100)<15 then enemy.teleportrange=rnd_range(3,6)
    endif
    
    if a=54 then 'Defense Bot
        enemy.stunres=10
        enemy.ti_no=1067
        enemy.faction=5
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
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.speed=-1
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.range=enemy.sight
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        for l=0 to rnd_range(5,8)
            enemy.items(l)=94
            enemy.itemch(l)=33
        next
        enemy.speed=12
        enemy.col=20
        enemy.sdesc="armored robot"
        enemy.sight=enemy.sight+3
        enemy.armor=5
        enemy.weapon=enemy.weapon+1
        enemy.range=1.5
        enemy.atcost=rnd_range(7,9)
        enemy.sprite=282
        enemy.items(0)=96
        enemy.itemch(0)=33
        enemy.faction=5
        
        if rnd_range(1,100)<15 then enemy.teleportrange=rnd_range(3,6)
    endif
    
    if a=55 then 'Living Energy
        enemy.stunres=10
        enemy.ti_no=1068
        enemy.faction=5
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
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,6)
        next
        enemy.hp=15+enemy.hp+planets(a).depth
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.hp=rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.atcost=2
        enemy.sdesc="living energy"
        enemy.ldesc="a pulsating shimmer in the air, it moves through the metal walls as if they were not there, only getting slightly more solid before it fires."
        enemy.weapon=rnd_range(4,6)-3
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=enemy.weapon-1
        if enemy.range<1.5 then enemy.range=1.5
        enemy.tile=asc("Z")
        enemy.col=rnd_range(192,197)
        enemy.speed=18
        enemy.movetype=mt_ethereal
        if rnd_range(1,100)<25 then enemy.teleportrange=rnd_range(3,6)+3
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif
    
    if a=56 then 'Bladebot
        enemy.stunres=10
        enemy.ti_no=1069
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="defense robot"
        enemy.ldesc="a metal ball, about 1m in diameter, sensor array to the right, weapons array to the left. It's locomotion unit seems to be damaged, it lies on the ground, surrounded by pieces of primitve art, now and then rising a few centimeters into the air, and slamming back into the ground."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        enemy.armor=6
        enemy.lang=-3
        enemy.sight=5
        enemy.atcost=rnd_range(6,8)
        for l=1 to 3+planets(a).depth
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.hp=150+enemy.hp+planets(a).depth
        
        enemy.weapon=rnd_range(1,6)
        if enemy.weapon<0 then enemy.weapon=0
        enemy.range=4
        if enemy.range<1.5 then enemy.range=1.5
        enemy.hpmax=enemy.hp
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=14
        enemy.tile=ASC("R")
        enemy.col=137
        enemy.sight=rnd_range(1,3)+rnd_range(1,3)-1
        enemy.sprite=278
        enemy.hp=30+rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.sdesc="bladebot"
        enemy.weapon=10
        enemy.atcost=12
        enemy.tile=ASC("R")
        enemy.armor=8
        enemy.speed=12
        enemy.col=219
        enemy.ldesc="A massive ball of metal on tracks, 5 arms end in massive blades, so thin they are almost invisible."
        enemy.range=1.5
        enemy.sight=4
        if rnd_range(1,100)<10 then enemy.teleportrange=rnd_range(2,4)
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif


    If a=57 then 'Armed Citizen
        enemy.ti_no=1513
        enemy.faction=8
        enemy.sight=5
        enemy.sdesc="armed citizen"
        enemy.ldesc="a gruff human pioneer hardened by living away from civilization"
        enemy.lang=18
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=6
        enemy.aggr=1
        enemy.intel=5
        enemy.allied=2
        enemy.enemy=1
        enemy.pumod=6
        enemy.atcost=rnd_range(6,8)
        
        enemy.movetype=rnd_range(0,2)
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
        enemy.tile=asc("H")
        enemy.sprite=287
        enemy.col=20
        enemy.speed=10
        enemy.respawns=0
        enemy.faction=1
    endif
    
    
    if a=58 then 'Redhat
        enemy.ti_no=1071
        enemy.atcost=rnd_range(6,8)
        enemy.sdesc="armed reptile"
        enemy.ldesc="A 3m tall reptile with yellow scales. It has 3 tentacles as arms, and 4 legs. It wears clothes and a red helmet, and wields an obviously human made Gauss gun!"
        enemy.lang=7
        enemy.sprite=291
        enemy.faction=9
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.aggr=1
        enemy.intel=5
        enemy.biomod=1
        enemy.cmmod=5
        enemy.sight=3
        enemy.range=3.5
        enemy.weapon=2
        enemy.swhat="shoots its gaussgun!"
        enemy.scol=11
        for l=1 to 3
            enemy.hp=enemy.hp+rnd_range(1,3)
        next
        enemy.hpmax=enemy.hp
        enemy.speed=10
        enemy.aggr=1
        enemy.tile=Asc("L")
        enemy.col=144
        enemy.items(0)=7
        enemy.itemch(0)=66
    endif  
        
    if a=59 then 'Crystal Hybrid
        enemy.stunres=9
        enemy.ti_no=1072
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
        enemy.intel=5
        enemy.armor=7
        enemy.hasoxy=1
        enemy.sprite=180
        enemy.hp=24+rnd_range(2,15)+rnd_range(2,15)
        enemy.hpmax=enemy.hp
        enemy.col=239
        enemy.aggr=0
        enemy.speed=7
        enemy.tile=asc("H")
        enemy.sdesc="crystal hybrid"
        enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is covered in the torn remains of a starship uniform. The half covered head looks like a grotesque helmet."
        enemy.armor=3
        enemy.atcost=7
        enemy.speed=18
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
            enemy.items(0)=7
            enemy.itemch(0)=66
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
            enemy.items(0)=9
            enemy.itemch(0)=33
        endif
        enemy.faction=5
    endif
    
    if a=60 then 'Floater
        enemy.ti_no=1073
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=10
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
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
    
    if a=61 then 'floauter
        enemy.ti_no=1074
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=10
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
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

    if a=62 then 'Cloudshark
        enemy.ti_no=1075
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=16
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1            
        enemy.sdesc="cloudshark"
        enemy.ldesc="A large tube shaped creature with wide maws and sharp teeth!"
        enemy.hp=rnd_range(1,20)+rnd_range(1,20)+10
        enemy.armor=1
        enemy.weapon=1
        enemy.range=1.5
        enemy.tile=asc("S")
        enemy.col=205
    endif

    if a=63 then 'Living Mushroom
        enemy.ti_no=1076
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.speed=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.hp=rnd_range(2,4)
        enemy.range=1.5
        enemy.weapon=1
        enemy.tile=asc("9")
        enemy.sdesc="floating mushroom"
        enemy.ldesc="a 30 cm big ball with long tentacles that connect it to the platform. It has a rim around the middle with 5 openings through wich it shoots hot gas jets to propell and defend itself."
        enemy.breedson=18
        enemy.atcost=11
        enemy.col=200
    endif

    if a=64 then 'Hydrogen Worm
        enemy.stunres=3
        enemy.ti_no=1077
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)
        enemy.atcost=rnd_range(6,8)
        enemy.movetype=mt_fly2
        enemy.aggr=0
        enemy.sight=4
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.biomod=1
        enemy.hasoxy=1
        enemy.sdesc="hydrogen worm"
        enemy.ldesc="A giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
        enemy.hp=rnd_range(30,100)+rnd_range(30,100)+20
        enemy.armor=4
        enemy.weapon=4
        enemy.range=1.5
        enemy.tile=asc("W")
        enemy.col=121
        enemy.speed=8
    endif
    
    if a=65 then 'Crystal Hybrid
        enemy.stunres=9
        enemy.ti_no=1078
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
        enemy.weapon=2
        enemy.atcost=11
        enemy.armor=3
        enemy.hasoxy=1
        enemy.sprite=180
        enemy.hpmax=14+rnd_range(2,5)+rnd_range(2,5)
        enemy.col=240
        enemy.aggr=0
        enemy.speed=16
        enemy.tile=asc("H")
        enemy.sdesc="crystal hybrid"
        enemy.ldesc="this once was a human being. It's arms, legs and head are encased in crystal tubes, fused to bare flesh. The torso is still bare. You can see the torn uniform of a scout ship security team member."
        enemy.hpmax=rnd_range(2,5)+rnd_range(2,5)
        enemy.armor=3
        enemy.atcost=7
        enemy.speed=18
        enemy.range=rnd_range(1,4)+0.5
        if enemy.range<=2.5 then
            enemy.scol=11
            enemy.swhat="shoots gauss guns"
            enemy.items(0)=7
            enemy.itemch(0)=33
        else
            enemy.scol=12
            enemy.swhat="shoots lasers"
            enemy.items(0)=9
            enemy.itemch(0)=33
        endif
        enemy.hp=enemy.hpmax
        enemy.faction=5
    endif
    
    '66,67,68,69: Tomb critters
    
    
    if a=71 then
        enemy.ti_no=1079
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Smith Heavy Industries security team"
        enemy.ldesc="a squad of Smith Heavy Industries Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=72 then
        enemy.ti_no=1080
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.intel=5
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Smith Heavy Industry security team"
        enemy.ldesc="a squad of Smith Heavy Industry Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=26
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=73 then 'Citizen
        enemy.ti_no=1509
        enemy.faction=8
        enemy.intel=-1 'Should make them not ally with the guards
        enemy.sdesc="worker"
        enemy.ldesc="a sullen looking very thin worker"
        enemy.lang=28
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=6
        enemy.intel=5
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=74 then
        enemy.ti_no=1082
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.intel=5
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Triax Traders security team"
        enemy.ldesc="a squad of Triax Traders security troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=75 then
        enemy.ti_no=1083
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.intel=5
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Triax Traders security team"
        enemy.ldesc="a squad of Triax Traders Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=76 then
        enemy.ti_no=1084
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.intel=5
        enemy.respawns=0
        
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Omega bioengineering security team"
        enemy.ldesc="a squad of Omega bioengineering security troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=25
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    
    if a=77 then
        enemy.ti_no=1085
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.intel=5
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite Omega bioengineering security team"
        enemy.ldesc="a squad of Omega bioengineering Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=78 then 'Citizen
        if rnd_range(1,50)<50 then
            enemy.ti_no=1086
        else
            enemy.ti_no=1510
        endif
        
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=29
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.intel=5
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=79 then
        enemy.ti_no=1087
        enemy.aggr=0
        enemy.hp=rnd_range(1,10)+20
        enemy.hpmax=enemy.hp
        enemy.speed=5
        enemy.atcost=8
        enemy.weapon=3
        enemy.specialattack=SA_corrodes
        enemy.armor=0
        enemy.sight=2
        enemy.range=1.5
        enemy.biomod=5
        enemy.hasoxy=1
        enemy.tile=asc("j")
        enemy.col=208
        enemy.faction=9
        enemy.sdesc="blob"
        enemy.ldesc="A huge pale amorphous mass wobbles towards you trying to engulf you. It's skin is covered in a highly corrosive substance"
    endif
    
    '80 taken
    
    if a=81 then
        enemy=civ(0).spec
        enemy.made=a
        enemy.diet=4
        enemy.hasoxy=1
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=rnd_range(0,2)
    endif
    
    if a=82 then
        enemy=civ(1).spec
        enemy.made=a
        enemy.diet=4
        enemy.hasoxy=1
        enemy.sight=35
        enemy.pumod=60
        enemy.movetype=rnd_range(0,2)
    endif
    
    
    if a=83 then  'Burrower
        enemy.ti_no=1088
        enemy.sdesc="Burrower"
        enemy.ldesc="A huge burrowing insect, with a thick carapace and huge mandibles. It hides in loose soil to suprise its prey"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.sight=4
        enemy.range=1.5
        enemy.weapon=1
        enemy.armor=1
        enemy.hp=rnd_range(3,5)
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=14
        enemy.aggr=0
        enemy.lang=-30
        enemy.tile=Asc("I")
        enemy.sprite=285
        enemy.col=162
        enemy.invis=2
    endif
    
    if a=84 then  'Burrower Mom
        enemy.ti_no=1089
        enemy.sdesc="Huge Burrower"
        enemy.ldesc="A huge burrowing insect, with a thick carapace and huge mandibles. It hides in loose soil to suprise its prey"
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.swhat="spits acid"
        enemy.scol=12
        enemy.sight=4
        enemy.range=2
        enemy.weapon=2
        enemy.armor=2
        enemy.hp=rnd_range(1,5)+8
        enemy.atcost=rnd_range(6,8)
        enemy.hpmax=enemy.hp
        enemy.biomod=1
        enemy.speed=14
        enemy.aggr=0
        enemy.tile=Asc("I")
        enemy.sprite=285
        enemy.items(1)=86
        enemy.itemch(1)=110
        enemy.col=204
        enemy.invis=2
        enemy.lang=-31
    endif
    
    if a=85 then 'Citizen
        enemy.faction=8
        enemy.ti_no=-1
        enemy.sdesc="citizen"
        enemy.ldesc="a friendly human pioneer"
        enemy.lang=23
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=4
        enemy.hp=4
        enemy.col=23
        enemy.aggr=1
        enemy.faction=1
    endif
    
    
    if a=86 then
        enemy.ti_no=1091
        enemy.faction=1
        enemy.atcost=rnd_range(6,9)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,4)
        enemy.range=0.5+enemy.weapon
        enemy.hp=5+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.intel=5
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="eridiani exploration security team"
        enemy.ldesc="a squad of Eridiani Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=33
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=1
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    if a=87 then
        enemy.ti_no=1092
        enemy.faction=1
        enemy.atcost=rnd_range(5,6)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(2,5)
        enemy.range=0.5+enemy.weapon
        enemy.hp=10+enemy.weapon
        enemy.sight=rnd_range(3,6)
        enemy.aggr=0
        enemy.respawns=0
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=10
        enemy.scol=10
        enemy.intel=5
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Elite eridiani exploration security team"
        enemy.ldesc="a squad of Elite Eridiani Security Troops, armed to the teeth and ready to fight"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=66
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=3
        enemy.lang=24
        enemy.aggr=1
        enemy.armor=2
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
    endif
    
    '88=Station inhabitant
    '89=
    
    if a=90 then
        enemy.ti_no=1094
        enemy.stunres=10
        enemy.biomod=0
        enemy.sdesc="Repair Bot"
        enemy.ldesc="a 30 cm metal sphere. Several arms extrude from it. They end in multipurpose tools. It uses those for movement as well as manipulation."
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.cmmod=1
        enemy.speed=18
        enemy.pumod=8
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=2
        enemy.hasoxy=1
        enemy.tile=Asc("R")
        enemy.sprite=286
        enemy.hpmax=24
        enemy.hp=24
        enemy.weapon=1
        if rnd_range(1,100)<10 then enemy.teleportrange=rnd_range(3,6)
        enemy.col=23
        enemy.aggr=1
        enemy.faction=5
    endif
    
    if a=91 then 'Bladebot
        enemy.stunres=10
        enemy.ti_no=1069
        enemy.faction=5
        enemy.hasoxy=1
        enemy.sdesc="battle robot"
        enemy.ldesc="a metal ball, about 2m in diameter, sensor array to the right, weapons array to the left."     
        enemy.dhurt="damaged"
        enemy.dkill="destroyed"
        enemy.swhat="shoots a disintegrator beam "
        enemy.scol=12
        enemy.respawns=0
        if rnd_range(1,100)<10 then enemy.teleportrange=rnd_range(2,4)
        enemy.armor=16
        enemy.lang=-3
        enemy.sight=9
        enemy.atcost=4
        enemy.range=3
        enemy.weapon=1
        enemy.biomod=0
        enemy.aggr=0
        enemy.speed=3
        enemy.tile=ASC("R")
        enemy.col=8
        enemy.sprite=278
        enemy.hp=230+rnd_range(1,5)+rnd_range(1,5)+rnd_range(1,3)+planets(map).depth
        for l=1 to 5
            enemy.hp=enemy.hp+rnd_range(1,5)
        next
        enemy.atcost=9
        enemy.tile=ASC("R")
        enemy.armor=8
        enemy.hpmax=enemy.hp
        enemy.faction=5
    endif

    if a=92 then
        enemy.ti_no=1095
        enemy.tile=asc("q")
        enemy.col=9
        enemy.sdesc="large squid"
        enemy.ldesc="A large squid-like creature with a 3m long body, 3 3m long tentacles and 3 shorter tentacles, only about 30cm long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations."
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.hp=rnd_range(1,5)+5
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=12
        enemy.atcost=5
        enemy.weapon=1
        enemy.range=2
        enemy.sight=2
        enemy.faction=9
        enemy.biomod=1
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=93 then
        enemy.ti_no=1096
        enemy.tile=asc("Q")
        enemy.col=9
        enemy.sdesc="Huge squid"
        enemy.ldesc="A large squid-like creature with a 5m long body, 3 5m long tentacles and 3 shorter tentacles, only about 30cm long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations. It's body is covered in very thick scales."
        enemy.hp=rnd_range(1,5)+25
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=11
        enemy.atcost=5
        enemy.weapon=1
        enemy.armor=3
        enemy.range=2
        enemy.sight=4
        enemy.faction=9
        enemy.biomod=1.5
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=94 then
        enemy.ti_no=1097
        enemy.tile=asc("Q")
        enemy.col=119
        enemy.sdesc="Giant squid"
        enemy.ldesc="A large squid-like creature with a 7m long body, 3 7m long tentacles and 3 shorter tentacles, only about 1m long. They don't seem to have any eyes, but the short tentacles are covered in fine hair enabling them to sense vibrations. It's body is covered in very thick scales. The tips of its tentacles are glowing with static electricity."
        enemy.hp=rnd_range(1,5)+55
        enemy.hpmax=enemy.hp
        enemy.aggr=0
        enemy.speed=10
        enemy.atcost=5
        enemy.weapon=1
        enemy.armor=5
        enemy.range=3.4
        enemy.sight=5
        enemy.scol=101
        enemy.swhat="shoots lightning"
        enemy.faction=9
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=95 then
        enemy.ti_no=1098
        enemy.tile=asc("F")
        enemy.col=14
        enemy.sdesc="swarm of fish"
        enemy.ldesc="A large swarm of different kind of fish, forming some form of symbiotic relationship."
        enemy.hp=30
        enemy.hpmax=enemy.hp
        enemy.faction=10
        enemy.aggr=2
        enemy.atcost=9
        enemy.speed=14
        enemy.sight=3
        enemy.biomod=1
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_hover
        enemy.hasoxy=1
    endif
    
    if a=96 then
        enemy.ti_no=1099
        enemy.stunres=9
        enemy.tile=asc("~")
        enemy.col=15
        enemy.sdesc="dense cloud"
        enemy.ldesc="This cloud is obviously a lifeform capable of intelligent action. It is actually composed of tiny animals, similiar to a plankton swarm.  The biodata from this unique lifeform will be worth a lot."
        enemy.hp=5
        enemy.hpmax=enemy.hp
        
        enemy.atcost=9
        enemy.weapon=1
        enemy.armor=0
        enemy.range=1.4
        enemy.sight=2
        enemy.intel=rnd_range(1,8)
        
        enemy.faction=10
        enemy.aggr=1
        enemy.speed=8
        enemy.sight=3
        enemy.biomod=2
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        enemy.movetype=mt_fly
    endif
    
    
    if a=97 then
        enemy.ti_no=1099
        enemy.stunres=9
        enemy.tile=asc("~")
        enemy.col=7
        enemy.sdesc="huge dense cloud"
        enemy.ldesc="This cloud is obviously a lifeform capable of intelligent action. It is actually composed of tiny animals, similiar to a plankton swarm. The biodata from this unique lifeform will be worth a lot."
        enemy.hp=15+rnd_range(1,10)
        enemy.hpmax=enemy.hp
        enemy.intel=rnd_range(1,8)
        enemy.atcost=9
        enemy.weapon=1
        enemy.armor=0
        enemy.range=2.4
        enemy.sight=3
        
        enemy.swhat="shoots lightning"
        enemy.scol=101
        
        enemy.faction=10
        enemy.aggr=1
        enemy.speed=7
        enemy.sight=3
        enemy.biomod=5
        enemy.dhurt="hurt"
        enemy.dkill="killed"
        
        enemy.movetype=mt_fly
    endif
    
    if a=98 then 'Citizen
        enemy.faction=8
        enemy.ti_no=1515
        enemy.sdesc="prospector"
        enemy.ldesc="a rich prospector"
        enemy.lang=35
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.armor=7
        enemy.speed=10
        enemy.pumod=5
        enemy.sight=4
        enemy.range=3.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=7
        enemy.hp=7
        enemy.swhat="shoots a disintegrator"
        enemy.scol=12
        
        enemy.movetype=rnd_range(0,2)
        enemy.col=23
        enemy.aggr=1
        enemy.items(1)=97
        enemy.itemch(1)=115
        enemy.items(2)=98
        enemy.itemch(2)=115
    endif
    
    if a=99 then 'Citizen
        enemy.ti_no=1086
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=36
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(8,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=39
        enemy.aggr=1
    endif
    
    
    if a=100 then 'Citizen
        enemy.ti_no=1086
        enemy.faction=8
        enemy.intel=5 'Should make them not ally with the guards
        enemy.sdesc="scientist"
        enemy.ldesc="a busy looking scientist"
        enemy.lang=37
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=8
        enemy.pumod=5
        enemy.sight=4
        enemy.range=1.5
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=3
        enemy.hp=3
        enemy.col=39
        enemy.aggr=1
    endif
    
    if a=101 then
        enemy.sdesc="Tribble"
        enemy.ldesc="A most curious creature, it's trilling seems to have a tranquilizing effect on the human nervous system." 
        enemy.ti_no=2121
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=12
        enemy.tile=asc("*")
        enemy.col=7
        enemy.aggr=1
        enemy.speed=-1
        enemy.breedson=33
        enemy.biomod=.1
        enemy.hp=1
        enemy.hpmax=1
        enemy.hasoxy=0
    endif
    
    if a=102 then 
        enemy.sdesc="Icetroll"
        enemy.ldesc="This creature hibernates during the cold nights on this planet and reawakes in the morning. In it's hibernating state it is virtually indistinguishable from a large block of ice. It's active state is mobile and sluglike. It seems to be a scavenger."
        enemy.hpmax=rnd_range(1,6)+10
        enemy.hp=enemy.hpmax
        enemy.biomod=3
        enemy.hasoxy=1        
        enemy.tile=176
        enemy.ti_no=258
        enemy.col=11    
        enemy.weapon=6
        enemy.armor=2
        enemy.aggr=0
        enemy.speed=4
        enemy.atcost=11
        enemy.range=1.5
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        for l=1 to rnd_range(2,5)
            enemy.items(l)=96
            enemy.itemch(l)=66
        next       
        
    endif
    
    if a=103 then
        enemy.ti_no=1000
        enemy.faction=8
        enemy.allied=0
        enemy.atcost=rnd_range(7,10)
        enemy.hasoxy=1
        enemy.weapon=rnd_range(1,3)
        enemy.range=0.5+enemy.weapon
        enemy.hp=2+enemy.weapon
        enemy.sight=rnd_range(2,5)
        enemy.aggr=1
        enemy.respawns=0
        if _debug>0 then enemy.teleportrange=10
        
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        enemy.movetype=rnd_range(0,2)
        'Looks
        enemy.biomod=0
        enemy.col=2
        enemy.scol=10
        enemy.tile=asc("H")
        enemy.sprite=2
        enemy.dhurt="hurt"
        enemy.dkill="dies" 
        enemy.swhat="shoot laser guns "
        enemy.sdesc="Station security team"
        enemy.ldesc="a station security team, keeping a watchful eye on visitors"        
    
        for l=0 to rnd_range(1,2)
            enemy.items(l)=-RI_weaponsarmor
            enemy.itemch(l)=22
        next
        enemy.hpmax=enemy.hp
        enemy.cmmod=4
        enemy.lang=38
        enemy.aggr=1
        enemy.armor=1
        enemy.diet=5'Critters who are fighting
        enemy.speed=(rnd_range(0,14)+rnd_range(0,13)+rnd_range(0,enemy.weapon))
        if enemy.speed<11 then enemy.speed=11
        if enemy.speed>14 then enemy.speed=14
        
    endif
    
    if a=104 then
        enemy.ti_no=1001
        enemy.sdesc="squatter"
        enemy.ldesc="a poor fellow"
        enemy.lang=40
        enemy.dhurt="hurt"
        enemy.dkill="dies"
        enemy.cmmod=7
        enemy.speed=6
        enemy.pumod=1
        enemy.sight=4
        enemy.intel=5
        enemy.range=1.5
        enemy.allied=2
        enemy.enemy=1
        enemy.atcost=rnd_range(6,12)
        enemy.hasoxy=1
        enemy.tile=Asc("H")
        enemy.sprite=286
        enemy.hpmax=1
        enemy.hp=1
        enemy.col=23
        enemy.aggr=1
        enemy.faction=8
    
    endif
    
    if planets(map).atmos=1 and planets(map).depth=0 then enemy.hasoxy=1
    
    if easy_fights=1 then
        enemy.armor=0
        enemy.weapon=0
        enemy.hp=1
    endif
    
    
    if configflag(con_easy)=0 and enemy.hp>0 then
        easy=player.turn/50000'!
        if easy<.5 then easy=.5
        if easy>1 then easy=1
        enemy.hp=enemy.hp*easy
        if enemy.hp<1 then enemy.hp=1
        enemy.hpmax=enemy.hp
    endif
    
    
    if enemy.hp>0 then enemy.hpmax=enemy.hp
    
    return enemy
end function
