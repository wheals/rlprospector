#ifndef _cords
type _cords
    x as short
    y as short
end type

declare Function rnd_range (first As short, last As short) As short
declare function distance(first as _cords, last as _cords) as single

function distance(first as _cords, last as _cords) as single
    dim dis as single
    dis=(first.x-last.x)*(first.x-last.x)
    dis=dis+(first.y-last.y)*(first.y-last.y)
    dis=sqr(dis)
    return dis
end function

Function rnd_range (first As short, last As short) As short
        return cint(Rnd * (last - first) + first)
End Function
#endif

type _node
    opclo as byte
    g as single
    h as single
    cost as single
    parent as _cords
end type

declare function a_star(path() as _cords, start as _cords,goal as _cords,map() as short,mx as short,my as short,echo as short=1,rollover as byte=0) as short
declare function manhattan(a as _cords,b as _cords) as single
declare function addneighbours(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short
declare function findlowerneighbour(node() as _node, curr as _cords,mx as short,my as short) as short

function a_star(path() as _cords, start as _cords,goal as _cords,map() as short,mx as short,my as short,echo as short=1,rollover as byte=0) as short

dim node(mx,my) as _node
dim as short lastopen,lastclosed,lastnode,x,y,i,j
dim as integer ccc
dim as _cords curr,p,best
dim as single d
dim as byte debug=0

if debug=1 then
    locate my+2,1
    print start.x;":";start.y;"-";goal.x;":";goal.y
endif
curr=start
for x=0 to mx
    for y=0 to my
        node(x,y).cost=abs(map(x,y))
    next
next

do
    ccc+=1
    if ccc mod 10=0 and echo=1 then print ".";
    node(curr.x,curr.y).opclo=1 'Node on Open list
    addneighbours(node(),curr,mx,my,rollover)
    node(curr.x,curr.y).opclo=2 'Add node to closed List
    findlowerneighbour(node(),curr,mx,my)
    
    d=9999999
    best.x=-1
    best.y=-1
    if curr.x<>goal.x or curr.y<>goal.y then
        for x=0 to mx
            for y=0 to my
                
                p.x=x
                p.y=y
                if curr.x<>goal.x or curr.y<>goal.y then
                    if node(x,y).opclo=1 then
                        node(x,y).h=manhattan(p,goal)
                        if node(x,y).h+node(x,y).g<d or manhattan(p,goal)=0 then
                            best.x=x
                            best.y=y
                            if manhattan(p,goal)>0 then 
                                d=node(x,y).h+node(x,y).g
                            else
                                d=0
                            endif
                        endif
                    endif
                endif
                if debug=1 then
                    locate y+1,x+1
                    color 10,0
                    if node(x,y).opclo=1 then print "1";
                    if node(x,y).opclo=2 then print "2";
                    if node(x,y).opclo=0 then 
                        color 15,0
                        print manhattan(p,goal);
                    endif
                endif
            next
        next
        if debug=1 then sleep 10
        if best.x>=0 and best.y>=0 and not (curr.x=goal.x and curr.y=goal.y) then
            node(best.x,best.y).opclo=2
            curr=best
        endif
    endif
loop until (curr.x=goal.x and curr.y=goal.y) or ccc<0

if ccc>0 then
    i=0
    do
        path(i).x=curr.x
        path(i).y=curr.y
        curr=node(curr.x,curr.y).parent
        i+=1
       
    loop until curr.x=start.x and curr.y=start.y or i>1024
    path(i).x=curr.x
    path(i).y=curr.y
     
    'i-=1
    if echo=1 then print "found with "&i &" Waypoints."
    return i
else
    if echo=1 then print "No path found"
endif
return -1
end function

function findlowerneighbour(node() as _node, curr as _cords,mx as short,my as short) as short
    dim as short x,y
    dim as _cords p
    dim value as single
    value=node(node(curr.x,curr.y).parent.x,node(curr.x,curr.y).parent.y).g
    for x=curr.x-1 to curr.x+1
        for y=curr.y-1 to curr.y+1
            if x>=0 and y>=0 and x<=mx and y<=my then
                if node(x,y).opclo=1 and node(x,y).g<value then
                    
                    p.x=x
                    p.y=y
                    node(curr.x,curr.y).parent.x=x
                    node(curr.x,curr.y).parent.y=y
                    node(curr.x,curr.y).g=node(x,y).g+node(curr.x,curr.y).cost+distance(p,curr)
                    value=node(x,y).g
                endif
            endif
        next
    next
    return 0
end function

function addneighbours(node() as _node, curr as _cords,mx as short,my as short,rollover as byte=0) as short
    dim as short x,y
    dim as single ng
    dim p as _cords
    for x=curr.x-1 to curr.x+1
        for y=curr.y-1 to curr.y+1
            if (rollover=0 and x>=0 and y>=0 and x<=mx and y<=my) or rollover=1 then
                if rollover=1 then
                    if x<0 then x=mx
                    if x>mx then x=0
                endif
                if node(x,y).opclo=0  then 
                    node(x,y).opclo=1
                    p.x=x
                    p.y=y
                    node(x,y).parent.x=curr.x
                    node(x,y).parent.y=curr.y
                    node(x,y).g=node(curr.x,curr.y).g+distance(p,curr)+node(x,y).cost
                endif
            endif
        next
    next
    return 0
end function

function manhattan(a as _cords,b as _cords) as single
    return abs(a.x-b.x)+abs(a.y-b.y)
end function
