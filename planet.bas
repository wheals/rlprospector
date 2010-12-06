function deletemonsters(a as short) as short
    dim b as short
    dim m as _monster
    if a>0 then
        for b=0 to 16
            planets(a).mon_template(b)=m
            planets(a).mon_noamin(b)=0
            planets(a).mon_noamax(b)=0
        next
    endif
    return 0
end function

function make_spacemap() as short
    dim as short a,b,c,d,e,astcou,gascou
    dim as _cords p1,p2,p3
    dim as _stars del
    
    color 11,0
    print
    Print "Generating sector"
    color 7,0
    
    rerollshops
    'generate starmap
    
    c=0
    for a=0 to laststar
        map(a)=del
        print ".";
        map(a).c.x=rnd_range(0,sm_x)
        map(a).c.y=rnd_range(0,sm_y)
        if rnd_range(1,100)<36 then
            map(a).spec=rnd_range(2,4)
        else
            map(a).spec=rnd_range(1,7)
        endif
        map(a).ti_no=map(a).spec+68
        if rnd_range(1,100)<91 then
            for b=1 to 9
                map(a).planets(b)=rnd_range(1,24)-((map(a).spec-3)^2+rnd_range(1,12))
                if map(a).planets(b)>0 then                    
                    if rnd_range(1,100)<77 then
                        c=c+1
                        map(a).planets(b)=c
                    else
                        if rnd_range(1,100)<64 then
                            map(a).planets(b)=-rnd_range(1,6)
                            astcou=astcou+1
                        else
                            if rnd_range(1,100)<45+b*5 then
                                if b<7 then
                                    map(a).planets(b)=-20001
                                else
                                    map(a).planets(b)=-20002
                                endif
                                if b=1 then map(a).planets(b)=-20003
                                gascou=gascou+1
                            endif
                        endif
                    endif
                else
                    map(a).planets(b)=0
                endif
            next
        else
            c=c+1
            map(a).spec=8
            map(a).ti_no=76
            map(a).planets(1)=c
        endif
    next
    for a=laststar+1 to laststar+wormhole-1 step 2
        map(a).c.x=rnd_range(0,sm_x)
        map(a).c.y=rnd_range(0,sm_y)
        map(a).spec=9
        map(a).ti_no=77
        map(a).planets(1)=a+1
        map(a).discovered=maximum(show_all,show_wormholes)
        map(a+1).planets(1)=a
        map(a+1).c.x=rnd_range(0,sm_x)
        map(a+1).c.y=rnd_range(0,sm_y)
        map(a+1).spec=9
        map(a+1).ti_no=77
        map(a+1).discovered=maximum(show_all,show_wormholes)
        
    next
    lastplanet=c
    lastportal=22
    
    for a=0 to lastspecial
        do
            b=getrandomsystem()
            print ".";
        loop until  map(b).spec<8 
        c=getrandomplanet(b)
        if c=-1 then 
            c=rnd_range(1,9)
            map(b).planets(c)=lastplanet+1
            lastplanet=lastplanet+1
            c=lastplanet
        endif
        map(b).discovered=2
        if a=12 then
            if map(b).planets(1)<=0 then 
                map(b).planets(1)=lastplanet+1
                lastplanet=lastplanet+1
            endif
            specialplanet(a)=map(b).planets(1)
        else        
            specialplanet(a)=c
        endif
        if a=18 then
            map(b).planets(3)=lastplanet+1
            specialplanet(18)=lastplanet+1
            map(b).planets(9)=lastplanet+2
            specialplanet(19)=lastplanet+2
            lastplanet=lastplanet+2
            a=19
        endif
            
        print ".";
        if specialplanet(a)<0 then
            color 12,0
            print a;" ";b;" ";c
            print lastplanet
            no_key=keyin
            color 15,0
        endif
    next
    
    specialplanet(30)=lastplanet+1
    lastplanet=lastplanet+1
    
    
    for a=0 to lastportal
         
            portal(a).desig="A natural tunnel. "
            portal(a).tile=111
            portal(a).col=7
            portal(a).ti_no=3001
            print ".";
            portal(a).from.m=get_nonspecialplanet()
            if portal(a).from.m<=0 then
                b=rnd_range(1,9)
                if portal(a).from.s=-1 then
                    do
                        portal(a).from.s=rnd_range(0,laststar)
                    loop until map(portal(a).from.s).discovered<>2
                endif
                if map(portal(a).from.s).planets(b)<=0 then
                    'makenewplanet
                    lastplanet=lastplanet+1
                    map(portal(a).from.s).planets(b)=lastplanet
                    'print portal(a).from.s &":" & map(portal(a).from.s).planets(b)
                else
                    portal(a).from.m=map(portal(a).from.s).planets(b)
                endif                
            endif
            'portal(a).from.m=map(portal(a).from.s).planets(portal(a).from.p)
            portal(a).from.x=rnd_range(1,59)
            portal(a).from.y=rnd_range(1,19)
            portal(a).dest.m=lastplanet+1
            portal(a).dest.s=portal(a).from.s
            portal(a).dest.x=rnd_range(1,59)
            portal(a).dest.y=rnd_range(1,19)
            portal(a).discovered=show_portals
            portal(a).dimod=2-rnd_range(1,4)
            portal(a).tumod=4-rnd_range(1,8)
            map(portal(a).from.s).discovered=-3
            lastplanet=lastplanet+1
            print ".";
    next
    
    for a=0 to _NoPB
        lastplanet=lastplanet+1
        pirateplanet(a)=lastplanet
        piratebase(a)=getrandomsystem
        if piratebase(a)=-1 then piratebase(a)=rnd_range(0,laststar)
        map(piratebase(a)).discovered=show_pirates
        map(piratebase(a)).planets(rnd_range(1,9))=pirateplanet(a)
        print ".";
    next
    
    'print pirateplanet
    'sleep
    print
    print "distributing ";
    for a=0 to laststar
        map(a).discovered=show_all
        pwa(a)=map(a).c
        print ".";
    next
    for a=laststar+1 to laststar+wormhole
        map(a).discovered=show_wormholes
        pwa(a)=map(a).c
    next
    a=distributepoints(pwa(),pwa(),laststar+wormhole)
    for a=0 to laststar+wormhole
        map(a).c=pwa(a)
        print ".";
    next
    do
        c=c+1
        b=0
        for a=0 to _nopb
           if _minsafe=0 and disnbase(map(piratebase(a)).c)<4 then 
               d=getrandomsystem(0)
               swap map(piratebase(a)),map(d)
               piratebase(a)=d
           endif
           if abs(spacemap(map(piratebase(a)).c.x,map(piratebase(a)).c.y))>1 then 
               d=getrandomsystem(0)
               swap map(piratebase(a)),map(d)
               piratebase(a)=d
           endif
           b=b+disnbase(map(piratebase(a)).c)
        next
    loop until b>24 or c>255
    
    make_clouds()
    
    a=sysfrommap(specialplanet(20))
    print a
    c=999
    for b=0 to laststar
        if b<>a then
            if cint(distance(map(a).c,map(b).c))<c then
                c=cint(distance(map(a).c,map(b).c))
                d=b
            endif
        endif
    next
    
    a=sysfrommap(specialplanet(26))
    swap map(a).c,map(d).c
    print "loading bones"
    loadbones
    
'    for a=0 to lastspecial
'        print ".";
'        b=sysfrommap(specialplanet(a))
'        for c=1 to 9
'            if map(b).planets(c)=specialplanet(a) then d=c
'        next
'        makeplanetmap(specialplanet(a),c,map(b).spec)
'    next
    
    for a=0 to laststar
        if map(a).discovered=2 then 
            map(a).discovered=show_specials
        endif
        if map(a).discovered=-3 then map(a).discovered=show_portals
        if abs(spacemap(map(a).c.x,map(a).c.y))>1 then
            map(a).spec=map(a).spec+abs(spacemap(map(a).c.x,map(a).c.y))/2
            if map(a).spec>7 then map(a).spec=7
        endif
        if map(a).discovered=4 then map(a).discovered=_debug_bones
        if _debug_bones=1 then player.c=map(a).c
        scount(map(a).spec)+=1
        'map(a).discovered=1
    next
    if show_specials<>0 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=show_specials then map(a).discovered=1
            next
        next
    endif
    print
    for e=0 to 2
    print "Moving Base ";e    
    if abs(spacemap(basis(e).c.x,basis(e).c.y))<>1 then
        p2.x=0
        p2.y=0
        p1.x=basis(e).c.x
        p1.y=basis(e).c.y        
        c=1000
        for x=0 to sm_x
            for y=0 to sm_y
                if abs(spacemap(x,y))<2 then
                    p2.x=x
                    p2.y=y
                    b=0
                    for a=1 to 9
                        if a<>5 then
                            p3=movepoint(p2,a)
                            if abs(spacemap(p3.x,p3.y))<2 then b=b+1
                        endif
                    next
                    if b>3 and distance(p2,p1)<c then
                        basis(e).c=p2
                        c=distance(p2,p1)
                    endif
                endif
            next
        next
        
    endif
    player.c=basis(e).c
    next
    
    print "checking for starmap errors: ";
    fixstarmap()

    color 7,0
    print "generating traderoutes"
    gen_traderoutes()
    
    
    color 7,0
    print
    print "Pregenerating planets ";
    for c=0 to 5
        print ".";
        a=getrandomsystem(0)
        if a>0 then
            b=getrandomplanet(a)
            if b>0 and b<=lastplanet then
                if is_special(b)=0 and b<>pirateplanet(0) and b<>pirateplanet(1) and b<>pirateplanet(2) then
                    makeplanetmap(b,rnd_range(1,9),map(a).spec)
                    planet_event(b)
                    if show_eventp=1 then map(a).discovered=1
                endif
            endif
        endif
    next
    
    makecivilisation(0,specialplanet(7))
    makecivilisation(1,specialplanet(46))
    
    if findcompany(1)=0 then specialplanet(40)=32767
    if findcompany(2)=0 then specialplanet(41)=32767
    if findcompany(3)=0 then specialplanet(42)=32767
    if findcompany(4)=0 then specialplanet(43)=32767
    
    ' The probesp
    print "Making drifters";
    for a=1 to lastdrifting
        print ".";
        lastplanet=lastplanet+1
        drifting(a).x=rnd_range(0,sm_x)
        drifting(a).y=rnd_range(0,sm_y)
        drifting(a).s=rnd_range(1,a)
        if drifting(a).s>16 then drifting(a).s=rnd_range(1,12)
        if all_drifters_are>0 then drifting(a).s=all_drifters_are
        drifting(a).m=lastplanet
        if a=1 then drifting(a).s=20
        if a=2 then drifting(a).s=20
        if a=3 then drifting(a).s=20
        if a=4 then drifting(a).s=17
        if a=5 then drifting(a).s=18 
        if a=6 then drifting(a).s=19 
        if drifting(a).s<=22 then makedrifter(drifting(a))
        drifting(a).p=show_all
    next
    print
    drifting(1).x=targetlist(firstwaypoint).x
    drifting(1).y=targetlist(firstwaypoint).y
    planets(drifting(1).m).atmos=5
    planets(drifting(1).m).depth=1
    planets(drifting(1).m).flavortext="A cheerfull sign says 'Welcome! Please enjoy our services'"
    deletemonsters(drifting(1).m)
    planets(drifting(1).m).mon_template(0)=makemonster(88,drifting(1).m)
    planets(drifting(1).m).mon_noamin(0)=2
    planets(drifting(1).m).mon_noamax(0)=6
    planetmap(19,10,drifting(1).m)=-287
    
    do
        a=rnd_range(firststationw,lastwaypoint)
    loop until targetlist(a).x>=20 and targetlist(a).x<=25
    drifting(2).x=targetlist(a).x
    drifting(2).y=targetlist(a).y
    planets(drifting(2).m).atmos=5
    planets(drifting(2).m).depth=1
    deletemonsters(drifting(2).m)
    planets(drifting(2).m).flavortext="A cheerfull sign says 'Welcome! Please enjoy our services'"
    planets(drifting(2).m).mon_template(0)=makemonster(88,drifting(2).m)
    planets(drifting(2).m).mon_noamin(0)=3
    planets(drifting(2).m).mon_noamax(0)=6
    planetmap(19,10,drifting(2).m)=-287
    
    do
        a=rnd_range(firststationw,lastwaypoint)
    loop until targetlist(a).x>=45 and targetlist(a).x<=50
    drifting(3).x=targetlist(a).x
    drifting(3).y=targetlist(a).y
    planets(drifting(3).m).atmos=5
    planets(drifting(3).m).depth=1
    deletemonsters(drifting(3).m)
    planets(drifting(3).m).flavortext="A cheerfull sign says 'Welcome! Please enjoy our services'"
    planets(drifting(3).m).mon_template(0)=makemonster(88,drifting(3).m)
    planets(drifting(3).m).mon_noamin(0)=3
    planets(drifting(3).m).mon_noamax(0)=6
    planetmap(19,10,drifting(3).m)=-287
    
    drifting(4).x=map(sysfrommap(specialplanet(18))).c.x-5+rnd_range(1,10)
    drifting(4).y=map(sysfrommap(specialplanet(18))).c.y-5+rnd_range(1,10)
    if drifting(4).x<0 then drifting(lastdrifting).x=0
    if drifting(4).y<0 then drifting(lastdrifting).y=0
    if drifting(4).x>sm_x then drifting(lastdrifting).x=sm_x
    if drifting(4).y>sm_y then drifting(lastdrifting).y=sm_y
    planets(drifting(4).m).flavortext="You enter the alien vessel. The air is breathable. Most of the ship seems to be a huge hall illuminated in blue light. Strange trees grow in orderly rows and stranger insect creatures scurry about." 
    planets(drifting(4).m).atmos=4
    planets(drifting(4).m).depth=1
    deletemonsters(drifting(4).m)
    planets(drifting(4).m).mon_template(0)=makemonster(37,drifting(4).m)
    planets(drifting(4).m).mon_noamin(0)=16
    planets(drifting(4).m).mon_noamax(0)=26
    
    planets(drifting(5).m).flavortext="This ship has been drifting here for millenia. The air is gone. Propably some asteroid punched a hole into the hull. Dim green lights on the floor barely illuminate the corridors."
    planets(drifting(5).m).darkness=5
    planets(drifting(5).m).atmos=1
    planets(drifting(5).m).depth=1
    deletemonsters(drifting(5).m)
    planets(drifting(5).m).mon_template(0)=makemonster(9,drifting(5).m)
    planets(drifting(5).m).mon_noamin(0)=16
    planets(drifting(5).m).mon_noamax(0)=26
    planets(drifting(5).m).flags(6)=66
    planets(drifting(5).m).flags(7)=66
    planets(drifting(5).m).flags(4)=6
    
    planets(drifting(6).m).flavortext="You dock at the ancient space probe."
    planets(drifting(6).m).darkness=5
    deletemonsters(drifting(6).m)
    planets(drifting(6).m).atmos=1
    planets(drifting(6).m).depth=1
    
    if map(sysfrommap(specialplanet(17))).c.x>=sm_x-4 then map(sysfrommap(specialplanet(17))).c.x-=4
    if map(sysfrommap(specialplanet(17))).c.y>=sm_y-4 then map(sysfrommap(specialplanet(17))).c.y-=4
    drifting(6).x=map(sysfrommap(specialplanet(17))).c.x+rnd_range(1,3)
    drifting(6).y=map(sysfrommap(specialplanet(17))).c.y+rnd_range(1,3)
    
    
    do
        for c=0 to 2    
            d=0
            for a=0 to lastdrifting
                for b=0 to 2
                    if drifting(a).x=basis(b).c.x and drifting(a).y=basis(b).c.y then
                        d=d+1
                        drifting(a).x=rnd_range(0,sm_x)
                        drifting(a).y=rnd_range(0,sm_y)
                    endif
                next
            next
        next
    loop until d=0
    
    for a=0 to 15
        p1=rnd_point(drifting(5).m,0)
        planetmap(p1.x,p1.y,drifting(5).m)=-81
    next
    for a=0 to 15
        p1=rnd_point(drifting(5).m,0)
        planetmap(p1.x,p1.y,drifting(5).m)=-158
    next
    
    if show_specials>0 then map(sysfrommap(specialplanet(show_specials))).discovered=1
    
    fleet(0).mem(1)=makeship(33)
    fleet(0).ty=1
    fleet(1).mem(1)=makeship(33)
    fleet(1).ty=1
    fleet(2).mem(1)=makeship(33)
    fleet(2).ty=1
    lastfleet=3
    
    if _clearmap=1 then
        for a=1 to laststar+wormhole+1
            map(a).discovered=0
            for b=1 to 9
                if map(a).planets(b)>0 then planets(map(a).planets(b)).visited=0
            next
        next
    endif
    
    print
    color 11,0
    print "Universe created with "&laststar &" stars and "&lastplanet-lastdrifting &" planets."
    color 15,0
    print "Star distribution:"
    for a=1 to 8
        print spectralname(a);":";scount(a)
    next
    print "Asteroid belts:";astcou
    print "Gas giants:";gascou
    sleep 1250
    return 0
end function

function gen_traderoutes() as short
    dim as _pfcords start,goal,wpl(40680)
    dim as _cords p
    dim t as short
    dim map(sm_x,sm_y) as byte
    dim as integer x,y,i,offset,a
    dim as integer fp,lp
    lastwaypoint=5
    firstwaypoint=5
    for a=10 to 4068
        targetlist(a).x=0
        targetlist(a).y=0
    next
    for x=0 to sm_x
        for y=0 to sm_y
            p.x=x
            p.y=y
            if abs(spacemap(x,y))>=2 then map(x,y)=2
            if abs(spacemap(x,y))>=5 then map(x,y)=2
            'if abs(spacemap(x-1,y))>=2 then map(x,y)=1
            'if abs(spacemap(x,y-1))>=2 then map(x,y)=1
            'if spacemap(x,y-1)<>0 and spacemap(x,y-1)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x,y-1)<>0 and spacemap(x,y-1)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x-1,y)<>0 and spacemap(x-1,y)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x-1,y)<>0 and spacemap(x-1,y)<>1 and disnbase(p)>3 then map(x,y)=1
            if map(x,y)>0 and show_NPCs=1 then
                locate y+1,x+1
                print "#"
            endif
        next
    next
    map(basis(0).c.x,basis(0).c.y)=0
    map(basis(1).c.x,basis(1).c.y)=0
    map(basis(2).c.x,basis(2).c.y)=0
    start.x=targetlist(0).x
    start.y=targetlist(0).y

    goal.x=basis(0).c.x
    goal.y=basis(0).c.y
    lp=gen_waypoints(wpl(),goal,start,map())
    offset=11
    for i=0 to lp
        targetlist(i+offset).x=wpl(i).x
        targetlist(i+offset).y=wpl(i).y
        wpl(i).i=0
        wpl(i).c=0
        wpl(i).x=0
        wpl(i).y=0
    next
    
    lastwaypoint=lp+offset
    print offset;"-";lastwaypoint
    offset=lastwaypoint+1
    firststationw=lastwaypoint
    for a=1 to 2
        start.x=basis(a-1).c.x
        start.y=basis(a-1).c.y
        goal.x=basis(a).c.x
        goal.y=basis(a).c.y
        lp=gen_waypoints(wpl(),goal,start,map())
        for i=0 to lp
            targetlist(i+offset).x=wpl(i).x
            targetlist(i+offset).y=wpl(i).y
            wpl(i).i=0
            wpl(i).c=0
            wpl(i).x=0
            wpl(i).y=0
        next
        print offset;"-";lastwaypoint+lp
        lastwaypoint=lastwaypoint+lp+1
        offset=lastwaypoint
    next
    
    start.x=basis(2).c.x
    start.y=basis(2).c.y
    goal.x=basis(0).c.x
    goal.y=basis(0).c.y
    lp=gen_waypoints(wpl(),goal,start,map())
    for i=0 to lp
        targetlist(i+offset).x=wpl(i).x
        targetlist(i+offset).y=wpl(i).y
    next
    offset=offset+lp+1
    print offset;"-";lastwaypoint+lp
    lastwaypoint=lastwaypoint+lp
    firstwaypoint=11
    if targetlist(firstwaypoint).x>1 and targetlist(firstwaypoint).y>1 then
        if spacemap(targetlist(firstwaypoint).x,0)=0 or spacemap(targetlist(firstwaypoint).x,0)=1 then
            targetlist(firstwaypoint).y=0
        else
            targetlist(firstwaypoint).x=0
        endif
    endif
    lastwaypoint-=1
    print firstwaypoint &"-"&lastwaypoint
    if show_NPCs=5 then
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)<>0 and spacemap(x,y)<>1 then 
                    map(x,y)=2
                    if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5 then map(x,y)=1
                
                else
                    map(x,y)=0
                endif
                locate y+1,x+1
                if map(x,y)=1 then
                    color 15,0
                    print "#";
                endif
                if map(x,y)=2 then
                    color 15,0
                    print ":";
                endif
                
                if map(x,y)=0 then
                    color 1,0
                    print ".";
                endif
            next
        next
        color 10,0
        x=firstwaypoint
        do
            color 10,0
            x+=1
            if x>lastwaypoint then x=firststationw
            for y=0 to 2
                if basis(y).c.x=targetlist(x).x and basis(y).c.y=targetlist(x).y then t=y
            next
            locate targetlist(x).y+1,targetlist(x).x+1
            if t=0 then print "0";
            if t=1 then print "1";
            if t=2 then print "2";
            sleep 66
            color 1,0
            locate targetlist(x).y+1,targetlist(x).x+1
            print "."
        loop until inkey<>""
        sleep
        cls
    endif
    
'    
'    targetlist(0)=basis(0).c
'    targetlist(1).x=rnd_range(0,30)
'    targetlist(1).y=rnd_range(15,20)
'    targetlist(2)=basis(1).c
'    
'    targetlist(3).x=rnd_range(0,60)
'    targetlist(3).y=rnd_range(1,20)
'    
'    targetlist(4).x=rnd_range(30,59)
'    targetlist(4).y=rnd_range(15,20)
'    targetlist(5)=basis(2).c
'    targetlist(6).x=rnd_range(0,60)
'    targetlist(6).y=rnd_range(0,20)
    return 0
end function


sub make_clouds()
    dim wmap(sm_x,sm_y)as ubyte
    dim as short x,y,bx,by,highest,count,a,b,c,r
    dim as single attempt
    dim as _cords p1,p2,p3,p4
    print
    print "Creating clouds";
    do
        print ".";
        for x=0 to sm_x
            for y=0 to sm_y
                wmap(x,y)=0
                spacemap(x,y)=0
            next
        next
        highest=0
        do
            count=0
            bx=rnd_range(3,7)
            p1.x=rnd_range(bx,sm_x-bx)
            p1.y=rnd_range(by,sm_y-by)
            r=rnd_range(1,100)
            if r<=20 then p1.y=sm_y
            if r<=15 then p1.x=sm_x
            if r<=10 then p1.y=0
            if r<=5 then p1.x=0
            for x=0 to sm_x
                for y=0 to sm_y
                    p2.x=x
                    p2.y=y
                    if distance(p1,p2)<bx then wmap(x,y)=wmap(x,y)+rnd_range(1,6)
                    if wmap(x,y)>highest then highest=wmap(x,y)
                    if wmap(x,y)>=8 then count+=1
                next
            next
        loop until count>=sm_x*sm_y*(0.20-attempt)
        for x=0 to sm_x
            for y=0 to sm_y
                if wmap(x,y)=8 or wmap(x,y)=9  then spacemap(x,y)=-2                    
                if wmap(x,y)=10 or wmap(x,y)=11  then spacemap(x,y)=-3                    
                if wmap(x,y)=12 or wmap(x,y)=13  then spacemap(x,y)=-4                    
                if wmap(x,y)>13 then spacemap(x,y)=-5                    
                if abs(spacemap(x,y))>2 then count+=1
            next
        next
    
    if rnd_range(1,100)<33 then
        p1.x=rnd_range(1,sm_x)
        p1.y=rnd_range(1,sm_y)
    else
        p1=map(rnd_range(laststar+1,laststar+wormhole)).c
    endif
    
    
    for a=0 to 25 'Space - Time Anomalies
        do
            if rnd_range(1,100)<33 then
                if rnd_range(1,100)<33 then
                    p1.x=rnd_range(1,sm_x)
                    p1.y=rnd_range(1,sm_y)
                else
                    p1=map(rnd_range(laststar+1,laststar+wormhole)).c
                endif
            endif
            if spacemap(p1.x,p1.y)=-6 or spacemap(p1.x,p1.y)=-7 or spacemap(p1.x,p1.y)=-8 then
                p1.x=rnd_range(1,sm_x)
                p1.y=rnd_range(1,sm_y)
            endif
        loop until not((p1.x=10 and p1.y=30) or (p1.x=60 and p1.y=10) or (p1.x=35 and p1.y=20))
        c=-6
        if rnd_range(1,100)<33 then c=-7
        if rnd_range(1,100)<33 then c=-8
        if rnd_range(1,100)<66 then c=-(8+rnd_range(1,9))
        for b=1 to 9
            if rnd_range(1,100)>66 then
                p2=p1
                do
                    if rnd_range(1,100)<66 then
                        p2=movepoint(p2,b,,1)
                    else
                        p2=movepoint(p2,5,,1)
                    endif
                    spacemap(p2.x,p2.y)=c                    
                loop until rnd_range(1,100)>66 or (p2.x=10 and p2.y=30) or (p2.x=60 and p2.y=10) or (p2.x=35 and p2.y=20)
            endif
        next
    next
        attempt=attempt+.01
        if attempt>0.1 then attempt=0.1
        flood_fill(35,20,spacemap(),1)
    loop until spacemap(10,30)=255 and spacemap(60,10)=255
    do
        x=rnd_range(0,sm_x)
        y=rnd_range(0,sm_y)
        if spacemap(x,0)=255 then
            targetlist(0).x=x
            targetlist(0).y=0
        endif
        
        if spacemap(x,sm_y)=255 then
            targetlist(0).x=x
            targetlist(0).y=sm_y
        endif
        
        if spacemap(0,y)=255 then
            targetlist(0).x=0
            targetlist(0).y=y
        endif
        
        if spacemap(sm_x,y)=255 then
            targetlist(0).x=sm_x
            targetlist(0).y=y
        endif
    loop until targetlist(0).x=0 xor targetlist(0).y=0
    
    if spacemap(map(piratebase(0)).c.x,map(piratebase(0)).c.y)<>11 then
        p1=map(piratebase(0)).c
        do
            spacemap(p1.x,p1.y)=255
            p1=movepoint(p1,5)
            print ".";
        loop until spacemap(p1.x,p1.y)=255
        
    endif
    
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)=255 then spacemap(x,y)=0
        next
    next
    
    if show_all=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)=0  then spacemap(x,y)=1                    
                if abs(spacemap(x,y))>1  then spacemap(x,y)=abs(spacemap(x,y))
            next
        next    
    endif
    'print highest;lowest
    'sleep
end sub


sub makefinalmap(m as short)
    dim as _cords p
    dim as short f,x,y,c
    planets(m).darkness=5
    planets(m).teleport=1
    f=freefile
    open "data/lstlvl.dat" for binary as #f
    for y=0 to 20
        for x=0 to 60
            get #f,,planetmap(x,y,m)
            if planetmap(x,y,m)=-80 and rnd_range(1,100)<20 then planetmap(x,y,m)=-81
            if planetmap(x,y,m)=-54 and rnd_range(1,100)<80 then planetmap(x,y,m)=-55
        next
    next
    close #f
    
    p=rnd_point(m,0)
    planetmap(p.x,p.y,m)=-127
    for y=0 to 20
        for x=0 to 60
             if show_all=1 then planetmap(x,y,m)=planetmap(x,y,m)*-1
        next
    next
    planets(m).depth=1
    planets(m).mon_template(0)=makemonster(19,m)
    planets(m).Mon_noamax(0)=28
    planets(m).mon_noamin(0)=22
    planets(m).grav=0.5
    planets(m).atmos=3
end sub

sub makeplatform(slot as short,platforms as short,rooms as short, translate as short, adddoors as short=0)
    
    dim map(60,20) as short
    dim as short x,y,a,w,h,c,d,b,n,flag,door,c0
    dim as _cords p(platforms)
    dim sides(4) as byte
    for x=0 to 60
        for y=0 to 20
            'map(x,y)=99
        next
    next
    
    
    n=rnd_range(5,12)
    
    
    for a=1 to platforms
        d=0
        do
            p(a).x=rnd_range(1,50)
            p(a).y=rnd_range(1,14)
            w=rnd_range(5,9)
            h=rnd_range(3,5)
            c=0
            for x=p(a).x-1 to p(a).x+w+1
                for y=p(a).y-1 to p(a).y+h+1
                    if map(x,y)>0 then c=1
                next
            next
            d+=1
        loop until c=0 or d>=100
        if c=0 then
            for x=p(a).x to p(a).x+w
                for y=p(a).y to p(a).y+h
                    map(x,y)=1
                next
            next
            map(p(a).x,p(a).y)=0
            map(p(a).x,p(a).y+h)=0
            map(p(a).x+w,p(a).y)=0
            map(p(a).x+w,p(a).y+h)=0
            p(a).x=p(a).x+w/2
            p(a).y=p(a).y+h/2
        endif
    next
    
    for a=1 to platforms-1       
        do
            while p(a).x<>p(a+1).x 
                if p(a).x>p(a+1).x then p(a).x-=1
                if p(a).x<p(a+1).x then p(a).x+=1
                if (map(p(a).x,p(a).y-1)<>2 and map(p(a).x,p(a).y+1)<>2) and p(a).x<>p(a+1).x and map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            wend
            if map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            while p(a).y<>p(a+1).y 
                if p(a).y>p(a+1).y then p(a).y-=1
                if p(a).y<p(a+1).y then p(a).y+=1
                if (map(p(a).x-1,p(a).y)<>2 and map(p(a).x+1,p(a).y)<>2) and p(a).y<>p(a+1).y and map(p(a).x,p(a).y)=0 then map(p(a).x,p(a).y)=2
            wend
        loop until (p(a).x=p(a+1).x and p(a).y=p(a+1).y) 'or map(p(0).x,p(0).y)=1
        c=0
    next
    
    for a=0 to rooms
        flag=0
        c0=0
        
        do
            p(0).x=rnd_range(1,49)
            p(0).y=rnd_range(1,14)
            p(1).x=p(0).x+rnd_range(3,10)
            p(1).y=p(0).y+rnd_range(3,5)
            flag=0
            c0=0
            for x=p(0).x-1 to p(1).x+1
                for y=p(0).y-1 to p(1).y+1
                    if map(x,y)=0 then c0+=1
                    if map(x,y)=3 then flag=1
                    if (x=p(0).x-1 or x=p(0).x+1 or y=p(0).y-1 or y=p(0).y+1) and map(x,y)=4 then flag=1 
                next
            next
        loop until flag=0 and c0>0 and c0<(2+p(1).x-p(0).x)*(2+p(1).y-p(0).y)
        
        
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if x=p(0).x or x=p(1).x or y=p(0).y or y=p(1).y then
                    map(x,y)=4
                else
                    map(x,y)=3
                endif
            next
        next
        sides(1)=0
        sides(2)=0
        sides(3)=0
        sides(4)=0
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if x=p(0).x or x=p(1).x or y=p(0).y or y=p(1).y then
                    if (map(x-1,y)<4 and map(x+1,y)<4 and map(x-1,y)>0 and map(x+1,y)>0 and (map(x,y-1)=4 or map(x,y+1)=4)) then
                        door=5
                        if x=p(0).x and sides(1)=1 then door=4
                        if x=p(1).x and sides(2)=1 then door=4
                        if y=p(0).y and sides(3)=1 then door=4
                        if y=p(1).y and sides(4)=1 then door=4
                        map(x,y)=door
                        if x=p(0).x then sides(1)=1
                        if x=p(1).x then sides(2)=1
                        if y=p(0).y then sides(3)=1
                        if y=p(1).y then sides(4)=1
                    endif
                    if (map(x,y-1)<4 and map(x,y+1)<4 and map(x,y-1)>0 and map(x,y+1)>0 and (map(x-1,y)=4 or map(x+1,y)=4)) then
                        door=5
                        if x=p(0).x and sides(1)=1 then door=4
                        if x=p(1).x and sides(2)=1 then door=4
                        if y=p(0).y and sides(3)=1 then door=4
                        if y=p(1).y and sides(4)=1 then door=4
                        map(x,y)=door
                        if x=p(0).x then sides(1)=1
                        if x=p(1).x then sides(2)=1
                        if y=p(0).y then sides(3)=1
                        if y=p(1).y then sides(4)=1
                    endif
                endif
            next
        next
        for x=p(0).x to p(1).x
            for y=p(0).y to p(1).y
                if (x=p(0).x and y=p(0).y) or (x=p(0).x and y=p(1).y) or (x=p(1).x and y=p(0).y) or (x=p(1).x and y=p(1).y) then
                    if map(x+1,y)=2 or map(x-1,y)=2 or map(x,y+1)=2 or map(x,y-1)=2 then
                        if map(x+1,y)<>5 and map(x-1,y)<>5 and map(x,y+1)<>5 and map(x,y-1)<>5 then map(x,y)=5
                    endif
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if translate=1 then
                if map(x,y)=0 then planetmap(x,y,slot)=-rnd_range(175,177) 'gasclouds
                if map(x,y)=1 then planetmap(x,y,slot)=-68 'platform
                if map(x,y)=2 then 'corridor
                    planetmap(x,y,slot)=-80
                    if rnd_range(1,100)<10 then planetmap(x,y,slot)=-81
                endif
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-54 'door
            endif
        
            if translate=2 then
                if map(x,y)=0 then 
                    planetmap(x,y,slot)=-rnd_range(49,51) 'stone walls
                    p(0).x=x
                    p(0).y=y
                    c=0
                    for b=1 to 9
                        p(2)=movepoint(p(0),b)
                        if planetmap(p(2).x,p(2).y,slot)=-158 then c=c+5
                    next
                    if rnd_range(1,100)<30+c-adddoors*3 then planetmap(p(0).x,p(0).y,slot)=-158
                endif
                if map(x,y)=1 then planetmap(x,y,slot)=-80 'platform
                if map(x,y)=2 then 'corridor
                    planetmap(x,y,slot)=-80
                    if rnd_range(1,100)<10 then planetmap(x,y,slot)=-81
                endif
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then 
                    if rnd_range(1,100)>66 then 'door
                        planetmap(x,y,slot)=-54
                    else 
                        planetmap(x,y,slot)=-55
                    endif
                endif
                if rnd_range(1,100)<adddoors and x>0 and x<60 and y>0 and y<20 then
                    if map(x+1,y)>0 and map(x+1,y)<4 and map(x-1,y)>0 and map(x-1,y)<4 and map(x,y+1)=4 and map(x,y-1)=4 then planetmap(x,y,slot)=-54
                    if map(x,y+1)>0 and map(x,y+1)<4 and map(x,y-1)>0 and map(x,y-1)<4 and map(x+1,y)=4 and map(x-1,y)=4 then planetmap(x,y,slot)=-54
                endif            
            endif
            
            
            if translate=3 then
                if map(x,y)=0 then 
                    planetmap(x,y,slot)=-rnd_range(49,51) 'stone walls
                    p(0).x=x
                    p(0).y=y
                    c=0
                    for b=1 to 9
                        p(2)=movepoint(p(0),b)
                        if planetmap(p(2).x,p(2).y,slot)=-158 then c=c+(10-adddoors)
                    next
                    if rnd_range(1,100)<adddoors+c then planetmap(p(0).x,p(0).y,slot)=-158
                endif
                if map(x,y)=1 then planetmap(x,y,slot)=-4 'platform
                if map(x,y)=2 then planetmap(x,y,slot)=-4
                
                if map(x,y)=3 then planetmap(x,y,slot)=-4 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-51 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-156 
                            
            endif
            
            if translate=4 then
                if map(x,y)=0 then planetmap(x,y,slot)=-rnd_range(175,177) 'gasclouds
                if map(x,y)=1 then planetmap(x,y,slot)=-68 'platform
                if map(x,y)=2 then planetmap(x,y,slot)=-80 'Corridor
                if map(x,y)=3 then planetmap(x,y,slot)=-80 'internal of room
                if map(x,y)=4 then planetmap(x,y,slot)=-52 'wall
                if map(x,y)=5 then planetmap(x,y,slot)=-156 'door
            endif
            
        next
    next


end sub

sub makecomplex(byref enter as _cords, down as short,blocked as byte=0)
    
    dim as short last,wantsize,larga,largb,lno,x,y,mi,slot,old,a,dx,dy,dis,d,b,c,best,startdigging
    dim t as _rect
    dim r(255) as _rect
    dim rfl(255) as short
    dim map2(60,20) as short
    dim sp(255) as _cords
    dim as short roomsize
    dim p1 as _cords
    dim p2 as _cords
    dim  as integer counter,bigc
    slot=enter.m

    if show_all=1 then dprint "Made complex at "&slot
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault=r(0)
    planets(slot).teleport=1
    
    planets(slot).temp=25
    planets(slot).atmos=3    
    planets(slot).grav=.8
    planets(slot).mon_template(0)=makemonster(9,slot)
    planets(slot).mon_noamin(0)=16
    planets(slot).mon_noamax(0)=26+planets(slot).depth
do   
    last=0
    for a=0 to 255
            r(a)=r(255)
    next
    roomsize=25
    wantsize=100 'chop to this size
    mi=2 'minimum
    
    r(0).x=0
    r(0).y=0
    r(0).h=20
    r(0).w=60
    
    do
        larga=0
        largb=0
        'find largestrect
        for a=0 to last
            if r(a).h>larga then 
                larga=r(a).h
                lno=a
            endif
            if r(a).w>larga then 
                larga=r(a).w
                lno=a
            endif
            if r(a).h*r(a).w>largb then
                largb=r(a).h*r(a).w
                lno=a
            endif
        next
        ' Half largest _rect 
        last=last+1
        if r(lno).h>r(lno).w then
            y=rnd_range(mi,r(lno).h-mi)
            old=r(lno).h
            t=r(lno)
            r(last)=t
            t.h=y-1
            r(last).y=r(last).y+y
            r(last).h=old-y
            r(lno)=t
        else
            x=rnd_range(mi,r(lno).w-mi)
            old=r(lno).w
            t=r(lno)
            r(last)=t
            t.w=x-1
            r(last).x=r(last).x+x
            r(last).w=old-x
            r(lno)=t
        endif
    loop until largb<wantsize 
    for a=0 to last
        fill_rect(r(a),1,0,map2())
    next
    
    for a=0 to last
        'make rects smaller
        fill_rect(r(a),1,1,map2())
        if r(a).h*r(a).w>roomsize then
            r(a).x=r(a).x+1
            r(a).y=r(a).y+1
            r(a).w=r(a).w-2
            r(a).h=r(a).h-2
            do 
                b=rnd_range(1,4)
                   
                if r(a).w>=r(a).h then
                    if b=1 then 
                        r(a).x=r(a).x+1
                        r(a).w=r(a).w-2
                    endif
                    if b=4 then r(a).w=r(a).w-2
                endif
                if r(a).h>r(a).w then
                    if b=2 then
                        r(a).y=r(a).y+1
                        r(a).h=r(a).h-2
                    endif
                    if b=3 then r(a).h=r(a).h-2
                endif
            loop until r(a).h*r(a).w<=roomsize
            if r(a).h>1 and r(a).w>1 then 
                fill_rect(r(a),0,0,map2())
            else 
                r(a).wd(5)=1 
            endif            
        else 
            r(a).wd(5)=1 
        endif
        
    next

    for a=0 to last
        if r(a).wd(5)=0 then
            c=0
            do
                do
                    if b>-1 then r(a).wd(b)=1
                    b=rndwall(r(a))
                    if b=-1  or c>52 then exit do
                    p1=rndwallpoint(r(a),b)
                    c=c+1
                loop until p1.x>2 and p1.y>1 and p1.x<58 and p1.y<19 and r(a).wd(b)=0
                if c<=52 and b>0 then
                if rnd_range(1,100)<33 then map2(p1.x,p1.y)=3
                b=digger(p1,map2(),b)
                if rnd_range(1,100)<33 then map2(p1.x,p1.y)=3
                endif
            loop until b<=0 or c>52
        endif    
    next a        
    
    flood_fill(r(1).x,r(1).y,map2())
    
    counter=counter+1
    c=0
    for a=0 to last
        if map2(r(a).x,r(a).y)<10 and r(a).wd(5)=0 then c=c+1
        
    next
        
    loop until c=0
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=-52
            if map2(x,y)=1 then planetmap(x,y,slot)=-52 'Wall
            if map2(x,y)=11 then planetmap(x,y,slot)=-80 'Floor
            if map2(x,y)=13 then planetmap(x,y,slot)=-80 'Wall
            if map2(x,y)=14 then 
                if rnd_range(1,100)<88 then
                    planetmap(x,y,slot)=-55 'Door
                else
                    planetmap(x,y,slot)=-54
                endif
            endif
            if map2(x,y)=15 then planetmap(x,y,slot)=-81 'Trap
            
        next
    next
    do
        a=rnd_range(0,last)
    loop until r(a).wd(5)=0
    'Put portal in room a 
    enter.x=r(a).x+r(a).w/2
    enter.y=r(a).y+r(a).h/2
    b=a
    for c=1 to rnd_range(1,planets(slot).depth+1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=r(a).x+r(a).w/2
        y=r(a).y+r(a).h/2
        planetmap(x,y,slot)=-82
    next
    for a=1 to rnd_range(1,planets(slot).depth+1)-rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=r(a).x+r(a).w/2
        y=r(a).y+r(a).h/2
        planetmap(x,y,slot)=-84
        placeitem(makeitem(99),x,y,slot)
    next
    for a=0 to rnd_range(1,planets(slot).depth+1)+rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=rnd_range(r(a).x,r(a).x+r(a).w)
        y=rnd_range(r(a).y,r(a).y+r(a).h)
        planetmap(x,y,slot)=-84
    next
    if (rnd_range(1,100)<33 or planets(slot).depth>7) and blocked=0 then
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=rnd_range(r(a).x,r(a).x+r(a).w)
        y=rnd_range(r(a).y,r(a).y+r(a).h)
        lastportal=lastportal+1
        lastplanet=lastplanet+1
        a=lastportal
        portal(a).desig="A shaft. "
        portal(a).tile=111
        portal(a).col=14
        portal(a).from.s=enter.s
        portal(a).from.m=enter.m
        'portal(a).from.m=map(portal(a).from.s).planets(portal(a).from.p)
        portal(a).from.x=x
        portal(a).from.y=y
        portal(a).dest.m=lastplanet
        portal(a).dest.s=portal(a).from.s
        portal(a).dest.x=rnd_range(1,59)
        portal(a).dest.y=rnd_range(1,19)
        portal(a).discovered=show_portals
        map(portal(a).from.s).discovered=3
        planetmap(portal(a).from.x,portal(a).from.y,slot)=0
    endif
    
    if rnd_range(1,100)<planets(slot).depth*2 then
        planets(slot).vault=r(rnd_range(0,last))
        planets(slot).vault.wd(5)=1
    endif
    planetmap(enter.x,enter.y,slot)=-80
end sub

sub makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short)

dim as short map(60,20)
dim as short map2(60,20)
dim as short map3(60,20)
dim as short x,y,c,a,ff,x1,y1,xx,yy,coll
dim as short rw1,rh1 ,rn1 ,rmw1 ,rmh1 ,rw2 ,rh2,rn2 ,rmw2 ,rmh2 
dim valid(1300) as _cords
dim lastvalid as short
dim valneigh(4) as _cords
dim lastneig as short
dim collision as short
dim as short w,h

rmw1=gc1.x
rmh1=gc1.y
rw1=gc1.p
rh1=gc1.s
rn1=gc1.m

rmw2=gc2.x
rmh2=gc2.y
rw2=gc2.p
rh2=gc2.s
rn2=gc2.m

for x=0 to 60
    for y=0 to 20
        map(x,y)=1
    next
next

for x=1 to 59 step 2
    for y=1 to 19 step 2
        map(x,y)=0
    next
next

if rn1>0 then
    a=0
    do
        w=rnd_range(rmw1,rw1)
        h=rnd_range(rmh1,rh1)
        valid(c).x=rnd_range(1,59-w)
        valid(c).y=rnd_range(1,19-h)
        if nocol1=1 then
            do
                w=rnd_range(rmw1,rw1)
                h=rnd_range(rmh1,rh1)
                valid(c).x=rnd_range(1,59-w)
                valid(c).y=rnd_range(1,19-h)
                collision=0
                for x=valid(c).x-1 to valid(c).x+w+1
                    for y=valid(c).y-1 to valid(c).y+h+1
                        if map2(x,y)=1 then 
                            collision=1
                        endif
                    next
                next
                if collision=0 then
                    for x=valid(c).x to valid(c).x+w
                        for y=valid(c).y to valid(c).y+h
                            map2(x,y)=1
                        next
                    next    
                endif
            loop until collision=0
        else
            collision=0
        endif
            
        if collision=0 then
            for x=valid(c).x to valid(c).x+w
                for y=valid(c).y to valid(c).y+h
                    if x=valid(c).x or y=valid(c).y or x=valid(c).x+w or y=valid(c).y+h then
                        map(x,y)=1
                    else
                        if map(x,y)=1 then map(x,y)=0
                    endif
            

                next
            next    
            
            if rnd_range(1,100)<roundedcorners1  and h>4 and w>4 then
                map(valid(c).x+1,valid(c).y+1)=1
                map(valid(c).x+w-1,valid(c).y+1)=1
                map(valid(c).x+w-1,valid(c).y+h-1)=1
                map(valid(c).x+1,valid(c).y+h-1)=1
            endif
            a+=1
        endif
    loop until a>=rn1
endif

if rn2>0 then
    a=0
    do
        w=rnd_range(rmw2,rw2)
        h=rnd_range(rmh2,rh2)
        valid(c).x=rnd_range(1,59-w)
        valid(c).y=rnd_range(1,19-h)
        if nocol2=1 then
            collision=0
            for x=valid(c).x-1 to valid(c).x+w+1
                for y=valid(c).y-1 to valid(c).y+h+1
                    if map2(x,y)=1 then 
                        collision=1
                    endif
                next
            next
            if collision=0 then
                for x=valid(c).x to valid(c).x+w
                    for y=valid(c).y to valid(c).y+h
                        map2(x,y)=1
                    next
                next    
            endif
        else
            collision=0
        endif
            
        if collision=0 then
            for x=valid(c).x to valid(c).x+w
                for y=valid(c).y to valid(c).y+h
                    if x=valid(c).x or y=valid(c).y or x=valid(c).x+w or y=valid(c).y+h then
                        map(x,y)=1
                    else
                        if map(x,y)=1 then map(x,y)=0
                    endif
            

                next
            next    
            
            if rnd_range(1,100)<roundedcorners2  and h>4 and w>4 then
                map(valid(c).x+1,valid(c).y+1)=1
                map(valid(c).x+w-1,valid(c).y+1)=1
                map(valid(c).x+w-1,valid(c).y+h-1)=1
                map(valid(c).x+1,valid(c).y+h-1)=1
            endif
            a+=1
        endif
    loop until a>=rn2
endif

do
    lastvalid=0
    for x=1 to 59
        for y=1 to 19
            if checkvalid(x,y,map()) then
                lastvalid+=1
                valid(lastvalid).x=x
                valid(lastvalid).y=y
            endif
        next
    next
    if lastvalid>=1 then
        c=rnd_range(1,lastvalid)
        x=valid(c).x
        y=valid(c).y
        lastneig=0
        if checkvalid(x-2,y,map()) then
            lastneig+=1
            valneigh(lastneig).x=x-2
            valneigh(lastneig).y=y
        endif
        
        if checkvalid(x+2,y,map()) then
            lastneig+=1
            valneigh(lastneig).x=x+2
            valneigh(lastneig).y=y
        endif
        
        if checkvalid(x,y+2,map()) then
            lastneig+=1
            valneigh(lastneig).x=x
            valneigh(lastneig).y=y+2
        endif
        
        if checkvalid(x,y-2,map()) then
            lastneig+=1
            valneigh(lastneig).x=x
            valneigh(lastneig).y=y-2
        endif
        
        if lastneig>0 then
            c=rnd_range(1,lastneig)
            if valneigh(c).x>x then map(x+1,y)=0
            if valneigh(c).x<x then map(x-1,y)=0
            if valneigh(c).y>y then map(x,y+1)=0
            if valneigh(c).y<y then map(x,y-1)=0
        else
            'print "No valid neighbour"
        endif

    endif
    
loop until lastvalid=0 or lastneig=0
    
do
    ff=1
    
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=-1 then map(x,y)=0
            'if map(x,y)=-2 then map(x,y)=2
            
        next
    next

    floodfill3(1,1,map())
    
    
    
    lastvalid=0
    for x=1 to 59 
        for y=1 to 19 
            if checkdoor(x,y,map()) then
                lastvalid+=1
                valid(lastvalid).x=x
                valid(lastvalid).y=y
                
            endif
        next
    next
    

    
    
    
    if lastvalid>0 then
        c=rnd_range(1,lastvalid)
        if rnd_range(1,100)<doorchance then
            map(valid(c).x,valid(c).y)=2
        else
            map(valid(c).x,valid(c).y)=0
        endif
    endif

    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then ff=0
        next
    next
    
loop until ff=1 or lastvalid=0

for x=0 to 60
    for y=0 to 20
        if map(x,y)=-1 then map(x,y)=0
        if map(x,y)=-2 then map(x,y)=2
    next
next

if culdesacruns>0 then
for a=0 to culdesacruns
    for x=0 to 60
        for y=0 to 20
            map2(x,y)=map(x,y)
        next
    next
    for x=1 to 59
        for y=1 to 19
            ff=0
            for x1=x-1 to x+1
                for y1=y-1 to y+1
                    if map(x1,y1)=1 then ff=ff+1
                next
            next
            if map(x,y)=1 or map(x,y)=0 then
                if map(x-1,y)<>2 and map(x+1,y)<>2 and map(x,y-1)<>2 and map(x,y+1)<>2 then
                    if ff<3 and map(x,y)=1 then 
                        map2(x,y)=0
                        map3(x,y)=1
                    endif
                    if ff>=7 and map(x,y)=0 then 
                        map2(x,y)=1
                        map3(x,y)=1
                    endif
                    if map(x,y)=0 then
                        if map(x-1,y-1)=1 and map(x-1,y)=1 and map(x-1,y+1)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
                            map2(x,y)=1
                            map3(x,y)=1
                        endif
                        if map(x+1,y-1)=1 and map(x+1,y)=1 and map(x+1,y+1)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
                            map2(x,y)=1
                            map3(x,y)=2
                        endif
                        if map(x+1,y-1)=1 and map(x,y-1)=1 and map(x-1,y-1)=1 and map(x-1,y)=1 and map(x+1,y)=1 then
                            map2(x,y)=1
                            map3(x,y)=3
                        endif
                        if map(x+1,y+1)=1 and map(x,y+1)=1 and map(x-1,y+1)=1 and map(x-1,y)=1 and map(x+1,y)=1 then
                            map2(x,y)=1
                            map3(x,y)=4
                        endif
                    endif
                endif
            endif
        next
            
    next

    for x=0 to 60
        for y=0 to 20
            map(x,y)=map2(x,y)
        next
    next
next
endif

if nosmallrooms>0 then
for a=0 to nosmallrooms

    for x=0 to 60
        for y=0 to 20
            map2(x,y)=map(x,y)
        next
    next
    for x=1 to 59
        for y=1 to 19
            ff=0
            for x1=x-1 to x+1
                for y1=y-1 to y+1
                    if map(x1,y1)=1 then ff=ff+1
                next
            next
            if ff=7 and nosmallrooms=1 then
                if map(x-1,y)=2 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
                    map2(x-1,y)=1
                    map3(x-1,y)=2
                    map2(x,y)=1
                    map3(x,y)=2
                endif
                if map(x-1,y)=1 and map(x+1,y)=2 and map(x,y-1)=1 and map(x,y+1)=1 then
                    map2(x+1,y)=1
                    map3(x+1,y)=3
                    map2(x,y)=1
                    map3(x,y)=3
                endif
                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=2 and map(x,y+1)=1 then
                    map2(x,y-1)=1
                    map3(x,y-1)=4
                    map2(x,y)=1
                    map3(x,y)=4
                endif
                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=2 then
                    map2(x,y+1)=1
                    map3(x,y+1)=5
                    map2(x,y)=1
                    map3(x,y)=5
                endif
            endif
        next
    next

    for x=0 to 60
        for y=0 to 20
            map(x,y)=map2(x,y)
        next
    next

next
endif


for x=0 to 58
    for y=0 to 18
        if map(x+1,y+1)=1 then
        'if rnd_range(1,100)<loopchance and map(x,y)=1 and map(x+1,y)=0 and map(x+2,y)=1 and map(x,y+1)=1 and map(x+1,y+1)=1 and map(x+2,y+1)=1 and map(x+2,y)=1 and map(x+2,y+1)=0 and map(x+3,y+2)=1 then map2(x+1,y+1)=0
        'if rnd_range(1,100)<loopchance and map(x,y)=1 and map(x,y+1)=0 and map(x,y+2)=1 and map(x+1,y)=1 and map(x+1,y+1)=1 and map(x+1,y+2)=1 and map(x+2,y)=1 and map(x+2,y+1)=0 and map(x+2,y+2)=1 then map2(x+1,y+1)=0
            if map(x+1,y)=1 and map(x+1,y+2)=1 and map(x,y+1)=0 and map(x+2,y+1)=0 then
                if rnd_range(1,100)<loopdoor and adddoor=1 then map(x+1,y+1)=2 
                if rnd_range(1,100)<loopchance and addloop=1 then map(x+1,y+1)=0
            endif
                
            if map(x,y+1)=1 and map(x+2,y+1)=1 and map(x+1,y)=0 and map(x+1,y+2)=0 then
                if rnd_range(1,100)<loopdoor and adddoor=1 then map(x+1,y+1)=2 
                if rnd_range(1,100)<loopchance and addloop=1 then map(x+1,y+1)=0
            endif
            
        endif
    next
    
next

x1=0
y1=0
for x=0 to 30
    for y=0 to 10
        if map(x,y)=0 and x1=0 and y1=0 then
            x1=x
            y1=y
        endif
    next
next    

floodfill3(x1,y1,map())
    
for x=0 to 60
    for y=0 to 20
        if map(x,y)=-1 then map(x,y)=0
        if map(x,y)=-2 then map(x,y)=2
    next
next

if t=1 then
    for xx=0 to 60
        for yy=0 to 20
            if map(xx,yy)=1 then planetmap(xx,yy,slot)=-50
            if map(xx,yy)=0 then planetmap(xx,yy,slot)=-202
            if xx>1 and yy>1 and xx<60 and yy<20 and map(xx,yy)=0 then
                coll=0
                for x=xx-1 to xx+1
                    for y=yy-1 to yy+1
                        if map(x,y)<>0 then coll+=1
                    next
                next
                if coll=0 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-223
                if coll=7 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-221
                if coll=4 and rnd_range(1,100)<60 then planetmap(xx,yy,slot)=-248
            endif
            if map(xx,yy)=3 then planetmap(xx,yy,slot)=-47
            if map(xx,yy)=4 then planetmap(xx,yy,slot)=-156
        next
    next
endif
    

end sub

sub makecomplex3(slot as short,cn as short, rc as short,columns as short,tileset as short)

dim map(60,20) as short
dim filled as short
dim as short x,y,h,w,coll,xx,yy,dx,dy,a,x1,x2,y1,y2,made,t
dim as integer giveup,giveup2
dim as single d
dim route(128) as _cords
dim lastr as short

rc=0
columns=0
coll=0
x=rnd_range(20,40)
y=rnd_range(8,16)
h=rnd_range(3,4)
w=rnd_range(3,5)
if x+w>59 then x=59-w
if y+h>19 then y=19-h
for xx=x to x+w
    for yy=y to y+h
        map(xx,yy)=1
    next
next
do
    giveup=0
    do
        coll=0
        x=rnd_range(1,59)
        y=rnd_range(1,19)
        h=rnd_range(2,6)
        w=rnd_range(3,9)
        if x+w>59 then x=59-w
        if y+h>19 then y=19-h
        for xx=x-4 to x+w+4
            for yy=y-3 to y+h+3
                if xx>0 and yy>0 and xx<60 and yy<20 then
                    if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
        giveup+=1
    loop until coll=0 or giveup>100
    for xx=0 to 60
        for yy=0 to 20
            if xx>=x and xx<=x+w and yy>=y and yy<=y+h and giveup<=100 then map(xx,yy)=2
        next
    next
    if rnd_range(1,100)<rc and giveup<=100 and h>=3 and w>3 then
        map(x,y)=0
        map(x+w,y)=0
        map(x+w,y+h)=0
        map(x,y+h)=0
    endif
    
        
    
    route(0).x=x+rnd_range(1,w-1)
    route(0).y=y+rnd_range(1,h-1)
    d=999999
    for xx=0 to 60
        for yy=0 to 20
            if map(xx,yy)=1 then
                route(1).x=xx
                route(1).y=yy
                if distance(route(0),route(1))<d then
                    d=distance(route(0),route(1))
                    route(2)=route(1)
                endif
            endif
        next
    next
    
    
    if giveup<=100 then
    do
        dx=route(0).x-route(2).x
        dy=route(0).y-route(2).y
        if abs(dx)>=abs(dy) then
            do
                dx=route(0).x-route(2).x
                map(route(0).x,route(0).y)=2
                if dx>0 then route(0).x=route(0).x-1
                if dx<0 then route(0).x=route(0).x+1
            loop until dx=0 or map(route(0).x,route(0).y)<>0 
        endif
        if abs(dx)<abs(dy) then
            do 
                dy=route(0).y-route(2).y
                map(route(0).x,route(0).y)=2
                if dy>0 then route(0).y=route(0).y-1
                if dy<0 then route(0).y=route(0).y+1
            loop until dy=0 or map(route(0).x,route(0).y)<>0
        endif
    
    loop until dx=0 and dy=0
    
    if rnd_range(1,100)<columns then
        if h>=5 and w>h and frac(w/2)=0 then
            for xx=x+1 to x+w-1 step 2
                map(xx,y+1)=3
                map(xx,y+h-1)=3
            next
        endif
        if w>=5 and h>w and frac(h/2)=0 then 
            for yy=y+1 to y+h-1 step 2
                map(x+1,yy)=3
                map(x+w-1,yy)=3
            next
        endif
    endif
    endif
    
    filled=0
    for xx=0 to 60
        for yy=0 to 20
            if map(xx,yy)=2 then map(xx,yy)=1
            if map(xx,yy)=1 then filled=filled+1
        next
    next

    giveup2+=1
loop until filled>750 or giveup2>500


made=0
do
    do
        y=rnd_range(1,19)
        x=rnd_range(1,59)
        coll=0
        for xx=x-1 to x+1
            for yy=y-2 to y+2
                if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
    loop until coll=0
    x1=0
    x2=0
    for xx=x to 59
        if x1=0 and (map(xx,y)<>0 or map(xx,y+1)<>0 or map(xx,y-1)<>0) then x1=xx
    next
    for xx=x to 1 step -1
        if x2=0 and (map(xx,y)<>0 or map(xx,y+1)<>0 or map(xx,y-1)<>0) then x2=xx
    next
    
    if x1>x2 then swap x1,x2
    if x1>1 and x2<59 then
        map(x1,y)=1
        map(x2,y)=1
        for x=x1 to x2
            if map(x,y)=0 and map(x,y-1)=0 and map(x,y+1)=0 then map(x,y)=2
        next
        made=made+1
    endif

    do
        y=rnd_range(1,19)
        x=rnd_range(1,59)
        coll=0
        for xx=x-2 to x+2
            for yy=y-1 to y+1
                if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                if map(xx,yy)<>0 then coll=1
                endif
            next
        next
        
    loop until coll=0
    y1=0
    y2=0
    for yy=y to 19
        if y1=0 and (map(x,yy)<>0 or map(x+1,yy)<>0 or map(x-1,yy)<>0) then y1=yy
    next
    for yy=y to 1 step -1
        if y2=0 and (map(x,yy)<>0 or map(x-1,yy)<>0 or map(x+1,yy)<>0) then y2=yy
    next
    
    if y1>y2 then swap y1,y2
    if y1>1 and y2<19 then
        map(x,y1)=1
        map(x,y2)=1
        for y=y1 to y2
            if map(x,y)=0 and map(x-1,y)=0 and map(x+1,y)=0 then map(x,y)=2
        next
        made=made+1
    endif
loop until made>=cn



for xx=1 to 59
    for yy=1 to 19
        if map(xx,yy)=1 or map(xx,yy)=2 then
            if map(xx-1,yy)=0 and map(xx+1,yy)=0 then
                if map(xx,yy+1)=1 and (map(xx-1,yy+1)=1 or map(xx+1,yy+1)=1) then map(xx,yy)=4
                if map(xx,yy-1)=1 and (map(xx-1,yy-1)=1 or map(xx+1,yy-1)=1) then map(xx,yy)=4
            endif
            if map(xx,yy+1)=0 and map(xx,yy-1)=0 then
                if map(xx-1,yy)=1 and (map(xx-1,yy+1)=1 or map(xx-1,yy-1)=1) then map(xx,yy)=4
                if map(xx+1,yy)=1 and (map(xx+1,yy+1)=1 or map(xx+1,yy-1)=1) then map(xx,yy)=4
            endif
            if map(xx,yy)=4 and (map(xx-1,yy)=4 or map(xx+1,yy)=4 or map(xx,yy-1)=4 or map(xx,yy+1)=4) then map(xx,yy)=1 
        endif
    next
next

if tileset=1 then
    
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=1 and rnd_range(1,100)<5+planets(slot).depth then planetmap(x,y,slot)=-248
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-221
            endif
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-223
            endif
            if map(x,y)=4 then planetmap(x,y,slot)=-156
            
        next
    next
endif

if tileset=2 then
    a=215
    planets(slot).flags(10)=rnd_range(4,6)
    planets(slot).flags(11)=rnd_range(4,6)
    planets(slot).flags(12)=rnd_range(4,6)
    planets(slot).flags(13)=rnd_range(4,6)
    planets(slot).flags(14)=rnd_range(4,6)
    planets(slot).flags(15)=rnd_range(4,6)
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=1 and rnd_range(1,100)<5+planets(slot).depth then planetmap(x,y,slot)=-248
            if map(x,y)=1 and rnd_range(1,100)<10 then 
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 then planetmap(x,y,slot)=-221
            endif
            if map(x,y)=4 then planetmap(x,y,slot)=-156
            if map(x,y)=1 then
                if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 and a<=219 then 
                    planetmap(x,y,slot)=-a
                    a+=1
                endif
            endif
                    
        next
    next
endif

if tileset=3 then
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=0 then planetmap(x,y,slot)=-50
            if map(x,y)=1 then planetmap(x,y,slot)=-202
            if map(x,y)=2 then planetmap(x,y,slot)=-202
            if map(x,y)=4 then planetmap(x,y,slot)=-202
        next
    next
endif


end sub

sub makecomplex4(slot as short,rn as short,tileset as short)
        
    dim as short map(60,20)
    dim as short map2(60,20)
    dim valid(1300) as _cords
    dim as short x,y,lastvalid,c,d,cc,h,w,xx,yy,coll,filled
    dim center(25) as _cords
    for x=0 to 60
        for y=0 to 20
            map(x,y)=1
        next
    next
    
    for x=1 to 59 step 2
        for y=1 to 19 step 2
            map(x,y)=0
        next
    next
    
    do
        lastvalid=0
        cc=0
        for x=1 to 59 step 2
            for y=1 to 19 step 2
                if checkbord(x,y,map())>0 then
                    lastvalid+=1
                    valid(lastvalid).x=x
                    valid(lastvalid).y=y
                    if checkbord(x,y,map())=5 then cc+=1
                
                endif
            next
        next
        if lastvalid>0 then
            c=rnd_range(1,lastvalid)
            if checkbord(valid(c).x,valid(c).y,map())=5 then
                d=rnd_range(1,4)
            else
                d=checkbord(valid(c).x,valid(c).y,map())
            endif
            if d=1 and valid(c).x+1<60 then 
                if checkbord(valid(c).x+2,valid(c).y,map())=5 then map(valid(c).x+1,valid(c).y)=0
            endif
            if d=2 and valid(c).x-1>0 then 
                if checkbord(valid(c).x-2,valid(c).y,map())=5 then map(valid(c).x-1,valid(c).y)=0
            endif
            if d=3 and valid(c).y+1<20 then 
                if checkbord(valid(c).x,valid(c).y+2,map())=5 then map(valid(c).x,valid(c).y+1)=0
            endif
            if d=4 and valid(c).y-1>0 then 
                if checkbord(valid(c).x,valid(c).y-2,map())=5 then map(valid(c).x,valid(c).y-1)=0
            endif
        endif
    loop until lastvalid<=200 or cc<=5
    
    for x=1 to 59 step 2
        for y=1 to 19 step 2
            if checkbord(x,y,map())=5 then map(x,y)=1
        next
    next
    
    if rn>0 then
        for c=0 to rn
            do
                x=rnd_range(1,28)*2
                y=rnd_range(1,8)*2
                h=rnd_range(2,3)*2
                w=rnd_range(1,4)*2
                if x+w>60 then x=58-w
                if y+h>20 then y=18-h
                if x<0 then x=0
                if y<0 then y=0
                coll=0
                for xx=x to x+w
                    for yy=y to y+w
                        if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                            if map2(xx,yy)=1 then coll=1
                        endif
                    next
                next
            loop until coll=0
            for xx=x to x+w
                for yy=y to y+h
                    if xx>=0 and yy>=0 and xx<=60 and yy<=20 then
                    if xx=x or yy=y or xx=x+w or yy=y+h then 
                        map(xx,yy)=1
                    else
                        map(xx,yy)=0
                    endif
                    map2(xx,yy)=1
                    endif
                next
            next
            center(c).x=x+w/2
            center(c).y=y+w/2
        next
    endif
    for x=1 to 59 step 2
        for y=1 to 19 step 2
            if checkbord(x,y,map())=5 then map(x,y)=1
        next
    next
    
    for c=0 to 5
        do
            x=rnd_range(1,59)
            y=rnd_range(1,20)
        loop until map(x,y)=0
        center(c).x=x
        center(c).y=y
    next
    c=0
    do
        filled=0
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=-2 then map(x,y)=2
                if map(x,y)=-1 then filled+=1
                if map(x,y)=-1 then map(x,y)=0
            next
        next
        c+=1
        if c>5 then c=0
        floodfill3(center(c).x,center(c).y,map())
        lastvalid=0
        for x=1 to 59 
            for y=1 to 19 
                map2(x,y)=0
                if checkdoor(x,y,map()) then
                    lastvalid+=1
                    valid(lastvalid).x=x
                    valid(lastvalid).y=y
                    map2(x,y)=1
                endif
            next
        next
        d=rnd_range(1,lastvalid)
        map(valid(d).x,valid(d).y)=2
        
    loop until lastvalid=0 or filled>=1000
    
    if tileset=1 then
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=0 then planetmap(x,y,slot)=4
                if map(x,y)=1 then planetmap(x,y,slot)=50
                if map(x,y)=2 then planetmap(x,y,slot)=156
                if map(x,y)=-2 then planetmap(x,y,slot)=156
                if map(x,y)=-2 then planetmap(x,y,slot)=156
            next
        next
        planetmap(0,0,slot)=50
    endif
end sub

sub makelabyrinth(slot as short)
    
    dim map(60,20) as short
    dim as short x,y,a,b,c,count
    dim p as _cords
    dim p2 as _cords
    dim border as short   
    dim t as integer
    
    planets(slot).darkness=5
    t=timer
    for x=0 to 60
        for y=0  to 20
            map(x,y)=1
            
        next
    next
    
    map(rnd_range(1,59),rnd_range(1,19))=0
    
    if slot=specialplanet(3) or slot=specialplanet(4) then
        map(rnd_range(1,59),rnd_range(1,19))=0
        map(rnd_range(1,59),rnd_range(1,19))=0
        map(rnd_range(1,59),rnd_range(1,19))=0
    endif
    do
        count=count+1
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=1 then
            if map(p.x-1,p.y)=0 or map(p.x,p.y+1)=0 or map(p.x+1,p.y)=0 or map(p.x,p.y-1)=0 then
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x-1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x+1,p.y)=1 and map(p.x+1,p.y-1)=1 and map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x,p.y-1)=1 and map(p.x+1,p.y-1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y+1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and  map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
            endif
            if map(p.x,p.y)=0 then
                c=0
                for x=0 to 60
                    for y=0  to 20
                        if map(x,y)=0 then c=c+1
                    next
                next
            endif
        endif
    loop until c+rnd_range(1,20)>575 or timer>t+15
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            if map(p.x-1,p.y-1)=2 or map(p.x,p.y-1)=2 or map(p.x+1,p.y-1)=2 or map(p.x+1,p.y)=2 or map(p.x+1,p.y-1)=2 or map(p.x,p.y+1)=2 or map(p.x+1,p.y)=2 or map(p.x-1,p.y+1)=2 then
                map(p.x,p.y)=3
            else
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then map(p.x,p.y)=2 
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1 then map(p.x,p.y)=2 
            endif
            if map(p.x,p.y)=2 then c=c+1
        endif
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+20
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            if map(p.x-1,p.y-1)=5 or map(p.x,p.y-1)=5 or map(p.x+1,p.y-1)=5 or map(p.x+1,p.y)=5 or map(p.x+1,p.y-1)=5 or map(p.x,p.y+1)=5 or map(p.x+1,p.y)=5 or map(p.x-1,p.y+1)=5 then
                map(p.x,p.y)=3
            else
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then map(p.x,p.y)=5 
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1 then map(p.x,p.y)=5 
            endif
            if map(p.x,p.y)=5 then c=c+1
        endif
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+25
    
    c=0
    do
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if map(p.x,p.y)=0 then
            map(p.x,p.y)=3
            c=c+1
        endif
    
    loop until c>12+rnd_range(1,6)+rnd_range(1,6) or t>timer+30
    
    for c=1 to 20
        p.x=rnd_range(1,59)
        p.y=rnd_range(1,19)
        if  map(p.x,p.y)=0 and map(p.x+1,p.y)=0 and map(p.x,p.y+1)=0 and map(p.x-1,p.y)=0 and map(p.x,p.y-1)=0 then
            map(p.x,p.y)=3
        endif
    next
    for x=0 to 60
       for y=0 to 20
           if map(x,y)=0 then planetmap(x,y,slot)=-4     
           if map(x,y)=1 then planetmap(x,y,slot)=-51     
           if map(x,y)=2 then 
               planetmap(x,y,slot)=-156 
               if rnd_range(1,100)<45 then planetmap(x,y,slot)=-157 
           endif
           if map(x,y)=3 then planetmap(x,y,slot)=-154     
           if map(x,y)=5 then planetmap(x,y,slot)=-151                    
       next
    next
end sub

sub makeroots(slot as short)
    dim as _cords p,p2
    dim as short a,b,c,x,y
    if planets(slot).depth=0 then planets(slot).depth=1
    for x=0 to 60
        for y=0 to 20
            if x=0 or y=0 or x=60 or y=20 then
                planetmap(x,y,slot)=-152
            else
                planetmap(x,y,slot)=-3
            endif
        next
    next
            
    for a=0 to 730
        do
            c=0
            p=rnd_point
            for b=1 to 9
                if b<>5 then
                    p2=movepoint(p,b)
                    if planetmap(p2.x,p2.y,slot)<>-3 then c=c+1
                endif
            next
        loop until c>0 and c<4
        planetmap(p.x,p.y,slot)=-152
    next
    for a=0 to 9
        p=rnd_point
        planetmap(p.x,p.y,slot)=-59
    next
    for a=0 to 29+rnd_range(1,6)
        p=rnd_point
        planetmap(p.x,p.y,slot)=-146
    next
    if show_specials=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
end sub

            
sub makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short, blocked as short=1)
    dim as short x,y,a,count,loops,b,slot,n,door,c,d,notu
    dim map2(60,20) as short 'hardness
    dim map3(60,20) as short 'to make vault
    dim seedps(64) as _cords
    dim r as _rect
    dim as _cords p1,p2,p3,rp,sp,ep
    dim gascloud as short
    gascloud=spacemap(player.c.x,player.c.y)
    slot=enter.m
    if show_all=1 then dprint "Made cave at "&slot
        
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault=r
    
                     
    for a=0 to rnd_range(1,6)+rnd_range(1,6)+gascloud
        p1=rnd_point
        placeitem(makeitem(96,-2,-3),p1.x,p1.y,slot)
    next
    
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=5
            map2(x,y)=100
        next
    next

    for a=0 to 20+tumod
        seedps(a).x=rnd_range(1,59)
        seedps(a).y=rnd_range(1,19)
        planetmap (seedps(a).x,seedps(a).y,slot)=0
    next
    planetmap(enter.x,enter.y,slot)=0
    
    if (rnd_range(1,100)<45 or spemap>0) and blocked=0 then
        lastportal=lastportal+1
        lastplanet=lastplanet+1
        a=lastportal
        portal(a).desig="A natural tunnel. "
        portal(a).tile=111
        portal(a).col=7
        portal(a).from.s=enter.s
        portal(a).from.m=enter.m
        portal(a).from.x=rnd_range(1,59)
        portal(a).from.y=rnd_range(1,19)
        portal(a).dest.m=lastplanet
        portal(a).dest.s=portal(a).from.s
        portal(a).dest.x=rnd_range(1,59)
        portal(a).dest.y=rnd_range(1,19)
        portal(a).discovered=show_portals
        map(portal(a).from.s).discovered=3
        planetmap(portal(a).from.x,portal(a).from.y,slot)=0
    endif
    
    do
        count=0
    for x=1 to 59
        for y=1 to 19
            p1.x=x
            p1.y=y
            for a=1 to 9
                if a<>5 then
                    p2=movepoint(p1,a)
                    map2(x,y)=map2(x,y)-(5-planetmap(p2.x,p2.y,slot))*10
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if rnd_range(1,100)>map2(x,y) then 
                planetmap(x,y,slot)=planetmap(x,y,slot)-1
                
                if planetmap(x,y,slot)<0 then 
                    count=count+1
                    planetmap(x,y,slot)=0
                endif
            endif
        next
    next
    loops=loops+1
    loop until loops>6+dimod
    'add vault
    for x=0 to 60
        for y=0 to 20
            map3(x,y)=planetmap(x,y,slot)
            if map3(x,y)>2 then map3(x,y)=5
        next
    next
    
    r=findrect(5,map3())
    
    'add tunnels
    notu=tumod+rnd_range(5,10)
    if notu>64 then notu=64
    for a=0 to notu
        
            b=rnd_range(0,20+tumod)
            sp.x=seedps(b).x
            sp.y=seedps(b).y
            c=rnd_range(0,20+tumod)
            ep.x=seedps(a+1).x
            ep.y=seedps(a+1).y
        do 
            
            d=nearest(sp,ep)
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            ep=movepoint(ep,d)
            planetmap(ep.x,ep.y,slot)=0
        loop until ep.x=sp.x and ep.y=sp.y
    next
    
    

    'add noise
    for x=0 to 60
        for y=0 to 20
            n=rnd_range(1,10)+rnd_range(1,10)+rnd_range(1,10)
            'if n>22 then planetmap(x,y,slot)=planetmap(x,y,slot)+1
            if n<15 then planetmap(x,y,slot)=planetmap(x,y,slot)-1
            if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=0
            if planetmap(x,y,slot)>5 then planetmap(x,y,slot)=5
        next
    next
    
    if (r.h*r.w>15 and rnd_range(1,100)<38) or make_vault=1 then 'realvault
        if r.h>3 or r.w>3 then 'really really vault
            sp.x=r.x+r.w/2
            sp.y=r.y+r.h/2
            ep.x=30
            ep.y=15
            for a=0 to 20+tumod
                if distance(seedps(a),sp)<distance(ep,sp) then ep=seedps(a)
            next
            makevault(r,slot,ep,rnd_range(1,6))   
        endif
    endif

    
    
    'translate from 0 to 5 to real tiles
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)=15 then 
                planetmap(x,y,slot)=-4
                placeitem(makeitem(96,planets(a).depth),x,y,slot)
            endif
            if planetmap(x,y,slot)=0 then planetmap(x,y,slot)=-4
            if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=-(46+planetmap(x,y,slot))
        next
    next
    for a=0 to gascloud+Rnd_range(1,5+planets(slot).depth)+rnd_range(1,5+planets(slot).depth)
        placeitem(makeitem(96,planets(a).depth),rnd_range(0,60),rnd_range(0,20),slot)
    next
    
    if rnd_range(1,100)<3*planets(slot).depth then
        p1=rnd_point
        b=rnd_range(1,3)
        
        if rnd_range(1,200)<6 then
            p1=rnd_point
            b=rnd_range(1,3)+rnd_range(0,2)
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=b then 
                            if rnd_range(1,100)<88 then planetmap(x,y,slot)=-13
                            if rnd_range(1,100)<15 then placeitem(makeitem(96,-3,-2),x,y,slot)
                        endif
                    endif
                next
            next
        endif
    endif
    if abs(froti)=1 or abs(froti)=2 then
        if rnd_range(1,100)<abs(froti)*8 then
            do
                p1=rnd_point
            loop until p1.x=0 or p1.y=0 or p1.x=60 or p1.y=20
            do
                p2=rnd_point
            loop until (p2.x=0 or p2.y=0 or p2.x=60 or p2.y=20) and (p1.x<>p2.x and p1.y<>p2.y)
            a=0
            do                 
               a=a+1
               d=nearest(p1,p2)
               if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
               
               p2=movepoint(p2,d)
               if planetmap(p2.x,p2.y,slot)=-52 or planetmap(p2.x,p2.y,slot)=-53 then
                   p2=rnd_point
               else
                   planetmap(p2.x,p2.y,slot)=-2
                    for b=1 to 9
                        p3=movepoint(p2,b)
                        if planetmap(p3.x,p3.y,slot)<>-52 or planetmap(p3.x,p3.y,slot)<>-53 then planetmap(p3.x,p3.y,slot)=planetmap(p3.x,p3.y,slot)+rnd_range(1,6)
                        if planetmap(p3.x,p3.y,slot)>-48 then planetmap(p3.x,p3.y,slot)=-1
                    next
               endif
            loop until (p1.x=p2.x and p1.y=p2.y) or a>900
        endif
    endif
    
    if abs(froti)=5 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,slot)=-4 then
                    if rnd_range(1,100)<3 then planetmap(x,y,slot)=-59 'Leafy tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-5 'Special tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-5 'Tree
                    if rnd_range(1,100)<5 then planetmap(x,y,slot)=-3 'Dirt
                    if rnd_range(1,100)<15 then planetmap(x,y,slot)=-11 'Grass
                endif
            next
        next
    endif
    
    if rnd_range(1,100)<33 then
    
        for b=1 to rnd_range(1,6)+rnd_range(1,6)
            select case rnd_range(1,100)
            case 1 to 33 
                c=-87
            case 34 to 66
                c=-88
            case else
                c=-97
            end select
            p1=rnd_point
            d=rnd_range(1,4)
            for x=p1.x-d to p1.x+d
                for y=p1.y-d to p1.y+d
                    p2.x=x
                    p2.y=y
                    if x>=0 and y>=0 and y<=20 and x<=60 and distance(p1,p2)<=d then
                        if planetmap(x,y,slot)=-4 then planetmap(x,y,slot)=c
                    endif
                        
                next
            next
                
        next
        
    endif
    planetmap(0,0,slot)=-51
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
end sub

sub makeplanetmap(a as short,orbit as short,spect as short)
    dim gascloud as short
    dim b1 as short
    dim b2 as short
    dim b3 as short
    dim o as short
    dim as short roll,planettype
    dim x as short
    dim y as short
    dim wx as short
    dim wy as short
    dim ice as short
    dim cnt as short
    dim as short b,c,d,e
    dim watercount as integer
    dim waterreplace as short
    dim as short prefmin
    dim as _cords p,p1,p2,p3,p4
    dim ti as short
    dim it as _items
    dim r1 as _rect
    dim t as _rect
    dim r(255) as _rect
    dim wmap(60,20) as short
    dim as short last,wantsize,larga,largb,lno,mi,old
    if a<=0 then 
       dprint "ERROR: Attempting to make planet map at "&a,14
       return
    endif
    prefmin=rnd_range(1,14)
    planettype=rnd_range(1,100)
    o=orbit
    planets(a).orbit=o
    planets(a).water=(rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)-orbit)*10
    if o<3 then planets(a).water=planets(a).water-rnd_range(70,100)
    if planets(a).water<0 then planets(a).water=0
    if planets(a).water>=75 then planets(a).water=75
    planets(a).atmos=rnd_range(1,21)
    if planets(a).atmos=21 then planets(a).atmos=2
    if planets(a).atmos=1 then planets(a).atmos=2
    if planets(a).atmos>16 then planets(a).atmos=planets(a).atmos-9
    
    if planets(a).atmos>16 then planets(a).atmos=16
    if planets(a).atmos<1 then planets(a).atmos=1
    planets(a).grav=(3+rnd_range(1,10)+rnd_range(1,8))/10
    planets(a).weat=0.5+(rnd_range(0,10)-5)/10
    if planets(a).weat<=0 then planets(a).weat=0.5
    if planets(a).weat>1 then planets(a).weat=0.9
    gascloud=abs(spacemap(player.c.x,player.c.y))
    if spect=1 then gascloud=gascloud-2
    if spect=2 then gascloud=gascloud-2
    if spect=3 then gascloud=gascloud-1
    if spect=4 then gascloud=gascloud-1
    if spect=5 then gascloud=gascloud-1
    if spect=6 then gascloud=gascloud
    if spect=7 then gascloud=gascloud+1
    if spect=8 then gascloud=gascloud+2
    planets(a).minerals=rnd_range(2,spect)+rnd_range(1,4)+disnbase(player.c)\7
    if gascloud<6 then planets(a).minerals+=gascloud
    
    roll=rnd_range(1,100)
    b1=3
    b2=4
    b3=12
    if roll<55 then
        b1=4
        b2=3
        b3=12
    endif
    if roll<75 then
        b1=12
        b2=3
        b3=4    
    endif
    'background
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-4
            if rnd_range(1,100)<60 then planetmap(x,y,a)=-b1
            if rnd_range(1,100)<20 then planetmap(x,y,a)=-b2            
            if rnd_range(1,100)<20 then planetmap(x,y,a)=-b3
        next
    next
    
    b2=planets(a).water    
    if b2>20 then
        cnt=0
        do    
            cnt=cnt+1
            wx=rnd_range(0,1)+rnd_range(0,1)+1
            wy=rnd_range(0,1)+rnd_range(0,1)+1
            p1.x=rnd_range(0,(60-(wx*2)))
            p1.y=rnd_range(0,(20-(wy*2)))
            p2.x=p1.x+wx-rnd_range(0,1)
            p2.y=p1.y+wy-rnd_range(0,1)
        
            if wx>wy then
                b1=cint(100/wx)
            else
                b1=cint(100/wy)
            endif
        
            for x=p1.x to p1.x+wx*2
                for y=p1.y to p1.y+wy*2
                    p3.x=x
                    p3.y=y
                    d=distance(p3,p2)
                    if rnd_range(1,100)<(101-(d*d*d*b1*b1)) then
                        planetmap(x,y,a)=rnd_range(1,2)*-1
                        watercount=watercount+1
                    endif
                next
            next
        loop until watercount>b2*12 or cnt>500
    else
        for b=1 to b2*12
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-2
            watercount=watercount+1
        next
    endif
  
    
    p1.x=rnd_range(1,59)
    p1.y=rnd_range(1,19)
    
    b1=100+rnd_range(25,50)+rnd_range(1,25)-planets(a).water
    if b1<=0 then b1=rnd_range(1,10)+rnd_range(1,10)
    
    for x=0 to b1
        planetmap(p1.x,p1.y,a)=-8
        if rnd_range(1,100)<planets(a).grav then planetmap(p1.x,p1.y,a)=-245
        if rnd_range(1,100)<(80-planets(a).water) then
            p1=movepoint(p1,5)
        else
            p1.x=rnd_range(1,59)
            p1.y=rnd_range(1,19)
        endif
    next
    for b=0 to rnd_range(0,b2)-10
        wx=rnd_range(0,2)+rnd_range(0,1)+1
        wy=rnd_range(0,2)+rnd_range(0,1)+1
        p1.x=rnd_range(0,(60-(wx*2)))
        p1.y=rnd_range(0,(20-(wy*2)))
        p2.x=p1.x+wx
        p2.y=p1.y+wy
        for x=p1.x to p1.x+wx*2
            for y=p1.y to p1.y+wy*2
                p3.x=x
                p3.y=y
                d=distance(p3,p2)
                if rnd_range(1,100)<=100-(d*25) then
                    if rnd_range(1,100)<50 then
                        planetmap(rnd_range(1,60),rnd_range(2,18),a)=-5
                    else
                        planetmap(rnd_range(1,60),rnd_range(2,18),a)=-6
                    endif
                endif
            next
        next
    next
    togglingfilter(a)
    togglingfilter(a,8,7)
    togglingfilter(a,5,6)
    
    if planettype>=22 and planettype<33 then
        makemossworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a)
        next b
    endif
    
    if planettype>=33 and planettype<44 then
        makeoceanworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a)
        next b
    endif
    
    if planettype>=44 and planettype<65 then 
        makecanyons(a,o)'canyons
        
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            do
               d=d+1
               p=rnd_point
            loop until planetmap(p.x,p.y,a)=-7 or planetmap(p.x,p.y,a)=-8 or d=10
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud,prefmin),p.x,p.y,a)
        next b
    
    endif
    if (planettype>=65 and planettype<80) or spect=8 then 
        makecraters(a,o)'craters
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            p=rnd_point
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a)
            if rnd_range(1,100)<66 then
                d=158
            else
                d=47
            endif
            for c=0 to rnd_range(0,2)
                planetmap(p.x,p.y,a)=d
                p=movepoint(p,5)
            next
        next b
    
    endif
    if planettype>=88 then 
        makeislands(a,o)'islands
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            do
               d=d+1
               p=rnd_point
            loop until planetmap(p.x,p.y,a)=-1 or planetmap(p.x,p.y,a)=-2 or d=10
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a)
        next b
    
    endif
    makeice(o,a)    
    planets(a).temp=((100-planets(a).water/1.5-planets(a).atmos*3)/100) 'dampened by atmos & water
    planets(a).temp=(spect-3)^3*3+planets(a).temp*(((9.1-o)^3)*2-400+rnd_range(1,100)- (((o-3)^2)+1)*rnd_range(10,25))
    if planets(a).temp>100 and (planettype>=22 and planettype<44) then planets(a).temp=planets(a).temp-rnd_range(1,planets(a).temp)-80
    if (planettype>=33 and planettype<44) then planets(a).temp=rnd_range(1,950)/10
    if spect=8 then planets(a).temp=-273
    
    'planets(a).temp=planets(a).temp*(-20.722*cos(o)+119.87*sin(o)+ (-0.0168*exp(o))+4.69)
    if planets(a).temp<-270 then planets(a).temp=-270+rnd_range(1,10)/10
    
    '
    ' "Normal" specials
    '
    
    ' 
    if a<>piratebase(0) then
        if planets(a).depth=0 and rnd_range(1,100)<15-disnbase(player.c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-86 '2nd landingparty
        endif
        
        if planets(a).depth=0 and rnd_range(1,100)<15-distance(player.c,map(sysfrommap(specialplanet(7))).c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-283
        endif
        
        if planets(a).depth=0 and rnd_range(1,100)<15-distance(player.c,map(sysfrommap(specialplanet(46))).c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-284
        endif
        
        if planets(a).depth=0 and rnd_range(1,150)<20-disnbase(player.c) then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        
        
        if rnd_range(1,200)<16 and planets(a).atmos>1 then
            if rnd_range(1,100)<66 then
                p1=rnd_point
                if p1.x>56 then p1.x=56
                if p1.y>16 then p1.y=16
                planetmap(p1.x+1,p1.y,a)=-8
                planetmap(p1.x+2,p1.y,a)=-8
                planetmap(p1.x,p1.y+1,a)=-8
                planetmap(p1.x+3,p1.y+1,a)=-8
                planetmap(p1.x,p1.y+2,a)=-8
                planetmap(p1.x+3,p1.y+2,a)=-8
                planetmap(p1.x+1,p1.y+3,a)=-8
                planetmap(p1.x+2,p1.y+3,a)=-8
                
                
                planetmap(p1.x+1,p1.y+1,a)=-2
                planetmap(p1.x+2,p1.y+1,a)=-2
                planetmap(p1.x+1,p1.y+2,a)=-2
                planetmap(p1.x+2,p1.y+2,a)=-2
            else
                p1=rnd_point
                b=rnd_range(3,5)
                for x=0 to 60
                    for y=0 to 20
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=b then planetmap(x,y,a)=-8
                        if distance(p1,p2)<b-1 then planetmap(x,y,a)=-2
                    next
                next
                if rnd_range(1,100)>33 then planetmap(p1.x,p1.y,a)=-7
                if rnd_range(1,100)>33 then placeitem(makeitem(96,10,-1),p1.x,p1.y,a)
            endif
        
        endif
        
        if rnd_range(1,200)<25 then 'Geyser
            for b=0 to rnd_range(1,8)+rnd_range(1,8)+planets(a).atmos
                p1=rnd_point
                planetmap(p1.x,p1.y,a)=-29
                if planets(a).temp<-100 then planetmap(p1.x,p1.y,a)=-30
                if planets(a).temp>-10 and planets(a).temp<130 then planetmap(p1.x,p1.y,a)=-28
            next
        endif
        
        if rnd_range(1,380)<disnbase(player.c)/5 then
            p2=rnd_point
            for b=1 to rnd_range(1,6)+rnd_range(1,3)
                p1=movepoint(p2,b)
                planetmap(p1.x,p1.y,a)=-148
            next
            planetmap(p2.x,p2.y,a)=-100 'Lone factory
        endif
        
        'pink sand
        if rnd_range(1,200)<9 then
            p1=rnd_point
            b=rnd_range(1,3)+rnd_range(0,2)+1
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then 
                            if rnd_range(1,100)<88 then planetmap(x,y,a)=-13
                            if rnd_range(1,100)<15 then placeitem(makeitem(96,-2,-3),x,y,a)
                        endif
                    endif
                next
            next
        endif
        
        planets(a).life=(((planets(a).water/10)+1)*planets(a).atmos)/10
        if planettype>=44 and planettype<65 then planets(a).life+=rnd_range(1,3)
    
        if planets(a).orbit>2 and planets(a).orbit<6 then planets(a).life=planets(a).life+rnd_range(1,5)
        if planets(a).life>10 then planets(a).life=10 
        planets(a).rot=(rnd_range(0,10)+rnd_range(0,5)+rnd_range(0,5)-4)/10
        if planets(a).rot<0 then planets(a).rot=0 
        
        'Flowers
        if rnd_range(1,200)<planets(a).atmos+planets(a).life and planets(a).atmos>1 then
            b=rnd_range(0,12)+rnd_range(0,12)+rnd_range(0,12)+1
            for x=1 to b
                p2=rnd_point
                if rnd_range(1,100)<88 then planetmap(p2.x,p2.y,a)=-146
            next
        endif
        
        'Stranded ship
        if rnd_range(1,300)<15-disnbase(player.c)/10 then
            p1=rnd_point
            b=rnd_range(1,100+player.turn/150)
            c=rnd_range(1,6)
            if c=5 or c=6 then c=1
            d=0
            if b>50 then d=4
            if b>75 then d=8
            if b>95 then d=12
            planetmap(p1.x,p1.y,a)=(-127-c-d)*-1
            'planetmap(p1.x,p1.y,a)=241
            for b=0 to 1+d
                if rnd_range(1,100)<11 then placeitem(rnd_item(21),p1.x,p1.y,a)
            next
        endif
        
        'Mining
        if rnd_range(1,200)<15-disnbase(player.c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-76
            for b=0 to rnd_range(1,4)
                if rnd_range(1,100)<25 then placeitem(rnd_item(6),p1.x,p1.y,a)
                if rnd_range(1,100)<35 then placeitem(makeitem(96,-2,-2),p1.x,p1.y,a)
            next
            if rnd_range(1,100)<42 then 
                p1=movepoint(p1,5)
                planetmap(p1.x,p1.y,a)=-68
            endif
            if rnd_range(1,100)<25 then
                for b=0 to rnd_range(1,4)
                    p1=rnd_point
                    if rnd_range(1,100)<25 then placeitem(makeitem(rnd_range(53,55)),p1.x,p1.y,a)
                next
            endif
        endif
        
        if rnd_range(1,100)<planets(a).grav then
            for b=1 to rnd_range(1,planets(a).grav*2)
                p=rnd_point
                planetmap(p.x,p.y,a)=-245
            next
        endif
        
'        'Castle : Belongs to adaptmap
'        if rnd_range(1,100)<300 then
'            p=rnd_point
'            if p.x>55 then p.x=55
'            if p.y>15 then p.y=15
'            p2.x=p.x+4
'            p2.y=p.y+4
'            if p2.x-p.x>10 then 
'                if rnd_range(1,100)<50 then
'                    p.x=p2.x-5
'                else
'                    p2.x=p.x+5
'                endif
'            endif
'            if p2.y-p.y>10 then 
'                if rnd_range(1,100)<50 then
'                    p.y=p2.y-5
'                else
'                    p2.y=p.y+5
'                endif
'            endif
'            dprint "Making vault from "&p.x &":"&p.y &" to "&p2.x &":"& p2.y
'            for x=p.x to p2.x
'                for y=p.y to p2.y
'                    planetmap(x,y,a)=-4
'                    if x=p.x or y=p.y or x=p2.x or y=p2.y then planetmap(x,y,a)=-49
'                next
'            next
'            planetmap(p.x-1,p.y,a)=-50
'            planetmap(p.x,p.y-1,a)=-50
'            planetmap(p.x-1,p.y-1,a)=-50
'            
'            planetmap(p2.x+1,p.y,a)=-50
'            planetmap(p2.x,p.y-1,a)=-50
'            planetmap(p2.x+1,p.y-1,a)=-50
'            
'            planetmap(p.x-1,p2.y,a)=-50
'            planetmap(p.x,p2.y+1,a)=-50
'            planetmap(p.x-1,p2.y+1,a)=-50
'            
'            planetmap(p2.x+1,p2.y,a)=-50
'            planetmap(p2.x,p2.y+1,a)=-50
'            planetmap(p2.x+1,p2.y+1,a)=-50
'            
'            select case rnd_range(1,4)
'            case 1
'                planetmap(p.x,rnd_range(p.y+1,p2.y-1),a)=-157
'            case 2
'                planetmap(p2.x,rnd_range(p.y+1,p2.y-1),a)=-157
'            case 3
'                planetmap(rnd_range(p.x+1,p2.x-1),p.y,a)=-157
'            case 4
'                planetmap(rnd_range(p.x+1,p2.x-1),p2.y,a)=-157
'            end select
'            planets(a).vault.x=p.x
'            planets(a).vault.y=p.y
'            planets(a).vault.w=p2.x-p.x
'            planets(a).vault.h=p2.y-p.y
'            planets(a).vault.wd(5)=2
'            planets(a).vault.wd(6)=-12
'            planets(a).mon_template(12)=makemonster(1,a)
'        endif
'        
        if rnd_range(1,100)<3 then
            p=rnd_point
            do
                planetmap(p.x,p.y,a)=-193
                p=movepoint(p,5)
            loop until rnd_range(1,100)<77
        endif
        
        'radioactive crater   
        if rnd_range(1,200)<1+disnbase(player.c)/10 then
            p1=rnd_point
            b=rnd_range(0,2)+rnd_range(0,2)+2
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then planetmap(x,y,a)=-160
                        if distance(p1,p2)=b then planetmap(x,y,a)=-159
                            
                    endif
                next
            next
            it=makeitem(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science+it.v2))*(it.v2*rnd_range(1,10-player.science))
            placeitem(it,p1.x,p1.y,a)        
        endif
        
        if is_special(a)=0 and a<>pirateplanet(0) and a<>pirateplanet(1) and a<>pirateplanet(2) and rnd_range(1,100)<15-disnbase(player.c)/2 then
            planet_event(a)
        endif
    endif
    
    planets(a).mapmod=0.5+planets(a).dens/10+planets(a).grav/5
    
    
    if o>6 and rnd_range(1,100)<35 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 or planetmap(x,y,a)=-20 then planetmap(x,y,a)=-26 
                if planetmap(x,y,a)=-2 or planetmap(x,y,a)=-21  then planetmap(x,y,a)=-26
                if planetmap(x,y,a)=-10 or planetmap(x,y,a)=-22 or planetmap(x,y,a)=-3 or planetmap(x,y,a)=-4 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-11 or planetmap(x,y,a)=-25 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-5 or planetmap(x,y,a)=-23 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-6 or planetmap(x,y,a)=-24 then planetmap(x,y,a)=-145
                if planetmap(x,y,a)=-12 or planetmap(x,y,a)=-13 then planetmap(x,y,a)=-14
                if planetmap(x,y,a)=-8 or planetmap(x,y,a)=-13 then planetmap(x,y,a)=-7
            next
        next
    endif
    
    
    if planets(a).temp<0 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 then planetmap(x,y,a)=-260
                if planetmap(x,y,a)=-2 then planetmap(x,y,a)=-27 
            next
        next
    endif
    
    
    if planets(a).temp>100 and planets(a).temp<180 then
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 or abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-12 
            next
        next
    endif
    
    if planets(a).temp>179 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 then 
                    planetmap(x,y,a)=-4
                    if rnd_range(1,100)>33 then planetmap(x,y,a)=-45
                endif
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-45
                if abs(planetmap(x,y,a))=5 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=6 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=10 then planetmap(x,y,a)=-4
                if abs(planetmap(x,y,a))=11 then planetmap(x,y,a)=-4
                if abs(planetmap(x,y,a))=22 then planetmap(x,y,a)=-4
            next
        next
    endif
    
    if planets(a).atmos>=8 then
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 then planetmap(x,y,a)=-20
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-21
                if abs(planetmap(x,y,a))=10 then planetmap(x,y,a)=-22
                if abs(planetmap(x,y,a))=11 then planetmap(x,y,a)=-25
                if abs(planetmap(x,y,a))=5 then planetmap(x,y,a)=-23
                if abs(planetmap(x,y,a))=6 then planetmap(x,y,a)=-24
                if abs(planetmap(x,y,a))=12 and rnd_range(1,100)>33 then planetmap(x,y,a)=-13
            next
        next
    endif
    
    for b=0 to planets(a).life
        if rnd_range(1,100)<(planets(a).life+1)*5 then 
            planets(a).mon_template(b)=makemonster(1,a)
            planets(a).mon_noamin(b)=rnd_range(1,planets(a).life)*planets(a).mon_template(b).diet
            planets(a).mon_noamax(b)=rnd_range(1,planets(a).life)*2*planets(a).mon_template(b).diet
            if planets(a).mon_noamin(b)>planets(a).mon_noamax(b) then swap planets(a).mon_noamin(b),planets(a).mon_noamax(b)
        endif
    next
    
    if rnd_range(1,100)<(planets(a).life+1)*5 then
        planets(a).mon_noamin(11)=1
        planets(a).mon_noamax(11)=1
        planets(a).mon_template(11)=makemonster(2,a)
    endif
    
    for b=1 to _NoPB
        if a=pirateplanet(b) then makeoutpost(a)
    next
    b=0
    for x=0 to 60
        for y=0 to 20
            if tiles(abs(planetmap(x,y,a))).walktru=1  or planetmap(x,y,a)=-1 or planetmap(x,y,a)=-20 or planetmap(x,y,a)=-25 or planetmap(x,y,a)=-27 then b=b+1
        next
    next
    planets(a).water=(b/1200)*100
    planets(a).darkness=3-cint((5-planets(a).orbit)/2)
    planets(a).dens=(planets(a).atmos-1)-6*((planets(a).atmos-1)\6)
    if spect=8 then
        makecraters(a,9)
        planets(a).darkness=5
        planets(a).orbit=9
        planets(a).temp=-270+rnd_range(1,10)/10
        planets(a).rot=-1
    endif    
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-planetmap(x,y,a)
            next
        next
    endif
    makespecialplanet(a)
    
    if is_special(a)=0 and distance(map(sysfrommap(a)).c,civ(0).home)<2*civ(0).tech+2*civ(0).aggr and rnd_range(1,100)<civ(0).aggr*15 then
        makealiencolony(0,a,rnd_range(2,4))    
        planets(a).mon_template(1)=civ(0).spec
        planets(a).mon_noamin(1)=rnd_range(2,4)
        planets(a).mon_noamax(1)=planets(a).mon_noamin(1)+rnd_range(2,4)
    endif
    
    for b=0 to planets(a).minerals+planets(a).life
        if specialplanet(15)<>a and planettype<44 and isgasgiant(a)=0 then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\6+gascloud,planets(a).depth+disnbase(player.c)\7+gascloud),rnd_range(0,60),rnd_range(0,20),a)
    next b
    
    if isgardenworld(a) then planets(a).flavortext="This place is lovely."
end sub

sub makecraters(a as short, o as short)
    dim as short x,y,d,b,b1,wx,wy,ice
    dim as _cords p3,p2,p1
    planets(a).water=0
    planets(a).atmos=1
    planets(a).grav=planets(a).grav-0.1
    
    for x=0 to 60
        for y=0 to 20
            if rnd_range(1,100)<60 then
                planetmap(x,y,a)=-4
            else
                planetmap(x,y,a)=-14
            endif
        next
    next
    b1=rnd_range(1,3)+rnd_range(1,3)+5
    for b=0 to b1
        wx=rnd_range(1,2)+rnd_range(1,3)+1
        wy=wx
        p1.x=rnd_range(0,(60-(wx*2)))
        p1.y=rnd_range(0,(20-(wy*2)))
        p2.x=p1.x+wx
        p2.y=p1.y+wy
        'do
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                d=distance(p3,p2)                    
                if d=wy then
                    planetmap(x,y,a)=-8
                endif
                if d<wy then
                    planetmap(x,y,a)=-14
                endif
                if rnd_range(1,200)>197 then
                    p3=movepoint(p3,5)
                    planetmap(p3.x,p3.y,a)=-8
                endif
            next
        next
        wy=wy-1
        'loop until rnd_range(1,100)>11 
    next
    for b=0 to rnd_range(1,20)+rnd_range(1,10)+3
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-7
    next
    if rnd_range(1,100)<50 then makeice(a,o)
end sub

sub makeislands(a as short, o as short)
    
dim as integer b,cir,r2,r,ry,bx,by,i,water,mount,mount2,sand,woods,x,y,highest,lowest
dim map(60,20) as short
dim as _cords p1,p2
dim as single elset1,elset2
dim as single rad
water=planets(a).water\10-1
if water>5 then water=5
sand=water+1
woods=sand+1
if water<1 then 
    elset1=-3
    elset2=-4
else
    elset1=-10
    elset2=-11
endif
    
cir=rnd_range(15,15+planets(a).water)
r2=rnd_range(2,4)
highest=0
for i=0 to cir 
    
    p1.x=rnd_range(0,60)
    p1.y=rnd_range(0,20)
    bx=rnd_range(2,r2*2)
    by=rnd_range(1,r2)
    do
        for rad=0 to 6.243 step .1
            x=cos(rad)*bx+p1.x
            y=sin(rad)*by+p1.y
            if x<0 then x=0
            if y<0 then y=0
            if x>60 then x=60
            if y>20 then y=20
            map(x,y)=map(x,y)+1
            if map(x,y)>highest then  highest=map(x,y)
        next
        bx=bx-1
        by=by-1
        if bx<0 then bx=0
        if by<0 then by=0
    loop until bx=0 and by=0
    
next
mount=highest-1
mount2=highest

for x=60 to 0 step -1
    for y=0 to 20
        select case map(x,y)
            case is<water
                planetmap(x,y,a)=-2
            case is=water
                planetmap(x,y,a)=-1
            case is=sand
                planetmap(x,y,a)=-12
            case is=woods
                if rnd_range(1,100)<66 and water>1 then
                    planetmap(x,y,a)=-5
                else
                    planetmap(x,y,a)=-6
                endif                    
            case is=mount
                planetmap(x,y,a)=-8
            case is=mount2
                planetmap(x,y,a)=-7
            case else
                if rnd_range(1,100)<66 then
                    planetmap(x,y,a)=elset2
                else
                    planetmap(x,y,a)=elset1
                endif
         end select
         map(x,y)=0
    next
next

b=100+rnd_range(25,50)+rnd_range(1,25)-planets(a).water
if b<=0 then b=rnd_range(1,10)+rnd_range(1,10)

for x=0 to b
    planetmap(p1.x,p1.y,a)=-8
    if rnd_range(1,100)<(80-planets(a).water) then
        p1=movepoint(p1,5)
    else
        p1.x=rnd_range(1,59)
        p1.y=rnd_range(1,19)
    endif    
next

togglingfilter(a)
togglingfilter(a,8,7)
makeice(o,a)
end sub

sub makeoceanworld(a as short,o as short)
    dim as short x,y,r,b,h
    dim as _cords p1,p2
    dim map(60,20) as byte
    for b=0 to rnd_range(10,20)+rnd_range(10,30)
        
        p1=rnd_point
        r=rnd_range(1,6)+rnd_range(0,5)            
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p1,p2)<=r then
                    map(x,y)=map(x,y)+1
                    if map(x,y)>h then h=map(x,y)
                endif
            next
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-2
            if map(x,y)>=h-2 then planetmap(x,y,a)=-1
            if map(x,y)>=h-1 and rnd_range(1,100)<66 then planetmap(x,y,a)=-165
        next
    next
    p1=rnd_point
    for b=0 to rnd_range(0,19)+rnd_range(0,19)
        if rnd_range(1,100)>33 then 
            p1=rnd_point
        else 
            p1=movepoint(p1,5)
        endif
        if p1.x=0 then p1.x=1
        if p1.y=0 then p1.y=1
        if p1.x=60 then p1.x=59
        if p1.y=20 then p1.y=19
        if rnd_range(1,100)<66 then
            planetmap(p1.x,p1.y,a)=-7
            planetmap(p1.x-1,p1.y,a)=-13
            planetmap(p1.x+1,p1.y,a)=-13
            planetmap(p1.x,p1.y-1,a)=-13
            planetmap(p1.x,p1.y+1,a)=-13
        else
            planetmap(p1.x,p1.y,a)=-28
            if planetmap(p1.x-1,p1.y,a)=-2 then planetmap(p1.x-1,p1.y,a)=-1
            if planetmap(p1.x+1,p1.y,a)=-2 then planetmap(p1.x+1,p1.y,a)=-1
            if planetmap(p1.x,p1.y-1,a)=-2 then planetmap(p1.x,p1.y-1,a)=-1
            if planetmap(p1.x,p1.y+1,a)=-2 then planetmap(p1.x,p1.y+1,a)=-1
        endif    
    next
    planets(a).mon_template(0)=makemonster(24,a)
    planets(a).mon_template(1)=makemonster(10,a)
    makeice(o,a)
end sub

sub makemossworld(a as short, o as short)
    dim as short x,y,r,b,h,l,t1,t2
    dim as _cords p1,p2
    dim map(60,20) as byte
    l=100
    for b=0 to 20+rnd_range(10,20)+rnd_range(10,30)
        
        p1=rnd_point
        r=rnd_range(1,3)+rnd_range(0,3)            
        for x=0 to 60
            for y=0 to 20
                if map(x,y)<l then l=map(x,y)
                
                p2.x=x
                p2.y=y
                if distance(p1,p2)<=r then
                    map(x,y)=map(x,y)+1
                    if map(x,y)>h then h=map(x,y)
                endif
            next
        next
    next   
    t1=rnd_range(l+3,h-1)
    t2=rnd_range(l+3,h-1)
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=-102
            if map(x,y)=l then planetmap(x,y,a)=-2 
            if map(x,y)=l+1 then planetmap(x,y,a)=-1 
            if map(x,y)=l+2 then planetmap(x,y,a)=-103 
            if map(x,y)=h then planetmap(x,y,a)=-104
            if map(x,y)=t1 then planetmap(x,y,a)=-105
            if map(x,y)=t2 then planetmap(x,y,a)=-106
            if rnd_range(1,200)<12 then planetmap(x,y,a)=-146
        next
    next

end sub

sub makecanyons(a as short, o as short)
    dim as _cords p1,p2
    dim as _rect r(128),t
    dim as short x,y,last,mi,wantsize,larga,largb,lno,b,c,d,cnt,old,bx,by
    dim as single rad
    planets(a).orbit=planets(a).orbit+3
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-7
                
            next
        next
        
    last=0    
    wantsize=60 'chop to this size
    mi=3 'minimum
    
    r(0).x=0
    r(0).y=0
    r(0).h=20
    r(0).w=60
    
    do
        larga=0
        largb=0
        'find largestrect
        for b=0 to last
            if r(b).h>larga then 
                larga=r(b).h
                lno=b
            endif
            if r(b).w>larga then 
                larga=r(b).w
                lno=b
            endif
            if r(b).h*r(b).w>largb then
                largb=r(b).h*r(b).w
                lno=b
            endif
        next
        ' Half largest _rect 
        last=last+1
        if r(lno).h>r(lno).w then
            y=rnd_range(mi,r(lno).h-mi)
            old=r(lno).h
            t=r(lno)
            r(last)=t
            t.h=y-1
            r(last).y=r(last).y+y
            r(last).h=old-y
            r(lno)=t
        else
            x=rnd_range(mi,r(lno).w-mi)
            old=r(lno).w
            t=r(lno)
            r(last)=t
            t.w=x-1
            r(last).x=r(last).x+x
            r(last).w=old-x
            r(lno)=t
        endif
    loop until largb<wantsize     
    for b=0 to last 
        p1.x=r(b).x+r(b).w/2-1+rnd_range(1,2)
        p1.y=r(b).y+r(b).h/2-1+rnd_range(1,2)
        bx=r(b).w/2-1
        by=r(b).h/2-1
        if bx<2 then bx=2
        if by<2 then by=2
        'if r(b).w*r(b).h>46 then 
            do
                for rad=0 to 6.243 step .1
                    x=cos(rad)*bx+p1.x
                    y=sin(rad)*by+p1.y
                    if x<0 then x=0
                    if y<0 then y=0
                    if x>60 then x=60
                    if y>20 then y=20
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-3
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-5
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-11
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-12
                    if rnd_range(1,100)<4 then planetmap(x,y,a)=-14
        '            planetmap(x,y,a)=-13
                next
                bx=bx-1
                by=by-1
                if bx<0 then bx=0
                if by<0 then by=0
            loop until bx=0 and by=0
        'endif
    next
    

    for b=0 to last step 2
        c=b+1
        p1.x=r(b).x+r(b).w/2
        p1.y=r(b).y+r(b).h/2
         
        p2.x=r(c).x+r(c).w/2
        p2.y=r(c).y+r(c).h/2
        cnt=0     
        do 
            cnt=cnt+1
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-3
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-5
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-11
            if rnd_range(1,100)<16 then planetmap(p2.x,p2.y,a)=-12
            if rnd_range(1,100)<15 then planetmap(p2.x,p2.y,a)=-14
            d=nearest(p1,p2)
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            if rnd_range(1,100)<15 then d=d+1
            p2=movepoint(p2,d)
        loop until distance(p1,p2)<1.5 or cnt>500        
    next    
    togglingfilter(a,8,7)
    togglingfilter(a,8,7)
    if rnd_range(1,100)<10 then
        planets(a).atmos=1
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-7 and planetmap(x,y,a)<>-8 then 
                    if rnd_range(1,100)<66 then
                        planetmap(x,y,a)=-4
                    else
                        planetmap(x,y,a)=-14
                    endif
                    if rnd_range(1,100)<6 then planetmap(x,y,a)=-158
                endif
            next
        next
    endif
    planets(a).water=0
    if rnd_range(1,100)<50 then makeice(a,o)
end sub

function makewhplanet() as short
    dim as short a,b,c,x,y
    dim as _cords p
    lastplanet+=1
    a=lastplanet
    whplanet=a
    b=-13
    makeplanetmap(a,3,9)
    deletemonsters(a)
    planets(a).mon_template(1)=makemonster(55,a)
    planets(a).mon_noamin(1)=2
    planets(a).mon_noamax(1)=3
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,a)=b
            if rnd_range(1,100)<22 then b=-14
            if rnd_range(1,100)<22 then b=-4
            if rnd_range(1,100)<22 then b=-3
            if rnd_range(1,100)<22 then b=-13
        next
    next
    
    for b=0 to 25
        p=rnd_point
            
        for c=0 to 15+rnd_range(2,6)+rnd_range(2,6)
            p=movepoint(p,5)
            planetmap(p.x,p.y,a)=-193
        next
    next
    p=rnd_point
    placeitem(makeitem(99,13),p.x,p.y,a)
    p=rnd_point
    placeitem(makeitem(99,16),p.x,p.y,a)
    return 0
end function

function makespecialplanet(a as short) as short
    dim as short x,y,b,c,d,b1,b2,b3,cnt,wx,wy,ti,x1,y1
    dim as _cords p,p1,p2,p3,p4,p5
    dim as _cords pa(5)
    dim as _rect r
    dim as _cords gc,gc1
    dim it as _items
    ' UNIQUE PLANETS
    '
    for b=0 to lastspecial
        if a=specialplanet(b) then
            planets(a).temp=22+rnd_range(2,20)/10
            planets(a).rot=1
            planets(a).grav=1
            planets(a).atmos=7
        endif
    next
    
    if a=specialplanet(0) then
        makemossworld(a,3)
    endif
    
    if a=specialplanet(1) then 'apollos temple
        planetmap(rnd_range(1,60),rnd_range(0,20),a)=-56
        planets(a).flavortext="A huge guy in a robe claims to be apollo and demands you to worship him. he gets very agressive as you refuse. Also your Ship suddenly disappears."        
    endif
    
    if a=specialplanet(2) then 'Defense town
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                if rnd_range(1,100)<90 then
                    if rnd_range(1,100)<20 then
                        planetmap(x,y,a)=-3
                    else
                        planetmap(x,y,a)=-4
                    endif
                else
                    planetmap(x,y,a)=-14
                endif
            next
        next
        for y=0 to 20
            p1=rnd_point
            for x=0 to rnd_range(1,5)+5
                planetmap(p1.x,p1.y,a)=-7
                p1=movepoint(p1,5)
            next
        next
        p1=rnd_point
        for x=0 to rnd_range(1,5)+5
            planetmap(p1.x,p1.y,a)=-16
            p1=movepoint(p1,5)
        next
        p1=movepoint(p1,5)
        planetmap(p1.x,p1.y,a)=-100
        p1=movepoint(p1,5)
        planetmap(p1.x,p1.y,a)=-4
        
        lastplanet=lastplanet+1
        
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        gc1.x=rnd_range(2,58)
        gc1.y=rnd_range(2,18)
        gc1.m=lastplanet
        makecomplex(gc1,0)
        
        addportal(gc,gc1,0,asc("#"),"A building still in good condition",15)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-167
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100
        for x=0 to rnd_range(1,6)+rnd_range(1,6)
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-127-rnd_range(1,10)
        next
        planets(a).atmos=6
        planets(lastplanet).atmos=6
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-168
    endif
    
    if a=specialplanet(3) or a=specialplanet(4) or a=specialplanet(28) then 'cityworld
        deletemonsters(a)
        planets(a).depth=5
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=asc("#")
        portal(lastportal).col=15
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        makecomplex(portal(lastportal).dest,0)
        for b=0 to rnd_range(1,6)+rnd_range(1,6)
            placeitem(rnd_item(21),rnd_range(0,60),rnd_range(0,20),a)
        next
        makelabyrinth(a)
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-4 then 
                    planetmap(x,y,a)=-16
                else
                    planetmap(x,y,a)=-31
                    if rnd_range(1,100)>50 then planetmap(x,y,a)=-32
                    if rnd_range(1,100)>50 then planetmap(x,y,a)=-33
                endif
            next
        next
        
        
        'roads
        'round the corners
        for x=1 to 59
            for y=1 to 19
                if planetmap(x,y,a)<-30 then
                    if planetmap(x-1,y,a)<-30 or planetmap(x+1,y,a)<-30 then planetmap(x,y,a)=-32
                    if planetmap(x,y-1,a)<-30 or planetmap(x,y+1,a)<-30 then planetmap(x,y,a)=-31
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-34
                    endif
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow up
                        planetmap(x,y,a)=-35
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-36
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow up
                        planetmap(x,y,a)=-37
                    endif
                    
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 then 'bow down
                        planetmap(x,y,a)=-38
                    endif
                    if planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)<-30 then 'bow up
                        planetmap(x,y,a)=-39
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)<-30 then 'bow down
                        planetmap(x,y,a)=-40
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)<-30then 'bow up
                        planetmap(x,y,a)=-41
                    endif
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)<-30 then
                        planetmap(x,y,a)=-33
                    endif
                endif
            next
        next
        
        for x=0 to 55+rnd_range(1,10)
            do
                p2=rnd_point
            loop until planetmap(p2.x,p2.y,a)<-30
            planetmap(p2.x,p2.y,a)=-16
        next
        
        
        for x=0 to rnd_range(1,5)+1
            p2=rnd_point
            planetmap(p2.x,p2.y,a)=-100
        next
        
        for x=0 to rnd_range(1,5)+1
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        if specialplanet(3)=a then            
            for x=0 to rnd_range(1,5)+20
                planetmap(rnd_range(0,60),rnd_range(0,20),a)=-18
            next    
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-17
        endif
        
        if a=specialplanet(28) then
            for b=0 to 1
                p=rnd_point
                if p.x>=52 then p.x=51
                if p.y>=15 then p.y=14
                for x=p.x to p.x+8
                    for y=p.y to p.y+5
                        planetmap(x,y,a)=-68
                    next
                next
            next
            p.x=rnd_range(p.x,p.x+10)
            p.y=rnd_range(p.y,p.y+5)
            planetmap(p.x,p.y,a)=-241
            'Unused
        endif
        
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=4
        planets(a).mon_noamax(0)=10
        
        
        planets(a).mon_template(1)=makemonster(53,a)
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=10
        
        planets(a).mon_template(2)=makemonster(54,a)
        planets(a).mon_noamin(2)=5
        planets(a).mon_noamax(2)=10
        
        
        
    endif
    
    
    if a=specialplanet(5) or a=specialplanet(12) then 
        deletemonsters(a)'dune and sandworms
        for x=0 to 60
            for y=0 to 20
                if rnd_range(1,100)<66 then
                    planetmap(x,y,a)=-12
                else 
                    planetmap(x,y,a)=-3
                endif
            next
        next
        b1=rnd_range(1,10)+rnd_range(1,10)+25
        p1.x=rnd_range(1,59)
        p1.y=rnd_range(1,19)
        for x=0 to b1
            planetmap(p1.x,p1.y,a)=-8
            if rnd_range(1,100)<30 then
                p1=movepoint(p1,5)
            else
                p1.x=rnd_range(1,59)
                p1.y=rnd_range(1,19)
            endif    
        next
        b1=rnd_range(1,4)+rnd_range(1,4)+2
        for x=0 to b1
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        if specialplanet(5)=a then
            p1.x=rnd_range(0,60)
            p1.y=rnd_range(0,20)
            planetmap(p1.x,p1.y,a)=-62
            b=rnd_range(1,8)
            if b=4 then b=b+1
            p2=movepoint(p1,b)
            c=1
            
            do
                p2=movepoint(p2,b)
                c=c+1
            loop until p1.x=0 or p1.y=0 or p1.x=60 or p1.y=60 or planetmap(p1.x,p1.y,a)=-8 or c>8
            planetmap(p2.x,p2.y,a)=-63
    
            planets(a).mon_template(0)=makemonster(11,a)
            planets(a).mon_noamax(0)=15
            planets(a).mon_noamin(0)=8
        endif
        if specialplanet(12)=a then 'dying world
            for b=0 to rnd_range(1,8)+rnd_range(1,5)+rnd_range(1,3)
                placeitem(makeitem(96,4,4),rnd_range(0,60),rnd_range(0,20),a)
            next
        
        endif
    endif
    
    if specialplanet(6)=a then'invisible critters +mine
        deletemonsters(a)
        p1.x=rnd_range(0,50)
        p1.y=rnd_range(0,16)
        planetmap(p1.x,p1.y,a)=-76
        planetmap(p1.x+2,p1.y,a)=-76
        planetmap(p1.x,p1.y+2,a)=-76
        planetmap(p1.x+2,p1.y+2,a)=-76
        planetmap(p1.x+1,p1.y,a)=-32
        planetmap(p1.x+1,p1.y+2,a)=-32
        planetmap(p1.x,p1.y+1,a)=-33
        planetmap(p1.x+2,p1.y+1,a)=-33        
        planetmap(p1.x+3,p1.y,a)=-32
        planetmap(p1.x+4,p1.y,a)=-32
        planetmap(p1.x+5,p1.y,a)=-32
        planetmap(p1.x+6,p1.y,a)=-68
        planetmap(p1.x+1,p1.y+1,a)=-4
        
        lastportal=lastportal+1
        portal(lastportal).desig="A Mineshaft. "
        portal(lastportal).tile=asc("#")
        portal(lastportal).col=14
        portal(lastportal).from.m=a
        portal(lastportal).from.x=p1.x+1
        portal(lastportal).from.y=p1.y+1
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        
        planets(a).mon_template(0)=makemonster(13,a)
        planets(a).mon_noamax(0)=8
        planets(a).mon_noamin(0)=15
        planets(lastplanet).mon_template(0)=makemonster(13,a)
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_noamin(0)=10
        placeitem(makeitem(15),p1.x,p1.y+2,a,0,0)
        'placeitem(makeitem(97),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0,0)
        placeitem(makeitem(98),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        placeitem(makeitem(99),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        
    endif
    
    if specialplanet(7)=a then 'Civ 1
        'Make Spacefaring civilization
    endif
    
    if specialplanet(8)=a then 'Pirate treasure on stormy world
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-75        
    endif
    
    
    if a=specialplanet(9) then
        deletemonsters(a)
        planets(a).water=25
        makeislands(a,3)
        planets(a).atmos=4
        planets(a).temp=15.5
        for x=4 to 16
            for y=4 to 16
                if x=4 or y=4 or x=16 or y=16 then planetmap(x,y,a)=-18
            next
        next
        for x=5 to 15
            for y=5 to 15
                if x=5 or y=5 or x=15 or y=15 then
                    planetmap(x,y,a)=-16
                else
                    if frac(x/2)=0 and frac(y/2)=0 then planetmap(x,y,a)=-68
                endif
            next
        next
        for x=6 to 8
            for y=6 to 8
                planetmap(x,y,a)=-18
            next
        next
        planetmap(7,7,a)=-241
        for b=0 to 1
            gc.m=a
            gc.x=rnd_range(20,60)
            gc.y=rnd_range(1,18)
            lastplanet+=1
            gc1.m=lastplanet
            p1=rnd_point(lastplanet,0)
            gc1.x=p1.x
            gc1.y=p1.y
            makecomplex(gc1,1)
            addportal(gc,gc1,0,asc("o"),"A shaft",14)
        next
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-242
    endif
    
    if specialplanet(10)=a or a=pirateplanet(0) then 'Settlement
        deletemonsters(a)

        planets(a).grav=0.8+rnd_range(1,3)/2
        planets(a).atmos=6
        planets(a).temp=9+rnd_range(1,200)/10
        
        if rnd_range(1,100)<35 then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        
        wx=rnd_range(5,8)
        wy=wx
        p1.x=rnd_range(20,40)
        
        p2.x=p1.x+wx
        p2.y=10
        
        for y=p2.y-wy+1 to p2.y+wy-1 step 3    
        
                for x=p2.x-wx to p2.x+wx 
                    if p4.x=0 and p4.y=0 then
                        p4.x=x
                        p4.y=y 'Grab first east west street
                    endif
                    planetmap(x,y,a)=32
                next
            next
            for x=p2.x-wx+1 to p2.x+wx-1 step 3
                for y=p2.y-wy to p2.y+wy
                    planetmap(x,y,a)=31
                next
            next
            
        for x=p2.x-wx to p2.x+wx
            for y=p2.y-wy to p2.y+wy
                if planetmap(x,y,a)>30 and planetmap(x+1,y,a)>30 and  planetmap(x,y+1,a)>30 then
                    planetmap(x,y,a)=33
                endif
            next
        next
        for x=0 to 60
           for y=0 to 20
               p3.x=x
               p3.y=y
               d=distance(p3,p2)
                
                if d<=wy then
                    if rnd_range(1,100)<80 and planetmap(x,y,a)<30 then
                    
                        planetmap(x,y,a)=16
                    endif
                endif
            next
        next
        cnt=0
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>9999
        
        if a=pirateplanet(0) then 
            planetmap(x,y,a)=74
        else
            planetmap(x,y,a)=42
        endif
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>20000
        planetmap(x,y,a)=43
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y-wy,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        if a<>pirateplanet(0) then planetmap(x,y,a)=270
        
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>pirateplanet(0) then 
            planetmap(x,y,a)=89
        else
            planetmap(x,y,a)=164
        endif
        
        
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until abs(planetmap(x,y,a))<30 or cnt>40000
        
        planetmap(x,y,a)=286
        
        planets(a).mon_template(0)=makemonster(14,a)
        planets(a).mon_noamin(0)=8
        planets(a).mon_noamax(0)=17
        
        if specialplanet(10)=a then 'Small spaceport for colony
            p3.x=p2.x+wx
            p3.y=10
            if p3.x+3>60 then p3.x-=3
            for x=p3.x to p3.x+3
                for y=10 to 12
                    planetmap(x,y,a)=68
                next
            next
            planetmap(p3.x,10,a)=70
            planetmap(p3.x,11,a)=71
        endif
        
        if a=pirateplanet(0) then 'add spaceport
            c=rnd_range(1,53)
            if c>p4.x then 
                b=1
            else
                b=-1
            endif
            for x=p4.x to c step b
                planetmap(x,p4.y,a)=32
            next
            'c=ende der strasse
            d=0
            if p4.y-3<0 then p4.y=p4.y+3
            if p4.y+3>60 then p4.y=p4.y-3
            
            for x=c to c+5
                for y=p4.y-3 to p4.y+3
                    planetmap(x,y,a)=68
                    if rnd_range(1,100)<25 then planetmap(x,y,a)=67
                    if x=c+1 and y>p4.y-3 and d<5 then
                        planetmap(x,y,a)=69+d
                        d=d+1
                    endif
                next
            next
            
            planetmap(c,p4.y-3,a)=-259
            planetmap(c,p4.y-2,a)=74
            do
                p=rnd_point(a,0)
            loop until tiles(abs(planetmap(p.x,p.y,a))).walktru>0 or abs(planetmap(p.x,p.y,a))<15
            planetmap(p.x,p.y,a)=-197
            planets(a).grav=.8+rnd_range(1,2)/2
            planets(a).atmos=5
            planets(a).temp=33+rnd_range(1,20)-10
            
            planets(a).mon_template(0)=makemonster(3,a)
            planets(a).mon_noamin(0)=8
            planets(a).mon_noamax(0)=15
            
            planets(a).mon_template(1)=makemonster(49,a)
            planets(a).mon_noamin(1)=6
            planets(a).mon_noamax(1)=10
            
            planets(a).mon_template(2)=makemonster(50,a)
            planets(a).mon_noamin(2)=3
            planets(a).mon_noamax(2)=6
        endif
    
    
    
        'Turn all around if player isnt pirate
        if not(faction(0).war(2)>=0 and a=pirateplanet(0)) then        
            for x=0 to 60
                for y=0 to 20
                    if planetmap(x,y,a)>0 then planetmap(x,y,a)=-planetmap(x,y,a)
                next
            next
        endif
        
    endif
    
    if specialplanet(11)=a then
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=79
        p2=movepoint(p1,5)
        planetmap(p2.x,p2.y,a)=270
        do
            p3=movepoint(p1,5)
        loop until (p1.x<>p3.x or p1.y<>p3.y) and (p2.x<>p3.x or p2.y<>p3.y)
        planetmap(p3.x,p3.y,a)=271
    endif
    
    if specialplanet(12)=a then
        for b=0 to rnd_range(0,15)+15
            placeitem(makeitem(96,9,7),rnd_range(0,60),rnd_range(0,20),a)
        next
        deletemonsters(a)
        planets(a).water=0
        planets(a).atmos=1
        planets(a).grav=3
        planets(a).temp=4326+rnd_range(1,100)
        planets(a).death=10+rnd_range(1,4)
    endif
    
    if a=specialplanet(13) then 'Entertainment world
        deletemonsters(a)
        makecraters(a,3)
        p=rnd_point
        p2=rnd_point
        if p2.x+4>60 then p2.x=55
        if p2.y+4>20 then p2.y=15
        makeroad(p,p2,a)
        p3=rnd_point
        if p3.x+3>60 then p3.x-=3
        makeroad(p3,p2,a)
        for x=p3.x to p3.x+3
            for y=10 to 12
                planetmap(x,y,a)=68
            next
        next
        planetmap(p3.x,10,a)=70
        planetmap(p3.x,11,a)=71
        
        for x=p2.x to p2.x+4
            for y=p2.y to p2.y+4
                planetmap(x,y,a)=-68
            next
        next
        p.m=a
        planetmap(p.x,p.y,a)=-4
        
        lastplanet+=1
        makecomplex3(lastplanet,5,6,0,3)
        
        for x=2 to 58
            for y=2 to 18
                if planetmap(x,y,lastplanet)=-202 and planetmap(x,y-1,lastplanet)=-50 and planetmap(x,y+1,lastplanet)=-50 then planetmap(x,y-1,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and planetmap(x-1,y,lastplanet)=-50 and planetmap(x+1,y,lastplanet)=-50 then planetmap(x-1,y,lastplanet)=-202
            next
        next
        p2=rnd_point(lastplanet,0)
        p3=rnd_point
        if p3.x+8>59 then p3.x=51
        if p3.y+8>19 then p3.y=11
        for x=p3.x to p3.x+8
            for y=p3.y to p3.y+8
                planetmap(x,y,lastplanet)=-202
            next
        next
        for x=p3.x+1 to p3.x+7
            for y=p3.y+1 to p3.y+7
                planetmap(x,y,lastplanet)=-3
                if x=p3.x+1 or x=p3.x+7 or y=p3.y+1 or y=p3.y+7 then planetmap(x,y,lastplanet)=-51
            next
        next
        
        
        p2=rnd_point(lastplanet,0)
        p2.m=lastplanet
        addportal(p,p2,0,asc(">"),"A wide and well lit staircase",15)
        
        planetmap(p3.x+1,p3.y+4,lastplanet)=-265
        for b=0 to 6
            do
                p4=rnd_point(lastplanet,0)
            loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
            planetmap(p4.x,p4.y,lastplanet)=-69
        next
        
        for b=0 to 2
            do
                p4=rnd_point(lastplanet,0)
            loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
            planetmap(p4.x,p4.y,lastplanet)=-266
        next

        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-261
    
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-262

        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-261
        
        
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-271
        
        
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        planetmap(p4.x,p4.y,lastplanet)=-270
        
        
        planets(lastplanet).depth=1
        planets(lastplanet).mon_template(2)=makemonster(39,lastplanet)
        planets(lastplanet).mon_noamin(2)=3
        planets(lastplanet).mon_noamax(2)=10
        
        'planets(lastplanet).mon_template(3)=makemonster(23,lastplanet)
        'planets(lastplanet).mon_noamin(3)=1
        'planets(lastplanet).mon_noamax(3)=3
        
        planets(lastplanet).atmos=7
        p2=rnd_point(lastplanet,0)
        p2.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,5,6,0,3)
        
        for x=2 to 58
            for y=2 to 18
                if planetmap(x,y,lastplanet)=-202 and planetmap(x,y-1,lastplanet)=-50 and planetmap(x,y+1,lastplanet)=-50 then planetmap(x,y-1,lastplanet)=-202 
                if planetmap(x,y,lastplanet)=-202 and planetmap(x-1,y,lastplanet)=-50 and planetmap(x+1,y,lastplanet)=-50 then planetmap(x-1,y,lastplanet)=-202
            next
        next
        p=rnd_point(lastplanet,0)
        p.m=lastplanet
        addportal(p2,p,0,asc(">"),"A wide and well lit staircase",15)
        for b=0 to 35
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-267
        next
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-268
    
        planets(lastplanet)=planets(lastplanet-1)
    endif
    
    if specialplanet(14)=a then
        deletemonsters(a)
        
        if rnd_range(1,100)<25 then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        p2=rnd_point
        p3=rnd_point
        p4=rnd_point
        p5=rnd_point
        makeoutpost(a,p2.x,p2.y)
        makeoutpost(a,p3.x,p3.y)
        p1=rnd_point
        makeroad(p1,p2,a)
        makeroad(p1,p3,a)
        makeroad(p1,p4,a)
        makeroad(p1,p5,a)
        
        if p5.x+3>60 then p5.x-=3
        if p5.y+3>20 then p5.y-=3
        for x=p5.x to p5.x+3
            for y=p5.y to p5.y+3
                planetmap(x,y,a)=68
            next
        next
        
        planetmap(p3.x,10,a)=70
        planetmap(p3.x,11,a)=71
        
        if p1.x>50 then p1.x=50
        if p1.x<5 then p1.x=10
        if p1.y<5 then p1.y=5
        if p1.y>19 then p1.y=19
        if p1.x>58 then p1.x=58
        planetmap(p1.x,p1.y,a)=-68
        planetmap(p1.x+1,p1.y,a)=-68
        planetmap(p1.x,p1.y+1,a)=-68
        planetmap(p1.x+1,p1.y+1,a)=-68
        planetmap(p1.x+2,p1.y,a)=-98
        planetmap(p1.x+2,p1.y+1,a)=-43
        
        p2.x=rnd_range(2,p1.x-2)
        p2.y=rnd_range(1,p1.y)
        if p2.y<5 then p2.y=5
        makeroad(p1,p2,a)
        for x=p2.x to p2.x+3
            for y=p2.y to p2.y+4
                planetmap(x,y,a)=-68
            next
        next
        planetmap(p2.x-1,p2.y,a)=-238
        planetmap(p2.x-1,p2.y+2,a)=-237
        planetmap(p2.x-1,p2.y+4,a)=-259
        planetmap(p3.x,p3.y,a)=-261
        planetmap(p4.x,p4.y,a)=-270
        p4=movepoint(p4,5)
        planetmap(p4.x,p4.y,a)=-271
    endif
    
    if specialplanet(15)=a then
        planets(a).water=66
        deletemonsters(a)
        makeislands(a,3)
        for b=0 to rnd_range(15,25)
            planetmap(rnd_range(1,59),rnd_range(1,19),a)=-91
            planetmap(rnd_range(1,59),rnd_range(1,19),a)=-96
        next
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        planets(a).mon_template(0)=makemonster(20,a)
        planets(a).mon_noamax(0)=24
        planets(a).mon_noamin(0)=18
        
        planets(a).mon_template(1)=makemonster(58,a)
        planets(a).mon_noamax(1)=24
        planets(a).mon_noamin(1)=18
        
        planets(lastplanet).depth=1
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=lastplanet
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),0,0)
        r.x=rnd_range(1,40)
        r.y=rnd_range(1,15)
        r.w=rnd_range(5,7)
        r.h=rnd_range(4,5)
        p1.x=gc.x
        p1.y=gc.y
        makevault(r,gc.m,p1,99)
    endif 
    
    if specialplanet(16)=a then
        b=lastportal
        c=lastplanet
        deletemonsters(a)
        planets(a).temp=22.5
        planets(a).grav=0.9
        planets(a).atmos=6
        planets(a).water=66
        makeislands(a,3)
        for x=26 to 34
            for y=6 to 14
                p.x=x
                p.y=y
                p1.x=30
                p1.y=10
                if distance(p,p1)<=3 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<88 and distance(p,p1)=2  then p2=p
            next
        next
        planetmap(p2.x,p2.y,a)=-4
        planetmap(30,10,a)=-150
        planets(a).mon_noamin(0)=15
        planets(a).mon_noamax(0)=25
        planets(a).mon_template(0)=makemonster(22,a)
        
        gc.x=rnd_range(1,60)
        gc.y=rnd_range(1,20)
        gc.m=c+1
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(gc.m).depth=1
        
        
        
        planets(lastplanet+3).depth=3
        
        lastportal=b
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=p2.x
        portal(lastportal).from.y=p2.y
        portal(lastportal).dest.m=gc.m
        p=rnd_point(lastplanet+1,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        
        gc.x=rnd_range(1,60)
        gc.y=rnd_range(1,20)
        gc.m=c+2
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(gc.m).depth=2
        lastportal=lastportal+1
        portal(lastportal).desig="Am ascending tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=c+1
        p=rnd_point(c+1,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        portal(lastportal).dest.m=c+2
        p=rnd_point(c+2,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        
        makelabyrinth(c+3)
        
        lastportal=lastportal+1
        portal(lastportal).desig="A stair going upwards. "
        portal(lastportal).tile=asc("<")
        portal(lastportal).col=7
        portal(lastportal).from.m=c+2
        p=rnd_point(c+2,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        portal(lastportal).dest.m=c+3
        p=rnd_point(c+3,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
        portal(lastportal).discovered=show_specials
        portal(lastportal).oneway=1
        
        lastportal=lastportal+1
        portal(lastportal)=portal(lastportal-1)
        swap portal(lastportal).from,portal(lastportal).dest
        portal(lastportal).desig="A stair leading down."
        portal(lastportal).tile=asc(">")
        portal(lastportal).col=7
    
        for b=0 to 30
            p1=rnd_point(lastplanet+3,0)
            planetmap(p1.x,p1.y,lastplanet+3)=-161
        next
        planets(lastplanet+1).mon_template(0)=makemonster(1,lastplanet+1)
        planets(lastplanet+1).mon_template(1)=makemonster(9,lastplanet+1)
        planets(lastplanet+1).mon_noamin(0)=9
        planets(lastplanet+1).mon_noamax(0)=18
        planets(lastplanet+1).mon_noamax(1)=1
        planets(lastplanet+1).mon_noamax(1)=2
        planets(lastplanet+1).atmos=6
        planets(lastplanet+2).mon_template(0)=makemonster(1,lastplanet+2)
        planets(lastplanet+2).mon_template(1)=makemonster(9,lastplanet+2)
        planets(lastplanet+2).mon_noamin(0)=9
        planets(lastplanet+2).mon_noamax(0)=18
        planets(lastplanet+2).mon_noamax(1)=1
        planets(lastplanet+2).mon_noamax(1)=2
        planets(lastplanet+2).atmos=6
        
        planets(lastplanet+3).mon_template(0)=makemonster(8,lastplanet+3)
        planets(lastplanet+3).mon_template(1)=makemonster(9,lastplanet+3)
        planets(lastplanet+3).mon_noamin(0)=9
        planets(lastplanet+3).mon_noamax(0)=18
        planets(lastplanet+3).mon_noamax(1)=1
        planets(lastplanet+3).mon_noamax(1)=3
        planets(lastplanet+3).atmos=6
       
        p1=rnd_point(lastplanet+3,0)
        placeitem(makeitem(90),p1.x,p1.y,lastplanet+3,0,0) 
        planetmap(p1.x,p1.y,lastplanet+3)=-162
        lastplanet=lastplanet+3
    endif
    
    if specialplanet(17)=a then
        planets(a).water=66
        makeislands(a,4)
        
        deletemonsters(a)
        p1=rnd_point
        
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)<>-1 and planetmap(x,y,a)<>-2 then
                    c=0
                    p.x=x
                    p.y=y
                    for b=1 to 9
                        p1=movepoint(p,b)
                        if planetmap(p1.x,p1.y,a)=-1 or planetmap(p1.x,p1.y,a)=-2 then c=c+1
                    next
                    if c=0 then  
                        planetmap(x,y,a)=-16
                        if rnd_range(1,100)<18 then planetmap(x,y,a)=-107
                        if rnd_range(1,100)<28 then planetmap(x,y,a)=-16
                    endif
                endif
            next
        next
        p.x=rnd_range(4,54)
        p.y=rnd_range(4,14)
        for x=p.x-2 to p.x+2
            for y=p.y-2 to p.y+2
                planetmap(x,y,a)=-11
            next
        next
        for x=0 to 15
            makeroad(rnd_point,rnd_point,a)
        next
        planetmap(p.x,p.y,a)=-108
        planetmap(p.x,p.y+1,a)=-108
        planetmap(p.x+1,p.y,a)=-108
        planetmap(p.x-1,p.y,a)=-108
        planetmap(p.x,p.y-1,a)=-108
        makeice(a,4)
        planets(a).mon_template(0)=makemonster(30,a)
        planets(a).mon_noamax(0)=25
        planets(a).mon_noamin(0)=18
        planets(a).temp=49.7
        planets(a).rot=12.7
        planets(a).atmos=3
    endif
    
    if specialplanet(18)=a then
        makemossworld(a,6)
        
        deletemonsters(a)
        y=rnd_range(8,12)
        for b=5 to 55
            planetmap(b,y,a)=-32
        next
        for x=5 to 55 step 10
            p.x=x-1+rnd_range(1,2)
            p.y=rnd_range(7,12)
            planetmap(p.x,p.y,a)=-171
            planetmap(p.x-1,p.y-1,a)=-171
            planetmap(p.x-2,p.y-2,a)=-171
            planetmap(p.x+1,p.y,a)=-171
            planetmap(p.x+2,p.y,a)=-171
            planetmap(p.x+1,p.y+1,a)=-171
            planetmap(p.x+2,p.y+2,a)=-171
            planetmap(p.x+1,p.y,a)=-171
            planetmap(p.x+2,p.y,a)=-171
            planetmap(p.x-1,p.y,a)=-171
            planetmap(p.x-2,p.y,a)=-171
            planetmap(p.x,p.y+1,a)=-171
            planetmap(p.x,p.y+2,a)=-171
            planetmap(p.x,p.y-1,a)=-171
            planetmap(p.x,p.y-2,a)=-171
            planetmap(p.x+1,p.y-1,a)=-171
            planetmap(p.x+2,p.y-2,a)=-171
            planetmap(p.x-1,p.y+1,a)=-171
            planetmap(p.x-2,p.y+2,a)=-171
            planetmap(p.x+3,p.y,a)=-171
            planetmap(p.x-3,p.y,a)=-171
            planetmap(p.x,p.y+3,a)=-171
            planetmap(p.x,p.y-3,a)=-171
        next
        p=rnd_point
        planetmap(3,3,a)=-173
        p=rnd_point
        planetmap(30,10,a)=-172
        planets(a).mon_template(0)=makemonster(25,a)
        planets(a).mon_noamax(0)=12
        planets(a).mon_noamin(0)=8
        
        planets(a).mon_template(1)=makemonster(26,a)
        planets(a).mon_noamax(1)=10
        planets(a).mon_noamin(1)=8
        
        planets(a).temp=19.7
        planets(a).grav=1.1
        planets(a).atmos=5
    endif
    
    if a=specialplanet(19) then
        deletemonsters(a)
        p.x=rnd_range(10,50)
        p.y=rnd_range(5,15)
        planetmap(p.x,p.y,a)=-171
        planetmap(p.x-1,p.y-1,a)=-171
        planetmap(p.x-2,p.y-2,a)=-171
        planetmap(p.x+1,p.y,a)=-171
        planetmap(p.x+2,p.y,a)=-171
        planetmap(p.x+1,p.y+1,a)=-171
        planetmap(p.x+2,p.y+2,a)=-171
        planetmap(p.x+1,p.y,a)=-171
        planetmap(p.x+2,p.y,a)=-171
        planetmap(p.x-1,p.y,a)=-171
        planetmap(p.x-2,p.y,a)=-171
        planetmap(p.x,p.y+1,a)=-171
        planetmap(p.x,p.y+2,a)=-171
        planetmap(p.x,p.y-1,a)=-171
        planetmap(p.x,p.y-2,a)=-171
        planetmap(p.x+1,p.y-1,a)=-171
        planetmap(p.x+2,p.y-2,a)=-171
        planetmap(p.x-1,p.y+1,a)=-171
        planetmap(p.x-2,p.y+2,a)=-171
        planetmap(p.x+3,p.y,a)=-171
        planetmap(p.x-3,p.y,a)=-171
        planetmap(p.x,p.y+3,a)=-171
        planetmap(p.x,p.y-3,a)=-171
        planets(a).mon_template(0)=makemonster(26,a)
        planets(a).mon_noamax(0)=12
        planets(a).mon_noamin(0)=8
        planets(a).temp=-219.7
        planets(a).grav=1.1
        planets(a).atmos=4
    endif
    
    if a=specialplanet(20) then
        planets(a).water=33
        makeislands(a,3)
        
        deletemonsters(a)
        p=rnd_point
        for b=0 to 6
            makeroad(p,rnd_point,a)
            p.x=rnd_range(2,55)
            p.y=rnd_range(2,15)
            for x=p.x to p.x+4
                for y=p.y to p.y+4
                    planetmap(x,y,a)=-181
                next
            next
        next
        p2=rnd_point
        planetmap(p2.x,p2.y,a)=-183
        p2=rnd_point
        makeroad(p,p2,a)
        if p2.x=60 then p2.x=59
        if p2.y=20 then p2.y=19
        planetmap(p2.x,p2.y,a)=-182
        planetmap(p2.x+1,p2.y,a)=-182
        planetmap(p2.x,p2.y+1,a)=-182
        planetmap(p2.x+1,p2.y+1,a)=-182
        planets(a).mon_template(0)=makemonster(28,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=15
        planets(a).atmos=6
        planets(a).grav=1.1
        planets(a).temp=15.3
        
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(b).depth=1
        
        planets(b).mon_template(0)=makemonster(29,a)
        planets(b).mon_noamin(0)=3
        planets(b).mon_noamax(0)=10
        
        planets(b).mon_template(1)=makemonster(65,a)
        planets(b).mon_noamin(1)=1
        planets(b).mon_noamax(1)=5
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=lastplanet
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        p=rnd_point(lastplanet,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        planets(b).depth=1
        
        
        planets(b).mon_template(0)=makemonster(29,a)
        planets(b).mon_noamin(0)=5
        planets(b).mon_noamax(0)=15
        
        planets(b).mon_template(1)=makemonster(65,a)
        planets(b).mon_noamin(1)=3
        planets(b).mon_noamax(1)=8
        
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-190
        for c=0 to 10
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\7,planets(a).depth),p.x,p.y,b,0,0)
        next
        for c=0 to 5
            placeitem(makeitem(rnd_range(1,lstcomit)),p.x,p.y,b,0,0)
        next
        placeitem(makeitem(89),p.x,p.y,lastplanet)
    endif
    
    if a=specialplanet(26) then
        b=-13
        
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=b
                if rnd_range(1,100)<22 then b=-14
                if rnd_range(1,100)<22 then b=-4
                if rnd_range(1,100)<22 then b=-3
                if rnd_range(1,100)<22 then b=-13
            next
        next
        
        for b=0 to 25
            p=rnd_point
                
            for c=0 to 15+rnd_range(2,6)+rnd_range(2,6)
                p=movepoint(p,5)
                planetmap(p.x,p.y,a)=-193
            next
        next
        for b=0 to rnd_range(2,4)
            p=rnd_point
            planetmap(p.x,p.y,a)=-191
        next
        p=rnd_point
        planetmap(p.x,p.y,a)=-132
        
        planets(a).mon_template(0)=makemonster(31,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=15
        
        planets(a).mon_template(1)=makemonster(65,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makecavemap(gc,4-rnd_range(1,8),2-rnd_range(1,4),-1,0)
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,b))).walktru>0 then planetmap(x,y,b)=-194
            next
        next
    
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191   
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191   
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191
        
        planets(b).depth=1
        planets(b).mon_template(0)=makemonster(31,b)
        planets(b).mon_noamin(0)=5
        planets(b).mon_noamax(0)=15
                
        planets(b).mon_template(1)=makemonster(65,b)
        planets(b).mon_noamin(1)=3
        planets(b).mon_noamax(1)=10
        
        planets(b).atmos=6
        
        lastportal=lastportal+1
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=7
        portal(lastportal).from.m=lastplanet
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        p=rnd_point(lastplanet,0)
        portal(lastportal).from.x=p.x
        portal(lastportal).from.y=p.y
        
        portal(lastportal).dest.m=lastplanet+1
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_all
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        b=lastplanet
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=b
        makelabyrinth(b)
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,b))).walktru>0 then planetmap(x,y,b)=-194
                if abs(planetmap(x,y,b))=151 then planetmap(x,y,b)=-195
            next
        next
        planets(b).depth=2
        planets(b).mon_template(0)=makemonster(31,a)
        planets(b).mon_noamin(0)=15
        planets(b).mon_noamax(0)=20        
        
        planets(b).mon_template(1)=makemonster(65,b)
        planets(b).mon_noamin(1)=10
        planets(b).mon_noamax(1)=12
        
        planets(b).atmos=6
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191
        
        p=rnd_point(b,0)
        portal(lastportal).dest.x=p.x
        portal(lastportal).dest.y=p.y
    endif
        
    if a=specialplanet(27) then
        makecraters(a,3)
        
        deletemonsters(a)
        p.x=30
        p.y=10
        p2.x=8
        p2.y=5
        p3.x=50
        p3.y=6
        p4.x=7
        p4.y=13
        p5.x=50
        p5.y=14
        p2=movepoint(p2,5)
        p3=movepoint(p3,5)
        p4=movepoint(p4,5)
        p5=movepoint(p5,5)
        b=10
        for x=0 to 60
            for y=0 to 20
                p1.x=x
                p1.y=y
                if int(distance(p,p1))=b  or int(distance(p,p1))=b-2 then planetmap(x,y,a)=-8 
                if int(distance(p,p1))=b-1 then planetmap(x,y,a)=-7  
                if distance(p,p1)<b-2 then planetmap(x,y,a)=-4 
                if distance(p,p1)<b-4 then planetmap(x,y,a)=-186 
                if distance(p,p1)<b-6 then planetmap(x,y,a)=-185 
                
                if distance(p2,p1)<5 then planetmap(x,y,a)=-186
                if distance(p2,p1)<2.5 then planetmap(x,y,a)=-185
                
                if distance(p3,p1)<5 then planetmap(x,y,a)=-186
                if distance(p3,p1)<2.5 then planetmap(x,y,a)=-185
            
                if distance(p4,p1)<5 then planetmap(x,y,a)=-186
                if distance(p4,p1)<2.5 then planetmap(x,y,a)=-185
            
                if distance(p5,p1)<5 then planetmap(x,y,a)=-186
                if distance(p5,p1)<2.5 then planetmap(x,y,a)=-185
            
            next
        next
        p=rnd_point()
        planetmap(p.x,p.y,a)=-rnd_range(140,143)
        p=rnd_point()
        planetmap(p.x,p.y,a)=-rnd_range(140,143)
        planets(a).mon_template(0)=makemonster(36,a)
        planets(a).mon_noamin(0)=2
        planets(a).mon_noamax(0)=5
        planets(a).mon_template(1)=makemonster(79,a)
        planets(a).mon_noamin(1)=2
        planets(a).mon_noamax(1)=5
        
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
            
        makecavemap(gc1,3,1,0,0)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<45 then planetmap(x,y,lastplanet)=-186
            next
        next
        
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=3
        planets(lastplanet).mon_noamax(0)=7
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=3
        planets(lastplanet).mon_noamax(1)=7
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        for b=0 to 2
            gc.m=a
            p1=rnd_point(a,0)
            gc.y=p1.y
            if b=0 then gc.x=rnd_range(5,15)
            if b=1 then gc.x=rnd_range(25,35)
            if b=1 then gc.y=rnd_range(7,13)
            if b=2 then gc.x=rnd_range(50,55)
            planetmap(gc.x,gc.y,a)=-185
            gc1.m=lastplanet
            p2=rnd_point(lastplanet,0)
            gc1.x=p2.x
            gc1.y=p2.y
            addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        next
        gc.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
        makecavemap(gc1,2,3,0,0)
        addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<35 then planetmap(x,y,lastplanet)=-186
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
            next
        next
        
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=6
        planets(lastplanet).mon_noamax(0)=17
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=6
        planets(lastplanet).mon_noamax(1)=17
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        gc.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet=lastplanet+1
        gc1.m=lastplanet
        p2=rnd_point(lastplanet,0)
        gc1.x=p2.x
        gc1.y=p2.y
        makecavemap(gc1,2,3,0,0)
        addportal(gc,gc1,0,asc("o"),"a dark cave entry",8)
        for x=0 to 60
            for y=0 to 20
                p3.x=x
                p3.y=y
                p4.x=30
                p4.y=10
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<15 then planetmap(x,y,lastplanet)=-186
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
            next
        next
        planetmap(30,10,lastplanet)=-187
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=13
        planets(lastplanet).mon_noamax(0)=27
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=13
        planets(lastplanet).mon_noamax(1)=27
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
    endif
    
    if a=specialplanet(29)then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-4
            next
        next
        
        deletemonsters(a)
        planets(a).flavortext="This is truly the most boring piece of rock you have ever laid eyes upon."
        planets(a).atmos=4
    endif
    
    if specialplanet(30)=a then 'Secret Base thingy
        wx=rnd_range(0,53)
        wy=rnd_range(0,13)
        
        deletemonsters(a)
        for x=wx to wx+7
            for y=wy to wy+7
                planetmap(x,y,a)=-18
            next
        next
        for x=wx+1 to wx+6
            for y=wy+1 to wy+6
                planetmap(x,y,a)=-16
            next
        next
        planetmap(wx+4,wy+4,a)=-4
        'planets(a).depth=7
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=ASC("#")
        portal(lastportal).ti_no=3006
        portal(lastportal).col=14
        portal(lastportal).from.m=a
        portal(lastportal).from.x=wx+4
        portal(lastportal).from.y=wy+4
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        
        makecomplex(portal(lastportal).dest,lastplanet,1)
        wx=rnd_range(0,53)
        wy=rnd_range(0,13)
        for x=wx to wx+4
            for y=wy to wy+4
                planetmap(x,y,a)=-18
            next
        next
        for x=wx+1 to wx+3
            for y=wy+1 to wy+3
                planetmap(x,y,a)=-80
                if rnd_range(1,100)<33 then planetmap(x,y,a)=-81
                placeitem(makeitem(rnd_range(96,99)),x,y,a)
            next
        next
        
        for b=0 to 6
            p1=rnd_point(lastplanet,0)
            p1.m=lastplanet
            lastplanet+=1
            p2=rnd_point(lastplanet,0)
            p2.m=lastplanet
            makecomplex(p2,lastplanet,1)
            if b<6 then addportal(p1,p2,0,asc("o"),"A shaft",14)
        next    
        lastplanet+=1
        p2.x=30
        p2.y=2
        p2.m=lastplanet
        addportal(p1,p2,0,asc("o"),"A very deep shaft",14)
        makefinalmap(lastplanet)
    endif
    
    if a=specialplanet(31)then
        makemossworld(a,4)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=1 then planetmap(x,y,a)=-4 
                if abs(planetmap(x,y,a))=2 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=102 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=103 then planetmap(x,y,a)=-158 
                if abs(planetmap(x,y,a))=104 then planetmap(x,y,a)=-80 
                if abs(planetmap(x,y,a))=105 then planetmap(x,y,a)=-145 
                if abs(planetmap(x,y,a))=106 then planetmap(x,y,a)=-145 
                if abs(planetmap(x,y,a))=146 then planetmap(x,y,a)=-145 
            next
        next
        for b=0 to 5
            pa(b)=rnd_point
        next
        for b=0 to 4
            planetmap(pa(b).x,pa(b).y,a)=-170
            if rnd_range(1,100)<2 then planetmap(pa(b).x,pa(b).y,a)=-169
        next
        
        planets(a).atmos=1
        planets(a).grav=.5
        planets(a).rot=12
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=15
        
        planets(a).mon_template(1)=makemonster(51,a)
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=15
        
        planets(a).mon_template(2)=makemonster(52,a)
        planets(a).mon_noamin(2)=5
        planets(a).mon_noamax(2)=15
        
        planets(a).atmos=6
        planets(a).temp=-241
        p.x=30
        p.y=10
        gc.x=pa(5).x
        gc.y=pa(5).y
        gc.m=a    
        for b=0 to 4
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(1,3)+b+2,rnd_range(0,1)+b,2,b*2)
            for c=0 to (b+1)*2
                p=rnd_point(lastplanet,0)
                placeitem(makeitem(96),p.x,p.y,lastplanet)
                p=rnd_point(lastplanet,0)
                if rnd_range(1,100)<b+5 then placeitem(makeitem(99),p.x,p.y,lastplanet) 
            next
            
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc("o"),"A shaft",14)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet)=planets(a)
            planets(lastplanet).atmos=1
            planets(lastplanet).grav=.5
            planets(lastplanet).depth+=1
            planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
            planets(lastplanet).mon_noamin(0)=10
            planets(lastplanet).mon_noamax(0)=15
        
        next
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-234
    endif
    
    if a=specialplanet(32) then
        deletemonsters(a)
        pa(0).x=10
        pa(0).y=10
        pa(1).x=30
        pa(1).y=16
        pa(2).x=30
        pa(2).y=10
        d=rnd_range(1,3)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-8
                if rnd_range(1,100)<55 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<15 then planetmap(x,y,a)=-158
                p.x=x
                p.y=y
                if distance(pa(0),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(1),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(2),p)<4 then planetmap(x,y,a)=-4
                if x>10 and x<30 and y=10 then planetmap(x,y,a)=-4
                
            next
        next
        p=rnd_point(a,0)
        planetmap(p.x,p.y,a)=-138
        p=rnd_point
        p2=p
        do
            if p.x<30 then p.x+=1
            if p.x>30 then p.x-=1
            planetmap(p.x,p.y,a)=-4
            if p.y<10 then p.y+=1
            if p.y>10 then p.y-=1
            planetmap(p.x,p.y,a)=-4
        loop until p.x=30 and p.y=10
        planetmap(p2.x,p2.y,a)=-4
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        planets(a).atmos=1
        planets(a).grav=.3
        planets(a).temp=-211
        planets(a).rot=.8
        for b=0 to 2
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(2,5)+b+2,rnd_range(1,3)+b,3)
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(rnd_item(21),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(makeitem(96,6,-1),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-231
            p=rnd_point(lastplanet,0)
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc(">"),"Stairs",15)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet).depth+=1
            planets(lastplanet).atmos=1
            planets(lastplanet).temp=1
            if d=1 then planets(lastplanet).mon_template(0)=makemonster(40,lastplanet)
            if d=2 then planets(lastplanet).mon_template(0)=makemonster(13,lastplanet)
            if d=3 then planets(lastplanet).mon_template(0)=makemonster(29,lastplanet)
            planets(lastplanet).mon_template(0).hasoxy=1
            planets(lastplanet).mon_noamin(0)=10
            planets(lastplanet).mon_noamax(0)=15
        
        next
    endif
        
    if a=specialplanet(33) then
        pa(0).x=10
        pa(0).y=10
        pa(1).x=30
        pa(1).y=16
        pa(2).x=30
        pa(2).y=10
        
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-8
                if rnd_range(1,100)<55 then planetmap(x,y,a)=-7
                if rnd_range(1,100)<15 then planetmap(x,y,a)=-158
                p.x=x
                p.y=y
                if distance(pa(0),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(1),p)<4 then planetmap(x,y,a)=-4
                if distance(pa(2),p)<4 then planetmap(x,y,a)=-4
                
                if x>10 and x<30 and y=10 then planetmap(x,y,a)=-4
                
            next
        next
        for b=0 to 5
            p=rnd_point(a,0)
            if p.y=10 then p.y=11
            planetmap(p.x,p.y,a)=-67
        next
        p=rnd_point(a,2)
        p2=p
        do
            if p.x<30 then p.x+=1
            if p.x>30 then p.x-=1
            planetmap(p.x,p.y,a)=-4
            if p.y<10 then p.y+=1
            if p.y>10 then p.y-=1
            planetmap(p.x,p.y,a)=-4
        loop until p.x=30 and p.y=10
        planetmap(p2.x,p2.y,a)=-4
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        planets(a).atmos=1
        planets(a).grav=.3
        planets(a).temp=-211
        planets(a).rot=.8
       
        planets(lastplanet).mon_template(0)=makemonster(3,a)
        planets(lastplanet).mon_noamin(0)=8
        planets(lastplanet).mon_noamax(0)=12
        for b=0 to 2
            lastplanet+=1
            makeplatform(lastplanet,rnd_range(2,5)+b+2,rnd_range(0,2)+b,3)
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(rnd_item(21),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(makeitem(96,6,-1),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            
            p=rnd_point(lastplanet,0)
            d=0
            for c=0 to (b+1)*2
                if d<4 then planetmap(p.x,p.y,lastplanet)=-215-d
                d+=1
                planets(lastplanet).flags(11+d)=rnd_range(2,6)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-231
            p=rnd_point(lastplanet,0)
            gc1.x=p.x
            gc1.y=p.y
            gc1.m=lastplanet
            addportal(gc,gc1,0,asc(">"),"Stairs",15)
            p=rnd_point(lastplanet,0)
            gc.x=p.x
            gc.y=p.y
            gc.m=lastplanet
            planets(lastplanet).depth+=1
            planets(lastplanet).atmos=6
            planets(lastplanet).temp=16
            planets(lastplanet).mon_template(0)=makemonster(3,lastplanet)
            planets(lastplanet).mon_template(0).hasoxy=1
            planets(lastplanet).mon_noamin(0)=8+b
            planets(lastplanet).mon_noamax(0)=18+b
        next
    endif
    
    if a=specialplanet(34) then 'Radioactive World 
        planets(a).water=15
        makeislands(a,3)
        for c=1 to 12+rnd_range(1,6)
            p1=rnd_point
            b=rnd_range(0,2)+rnd_range(0,2)+2
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<b then planetmap(x,y,a)=-160
                        if distance(p1,p2)=b then planetmap(x,y,a)=-159
                    endif
                next
            next
            it=makeitem(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science+it.v2))*(it.v2*rnd_range(1,10-player.science))            
            placeitem(it,p1.x,p1.y,a)
        next
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100 
        planets(a).mon_template(0)=makemonster(2,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=7
    endif
    
    if a=specialplanet(35) then
        makeoceanworld(a,3)
        for b=0 to 36
            planetmap(rnd_range(0,60),rnd_range(4,16),a)=-239
        next
        planets(a).temp=12.3
        planets(a).rot=12.3 
        planets(a).mon_template(0)=makemonster(42,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=25
    endif
    
    if a=specialplanet(36) then
        planets(a).water=77
        makeislands(a,3)
        deletemonsters(a)
        planets(a).mon_template(0)=makemonster(43,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=25
        planets(a).temp=12.3
        planets(a).atmos=8
        planets(a).rot=12.3
        for b=0 to 36
            planetmap(rnd_range(0,60),rnd_range(4,16),a)=-90
        next
        lastplanet+=1
        gc.x=rnd_range(0,60)
        gc.y=rnd_range(0,20)
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc("o"),"A natural tunnel",7)
        makecavemap(gc1,2-rnd_range(1,4),4-rnd_range(1,8),0,0)
        for b=0 to 25
            planetmap(rnd_range(0,60),rnd_range(0,20),lastplanet)=-146
        next 
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(44,a)
        planets(lastplanet).mon_noamin(0)=1
        planets(lastplanet).mon_noamax(0)=1
        planets(lastplanet).depth=1
        planets(lastplanet).temp=12.3
        planets(lastplanet).atmos=8
        planets(lastplanet).rot=12.3
    endif
    
    if a=specialplanet(37) then 'Invisible Labyrinth
        planets(a).temp=12.3
        planets(a).atmos=8
        planets(a).rot=12.3
        it=makeitem(96,9,9)
        it.v2=6
        it.col=3
        it.desig="lutetium"
        it.discovered=1
        it.v5=(it.v1+rnd_range(1,player.science+it.v2))*(it.v2*rnd_range(1,10-player.science))            
        placeitem(it,30,10,a)
    endif
    
    if a=specialplanet(38) then 'Ted Rofes and the living trees
        planets(a).water=57
        deletemonsters(a)
        makeislands(a,3)
        planetmap(rnd_range(1,60),rnd_range(3,12),a)=-62
         
        planets(a).mon_template(0)=makemonster(45,a)
        planets(a).mon_noamin(0)=45
        planets(a).mon_noamax(0)=46
        planets(a).mon_template(1)=makemonster(48,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=1
        
        planets(a).temp=12.3
        planets(a).atmos=5
        planets(a).rot=12.3
        
        lastplanet+=1
        gc.x=rnd_range(0,60)
        gc.y=rnd_range(0,20)
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        planets(lastplanet)=planets(a)
        planets(lastplanet).depth=2
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
        planets(lastplanet).mon_noamin(0)=5
        planets(lastplanet).mon_noamax(0)=8
        makecavemap(gc1,3-rnd_range(1,4),3-rnd_range(1,6),0,0)
        addportal(gc,gc1,0,asc("o"),"A natural tunnel",7)
        gc.m=lastplanet   
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        lastplanet+=1
        planets(lastplanet)=planets(a)
        planets(lastplanet).depth=3
        deletemonsters(lastplanet)
                 
        planets(lastplanet).mon_template(0)=makemonster(8,lastplanet)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=25
        
        planets(lastplanet).mon_template(1)=makemonster(54,lastplanet)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=8
        
        planets(lastplanet).mon_template(2)=makemonster(53,lastplanet)
        planets(lastplanet).mon_noamin(2)=5
        planets(lastplanet).mon_noamax(2)=10
        
        gc1.x=rnd_range(1,59)
        gc1.y=rnd_range(1,19)
        gc1.m=lastplanet
        makecomplex(gc1,2)
        addportal(gc,gc1,0,asc("o"),"A shaft",14)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-240
    endif
    
    if a=specialplanet(39) then 'Burrowers
        deletemonsters(a)
        planets(a).grav=0.9
        planets(a).atmos=5
        planets(a).temp=15.3
        planets(a).weat=0
        makeislands(a,3)
        for b=0 to 166
            p1=rnd_point(a,0)
            planetmap(p1.x,p1.y,a)=-96
        next
        p1.x=30
        p1.y=10
        pa(0).x=rnd_range(1,20)
        pa(0).y=rnd_range(1,5)
        pa(1).x=rnd_range(21,40)
        pa(1).y=rnd_range(1,5)
        pa(2).x=rnd_range(41,60)
        pa(2).y=rnd_range(1,5)
        
        pa(3).x=rnd_range(1,20)
        pa(3).y=rnd_range(15,20)
        pa(4).x=rnd_range(21,40)
        pa(4).y=rnd_range(15,20)
        pa(5).x=rnd_range(41,60)
        pa(5).y=rnd_range(15,20)
        
        for b=0 to 5
            makeroad(pa(b),p1,a)
        next
        
        for b=0 to 5
            planetmap(pa(b).x,pa(b).y,a)=-16
        next
        planetmap(p1.x,p1.y,a)=-247
        
        planets(a).mon_template(0)=makemonster(85,a) 'Colonists
        
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        
        planets(a).mon_template(1)=makemonster(83,a) 'Burrowers
        planets(a).mon_noamin(1)=10
        planets(a).mon_noamax(1)=15
        
        for b=0 to 2
            lastplanet+=1
            lastportal+=1
            portal(lastportal).desig="A hole in the ground. "
            portal(lastportal).tile=asc("o")
            portal(lastportal).col=4
            portal(lastportal).from.m=a
            portal(lastportal).from.x=rnd_range(0,60)
            portal(lastportal).from.y=rnd_range(0,20)
            portal(lastportal).dest.m=lastplanet
            portal(lastportal).dest.x=rnd_range(1,59)
            portal(lastportal).dest.y=rnd_range(1,19)
            portal(lastportal).discovered=show_all
            portal(lastportal).tumod=10
            portal(lastportal).dimod=-3
            
            gc.x=portal(lastportal).dest.x
            gc.y=portal(lastportal).dest.y
            gc.m=lastplanet
            
            planets(lastplanet).grav=0.9
            planets(lastplanet).atmos=5
            planets(lastplanet).temp=15.3
            planets(lastplanet).weat=0
            planets(lastplanet).depth=1
            planets(lastplanet).mon_template(0)=makemonster(83,lastplanet)
            planets(lastplanet).mon_template(0).invis=0
            planets(lastplanet).mon_noamin(0)=20
            planets(lastplanet).mon_noamax(0)=25
            planets(lastplanet).mon_template(1)=makemonster(84,lastplanet)
            planets(lastplanet).mon_template(1).invis=0
            planets(lastplanet).mon_noamin(1)=2
            planets(lastplanet).mon_noamax(1)=5
            makecavemap(gc,6-rnd_range(2,7),3-rnd_range(1,6),0,0)
        next
    endif
        
    if a=specialplanet(40) then 'Eridianis Scandal
        planets(a).water=57
        planets(a).temp=33
        planets(a).rot=33
        planets(a).grav=0.9
        planets(a).atmos=5
        makeislands(a,3)
        p.x=rnd_range(1,52)
        p.y=rnd_range(1,12)
        for x=p.x to p.x+7
            for y=p.y to p.y+7
                if x=p.x or x=p.x+1 or x=p.x+6 or x=p.x+7 or y=p.y or y=p.y+1 or y=p.y+6 or y=p.y+7 then 
                    planetmap(x,y,a)=-16
                else
                    planetmap(x,y,a)=-68
                endif
            next
        next
        deletemonsters(a)
        planets(a).mon_template(0)=makemonster(86,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=15
        planets(a).mon_template(1)=makemonster(1,a)
        planets(a).mon_template(1).diet=2
        planets(a).mon_template(1).disease=13
        planets(a).mon_template(1).faction=1
        planets(a).mon_noamin(1)=5
        planets(a).mon_noamax(1)=10
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        gc.x=p.x+4
        gc.y=p.y+4
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(86,a)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=20
        planets(lastplanet).mon_template(1)=makemonster(87,a)
        planets(lastplanet).mon_noamin(1)=2
        planets(lastplanet).mon_noamax(1)=3
        planets(lastplanet).depth=3
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(86,a)
        planets(lastplanet).mon_noamin(0)=20
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_template(1)=makemonster(87,a)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=8
        planets(lastplanet).depth=6
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=250
    endif
    
    if a=specialplanet(41) then 'Smith heavy industries Scandal
        makecraters(a,3)
        deletemonsters(a)
        p1=rnd_point
        p2=rnd_point
        p3=rnd_point
        p1.x=rnd_range(1,20)
        p2.x=rnd_range(20,40)
        p3.x=rnd_range(40,55)
        makeroad(p1,p2,a)
        makeroad(p1,p3,a)
        
        for x=p2.x to p2.x+5
            for y=p2.y to p2.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-16
            next
        next
        for x=p1.x to p1.x+3
            for y=p2.y to p2.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-68
            next
        next
        for x=p3.x to p3.x+3
            for y=p3.y to p3.y+3
                if x<=60 and y<=20 then planetmap(x,y,a)=-16
            next
        next
        planets(a).atmos=1
        planets(a).temp=-233
        planets(a).grav=.3
        planets(a).mon_template(0)=makemonster(70,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        planets(a).mon_template(1)=makemonster(71,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        gc.x=p2.x+1
        gc.y=p2.y+1
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        if gc.x>60 then gc.x=60
        if gc.y>20 then gc.y=20
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        lastplanet+=1
        makecomplex3(lastplanet,10,0,0,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=15
        planets(lastplanet).mon_noamax(0)=20
        planets(lastplanet).mon_template(1)=makemonster(72,lastplanet)
        planets(lastplanet).mon_noamin(1)=5
        planets(lastplanet).mon_noamax(1)=6
        planets(lastplanet).mon_template(2)=makemonster(73,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        
        
        planets(lastplanet).depth=6
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=252
        lastplanet+=1
        makecomplex4(lastplanet,10,1)
        p=rnd_point(lastplanet-1,0)
        gc.x=p.x
        gc.y=p.y
        gc.m=lastplanet-1
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-252
        planets(lastplanet).mon_template(0)=makemonster(71,lastplanet)
        planets(lastplanet).mon_noamin(0)=20
        planets(lastplanet).mon_noamax(0)=25
        planets(lastplanet).mon_template(1)=makemonster(72,lastplanet)
        planets(lastplanet).mon_noamin(1)=8
        planets(lastplanet).mon_noamax(1)=10
        planets(lastplanet).mon_template(2)=makemonster(73,lastplanet)
        planets(lastplanet).mon_noamin(2)=20
        planets(lastplanet).mon_noamax(2)=25
        planets(lastplanet).depth=6
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        
    endif
    
    if a=specialplanet(42) then 'Triax Traders Scandal
        p2=rnd_point
        for x=p2.x to p2.x+5
            for y=p2.y to p2.y+5
                if x<60 and y<20 then 
                    planetmap(x,y,a)=-68
                    if rnd_range(1,100)<10 then planetmap(x,y,a)=67
                endif
            next
        next
        
        deletemonsters(a)
        gc.x=p2.x
        gc.y=p2.y
        gc.m=a
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        
        makeoutpost(a)
        planets(a).mon_template(0)=makemonster(7,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamin(0)=15
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-16 or planetmap(x,y,a)=+16 then 
                    p1.x=x
                    p1.y=y
                endif
            next
        next
        makeroad(p1,p2,a)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p2=rnd_point(lastplanet,0)
        
        gc.x=p2.x
        gc.y=p2.y
        gc.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,2)

        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(7,a)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(50,a)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=15
        planets(lastplanet).depth=3
        planets(lastplanet).atmos=4
        planets(lastplanet).darkness=1
        planets(lastplanet).grav=.3
        p2=rnd_point(lastplanet,0)
        planetmap(p2.x,p2.y,lastplanet)=-255
    endif
    
    if a=specialplanet(43) then 'Omega Bioengineering Scandal
        makeplatform(a,rnd_range(4,8),rnd_range(1,3),4)
        deletemonsters(a)
        planets(a).temp=-160
        planets(a).grav=.1
        planets(a).atmos=9
        planets(a).depth=1
        planets(a).mon_template(0)=makemonster(76,a)
        planets(a).mon_noamin(0)=5
        planets(a).mon_noamax(0)=8
        planets(a).mon_template(1)=makemonster(77,a)
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=5
        
        p1=rnd_point(a,,80)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,1)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        planets(lastplanet).mon_template(0)=makemonster(76,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(77,lastplanet)
        planets(lastplanet).mon_noamin(1)=4
        planets(lastplanet).mon_noamax(1)=6
        planets(lastplanet).mon_template(2)=makemonster(78,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        planets(lastplanet).depth=1
        p1=rnd_point(lastplanet,0)
        gc.x=p1.x
        gc.y=p1.y
        gc.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,6,60,60,1)
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc(">"),"Stairs",15)
        
        planets(lastplanet).mon_template(0)=makemonster(76,lastplanet)
        planets(lastplanet).mon_noamin(0)=10
        planets(lastplanet).mon_noamax(0)=15
        planets(lastplanet).mon_template(1)=makemonster(77,lastplanet)
        planets(lastplanet).mon_noamin(1)=8
        planets(lastplanet).mon_noamax(1)=10
        planets(lastplanet).mon_template(2)=makemonster(78,lastplanet)
        planets(lastplanet).mon_noamin(2)=10
        planets(lastplanet).mon_noamax(2)=15
        planets(lastplanet).depth=1
        for b=0 to 1
            p=rnd_point(lastplanet,0)
            x1=rnd_range(6,8)
            y1=rnd_range(4,6)
            if p.x+x1>=59 then p.x=p.x-x1-1
            if p.y+y1>=19 then p.y=p.y-y1-1
            if p.x<0 then p.x=1
            if p.y<0 then p.y=1
            
            for x=p.x to p.x+x1
                for y=p.y to p.y+y1
                    if x=p.x or y=p.y or x=p.x+x1 or y=p.y+y1 then
                        planetmap(x,y,lastplanet)=-52
                    else
                        planetmap(x,y,lastplanet)=-202
                    endif
                next
            next
            if b=0 then    
            planets(lastplanet).vault.x=p.x
            planets(lastplanet).vault.y=p.y
            planets(lastplanet).vault.w=x1
            planets(lastplanet).vault.h=y1
            planets(lastplanet).vault.wd(5)=3
            endif
        next
        planetmap(p.x+x1/2,p.y+y1/2,lastplanet)=257
        for x=1 to 59
            for y=1 to 19
                if abs(planetmap(x,y,lastplanet))=52 then
                    if abs(planetmap(x-1,y,lastplanet))=202 and abs(planetmap(x+1,y,lastplanet))=202 then
                        if abs(planetmap(x,y+1,lastplanet))=52 and abs(planetmap(x,y-1,lastplanet))=52 then planetmap(x,y,lastplanet)=-54
                    endif
                    if abs(planetmap(x,y-1,lastplanet))=202 and abs(planetmap(x,y+1,lastplanet))=202 then
                        if abs(planetmap(x-1,y,lastplanet))=52 and abs(planetmap(x+1,y,lastplanet))=52 then planetmap(x,y,lastplanet)=-54
                    endif
                endif
            next
        next
    endif
    
    if a=specialplanet(44) then
        makecraters(a,0)
        deletemonsters(a)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,a))=4 and rnd_range(1,100)<20 then planetmap(x,y,a)=-102 
                if abs(planetmap(x,y,a))=4 and rnd_range(1,100)<10 then planetmap(x,y,a)=-146
                if abs(planetmap(x,y,a))=7 and rnd_range(1,100)<10 then planetmap(x,y,a)=-244 
                if abs(planetmap(x,y,a))=8 and rnd_range(1,100)<15 then planetmap(x,y,a)=-244 
                if abs(planetmap(x,y,a))=8 and rnd_range(1,100)<15 then 
                    p.x=x
                    p.y=y
                endif
            next
        next
        if p.x=0 and p.y=0 then p=rnd_point
        planetmap(p.x,p.y,a)=-244
        
        planets(a).mon_template(0)=makemonster(8,a)
        planets(a).mon_noamin(0)=4
        planets(a).mon_noamax(0)=10
        
        gc.x=p.x
        gc.y=p.y
        gc.m=a
        p2=rnd_point
        gc1.x=p2.x
        gc1.y=p2.y
        lastplanet+=1
        gc1.m=lastplanet
        addportal(gc,gc1,1,asc("^"),"This tunnel leads deeper underground.",14)
        addportal(gc1,gc,1,asc("o"),"This tunnel leads back to the surface.",7)
        makecavemap(gc1,5,-1,0,0)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=4 and rnd_range(1,100)<20 then planetmap(x,y,lastplanet)=-102 
                if abs(planetmap(x,y,lastplanet))=4 and rnd_range(1,100)<12 then planetmap(x,y,lastplanet)=-146
            next
        next
        p.y=rnd_range(1,13)
        p.x=rnd_range(1,24)
        p2.x=rnd_range(30,54)
        p2.y=rnd_range(1,13)
        for x=p.x to p.x+6
            for y=p.y to p.y+6
                'planetmap(x,y,lastplanet)=-4
                if x=p.x or x=p.x+6 or y=p.y or y=p.y+6 then 
                    planetmap(x,y,lastplanet)=-52
                else
                    planetmap(x,y,lastplanet)=-4
                endif
            next
        next
        for x=p2.x to p2.x+6
            for y=p2.y to p2.y+6
                'planetmap(x,y,lastplanet)=-4
                if x=p2.x or x=p2.x+6 or y=p2.y or y=p2.y+6 then
                    planetmap(x,y,lastplanet)=-52
                else
                    planetmap(x,y,lastplanet)=-4
                endif
            next
        next
        planetmap(p.x+3,p.y,lastplanet)=-54
        planetmap(p.x+3,p.y+6,lastplanet)=-54
        planetmap(p.x,p.y+3,lastplanet)=-54
        planetmap(p.x+6,p.y+3,lastplanet)=-54
        
        planetmap(p2.x+3,p2.y,lastplanet)=-54
        planetmap(p2.x+3,p2.y+6,lastplanet)=-54
        planetmap(p2.x,p2.y+3,lastplanet)=-54
        planetmap(p2.x+6,p2.y+3,lastplanet)=-54
        
        
        planets(lastplanet).mon_template(0)=makemonster(8,a)
        planets(lastplanet).mon_noamin(0)=14
        planets(lastplanet).mon_noamax(0)=20
        
        planets(lastplanet).mon_template(1)=makemonster(56,a)
        planets(lastplanet).mon_noamin(1)=1
        planets(lastplanet).mon_noamax(1)=2
        
        for b=0 to 15
            placeitem(makeitem(301),p.x+3,p.y+3,lastplanet,0,0)
        next
        planetmap(p.x+3,p.y+3,lastplanet)=-4
    endif
    
    if a=specialplanet(isgasgiant(a)) and isgasgiant(a)>1 and isgasgiant(a)<40 then
        deletemonsters(a)
        makeplatform(a,rnd_range(4,8),rnd_range(1,3),1)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(makeitem(99),p.x,p.y,a,0,0)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(makeitem(99),p.x,p.y,a,0,0)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then planetmap(p.x,p.y,a)=-100
        p=rnd_point(a,0)
        if rnd_range(1,100)<88 then planetmap(p.x,p.y,a)=-178
        p=rnd_point(a,0)
        if rnd_range(1,100)<18 then planetmap(p.x,p.y,a)=-178

        planets(a).temp=-160
        planets(a).grav=1.1
        planets(a).atmos=9
        if rnd_range(1,100)<35 then                 
            planets(a).mon_template(0)=makemonster(8,a)
            planets(a).mon_noamin(0)=5
            planets(a).mon_noamax(0)=15
        endif
        if rnd_range(1,100)<25 then             
            planets(a).mon_template(0)=makemonster(9,a)
            planets(a).mon_noamin(0)=5
            planets(a).mon_noamax(0)=15
        endif
        if rnd_range(1,100)<15 then
             
            planets(a).mon_template(0)=makemonster(27,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=5
        endif
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(61,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
        
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(62,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
        
        if rnd_range(1,100)<10 then
            planets(a).mon_template(0)=makemonster(63,a)
            planets(a).mon_noamin(0)=1
            planets(a).mon_noamax(0)=3
        endif
    endif
    return 0
end function

function makedrifter(d as _driftingship, bg as short=0,broken as short=0) as short
    dim as short a,m,roll,x,y,f,ti,xs,ys,x2,y2,addweap,addcarg
    dim as byte retirementshop
    dim s as _ship
    dim pods(6,5,1) as short
    dim p as _cords
    dim crates(254) as _cords
    dim from as _cords
    dim dest as _cords
    dim lastcrate as short
    if bg=0 then
        m=d.m
    else
        m=lastplanet+1
        lastplanet+=1
        from.x=d.x
        from.y=d.y
        from.m=d.m
        d.m=m
    endif
    loadmap(d.s,lastplanet)  
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
    s=gethullspecs(d.s)
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
            if ti=999 then
                planetmap(x,y,m)=-202
                if rnd_range(1,100)<66 then
                    if retirementshop=1 and rnd_range(1,100)<33 then
                        planetmap(x,y,m)=-262
                    endif
                    if retirementshop=0 then
                        retirementshop=1
                        planetmap(x,y,m)=-270
                    endif
                    if rnd_range(1,100)<10 then
                        if rnd_range(1,100)<50 then
                            planetmap(x,y,m)=-261
                        else
                            planetmap(x,y,m)=-98
                        endif
                    endif
                endif
            endif
        next
    next
    
    
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=204 and rnd_range(1,100)<66 then planetmap(x,y,m)=-205
            if abs(planetmap(x,y,m))=202 and rnd_range(1,100)<8 and (d.s<=19) then 
                if abs(planetmap(x-1,y,m))=201 or abs(planetmap(x+1,y,m))=201 or abs(planetmap(x,y-1,m))=201 or abs(planetmap(x,y+1,m))=201 then 
                    planetmap(x,y,m)=-221
                    if rnd_range(1,100)<66 then planetmap(x,y,m)=-222
                    for a=0 to rnd_range(0,1)
                        if bg=0 then placeitem(rnd_item(21),x,y,m)
                    next
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
            if abs(planetmap(x,y,m))=200 and bg<>0 then planetmap(x,y,m)=-bg
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
        if roll<40 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(32,m)
            planets(m).mon_noamin(0)=s.h_maxcrew-1
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        endif
        
        if roll>39 and roll<50 then
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=makemonster(33,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            planets(m).flavortext="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. You feel like defiling a grave."
        endif
        
        if roll>49 and roll<60 then
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=1
            planets(m).mon_template(0)=makemonster(31,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(33,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets(m).flavortext="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. No sound reaches you through the vacuum but you see red alert lights still flashing."
        endif
        
        if roll>59 and roll<70 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(34,m)
            planets(m).mon_noamin(0)=d.s+10
            planets(m).mon_noamax(0)=d.s+15
            
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        endif
        
        if roll>69 and roll<80 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(3,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        endif
        
        if roll>79 and roll<85 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(18,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=makemonster(18,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        endif
        
        if roll>84 and roll<90 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(19,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        endif
        
        if roll>89 and roll<95 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(35,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=2
            
            planets(m).mon_template(1)=makemonster(35,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
        endif
        
        
        if roll>94 and roll<100 then
            planets(m).darkness=0
            planets(m).depth=1
            planets(m).atmos=4
            planets(m).mon_template(0)=makemonster(65,m)
            planets(m).mon_noamin(0)=minimum(1,s.h_maxcrew-3)
            planets(m).mon_noamax(0)=s.h_maxcrew
            
            planets(m).mon_template(1)=makemonster(29,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=2
            
            planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
        endif
        
        if roll>98 then
            planets(m).darkness=5
            planets(m).depth=1
            planets(m).atmos=4
            
            planets(m).mon_template(0)=makemonster(38,m)
            planets(m).mon_noamin(0)=1
            planets(m).mon_noamax(0)=1
            
            planets(m).mon_template(1)=makemonster(47,m)
            planets(m).mon_noamin(1)=1
            planets(m).mon_noamax(1)=1
            
            planets(m).flavortext="As you enter this " &shiptypes(d.s)& " you hear a squeaking noise almost like a jiggle. You feel uneasy. Something is here, and it is not friendly." 
        endif
    else
        'On planets surface
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=203 then 'Add portals from airlocks to planet surfaces
                    dest.x=x
                    dest.y=y
                    dest.m=lastplanet
                    addportal(from,dest,0,asc("@"),"abandoned ship",11)
                    exit for, for
                endif
            next
        next
        for x=0 to 60
            for y=0 to 20
                if broken=1 and abs(planetmap(x,y,m))=220 then planetmap(x,y,m)=-202
            next
        next
        if d.s=18 and broken=0 then planetmap(30,20,m)=-220
        m=dest.m
    endif
    planets(m).flags(0)=0
    planets(m).flags(1)=d.s
    planets(m).flags(2)=rnd_range(1,s.h_maxhull)
    planets(m).flags(3)=rnd_range(1,s.h_maxengine)
    planets(m).flags(4)=rnd_range(1,s.h_maxsensors)
    planets(m).flags(5)=rnd_range(0,s.h_maxshield)
    return 0
end function

function makecivilisation(slot as short,m as short) as short
    dim  as _cords p,p1,p2,p3,p4,p5
    dim as short x,y,a,b
'    n as string
'    ship as _ship
'    spec as _monster
'    aggr as byte
'    inte as byte
'    tech as byte
'    phil as byte
    
    specialflag(7)=0
    specialflag(46)=0
    civ(slot).n=alienname(3)
    civ(slot).popu=rnd_range(1,4)+rnd_range(1,4)+rnd_range(1,4)
    civ(slot).aggr=rnd_range(1,3) '1=submissive 2=neutral 3=agressive
    civ(slot).inte=rnd_range(1,3) '1=Science 2=Trade 3=conquest
    civ(slot).tech=rnd_range(1,3) 
    civ(slot).phil=rnd_range(1,3)'1=individualists 2=organized 3=collectivists
    if rnd_range(1,100)<50 then
        civ(slot).prefweap=0
    else
        civ(slot).prefweap=5
    endif
    civ(slot).spec=makemonster(1,m,1)
    civ(slot).spec.sdesc=civ(slot).n
    civ(slot).spec.ldesc="A " &civ(slot).n &". " &civ(slot).spec.ldesc
    civ(slot).spec.hpmax=civ(slot).spec.hpmax+rnd_range(1,civ(slot).tech)+rnd_range(1,civ(slot).aggr)
    civ(slot).spec.hp=civ(slot).spec.hpmax
    civ(slot).spec.armor=rnd_range(1,civ(slot).tech)
    civ(slot).spec.lang=32+slot
    civ(slot).spec.col=rnd_range(8,15)
    civ(slot).spec.aggr=1
    civ(slot).spec.faction=1+slot
    civ(slot).spec.allied=6+slot
    civ(slot).spec.hasoxy=1
    civ(slot).spec.cmmod=10-civ(slot).aggr
    civ(slot).spec.items(1)=201+slot*2
    civ(slot).spec.itemch(1)=35+civ(slot).aggr*10
    civ(slot).spec.items(2)=202+slot*2
    civ(slot).spec.itemch(2)=35+civ(slot).aggr*10
    civ(slot).spec.items(3)=-21
    civ(slot).spec.itemch(3)=88
    civ(slot).spec.items(3)=96
    civ(slot).spec.itemch(3)=25
    civ(slot).spec.items(4)=96
    civ(slot).spec.itemch(4)=77
    civ(slot).spec.items(5)=96
    civ(slot).spec.itemch(5)=66
    civ(slot).spec.swhat=" fires an exotic weapon"
    civ(slot).spec.scol=rnd_range(1,6)
    civ(slot).home=map(sysfrommap(m)).c
    for a=0 to 7
        faction(slot+6).war(a)=civ(slot).aggr*10 'Other Civ
    next
    makeplanetmap(m,3,3)
    deletemonsters(m)
    planets(m).mon_template(0)=civ(slot).spec
    planets(m).mon_noamin(0)=10
    planets(m).mon_noamax(0)=20
    makealiencolony(slot,m,civ(slot).popu)
    planetmap(rnd_range(1,60),rnd_range(1,20),m)=276+slot
    planetmap(rnd_range(1,60),rnd_range(1,20),m)=278+slot

    civ(slot).item(0).desig=civ(slot).n &" gun"
    civ(slot).item(0).desigp=civ(slot).n &" guns"
    civ(slot).item(0).ty=2
    civ(slot).item(0).id=201+slot*2
    civ(slot).item(0).v1=(rnd_range(0,3)+rnd_range(0,3)+rnd_range(0,3)+rnd_range(0,civ(slot).aggr)+rnd_range(0,civ(slot).tech)-2)/10'damage
    civ(slot).item(0).v2=(rnd_range(1,3)+rnd_range(1,3)+civ(slot).aggr+civ(slot).tech-2)'range
    civ(slot).item(0).v3=(rnd_range(0,3)+rnd_range(0,civ(slot).aggr)+rnd_range(0,civ(slot).tech)-5)'tohit
    if civ(slot).item(0).v1<=0 then civ(slot).item(0).v1=.1
    if civ(slot).item(0).v2<=0 then civ(slot).item(0).v2=1
    if civ(slot).item(0).v3<=0 then civ(slot).item(0).v3=1
    civ(slot).item(0).price=(civ(slot).item(0).v1*10+civ(slot).item(0).v2+civ(slot).item(0).v3)*75
    civ(slot).item(0).col=civ(slot).spec.col
    civ(slot).item(0).icon="-"
    civ(slot).item(0).ldesc="A gun used by the "&civ(slot).n &"  | | Accuracy: "&civ(slot).item(0).v3 &" | Damage: "&civ(slot).item(0).v1 &" | Range:"&civ(slot).item(0).v2
    
    civ(slot).item(1).desig=civ(slot).n &" blade"
    civ(slot).item(1).desigp=civ(slot).n &" blades"
    civ(slot).item(1).ty=4
    civ(slot).item(1).id=202+slot*2
    civ(slot).item(1).v1=(rnd_range(0,3)+rnd_range(0,3)+rnd_range(0,3)+civ(slot).aggr+civ(slot).tech-2)/10'damage
    civ(slot).item(1).v3=(rnd_range(0,3)+civ(slot).aggr+civ(slot).tech-5)'tohit
    if civ(slot).item(1).v1<=0 then civ(slot).item(1).v1=.1
    if civ(slot).item(1).v3<=0 then civ(slot).item(1).v3=1
    civ(slot).item(1).price=(civ(slot).item(1).v1*10+civ(slot).item(1).v3)*50
    civ(slot).item(1).col=civ(slot).spec.col
    civ(slot).item(1).icon="("
    civ(slot).item(1).ldesc="A close combat weapon used by the "&civ(slot).n &"  | | Accuracy: "&civ(slot).item(1).v3 &" | Damage: "&civ(slot).item(1).v1 
    
    makealienship(slot,0)
    makealienship(slot,1)
    
    for a=0 to 6
        if rnd_range(1,100)<66 then
            civ(slot).culture(a)=rnd_range(1,5+civ(slot).aggr+civ(slot).phil)
            if civ(slot).culture(a)>6 then civ(slot).culture(a)=6
        endif
    next
        
    tiles(272+slot).no=272+slot
    tiles(272+slot).tile=64 
    tiles(272+slot).col=civ(slot).spec.col
    tiles(272+slot).bgcol=0
    tiles(272+slot).desc="A "&civ(slot).n &" spaceship."
    tiles(272+slot).seetru=1
    tiles(272+slot).hides=2
    
    if rnd_range(1,100)<55 then
        tiles(274+slot).tile=asc("#") 
        tiles(274+slot).col=17
    else
        tiles(274+slot).tile=asc("O") 
        tiles(274+slot).col=137
    endif
    tiles(274+slot).bgcol=0
    tiles(274+slot).desc="A "&civ(slot).n &" building."
    tiles(274+slot).seetru=1
    tiles(274+slot).hides=2
    
    tiles(276+slot).tile=tiles(274+slot).tile
    tiles(276+slot).col=tiles(274+slot).col+2
    tiles(276+slot).seetru=1
    tiles(276+slot).gives=301+slot
    tiles(276+slot).hides=2
    tiles(276+slot).turnsinto=276+slot
    
    tiles(278+slot).tile=tiles(274+slot).tile
    tiles(278+slot).col=tiles(274+slot).col+3
    tiles(278+slot).seetru=1
    tiles(278+slot).gives=311+slot
    tiles(278+slot).hides=2
    tiles(278+slot).turnsinto=278+slot
    
    tiles(280+slot).tile=tiles(274+slot).tile
    tiles(280+slot).col=tiles(274+slot).col+3
    tiles(280+slot).seetru=1
    tiles(280+slot).gives=321+slot
    tiles(280+slot).hides=2
    tiles(280+slot).turnsinto=280+slot
    
    tiles(282)=tiles(280)
    tiles(282).gives=330
    tiles(282).turnsinto=282
    
    
    tiles(283+slot).tile=64 
    tiles(283+slot).col=civ(slot).spec.col
    tiles(283+slot).bgcol=0
    tiles(283+slot).desc="An alien scoutship"
    tiles(283+slot).seetru=1
    tiles(283+slot).walktru=0
    tiles(283+slot).firetru=1
    tiles(283+slot).shootable=1
    tiles(283+slot).locked=3
    tiles(283+slot).spawnson=100
    tiles(283+slot).spawnswhat=81+slot
    tiles(283+slot).spawnsmax=1
    tiles(283+slot).spawnblock=1
    tiles(283+slot).turnsinto=62
    tiles(283+slot).dr=2
    tiles(283+slot).hp=25
    tiles(283+slot).succt="It is slightly dented now"
    tiles(283+slot).failt="Your handwapons arent powerful enough to damage a spaceship"
    tiles(283+slot).killt="That will teach them a lesson!"
    tiles(283+slot).hides=2
    
    if slot=0 then
        if civ(slot).phil=1 then specialplanettext(7,0)="A planet with many small, modern structures dotting the landscape"
        if civ(slot).phil=2 then specialplanettext(7,0)="A planet with several medium to large cities distributed on the surface"
        if civ(slot).phil=3 then specialplanettext(7,0)="A planet with a huge, dominating megacity"
        specialplanettext(7,1)="The homeworld of the "&civ(slot).n
        if civ(slot).culture(4)=5 then 
            specialplanettext(7,0)=specialplanettext(7,0) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!"
            specialplanettext(7,1)=specialplanettext(7,1) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!"
        endif
    endif
    if slot=1 then
        if civ(slot).phil=1 then specialplanettext(46,0)="A planet with many small, modern structures dotting the landscape"
        if civ(slot).phil=2 then specialplanettext(46,0)="A planet with several medium to large cities distributed on the surface"
        if civ(slot).phil=3 then specialplanettext(46,0)="A planet with a huge, dominating megacity"
        specialplanettext(46,1)="The homeworld of the "&civ(slot).n
        if civ(slot).culture(4)=5 then 
            specialplanettext(46,0)=specialplanettext(46,0) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!" 
            specialplanettext(46,1)=specialplanettext(46,1) &". In its orbit you discover a spacestation, connected to the ground by a gargantuan cable. A space lift!" 
        endif
    endif
    if civ(slot).culture(3)=5 then 'Tamed robots
        planets(m).mon_template(2)=makemonster(8,m)
        planets(m).mon_template(2).faction=1+slot
        planets(m).mon_template(2).cmmod=6
        planets(m).mon_noamin(2)=3
        planets(m).mon_noamax(2)=8
    endif
    if civ(slot).culture(4)=2 then
        lastplanet+=1
        p1=rnd_point
        p1.m=lastplanet
        makecavemap(p1,rnd_range(1,4),rnd_range(1,4),0,0)
        p2=rnd_point
        p2.m=m
        addportal(p1,p2,0,asc("o"),"A natural tunnel",7)
        planets(lastplanet)=planets(m)
        planets(lastplanet).life=planets(lastplanet).life+5
        planets(lastplanet).depth=1
        planets(lastplanet).weat=0
        for b=0 to planets(a).life
            planets(lastplanet).mon_noamin(b)=0
            planets(lastplanet).mon_noamax(b)=0
            if rnd_range(1,100)<100-b*10 then 
                planets(lastplanet).mon_template(b)=makemonster(1,lastplanet)
                planets(lastplanet).mon_noamin(b)=rnd_range(1,planets(lastplanet).life)*planets(lastplanet).mon_template(b).diet
                planets(lastplanet).mon_noamax(b)=rnd_range(1,planets(lastplanet).life)*2*planets(lastplanet).mon_template(b).diet
                if planets(lastplanet).mon_noamin(b)>planets(lastplanet).mon_noamax(b) then swap planets(lastplanet).mon_noamin(b),planets(lastplanet).mon_noamax(b)
            endif
        next
        p1=rnd_point
        placeitem(makeitem(205,slot),p1.x,p1.y,lastplanet)
        placeitem(makeitem(201+slot*2),p1.x,p1.y,lastplanet)
        placeitem(makeitem(202+slot*2),p1.x,p1.y,lastplanet)
    endif
    if civ(slot).culture(4)=4 then 'slave population
        planets(m).mon_template(2)=makemonster(1,m,1)
        planets(m).mon_template(2).faction=1+slot
        planets(m).mon_template(2).lang=34
        planets(m).mon_template(2).cmmod=6
        planets(m).mon_noamin(2)=5
        planets(m).mon_noamax(2)=10
    endif
    if civ(slot).culture(4)=5 then 'Space lift
        lastplanet+=1
        p1.x=30
        p1.y=5
        p2.x=30
        p2.y=15
        p3.x=5
        p3.y=10
        p4.x=55
        p4.y=10
        for x=0 to 60
            for y=0 to 20
                p.x=x
                p.y=y
                planetmap(x,y,lastplanet)=-200
                if distance(p,p1)<=9 then planetmap(x,y,lastplanet)=-68
                if distance(p,p2)<=9 then planetmap(x,y,lastplanet)=-68
                if distance(p,p3)<=9 then planetmap(x,y,lastplanet)=-68
                if distance(p,p4)<=9 then planetmap(x,y,lastplanet)=-68
                if distance(p,p1)<=7 then planetmap(x,y,lastplanet)=-201
                if distance(p,p2)<=7 then planetmap(x,y,lastplanet)=-201
                if distance(p,p3)<=7 then planetmap(x,y,lastplanet)=-201
                if distance(p,p4)<=7 then planetmap(x,y,lastplanet)=-201
                if distance(p,p1)<5 then planetmap(x,y,lastplanet)=-202
                if distance(p,p2)<5 then planetmap(x,y,lastplanet)=-202
                if distance(p,p3)<5 then planetmap(x,y,lastplanet)=-202
                if distance(p,p4)<5 then planetmap(x,y,lastplanet)=-202
            next
        next
        for x=0 to 60
            for y=0 to 20
                if y=9 and x>5 and x<55 then planetmap(x,y,lastplanet)=-202
                if y=10 and x>5 and x<55 then planetmap(x,y,lastplanet)=-202
                if y=11 and x>5 and x<55 then planetmap(x,y,lastplanet)=-202
                if x>5 and x<55 and (y=8 or y=12) then
                    if planetmap(x,y,lastplanet)=-200 or planetmap(x,y,lastplanet)=-68 then 
                        if y=8 then planetmap(x,y-1,lastplanet)=-68
                        if y=12 then planetmap(x,y+1,lastplanet)=-68
                        planetmap(x,y,lastplanet)=-201
                    endif
                endif
            next
        next
        planets(lastplanet)=planets(m)
        planets(lastplanet).grav=planets(lastplanet).grav/5
        planets(lastplanet).depth=1
        planets(lastplanet).weat=0
        p.x=30
        p.y=10
        p.m=lastplanet
        p2.x=30
        p2.y=10
        p2.m=m
        addportal(p,p2,0,asc("o"),"A space lift",14)
        for a=0 to 5
            p=rnd_point(lastplanet,0)
            planetmap(p.x,p.y,lastplanet)=-267
        next
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-282
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-266
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-280-slot 'Shop
        p=rnd_point(lastplanet,0)
        planetmap(p.x,p.y,lastplanet)=-280-slot 'Shop
    
    endif 
    
    'shop21+slot= alienshop
    shopitem(1,22+slot)=civ(slot).item(0)
    shopitem(2,22+slot)=civ(slot).item(1)
    b=2
    for a=0 to civ(slot).tech*2+civ(slot).inte
       b+=1
       shopitem(b,22+slot)=(rnd_item(5))
    next
    return 0
end function

function makealiencolony(slot as short,map as short, popu as short) as short
    dim as short a,x,y,xw,yw,sh
    dim as _cords p,p2,ps(20)
    if civ(slot).phil=1 then
        for a=0 to popu*10
            p=rnd_point
            planetmap(p.x,p.y,map)=-274-slot
        next
        for a=0 to popu*3
            p=rnd_point
            planetmap(p.x,p.y,map)=-68
            if rnd_range(1,100)<civ(slot).tech*10 then planetmap(p.x,p.y,map)=-272-slot
        next
    endif
    if civ(slot).phil=2 then
        for a=0 to popu*10
            if a<=20 then ps(a)=rnd_point
        next
        for a=0 to popu*10-1 step 2 
            if a<=19 then makeroad(ps(a),ps(a+1),map)
        next
        for a=0 to popu*10
            if a<=20 then 
                p=ps(a)
            else
                p=rnd_point
            endif
            if p.x<1 then p.x=1
            if p.x>59 then p.x=59
            if p.y<1 then p.y=1
            if p.y>19 then p.y=19
            planetmap(p.x,p.y,map)=-274-slot
            planetmap(p.x,p.y-1,map)=-274-slot
            planetmap(p.x,p.y+1,map)=-274-slot
            planetmap(p.x+1,p.y,map)=-274-slot
            planetmap(p.x-1,p.y,map)=-274-slot
        next
        for a=1 to rnd_range(1,3)
            p=rnd_point
            xw=rnd_range(2,4)
            yw=rnd_range(2,4)
            for x=p.x to p.x+xw
                for y=p.y to p.y+yw
                    if x>=0 and x<=60 and y>=0 and y<=20 then
                        planetmap(x,y,map)=-68
                        if rnd_range(1,100)<civ(slot).tech*10 then planetmap(x,y,map)=-272-slot
                    endif
                next
            next
        next
    endif
    if civ(slot).phil=3 then
        p=rnd_point
        for x=p.x-10 to p.x+10
            for y=p.y-10 to p.y+10
                if x>=0 and x<=60 and y>=0 and y<=20 then
                    p2.x=x
                    p2.y=y
                    if distance(p2,p)<popu+2 then planetmap(x,y,map)=-68
                    if rnd_range(1,100)<civ(slot).tech*10 then planetmap(p.x,p.y,map)=-272-slot
                    if distance(p2,p)<popu then planetmap(x,y,map)=-274-slot
                endif
            next
        next
        planetmap(p.x,p.y,map)=-68
    endif
    if civ(slot).inte=2 then
        sh=3
    else
        sh=1
    endif
    for a=0 to sh
        if rnd_range(1,100)<(popu+sh)*5 then
            p=rnd_point(map,0)
            planetmap(p.x,p.y,map)=-280-slot
        endif
    next
    return 0
end function


function makealienship(slot as short,t as short) as short
    dim as short c,wc,cc,roll
    dim chance(3) as short '3 chance for weapon 2 chance for cargo 1 chance for sensors
    if civ(slot).inte=1 then
        chance(1)=20
    else
        chance(1)=10
    endif
    
    if civ(slot).inte=2 then
        chance(2)=20
    else
        chance(2)=10
    endif
    
    if civ(slot).inte=3 then
        chance(3)=30
    else
        chance(3)=10
    endif
    
    
    civ(slot).ship(t).hull=5+rnd_range(1,civ(slot).tech)*5*(t+1)-rnd_range(1,civ(slot).phil)*3*(t+1)
    if civ(slot).ship(t).hull<1 then civ(slot).ship(t).hull=1
    civ(slot).ship(t).shieldmax=rnd_range(1,civ(slot).tech)-2
    if civ(slot).ship(t).shieldmax<0 then civ(slot).ship(t).shieldmax=0
    civ(slot).ship(t).shield=civ(slot).ship(t).shieldmax
    civ(slot).ship(t).sensors=rnd_range(1,civ(slot).tech)
    civ(slot).ship(t).col=civ(slot).spec.col
    civ(slot).ship(t).engine=1
    civ(slot).ship(t).pilot=3
    civ(slot).ship(t).gunner=3
    wc=2
    cc=1
    civ(slot).ship(t).weapons(1)=makeweapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
    for c=0 to civ(slot).ship(t).hull step 5
        if rnd_range(1,100)<75 then
            civ(slot).ship(t).engine+=1
        else
            civ(slot).ship(t).engine-=1
        endif
        if rnd_range(1,100)<50 then
            civ(slot).ship(t).pilot+=1
        else
            civ(slot).ship(t).pilot-=1
        endif
        if rnd_range(1,100)<50 then
            civ(slot).ship(t).gunner+=1
        else
            civ(slot).ship(t).gunner-=1
        endif
            
        roll=rnd_range(1,100)
        select case roll
        case 0 to chance(1)
            civ(slot).ship(t).weapons(wc)=makeweapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
            wc+=1
        case chance(1)+1 to chance(1)+chance(2)
            civ(slot).ship(t).cargo(cc).x=1
            cc+=1
        case chance(1)+chance(2)+1 to chance(1)+chance(2)+chance(3)
            civ(slot).ship(t).sensors+=1
        case else
            if civ(slot).inte=1 then
                civ(slot).ship(t).sensors+=1
            endif
            if civ(slot).inte=2 then
                civ(slot).ship(t).cargo(cc).x=1
                cc+=1
            endif
            if civ(slot).inte=3 then
                civ(slot).ship(t).weapons(wc)=makeweapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
                wc+=1
            endif
        end select
        
    
    next
    civ(slot).ship(t).c.x=rnd_range(1,60)
    civ(slot).ship(t).c.y=rnd_range(1,20)
    if civ(slot).ship(t).engine<1 then civ(slot).ship(t).engine=1
    if civ(slot).ship(t).gunner<1 then civ(slot).ship(t).gunner=1
    if civ(slot).ship(t).pilot<1 then civ(slot).ship(t).pilot=1
    civ(slot).ship(t).h_maxweaponslot=wc-1
    civ(slot).ship(t).h_maxhull=civ(slot).ship(t).hull
    if t=0 then civ(slot).ship(t).icon=left(civ(slot).n,1)
    if t=1 then civ(slot).ship(t).icon=lcase(left(civ(slot).n,1))
    if civ(slot).inte=1 then
        if t=0 then civ(slot).ship(t).desig=civ(slot).n &" explorer"
        if t=1 then civ(slot).ship(t).desig=civ(slot).n &" scout"
    endif
    if civ(slot).inte=2 then 
        if t=0 then civ(slot).ship(t).desig=civ(slot).n &" merchantman"
        if t=1 then civ(slot).ship(t).desig=civ(slot).n &" transporter"
    endif
    if civ(slot).inte=3 then 
        if t=0 then civ(slot).ship(t).desig=civ(slot).n &" warship"
        if t=1 then civ(slot).ship(t).desig=civ(slot).n &" fighter"
    endif
    civ(0).ship(0).ti_no=45
    civ(0).ship(1).ti_no=46
    civ(1).ship(0).ti_no=47
    civ(1).ship(1).ti_no=48
    return 0
end function


function makeice(o as short,a as short) as short
    dim as short ice,x,y
    ice=(10-o)*rnd_range(5,10)
    if o<3 then ice=100
    if a<0 or a>1024 then print a
    for x=0 to 60
        for y=0 to 10
            if rnd_range(1,100)<=(100-(y*ice)) then
                if rnd_range(1,100)<65 then
                   
                    planetmap(x,y,a)=-14
                else
                    if rnd_range(1,100)<65 then
                        planetmap(x,y,a)=-7
                    else
                        planetmap(x,y,a)=-145
                    endif
                endif
            endif
            if rnd_range(1,100)<=(100-(y*ice)) then
               if rnd_range(1,100)<65 then
                    planetmap(x,20-y,a)=-14
                else
                    if rnd_range(1,100)<65 then
                        planetmap(x,20-y,a)=-7
                    else
                        planetmap(x,20-y,a)=-145
                    endif
                endif
            endif
        next
    next
    return 0
end function

function addportal(from as _cords, dest as _cords, oneway as short, tile as short,desig as string, col as short) as short
    dim e as short
    if from.x<0 then 
        dprint "error. tried to create portal at from.x="&from.x
        dest.x=0
    endif
    if from.y<0 then 
        dprint "error. tried to create portal at from.y="&from.y
        from.y=0
    endif
    if from.x>60 then
        dprint "error. tried to create portal at from.x="&from.x 
        from.x=60
    endif
    if from.y>20 then 
        dprint "error. tried to create portal at from.y="&from.y
        from.y=20
    endif
    
    if dest.x<0 then 
        dprint "error. tried to create portal at dest.x="&dest.x
        dest.x=0
    endif
    if dest.y<0 then 
        dprint "error. tried to create portal at from.y="&dest.y
        dest.y=0
    endif
    if dest.x>60 then
        dprint "error. tried to create portal at from.x="&dest.x 
        dest.x=60
    endif
    if dest.y>20 then 
        dprint "error. tried to create portal at from.y="&dest.y
        dest.y=20
    endif
    lastportal=lastportal+1
    portal(lastportal).from=from
    portal(lastportal).dest=dest
    portal(lastportal).oneway=oneway
    portal(lastportal).tile=tile
    portal(lastportal).col=col
    portal(lastportal).desig=desig
    portal(lastportal).discovered=show_all
    if tile=asc("o") then portal(lastportal).ti_no=3001
    if tile=asc("#") and col=14 then portal(lastportal).ti_no=3002
    if tile=asc("o") and col=14 then portal(lastportal).ti_no=3003
    if tile=asc(">") then portal(lastportal).ti_no=3004
    if tile=asc("^") then portal(lastportal).ti_no=3005
    return 0
end function

function deleteportal(f as short=0, d as short=0) as short
    dim a as short
    for a=1 to lastportal
        if portal(a).from.m=f or portal(a).from.m=d then
            portal(a)=portal(lastportal)
            lastportal-=1
        endif
    next
    return 0
end function


function makesettlement(p as _cords,slot as short, typ as short) as short
    if typ=0 then
        if p.x>55 then p.x=55
        if p.y>15 then p.y=15
        planetmap(p.x+2,p.y,slot)=-228
        planetmap(p.x+2,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
        planetmap(p.x+1,p.y+2,slot)=-32
        planetmap(p.x+2,p.y+2,slot)=-229
        planetmap(p.x+3,p.y+2,slot)=-228
        planetmap(p.x+4,p.y+2,slot)=-32
        planetmap(p.x+5,p.y+2,slot)=-228
        planetmap(p.x+2,p.y+3,slot)=-31
        planetmap(p.x+2,p.y+4,slot)=-31
        planetmap(p.x+2,p.y+5,slot)=-228
    endif
    if typ=1 then
        if p.x>53 then p.x=53
        if p.y>13 then p.y=13
        planetmap(p.x+2,p.y-2,slot)=-228
        planetmap(p.x+2,p.y-1,slot)=-31
        planetmap(p.x+2,p.y,slot)=-228
        planetmap(p.x+2,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
        planetmap(p.x+1,p.y+2,slot)=-32
        planetmap(p.x+2,p.y+2,slot)=-229
        planetmap(p.x+3,p.y+2,slot)=-32
        planetmap(p.x+4,p.y+2,slot)=-32
        planetmap(p.x+5,p.y+2,slot)=-228
        planetmap(p.x+6,p.y+2,slot)=-32
        planetmap(p.x+7,p.y+2,slot)=-228
        planetmap(p.x+2,p.y+3,slot)=-31
        planetmap(p.x+2,p.y+4,slot)=-31
        planetmap(p.x+2,p.y+5,slot)=-228
    endif
    if typ=2 then
        if p.y>58 then p.y=58
        planetmap(p.x,p.y,slot)=-228
        planetmap(p.x,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-228
    endif
    if typ=3 then
        if p.x>53 then p.x=53
        if p.y>13 then p.y=13
        planetmap(p.x,p.y,slot)=-228
        planetmap(p.x,p.y+1,slot)=-31
        planetmap(p.x,p.y+2,slot)=-229
        planetmap(p.x+1,p.y,slot)=-32
        planetmap(p.x+2,p.y,slot)=-228
    endif
        
    return 0
end function

function makeroad(byval s as _cords,byval e as _cords, a as short) as short
    dim as short x,y
    do
        if s.x>e.x then s.x=s.x-1
        if s.x<e.x then s.x=s.x+1
        planetmap(s.x,s.y,a)=-31
        if s.y>e.y then s.y=s.y-1
        if s.y<e.y then s.y=s.y+1
        planetmap(s.x,s.y,a)=-32
    loop until s.x=e.x and s.y=e.y
    for x=1 to 59
            for y=1 to 19
                if planetmap(x,y,a)<-30 and planetmap(x,y,a)>-42 then
                    if (planetmap(x-1,y,a)<-30 and planetmap(x-1,y,a)>-42) or (planetmap(x+1,y,a)<-30 and planetmap(x+1,y,a)>-42) then planetmap(x,y,a)=-32
                    if (planetmap(x,y-1,a)<-30 and planetmap(x,y-1,a)>-42) or (planetmap(x,y+1,a)<-30 and planetmap(x,y+1,a)>-42) then planetmap(x,y,a)=-31
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)>-42 and planetmap(x,y+1,a)>-42 then 'bow down
                        planetmap(x,y,a)=-34
                    endif
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)>-42 and planetmap(x,y-1,a)>-42 then 'bow up
                        planetmap(x,y,a)=-35
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y+1,a)>-42 then 'bow down
                        planetmap(x,y,a)=-36
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y-1,a)>-42 then 'bow up
                        planetmap(x,y,a)=-37
                    endif
                    
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow down
                        planetmap(x,y,a)=-38
                    endif
                    if planetmap(x,y+1,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x+1,y,a)>-42  then 'bow up
                        planetmap(x,y,a)=-39
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y+1,a)<-30 and planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y+1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow down
                        planetmap(x,y,a)=-40
                    endif
                    if planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)>-42 and planetmap(x,y-1,a)>-42 and planetmap(x-1,y,a)>-42 then 'bow up
                        planetmap(x,y,a)=-41
                    endif
                    
                    if planetmap(x-1,y,a)<-30 and planetmap(x+1,y,a)<-30 and planetmap(x,y-1,a)<-30 and planetmap(x,y+1,a)<-30 then
                        planetmap(x,y,a)=-33
                    endif
                endif
            next
        next
        
    return 0
end function


function findsmartest(start as short, iq as short, enemy() as _monster, lastenemy as short) as short
    dim a as short
    if start<lastenemy then
        for a=start to lastenemy
            if enemy(a).intel=iq then return a
        next
    endif
    return -1
end function

function makevault(r as _rect,slot as short,nsp as _cords, typ as short) as short
    dim as short x,y,a,b,c,d,nodo,best,bx,by
    dim p(31) as _cords
    dim wmap(r.w,r.h) as short
    dim as single rad
    
    r.wd(16)=typ
    if typ=1 or typ=2 then
        do
           if r.h>10 then r.h=r.h-rnd_range(3,6)
           if r.w>10 then r.w=r.w-rnd_range(3,6)
        loop until r.h+r.w<30
        
        for x=r.x to r.x+r.w
            for y=r.y to r.y+r.h
                if x=r.x or y=r.y or x=r.x+r.w or y=r.y+r.h then
                    planetmap(x,y,slot)=6
                else
                    planetmap(x,y,slot)=0
                endif
            next
        next
        
        for a=1 to 10
            do 
                do
                    d=rnd_range(1,8)
                    if d=4 then d=d+1
                loop until frac(d/2)=0
                p(a)=rndrectwall(r,d)
            loop until p(a).x>0 and p(a).y>0 and p(a).y<60 and p(a).y<20
        next
        
        nodo=rnd_range(1,5)+rnd_range(1,5)-4
        if nodo<1 then nodo=1
        for a=1 to nodo
            best=99
            for b=1 to 10
                if p(b).x>0 then
                   if chksrd(p(b),slot)<=best and chksrd(p(b),slot)>0 then
                       c=b
                       best=chksrd(p(c),slot)
                       if show_all then dprint "Points of door pos:"& best
                    endif
                endif
            next
            if p(c).x>0 and p(c).y>0 and p(c).x<60 and p(c).y<20 then planetmap(p(c).x,p(c).y,slot)=8
            p(c).x=-1
        next
        r.wd(5)=1
        r.wd(6)=9
    endif
    
    if typ>2 and typ<7 then
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        bx=r.w/2
        by=r.h/2
        do
        for rad=0 to 6.243 step .1
            x=cos(rad)*bx+p(1).x
            y=sin(rad)*by+p(1).y
            if x<0 then x=0
            if y<0 then y=0
            if x>60 then x=60
            if y>20 then y=20
            planetmap(x,y,slot)=0
        next
        bx=bx-1
        by=by-1
        if bx<0 then bx=0
        if by<0 then by=0
        loop until bx=0 and by=0
'        for x=r.x to r.x+r.w
'            for y=r.y to r.y+r.h
'                planetmap(x,y,slot)=2
'                p(2).x=x
'                p(2).y=y
'                if distance(p(1),p(2))<b then planetmap(x,y,slot)=0
'            next
'        next
        for y=r.y to r.y+r.h
            if planetmap(x,y,slot)=0 then
                if rnd_range(1,100)<11 then placeitem(rnd_item(21),x,y,slot)
                if rnd_range(1,100)<21 then placeitem(makeitem(96),x,y,slot,-3,-3)
                if rnd_range(1,100)<3 then placeitem(makeitem(99),x,y,slot)                
            endif
        next
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        p(2)=nsp
        do 
            d=nearest(p(1),p(2))
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            p(2)=movepoint(p(2),d)
            planetmap(p(2).x,p(2).y,slot)=0
        loop until p(2).x=p(1).x and p(2).y=p(1).y
        
        r.wd(5)=2
        if rnd_range(1,6)<3 then r.wd(6)=18
        if rnd_range(1,6)<3 then r.wd(6)=17
        r.wd(6)=16
    endif
    if typ=99 then
        for x=r.x to r.x+r.w
            for y=r.y to r.y+r.h
                if x=r.x or x=r.x+r.w or y=r.y or y=r.y+r.h then
                    planetmap(x,y,slot)=-51
                else    
                    planetmap(x,y,slot)=-4
                    if rnd_range(1,100)<21 then placeitem(makeitem(7),x,y,slot)
                    if rnd_range(1,100)<15 then placeitem(makeitem(96),x,y,slot,5,5)
                endif
            next
        next
        p(1).x=r.x+r.w/2
        p(1).y=r.y+r.h/2
        p(2)=nsp
        do 
            d=nearest(p(1),p(2))
            if frac(d/2)<>0 then d=bestaltdir(d,rnd_range(0,1))
            p(2)=movepoint(p(2),d)
            planetmap(p(2).x,p(2).y,slot)=-4
        loop until p(2).x=p(1).x and p(2).y=p(1).y
        
        r.wd(5)=2
        r.wd(6)=3
    endif
    
    planets(slot).vault=r
    return 0
end function
  
sub invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=11, _y as short=11)
    dim map(_x,_y) as short
    dim as short x,y,a,b,c,count
    dim p as _cords
    dim p2 as _cords
    dim border as short   
    dim t as integer
    
    t=timer
    for x=0 to _x
        for y=0  to _y
            map(x,y)=1
            
        next
    next
    
    map(rnd_range(1,_x-1),rnd_range(1,_y-1))=0
    
    do
        count=count+1
        p.x=rnd_range(1,_x-1)
        p.y=rnd_range(1,_y-1)
        if map(p.x,p.y)=1 then
            if map(p.x-1,p.y)=0 or map(p.x,p.y+1)=0 or map(p.x+1,p.y)=0 or map(p.x,p.y-1)=0 then
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x-1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 and map(p.x+1,p.y)=1 and map(p.x+1,p.y-1)=1 and map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and map(p.x-1,p.y-1)=1 and map(p.x,p.y-1)=1 and map(p.x+1,p.y-1)=1 then map(p.x,p.y)=0
                if map(p.x-1,p.y+1)=1 and map(p.x,p.y+1)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 and  map(p.x+1,p.y+1)=1 then map(p.x,p.y)=0
            endif
            if map(p.x,p.y)=0 then
                c=0
                for x=0 to _x
                    for y=0  to _y
                        if map(x,y)=0 then c=c+1
                    next
                next
            endif
        endif
    loop until c+rnd_range(1,20)>_x*_y*.6 or timer>t+15    

    for x=0 to 10
        for y=0 to 10
            if map(x,y)=0 then
                tmap(x+xoff,y+yoff).walktru=5
                tmap(x+xoff,y+yoff).desc="an invisible wall"
            else
                tmap(x+xoff,y+yoff).walktru=0
            endif
        next
    next
    tmap(30,10).walktru=0
end sub

sub makemudsshop(slot as short, x1 as short, y1 as short) 
    dim as short x,y
    dim as _cords p3
    if x1<3 then x1=3
    if x1>57 then x1=57
    if y1<3 then y1=3
    if y1>17 then y1=17
    planetmap(x1,y1,slot)=-262
    planetmap(x1-1,y1,slot)=-32
    planetmap(x1+1,y1,slot)=-32
    planetmap(x1,y1+1,slot)=-31
    planetmap(x1,y1-1,slot)=-31
    planetmap(x1-2,y1,slot)=-68
    planetmap(x1+2,y1,slot)=-68
    planetmap(x1,y1+2,slot)=-68
    planetmap(x1,y1-2,slot)=-68
    
    p3.x=x1+2
    p3.y=y1+2
    if p3.x+3<60 and p3.y+3<20 and rnd_range(1,100)<10 then 
        for x=p3.x to p3.x+3
            for y=p3.y to p3.y+3
                planetmap(x,y,slot)=68
            next
        next
        planetmap(p3.x+1,p3.y,slot)=70
        planetmap(p3.x+2,p3.y,slot)=71
    endif

end sub

sub planet_event(slot as short)
    dim as _cords p1
    dim as _cords gc1,gc
    dim as short x,y,a,b,t1,t2,t
    static generated(8) as short
    t1=rnd_range(0,6)+disnbase(map(sysfrommap(slot)).c)/10
    t2=rnd_range(0,6)+disnbase(map(sysfrommap(slot)).c)/10
    if t1<1 then t1=1
    if t2<1 then t2=1
    if t1>8 then t1=8
    if t2>8 then t2=8
    if generated(t1)>generated(t2) then t=t2
    if generated(t1)<generated(t2) then t=t1
    if generated(t1)=generated(t2) then 
        if rnd_range(1,100)<=50 then
            t=t1
        else
            t=t2
        endif
    endif
    generated(t)+=1
    
    if t<1 then t=1
    if t>8 then t=8
    if t=1 or t=2 then 'Mining Colony in Distress Flag 22 
        p1.x=rnd_range(0,50)
        p1.y=rnd_range(0,15)
        planetmap(p1.x,p1.y,slot)=-76
        planetmap(p1.x+2,p1.y,slot)=-76
        planetmap(p1.x+2,p1.y+2,slot)=-76
        planetmap(p1.x+1,p1.y,slot)=-32
        planetmap(p1.x+1,p1.y+2,slot)=-32
        planetmap(p1.x,p1.y+1,slot)=-33
        planetmap(p1.x+2,p1.y+1,slot)=-33        
        planetmap(p1.x+3,p1.y,slot)=-32
        planetmap(p1.x+4,p1.y,slot)=-32
        planetmap(p1.x+5,p1.y,slot)=-32
        planetmap(p1.x+6,p1.y,slot)=-68
        planetmap(p1.x+1,p1.y+1,slot)=-4
        if rnd_range(1,100)<66 then
            planets(slot).flags(22)=1
            planetmap(p1.x,p1.y+2,slot)=-99
        else
            planets(slot).flags(22)=2
            planetmap(p1.x,p1.y+2,slot)=-76
        endif
        gc1.x=p1.x+1
        gc1.y=p1.y+1
        gc1.m=slot
        
        lastplanet=lastplanet+1
        gc.x=rnd_range(1,59)
        gc.y=rnd_range(1,19)
        gc.m=lastplanet
        
        
        makecavemap(gc,8,-1,0,0)
        planets(lastplanet)=planets(slot)
        planets(lastplanet).grav=1.4
        planets(lastplanet).depth=2
        planets(lastplanet).mon_template(0)=makemonster(1,lastplanet)
        planets(lastplanet).mon_noamax(0)=rnd_Range(2,12)+6
        planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,lastplanet)=-4 and rnd_range(0,100)<66 then planetmap(x,y,lastplanet)=-47
            next
        next
        gc=rnd_point(lastplanet,0)
        gc.m=lastplanet
        addportal(gc1,gc,0,ASC("#"),"A mineshaft.",14)
        
    endif
    
    if t=3 then
        planetmap(rnd_range(0,60),rnd_range(0,20),slot)=-9
    endif
    
    if t=4 then 'Smith & Pirates fighting over an ancient factory Flag 23
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=246
        next
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=-67
        next
        planets(slot).flags(23)=1
        
        planets(slot).mon_template(0)=makemonster(3,slot)
        planets(slot).mon_template(0).faction=1
        planets(slot).mon_noamax(0)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        
        planets(slot).mon_template(1)=makemonster(50,slot)
        planets(slot).mon_template(1).faction=1
        planets(slot).mon_noamax(1)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(1)=rnd_Range(1,2)
        
        planets(slot).mon_template(2)=makemonster(71,slot)
        planets(slot).mon_template(2).faction=2
        planets(slot).mon_template(2).cmmod=5
        planets(slot).mon_template(2).lang=29
        planets(slot).mon_noamax(2)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        
        planets(slot).mon_template(3)=makemonster(72,slot)
        planets(slot).mon_template(3).faction=2
        planets(slot).mon_template(3).cmmod=5
        planets(slot).mon_template(3).lang=29
        planets(slot).mon_noamax(3)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(3)=rnd_Range(1,2)
            
        gc.m=slot
        gc.x=rnd_range(2,60)
        gc.y=rnd_range(1,18)
        lastplanet+=1
        gc1.m=lastplanet
        p1=rnd_point(lastplanet,0)
        gc1.x=p1.x
        gc1.y=p1.y
        makecomplex(gc1,1)
        addportal(gc,gc1,0,asc("o"),"A shaft",14)
    
    endif
    
    if t=5 or t=6 then
        deletemonsters(slot)
        planets(slot).flags(24)=1
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-4
                if rnd_range(1,100)<77 then
                    if rnd_range(1,100)<80 then
                        planetmap(x,y,slot)=-6
                    else
                        planetmap(x,y,slot)=-5
                    endif
                endif
            next
        next
        for x=0 to 29+rnd_range(1,6)
            planetmap(rnd_range(0,60),rnd_range(0,20),slot)=-146
        next
        for x=0 to rnd_range(1,5)
            placeitem(makeitem(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),slot)
        next
        for x=0 to 3
            p1=rnd_point
            planetmap(p1.x,p1.y,slot)=-59
            placeitem(makeitem(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),p1.x,p1.y,slot)

        next
        
        lastportal=lastportal+1
        lastplanet=lastplanet+1
        portal(lastportal).desig="An opening between the roots. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=4
        portal(lastportal).from.m=a
        portal(lastportal).from.x=rnd_range(0,60)
        portal(lastportal).from.y=rnd_range(0,20)
        portal(lastportal).dest.m=lastplanet
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        
        makeroots(lastplanet)
        planets(slot).mon_template(0)=makemonster(4,slot)
        planets(slot).mon_noamin(0)=15
        planets(slot).mon_noamax(0)=25
        planets(lastplanet)=planets(slot)
        planets(lastplanet).depth=3
        planets(lastplanet).grav=0
        for b=0 to rnd_range(0,6)+disnbase(player.c)\4
            placeitem(makeitem(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),lastplanet)
        next b
    
    endif
    if t=7 or t=8 then
        makemossworld(slot,5)
        planets(slot).atmos=4
        planets(slot).flags(25)=1
    endif
    
end sub

sub makeoutpost (slot as short,x1 as short=0, y1 as short=0)
    dim as short x,y,a,w,h
    if x1=0 then x1=rnd_range(1,59)
    if y1=0 then y1=rnd_range(1,19)
    h=rnd_range(4,7)
    w=rnd_range(4,7)
    if x1+w>57 then x1=57-w
    if y1+h>17 then y1=17-h
    for x=x1 to x1+w
        for y=y1 to y1+h
            if rnd_range(1,100)<88 then planetmap(x,y,slot)=-16
            if rnd_range(1,100)<18 then planetmap(x,y,slot)=-68
            
        next
    next
    for w=0 to 5
        x=rnd_range(x1-1,x1+w+1)
        y=rnd_range(y1-1,y1+h+1)
        if rnd_range(1,100)<9 then planetmap(x,y,slot)=-69-w
    next        
    y=rnd_range(y1+1,y1+h-2)
    for x=x1 to x1+w
        planetmap(x,y,slot)=-32
    next
    
    x=rnd_range(x1+1,x1+w-2)
    for y=y1 to y1+h
        if planetmap(x,y,slot)<>-32 then
        planetmap(x,y,slot)=-31
    else
        planetmap(x,y,slot)=-33
        endif
    next
    if faction(0).war(2)<50 then
        for x=x1 to x1+w
            for y=y1 to y1+h
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
end sub

sub adaptmap(slot as short,enemy()as _monster,byref lastenemy as short)
    dim as short in,start,cur,a,b,c,pyr,hou,i,ti,x,y,vt
    dim houses(2) as short
    dim r as _rect
    dim as _cords p
    dim as _cords from,dest
    p=rnd_point
    if lastenemy>1 and planets(slot).atmos>1 then
        for a=1 to lastenemy
            if enemy(a).intel>=6 then
                if enemy(a).intel=6 then in=0
                if enemy(a).intel=7 then in=1
                if enemy(a).intel>7 then in=2
                if rnd_range(1,100)<66 then houses(in)=houses(in)+1
                if houses(in)>5 then houses(in)=5
            endif
        next
        for i=0 to 2
            p=rnd_point
            for a=0 to 2
               if houses(a)>0 then
                   for b=1 to houses(a)
                       c=rnd_range(1,8)
                       if c=5 then c=9
                       p=movepoint(p,c)
                       p=movepoint(p,c)
                       'put house
                       if rnd_range(1,100)<66 then
                            ti=90+in
                       else
                            ti=93+in
                       endif
                       if rnd_range(1,100)<16+planets(slot).atmos then
                            planetmap(p.x,p.y,slot)=-ti
                            if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
                            pyr=pyr+10+2*(a+1)                
                            if rnd_range(1,100)<ti-66 then placeitem(makeitem(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 then placeitem(makeitem(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(makeitem(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(makeitem(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(makeitem(94),p.x,p.y,slot,0,0)
                       endif
                       c=rnd_range(1,8)
                       if c=5 then c=9
                       p=movepoint(p,c)
                       'put cultivated land 
                       if abs(planetmap(p.x,p.y,slot))<90 then planetmap(p.x,p.y,slot)=-96                            
                   next
               endif 'no int aliens
                   
            next
        next
    endif
    
    if houses(0)=0 and houses(1)=0 and houses(2)=0 and rnd_range(1,100)<55 and isgardenworld(slot)<>0 then makesettlement(rnd_point,slot,rnd_range(0,4))
       
       
    if (rnd_range(1,100)<pyr+7 and pyr>0) or addpyramids=1 then         
        planetmap(p.x,p.y,slot)=-150
        if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
        if rnd_range(1,100)<pyr+5 or addpyramids=1 then
            p=movepoint(p,5)
            from.x=p.x
            from.y=p.y
            from.m=slot
            lastplanet=lastplanet+1
            makelabyrinth(lastplanet)
            planets(lastplanet).depth=1
    
            planets(lastplanet).mon_template(0)=makemonster(21,lastplanet)
            planets(lastplanet).mon_noamin(0)=10
            planets(lastplanet).mon_noamax(0)=20
            planets(lastplanet).atmos=planets(slot).atmos
            for i=0 to rnd_range(2,6)+rnd_range(1,6)+rnd_range(2,6)
                p=rnd_point(lastplanet,0)
                if i<6 then placeitem(makeitem(96,-2,-3),p.x,p.y,lastplanet)
                if i>6 then placeitem(makeitem(94),p.x,p.y,lastplanet)
            next                 
            for i=0 to rnd_range(1,6)+rnd_range(1,6)
                p=rnd_point(lastplanet,0)
                placeitem(makeitem(96,-2,-3),p.x,p.y,lastplanet)
            next
            
            if rnd_range(1,100)<5 then
                p=rnd_point(lastplanet,0)
                planetmap(p.x,p.y,lastplanet)=225
                placeitem(makeitem(97),p.x,p.y,lastplanet)
                placeitem(makeitem(98),p.x,p.y,lastplanet)
            endif
            
            if rnd_range(1,100)<55 or addpyramids=1 then
                vt=rnd_range(1,6)
                p=rnd_point
                x=rnd_range(6,9)+rnd_range(0,3)
                y=rnd_range(5,7)+rnd_range(0,2)
                if p.x+x>=59 then p.x=58-x
                if p.y+y>=19 then p.y=18-y
                if p.x=0 then p.x=1
                if p.y=0 then p.y=1
                if p.x+x>=59 then x=59-p.x
                if p.y+y>=19 then y=19-p.y
                r.x=p.x
                r.y=p.y
                r.w=x
                r.h=y
                for x=r.x to r.x+r.w
                    for y=r.y to r.y+r.h
                        planetmap(x,y,lastplanet)=-4
                        if x=r.x or x=r.x+r.w or y=r.y or y=r.y+r.h then
                            planetmap(x,y,lastplanet)=-51
                            if vt=5 then 
                                planetmap(x,y,lastplanet)=-50
                                placeitem(makeitem(96,-2,-3),x,y,lastplanet)
                                placeitem(makeitem(96,-2,-3),x,y,lastplanet)
                            endif
                            if rnd_range(1,100)<33 then
                                if planetmap(x-1,y,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                                if planetmap(x+1,y,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                                if planetmap(x,y-1,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                                if planetmap(x,y+1,lastplanet)=-4 then planetmap(x,y,lastplanet)=-151
                            endif
                        else
                            if vt=2 then planetmap(x,y,lastplanet)=-154
                        endif
                    next
                next
                if vt<5 then
                    for i=0 to rnd_range(1,6)+rnd_range(1,6)+vt
                        p.x=rnd_range(r.x+1,r.x+r.w-2)
                        p.y=rnd_range(r.y+1,r.y+r.h-2)
                        placeitem(makeitem(96,-2,-3),p.x,p.y,lastplanet)
                        p.x=rnd_range(r.x+1,r.x+r.w-2)
                        p.y=rnd_range(r.y+1,r.y+r.h-2)
                        placeitem(makeitem(94),p.x,p.y,lastplanet)
                    next
                endif
                if vt=3 or vt=5 then
                    planets(lastplanet).vault=r
                    planets(lastplanet).vault.wd(5)=2
                    planets(lastplanet).vault.wd(6)=rnd_range(66,68)
                endif
                if vt=4 then
                    planets(lastplanet).vault=r
                    planets(lastplanet).vault.wd(5)=2
                    planets(lastplanet).vault.wd(6)=rnd_range(16,18)
                endif
                if vt=6 then
                    planets(lastplanet).vault=r
                    planets(lastplanet).vault.wd(5)=2
                    planets(lastplanet).vault.wd(6)=rnd_range(16,18)
                    for x=r.x to r.x+r.w
                        for y=r.y to r.y+r.h
                            if x=r.x+1 or x=r.x+r.w-1 or y=r.y+1 or y=r.y+r.h-1 then planetmap(x,y,lastplanet)=-225
                            if x=r.x+r.w/2 and y=r.x+r.h/2 then planetmap(x,y,lastplanet)=-225
                        next
                    next
                endif
            endif
                
            p=rnd_point(slot,0)
            
            do
                p=rnd_point(lastplanet,0)
            loop until not (p.x>r.x and p.x<r.x+r.w and p.y>r.y and p.y<r.y+r.h)
            dest.x=p.x
            dest.y=p.y
            dest.m=lastplanet
            if addpyramids=1 then dprint "Pyramid at "&from.x &":"& from.y
            addportal(from,dest,1,asc("^"),"A pyramid with an entry.",14)
            addportal(dest,from,1,asc("o"),"The exit.",7)
            
        endif
    endif

    for b=0 to lastitem
        if item(b).w.m=slot and item(b).w.s>0 and slot<>specialplanet(9) then
            if item(b).ty=99 then
                planetmap(item(b).w.x,item(b).w.y,slot)=-149
                if rnd_range(1,100)>50 then 
                    planetmap(item(b).w.x,item(b).w.y,slot)=-148
                    p.x=item(b).w.x
                    p.y=item(b).w.y
                    for c=0 to rnd_range(1,3)
                        p=movepoint(p,5)
                        planetmap(item(b).w.x,item(b).w.y,slot)=-148
                    next
                    if rnd_range(1,100)>50 then planetmap(item(b).w.x,item(b).w.y,slot)=-100
                    
                endif
            endif
        endif
    next
    
    
end sub

sub togglingfilter(slot as short, high as short=1, low as short=2)        
dim as short x,y,ti1,ti2
dim as short a
dim as _cords p1,p2
dim workmap(60,20) as short
dim workmap2(60,20) as short

for x=0 to 60
    for y=0 to 20
        if abs(planetmap(x,y,slot))=high then workmap(x,y)=1
        if abs(planetmap(x,y,slot))=low then workmap(x,y)=1
    next
next

for x=1 to 59
    for y=1 to 19
        if workmap(x,y)>0 then
        p1.x=x
        p1.y=y
        for a=1 to 9
            if a<>5 then
                p2=movepoint(p1,a)
                if workmap(p2.x,p2.y)>0 then workmap2(x,y)=workmap2(x,y)+1
            endif
        next
        endif
    next
next

for x=59 to 1 step -1
    for y=1 to 19
        if workmap(x,y)<>0 then
            if workmap2(x,y)<4 then planetmap(x,y,slot)=-rnd_range(3,6)
            if workmap2(x,y)>3 then planetmap(x,y,slot)=-high
            if workmap2(x,y)>7 then planetmap(x,y,slot)=-low
            
        endif
    next
next

end sub


function flood_fill(x as short,y as short,map() as short, flag as short=0) as short
  if flag=0 then 
      if x>0 and y>0 and x<60 and y<20 then
          if (map(x,y)=0 or map(x,y)=2 or map(x,y)=3 or map(x,y)=4) and map(x,y)<10 then
              map(x,y)=map(x,y)+11
          else
              return 0
          endif
          Flood_Fill(x+1,y,map())
          Flood_Fill(x-1,y,map())
          Flood_Fill(x,y+1,map())
          Flood_Fill(x,y-1,map())
      endif
  endif
  if flag=1 then
      if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),1)
          Flood_Fill(x-1,y,map(),1)
          Flood_Fill(x,y+1,map(),1)
          Flood_Fill(x,y-1,map(),1)
      endif
  endif
  if flag=2 then
      if x>=0 and y>=0 and x<=60 and y<=20 then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),2)
          Flood_Fill(x-1,y,map(),2)
          Flood_Fill(x,y+1,map(),2)
          Flood_Fill(x,y-1,map(),2)
      endif
  endif
  
end function

function flood_fill2(x as short,y as short, xm as short, ym as short, map() as byte) as short
    if x>=0 and y>=0 and x<=xm and y<=ym then
      if map(x,y)=1 then
          map(x,y)=2
      else
          return 0
      endif
      Flood_Fill2(x+1,y,xm,ym,map())
      Flood_Fill2(x-1,y,xm,ym,map())
      Flood_Fill2(x,y+1,xm,ym,map())
      Flood_Fill2(x,y-1,xm,ym,map())
  endif
end function

function floodfill3(x as short,y as short,map() as short) as short
    if x>=0 and y>=0 and x<=60 and y<=20 then
          if map(x,y)=0 or map(x,y)=2 or map(x,y)=-2 then
              if map(x,y)=0 then map(x,y)=-1
              if map(x,y)=2 then map(x,y)=-2
          else
              return 0
          endif
          FloodFill3(x+1,y,map())
          FloodFill3(x-1,y,map())
          FloodFill3(x,y+1,map())
          FloodFill3(x,y-1,map())
    endif
    return 0
end function

function checkvalid(x as short,y as short, map() as short) as short
    if x<=0 then return 0
    if y<=0 then return 0
    if x>=60 then return 0
    if y>=20 then return 0
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then
            return -1
        endif
        return 0
end function

function checkdoor(x as short,y as short, map() as short) as short
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y)=1 then
        if map(x,y+1)=-1 and map(x,y-1)=0 then return -1
        if map(x,y-1)=-1 and map(x,y+1)=0 then return -1
    endif
    
    if map(x,y-1)=1 and map(x,y+1)=1 and map(x,y)=1 then
        if map(x+1,y)=-1 and map(x-1,y)=0 then return -1
        if map(x-1,y)=-1 and map(x+1,y)=0 then return -1
    endif
    return 0
end function

function checkbord(x as short,y as short, map() as short) as short
    if x<=0 then return 0
    if y<=0 then return 0
    if x>=60 then return 0
    if y>=20 then return 0
    dim r as short
    if map(x-1,y)=0 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then r=1
    if map(x-1,y)=1 and map(x+1,y)=0 and map(x,y-1)=1 and map(x,y+1)=1 then r=2
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=0 and map(x,y+1)=1 then r=3
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=0 then r=4
    if map(x-1,y)=1 and map(x+1,y)=1 and map(x,y-1)=1 and map(x,y+1)=1 then r=5
    return r
end function

function rndwallpoint(r as _rect, w as byte) as _cords
    dim p as _cords
    if w=1 then 'north wall
        p.y=r.y-1
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif
    
    if w=2 then 'East wall
        p.x=r.x+r.w+1
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    
    if w=3 then 'South wall
        p.y=r.y+r.h+1
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif
    
    if w=4 then 'west woll
        p.x=r.x-1
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    return p
    
end function

function rndwall(r as _rect) as short
    dim as short a,b,c
    dim po(4) as byte
    for a=1 to 4
        if r.wd(a)=0 then
            b=b+1
            po(b)=a
        endif
    next
    if b>0 then
        c=po(rnd_range(1,b))
    else
        c=-1
    endif
    return c
end function

function digger(byval p as _cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
    dim d2 as short
    dim c as short
    do
        c=c+1
        if p.y=0 or p.x=0 or p.x=60 or p.y=20 then return 1
        if d=1 and p.y<=1 then d2=1
        if d=2 and p.x>=59 then d2=2
        if d=3 and p.y>=19 then d2=3
        if d=4 and p.y<=1 then d2=4
        if d2=1 or d2=3 then
            if rnd_range(1,100)<51 then
                d=2
            else
                d=4
            endif
            d2=0
        endif
        if d2=2 or d2=4 then
            if rnd_range(1,100)<51 then
                d=1
            else
                d=3
            endif
            d2=0
        endif
        if map(p.x,p.y)=stopti then return 0
        map(p.x,p.y)=ti
        if rnd_range(1,100)<10 then map(p.x,p.y)=4
        if d=1 or d=3 then
            if map(p.x-1,p.y)=stopti or map(p.x+1,p.y)=stopti then return 0
        else
            if map(p.x,p.y-1)=stopti or map(p.x,p.y+1)=stopti then return 0
        endif
        if d=1 then p.y=p.y-1
        if d=2 then p.x=p.x+1
        if d=3 then p.y=p.y+1
        if d=4 then p.x=p.x-1
    loop until c>512
    return 0
end function

function dominant_terrain(x as short,y as short,m as short) as short
    dim as short x2,y2,i,in,set,dom,t1
    dim t(9) as short
    dim c(9) as short
    in=1
    for x2=x-1 to x+1
        for y2=y-1 to y+1
            if x2>=0 and x2<=60 and y2>=0 and y2<=20 then
                for i=1 to 9
                    set=0
                    if t(i)=abs(planetmap(x2,y2,m)) then
                        c(i)+=1
                        set+=1
                    endif
                next
                if set=0 then 
                    t(in)=abs(planetmap(x2,y2,m))
                    in+=1
                endif
            endif
        next
    next
    for i=1 to in-1
        if c(i)>dom then 
            dom=c(i)
            t1=t(i)
            dprint ""&dom
        endif
    next
    return t1
end function


function isgardenworld(m as short) as short
    if planets(m).grav>1.1 then return 0
    if planets(m).atmos<3 or planets(m).atmos>5 then return 0
    if planets(m).temp<-20 or planets(m).temp>55 then return 0
    if planets(m).weat>1 then return 0
    if planets(m).water<30 then return 0
    if planets(m).rot<0.5 or planets(m).rot>1.5 then return 0
    return -1
end function


function isgasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    if m=specialplanet(43) then return 43
    return 0
end function

function isasteroidfield(m as short) as short
    if m>=-20000 and m<0 then return 1
    if m=specialplanet(31) then return 1 
    if m=specialplanet(32) then return 1 
    if m=specialplanet(33) then return 1
    if m=specialplanet(41) then return 1
    return 0
end function

function countasteroidfields(sys as short) as short
    dim as short a,b
    for a=1 to 9
        if map(sys).planets(a)<0 and isgasgiant(map(sys).planets(a))=0 then b=b+1
    next
    return b
end function


function countgasgiants(sys as short) as short
    dim as short a,b
    for a=1 to 9
        if isgasgiant(map(sys).planets(a))>0 then b=b+1
    next
    return b
end function

function checkcomplex(map as short,fl as short) as integer
    dim result as integer
    dim maps(36) as short
    dim as short nextmap,lastmap,foundport,a,b,done
    maps(0)=map
    do
    ' Suche portal auf maps(lastmap)
        lastmap=nextmap
        nextmap+=1
        for a=1 to lastportal
            if portal(a).from.m=maps(lastmap) then maps(nextmap)=portal(a).dest.m
        next
    loop until maps(nextmap)=0
    
    for a=1 to lastmap
        if maps(a)>0 and planets(maps(a)).genozide=0 then result+=1
    next
    return result
end function

function is_drifter(m as short) as short
    dim a as short
    for a=0 to lastdrifting
        if m=drifting(a).m then return -1
    next
    return 0
end function

function is_special(m as short) as short
    dim a as short
    for a=0 to lastspecial
        if m=specialplanet(a) then return -1
    next
    return 0
end function    

function get_nonspecialplanet() as short
    dim pot(1024) as short
    dim as short a,b,last
    for a=0 to laststar
        for b=1 to 9
            if map(a).planets(b)>0 and is_special(map(a).planets(b))=0 then
                if planetmap(0,0,map(a).planets(b))=0 then
                    last+=1
                    pot(last)=map(a).planets(b)
                endif
            endif
        next
    next
    if last>0 then
        return pot(rnd_range(1,last))
    else 
        return 0
    end if
end function

function fillmap(map() as short,tile as short) as short
    dim x as short
    dim y as short
    for x=0 to 60
        for y=0 to 20
            map(x,y)=tile
        next
    next
    return 0
end function
