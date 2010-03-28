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
                    if specialplanet(c)=map(a).planets(b) and specialplanet(c)>0 then sp(c)=sp(c)+1
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

function nearestbase(c as _cords) as short
    dim r as single
    dim a as short
    dim b as short
    r=65
    for a=0 to 2
        if distance(c,basis(a).c)<r then 
            r=distance(c,basis(a).c)
            b=a
        endif
    next
    return b
end function

function disnbase(c as _cords) as single
    dim r as single
    dim a as short
    r=65
    for a=0 to 2
        if distance(c,basis(a).c)<r then r=distance(c,basis(a).c)
    next
    return r
end function

function dispbase(c as _cords) as single
    dim as single r,r2
    dim a as short
    r=65
    for a=0 to _NoPB
        if piratebase(a)>0 then
            r2=distance(c,map(piratebase(a)).c)
        endif
    next
    return r2
end function 

function findrect(tile as short,map() as short,er as short=10,fi as short=60) as _rect
    dim as _rect best,current
    dim as short x,y,x2,y2,com,dx,dy,u,besta
    
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

function countdeadofficers(max as short) as short
    dim r as short
    dim all as short
    dim a as short
    dim o as short
    for a=1 to 6
        if crew(a).hp<=0 and crew(1).onship=0 then o+=1
    next
    if max>=7 then
        for a=7 to max
            if crew(a).hp>0 and crew(1).onship=0 then r+=1
        next
    else
        r=-1
    endif
    if o=0 then
        return 0
    endif

    if r=-1 then 
        return 0
    else
        if crew(1).hp<=0 then 
            o=o+5
        else
            o-=1
        endif
        return r-o*10
    endif
        
    return r
end function

function movepoint(byval c as _cords, a as short, eo as short=0, border as short=0) as _cords
    dim p as _cords
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
    dim as short illu
    dim as short x2,x1,y2,y1,mx,my
    Dim As Integer i, deltax, deltay, numtiles
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    dim as byte mask
    dim as _cords p
    x1=a.c.x
    y1=a.c.y
    if m>0 then
        illu=10-a.dark
        if a.light>illu then illu=a.light
        if a.sight>illu then a.sight=illu
        if a.sight<2 then a.sight=2
        mx=60
        my=20
    else
        mx=sm_x
        my=sm_y
    endif
    
    for x=a.c.x-12 to a.c.x+12 step 2
        for y=a.c.y-12 to a.c.y+12 step 2
            if x=a.c.x-12 or x=a.c.x+12 or y=a.c.y-12 or y=a.c.y+12 or x=0 or y=my or x=mx or x=0 then    
                'if x>=0 and x<=79 and y>=0 and y<=25 then level(l).vis(x,y)=1
                
                mask=1
                x2=x
                y2=y
                x1=a.c.x
                y1=a.c.y
                d=abs(x1-x2)
                if abs(y1-y2)>d then d=abs(y1-y2)
                for i=0 to d*2
                    x1=x1+(x2-x1)*i/(d*2)
                    y1=y1+(y2-y1)*i/(d*2)
                    p.x=x1
                    p.y=y1
                    if x1>=0 and x1<=mx and y1>=0 and y1<=my and (x1<>a.c.x or y1<>a.c.y) then
                        if m>0 then
                            vismask(x1,y1)=mask
                            if tmap(x1,y1).seetru=1 or distance(a.c,p)>a.sight then 
                                mask=0
                            else
                                if x1<mx then vismask(x1+1,y1)=mask
                                if x1>0 then vismask(x1-1,y1)=mask
                                if y1<my then vismask(x1,y1+1)=mask
                                if y1>0 then vismask(x1,y1-1)=mask
                            endif
                        else
                            vismask(x1,y1)=mask
                            If spacemap(x1,y1)>1 or distance(a.c,p)>a.sight Then
                                mask=0
                            else
                                if x1<mx then vismask(x1+1,y1)=mask
                                if x1>0 then vismask(x1-1,y1)=mask
                                if y1<my then vismask(x1,y1+1)=mask
                                if y1>0 then vismask(x1,y1-1)=mask
                            endif
                        endif
                    endif
                next
            endif
        next
    next
    
    for x2=a.c.x-1 to a.c.x+1
        for y2=a.c.y-1 to a.c.y+1
            if x2>=0 and y2>=0 and x2<=mx and y2<=my then vismask(x2,y2)=1
        next
    next
    
    return 0
end function

'
'function makevismask(vismask()as byte,byval a as _monster,m as short) as short
'    dim as single dx,dy 'delta
'    dim as single cx,cy 'center
'    dim as single ex,ey
'    dim as short mx,my
'    dim l as short
'    dim length as single
'    dim dis as single 
'    dim as short yt,yb,xr,xl 'Y top, Y bottom, Xright, Xleft
'    dim as single x,y 'point we are looking at
'    dim as _cordsp
'    dim as short tile
'    dim as short mask
'    cx=a.c.x
'    cy=a.c.y
'    yt=cy-10
'    yb=cy+10
'    xl=cx-10
'    xr=cx+10
'    
'    if m>0 then
'        a.dark=a.dark-a.light
'        if a.dark<0 then a.dark=0
'        a.sight=a.sight-a.dark
'        if a.sight<2 then a.sight=2
'        mx=60
'        my=20
'    else
'        mx=sm_x
'        my=sm_y
'    endif
'    if yt<0 then yt=0
'    if xl<0 then xl=0
'    if m>0 then
'        if yb>20 then yb=20
'        if xr>60 then xr=60
'    else
'        if yb>sm_y then yb=sm_y
'        if xr>sm_x then xr=sm_x
'    endif
'    'clear old
'    for x=0 to mx
'        for y=0 to my
'            vismask(x,y)=0
'            p.x=x
'            p.y=y
'            if distance(p,a.c)<=a.sight or distance(p,a.c)<1.5 then vismask(x,y)=1
'        next
'    next
'    for ex=xl to xr 
'        for ey=yt to yb 
'            if ex=xl or ex=xr or ey=yt or ey=yb then  
'                mask=1
'                x=cx
'                y=cy
'                dx=ex-cx
'                dy=ey-cy
'                length=sqr((dx*dx)+(dy*dy))
'                dx=dx/length
'                dy=dy/length
'                for l=1 to length
'                    x=x+dx
'                    y=y+dy
'                    dis=sqr(((cx-x)*(cx-x))+((cy-y)*(cy-y)))                    
'                    if x>=0 and y>=0 and x<=mx and y<=my then    
'                        if dis>a.sight  then mask=0
'                        if vismask(x,y)=1 then vismask(x,y)=mask
'                        if m>0 then
'                            if tmap(x,y).seetru=1 then mask=0
''                            if tiles(tile).seetru=0 and mask=1 then
''                                if x-1>=0 then vismask(x-1,y)=1
''                                if x+1<=mx then vismask(x+1,y)=1
''                                if y-1>=0 then vismask(x,y-1)=1
''                                if y+1<=my then vismask(x,y+1)=1
''                            endif
'                        else
'                            if abs(spacemap(x,y))=2 then mask=0
'                        endif
'                    endif
'                next
'    
'            endif
'        next
'    next
'    for x=0 to mx
'        for y=0 to my
'            p.x=x
'            p.y=y
'            if distance(p,a.c)>a.sight then vismask(x,y)=0
'        next
'    next
'    
'    for x=cx-1 to cx+1
'        for y=cy-1 to cy+1
'            if x>=0 and y>=0 and x<=mx and y<=my then vismask(x,y)=1
'        next
'    next
'    return 0
'end function

function nextpoint(byval start as _cords, byval target as _cords) as _cords
    dim as short dx,dy,d,x1,x2,y1,y2 
    x1=start.x
    y1=start.y
    d=abs(x1-x2)
    if abs(y1-y2)>d then d=abs(y1-y2)
    start.x=x1+(x2-x1)/d
    start.y=y1+(y2-y1)/d
    return start
end function


function pathblock(byval c as _cords,byval b as _cords,mapslot as short,blocktype as short=1,col as short=0) as short
    dim as single px,py
    dim deltax as single
    dim deltay as single
    dim numtiles as single
    dim l as single
    dim  as short result
    dim text as string
    dim as short co,i
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    
    deltax = Abs(c.x - b.x)
    deltay = Abs(c.y - b.y)
    if col>0 then screenset 1,1
    If deltax >= deltay Then
        numtiles = deltax + 1
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay + 1
        d = (2 * deltax) - deltay
        dinc1 = deltax Shl 1
        dinc2 = (deltax - deltay) Shl 1
        xinc1 = 0
        xinc2 = 1
        yinc1 = 1
        yinc2 = 1
    End If

    If c.x > b.x Then
        xinc1 = - xinc1
        xinc2 = - xinc2
    End If
   
    If c.y > b.y Then
        yinc1 = - yinc1
        yinc2 = - yinc2
    End If

    x = c.x
    y = c.y
    result=-1
    For i = 1 To numtiles
        
        If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
        Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
    
            if blocktype=1 or blocktype=3 then 'check for firetru
               if x<0 then x=0
               if x>60 then x=60
               if y<0 then y=0
               if y>20 then y=20
               if tmap(x,y).firetru=1  then 
                    if not (x=b.x and y=b.y) then
                        result=0
                        if blocktype=3 then
                           b.x=x
                           b.y=y
                           return 0
                        endif
                    endif
               endif
                if col>0 then 
                    locate y+1,x+1
                    color col,0
                    print "*"
                    sleep 100
                endif
            endif
            if blocktype=2 then
                if x<0 then x=0
                if x>60 then x=60
                if y<0 then y=0
                if y>20 then y=20
                if combatmap(x,y)=7 or combatmap(x,y)=8 then
                    combatmap(x,y)=0
                    return 0
                endif
                if col>0 and co<l then 
                    locate y+1,x+1
                    color col,0
                    print "*"
                endif
            endif
        next

    if blocktype=2 then sleep 150
    return result
end function


function nearest(c as _cords, b as _cords) as single
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


function farthest(c as _cords, b as _cords) as single
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

function rnd_point(m as short=-1,w as short=-1,t as short=0)as _cords
    dim p(1281) as _cords
    dim as short last,x,y,a
    if m>-1 and w>-1 then
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
    if m>0 and t>0 then
        for x=0 to 60
            for y=0 to 20
                if tiles(abs(planetmap(x,y,m))).walktru=t then
                    p(a).x=x
                    p(a).y=y
                    a=a+1
                endif
            next
        next
        if a>0 then return p(rnd_range(0,a-1))
    endif
    
    p(0).x=rnd_range(0,60)
    p(0).y=rnd_range(0,20)
    return p(0)
end function

function rndrectwall(r as _rect,d as short=5) as _cords
    dim p as _cords
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

function chksrd(p as _cords, slot as short) as short'Returns the sum of tile values around a point, -1 if at a border
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

function distributepoints(result() as _cords, ps() as _cords, last as short) as single
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
