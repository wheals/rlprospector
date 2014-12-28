function captain_sprite() as short
    return gt_no(990+crew(1).story(3)+abs(awayteam.helmet-1)*3*crew(1).story(10)+6*awayteam.helmet)
end function

function change_captain_appearance(x as short,y as short) as short
    dim as short a,n
    dim as string text,mf(1)
    mf(0)="Female"
    mf(1)="Male"
    do
        't="Age:"& 18+crew(i).story(6) &" Size: 1."& 60+crew(i).story(7)*4 &"m Weight:" &50+crew(i).story(8)*4+crew(i).story(7) &"kg. ||"

        text="Captain:/Name: "&crew(1).n &"/"
        if _debug=1310 then text=text &" s10:"&crew(1).story(10)
        text &= "Gender: "&mf(crew(1).story(10))&"/"
        text &= "Age: "&18+crew(1).story(6) &"/"
        text &= "Height: 1."&60+crew(1).story(7) &"/"
        text &= "Weight: "&50+crew(1).story(8)*4+crew(1).story(7) &"/"
        text &= "Change outfit/"
        if awayteam.helmet=0 then
            text &="close helmet/"
        else
            text &="open helmet/"
        endif
        text &= "Exit"
        put (x*_fw1-2-_tix,y*_fh1),gtiles(captain_sprite),trans
        a=menu(bg_noflip,text,"",x,y)
        select case a
        case 1
            dprint ""
            crew(1).n=gettext(LocEOL.x,LocEOL.y,16,crew(1).n)
            dprint "Are you male or female?(m/f)"
            no_key=keyin
            if lcase(no_key)="m" then
                crew(1).story(10)=0
            else
                crew(1).story(10)=1
            endif
        case 2
            crew(1).story(10)+=1
            if crew(1).story(10)>1 then crew(1).story(10)=0
        case 3
            dprint "Age: "
            crew(1).story(6)=getnumber(18,120,20)-18
            'age
        case 4
            dprint "Height in cm: "
            n=getnumber(100,300,180)
            n=n-160
            crew(1).story(7)=n
            'height
        case 5
            dprint "Weight in kg: "
            n=getnumber(50,500,100)
            n=(n-50-crew(1).story(7))/4
            crew(1).story(8)=n
            'weight
        case 6
            crew(1).story(3)+=1
            if crew(1).story(3)>2 then crew(1).story(3)=0
        case 7
            if awayteam.helmet=1 then
                awayteam.helmet=0
            else
                awayteam.helmet=1
            endif
        end select
    loop until a=8 or a=-1
    return 0
end function


function update_tmap(slot as short) as short
    dim as short x,y,x1,y1
    if slot<0 then return 0
    erase tmap
    for x=0 to 60
        for y=0 to 20
            tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
            
            If show_all=1 And planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-planetmap(x,y,slot)
            If Abs(planetmap(x,y,slot))>512 Then
                dprint "ERROR: Tile #"&planetmap(x,y,slot)&"out ofbounds"
                planetmap(x,y,slot)=512
            EndIf
            If tmap(x,y).ti_no=2505 Then 'Ship walls
                If rnd_range(1,100)<33 Then
                    tmap(x,y).ti_no=2504+rnd_range(1,4)
                EndIf
            EndIf
            If Abs(planetmap(x,y,slot))=267 Then
                enemy(0)=makemonster(1,slot)
                tmap(x,y).desc="A cage. Inside is "&first_lc(enemy(0).ldesc)
                enemy(0)=enemy(1) 'Delete monster
            EndIf

            If tmap(x,y).vege>0 Then
                tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                If rnd_range(1,100)<tmap(x,y).vege/2 Then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
            EndIf
            
        next
    next
    for x=0 to 60
        for y=0 to 20
            if tmap(x,y).no=200 then
                vacuum(x,y)=1
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if x1>=0 and x1<=60 and y1>=0 and y1<=20 then
                            if tmap(x1,y1).no<>200 then
                                tmap(x,y).walktru=0
                                tmap(x,y).desc="Hullsurface"
                            endif
                        endif
                    next
                next
            else
                vacuum(x,y)=0
            endif
        next
    next
    return 0
end function

function earthquake(t as _tile,dam as short)as _tile
    dim roll as short
    if t.shootable=1 then
        t.hp=t.hp-dam
        if t.hp<=0 then t=tiles(t.turnsinto)
    endif
    if t.no<41 and t.no<>1 and t.no<>2 and t.no<>26 and t.no<>20 and t.no<>21 then
        if t.no=6 or t.no=5 then t=tiles(3)
        if t.no=7 or t.no=8 and rnd_range(1,100)<33+dam then t=tiles(4)
        if t.no=20 and rnd_range(1,100)<33+dam then t=tiles(rnd_range(1,2))
        if rnd_range(1,100)<15 and t.no<>18 then t=tiles(47)
    endif
    return t
end function

function hpdisplay(a as _monster) as short
    dim as short hp,b,c,x,y,l
    hp=0
    a.hpmax=0
    a.hp=0
    for b=1 to 128
        if crew(b).hpmax>0 and crew(b).onship=0 then a.hpmax+=1
        if crew(b).hp>0 and crew(b).onship=0  then a.hp+=1
        if crew(b).hp>0 and crew(b).onship=0 then hp=hp+1
    next

    set__color( 15,0)
    draw string(sidebar,0*_fh1),"Status ",,font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar+7*_fw2,0*_fh2),"(",,font2,custom,@_col
    draw string(sidebar+10*_fw2,0*_fh2),""&a.hpmax &"/",,font2,custom,@_col
    if a.hp/a.hpmax<.7 then set__color( 14,0)
    if a.hp/a.hpmax<.4 then set__color( 12,0)
    draw string(sidebar+13*_fw2,0*_fh2) ,""&a.hp,,font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar+16*_fw2,0*_fh2), ")",,font2,custom,@_col
    
    y=2
    x=0
    c=1
    do
        if crew(c).hpmax>0 and crew(c).onship=0 then
            x+=1
            l=y
            if crew(c).hp>0  then

                set__color( 14,0)
                if crew(c).hp=crew(c).hpmax then set__color( 10,0)
                if crew(c).disease>0 then set__color( 192,0)
                if _HPdisplay=1 then
                    draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2),crew(c).icon,,font2,custom,@_col
                else
                    draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2),""&crew(c).hp,,font2,custom,@_col
                endif
            else
                set__color( 12,0)
                draw string(sidebar+(x-1)*_fw2,(y-1)*_fh2), "X",,font2,custom,@_col
            endif
        endif
        if x>15 then
            x=0
            y+=1
        endif
        c+=1
    loop until c=128 or crew(c).hpmax=0
        
    return l
end function

function dplanet(p as _planet,orbit as short,scanned as short,slot as short) as short
    dim a as short
    dim as single plife
    dim text as string
    dim as short debug
    debug=1
    draw_border(0)

    set__color( 15,0)
    draw string(sidebar,1*_fh2), "Scanning Results:",,font2,custom,@_col

    set__color( 11,0)
    draw string(sidebar,2*_fh2), "Planet in orbit " & orbit,,font2,custom,@_col
    draw string(sidebar,3*_fh2), scanned &" km2 scanned",,font2,custom,@_col
    draw string(sidebar,5*_fh2), p.water &"% Liq. Surface",,font2,custom,@_col
    text=atmdes(p.atmos) &" atmosphere"
    textbox(text,sidebar+_fw2,(7*_fh2),16,11,0,1)
    draw string(sidebar,12*_fh2), "Gravity:"&p.grav &"g",,font2,custom,@_col
    set__color( 10,0)
    if p.grav<1 then draw string(62*_fw1+13*_fw2,12*_fh2), "(Low)",,font2,custom,@_col
    set__color( 14,0)
    if p.grav>1.5 then draw string(62*_fw1+13*_fw2,12*_fh2), "(High)",,font2,custom,@_col
    set__color( 11,0)


    draw string(sidebar,13*_fh2), "Avg. Temperature",,font2,custom,@_col
    draw string(sidebar+_fw2,14*_fh2), p.temp &" "&chr(248)&"C ",,font2,custom,@_col
    draw string(sidebar+_fw2,15*_fh2), c_to_f(p.temp) &" "&chr(248)&"F ",,font2,custom,@_col
    if p.rot>0 then
        draw string(sidebar,17*_fh2),"Rot.: "&display_time((60*24*p.rot),3) &" h" ,,font2,custom,@_col
    else
        draw string(sidebar,17*_fh2),"Rot.: Nil",,font2,custom,@_col
    endif
    Draw string(sidebar,19*_fh2),"Vegetation: "&int(vege_per(slot)*100) &"%",,font2,custom,@_col
    select case p.highestlife*100
    case is=0
        set__color(c_gre,0)
        draw string(sidebar,20*_fh2),"No Lifeforms",,font2,custom,@_col
    case 0 to 10
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_gre,0)
        draw string(sidebar,22*_fh2),"Very Low",,font2,custom,@_col
    case 11 to 20
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_gre,0)
        draw string(sidebar,22*_fh2),"Low",,font2,custom,@_col

    case 50 to 80
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        set__color(c_yel,0)
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col

    case 81 to 90
        set__color(11,0)
        draw string(sidebar,20*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,21*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_red,0)
        draw string(sidebar,22*_fh2),"High",,font2,custom,@_col

    case is>90
        set__color(11,0)
        draw string(sidebar,19*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,20*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col
        set__color(c_red,0)
        draw string(sidebar,21*_fh2),"Very High",,font2,custom,@_col
    case else
        set__color(11,0)
        draw string(sidebar,19*_fh2),"Lifeforms:",,font2,custom,@_col
        draw string(sidebar,20*_fh2),p.highestlife*100 &" % probability",,font2,custom,@_col

    end select
    return 0
end function

function monster_description(enemy as _monster) as string
    dim text as string
    if enemy.hp<=0 then text=text &"A dead "
    text=text &enemy.ldesc
    if enemy.hpnonlethal>enemy.hp and enemy.hp>0 then
        text =text &". Immobilized."
    else
        if enemy.hpmax=enemy.hp then
            text=text &". Unhurt."
        else
            if enemy.hp>0 then
                if enemy.hp<2 then
                    text=text &". Badly hurt."
                else
                    text=text &". Hurt."
                endif
            endif
        endif
    endif
    if enemy.stuff(9)=0 then
        if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>9 then enemy.stuff(10)=1
        if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>10 then enemy.stuff(11)=1
        if rnd_range(1,6)+rnd_range(1,6)+player.science(1)>11 then enemy.stuff(12)=1
        enemy.stuff(9)=1
    endif
    if enemy.stuff(10)=1 then text=text &" (" &enemy.hpmax &"/" &enemy.hp &")"
    if enemy.stuff(11)=1 then text=text &" W:" &enemy.weapon
    if enemy.stuff(12)=1 then text=text &" A:" &enemy.armor
    if enemy.hp>0 and enemy.aggr=0 and enemy.sleeping=0 and enemy.hp>enemy.hpnonlethal then text=text &" It is attacking!"
    if enemy.sleeping>0 then text=text &" It is asleep."
    return text
end function

function draw_border(xoffset as short) as short
    dim as short fh1,fw1,fw2,a
    if configflag(con_tiles)=0 then
        fh1=16
        fw1=8
        fw2=_fw2
    else
        fh1=_fh1
        fw1=_fw1
        fw2=_fw2
    endif
    set__color( 224,1)
    if xoffset>0 then draw string(xoffset*fw2,21*_fh1),chr(195),,Font1,Custom,@_col
    for a=(xoffset+1)*fw2 to (_mwx+1)*_fw1 step fw1
        draw string (a,21*_fh1),chr(196),,Font1,custom,@_col
    next
    for a=0 to _screeny-fh1 step fh1
        set__color( 224,1)
        'draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        draw string ((_mwx+1)*_fw1,a),chr(179),,Font1,custom,@_col
        set__color(0,0)
        draw string ((_mwx+2)*_fw1,a),space(25),,font1,custom,@_col
    next
    set__color( 224,1)
    draw string ((_mwx+1)*_fw1,21*_fh1),chr(180),,Font1,custom,@_col
    set__color( 11,0)
    return 0
end function



function settactics() as short
    dim as short a
    dim text as string
    screenshot(1)
    text="Tactics:/"
    for a=1 to 6
        if a=player.tactic+3 then
            text=text &" *"&tacdes(a)&"   "
        else
            text=text &"  "&tacdes(a)&"   "
        endif
        text=text &"/"
    next
    text=text &"Exit"
    a=menu(bg_awayteamtxt,text,,,,1)
    if a<7 then
        player.tactic=a-3
    endif
    screenshot(2)
    return 0
end function

function screenshot(a as short) as short
    savepng( "summary/" &player.desig &".png", 0, 1)
    return 0
end function

function bioreport(slot as short) as short
    dim a as short
    dim as string t,h
    screenshot(1)
    t="Bio Report for /"
    h="/"
    for a=0 to 16
        if planets(slot).mon_seen(a)>0 or planets(slot).mon_killed(a)>0 or planets(slot).mon_caught(a)>0 then
            t=t & planets(slot).mon_template(a).sdesc &"/"
            h=h & " | "&planets(slot).mon_template(a).ldesc &" | | Visual  :"
            if planets(slot).mon_seen(a)>0 then
                h=h &" Yes"
            else
                h=h &" No"
            endif
            h=h & " | Killed  : "&planets(slot).mon_killed(a)
            h=h & " | Disected: "&planets(slot).mon_disected(a)
            h=h & " | Caught  : "&planets(slot).mon_caught(a) &" | /"
        endif
    next
    t=t &"Exit"
    do
    loop until menu(bg_awayteamtxt,t,h)
    return 0
end function


function manual() as short
    dim as integer f,offset,c,a,lastspace
    dim lines(512) as string
    dim col(512) as short
    dim as string key,text
    'dim evkey as EVENT
    screenshot(1)
    set__color( 15,0)
    cls
    f=freefile
    if (open ("readme.txt" for input as #f))=0 then
        do
            line input #f,lines(c)
            while len(lines(c))>80
                text=lines(c)
                lastspace=80
                do
                    lastspace=lastspace-1
                loop until mid(text,lastspace,1)=" "
                lines(c)=left(text,lastspace)
                lines(c+1)=mid(text,lastspace+1,(len(text)-lastspace+1))
                c=c+1
            wend
            c=c+1

        loop until eof(f) or c>512
        close #f
        for a=1 to c
            col(a)=11
            if left(lines(a),2)="==" then
                col(a)=7
                col(a-1)=14
            endif
            'if left(lines(a),1)="*" then col(a)=14
        next
        do
            key=""
            cls
            set__color( 11,0)
            for a=1 to 24
                locate a,1
                set__color( col(a+offset),0)
                print lines(a+offset);
            next
            locate 25,15
            set__color( 14,0)
            print "Arrow down and up to browse, esc to exit";
            key=keyin("12346789 ",1)
            if keyplus(key)  then offset=offset-22
            if keyminus(key)  then offset=offset+22
            if offset<0 then offset=0
            if offset>488 then offset=488
        loop until key=key__esc or key=" "
    else
        locate 10,10
        print "Couldnt open readme.txt"
    endif
    cls
    while inkey<>""
    wend
    screenshot(2)
    return 0
end function

function messages() as short
    dim as short a,ll
    screenshot(1)
    ll=_lines*_fh1/_fh2
    set__color( 15,0)
    cls
    for a=1 to ll
        locate a,1
        set__color( dtextcol(a),0)
        draw string (0,a*_fh2), displaytext(a),,font2,custom,@_col
    next
    no_key=keyin(,1)
    cls
    screenshot(2)
    return 0
end function

function display_stars(bg as short=0) as short
    dim as uinteger alphav
    dim as short a,b,x,y,navcom,mask,ti_no
    dim as short reveal
    dim as _cords p,p1,p2
    dim range as integer
    dim as single dx,dy,l,x1,y1,vis
    dim as short debug
    if bg<2 then
        player.osx=player.c.x-_mwx/2
        player.osy=player.c.y-10
        if player.osx<=0 then player.osx=0
        if player.osy<=0 then player.osy=0
        if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
        if player.osy>=sm_y-20 then player.osy=sm_y-20
    endif
    if rnd_range(1,100)<player.cursed then
        make_vismask(player.c,0,-1)
        dprint "Sensor malfunction",c_yel
    else
        make_vismask(player.c,player.sensors+5.5-player.sensors/2,-1)
    endif
    navcom=player.equipment(se_navcom)
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then vismask(x,y)=1
        next
    next

    for x=player.c.x-10 to player.c.x+10
        for y=player.c.y-10 to player.c.y+10
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                if vismask(x,y)=1 then
                    p.x=x
                    p.y=y
                    if distance(p,player.c)>player.sensors then vismask(x,y)=2
                endif
            endif
        next
    next

    if bg>0 then
        for x=0 to _mwx
            for y=0 to 20
                if x+player.osx>=0 and x+player.osx<=sm_x and y+player.osy>=0 and y+player.osy<=sm_y then
                    ti_no=spacemap(x+player.osx,y+player.osy)
                    set__color( 1,0)
                    if debug=44 and _debug=1 then draw string (x*_fw1,y*_fh1),""&spacemap(x+player.osx,y+player.osy),,FONT1,custom,@_col
    
                    if spacemap(x+player.osx,y+player.osy)=1 and navcom>0 then
                        if configflag(con_tiles)=0 then
                            alphav=192
                            if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                            if (x+player.osx+y+player.osy) mod 2=0 then
                                put (x*_fw1+1,y*_fh1+1),gtiles(49),alpha,alphav
                            else
                                put (x*_fw1+1,y*_fh1+1),gtiles(50),alpha,alphav
                            endif
                        else
                            draw string (x*_fw1,y*_fh1),".",,FONT1,custom,@_col
                        endif
                    endif
                    if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then
                        if configflag(con_tiles)=0 then
                            alphav=192
                            if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                            put (x*_fw1+1,y*_fh1+1),gtiles(ti_no+49),alpha,alphav
                        else
                            if spacemap(x+player.osx,y+player.osy)=2 then color(rgb(0,0,50))
                            if spacemap(x+player.osx,y+player.osy)=3 then color(rgb(0,0,100))
                            if spacemap(x+player.osx,y+player.osy)=4 then color(rgb(0,0,150))
                            if spacemap(x+player.osx,y+player.osy)=5 then color(rgb(0,0,250))
                            draw string (x*_fw1,y*_fh1),chr(176),,Font1,custom,@_col
                        endif
                    endif
                    if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then
    
                    endif
                    if spacemap(x+player.osx,y+player.osy)>=6 and spacemap(x+player.osx,y+player.osy)<=20 then
                        ti_no=abs(spacemap(x+player.osx,y+player.osy))
                        if ti_no>10 then ti_no-=10
                        if configflag(con_tiles)=0 then
                            alphav=192
                            if vismask(x+player.osx,y+player.osy)=1 then alphav=255
                            put (x*_fw1+1,y*_fh1+1),gtiles(ti_no+49),alpha,alphav
                        else
                            if ti_no=6 then set__color( 2,0)
                            if ti_no=7 then set__color( 10,0)
                            if ti_no=8 then set__color( 4,0)
                            if ti_no=9 then set__color( 12,0)
                            if ti_no=10 then set__color( 3,0)
                            draw string (x*_fw1,y*_fh1),":",,Font1,custom,@_col
    
                        endif
                    endif
                endif
            next
        next
    endif
    if debug=25 then
        for a=firstwaypoint to lastwaypoint
            set__color( 11,0)
            if a>=firststationw then set__color( 15,0)
            if targetlist(a).x-player.osx>=0 and targetlist(a).x-player.osx<=60 and targetlist(a).y-player.osy>=0 and targetlist(a).y-player.osy<=20 then
                draw string((targetlist(a).x-player.osx)*_fw1,(targetlist(a).y-player.osy)*_fh1),";",,Font1,Custom,@_tcol
            endif
        next
    endif
    set__color( 1,0)
    for x=player.c.x-10 to player.c.x+10
        for y=player.c.y-10 to player.c.y+10
            if x-player.osx>=0 and y-player.osy>=0 and x-player.osx<=60 and y-player.osy<=20 and x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                p.x=x
                p.y=y
                if vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then
                    if spacemap(x,y)<=0 then reveal=1
                    if spacemap(x,y)=0 then spacemap(x,y)=1
                    if spacemap(x,y)=-2 then spacemap(x,y)=2
                    if spacemap(x,y)=-3 then spacemap(x,y)=3
                    if spacemap(x,y)=-4 then spacemap(x,y)=4
                    if spacemap(x,y)=-5 then spacemap(x,y)=5
                endif
                locate y+1-player.osy,x+1-player.osx,0
                set__color( 1,0)
                if abs(spacemap(x,y))=1 and navcom>0 and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5  then
                    if configflag(con_tiles)=1 then
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    else

                        alphav=192
                        if vismask(x,y)=1 then alphav=255
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(50),alpha,alphav
                    endif
                endif
                if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5 and vismask(x,y)>0  and distance(p,player.c)<player.sensors+0.5 then
                    if configflag(con_tiles)=1 then
                        set__color( rnd_range(48,59),1,vismask(x,y))
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1,vismask(x,y))
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1,vismask(x,y))
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1,vismask(x,y))
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1,vismask(x,y))
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),chr(177),,Font1,custom,@_col
                    else
                        alphav=192
                        if vismask(x,y)=1 then alphav=255
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),alpha,alphav
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),alpha,alphav
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(52),alpha,alphav
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(53),alpha,alphav
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(54),alpha,alphav
                    endif
                endif
                if abs(spacemap(x,y))>=6 and abs(spacemap(x,y)<=17) and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then
                    if (spacemap(x,y)>=6 and spacemap(x,y)<=17) or rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8  then
                        if configflag(con_tiles)=0 then
                            alphav=192
                            if vismask(x,y)=1 then alphav=255
                            put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(49+abs(spacemap(x,y))),alpha,alphav
                        else
                            if abs(spacemap(x,y))>8 then set__color( 3,0,vismask(x,y))
                            if abs(spacemap(x,y))=6 then set__color( 9,0,vismask(x,y))
                            if abs(spacemap(x,y))=7 then set__color( 113,0,vismask(x,y))
                            if abs(spacemap(x,y))=8 then set__color( 53,0,vismask(x,y))
                            draw string (x*_fw1-player.osx*_fw1,y*_fh1-player.osy*_fh1),":",,Font1,custom,@_col
                        endif
                        if spacemap(x,y)<=-6 then ano_money+=5
                        spacemap(x,y)=abs(spacemap(x,y))
                    else
                        set__color( 1,0)
                        if navcom>0 then draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    endif
                endif
            endif
        next
    next

    if reveal=1 and disnbase(player.c,1)>farthestexpedition then farthestexpedition=disnbase(player.c,1)

    a=player.equipment(se_shipdetection)
    if a>0 or ((debug=4 or debug=1024) and _debug=1) then
        if (debug=4 or debug=1024) and _debug=1 then a=1
        for b=6 to lastfleet
            x=fleet(b).c.x
            y=fleet(b).c.y
            if (vismask(x,y)=1 and (distance(player.c,fleet(b).c)<player.sensors or distance(player.c,fleet(b).c)<2)) or ((debug=4 or debug=1024) and _debug=1) then
                set__color( 11,0)
                if a=1 then 'No Friend Foe
                    set__color( 11,0)
                    if configflag(con_tiles)=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),trans
                    else
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
                    if fleet(b).fighting>0 then
                        set__color( 12,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"X",,Font2,custom,@_col
                    endif
                else

                    if configflag(con_tiles)=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),trans
                        if fleet(b).ty=1 or fleet(b).ty=3 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(67),trans
                        if fleet(b).ty=2 or fleet(b).ty=4 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(68),trans
                    else
                        if fleet(b).ty=1 or fleet(b).ty=3 then set__color( 10,0)
                        if fleet(b).ty=2 or fleet(b).ty=4 then set__color( 12,0)
                        if fleet(b).ty=5 then set__color( 5,0)
                        if fleet(b).ty=6 then set__color( 8,0)
                        if fleet(b).ty=7 then set__color( 8,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif

                    if fleet(b).fighting>0 then
                        set__color( 12,0)
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"X",,Font2,custom,@_col
                    endif
                endif
            endif
        next
    endif

    for b=3 to lastfleet
        if fleet(b).ty=10 then 'Eris
            if vismask(fleet(b).c.x,fleet(b).c.y)=1 then
                x=fleet(b).c.x
                y=fleet(b).c.y
                if configflag(con_tiles)=0 then
                    put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(gt_no(88)),trans
                else
                    set__color( rnd_range(1,15),0)
                    draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"@",,Font1,custom,@_col
                endif
            endif
        endif
    next
    for x=1 to lastdrifting
        if drifting(x).x<0 then drifting(x).x=0
        if drifting(x).y<0 then drifting(x).y=0
        if drifting(x).x>sm_x then drifting(x).x=sm_x
        if drifting(x).y>sm_y then drifting(x).y=sm_y
        p.x=drifting(x).x
        p.y=drifting(x).y
        if drifting(x).x=player.c.x and drifting(x).y=player.c.y and drifting(x).p=0 then
            drifting(x).p=1
            walking=0
        endif
        if planets(drifting(x).m).flags(0)=0 then
            set__color( 7,0,vismask(p.x,p.y))
            if drifting(x).s=20 then set__color( 15,0,vismask(p.x,p.y))
            if (a>0 and vismask(p.x,p.y)=1 and distance(player.c,p)<player.sensors) or drifting(x).p>0 then
                if p.x+1-player.osx>=0 and p.x+1-player.osx<=_mwx+1 and p.y+1-player.osy>=0 and p.y+1-player.osy<=21 then
                    if configflag(con_tiles)=0 then
                        if drifting(x).g_tile.x=0 or drifting(x).g_tile.x=5 or drifting(x).g_tile.x>9 then drifting(x).g_tile.x=rnd_range(1,4)
                        alphav=192
                        if vismask(p.x,p.y)=1 then alphav=255
                        put ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),stiles(drifting(x).g_tile.x,drifting(x).g_tile.y),alpha,alphav
                    else
                        draw string ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
                    if debug=111 and _debug=1 then draw string ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),":"&vismask(p.x,p.y),,Font1,custom,@_col
                    if drifting(x).p=0 then walking=0
                    drifting(x).p=1
                endif
            endif
        endif
    next
    if show_NPCs>0 then
        for a=3 to lastfleet
            x=fleet(a).c.x-player.osx
            y=fleet(a).c.y-player.osy
            if x>=0 and x<=_mwx and y>=0 and y<=20 then
                if fleet(a).ty=1 or fleet(a).ty=3 then set__color( 10,0)
                if fleet(a).ty=2 or fleet(a).ty=4 then set__color( 12,0)
                if fleet(a).ty=5 then set__color( 5,0)
                if fleet(a).ty=6 then set__color( 8,0)
                if fleet(a).ty=7 then set__color( 6,0)
                draw string (x*_fw1,(y)*_fh1),"s",,Font1,custom,@_col
            endif
            x=targetlist(fleet(a).t).x-player.osx
            y=targetlist(fleet(a).t).y-player.osy
            if x>=0 and x<=60 and y>=0 and y<=20 then
                set__color( 15,0)
                draw string (x*_fw1,y*_fh1),"*",,Font1,custom,@_col
            endif
        next
    endif
    if show_civs=1 then
        for a=0 to 1
            x=civ(a).home.x-player.osx
            y=civ(a).home.y-player.osy
            if x>=0 and x<=_mwx and y>=0 and y<=20 then
                set__color( 11,0)
                draw string ((x)*_fw1,(y)*_fh1)," "&a,,Font1,custom,@_col
            endif
        next
    endif
    set__color( 11,0)
    if lastcom>ubound(coms) then lastcom=ubound(coms)
    for a=1 to lastcom
        if coms(a).c.x>player.osx and coms(a).c.x<player.osx+60 and coms(a).c.y>player.osy and coms(a).c.y<player.osy+20 then
            draw string ((coms(a).c.x-player.osx)*_fw1,(coms(a).c.y-player.osy)*_fh1),trim(coms(a).t),,Font2,custom,@_tcol
        endif
    next

    for a=0 to laststar+wormhole
        if map(a).spec<=7 then
            vis=maximum(player.sensors+.5,(map(a).spec)-2)
        else
            vis=0
        endif

        if (vismask(map(a).c.x,map(a).c.y)=1 and distance(map(a).c,player.c)<=vis) or map(a).discovered>0 then
            if map(a).discovered=0 and walking<10 then walking=0
            display_star(a)
        endif
    next


'
    for a=1 to lastprobe
        x=probe(a).x-player.osx
        y=probe(a).y-player.osy
        if x>=0 and y>=0 and x<=_mwx and y<=20 then
            if configflag(con_tiles)=0 then
               put ((x)*_fw1,(y)*_fh1),gtiles(gt_no(2117+probe(a).p)),trans
                if _debug>0 then draw string((x)*_fw1,(y)*_fh1),"m:"&probe(a).m &"v5:"&item(probe(a).m).v5 &"z"&probe(a).z
            else
                set__color( _shipcolor,0)
                draw string (x*_fw1,y*_fh1),"s",,Font1,custom,@_col
            endif
        endif
    next
    for a=0 to 2
        if basis(a).c.x>0 and basis(a).c.y>0 then
            if basis(a).discovered>0 then display_station(a)
        endif
    next
    if walking=10 and reveal=1 then
        p1=apwaypoints(lastapwp)
        lastapwp=ap_astar(player.c,p1,apdiff)
        currapwp=0
    endif
    return 0
end function


function display_star(a as short,fbg as byte=0) as short
    dim bg as short
    dim n as short
    dim p as short
    dim as short x,y,debug,s
    'debug=2
    x=map(a).c.x-player.osx
    y=map(a).c.y-player.osy
    if x<0 or y<0 or x>_mwx or y>20 then return 0
    bg=0
    if spacemap(map(a).c.x,map(a).c.y)>=2 then bg=5
    if spacemap(map(a).c.x,map(a).c.y)=6 then bg=1

    if map(a).discovered=2 then bg=1
    for p=1 to 9
        if map(a).planets(p)>0 then
            for n=0 to lastspecial
                set__color( 11,0)
                if map(a).planets(p)=specialplanet(n) and planets(map(a).planets(p)).mapstat>0 then
                    bg=233
                    s=n
                endif
                if show_specials>0 or (debug=2 and _debug=1) then
                    if map(a).planets(p)=specialplanet(n) then
                        set__color( 11,0)
                        draw string((map(a).c.x-player.osx+1)*_fw1,(map(a).c.y-player.osy+1)*_fh1) ,""&n,,font2
                    endif
                endif
            next
            if planets(map(a).planets(p)).colony<>0 then bg=246
        endif
    next
    if map(a).discovered<=0 then
        player.discovered(map(a).spec)=player.discovered(map(a).spec)+1
        map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        map(a).discovered=1
        if map(a).spec=9 then ano_money+=250
    endif
    if configflag(con_tiles)=0 then
        if vismask(map(a).c.x,map(a).c.y)=1 then
            put (x*_tix,y*_tiy),gtiles(map(a).ti_no),alpha,255
        else
            put (x*_tix,y*_tiy),gtiles(map(a).ti_no),alpha,192
        endif
        if fbg=1 then put (x*_tix,y*_tiy),gtiles(85),trans
        set__color( 11,0,vismask(map(a).c.x,map(a).c.y))
        if bg=233 then draw string (x*_tix,y*_tiy),"s",,font2,custom,@_tcol
        if bg=233 and _debug>0 then draw string (x*_tix,y*_tiy),"s:"&s,,font2,custom,@_tcol
        if debug=1 and _debug=1 then draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),""&map(a).discovered,,Font1,custom,@_col
        if debug=5 and _debug=1 then draw string (x*_tix+_tix,y*_tiy),""&map(a).ti_no &":"&map(a).spec,,Font1,custom,@_col
    else
        set__color( spectraltype(map(a).spec),bg,vismask(map(a).c.x,map(a).c.y))
        if map(a).spec<8 then draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"*",,Font1,custom,@_col
        if map(a).spec=8 then
            set__color( 7,bg)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
        endif

        if map(a).spec=9 then
            n=distance(map(a).c,map(map(a).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            set__color( 179+n,bg)
            if fbg=1 then set__color( 179+n,c_gre,1)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
        endif
        if map(a).spec=10 then
            set__color(63,bg)
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"O",,Font1,custom,@_col
        endif
    endif
    return 0
end function

function display_station(a as short) as short
    dim as short x,y,debug,t
    debug=1
    basis(a).discovered=1
    x=basis(a).c.x-player.osx
    y=basis(a).c.y-player.osy
    if a<3 then
        t=a+3*(basis(a).company-1)
    else
        t=2+3*(basis(a).company-1)
    endif
    if x<0 or y<0 or x>_mwx or y>20 then return 0
    set__color( 15,0)
    if configflag(con_tiles)=1 then
        draw string (x*_fw1,y*_fh1),"S",,Font1,custom,@_col
    else
        if vismask(basis(a).c.x,basis(a).c.y)=1 then
            put ((x)*_tix+1,(y)*_tiy+1),gtiles(gt_no(1750+t)),trans
        else
            put ((x)*_tix+1,(y)*_tiy+1),gtiles(gt_no(1750+t)),alpha,192
        endif
    endif
    if distance(player.c,basis(a).c)<player.sensors then
        if fleet(a).fighting<>0 then
            set__color( c_red,0,vismask(basis(a).c.x,basis(a).c.y))
            draw string (x*_fw1,y*_fh1),"x",,Font2,custom,@_col
            if player.turn mod 10=0 then dprint "Station "&a+1 &" is sending a distress signal! They are under attack!",c_red
        endif
    endif
    if debug=1 and _debug=1 then draw string (x*_fw1,y*_fh1),""&count_gas_giants_area(basis(a).c,7) &":"& basis(a).inv(9).v ,,Font2,custom,@_col

    return 0
end function

function display_ship(show as byte=0) as short
    dim  as short a,mjs,wl',b
    dim t as string
    dim as string p,g,s,d,carg
    dim as byte fw1,fh1
    fw1=11
    #ifdef _windows
    Fw1=_fw1
    #endif
    Fh1=22
    
    
    if show=1 then
        if configflag(con_tiles)=0 then
            put ((player.c.x-player.osx)*_tix-(_tiy-_tix)/2,(player.c.y-player.osy)*_tiy),stiles(player.di,player.ti_no),trans
        else
            set__color( _shipcolor,0)
            draw string ((player.c.x-player.osx)*_fw1,(player.c.y-player.osy)*_fh1),"@",,Font1,custom,@_col
        endif
    endif
    
    set__color( 15,0)
    if player.equipment(se_navcom)>0 then
        draw string (0,21*_fh1), "Pos:"&player.c.x &":"&player.c.y,, font2,custom,@_col

    else
        set__color( 14,0)
        draw string (0,21*_fh1), "No navcomp",, font2,custom,@_col
    endif

    draw_border(11)
    set__color( 15,0)
    draw string(sidebar,0*_fh1),(player.h_sdesc &" "& player.desig),,Font2,custom,@_col
    set__color( 11,0)
    draw string(sidebar,1*_fh2),"HP:"&space(4) &" "&"SP:"&player.shieldmax &" ",,Font2,custom,@_col
    if player.hull<(player.h_maxhull+player.addhull)/2 then set__color( 14,0)
    if player.hull<2 then set__color( 12,0)
    draw string(sidebar+3*_fw2,1*_fh2),""&player.hull,,Font2,custom,@_col
    set__color( 11,0)
    p=""&player.pilot(0)
    g=""&player.gunner(0)
    s=""&player.science(0)
    d=""&player.doctor(0)
    if player.pilot(0)<0 then p="{12}-{11}"
    if player.gunner(0)<0 then g="{12}-{11}"
    if player.science(0)<0 then s="{12}-{11}"
    if player.doctor(0)<0 then d="{12}-{11}"
    player.security=0
    for a=2 to 128
       if crew(a).hpmax>=1 and crew(a).typ>=6 then player.security+=1
    next

    textbox("Pi:" & p & " Gu:" &g &" Sc:" &s &" Dr:"&d &"  Security:"&player.security,sidebar,2*_fh2,(_screenx-sidebar)/_fw2,11,0,1 )
    draw string(sidebar,4*_fh2), "Sensors:"&player.sensors,,Font2,custom,@_col

    for a=1 to 5
        if player.weapons(a).made=88 then mjs+=1
        if player.weapons(a).made=89 then mjs+=2
    next
    draw string(sidebar,5*_fh2), "Engine :"&player.engine &" ("&player.movepoints(mjs) &" MP)",,Font2,custom,@_col
    set__color( 15,0)

    wl=display_ship_weapons()
    if wl+4>_lines then
        _lines=wl+4
        save_config(configflag(con_tiles))
        _screeny=_lines*_fh1

        'screenres _screenx,_screeny,8,2,GFX_WINDOWED
    endif
    draw string(sidebar,(wl+4)*_fh2), "Fuel(" &player.fuelmax+player.fuelpod &"):",,Font2,custom,@_col
    set__color( 11,0)
    if player.fuel<(player.fuelmax+player.fuelpod)*0.5 then set__color(c_yel,0)
    if player.fuel<(player.fuelmax+player.fuelpod)*0.2 then set__color(c_red,0)
    draw string(sidebar+11*_fw2,(wl+4)*_fh2) ,space(10-len(round_str(player.fuel,1)))&round_str(player.fuel,1) ,,Font2,custom,@_col

    set__color( 11,0)
    draw string(sidebar,(wl+2)*_fh2),"Credits: "&space(12-len(Credits(player.money)))&Credits(player.money),,Font2,custom,@_col
    draw string(sidebar,(wl+3)*_fh2),display_time(player.turn),,Font2,custom,@_col
    set__color( 15,0)
    draw string(sidebar,wl*_fh2), "Cargo",,font2,custom,@_col
    for a=1 to 10
        carg=""
        if player.cargo(a).x=1 then
            set__color( 8,1)
        else
            set__color( 10,8)
        endif
        if player.cargo(a).x=1 then carg= "E"
        if player.cargo(a).x=2 then carg= "F"
        if player.cargo(a).x=3 then carg= "B"
        if player.cargo(a).x=4 then carg= "T"
        if player.cargo(a).x=5 then carg= "L"
        if player.cargo(a).x=6 then carg= "W"
        if player.cargo(a).x=7 then carg= "N"
        if player.cargo(a).x=8 then carg= "H"
        if player.cargo(a).x=9 then carg= "U"
        if player.cargo(a).x=10 then carg= "f"
        if player.cargo(a).x=11 then carg= "C"
        if player.cargo(a).x=12 then carg= "?"
        if player.cargo(a).x=13 then carg= "t"
        draw string(sidebar+(a-1)*_fw2,(wl+1)*_fh2),carg,,font2,custom,@_col
    next
    wl+=6

    comstr.display(wl)
    set__color( 11,0)
    if player.tractor=0 then player.towed=0
    return wl+4
end function

function explore_space_messages() as short
    static wg as byte
    if player.fuel=player.fuelmax then wg=0

    if player.fuel<(player.fuelmax+player.fuelpod)*0.5 then
        if wg=0 then
            wg=1
            dprint "Fuel low",14
            if configflag(con_sound)=0 or configflag(con_sound)=2 then
                #ifdef _FMODSOUND
                FSOUND_PlaySound(FSOUND_FREE, sound(2))
                #endif
                #ifdef _FBSOUND
                fbs_Play_Wave(sound(2))
                #endif
            endif
            if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
        endif
        set__color( 14,0)

    endif

    if player.fuel<(player.fuelmax+player.fuelpod)*0.2 then
        if wg=1 then
            wg=2
            dprint "Fuel very low",12
            if configflag(con_sound)=0 or configflag(con_sound)=2 then
                #ifdef _FMODSOUND
                FSOUND_PlaySound(FSOUND_FREE, sound(2))
                #endif
                #ifdef _FBSOUND
                fbs_Play_Wave(sound(2))
                #endif
            endif
            if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)

        endif
        set__color( 12,0)
    endif

    if player.turn mod 20=0 then low_morale_message
    return 0
end function

function display_awayteam(showshipandteam as byte=1,osx as short=555) as short
        dim a as short
        dim c as short
        dim x as short
        dim y as short
        dim xoffset as short
        dim t as string
        static wg as byte
        static wj as byte
        dim thp as short
        dim as string poi
        dim as byte fw1,fh1,l
        dim debug as byte=0
        dim as short map
        Fh1=22
        dim as _cords ship
        ship=player.landed
        map=player.map
        if osx=555 then osx=calcosx(awayteam.c.x,planets(map).depth)
        xoffset=22
        locate 22,1
        set__color( 15,0)
        if awayteam.stuff(8)=1 and player.landed.m=map and planets(map).depth=0 then
            set__color( 15,0)
            locate 22,3
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "Pos:"&awayteam.c.x &":"&awayteam.c.y,,Font2,Custom,@_col
        else
            locate 22,1
            set__color( 14,0)
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "no satellite",,Font2,Custom,@_col
        endif
        locate 22,15
        set__color( 15,0)
        if adisloctime=3 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Night",,Font2,Custom,@_col
        if adisloctime=0 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2)," Day ",,Font2,Custom,@_col
        if adisloctime=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dawn ",,Font2,Custom,@_col
        if adisloctime=2 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dusk ",,Font2,Custom,@_col
        if show_mnr=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),""&map &":"&planets(map).flags(1),,Font2,Custom,@_col
        set__color( 10,0)
        locate 22,xoffset
        if awayteam.invis>0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"Camo",,Font2,Custom,@_col
            xoffset=xoffset+5
        endif
        if _autopickup=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"P",,Font2,Custom,@_col
            xoffset+=1
        endif
        if _autoinspect=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"I",,Font2,Custom,@_col
            xoffset+=1
        endif
        if awayteam.helmet=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"O",,Font2,Custom,@_col
        else
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"C",,Font2,Custom,@_col
        endif
        xoffset+=2
        draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),tacdes(player.tactic+3),,Font2,Custom,@_col
        xoffset=xoffset+len(tacdes(player.tactic+3))

        draw_border(xoffset)
        if showshipandteam=1 then
            set__color( 15,0)
            if player.landed.m=map then
                if planetmap(ship.x,ship.y,map)>0 or player.stuff(3)=2 then
                    if configflag(con_tiles)=0 then
                        x=ship.x-osx
                        if x<0 then x+=61
                        if x>60 then x-=61
                        if x>=0 and x<=_mwx then put (x*_tix,ship.y*_tiy),stiles(5,player.ti_no),trans
                    else
                        set__color( _shipcolor,0)
                        draw string((ship.x)*_fw1,ship.y*_fh1),"@",,Font1,custom,@_col
                    endif
                endif
            endif

            if configflag(con_tiles)=0 then
                x=awayteam.c.x-osx
                if x<0 then x+=61
                if x>60 then x-=61
                if x>=0 and x<=_mwx then
                    if awayteam.movetype=mt_fly or awayteam.movetype=mt_flyandhover then put (x*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                    put (x*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                    if awayteam.movetype=mt_hover or awayteam.movetype=mt_flyandhover then put (x*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
                    
                    if show_energy=1 then 
                        set__color(15,0)
                        draw string ((x)*_tix,awayteam.c.y*_tiy),"E:"&awayteam.e.e,,font2,custom,@_tcol
                    endif
                endif
                if _debug=2609 then draw string(x*_tix,awayteam.c.y*_tiy),"e:"&awayteam.e.e
            else
                set__color( _teamcolor,0)
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,Font1,custom,@_col
            endif
        endif

        l=hpdisplay(awayteam)
        set__color( 11,0)
        l+=1
        draw string(sidebar,l*_fh2), "Visibility: " &calc_sight(),,Font2,custom,@_col
        l+=1
        if awayteam.movetype=0 then draw string(sidebar,l*_fh2), "Trp.: None",,Font2,custom,@_col
        if awayteam.movetype=1 then draw string(sidebar,l*_fh2), "Trp.: Hoverplt.",,Font2,custom,@_col
        if awayteam.movetype=2 then draw string(sidebar,l*_fh2), "Trp.: Jetpacks",,Font2,custom,@_col
        if awayteam.movetype=3 then draw string(sidebar,l*_fh2), "Trp.: Jetp&Hover",,Font2,custom,@_col
        if artflag(9)=1 then
            l+=1
            draw string(sidebar,l*_fh2), "      Teleport",,Font2,custom,@_col
        endif
        l+=1
        draw string(sidebar,l*_fh2),"Speed: "&awayteam.speed+stims.effect,,Font2,Custom,@_col
        xoffset=xoffset+8

        l+=2
        draw string(sidebar,l*_fh2),"Armor:    "&awayteam.armor,,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Firearms: "&awayteam.guns_to,,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Melee:    "&awayteam.blades_to,,Font2,custom,@_col
        if player.stuff(3)=2 then
            l+=1
            draw string(sidebar,l*_fh2),"Alien Scanner",,font2,custom,@_col
            l+=1
            draw string(sidebar,l*_fh2),adislastenemy-adisdeadcounter &" Lifeforms ",,Font2,custom,@_col
        endif
        calc_resrev
        l+=2
        draw string(sidebar,l*_fh2),"Map Data  :"& cint(reward(7)),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2), "Bio Data  :"& cint(reward(1)),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2), "Resources :"& cint(reward(2)),,Font2,custom,@_col
        
        for a=1 to player.h_maxweaponslot
            if player.weapons(a).heat>0 then
                l+=2
                l=l+textbox(trim("{15}"&weapon_text(player.weapons(a))),sidebar,(l)*_fh2,20,,0,1)+1
            endif
        next
        
        if (awayteam.movetype=2 or awayteam.movetype=3) and awayteam.hp>0 then
            set__color( 11,0)
            l+=1
            draw string(sidebar,l*_fh2), "Jetpackfuel: ",,Font2,custom,@_col
            set__color( 10,0)
            if awayteam.jpfuel<awayteam.jpfuelmax*.5 then set__color( 14,0)
            if awayteam.jpfuel<awayteam.jpfuelmax*.3 then set__color( 12,0)
            if awayteam.jpfuel<0 then awayteam.jpfuel=0
            if awayteam.hp>0 then
                draw string(sidebar+13*_fw2,l*_fh2), ""&int(awayteam.jpfuel/awayteam.hp),,Font2,custom,@_col
            else
                draw string(sidebar+13*_fw2,l*_fh2), ""&awayteam.jpfuel,,Font2,custom,@_col
            endif
        endif

        if player.turn mod 15=0 then low_morale_message

        set__color( 11,0)
        l+=1
        draw string(sidebar,l*_fh2),"Oxygen: ",,Font2,custom,@_col
        set__color( 10,0)
        if awayteam.oxygen<50 then set__color( 14,0)
        if awayteam.oxygen<25 then set__color( 12,0)
        if awayteam.hp-awayteam.robots>0 then
            draw string(sidebar+8*_fw2,l*_fh2),""&int(awayteam.oxygen/(awayteam.hp-awayteam.robots)),,Font2,custom,@_col
        else
            draw string(sidebar+8*_fw2,l*_fh2),""&awayteam.oxygen,,Font2,custom,@_col
        endif
        set__color( 11,0)
        l+=2
        draw string(sidebar,l*_fh2),"Temp: " &round_nr(adisloctemp,1) &chr(248)&"C",,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),"Gravity: " &planets(map).grav,,Font2,custom,@_col
        if len(trim(tmap(awayteam.c.x,awayteam.c.y).desc))<18 then
            l+=1
            draw string(sidebar,l*_fh2),tmap(awayteam.c.x,awayteam.c.y).desc,,Font2,custom,@_col ';planetmap(awayteam.c.x,awayteam.c.y,map)
        endif
        l+=2
        draw string(sidebar,l*_fh2),"Credits: " &credits(player.money),,Font2,custom,@_col
        l+=1
        draw string(sidebar,l*_fh2),display_time(player.turn),,Font2,custom,@_col
        if debug=1 and _debug=1 then draw string(sidebar,26*_fh2),"life:" &planets(map).life,,Font2,custom,@_col

        comstr.display(l+2)


    return 0
end function

function display_planetmap(slot as short,osx as short,bg as byte) as short

    dim x as short
    dim y as short
    dim b as short
    dim x2 as short
    dim debug as byte

    for x=_mwx to 0 step-1
        for y=0 to 20
            x2=x+osx
            if x2>60 then x2=x2-61
            if x2<0 then x2=x2+61
            if planetmap(x2,y,slot)>0 then
                if tmap(x2,y).no=0 then tmap(x2,y)=tiles(planetmap(x2,y,slot))
                dtile(x,y,tmap(x2,y),bg)
                if _debug=2508 then draw string(x,y),""&planetmap(x2,y,slot)
            endif
            if itemindex.last(x2,y)>0 then
                for b=1 to itemindex.last(x2,y)
                    display_item(itemindex.index(x2,y,b),osx,slot)
                next
            endif
        next
    next

    display_portals(slot,osx)

    return 0
end function

function display_portals(slot as short,osx as short) as short
    dim as short b
    for b=0 to lastportal
        display_portal(b,slot,osx)
    next
    return 0
end function

function display_portal(b as short,slot as short,osx as short) as short
    dim as short x,debug
    x=portal(b).from.x-osx
    if planets(slot).depth=0 then
        if x<0 then x+=61
        if x>60 then x-=61
    else
        if x<0 then x=0
        if x>60 then x=60
    endif
    if x>=0 and x<=_mwx then
        if (portal(b).from.m=slot and portal(b).oneway<2) and (portal(b).discovered=1 or vismask(portal(b).from.x,portal(b).from.y)>0) then
            portal(b).discovered=1
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).from.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
                if _debug>0 then draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),""&portal(b).ti_no,,Font2,custom,@_col
            else
                set__color( portal(b).col,0)
                draw string(x*_fw1,portal(b).from.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    x=portal(b).dest.x-osx
    if planets(slot).depth=0 then
        if x<0 then x+=61
        if x>60 then x-=61
    else
        if x<0 then x=0
        if x>60 then x=60
    endif
    if x>=0 and x<=_mwx then
        if portal(b).oneway=0 and portal(b).dest.m=slot and (portal(b).discovered=1 or vismask(portal(b).dest.x,portal(b).dest.y)>0) then
            if configflag(con_tiles)=0 then
                put ((x)*_tix,portal(b).dest.y*_tiy),gtiles(gt_no(portal(b).ti_no)),trans
            else
                set__color( portal(b).col,0)
                draw string(x*_fw1,portal(b).dest.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    endif
    return 0
end function

function display_monsters(osx as short) as short
    dim as short a,x2
    dim as _cords p
    for a=1 to lastenemy
        if enemy(a).hp<=0 then
            p.x=enemy(a).c.x
            p.y=enemy(a).c.y
            if awayteam.c.x=p.x and awayteam.c.y=p.y and comstr.comdead=0 then
                comstr.t=comstr.t &key_inspect &" Inspect;"
                comstr.comdead=1 'only add it once
            endif
            if  p.y>=0 and p.y<=20 then 'vis_test(awayteam.c,p,planets(slot).depth)=-1 and
                if vismask(p.x,p.y)>0 then
                    set__color( 12,0)
                    if configflag(con_tiles)=0 then
                        if enemy(a).hpmax>0 then put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(1093)),trans
                    else
                        if enemy(a).hpmax>0 then draw string(p.x*_fw1,P.y*_fh1), "%",,font1,custom,@_col
                    endif
                endif
            endif
        endif
    next

    for a=1 to lastenemy
        if enemy(a).ti_no=-1 then enemy(a).ti_no=rnd_range(0,8)+1500 'Assign sprite range
        if enemy(a).hp>0 then
            p=enemy(a).c
            if comstr.comalive=0 and awayteam.c.x>=p.x-1 and awayteam.c.x<=p.x+1 and awayteam.c.y>=p.y-1 and awayteam.c.y<=p.y+1 then
                comstr.t=comstr.t & key_co &" Chat, " & key_of &" Offer;"
                comstr.comalive=1
            endif
            
            x2=enemy(a).c.x-osx
            If x2<0 Then x2+=61
            If x2>60 Then x2-=61
            if x2>=0 and x2<=_mwx and p.y>=0 and p.y<=20 then
                if (vismask(p.x,p.y)>0) or player.stuff(3)=2 then
                    if enemy(a).cmshow=1 then
                        enemy(a).cmshow=0
                        set__color( enemy(a).col,179)
                    else
                        set__color( enemy(a).col,0)
                    endif
                    if enemy(a).invis=0 then 'or (enemy(a).invis=3 and distance(enemy(a).c,awayteam.c)<2) then
                        if configflag(con_tiles)=0 then
                            put ((x2)*_tix,p.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                        else
                            draw string(p.x*_fw1,P.y*_fh1),chr(enemy(a).tile),,font1,custom,@_col
                        endif
                        if enemy(a).sleeping>0 or enemy(a).hpnonlethal>enemy(a).hp then
                            if configflag(con_tiles)=0 then
                                set__color(  203,0)
                                draw string ((x2)*_tix,P.y*_fh1),"z",,font2,custom,@_tcol
                            else
                                set__color(  203,0)
                                draw string ((x2)*_fw1,P.y*_fh1),"z",,font2,custom,@_tcol
                            endif
                        endif
                        if _debug>0 then 
                            Draw String ((p.x-osx)*_fw1,P.y*_fh1),cords(enemy(a).c) & " Made:"&enemy(a).made,,font2,custom,@_tcol
                        endif    
                        if show_energy=1 then 
                            set__color(15,0)
                            draw string ((p.x-osx)*_tix,p.y*_tiy),"E:"&enemy(a).e.e,,font2,custom,@_tcol
                        endif
                        if player.stuff(3)<>2 and enemy(a).sleeping=0 and enemy(a).aggr=0 then walking=0
                    endif
                endif
            endif
        endif
    next


    return 0
end function

function display_item(i as integer,osx as short,slot as short) as short
    dim as _cords p
    dim as short x2,bg,fg,alp
    If item(i).w.s=0 And item(i).w.p=0 Then
        p.x=item(i).w.x
        p.y=item(i).w.y
        If awayteam.c.x=p.x And awayteam.c.y=p.y And comstr.comitem=0 Then
            comstr.t=comstr.t &key_pickup &" Pick up;"
            comstr.comitem=1
        EndIf
            
        If  item(i).w.s=0 and item(i).discovered=1 or (tiles(Abs(planetmap(p.x,p.y,slot))).hides=0 and vismask(item(i).w.x,item(i).w.y)>0) Then
            If item(i).discovered=0 And walking<11 Then walking=0
            item(i).discovered=1
            If tiles(Abs(planetmap(item(i).w.x,item(i).w.y,slot))).walktru>0 And item(i).bgcol=0 Then
                bg=tiles(Abs(planetmap(item(i).w.x,item(i).w.y,slot))).col
            Else
                If item(i).bgcol>=0 Then bg=item(i).bgcol
            EndIf
            If item(i).col>0 Then
                fg=item(i).col
            Else
                fg=rnd_range(Abs(item(i).col),Abs(item(i).bgcol))
            EndIf
            set__color( fg,bg)
            If configflag(con_tiles)=0 Then
                p.x=item(i).w.x
                p.y=item(i).w.y
                If vismask(p.x,p.y)=0 Then
                    alp=197
                Else
                    alp=255
                EndIf
                x2=item(i).w.x-osx
                If x2<0 Then x2+=61
                If x2>60 Then x2-=61
                Put (x2*_tix,item(i).w.y*_tiy),gtiles(gt_no(item(i).ti_no)),alpha,alp
                If _debug=2904 Then Draw String(x*_tix,item(i).w.y*_tiy),cords(item(i).vt) &":"&item(i).w.m,,font1,custom,@_tcol'REMOVE
            Else
                If configflag(con_transitem)=1 Then
                    Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_col
                Else
                    If item(i).bgcol<=0 Then
                        set__color( 241,0)
                        Draw String(p.x*_fw1-1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1+1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1,P.y*_fh1+1), item(i).ICON,,font1,custom,@_tcol
                        Draw String(p.x*_fw1,P.y*_fh1-1), item(i).ICON,,font1,custom,@_tcol
                        set__color( fg,bg)
                        Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_tcol
                    Else
                        Draw String(p.x*_fw1,P.y*_fh1), item(i).ICON,,font1,custom,@_col
                    EndIf
                EndIf
            EndIf
        EndIf
    endif
    return 0
end function

function display_ship_weapons(m as short=0) as short
    dim as short a,b,bg,wl,ammo,ammomax,c,empty
    dim as string text
    set__color( 15,0)
    draw string ((_mwx+1)*_fw1+_fw2,7*_fh2), "Weapons:",,font2,custom,@_col
    set__color( 11,0)
    wl=9
    for a=1 to player.h_maxweaponslot
        if m<>0 and a=m then
            bg=1
        else
            bg=0
        endif
        if player.weapons(a).ammomax>0 then 
            ammo+=player.weapons(a).ammo
            ammomax+=player.weapons(a).ammomax
        endif
        text=weapon_text(player.weapons(a))
        if text<>"" then
            c=c+textbox(trim("{15}"&text),sidebar,(8+c)*_fh2,20,,bg,1)+1
        else
            empty+=1
        endif
    next

    if empty>0 then
        set__color(15,0)
        if empty=1 then draw string(sidebar,(8+c)*_fh2), "Empty turret",,Font2,custom,@_col
        if empty>1 then draw string(sidebar,(8+c)*_fh2), empty &" empty turrets",,Font2,custom,@_col
        c+=1
    endif
    c+=1
    if ammo>0 then
        set__color(15,0)
        draw string(sidebar,(8+c)*_fh2), "Loadout ("& ammomax &"/"&ammo &"):",,Font2,custom,@_col
        set__color(11,0)
        draw string(sidebar,(9+c)*_fh2), ammotypename(player.loadout),,Font2,custom,@_col
        draw string(sidebar,(10+c)*_fh2), "Damage: "&player.loadout+1,,Font2,custom,@_col
        wl+=3
    endif
    set__color( 11,0)


    wl=wl+c
    return wl
end function



function display_system(in as short,forcebar as byte=0,hi as byte=0) as short
    dim as short a,b,bg,x,y,debug,fw1
    dim as string bl,br
    'localdebug=2
    if _fw1<_tix then
        fw1=_fw1
    else
        fw1=_tix
    endif
    debug=0
    if configflag(con_onbar)=0 or forcebar=1 then
        y=21
        x=_mwx/2-2
        bl=chr(180)
        br=chr(195)
    else
        x=((map(in).c.x-player.osx)*fw1-12*_fw2)/_fw1
        y=map(in).c.y+1-player.osy
        if x<0 then x=0
        if configflag(con_sysmaptiles)=0 then
            if x*fw1+18*_tix>_mwx*fw1 then x=(_mwx*fw1-18*_tix)/fw1
        else
            if x*fw1+24*_fw2>_mwx*fw1 then x=(_mwx*fw1-24*_fw2)/fw1
        endif
        'if x*fw1+(25*_fw2)/fw1>_mwx*fw1 then x=_mwx*fw1-(25*_fw2)/fw1
        bl="["
        br="]"
    endif
    display_sysmap(x*fw1,y*_fh1,in,hi,bl,br)
    set__color( 11,0)
    if debug=1 and _debug=1 then
        bl=""
        for a=1 to 9
            bl=bl &map(in).planets(a)&" "
            if map(in).planets(a)>0 then
                bl=bl &"ms:"&map(in).planets(a)
            endif
        next
        dprint bl &":"& hi
    endif
    if debug=2 and _debug=1 then dprint ""&x
    return 0
end function

function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
    dim as short a,b,c,bg,yof,ptile,alp,spec
    dim t as string
    set__color( 224,0)
    yof=(_fh1-_fh2)/2
    if configflag(con_sysmaptiles)=0 then
        line (x,y)-(x+19*_tix,y+_tiy+6),RGB(0,0,0),BF
        line (x,y+1)-(x+19*_tix,y+_tiy+6),RGB(0,0,255),B
        'draw string(x,y),bl ,,font1,custom,@_col
        'draw string(x+19*_tix,y),br ,,font1,custom,@_col

    else
        draw string(x,y),bl ,,font1,custom,@_col
        draw string (x+_fw2,y+yof), space(25),,font2,custom,@_col
        draw string(x+25*_fw2,y),br ,,font1,custom,@_col
    endif
    set__color( spectraltype(map(in).spec),0)
    if configflag(con_sysmaptiles)=0 then
        if spectraltype(map(in).spec)>0 then put (x+_fw1,y),gtiles(gt_no(1599+map(in).spec)),trans
    else
        draw string(x+_fw1,y), "*"&space(2),,font1,custom,@_col
    endif
    for a=1 to 9
        bg=0
        spec=0
        if map(in).planets(a)>0 then
            if is_special(map(in).planets(a)) and planets(map(in).planets(a)).mapstat<>0 then
                bg=233
                spec=1
            endif
        endif
        if hi=a then bg=11
        t=" "

        if map(in).planets(a)<>0 then
                ptile=0
                alp=255
                if is_gasgiant(map(in).planets(a))<>0 then
                    t="O"
                    if a<6 then
                        set__color( 162,bg)
                        ptile=1612
                    endif
                    if a=1 then
                        set__color( 164,bg)
                        ptile=1613
                    endif
                    if a>5 or map(in).spec=10 then
                        set__color( 63,bg)
                        ptile=1614
                    endif
                endif
                if is_asteroidfield(map(in).planets(a))<>0 then
                    t=chr(176)
                    set__color( 7,bg)
                    ptile=1608
                endif
                if is_asteroidfield(map(in).planets(a))=0 and is_gasgiant(map(in).planets(a))=0 and map(in).planets(a)>0 then
                    t="o"
                    ptile=1609

                    if planets(map(in).planets(a)).atmos=0 then planets(map(in).planets(a)).atmos=1
                    if planets(map(in).planets(a)).mapstat=0 then set__color( 7,bg)
                    if planets(map(in).planets(a)).mapstat=1 then
                        alp=197
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 15,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color( 101,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color( 210,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 10,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                    if planets(map(in).planets(a)).mapstat=2 then
                        if planets(map(in).planets(a)).atmos=1 then
                            set__color( 8,bg)
                            ptile=1616
                        endif
                        if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then
                            set__color(9,bg)
                            ptile=1619
                        endif
                        if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then
                            set__color(198,bg)
                            ptile=1622
                        endif
                        if planets(map(in).planets(a)).atmos>11 then
                            set__color( 54,bg)
                            ptile=1625
                        endif
                        if planets(map(in).planets(a)).grav<0.8 then ptile+=1
                        if planets(map(in).planets(a)).grav>1.2 then ptile-=1
                    endif
                endif
            if configflag(con_sysmaptiles)=0 then
                if ptile>0 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(ptile)),alpha,alp
                if bg=11 then put (x+_tix*(a*1.5+4),y+yof),gtiles(gt_no(1610)),trans
                if spec=1 then
                    set__color(11,0)
                    draw string(x+_tix*(a*1.5+4),y+yof),"s",,font2,custom,@_tcol
                endif
            else
                draw string(x+_fw2*(a*2+4),y+yof),t,,font2,custom,@_col
                if spec=1  then
                    set__color(11,0)
                    draw string(x+_fw2*(a*2+5),y+yof),"s",,font2,custom,@_tcol
                endif
            endif
        endif
    next
    return 0
end function

function dtile(x as short,y as short, tiles as _tile,visible as byte) as short
    dim as short col,bgcol,slot,tino
    slot=player.map
    col=tiles.col
    bgcol=tiles.bgcol
    tino=tiles.ti_no
    if tino>1000 then
        tino=2500+(tino-2500)+planets(slot).wallset*10
    endif
    'if tiles.walktru=5 then bgcol=1
    if tiles.col<0 and tiles.bgcol<0 then
        col=col*-1
        bgcol=bgcol*-1
        col=rnd_range(col,bgcol)
        bgcol=0
    endif
    if configflag(con_tiles)=0 then
        if visible=1 then
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),pset
        else
            put (x*_tix,y*_tiy),gtiles(gt_no(tino)),alpha,196
        endif
    else
        if configflag(con_showvis)=0 and visible>0 and bgcol=0 then
            bgcol=234
        endif
        set__color( col,bgcol,visible)
        draw string (x*_fw1,y*_fh1),chr(tiles.tile),,Font1,custom,@_col
    endif
    set__color( 11,0)
    return 0
end function


function nextplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p+1
        if p>9 then p=1
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

function prevplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p-1
        if p<1 then p=9
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function
'

function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
    dim osx as short
    dim as string key
    display_planetmap(mapslot,osx,1)
    display_ship
    do
        key=planet_cursor(p,mapslot,osx,shteam)
        key=cursor(p,mapslot,osx)
    loop until key=key__esc or key=key__enter

    return key
end function

function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string
    dim key as string
    screenset 0,1
    cls
    osx=calcosx(p.x,planets(mapslot).depth)
    display_planetmap(mapslot,osx,4)
    if shteam=0 then
        draw_border(0)
    else
        display_awayteam(,osx)
    endif
    if planetmap(p.x,p.y,mapslot)>0 then
        dprint cords(p)&": "&tiles(planetmap(p.x,p.y,mapslot)).desc
    else
        dprint cords(p)&": "&"Unknown"
    endif
    flip
    return key
end function

function getplanet(sys as short,forcebar as byte=0) as short
    dim as short r,p,a,b
    dim as string text,key
    dim as _cords p1
    if sys<0 or sys>laststar then
        dprint ("ERROR:System#:"&sys,14)
        return -1
    endif
    map(sys).discovered=2
    p=liplanet
    if p<1 then p=1
    if p>9 then p=9
    if map(sys).planets(p)=0 then p=nextplan(p,sys)
    for a=1 to 9
        if map(sys).planets(a)<>0 then b=1
    next
    if b>0 then
        dprint "Enter to select, arrows to move,ESC to quit"
        if show_mapnr=1 then dprint map(sys).planets(p)&":"&is_gasgiant(map(sys).planets(p))
        do
            display_system(sys,,p)
            key=""
            key=keyin
            if keyplus(key) or key=key_east or key=key_north then p=nextplan(p,sys)
            if keyminus(key) or key=key_west or key=key_south then p=prevplan(p,sys)
            if key=key_comment then
                if map(sys).planets(p)>0 then
                    dprint "Enter comment on planet: "
                    p1=locEOL
                    planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
                endif
            endif
            if key="q" or key="Q" or key=key__esc then r=-1
            if (key=key__enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
        loop until r<>0
        liplanet=r

    else
        r=-1
    endif
    return r
end function

'function getplanet(sys as short,forcebar as byte=0) as short
'    dim as short a,r,p,x,xo,yo
'    dim text as string
'    dim key as string
'    dim firstplanet as short
'    dim lastplanet as short
'    dim p1 as _cords
'    if sys<0 or sys>laststar then
'        dprint ("ERROR:System#:"&sys,14)
'        return -1
'    endif
'    for a=1 to 9
'        if map(sys).planets(a)<>0 then
'            lastplanet=a
'            x=x+1
'        endif
'    next
'    for a=9 to 1 step-1
'        if map(sys).planets(a)<>0 then firstplanet=a
'    next
'    p=liplanet
'    if p<1 then p=1
'    if p>9 then p=9
'    if map(sys).planets(p)=0 then
'        do
'            p=p+1
'            if p>9 then p=1
'        loop until map(sys).planets(p)<>0 or lastplanet=0
'    endif
'    if p>9 then p=firstplanet
'    if lastplanet>0 then
'        if _onbar=0 or forcebar=1 then
'            xo=31
'            yo=22
'        else
'            xo=map(sys).c.x-9-player.osx
'            yo=map(sys).c.y+2-player.osy
'            if xo<=4 then xo=4
'            if xo+18>58 then xo=42
'        endif
'        dprint "Enter to select, arrows to move,ESC to quit"
'        if show_mapnr=1 then dprint map(sys).planets(p)&":"&isgasgiant(map(sys).planets(p))
'        do
'            displaysystem(sys)
'            if keyplus(key) or a=6 then
'                do
'                    p=p+1
'                    if p>9 then p=1
'                loop until map(sys).planets(p)<>0
'            endif
'            if keyminus(key) or a=4 then
'                do
'                    p=p-1
'                    if p<1 then p=9
'                loop until map(sys).planets(p)<>0
'            endif
'            if p<1 then p=lastplanet
'            if p>9 then p=firstplanet
'            x=xo+(p*2)
'            if left(displaytext(25),14)<>"Asteroid field" or left(displaytext(25),15)<>"Planet at orbit" then dprint "System " &map(sys).desig &"."
'            if map(sys).planets(p)>0 then
'                if planets(map(sys).planets(p)).comment="" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if planets(map(sys).planets(p)).mapstat<>0 then
'                            if isgasgiant(map(sys).planets(p))<>0 then
'                                if p>1 and p<7 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                                if p>6 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                                if p=1 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                            else
'                                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then displaytext(25)="Planet at orbit " &p &". " &atmdes(planets(map(sys).planets(p)).atmos) &" atm., " &planets(map(sys).planets(p)).grav &"g grav."
'                            endif
'                        else
'                            displaytext(25)= "Planet at orbit " &p &"."
'                        endif
'                    endif
'                endif
'                if planets(map(sys).planets(p)).comment<>"" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    else
'                        displaytext(25)= "Planet at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    endif
'                endif
'                dprint ""
'                locate yo,x
'                set__color( 15,3
'                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then print "o"
'                if isgasgiant(map(sys).planets(p))>0 then print "O"
'                if isasteroidfield(map(sys).planets(p))=1 then print chr(176)
'                set__color( 11,0
'            endif
'
'            if map(sys).planets(p)<0 then
'                if map(sys).planets(p)<0 then
'                    if isgasgiant(map(sys).planets(p))=0 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if map(sys).planets(p)=-20001 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                        if map(sys).planets(p)=-20002 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                        if map(sys).planets(p)=-20003 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                    endif
'                    dprint ""
'                endif
'                locate yo,x
'                set__color( 15,3
'                if isgasgiant(map(sys).planets(p))=0 then
'                    print chr(176)
'                else
'                    print "O"
'                endif
'                set__color( 11,0
'            endif
'            key=keyin
'            if key=key_comment then
'                dprint "Enter comment on planet: "
'                p1=locEOL
'                planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
'            endif
'            a=Getdirection(key)
'
'
'            if key="q" or key="Q" or key=key__esc then r=-1
'            if (key=key__enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
'        loop until r<>0
'        liplanet=r
'    else
'        r=-1
'    endif
'    return r
'end function
'

function shipstatus(heading as short=0) as short
'    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,offset,mjs,filter
'    dim as short a,b,c,lastinv,set,tlen,cx,cy
'    dim as string text,key
'    dim inv(256) as _items
'    dim invn(256) as short
'    dim cargo(12) as string
'    dim cc(12) as short
    dim as short cw,turrets,a,offset
    set__color( 0,0)
    cls
    do
        cw=(_screenx-16*_fw2)/3.5
        cw=cw/_fw2
        if heading=0 then textbox("{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig,1,0,40)

        textbox(shipstatsblock &"||" & weapon_string &"|" & cargo_text ,1,2,cw)

        textbox(crewblock,(2+cw)*_fw2/_fw1,2,16)

        textbox(list_artifacts(artflag()),(2+18+cw)*_fw2/_fw1,2,cw)

        if heading=0 then
            textbox(list_inventory,(2+18+2*cw)*_fw2/_fw1,2,cw,,,,,offset)

            no_key=keyin
            if no_key="+" then offset+=1
            if no_key="-" then offset-=1
        endif
    loop until not(no_key="+" or no_key="-")
    cls
    return 0
end function

function textbox(text as string,x as short,y as short,w as short,_
    fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
    'op=1 only count lines, don't print
    dim as short lastspace,tlen,p,wcount,lcount,xw,a,longestline,linecount,maxlines,blocks,debug
    dim words(6023) as string
    dim addt as string
    addt=text
    debug=22

    if pixel=0 then
        x=x*_fw1
        y=y*_fh1
    endif
    maxlines=(20*_fh1-y)/_fh2
    'if len(text)<=w then addt(0)=text
    for p=0 to len(text)
        if mid(text,p,1)="{" or mid(text,p,1)="|" then wcount+=1
        words(wcount)=words(wcount)&mid(text,p,1)
        if mid(text,p,1)=" " or mid(text,p,1)="|" or  mid(text,p,1)="}" then wcount+=1
    next
    if words(wcount)<>"|" and bg<>0 and pixel=0 then
        wcount+=1
        words(wcount)="|"
    endif
    set__color( fg,bg)
    'Count lines
    for p=0 to wcount
        if words(p)="|" then
            linecount+=1
            xw=0
        else
            if xw+len(words(p))>w then
                linecount+=1
                xw=0
            endif
            xw=xw+len(words(p))
        endif
    next
    xw=0
    if offset>0 and linecount-offset<maxlines-1 then offset=linecount-maxlines-1
    if offset<0 then offset=0

    for p=0 to wcount

        if words(p)="|" then 'New line
            if op=0 and lcount-offset>=0  and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),space(w-xw),,font2,custom,@_col
            lcount=lcount+1
            xw=0
        endif

        if Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}" then 'Color
            set__color( numfromstr(words(p)),bg)
        endif

        if words(p)<>"|" and not(Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}") then 'Print word
            if xw+len(words(p))>w then 'Newline
                if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),space(w-xw),,font2,custom,@_col
                lcount=lcount+1
                xw=0
            endif
            if op=0 and lcount-offset>=0 and (lcount-offset)<=maxlines then draw string((x)+xw*_fw2,y+(lcount-offset)*_fh2),words(p),,font2,custom,@_col
            xw=xw+len(words(p))
            if xw>longestline then longestline=xw
        endif

        if (lcount-offset)>maxlines then 'Too long
            if op<>0 then
                op=longestline
                return lcount
            endif
            set__color( fg,bg)
        endif
    next
    if linecount>maxlines then
        if offset>0 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        draw string(x+w*_fw2-_fw2,y),chr(24),,font2,custom,@_col
        draw string(x+w*_fw2-_fw2,y+_fh2),"-",,font2,custom,@_col
        if offset+maxlines<linecount-1 then
            set__color(14,0)
        else
            set__color(14,0,0)
        endif
        draw string(x+w*_fw2-_fw2,y+maxlines*_fh2-_fh2),"+",,font2,custom,@_col
        draw string(x+w*_fw2-_fw2,y+maxlines*_fh2),chr(25),,font2,custom,@_col

        if debug=1 and _debug=1 then dprint "LC:" &linecount &"ML:"&maxlines
        scroll_bar(offset,linecount,maxlines,maxlines-4,x+w*_fw2-_fw2,y+2*_fh2,14)
    endif
    text=addt
    set__color(11,0)
    op=longestline
    return lcount
end function

function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short
    dim as single part,i,balkenh,offset2,oneline
    oneline=winhigh/(linetot-1)
    balkenh=cint(lineshow*oneline)
    offset2=cint(offset*oneline)
    for i=0 to winhigh
        if i>=offset2 and i<=offset2+balkenh then
            set__color(col,0)
        else
            set__color(0,0)
        end if

        draw string(x,y+(i)*_fh2),chr(178),,font2,custom,@_col
    next
    return 0
end function


function locEOL() as _cords
    'puts cursor at end of last displayline
    dim as short y,x,a,winh,firstline
    dim as _cords p
    winh=fix((_screeny-_fh1*22)/_fh2)-1
    do
        firstline+=1
    loop until firstline*_fh2>=22*_fh1

    y=firstline+winh
    for a=firstline+winh to firstline step -1
        if displaytext(a+1)="" then y=a
    next
    x=len(displaytext(y))+1
    p.x=x
    p.y=y
    return p
end function

function scrollup(b as short) as short
    dim as short a,c
    for c=0 to b
        for a=0 to 254
            displaytext(a)=displaytext(a+1)
            dtextcol(a)=dtextcol(a+1)
        next
        displaytext(255)=""
        dtextcol(255)=11
    next
    return 0
end function

function dprint(t as string, col as short=11) as short
    dim as short a,b,c,delay
    dim text as string
    dim wtext as string
    'static offset as short
    dim tlen as short
    'dim addt(64) as string
    dim lastspace as short
    dim key as string
    dim as short winw,winh
    dim firstline as byte
    dim words(4064) as string
    static curline as single
    static lastmessage as string
    static lastmessagecount as short
    firstline=fix((22*_fh1)/_fh2)
    winw=fix(((_fw1*_mwx+1))/_fw2)
    winh=fix((_screeny-_fh1*22-_fh2)/_fh2)
    if t<>"" then
'    firstline=0
'    do
'        firstline+=1
'    loop until firstline*_fh2>=22*_fh1
'
    if _fh1=_fh2 then
        firstline=22
        winh=_lines-22
    endif
    curline=locEOL.y+1
    for a=0 to len(t)
        if mid(t,a,1)<>"|" then text=text & mid(t,a,1)
    next
    if text<>"" and len(text)<winw-4 then
        if lastmessage=t then
            a=curline-1
            lastmessagecount+=1
            if len(displaytext(a))<winw-4 then
                displaytext(a)=text &"(x"&lastmessagecount &")"
                t=""
            else
                displaytext(a)=text
                displaytext(a+1)="(x"&lastmessagecount &")"
                t=""
            endif
            text=""
        else
            lastmessage=t
            lastmessagecount=1
        endif
    endif

    'draw string (61*_fw1,firstline*_fh2),"*",,font1,custom,@_col
    'draw string (61*_fw1,(firstline+winh)*_fh2),"*",,font1,custom,@_col
    'find offset
    'if offset=0 then offset=firstline

    if text<>"" then
        while displaytext(curline)<>""
            curline+=1
        wend
        for a=0 to len(text)
            words(b)=words(b)&mid(text,a,1)
            if mid(text,a,1)=" " then b+=1
        next
        for a=0 to b
            if instr(ucase(words(a)),"\C")>0 then
                words(a)="Ctrl-"&right(trim(words(a)),1) &" "
            endif
        next
        for a=0 to b
            if len(displaytext(curline+tlen))+len(words(a))>=winw then
                displaytext(curline+tlen)=trim(displaytext(curline+tlen))
                tlen+=1
            endif
            displaytext(curline+tlen)=displaytext(curline+tlen)&words(a)
            dtextcol(curline+tlen)=col
        next

        if curline+tlen>firstline+winh then
            if tlen<winh then
                scrollup(tlen-1)
            else
                do
                    scrollup(winh-2)
                    for b=firstline to firstline+winh
                        set__color( 0,0)
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
                        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
                        set__color( dtextcol(b),0)
                        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
                    next
                    set__color( 14,1)
                    if displaytext(firstline+winh+1)<>"" then
                        draw string((winw+1)*_fw2,_screeny-_fh2), chr(25),,font2,custom,@_col
                        no_key=keyin
                    endif
                loop until displaytext(_textlines+1)=""
            endif
        else
            if curline=firstline+winh then scrollup(0)
        endif
        while displaytext(_textlines+1)<>""
            scrollup(0)
            wend
        endif
    endif
    for b=firstline to firstline+winh
        set__color( 0,0)
        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
        set__color( dtextcol(b),0)
        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
    next
    locate 24,1
    set__color( 11,0)
    return 0
end function


function getmonster() as short
    dim as short d,e,c
    d=0
    for c=1 to lastenemy 'find dead that doesnt respawn
        if enemy(c).respawns=0 and enemy(c).hp<=0 then return c
    next
    if d=0 then
        lastenemy=lastenemy+1
        d=lastenemy
        if d>255 then
            lastenemy=255
            d=255
        endif
    endif
    return d
end function

'function getshipweapon() as short
'    dim as short a,b,c
'    dim p(7) as short
'    dim t as string
'    t="Chose weapon/"
'    for a=1 to 5
'        if player.weapons(a).dam>0 then
'            b=b+1
'            p(b)=a
'            t=t &player.weapons(a).desig & "/"
'        endif
'    next
'    b=b+1
'    p(b)=-1
'    t=t &"Cancel"
'    c=b-1
'    if b>1 then c=p(menu(t))
'    return c
'end function


function changetile(x as short,y as short,m as short,t as short) as short
    if planetmap(x,y,m)<0 then
        planetmap(x,y,m)=abs(t)*-1
    else
        planetmap(x,y,m)=abs(t)
    endif
    tmap(x,y)=tiles(t)
    return 0
end function