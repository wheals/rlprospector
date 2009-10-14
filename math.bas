declare function fixstarmap() as short


function sub0(a as single,b as single) as single
    dim c as single
    c=a-b
    if c<0 then c=0
    return c
end function

function fixstarmap() as short
    dim p(2048) as short
    dim sp(lastspecial) as short
    dim as short a,b,c,fixed,fsp
    for a=0 to laststar
        for b=1 to 9
            if map(a).planets(b)>0 then
                p(map(a).planets(b))+=1
                if p(map(a).planets(b))>1  then
                    lastplanet=lastplanet+1
                    fixed=fixed+1
                    map(a).planets(b)=lastplanet
                endif
                for c=0 to lastspecial
                    if specialplanet(c)=map(a).planets(b) then sp(c)=sp(c)+1
                next
            endif
        next
    next
    for c=0 to lastspecial
        if sp(c)=0 then 
            fsp=fsp+1
        endif
    next
    if fsp>1 then
        color 14,0
        print fsp &"specials missing. ";
    endif
    if fixed>0 then
        color 14,0
        print fixed &" fixed."
        color 14,0
    else
        color 10,0
        print "All Ok"
        color 14,0
    endif
    return 0
end function



function disnbase(c as cords) as single
    dim r as single
    dim a as short
    r=65
    for a=0 to 2
        if distance(c,basis(a).c)<r then r=distance(c,basis(a).c)
    next
    return r
end function

function dispbase(c as cords) as single
    dim r as single
    dim a as short
    r=65
    for a=0 to _NoPB
        if distance(c,map(piratebase(a)).c)<r then r=distance(c,map(piratebase(a)).c)
    next
    return r
end function 

function findrect(tile as short,map() as short,er as short=10,fi as short=60) as _rect
    dim as _rect best,current
    dim as short x,y,x2,y2,com,dx,dy,u,besta
    
    '
    ' er = fehlerrate, up to er sqares may be something else
    ' fi = stop looking if one is larger than fi
    
    
    besta=15
    for x=0 to 60
        for y=0 to 20
            for x2=x+3 to 60
                for y2=y+3 to 20
                    current.x=x
                    current.y=y
                    current.w=x2-x
                    current.h=y2-y
                    if current.w*current.h>besta then
                        if map(current.x,current.y)=tile and  map(current.x+current.w,current.y)=tile and  map(current.x,current.y+current.h)=tile and  map(current.x+current.w,current.y+current.h)=tile then
                            if content(current,tile,map())<=er then 
                                best=current
                                besta=best.h*best.w
                                if besta>fi then exit for,for,for,for
                            endif
                        endif
                    endif
                next
            next
        next
    next
    return best
end function

function content(r as _rect,tile as short,map()as short) as integer
    dim as short con,x,y
    for x=r.x to r.x+r.w
      for y=r.y to r.y+r.h
          if map(x,y)<>tile then con=con+1
      next
    next
    return con
end function

function maximum(a as double,b as double) as double
    if a>b then return a
    if b>a then return b
    if a=b then return a
end function

function minimum(a as double,b as double) as double
    if a<b then return a
    if b<a then return b
    if a=b then return a
end function


function distance(first as cords, last as cords) as single
    dim dis as double
    dis=(first.x-last.x)*(first.x-last.x)
    dis=dis+(first.y-last.y)*(first.y-last.y)
    dis=sqr(dis)
    return dis
end function

Function rnd_range (first As short, last As short) As short
        return cint(Rnd * (last - first) + first)
End Function

function getany(possible() as short) as short
    dim r as short
    dim mat1(3,3) as short
    dim sam(9) as short
    dim a as short
    dim x as short
    dim y as short
    mat1(1,1)=7
    mat1(1,2)=8
    mat1(1,3)=9
    
    mat1(2,1)=4
    mat1(2,2)=0
    mat1(2,3)=6
    
    mat1(3,1)=1
    mat1(3,2)=2
    mat1(3,3)=3
    for x=1 to 3
        for y=1 to 3
            if possible(x,y)=0 then
                a=a+1
                sam(a)=mat1(x,y)
            endif
        next
    next
    if a>0 then
        r=sam(rnd_range(1,a))
    else
        r=0
    endif
    return r
end function

function movepoint(byval c as cords, a as short, eo as short=0, border as short=0) as cords
    dim p as cords
    static statistics(9) as integer
    dim as short x,y
    dim f as integer
    if border=0 then
        x=60
        y=20
    else
        x=sm_x
        y=sm_y
    endif
        
    if a=5 then
        a=rnd_range(1,8)
        if a=5 then a=9
    endif
    statistics(a)=statistics(a)+1
    p=c
    if a=1 then
        c.x=c.x-1
        c.y=c.y+1
    endif
    if a=2 then
        c.x=c.x
        c.y=c.y+1
    endif
    if a=3 then
        c.x=c.x+1
        c.y=c.y+1
    endif
    if a=4 then
        c.x=c.x-1
        c.y=c.y
    endif
    if a=6 then
        c.x=c.x+1
        c.y=c.y
    endif
    if a=7 then
        c.x=c.x-1
        c.y=c.y-1
    endif
    if a=8 then
        c.x=c.x
        c.y=c.y-1
    endif
    if a=9 then
        c.x=c.x+1
        c.y=c.y-1
    endif
    if eo=0 then
        if c.x<0 then c.x=0
        if c.x>x then c.x=x
        if c.y<0 then c.y=0
        if c.y>y then c.y=y
    endif
    if eo=1 then
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
        if c.y<0 then c.y=y
        if c.y>y then c.y=0
    endif
    if eo=2 then
        if c.x<0 or c.x>x then c=p
        if c.y<0 or c.y>y then c=p
    endif
    return c
end function

function makevismask(vismask()as byte,byval a as _monster,m as short) as short
    dim as single dx,dy 'delta
    dim as single cx,cy 'center
    dim as single ex,ey
    dim as short mx,my
    dim l as short
    dim length as single
    dim dis as single 
    dim as short yt,yb,xr,xl 'Y top, Y bottom, Xright, Xleft
    dim as single x,y 'point we are looking at
    dim as cords p
    dim as short tile
    dim as short mask
    cx=a.c.x
    cy=a.c.y
    yt=cy-10
    yb=cy+10
    xl=cx-10
    xr=cx+10
    
    if m>0 then
        a.sight=a.sight-sub0(a.dark,a.light)
        if a.sight<2 then a.sight=2
        mx=60
        my=20
    else
        mx=sm_x
        my=sm_y
    endif
    if yt<0 then yt=0
    if xl<0 then xl=0
    if m>0 then
        if yb>20 then yb=20
        if xr>60 then xr=60
    else
        if yb>sm_y then yb=sm_y
        if xr>sm_x then xr=sm_x
    endif
    'clear old
    for x=0 to mx
        for y=0 to my
            vismask(x,y)=0
            p.x=x
            p.y=y
            if distance(p,a.c)<=a.sight or distance(p,a.c)<1.5 then vismask(x,y)=1
        next
    next
    for ex=xl to xr 
        for ey=yt to yb 
            if ex=xl or ex=xr or ey=yt or ey=yb then  
                mask=1
                x=cx
                y=cy
                dx=ex-cx
                dy=ey-cy
                length=sqr((dx*dx)+(dy*dy))
                dx=dx/length
                dy=dy/length
                for l=1 to length
                    x=x+dx
                    y=y+dy
                    dis=sqr(((cx-x)*(cx-x))+((cy-y)*(cy-y)))                    
                    if x>=0 and y>=0 and x<=mx and y<=my then    
                        if dis>a.sight  then mask=0
                        if vismask(x,y)=1 then vismask(x,y)=mask
                        if m>0 then
                            if tmap(x,y).seetru=1 then mask=0
'                            if tiles(tile).seetru=0 and mask=1 then
'                                if x-1>=0 then vismask(x-1,y)=1
'                                if x+1<=mx then vismask(x+1,y)=1
'                                if y-1>=0 then vismask(x,y-1)=1
'                                if y+1<=my then vismask(x,y+1)=1
'                            endif
                        else
                            if abs(spacemap(x,y))=2 then mask=0
                        endif
                    endif
                next
    
            endif
        next
    next
    for x=0 to mx
        for y=0 to my
            p.x=x
            p.y=y
            if distance(p,a.c)>a.sight then vismask(x,y)=0
        next
    next
    
    for x=cx-1 to cx+1
        for y=cy-1 to cy+1
            if x>=0 and y>=0 and x<=mx and y<=my then vismask(x,y)=1
        next
    next
    return 0
end function

function pathblock(byval c as cords,byval b as cords,mapslot as short,blocktype as short=1,col as short=0) as short
    dim as single px,py
    dim dx as single
    dim dy as single
    dim l as single
    dim result as short
    dim text as string
    dim as short co
    l=distance(c,b)
    dx=(c.x-b.x)/l
    dy=(c.y-b.y)/l
    px=b.x
    py=b.y
    result=-1
    if l>1.5 then
        for co=0 to l
            if blocktype=1 then 'check for firetru
               if px<0 then px=0
               if px>60 then px=60
               if py<0 then py=0
               if py>20 then py=20
               if tiles(abs(planetmap(px,py,mapslot))).firetru=1 then 
                   result=0
               endif
                if col>0 then 
                    locate py+1,px+1
                    color col,0
                    print "*"
                    sleep 100
                endif
            endif
            px=px+dx
            py=py+dy
            if blocktype=2 then
                if px<0 then px=0
                if px>60 then px=60
                if py<0 then py=0
                if py>20 then py=20
                if combatmap(px,py)=7 or combatmap(px,py)=8 then
                    combatmap(px,py)=0
                    return 0
                endif
                if col>0 and co<l then 
                    locate py+1,px+1
                    color col,0
                    print "*"
                endif
            endif
        next
    endif
    if blocktype=2 then sleep 150
    return result
end function


function nearest(c as cords, b as cords) as single
    ' Moves B towards C, or C away from B
    dim direction as short
    if c.x>b.x and c.y>b.y then direction=3
    if c.x>b.x and c.y=b.y then direction=6
    if c.x>b.x and c.y<b.y then direction=9
    
    if c.x=b.x and c.y>b.y then direction=2
    if c.x=b.x and c.y<b.y then direction=8
    
    if c.x<b.x and c.y=b.y then direction=4
    if c.x<b.x and c.y<b.y then direction=7
    if c.x<b.x and c.y>b.y then direction=1
    return direction
end function


function farthest(c as cords, b as cords) as single
    dim direction as short
    if c.x>b.x and c.y>b.y then direction=3
    if c.x>b.x and c.y=b.y then direction=6
    if c.x>b.x and c.y<b.y then direction=9
    
    if c.x=b.x and c.y>b.y then direction=8
    if c.x=b.x and c.y<b.y then direction=2
    
    if c.x<b.x and c.y=b.y then direction=4
    if c.x<b.x and c.y<b.y then direction=7
    if c.x<b.x and c.y>b.y then direction=1
    return direction
end function


function fill_rect(r as _rect,wall as short, floor as short,map() as short) as short
    dim as short x,y 
    for x=r.x to r.x+r.w
        for y=r.y to r.y+r.h
            
            if x=r.x or y=r.y or x=r.x+r.w or y=r.y+r.h then
                map(x,y)=wall
            else 
                map(x,y)=floor
            endif
        next
    next
    return 0
end function

function rnd_point(m as short=-1,w as short=-1)as cords
    dim p(1281) as cords
    dim as short last,x,y,a
    if m=-1 and w=-1 then
        p(0).x=rnd_range(0,60)
        p(0).y=rnd_range(0,20)
        return p(0)
    else
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,m))).walktru=w then
                    p(a).x=x
                    p(a).y=y
                    a=a+1
                endif
            next
        next
        if a>0 then return p(rnd_range(0,a-1))
    endif
    dprint "Error looking for point",14,14
end function

function rndrectwall(r as _rect,d as short=5) as cords
    dim p as cords
    if d=5 then 
        do
            d=rnd_range(1,8)
            if d=4 then d=d+1
        loop until frac(d/2)=0
    endif
    if d=1 then
        p.x=r.x
        p.y=r.y+r.h
    endif
    if d=2 then 
        p.y=r.y+r.h
        p.x=rnd_range(r.x+1,r.x+r.w-2)
    endif 
    if d=3 then
        p.x=r.x+r.h
        p.y=r.y+r.h
    endif
    if d=4 then
        p.x=r.x
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    if d=6 then
        p.x=r.x+r.w
        p.y=rnd_range(r.y+1,r.y+r.h-2)
    endif
    if d=7 then
        p.x=r.x
        p.y=r.y
    endif
    if d=8 then
        p.x=rnd_range(r.x+1,r.x+r.w-2)
        p.y=r.y
    endif
    if d=9 then
        p.x=r.x+r.w
        p.y=r.y+r.h
    endif
    return p
end function

function chksrd(p as cords, slot as short) as short'Returns the sum of tile values around a point, -1 if at a border
    dim r as short
    dim as short x,y
    for x=p.x-1 to p.x+1
        for y=p.y-1 to p.y-1
            if x<0 or y<0 or x>60 or y>20 then 
                return -1
            else
                r=r+abs(planetmap(x,y,slot))
            endif
        next
    next
    return r
end function

function distributepoints(result() as cords, ps() as cords, last as short) as single
    dim re as single
    dim a as short
    dim b as short
    dim doubl(last) as short
    dim countr as short
    
    do 
        countr=0
        for a=0 to last
            doubl(a)=0
        next
        for a=0 to last
            for b=0 to last
                if a<>b then
                    if ps(a).x=ps(b).x and ps(a).y=ps(b).y then
                        doubl(a)=1
                        countr=countr+1
                    endif
                endif
            next
        next
        for a=0 to last
            if doubl(a)=1 then
                ps(a)=movepoint(ps(a),5,,1)
            endif
        next
    loop until countr=0
    for a=0 to last
        result(a)=ps(a)
    next
    return re
end function
