function make_drifter(d as _driftingship, bg as short=0,broken as short=0,f2 as short=0) as short
    dim as short a,m,roll,x,y,f,ti,xs,ys,x2,y2,addweap,addcarg,ff,fc,wc,i,j,l
    dim as byte retirementshop,antiques,oneway,lockermap(60,20)
    dim as short randomshop(14),lastrandomshop,shoptile
    dim s as _ship
    dim pods(6,5,1) as short
    dim as _cords p,p2,bgtiles
    dim crates(254) as _cords
    dim from as _cords
    dim dest as _cords
    dim lastcrate as short
    randomshop(1)=113 'Giftshop
    randomshop(2)=270 'Retirement
    randomshop(3)=261 'Hospital
    randomshop(4)=294 'Antiques
    randomshop(5)=109 'Bot-Bin
    randomshop(6)=98 'Black Market
    randomshop(7)=286 'Customize item
    randomshop(8)=110 'Zoo
    randomshop(9)=112 'Used ships
    randomshop(10)=262 'mudds
    randomshop(11)=262 'mudds
    randomshop(12)=262 'mudds
    randomshop(13)=262 'mudds
    randomshop(14)=262 'mudds
    lastrandomshop=14 '
    if _debug>0 then dprint "DS:"&d.s
    if _debug=18 then d.s=18
    
    if bg=0 then
        m=d.m
    else
        bgtiles=dominant_terrain(d.x,d.y,d.m)
        lastplanet+=1
        m=lastplanet
        from.x=d.x
        from.y=d.y
        from.m=d.m
        d.m=m
    endif
    d.g_tile.x=rnd_range(1,8)
    if d.g_tile.x>=5 then d.g_tile.x+=1
    d.g_tile.y=d.s+51
    if d.s=19 then d.g_tile.y=49
    if d.s=18 then d.g_tile.y=68
    if d.s=17 then d.g_tile.y=48 'Generation Ship
    if d.s=20 then d.g_tile.y=47 'Small station
    load_map(d.s,lastplanet) 
    planets(m).flags(1)=d.s
    d.start.x=d.x
    d.start.y=d.y
    f=freefile
    open "data/pods.dat" for binary as #f
    for a=0 to 1
        for y=0 to 5
            for x=0 to 6
                get #f,,pods(x,y,a)
            next
        next
    next
    close #f
    if f2>0 then 
        print #f2,"Getting hullspecs"&d.s
    endif
    s=gethullspecs(d.s,"data/ships.csv")
    if bg=0 then
        addweap=s.h_maxweaponslot*10
        addcarg=s.h_maxcargo*10
        for a=6 to 6+s.h_maxweaponslot
            if rnd_range(1,100)<66 then planets(m).flags(a)=rnd_range(1,6)
            if rnd_range(1,100)<16+addweap then planets(m).flags(a)=planets(m).flags(a)+rnd_range(0,4)
            if rnd_range(1,100)<25 then planets(m).flags(a)=-rnd_range(1,2)
            if planets(m).flags(a)=-1 then addcarg=addcarg+10
            if planets(m).flags(a)=-2 then s.h_maxcrew=s.h_maxcrew+3
        next
        for a=6 to 6+s.h_maxweaponslot
            if planets(m).flags(a)>0 and planets(m).flags(a)<=10 then
                planets(m).weapon(a-6)=make_weapon(planets(m).flags(a))
            endif
        next
    endif
    for x=0 to 60
        for y=0 to 20
            ti=abs(planetmap(x,y,m))
            if ti>=209 and ti<=214 then
                ti=ti-203
                if planets(m).flags(ti)<0 then
                    if y<10 then a=1
                    if y>9 then a=0
                    xs=x-3
                    if a=1 then
                        ys=y-5
                    else
                        ys=y
                    endif
                    if xs<0 then xs=0
                    if ys<0 then ys=0
                    if xs+6>60 then xs=54
                    if ys+5>20 then ys=15
                    for x2=xs to xs+6
                        for y2=ys to ys+5
                            if pods(x2-xs,y2-ys,a)<>-200 then planetmap(x2,y2,m)=pods(x2-xs,y2-ys,a)
                            if planets(m).flags(ti)=-1 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-223 
                            if planets(m).flags(ti)=-2 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-224
                            if planets(m).flags(ti)=-3 and x2<>xs+3 and planetmap(x2,y2,m)=-202 and rnd_range(1,100)<33 then planetmap(x2,y2,m)=-221
                        next
                    next
                endif
            endif
            if ti=202 then 'floor then
                fc=0
                wc=0
                for x2=x-1 to x+1
                    for y2=y-1 to y+1
                        if x2>=0 and x2<=60 and y2>=0 and y2<=20 then
                            if planetmap(x2,y2,m)=-202 then fc+=1
                            if planetmap(x2,y2,m)=-201 then wc+=1
                        endif
                    next
                next
                if fc>3 and wc>=3 and wc<>6 then lockermap(x,y)=1
                if fc=2 and wc=8 then lockermap(x,y)=1
                if fc=5 and wc=4 then lockermap(x,y)=0
            endif
            if ti=999 then
                planetmap(x,y,m)=-202
                if rnd_range(1,100)<66 then 'Random Shops
                    ti=rnd_range(1,lastrandomshop)
                    planetmap(x,y,m)=-randomshop(ti)
                    p.x=x
                    p.y=y
                    p.m=m
                    if randomshop(ti)=98 then add_shop(sh_blackmarket,p,-1)
                    if randomshop(ti)=262 then add_shop(sh_mudds,p,-1)
                    if randomshop(ti)=109 then add_shop(sh_bots,p,-1)
                    if randomshop(ti)=112 then add_shop(sh_usedships,p,-1)'Need both
                    if randomshop(ti)=112 then add_shop(sh_used,p,-1)
                    if randomshop(ti)=113 then add_shop(sh_giftshop,p,-1)
                    if randomshop(ti)=261 then add_shop(sh_sickbay,p,-1)
                    shoptile=randomshop(ti)
                    for i=1 to lastrandomshop
                        if randomshop(i)=shoptile then
                            randomshop(i)=randomshop(lastrandomshop)
                            lastrandomshop-=1
                        endif
                    next
                                    
                endif
            endif
        next
    next
    
    
    if d.s=18 and bg=0 then 'Drifting alien ship
        for i=1 to rnd_range(4,10)+rnd_range(4,10)            
            p=rnd_point
            select case rnd_range(1,9)
            case 1
                p.x=0
                a=6
                l=15
            case 2
                p.x=60
                a=4
                l=15
            case 3 to 6
                p.y=0
                a=rnd_range(1,3)
                l=5
            case 7 to 9
                p.y=20
                a=rnd_range(7,9)
                l=5
            end select
            for j=1 to rnd_range(1+l,5+l)
                p2=p
                if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                if rnd_range(1,100)<25 then
                    p=movepoint(p2,4)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,6)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,2)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                    p=movepoint(p2,8)
                    if (abs(planetmap(p.x,p.y,m))=201 or planetmap(p.x,p.y,m)) and rnd_range(1,100)<50 then planetmap(p.x,p.y,m)=-199
                    if abs(planetmap(p.x,p.y,m))<>203 and abs(planetmap(p.x,p.y,m))<>199 then planetmap(p.x,p.y,m)=-200
                endif
                if rnd_range(1,100)<50 then
                    p=movepoint(p2,a)
                else
                    p=movepoint(p2,5)
                endif
            next
        next
    endif
    
    
    for x=1 to 59
        for y=1 to 19
            ti=abs(planetmap(x,y,m))
            if ti=204 or ti=205 then
                lockermap(x-1,y)=0
                lockermap(x+1,y)=0
                lockermap(x,y+1)=0
                lockermap(x,y-1)=0
            endif    
            if ti=203 or tiles(ti).gives<>0 then
                for x2=x-1 to x+1
                    for y2=y-1 to y+1
                        lockermap(x2,y2)=0
                    next
                next
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            'if lockermap(x,y)=1 then planetmap(x,y,m)=-221
            if abs(planetmap(x,y,m))=204 and rnd_range(1,100)<66 then planetmap(x,y,m)=-205
            if abs(planetmap(x,y,m))=202 and rnd_range(1,100)<8 and (d.s<=19) then 
                if lockermap(x,y)=1 then 
                    planetmap(x,y,m)=-221
                    if rnd_range(1,100)<66 then planetmap(x,y,m)=-222
                    for a=0 to rnd_range(0,1)
                        if bg=0 then placeitem(rnd_item(RI_StrandedShip),x,y,m)
                    next
                    if lockermap(x-1,y)=0 then lockermap(x+1,y)=2
                    if lockermap(x+1,y)=0 then lockermap(x-1,y)=2
                    if lockermap(x,y-1)=0 then lockermap(x,y+1)=2
                    if lockermap(x,y+1)=0 then lockermap(x,y-1)=2
                endif
            endif
            if abs(planetmap(x,y,m))=223 then
                lastcrate=lastcrate+1
                crates(lastcrate).x=x
                crates(lastcrate).y=y
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=200 and bg<>0 then 
                if rnd_range(1,bgtiles.y+bgtiles.s)<=bgtiles.y then 'Y and s is the count for x and m type bg tiles
                    planetmap(x,y,m)=-bgtiles.x
                else
                    planetmap(x,y,m)=-bgtiles.m
                endif
            endif
        next
    next
    if bg=0 then
        if s.h_maxcargo>5 then s.h_maxcargo=5
        for a=1 to s.h_maxcargo
            if rnd_range(1,100)>25+addcarg then
                p=crates(rnd_range(1,lastcrate))
                planetmap(p.x,p.y,m)=-214-a
                planets(m).flags(10+a)=rnd_range(2,6)
            endif
        next
    endif
    for x=1 to 59
        for y=1 to 19
            if abs(planetmap(x,y,m))=201 then 
                if abs(planetmap(x-1,y,m))=200 or abs(planetmap(x+1,y,m))=200 or abs(planetmap(x,y+1,m))=200 or abs(planetmap(x,y-1,m))=200 then planetmap(x,y,m)=-243
                if abs(planetmap(x-1,y-1,m))=200 or abs(planetmap(x+1,y+1,m))=200 or abs(planetmap(x-1,y+1,m))=200 or abs(planetmap(x+1,y-1,m))=200 then planetmap(x,y,m)=-243
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if (x=0 or y=0 or x=60 or y=20) and abs(planetmap(x,y,m))=201 then planetmap(x,y,m)=-243
        next
    next
    
        
    planets(m).depth=1
    if bg=0 then
        
        roll=rnd_range(1,100)
        select case roll
        case 0 to 39
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(32,m)
            planets(m).mon_noamin(0)=s.h_maxcrew-1
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 40 to 50
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=makemonster(33,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            planets_flavortext(m)="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. You feel like defiling a grave."
        
        case 50 to 60
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=makemonster(31,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. No sound reaches you through the vacuum but you see red alert lights still flashing."
        case 60 to 70
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(34,m)
            planets(m).mon_noamin(0)=d.s+10
            planets(m).mon_noamax(0)=d.s+15
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        
        
        case 70 to 80
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(3,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 80 to 85
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(18,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=makemonster(18,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 85 to 90
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(19,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        
        case 90 to 95
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(35,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=makemonster(35,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        case 90 to 98
        
        
            planets(m).darkness=2
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(65,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(29,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets_flavortext(m)="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        
        
        case else
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(38,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=1
            
            planets(m).mon_template(1)=makemonster(47,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=1
            
            planets_flavortext(m)="As you enter this " &shiptypes(d.s)& " you hear a squeaking noise almost like a jiggle. You feel uneasy. Something is here, and it is not friendly." 
        end select

    else
        'On planets surface
        oneway=0
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=203 then 'Add portals from airlocks to planet surfaces
                    dest.x=x
                    dest.y=y
                    dest.m=lastplanet
                    addportal(dest,from,1,asc("@"),"airlock",11)
                endif
                if broken=1 and abs(planetmap(x,y,m))=220 then planetmap(x,y,m)=-202
            next
        next
        
        if d.s=18 then
            addportal(from,dest,1,asc("@"),"Abandoned "&shiptypes(17),11)
            portal(lastportal).ti_no=3009+17
        else
            addportal(from,dest,1,asc("@"),"Abandoned "&shiptypes(d.s),11)
            portal(lastportal).ti_no=3009+d.s
        endif
        addportal(dest,from,2,asc(" "),"",11)
        if d.s=18 and broken=0 then planetmap(30,20,m)=-220
        m=dest.m
        planets(m).atmos=planets(from.m).atmos
        planets(m).grav=planets(from.m).grav
    endif
    
    if planets(m).atmos>0 then planets(m).temp=20+rnd_range(1,20)/10
    
    planets(m).flags(0)=0
    planets(m).flags(1)=d.s
    planets(m).flags(2)=rnd_range(1,s.h_maxhull)
    planets(m).flags(3)=rnd_range(1,s.h_maxengine)
    planets(m).flags(4)=rnd_range(1,s.h_maxsensors)
    planets(m).flags(5)=rnd_range(0,s.h_maxshield)
    select case d.s
    case 20
        planets(m).wallset=rnd_range(7,9)
    case 18
        planets(m).wallset=rnd_range(10,11)
    case 17,19
        planets(m).wallset=rnd_range(12,13)
    case else
        planets(m).wallset=rnd_range(0,7)
    end select
    
    if _Debug=18 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,m)=abs(planetmap(x,y,m))
            next
        next
    endif
    
    if d.s=20 and _debug=2412 then
        planets(m).mon_template(3)=makemonster(34,m)
        planets(m).mon_noamin(3)=5
        planets(m).mon_noamax(3)=5
    endif
    
    if d.s=20 and (rnd_range(1,100)<10 or _debug>0) then
        from.x=38
        from.y=1
        from.m=lastplanet
        lastplanet+=1
        dest=from
        dest.m=lastplanet
        load_map(d.s,lastplanet)
        addportal(from,dest,1,asc(">"),"Stairs going down.",9)
        addportal(dest,from,1,asc(">"),"Stairs going up.",9)
        a=0
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,lastplanet)=-999 then planetmap(x,y,lastplanet)=-202
                if planetmap(x,y,lastplanet)=-203 then planetmap(x,y,lastplanet)=-201 
                if tiles(abs(planetmap(x,y,lastplanet))).gives>0 then planetmap(x,y,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and rnd_range(1,100)<50-a*10 and a<5 then 
                    planetmap(x,y,lastplanet)=-1*(215+a)
                    a+=1
                endif
                if planetmap(x,y,lastplanet)=-202 and rnd_range(1,100)<15 then
                    planetmap(x,y,lastplanet)=-222
                    p.x=x
                    p.y=y
                    if rnd_range(1,100)<15 then
                        for a=0 to rnd_range(0,2)
                            if rnd_range(1,100)<50 then
                                placeitem(rnd_item(RI_weakstuff),x,y,lastplanet)
                            else
                                placeitem(rnd_item(RI_weakweapons),x,y,lastplanet)
                            endif
                        next
                    endif
                endif
            next
        next
        
        planets(dest.m)=planets(from.m)
        planets(dest.m).atmos=4
        deletemonsters(dest.m)
        
        for a=12 to 16
            if rnd_range(1,100)<15 then planets(dest.m).flags(a)=rnd_range(2,3)
        next
        
        if rnd_range(1,100)<10 then
            planets(dest.m).mon_template(0)=makemonster(1,dest.m)
            planets(dest.m).mon_template(0).aggr=0
            planets(dest.m).mon_noamin(0)=1
            planets(dest.m).mon_noamax(0)=5
        endif
        
        if rnd_range(1,100)<50 or _Debug>0 then
            planets(dest.m).mon_template(1)=makemonster(104,dest.m)
            planets(dest.m).mon_noamin(1)=1
            planets(dest.m).mon_noamax(1)=5
        endif
    endif
    return 0
end function

function add_stranded_ship(s as short,p as _cords, a as short,broken as short) as short
    dim addship as _driftingship
    dim as short b
    planetmap(p.x,p.y,a)=-127-s
    if s=18 then planetmap(p.x,p.y,a)=-241
    addship.x=p.x
    addship.y=p.y
    addship.m=a
    addship.s=s
    if _debug>0 then planetmap(p.x,p.y,a)=abs(planetmap(p.x,p.y,a))
    make_drifter(addship,1,broken)
    planets(lastplanet).depth=1
    planets(lastplanet).atmos=planets(a).atmos
    if rnd_range(1,100)<30 or broken=0 then planets(lastplanet).atmos=6
    planets(lastplanet).grav=planets(a).grav
    planets(lastplanet).temp=30
    For b=1 To 16
        planets(lastplanet).mon_template(b)=planets(a).mon_template(b)
        planets(lastplanet).mon_noamin(b)=planets(a).mon_noamin(b)/3-1
        planets(lastplanet).mon_noamax(b)=planets(a).mon_noamax(b)/3-1
    Next
    for b=0 to 1+s/4
        p=rnd_point
        if rnd_range(1,100)<11 then placeitem(rnd_item(RI_StrandedShip),p.x,p.y,lastplanet)
    next
    return 0
end function

function station_event(m as short) as short
    dim p as _cords
    dim as short c,s,i,j,r,r2
    for i=10 to 1 step -1
        if planets(m).mon_template(i).made=0 and s=0 then s=i
    next
    planets_flavortext(m)="Something is going on here today."
    r=rnd_range(1,100)
    r2=rnd_range(1,100)
    if _debug=1501 then 
        r=60
        r2=50
    endif
    select case r
    case is<35 'Good stuff
        select case r2
            case 0 to 25
                planets(m).mon_template(s)=makemonster(98,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 26 to 50
                planets(m).flags(26)=7
                planetmap(39,1,m)=-268
                planetmap(38,1,m)=-267
                planetmap(40,1,m)=-267
                planetmap(40,2,m)=-267
                planetmap(38,2,m)=-267
            case 51 to 75
                planetmap(46,17,m)=-215
                planetmap(44,18,m)=-216
                planets(m).flags(26)=8
                planets(m).flags(12)=rnd_range(2,6)
                planets(m).flags(13)=rnd_range(2,6)
            case else
                planets(m).flags(26)=9 'Fuel shortage
                planets(m).flags(27)=0 
        end select
    case is>55 'Bad Stuff
        select case r2
            case 0 to 20
                planets(m).flags(26)=1 'Standard Critter loose
                planets(m).mon_template(s)=makemonster(1,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 21 to 40
                planets(m).flags(26)=4 'Crawling Shrooms loose
                planets(m).mon_template(s)=makemonster(34,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case 41 to 60
                planets(m).flags(26)=5 'Pirate band attacking
                planets(m).mon_template(s)=makemonster(3,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=3
                p=rnd_point(m,,203)
                planetmap(p.x,p.y,m)=-67
            case 61 to 80 'Tribble infestation
                planets(m).flags(26)=12
                planets(m).mon_template(s)=makemonster(80,m)
                planets(m).mon_noamin(s)=1
                planets(m).mon_noamax(s)=1
            case else
                planets(m).flags(26)=6 'Leak
                p=rnd_point(m,,243)
                planetmap(p.x,p.y,m)=-4
                'planets(m).atmos=1
        end select
    case else 'Neutral Stuff
        c=rnd_range(0,1)
        planets(m).flags(26)=10
        planets(m).mon_template(s)=civ(c).spec
        planets(m).mon_noamin(s)=1
        planets(m).mon_noamax(s)=3
        p=rnd_point(m,,203)
        
        planetmap(p.x,p.y,m)=-(272+c)
    end select
    'Clear cache
    
    for i=1 to 15 'Look for saved status on this planet
        if savefrom(i).map=m then
            for j=i to 14
                savefrom(j)=savefrom(j+1)
            next
            savefrom(15)=savefrom(0)
        endif
    next
    
    return 0
end function

function clean_station_event() as short
    dim as short a,m,x,y
    for a=1 to 3
        m=drifting(a).m
        planets(m).mon_noamin(2)=0
        planets(m).mon_noamax(2)=0
        if planets(m).flags(26)<>9 then 
            planets(m).flags(26)=0
            planets(m).flags(27)=0
            planets(m).atmos=5
            planets_flavortext(m)="A cheerful sign welcomes you to the station"
        endif
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,m)=268 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-268 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=267 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-267 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=215 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-215 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=216 then planetmap(x,y,m)=202 
                if planetmap(x,y,m)=-216 then planetmap(x,y,m)=-202 
                if planetmap(x,y,m)=67 then planetmap(x,y,m)=203
                if planetmap(x,y,m)=-67 then planetmap(x,y,m)=-203
                if planetmap(x,y,m)=4 then planetmap(x,y,m)=243
                if planetmap(x,y,m)=-4 then planetmap(x,y,m)=-243 
            next
        next
    next
    return 0
end function

function dominant_terrain(x as short,y as short,m as short) as _cords
    dim as short x2,y2,i,in,set,dom,t1,t2,p,addtile
    dim t(9) as short
    dim c(9) as short
    dim result as _cords
    for x2=x-1 to x+1
        for y2=y-1 to y+1
            if x2>=0 and x2<=60 and y2>=0 and y2<=20 and (x2<>x or y2<>y) then
                if (abs(planetmap(x2,y2,m))<128 or abs(planetmap(x2,y2,m)>149)) and tiles(abs(planetmap(x2,y2,m))).gives=0 then
                    if abs(planetmap(x2,y2,m))=27 then
                        addtile=14
                    else
                        addtile=abs(planetmap(x2,y2,m))
                    endif
                    set=0
                    for i=1 to 9
                        if t(i)=addtile then
                            c(i)+=1
                            set+=1
                        endif
                    next
                    if set=0 then 
                        in+=1
                        t(in)=addtile
                        c(in)+=1
                    endif
                endif
            endif
        next
    next
    for i=1 to in
        if c(i)>dom then 
            dom=c(i)
            t1=t(i)
            p=i
        endif
    next
    result.x=t1
    result.y=dom*10
    c(p)=c(in)
    t(p)=t(in)
    in-=1 'One terrain removed
    dom=0
    if in>0 then
        for i=1 to in
            if c(i)>dom then 
                dom=c(i)
                t2=t(i)
            endif
        next
        result.m=t2
        result.s=dom*10
    else
        result.m=t1
        result.s=dom*10
    endif
    return result
end function
