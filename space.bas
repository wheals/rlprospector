function make_spacemap() as short
    dim as short a,f,b,c,d,e,astcou,gascou,x,y,i
    dim as byte makelog
    dim as _cords p1,p2,p3
    dim as _planet del 
    dim showclouds as byte
    if makelog=1 then
        f=freefile
        open "creation.log" for output as #f
    endif
    screenset 1,1
    b=rnd_range(1,_last_title_pic)
    background(b &".bmp")
    
    set__color 1,1
    for a=0 to 3
        draw string(_screenx/2-(8*_fw1),_screeny/2-(2-a)*_fh1),space(27),,font1,custom,@_col
        draw string(_screenx/2-(8*_fw1),_screeny/2-(2-a)*_fh1+_fh1/2),space(27),,font1,custom,@_col
    next
    set__color 15,1
    draw string(_screenx/2-(6*_fw1),_screeny/2-_fh1),"Generating Sector:",,font1,custom,@_col
    set__color 5,1
    draw string(_screenx/2-(7*_fw1),_screeny/2),string(1,178),,font1,custom,@_col
    showclouds=0
    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=del
    next
    if makelog=1 then print #f,,"Generated sector"
    if _debug>0 then dprint  "Gen sec"
    
    draw string(_screenx/2-7*_fw1,_screeny/2),string(2,178),,font1,custom,@_col
    
    for a=0 to 1024
        portal(a).oneway=0
    next
    if makelog=1 then print #f,,"Portals done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(3,178),,font1,custom,@_col
    
    gen_shops
    draw string(_screenx/2-7*_fw1,_screeny/2),string(4,178),,font1,custom,@_col
    
    if _debug>0 then dprint  "Reroll shops"
    reroll_shops
    if _debug>0 then dprint  "Reroll shops done"
    draw string(_screenx/2-7*_fw1,_screeny/2),string(5,178),,font1,custom,@_col
    if makelog=1 then print #f,,"Reroll shops done" &lastitem
    
    add_stars
    draw string(_screenx/2-7*_fw1,_screeny/2),string(6,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_stars done" &lastitem
    
    add_wormholes
    draw string(_screenx/2-7*_fw1,_screeny/2),string(7,178),,font1,custom,@_col
    if makelog=1 then print #f,,"add_wormholes done" &lastitem
    
    distribute_stars
    draw string(_screenx/2-7*_fw1,_screeny/2),string(8,178),,font1,custom,@_col
    if makelog=1 then print #f,,"distribute_stars done" &lastitem
    if _debug>0 then dprint "Distri stars"
    make_clouds()
    draw string(_screenx/2-7*_fw1,_screeny/2),string(9,178),,font1,custom,@_col
    if makelog=1 then print #f,"make_clouds done" &lastitem
    if _debug>0 then dprint "Make clouds stars"
    
    gen_traderoutes()
    draw string(_screenx/2-7*_fw1,_screeny/2),string(10,178),,font1,custom,@_col
    if makelog=1 then print #f,"gen_traderoutes done" &lastitem
    if _debug>0 then dprint "gen traderoutes"
    
    add_stations
    draw string(_screenx/2-7*_fw1,_screeny/2),string(11,178),,font1,custom,@_col
    if _debug>0 then dprint "Add stations"
    
    gascou+=1
    for a=0 to laststar
        if spacemap(map(a).c.x,map(a).c.y)<>0 then gascou+=1
    next
    
    add_easy_planets(targetlist(firstwaypoint))
    if makelog=1 then print #f,"add_easy_planets done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(12,178),,font1,custom,@_col
    if _debug>0 then dprint "Add easy planets done"
    
    add_special_planets
    if makelog=1 then print #f,"add_special_planets done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(13,178),,font1,custom,@_col
    if _debug>0 then dprint "Add specials"
    
    add_event_planets
    if makelog=1 then print #f,"addeventplanets done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(14,178),,font1,custom,@_col
    if _debug>0 then dprint "Add events"
    
    fixstarmap()
    if makelog=1 then print #f,"Fixstarmap" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(15,178),,font1,custom,@_col
    if _debug>0 then dprint "fix"
    
    add_caves
    if makelog=1 then print #f,"addcaves" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(16,178),,font1,custom,@_col
    if _debug>0 then dprint "Add caves"
    
    add_piratebase
    if makelog=1 then print #f,"addpiratbase" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(17,178),,font1,custom,@_col
    if _debug>0 then dprint "Add piratebase"
    
    add_drifters
    if makelog=1 then print #f,"adddrifters" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(18,178),,font1,custom,@_col
    if _debug>0 then dprint "Add drifters"
    
    load_bones
    if makelog=1 then print #f,"loadbones done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(19,178),,font1,custom,@_col
    if _debug>0 then dprint "load bones"
    
    for a=0 to laststar
        if map(a).discovered=2 then map(a).discovered=show_specials
        if map(a).discovered=3 then map(a).discovered=show_eventp
        if map(a).discovered=4 then map(a).discovered=_debug_bones
        if map(a).discovered=5 then map(a).discovered=show_portals
        if map(a).discovered=6 then map(a).discovered=-1
        if abs(spacemap(map(a).c.x,map(a).c.y))>1 and map(a).spec<8 then
            map(a).spec=map(a).spec+abs(spacemap(map(a).c.x,map(a).c.y))/2
            if map(a).spec>7 then map(a).spec=7
            map(a).ti_no=map(a).spec+68
        endif
        scount(map(a).spec)+=1
        for b=1 to 9
            if map(a).planets(b)<-20000 then gascou+=1
            if map(a).planets(b)>-20000 and map(a).planets(b)<0  then astcou+=1
        next
    next
    if show_specials<>0 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=show_specials then map(a).discovered=1
            next
        next
        if map(a).spec=10 then map(a).discovered=1
    endif
    if show_all_specials=1 then
        for a=0 to laststar
            for b=1 to 9
                for c=0 to lastspecial
                    if map(a).planets(b)=specialplanet(c) then map(a).discovered=1
                next            
            next
        next
    endif
    if show_dangerous=1 then
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)=specialplanet(2) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(3) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(4) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(26) then map(a).discovered=1
                if map(a).planets(b)=specialplanet(27) then map(a).discovered=1
            next
        next
        
    endif
    if makelog=1 then print #f,"Making Civs"
    
    make_civilisation(0,specialplanet(7))
    draw string(_screenx/2-7*_fw1,_screeny/2),string(20,178),,font1,custom,@_col
    
    if makelog=1 then print #f,"makeciv1 done" &lastitem
    make_civilisation(1,specialplanet(46))
    
    if makelog=1 then print #f,"makeciv2 done" &lastitem
    draw string(_screenx/2-7*_fw1,_screeny/2),string(21,178),,font1,custom,@_col
    
    add_questguys
    draw string(_screenx/2-7*_fw1,_screeny/2),string(22,178),,font1,custom,@_col
    
    if findcompany(1)=0 then specialplanet(40)=32767
    if findcompany(2)=0 then specialplanet(41)=32767
    if findcompany(3)=0 then specialplanet(42)=32767
    if findcompany(4)=0 then specialplanet(43)=32767
    
    if makelog=1 then print #f,"delete company specials" &lastitem
    
    fleet(1).mem(1)=make_ship(33)
    fleet(1).ty=1
    fleet(1).c=basis(0).c
    fleet(2).mem(1)=make_ship(33)
    fleet(2).ty=1
    fleet(2).c=basis(1).c
    fleet(3).mem(1)=make_ship(33)
    fleet(3).ty=1
    fleet(3).c=basis(2).c
    fleet(5).mem(1)=make_ship(33)
    fleet(5).ty=1
    fleet(5).c=basis(4).c
    
    lastfleet=12
    for a=6 to lastfleet
        fleet(a)=makemerchantfleet
        fleet(a).t=rnd_range(firstwaypoint,lastwaypoint)
        fleet(a).c=targetlist(fleet(a).t)
        e=999
        for b=1 to 15
            if fleet(a).mem(b).movepoints(0)<e and fleet(a).mem(b).movepoints(0)>0 then e=fleet(a).mem(b).movepoints(0)
        next
        fleet(a).mem(0).engine=e
        if fleet(a).mem(0).engine<1 then fleet(a).mem(0).engine=1
        
    next
    
    if _clearmap=1 then
        for a=0 to laststar+wormhole+1
            if map(a).discovered>0 then 
                map(a).discovered=0
                for b=1 to 9
                    if map(a).planets(b)>0 then planets(map(a).planets(b)).visited=0
                next
'            else
'                print "system "&a &" at "& map(a).c.x &":"& map (a).c.y
'                map(a).discovered=1
'                sleep
            endif
        next
    endif
    if showclouds=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
        for a=0 to laststar+wormhole+1
            player.discovered(map(a).spec)+=1
            map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        
        next
    endif
    
    gen_bountyquests()
    
    if makelog=1 then 
        print #f,"Clear stuff" &lastitem
        close #f
    endif
    
    if show_space=1 then
        for a=0 to laststar
            map(a).discovered=1
        next
        for a=0 to lastdrifting
            drifting(a).p=1
        next
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)=0 then spacemap(x,y)=1
                spacemap(x,y)=abs(spacemap(x,y))
            next
        next
    endif
    set__color( 11,0)
    locate 1,1
    print
    print "Universe created with "&laststar &" stars and "&lastplanet-lastdrifting &" planets."
    set__color( 15,0)
    print "Star distribution:"
    for a=1 to 10
        print spectralname(a);":";scount(a)
    next
    print "Asteroid belts:";astcou
    print "Gas giants:";gascou
    sleep 2500
    if _debug>0 then
        dim key as string
        key=keyin
    endif
    return 0
end function

function add_stations() as short
    dim as _cords p
    dim as single d
    dim as short j,i,res
    for j=0 to 1
        p.x=(basis(1+j).c.x+basis(0+j).c.x)/2
        p.y=(basis(1+j).c.y+basis(0+j).c.y)/2
        d=9999
        for i=firststationw to lastwaypoint
            if distance(targetlist(i),p)<d then 
                d=distance(targetlist(i),p)
                res=i
            endif
        next
        drifting(2+j).x=targetlist(res).x
        drifting(2+j).y=targetlist(res).y
    next
    return 0
end function


function add_stars() as short
    dim as short a,cc,b,f,debug
    dim as string l
    dim as _stars del
    dim as _planet delpl
    
    'debug=2
    for a=0 to max_maps
        planets(a)=delpl
    next
    
    cc=0
    
    for a=0 to laststar
        map(a)=del
        for b=1 to 9
            map(a).planets(b)=0
        next
        map(a).c.x=rnd_range(0,sm_x)
        map(a).c.y=rnd_range(0,sm_y)
        if rnd_range(1,100)<36 then
            map(a).spec=rnd_range(2,4)
        else
            map(a).spec=rnd_range(1,7)
        endif
        if rnd_range(1,100)<91 then
            for b=1 to 9
                map(a).planets(b)=rnd_range(1,24)-((map(a).spec-3)^2+rnd_range(1,12))
                if map(a).planets(b)>0 then                    
                    if rnd_range(1,100)<77 then
                        cc+=1
                        map(a).planets(b)=cc
                    else
                        if rnd_range(1,100)<64 then
                            map(a).planets(b)=-rnd_range(1,6)
                        else
                            if rnd_range(1,100)<45+b*5 then
                                if b<7 then
                                    map(a).planets(b)=-20001
                                else
                                    map(a).planets(b)=-20002
                                endif
                                if b=1 then map(a).planets(b)=-20003
                            else
                                map(a).planets(b)=0
                            endif
                        endif
                    endif
                else
                    map(a).planets(b)=0
                endif
            next
        else
            if rnd_range(1,100)<50 then
                map(a).spec=8
                cc+=1
                map(a).planets(1)=cc
            else
                if debug=1 and _debug=1 then dprint map(a).c.x &":"&map(a).c.y
                map(a).spec=10
                map(a).planets(1)=-20002
                if rnd_range(1,100)<25 then 
                    cc+=1
                    map(a).planets(2)=cc
                endif
                if rnd_range(1,100)<15 then 
                    cc+=1
                    map(a).planets(rnd_range(3,5))=cc
                endif
                
                if rnd_range(1,100)<5 then 
                    cc+=1
                    map(a).planets(rnd_range(6,9))=cc
                endif
            endif
        endif
    next
    for a=0 to cc
        planets(a)=delpl
    next
    for a=0 to laststar
        map(a).ti_no=89
    next
    lastplanet=cc
    return 0
end function

function add_wormholes() as short
    dim as short a,i,last,x,y,ano,qux1,quy1,qux2,quy2,highest,qdivx,qdivy
    
    dim quadrant(2,2) as byte
    if _debug>0 then dprint "W:"&wormhole
    for a=laststar+1 to laststar+wormhole-1 step 2
        do 
            qux1=rnd_range(0,2)
            quy1=rnd_range(0,2)
            qux2=rnd_range(0,2)
            quy2=rnd_range(0,2)
        loop until quadrant(qux1,quy1)<=highest and quadrant(qux2,quy2)<=highest and (qux1<>qux2 or quy1<>quy2)
        quadrant(qux1,quy1)+=1
        if quadrant(qux1,quy1)>highest then highest=quadrant(qux1,quy1)
        quadrant(qux2,quy2)+=1
        if quadrant(qux2,quy2)>highest then highest=quadrant(qux2,quy2)
        
        do
            map(a).c.x=rnd_range(0,sm_x/3)+qux1*sm_x/3
            map(a).c.y=rnd_range(0,sm_y/3)+quy1*sm_y/3
            map(a+1).c.x=rnd_range(0,sm_x/3)+qux2*sm_x/3
            map(a+1).c.y=rnd_range(0,sm_y/3)+quy2*sm_y/3
        loop until distance(map(a).c,map(a+1).c)>sm_x/3
        
        map(a).spec=9
        map(a).ti_no=77
        map(a).planets(1)=a+1
        map(a).discovered=maximum(show_all,show_wormholes)
        map(a+1).planets(1)=a
        map(a+1).spec=9
        map(a+1).ti_no=77
        map(a+1).discovered=maximum(show_all,show_wormholes)
    next
    if _debug>0 then dprint "Add wormholes done"
    return 0
end function

function add_ano(p1 as _cords,p2 as _cords,ano as short=0) as short
    dim as _cords p(256),p3
    dim as short last,x,y,r,ring
    if p2.x>=0 then
        last=line_in_points(p1,p2,p())
        if ano=0 then ano=rnd_range(6,9)
        p3=p(rnd_range(1,last))
        r=rnd_range(0,3)
    else
        p3=p1
        r=4
        ring=2
    endif
    if r=3 then ring=1
    for x=p3.x-6 to p3.x+6
        for y=p3.y-6 to p3.y+6
            p(0).x=x
            p(0).y=y
            if ((r=4 and ring=2 and (distance(p(0),p3)>2.5 and distance(p(0),p3)<4.5)) xor (ring=0 and distance(p(0),p3)<=r) xor (ring=1 and cint(distance(p(0),p3))=r)) and x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                spacemap(x,y)=-ano
            endif
        next
    next
    return 0
end function

function add_special_planets() as short
    dim as short a,sys,mp,d,gas,cgas,cc
    for a=0 to laststar
        if spacemap(map(a).c.x,map(a).c.y)<>0 and map(a).discovered=0 and map(a).spec<8 then cgas+=1
    next
    for a=0 to lastspecial
        do
            if a=2 or a=3 or a=4 or a=26 or a=27 then 'These specials are always generated in gasclouds
                cgas-=1
                gas=1
            else
                gas=0
            endif
            if cgas<=0 then 
                gas=0
                print "No more stars in gas clouds"
            endif
            sys=get_random_system(1,gas,1)
            if sys<0 then sys=get_random_system(1)
            if a=7 or a=46 and disnbase(map(sys).c)<25 then 
                cc=0
                do
                    cc+=1
                    sys=get_random_system(1,gas,1)
                    if sys<0 then sys=get_random_system(1)
                loop until disnbase(map(sys).c)>=25-cc/20 or cc>500
            endif
        loop until map(sys).spec<8 
        mp=getrandomplanet(sys)
        if mp=-1 and a<>18 then 
            mp=rnd_range(1,9)
            map(sys).planets(mp)=lastplanet+1
            lastplanet=lastplanet+1
            mp=lastplanet
        endif
        map(sys).discovered=2
        if a=18 then
            map(sys).planets(3)=lastplanet+1
            specialplanet(18)=lastplanet+1
            map(sys).planets(9)=lastplanet+2
            specialplanet(19)=lastplanet+2
            lastplanet=lastplanet+2
            a=19
        endif
        
        if a<>18 then specialplanet(a)=mp
        
    next
    
    specialplanet(30)=lastplanet+1
    lastplanet=lastplanet+1
    
'    a=sysfrommap(specialplanet(20))
'    print a
'    c=999
'    for b=0 to laststar
'        if b<>a then
'            if cint(distance(map(a).c,map(b).c))<c then
'                c=cint(distance(map(a).c,map(b).c))
'                d=b
'            endif
'        endif
'    next
'    
'    a=sysfrommap(specialplanet(26))
'    swap map(a).c,map(d).c
'    
    
    return 0
end function


function add_easy_planets(start as _cords) as short
    dim as short closest(5)
    dim as short a,b,c,f,r
    dim as single d
    dim as short list(laststar)
    for a=0 to laststar
        list(a)=a
    next
    
        
    for b=0 to 4
        d=999
        for a=0 to laststar
            if distance(start,map(a).c)<=d and map(a).spec<8 then
                f=0
                for c=0 to 4
                    if a=closest(c) then f=-1
                next
                if f=0 then
                    r=a
                    d=distance(start,map(a).c)
                endif
            endif
        next
        closest(b)=r
    next
    for b=0 to 4
        for a=1 to 9
            map(closest(b)).discovered=6
            if map(closest(b)).planets(a)>0 then
                if is_special(map(b).planets(a))=0 then
                    makeplanetmap(map(closest(b)).planets(a),a,map(closest(b)).spec+5)
                    for c=0 to 16
                        if planets(map(closest(b)).planets(a)).mon_template(c).hpmax>3 then planets(map(closest(b)).planets(a)).mon_template(c).hpmax=3 
                        planets(map(closest(b)).planets(a)).mon_template(c).hp=planets(map(closest(b)).planets(a)).mon_template(c).hpmax
                        planets(map(closest(b)).planets(a)).mon_template(c).armor=0
                        planets(map(closest(b)).planets(a)).mon_template(c).weapon=0
                        planets(map(closest(b)).planets(a)).mon_template(c).range=1.5
                    next
                endif
            endif
        next
    next
    
    return 0
end function

function add_event_planets() as short
    dim as short sys,d,planet,debug,f,orbit
    
    for d=0 to 5
        sys=get_random_system()
        if sys>0 then
            if debug=1 and _debug=1 then print "disc:";map(sys).discovered
            if map(sys).discovered=0 then
                planet=getrandomplanet(sys)
                
                if planet>0 then
                    if is_special(planet)=0 then
                        orbit=orbitfrommap(planet)
                        makeplanetmap(planet,orbit,map(sys).spec)
                        map(sys).discovered=3
                        make_eventplanet(planet)
                    endif
                endif
            endif
        endif
    next
    return 0
end function

function add_drifters() as short
    dim as short a,b,c,d,e,f,ba(3)
    dim as _cords p
    dim as byte makelog=0
    
    for e=firstwaypoint to lastwaypoint
        if targetlist(e).x=basis(0).c.x and targetlist(e).y=basis(0).c.y then ba(1)=e 
        if targetlist(e).x=basis(1).c.x and targetlist(e).y=basis(1).c.y then ba(2)=e 
        if targetlist(e).x=basis(2).c.x and targetlist(e).y=basis(2).c.y then ba(3)=e 
    next
    
    if makelog=1 then
        f=Freefile
        open "drifter.log" for output as #f
    endif
    for a=1 to lastdrifting
        if makelog=1 then print #f,a
        lastplanet=lastplanet+1
        drifting(a).x=rnd_range(0,sm_x)
        drifting(a).y=rnd_range(0,sm_y)
        drifting(a).s=rnd_range(1,a)
        drifting(a).m=lastplanet
        if a=1 then drifting(a).s=20
        if a=2 then drifting(a).s=20
        if a=3 then drifting(a).s=20
        if a=4 then drifting(a).s=17
        if a=5 then drifting(a).s=18 
        if a=6 then drifting(a).s=19
        if a=7 or a=8 then drifting(a).s=rnd_range(9,12)
        if a>=9 and a<=11 then drifting(a).s=rnd_range(5,8)
        if a>=12 and a<=16 then drifting(a).s=rnd_range(1,4)
        if makelog=1 then print #f,drifting(a).x;":";drifting(a).y;":";drifting(a).s;":";drifting(a).m
        if _debug>0 then dprint "Making drifter "&a
        if drifting(a).s<=22 then make_drifter(drifting(a),0,0,f)
        drifting(a).p=show_all
        if _debug>0 then drifting(a).p=1
    next
    if makelog=1 then close #f
    drifting(1).x=targetlist(firstwaypoint).x
    drifting(1).y=targetlist(firstwaypoint).y
    planets(drifting(1).m).atmos=5
    planets(drifting(1).m).depth=1
    planets_flavortext(drifting(1).m)="A cheerfull sign says 'Welcome! Please enjoy our services'"
    deletemonsters(drifting(1).m)
    planets(drifting(1).m).mon_template(0)=makemonster(88,drifting(1).m)
    planets(drifting(1).m).mon_noamin(0)=1
    planets(drifting(1).m).mon_noamax(0)=4
    planets(drifting(1).m).mon_template(2)=makemonster(99,drifting(1).m)
    planets(drifting(1).m).mon_noamin(2)=1
    planets(drifting(1).m).mon_noamax(2)=1
    planets(drifting(1).m).mon_template(3)=makemonster(103,drifting(1).m)
    planets(drifting(1).m).mon_noamin(3)=1
    planets(drifting(1).m).mon_noamax(3)=2
    planets(drifting(1).m).darkness=0
    planets(drifting(2).m).darkness=0
    planets(drifting(3).m).darkness=0
    planets(drifting(1).m).flags(29)=5
    planets(drifting(2).m).flags(29)=6
    planets(drifting(3).m).flags(29)=7
    
    planetmap(19,10,drifting(1).m)=-287
    if rnd_range(1,100)<66 then add_company_shop(1,4)'company shop
        
    planetmap(46,18,drifting(1).m)=-222
    for a=1 to rnd_range(2,5) 'Some spacesuits in the starting station
        placeitem(make_item(320),46,18,drifting(1).m)
    next
    
    b=0
    do
        b+=1
        p=targetlist(rnd_range(firstwaypoint,lastwaypoint))
    loop until (p.x>=20 and p.x<=25) or b>250
    
    drifting(2).x=p.x
    drifting(2).y=p.y
    planets(drifting(2).m).atmos=5
    planets(drifting(2).m).depth=1
    deletemonsters(drifting(2).m)
    planets_flavortext(drifting(2).m)="A cheerfull sign says 'Welcome! Please enjoy our services'"
    planets(drifting(2).m).mon_template(0)=makemonster(88,drifting(2).m)
    planets(drifting(2).m).mon_noamin(0)=1
    planets(drifting(2).m).mon_noamax(0)=4
    
    planets(drifting(2).m).mon_template(2)=makemonster(103,drifting(1).m)
    planets(drifting(2).m).mon_noamin(2)=1
    planets(drifting(2).m).mon_noamax(2)=2

    
    planetmap(19,10,drifting(2).m)=-287
    
    if rnd_range(1,100)<33 then add_company_shop(2,3)
    
    b=0
    do
        b+=1
        p=targetlist(rnd_range(firstwaypoint,lastwaypoint))
    loop until (p.x>=50 and p.x<=55) or b>250
    drifting(3).x=p.x
    drifting(3).y=p.y
    
    planets(drifting(3).m).atmos=5
    planets(drifting(3).m).depth=1
    deletemonsters(drifting(3).m)
    planets_flavortext(drifting(3).m)="A cheerfull sign says 'Welcome! Please enjoy our services'"
    planets(drifting(3).m).mon_template(0)=makemonster(88,drifting(3).m)
    planets(drifting(3).m).mon_noamin(0)=1
    planets(drifting(3).m).mon_noamax(0)=4
    
    planets(drifting(3).m).mon_template(2)=makemonster(103,drifting(1).m)
    planets(drifting(3).m).mon_noamin(2)=1
    planets(drifting(3).m).mon_noamax(2)=2
    
    if _debug=-1 then
        drifting(1).s=9
        drifting(1).m=lastplanet
        lastplanet+=1
        make_drifter(drifting(1))
        deletemonsters(drifting(1).m)
    endif
    
    planetmap(19,10,drifting(3).m)=-287
    if rnd_range(1,100)<33 then add_company_shop(3,3)
    drifting(4).x=map(sysfrommap(specialplanet(18))).c.x-5+rnd_range(1,10)
    drifting(4).y=map(sysfrommap(specialplanet(18))).c.y-5+rnd_range(1,10)
    if drifting(4).x<0 then drifting(lastdrifting).x=0
    if drifting(4).y<0 then drifting(lastdrifting).y=0
    if drifting(4).x>sm_x then drifting(lastdrifting).x=sm_x
    if drifting(4).y>sm_y then drifting(lastdrifting).y=sm_y
    planets_flavortext(drifting(4).m)="You enter the alien vessel. The air is breathable. Most of the ship seems to be a huge hall illuminated in blue light. Strange trees grow in orderly rows and stranger insect creatures scurry about." 
    planets(drifting(4).m).atmos=4
    planets(drifting(4).m).depth=1
    deletemonsters(drifting(4).m)
    planets(drifting(4).m).mon_template(0)=makemonster(37,drifting(4).m)
    planets(drifting(4).m).mon_noamin(0)=16
    planets(drifting(4).m).mon_noamax(0)=26
    
    planets_flavortext(drifting(5).m)="This ship has been drifting here for millenia. The air is gone. Propably some asteroid punched a hole into the hull. Dim green lights on the floor barely illuminate the corridors."
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
    
    planets_flavortext(drifting(6).m)="You dock at the ancient space probe."
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
            for a=1 to lastdrifting
                for b=0 to 2
                    if drifting(a).x=basis(b).c.x and drifting(a).y=basis(b).c.y then
                        d=d+1
                        drifting(a).x=rnd_range(0,sm_x)
                        drifting(a).y=rnd_range(0,sm_y)
                    endif
                next
                for b=1 to lastdrifting
                    if a<> b then
                        if drifting(a).x=drifting(b).x and drifting(a).y=drifting(b).y then
                            d=d+1
                            drifting(a).x=rnd_range(0,sm_x)
                            drifting(a).y=rnd_range(0,sm_y)
                        endif
                    endif
                next
                
            next
        next
        if _debug>0 then dprint "D"&d
    loop until d=0
    
    for a=0 to 15
        p=rnd_point(drifting(5).m,0)
        planetmap(p.x,p.y,drifting(5).m)=-81
    next
    for a=0 to 15
        p=rnd_point(drifting(5).m,0)
        planetmap(p.x,p.y,drifting(5).m)=-158
    next
    
    return 0
end function

function add_company_shop(slot as short,mt as short) as short
    dim as short c
    c=rnd_range(1,4)
    planetmap(39,13,drifting(slot).m)=(298+c)*-1
    select case c
    case 1 'EE
        planets(drifting(slot).m).mon_template(mt)=makemonster(86,drifting(slot).m)
    case 2 'SHI
        planets(drifting(slot).m).mon_template(mt)=makemonster(71,drifting(slot).m)
    case 3 'TT
        planets(drifting(slot).m).mon_template(mt)=makemonster(74,drifting(slot).m)
    case 4 'OB
        planets(drifting(slot).m).mon_template(mt)=makemonster(76,drifting(slot).m)
    end select
    planets(drifting(slot).m).mon_template(mt).lang=39
    planets(drifting(slot).m).mon_template(mt).allied=1
    planets(drifting(slot).m).mon_template(mt).faction=10
    planets(drifting(slot).m).mon_template(mt).aggr=1
    planets(drifting(slot).m).mon_noamin(mt)=1
    planets(drifting(slot).m).mon_noamax(mt)=1
    return 0
end function
    

function add_caves() as short
    dim as short a,b,debug
    for a=lastportal+1 to lastportal+23
         
            portal(a).desig="A natural tunnel. "
            portal(a).tile=111
            portal(a).col=7
            portal(a).ti_no=3001
            portal(a).from.m=get_nonspecialplanet(1)
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
            else
                portal(a).from.s=sysfrommap(portal(a).from.m)
                portal(a).dest.s=sysfrommap(portal(a).from.m)
            endif
            'portal(a).from.m=map(portal(a).from.s).planets(portal(a).from.p)
            lastplanet+=1
            portal(a).from.x=rnd_range(1,59)
            portal(a).from.y=rnd_range(1,19)
            portal(a).dest.m=lastplanet
            portal(a).dest.s=portal(a).from.s
            portal(a).dest.x=rnd_range(1,59)
            portal(a).dest.y=rnd_range(1,19)
            portal(a).discovered=show_portals
            portal(a).dimod=2-rnd_range(1,4)
            portal(a).tumod=4-rnd_range(1,8)
            portal(a).oneway=0
            map(sysfrommap(portal(a).from.m)).discovered=5
            
            if debug=1 and _debug=1 then
                portal(a).from.x=30
                portal(a).from.y=10
                
            endif
    next
    lastportal+=23
    if debug=1 and _debug=1 then
        a=freefile
        open "portals.csv" for output as #a
        for b=0 to lastportal
            print #a,portal(b).from.x;";";portal(b).from.y;";";portal(b).from.m;";";portal(b).dest.x;";";portal(b).dest.y;";";portal(b).dest.m
        next
        close #a
    endif
    return 0
end function

function add_piratebase() as short
    dim list(laststar) as short
    dim dist(laststar) as single
    dim as short a,b,c,d,piratesys,found,cc,f
    for a=1 to laststar
        if spacemap(map(a).c.x,map(a).c.y)=0 and disnbase(map(a).c)>=5 and map(a).spec<=7 then
            cc=0
            for b=1 to 9
                if is_special(map(a).planets(b)) then cc=1
            next
            if cc=0 then
                c+=1
                list(c)=a
                dist(c)=99999
                for b=1 to lastwaypoint
                    if distance(targetlist(b),map(a).c)<dist(c) then dist(c)=distance(targetlist(b),map(a).c)
                next
            endif
        endif
    next
    for a=1 to cc
        dist(a)=dist(a)-disnbase(map(list(a)).c)
    next
    'List = candidates
    if _debug>0 then 
        f=freefile
        open "distances.csv" for output as #f
        for a=0 to c
            print #f,a &";" &cint(dist(a)) &";"&cint(disnbase(map(list(a)).c))
        next
        close #f
    end if
    
    for a=0 to _noPB
        dist(0)=9999
        for b=1 to c
            if dist(b)<dist(0) and dist(b)>0 then
                found=b
                dist(0)=dist(b)
            endif
        next
        lastplanet+=1
        piratebase(a)=lastplanet
        map(list(found)).planets(rnd_range(1,9))=lastplanet
        list(found)=list(c)
        dist(found)=dist(c)
        c-=1
    next
    if _debug>0 then dprint "Added pirate base"
    return 0
end function

function add_questguys() as short
    dim as short i,debug,f,j
    dim alreadyhere(17) as byte
    questguy(0).n="Questguy0" 'WE should never see this guy
    for i=0 to lastquestguy
        questguy(i)=questguy(0) 'Delete quest guy
    next
    for i=0 to lastquestguy 'For the deletion questguy
        questguy(i).location=-2 'Everybody starts nowhere
    next
    
    debug=1
    f=freefile
    if debug=1 and _debug=1 then open "questguys.log" for output as #f
    for i=1 to lastquestguy
        if debug=1 and _debug=1 then print #f,"Making qg "&i
        questguy(i).n=character_name(questguy(i).gender)
        if i=1 then 
            questguy(i).location=0
            questguy(i).job=1
        endif
        if i=2 then
            questguy(i).location=1
            questguy(i).job=1
        endif
        if i=3 then 
            questguy(i).location=2
            questguy(i).job=1
        endif
        if i=4 then questguy(i).job=14
        if i>4 then 
            do
                questguy(i).job=rnd_range(2,17)
            loop until alreadyhere(questguy(i).job)=0
            alreadyhere(questguy(i).job)=1
            questguy_newloc(i)
        endif
        questguy(i).risk=rnd_range(3,9)
        select case questguy(i).job
        case 1
            questguy(i).risk+=1
        case 2 to 9
            questguy(i).risk+=2
        end select
        if questguy(i).risk>9 then questguy(i).risk=9 
        if debug=1 and _debug=1 then print #f,"Doing newquest"
        questguy_newquest(i)
        for j=0 to lastquestguy
            questguy(i).friendly(j)=rnd_range(0,2) '0 hates you, 2 loves you
        next
        questguy(i).money=rnd_range(10,15)*100
        select case questguy(i).job
        case 1
            questguy(i).money+=rnd_range(5,10)*100
        case 2,14,15,16,17
            questguy(i).money+=rnd_range(5,10)*10
        case 10,11,12,13
            questguy(i).money+=rnd_range(5,15)*100
        case 9
            questguy(i).money+=rnd_range(5,10)*10
        case else
            questguy(i).money-=rnd_range(1,10)*100
            if questguy(i).money<=0 then questguy(i).money=rnd_range(100,300)
        end select' 
        
        if rnd_range(1,100)<20 or _debug=2020 then 'talent to share
            if rnd_range(1,100)<66 then 'Job specific
                select case questguy(i).job
                case 1,2
                    questguy(i).flag(10)=rnd_range(1,6)
                case 4,15,16,17 'SO
                    questguy(i).flag(10)=rnd_range(14,16)
                case 5 'gunner
                    questguy(i).flag(10)=rnd_range(7,9)
                case 6
                    questguy(i).flag(10)=rnd_range(17,19)
                case 7
                    questguy(i).flag(10)=6
                case 10,11,12,13
                    questguy(i).flag(10)=3
                case 14
                    questguy(i).flag(10)=4
                case else
                    questguy(i).flag(10)=rnd_range(20,26)
                end select
            else
                questguy(i).flag(10)=rnd_range(20,26)'generic
            endif
        endif
        
        if debug=1 and _debug=1 then 
            print #f,i;"flag 3";questguy(i).flag(3)
            print #f,i;"flag 4";questguy(i).flag(4)
        endif
        if debug=1 and _debug=1 then print #f,i;"Outloan:"&questguy(questguy(i).flag(1)).loan ;" to "; questguy(questguy(i).flag(1)).n
        if debug=1 and _debug=1 then print #f,"Money:"&questguy(i).money
    next
    if debug=1 and _debug=1 then 
        for i=1 to lastquestguy
            print #f,questguy(i).n ;" loaned ";questguy(questguy(i).flag(1)).loan;" to "; questguy(questguy(i).flag(1)).n
        next
        close #f
    endif
    return 0
end function

function gen_bountyquests() as short
    dim as short f,i
    dim as string w(4),l
    f=freefile
    open "data\bountyquests.csv" for input as #f
    do
        line input #f,l
        string_towords(w(),l,";")
        i+=1
        bountyquest(i).employer=val(w(0))
        bountyquest(i).ship=val(w(1))
        bountyquest(i).reward=val(w(2))
        bountyquest(i).reason=rnd_range(1,3)+3*bountyquest(i).employer
    loop until eof(f)
    close #f
    return 0
end function


function distribute_stars() as short
    dim a as short
    for a=0 to laststar
        map(a).discovered=show_all
        pwa(a)=map(a).c
    next
    for a=laststar+1 to laststar+wormhole
        map(a).discovered=show_wormholes
        pwa(a)=map(a).c
    next
    a=distributepoints(pwa(),pwa(),laststar+wormhole)
    for a=0 to laststar+wormhole
        map(a).c=pwa(a)
    next
    return 0
end function

function gen_traderoutes() as short
    dim as _cords start,goal,wpl(40680)
    dim as _cords p
    dim t as short
    dim map(sm_x,sm_y) as short
    dim as integer x,y,i,offset,a,d,r
    dim as integer fp,lp,smallstation
    dim as byte debug
    dim as byte visited(2)
    
    lastwaypoint=5
    firstwaypoint=5
    for a=5 to 4068
        targetlist(a).x=0
        targetlist(a).y=0
    next
    for x=0 to sm_x
        for y=0 to sm_y
            p.x=x
            p.y=y
            if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5 then map(x,y)=3200
            if abs(spacemap(x,y))>5 then map(x,y)=15
            'if abs(spacemap(x-1,y))>=2 then map(x,y)=1
            'if abs(spacemap(x,y-1))>=2 then map(x,y)=1
            'if spacemap(x,y-1)<>0 and spacemap(x,y-1)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x,y-1)<>0 and spacemap(x,y-1)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x-1,y)<>0 and spacemap(x-1,y)<>1 and disnbase(p)>3 then map(x,y)=1
            'if spacemap(x-1,y)<>0 and spacemap(x-1,y)<>1 and disnbase(p)>3 then map(x,y)=1
            if map(x,y)>0 and show_NPCs=1 and _debug=1 then
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
    d=99999
    for a=0 to 2
        lp=a_star(wpl(),basis(a).c,start,map(),sm_x,sm_y)
        if lp<d and visited(a)=0 then
            d=lp
            r=a
        endif
        for i=0 to lp
            wpl(i).x=0
            wpl(i).y=0
        next
    next
    goal.x=basis(r).c.x
    goal.y=basis(r).c.y
    lp=A_Star(wpl(),goal,start,map(),sm_x,sm_y)
    offset=11
    if lp>0 then
        for i=0 to lp
            targetlist(i+offset).x=wpl(i).x
            targetlist(i+offset).y=wpl(i).y
            spacemap(wpl(i).x,wpl(i).y)=0
            wpl(i).x=0
            wpl(i).y=0
        next
    else
        
    endif
    firstwaypoint=lp+offset
    smallstation=2
    do
        lastwaypoint=lp+offset
        offset=lastwaypoint+1
        firststationw=lastwaypoint
        visited(r)=1
        
        start=targetlist(lastwaypoint)
        d=99999
        for a=0 to 2
            lp=a_star(wpl(),basis(a).c,start,map(),sm_x,sm_y)
            if lp<d and visited(a)=0 then
                d=lp
                r=a
            endif
            for i=0 to lp
                wpl(i).x=0
                wpl(i).y=0
            next
        next
        goal.x=basis(r).c.x
        goal.y=basis(r).c.y
        lp=A_Star(wpl(),goal,start,map(),sm_x,sm_y)
        if lp>0 then
            for i=0 to lp
                targetlist(i+offset).x=wpl(i).x
                targetlist(i+offset).y=wpl(i).y
                spacemap(wpl(i).x,wpl(i).y)=0
                wpl(i).x=0
                wpl(i).y=0
            next
        endif
    loop until visited(0)=1 and visited(1)=1 and visited(2)=1

start=targetlist(lastwaypoint)
goal=targetlist(firstwaypoint)
offset=lastwaypoint+1
if debug=5 and _debug=1 then
    locate goal.y+1,goal.x+1
    print "G"
    locate start.y+1,start.x+1
    print "S"
endif
lp=A_Star(wpl(),goal,start,map(),sm_x,sm_y)

    if lp>0 then
        for i=0 to lp
            targetlist(i+offset).x=wpl(i).x
            targetlist(i+offset).y=wpl(i).y
            spacemap(wpl(i).x,wpl(i).y)=0
            wpl(i).x=0
            wpl(i).y=0
            if debug=5 and _debug=1 then
                sleep 50
                locate targetlist(i+offset).y+1,targetlist(i+offset).x+1
                print "*"
            endif
        next
    endif
    lastwaypoint=lastwaypoint+lp
'    for a=1 to 2
'        start.x=basis(a-1).c.x
'        start.y=basis(a-1).c.y
'        goal.x=basis(a).c.x
'        goal.y=basis(a).c.y
'        lp=A_Star(wpl(),goal,start,map(),sm_x,sm_y)
'        for i=0 to lp
'            targetlist(i+offset).x=wpl(i).x
'            targetlist(i+offset).y=wpl(i).y
'
'            wpl(i).x=0
'            wpl(i).y=0
'        next
'        print offset;"-";lastwaypoint+lp
'        lastwaypoint=lastwaypoint+lp+1
'        offset=lastwaypoint
'    next
'    start.x=basis(2).c.x
'    start.y=basis(2).c.y
'    goal.x=basis(0).c.x
'    goal.y=basis(0).c.y
'    lp=A_star(wpl(),goal,start,map(),sm_x,sm_y)
'    for i=0 to lp
'        targetlist(i+offset).x=wpl(i).x
'        targetlist(i+offset).y=wpl(i).y
'    next
'    offset=offset+lp+1
'    print offset;"-";lastwaypoint+lp
'    lastwaypoint=lastwaypoint+lp
    firstwaypoint=11
'    
    if debug=5 and _debug=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)<>0 and spacemap(x,y)<>1 then 
                    map(x,y)=abs(spacemap(x,y))
                    
                else
                    map(x,y)=0
                endif
                locate y+1,x+1
                if map(x,y)>=1 and map(x,y)<=9 then
                    set__color( 15,0)
                    if map(x,y)=1 then print "1";
                    if map(x,y)=2 then print "2";
                    if map(x,y)=3 then print "3";
                    if map(x,y)=4 then print "4";
                    if map(x,y)=5 then print "5";
                endif
                
                if map(x,y)=0 then
                    set__color( 1,0)
                    print ".";
                endif
            next
        next
        set__color( 10,0)
        x=firstwaypoint
        do
            set__color( 10,0)
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
            set__color( 15,0)
            locate targetlist(x).y+1,targetlist(x).x+1
            print "."
        loop until inkey<>""
        sleep
        
    endif
    if debug=5 and _debug=1 then
        for a=11 to lastwaypoint
            locate targetlist(a).y+1,targetlist(a).x+1
            print "*"
            sleep 100
        next
        set__color(c_red,0)
        locate targetlist(0).y+1,targetlist(0).x+1
        print "*TP0"
        
        locate targetlist(firstwaypoint).y+1,targetlist(firstwaypoint).x+1
        print "*FWP"
        for a=0 to 3
            locate basis(a).c.y+1,basis(a).c.x+2
            print "<-S"&a+1;
        next
        sleep    
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

function gen_shops() as short
    dim  as short i,j,flag,debug,mudddone,lastshopspec,botsdone
    dim as byte shopspec(7)
    dim c as _cords
    lastshopspec=3
    for i=0 to 3
        shopspec(i)=sh_Explorers+i
    next
    
    for i=0 to 3 'Set shopspecs. Never should be the same twice
        j=rnd_range(0,lastshopspec)
        add_shop(shopspec(j),c,i)
        basis(i).shop(0)=shopspec(j)
        shopspec(j)=shopspec(lastshopspec)
        lastshopspec-=1
        if rnd_range(1,100)<15 then 
            basis(i).shop(sh_mudds)=1
            add_shop(sh_mudds,c,i)
            mudddone=1
        endif
        if rnd_range(1,100)<15 then
            basis(i).shop(sh_bots)=1
            add_shop(sh_bots,c,i)
            botsdone=1
        endif
        select case rnd_range(1,100)
        case 1 to 10
            basis(i).pricelevel=1.2
        case 11 to 30
            basis(i).pricelevel=1.1
        case 71 to 90
            basis(i).pricelevel=0.9
        case 91 to 100
            basis(i).pricelevel=0.8
        case else
            basis(i).pricelevel=1
        end select
        if rnd_range(1,100)<(1-basis(i).pricelevel)*100 or _debug=1 then 
            basis(i).shop(sh_used)=1
            add_shop(sh_used,c,i)
            add_shop(sh_usedships,c,i)'Need both
        endif
    next
    if mudddone=0 then 
        i=rnd_range(0,2)
        basis(i).shop(Sh_mudds)=1
        add_shop(sh_mudds,c,i)
    endif 
    if botsdone=0 then 
        i=rnd_range(0,2)
        basis(i).shop(Sh_bots)=1
        add_shop(sh_bots,c,i)
    endif
    
    j=0
    lastshopspec=5
    for i=0 to lastshopspec
       shopspec(i)=j
       j+=1
       if j>2 then j=0
    next
    for i=6 to 7
        shopspec(i)=0
    next
    for i=0 to 3
        j=rnd_range(0,lastshopspec)
        basis(i).shop(sh_modules)=shopspec(j)
        shopspec(j)=shopspec(lastshopspec)
        lastshopspec-=1
        basis(i).shop(sh_shipyard)=rnd_range(0,1)
    next
    
    shopspec(0)=0
    shopspec(1)=1
    shopspec(2)=rnd_range(0,1)
    lastshopspec=2
    for i=0 to 2
        j=rnd_range(0,lastshopspec)
        basis(i).shop(sh_shipyard)=shopspec(j)
        shopspec(j)=shopspec(lastshopspec)
        lastshopspec-=1
    next
    basis(3).shop(sh_shipyard)=rnd_range(0,1)
    
    for i=0 to 2
        add_shop(sh_sickbay,c,i)
    next
    
    add_shop(sh_modules,c,0)
    add_shop(sh_modules,c,1)
    add_shop(sh_modules,c,2)
    add_shop(sh_modules,c,3)
    add_shop(sh_modules,c,4)
    add_shop(sh_modules,c,5)
    
    return 0
end function

function make_eventplanet(slot as short, cl as byte=0) as short
    dim as _cords p1,from,dest
    dim as _cords gc1,gc
    dim as short x,y,a,b,t1,t2,t,maxt,debug
    static generated(11) as short
    
    if cl=1 then
        for a=0 to 11
            generated(a)=0
        next
        return 0
    endif
    debug=4
    if orbitfrommap(slot)<>1 then
        maxt=10
    else
        maxt=11
    endif
    
    do
        t1=rnd_range(0,maxt)+disnbase(map(sysfrommap(slot)).c)/10
        t2=rnd_range(0,maxt)+disnbase(map(sysfrommap(slot)).c)/10
        if t1<1 then t1=1
        if t2<1 then t2=1
        if t1>maxt then t1=maxt
        if t2>maxt then t2=maxt
    loop until t1<>t2
    if generated(t1)>generated(t2) then t=t2
    if generated(t1)<generated(t2) then t=t1
    if generated(t1)=generated(t2) then 
        if rnd_range(1,100)<=50 then
            t=t1
        else
            t=t2
        endif
    endif
    
    if t<1 then t=1
    if t>maxt then t=maxt
    
    generated(t)+=1
    't=4
    if debug=1 and _debug=1 then 
        print "making "&t & " on planet "&slot &" in system " &sysfrommap(slot)
        no_key=keyin
    endif
    if debug=4 and _Debug>1 then t=1
    if t=1 then 'Mining Colony in Distress Flag 22 
        make_mine(slot)
        if _Debug>0 then 
            dprint "Slot:"&slot &"LP:"&lastportal
            no_key=keyin
        endif
    endif
    
    if t=2 then 'Icetrolls
        deletemonsters(slot)
        makecraters(slot,3)
        planets(slot).temp=-100+rnd_range(1,15)/2
        planets(slot).atmos=1
        planets(slot).rot=rnd_range(1,3)/100
        planets(slot).grav=rnd_range(6,16)/10
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,slot))).walktru=0 then
                    if rnd_range(1,100)<25 then planetmap(x,y,slot)=-304
                endif
            next
        next
    endif
    
    if t=3 then
        planetmap(rnd_range(0,60),rnd_range(0,20),slot)=-9
    endif
    
    if t=4 then 'Smith & Pirates fighting over an ancient factory Flag 23
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=264
        next
        for a=0 to rnd_range(2,5)
            p1=rnd_point()
            planetmap(p1.x,p1.y,slot)=-67
        next
        planets(slot).flags(23)=1
        
        planets(slot).mon_template(0)=makemonster(3,slot)
        planets(slot).mon_noamax(0)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        
        planets(slot).mon_template(1)=makemonster(50,slot)
        planets(slot).mon_noamax(1)=rnd_Range(0,2)+3
        planets(slot).mon_noamin(1)=rnd_Range(1,2)
        
        planets(slot).mon_template(2)=makemonster(71,slot)
        planets(slot).mon_template(2).cmmod=5
        planets(slot).mon_template(2).lang=29
        planets(slot).mon_noamax(2)=rnd_Range(2,12)+6
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        
        planets(slot).mon_template(3)=makemonster(72,slot)
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
        planets(slot).atmos=5
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
            placeitem(make_item(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
        for x=0 to 3
            p1=rnd_point
            planetmap(p1.x,p1.y,slot)=-59
            placeitem(make_item(96,planets(slot).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),p1.x,p1.y,slot,0,0)

        next
        
        lastportal=lastportal+1
        lastplanet=lastplanet+1
        makeroots(lastplanet)
        
        portal(lastportal).desig="An opening between the roots. "
        portal(lastportal).tile=asc("o")
        portal(lastportal).col=4
        portal(lastportal).ti_no=3003
        portal(lastportal).from=rnd_point(0,slot)
        portal(lastportal).from.m=slot
        portal(lastportal).dest=rnd_point(0,lastplanet)
        portal(lastportal).dest.m=lastplanet
        portal(lastportal).discovered=show_portals
        if debug<>0 and _debug=1 then portal(lastportal).discovered=1
        planets(slot).mon_template(0)=makemonster(4,slot)
        planets(slot).mon_noamin(0)=15
        planets(slot).mon_noamax(0)=25
        planets(lastplanet)=planets(slot)
        planets(lastplanet).depth=3
        planets(lastplanet).grav=0
        for b=0 to rnd_range(0,6)+disnbase(player.c)\4
            placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),lastplanet)
        next b
        
    endif
    if t=7 or t=8 then
        makemossworld(slot,5)
        planets(slot).atmos=4
        planets(slot).flags(25)=1
    endif
    
    if t=9 then 'Squid underwater cave world
        makeoceanworld(slot,3)
        lastplanet+=1
        makeroots(lastplanet)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=152 then planetmap(x,y,lastplanet)=-48
                if abs(planetmap(x,y,lastplanet))=3 then planetmap(x,y,lastplanet)=-1
                if abs(planetmap(x,y,lastplanet))=59 then planetmap(x,y,lastplanet)=-97
                if abs(planetmap(x,y,lastplanet))=146 then planetmap(x,y,lastplanet)=-165
            next
        next
        deletemonsters(slot)
        planets(slot).mon_template(0)=makemonster(92,slot)
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        planets(slot).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(1)=makemonster(93,slot)
        planets(slot).mon_noamin(1)=rnd_Range(2,12)
        planets(slot).mon_noamax(1)=planets(slot).mon_noamin(0)+6
        
        planets(slot).mon_template(2)=makemonster(95,slot)
        planets(slot).mon_noamin(2)=rnd_Range(2,12)
        planets(slot).mon_noamax(2)=planets(slot).mon_noamin(0)+6
        
        
        planets(slot).temp=30
        for b=1 to 5
            from=rnd_point(slot,1)
            from.m=slot
            dest=rnd_point(lastplanet,1)
            dest.m=lastplanet
            addportal(from,dest,1,asc("o"),"An underwater cave",9)
            addportal(Dest,from,1,asc("o"),"A tunnel to the surface",9)
        next
        planets(slot).flags(26)=1
        planets(slot).atmos=6
        planets(lastplanet).atmos=1
        planets(lastplanet).depth=5
        planets(lastplanet).mon_template(0)=makemonster(92,slot)
        planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(0)=planets(slot).mon_noamin(0)+6
        
        planets(lastplanet).mon_template(1)=makemonster(93,slot)
        planets(lastplanet).mon_noamin(1)=rnd_Range(2,12)
        planets(lastplanet).mon_noamax(1)=planets(lastplanet).mon_noamin(1)+6
        
        planets(lastplanet).mon_template(2)=makemonster(94,slot)
        planets(lastplanet).mon_noamin(2)=rnd_Range(2,4)
        planets(lastplanet).mon_noamax(2)=planets(slot).mon_noamin(2)+2
        for b=0 to 20+rnd_range(0,6)+disnbase(player.c)\4
            gc=rnd_point(lastplanet,0)
            placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),gc.x,gc.y,lastplanet,0,0)
        next b
    endif
    if t=10 then 'Living geysers
        makegeyseroasis(slot)
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,slot))=28 then planetmap(x,y,slot)=-295
            next
        next
        
        planets(slot).mon_template(0)=makemonster(97,slot)
        planets(slot).mon_noamin(0)=rnd_Range(2,12)
        planets(slot).mon_noamax(0)=planets(slot).mon_noamin(0)+6
    endif
    
    if t=11 then
        deletemonsters(slot)
        planets(slot).flags(27)=1
        planets(slot).water=0
        planets(slot).atmos=1
        planets(slot).grav=3
        planets(slot).temp=4326+rnd_range(1,100)
        planets(slot).death=10+rnd_range(0,6)+rnd_range(0,6)
        for b=0 to rnd_range(1,8)+rnd_range(1,5)+rnd_range(1,3)
            placeitem(make_item(96,4,4),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
        for b=0 to rnd_range(0,15)+15
            placeitem(make_item(96,9,7),rnd_range(0,60),rnd_range(0,20),slot,0,0)
        next
    endif
    return 0
    
end function

function make_clouds() as short
    dim wmap(sm_x,sm_y)as ubyte
    dim wmap2(sm_x,sm_y)as ubyte
    dim as short x,y,bx,by,highest,count,a,b,c,r,last,i,ano,x1,y1,j,last2,f
    dim as single attempt
    dim debug as short
    dim pp((sm_x+1)*(sm_y+1)) as _cords
    
    dim as _cords p1,p2,p3,p4,p(1024)
    for i=0 to sm_x*sm_y*0.66
        wmap(rnd_range(0,sm_x),rnd_range(0,sm_y))=1
    next
    for i=0 to laststar
        if rnd_range(1,100)<50 then wmap(map(i).c.x,map(i).c.y)=1
    next
    for a=0 to 2
        for x=basis(a).c.x-2 to basis(a).c.x+2
            for y=basis(a).c.y-2 to basis(a).c.y+2
                if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                    wmap(x,y)=0
                endif
            next
        next
    next
    for i=0 to 5
        for x=1 to sm_x-1
            for y=1 to sm_y-1
                count=0
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if wmap(x1,y1)=1 then count+=1
                    next
                next
                if count>=5 then 
                    wmap2(x,y)=1
                else
                    wmap2(x,y)=0
                endif
            next
        next
        for x=0 to sm_x
            for y=0 to sm_y
                wmap(x,y)=wmap2(x,y)
            next
        next
    next
    for j=0 to 1
        for i=1 to 4
            
            
            for x=1 to sm_x-1
                for y=1 to sm_y-1
                    count=0
                    for x1=x-1 to x+1
                        for y1=y-1 to y+1
                            if wmap(x1,y1)=i then count+=1
                        next
                    next
                    if count>=7 and wmap(x,y)<i+1 then 
                        wmap2(x,y)=i+1
                    else
                        wmap2(x,y)=wmap(x,y)
                    endif
                next
            next
            
            for x=0 to sm_x
                for y=0 to sm_y
                    wmap(x,y)=wmap2(x,y)
                next
            next
            
        next
    next
'    for x=0 to sm_x
'        for y=0 to sm_y
'            if wmap(x,y)>0 and wmap(x,y)<5 then wmap(x,y)+=1
'            color rgba(wmap(x,y)*50,wmap(x,y)*50,wmap(x,y)*50,255)
'            pset(x*2,y*2)
'            pset(x*2,y*2+1)
'            pset(x*2+1,y*2+1)
'            pset(x*2+1,y*2)
'        next
'    next
'    color rgba(0,255,0,255)
'    for a=0 to 2
'        pset (basis(a).c.x*2,basis(a).c.y*2)
'    next
'    sleep
    
    for x=0 to sm_x
        for y=0 to sm_y
            spacemap(x,y)=-wmap(x,y)
            if abs(spacemap(x,y))=1 then spacemap(x,y)=0
        next
    next
    
    

    if rnd_range(1,100)<33 then
        p1.x=rnd_range(1,sm_x)
        p1.y=rnd_range(1,sm_y)
    else
        p1=map(rnd_range(laststar+1,laststar+wormhole)).c
    endif

    for a=laststar+1 to laststar+wormhole
        last=line_in_points(map(a).c,map(map(a).planets(1)).c,p())
        for i=1 to last
            if a mod 2=0 and last2<=1024 then
                last2+=1
                pp(last2)=p(i)
            endif
            if rnd_range(1,10)<12-distance(map(a).c,p(i)) then
                if p(i).x>=0 and p(i).y>=0 and p(i).x<=sm_x and p(i).y<=sm_y then
                    spacemap(p(i).x,p(i).y)=-1*rnd_range(6,9)
                endif
            endif
        next
        ano=rnd_range(6,9)
        r=distance(map(a).c,map(map(a).planets(1)).c)/20
        if r<1 then r=1
        for x=map(a).c.x-r to map(a).c.x+r
            for y=map(a).c.y-r to map(a).c.y+r
                if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                    p1.x=x
                    p1.y=y
                    if distance(p1,map(a).c)<=r then spacemap(x,y)=-ano
                endif
            next
        next
        if rnd_range(1,100)<distance(map(a).c,map(map(a).planets(1)).c) or rnd_range(1,100)<distance(map(a).c,map(map(a).planets(1)).c) then
            'add_ano(map(a).c,map(map(a).planets(1)).c,ano)
        endif
    next
    
    if last2>1024 then last2=1024
    
    for i=1 to last2
        for a=1 to last2
            if i<>a then
                if pp(a).x=pp(i).x and pp(a).y=pp(i).y then
                    p1.x=-1
                    'add_ano(pp(i),p1,rnd_range(6,9))
                    for j=a-rnd_range(1,4) to a+rnd_range(1,4)
                        if j>=1 and j<=last2 then
                            if distance(pp(a),pp(j))<=5 then spacemap(pp(j).x,pp(j).y)=-rnd_range(6,9)
                        endif
                    next
                endif
            endif
        next
    next
    
    x=rnd_range(0,sm_x)
    y=rnd_range(0,sm_y)
    select case rnd_range(1,4)
    case 1
        targetlist(0).x=x
        targetlist(0).y=0
    case 2
        targetlist(0).x=x
        targetlist(0).y=sm_y
    case 3
        targetlist(0).x=0
        targetlist(0).y=y
    case 4
        targetlist(0).x=sm_x
        targetlist(0).y=y
    end select
        

    if spacemap(map(piratebase(0)).c.x,map(piratebase(0)).c.y)<>0 then
        p1=map(piratebase(0)).c
        do
            spacemap(p1.x,p1.y)=255
            p1=movepoint(p1,5)
        loop until spacemap(p1.x,p1.y)=0
        
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
    return 0
end function

function make_civilisation(slot as short,m as short) as short
    dim  as _cords p,p1,p2,p3,p4,p5
    dim as short x,y,a,b,row
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
    civ(slot).spec.ldesc=add_a_or_an(civ(slot).n,1) &". " &civ(slot).spec.ldesc
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
    make_aliencolony(slot,m,civ(slot).popu)
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
    
    make_alienship(slot,0)
    make_alienship(slot,1)
    civ(slot).ship(0).st=st_civ1+slot
    civ(slot).ship(1).st=st_civ1+slot
    piratenames(st_civ1+slot)=civ(slot).n &" ship"
    
    civ_adapt_tiles(slot)
    
    for a=0 to 6
        if rnd_range(1,100)<66 then
            civ(slot).culture(a)=rnd_range(1,5+civ(slot).aggr+civ(slot).phil)
            if civ(slot).culture(a)>6 then civ(slot).culture(a)=6
        endif
    next
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
        placeitem(make_item(205,slot),p1.x,p1.y,lastplanet)
        placeitem(make_item(201+slot*2),p1.x,p1.y,lastplanet)
        placeitem(make_item(202+slot*2),p1.x,p1.y,lastplanet)
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
        planetmap(12,8,lastplanet)=-203
        planetmap(48,12,lastplanet)=-203
    endif 
    
    'shop21+slot= alienshop
    shopitem(1,26+slot)=civ(slot).item(0)
    shopitem(2,26+slot)=civ(slot).item(1)
    b=2
    for a=0 to civ(slot).tech*2+civ(slot).inte
       b+=1
       shopitem(b,22+slot)=(rnd_item(RI_ShopAliens))
    next
    
    if slot=0 then 
        spdescr(7)="The homeworld of the "&civ(0).n
    endif
    if slot=1 then 
        spdescr(46)="The homeworld of the "&civ(1).n
    endif
    return 0
end function

function civ_adapt_tiles(slot as short) as short
        
    tiles(272+slot).no=272+slot
    tiles(272+slot).tile=64 
    tiles(272+slot).col=civ(slot).spec.col
    tiles(272+slot).bgcol=0
    tiles(272+slot).desc=add_a_or_an(civ(slot).n,1) &" spaceship."
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
    tiles(274+slot).desc=add_a_or_an(civ(slot).n,1) &" building."
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
    return 0
end function

function make_aliencolony(slot as short,map as short, popu as short) as short
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


function make_alienship(slot as short,t as short) as short
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
    civ(slot).ship(t).sensors=rnd_range(1,civ(slot).tech)
    civ(slot).ship(t).col=civ(slot).spec.col
    civ(slot).ship(t).engine=1
    civ(slot).ship(t).pipilot=3
    civ(slot).ship(t).pigunner=3
    civ(slot).ship(t).ti_no=25+slot
    wc=2
    cc=1
    civ(slot).ship(t).weapons(1)=make_weapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
    for c=0 to civ(slot).ship(t).hull step 5
        if rnd_range(1,100)<75 then
            civ(slot).ship(t).engine+=1
        else
            civ(slot).ship(t).engine-=1
        endif
        if rnd_range(1,100)<50 then
            civ(slot).ship(t).pipilot+=1
        else
            civ(slot).ship(t).pipilot-=1
        endif
        if rnd_range(1,100)<50 then
            civ(slot).ship(t).pigunner+=1
        else
            civ(slot).ship(t).pigunner-=1
        endif
            
        roll=rnd_range(1,100)
        select case roll
        case 0 to chance(1)
            civ(slot).ship(t).weapons(wc)=make_weapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
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
                civ(slot).ship(t).weapons(wc)=make_weapon(rnd_range(1,civ(slot).tech)+civ(slot).prefweap)
                wc+=1
            endif
        end select
        
    
    next
    civ(slot).ship(t).turnrate=1
    if civ(slot).ship(t).engine>3 then civ(slot).ship(t).turnrate+=1
    civ(slot).ship(t).c.x=rnd_range(1,60)
    civ(slot).ship(t).c.y=rnd_range(1,20)
    if civ(slot).ship(t).engine<1 then civ(slot).ship(t).engine=1
    if civ(slot).ship(t).pigunner<1 then civ(slot).ship(t).pigunner=1
    if civ(slot).ship(t).pipilot<1 then civ(slot).ship(t).pipilot=1
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
    civ(0).ship(0).ti_no=35
    civ(0).ship(1).ti_no=35
    civ(1).ship(0).ti_no=36
    civ(1).ship(1).ti_no=36
    return 0
end function
