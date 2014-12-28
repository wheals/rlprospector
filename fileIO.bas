'
' File Input/output routines
'
function count_lines(file as string) as short
    dim as short f,n
    dim dummy as string
    f=freefile
    open file for input as #f
    do
        line input #f,dummy
        if len(dummy)>0 then n+=1
    loop until eof(f)
    close #f
    return n
end function

function open_file(filename as string) as short
    dim f as short
    f=freefile
    if fileexists(filename) then
        open filename for input as #f
        return f
    else
        color rgb(255,255,0)
        print "Couldn't find "&filename &"."
        sleep
        end
    endif
end function


function character_name(byref gender as byte) as string
    dim as string n,fn(200),ln(200),st
    dim as short f,lastfn,lastln,fnn,lnn
    f=freefile
    open "data/crewnames.txt" for input as #f
    do
        ln(lastln)=st
        lastln+=1
        line input #f,st
    loop until st="####"
    st=""
    do
        fn(lastfn)=st
        lastfn+=1
        line input #f,st
    loop until eof(f)
    st=""
    close #f
    lastfn-=1
    lastln-=1
    lnn=rnd_range(1,lastln)
    fnn=rnd_range(1,lastfn)
    if rnd_range(1,100)<80 then
        n=fn(fnn) &" "&ln(lnn)
    else
        n=fn(fnn) &" "&CHR(rnd_range(65,87))&". " &ln(lnn)
    endif
    if fnn<=22 then
        gender=0 'Female
    else
        gender=1 'Male
    endif
    return n
end function


function gethullspecs(t as short,file as string) as _ship
    dim as short f,a,b
    dim as string word(12)
    dim as string l
    dim as _ship n
    f=freefile
    open file for input as #f
    line input #f,l
    for a=1 to t
        line input #f,l
    next
    close #f

    string_towords(word(),l,";")

    n.h_no=t
    n.h_desig=word(0)
    n.h_price=val(word(1))
    n.h_maxhull=val(word(2))
    n.h_maxshield=val(word(3))
    n.h_maxengine=val(word(4))
    n.h_maxsensors=val(word(5))
    n.h_maxcargo=val(word(6))
    n.h_maxcrew=val(word(7))
    n.h_maxweaponslot=val(word(8))
    n.h_maxfuel=val(word(9))
    n.h_sdesc=word(10)
    n.reloading=val(word(11))
    n.h_desc=word(12)
    if _debug>0 then dprint "Cursed:"&n.cursed
    return n
end function

function delete_custom(pir as short) as short
    dim s as _ship
    dim as short n,f,c,last,i,flag
    dim as string lines(22),men,des
    do
        last=0
        n=count_lines("data/customs.csv")-1
        f=freefile
        open "data/customs.csv" for input as #f
        for i=0 to n
            line input #f,lines(i)
        next
        close #f
        men="Delete Ship Design/"
        des="/"
        for i=1 to n
            s=gethullspecs(i,"data/customs.csv")
            men=men & s.h_desig & "/"
            des=des &makehullbox(i,"data/customs.csv") &"/"
            last=last+1
        next
        last+=1
        men=men &"Exit"
        c=menu(bg_parent,men,des)
        if c>0 and c<last then
            if askyn("do you really want to delete this ship design? (y/n)") then
                lines(c)=lines(n)
                lines(n)=""
                n-=1
                open "data/customs.csv" for output as #f
                for i=0 to n
                    print #f,lines(i)
                next
                close #f
            endif
        endif
    loop until c=last or c=-1
    if flag=1 then
    endif
    return 0
end function



function check_filestructure() as short
    dim as short f
    
    if chdir("data")=-1 then
        set__color(c_yel,0)
        print "Can't find folder 'data'. Try reinstalling the game."
        sleep
        end
    else
        chdir("..")
    endif

    if chdir("savegames")=-1 then
        mkdir("savegames")
    else
        chdir("..")
    endif

    if chdir("bones")=-1 then
        mkdir("bones")
    else
        chdir("..")
    endif

    if chdir("summary")=-1 then
        mkdir("summary")
    else
        chdir("..")
    endif
    
    if chdir("config")=-1 then
        mkdir("config")
    else
        chdir("..")
    endif
    
    set__color(11,0)

    if not fileexists("savegames/empty.sav") then
        player.desig="empty"
        savegame()
    endif
    
    return 0
end function

function load_palette() as short
    dim as short f,i,j,k,debug
    dim as string l,w(3)
    if not(fileexists("data/p.pal")) then
        color rgb(255,255,0),0
        print "p.pal not found - can't start the game"
        sleep
        end
    endif
    f=freefile
    open "data/p.pal" for input as #f
    line input #f,l
    line input #f,l
    line input #f,l 'First do not need to be checked
    do
        line input #f,l
        if debug=1 and _debug=1 then print l
        k=1
        w(1)=""
        w(2)=""
        w(3)=""
        for j=1 to len(l)
            w(k)=w(k)&mid(l,j,1)
            if mid(l,j,1)=" " then k+=1
        next
        palette_(i)=RGB(val(w(1)),val(w(2)),val(w(3)))
        if debug=1 and _debug=1 then
            print w(1);":";w(2);":";w(3)
            print palette_(i)
        endif
        i+=1
        if debug=2 and _debug=1 then print i;":";
    loop until eof(f)
    close #f



    return 0
end function


function load_sounds() as short
    #ifdef _FMODSOUND
    print
    print "Loading sounds:";
    fsound_init(48000,11,0)
    print FSOUND_geterror();
    IF _Volume = 0 THEN FSOUND_SetSFXMasterVolume(0)
    IF _Volume = 1 THEN FSOUND_SetSFXMasterVolume(63)
    IF _Volume = 2 THEN FSOUND_SetSFXMasterVolume(128)
    IF _Volume = 3 THEN FSOUND_SetSFXMasterVolume(190)
    IF _Volume = 4 THEN FSOUND_SetSFXMasterVolume(255)
    sound(1)= FSOUND_Sample_Load(FSOUND_FREE, "data/alarm_1.wav", 0, 0, 0)
    sound(2)= FSOUND_Sample_Load(FSOUND_FREE, "data/alarm_2.wav", 0, 0, 0)
    sound(3)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_1.wav", 0, 0, 0)
    sound(4)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_2.wav", 0, 0, 0)
    sound(5)= FSOUND_Sample_Load(FSOUND_FREE, "data/wormhole.wav", 0, 0, 0)
    sound(7)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_4.wav", 0, 0, 0)
    sound(8)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_3.wav", 0, 0, 0)
    sound(9)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_5.wav", 0, 0, 0)
    sound(10)= FSOUND_Sample_Load(FSOUND_FREE, "data/start.wav", 0, 0, 0)
    sound(11)= FSOUND_Sample_Load(FSOUND_FREE, "data/land.wav", 0, 0, 0)
    sound(12)= FSOUND_Sample_Load(FSOUND_FREE, "data/pain.wav", 0, 0, 0)
    #endif
    #ifdef _FBSOUND
    dim ok as FBSBOOLEAN
    print
    print "Loading sounds:";
    'fbs_Init(48000,2,11,2048,0)
    ok=fbs_Init()
    if ok=true then
        fbs_Set_MasterVolume(_Volume/2.0)
        print ".";
        fbs_Load_WAVFile("data/alarm_1.wav",@sound(1))
        print ".";
        fbs_Load_WAVFile("data/alarm_2.wav",@sound(2))
        print ".";
        fbs_Load_WAVFile("data/weap_1.wav",@sound(3))
        print ".";
        fbs_Load_WAVFile("data/weap_2.wav",@sound(4))
        print ".";
        fbs_Load_WAVFile("data/wormhole.wav",@sound(5))
        print ".";
        fbs_Load_WAVFile("data/weap_4.wav",@sound(7))
        print ".";
        fbs_Load_WAVFile("data/weap_3.wav",@sound(8))
        print ".";
        fbs_Load_WAVFile("data/weap_5.wav",@sound(9))
        print ".";
        fbs_Load_WAVFile("data/start.wav",@sound(10))
        print ".";
        fbs_Load_WAVFile("data/land.wav",@sound(11))
        print ".";
        fbs_Load_WAVFile("data/pain.wav",@sound(12))
    else
        print "Error initializing FBsound"
    endif
    #endif
    return 0
end function


function load_map(m as short,slot as short)as short
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

function count_savegames() as short
    dim as short c
    dim as string text
    chdir "savegames"
    text=dir$("*.sav")
    while text<>""
        text=dir$()
        c=c+1
    wend
    chdir ".."
    cls
    return c
end function


function load_fonts() as short
    dim as short a,debug,f
    dim as integer depth

    if debug=1 and _debug=1 then
        f=freefile
        open "fontlog.txt" for append as #f
    endif
    if ((not fileexists("graphics/font"&_fohi1 &".bmp")) or (not fileexists("graphics/font"&_fohi2 &".bmp"))) then
        if configflag(con_customfonts)=0 then
            if not fileexists("graphics/ships.bmp") then configflag(con_tiles)=1
            configflag(con_customfonts)=1
            _fw1=8
            _tix=8
            _mwx=60
            color 14,0
            print "Couldn't find fonts. Switching to built in font."
            sleep 1500
        else

        endif
    endif
    if _lines<25 then _lines=25
    if configflag(con_tiles)=0 then
        '_fohi2=10
        _fohi1=26
    endif
    if _fohi1=9 then _fohi1=10
    if _fohi1=11 then _fohi1=12
    if _fohi1=13 then _fohi1=14
    if _fohi1=15 then _fohi1=16
    if _fohi1=17 then _fohi1=18
    if _fohi1=19 then _fohi1=20
    if _fohi1=21 then _fohi1=22
    if _fohi1=23 then _fohi1=24
    if _fohi1=25 then _fohi1=26
    if _fohi2=9 then _fohi2=10
    if _fohi2=11 then _fohi2=12
    if _fohi2=13 then _fohi2=14
    if _fohi2=15 then _fohi2=16
    if _fohi2=17 then _fohi2=18
    if _fohi2=19 then _fohi2=20
    if _fohi2=21 then _fohi2=22
    if _fohi2=23 then _fohi2=24
    if _fohi2=25 then _fohi2=26
    if _fohi1<8 or _fohi1>24 then _fohi1=12
    if _fohi2<8 or _fohi2>24 then _fohi2=12
    if _fohi2>_fohi1 then _fohi2=_fohi1
    'Extern fb_mode Alias "fb_mode" As Uinteger Ptr
    _FH1=_fohi1
    _FH2=_fohi2
    _FW1=_FH1/2+2
    _FW2=_FH2/2+2
    if configflag(con_tiles)=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif

    if _screeny<>_lines*_fh1 then _screeny=_lines*_fh1
    _textlines=fix((22*_fh1)/_fh2)+fix((_screeny-_fh1*22)/_fh2)-1
    _screenx=_mwx*_fw1+25*_fw2
    screenres _screenx,_screeny,16,2,GFX_WINDOWED
    if debug=1 and _debug=1 then print #f,"Made screen"
    Print "Loading Fonts"
    'gfx.font.loadttf("graphics/Nouveau_IBM.ttf", FONT1, 32, 448, _fh1)
    'gfx.font.loadttf("graphics/Nouveau_IBM.ttf", FONT2, 32, 448, _fh2)
    set__color(11,0)

    if configflag(con_customfonts)=0 then
        print "loading font 1"
        font1=load_font(""&_fohi1,_FH1)
        if debug=1 and _debug=1  then print #f,"Loaded Font 1"
        print "loading font 2"
        font2=load_font(""&_fohi2,_FH2)
        if debug=1 and _debug=1 then print #f,"Loaded Font 2"
        titlefont=load_font("26",26)
    else
        _screenx=1024
        _screeny=768
        screenres _screenx,_screeny,16,2,GFX_WINDOWED
        width _screenx/8,_screeny/16
        'font1=load_font("FH1.bmp",16)
        'font2=load_font("FH1.bmp",16)
        Font1 = ImageCreate((254-1) * 8, 17,rgba(0,0,0,0),16)
        Font2 = ImageCreate((254-1) * 8, 17,rgba(0,0,0,0),16)
        dim as ubyte ptr p
        ImageInfo( Font1, , ,depth , , p )

        p[0] = 0
        p[1] = 24
        p[2] = 254
        For a = 24 To 254
            p[3 + a - 24] = 8
            Draw String Font1, ((a - 24) * 8, 1), Chr(a),rgba(255,255,255,255)
        Next
        _fh1=16
        _fh2=16
        bsave "data/F1.bmp",Font1
        font2=font1
    endif

    _FW1=_FH1/2+2
    _FW2=_FH2/2+2
    if configflag(con_tiles)=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif

    if _screeny<>_lines*_fh1 then _screeny=_lines*_fh1
    _textlines=fix((22*_fh1)/_fh2)+fix((_screeny-_fh1*22)/_fh2)-1
    _screenx=_mwx*_fw1+25*_fw2
    screenres _screenx,_screeny,16,2,GFX_ALWAYS_ON_TOP
    screenres _screenx,_screeny,16,2,GFX_WINDOWED
    sidebar=(_mwx+1)*_fw1+_fw2

    if debug=1 and _debug=1 then
        print #f,"reset screen size"
        close #f
    endif
    return 0
end function


function load_font(fontdir as string,byref fh as ubyte) as ubyte ptr
    Dim as ubyte ptr img
    dim font as ubyte ptr
    Dim As Integer imgwidth,imgheight,i,ff
    ff=FreeFile
    Open "graphics/font"&fontdir &".bmp" For Binary As ff
    Get #ff, 19, imgwidth
    Get #ff, 23, imgheight
    Close ff
    fh=imgheight
    img=ImageCreate(imgwidth,imgheight) 'Zwischenpuffer f�r bmp
    If img Then
      BLoad ("graphics/font"&fontdir &".bmp",img)
      font=ImageCreate(imgwidth,imgheight+1) 'eigentlicher Font
      If font Then
        ff=FreeFile
        Open "graphics/"&fontdir &"header" For Binary As ff  'Buchstabenbreite dazuladen
        i=0
        Do Until EOF(ff)
          Get #ff,, font[SizeOf(FB.Image)+i]
          i=i+1
        Loop
        Close ff
        Put font,(0,1),img,(0,0)-(imgwidth-1,imgheight-1),PSet  'Zwischenpuffer in Font kopieren
      End If
      ImageDestroy (img)    'Zwischenpuffer l�schen
    else
        set__color( 14,0)
        print "Loading font graphics/"&fontdir &".bmp failed."
        sleep 600
    endif
    return font
end function

Function font_load_bmp(ByRef _filename As String) As UByte Ptr
    Dim As UInteger w,h,f=FreeFile
    Dim As UShort bpp
    If (Open(_filename, For Binary, Access Read, As #f)<>0)Then
        Print "Font " + _filename+" not loaded!"
        Return 0
    EndIf
    Get #f,19,w
    Get #f,23,h
    Get #f,29,bpp
    Close #f

    Dim As UByte Ptr font
    font=ImageCreate(w,h)
    BLoad(_filename,font)
    Dim As UByte Ptr fontheader=Cast(UByte Ptr,font+SizeOf(FB.image))

    Select Case As Const fontheader[0]
        Case 0 'standard draw string font buffer
            fontheader[0]=Point(0,0,font)
            fontheader[1]=Point(1,0,font)
            fontheader[2]=Point(2,0,font)
            For x As Integer=0 To (fontheader[2]-fontheader[1])+1
                fontheader[3+x]=Point(3+x,0,font)
            Next x
        Case 5 'unicode draw string font buffer
            fontheader[0]=Point(0,0,font)
            fontheader[1]=Point(1,0,font)
            fontheader[2]=Point(2,0,font)
            fontheader[3]=Point(3,0,font)
            fontheader[4]=Point(4,0,font)
            Dim As UShort first,last
            first=((fontheader[1] Shl 4)) Or (fontheader[2])
            last=((fontheader[3] Shl 4)) Or (fontheader[4])
            For x As Integer=0 To last-first+1
                fontheader[5+x]=Point(5+x,0,font)
            Next x
    End Select

    Return font
End Function

function load_tiles() as short
    dim as short x,y,a,n,sx,sy,showtiles
    showtiles=0
    screenset 1,1
    locate 1,1
    print "Loading tiles:."
    screenset 0,1
    for a=0 to 4096
        gt_no(a)=2048
    next
    if not fileexists("graphics/ships.bmp") then
        color rgb(255,255,0)
        print "Couldn't find graphic tiles, switching to ASCII"
        configflag(con_tiles)=1
        configflag(con_sysmaptiles)=1
        sleep 1500
        return 0
    endif
    cls
    bload "graphics/ships.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*9,y),""&sy
    next
    
    screenset 1,1
    locate 1,1
    print "Loading tiles:.."
    screenset 0,1
    
    cls
    bload "graphics/ships2.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*9,y),""&sy
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:..."
    screenset 0,1
    
    cls
    bload "graphics/ships3.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*10,y),""&sy
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:...."
    screenset 0,1
    
    cls
    bload "graphics/drifting.bmp"
    for y=0 to _tiy*16 step _tiy
        sx=1
        sy+=1
        for x=0 to _tix*8 step _tix
            stiles(sx,sy)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
            sx+=1
        next
        draw string (24*10,y),""&sy
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:....."
    screenset 0,1
    
    cls
    bload "graphics/shield.bmp"
    for x=0 to 7
        for y=0 to 4
            shtiles(x,y)=imagecreate(16,16)
            get (x*16,y*16)-((x+1)*16-1,(y+1)*16-1),shtiles(x,y)
        next
    next
    
    'Clear tile
    gtiles(0)=imagecreate(_tix,_tiy,rgba(0,0,0,255))
    
    screenset 1,1
    locate 1,1
    print "Loading tiles:......"
    screenset 0,1

    a=1
    n=1
    cls
    bload "graphics/space.bmp"
    for y=0 to _tiy*6 step _tiy
        for x=0 to _tix*15 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next
    
    screenset 1,1
    locate 1,1
    print "Loading tiles:......."
    screenset 0,1
    n=75
    cls
    bload "graphics/weapons.bmp"
    y=0
    for x=0 to _tix*2 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next
    y=_tiy
    for x=0 to _tix*8 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next
    y=_tiy*2
    for x=0 to _tix*2 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    
    screenset 1,1
    locate 1,1
    print "Loading tiles:........"
    screenset 0,1
    
    n=101
    cls
    bload "graphics/land.bmp"
    for y=0 to _tiy*16 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:........."
    screenset 0,1
    
    n=750
    cls
    bload "graphics/critters3.bmp"
    for y=0 to _tiy*10 step _tiy
        x=0
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:.........."
    screenset 0,1
    

    n=800
    cls
    bload "graphics/critters2.bmp"
    for y=0 to _tiy*11 step _tiy
        for x=0 to _tix*12 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
        draw string (x,y),""&n-1
    next
    if showtiles=1 then sleep

    screenset 1,1
    locate 1,1
    print "Loading tiles:..........."
    screenset 0,1
    
    n=990
    cls
    bload "graphics/player.bmp"
    for y=0 to _tiy*2 step _tiy
        for x=0 to _tix*2 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


    screenset 1,1
    locate 1,1
    print "Loading tiles:............"
    screenset 0,1
    
    n=1000
    cls
    bload "graphics/critters.bmp"
    for y=0 to _tiy*4 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:............."
    screenset 0,1
    

    n=1500
    cls
    bload "graphics/characters.bmp"

    for y=0 to _tiy*1 step _tiy
        for x=0 to _tix*7 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next

    n=1600
    'Space tiles
    cls
    bload "graphics/planetmap.bmp"

    screenset 1,1
    locate 1,1
    print "Loading tiles:.............."
    screenset 0,1
    
    for y=0 to _tiy*4 step _tiy
        for x=0 to _tix*5 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


    screenset 1,1
    locate 1,1
    print "Loading tiles:..............."
    screenset 0,1
    
    n=1750
    cls
    bload "graphics/spacestations.bmp"
    for x=0 to _tix*11 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,0)-(x+_tix-1,_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    screenset 1,1
    locate 1,1
    print "Loading tiles:................"
    screenset 0,1
    
    n=2001
    cls
    bload "graphics/items.bmp"
    for y=0 to _tiy*6 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


    screenset 1,1
    locate 1,1
    print "Loading tiles:................."
    screenset 0,1
    
    n=2500
    cls
    bload "graphics/walls.bmp"
    for y=0 to _tiy*13 step _tiy
        for x=0 to _tix*9 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1
            n+=1
        next
    next


    screenset 1,1
    locate 1,1
    print "Loading tiles:.................."
    screenset 0,1
    
    n=3001
    cls
    bload "graphics/portals.bmp"
    y=0
    for x=0 to _tix*8 step _tix
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next
    cls
    bload "graphics/brokenships.bmp"
    x=0
    for y=0 to _tiy*16 step _tiy
        gtiles(a)=imagecreate(_tix,_tiy)
        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
        gt_no(n)=a
        a+=1
        n+=1
    next

    bload "graphics/missing.bmp"
    gtiles(2048)=imagecreate(_tix,_tiy)
    get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
    screenset 1,1
    locate 1,1
    print "Loading tiles:.................."
    
    return 0
end function


'function load_tiles() as short
'    dim as short x,y,a,n,sx,sy,showtiles
'    dim as any ptr img,img2
'    showtiles=0
'    for a=0 to 4096
'        gt_no(a)=2048
'    next
'    cls
'    img=bmp_load( "graphics/ships.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    imagedestroy(img)
'    cls
'    img=bmp_load( "graphics/ships2.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    imagedestroy(img)
'
'
'    cls
'    img=bmp_load( "graphics/ships3.bmp")
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*10,y),""&sy
'    next
'    imagedestroy(img)
'
'
'    a=1
'    n=1
'    cls
'    bload("graphics/space.bmp")
'
'    for y=0 to _tiy*6 step _tiy
'        for x=0 to _tix*15 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=75
'    cls
'    bload "graphics/weapons.bmp"
'    y=0
'    for x=0 to _tix*2 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'    y=_tiy
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    n=101
'    imagedestroy(img)
'    img=0
'    cls
'    img=bmp_load( "graphics/land.bmp")
'    for y=0 to _tiy*16 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get img,(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=750
'    cls
'    bload "graphics/critters3.bmp"
'    for y=0 to _tiy*10 step _tiy
'        x=0
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    n=800
'    cls
'    bload "graphics/critters2.bmp"
'    for y=0 to _tiy*10 step _tiy
'        for x=0 to _tix*12 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'        draw string (x,y),""&n-1
'    next
'    if showtiles=1 then sleep
'
'    n=1000
'    cls
'    bload "graphics/critters.bmp"
'    for y=0 to _tiy*4 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=2001
'    cls
'    bload "graphics/items.bmp"
'    for y=0 to _tiy*5 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=3001
'    cls
'    bload "graphics/portals.bmp"
'    y=0
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    bload "graphics/missing.bmp"
'    gtiles(2048)=imagecreate(_tix,_tiy)
'    get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
'    cls
'    print "loaded "& a &" sprites."
'    return 0
'end function
'
'
'
'function load_tiles() as short
'    dim as short x,y,a,n,sx,sy,showtiles
'    dim image(12) as any ptr
'    showtiles=0
'    for a=0 to 4096
'        gt_no(a)=2048
'    next
'    print "Loading sprites .";
'    image(0)=bmp_load( "graphics/ships.bmp")
'    image(1)=bmp_load( "graphics/ships2.bmp")
'    image(2)=bmp_load( "graphics/ships3.bmp")
'    image(3)=bmp_load( "graphics/space.bmp")
'
'    put (0,0),image(3)
'    sleep
'
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(0),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'    print ".";
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(1),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*9,y),""&sy
'    next
'
'    print ".";
'    for y=0 to _tiy*16 step _tiy
'        sx=1
'        sy+=1
'        for x=0 to _tix*8 step _tix
'            stiles(sx,sy)=imagecreate(_tix,_tiy)
'            get image(2),(x,y)-(x+_tix-1,y+_tiy-1),stiles(sx,sy)
'            sx+=1
'        next
'        draw string (24*10,y),""&sy
'    next
'
'
'    n=75
'    print ".";
'    image(4)=bmp_load( "graphics/weapons.bmp")
'    y=0
'    for x=0 to _tix*2 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(4),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'    y=_tiy
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(4),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    a=1
'    n=1
'    print ".";
'    for y=0 to _tiy*6 step _tiy
'        for x=0 to _tix*15 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(3),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=101
'    print ".";
'    image(5)=bmp_load( "graphics/land.bmp")
'    for y=0 to _tiy*16 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(5),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=750
'    print ".";
'    image(6)=bmp_load( "graphics/critters3.bmp")
'    for y=0 to _tiy*10 step _tiy
'        x=0
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(6),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'
'    n=800
'    print ".";
'    image(7)=bmp_load( "graphics/critters2.bmp")
'    for y=0 to _tiy*10 step _tiy
'        for x=0 to _tix*12 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(7),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'        draw string (x,y),""&n-1
'    next
'    if showtiles=1 then sleep
'
'    n=1000
'    print ".";
'    image(8)=bmp_load( "graphics/critters.bmp")
'    for y=0 to _tiy*4 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(8),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    print ".";
'    image(9)=bmp_load( "graphics/planetmap.bmp")
'
'    n=1500
'    for y=0 to _tiy*3 step _tiy
'        for x=0 to _tix*11 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(9),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'    n=2001
'    print ".";
'    image(10)=bmp_load( "graphics/items.bmp")
'    for y=0 to _tiy*5 step _tiy
'        for x=0 to _tix*19 step _tix
'            gtiles(a)=imagecreate(_tix,_tiy)
'            get image(10),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'            gt_no(n)=a
'            a+=1
'            n+=1
'        next
'    next
'
'    n=3001
'    print ".";
'    image(11)=bmp_load( "graphics/portals.bmp")
'    y=0
'    for x=0 to _tix*8 step _tix
'        gtiles(a)=imagecreate(_tix,_tiy)
'        get image(11),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
'        gt_no(n)=a
'        a+=1
'        n+=1
'    next
'
'    image(12)=bmp_load( "graphics/missing.bmp")
'    gtiles(2048)=imagecreate(_tix,_tiy)
'    get image(12),(x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
'    print ".";
'    print " loaded "& a &" sprites."
'    sleep
'    return 0
'end function
'
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
    if (open ("config/shipregister.txt" for input as f))=0 then
        while not(eof(f))
            input #f,lines(count)
            if lines(count)<>"" then count=count+1
        wend
        close f
    endif
    d=val(lines(0))
    mask=lines(1)
    if lines(2)<>"" then
        fname="config/"&lines(2)
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

    open "config/shipregister.txt" for output as f
    print #f,d
    print #f,mask
    print #f,fname

    close f
    return desig

end function

function background(fn as string) as short
    static last as string
    static firstcall as byte
    Dim As Integer filenum, bmpwidth, bmpheight,x,y
    static As Any Ptr img
    cls
    fn="graphics/"&fn
    '' open BMP file
    filenum = FreeFile()
    If Open( fn For Binary Access Read As #filenum ) <> 0 Then Return 0

        '' retrieve BMP dimensions
        Get #filenum, 19, bmpwidth
        Get #filenum, 23, bmpheight

    Close #filenum
    if fn<>last then
        '' create image with BMP dimensions
        if firstcall<>0 then imagedestroy(img)
        img = ImageCreate( bmpwidth, Abs(bmpheight) )

        If img = 0 Then Return 0
        'dst=imagecreate(_screenx,_screeny)
        '' load BMP file into image buffer
        BLoad( fn, img )
        last=fn
    endif
    x=(_screenx-bmpwidth)/2
    y=(_screeny-bmpheight)/2
    put (x,y),img,pset
    firstcall=1
    Return 0

end function

function keybindings(allowed as string="") as short
    dim as short f,a,b,d,x,y,c,ls,lk,cl(99),colflag(99),lastcom,changed,fg,bg,o
    dim as _cords cc,ncc
    dim as string keys(99),nkeys(99),varn(99),expl(99),coml(99),comn(99),comdes(99),text,newkey,text2
    cls
    if not fileexists("config/keybindings.txt") then
        save_keyset
    endif
    f=freefile
    open "config/keybindings.txt" for input as #f
    while not eof(f)
        ls+=1
        line input #f,text2
        if left(text2,1)<>"#" and len(text2)>0 then
            if allowed="" or instr(allowed,load_key(text2))>0 or val(text2)>0 then
                a+=1
                lk+=1
                text=text2
                keys(a)=load_key(text2,varn(a))
                nkeys(a)=keys(a)
                expl(a)=right(varn(a),len(varn(a))-4)
                expl(a)=Ucase(left(expl(a),1))&right(expl(a),len(expl(a))-1)
            endif
        else
            lastcom+=1
            coml(lastcom)=text2
            cl(lastcom)=ls
        endif
    wend
    close #f
    f=freefile
    open "data/commands.csv" for input as #f
    a=0
    cls
    while not eof(f)
        line input #f,text2
        if left(text2,1)<>"#" then
            a+=1
            coml(a)=left(text2,instr(text2,";")-1) &" = "
            comdes(a)=right(text2,len(text2)-instr(text2,";"))
        endif
    wend
    close #f
    do
        for a=1 to lk
            colflag(a)=0
        next
        for a=1 to lk
            for b=1 to lk
                if a<>b and nkeys(a)=nkeys(b) then
                    colflag(a)=1
                    colflag(b)=1
                endif
            next
        next
        set__color( 11,0)
        cls
        if cc.x<1 then cc.x=1
        if cc.y<1 then cc.y=1
        if cc.x>4 then cc.x=4
        if cc.y>20 then cc.y=20
        'c=(cc.x-1)*20+cc.y
        if c<1 then c=lk
        if c>lk then c=1

        if varn(c)="" then cc=ncc
        screenset 0,1
        set__color( 15,0)
        draw string ((_screenx-12*_fw2)/2,1*_fh2),"Keybindings:",,FONT2,custom,@_col
        b=0
        for x=1 to 4
            for y=1 to 20
                if x>1 or y>6 then
                b+=1
                if c=b then
                    fg=15
                    bg=5
                    cc.x=x
                    cc.y=y
                    for d=1 to 99
                        set__color( 15,0)
                        if ucase(trim(varn(b)))=ucase(trim(coml(d))) then draw string (5*_fw2,26*_fh2), comdes(d),,FONT2,custom,@_col
                    next
                else
                    fg=11
                    bg=0
                endif
                if colflag(b)=1 then fg=14
                set__color( fg,bg)

                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),space(25),,FONT2,custom,@_col
                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),expl(b)& nkeys(b),,FONT2,custom,@_col
                endif
            next
        next
        set__color( 11,0)
        draw string (5*_fw2,25*_fh2),"\C=Control Yellow: 2 commands bound to same key.",,FONT2,custom,@_col
        for b=1 to 8
            set__color( 11,0)
            if b=1 then
                draw string (2*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=2 then
                draw string (4*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=3 then
                draw string (6*_fw2,(3)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=4 then
                draw string (2*_fw2,(5)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=5 then
                draw string (6*_fw2,(5)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=6 then
                draw string (2*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=7 then
                draw string (4*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
            if b=8 then
                draw string (6*_fw2,(7)*_fh2),nkeys(b),,FONT2,custom,@_col
            endif
        next
        set__color( 15,0)
        draw string (3*_fw2,4*_fh2),"\|/",,FONT2,custom,@_col
        draw string (3*_fw2,5*_fh2),"- -",,FONT2,custom,@_col
        draw string (3*_fw2,6*_fh2),"/|\",,FONT2,custom,@_col
        set__color( 11,0)
        draw string (4*_fw2,5*_fh2),"@",,FONT2,custom,@_col

        no_key=keyin
        o=c
        if getdirection(no_key)=8 then c-=1
        if getdirection(no_key)=2 then c+=1
        if getdirection(no_key)=4 then c-=20
        if getdirection(no_key)=6 then c+=20
        if c<1 then c=lk
        if c>lk then c=1
    
        'c=(cc.x-1)*20+cc.y
        if varn(c)="" then o=c

        if no_key=key__enter and keys(c)<>"" then
            screenset 1,1
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),space(25),,FONT2,custom,@_col
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),expl(c),,FONT2,custom,@_col
            newkey=gettext(2+(cc.x-1)*25+len(expl(c)),cc.y+2,3,"")
            newkey=trim(newkey)
            if newkey<>"" and newkey<>nkeys(c) then
                nkeys(c)=newkey
            endif
        endif
    loop until no_key=key__esc

    for a=1 to lk
        if keys(a)<>nkeys(a) then
            changed=1
        endif
    next

    if changed=1 then
        if askyn("Do you want to save changes(y/n)?") then
            f=freefile
            open "config/keybindings.txt" for output as #f
            lastcom=1
            b=1
            for a=1 to lk
                print #f,varn(a)&" "&nkeys(a)
            next
            close #f
            load_keyset
        endif
    endif
    return 0
end function

function save_keyset() as short
    dim f as short
    f=freefile
    open "config/keybindings.txt" for output as #f
    print #f,"key_nw = "&key_nw
    print #f,"key_north = "&key_north
    print #f,"key_ne = "&key_ne
    print #f,"key_west = "&key_west
    print #f,"key_east = "&key_east
    print #f,"key_sw = " &key_sw
    print #f,"key_south = "&key_south
    print #f,"key_se = "&key_se
    print #f,"key_wait = "&key_wait
    print #f,"key_portal = "&key_portal
    print #f,"key_autoexplore = "&key_autoexplore
    print #f,"key_optequip = "&key_optequip
    print #f,"key_layfire = "&key_layfire
    print #f,"key_manual = "&key_manual
    print #f,"key_messages = "&key_messages
    print #f,"key_configuration = "&key_configuration
    print #f,"key_autoinspect = "&key_autoinspect
    print #f,"key_autopickup = "&key_autopickup
    print #f,"key_shipstatus ="&key_shipstatus
    print #f,"key_awayteam ="&key_awayteam
    print #f,"key_togglehpdisplay ="&key_togglehpdisplay
    print #f,"key_tactics ="&key_tactics
    print #f,"key_filter ="&key_filter
    print #f,"key_logbook ="&key_logbook
    print #f,"key_quest ="&key_quest
    'print #f,"key_weapons ="&key_weapons
    print #f,"key_equipment ="&key_equipment
    print #f,"key_yes ="&key_yes
    print #f,"key_landing ="&key_la
    print #f,"key_scanning ="&key_sc
    print #f,"key_standing ="&key_standing
    print #f,"key_targetlanding ="&key_tala
    print #f,"key_dock ="&key_dock
    print #f,"key_save ="&key_save
    print #f,"key_quit="&key_quit
    print #f,"key_rename ="&key_rename
    print #f,"key_comment ="&key_comment
    print #f,"key_tow ="&key_tow
    print #f,"key_pickup ="&key_pickup
    print #f,"key_dropitem ="&key_drop
    print #f,"key_inspect ="&key_inspect
    print #f,"key_examine ="&key_ex
    print #f,"key_report ="&key_report
    print #f,"key_radio ="&key_ra
    print #f,"key_teleport ="&key_te
    print #f,"key_jump ="&key_ju
    print #f,"key_communicate ="&key_co
    print #f,"key_offer ="&key_of
    print #f,"key_grenade ="&key_gr
    print #f,"key_fire ="&key_fi
    print #f,"key_autofire ="&key_autofire
    print #f,"key_heal ="&key_he
    print #f,"key_walk ="&key_walk
    print #f,"key_oxygen ="&key_oxy
    print #f,"key_close ="&key_close
    print #f,"key_dropshield ="&key_dropshield
    print #f,"key_activatesensors ="&key_ac
    print #f,"key_run ="&key_ru
    print #f,"key_togglemanjets ="&key_togglemanjets
    close f
    return 0
end function


function load_keyset() as short
    dim as short f,a,b,c,i,j,li
    dim as string text,lctext
    dim keys(256) as string
    dim texts(256) as string
    f=freefile
    if fileexists("config/keybindings.txt") then

        open "config/keybindings.txt" for input as #f
        print "loading keyset";
        do
            b+=1
            line input #f,texts(b)
            if instr(text,"#")=0 and len(text)>0 then
                a+=1
                keys(a)=right(text,1)
            endif
        loop until eof(f)
        for i=1 to a
            for j=1 to a
                if i<>j then
                    if keys(i)=keys(j) then
                        for c=1 to b
                            if right(texts(c),1)=keys(j) then li=c
                        next
                        print "Two commands bound to "&keys(j) &"in line "&li &" ("&texts(li) &")"
                        print "using default keys"
                        sleep 250
                        close f
                        return 0
                    endif
                endif
            next
        next

        close f

        for i=1 to b
            print ".";
            text=texts(i)
            if left(text,1)<>"#" and len(text)>0 then
                lctext=lcase(text)
                if instr(lctext,"key_nw")>0 then key_nw=load_key(text)
                if instr(lctext,"key_north")>0 then key_north=load_key(text)
                if instr(lctext,"key_ne")>0 then key_ne=load_key(text)
                if instr(lctext,"key_west")>0 then key_west=load_key(text)
                if instr(lctext,"key_east")>0 then key_east=load_key(text)
                if instr(lctext,"key_sw")>0 then key_sw=load_key(text)
                if instr(lctext,"key_south")>0 then key_south=load_key(text)
                if instr(lctext,"key_se")>0 then key_se=load_key(text)
                if instr(lctext,"key_wait")>0 then key_wait=load_key(text)
                if instr(lctext,"key_portal")>0 then key_portal=load_key(text)
                if instr(lctext,"key_accounting")>0 then key_accounting=load_key(text)
                if instr(lctext,"key_autoexplore")>0 then key_autoexplore=load_key(text)
                if instr(lctext,"key_optequip")>0 then key_optequip=load_key(text)

                if instr(lctext,"key_manual")>0 then key_manual=load_key(text)
                if instr(lctext,"key_messages")>0 then key_messages=load_key(text)
                if instr(lctext,"key_configuration")>0 then key_configuration=load_key(text)
                if instr(lctext,"key_autopickup")>0 then key_autopickup=load_key(text)
                if instr(lctext,"key_autoinspect")>0 then key_autoinspect=load_key(text)
                if instr(lctext,"key_shipstatus")>0 then key_shipstatus=load_key(text)
                if instr(lctext,"key_save")>0 then key_save=load_key(text)
                if instr(lctext,"key_quit")>0 then key_quit=load_key(text)
                if instr(lctext,"key_tactics")>0 then key_tactics=load_key(text)
                if instr(lctext,"key_filter")>0 then key_filter=load_key(text)
                if instr(lctext,"key_comment")>0 then key_comment=load_key(text)
                if instr(lctext,"key_awayteam")>0 then key_awayteam=load_key(text)
                if instr(lctext,"key_logbook")>0 then key_logbook=load_key(text)
                if instr(lctext,"key_equipment")>0 then key_equipment=load_key(text)
                if instr(lctext,"key_quest")>0 then key_quest=load_key(text)
                if instr(lctext,"key_tow")>0 then key_tow=load_key(text)
                if instr(lctext,"key_standing")>0 then key_standing=load_key(text)

                if instr(lctext,"key_landing")>0 then key_la=load_key(text)
                if instr(lctext,"key_scanning")>0 then key_sc=load_key(text)
                if instr(lctext,"key_comment")>0 then key_comment=load_key(text)
                if instr(lctext,"key_rename")>0 then key_rename=load_key(text)
                if instr(lctext,"key_targetlanding")>0 then key_tala=load_key(text)
                if instr(lctext,"key_togglehpdisplay")>0 then key_togglehpdisplay=load_key(text)

                if instr(lctext,"key_pickup")>0 then key_pickup=load_key(text)
                if instr(lctext,"key_dropitem")>0 then key_drop=load_key(text)
                if instr(lctext,"key_inspect")>0 then key_inspect=load_key(text)
                if instr(lctext,"key_examine")>0 then key_ex=load_key(text)
                if instr(lctext,"key_radio")>0 then key_ra=load_key(text)
                if instr(lctext,"key_teleport")>0 then key_te=load_key(text)
                if instr(lctext,"key_jump")>0 then key_ju=load_key(text)
                if instr(lctext,"key_communicate")>0 then key_co=load_key(text)
                if instr(lctext,"key_offer")>0 then key_of=load_key(text)
                if instr(lctext,"key_grenade")>0 then key_gr=load_key(text)
                if instr(lctext,"key_fire")>0 then key_fi=load_key(text)
                if instr(lctext,"key_autofire")>0 then key_autofire=load_key(text)
                if instr(lctext,"key_walk")>0 then key_walk=load_key(text)
                if instr(lctext,"key_heal")>0 then key_he=load_key(text)
                if instr(lctext,"key_oxygen")>0 then key_oxy=load_key(text)
                if instr(lctext,"key_close")>0 then key_close=load_key(text)

                if instr(lctext,"key_shield")>0 then key_dropshield=load_key(text)
                if instr(lctext,"key_activatesensors")>0 then key_ac=load_key(text)
                if instr(lctext,"key_run")>0 then key_ru=load_key(text)
                if instr(lctext,"key_togglemanjets")>0 then key_togglemanjets=load_key(text)
                if instr(lctext,"key_yes")>0 then key_yes=load_key(text)
                if instr(lctext,"key_extendedkey")>0 then key_extended=load_key(text)

            endif
        next
    else
        set__color( 14,0)
        print "File keybindings.txt not found. Using default keys"
        save_keyset
        set__color( 15,0)
        Sleep 1500
        return 1
    endif

    return 0
end function

function load_key(byval t2 as string,byref n as string="") as string
    dim as short l,i,record
    dim as string t,t3
    t=t2
    for i=1 to len(t)
        if record=1 then t3 &=mid(t,i,1)
        if record=0 then n &=mid(t,i,1)
        if mid(t,i,1)="=" then record=1
    next
    return trim(t3)
end function

function numfromstr(t as string) as short
    dim as short a
    dim as string t2
    for a=1 to len(t)
        if val(mid(t,a,1))<>0 or (mid(t,a,1))="0" then t2=t2 &mid(t,a,1)
    next
    return val(t2)
end function

function load_dialog_quests() as short
    dim as short f,i,j,g
    dim as string l,w(3)

    f=open_file("data/dialogquests.csv")
    do
        i+=1
        for j=0 to 2
            for g=0 to 3
                w(g)=""
            next
            line input #f,l
            string_towords(w(),l,";")

            questguydialog(i,j,Q_WANT)=w(1)
            questguydialog(i,j,Q_HAS)=w(2)
            questguydialog(i,j,Q_ANSWER)=w(3)
        next

    loop until eof(f)

    close #f
    f=open_file("data/dialogquests2.csv")
    i=0
    do
        w(0)=""
        w(1)=""
        w(2)=""
        line input #f,l
        string_towords(w(),l,";")
        i+=1
        questguyquestion(i,Q_WANT)=w(0)
        questguyquestion(i,Q_HAS)=w(1)
    loop until eof(f)
    close #f
    return 0
end function


function load_dialog(fn as string, n() as _dialognode) as short
    dim as short f,i,j,g,node,answer
    dim l(1028) as string
    dim w(9) as string
    f=freefile
    open fn for input as #f
    while not eof(f)
        i+=1
        line input #f,l(i)
    wend
    close #f
    for j=1 to i
        for g=0 to 9
            w(g)=""
        next
        g=string_towords(w(),l(j),";")
        if w(0)<>"" then
            node=val(w(0))
            n(node).no=node
            n(node).statement=w(1)
            n(node).effekt=w(3)
            n(node).param(1)=val(w(4))
            n(node).param(2)=val(w(5))
            n(node).param(3)=val(w(6))
            n(node).param(4)=val(w(7))
            n(node).param(5)=val(w(8))
            answer=0
        else
            answer+=1
            n(node).option(answer).answer=w(1)
            n(node).option(answer).no=val(w(2))
        endif
    next
    return node
end function

function string_towords(word() as string, s as string, break as string, punct as short=0) as short
    dim as short i,a,debug
    'Starts with 0,
    for a=0 to ubound(word)
        word(a)=""
    next
    for a=1 to len(s)
        if i>ubound(word) then
            redim word(i)
        endif
        if mid(s,a,1)=break then
            if debug=1 and _debug=1 then dprint word(i)
            i+=1
        else
            if punct=1 and (mid(s,a,1)="." or mid(s,a,1)=",") then
                i+=1
                word(i)=word(i)&mid(s,a,1)
            else
                word(i)=word(i)&mid(s,a,1)
            endif
        endif
    next
    return i
end function



function texttofile(text as string) as string
    dim a as short
    dim head as short
    dim outtext as string
    outtext="<p>"
    for a=0 to len(text)
        if mid(text,a,1)="|" or mid(text,a,1)="{" then
            if mid(text,a,1)="|" then
                if head=1 then
                    outtext=outtext &"</b>"
                    head=2
                endif
                if head=0 then
                    outtext=outtext &"<b>"
                    head=1
                endif
                outtext=outtext &"<br>"'chr(13)& chr(10)
            endif
            if mid(text,a,1)="{" then a=a+3
        else
            outtext=outtext &mid(text,a,1)
        endif
    next
    outtext=outtext &"</p>"
    return outtext
end function

function configuration() as short
    dim text as string
    dim onoff(1) as string
    dim offon(1) as string
    dim warn(2) as string
    dim sprite(2) as string
    dim res as string
    dim as short c,d,f,i
    dim oldtiles as byte
    oldtiles=configflag(con_tiles)
    onoff(0)=" On "
    onoff(1)=" Off"
    warn(0)="On  "
    warn(1)="Off "
    warn(2)="High"
    offon(0)=" Off"
    offon(1)=" On "
    sprite(0)="Brown"
    sprite(1)="White"
    sprite(2)=" Red "
    screenshot(1)
    do
        if configflag(con_customfonts)=1 then
            res="tiles:"&_fohi1 &" text:"& _fohi2 &" lines:"&_lines
        else
            res="classic"
        endif
        text="Prospector "&__VERSION__ &" Configuration"
        for i=1 to con_end-1
            select case i
            case con_volume
                text=text &"/ Volume (0-4):" & _volume
            case con_res
                text=text &"/ Resolution: "&res
            case con_gtmwx
                text=text &"/ Main window width(tile mode): "& gt_mwx
            case con_sound
                text=text &"/ Sound effects :"& warn(configflag(con_sound))
            case con_captainsprite
                text=text &"/ Captains sprite:"&sprite(configflag(con_captainsprite))
            case else
                text=text & configdesc(i) & onoff(configflag(i))
            end select
        next
        text=text &"/Exit"
        c=menu(bg_randompic,text,,,,1)
        select case c
        case con_sound,con_captainsprite
            configflag(c)+=1
            if configflag(c)>2 then configflag(c)=0
        case con_sound
            configflag(con_sound)=configflag(con_sound)+1
            if configflag(con_sound)=3 then configflag(con_sound)=0
        case con_volume
            dprint "Select volume (0-4)"
            _volume=getnumber(0,4,_volume)
            #ifdef _FMODSOUND
            IF _volume = 0 THEN FSOUND_SetSFXMasterVolume(0)
            IF _volume = 1 THEN FSOUND_SetSFXMasterVolume(63)
            IF _volume = 2 THEN FSOUND_SetSFXMasterVolume(128)
            IF _volume = 3 THEN FSOUND_SetSFXMasterVolume(190)
            IF _volume = 4 THEN FSOUND_SetSFXMasterVolume(255)
            #endif
            #ifdef _FBSOUND
            fbs_Set_MasterVolume(_volume/2.0)
            #endif
        case con_res
            d=menu(bg_randompic,"Resolution/Tiles/Text/Lines/Classic look: "& onoff(configflag(con_customfonts))&" (overrides if on)/Exit")
            if d=1 then
                dprint "Set graphic font height:(8-28)"
                _fohi1=Getnumber(8,28,_fohi1)
            endif
            if d=2 then
                dprint "Set text font height:(8-28)"
                _fohi2=Getnumber(8,28,_fohi2)
            endif
            if d=3 then
                dprint "Number of display lines:"
                _lines=Getnumber(22,33,_lines)
            endif
            if d=4 then
                select case configflag(con_customfonts)
                case is=1
                    configflag(con_customfonts)=0
                case is=0
                    configflag(con_customfonts)=1
                end select
            endif
            if _fohi2>_fohi1 then _fohi2=_fohi1
            dprint "Resolution will be changed next time you start prospector."
        case con_gtmwx
            gt_mwx=getnumber(20,60,30)
            dprint "Will be changed next time you start prospector."
        case con_end,-1 'Exit, do nothing
        case else
            select case configflag(c)
            case 1
                configflag(c)=0
            case 0
                configflag(c)=1
            end select
        end select

    loop until c=con_end or c=-1
    if gamerunning=1 then crew(1).story(3)=configflag(con_captainsprite)
    screenshot(2)
    save_config(oldtiles)
    return 0
end function

function save_config(oldtiles as short) as short
    dim as short f,i
    f=freefile
    open "config/config.txt" for output as #f
    print #f,"# 0 is on, 1 is off"
    for i=con_tiles to con_end-1
        print #f,configname(i)&":"&configflag(i)
    next
    print #f,""
    print #f,"spacemapx:"&sm_x
    print #f,"spacemapy:"&sm_y
    print #f,"laststar:"&laststar
    print #f,"wormholes:"&wormhole
    print #f,"gtmwx:"&gt_mwx
    print #f,"_tix:"&_tix
    print #f,"_tiy:"&_tiy
    print #f,"tilefont:"&_FoHi1
    print #f,"textfont:"&_FoHi2
    print #f,"lines:"&_lines
    print #f,"volume:"&_volume
    close #f
    return 0
end function

function load_config() as short
    dim as short f,i,j
    dim as string text,rhs,lhs

    if fileexists("config/config.txt") then
        f=freefile
        open "config/config.txt" for input as #f
        print "loading config";
        do
            print ".";
            line input #f,text
            if instr(text,"#")=0 and len(text)>1 then
                text=lcase(text)

                j=instr(text,":")
                rhs=right(text,len(text)-j)
                lhs=left(text,j-1)

                for i=con_tiles to con_end-1
                    if lhs=configname(i) then
                        if val(rhs)=0 or rhs="on" then configflag(i)=0
                        if val(rhs)=1 or rhs="off" then configflag(i)=1
                        print i;":";lhs;":";rhs ;":";configflag(i)
                    endif
                next

                if lhs="captainsprite" then configflag(con_captainsprite)=val(rhs)
                if instr(text,"wormhole")>0 then wormhole=numfromstr(text)
                if instr(text,"laststar")>0 then laststar=numfromstr(text)
                if instr(text,"spacemapx")>0 then sm_x=numfromstr(text)
                if instr(text,"spacemapy")>0 then sm_y=numfromstr(text)
                if instr(text,"_tix")>0 then _tix=numfromstr(text)
                if instr(text,"_tiy")>0 then _tiy=numfromstr(text)
                if instr(text,"gtmwx")>0 then gt_mwx=numfromstr(text)
                if instr(text,"tilefont")>0 then _FoHi1=numfromstr(text)
                if instr(text,"textfont")>0 then _FoHi2=numfromstr(text)
                if instr(text,"lines")>0 then _lines=numfromstr(text)
                if instr(text,"shipcolor")>0 then _shipcolor=numfromstr(text)
                if instr(text,"teamcolor")>0 then _teamcolor=numfromstr(text)


                if instr(text,"soun")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then configflag(con_sound)=0
                    if instr(text,"1")>0 or instr(text,"of") then configflag(con_sound)=1
                    if instr(text,"2")>0 or instr(text,"high") then configflag(con_sound)=2
                endif

                if instr(text,"volume")>0 then
                    if instr(text,"0")>0 then _volume=0
                    if instr(text,"1")>0 then _volume=1
                    if instr(text,"2")>0 then _volume=2
                    if instr(text,"3")>0 then _volume=3
                    if instr(text,"4")>0 then _volume=4
                endif

                if instr(text,"rolls")>0 then
                    if instr(text,"0")>0 then configflag(con_showrolls)=0
                    if instr(text,"1")>0 then configflag(con_showrolls)=1
                    if instr(text,"2")>0 then configflag(con_showrolls)=2
                endif

            endif
        loop until eof(f)
        close #f
    else
        color 15,0
        print "No Config.txt. Using default configuration"
        configflag(con_tiles)=0
        configflag(con_gtmwx)=40
        configflag(con_classic)=1
        configflag(con_showvis)=0
        configflag(con_transitem)=0
        configflag(con_onbar)=1
        configflag(con_sysmaptiles)=0
        configflag(con_customfonts)=0
        configflag(con_chosebest)=0
        configflag(con_autosale)=0
        configflag(con_sound)=0
        configflag(con_warnings)=0
        configflag(con_damscream)=0
        configflag(con_volume)=2
        configflag(con_anykeyno)=0
        configflag(con_diagonals)=1
        configflag(con_easy)=0
        configflag(con_minsafe)=0
        configflag(con_startrandom)=1
        configflag(con_autosave)=0
        configflag(con_savescumming)=0
        configflag(con_restart)=0
        gt_mwx=40
        _tix=24
        _tiy=24
        _Fohi1=18
        _Fohi2=16
        _lines=26
        _volume=1
        sleep 100
        save_config(configflag(con_tiles))
        load_config
    endif

    if configflag(con_tiles)=0 then
        _mwx=gt_mwx
    else
        _mwx=60
    endif

    #ifdef _FBSOUND
    fbs_Set_MasterVolume(_volume/2.0)
    #endif
    if sm_x>200 then sm_x=200
    if sm_y>200 then sm_y=200
    redim spacemap(sm_x,sm_y)
    redim vismask(sm_x,sm_y)
    if wormhole mod 2<>0 then wormhole+=1
    redim map(laststar+wormhole+1)
    return 0
end function


function getfilename() as string
    dim filename as string
    dim a as string
    dim b as string*36
    dim c as short
    dim n(24) as string
    dim d as string*36
    dim vers as string*36
    dim datestring as string*12
    dim ustring as string*512
    dim as string help
    dim text as string
    dim unflags(lastspecial) as byte
    dim artflags(lastartifact) as short
    dim f as integer
    dim i as integer
    dim as short j,ll,ca
    text="Savegames:"
    a=dir$("savegames/*.sav")
    while a<>""
        if a<>"empty.sav" and c<24 then
            c+=1
            n(c)=a



            f=freefile
            open "savegames/"&n(c) for binary as #f
            get #f,,vers
            if instr(vers,"VERSION")>0 then                    
                get #f,,b
            else
                b=vers
            endif
            get #f,,d
            get #f,,datestring
            get #f,,unflags()
            get #f,,artflags()
            close #f
            ll=0
            for j=0 to lastspecial
                if unflags(j)=1 then ll+=1
            next
            for j=0 to lastartifact
                if artflags(j)=1 then ca+=1
            next
            text=text &"/" & b &d &"(" &datestring &")"
            if ll>20 then
                help=help &"/ Discovered " & ll &" unique planets"
            else
                help=help &"/" &trim(uniques(unflags()))
            endif
            if ca>20 then
                help=help &"| Discovered "& ca &" artifacts"
            else
                help=help &"|"& trim(list_artifacts(artflags()))
            endif
        endif
        a=dir()
    wend
    text=text &"/Exit"
    c=menu(bg_randompictxt,text,help,2,2)
    if c>0 and c<=24 then filename=n(c)
    return filename
end function

function save_bones(t as short) as short
    dim f as integer
    dim as short x,y,a,b
    dim as _cords team
    dim bones_item(64) as _items
    if is_special(player.landed.m) then return 0
    if is_drifter(player.landed.m) then return 0
    if planets(player.landed.m).depth=0 then planetmap(player.landed.x,player.landed.y,player.landed.m)=127+player.h_no
    f=freefile
    open "bones/"&player.desig &".bon" for binary as #f
    put #f,,planets(player.landed.m)
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,player.landed.m)>0 then planetmap(x,y,player.landed.m)=-planetmap(x,y,player.landed.m)
            put #f,,planetmap(x,y,player.landed.m)
        next
    next
    team=awayteam.c
    for a=0 to lastitem
        if item(a).w.s=-1 and rnd_range(1,100)<25 then
            b+=1
            item(a).w.s=0
            item(a).w.p=0
            item(a).w.x=player.landed.x
            item(a).w.y=player.landed.y
            if rnd_range(1,100)<25 then item(a).w=movepoint(item(a).w,5)
            if b<=64 then bones_item(b)=item(a)
        endif
    next
    b+=1
    if b>64 then b=64
    bones_item(b)=make_item(81)
    bones_item(b).ldesc="The Id-tag of Captain  "&crew(1).n &" of the "&player.desig
    bones_item(b).w.x=team.x
    bones_item(b).w.y=team.y

    put #f,,b
    for a=1 to b
        put #f,,bones_item(a)
    next
    close #f
    return 0
end function

function load_bones() as short
    dim s as string
    dim as short d,c,m,f,sys
    dim as _cords p
    dim as _planet pl
    s=getbonesfile
    if _debug>0 then dprint s
    if s<>"" then
        f=freefile
        open "bones/"&s for binary as #f
        get #f,,pl
        if pl.depth=0 then
            do
                sys=get_random_system
                m=getrandomplanet(sys)
            loop until m>0 and is_gasgiant(m)=0 and is_special(m)=0
            BonesFlag=m
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 and _debug=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            map(sys).discovered=4
        else
            sys=rnd_range(1,lastportal)
            m=portal(sys).dest.m
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 and _debug=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            p=rnd_point(m,0)
            portal(sys).dest.x=p.x
            portal(sys).dest.y=p.y
        endif
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,m)>0 then planetmap(x,y,m)=planetmap(x,y,m)*-1
            next
        next
        planets(m).visited=0
        get #f,,d
        for c=lastitem+1 to lastitem+1+d
            if c>0 and c<=25000 then
                get #f,,item(c)
                item(c).w.m=m
            endif
        next
        lastitem=lastitem+1+d
        close #f
        planets(m)=pl
        planets(m).visited=_debug_bones
        planets_flavortext(m)="You get a wierd sense of deja vu from this place."
        kill "bones/"&s
    endif
    return 0
end function

function getbonesfile() as string
    dim s as string
    dim d as string
    dim as short chance
    d=dir$("bones/*.bon")
    chance=10
    do
        d=dir()
        chance=chance+1
    loop until d=""
    if _debug_bones=2 and _debug=1 then print "chance for bones file:"&chance
    d=dir$("bones/*.bon")
    do
        if (rnd_range(1,100)<chance or _debug_bones=1) and s="" then s=d
        d=dir()
    loop until d=""
    return s
end function

function savegame(crash as short=0) as short
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim desig as string*36
    dim names as string*36
    dim versionstring as string*36
    dim datestring as string*12
    dim cl as string
    dim unflags(lastspecial) as byte
    dim artifactstr as string*512

    'Needed for compression
    dim as Integer dest_len, header_len
    dim as Ubyte Ptr dest
    dim filedata_string as string
    dim as short emptyshort
    make_unflags(unflags())
    versionstring="VERSION:"&__VERSION__
    cl=player.h_sdesc
    names=player.desig
    desig="("&cl &", "&credits(player.money) &" Cr, T:" &display_time(player.turn,2) &")"
    datestring=date_string
    cls
    back=99
    f=freefile
    fname="savegames/"&player.desig
    if crash=0 then 
        fname=fname &".sav"
    else
        fname=fname &"-crash.sav"
    endif
    print "Saving "&fname;
    open fname for binary as #f
    print ".";
    'save shortinfo
    put #f,,versionstring
    put #f,,names
    put #f,,desig
    put #f,,datestring
    put #f,,unflags()
    put #f,,artflag()
    print ".";
    'save player
    put #f,,player
    put #f,,whtravelled
    put #f,,whplanet
    put #f,,ano_money
    put #f,,questroll
    put #f,,_autopickup
    put #f,,_autoinspect
    put #f,,ranoutoffuel
    put #f,,income()
    put #f,,piratekills()
    put #f,,farthestexpedition
    put #f,,BonesFlag
    put #f,,alliance()
    put #f,,bountyquest()
    put #f,,patrolquest()
    put #f,,nextlanding
    
    for a=1 to 255
        put #f,,crew(a)
    next

    for a=0 to 8
        put #f,,faction(a)
    next

    for a=0 to 9
        put #f,,combon(a)
    next

    put #f,,captainskill
    put #f,,wage

    for a=0 to 16
        put #f,,retirementassets(a)
    next

    print ".";

    for a=0 to 16
        put #f,,savefrom(a).awayteam
        put #f,,savefrom(a).lastlocalitem
        put #f,,savefrom(a).lastenemy
        if savefrom(a).lastenemy>0 then
            for b=0 to savefrom(a).lastenemy
                put #f,,savefrom(a).enemy(b)
            next
        endif
        put #f,,savefrom(a).ship
        put #f,,savefrom(a).map
        print ".";
        'dat(1)=dat(1)+sizeof(savefrom(a))
    next
    'save maps
    put #f,,laststar
    put #f,,wormhole
    for a=0 to laststar+wormhole
        put #f,,map(a)
        print ".";
    next
    for a=0 to 12
        put #f,,basis(a)
        print ".";
    next

    put #f,,lastprobe
    if lastprobe>0 then
        for a=1 to lastprobe
            put #f,,probe(a)
        next
    endif

    for a=1 to 4
        put #f,,companystats(a)
    next

    put #f,,alienattacks

    put #f,,lastshare
    for a=0 to lastshare
        put #f,,shares(a)
    next

    for a=0 to 5
        for b=0 to 20
            put #f,,makew(b,a)
        next
    next

    put #f,,lastcagedmonster
    for a=0 to lastcagedmonster
        put #f,,cagedmonster(a)
    next
    put #f,,sm_x
    put #f,,sm_y
    for x=0 to sm_x
        for y=0 to sm_y
            put #f,,spacemap(x,y)
        next
    next

    put #f,,lastdrifting
    if lastdrifting>128 then lastdrifting=128
    for a=1 to lastdrifting
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
        put #f,,piratebase(a)
        print ".";
    next

    put #f,,lastplanet
    for a=0 to lastplanet
        put #f,,planetmap(0,0,a)
        if planetmap(0,0,a)<>0 then
            for b=0 to 60
                for c=0 to 20
                    put #f,,planetmap(b,c,a)
                next
            next
            put #f,,planets(a)
            print ".";
        endif
    next
    for a=0 to lastspecial
        put #f,,specialplanet(a)
        put #f,,specialflag(a)
    next

    for a=272 to 279
        put #f,,tiles(a)
    next

    print ".";

    put #f,,uid
    put #f,,lastitem
    for a=0 to lastitem
        put #f,,item(a)
    next



    print ".";
    'save pirates
    put #f,,reward()
    print ".";

    put #f,,flag()



    put #f,,firstwaypoint
    put #f,,lastwaypoint
    for a=0 to lastwaypoint
        put #f,,targetlist(a)
    next

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

    for c=0 to 12
        for a=0 to 12
            for b=0 to 8
                put #f,,goods_prices(b,a,c)
            next
        next
    next

    for a=0 to lastquestguy
        put #f,,questguy(a)
    next

    put #f,,foundsomething

    put #f,,civ()
    
    put #f,,battleslost()
    
    put #f,,lastshop
    for b=1 to lastshop
        put #f,,shoplist(b)
    next

    for a=0 to 20
        for b=0 to lastshop
            put #f,,shopitem(a,b)
        next
        print ".";
    next
        
    close f

    'Overwrites large save file with compressed save file. but skips if file is empty
    if fname<>"savegames/empty.sav" then
        f=freefile
        open fname for binary as #f
        filedata_string = space(LOF(f))
        get #f,, filedata_string
        close f

        dim as Integer src_len = len(filedata_string) + 1
        dest_len = compressBound(src_len)
        dest = Allocate(dest_len)
        kill(fname)

        f=freefile
        open fname for binary as #f
        compress(dest , @dest_len, StrPtr(filedata_string), src_len)
        put #f,,versionstring
        put #f,,names           '36 bytes
        put #f,,desig           '36 bytes
        put #f,,datestring      '12 bytes + 1 overhead
        put #f,,unflags()       'lastspecial + 1 overhead
        put #f,,artflag()       'lastartifact + 1 overhead
        put #f,, src_len 'we can use this to know the amount of memory needed when we load - should be 4 bytes long
        'Putting in the short info the the load game menu

        header_len =  36 + 36 + 36 + 12 + lastspecial + lastartifact*2 + 4 + 4 + 3 ' bytelengths of names, desig, datestring,
        'unflags, artflag, src_len, header_len, and 3 bytes of over head for the 3 arrays datestring, unflags, artflag
        put #f,, header_len
        put #f,, *dest, dest_len
        close f
        Deallocate(dest)
    endif
    'Done with compressed file stuff

    set__color( 14,0)
    cls
    return back
end function


function load_game(filename as string) as short
    dim from as short
    dim ship as _cords
    dim awayteam as _monster
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim desig as string*36
    dim names as string*36
    dim versionstring as string*36
    dim datestring as string*12
    dim unflags(lastspecial) as byte
    dim as short emptyshort
    dim text as string
    dim p as _planet
    dim debug as byte

    'needed to handle the compressed data
    dim as uByte ptr src, dest
    dim as Integer src_len, dest_len, header_len
    dim as string compressed_data

    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=p
    next


    if filename<>"" then
        fname="savegames/"&filename
        dprint "loading "&fname

        if fname <> "savegames/empty.sav" then 'makes sure we dont load the uncompressed empty
            'Starting the uncompress
            f=freefile
            open fname for binary as #f
            get #f,,versionstring
            dprint "checking version"
            if instr(versionstring,"VERSION:")>0 then
                if versionstring<>"VERSION:"&__version__ then
                    dprint "Savegame from another version then your current version(" & (versionstring) &" and VERSION:" &(__version__)  & ")."
                    if val(__version__)>val(__lastsavegamechange__) then
                        dprint "Should be ok"
                    else
                        if not askyn("Versions incompatible. Savegame must be at least v " & __lastsavegamechange__ & "Do you want to try to load anyway?(y/n)") then return 0
                    endif
                else
                    dprint "Version Ok."
                endif
                get #f,,names           '36 bytes
            else
                names=versionstring
            endif
            get #f,,desig             '36 bytes
            get #f,,datestring      '12 bytes + 1 overhead
            get #f,,unflags()       'lastspecial + 1 overhead
            get #f,,artflag()       'lastartifact + 1 overhead

            get #f,,dest_len
            get #f,,header_len

            src_len = LOF(f)-header_len
            src = Allocate(src_len)
            dest = Allocate(dest_len)
            get #f,,*src, src_len
            uncompress(dest, @dest_len, src, src_len)
            close f

            open fname for binary as #f
            compressed_data = space(LOF(f))
            get #f,, compressed_data
            close f

            kill(fname)

            f=freefile
            open fname for binary as #f
            put #f,, *dest, dest_len
            close f
        endif
        'Ending uncompress


        f=freefile
        open fname for binary as #f
        get #f,,versionstring
        get #f,,names
        get #f,,desig
        get #f,,datestring
        get #f,,unflags()
        get #f,,artflag()
        print ".";
        'save player
        get #f,,player
        get #f,,whtravelled
        get #f,,whplanet
        get #f,,ano_money
        get #f,,questroll
        get #f,,_autopickup
        get #f,,_autoinspect
        get #f,,ranoutoffuel
        get #f,,income()
        get #f,,piratekills()
        get #f,,farthestexpedition
        get #f,,BonesFlag
        get #f,,alliance()
        get #f,,bountyquest()
        get #f,,patrolquest()
        get #f,,nextlanding
    
        for a=1 to 255
            get #f,,crew(a)
        next
    
        for a=0 to 8
            get #f,,faction(a)
        next

        for a=0 to 9
            get #f,,combon(a)
        next

        get #f,,captainskill
        get #f,,wage
        for a=0 to 16
            get #f,,retirementassets(a)
        next

        print ".";



        for a=0 to 16
            get #f,,savefrom(a).awayteam
            get #f,,savefrom(a).lastlocalitem
            get #f,,savefrom(a).lastenemy
            if savefrom(a).lastenemy>0 then
                for b=0 to savefrom(a).lastenemy
                    get #f,,savefrom(a).enemy(b)
                    if _debug>0 then dprint cords(savefrom(a).enemy(b).c)
                next
            endif
            get #f,,savefrom(a).ship
            get #f,,savefrom(a).map
            print ".";
        next
        get #f,,laststar
        get #f,,wormhole
        redim map(laststar+wormhole+1) as _stars
        for a=0 to laststar+wormhole
            get #f,,map(a)
            print ".";
        next

        for a=0 to 12
            get #f,,basis(a)
            print ".";
        next

        get #f,,lastprobe
        if lastprobe>0 then
            for a=1 to lastprobe
                get #f,,probe(a)
            next
        endif

        for a=1 to 4
            get #f,,companystats(a)
        next

        get #f,,alienattacks

        get #f,,lastshare
        for a=0 to lastshare
            Get #f,,shares(a)
        next

        for a=0 to 5
            for b=0 to 20
                get #f,,makew(b,a)
            next
        next


        get #f,,lastcagedmonster
        for a=0 to lastcagedmonster
            get #f,,cagedmonster(a)
        next


        get #f,,sm_x
        get #f,,sm_y
        redim spacemap(sm_x,sm_y) as short
        redim vismask(sm_x,sm_y) as byte
        for x=0 to sm_x
            for y=0 to sm_y
                get #f,,spacemap(x,y)
            next
        next

        get #f,,lastdrifting
        for a=1 to lastdrifting
            get #f,,drifting(a)
            print ".";
        next

        get #f,,lastportal
        print "Lastportal:"&lastportal
        sleep
        for a=0 to lastportal
            get #f,,portal(a)
        next
        get #f,,_NoPB
        for a=0 to _NoPB
            get #f,,piratebase(a)
        next

        get #f,,lastplanet
        for a=0 to lastplanet
            get #f,,planetmap(0,0,a)

            if planetmap(0,0,a)<>0 then
                for b=0 to 60
                    for c=0 to 20
                        get #f,,planetmap(b,c,a)
                    next
                next
                get #f,,planets(a)
                print ".";
            endif
        next
        for a=0 to lastspecial
            get #f,,specialplanet(a)
            get #f,,specialflag(a)
            print ".";
        next

        for a=272 to 279
            get #f,,tiles(a)
        next

        get #f,,uid
        get #f,,lastitem
        for a=0 to lastitem
            get #f,,item(a)
            print ".";
        next
        'save pirates
        get #f,,reward()
        print ".";

        get #f,,flag()

        print ".";


        get #f,,firstwaypoint
        get #f,,lastwaypoint
        for a=0 to lastwaypoint
            get #f,,targetlist(a)
        next

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

        for c=0 to 12
            for a=0 to 12
                for b=0 to 8
                    get #f,,goods_prices(b,a,c)
                next
            next
        next


        for a=0 to lastquestguy
            get #f,,questguy(a)
        next

        get #f,,foundsomething

        get #f,,civ()
        
        get #f,,battleslost()
                    
        get #f,,lastshop
        for b=1 to lastshop
            get #f,,shoplist(b)
        next
        
        for a=0 to 20
            for b=0 to lastshop
                get #f,,shopitem(a,b)
            next
            print ".";
        next
        
        close f
        if fname<>"savegames/empty.sav" then
            kill(fname)
            if configflag(con_savescumming)=1 then
                f=freefile
                open fname for binary as #f
                put #f,, compressed_data
                close f
            endif
        endif
        player.lastvisit.s=-1
    else
        player.desig=filename
    endif
    cls
    if debug=1 and _debug=1 then
        f=freefile
        open "portals.csv" for output as #f
        for a=0 to lastportal
            print #f,portal(a).from.x &";"&portal(a).from.y &";"&portal(a).from.m &";"& portal(a).dest.x &";"&portal(a).dest.y &";"&portal(a).dest.m &";"&portal(a).oneway
        next
        print #f,player.map
        close #f

    endif

    if debug=2 and _debug=1 then
        f=freefile
        open "items.csv" for output as #f
        for a=0 to lastitem
            if item(a).w.s<0 then print #f,item(a).desig &";"&item(a).w.s &";"& item(a).ty &";"&item(a).uid
        next
        close #f
    endif

    if debug=10 and _debug=1 then
        f=freefile
        open "factions.csv" for output as #f
        for a=0 to 5
            text=""
            for b=0 to 5
                text=text &faction(a).war(b) &";"
            next
            print #f,text
        next
        close #f

    endif
    
    if _debug=1110 then
        f=freefile
        open "Fleetdump.csv" for output as #f
        print #f,_NoPB
        for a=0 to _NoPB
            print #f,piratebase(a)
        next
        for a=0 to lastfleet
            print #f,"Fleet "&fleet(a).ty &":"&cords(fleet(a).c)
            for b=0 to 15
                if fleet(a).mem(b).hull>0 then print #f,fleet(a).mem(b).hull
            next
        next
        close #f
        dprint "Randombase:"&random_pirate_system
    endif
    
    return 0

end function

'Used by savepng
function bswap(byval n as uinteger) as uinteger

    return (n and &h000000ff) shl 24 or _
    (n and &h0000ff00) shl 8  or _
    (n and &h00ff0000) shr 8  or _
    (n and &hff000000) shr 24

end function

'savepng create by counting_pine on the freebasic.net forum
'Works as a drop in replacement for bsave
' usage savepng( filename, picture data, 1 for alpha 0 for no alpha)
function savepng( _
    byref filename as string = "screenshot.png", _
    byval image as any ptr = 0, _
    byval save_alpha as integer = 0) as integer


    dim as uinteger w, h, depth
    dim as integer f = freefile()
    dim as integer e

    if image <> 0 then
        if imageinfo( image, w, h, depth ) < 0 then return -1
        depth *= 8
    else
        if screenptr = 0 then return -1
        screeninfo( w, h, depth )
    end if

    if depth <> 32 then save_alpha = 0

    select case as const depth

    case 1 to 8

        scope

            dim ihdr as struct_ihdr = (bswap(w), bswap(h), 8, 3, 0, 0, 0)
            dim as uinteger ihdr_crc32 = crc32(IHDR_CRC0, cptr(ubyte ptr, @ihdr), sizeof(ihdr))

            dim palsize as uinteger = 1 shl depth
            dim pltesize as uinteger = palsize * 3
            dim plte(0 to 767) as ubyte
            dim plte_crc32 as uinteger

            dim as uinteger l = w + 1
            dim as uinteger imgsize = l * h
            dim as uinteger idatsize = imgsize + 11 + 5 * (imgsize \ 16383)
            dim imgdata(0 to imgsize - 1) as ubyte
            dim idat(0 to idatsize - 1) as ubyte
            dim as uinteger idat_crc32
            dim as uinteger x, y, col, r, g, b
            dim as uinteger index

            index = 0
            for col = 0 to palsize - 1
                palette get col, r, g, b
                plte(index) = r : index += 1
                plte(index) = g : index += 1
                plte(index) = b : index += 1
            next col

            plte_crc32 = crc32(PLTE_CRC0, @plte(0), pltesize)

            index = 0

            if image <> 0 then
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y, image)
                        imgdata(index) = col : index += 1
                    next x
                next y
            else
                screenlock
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y)
                        imgdata(index) = col : index += 1
                    next x
                next y
                screenunlock
            end if

            if compress2(@idat(0), @idatsize, @imgdata(0), imgsize, 9) then return -1
            idat_crc32 = crc32(IDAT_CRC0, @idat(0), idatsize)

            if open (filename for output as #f) then return -1

            e = put( #f, 1, PNG_HEADER )

            e orelse= put( #f, , bswap(IHDR_SIZE) )
            e orelse= put( #f, , "IHDR" )
            e orelse= put( #f, , ihdr )
            e orelse= put( #f, , bswap(ihdr_crc32) )

            e orelse= put( #f, , bswap(pltesize) )
            e orelse= put( #f, , "PLTE" )
            e orelse= put( #f, , plte(0), 3 * (1 shl depth) )
            e orelse= put( #f, , bswap(plte_crc32) )

            e orelse= put( #f, , bswap(idatsize) )
            e orelse= put( #f, , "IDAT" )
            e orelse= put( #f, , idat(0), idatsize )
            e orelse= put( #f, , bswap(idat_crc32) )

            e orelse= put( #f, , bswap(0) )
            e orelse= put( #f, , "IEND" )
            e orelse= put( #f, , bswap(IEND_CRC0) )

            close #f

            return e

        end scope

    case 9 to 32

        scope

            dim ihdr as struct_ihdr = (bswap(w), bswap(h), 8, iif( save_alpha, 6, 2), 0, 0, 0)
            dim as uinteger ihdr_crc32 = crc32(IHDR_CRC0, cptr(ubyte ptr, @ihdr), sizeof(ihdr))

            dim as uinteger l = iif(save_alpha, (w * 4) + 1, (w * 3) + 1)
            dim as uinteger imgsize = l * h
            dim as uinteger idatsize = imgsize + 11 + 5 * (imgsize \ 16383)
            dim imgdata(0 to imgsize - 1) as ubyte
            dim idat(0 to idatsize - 1) as ubyte
            dim as uinteger idat_crc32
            dim as uinteger x, y, col, r, g, b, a
            dim as uinteger index
            dim as integer ret

            index = 0

            if image <> 0 then
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y, image)
                        r = col shr 16 and 255
                        g = col shr 8 and 255
                        b = col and 255
                        imgdata(index) = r : index += 1
                        imgdata(index) = g : index += 1
                        imgdata(index) = b : index += 1
                        if save_alpha then
                            a = col shr 24
                            imgdata(index) = a : index += 1
                        end if
                    next x
                next y
            else
                screenlock
                for y = 0 to h - 1
                    imgdata(index) = 0 : index += 1
                    for x = 0 to w - 1
                        col = point(x, y)
                        r = col shr 16 and 255
                        g = col shr 8 and 255
                        b = col and 255
                        imgdata(index) = r : index += 1
                        imgdata(index) = g : index += 1
                        imgdata(index) = b : index += 1
                        if save_alpha then
                            a = col shr 24
                            imgdata(index) = a : index += 1
                        end if
                    next x
                next y
                screenunlock
            end if

            if compress2(@idat(0), @idatsize, @imgdata(0), imgsize, 9) then return -1
            idat_crc32 = crc32(IDAT_CRC0, @idat(0), idatsize)

            if open (filename for output as #f) then return -1

            e = put( #f, 1, PNG_HEADER )

            e orelse= put( #f, , bswap(IHDR_SIZE) )
            e orelse= put( #f, , "IHDR" )
            e orelse= put( #f, , ihdr )
            e orelse= put( #f, , bswap(ihdr_crc32) )

            e orelse= put( #f, , bswap(idatsize) )
            e orelse= put( #f, , "IDAT" )
            e orelse= put( #f, , idat(0), idatsize )
            e orelse= put( #f, , bswap(idat_crc32) )

            e orelse= put( #f, , bswap(0) )
            e orelse= put( #f, , "IEND" )
            e orelse= put( #f, , bswap(IEND_CRC0) )

            close #f

            return e

        end scope

    case else

        return -1

    end select

end function
