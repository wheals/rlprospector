
function keyin(byref allowed as string="" , byref walking as short=0,blocked as short=0)as string
    dim key as string
    dim as string text
    static as byte recording
    static as byte seq
    static as string*3 comseq
    dim as short a,b,i,tog1,tog2,tog3,tog4,ctr,f,it,debug
    dim as string control
    debug=0
    if walking<>0 then sleep 50
    flip
    if _test_disease=1 and allowed<>"" then allowed="#"&allowed
    if player.dead>0 and allowed<>"" then allowed=allowed &" "
    do 
        control=""
        do        
            If (ScreenEvent(@evkey)) Then
'                
'if evkey.ascii=0 and evkey.scancode=23 or evkey.ascii=asc(key_extended) then
'                    if evkey.type=EVENT_KEY_PRESS or evkey.type=EVENT_KEY_REPEAT THEN
'                        if evkey.scancode=23 then control="\C"
'                        if evkey.ascii=asc(key_extended) then control=key_extended
'                    else
'                        control=""
'                    endif
'                endif
                Select Case evkey.type
                    case EVENT_MOUSE_MOVE
                        mouse.x=evkey.x
                        mouse.y=evkey.y
                        mouse.s=1
                    Case EVENT_KEY_PRESS
                        if debug =1 then
                            locate 1,1
                            print evkey.scancode &":"& evkey.ascii
                        endif
                        select case evkey.scancode
                        case sc_down
                            key = key_south
                        case sc_up
                            key = key_north
                        case sc_left
                            key = key_west
                        case sc_right
                            key = key_east
                        case sc_home
                            key = key_nw
                        case sc_pageup
                            key = key_ne
                        case sc_end
                            key = key_sw
                        case sc_pagedown
                            key = key_se
                        case sc_escape
                            key=key_esc
                        case sc_enter
                            key=key_enter
                        case sc_pageup
                            key=key_pageup
                        case sc_pagedown
                            key=key_pagedown
                        'case sc_control
                        '    control="\C"
                        case else
                            if evkey.ascii<=26 then
                                key="\C"&chr(evkey.ascii+96)
                            else
                                if len(chr(evkey.ascii))>0 then key = chr(evkey.ascii)
                            endif
                        end select
                    
                    end select
                endif            
                'if evkey.type=13 then key=key_quit
            sleep 1
        loop until key<>"" or walking<>0 or mouse.s=1 or (allowed="" and player.dead<>0) or just_run=1
        if debug=1 then
            dprint mouse.x &":"&mouse.y
        endif
            
        if key<>"" then walking=0 
        if _test_disease=1 and key="#" then
            a=getnumber(0,255,0)
            b=Getnumber(0,255,0)
            crew(a).disease=b
            crew(a).duration=disease(b).duration
            crew(a).incubation=disease(b).incubation
            if b>player.disease then player.disease=b
            dprint a &":" & b
            a=0
            b=0
            key=""
        endif
        if blocked=0 then
            if key=key_manual then
                a=menu("Help/Manual/Keybindings/Exit","",2,2)
                if a=1 then manual
                if a=2 then keybindings
                return ""
            endif
            if key=key_screenshot then 
                screenshot(3)
                dprint "saved screenshot in screenshot.bmp"
                return ""
            endif
            if key=key_messages then 
                messages
                return ""
            endif
            if key=key_configuration then
                configuration
                return ""
            endif
            if key=key_tactics then
                settactics
                return ""
            endif
            if key=key_shipstatus then         
                shipstatus()
                return ""
            endif
            if key=key_logbook then
                logbook(walking)
                return ""
            endif

            if key=key_equipment then
                a=getitem(999)
                if a>0 then dprint item(a).ldesc
                key=keyin()
                return ""
            endif

            if key=key_quests then
                showquests
                return ""
            endif
            if key="ü" then dprint faction(0).war(2) &""
        endif
        if key=key_autoinspect then
            select case _autoinspect
                case is =0
                    _autoinspect=1
                    dprint "Autoinspect Off"
                case is =1
                    _autoinspect=0
                    dprint "Autoinspect On"                
            end select
            key=""     
        endif
        if key=key_autopickup then
            select case _autopickup
                case is =0
                    _autopickup=1
                    dprint "Autopickup Off"
                case is =1
                    _autopickup=0
                    dprint "Autopickup On"                
            end select
            key=""     
        endif       
        if key=key_togglehpdisplay then
            select case _HPdisplay
                case is =0
                    _HPdisplay=1
                    dprint "Hp display now displays icons"
                case is =1
                    _HPdisplay=0
                    dprint "Hp display now displays HPs"
            end select
        
        endif
        if key=key_quit then 
            if askyn("Do you really want to quit? (y/n)") then player.dead=6
        endif
        if key="$" and dbshow_factionstatus=1 then
            
            for a=0 to 7
                text="Faction "&a
                for b=0 to 7
                    text=text &":"&faction(a).war(b)
                next
                dprint text
            next
        endif
        if key=key_mfile then
            f=freefile
            open "map.txt" for output as #f
            for a=1 to laststar
                print #f, a;":";map(a).discovered
            next
            close f
        endif
        if len(allowed)>0 and key<>key_esc and key<>key_enter and getdirection(key)=0 then
            if instr(allowed,key)=0 then key=""
        endif
    loop until key<>"" or walking <>0 or just_run=1
    return key
end function

function gettext(x as short, y as short, ml as short, text as string) as string
    dim as short l,lasttimer
    dim key as string
    dim p as _cords
    l=len(text)
    sleep 150
    if l>ml and text<>"" then
        text=left(text,ml-1)
        l=ml-1
    endif
    do 
            
        key=""
        color 11,0
        draw string (x*_fw2,y*_fh2), text &"_ ",,font2,custom,@_col
        do
            do
                sleep 1
                lasttimer+=1
                if lasttimer>100 then
                    draw string (x*_fw2,y*_fh2), text &"  ",,font2,custom,@_col
                else
                    draw string (x*_fw2,y*_fh2), text &"_ ",,font2,custom,@_col
                endif
                if lasttimer>200 then lasttimer=0
            loop until screenevent(@evkey)
            
            if evkey.type=EVENT_KEY_press then
                if evkey.ascii=asc(key_esc) then key=key_esc
                if evkey.ascii=8 then key=chr(8)
                if evkey.ascii=32 then key=chr(32)
                if evkey.ascii=asc(key_enter) then key=key_enter
                if evkey.ascii>32 and evkey.ascii<123 then key=chr(evkey.ascii)
            endif
        loop until key<>""  
        
        if key=chr(8) and l>=1 then
           l=l-1
           text=left(text,len(text)-1)
           if text=chr(8) then text=""
        endif
        if l<ml and key<>key_enter and key<>chr(8) and key<>key_esc then
            text=text &key
            l=l+1
        endif
        if l>ml then 
            l=ml
            text=left(text,ml)
        endif
        
    loop until key=key_enter or key=key_esc
    if key=key_esc or l<1 then
        color 0,0
        locate y+1,x+1
        print space(len(text));
        text=""
    endif
    if len(text)=0 then text=""
    if text=key_enter or text=key_esc or text=chr(8) then text=""
    while inkey<>""
    wend
    return text
end function

function getnumber(a as short,b as short, e as short) as short
    dim key as string
    dim buffer as string
    dim c as short
    dim d as short
    dim i as short
    dim p as _cords
    screenset 1,1
    dprint ""
    if _altnumber=0 then
        p=locEOL
        c=numfromstr((gettext(p.x,p.y,46,"")))
        if c>b then c=b
        if c<a then c=e
        return c
    else
        
        color 11,1
        for i=1 to 61
            draw string (i*_fw1,21*_fh1),chr(196),,font1,custom,@_col
        next
        color 11,11
        draw string (28*_fw1,21*_fh1),space(5),,font1,custom,@_col
        c=a
        if e>0 then c=e
        do 
            color 11,1
            
            draw string (27*_fw1,22*_fh1),chr(180),,font1,custom,@_col
            color 5,11
            
            draw string (29*_fw1,21*_fh1),"-",,font1,custom,@_col
            print "-"
    
            if c<10 then 
                color 1,11
                print "0" &c
                draw string (30*_fw1,21*_fh1),"0"&c,,font2,custom,@_col
            else
                color 1,11
                draw string (30*_fw1,21*_fh1),""&c,,font2,custom,@_col
            endif
            
            locate 22,32
            color 5,11        
            draw string (32*_fw1,21*_fh1),"+",,font1,custom,@_col
            
            color 11,1
            draw string (33*_fw1,21*_fh1),chr(195),,font1,custom,@_col
            key=keyin(key_up &key_dn &key_rt &key_lt &"1234567890+-"&key_esc &key_enter)
            if keyplus(key) then c=c+1
            if keyminus(key) then c=c-1
            if key=key_enter then d=1
            if key=key_esc then d=2
            buffer=buffer+key
            if len(buffer)>2 then buffer=""
            if val(buffer)<>0 or buffer="0" then c=val(buffer)
            
            if c>b then c=b
            if c<a then c=a
            
        loop until d=1 or d=2
        if d=2 then c=-1
        color 11,0
    endif
    return c
end function    

function keyplus(key as string) as short
    dim r as short
    if key=key_up or key=key_lt or key=key_south or key="+" then r=-1
    return r
end function

function keyminus(key as string) as short
    dim r as short
    if key=key_dn or key=key_rt or key=key_north or key="-" then r=-1
    return r
end function

function getdirection(key as string) as short
    dim d as short
    if key=key_south then return 2
    if key=key_north then return 8
    if key=key_east then return 6
    if key=key_west then return 4
    if key=key_nw then return 7
    if key=key_ne then return 9
    if key=key_se then return 3
    if key=key_sw then return 1
    if key=key_up then return 8
    if key=key_dn then return 2
    if key=key_rt then return 6
    if key=key_lt then return 4
    return 0
end function

function askyn(q as string,col as short=11) as short
    dim a as short
    dim key as string*1
    dprint (q,col)
    while screenevent(@evkey)
    wend
    do
        key=keyin
        displaytext(_lines-1)=displaytext(_lines-1)&key
        if key <>"" then 
            dprint ""
            if _anykeyno=0 and key<>key_yes then key="N"
        endif
    loop until key="N" or key="n" or key=" " or key=key_esc or key=key_enter or key=key_yes  
    if key=key_yes or key=key_enter then a=-1
    return a
end function

function menu(te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0) as short
    ' 0= headline 1=first entry
    dim as short blen
    dim as string text,help
    dim lines(25) as string
    dim helps(25) as string
    dim shrt(25) as string
    dim as string key,delhelp
    dim a as short
    dim b as short
    dim c as short
    static loca as short
    dim e as short
    dim l as short
    dim hfl as short
    dim hw as short
    dim lastspace as short
    dim tlen as short
    dim longest as short
    dim as short ofx
    text=te
    help=he
    b=len(text)
    if loca=0 then loca=1
    c=0
    text=text &"/"
    do
        tlen=instr(text,"/")
        lines(c)=left(text,tlen-1)
        text=mid(text,tlen+1)
        c=c+1
    loop until len(text)<=0
    c=c-1
    if help<>"" then
        help=help &"/"
        hfl=1
        e=0
        b=len(help)
        do
            tlen=instr(help,"/")
            helps(e)=left(help,tlen-1)
            'if len(helps(e))>len(delhelp) then delhelp=space(len(helps(e)))
            help=mid(help,tlen+1)
            e=e+1
        loop until len(help)<=0
        e=0
    endif
    
    if loca>c then loca=c
    b=0
    for a=0 to c
        shrt(a)=chr(64+b+a)
        if getdirection(lcase(shrt(a)))>0 or getdirection(lcase(shrt(a)))>0 or val(shrt(a))>0 or ucase(shrt(a))=ucase(key_awayteam) then
            do 
                b+=1
                shrt(a)=chr(64+b+a)
            loop until getdirection(lcase(shrt(a)))=0 and getdirection(shrt(a))=0 and val(shrt(a))=0
        endif
        if len(lines(a))>longest then longest=len(lines(a))
    next
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    hw=_mwx*_fw1-((4+longest)*_fw2)
    hw=hw/_fw2
    ofx=x+4+(longest*_fw2/_fw1)
    e=0
    do        
        locate y,x
        color 15,0
        draw string(x*_fw1,y*_fh1), lines(0),,font2,custom,@_col
        
        for a=1 to c
            if loca=a then 
                if hfl=1 and loca<c then blen=textbox(helps(a),ofx,2,hw,15,1)
                color 15,5
            else
                color 11,0
            endif
            locate y+a,x
            draw string(x*_fw1,y*_fh1+a*_fh2),shrt(a) &") "& lines(a),,font2,custom,@_col
        next
        if player.dead=0 then key=keyin(,,blocked)
        
        if hfl=1 then 
            for a=1 to blen
                color 0,0
                draw string(ofx*_fw1,y*_fh1+(a-1)*_fh2), space(hw),,font2,custom,@_col
            next
        endif
        if getdirection(key)=8 then loca=loca-1
        if getdirection(key)=2 then loca=loca+1
        if loca<1 then loca=c
        if loca>c then loca=1
        if key=key_enter then e=loca
        if key=key_awayteam then 
            showteam(0)
        endif
        for a=0 to c
            if key=lcase(shrt(a)) then loca=a
            if key=ucase(shrt(a)) then e=a
        next
        if key=key_esc or player.dead<>0 then e=c
    loop until e>0 
    if key=key_esc and markesc=1 then e=-1
    color 0,0        
    for a=0 to c
        locate y+a,x
        draw string(x*_fw1,y*_fh1+a*_fh2), space(59),,font2,custom,@_col
    next
    color 11,0
    return e
end function
