

declare function lb_listmake(lobk() as string, lobn() as short, lobc() as short,lobp() as _cords) as short

function logbook() as short
    cls
    dim lobk(255) as string 'lobk is description
    dim lobn(255) as short 'lobn is n to get map(n)
    dim lobc(255) as short 'lobc is bg set__color(
    dim lobp(255) as _cords 'lobc is bg set__color(
    static as short curs
    dim as short x,y,a,b,p,m,lx,ly,dlx,diff,i,last,ll,debug,osx
    dim as string key,lobk1,lobk2
    
    ll=fix(20*_fh1/_fh2)
    last=lb_listmake(lobk(),lobn(),lobc(),lobp())
    for a=1 to last       'tests all lobn for special planets, system comments and planets comments for coloring bg
'        'print "test for special planets and change lobc (bg set__color(): system " &map(lobn(int(a/21), (a mod 21))).desig 'debug
        if lobn(a)>=0 then
            if map(lobn(a)).comment<>"" then lobc(a)=228
            for p=1 to 9 'find number of planet in system's orbits
    '            
                m=map(lobn(a)).planets(p)
                if m>0 then
                    if planets(m).comment<>"" then lobc(a)=241
                    for b=0 to lastspecial
                        if planetmap(0,0,m)<>0 and m=specialplanet(b) then lobc(a)=233
                    next
                endif
            next
        endif
    next
'    
    do
        screenset 0,1
        cls
        draw_border(0)
        for x=(_mwx+1)*_fw1 to (_mwx+20)*_fw1 step 8
            set__color( 224,1)
            draw string (x,11*_fh1),chr(196),,Font1,custom,@_col
        next
        draw string((_mwx+1)*_Fw1,11*_fh1),chr(195),,Font1,custom,@_col
        
        for x=(_mwx+1)*_fw1 to (_mwx+20)*_fw1 step 8
            set__color( 224,1)
            draw string (x,12*_fh1+sm_y*2),chr(196),,Font1,custom,@_col
        next
        draw string((_mwx+1)*_Fw1,12*_fh1+sm_y*2),chr(195),,Font1,custom,@_col
        set__color( 15,1)
            
        draw string((_mwx+1)*_Fw1+6*_fw2,12*_fh1+sm_y*2),"Minimap",,Font2,custom,@_col
        
        'displayship(1)
       
        if curs<1 then curs=1
        if curs>last then curs=last
        i=1
        for x=0 to 4
            for y=1 to ll
                if i<=last then
                    if i=curs then
                        set__color( 15,3)
                    else
                        set__color( 11, 0)
                        if lobc(i)<>0 then set__color( 11, lobc(i))
                    endif
                    if lobk(i)<>"" then
                        draw string (x*14*_fw2,y*_fh2),lobk(i),,Font2,custom,@_col
                    else
                        draw string (x*14*_fw2,y*_fh2),space(14),,Font2,custom,@_col
                    endif
                    i+=1
                endif
            next
        next
        
        dprint "Logbook: Press " &key_sc &" or enter to choose system. ESC to exit.",15
        
        if lobn(curs)>=0 then
            if debug=1 and _debug=1 and key="t" then player.c=lobp(curs)
            show_minimap(lobp(curs).x,lobp(curs).y)
            show_dotmap(lobp(curs).x,lobp(curs).y)
            if lobn(curs)>laststar then show_wormholemap(lobn(curs))
            if lobn(curs)<=laststar then
                if map(lobn(curs)).discovered>1 then
                    display_system(lobn(curs),1)
                else
                    dprint trim(map(lobn(curs)).desig)&": only long range data."
                endif
                if map(lobn(curs)).comment<>"" then dprint map(lobn(curs)).comment
                'fill msg area with planets comments, if there are more then shown, then msg there are more.
                p=0
                b=0
                lobk1=""
                if map(lobn(curs)).comment<>"" then b=1
                do 'print max of 2 planets comments
                    p+=1
                    m=map(lobn(curs)).planets(p)
                    if m>0 then
                        if planets(m).comment<>"" then
                            if b<2 then dprint "Orbit " &p &":" &planets(m).comment &"." 'print when b=0 or b=1
                            if b=2 then lobk1=str(p) &":" &planets(m).comment &"." 'store third planet comments
                            b+=1
                        endif
                    endif
                loop until p=9 or b=3 'test for 4 planets with comments
                if b>1 and lobk1<>"" then
                    if b=2 then dprint "Orbit " &lobk1 endif
                    if b=3 then dprint "Orbit " &lobk1 &" .Enter to see more comments."
                elseif b>1 then
                    if b=2 then dprint "Orbit " &p endif
                    if b=3 then dprint "Orbit " &p &" .Enter to see more comments."
                endif
                
                if key=key_comment and lobn(curs)<>0 then
                    screenset 1,1
                    dprint "Enter comment on system"
                    map(lobn(curs)).comment=gettext(LocEOL.x,LocEOL.y,60,map(lobn(curs)).comment)
                    if map(lobn(curs)).comment<>"" then lobc(curs)=228
                endif
                if key=key__enter and map(lobn(curs)).discovered>1 then
                for p=1 to 9
                    if map(lobn(curs)).planets(p)>0 then
                        if planets(map(lobn(curs)).planets(p)).comment<>"" then dprint "Orbit " &p &":" &planets(map(lobn(curs)).planets(p)).comment
                    endif
                next
                do
                    p=getplanet(lobn(curs),1)
                    if p>0 then
                        m=map(lobn(curs)).planets(p)
                        if m>0 then
                            if planets(m).comment<>"" then dprint planets(m).comment
                            if planetmap(0,0,m)=0 then
                                cls
                                display_ship(1)
                                set__color( 15,0)
                                draw string (15*_fw1,10*_fh1),"No map data for this planet.",,Font2,custom,@_col
                                flip
                                no_key=keyin
                            else
                                do
                                    cls
                                    dplanet(planets(m),p,planets(m).mapped,m)
                                    display_planetmap(m,osx,1)
                                    flip
                                    no_key=keyin(key_comment &key_report &key__esc &"abcdefghiklmnop" &key_east &key_west & key__enter)
                                    if no_key=key_comment then
                                        screenset 1,1
                                        dprint "Enter comment on planet"
                                        planets(m).comment=gettext(loceol.x,loceol.y,60,planets(m).comment)
                                        if planets(m).comment<>"" and map(lobn(curs)).comment="" then lobc(curs)=241
                                    endif
                                    if no_key=key_report then
                                        bioreport(m)
                                    endif 
                                    If no_key=key_east Then osx+=1
                                    If no_key=key_west Then osx-=1
                                    If osx<0 Then osx=0
                                    If osx>60-_mwx Then osx=60-_mwx
                                loop until no_key<>key_comment and no_key<>key_report and no_key<>key_west and no_key<>key_east
                                
                            endif
                        endif
                    endif
                    
                loop until no_key=key__esc or p=-1
                
                key=""
            endif
            
            endif
            if key=key_walk then
                dprint "Setting autopilot, risk setting? (0 ignore gasclouds, 5 avoid all)"
                diff=getnumber(0,5,0)
                if auto_pilot(player.c,lobp(curs),diff)=1 then return 0
            endif
            
            if key=key_filter then last=lb_filter(lobk(),lobn(),lobc(),lobp(),last)
                
        endif
        flip
        key=keyin("123456789 " &key_sc &key__esc &key__enter &key_comment &key_walk &key_filter &"t",walking)
        a=getdirection(key)
        if a=5 then key=key__enter 
        
        
        if a=7 then curs-=(ll-1)
        if a=4 then curs-=ll
        if a=1 then curs-=(ll+1)
        if a=9 then curs+=(ll-1)
        if a=6 then curs+=ll
        if a=3 then curs+=(ll+1)
        if a=8 then curs-=1
        if a=2 then curs+=1
        a=0
        set__color( 11,0)
    loop until key=key__esc or player.dead<>0 or walking=10
    return 0
end function

function ap_astar(start as _cords,ende as _cords,diff as short) as short
    dim map(sm_x,sm_y) as short
    dim as short x,y,debug
    
    if debug=2 and _debug=1 then dprint ""&diff
    for x=0 to sm_x 
        for y=0 to sm_y
            map(x,y)=0
            if spacemap(x,y)>0 then 
                map(x,y)=spacemap(x,y)*200*diff^2
                if map(x,y)<0 then map(x,y)=32000
            else
                map(x,y)=100*diff
            endif
            if debug=1 and _debug=1 then
                set__color( map(x,y),0)
                pset(x,y)
            endif
        next
    next
    lastapwp=a_star(apwaypoints(),ende,start,map(),sm_x,sm_y,0)
    return lastapwp
end function


function auto_pilot(start as _cords, ende as _cords, diff as short) as short
    lastapwp=ap_astar(start,ende,diff)
    if lastapwp>0 then
        show_dotmap(ende.x,ende.y) 
        if askyn( "Route calculated with "&lastapwp &" parsecs. Use it? (y/n)") then
            walking=10
            currapwp=0
            apdiff=diff
            return 1
        endif
    endif
    return 0
end function

function show_dotmap(x1 as short, y1 as short) as short
    dim as short a,x,y,px,py
    x1=x1*2
    y1=y1*2
    px=_screenx-2-sm_x*2
    py=11*_fh1+_fh2+2
    set__color( 1,0)
    
    for x=-1 to sm_x*2+1
        for y=-1 to sm_y*2+1
            set__color( 0,0)
            pset(x+px,y+py)
        next
    next
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)=0 then set__color( 0,0)
            if spacemap(x,y)=1 then set__color( 1,0)
            if spacemap(x,y)>1 then set__color( 9,0)
            pset((x*2)+px,(y*2)+py)
            'pset((x*2)+px,(y*2)+py+1)
            'pset((x*2)+px+1,(y*2)+py)
            pset((x*2)+px+1,(y*2)+py+1)
        next
    next
    for a=0 to laststar
        if map(a).discovered>0 then
            set__color( spectraltype(map(a).spec),0)
            x=map(a).c.x
            y=map(a).c.y
            pset((x*2)+px,(y*2)+py)
            pset((x*2)+px,(y*2)+py+1)
            pset((x*2)+px+1,(y*2)+py)
            pset((x*2)+px+1,(y*2)+py+1)
        endif
    next
    for x=x1-10 to x1+10
        for y=y1-10 to y1+10
            if x=x1-10 or x=x1+10 or y=y1-10 or y=y1+10 then
                set__color( 15,0)
                pset(x+px,y+py)
            endif
        next
    next
    set__color( 224,0)
            
    for x=-1 to sm_x*2+1
        for y=-1 to sm_y*2+1
            if y=-1 or x=-1 or y=sm_y*2+1 or x=sm_x*2+1 then pset(x+px,y+py)
        next
    next
    if lastapwp>0 then
        for a=1 to lastapwp
            if spacemap(apwaypoints(a).x,apwaypoints(a).y)>1 then
                set__color( 12,0)
            else
                set__color( 10,0)
            endif
            pset(apwaypoints(a).x*2+px,apwaypoints(a).y*2+py)
            pset(apwaypoints(a).x*2+1+px,apwaypoints(a).y*2+py)
            pset(apwaypoints(a).x*2+px,apwaypoints(a).y*2+1+py)
            pset(apwaypoints(a).x*2+1+px,apwaypoints(a).y*2+1+py)
        next
    endif
        
    return 0
end function

function show_minimap(xx as short,yy as short) as short
    dim as short a,x1,y1,x,y,osx,osy,n,bg,wid,px,py,debug,f,tile
    
    x1=xx
    y1=yy
    wid=fix(20*_fw2/_fw1)
    wid=fix(wid/2)
    if configflag(con_tiles)=0 then
        px=_mwx*_fw1+_fw1+8
    else
        px=_mwx*_fw1+_fw1+_fw2
    endif
    osx=wid-xx
    osy=5-yy+py
    for x=xx-wid to xx+wid
        for y=yy-5 to yy+5
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if spacemap(x,y)>=2 and  spacemap(x,y)<=5 then 
                    if configflag(con_tiles)=0 then
                        put ((x+osx)*_fw1+px,(y+osy)*_fh1),gtiles(abs(spacemap(x,y))+49),trans
                    else                        
                        set__color( rnd_range(48,59),1)
                        'if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1
                        'if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1
                        'if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1
                        'if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1
                        draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),chr(176),,Font1,custom,@_col
                    endif
                endif
                if spacemap(x,y)>5 then
                
                endif
            endif
            'locate y+osy,x+osx
            'if spacemap(x,y)>0 then print "#"
        next
    next
    for a=0 to laststar+wormhole
        if map(a).c.x>=x1-wid and map(a).c.x<=x1+wid and map(a).c.y>=y1-5 and map(a).c.y<=y1+5 then
            if map(a).discovered>0 then
                x=map(a).c.x
                y=map(a).c.y
                if xx<>x or yy<>y then 
                    bg=0
                else
                    bg=5
                endif

                if configflag(con_tiles)=0 then
                    put ((x+osx)*_tix+px,(y+osy)*_tiy),gtiles(map(a).ti_no),trans
                    if bg=5 then put ((x+osx)*_tix+px,(y+osy)*_tiy),gtiles(85),trans
    
                else        
                    set__color( spectraltype(map(a).spec),bg)
                    if map(a).spec<8 then draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),"*",,Font1,custom,@_col
                    if map(a).spec=8 then     
                        set__color( 7,bg)
                        draw string ((x+osx)*_fw1+px,(y+osy)*_fh1),"o",,Font1,custom,@_col
                    endif
                        
                    if map(a).spec=9 then 
                        n=distance(map(a).c,map(map(a).planets(1)).c)/5
                        if n<1 then n=1
                        if n>6 then n=6
                        set__color( 179+n,bg)
                        draw string ((map(a).c.x+osx)*_fw1+px,(map(a).c.y+osy)*_fh1),"o",,Font1,custom,@_col
                    endif
                endif
            endif
        endif
    
    next
    
    for a=0 to lastdrifting
        x=drifting(a).x
        y=drifting(a).y
        
        if planets(drifting(a).m).flags(0)=0 then
            set__color( 7,0)
            if debug=1 and _debug=1 then
                f=freefile
                open "debuglog.txt" for append as #f
                print #f,drifting(a).g_tile.x &":"& drifting(a).g_tile.y &":"& drifting(a).y
                close #f
            endif
            'drifting(a).g_tile.y=1
            'drifting(a).p=1
            if drifting(a).g_tile.x=0 or drifting(a).g_tile.x=5 or drifting(a).g_tile.x>9 then drifting(a).g_tile.x=rnd_range(1,4)
            if drifting(a).s=20 then set__color( 15,0)
            if drifting(a).p>0 then
                if x>=x1-wid and x<=x1+wid and y>=y1-5 and y<=y1+5 then 
                    x=x+osx
                    y=y+osy
                    if configflag(con_tiles)=0 then
                        put (x*_tix+px,y*_tiy),stiles(drifting(a).g_tile.x,drifting(a).g_tile.y),trans
                    else
                        draw string (x*_fw1+px,y*_fh1+py),"s",,Font1,custom,@_col
                    endif                
                endif
            endif
        endif
    next
    
    for a=0 to 2
        if basis(a).discovered>0 then
            if basis(a).c.x>=x1-wid and basis(a).c.x<=x1+wid and basis(a).c.y>=y1-5 and basis(a).c.y<=y1+5 then
                x=basis(a).c.x+osx
                y=basis(a).c.y+osy
                set__color( 15,0)
                tile=a+3*(basis(a).company-1)
                if configflag(con_tiles)=1 then
                    draw string (x*_fw1+px,y*_fh1),"S",,Font1,custom,@_col
                else
                    put (x*_tix+px,y*_tiy),gtiles(gt_no(1750+tile)),trans
                endif
            endif
        endif
    next
    if player.c.x>=x1-wid and player.c.x<=x1+wid and player.c.y>=y1-5 and player.c.y<=y1+5 then        
        x=player.c.x
        y=player.c.y
        if configflag(con_tiles)=0 then
            put (x*_tix+px,y*_tiy),stiles(player.di,player.ti_no),trans
        else
            set__color( _shipcolor,0)
            draw string (x*_fw1+px,y*_fh1),"@",,Font1,custom,@_col
        endif
    endif
    set__color( 11,0)
    return 0
end function

function show_wormholemap(j as short=0) as short
    dim as short px,py,i,debug
    px=_screenx-2-sm_x*2
    py=11*_fh1+_fh2+2
    
    if j>0 then
        if debug=1 and _debug=1 then map(j).planets(2)=1
        if map(j).planets(2)=1 then
            set__color( 1,0)
            line(map(j).c.x*2+px,map(j).c.y*2+py)-(map(map(j).planets(1)).c.x*2+px,map(map(j).planets(1)).c.y*2+py),15
        endif
        return 0
    endif
    
    for i=laststar+1 to laststar+wormhole
        if debug=1 and _debug=1 then map(i).planets(2)=1
        if map(i).planets(2)=1 then
            set__color( 1,0)
            line(map(i).c.x+px,map(i).c.y+py)-(map(map(i).planets(1)).c.x+px,map(map(i).planets(1)).c.y+py),15
        endif
    next
    return 0
end function

'    cls
'    displayship
'    for x=0 to sm_x
'        for y=0 to sm_y
'            if spacemap(x,y)>0 then
'                set__color( 1,0
'                locate map(i).c.y+1,map(i).c.x+1
'                print "."
'            endif
'        next
'    next
'    set__color( 15,0
'    
'    for i=laststar+1 to laststar+wormhole
'        if map(i).planets(2)=1 then
'            l=line_in_points(map(i).c,map(map(i).planets(1)).c,p())
'            n=distance(map(i).c,map(map(i).planets(1)).c)/5
'            if n<1 then n=1
'            if n>6 then n=6
'            set__color( 179+n,0
'            for i2=1 to l-1
'                locate p(i2).y+1,p(i2).x+1
'                print "."
'            next
'        endif
'    next
'    for i=laststar+1 to laststar+wormhole
'        if map(i).discovered<>0 then
'            n=distance(map(i).c,map(map(i).planets(1)).c)/5
'            if n<1 then n=1
'            if n>6 then n=6
'            set__color( 179+n,0
'            locate map(i).c.y+1,map(i).c.x+1
'            print "o"
'            locate map(i).c.y+1,map(i).c.x+2
'        endif
'    next
'    for i=1 to laststar
'        if map(i).discovered<>0 then
'            set__color( spectraltype(map(i).spec),0
'            locate map(i).c.y+1,map(i).c.x+1
'            print "*"
'        endif
'    next
'    dprint "Displaying wormhole map"
'    no_key=keyin

function lb_listmake(lobk() as string, lobn() as short, lobc() as short,lobp()as _cords) as short
    dim last as short
    dim as short i,a,b,f,j
    dim as short debug=1
    for a=0 to 255
        lobn(a)=-1
    next
    i=0
    for a=0 to laststar
        if map(a).discovered>0 and map(a).desig<>"" then
            i+=1
            lobk(i)=trim(map(a).desig)
            if map(a).comment<>"" then lobk(i)=lobk(i) &" (c)"
            lobn(i)=a
            lobc(i)=0
            lobp(i)=map(a).c
            for b=1 to 9
                if map(a).planets(b)>0 and map(a).planets(b)<max_maps then
                if is_special(map(a).planets(b)) and planets(map(a).planets(b)).mapstat<>0 then lobc(i)=6
                endif
            next
        endif
    next
    last=i
    do
    f=0
        for j=1 to last-1
            if map(lobn(j)).c.x>map(lobn(j+1)).c.x then
                f=1
                swap lobn(j),lobn(j+1)
                swap lobc(j),lobc(j+1)
                swap lobk(j),lobk(j+1)
                swap lobp(j),lobp(j+1)
            endif
        next
    loop until f=0
    
    
    
    for a=laststar+1 to laststar+wormhole
        if map(a).discovered>0 then
            i+=1
            lobk(i)=trim(map(a).desig)
            lobn(i)=a
            lobp(i)=map(a).c
        endif
    next
    for a=0 to 2
        if basis(a).c.x>0 and basis(a).c.y>0 then
            i+=1
            lobk(i)="Station "&a+1
            lobp(i)=basis(a).c
            lobn(i)=0
        endif
    next
    
    for a=1 to 3
        if drifting(a).p=1 then
            i+=1
            lobk(i)="Minor station"&cords(drifting(a))
            lobp(i)=drifting(a)
            lobn(i)=0
        endif
    next
    
    last=i
    return last
end function



function lb_filter(lobk() as string, lobn() as short, lobc() as short,lobp() as _cords,last as short) as short
    dim as short c,i,j,f,cc,c2,last2
    last=lb_listmake(lobk(),lobn(),lobc(),lobp())
    last2=last
    c=menu(bg_logbook,"Filter & Sort/Distance from base/Distance from ship/Spectral type/Systems with unexplored planets/Systems with gas giants/Systems with asteroid belts/Exit")
    if c=1 then
        do
            f=0
            cc+=1
            for i=1 to last-1
                if disnbase(map(lobn(i)).c)>disnbase(map(lobn(i+1)).c) then
                    swap lobn(i),lobn(i+1)
                    swap lobc(i),lobc(i+1)
                    swap lobk(i),lobk(i+1)
                    swap lobp(i),lobp(i+1)
                    f=1
                endif
            next
        loop until f=0 or cc>1000
    endif
    if c=2 then
        do
            f=0
            cc+=1
            for i=1 to last-1
                if distance(map(lobn(i)).c,player.c)>distance(map(lobn(i+1)).c,player.c) then
                    swap lobn(i),lobn(i+1)
                    swap lobc(i),lobc(i+1)
                    swap lobk(i),lobk(i+1)
                    swap lobp(i),lobp(i+1)
                    f=1
                endif
            next
        loop until f=0 or cc>1000
    endif
    if c=3 then 
        c2=menu(bg_logbook,"Spectral type:/"&spectralname(1) &"/"&spectralname(2) &"/"&spectralname(3) &"/"&spectralname(4) &"/"&spectralname(5) &"/"&spectralname(6) &"/"&spectralname(7) &"/"& spectralname(8) & "/Exit",,20,2)
        if c2>0 and c2<=8 then
            for i=1 to last
                if map(lobn(i)).spec<>c2 then
                    lobn(i)=0
                    lobc(i)=0
                    lobk(i)=""
                endif
            next
        endif
    endif
    if c=4 then
        for i=1 to last
            f=0
            for j=1 to 9
                if map(lobn(i)).planets(j)>0 then
                    if planets(map(lobn(i)).planets(j)).visited=0 then f=1
                endif
            next
            if f=0 then
                lobk(i)=""
            endif
        next
    endif
    if c=5 then
        for i=1 to last
            f=0
            for j=1 to 9
                if is_gasgiant(map(lobn(i)).planets(j))<>0 then f=1
            next
            if map(lobn(i)).discovered<2 then f=0
            if f=0 then lobk(i)=""
        next
    endif
    if c=6 then
        for i=1 to last
            f=0
            for j=1 to 9
                if is_asteroidfield(map(lobn(i)).planets(j))<>0 then f=1
            next
            if map(lobn(i)).discovered<2 then f=0
            if f=0 then lobk(i)=""
        next
    endif
    last2=0
    i=1
    for i=last to 1 step -1
        if lobk(i)="" then
            j=i
            for j=i to 254
                lobn(j)=lobn(j+1)
                lobc(j)=lobc(j+1)
                lobk(j)=lobk(j+1)
                lobp(j)=lobp(j+1)
            next
        endif
    next
    for i=1 to 255
        if lobk(i)<>"" then last2+=1
    next
    return last2
end function
