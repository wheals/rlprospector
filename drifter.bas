function make_drifter(d as _driftingship, bg as short=0,broken as short=0,f2 as short=0) as short
    dim as short a,m,roll,x,y,f,ti,xs,ys,x2,y2,addweap,addcarg,ff,fc,wc,i,j,l
    dim as byte retirementshop,antiques,oneway,lockermap(60,20)
    dim as short randomshop(10),lastrandomshop
    dim s as _ship
    dim pods(6,5,1) as short
    dim as _cords p,p2,bgtiles
    dim crates(254) as _cords
    dim from as _cords
    dim dest as _cords
    dim lastcrate as short
    randomshop(1)=262 'Mudds
    randomshop(2)=270 'Retirement
    randomshop(3)=261 'Hospital
    randomshop(4)=294 'Antiques
    randomshop(5)=109 'Bot-Bin
    randomshop(6)=98 'Black Market
    randomshop(7)=43 'Equipment
    randomshop(8)=286 'Customize item
    randomshop(9)=110 'Zoo
    randomshop(10)=112 'Used ships
    lastrandomshop=10 '
    
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
                    if _debug>0 then ti=8
                    planetmap(x,y,m)=-randomshop(ti)
                    randomshop(ti)=randomshop(lastrandomshop)
                    lastrandomshop-=1
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
        if _debug>0 then dprint "from:"&from.x &":"& from.y &":"&from.m &"M"&m &":"
        addportal(from,dest,1,asc("@"),"Abandoned "&shiptypes(d.s),11)
        portal(lastportal).ti_no=3009+d.s
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

function dominant_terrain(x as short,y as short,m as short) as _cords
    dim as short x2,y2,i,in,set,dom,t1,t2,p
    dim t(9) as short
    dim c(9) as short
    dim result as _cords
    for x2=x-1 to x+1
        for y2=y-1 to y+1
            if x2>=0 and x2<=60 and y2>=0 and y2<=20 then
                if (abs(planetmap(x2,y2,m))<128 or abs(planetmap(x2,y2,m)>149)) and tiles(abs(planetmap(x2,y2,m))).gives=0 then
                    set=0
                    for i=1 to 9
                        if t(i)=abs(planetmap(x2,y2,m)) then
                            c(i)+=1
                            set+=1
                        endif
                    next
                    if set=0 then 
                        in+=1
                        t(in)=abs(planetmap(x2,y2,m))
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
