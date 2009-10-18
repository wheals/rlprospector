function loadmap(m as short,slot as short)as short
    dim as short f,b,x,y
    f=freefile
    open "data/deckplans.dat" for binary as #f
    for b=1 to m
        for x=0 to 60
            for y=0 to 20
                get #f,,planetmap(x,y,slot)
                planetmap(x,y,slot)=-planetmap(x,y,slot)                
            next
        next
    next
    close #f
    return 0
end function



function randomname() as string
    dim f as integer
    dim d as integer
    dim count as integer
    dim ra as integer
    dim mask as string
    dim fname as string
    dim lines(128) as string
    dim desig as string="NNC - "
    dim suf as string
    f=freefile
    if (open ("register" for input as f))=0 then 
        while not(eof(f))
            input #f,lines(count)
            if lines(count)<>"" then count=count+1
        wend
        close f
    endif
    d=val(lines(0))
    mask=lines(1)
    if lines(2)<>"" then
        fname=lines(2)
    else
        fname=mask
    endif
    if mask<>"" then
        ra=instr(mask,"####")
        desig=left(mask,ra-1)
        if len(mask)>ra+4 then suf=right(mask,ra+1)
    endif
    count=0
    f=freefile
    if (open (fname for input as f))=0 then
        do 
            input #f,lines(count)
            lines(128)="savegames/" & lines(count)&".sav"
            if not(fileexists(lines(128))) then count=count+1
            
        loop until eof(f) or count>127
        ra=rnd_range(0,count)
        'print count;" ";ra;" ";lines(ra)
        'sleep
        
    endif
        
    d=d+1
    if d=0 then d=1
    if d>9999 then d=1
    if d<10 then desig=desig & "0"
    if d<100 then desig=desig & "0"
    if d<1000 then desig=desig & "0"
     
    desig=desig &d &suf
    if lines(ra)<>"" and count>0 then desig=lines(ra)
    
    f=freefile
    
    open "register" for output as f
    print #f,d
    print #f,mask
    print #f,fname
    
    close f
    return desig
    
end function

function background(fn as string) as short
    dim as short f,x,y,c
    dim scr(81,25) as short
    dim pal(32) as integer
    f=freefile
    open "data/"&fn for binary as #f
    for x=0 to 80
        for y=0 to 25
            get #f,,c
            scr(x,y)=c
        next
    next
    for x=0 to 32
        get #f,,pal(x)
    next
    close #f
    for x=0 to 32
        palette 32+x,pal(x)
    next
    for x=0 to 80
        for y=0 to 25
            locate y+1,x+1
            color 32+scr(x+1,y),32+scr(x,y)
            print chr(178);
        next
    next
    return 0
end function

function loadkeyset() as short
    dim f as short
    dim as string text,lctext
    f=freefile
    if fileexists("keybindings.txt") then
        open "keybindings.txt" for input as #f
        print "loading keyset";
        do
            print ".";
            line input #f,text
            if instr(text,"#")=0 and len(text)>0 then                            
                lctext=lcase(text)
                if instr(lctext,"key_nw")>0 then key_nw=right(text,1)
                if instr(lctext,"key_north")>0 then key_north=right(text,1)
                if instr(lctext,"key_ne")>0 then key_ne=right(text,1)
                if instr(lctext,"key_west")>0 then key_west=right(text,1)
                if instr(lctext,"key_east")>0 then key_east=right(text,1)
                if instr(lctext,"key_sw")>0 then key_sw=right(text,1)
                if instr(lctext,"key_south")>0 then key_south=right(text,1)
                if instr(lctext,"key_se")>0 then key_se=right(text,1)
                if instr(lctext,"key_wait")>0 then key_wait=right(text,1)
                if instr(lctext,"key_portal")>0 then key_portal=right(text,1)
                
                if instr(lctext,"key_manual")>0 then key_manual=right(text,1)
                if instr(lctext,"key_messages")>0 then key_messages=right(text,1)
                if instr(lctext,"key_screenshot")>0 then key_screenshot=right(text,1)
                if instr(lctext,"key_configuration")>0 then key_configuration=right(text,1)
                if instr(lctext,"key_autopickup")>0 then key_autopickup=right(text,1)
                if instr(lctext,"key_autoinspect")>0 then key_autoinspect=right(text,1)
                if instr(lctext,"key_shipstatus")>0 then key_shipstatus=right(text,1)
                if instr(lctext,"key_save")>0 then key_save=right(text,1)
                if instr(lctext,"key_quit")>0 then key_quit=right(text,1)
                if instr(lctext,"key_tactics")>0 then key_tactics=right(text,1)
                if instr(lctext,"key_comment")>0 then key_comment=right(text,1)
                if instr(lctext,"key_logbook")>0 then key_comment=right(text,1)
                if instr(lctext,"key_weapons")>0 then key_weapons=right(text,1)
                if instr(lctext,"key_equipped")>0 then key_equipped=right(text,1)
                if instr(lctext,"key_quest")>0 then key_quests=right(text,1)
                if instr(lctext,"key_tow")>0 then key_tow=right(text,1)
                
                if instr(lctext,"key_landing")>0 then key_la=right(text,1)
                if instr(lctext,"key_scanning")>0 then key_sc=right(text,1)
                if instr(lctext,"key_comment")>0 then key_comment=right(text,1)
                if instr(lctext,"key_rename")>0 then key_rename=right(text,1)

                if instr(lctext,"key_pickup")>0 then key_pickup=right(text,1)
                if instr(lctext,"key_dropitem")>0 then key_drop=right(text,1)
                if instr(lctext,"key_inspect")>0 then key_i=right(text,1)
                if instr(lctext,"key_examine")>0 then key_ex=right(text,1)
                if instr(lctext,"key_radio")>0 then key_ra=right(text,1)
                if instr(lctext,"key_teleport")>0 then key_te=right(text,1)
                if instr(lctext,"key_jump")>0 then key_ju=right(text,1)
                if instr(lctext,"key_communicate")>0 then key_co=right(text,1)
                if instr(lctext,"key_offer")>0 then key_of=right(text,1)
                if instr(lctext,"key_grenade")>0 then key_gr=right(text,1)
                if instr(lctext,"key_fire")>0 then key_fi=right(text,1)
                if instr(lctext,"key_walk")>0 then key_walk=right(text,1)
                if instr(lctext,"key_heal")>0 then key_he=right(text,1)
                if instr(lctext,"key_oxygen")>0 then key_oxy=right(text,1)
                if instr(lctext,"key_close")>0 then key_close=right(text,1)
                
                if instr(lctext,"key_dropshield")>0 then key_sh=right(text,1)
                if instr(lctext,"key_activatesensors")>0 then key_ac=right(text,1)
                if instr(lctext,"key_run")>0 then key_ru=right(text,1)

            endif
        loop until eof(f)
        close f
    else
        color 14,0
        print "File keybindings.txt not found. Using default keys"
        color 15,0
        Sleep 3000
        return 1
    endif
    return 0
end function

function loadconfig() as short
    dim f as short
    dim text as string
    
    if fileexists("config.txt") then
        f=freefile
        open "config.txt" for input as #f
        print "loading config";
        do
            print ".";
            line input #f,text
            if instr(text,"#")=0 and len(text)>1 then
                text=lcase(text)
                if instr(text,"autosale")>0 then
                    if instr(text,"0")>0 or instr(text,"on")>0 then _autosell=0
                    if instr(text,"1")>0 or instr(text,"of") then _autosell=1
                endif
                
                if instr(text,"autopick")>0 then
                    if instr(text,"0")>0 or instr(text,"on")>0 then _autopickup=0
                    if instr(text,"1")>0 or instr(text,"of") then _autopickup=1
                endif
                if instr(text,"chosebe")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _chosebest=0
                    if instr(text,"1")>0 or instr(text,"of") then _chosebest=1
                endif
                if instr(text,"soun")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _sound=0
                    if instr(text,"1")>0 or instr(text,"of") then _sound=1
                    if instr(text,"2")>0 or instr(text,"high") then _sound=2
                endif
                if instr(text,"diagon")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _diagonals=0
                    if instr(text,"1")>0 or instr(text,"of") then _diagonals=1
                endif
                if instr(text,"screen")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _savescreenshots=0
                    if instr(text,"1")>0 or instr(text,"of") then _savescreenshots=1
                endif
                if instr(text,"startrandom")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _startrandom=0
                    if instr(text,"1")>0 or instr(text,"of") then _startrandom=1
                endif
                if instr(text,"autosave")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _autosave=0
                    if instr(text,"1")>0 or instr(text,"of") then _autosave=1
                endif
                if instr(text,"minimum")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _minsafe=0
                    if instr(text,"1")>0 or instr(text,"of") then _minsafe=1
                endif
                if instr(text,"anykeyno")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _anykeyno=0
                    if instr(text,"1")>0 or instr(text,"of") then _anykeyno=1
                endif
                if instr(text,"restart")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _restart=0
                    if instr(text,"1")>0 or instr(text,"of") then _restart=1
                endif
                if instr(text,"warnings")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _warnings=0
                    if instr(text,"1")>0 or instr(text,"of") then _warnings=1
                endif
                if instr(text,"tiles")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _tiles=0
                    if instr(text,"1")>0 or instr(text,"of") then _tiles=1
                endif
                if instr(text,"easy")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _easy=0
                    if instr(text,"1")>0 or instr(text,"of") then _easy=1
                endif
                if instr(text,"volume")>0 then
                    if instr(text,"0")>0 then _volume=0
                    if instr(text,"1")>0 then _volume=1
                    if instr(text,"2")>0 then _volume=2
                    if instr(text,"3")>0 then _volume=3
                    if instr(text,"4")>0 then _volume=4
                endif
                if instr(text,"resolution")>0 then
                    if instr(text,"0")>0 then _resolution=0
                    if instr(text,"1")>0 then _resolution=1
                    if instr(text,"2")>0 then _resolution=2
                endif
            endif                
        loop until eof(f)
        close #f
        return 0
    else
        dprint "No Config.txt. Using default configuration"
    endif
end function

function configuration() as short
    dim text as string
    dim onoff(1) as string
    dim warn(2) as string
    dim res(2) as string
    dim c as short
    dim f as integer
    onoff(0)=" On "
    onoff(1)=" Off"
    warn(0)="On  "
    warn(1)="Off "
    warn(2)="High"
    res(0)="Low"
    res(1)="Med"
    res(2)="High"
    screenshot(1)
    do
        text="Prospector 0.1.7 Configuration/ Autopickup :"& onoff(_autopickup)
        text=text &"/ Always chose best item :"& onoff(_chosebest)
        text=text &"/ Sound effects :"& warn(_sound)
        text=text &"/ Automatically chose diagonal:" & onoff(_diagonals)
        text=text &"/ Always sell all:" & onoff(_autosell)
        text=text &"/ Start with random ship:"& onoff(_startrandom)
        text=text &"/ Don't use Ext Ascii for screenshots:" & onoff(_savescreenshots)
        text=text &"/ Autosave on entering station:" & onoff(_autosave)
        text=text &"/ Minimum safe distance to pirate planets:" & onoff(_minsafe)
        text=text &"/ Any key counts as no on yes-no questions:" & onoff(_anykeyno)
        text=text &"/ Return to start menu on death:" & onoff(_restart)
        text=text &"/ Navigational Warnings(Gasclouds & 1HP landings):" & onoff(_warnings)
        text=text &"/ Graphic tiles:" & onoff(_tiles)
        text=text &"/ Easy start:" & onoff(_easy)
        text=text &"/ Volume (0-5):" & _volume
        text=text &"/ Resolution: "&res(_resolution)
        text=text &"/Exit"
        c=menu(text,,,,1)
        if c=1 then
            select case _autopickup
            case is=1
                _autopickup=0
            case is=0
                _autopickup=1
            end select
        endif
        if c=2 then
            select case _chosebest
            case is=1
                _chosebest=0
            case is=0
                _chosebest=1
            end select
        endif 
        if c=3 then
            _sound=_sound+1
             if _sound=3 then _sound=0
        endif
        if c=4 then
            select case _diagonals
            case is=1
                _diagonals=0
            case is=0
                _diagonals=1
            end select
        endif
        
        if c=5 then
            select case _autosell
            case is=1
                _autosell=0
            case is=0
                _autosell=1
            end select
        endif
        if c=6 then
            select case _startrandom
            case is=1
                _startrandom=0
            case is=0
                _startrandom=1
            end select
        endif
        if c=7 then
            select case _savescreenshots
            case is=1
                _savescreenshots=0
            case is=0
                _savescreenshots=1
            end select
        endif
        if c=8 then
            select case _autosave
            case is=1
                _autosave=0
            case is=0
                _autosave=1
            end select
        endif
        if c=9 then
            select case _minsafe
            case is=1
                _minsafe=0
            case is=0
                _minsafe=1
            end select
        endif
        if c=10 then
            select case _anykeyno
            case is=1
                _anykeyno=0
            case is=0
                _anykeyno=1
            end select
        endif
        if c=11 then
            select case _restart
            case is=1
                _restart=0
            case is=0
                _restart=1
            end select
        endif
        if c=12 then
            select case _warnings
            case is=1
                _warnings=0
            case is=0
                _warnings=1
            end select
        endif
        if c=13 then
            select case _tiles
            case is=1
                _tiles=0
            case is=0
                _tiles=1
            end select
        endif
        if c=14 then
            select case _easy
            case is=1
                _easy=0
            case is=0
                _easy=1
            end select
        endif
        if c=15 then
            _volume=getnumber(0,4,_volume)                        
            IF _volume = 0 THEN FSOUND_SetSFXMasterVolume(0)
            IF _volume = 1 THEN FSOUND_SetSFXMasterVolume(63)
            IF _volume = 2 THEN FSOUND_SetSFXMasterVolume(128)
            IF _volume = 3 THEN FSOUND_SetSFXMasterVolume(190)
            IF _volume = 4 THEN FSOUND_SetSFXMasterVolume(255)
        endif
        
        
        if c=16 then
            _resolution+=1
            if _resolution>2 then _resolution=0
            dprint "Resolution will be changed next time you start prospector."
        endif
    loop until c=17
    screenshot(2)
    f=freefile
    open "config.txt" for output as #f
    print #f,"# 0 is on, 1 is off"
    print #f,""
    print #f,"autopickup:"&_autopickup
    print #f,"chosebest:"&_chosebest
    print #f,"sound:"&_sound
    print #f,"diagonals:"&_diagonals
    print #f,"autosale:"&_autosell
    print #f,"startrandom:"&_startrandom
    print #f,"safescreenshots:"&_savescreenshots
    print #f,"autosave:"&_autosave
    print #f,"minsafe:"&_minsafe
    print #f,"anykeyno:"&_anykeyno
    print #f,"restart:"&_restart
    print #f,"warnings:"&_warnings
    print #f,"tiles:"&_tiles
    print #f,"easy:"&_easy
    print #f,"volume:"&_volume
    print #f,"resolution:"&_resolution
    close #f
    return 0
end function



function getfilename() as string
    dim filename as string
    dim a as string
    dim b as string*36
    dim c as short
    dim n(10) as string
    dim d as string*36
    dim text as string
    dim f as integer
    dim i as integer
    text="Files:"
    a=dir$("savegames/*.sav")
    while a<>""
        if a<>"empty.sav" then
            n(c)=a
            f=freefile
            open "savegames/"&n(c) for binary as #f
            get #f,,b
            get #f,,d
            close #f
            text=text &"/" & b &d
            c=c+1
        endif
        a=dir()
    wend    
    text=text &"/Exit"
    c=menu(text,,45,10)
    filename=n(c-1)
    return filename    
end function




function savegame() as short
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim dat as string*36
    dim names as string*36
    dim cl as string
    cl=player.h_sdesc
    names=player.desig
    dat="("&cl &", "&player.money &"Cr T:" &player.turn &")"
    
    cls
    back=99
    f=freefile
    fname="savegames/"&player.desig &".sav"
    
    print "Saving "&fname;
    open fname for binary as #f
    print ".";
    'save shortinfo
    put #f,,names
    put #f,,dat
    
    'save player
    put #f,,player
    put #f,,_autopickup
    put #f,,_autoinspect
    for a=1 to 128
        put #f,,crew(a)
    next
    for a=1 to 4
        put #f,,awayteamcomp(a)
    next
    
    print ".";
    for a=0 to 16
        put #f,,savefrom(a)
        print ".";
    next
    'save maps
    for a=0 to laststar
        put #f,,map(a)
        print ".";
    next
    for a=0 to 3
        put #f,,basis(a)
        print ".";
    next
    
    for a=0 to 20
        for b=0 to 20
            put #f,,shopitem(a,b)
        next
        print ".";
    next

    for x=0 to sm_x
        for y=0 to sm_y
            put #f,,spacemap(x,y)
        next
    next
    
    put #f,,lastdrifting
    for a=0 to lastdrifting
        put #f,,drifting(a)
        print ".";
    next
    
    put #f,,lastportal
    for a=0 to lastportal
        put #f,,portal(a)
        print ".";
    next
    put #f,,_NoPB
    for a=0 to _NoPB
        put #f,,pirateplanet(a)
        put #f,,piratebase(a)
        print ".";
    next
    
    put #f,,lastplanet
    put #f,,wormhole
    for a=0 to lastplanet+wormhole
        put #f,,planets(a)
        for b=0 to 60
            for c=0 to 20
                put #f,,planetmap(b,c,a)
            next
        next
        print ".";
    next
    for a=0 to lastspecial
        put #f,,specialplanet(a)
        put #f,,specialflag(a)
    next
    print ".";
    
    put #f,,lastitem
    for a=0 to lastitem
        put #f,,item(a)
    next
    print ".";
    'save pirates
    for a=0 to 9
        put #f,,reward(a)
    next
    print ".";
    
    for a=0 to 20
        put #f,,flag(a)
    next
    
    for a=0 to lastflag
        put #f,,artflag(a)
    next
    print ".";
    
    put #f,,lastfleet
    for a=0 to lastfleet
        put #f,,fleet(a)
    next
    print ".";
    
    'save comments
    put #f,,lastcom
    for a=1 to lastcom
        put #f,,coms(a)
        print ".";
    next
    close f
    
    color 14,0
    cls
    return back
end function


function loadgame(filename as string) as short
    dim from as short
    dim ship as cords
    dim awayteam as _monster
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim dat as string*36
    dim names as string*36
    
    
    if filename<>"" then
        f=freefile
        fname="savegames/"&filename
        print "loading"&fname;
        open fname for binary as #f
        get #f,,names
        get #f,,dat
        print ".";
        'save player
        get #f,,player
        get #f,,_autopickup
        get #f,,_autoinspect
        for a=1 to 128
            get #f,,crew(a)
        next
        for a=1 to 4
            get #f,,awayteamcomp(a)
        next
    
        
        print ".";
        
        for a=0 to 16
            get #f,,savefrom(a)
            print ".";
        next
        
        for a=0 to laststar
            get #f,,map(a)
            print ".";
        next
                    
        for a=0 to 3
            get #f,,basis(a)
            print ".";
        next    
                    
        for a=0 to 20
            for b=0 to 20
                get #f,,shopitem(a,b)
            next
            print ".";
        next
                                        
        for x=0 to sm_x
            for y=0 to sm_y
                get #f,,spacemap(x,y)
            next
        next
            
        get #f,,lastdrifting
        for a=0 to lastdrifting
            get #f,,drifting(a)
            print ".";
        next
        
        get #f,,lastportal
        for a=0 to lastportal
            get #f,,portal(a)
        next
        get #f,,_NoPB
        for a=0 to _NoPB
            get #f,,pirateplanet(a)
            get #f,,piratebase(a)
        next
        
        get #f,,lastplanet
        get #f,,wormhole
        for a=0 to lastplanet+wormhole
            get #f,,planets(a)
            for b=0 to 60
                for c=0 to 20
                    get #f,,planetmap(b,c,a)
                next
            next
            print ".";
        next
        
        for a=0 to lastspecial
            get #f,,specialplanet(a)
            get #f,,specialflag(a)
            print ".";
        next
        get #f,,lastitem
        for a=0 to lastitem
            get #f,,item(a)
            print ".";
        next
        'save pirates
        for a=0 to 9
            get #f,,reward(a)
            print ".";
        next
        
        for a=0 to 20
            get #f,,flag(a)
        next
        
        for a=0 to lastflag
            get #f,,artflag(a)
        next
        print ".";
        
        get #f,,lastfleet
        for a=0 to lastfleet
            get #f,,fleet(a)
        next
        print ".";
            
        get #f,,lastcom
        for a=1 to lastcom
            get #f,,coms(a)
            print ".";
        next
        close f
        if fname<>"savegames\empty.sav" then kill(fname)
        player.lastvisit.s=-1
    else 
        player.desig=filename
    endif
    cls
    return 0
    
end function
