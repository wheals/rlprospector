
function keyin(byref allowed as string="" , byref walking as short=0,blocked as short=0)as string
    dim key as string
    dim as string text
    static as byte recording
    static as byte seq
    static as string*3 comseq
    dim as short a,b,i,tog1,tog2,tog3,tog4,ctr,f,it
    if walking<>0 then sleep 50
    flip
    
    do 
     do        
      If (ScreenEvent(@evkey)) Then
          Select Case evkey.type
          Case EVENT_KEY_PRESS
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
              case else
                 key = chr(evkey.ascii)
              end select
           end select
           if evkey.type=13 then key=key_quit
          end if
         sleep 1
        loop until key<>"" or walking<>0 or (allowed="" and player.dead<>0) or just_run=1
        
        
        if key<>"" then walking=0 
        if blocked=0 then
            if key=key_manual then 
                manual
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
                logbook
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
            if key=key_wormholemap then
                showwormholemap
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
        if key=key_quit then 
            if askyn("do you really want to quit? (y/n)") then player.dead=6
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
        if recording=2 then walking=-1
    loop until key<>"" or walking <>0 or just_run=1
    while inkey<>""
    wend
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
    for a=0 to c
        shrt(a)=ucase(left(lines(a),1))
        if getdirection(shrt(a))>0 or val(shrt(a))>0 then shrt(a)=""
        if len(lines(a))>longest then longest=len(lines(a))
    next
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    hw=58-2-longest
    e=0
    do        
        locate y,x
        color 15,0
        draw string(x*_fw1,y*_fh1), lines(0),,font2,custom,@_col
        
        for a=1 to c
            if loca=a then 
                if hfl=1 and loca<c then blen=textbox(helps(a),x+longest+2,2,hw,15,1)
                color 15,5
            else
                color 11,0
            endif
            locate y+a,x
            draw string(x*_fw1,y*_fh1+a*_fh2), lines(a),,font2,custom,@_col
        next
        if player.dead=0 then key=keyin(,,blocked)
        
        if hfl=1 then 
            for a=1 to blen
                color 0,0
                draw string((longest+x+2)*_fw1,y*_fh1+(a-1)*_fh2), space(hw),,font2,custom,@_col
            next
        endif
        if getdirection(key)=8 then loca=loca-1
        if getdirection(key)=2 then loca=loca+1
        if loca<1 then loca=c
        if loca>c then loca=1
        if key=key_enter then e=loca
        if key=key_awayteam then 
            screenshot(1)
            showteam(0)
            screenshot(2)
        endif
        for a=0 to c
            if ucase(key)=shrt(a) and getdirection(key)=0 then loca=a
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
    while inkey<>""
    wend
    return e
end function
