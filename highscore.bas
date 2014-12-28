'
' Calculate and display Highscore and post-mortem
'

function space_mapbmp() as short
    dim as any ptr img
    dim as short x,y,a,n,ti_no,minx,maxx,miny,maxy,t
    dim as byte debug=1
    if debug=1  and _debug=1 then dprint "configflag(con_tiles)"&configflag(con_tiles)
    minx=-1
    miny=-1
    maxx=-1
    maxy=-1
    for x=0 to sm_x
        for y=0 to sm_y
            if debug=1 and _debug=1 then spacemap(x,y)=abs(spacemap(x,y))
            if spacemap(x,y)>0 then
                if minx=-1 or minx>x then minx=x
                if miny=-1 or miny>y then miny=y
                if maxx=-1 or maxx<x then maxx=x
                if maxy=-1 or maxy<y then maxy=y
            endif
        next
    next
    
    for a=1 to laststar+wormhole
        if map(a).discovered>0 then
            x=map(a).c.x
            y=map(a).c.y
            if minx=-1 or minx>x then minx=x
            if miny=-1 or miny>y then miny=y
            if maxx=-1 or maxx<x then maxx=x
            if maxy=-1 or maxy<y then maxy=y
        endif
    next
    
    for a=1 to lastdrifting
        if drifting(a).p=1 then
            x=drifting(a).x
            y=drifting(a).y
            if minx=-1 or minx>x then minx=x
            if miny=-1 or miny>y then miny=y
            if maxx=-1 or maxx<x then maxx=x
            if maxy=-1 or maxy<y then maxy=y
        endif
    next
    if maxx-minx<25 then
        maxx+=12
        minx-=12
        if minx<0 then minx=0
        if maxx>sm_x then maxx=sm_x
    endif
    
    img=imagecreate((maxx-minx+1)*_fw1,(maxy-miny+1)*_fh1,rgba(0,0,77,0))
    
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then
                if configflag(con_tiles)=0 then
                    if spacemap(x,y)=1 then put img,((x-minx)*_tix,(y-miny)*_tiy),gtiles(50),pset
                    if spacemap(x,y)>=2 and spacemap(x,y)<=20 then
                        if spacemap(x,y)>10 then 
                            ti_no=spacemap(x,y)-10
                        else
                            ti_no=spacemap(x,y)
                        endif
                        put img,((x-minx)*_tix,(y-miny)*_tiy),gtiles(ti_no+49),trans
                    endif
                else
                    set__color(1,0)
                    if spacemap(x,y)=1 then draw string img,((x-minx)*_fw1,(y-miny)*_fh1),".",,Font1,custom,@_col
                    
                    if spacemap(x,y)>=2 and spacemap(x,y)<=5 then
                        set__color( rnd_range(48,59),1)
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(48,59),1)
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(96,107),1)
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(144,155),1)
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot(0)>8 then set__color( rnd_range(192,203),1)
                        draw string img,((x-minx)*_fw1,(y-miny)*_fh1),chr(176),,Font1,custom,@_col
                    endif
                    if spacemap(x,y)>5 then
                        if spacemap(x,y)>10 then
                            ti_no=spacemap(x,y)-10
                        else
                            ti_no=spacemap(x,y)
                        endif
                        if ti_no=6 then set__color( 2,0)
                        if ti_no=7 then set__color( 10,0)
                        if ti_no=8 then set__color( 4,0)
                        if ti_no=9 then set__color( 12,0)
                        if ti_no=10 then set__color( 3,0)
                        draw string img,((x-minx)*_fw1,(y-miny)*_fh1),":",,Font1,custom,@_col
                    endif
                endif
            endif
        next
    next
    for a=1 to lastdrifting
        if drifting(a).p=1 or (debug=1  and _debug=1) then
            if configflag(con_tiles)=0 then
                if drifting(a).g_tile.x=0 or drifting(a).g_tile.x=5 or drifting(a).g_tile.x>9 then drifting(a).g_tile.x=rnd_range(1,4)
                put img,((drifting(a).x-minx)*_fw1,(drifting(a).y-miny)*_fh1),stiles(drifting(a).g_tile.x,drifting(a).g_tile.y),trans
            else
                set__color(7,0)
                draw string img,((drifting(a).x-minx)*_fw1,(drifting(a).y-miny)*_fh1),"s",,Font1,custom,@_col
            endif
        endif
    next
    for a=0 to laststar+wormhole
        if map(a).discovered>0  or (debug=1 and _debug=1) then
            if configflag(con_tiles)=0 then
                put img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),gtiles(map(a).ti_no),trans
            else
                set__color( spectraltype(map(a).spec),0)
                if map(a).spec<8 then draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"*",,Font1,custom,@_tcol
                if map(a).spec=8 then     
                    set__color( 7,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"o",,Font1,custom,@_tcol
                endif
                if map(a).spec=9 then 
                    n=distance(map(a).c,map(map(a).planets(1)).c)/5
                    if n<1 then n=1
                    if n>6 then n=6
                    set__color( 179+n,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"o",,Font1,custom,@_tcol
                endif
                if map(a).spec=10 then
                    set__color(63,0)
                    draw string img,((map(a).c.x-minx)*_fw1,(map(a).c.y-miny)*_fh1),"O",,Font1,custom,@_col
                endif
            endif
        endif
    next
    for a=0 to 2
        if basis(a).c.x>=minx and basis(a).c.y>=miny and basis(a).c.x<=maxx and basis(a).c.y<=maxy then
            if configflag(con_tiles)=1 then
                set__color(15,0)
                draw string img,((basis(a).c.x-minx)*_fw1,(basis(a).c.y-miny)*_fh1),"S",,Font1,custom,@_col
            else
                if a<3 then
                    t=a+3*(basis(a).company-1)
                else
                    t=2+3*(basis(a).company-1)
                endif
                put img,((basis(a).c.x-minx)*_tix,(basis(a).c.y-miny)*_tiy),gtiles(1750+t),trans
            endif
        endif
    next
    if configflag(con_tiles)=0 then
        put img,((player.c.x-minx)*_tix-(_tiy-_tix)/2,(player.c.y-miny)*_tiy),stiles(player.di,player.ti_no),trans
    else
        set__color( _shipcolor,0)
        draw string img,((player.c.x-minx)*_fw1,(player.c.y-miny)*_fh1),"@",,Font1,custom,@_col
    endif
    if debug=1 and _debug=1 then
        set__color(15,0)
        for a=11 to lastwaypoint
            x=targetlist(a).x
            y=targetlist(a).y
            if x>=minx and x<=maxx and y>=miny and y<=maxx then
                draw string img,((targetlist(a).x-minx)*_tix,(targetlist(a).y-miny)*_tiy),"*",,font1,custom,@_col
            endif
        next
    endif
    savepng( "summary/" &player.desig &"-map.png", img, 1)
    imagedestroy img
    return 0
end function

    
function death_message() as short
    dim as string text,text2
    dim as short b,a,wx,tx
    text=""
    
    if not fileexists("summary/"&player.desig &".png") then screenshot(3)
    cls
    background(rnd_range(1,_last_title_pic)&".bmp")
    set__color( 12,0)
    text=death_text()
    text2=text
    if text<>"" and player.dead<>98 then
        set__color( 11,0)
        
        b=0
        tx=_screenx/_fw1-10
        while len(text)>tx
            a=40
            do 
                a=a-1
            loop until mid(text,a,1)=" "        
            draw_string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(_screeny/15),left(text,a),TITLEFONT,_tcol)
            text=mid(text,a,(len(text)-a+1))
            b=b+1
        wend
        draw_string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(_screeny/15),text,TITLEFONT,_tcol)
        
    endif
    
    no_key=""
    no_key=keyin
    if player.dead<99 then 
        if askyn("Do you want to see the last messages again?(y/n)") then messages
        high_score(text2)
    endif

    return 0
end function

function explper() as short
    dim as single per
    dim as integer a,b,tp,xx,yy,expl, exps,expp,total
    for a=0 to laststar
        if map(a).discovered>0 then
            exps=exps+1
            for b=1 to 9
                if map(a).planets(b)>0 then
                    tp+=1
                    if planets(map(a).planets(b)).mapstat<>0 then expp=expp+1
                    for xx=0 to 60
                        for yy=0 to 20
                            if planetmap(xx,yy,map(a).planets(b))>0 then expl=expl+1
                            total=total+1
                        next
                    next
                endif
            next
        endif
    next
    if expl>0 and total>0 then
        per=((expl/total)*100)
        if per>100 then per=100
    endif
    return int(per)
end function

function post_mortemII(text as string) as short
    dim as short page,full,half,third,i,x,offset,crewn,bg
    dim as string key,header(4),crewtext,income
    dim as byte unflags(lastspecial)
    make_unflags(unflags())
    full=(_screenx-4*_fw1)/_fw2
    half=fix(full/2)
    third=fix(full/3)
    
    for i=1 to 128
        if crew(i).hpmax>0 then 
            crewn+=1
            crewtext=crewtext &"{15}"&i &") "&crew_text(crew(i))
        endif
    next
    
    header(0)="a) Achievements"
    header(1)="b) Discoveries"
    header(2)="c) Ship"
    header(3)="d) Crew ("&crewn &")"
    header(4)="e) Equipment"
    
    bg=rnd_range(1,_last_title_pic)
    income=mission_type &"|{15}" & get_death &"||"&income_expenses
    do
        set__color(11,0)
        screenset 0,1
        cls
        background(bg &".bmp")
    
        line (2*_fw1,4*_fh1)-(2*_fw1+full*_fw2,20*_fh1),rgb(0,0,128),BF
        select case page
        case 0 'Achievments
            textbox("|"&income,2,4,half,11,1,,,offset)
            textbox("|"&exploration_text ,2+half*_fw2/_fw1,4,half,11,1,,,offset)
        case 1 'Uniques and artifacts
            textbox("|"&list_artifacts(artflag()),2,4,half,11,1,,,offset)
            textbox("|"&uniques(unflags()),2+half*_fw2/_fw1,4,half,11,1,,,offset)
        case 2 'Ship
            textbox("|"&shipstatsblock,2,4,third,11,1)
            textbox("|"&weapon_string,2+third*_fw2/_fw1,4,third,11,1)
            textbox("|"&cargo_text,2+2*(third*_fw2/_fw1),4,third,11,1)
        case 3 'Crew
            textbox("|"&crewtext,2,4,full,11,1,0,0,offset)
        case 4 'Equipment
            textbox("|"&list_inventory,2,4,full,11,1,0,0,offset)
        end select
        set__color(11,0)
        x=len("Mission Summary: "&player.desig)/2
        draw string(2*_fw1,_fh1),"Mission summary: "&player.h_desig &" "&player.desig,,titlefont,custom,@_tcol
        x=2*_fw1
        for i=0 to 4
            if i=page then
                set__color(15,1)
            else
                set__color(15,1,0)
            endif
            draw string(x,4*_fh1-_fh2),header(i),,font2,custom,@_col
            if i=page then draw string(x+1,4*_fh1-_fh2),header(i),,font2,custom,@_tcol
            x+=len(header(i))*_fw2+_fw1
        next
        dprint ""
        flip
        key=keyin(,3)
        select case key
        case "1","a","A"
            page=0
            offset=0
        case "2","u","U","B","b"
            page=1
            offset=0
        case "3","C","c"
            page=2
            offset=0
        case "4","D","d"
            page=3
            offset=0
        case "5","E","e"
            page=4
            offset=0 
        case else
            if key=key__rt then
                offset=0
                page+=1
                if page>4 then page=0
            endif
            if key=key__lt then
                offset=0
                page-=1
                if page<0 then page=4
            endif
            if key="+" then offset+=5
            if key="-" then offset-=5
        end select    
            
    loop until key=key__esc
    
    if askyn("Do you want to save your mission summary to a file?(y/n)") then
        'configflag(con_tiles)=old_g
        
        postmort_html(text)
        'configflag(con_tiles)=1
    else
        kill player.desig &".bmp"
    endif
    'configflag(con_tiles)=old_g
    
    return 0
end function

function postmort_html(text as string) as short
    dim as short f,ll,i
    dim as string fname
    dim lines(255) as string
    space_mapbmp
    f=freefile
    open "data/template.html" for input as f
    ll=0
    while not eof(f)
        ll+=1
        line input #f,lines(ll)
    wend
    close f
    fname="summary/("&date_string &")" &player.desig &".html"
    dprint "saving to "&fname &". Key to continue."
    f=freefile
    open fname for output as f
    for i=1 to ll
        lines(i)=trim(lines(i))
        if lines(i)="{title}" then lines(i)=player.desig &" mission summary"
        if lines(i)="{screenshots}" then 
            lines(i)="<div align=" &chr(34) &"middle"&chr(34)&"><img src="&chr(34) &player.desig &".png" &chr(34)&" width="&chr(34) &"80%"&chr(34) &" align="&chr(34)&"middle"&chr(34)&"></div><br>"
            lines(i)=lines(i)&"<div align=" &chr(34) &"middle"&chr(34)&"><img src="&chr(34) &player.desig &"-map.png" &chr(34)&" width="&chr(34) &"80%"&chr(34) &" align="&chr(34)&"middle"&chr(34)&"></div><br>"
        endif
        
        if lines(i)="{ship}" then lines(i)=ship_table
        if lines(i)="{crew}" then lines(i)=crew_table
        if lines(i)="{uniqueart}" then lines(i)=planet_artifacts_table
        if lines(i)="{achievements}" then lines(i)=acomp_table
        if lines(i)="{equipment}" then lines(i)=items_table
        if lines(i)="{endstory}" then lines(i)="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td>"&text_to_html(text) &"</td></tr><tbody></table>"
        print #f,lines(i)
    next
    no_key=keyin
    close #f
    return 0
end function

function high_score(text as string) as short
    
    dim highscore(11) as _table
    dim in as integer=1
    dim key as string
    dim rank as integer
    dim offset as integer
    dim off2 as integer
    dim store as _table
    dim f as integer
    dim a as integer
    dim s as integer
    dim as short xo,yo,sp
    'open highscore table
    f=freefile
    open "data/highscore.dat" for binary as f
    for a=1 to 10
        get #f,,highscore(a)
    next        
    close f
    'edit highscore table
    rank=1
    if player.desig<>"" then
        
        post_mortemII(text)
        
        if player.score=0 then 
            s=score()
        else
            s=player.score
        endif
        
        for a=1 to 10
            if highscore(a).points>s then rank=rank+1
        next
        if rank<10 then
            for a=9 to rank step -1
                highscore(a+1)=highscore(a)
            next
        endif
        if rank<11 then
            highscore(rank).points=s
            highscore(rank).desig=player.desig &" ("&date_string &"), "& ltrim(player.h_desig) &", " &credits(player.money) &" Cr."            
            highscore(rank).death=get_death
        endif
    else
        rank=-1
    endif
    'display highscore table
    offset=rank
    set__color( 11,0)

    cls
    
    background(rnd_range(1,_last_title_pic)&".bmp")
    yo=(_screeny-22*_fh2)/2
    xo=(_screenx-80*_fw2)/2
    set__color( 0,0)
    for a=yo/2-_fh2 to _screeny-yo/2+_fh2 step _fh2-1
        draw_string (xo,a,space(80),font2,_col)
    next
    set__color( 15,0)
    draw_string (2*_fw2+xo,yo/2,"10 MOST SUCCESSFUL MISSIONS",Titlefont,_col)
    
    for a=1 to 10
        if a=rank then 
            set__color( 15,0)
        else
            set__color( 11,0)
        endif
        sp=73-len(a &".)")-len(trim(highscore(a+off2).desig))-len(highscore(a+off2).points &" pts.")
        draw_string (2*_fw2+xo,yo+(a*2)*_fh2, a & ".) " & trim(highscore(a+off2).desig) & ", "  & space(sp)&credits( highscore(a+off2).points) &" pts." ,font2,_col)
        if a=rank then
            set__color( 14,0)
        else
            set__color( 7,0)
        endif
        draw_string (2*_fw2+xo,yo+(a*2+1)*_fh2, trim(highscore(a+off2).death),font2,_col)
    next
    set__color( 11,0)
    if rank>10 then draw_string (2*_fw2+xo,_screeny-yo, highscore(10).points &" Points required to enter highscore. you scored "&s &" Points",font2,_col)
    draw_string (2*_fw2+xo,_screeny-yo/2, "Esc to continue",font2,_col)
    no_key=keyin(key__esc)
    'save highscore table
    f=freefile
    
    
    'open highscore table
    in=1
    open "data/highscore.dat" for binary as f
      for a=1 to 10  
        put #f,,highscore(a)
        
      next
    close f
    cls
    return 0
end function

function score() as integer
    dim s as integer
    dim a as short
    dim b as short
    dim c as short
    s=s+player.hull
    s=s+player.shieldmax
    s=s+player.money-income(mt_pirates)
    s=s+player.turn
    s=s+player.pilot(1)*100
    s=s+player.gunner(1)*100
    s=s+player.science(1)*100
    s=s+player.doctor(1)*100
    s=s+player.sensors
    s=s+player.engine
    s=s+player.fuel
    s=s+income(mt_pirates)*1.5
    for a=0 to 5
        s=s+player.weapons(a).dam
        s=S+player.weapons(a).range
    next
    for a=0 to laststar
        if map(a).discovered=1 then s=s+100
    next
    for a=0 to 255
        if planetmap(0,0,a)<>0 then
            for b=0 to 60
                for c=0 to 20
                    if planetmap(b,c,a)>0 then s=s+1
                next
            next
        endif
    next
    for a=0 to lastitem
        if item(a).w.s<0 then s=s+item(a).price\100
    next
    if retirementassets(1)>0 then s+=1000
    if retirementassets(2)>0 then s+=2000
    if retirementassets(3)>0 then s+=5000
    if retirementassets(4)>0 then s+=10000
    if retirementassets(5)>0 then s+=100000
    if retirementassets(6)>0 then s+=200000
    if retirementassets(7)>0 then s+=500000
    if retirementassets(8)>0 then s+=1000000
    if retirementassets(9)>0 then s+=2000000
    
    if retirementassets(10)>0 then s+=2000
    if retirementassets(11)>0 then s+=10000
    if retirementassets(12)>0 then s+=20000
    if retirementassets(13)>0 then s+=50000
    if retirementassets(14)>0 then s+=100000
    if retirementassets(15)>0 then s+=200000
    
    s=s-player.deadredshirts*100
    return s
end function

function get_death() as string
    dim as string death,key 
    dim as short a,st
    if player.dead=1 then death="Captain forgot to refuel his spaceship"    
    if player.dead=2 then death="Captain became a cook after running out of money"
    if player.dead=3 or player.dead=25 then 
        if player.dead=3 then
            if player.landed.s>0 then 
                death=add_a_or_an(player.killedby,0) & " under "
            else
                death=add_a_or_an(player.killedby,0) & " on "
            endif
        endif
        
        if player.dead=25 then
            for a=1 to lastdrifting
                if player.landed.s=drifting(a).m then st=drifting(a).s
            next
            death="Captain got killed by "&add_a_or_an(player.killedby,0) &" on "&add_a_or_an(shiptypes(st),0)
        else
            if player.landed.s>0 then 
                death="Captain got killed by " &add_a_or_an(player.killedby,0) &" under an unknown world"
            else
                death="Captain got killed by " &add_a_or_an(player.killedby,0) &" on an unknown world"
            endif
        endif
    endif
    if player.dead=4 then death="Captain started his own Colony"
    if player.dead=5 then death="Got blasted into atoms by spacepirates"
    if player.dead=6 then death="Got sucked into a wierd Q-particle Wormhole"
    if player.dead=7 then death="Got killed in a valiant attempt to take out the pirates"
    if player.dead=8 then death="Got eaten by a plant monster"
    if player.dead=9 then death="Started the new following of apollo"
    if player.dead=10 then death="Ended as a red spot on a wall in an ancient city"
    if player.dead=11 then death="Got ripped apart by ravenous Sandworms"
    if player.dead=12 then death="Ship lost due to navigational error in gascloud"
    if player.dead=13 or player.dead=18 then death="Got blasted into atoms while trying to be a pirate"
    if player.dead=14 then death="Died of asphyxication while exploring too far"
    if player.dead=15 then death="Lost his ship while exploring a planet"
    if player.dead=16 then death="Got fried extra crispy while bathing in lava"
    if player.dead=17 then death="Dove into a sun on a doomed planet"
    if player.dead=19 then death="Underestimated the dangers of asteroid mining"
    if player.dead=20 then death="Got gobbled up by a space monster"
    if player.dead=21 then death="Got destroyed by an alien scoutship"
    if player.dead=22 then death="Suffered an accident while refueling at a gas giant"
    if player.dead=23 then death="Got eaten by gas giant inhabitants"
    if player.dead=24 then death="Lost in a worm hole"
    'player dead 25 is taken
    if player.dead=26 then death="Lost a duel against the infamous Anne Bonny"
    if player.dead=27 then death="Attempted to land on a gas giant without his spaceship"
    if player.dead=28 then death="Underestimated the risks of surgical body augmentation"
    if player.dead=29 then death="Got caught in a huge explosion"
    if player.dead=30 then death="Lost while exploring an anomaly"
    if player.dead=31 then death="Destroyed battling an ancient alien ship"
    if player.dead=32 then death="Died in battle with the "&civ(0).n 
    if player.dead=33 then death="Died in battle with the "&civ(1).n
    if player.dead=34 then death="Surfed to his death on a chunk of ice"
    if player.dead=35 then death="Flew into his own engine exaust"
    if player.dead=36 then death="Destroyed in an assault on a space station."
    if player.dead=98 then death="Captain got filthy rich as a prospector"
    death=death &" after "&display_time(player.turn,2) &"."
    return death
end function
