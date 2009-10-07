

sub makeclouds()
    dim map(sm_x,sm_y)as ubyte
    dim as short x,y,bx,by,highest,count,a,total,xoff,yoff,r
    
    dim as cords p1,p2,p3,p4
    
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
                if distance(p1,p2)<bx then map(x,y)=map(x,y)+rnd_range(1,6)
                if map(x,y)>highest then highest=map(x,y)
                if map(x,y)>=8 then count+=1
            next
        next
    loop until count>=sm_x*sm_y*0.20
    for x=0 to sm_x
        for y=0 to sm_y
            if map(x,y)=8 or map(x,y)=9  then spacemap(x,y)=-2                    
            if map(x,y)=10 or map(x,y)=11  then spacemap(x,y)=-3                    
            if map(x,y)=12 or map(x,y)=13  then spacemap(x,y)=-4                    
            if map(x,y)>13 then spacemap(x,y)=-5                    
            if abs(spacemap(x,y))>2 then count+=1
        next
    next

    if show_all=1 then
        for x=0 to sm_x
            for y=0 to sm_y
                if spacemap(x,y)=0  then spacemap(x,y)=1                    
                if spacemap(x,y)=-2  then spacemap(x,y)=2                    
                if spacemap(x,y)=-3  then spacemap(x,y)=3                    
                if spacemap(x,y)=-4  then spacemap(x,y)=4                    
                if spacemap(x,y)=-5  then spacemap(x,y)=5 
            next
        next    
    endif
    'print highest;lowest
    'sleep
end sub


sub makefinalmap(m as short)
    
    dim as short f,x,y,c
    planets(m).darkness=5
    planets(m).teleport=1
    f=freefile
    open "lstlvl.dat" for binary as #f
    for y=0 to 20
        for x=0 to 60
            get #f,,planetmap(x,y,m)
            if planetmap(x,y,m)=-80 and rnd_range(1,100)<20 then planetmap(x,y,m)=-81
            if planetmap(x,y,m)=-54 and rnd_range(1,100)<80 then planetmap(x,y,m)=-55
            
        next
     next
     do
     for y=0 to 20
             for x=0 to 60
                 if planetmap(x,y,m)=-82 then
                     if rnd_range(1,100)>22 and c=0 then 
                        planetmap(x,y,m)=-127
                        c=1
                    endif
                endif
            next
        next
     loop until c=1
     close #f
     for y=0 to 20
        for x=0 to 60
             if show_all=1 then planetmap(x,y,m)=planetmap(x,y,m)*-1
        next
    next
    
     planets(m).mon=19
     planets(m).noamax=13
     planets(m).noamin=8
     planets(m).grav=0.5
     planets(m).atmos=3
end sub

sub makeplatform(slot as short,platforms as short,rooms as short, translate as short, adddoors as short=0)
    
dim map(60,20) as short
dim as short x,y,a,w,h,c,d,b,n,flag,door
dim as cords p(platforms)
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
    do
        p(0).x=rnd_range(1,49)
        p(0).y=rnd_range(1,14)
        p(1).x=p(0).x+rnd_range(3,10)
        p(1).y=p(0).y+rnd_range(3,5)
        flag=0
        for x=p(0).x-1 to p(1).x+1
            for y=p(0).y-1 to p(1).y+1
                if map(x,y)=3 then flag=1
                if (x=p(0).x-1 or x=p(0).x+1 or y=p(0).y-1 or y=p(0).y+1) and map(x,y)=4 then flag=1 
            next
        next
    loop until flag=0
    flag=0
    
    
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
                    if (map(x-1,y)<4 and map(x+1,y)<4 and map(x-1,y)>0 and map(x+1,y)>0 and map(x,y-1)=4 and map(x,y+1)=4) then
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
                    if (map(x,y-1)<4 and map(x,y+1)<4 and map(x,y-1)>0 and map(x,y+1)>0 and map(x-1,y)=4 and map(x+1,y)=4) then
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
    next
next

if show_all=1 then
    for x=0 to 60
        for y=0 to 20
            planetmap(x,y,slot)=-planetmap(x,y,slot)
        next
    next
endif

end sub


sub makecomplex(byref enter as gamecords, down as short)
    
    dim as short last,wantsize,larga,largb,lno,x,y,mi,slot,old,a,dx,dy,dis,d,b,c,best,startdigging
    dim t as _rect
    dim r(255) as _rect
    dim rfl(255) as short
    dim map2(60,20) as short
    dim sp(255) as cords
    dim as short roomsize
    dim p1 as cords
    dim p2 as cords
    dim  as integer counter,bigc
    slot=enter.m

    planets(slot).darkness=5
    planets(slot).vault=r(0)
    planets(slot).teleport=1
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

    for a=1 to last
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
    for a=1 to rnd_range(1,planets(slot).depth+1)
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
    for a=1 to rnd_range(1,planets(slot).depth+1)+rnd_range(1,planets(slot).depth-1)
        do
            a=rnd_range(0,last)
        loop until r(a).wd(5)=0 and a<>b
        x=rnd_range(r(a).x,r(a).x+r(a).w)
        y=rnd_range(r(a).y,r(a).y+r(a).h)
        planetmap(x,y,slot)=-84
    next
    if rnd_range(1,100)<33 or planets(slot).depth>7 then
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
    
    planets(slot).temp=25
    planets(slot).atmos=3    
    planets(slot).grav=0
    planets(slot).mon=9
end sub

sub makelabyrinth(slot as short)

dim map(60,20) as short
dim as short x,y,a,b,c,count
dim p as cords
dim p2 as cords
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
    dim as cords p,p2
    dim as short a,b,c,x,y
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

            
sub makecavemap(enter as gamecords,tumod as short,dimod as short, spemap as short, froti as short)
    dim as short x,y,a,count,loops,b,slot,n,door,c,d,notu
    dim map2(60,20) as short 'hardness
    dim map3(60,20) as short 'to make vault
    dim seedps(64) as cords
    dim r as _rect
    dim as cords p1,p2,p3,rp,sp,ep
    dim gascloud as short
    gascloud=spacemap(player.c.x,player.c.y)
    slot=enter.m
    
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
    
    if rnd_range(1,100)<45 and lastplanet<512 and spemap>0 then
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
    
    if r.h*r.w>15 and rnd_range(1,100)<38 then 'realvault
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
    dim as cords p,p1,p2,p3,p4
    dim ti as short
    dim it as _items
    dim r1 as _rect
    dim t as _rect
    dim r(255) as _rect
    dim wmap(60,20) as short
    dim as short last,wantsize,larga,largb,lno,mi,old
    if a<=0 then 
       dprint "ERROR: Attempting to make planet map at "&a,14,14
       return
    endif
    planettype=rnd_range(1,100)
    o=orbit
    planets(a).orbit=o
    planets(a).water=(rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)+rnd_range(1,3)-orbit)*10
    if o<3 then planets(a).water=planets(a).water-rnd_range(70,100)
    if planets(a).water<0 then planets(a).water=0
    if planets(a).water>=75 then planets(a).water=75
    planets(a).atmos=rnd_range(1,16)
    if planets(a).water>0 then
        planets(a).atmos=planets(a).atmos+5
    endif
    planets(a).atmos=planets(a).atmos-abs((5-o)\2)
    planets(a).mon=1
    planets(a).mon2=2
    if planets(a).atmos>16 then planets(a).atmos=16
    if planets(a).atmos<1 then planets(a).atmos=1
    planets(a).grav=(3+rnd_range(1,10)+rnd_range(1,8))/10
    planets(a).weat=0.5+(rnd_range(0,10)-5)/10
    if planets(a).weat<=0 then planets(a).weat=0.5
    if planets(a).weat>1 then planets(a).weat=0.9
    gascloud=spacemap(player.c.x,player.c.y)
    if gascloud=2 then
        gascloud=1
    else
        gascloud=-1
    endif
    if spect=1 then gascloud=gascloud-1
    if spect<3 then gascloud=gascloud-1
    if spect>5 then gascloud=gascloud+1
    if spect>=7 then gascloud=gascloud+1
    for b=0 to rnd_range(0,spect)+rnd_range(0,3)+gascloud+disnbase(player.c)\7
        if specialplanet(15)<>a and planettype<44 and isgasgiant(a)=0 then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\7+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),rnd_range(0,60),rnd_range(0,20),a)
    next b
    
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
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),p.x,p.y,a)
        next b
    endif
    
    if planettype>=33 and planettype<44 then
        makeoceanworld(a,o)
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            d=0
            p=rnd_point
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),p.x,p.y,a)
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
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),p.x,p.y,a)
        next b
    
    endif
    if (planettype>=65 and planettype<80) or spect=8 then 
        makecraters(a,o)'craters
        for b=0 to rnd_range(0,3)+gascloud+disnbase(player.c)\4
            p=rnd_point
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),p.x,p.y,a)
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
            if specialplanet(15)<>a then placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5+gascloud,planets(a).depth+disnbase(player.c)\6+gascloud),p.x,p.y,a)
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
    if planets(a).depth=0 and rnd_range(1,100)<15-disnbase(player.c) then
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-86 '2nd landingparty
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
    
    if rnd_range(1,200)<15 then 'Geyser
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
    if planets(a).orbit>2 and planets(a).orbit<6 then planets(a).life=planets(a).life+rnd_range(1,5)
    if planets(a).life>10 then planets(a).life=10 
    planets(a).rot=(rnd_range(0,6)+rnd_range(0,6)-3)/10
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
        planetmap(p1.x,p1.y,a)=-127-c-d
        for b=0 to 1+d
            if rnd_range(1,100)<11 then placeitem(rnd_item(21),p1.x,p1.y,a)
        next
    endif
    
    'Mining
    if rnd_range(1,200)<15-disnbase(player.c) then
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-76
        if rnd_range(1,100)<22 then 
            planetmap(p1.x,p1.y,a)=-77
            for b=0 to rnd_range(1,4)
                if rnd_range(1,100)<25 then placeitem(rnd_item(6),p1.x,p1.y,a)
                if rnd_range(1,100)<35 then placeitem(makeitem(96,-2,-2),p1.x,p1.y,a)
            next
        endif
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
       
    planets(a).mapmod=0.5+planets(a).orbit/10+planets(a).atmos/10+planets(a).grav/5
    if planets(a).atmos>=8 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 then planetmap(x,y,a)=-20
                if planetmap(x,y,a)=-2 then planetmap(x,y,a)=-21
                if planetmap(x,y,a)=-10 then planetmap(x,y,a)=-22
                if planetmap(x,y,a)=-11 then planetmap(x,y,a)=-25
                if planetmap(x,y,a)=-5 then planetmap(x,y,a)=-23
                if planetmap(x,y,a)=-6 then planetmap(x,y,a)=-24
                if planetmap(x,y,a)=-12 and rnd_range(1,100)>33 then planetmap(x,y,a)=-13
            next
        next
    endif
    
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
    
    makespecialplanet(a)
    
    if planets(a).temp<0 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 or planetmap(x,y,a)=-2 then planetmap(x,y,a)=-27 
            next
        next
    endif
    
    
    if planets(a).temp>100 and planets(a).temp<180 then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,a)=-1 or planetmap(x,y,a)=-2 then planetmap(x,y,a)=-12 
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
                if planetmap(x,y,a)=-2 then planetmap(x,y,a)=-45
                if planetmap(x,y,a)=-5 then planetmap(x,y,a)=-25
                if planetmap(x,y,a)=-6 then planetmap(x,y,a)=-25
                if planetmap(x,y,a)=-10 then planetmap(x,y,a)=-4
                if planetmap(x,y,a)=-11 then planetmap(x,y,a)=-4
                if planetmap(x,y,a)=-22 then planetmap(x,y,a)=-4
            next
        next
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
    planets(a).darkness=cint((5-planets(a).orbit)/2)
    planets(a).dens=(planets(a).atmos-1)-6*((planets(a).atmos-1)\6)
    if spect=8 then
        makecraters(a,9)
        planets(a).darkness=5
        planets(a).orbit=9
        planets(a).temp=-270+rnd_range(1,10)/10
    endif    
    if show_all=1 then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-planetmap(x,y,a)
            next
        next
    endif
end sub

sub makecraters(a as short, o as short)
    dim as short x,y,d,b,b1,wx,wy,ice
    dim as cords p3,p2,p1
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
dim as cords p1,p2
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
    dim as cords p1,p2
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
    planets(a).mon=24
    planets(a).mon2=10
    makeice(o,a)
end sub

sub makemossworld(a as short, o as short)
    dim as short x,y,r,b,h,l,t1,t2
    dim as cords p1,p2
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
    dim as cords p1,p2
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
    planets(a).water=0
    if rnd_range(1,100)<50 then makeice(a,o)
end sub

sub makespecialplanet(a as short)
    dim as short x,y,b,c,d,b1,b2,b3,cnt,wx,wy,ti
    dim as cords p,p1,p2,p3,p4,p5
    dim as cords pa(5)
    dim as _rect r
    dim as gamecords gc,gc1
    dim it as _items
    ' UNIQUE PLANETS
    '
    
    
    if a=specialplanet(0) then 'Woodworld
        
        for x=0 to 60
            for y=0 to 20
                if rnd_range(1,100)<77 then
                    if rnd_range(1,100)<80 then
                        planetmap(x,y,a)=-6
                    else
                        planetmap(x,y,a)=-5
                    endif
                endif
            next
        next
        for x=0 to 29+rnd_range(1,6)
            planetmap(rnd_range(0,60),rnd_range(0,20),a)=-146
        next
        for x=0 to rnd_range(1,5)
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),a)
        next
        for x=0 to 3
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-59
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\5,planets(a).depth+disnbase(player.c)\6),p1.x,p1.y,a)

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
        planets(a).mon=4
        planets(a).noamin=15
        planets(a).noamax=25
        planets(lastplanet)=planets(a)
        planets(lastplanet).depth=3
        planets(lastplanet).grav=0
        for b=0 to rnd_range(0,6)+disnbase(player.c)\4
            placeitem(makeitem(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),rnd_range(0,60),rnd_range(0,20),lastplanet)
        next b
    
    endif
    
    if a=specialplanet(1) then 'apollos temple
        planetmap(rnd_range(1,60),rnd_range(0,20),a)=-56
    endif
    
    if a=specialplanet(2) then 'Defense town
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
        
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=asc("#")
        portal(lastportal).col=15
        portal(lastportal).from.m=a
        portal(lastportal).from.x=p1.x
        portal(lastportal).from.y=p1.y
        portal(lastportal).dest.m=lastplanet+1
        'specialplanet(11)=portal(lastportal).dest.m
        portal(lastportal).dest.x=rnd_range(1,59)
        portal(lastportal).dest.y=rnd_range(1,19)
        portal(lastportal).discovered=show_portals
        portal(lastportal).tumod=10
        portal(lastportal).dimod=-3
        lastplanet=lastplanet+1
        
        gc.x=portal(lastportal).dest.x
        gc.y=portal(lastportal).dest.y
        gc.m=portal(lastportal).dest.m
        makecomplex(gc,0)
        portal(lastportal).dest.x=gc.x
        portal(lastportal).dest.y=gc.y
        portal(lastportal).dest.m=gc.m
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-167
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-100
        for x=0 to rnd_range(1,6)+rnd_range(1,6)
            p1=rnd_point
            planetmap(p1.x,p1.y,a)=-127-rnd_range(1,10)
        next
        planets(a).mon=0
        planets(a).mon2=0
        planets(a).life=0
        planets(a).atmos=6
        planets(lastplanet).atmos=6
        p1=rnd_point
        planetmap(p1.x,p1.y,a)=-168
    endif
    
    if a=specialplanet(3) or a=specialplanet(4) then 'cityworld
        
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
        
        planets(a).mon=8
        planets(a).noamin=8
        planets(a).noamax=15
    endif
    
    
    if a=specialplanet(5) or a=specialplanet(12) then 'dune and sandworms
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
        
        
            planets(a).mon=11
            planets(a).noamax=15
            planets(a).noamin=8
        endif
        if specialplanet(12)=a then 'dying world
            for b=0 to rnd_range(1,8)+rnd_range(1,5)+rnd_range(1,3)
                placeitem(makeitem(96,4,4),rnd_range(0,60),rnd_range(0,20),a)
            next
        
        endif
    endif
    
    if specialplanet(6)=a then 'invisible critters +mine
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
        
        planets(a).mon=13
        planets(a).noamax=8
        planets(a).noamin=15
        planets(lastplanet).mon=13
        planets(lastplanet).noamax=25
        planets(lastplanet).noamin=10
        placeitem(makeitem(15),p1.x,p1.y+2,a,0,0)
        'placeitem(makeitem(97),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0,0)
        placeitem(makeitem(98),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        placeitem(makeitem(99),rnd_range(0,60),rnd_range(0,20),lastplanet,0,0)
        
    endif
    
    if specialplanet(7)=a then 'stranded ship
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-9
    endif
    
    if specialplanet(8)=a then 'Pirate treasure on stormy world
        planetmap(rnd_range(0,60),rnd_range(0,20),a)=-75
        
    endif
    
    if specialplanet(9)=a then 'Secret Base thingy
        wx=rnd_range(0,53)
        wy=rnd_range(0,13)
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
        planets(a).depth=7
        lastportal=lastportal+1
        portal(lastportal).desig="A building still in good condition. "
        portal(lastportal).tile=ASC("#")
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
        
    endif
    
    if specialplanet(10)=a or a=pirateplanet(0) then 'Settlement
        if a<>pirateplanet(0) then
            lastwaypoint=7
            targetlist(7)=map(sysfrommap(a)).c
        endif

        planets(a).grav=0.8+rnd_range(1,3)/2
        planets(a).atmos=6
        planets(a).temp=9+rnd_range(1,200)/10
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
            y=rnd_range(p2.y,p2.y+wy)
        loop until planetmap(x,y,a)<30 or cnt>40000
        if a<>pirateplanet(0) then 
            planetmap(x,y,a)=89
        else
            planetmap(x,y,a)=164
        endif
        planets(a).mon=14
        planets(a).noamin=8
        planets(a).noamax=17
            
        if a=pirateplanet(0) then 'add spaceport
            c=rnd_range(1,55)
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
            if p4.y-2<0 then p4.y=p4.y+2
            if p4.y+2>60 then p4.y=p4.y-2
            for x=c to c+3
                for y=p4.y-2 to p4.y+2
                    planetmap(x,y,a)=68
                    if rnd_range(1,100)<35 then planetmap(x,y,a)=67
                    if x=c and d<5 then
                        planetmap(x,y,a)=69+d
                        d=d+1
                    endif
                next
            next
            do
                p=rnd_point(a,0)
            loop until tiles(abs(planetmap(p.x,p.y,a))).walktru>0 or abs(planetmap(p.x,p.y,a))<15
            planetmap(p.x,p.y,a)=-197
            planets(a).mon=10
            planets(a).noamin=8
            planets(a).noamax=15
        endif
    
    
    
        'Turn all around
        if not(player.pirate_agr=0 and a=pirateplanet(0)) then
        
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
    endif
    
    if specialplanet(12)=a then
        for b=0 to rnd_range(0,15)+15
            placeitem(makeitem(96,9,7),rnd_range(0,60),rnd_range(0,20),a)
        next
        
        planets(a).water=0
        planets(a).atmos=1
        planets(a).grav=3
        planets(a).temp=4326+rnd_range(1,100)
        planets(a).death=10+rnd_range(1,4)
    endif
    
    if specialplanet(13)=a then
        p1.x=rnd_range(0,50)
        p1.y=rnd_range(0,15)
        planetmap(p1.x,p1.y,a)=-76
        planetmap(p1.x+2,p1.y,a)=-76
        planetmap(p1.x,p1.y+2,a)=-99
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
        portal(lastportal).tumod=8
        portal(lastportal).dimod=-1
        lastplanet=lastplanet+1
        
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,lastplanet)=-4 and rnd_range(0,100)<66 then planetmap(x,y,lastplanet)=-47
            next
        next

    endif
    
    if specialplanet(14)=a then
        p2=rnd_point
        p3=rnd_point
        makeoutpost(a,p2.x,p2.y)
        makeoutpost(a,p3.x,p3.y)
        p1=rnd_point
        makeroad(p1,p2,a)
        makeroad(p1,p3,a)
        if p1.x>50 then p1.x=50
        if p1.x<5 then p1.x=10
        if p1.y<5 then p1.y=5
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
            for y=p2.y to p2.y+3
                planetmap(x,y,a)=-68
            next
        next
        planetmap(p2.x-1,p2.y,a)=-238
        planetmap(p2.x-1,p2.y+3,a)=-237
        
    endif
    
    if specialplanet(15)=a then
        planets(a).water=66
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
        planets(a).mon=20
        planets(a).noamax=20
        planets(a).noamin=18
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
        planets(a).noamin=15
        planets(a).noamax=25
        planets(a).mon=22
        
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
        planets(lastplanet+1).mon=1
        planets(lastplanet+1).mon2=9
        planets(lastplanet+1).noamin=9
        planets(lastplanet+1).noamax=18
        planets(lastplanet+1).atmos=6
        planets(lastplanet+2).mon=1
        planets(lastplanet+2).mon2=9
        planets(lastplanet+2).noamin=9
        planets(lastplanet+2).noamax=18
        planets(lastplanet+2).atmos=6
        planets(lastplanet+3).mon=9
        planets(lastplanet+3).noamin=9
        planets(lastplanet+3).noamax=18
        planets(lastplanet+3).atmos=6
        p1=rnd_point(lastplanet+3,0)
        placeitem(makeitem(90),p1.x,p1.y,lastplanet+3,0,0) 
        planetmap(p1.x,p1.y,lastplanet+3)=-162
        lastplanet=c+3
    endif
    
    if specialplanet(17)=a then
        planets(a).water=66
        makeislands(a,4)
        
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
        planets(a).mon=30
        planets(a).noamax=25
        planets(a).noamin=18
        planets(a).temp=49.7
        planets(a).rot=12.7
        planets(a).atmos=3
    endif
    
    if specialplanet(18)=a then
        makemossworld(a,6)
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
        planets(a).mon=25
        planets(a).noamax=20
        planets(a).noamin=18
        planets(a).temp=19.7
        planets(a).grav=1.1
        planets(a).atmos=5
    endif
    if a=specialplanet(19) then
    
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
        planets(a).mon=26
        planets(a).noamax=12
        planets(a).noamin=88
        planets(a).temp=-219.7
        planets(a).grav=1.1
        planets(a).atmos=4
    endif
    
    if a=specialplanet(20) then
        planets(a).water=33
        makeislands(a,3)
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
        planets(a).mon=28
        planets(a).noamin=5
        planets(a).noamax=15
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
        
        planets(b).mon=29
        planets(b).depth=1
        planets(b).noamin=5
        planets(b).noamax=15
        
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
        
        planets(b).mon=29
        planets(b).depth=1
        planets(b).noamin=5
        planets(b).noamax=15
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-190
        for c=0 to 10
            placeitem(makeitem(96,planets(a).depth+disnbase(player.c)\7,planets(a).depth),p.x,p.y,b,0,0)
        next
        for c=0 to 5
            placeitem(makeitem(rnd_range(1,lstcomit)),p.x,p.y,b,0,0)
        next
        placeitem(makeitem(89),p.x,p.y,a)
    endif
    
    if a=specialplanet(26) then
        b=-13
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
        
        planets(a).mon=31
        planets(a).noamin=10
        planets(a).noamax=15
        
        
        
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
        planets(b).mon=31
        planets(b).noamin=5
        planets(b).noamax=15
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
        planets(b).mon=31
        planets(b).noamin=15
        planets(b).noamax=25        
        planets(b).atmos=6
        
        p=rnd_point(b,0)
        planetmap(p.x,p.y,b)=-191
    
    endif
        
    if a=specialplanet(27) then
        makecraters(a,3)
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
        planets(a).mon=36
        planets(a).noamin=5
        planets(a).noamax=10
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
        
        
        planets(lastplanet).mon=36
        planets(lastplanet).noamin=10
        planets(lastplanet).noamax=15
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
        
        planets(lastplanet).mon=36
        planets(lastplanet).noamin=15
        planets(lastplanet).noamax=20
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
        
        planets(lastplanet).mon=36
        planets(lastplanet).noamin=25
        planets(lastplanet).noamax=30
        planets(lastplanet).atmos=6
        planets(lastplanet).depth=1
        
    endif
    
    if a=specialplanet(28) then
        makemossworld(a,5)
        planets(a).atmos=6
    endif
    
    if a=specialplanet(29)then
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=-4
            next
        next
        planets(a).flavortext="This is truly the most boring piece of rock you have ever laid eyes upon."
        planets(a).atmos=4
        planets(a).noamin=0
        planets(a).noamax=0
    endif
    
    
    
    if a=specialplanet(30) then
        planets(a).water=25
        makeislands(a,3)
        planets(a).atmos=4
        planets(a).temp=15.5
        
        for x=5 to 15
            for y=5 to 15
                if x=5 or y=5 or x=15 or y=15 then
                    planetmap(x,y,a)=-16
                else
                    if frac(x/2)=0 and frac(y/2)=0 then planetmap(x,y,a)=-68
                endif
            next
        next
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
        planets(a).mon=8
        planets(a).temp=-241
        planets(a).noamin=5
        planets(a).noamax=10
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
            planets(lastplanet).atmos=1
            planets(lastplanet).grav=.5
            planets(lastplanet).depth+=1
            planets(lastplanet).mon=8
            planets(lastplanet).noamin=5
            planets(lastplanet).noamax=10
        next
    endif
    
    if a=specialplanet(32) then
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
                if x>10 and x<25 and y=10 then planetmap(x,y,a)=-4
                
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
            if d=1 then planets(lastplanet).mon=40
            if d=2 then planets(lastplanet).mon=13
            if d=3 then planets(lastplanet).mon=29
            planets(lastplanet).noamin=5+b
            planets(lastplanet).noamax=10+b
        next
    endif
        
    if a=specialplanet(33) then
        pa(0).x=10
        pa(0).y=10
        pa(1).x=30
        pa(1).y=16
        pa(2).x=30
        pa(2).y=10
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
                if x>10 and x<25 and y=10 then planetmap(x,y,a)=-4
                
            next
        next
        for b=0 to 5
            p=rnd_point(a,0)
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
        planets(lastplanet).mon=3
        planets(lastplanet).noamin=8
        planets(lastplanet).noamax=12
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
            planets(lastplanet).mon=3
            planets(lastplanet).noamin=8+b
            planets(lastplanet).noamax=18+b
        next
    endif
    
    if a=specialplanet(34) then
        planets(a).water=45
        makeislands(a,3)
        for c=1 to 12
            p1=rnd_point
            b=rnd_range(0,2)+rnd_range(0,2)+2
            for x=p1.x-4 to p1.x+4
                for y=p1.y-4 to p1.y+4
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if abs(planetmap(x,y,a))>2 then
                            if distance(p1,p2)<b then planetmap(x,y,a)=-160
                            if distance(p1,p2)=b then planetmap(x,y,a)=-159
                        endif    
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
        planets(a).mon=42
        planets(a).noamin=5
        planets(a).noamax=7
    endif
    
    if a=specialplanet(35) then
        planets(a).mon=42
        planets(a).noamin=10
        planets(a).noamin=25
        planets(a).temp=12.3
        planets(a).rot=12.3
        makeoceanworld(a,3)
        for b=0 to 36
            planetmap(rnd_range(0,60),rnd_range(4,16),a)=-239
        next
    endif
    
    if a=specialplanet(36) then
        planets(a).water=77
        makeislands(a,3)
        planets(a).mon=43
        planets(a).noamin=10
        planets(a).noamax=25
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
        planets(lastplanet).mon=44
        planets(lastplanet).noamin=1
        planets(lastplanet).noamax=1
        planets(lastplanet).depth=1
        planets(lastplanet).temp=12.3
        planets(lastplanet).atmos=8
        planets(lastplanet).rot=12.3
    endif
    
    if a=specialplanet(37) then
        planets(a).mon=-1
        planets(a).noamin=0
        planets(a).noamax=0
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
    
    if a=specialplanet(38) then
        planets(a).water=57
        makeislands(a,3)
        planetmap(rnd_range(1,60),rnd_range(3,12),a)=-62
        planets(a).mon=45
        planets(a).noamin=35
        planets(a).noamax=46
        planets(a).temp=12.3
        planets(a).atmos=8
        planets(a).rot=12.3
        
        lastplanet+=1
        gc.x=rnd_range(0,60)
        gc.y=rnd_range(0,20)
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc("o"),"A natural tunnel",7)
        makecavemap(gc1,2-rnd_range(1,4),4-rnd_range(1,8),0,0)
        
        p1=rnd_point(lastplanet,0)
        lastplanet+=1
        gc.x=p1.x
        gc.y=p1.y
        gc.m=a    
        gc1.x=rnd_range(0,60)
        gc1.y=rnd_range(0,20)
        gc1.m=lastplanet
        addportal(gc,gc1,0,asc("o"),"A shaft",14)
        makecomplex(gc1,2)
        p1=rnd_point(lastplanet,0)
        planetmap(p1.x,p1.y,lastplanet)=-240
    endif
    
    
    if isgasgiant(a)>0 and a=specialplanet(isgasgiant(a)) then
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
        planets(a).mon=0
        planets(a).noamin=0
        planets(a).noamax=0
        planets(a).mon2=0
        planets(a).temp=-160
        planets(a).grav=1.1
        planets(a).atmos=9
        if rnd_range(1,100)<35 then
            planets(a).mon=8
            planets(a).noamin=5
            planets(a).noamax=15
        endif
        if rnd_range(1,100)<25 then
            planets(a).mon=9
            planets(a).noamin=5
            planets(a).noamax=15
        endif
        if rnd_range(1,100)<15 then
            planets(a).mon=27
            planets(a).noamin=1
            planets(a).noamax=5
        endif
        if rnd_range(1,100)<10 then
            planets(a).mon=27
            planets(a).noamin=1
            planets(a).noamax=3
        endif
    endif
        
    
    
end sub

sub makedrifter(d as gamecords, bg as short=0)
    dim as short a,m,roll,x,y,f,ti,xs,ys,x2,y2,addweap,addcarg
    dim s as _ship
    dim pods(6,5,1) as short
    dim p as cords
    dim crates(254) as cords
    dim from as gamecords
    dim dest as gamecords
    dim lastcrate as short
    loadmap(d.s,lastplanet)  
    if bg=0 then
        m=d.m
    else
        m=lastplanet+1
        lastplanet+=1
    endif
    f=freefile
    open "pods.dat" for binary as #f
    for a=0 to 1
        for y=0 to 5
            for x=0 to 6
                get #f,,pods(x,y,a)
            next
        next
    next
    close #f
    s=gethullspecs(d.s)
    addweap=s.h_maxweaponslot*10
    addcarg=s.h_maxcargo*10
    for a=6 to s.h_maxweaponslot
        if rnd_range(1,100)<66 then planets(m).flags(a)=rnd_range(1,6)
        if rnd_range(1,100)<16+addweap then planets(m).flags(a)=planets(m).flags(a)+rnd_range(0,4)
        if rnd_range(1,100)<25 then planets(m).flags(a)=-rnd_range(1,3)
        if planets(m).flags(a)=-1 then addcarg=addcarg+10
        if planets(m).flags(a)=-2 then s.h_maxcrew=s.h_maxcrew+3
    next
    
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
        next
    next
    
    
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=204 and rnd_range(1,100)<66 then planetmap(x,y,m)=-205
            if abs(planetmap(x,y,m))=202 and rnd_range(1,100)<8 then 
                if abs(planetmap(x-1,y,m))=201 or abs(planetmap(x+1,y,m))=201 or abs(planetmap(x,y-1,m))=201 or abs(planetmap(x,y+1,m))=201 then 
                    planetmap(x,y,m)=-221
                    if rnd_range(1,100)<66 then planetmap(x,y,m)=-222
                    for a=0 to rnd_range(0,1)
                        placeitem(rnd_item(21),x,y,m)
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
            if abs(planetmap(x,y,m))=200 and bg<>0 then planetmap(x,y,m)=bg
        next
    next
    
    if s.h_maxcargo>5 then s.h_maxcargo=5
    for a=1 to s.h_maxcargo
        if rnd_range(1,100)>25+addcarg then
            p=crates(rnd_range(1,lastcrate))
            planetmap(p.x,p.y,m)=-214-a
            planets(m).flags(10+a)=rnd_range(2,6)
        endif
    next
    
    if bg<>0 then
        'add portals
        from=d
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=203 then
                    dest.x=x
                    dest.y=y
                    dest.m=m
                    addportal(from,dest,0,asc("O"),"An airlock of the "&shiptypes(d.s),14)
                    addportal(dest,from,0,asc("@"),"An stranded "&shiptypes(d.s),11)
                endif
            next
        next
        
    endif
    
    roll=rnd_range(1,100)
    if roll<40 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=32
        planets(m).mon2=33
        planets(m).noamin=d.s
        planets(m).noamax=1+d.s
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
    endif
    
    if roll>40 and roll<50 then
        planets(m).darkness=5
        planets(m).depth=1
        planets(m).atmos=1
        planets(m).mon=33
        planets(m).mon2=33
        planets(m).noamin=d.s
        planets(m).noamax=1+d.s
        planets(m).flavortext="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. You feel like defiling a grave."
    endif
    
    if roll>49 and roll<60 then
        planets(m).darkness=5
        planets(m).depth=1
        planets(m).atmos=1
        planets(m).mon=31
        planets(m).mon2=33
        planets(m).noamin=d.s-5
        planets(m).noamax=d.s-4
        if planets(m).noamin<0 then planets(m).noamin=2 
        if planets(m).noamax<0 then planets(m).noamax=8 
        planets(m).flavortext="It is dark as you enter the " &shiptypes(d.s)&". A thin layer of ice covers everything. The air is gone. No sound reaches you through the vakuum but you see red alert lights still flashing."
    endif
    
    if roll>59 and roll<70 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=34
        planets(m).mon2=34
        planets(m).noamin=5+d.s
        planets(m).noamax=15+d.s
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
    endif
    
    if roll>69 and roll<80 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=3
        planets(m).mon2=3
        planets(m).noamin=1
        planets(m).noamax=1
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
    endif
    
    if roll>79 and roll<85 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=18
        planets(m).mon2=18
        planets(m).noamin=1
        planets(m).noamax=1
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
    endif
    
    if roll>84 and roll<90 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=19
        planets(m).mon2=19
        planets(m).noamin=1
        planets(m).noamax=1
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
    endif
    
    if roll>89 and roll<95 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=35
        planets(m).mon2=35
        planets(m).noamin=1
        planets(m).noamax=1
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale."
    endif
    
    
    if roll>94 and roll<100 then
        planets(m).darkness=0
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=29
        planets(m).mon2=29
        planets(m).noamin=d.s-5
        if planets(m).noamin<0 then planets(m).noamin=0
        planets(m).noamax=d.s
        planets(m).flavortext="No hum from the engines is heard as you enter the " &shiptypes(d.s)&". Emergency lighting bathes the corridors in red light, and the air smells stale. An alert klaxon is the only sound you hear."
    endif
    
    if roll>98 then
        planets(m).darkness=5
        planets(m).depth=1
        planets(m).atmos=4
        planets(m).mon=38
        planets(m).mon2=33
        planets(m).noamin=1
        planets(m).noamax=2
        planets(m).flavortext="As you enter this " &shiptypes(d.s)& " you hear a squeaking noise almost like a jiggle. You feel uneasy. Something is here, and it is not friendly." 
    endif
    planets(m).flags(0)=0
    planets(m).flags(1)=d.s
    planets(m).flags(2)=rnd_range(1,s.h_maxhull)
    planets(m).flags(3)=rnd_range(1,s.h_maxengine)
    planets(m).flags(4)=rnd_range(1,s.h_maxsensors)
    planets(m).flags(5)=rnd_range(0,s.h_maxshield)
        
end sub

sub makeice(o as short,a as short)
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

end sub

function addportal(from as gamecords, dest as gamecords, oneway as short, tile as short,desig as string, col as short) as short
    lastportal=lastportal+1
    portal(lastportal).from=from
    portal(lastportal).dest=dest
    portal(lastportal).oneway=oneway
    portal(lastportal).tile=tile
    portal(lastportal).col=col
    portal(lastportal).desig=desig
    portal(lastportal).discovered=show_all
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


function makesettlement(p as cords,slot as short, typ as short) as short
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

function makeroad(byval s as cords,byval e as cords, a as short) as short
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

function makevault(r as _rect,slot as short,nsp as cords, typ as short) as short
    dim as short x,y,a,b,c,d,nodo,best,bx,by
    dim p(31) as cords
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
                    if rnd_range(1,100)<21 then placeitem(makeitem(5),x,y,slot)
                    if rnd_range(1,100)<5 then placeitem(makeitem(96),x,y,slot,5,5)
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
    dim as short x,y,a
    
    
    x=rnd_range(1,_x)
    y=rnd_range(1,_y)
    map(x,y)=1
    do        
        x=rnd_range(1,_x)
        y=rnd_range(1,_y)
        if x>0 then
            if map(x-1,y)=1 and map(x,y-1)=0 and map(x,y+1)=0 then map(x,y)=1
        endif
        if y>0 then
            if map(x,y-1)=1 and map(x-1,y)=0 and map(x+1,y)=0 then map(x,y)=1
        endif    
        if x<_x then
            if map(x+1,y)=1 and map(x,y-1)=0 and map(x,y+1)=0 then map(x,y)=1
        endif
        if y<_y then
            if map(x,y+1)=1 and map(x-1,y)=0 and map(x+1,y)=0 then map(x,y)=1
        endif    
        a=0
        color 15,0
        for x=0 to 10
            for y=0 to 10
                if map(x,y)=1 then a+=1
            next
        next
    loop until a>_x*_y*.6
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
    if player.pirate_agr=0 then
        for x=x1 to x1+w
            for y=y1 to y1+h
                planetmap(x,y,slot)=-planetmap(x,y,slot)
            next
        next
    endif
end sub

sub adaptmap(slot as short,enemy()as _monster,byref lastenemy as short)
    dim as short in,start,cur,a,b,c,pyr,hou,i,ti
    dim houses(2) as short
    dim as cords p
    dim as gamecords from,dest
    p=rnd_point
    if lastenemy>1 and planets(slot).atmos>1 then
        for a=1 to lastenemy
            if enemy(a).intel>=6 then
                if enemy(a).intel=6 then in=0
                if enemy(a).intel=7 then in=1
                if enemy(a).intel>7 then in=2
                if rnd_range(1,100)<66 then houses(in)=houses(in)+1
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
                       planetmap(p.x,p.y,slot)=-ti
                       if rnd_range(1,100)<16+planets(slot).atmos then
                            planetmap(p.x,p.y,slot)=-b
                            if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
                            pyr=pyr+10+2*in                
                            if rnd_range(1,100)<b-66 then 
                                placeitem(makeitem(94),p.x,p.y,slot,0,0)
                            endif
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
    
    if houses(0)=0 and houses(1)=0 and houses(2)=0 and rnd_range(1,100)<25 and planets(slot).atmos>1 and planets(slot).atmos<7 then makesettlement(rnd_point,slot,rnd_range(0,4))
                        
    if rnd_range(1,100)<pyr+7 and pyr>0 then         
        planetmap(p.x,p.y,slot)=-150
        if show_all=1 then planetmap(p.x,p.y,slot)=-planetmap(p.x,p.y,slot)
        if rnd_range(1,100)<pyr+5 then
            p=movepoint(p,5)
            lastplanet=lastplanet+1
            makelabyrinth(lastplanet)
            planets(lastplanet).depth=1
            planets(lastplanet).mon=21
            planets(lastplanet).noamin=10
            planets(lastplanet).noamax=20
            planets(lastplanet).depth=1
            for i=0 to rnd_range(2,6)+rnd_range(1,6)+rnd_range(2,6)
                p=rnd_point(lastplanet,0)
                if i<6 then placeitem(makeitem(96,-2,-3),p.x,p.y,lastplanet)
                if i>6 then placeitem(makeitem(94),p.x,p.y,lastplanet)
            next                 
            for i=0 to rnd_range(1,6)+rnd_range(1,6)
                p=rnd_point(lastplanet,0)
                placeitem(makeitem(96,-2,-3),p.x,p.y,lastplanet)
            next
            
            from.x=p.x
            from.y=p.y
            from.m=slot
            
            p=rnd_point(lastplanet,0)
            dest.x=p.x
            dest.y=p.y
            dest.m=lastplanet
            
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
dim as cords p1,p2
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


function flood_fill(x as short,y as short,map() as short) as short
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
end function


function rndwallpoint(r as _rect, w as byte) as cords
    dim p as cords
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

function digger(byval p as cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
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
