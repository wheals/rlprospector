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

function makefinalmap(m as short) as short
    dim as _cords p,p2
    dim as short f,x,y,c,l
    planets(m).darkness=5
    planets(m).teleport=1
    f=freefile
    open "data/lstlvl.dat" for binary as #f
    for y=0 to 20
        for x=0 to 60
            get #f,,l
            planetmap(x,y,m)=l
            if planetmap(x,y,m)=-80 and rnd_range(1,100)<20 then planetmap(x,y,m)=-81
            if planetmap(x,y,m)=-54 and rnd_range(1,100)<80 then planetmap(x,y,m)=-55
        next
    next
    close #f
    p2.x=31
    p2.y=2
    do
        p=rnd_point(m,0)
    loop until distance(p,p2)>15
    planetmap(p.x,p.y,m)=-127
    for y=0 to 20
        for x=0 to 60
             if show_all=1 then planetmap(x,y,m)=planetmap(x,y,m)*-1
        next
    next
    planets(m).depth=10
    planets(m).mon_template(0)=makemonster(19,m)
    planets(m).Mon_noamax(0)=28
    planets(m).mon_noamin(0)=22
    planets(m).mon_template(1)=makemonster(56,m)
    planets(m).Mon_noamax(1)=12
    planets(m).mon_noamin(1)=10
    planets(m).mon_template(2)=makemonster(55,m)
    planets(m).Mon_noamax(2)=12
    planets(m).mon_noamin(2)=10
    planets(m).mon_template(3)=makemonster(91,m)
    planets(m).Mon_noamax(3)=12
    planets(m).mon_noamin(3)=10
    planets(m).grav=0.5
    planets(m).atmos=3
    return 0
end function

function makeplatform(slot as short,platforms as short,rooms as short, translate as short, adddoors as short=0) as short
    
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

    return 0
end function

function makecomplex(byref enter as _cords, down as short,blocked as byte=0) as short
    
    dim as short last,wantsize,larga,largb,lno,x,y,mi,slot,old,a,dx,dy,dis,d,b,c,best,startdigging
    dim t as _rect
    dim r(255) as _rect
    dim rfl(255) as short
    dim map2(60,20) as short
    dim sp(255) as _cords
    dim as short roomsize
    dim p as _cords
    dim p1 as _cords
    dim p2 as _cords
    dim  as integer counter,bigc
    dim as short varchance
    slot=enter.m

    if show_all=1 then dprint "Made complex at "&slot
    if planets(slot).depth=0 then planets(slot).depth=1
    planets(slot).darkness=5
    planets(slot).vault(0)=r(0)
    planets(slot).teleport=1
    
    planets(slot).temp=25
    planets(slot).atmos=3    
    planets(slot).grav=.8
    planets(slot).mon_template(0)=makemonster(9,slot)
    planets(slot).mon_noamin(0)=8
    planets(slot).mon_noamax(0)=16+planets(slot).depth
    planets(slot).mon_template(1)=makemonster(90,slot)
    planets(slot).mon_noamin(1)=16
    planets(slot).mon_noamax(1)=26+planets(slot).depth
    if rnd_range(1,100)<15+planets(slot).depth*3 then
        planets(slot).mon_template(2)=makemonster(56,slot)
        planets(slot).mon_noamin(2)=1
        planets(slot).mon_noamax(2)=2+planets(slot).depth
    endif
    if rnd_range(1,100)<25+planets(slot).depth*5 then
        planets(slot).mon_template(3)=makemonster(19,slot)
        planets(slot).mon_noamin(3)=0
        planets(slot).mon_noamax(3)=1+planets(slot).depth
    endif
    if rnd_range(1,100)<15+planets(slot).depth*5 then
        planets(slot).mon_template(4)=makemonster(91,slot)
        planets(slot).mon_noamin(4)=1
        planets(slot).mon_noamax(4)=2+planets(slot).depth
    endif
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
                if rnd_range(1,100)>planets(slot).depth*10 then
                    if rnd_range(1,100)<88 then
                        planetmap(x,y,slot)=-55 'Door
                    else
                        planetmap(x,y,slot)=-54
                    endif
                else
                    planetmap(x,y,slot)=-289 'secretdoor
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
        placeitem(make_item(99),x,y,slot)
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
        lastportal+=1
        lastplanet+=1
        a=lastportal
        portal(a).desig="A shaft. "
        portal(a).tile=111
        portal(a).ti_no=3003
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
    
    for a=0 to planets(slot).depth*5
        do
            p=rnd_point(slot,0)
            if p.x=0 then p.x=1
            if p.x=60 then p.x=59
            if p.y=0 then p.y=1
            if p.y=20 then p.y=19
        loop until (abs(planetmap(p.x,p.y-1,slot))=52 and abs(planetmap(p.x,p.y+1,slot))=52) or (abs(planetmap(p.x-1,p.y,slot))=52 and abs(planetmap(p.x+1,p.y,slot))=52) 
        planetmap(p.x,p.y,slot)=-289
    next
    planetmap(enter.x,enter.y,slot)=-80
    
    varchance=0
    
    if rnd_range(1,100)<planets(slot).depth*2 then
        planets(slot).vault(0)=r(rnd_range(0,last))
        planets(slot).vault(0).wd(5)=1
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-298
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-288
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-288
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-291
        varchance-=5
    endif
    varchance+=5
    
    if rnd_range(1,100)<5+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-293
        varchance-=4
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        for b=0 to rnd_range(1,planets(slot).depth)
            p=rnd_point(slot,0)
            if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-225
        next
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-292
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<25+planets(slot).depth*2+varchance then
        for b=0 to rnd_range(1,planets(slot).depth)
            p=rnd_point(slot,0)
            if abs(planetmap(p.x,p.y,slot))=80 then planetmap(p.x,p.y,slot)=-290
        next
        varchance-=5
    endif
    varchance+=5
    if rnd_range(1,100)<15+planets(slot).depth*2+varchance then
        p=rnd_point(slot,0)
        planetmap(p.x,p.y,slot)=-231
        planets(slot).atmos=1
        planets(slot).grav=1
    endif
    return 0
end function

function makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short) as short

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
    
return 0
end function

function makecomplex3(slot as short,cn as short, rc as short,columns as short,tileset as short) as short

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

return 0
end function

function makecomplex4(slot as short,rn as short,tileset as short) as short
        
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
                if map(x,y)=0 then planetmap(x,y,slot)=-4
                if map(x,y)=1 then planetmap(x,y,slot)=-50
                if map(x,y)=2 then planetmap(x,y,slot)=-156
                if map(x,y)=-2 then planetmap(x,y,slot)=-156
                if map(x,y)=-2 then planetmap(x,y,slot)=-156
            next
        next
    endif
    return 0
end function

function makelabyrinth(slot as short) as short
    
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
    return 0
end function

function makeroots(slot as short) as short
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
    return 0
end function

            
function makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short, blocked as short=1) as short
    dim as short x,y,a,count,loops,b,slot,n,door,c,d,notu,t
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
    planets(slot).vault(0)=r
    
                     
    for a=0 to rnd_range(1,6)+rnd_range(1,6)+gascloud
        p1=rnd_point
        placeitem(make_item(96,-2,-3),p1.x,p1.y,slot)
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
        lastportal+=1
        lastplanet+=1
        
        portal(lastportal).desig="A natural tunnel. "
        portal(lastportal).tile=111
        portal(lastportal).ti_no=3001
        portal(lastportal).col=7
        portal(lastportal).from.s=enter.s
        portal(lastportal).from.m=enter.m
        portal(lastportal).from.x=rnd_range(1,59)
        portal(lastportal).from.y=rnd_range(1,19)
        portal(lastportal).dest.m=lastplanet
        portal(lastportal).dest.s=portal(lastportal).from.s
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        map(portal(lastportal).from.s).discovered=3
        for b=0 to lastportal
            if portal(a).dest.m=portal(b).from.m then
                if portal(a).dest.x=portal(b).from.x and portal(a).from.y=portal(b).from.y then
                    portal(a).from.x=rnd_range(1,59)
                    portal(a).from.y=rnd_range(1,19)
                endif
            endif
        next
        
        planetmap(portal(a).from.x,portal(a).from.y,slot)=-4
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
    
    if (r.h*r.w>15 and rnd_range(1,100)<38) then 'realvault
        if r.h>3 or r.w>3 then 'really really vault
            sp.x=r.x+r.w/2
            sp.y=r.y+r.h/2
            ep.x=30
            ep.y=15
            for a=0 to 20+tumod
                if distance(seedps(a),sp)<distance(ep,sp) then ep=seedps(a)
            next
            make_vault(r,slot,ep,rnd_range(1,6),0,enter)   
        endif
    endif

    
    
    'translate from 0 to 5 to real tiles
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)=15 then 
                planetmap(x,y,slot)=-4
                placeitem(make_item(96,planets(a).depth),x,y,slot)
            endif
            if planetmap(x,y,slot)=0 then planetmap(x,y,slot)=-4
            if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=-(46+planetmap(x,y,slot))
        next
    next
    for a=0 to gascloud+Rnd_range(1,5+planets(slot).depth)+rnd_range(1,5+planets(slot).depth)
        placeitem(make_item(96,planets(a).depth),rnd_range(0,60),rnd_range(0,20),slot)
    next
    
    if rnd_range(1,100)<planets(slot).depth then
        if rnd_range(1,200)<6 then
            do
                p1=rnd_point
            loop until distance(p1,enter)>20
            b=rnd_range(1,3)+rnd_range(0,2)
            for x=p1.x-b to p1.x+b
                for y=p1.y-b to p1.y+b
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=b then 
                            if rnd_range(1,100)<88 then planetmap(x,y,slot)=-13
                            if rnd_range(1,100)<15 then placeitem(make_item(96,-3,-2),x,y,slot)
                        endif
                    endif
                next
            next
        endif
    endif
    
    if rnd_range(1,100)<2*planets(slot).depth or show_portals=1 then
        do
        p1=rnd_point
        loop until distance(p1,enter)>20
        if rnd_range(1,100)<10 then
            b=rnd_range(4,6)
        else
            b=rnd_range(2,5)
        endif
        c=rnd_range(1,100)
        select case rnd_range(1,100)
            
        case 1 to 10
            t=1
        case 10 to 20
            t=13
        case 21 to 30
            t=14
        case 31 to 40
            t=20
        case 41 to 50
            t=26
        case 51 to 60
            t=47
        case 61 to 70
            t=159
        case 71 to 80
            t=12
            if c>50 then c=rnd_range(1,90)
        case 81 to 90
            t=rnd_range(28,30)'Geysers
            if c>50 then c=rnd_range(1,90)
        case else
            t=45
            if c>50 then c=rnd_range(1,90)
        end select
        
        for x=p1.x-b-1 to p1.x+b+1
            for y=p1.y-b-1 to p1.y+b+1
                if x>0 and y>0 and x<60 and y<20 then
                    p2.x=x
                    p2.y=y
                    if distance(p1,p2)<b and rnd_range(1,100)<100-distance(p1,p2)*10 then 
                        planetmap(x,y,slot)=-t
                        if show_portals=1 then planetmap(x,y,slot)=abs(planetmap(x,y,slot))
                        if c<50 or rnd_range(1,100)<10 then placeitem(make_item(96),x,y,slot)
                        if t=1 or t=20 and rnd_range(1,100)<100-distance(p1,p2)*10 then planetmap(x,y,slot)=-t-1'Deep water and deep acid
                    endif
                endif
            next
        next
                
    
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
    
    if rnd_range(1,100)<5 then 'Geyser caves
        for d=0 to rnd_range(1,10)+rnd_range(10,15)
            p1=rnd_point(slot,0)
            if planets(slot).temp>-50 then
                planetmap(p1.x,p1.y,slot)=-28
            else
                planetmap(p1.x,p1.y,slot)=-30
            endif
        next
    endif
    
    if rnd_range(1,100)<planets(slot).depth then
        p1=rnd_point(slot,0)
        planetmap(p1.x,p1.y,slot)=-298
    endif
    
    planetmap(0,0,slot)=-51
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
    return 0
end function

function makeplanetmap(a as short,orbit as short,spect as short) as short
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
    dim as single dawn,dawn2
    Dim areaeffect(16) As _ae
    Dim last_ae As Short
    
    dawn=rnd_range(1,60)
    
    Dim lavapoint(5) As _cords
    
    Dim mapmask(60,20) As Byte
    Dim nightday(60) As Byte
    Dim watermap(60,20) As Byte
    Dim localtemp(60,20) As Single
    Dim cloudmap(60,20) As Byte
    Dim spawnmask(1281) As _cords
    

    dim as short last,wantsize,larga,largb,lno,mi,old,alwaysstranded,debug,lsp
    if a<=0 then 
       dprint "ERROR: Attempting to make planet map at "&a,14
       return 0
    endif
    if _debug>0 then dprint "making planet"
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
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    endif
    
    if planettype>=33 and planettype<44 then
        makeoceanworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
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
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud,prefmin),p.x,p.y,a,0,0)
        next b
    
    endif
    if (planettype>=65 and planettype<80) or spect=8 then 
        makecraters(a,o)'craters
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
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
    if planettype>=80 and planettype<95 then 
        makeislands(a,o)'islands
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            do
               d=d+1
               p=rnd_point
            loop until planetmap(p.x,p.y,a)=-1 or planetmap(p.x,p.y,a)=-2 or d=10
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    
    endif
    if planettype>=95 and o>6 then
        makegeyseroasis(a)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(make_item(96,planets(a).depth+planets(a).minerals,planets(a).depth+planets(a).minerals,prefmin),p.x,p.y,a,0,0)
        next b
    endif
    makeice(a,o)    
    
    planets(a).dens=(planets(a).atmos-1)-6*((planets(a).atmos-1)\6)
    'planets(a).temp=round_nr(spect*83-o*(53+rnd_range(1,20)/10),1)'(8-planets(a).dens)
    planets(a).temp=fix(((Spect*500*(1-planets(a).dens/10))/(16*3.14*5.67*((orbit*75)^2)))^0.25*2500)*(3/orbit)-173.15
    if spect=8 then planets(a).temp=-273
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
        
        if planets(a).depth=0 and rnd_range(1,350)<20-disnbase(player.c) then
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
                if rnd_range(1,100)>33 then placeitem(make_item(96,10,-1),p1.x,p1.y,a,0,0)
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
                            if rnd_range(1,100)<15 then placeitem(make_item(96,-2,-3),x,y,a,0,0)
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
        if planets(a).rot>1 and rnd_range(1,100)>90 then planets(a).rot+=rnd_range(1,10)
        if planets(a).rot>5 and rnd_range(1,100)>90 then planets(a).rot+=rnd_range(1,10)
        if planets(a).rot>10 and rnd_range(1,100)>90 then planets(a).rot+=rnd_range(1,10)
        planets(a).rot=planets(a).rot*planets(a).grav
        'Flowers
        if rnd_range(1,200)<planets(a).atmos+planets(a).life and planets(a).atmos>1 then
            b=rnd_range(0,12)+rnd_range(0,12)+rnd_range(0,12)+1
            for x=1 to b
                p2=rnd_point
                if rnd_range(1,100)<88 then planetmap(p2.x,p2.y,a)=-146
            next
        endif
        
        alwaysstranded=1
        'Stranded ship
        if rnd_range(1,300)<15-disnbase(player.c)/10+planets(a).grav*10 or (alwaysstranded=1 and _debug>0) then
            p1=rnd_point
            b=rnd_range(1,100+player.turn/50000)'!
            c=rnd_range(1,6)
            if c<4 then c=1
            d=0
            if b>50 then d=4
            if b>75 then d=8
            if b>95 then d=12
            add_stranded_ship(d+c,p,a,1)
        endif
        
        'Mining
        if rnd_range(1,200)<15-disnbase(player.c) then
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-76
            for b=0 to rnd_range(1,4)
                if rnd_range(1,100)<25 then placeitem(rnd_item(RI_Mining),p1.x,p1.y,a)
                if rnd_range(1,100)<66 then placeitem(make_item(96,-2,-2),p1.x,p1.y,a,0,0)
            next
            if rnd_range(1,100)<42 then 
                p1=movepoint(p1,5)
                planetmap(p1.x,p1.y,a)=-68
            endif
            if rnd_range(1,100)<25 then
                for b=0 to rnd_range(1,4)
                    do
                        p2=rnd_point
                    loop until distance(p1,p2)<10
                    if rnd_range(1,100)<25 then placeitem(rnd_item(RI_MiningBots),p2.x,p2.y,a)
                next
            endif
        endif
        
        if rnd_range(1,100)<planets(a).grav then
            for b=1 to rnd_range(1,planets(a).grav*2)
                p=rnd_point
                planetmap(p.x,p.y,a)=-245
            next
        endif
        
        
        if rnd_range(1,100)<3 then
            p=rnd_point
            do
                planetmap(p.x,p.y,a)=-193
                p=movepoint(p,5)
            loop until rnd_range(1,100)<77
        endif
        
        if rnd_range(1,200)<3+disnbase(player.c)/10 then 'Abandoned squidsuit
            p=rnd_point
            placeitem(make_item(123),p.x,p.y,a)
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
            it=make_item(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))
            placeitem(it,p1.x,p1.y,a)        
        endif
        

    endif
    
    
    
    modsurface(a,o)
    
    b=0
    for x=0 to 60
        for y=0 to 20
            if tiles(abs(planetmap(x,y,a))).walktru=1  or planetmap(x,y,a)=-1 or planetmap(x,y,a)=-20 or planetmap(x,y,a)=-25 or planetmap(x,y,a)=-27 then b=b+1
        next
    next
    planets(a).water=(b/1200)*100
    
    planets(a).dens=planets(a).atmos
    if planets(a).dens>5 then planets(a).dens-=5
    if planets(a).dens>5 then planets(a).dens-=5
    planets(a).dens-=1
    
    planets(a).mapmod=0.5+planets(a).dens/10+planets(a).grav/5
    
    planets(a).darkness=o-spect*3
    planets(a).darkness+=planets(a).dens
    if planets(a).darkness<0 then planets(a).darkness=0
    if spect=8 or spect=10 then
        makecraters(a,9)
        planets(a).darkness=5
        planets(a).orbit=9
        planets(a).temp=-270+rnd_range(1,10)/10
        planets(a).rot=-1
    endif
    
    for b=0 to planets(a).life
        if debug=99 and _debug=1 then dprint "chance:"&(planets(a).life+1)*3
        if rnd_range(1,100)<(planets(a).life+1)*3 then 
            planets(a).mon_template(b)=makemonster(1,a)
            planets(a).mon_noamin(b)=cint((rnd_range(1,planets(a).life)*planets(a).mon_template(b).diet)/2)
            planets(a).mon_noamax(b)=cint((rnd_range(1,planets(a).life)*2*planets(a).mon_template(b).diet)/2)
            if planets(a).mon_noamin(b)>planets(a).mon_noamax(b) then swap planets(a).mon_noamin(b),planets(a).mon_noamax(b)
        endif
    next
    
    if rnd_range(1,100)<(planets(a).life+1)*3 then
        planets(a).mon_noamin(11)=1
        planets(a).mon_noamax(11)=1
        planets(a).mon_template(11)=makemonster(2,a)
    endif
    
    for b=1 to _NoPB '1 because 0 is mainbase
        if a=piratebase(b) then makeoutpost(a)
    next
    
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-planetmap(x,y,a)
            next
        next
    endif
    
    if _debug>0 then dprint "looking if special"
    make_special_planet(a)
    if is_special(a)=0 or _debug>0 then
        if _debug>0 then dprint "sysfrommap"&sysfrommap(a)
        if sysfrommap(a)>0 then
            if distance(map(sysfrommap(a)).c,civ(0).home)<2*civ(0).tech+2*civ(0).aggr and rnd_range(1,100)<civ(0).aggr*15 then
                make_aliencolony(0,a,rnd_range(2,4))    
                planets(a).mon_template(1)=civ(0).spec
                planets(a).mon_noamin(1)=rnd_range(2,4)
                planets(a).mon_noamax(1)=planets(a).mon_noamin(1)+rnd_range(2,4)
            endif
        endif
    endif    
    for b=0 to planets(a).minerals+planets(a).life
        if specialplanet(15)<>a and planettype<44 and is_gasgiant(a)=0 then placeitem(make_item(96,planets(a).depth+disnbase(player.c)\6+gascloud,planets(a).depth+disnbase(player.c)\7+gascloud),rnd_range(0,60),rnd_range(0,20),a)
    next b
    if add_tile_each_map<>0 then
        p=rnd_point
        planetmap(p.x,p.y,a)=add_tile_each_map
    endif
    if is_gardenworld(a) then planets_flavortext(a)="This place is lovely."
    if planets(a).temp=0 and planets(a).grav=0 then dprint "Made a 0 planet,#"&a,c_red
    awayteam.c.x=-1
    for a=0 to 25
        lsp=ep_updatemasks(watermap(),localtemp(),cloudmap(),spawnmask(),mapmask(),nightday(),dawn,dawn2)
        ep_tileeffects(areaeffect(),last_ae,lavapoint(),nightday(),localtemp(),cloudmap())
    next
    return 0
end function

function modsurface(a as short,o as short) as short
    
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
    return 0
end function


function makecraters(a as short, o as short) as short
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
    return 0
end function

function makeislands(a as short, o as short) as short
    
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
makeice(a,o)
return 0
end function

function makeoceanworld(a as short,o as short) as short
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
    makeice(a,o)
    return 0
end function

function makemossworld(a as short, o as short) as short
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
    return 0
end function

function makecanyons(a as short, o as short) as short
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
    return 0
end function

function makegeyseroasis(slot as short) as short
    ' Makes a planet map covered in ice and mountains with geysers surrounded by greenlands
    dim as short x,y,r,oasis,mountains,i,x1,y1
    dim as short camap(60,20)
    dim as _cords p,p2
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=-14
        next
    next
    mountains=rnd_range(4,10)
    for i=0 to mountains
        p=rnd_point
        do
            p=movepoint(p,5)
            planetmap(p.x,p.y,slot)=-8
        loop until rnd_range(1,100)<10
    next
    oasis=rnd_range(4,10)
    for i=0 to oasis
        p=rnd_point
        r=rnd_range(3,5)
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p2,p)=r then planetmap(x,y,slot)=-12
                if distance(p2,p)<r then
                    planetmap(x,y,slot)=-11
                    if rnd_range(1,100)<20 then
                        if rnd_range(1,100)<60 then
                            if rnd_range(1,100)<60 then
                                planetmap(x,y,slot)=-5
                            else
                                planetmap(x,y,slot)=-146
                            endif
                        else
                            planetmap(x,y,slot)=-6
                        endif
                    endif
                endif
            next
        next
        planetmap(p.x,p.y,slot)=-28
    next
    for x=0 to 60
        for y=0 to 20
            for x1=x-1 to x+1
                for y1=y-1 to y+1
                    if x1>=0 and y1>=0 and x1<=60 and y1<=20 then
                        if planetmap(x1,y1,slot)=-14 then camap(x,y)+=1
                        if planetmap(x1,y1,slot)=-8 then camap(x,y)+=1
                    endif
                next
            next
        next
    next
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)=-14 then
                if rnd_range(1,100)>88 then 
                    planetmap(x,y,slot)=-145
                else
                    if rnd_range(1,100)<camap(x,y) then planetmap(x,y,slot)=-158
                endif
            endif
        next
    next
    
    return 0
end function


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
    placeitem(make_item(99,13),p.x,p.y,a)
    p=rnd_point
    placeitem(make_item(99,16),p.x,p.y,a)
    return 0
end function

function make_special_planet(a as short) as short
    dim as short x,y,b,c,d,b1,b2,b3,cnt,wx,wy,ti,x1,y1
    dim as _cords p,p1,p2,p3,p4,p5
    dim as _cords pa(5)
    dim as _rect r
    dim as _cords gc,gc1
    dim it as _items
    dim addship as _driftingship
    ' UNIQUE PLANETS
    '
    if _debug>0 then dprint "making special"
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
        planets_flavortext(a)="A huge guy in a robe claims to be apollo and demands you to worship him. He seems a little agressive. Also your ship suddenly disappears."        
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
        makecomplex(gc1,1,1)
        
        addportal(gc,gc1,0,asc("#"),"A building still in good condition",15)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-167
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100
        planets(a).atmos=6
        planets(lastplanet).atmos=6
        
        for x=0 to rnd_range(1,6)+rnd_range(1,6)
            p1=rnd_point
            b=rnd_range(1,10)
            add_stranded_ship(b,p1,a,1)
        next
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
            placeitem(rnd_item(RI_StrandedShip),rnd_range(0,60),rnd_range(0,20),a)
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
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        if specialplanet(3)=a then            
            for x=0 to rnd_range(1,5)+20
                planetmap(rnd_range(0,60),rnd_range(0,20),a)=-18
            next    
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-17
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
            add_stranded_ship(18,p,a,1)
            'Unused
        endif
        
    endif
    
    
    if a=specialplanet(5) then 
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
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
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
        placeitem(make_item(15),p1.x,p1.y+2,a,0,0)
        'placeitem(make_item(97),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0,0)
        placeitem(make_item(98),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        placeitem(make_item(99),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        
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
        p.x=7
        p.y=7
        add_stranded_ship(18,p,a,1)
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
    
    if specialplanet(10)=a or a=piratebase(0) then 'Settlement
        
        if _debug>0 then dprint "-1"
        deletemonsters(a)

        planets(a).grav=0.8+rnd_range(1,3)/2
        planets(a).atmos=6
        planets(a).temp=9+rnd_range(1,200)/10
        
        if _debug>0 then dprint "0"
        if rnd_range(1,100)<35 then
            p1=rnd_point
            makemudsshop(a,p1.x,p1.y) 'Mud's Bazar
        endif
        if _debug>0 then dprint "1"
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
        if _debug>0 then dprint "2"
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
        
        if _debug>0 then dprint "3"
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>9999
        
        if a=piratebase(0) then 
            planetmap(x,y,a)=74
        else
            planetmap(x,y,a)=42
        endif
        
        if _debug>0 then dprint "4"
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>20000
        
        planetmap(x,y,a)=43
        p1.x=x
        p1.y=y
        p1.m=a
        add_shop(sh_colonyI,p1,-1)
        
        if _debug>0 then dprint "5"
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y-wy,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>piratebase(0) then planetmap(x,y,a)=270
        
        if _debug>0 then dprint "6"
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>piratebase(0) then 
            planetmap(x,y,a)=89
        else
            planetmap(x,y,a)=164
        endif
        
        
        if _debug>0 then dprint "7"
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until abs(planetmap(x,y,a))<30 or cnt>40000
        
        planetmap(x,y,a)=286
        
        if _debug>0 then dprint "8/"
        if rnd_range(1,100)<50 or a=piratebase(0) then
        do
            cnt=cnt+1
            x=rnd_range(p2.x-wx,p2.x+wx)
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        
        if a<>piratebase(0) then 
            planetmap(x,y,a)=110
        else
            planetmap(x,y,a)=111
        endif
        endif
        
        planets(a).mon_template(0)=makemonster(14,a)
        planets(a).mon_noamin(0)=8
        planets(a).mon_noamax(0)=17
        
        if _debug>0 then dprint "9"
        if specialplanet(10)=a then 'Small spaceport for colony
            p3.x=p2.x+wx
            p3.y=10
            if p3.x+3>60 then p3.x-=3
            for x=p3.x to p3.x+3
                for y=10 to 12
                    planetmap(x,y,a)=68
                next
            next
            
            if (a=specialplanet(10) and rnd_range(1,100)<50) or _debug=2 then 
                p4.x=p3.x
                p4.y=12
                p4.m=a
                planetmap(p3.x,12,a)=-112
                add_shop(sh_used,p4,-1)
                add_shop(sh_usedships,p4,-1)'Need both
            endif
            planetmap(p3.x,10,a)=70
            planetmap(p3.x,11,a)=71
    
        endif
        
        if _debug>0 then dprint "10"
        if a=piratebase(0) then 'add spaceport
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
            if rnd_range(1,100)<50 or _debug=2 then 
                planetmap(c+1,p4.y+3,a)=-112
                p5.x=c+1
                p5.y=p4.y+3
                p5.m=a
                add_shop(sh_used,p5,-1)
                add_shop(sh_usedships,p5,-1)'Need both
            endif
            planetmap(c,p4.y-3,a)=-259
            planetmap(c,p4.y-2,a)=74
            do
                p=rnd_point(a,0)
                if _debug>0 then dprint cords(p)
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
        if not(faction(0).war(2)>=0 and a=piratebase(0)) then        
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
        if rnd_range(1,100)<33 then
            do
                p3=movepoint(p3,5)
            loop until tiles(abs(planetmap(p3.x,p3.y,a))).gives=0
            p3.m=a
            add_shop(sh_giftshop,p3,-1)
        endif
            
    endif
    
    if specialplanet(12)=a then
        planetmap(30,10,a)=296
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
        
        planets(lastplanet).depth=1
        planets(lastplanet).mon_template(2)=makemonster(39,lastplanet)
        planets(lastplanet).mon_noamin(2)=3
        planets(lastplanet).mon_noamax(2)=10
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        if rnd_range(1,100)<10 then
            planets(lastplanet).mon_template(3)=makemonster(104,lastplanet)
            planets(lastplanet).mon_noamin(3)=1
            planets(lastplanet).mon_noamax(3)=5
        endif
        
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
        p4.m=lastplanet
        planetmap(p4.x,p4.y,lastplanet)=-261
        add_shop(sh_sickbay,p4,-1)
        
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        p4.m=lastplanet
        add_shop(sh_mudds,p4,-1)
        do
            p4=rnd_point(lastplanet,0)
        loop until p4.x<p3.x or p4.x>p3.x+7 or p4.y<p3.y or p4.y>p3.y+7
        if p4.x<0 then p4.x=0
        if p4.y<0 then p4.y=0
        if p4.y>20 then p4.y=20
        if p4.x>60 then p4.x=60
        p4.m=lastplanet
        add_shop(sh_sickbay,p4,-1)
                
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
        
        
        
        'planets(lastplanet).mon_template(3)=makemonster(23,lastplanet)
        'planets(lastplanet).mon_noamin(3)=1
        'planets(lastplanet).mon_noamax(3)=3
        
        p2=rnd_point(lastplanet,0)
        p2.m=lastplanet
        lastplanet+=1
        makecomplex3(lastplanet,5,6,0,3)
        if rnd_range(1,100)<10 then
            p2=rnd_point(lastplanet,0)
            p2.m=a
            add_shop(sh_giftshop,p2,-1)
        endif
        planets(lastplanet).depth=1
        planets(lastplanet).mon_template(2)=makemonster(39,lastplanet)
        planets(lastplanet).mon_noamin(2)=3
        planets(lastplanet).mon_noamax(2)=10
        if rnd_range(1,100)<10 then
            planets(lastplanet).mon_template(3)=makemonster(104,lastplanet)
            planets(lastplanet).mon_noamin(3)=1
            planets(lastplanet).mon_noamax(3)=5
        endif
        planets(lastplanet).atmos=4
        planets(lastplanet).temp=20
        
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
    
    endif
    
    if specialplanet(14)=a then 'Black Market
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
        
        
        if rnd_range(1,100)<50 then
            p4.x=p3.x
            p4.y=9
            p4.m=a
            planetmap(p3.x,9,a)=-112
            add_shop(sh_used,p4,-1)
            add_shop(sh_usedships,p4,-1)'Need both
        endif
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
                if x>=0 and y>=0 and x<=60 and y<=20 then
                    planetmap(x,y,a)=-68
                endif
            next
        next
        planetmap(p2.x-1,p2.y,a)=-238
        planetmap(p2.x-1,p2.y+2,a)=-237
        planetmap(p2.x-1,p2.y+4,a)=-259
        planetmap(p3.x,p3.y,a)=-261
        p3.m=a
        add_shop(sh_sickbay,p3,-1)
        planetmap(p4.x,p4.y,a)=-270
        planetmap(p4.x-1,p4.y,a)=-271
        p4.x+=2
        if p4.x>60 then p4.x-=60
        planetmap(p4.x,p4.y,a)=-110
        
        planets(a).mon_template(1)=makemonster(100,a)
        planets(a).mon_noamax(1)=1
        planets(a).mon_noamin(1)=1
        
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
        portal(lastportal).ti_no=3001
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
        
        lastplanet+=1
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
        make_vault(r,gc.m,p1,99,0,portal(lastportal).dest)
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
        portal(lastportal).ti_no=3001
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
        portal(lastportal).ti_no=3001
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
        portal(lastportal).ti_no=3004
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
        portal(lastportal).ti_no=3004
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
        placeitem(make_item(90),p1.x,p1.y,lastplanet+3,0,0) 
        planetmap(p1.x,p1.y,lastplanet+3)=-162
        lastplanet=lastplanet+3
    endif
    
    if specialplanet(17)=a then
        planets(a).water=66
        planets(a).atmos=6
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
        portal(lastportal).ti_no=3001
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
        portal(lastportal).ti_no=3001
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
            placeitem(make_item(96,planets(a).depth+disnbase(player.c)\7,planets(a).depth),p.x,p.y,b,0,0)
        next
        for c=0 to 5
            placeitem(make_item(rnd_range(1,lstcomit)),p.x,p.y,b,0,0)
        next
        placeitem(make_item(89),p.x,p.y,lastplanet)
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
        portal(lastportal).ti_no=3001
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
        portal(lastportal).ti_no=3001
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
        planets(a).mon_noamin(1)=1
        planets(a).mon_noamax(1)=3
        
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
        
        for b=1 to rnd_range(1,10)+10
            placeitem(make_item(99),rnd_range(1,60),rnd_range(0,20),lastplanet)
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
        planets(lastplanet).mon_noamin(0)=3
        planets(lastplanet).mon_noamax(0)=9
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=8
        planets(lastplanet).mon_noamax(1)=12
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        
        for b=1 to rnd_range(1,10)+15
            placeitem(make_item(96),rnd_range(1,60),rnd_range(0,20),lastplanet)
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
                if abs(planetmap(x,y,lastplanet))=185 and rnd_range(1,100)<15 then planetmap(x,y,lastplanet)=-186
                if distance(p3,p4)<6 then planetmap(x,y,lastplanet)=-185
                if abs(planetmap(x,y,lastplanet))=4 then planetmap(x,y,lastplanet)=-185
            next
        next
        planetmap(30,10,lastplanet)=-187
        
        planets(lastplanet).mon_template(0)=makemonster(36,lastplanet)
        planets(lastplanet).mon_noamin(0)=3
        planets(lastplanet).mon_noamax(0)=9
        
        
        planets(lastplanet).mon_template(1)=makemonster(79,lastplanet)
        planets(lastplanet).mon_noamin(1)=10
        planets(lastplanet).mon_noamax(1)=14
        
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
        
        for b=1 to rnd_range(1,25)+10
            placeitem(make_item(96),rnd_range(1,60),rnd_range(0,20),lastplanet)
        next
        
    endif
    
    if a=specialplanet(29)then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-4
            next
        next
        
        deletemonsters(a)
        planets_flavortext(a)="This is truly the most boring piece of rock you have ever laid eyes upon."
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
        portal(lastportal).ti_no=3007
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
                placeitem(make_item(rnd_range(96,99)),x,y,a)
            next
        next
        
        for b=0 to 6
            p1=rnd_point(lastplanet,0)
            p1.m=lastplanet
            lastplanet+=1
            p2=rnd_point(lastplanet,0)
            p2.m=lastplanet
            planets(lastplanet).depth=b+1
            makecomplex(p2,lastplanet,1)
            if b<6 then addportal(p1,p2,0,asc("o"),"A shaft",14)
        next    
        lastplanet+=1
        p2.x=32
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
                placeitem(make_item(96),p.x,p.y,lastplanet)
                p=rnd_point(lastplanet,0)
                if rnd_range(1,100)<b+5 then placeitem(make_item(99),p.x,p.y,lastplanet) 
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
                placeitem(rnd_item(RI_StrandedShip),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(make_item(96,6,-1),p.x,p.y,lastplanet)
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
                placeitem(rnd_item(RI_StrandedShip),p.x,p.y,lastplanet)
                do
                    p=movepoint(p,5)
                loop until tiles(abs(planetmap(p.x,p.y,lastplanet))).walktru=0
            next
            p=rnd_point(lastplanet,0)
            for c=0 to (b+1)*2
                placeitem(make_item(96,6,-1),p.x,p.y,lastplanet)
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
            it=make_item(96,9,9)
            it.v2=6
            it.col=11
            it.desig="transuranic metals"
            it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))            
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
        deletemonsters(a)
        planets(a).temp=16.3
        planets(a).rot=12.3
        planets(a).atmos=5
        planets(a).mon_template(0)=makemonster(42,a)
        planets(a).mon_noamin(0)=10
        planets(a).mon_noamax(0)=25
        p1=rnd_point(a,,2)
        addship.x=p1.x
        addship.y=p1.y
        addship.m=a
        addship.s=18
        planetmap(p1.x,p1.y,a)=-149
        make_drifter(addship,2,1)
        deletemonsters(lastplanet)
        planets(lastplanet).mon_template(0)=makemonster(90,a)
        planets(lastplanet).mon_noamin(0)=0
        planets(lastplanet).mon_noamax(0)=5
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,lastplanet))=82 then planetmap(x,y,lastplanet)=-80 'Delete spawning computers
            next
        next
        for b=0 to rnd_range(1,6)
            p1=rnd_point(lastplanet,,202)
            planetmap(p1.x,p1.y,lastplanet)=-rnd_range(290,293)
        next
        for b=0 to rnd_range(1,6)
            p1=rnd_point(lastplanet,,202)
            placeitem(make_item(99),p1.x,p1.y,lastplanet)
        next
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
        it=make_item(96,9,9)
        it.v2=6
        it.col=3
        it.desig="lutetium"
        it.discovered=1
        it.v5=(it.v1+rnd_range(1,player.science(0)+it.v2))*(it.v2*rnd_range(1,10-player.science(0)))            
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
            portal(lastportal).ti_no=3001
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
        planets(lastplanet).temp=20
        planets(lastplanet).atmos=4
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
        planets(lastplanet).temp=20
        planets(lastplanet).atmos=4
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
        
        planetmap(p1.x,p1.y,a)=-111
                
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
        planets(lastplanet).temp=20
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
        planets(lastplanet).temp=20
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
        planets(lastplanet).temp=20
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
        planets(lastplanet).temp=20
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
        planets(lastplanet).temp=20
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
        planets(lastplanet).temp=20
        planets(lastplanet).grav=1
        planets(lastplanet).atmos=4
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
        planets(lastplanet).temp=20
        planets(lastplanet).grav=1
        planets(lastplanet).atmos=4
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
                planets(lastplanet).vault(0).x=p.x
                planets(lastplanet).vault(0).y=p.y
                planets(lastplanet).vault(0).w=x1
                planets(lastplanet).vault(0).h=y1
                planets(lastplanet).vault(0).wd(5)=3
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
            placeitem(make_item(301),p.x+3,p.y+3,lastplanet,0,0)
        next
        planetmap(p.x+3,p.y+3,lastplanet)=-4
    endif
    
    if (a=specialplanet(21) or a=specialplanet(22) or a=specialplanet(23) or a=specialplanet(24) or a=specialplanet(25)) and is_gasgiant(a)>1 and is_gasgiant(a)<40 then
        deletemonsters(a)
        makeplatform(a,rnd_range(4,8),rnd_range(1,3),1)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(make_item(99),p.x,p.y,a,0,0)
        p=rnd_point(a,0)
        if rnd_range(1,100)<10 then placeitem(make_item(99),p.x,p.y,a,0,0)
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

Function rg_icechunk() As Short
    Dim As Short debug,x,y,b
    Dim gc As _cords
    If rnd_range(1,100)>5+player.sensors Then Return 0
    dprint "Your sensors seem to pick up something"
    If rnd_range(1,100)>5+player.sensors Then
        dprint "But it is gone again quickly."
        Return 0
    EndIf
    lastplanet+=1
    makemossworld(lastplanet,4)
    For x=0 To 60
        For y=0 To 20
            If Abs(planetmap(x,y,lastplanet))=1 Then planetmap(x,y,lastplanet)=-4
            If Abs(planetmap(x,y,lastplanet))=2 Then planetmap(x,y,lastplanet)=-158
            If Abs(planetmap(x,y,lastplanet))=102 Then planetmap(x,y,lastplanet)=-4
            If Abs(planetmap(x,y,lastplanet))=103 Then planetmap(x,y,lastplanet)=-7
            If Abs(planetmap(x,y,lastplanet))=104 Then planetmap(x,y,lastplanet)=-193
            If Abs(planetmap(x,y,lastplanet))=105 Then planetmap(x,y,lastplanet)=-145
            If Abs(planetmap(x,y,lastplanet))=106 Then planetmap(x,y,lastplanet)=-145
            If Abs(planetmap(x,y,lastplanet))=146 Then planetmap(x,y,lastplanet)=-145
            If rnd_range(1,6)+player.science(0)>9 Then planetmap(x,y,lastplanet)=Abs(planetmap(x,y,lastplanet))
        Next
    Next
    planets(lastplanet).grav=.3
    planets(lastplanet).temp=-120
    planets(lastplanet).atmos=1
    planets(lastplanet).death=5+rnd_range(3,6)
    planets(lastplanet).flags(27)=2
    planets(lastplanet).flags(29)=1 'Planet Flag for Ice Chunk
    If rnd_range(1,100)<10 Then
        planets(lastplanet).mon_template(0)=makemonster(rnd_range(62,64),0,0)
        planets(lastplanet).mon_noamin(0)=1
        planets(lastplanet).mon_noamax(0)=3

    EndIf
    For b=0 To 10+rnd_range(0,6)+disnbase(player.c)\4
        gc=rnd_point(lastplanet,1)
        placeitem(make_item(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),gc.x,gc.y,lastplanet)
    Next b
    display_planetmap(lastplanet,30,1)
    dprint "Your sensors pick up a huge chunk of ice in the atmosphere, quickly tumbling down into the denser areas of the gas giant. It is big enough to land on."
    If askyn("Do you want to try to land on it?(y/n)") Then
        landing(lastplanet)
        lastplanet-=1
    Else
        dprint "You climb back up into free space while the icechunk disintegrates"
    EndIf
    Return 0
End Function

function makeice(a as short,o as short) as short
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
    dim as short e,a,u
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
        dprint "error. tried to create portal at dest.y="&dest.y
        dest.y=0
    endif
    if dest.x>60 then
        dprint "error. tried to create portal at dest.x="&dest.x 
        dest.x=60
    endif
    if dest.y>20 then 
        dprint "error. tried to create portal at Dest.y="&dest.y
        dest.y=20
    endif
    
    lastportal=lastportal+1
    if lastportal>ubound(portal) then 
        u=ubound(portal)
        redim preserve portal(u+100)
    endif
    portal(lastportal).from=from
    portal(lastportal).dest=dest
    portal(lastportal).oneway=oneway
    portal(lastportal).tile=tile
    portal(lastportal).col=col
    portal(lastportal).desig=desig
    portal(lastportal).discovered=show_all
    portal(lastportal).ti_no=3001
    if tile=asc("#") and col=14 then portal(lastportal).ti_no=3002
    if tile=asc("o") and col=14 then portal(lastportal).ti_no=3003
    if tile=asc(">") then portal(lastportal).ti_no=3004
    if tile=asc("^") then portal(lastportal).ti_no=250
    if tile=asc("@") then portal(lastportal).ti_no=3008
    if tile=asc("o") and col=7 then portal(lastportal).ti_no=3004
    if tile=asc("O") then portal(lastportal).ti_no=3006
    'dprint chr(tile)&":"&portal(lastportal).ti_no
'    for e=0 to lastportal-1
'        for f=0 to lastportal-1
'            if f<>e then
'                if portal(e).from.x=portal(f).from.x and portal(e).from.y=portal(f).from.y and portal(e).from.m=portal(f).from.m then movepoint(portal(e).from,5)
'                if portal(e).dest.x=portal(f).from.x and portal(e).dest.y=portal(f).from.y and portal(e).dest.m=portal(f).from.m then movepoint(portal(e).from,5)
'                if portal(e).dest.x=portal(f).dest.x and portal(e).dest.y=portal(f).dest.y and portal(e).dest.m=portal(f).dest.m then movepoint(portal(e).from,5)
'            endif
'        next
'    next
    return 0
end function

function deleteportal(f as short=0, d as short=0,x as short=-1,y as short=-1) as short
    dim a as short
    for a=1 to lastportal
        if portal(a).from.m=f or portal(a).from.m=d or portal(a).dest.m=f or portal(a).dest.m=d then
            if (x=-1 and y=-1) or (portal(a).from.x=x and portal(a).from.y=y) then
                portal(a)=portal(lastportal)
                lastportal-=1
            endif
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


function findsmartest(slot as short) as short
    dim as short a,in,m
    for a=0 to 16
        if planets(slot).mon_template(a).intel>m then
            in=a
            m=planets(slot).mon_template(a).intel
        endif
    next
    return in
end function

function make_vault(r as _rect,slot as short,nsp as _cords, typ as short,ind as short,entr as _cords) as short
    dim as short x,y,a,b,c,d,nodo,best,bx,by
    dim p(31) as _cords
    dim wmap(r.w,r.h) as short
    dim as single rad
    p(0).x=r.x+r.w/2
    p(0).y=r.y+r.h/2
    while distance(p(0),entr)<20
        r.x=rnd_range(1,60-r.w)
        r.y=rnd_range(1,20-r.h)
        p(0).x=r.x+r.w/2
        p(0).y=r.y+r.h/2
    wend
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
                if rnd_range(1,100)<11 then placeitem(rnd_item(RI_StrandedShip),x,y,slot)
                if rnd_range(1,100)<21 then placeitem(make_item(96,-3,-3),x,y,slot)
                if rnd_range(1,100)<3 then placeitem(make_item(99),x,y,slot)                
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
                    if rnd_range(1,100)<21 then placeitem(make_item(7),x,y,slot)
                    if rnd_range(1,100)<15 then placeitem(make_item(96,5,5),x,y,slot)
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
    
    planets(slot).vault(ind)=r
    return 0
end function
  
function invisiblelabyrinth(xoff as short ,yoff as short, _x as short=11, _y as short=11) as short
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
    return 0
end function

function makemudsshop(slot as short, x1 as short, y1 as short)  as short
    dim as short x,y,sys,i
    dim as _cords p3
    sys=sysfrommap(slot)
    if sys>0 then
        for i=1 to 9
            if rnd_point(map(sys).planets(i),,262).x>-1 then return -1 'Not more than one mudds shop per system
        next
    endif
        
    if x1<3 then x1=3
    if x1>57 then x1=57
    if y1<3 then y1=3
    if y1>17 then y1=17
    p3.x=x1
    p3.y=y1
    p3.m=slot
    planetmap(x1,y1,slot)=-262
    add_shop(sh_mudds,p3,-1)
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
    return 0
end function

function make_mine(slot as short) as short
    dim as short x,y
    dim as _cords p1,gc1,gc
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
        planets(slot).flags(22)=-1
        planetmap(p1.x,p1.y+2,slot)=-99
    else
        planets(slot).flags(22)=rnd_range(1,6)
        planetmap(p1.x,p1.y+2,slot)=-99
    endif
    gc1.x=p1.x+1
    gc1.y=p1.y+1
    gc1.m=slot
    if _debug>0 then dprint cords(gc1)
    lastplanet=lastplanet+1
    gc.x=rnd_range(1,59)
    gc.y=rnd_range(1,19)
    gc.m=lastplanet
    
    
    makecavemap(gc,8,-1,0,0)
    planets(lastplanet)=planets(slot)
    planets(lastplanet).grav=1.4
    planets(lastplanet).depth=2
'    planets(lastplanet).mon_template(0)=makemonster(1,lastplanet)
'    planets(lastplanet).mon_noamax(0)=rnd_Range(2,12)+6
'    planets(lastplanet).mon_noamin(0)=rnd_Range(2,12)
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,lastplanet)=-4 and rnd_range(0,100)<66 then planetmap(x,y,lastplanet)=-47
        next
    next
    gc=rnd_point(lastplanet,0)
    gc.m=lastplanet
    addportal(gc1,gc,0,ASC("#"),"A mineshaft.",14)
    if _debug>0 then 
        dprint "slot:" &gc1.m
        dprint "slot:" &gc.m
    endif
    return 0
end function

function makeoutpost (slot as short,x1 as short=0, y1 as short=0) as short
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
    return 0
end function

function adaptmap(slot as short) as short
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
                            if rnd_range(1,100)<ti-66 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
                            if rnd_range(1,100)<ti-66 and ti>=93 then placeitem(make_item(94),p.x,p.y,slot,0,0)
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
    
    if houses(0)=0 and houses(1)=0 and houses(2)=0 and rnd_range(1,100)<55 and is_gardenworld(slot)<>0 then makesettlement(rnd_point,slot,rnd_range(0,4))
       
       
    if (rnd_range(1,100)<pyr+7 and pyr>0) or addpyramids=1 then         
        if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
        if rnd_range(1,100)<pyr+5 or addpyramids=1 then 
            if rnd_range(1,100)<33 then
                planetmap(p.x,p.y,slot)=-150
                addpyramid(p,slot)
            else
                planetmap(p.x,p.y,slot)=-4
                addcastle(p,slot)
            endif
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
    
    return 0
end function

function addpyramid(p as _cords, slot as short) as short
    dim as _cords from,dest
    dim as short i,vt
    dim as _rect r
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
                if i<6 then placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
                if i>6 then placeitem(make_item(94),p.x,p.y,lastplanet)
            next                 
            for i=0 to rnd_range(1,6)+rnd_range(1,6)
                p=rnd_point(lastplanet,0)
                placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
            next
            
            if rnd_range(1,100)<5 then
                p=rnd_point(lastplanet,0)
                planetmap(p.x,p.y,lastplanet)=225
                placeitem(make_item(97),p.x,p.y,lastplanet)
                placeitem(make_item(98),p.x,p.y,lastplanet)
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
                                placeitem(make_item(96,-2,-3),x,y,lastplanet)
                                placeitem(make_item(96,-2,-3),x,y,lastplanet)
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
                        placeitem(make_item(96,-2,-3),p.x,p.y,lastplanet)
                        p.x=rnd_range(r.x+1,r.x+r.w-2)
                        p.y=rnd_range(r.y+1,r.y+r.h-2)
                        placeitem(make_item(94),p.x,p.y,lastplanet)
                    next
                endif
                if vt=3 or vt=5 then
                    planets(lastplanet).vault(0)=r
                    planets(lastplanet).vault(0).wd(5)=2
                    planets(lastplanet).vault(0).wd(6)=rnd_range(66,68)
                endif
                if vt=4 then
                    planets(lastplanet).vault(0)=r
                    planets(lastplanet).vault(0).wd(5)=2
                    planets(lastplanet).vault(0).wd(6)=rnd_range(16,18)
                endif
                if vt=6 then
                    planets(lastplanet).vault(0)=r
                    planets(lastplanet).vault(0).wd(5)=2
                    planets(lastplanet).vault(0).wd(6)=rnd_range(16,18)
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
            
    return 0
end function

function addcastle(from as _cords,slot as short) as short
    
    dim map(60,20) as short
    dim r(1) as _rect
    dim vaults(6) as _rect
    dim as short x,y,a,b,c,c2,x2,xm,ym,x1,y1,sppc(1200),last,lasttrap
    dim  as _cords p,p2,dest,spp(1200),traps(1200)
    xm=0
    ym=0
    for b=0 to 1+rnd_range(0,10)
    
        r(1).x=rnd_range(2,35+xm)
        r(1).y=rnd_range(2,8+ym)
        r(1).w=rnd_range(8,20-xm)
        r(1).h=rnd_range(5,10-ym)
        if xm<6 and b mod 2=0 then xm+=1
        if ym<4 and b mod 2=0 then ym+=1
        if map(r(1).x-1,r(1).y-1)=1 and map(r(1).x-1,r(1).y+r(1).h+1)=1 and map(r(1).x+r(1).w+1,r(1).y-1)=1 and map(r(1).x+r(1).w+1,r(1).y+r(1).h+1)=1 then
            for x=r(1).x to r(1).x+r(1).w
                for y=r(1).y to r(1).y+r(1).h
                    map(x,y)=0
                next
            next
        else
            for x=r(1).x to r(1).x+r(1).w
                for y=r(1).y to r(1).y+r(1).h
                    map(x,y)=1
                next
            next
        endif
    next
    
    if rnd_range(1,100)<20 then
        c=4
        x2=rnd_range(15,45)
        for y=1 to 19
            map(x2,y)=1
        next
        for x=x2-2 to x2+2
            for y=0 to 3
                map(x,y)=1
            next
            for y=17 to 20
                map(x,y)=1
            next
        next
    endif
    a=rnd_range(1,100)        
    if rnd_range(1,100)<10 or a<60 then
        c=rnd_range(3,6)
        for x=0 to c
            for y=0 to c
                map(x,y)=1
            next
        next
        vaults(0).x=0
        vaults(0).y=0
        vaults(0).h=c
        vaults(0).w=c
        vaults(0).wd(5)=4
        vaults(0).wd(6)=-1
    endif
    if rnd_range(1,100)<30 or a<60 then
        c=rnd_range(3,6)
        for x=0 to c
            for y=20-c to 20
                map(x,y)=1
            next
        next
        vaults(1).x=0
        vaults(1).y=20-c
        vaults(1).h=c
        vaults(1).w=c
        vaults(1).wd(5)=4
        vaults(1).wd(6)=-1
    endif
    if rnd_range(1,100)<40 or a<60 then
        c=rnd_range(3,6)
        for x=60-c to 60
            for y=20-c to 20
                map(x,y)=1
            next
        next
        
        vaults(2).x=60-c
        vaults(2).y=20-c
        vaults(2).h=c
        vaults(2).w=c
        vaults(2).wd(5)=4
        vaults(2).wd(6)=-1
    endif
    if rnd_range(1,100)<50 or a<60 then
        c=rnd_range(3,6)
        for x=60-c to 60
            for y=0 to c
                map(x,y)=1
            next
        next
        vaults(3).x=60-c
        vaults(3).y=0
        vaults(3).h=c
        vaults(3).w=c
        vaults(3).wd(5)=4
        vaults(3).wd(6)=-1
    endif
    
'    screenset 1,1
'    for x=0 to 60
'        for y=0 to 20
'            locate y+1,x+1
'            if map(x,y)=1 then print "#";
'            if map(x,y)=0 then print " ";
'            if map(x,y)=7 then print "=";
'        next
'    next
'    sleep
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=1 then
                if map(x-1,y)=0 or map(x+1,y)=0 or map(x,y+1)=0 or map(x,y-1)=0 or map(x-1,y-1)=0 or map(x-1,y+1)=0 or map(x+1,y+1)=0 or map(x+1,y-1)=0 then
                    map(x,y)=1
                else
                    map(x,y)=2
                endif
            endif
        next
    next
'
'    if rnd_range(1,100)<33+addpyramids*100 then
'        for x=1 to 59
'            for y=1 to 19
'                if (x=1 or y=1 or x=59 or y=19) and map(x,y)=0 then map(x,y)=7
'            next
'        next
'    endif
'
    for a=0 to rnd_range(5,13)
        
        do
            p.x=rnd_range(2,58)
            p.y=rnd_range(2,18)
            b+=1
        loop until b>5000 or map(p.x,p.y)=2 and map(p.x,p.y-1)=2 and map(p.x,p.y+1)=2 and map(p.x-1,p.y)=2 and map(p.x+1,p.y)=2
        if b<5000 then
            p2=p
            select case rnd_range(1,2)
            case is<2
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.x-=1
                    if p.x=0 or p.x=60 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x+1,p.y-1)=1 or map(p.x+1,p.y+1)=1
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.x+=1
                    if p.x=0 or p.x=60 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y-1)=1 or map(p.x-1,p.y+1)=1            
            case else
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.y-=1
                    if p.y=0 or p.y=20 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y+1)=1 or map(p.x+1,p.y+1)=1
                p=p2
                do    
                    map(p.x,p.y)=1
                    p.y+=1
                    if p.y=0 or p.y=20 then map(p.x,p.y)=1
                loop until map(p.x,p.y)=1 or map(p.x-1,p.y-1)=1 or map(p.x+1,p.y-1)=1
            end select
        endif
    next

    for x=1 to 59
        for y=1 to 19
            if map(x,y)=2 and map(x+1,y)=1 and map(x,y+1)=1 and map(x+1,y+1)=2 then map(x,y)=1
            if map(x,y)=1 and map(x+1,y)=2 and map(x,y+1)=2 and map(x+1,y+1)=1 then map(x,y)=2
        next
    next
    for a=0 to 3
        do
            p.x=rnd_range(1,59)
            p.y=rnd_range(1,19)
        loop until map(p.x,p.y)=1 and ((map(p.x-1,p.y)=0 and map(p.x+1,p.y)=2) or (map(p.x+1,p.y)=0 and map(p.x-1,p.y)=2) or (map(p.x,p.y-1)=0 and map(p.x,p.y+1)=2) or (map(p.x,p.y+1)=0 and map(p.x,p.y-1)=2)) 
        map(p.x,p.y)=3
    next
    b=0
    p2.x=1
    p2.y=1
    do
        
        floodfill4(map(),p2.x,p2.y)
        a=0
        for x=0 to 60
            for y=0 to 20
                if map(x,y)=2 or map(x,y)=0 then a+=1
            next
        next
        
        if a>0 then
            add_door(map())
        endif
        
        for x=1 to 59
            for y=1 to 19
                if map(x,y)>5 then map(x,y)=map(x,y)-10
            next
        next
            
            
    loop until a=0

    remove_doors(map())


    for x=0 to 60
        for y=0 to 20
            if x=0 or y=0 or x=60 or y=20 then map(x,y)=1
        next
    next
    
    for a=0 to rnd_range(14,24)
        add_door2(map())
    next
    
    'Find spawn points+chance
    last=0
    
    vaults(4)=findrect(2,map(),0,40)
    if addpyramids=1 then dprint "Vault 4 at "&vaults(4).x &":"& vaults(4).y
    
    if rnd_range(1,100)<33+addpyramids*100 then
        if rnd_range(1,100)<33 then
            vaults(3).wd(5)=4
            vaults(3).wd(6)=-1
        else
            if rnd_range(1,100)< 50 then
                for x=vaults(4).x to vaults(4).x+vaults(4).w
                    for y=vaults(4).y to vaults(4).y+vaults(4).h
                        placeitem(make_item(94,2,3),x,y,lastplanet)
                    next
                next
            else
                for x=vaults(4).x to vaults(4).x+vaults(4).w
                    for y=vaults(4).y to vaults(4).y+vaults(4).h
                        placeitem(make_item(96,2,3),x,y,lastplanet)
                    next
                next
            endif
        endif
    endif    
    
    vaults(5)=findrect(0,map(),0,60)
    if addpyramids=1 then dprint "garden at "&vaults(5).w &":"& vaults(5).h
    
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=2 then
                c=0
                c2=0
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if map(x1,y1)=1 then c+=1
                        if map(x1,y1)=3 then c2+=1
                    next
                next
                last+=1
                if c2=1 and c=7 then
                    sppc(last)=100
                else
                    if map(x-1,y)=2 and map(x+1,y)=2 then c=c-20
                    if map(x,y-1)=2 and map(x,y+1)=2 then c=c-20
                    if c2=0 then sppc(last)=c*10
                endif
                spp(last).x=x
                spp(last).y=y
                if c=6 then
                    lasttrap+=1
                    traps(lasttrap).x=x
                    traps(lasttrap).y=y
                endif
            endif
        next
    next
    
    'Translate to real map
    lastplanet+=1
    for a=0 to 25
        b=rnd_range(3,9)
        p=rnd_point
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if distance(p2,p)<b then 
                    planetmap(x,y,lastplanet)+=1
                    if planetmap(x,y,lastplanet)>5 then planetmap(x,y,lastplanet)=0
                endif
            next
        next
    next
    sleep
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,lastplanet)<2 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-10
            if planetmap(x,y,lastplanet)=2 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-6
            if planetmap(x,y,lastplanet)=3 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-5
            if planetmap(x,y,lastplanet)=4 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-12
            if planetmap(x,y,lastplanet)>4 and planetmap(x,y,lastplanet)>=0 then planetmap(x,y,lastplanet)=-3
        next
    next
    
    if rnd_range(1,100)<33+addpyramids*100 then
        for x=vaults(5).x+1 to vaults(5).x+vaults(5).w-2
            for y=vaults(5).y+1 to vaults(5).y+vaults(5).h-2
                planetmap(x,y,lastplanet)=-96
            next
        next
    endif
    
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=1 then planetmap(x,y,lastplanet)=-51
            if map(x,y)=2 then planetmap(x,y,lastplanet)=-4
            if map(x,y)=3 then 
                if rnd_range(1,100)<33 then
                    planetmap(x,y,lastplanet)=-151
                else
                    if rnd_range(1,100)<50 then
                        planetmap(x,y,lastplanet)=-156
                    else
                        planetmap(x,y,lastplanet)=-157
                    endif
                endif
            endif
            if map(x,y)=7 then planetmap(x,y,lastplanet)=-2
        next
    next
    
    'Add stuff & features
    for a=0 to rnd_range(1,10)+rnd_range(1,10)
        b=find_high(sppc(),last)
        if b>0 then
            for c=0 to rnd_range(1,3)
                if rnd_range(1,100)<10 then
                    planetmap(spp(b).x,spp(b).y,lastplanet)=-154
                else
                    if rnd_range(1,100)<50 then
                        placeitem(make_item(96,2,3),spp(b).x,spp(b).y,lastplanet)
                    else
                        placeitem(make_item(94,2,3),spp(b).x,spp(b).y,lastplanet)
                    endif
                endif
            next
            spp(b)=spp(last)
            sppc(b)=sppc(last)
            last-=1
        endif
    next
    
    for a=0 to rnd_range(0,5)+rnd_range(0,5)
        b=rnd_range(1,lasttrap)
        if b>0 and lasttrap>1 then
            planetmap(traps(b).x,traps(b).y,lastplanet)=-154
            traps(b)=traps(lasttrap)
            lasttrap-=1
        endif
    next
    
    planets(lastplanet)=planets(slot)
    modsurface(lastplanet,5)
    a=findsmartest(lastplanet)
    deletemonsters(lastplanet)
    planets(lastplanet).mon_template(0)=planets(slot).mon_template(a)
    planets(lastplanet).mon_noamin(0)=15
    planets(lastplanet).mon_noamax(0)=25
    planets(lastplanet).mon_template(0).faction=7
    planets(lastplanet).mon_template(1)=planets(slot).mon_template(a)
    planets(lastplanet).mon_noamin(1)=5
    planets(lastplanet).mon_noamax(1)=15
    planets(lastplanet).mon_template(1).hpmax+=rnd_range(5,15)
    planets(lastplanet).mon_template(1).hp=planets(lastplanet).mon_template(0).hpmax
    planets(lastplanet).mon_template(1).sdesc=planets(lastplanet).mon_template(1).sdesc &" guard"
    planets(lastplanet).mon_template(1).weapon+=2
    planets(lastplanet).mon_template(1).armor+=2
    planets(lastplanet).mon_template(1).faction=7
    planets(lastplanet).depth=1
    planets(lastplanet).mapmod=0
    planets(lastplanet).grav=.5
    planets(lastplanet).weat=0
    planets(lastplanet).vault(0)=vaults(0)
    planets(lastplanet).vault(1)=vaults(1)
    planets(lastplanet).vault(2)=vaults(2)
    planets(lastplanet).vault(3)=vaults(3)
    if planets(lastplanet).temp>300 then planets(lastplanet).temp=300
    dest.x=30
    dest.y=0
    dest.m=lastplanet
    if planetmap(30,1,lastplanet)=-51 then dest.x+=1
    planetmap(dest.x,0,lastplanet)=-4
    from.m=slot
    addportal(from,dest,1,asc("O"),"A Fortress.",15)
    addportal(dest,from,1,asc("o"),"The front gate.",7)
    if addpyramids=1 then dprint "Fortress at "&from.x &":"&from.y &":"&from.m
    return 0
end function

function remove_doors(map() as short) as short
    dim as short x,y,last,a,c
    dim as _cords ps(1200)
    for x=0 to 60
        for y=0 to 20
            if map(x,y)=3 then
                last+=1
                ps(last).x=x
                ps(last).y=y
            endif
        next
    next
    if last>0 then
        for a=1 to last
            c=0
            map(ps(a).x,ps(a).y)=1
            floodfill4(map(),1,1)
            for x=0 to 60
                for y=0 to 20
                    if map(x,y)=2 or map(x,y)=0 then c+=1
                    if map(x,y)>9 then map(x,y)=map(x,y)-10
                next
            next
            if c>0 then map(ps(a).x,ps(a).y)=3
        next
    endif
    return 0
end function

function floodfill4(map() as short,x as short,y as short) as short
    if x<0 or y<0 or x>60 or y>20 then return 0
    if map(x,y)<>1 and map(x,y)<5 then
        map(x,y)=map(x,y)+10
    else
        return 0
    endif
    floodfill4(map(),x+1,y)
    floodfill4(map(),x-1,y)
    floodfill4(map(),x,y+1)
    floodfill4(map(),x,y-1)
end function

function add_door2(map() as short) as short
    dim ps(1200) as _cords
    dim pc(1200) as short
    dim as short last,x,y,a,c
    dim as _cords p
    for x=1 to 59
        for y=1 to 19
            if map(x,y)=1 or map(x,y)=2 then
                if map(x-1,y)=2 and map(x+1,y)=2 then
                    if map(x,y+1)=1 and map(x,y-1)=1 then
                        last+=1
                        ps(last).x=x
                        ps(last).y=y
                    endif
                endif
                if map(x,y-1)=2 and map(x,y+1)=2 then
                    if map(x-1,y)=1 and map(x+1,y)=1 then
                        last+=1
                        ps(last).x=x
                        ps(last).y=y
                    endif
                endif
            endif
        next
    next
    for a=1 to last
        pc(a)=20
        x=ps(a).x
        y=ps(a).y
        c=0
        if map(x-1,y-1)=1 then c+=1
        if map(x+1,y-1)=1 then c+=1
        if map(x-1,y+1)=1 then c+=1
        if map(x+1,y+1)=1 then c+=1
        if c=1 then pc(a)+=10
        if c=2 then pc(a)+=30
        if c=3 then pc(a)+=20
        if c=4 then pc(a)-=10
    next
    c=rnd_range(1,last)
    if rnd_range(1,100)<pc(c) then map(ps(c).x,ps(c).y)=3
    return 0
end function

function add_door(map() as short) as short
    dim ps(1200) as _cords
    dim as short last,x,y
    dim as _cords p
    for x=1 to 59
        for y=1 to 19
            p.x=x
            p.y=y
            if map(p.x,p.y)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 then
                if (map(p.x,p.y-1)=2 and map(p.x,p.y+1)>9) or (map(p.x,p.y-1)>9 and map(p.x,p.y+1)=2) then  
                    last+=1
                    ps(last)=p
                endif
            endif
            if map(p.x,p.y)=1 and map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 then
                if (map(p.x-1,p.y)=2 and map(p.x+1,p.y)>9) or (map(p.x-1,p.y)>9 and map(p.x+1,p.y)=2) then
                    last+=1
                    ps(last)=p
                endif
            endif
        next
    next
    if last>0 then
        p=ps(rnd_range(1,last))
        map(p.x,p.y)=3
    else
        for x=1 to 59
            for y=1 to 19
                p.x=x
                p.y=y
                if map(p.x,p.y)=1 and map(p.x-1,p.y)=1 and map(p.x+1,p.y)=1 then
                    if map(p.x,p.y-1)<>1 and map(p.x,p.y+1)<>1 then  
                        last+=1
                        ps(last)=p
                    endif
                endif
                if map(p.x,p.y)=1 and map(p.x,p.y-1)=1 and map(p.x,p.y+1)=1 then
                    if (map(p.x-1,p.y)<>1 and map(p.x+1,p.y)<>1) then
                        last+=1
                        ps(last)=p
                    endif
                endif
            next
        next
        if last>0 then
            p=ps(rnd_range(1,last))
            map(p.x,p.y)=3
        endif    
    endif
    return 0
end function


function togglingfilter(slot as short, high as short=1, low as short=2) as short     
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
return 0
end function


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
  if flag=3 then
      if x>=0 and y>=0 and x<=60 and y<=20 then
          if map(x,y)=0 then
              map(x,y)=255
          else
              return 0
          endif
          Flood_Fill(x+1,y,map(),3)
          Flood_Fill(x-1,y,map(),3)
          Flood_Fill(x,y+1,map(),3)
          Flood_Fill(x,y-1,map(),3)
          Flood_Fill(x+1,y+1,map(),3)
          Flood_Fill(x-1,y-1,map(),3)
          Flood_Fill(x-1,y+1,map(),3)
          Flood_Fill(x+1,y-1,map(),3)
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


function countasteroidfields(sys as short) as short
    dim as short a,b
    if sys<0 then return 0
    for a=1 to 9
        if map(sys).planets(a)<0 and is_gasgiant(map(sys).planets(a))=0 then b=b+1
    next
    return b
end function


function countgasgiants(sys as short) as short
    dim as short a,b
    if sys<0 then return 0
    for a=1 to 9
        if is_gasgiant(map(sys).planets(a))>0 then b=b+1
    next
    return b
end function

function checkcomplex(map as short,fl as short) as integer
    dim result as integer
    dim maps(36) as short
    dim flags(lastplanet) as byte
    dim as short nextmap,lastmap,foundport,a,b,done
    maps(0)=map
    do
    ' Suche portal auf maps(lastmap)
        lastmap=nextmap
        nextmap+=1
        for a=1 to lastportal
            if portal(a).from.m=maps(lastmap) and flags(portal(a).dest.m)=0 then 
                maps(nextmap)=portal(a).dest.m
                flags(portal(a).dest.m)=1
            endif
        next
    loop until maps(nextmap)=0 or nextmap>35
    
    for a=1 to lastmap
        if maps(a)>0 and planets(maps(a)).genozide=0 then result+=1
    next
    return result
end function

function is_drifter(m as short) as short
    dim a as short
    for a=1 to lastdrifting
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

function is_gardenworld(m as short) as short
    if m<0 then return 0
    if planets(m).grav>1.1 then return 0
    if planets(m).atmos<3 or planets(m).atmos>5 then return 0
    if planets(m).temp<-20 or planets(m).temp>55 then return 0
    if planets(m).weat>1 then return 0
    if planets(m).water<30 then return 0
    if planets(m).rot<0.5 or planets(m).rot>1.5 then return 0
    return -1
end function

function is_gasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    if m=specialplanet(43) then return 43
    return 0
end function

function is_asteroidfield(m as short) as short
    if m>=-20000 and m<0 then return 1
    if m=specialplanet(31) then return 1 
    if m=specialplanet(32) then return 1 
    if m=specialplanet(33) then return 1
    if m=specialplanet(41) then return 1
    return 0
end function

function get_nonspecialplanet(disc as short=0) as short
    dim pot(1024) as short
    dim as short a,b,last
    for a=0 to laststar
        if map(a).discovered=0 or disc=0 then
            for b=1 to 9
                if map(a).planets(b)>0 and is_special(map(a).planets(b))=0 then
                    if planetmap(0,0,map(a).planets(b))=0 then
                        last+=1
                        pot(last)=map(a).planets(b)
                    endif
                endif
            next
        endif
    next
    if last>0 then
        return pot(rnd_range(1,last))
    else 
        return 0
    end if
end function


function sysfrommap(a as short)as short
    ' returns the systems number of a planet
    dim as short b,c,d
    for b=0 to laststar
        for c=1 to 9
            if map(b).planets(c)=a then return b
        next
    next
    return -1
end function

function orbitfrommap(a as short) as short
    dim as short orbit,sys,b
    sys=sysfrommap(a)
    if sys>=0 then
        for b=1 to 9
            if map(sys).planets(b)=a then return b
        next
    endif
    return -1
end function


function get_random_system(unique as short=0,gascloud as short=0,disweight as short=0,hasgarden as short=0) as short 'Returns a random system. If unique=1 then specialplanets are possible
    dim as short a,b,c,p,u,ad,debug,cc,f
    dim pot(laststar*100) as short
    'debug=1
    
    if debug=1 and _debug=1 then
        f=freefile
        open "getrandsystem.csv" for append as #f
    endif
    
    for a=0 to laststar
        if map(a).discovered=0 and map(a).spec<8 then
            ad=0
            if unique=0 then
                for p=1 to 9
                    for u=0 to lastspecial
                        if map(a).planets(p)=specialplanet(u) then ad=1
                    next
                next
            endif
            if hasgarden=1 then
                ad=1
                for p=1 to 9
                    if is_gardenworld(map(a).planets(p)) then ad=0
                next
            endif
            if spacemap(map(a).c.x,map(a).c.y)<>0 then cc+=1
            if gascloud=1 and (spacemap(map(a).c.x,map(a).c.y)=0 or abs(spacemap(map(a).c.x,map(a).c.y))>6) then ad=1
            if gascloud=2 and abs(spacemap(map(a).c.x,map(a).c.y))<2 then ad=0
            if ad=0 then
                if disweight=1 then 'Weigh for distance
                    cc=1+disnbase(map(a).c)*disnbase(map(a).c)/10
                else
                    cc=1
                endif
                if debug=1 and _debug=1 then print #f,a &";"& cc &";"& disnbase(map(a).c)
                for p=1 to cc
                    if b<laststar*100 then
                        b=b+1
                        pot(b)=a
                    endif
                    'print "B";b;":";
                next
            endif
        endif
    next
    if debug=1 and _debug=1 then
        print #f,"+++++"
        close #f
    endif
        
    if b>0 then 
        c=pot(rnd_range(1,b))
    else 
        c=-1
    endif
    return c
end function 


function getrandomplanet(s as short) as short
    dim pot(10) as short
    dim as short a,b,c
    if s>=0 and s<=laststar then
        for a=1 to 9
            if map(s).planets(a)>0 then
                b=b+1
                pot(b)=map(s).planets(a)
                
            endif
        next
        if b<=0 then 
            c=-1
        else 
            c=pot(rnd_range(1,b))
        endif
    else
        c=-1
    endif
    return c
end function

function get_system() as short  'returns the number of the system the player is in
    dim a as short
    dim b as short
    b=-1
    for a=0 to laststar
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then b=a
    next
    return b
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
