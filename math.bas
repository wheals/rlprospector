function get_biodata(e as _monster) as integer
    if e.hp>0 then
        return (50)*(1+e.stunres/2)*e.biomod+cint(2*e.biomod*(e.hpmax^2)/3)
    else
        return e.biomod*(e.hpmax^2/3)
    endif
end function

function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short
    dim as short sort,i
    dim as byte debug=1
    do
        sort=0
        for i=1 to last-1
            if distance(c,p(i))>distance(c,P(i+1)) then
                sort=1
                swap p(i),p(i+1)
                swap l(i),l(i+1)
            endif
        next
    loop until sort=0
    if debug=1 and _debug=1 then
        for i=1 to last
            dprint i &":"&int(distance(c,p(i)))
        next
    endif
    
    return 0
end function

function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short
    dim as single dis
    dim as short i,res
    for i=1 to last
        if distance(list(i),a)+distance(list(i),b)>dis then
            dis=distance(list(i),a)+distance(list(i),b)
            res=i
        endif
    next
    return res
end function

function urn(min as short, max as short,mult as short,bonus as short) as short 
    dim as short values(1024),v,st,i,j,e,f,r
    if min>max then 
        st=-1
    else
        st=1
    endif
    for i=min to max step st
        e+=1
        for j=1 to e
            f+=1
            values(f)=i
        next
    next
    r=rnd_range(1,f)+bonus
    if r>f then r=f
    if r<1 then r=1
    return values(r)
end function


declare function fixstarmap() as short
    
function C_to_F(c as single) as single
    return round_nr(c*1.8+32,1)
end function

function round_nr(i as single,c as short) as single
    i=i*(10^c)
    i=int(i)
    i=i/(10^c)
    return i
end function

function find_high(list() as short,last as short, start as short=1) as short
    dim as short i,m,r
    for i=1 to last
        if list(i)>m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function find_low(list() as short,last as short,start as short=1) as short
    dim as short i,m,r
    m=32767
    for i=start to last
        if list(i)<m then
            r=i
            m=list(i)
        endif
    next
    return r
end function

function sub0(a as single,b as single) as single
    dim c as single
    c=a-b
    if c<0 then c=0
    return c
end function

function calcosx(x as short,wrap as byte) as short 'Caculates Ofset X for windows less than 60 tiles wide
    dim osx as short
    osx=x-_mwx/2
    if wrap>0 then
        if osx<0 then osx=0
        if osx>60-_mwx then osx=60-_mwx
    endif
    if _mwx=60 then osx=0
    return osx
end function

function fixstarmap() as short
    dim p(2048) as short
    dim sp(lastspecial) as short
    dim as string l
    dim as short a,b,c,fixed,fsp,pis,newfix,cc,spfix, debug,f
        
    do
        cc+=1
        newfix=0
        
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)>0 then
                    p(map(a).planets(b))=0
                endif
            next
        next
        
        for a=0 to laststar
            pis=0
            for b=1 to 9
                if map(a).planets(b)>0 then
                    pis+=1
                    p(map(a).planets(b))+=1
                    if p(map(a).planets(b))>1  then
                        newfix+=1
                        lastplanet=lastplanet+1
                        fixed=fixed+1
                        map(a).planets(b)=lastplanet
                        p(lastplanet)+=1
                    endif
                    for c=0 to lastspecial
                        if specialplanet(c)=map(a).planets(b) and specialplanet(c)>0 then sp(c)=sp(c)+1
                    next
                endif
            next
            if map(a).spec=8 and pis=0 then 
                fixed+=1
                newfix+=1
                lastplanet+=1
                p(lastplanet)+=1
                map(a).planets(1)=lastplanet
            endif
        next
    loop until newfix=0
    for c=0 to lastspecial
        if sp(c)=0 then 
            fsp=fsp+1
        endif
    next
    for c=0 to lastspecial
        if specialplanet(c)>0 and specialplanet(c)<max_maps then
            if planetmap(0,0,specialplanet(c))<>0 then spfix+=1
            planetmap(0,0,specialplanet(c))=0
        endif
    next
    for a=0 to laststar
        map(a).ti_no=map(a).spec+68
        if map(a).spec=8 then map(a).ti_no=rnd_range(33,38)
        if map(a).spec=10 then map(a).ti_no=89
    next
    return 0
end function

function nearest_base(c as _cords) as short
    dim r as single
    dim a as short
    dim b as short
    r=650
    for a=0 to 2
        if distance(c,basis(a).c)<r then 
            r=distance(c,basis(a).c)
            b=a
        endif
    next
    return b
end function

function disnbase(c as _cords,weight as short=2) as single
    dim r as single
    dim a as short
    r=65
    for a=0 to 2
        if distance(c,basis(a).c)<r then r=distance(c,basis(a).c)
    next
    for a=1 to 3
        if distance(c,fleet(a).c)*weight<r then r=distance(c,fleet(a).c)*2
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


function distance(first as _cords, last as _cords,rollover as byte=1) as single
    dim as single dis,dx,dy,dx2
    dx=first.x-last.x
    dy=first.y-last.y
    if rollover=0 then
        dx2=61-abs(first.x-last.x)
        if abs(dx)>abs(dx2) then dx=dx2
    endif
    dis=sqr(dx*dx+dy*dy)
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
    if crew(1).hp>0 then return 0
    for a=2 to 6
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
    if eo=3 then
        if c.y<0 then c.y=0
        if c.y>y then c.y=y
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
    endif
    if eo=4 then
        if c.y<0 then c.y=0
        if c.y>20 then c.y=20
        if c.x<0 then c.x=x
        if c.x>x then c.x=0
    endif
    return c
end function

function calc_sight() as short
    dim as byte darkness,sight,binocbonus
    darkness=awayteam.dark
    sight=awayteam.sight
    if darkness>0 then
        sight=sight-darkness
        if sight<0 then sight=0
        if awayteam.light>0 then 
            sight=awayteam.light 'Lamps always illuminate the same area
            if findbest(8,-1)>0 then 'But maybe they illuminate more than we can see
                binocbonus=item(findbest(8,-1)).v1
            endif
            
            if 3+binocbonus>awayteam.light then
                sight=awayteam.light
            else
                sight=3+binocbonus
            endif
        
        endif
    endif
    return sight
end function


function make_vismask(c as _cords, sight as short,m as short,ad as short=0,groundpen as short=0) as short
    dim as short illu
    dim as short x,y,x1,y1,x2,y2,mx,my,i,d,grr,rollover,gprange
    dim as byte mask
    dim as _cords p,pts(128)
    x1=c.x
    y1=c.y
    if m>0 then
        if planets(m).depth>0 then rollover=1
        mx=60
        my=20
        if sight=0 then sight=calc_sight
        if _debug>0 then dprint "Rollover:"&rollover
    else
        mx=sm_x
        my=sm_y
    endif
    if ad=0 then
        for x=0 to mx
            for y=0 to my
                vismask(x,y)=-1
            next
        next
    endif
    
    for x=c.x-12 to c.x+12 
        for y=c.y-12 to c.y+12 
            if x=c.x-12 or x=c.x+12 or y=c.y-12 or y=c.y+12 then
                mask=1
                p.x=x
                p.y=y
                d=line_in_points(p,c,pts(),1)
                gprange=groundpen
                for i=1 to d
                    if distance(c,pts(i),rollover)<=sight then
                        if m>0 then
                            if rollover=0 then
                                if pts(i).x>60 then pts(i).x-=61
                                if pts(i).x<0 then pts(i).x+=61
                            else
                                if pts(i).x>60 then pts(i).x=60
                                if pts(i).x<0 then pts(i).x=0
                            endif
                            if pts(i).y>=0 and pts(i).y<=20 then
                                vismask(pts(i).x,pts(i).y)=mask
                                if tmap(pts(i).x,pts(i).y).seetru>0 then 
                                    mask=0
                                    gprange-=1
                                endif
                                if tmap(pts(i).x,pts(i).y).seetru>0 and gprange>0 then mask=1    
                            endif
                        else
                            if pts(i).x>=0 and pts(i).x<=mx and pts(i).y>=0 and pts(i).y<=my then
                                vismask(pts(i).x,pts(i).y)=mask
                                if spacemap(pts(i).x,pts(i).y)>1 then mask=0
                            endif
                        endif
                    endif
                next
                
            endif
        next
    next
    vismask(c.x,c.y)=1
    if _debug=1 then
        for x=0 to 60
            for y=0 to 20
                if vismask(x,y)>0 then pset(x+60,y)
            next
        next
    endif
'            if (y>=0 and x>=0 and y<=my and x<=mx) or m>0 then
'                p.x=x
'                p.y=y
'                if p.x<0 then p.x=60-x
'                if p.x>60 then p.x=x-60
'                if vismask(p.x,p.y)=-1 then
'                    mask=1
'                    x2=x
'                    y2=y
'                    x1=a.c.x
'                    y1=a.c.y
'                    if distance(p,a.c)<=a.sight then
'                        d=abs(x1-x2)
'                        if abs(y1-y2)>d then d=abs(y1-y2)
'                        for i=0 to d*2
'                            p.x=x1
'                            p.y=y1
'                            if x1>=0 and x1<=mx and y1>=0 and y1<=my and (x1<>a.c.x or y1<>a.c.y) then
'                                if m>0 then
'                                    if tmap(x1,y1).seetru>0 or (tmap(x1,y1).seetru>0 and tmap(x1,y1).dr>grr) then mask=0
'                                else
'                                    If abs(spacemap(x1,y1))>1 Then mask=0
'                                endif
'                            endif
'                            x1=x1+(x2-x1)*i/(d*2)
'                            y1=y1+(y2-y1)*i/(d*2)
'                        next
'                        vismask(x,y)=mask
'                    endif
'                endif
'            endif
'        next
'    next
'
'    for x2=a.c.x-1 to a.c.x+1
'        for y2=a.c.y-1 to a.c.y+1
'            if x2>=0 and y2>=0 and x2<=mx and y2<=my then vismask(x2,y2)=1
'        next
'    next
'    
'    for x=0 to a.c.x
'        for y=0 to a.c.y
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    
'    for x=mx to a.c.x step -1
'        for y=0 to a.c.y
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    for x=0 to a.c.x 
'        for y=my to a.c.y step -1
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'    
'    for x=mx to a.c.x step -1
'        for y=my to a.c.y step -1
'            vistest(a,m,mx,my,x,y,vismask())
'        next
'    next
'            
'    flood_fill2(a.c.x,a.c.y,mx,my,vismask())
'    for x=0 to mx
'        for y=0 to my
'            if vismask(x,y)=1 then vismask(x,y)=0
'            if vismask(x,y)=2 then vismask(x,y)=1
'        next
'    next
    return 0
end function

function vis_test(a as _cords,p as _cords,test as short) as short
    dim as short x1,x2
    x1=a.x-_mwx/2
    x2=a.x+_mwx/2
    if test=0 then 'Surface, can Wrap
        if x1<0 or x2>60 then 'Wraps
            if x1<0 then x1+=61
            if x2>60 then x2-=61
            'dprint "X1:"&x1 &"X2:"& x2 &":"& p.x
            if p.x>=x1 then return -1
            'dprint "not p.x>=x1" &p.x &":"&x1
            if p.x<=x2 then return -1
            'dprint "not p.x<=x2"&p.x &":"&x2
            return 0
        else 'Doesn't Wrap
            if p.x>=x1 and p.x<=x2 then return -1
            return 0
        endif
    else 'Below Surface, doesn't wrap
        if x1<0 then x1=0
        if x2>60 then x2=60
        if p.x>=x1 and p.x<=x2 then return -1
        return 0
    endif
end function


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


function pathblock(byval c as _cords,byval b as _cords,mapslot as short,blocktype as short=1,col as short=0, delay as short=25,rollover as byte=0) as short
    dim as single px,py
    dim deltax as single
    dim deltay as single
    dim numtiles as single
    dim l as single
    dim  as short result
    dim text as string
    dim as short co,i,osx
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    dim debug as short
    
    if abs(c.x-b.x)>30 then
        if c.x>b.x then
            b.x+=61
        else
            c.x+=61
        endif
    endif
    osx=calcosx(awayteam.c.x,rollover)
    deltax = Abs(c.x - b.x)
    deltay = Abs(c.y - b.y)
    If deltax >= deltay Then
        numtiles = deltax 
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay 
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
        if rollover>0 then 
            if x<0 then x=0
            if x>60 then x=60
        else
            if x>60 then x-=61
            if x<0 then x+=61
        endif
        
        if y<0 then y=0
        if y>20 then y=20
        
        if blocktype=1 or blocktype=3 or blocktype=4 then 'check for firetru
           if tmap(x,y).firetru=1  then 
                if not (x=b.x and y=b.y) then
                    result=0
                    if blocktype=3 or blocktype=4 then
                       b.x=x
                       b.y=y
                       return 0
                    endif
                endif
            endif
            if col>0 then 
                if configflag(con_tiles)=0 then
                    put((x-osx)*_fw1,y*_fh1),gtiles(gt_no(75)),trans
                else
                    set__color( col,0)
                    draw string(x*_fw1,y*_fh1),"*",,font1,custom,@_col
                endif
                sleep delay
            endif
        endif
        if blocktype=2 then
            if combatmap(x,y)=7 or combatmap(x,y)=8 then
                combatmap(x,y)=0
                return 0
            endif
            if col>0 and co<l then 
                draw string(x*_fw1,y*_fh1),"*",,font1,custom,@_col
            endif
        endif
        if blocktype=5 then
            if tmap(x,y).seetru<>0 then return -1
        endif
            
    next
    if blocktype=5 then return 0
    if blocktype=2 then sleep delay
    return result
end function

function line_in_points(b as _cords,c as _cords,p() as _cords,rollover as short=1) as short
    dim last as short
    dim as single px,py
    dim deltax as single
    dim deltay as single
    dim numtiles as single
    dim l as single
    dim  as short result
    dim text as string
    dim as short co,i,dx,dx2
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    if rollover=0 then
        dx2=61-abs(b.x-c.x)
        dx=abs(b.x-c.x)
        if dx2<dx then
            b.x-=61
        endif
    endif

    deltax = Abs(c.x - b.x)
    deltay = Abs(c.y - b.y)
    
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
    p(1).x=x
    p(1).y=y
    result=-1
    For i = 2 To numtiles
        
        If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
        Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
        last+=1
        if rollover=0 then
            if x>60 then x=0
            if x<0 then x=60
        endif
        p(last).x=x
        p(last).y=y
    next
    
    return last
end function


function nearest(byval c as _cords, byval b as _cords,rollover as byte=0) as single
    ' Moves B towards C, or C away from B
    dim direction as short
    if rollover=1 then
        if abs(c.x-b.x)>30 then swap c,b
    endif
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

function rnd_point(m as short=-1,w as short=-1,t as short=-1,vege as short=-1)as _cords
    dim p(1281) as _cords
    dim as short last,x,y,a,debug
    if m>0 and w>=0 then
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
    if m>0 and t>0 and w=-1 then
        if debug=1 and _debug=1 then dprint "Looking for tile "&t
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,m))=t then
                    a+=1
                    p(a).x=x
                    p(a).y=y
                endif
            next
        next
        if a=0 and debug=1 and _debug=1 then dprint "No tiles found"
        if a>0 then 
            a=rnd_range(1,a)
            if debug=1 and _debug=1 then dprint "Point returned was "&p(a).x &":"&p(a).y
            return p(a)
        else
            p(0).x=-1
            p(0).y=-1
            return p(0) 
        endif
    endif
    
    if m>0 and vege=1 then 'Return a point with vege>0
        a=0
        for x=0 to 60
            for y=0 to 20
                if tmap(x,y).vege>0 then
                    a+=1
                    p(a).x=x
                    p(a).y=y
                endif
            next
        next
        if a>0 then
            return p(rnd_range(1,a))
        else
            p(0).x=-1
            p(0).y=-1
            return p(0)
        endif
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

function gen_waypoints(queue() as _pfcords,start as _pfcords,goal as _pfcords,map() as byte) as short
    dim as integer s,count,nono,x,y,f
    dim in as integer
    dim path(40680) as _pfcords
    queue(0).x=start.x
    queue(0).y=start.y
    queue(0).i=1
    queue(0).c=1
    if show_NPCs=1 then
        cls
        for x=0 to sm_x
            for y=0 to sm_y
                if map(x,y)>0 then
                    locate y+1,x+1
                    print "#"
                endif
            next
        next
    endif
    do
        nono=0
        for in=0 to 40680
            if queue(in).i=1 then
                nono+=1
                'if queue(in).x=goal.x and queue(in).y=goal.y then 
                if abs(queue(in).x-goal.x)<=pf_stp-1 and abs(queue(in).y-goal.y)<=pf_stp-1 then 
                    queue(in).x=goal.x
                    queue(in).y=goal.y
                    s=in
                    exit for
                endif
                f=checkandadd(queue(),map(),in)
                'if f=0 then exit for
            endif
            if frac(in/100)=0 then print ".";
        next
        count+=1
    loop until s<>0 or count>50
    
    if s=0 then
        print "unable to find path from "&start.x &":"&start.y &" to "&goal.x &":"&goal.y &" in "& count &" attempts"
        queue(0)=start
        queue(1)=goal
        in=1
        return in
    else
        in=0
        path(in)=queue(s)
        do
            path(in+1)=nearlowest(path(in),queue())
            in+=1
        loop until path(in).x=queue(0).x and path(in).y=queue(0).y or in>40680
        for s=0 to in
            queue(s)=path(s)
        next
        for s=in+1 to 40680
            queue(s).i=0
            queue(s).c=0
            queue(s).x=0
            queue(s).y=0
        next
        print "found path with "&in &" waypoints. ";
    endif
    return in
end function

function checkandadd(queue() as _pfcords,map() as byte ,in as short) as short
    dim p as _pfcords
    dim a as short
    p.x=queue(in).x+pf_stp
    p.y=queue(in).y
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x-pf_stp
    p.y=queue(in).y
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x
    p.y=queue(in).y+pf_stp
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    p.x=queue(in).x
    p.y=queue(in).y-pf_stp
    p.c=queue(in).c+1
    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
        'if map(p.x,p.y)=2 then p.c+=1
        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
    endif
    
'    p.x=queue(in).x+1
'    p.y=queue(in).y+1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x-1
'    p.y=queue(in).y+1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x-1
'    p.y=queue(in).y-1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    p.x=queue(in).x+1
'    p.y=queue(in).y-1
'    p.c=queue(in).c+1
'    if p.x>=0 and p.y>=0 and p.y<=sm_y and p.x<=sm_x  then
'        'if map(p.x,p.y)=2 then p.c+=1
'        if map(p.x,p.y)<>2 and check(queue(),p)=0 then a+=add_p(queue(),p)
'    endif
'    
    if show_NPCs=1 then
        locate 16,0
        locate queue(in).y+1,queue(in).x+1
        print "*";
    endif
    'if a>0 then print a &" nodes added from "&queue(in).x &":"&queue(in).y &" value "&queue(in).c
    return a
end function

function check(queue() as _pfcords, p as _pfcords) as short
    dim as integer i
    for i=0 to 40680
        if queue(i).i<>0 then
            if (queue(i).x=p.x and queue(i).y=p.y) and queue(i).c<=p.c then
                return -1
            endif
        endif
    next
    return 0
end function
    
function add_p(queue() as _pfcords,p as _pfcords) as short
    dim i as integer
    for i=0 to 40680
        if queue(i).i=0 then
            queue(i).x=p.x
            queue(i).y=p.y
            queue(i).c=p.c
            queue(i).i=1
            return 1
        endif
    next
    print "Ran out of nodes"
    return 0
end function
    
function nearlowest(p as _pfcords,queue() as _pfcords) as _pfcords
    dim in as integer
    dim pot(20) as _pfcords
    dim pot2(20) as _pfcords
    dim as short b,c,a,v,lo
    dim in2 as short
    for in=0 to 40680
        if abs(p.x-queue(in).x)<=pf_stp and abs(p.y-queue(in).y)<=pf_stp  and queue(in).i<>0 and c<20 then
            c+=1
            pot(c)=queue(in)
        endif
    next
    v=p.c
    if c=0 then
        print "NO LEGAL NODES"
        sleep
    endif
        
    for a=1 to c
        if pot(a).c<v then
            v=pot(a).c
        endif
    next
    for a=1 to c
        if pot(a).c=v then
            b+=1
            pot2(b)=pot(a)
        endif
    next
    if b=0 then
        print "No lower node"
        sleep
    endif
        
    if b>1 then
        return pot2(rnd_range(1,b))
    else
        return pot2(b)
    endif
end function

function factionadd(a as short,b as short, ad as short) as short
    dim as short c
    faction(a).war(b)+=ad
    faction(b).war(a)+=ad
    if faction(a).alli<>0 then 
        c=faction(a).alli
        faction(b).war(c)+=ad
        faction(c).war(b)+=ad
        if faction(b).war(c)>100 then faction(b).war(c)=100
        if faction(c).war(b)>100 then faction(c).war(b)=100
        if faction(b).war(c)<0 then faction(b).war(c)=0
        if faction(c).war(b)<0 then faction(c).war(b)=0
    endif
    if faction(b).alli<>0 then 
        c=faction(b).alli
        faction(a).war(a)+=ad
        faction(c).war(c)+=ad
        if faction(a).war(c)>100 then faction(a).war(c)=100
        if faction(c).war(a)>100 then faction(c).war(a)=100
        if faction(a).war(c)<0 then faction(a).war(c)=0
        if faction(c).war(a)<0 then faction(c).war(a)=0
    endif
    if faction(a).war(b)>100 then faction(a).war(b)=100
    if faction(b).war(a)>100 then faction(b).war(a)=100
    if faction(a).war(b)<0 then faction(a).war(b)=0
    if faction(b).war(a)<0 then faction(b).war(a)=0
    return 0
end function        
