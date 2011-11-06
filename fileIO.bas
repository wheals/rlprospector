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

function gethullspecs(t as short,file as string) as _ship
    dim as short f,a,b
    dim as string word(11)
    dim as string l
    dim as _ship n
    f=freefile
    open file for input as #f
    line input #f,l
    for a=1 to t
        line input #f,l
    next
    close #f
    for a=1 to len(l)
        if mid(l,a,1)=";" then
            if b<11 then b+=1
        else
            word(b)=word(b)&mid(l,a,1)
        endif
    next
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
    n.h_desc=word(11)
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
        c=menu(men,des)
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

    

function checkfilestructure() as short    
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
    
    if not fileexists("savegames/empty.sav") then
        player.desig="empty"
        savegame()
    endif
    return 0
end function


function loadsounds() as short
    #ifdef _windows
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
    return 0
end function

function keybindings() as short
    dim as short f,a,b,d,x,y,c,ls,lk,cl(99),colflag(99),lastcom,changed,fg,bg,o
    dim as _cords cc,ncc
    dim as string keys(99),nkeys(99),varn(99),expl(99),coml(99),comn(99),comdes(99),text,newkey,text2
    f=freefile
    open "keybindings.txt" for input as #f
    while not eof(f)
        ls+=1
        line input #f,text2
        if left(text2,1)<>"#" and len(text2)>0 then                            
            a+=1
            lk+=1
            text=text2
            keys(a)=loadkey(text2)
            nkeys(a)=keys(a)
            varn(a)=left(text,len(text)-len(keys(a))-1)
            expl(a)=right(varn(a),len(varn(a))-4)
            expl(a)=Ucase(left(expl(a),1))&right(expl(a),len(expl(a))-1)
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

       a+=1
       coml(a)=left(text2,instr(text2,";")-1) &" = "
       comdes(a)=right(text2,len(text2)-instr(text2,";"))
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
        b=0
        color 11,0
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
        color 15,0
        draw string ((_screenx-12*_fw2)/2,1*_fh2),"Keybindings:",,FONT2,custom,@_col
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
                        color 15,0
                        if ucase(trim(varn(b)))=ucase(trim(coml(d))) then draw string (5*_fw2,26*_fh2), comdes(d),,FONT2,custom,@_col
                    next
                else
                    fg=11
                    bg=0
                endif
                if colflag(b)=1 then fg=14
                color fg,bg
                
                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),space(25),,FONT2,custom,@_col
                draw string ((2*_fw2)+(x-1)*25*_fw2,(y+2)*_fh2),expl(b) &nkeys(b),,FONT2,custom,@_col
                endif
            next
        next
        color 11,0
        draw string (5*_fw2,25*_fh2),"\C=Control Yellow: 2 commands bound to same key.",,FONT2,custom,@_col
        for b=1 to 8
            color 11,0
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
        color 15,0
        draw string (3*_fw2,4*_fh2),"\|/",,FONT2,custom,@_col
        draw string (3*_fw2,5*_fh2),"- -",,FONT2,custom,@_col
        draw string (3*_fw2,6*_fh2),"/|\",,FONT2,custom,@_col
        color 11,0
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
        
        if no_key=key_enter and keys(c)<>"" then
            screenset 1,1
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),space(25),,FONT2,custom,@_col
            draw string ((2*_fw2)+(cc.x-1)*25*_fw2,(cc.y+2)*_fh2),expl(c),,FONT2,custom,@_col
            newkey=trim(gettext(((_screenx-75*_fw2)/2)/_fw2+(cc.x-1)*25+len(expl(c)),cc.y+2,3,""))
            if newkey<>"" and newkey<>nkeys(c) then
                nkeys(c)=newkey
            endif
        endif
    loop until no_key=key_esc
    
    for a=1 to lk
        if keys(a)<>nkeys(a) then 
            changed=1
        endif
    next
    
    if changed=1 then
        if askyn("Do you want to save changes(y/n)?") then
            
            f=freefile
            open "keybindings.txt" for output as #f
            lastcom=1
            b=1
            for a=1 to lk
                print #f,varn(a)&" "&nkeys(a)
            next
            close #f
            loadkeyset
        endif
    endif
    return 0
end function


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


function loadfonts() as short
    dim as short a,debug,f
    debug=0
    if debug=1 then
        f=freefile
        open "fontlog.txt" for append as #f
    endif
    if _lines<25 then _lines=25
    if _tiles=0 then 
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
    if _tiles=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif
    if _screeny<>_lines*_fh1 then _screeny=_lines*_fh1
    _textlines=fix((22*_fh1)/_fh2)+fix((_screeny-_fh1*22)/_fh2)-1
    _screenx=_mwx*_fw1+25*_fw2
    screenres _screenx,_screeny,8,2,GFX_WINDOWED
    if debug=1 then print #f,"Made screen"
    Print "Loading Fonts"
    if _customfonts=1 then
        print "loading font 1"
        font1=load_font(""&_fohi1,_FH1)
        if debug=1 then print #f,"Loaded Font 1"
        print "loading font 2"
        font2=load_font(""&_fohi2,_FH2)
        if debug=1 then print #f,"Loaded Font 2"
    else 
        Font1 = ImageCreate((254-1) * 8, 17)
        dim as ubyte ptr p
        ImageInfo( Font1, , , , , p )
        p[0] = 0
        p[1] = 1
        p[2] = 254
        
        For a = 1 To 254
            p[3 + a - 1] = 8
            Draw String Font1, ((a - 1) * 8, 1), Chr(a), 1
        Next 
        font2=font1
        _fh1=16
        _fh2=16
    endif
    
    _FW1=_FH1/2+2
    _FW2=_FH2/2+2
    #ifdef _windows
    _FW1=gfx.font.gettextwidth(FONT1,"W")
    _FW2=gfx.font.gettextwidth(FONT2,"W")
    #endif
    if _tiles=0 then
        _Fw1=_tix
        _Fh1=_tiy
    endif    
    if _screeny<>_lines*_fh1 then _screeny=_lines*_fh1
    _textlines=fix((22*_fh1)/_fh2)+fix((_screeny-_fh1*22)/_fh2)-1
    _screenx=_mwx*_fw1+25*_fw2
    screenres _screenx,_screeny,8,2,GFX_WINDOWED
    
    if debug=1 then 
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
    img=ImageCreate(imgwidth,imgheight) 'Zwischenpuffer für bmp
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
        Put font,(0,1),img,(0,0)-(imgwidth-1,imgheight-1),PSet	'Twischenpuffer in Font kopieren
      End If
      ImageDestroy (img)	'Zwischenpuffer löschen
    else
        color 14,0
        print "Loading font graphics/"&fontdir &"font.bmp failed."
        sleep 600
    endif
    return font
end function

function load_tiles() as short
    dim as short x,y,a,n,sx,sy,showtiles
    showtiles=0
    for a=0 to 4096
        gt_no(a)=2048
    next
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
    
    
    n=800
    cls
    bload "graphics/critters2.bmp"
    for y=0 to _tiy*10 step _tiy
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
    n=2001
    cls
    bload "graphics/items.bmp"
    for y=0 to _tiy*5 step _tiy
        for x=0 to _tix*19 step _tix
            gtiles(a)=imagecreate(_tix,_tiy)
            get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(a)
            gt_no(n)=a
            a+=1 
            n+=1 
        next
    next
    
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
    
    bload "graphics/missing.bmp"
    gtiles(2048)=imagecreate(_tix,_tiy)
    get (x,y)-(x+_tix-1,y+_tiy-1),gtiles(2048)
    cls
    print "loaded "& a &" sprites."
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
    cls
    Dim As Integer filenum, bmpwidth, bmpheight,x,y
    Dim As Any Ptr img
    dim as any ptr dst
    fn="graphics/"&fn
    '' open BMP file
    filenum = FreeFile()
    If Open( fn For Binary Access Read As #filenum ) <> 0 Then Return 0

        '' retrieve BMP dimensions
        Get #filenum, 19, bmpwidth
        Get #filenum, 23, bmpheight

    Close #filenum
    '' create image with BMP dimensions
    img = ImageCreate( bmpwidth, Abs(bmpheight) )

    If img = 0 Then Return 0
    'dst=imagecreate(_screenx,_screeny)
    '' load BMP file into image buffer
    BLoad( fn, img )
    x=(_screenx-bmpwidth)/2    
    y=(_screeny-bmpheight)/2
    put (x,y),img
    imagedestroy( img )
    
    Return 0
    
end function

function loadkeyset() as short
    dim as short f,a,b,c,i,j,li
    dim as string text,lctext
    dim keys(256) as string
    dim texts(256) as string
    f=freefile
    if fileexists("keybindings.txt") then
        
        open "keybindings.txt" for input as #f
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
                if instr(lctext,"key_nw")>0 then key_nw=loadkey(text)
                if instr(lctext,"key_north")>0 then key_north=loadkey(text)
                if instr(lctext,"key_ne")>0 then key_ne=loadkey(text)
                if instr(lctext,"key_west")>0 then key_west=loadkey(text)
                if instr(lctext,"key_east")>0 then key_east=loadkey(text)
                if instr(lctext,"key_sw")>0 then key_sw=loadkey(text)
                if instr(lctext,"key_south")>0 then key_south=loadkey(text)
                if instr(lctext,"key_se")>0 then key_se=loadkey(text)
                if instr(lctext,"key_wait")>0 then key_wait=loadkey(text)
                if instr(lctext,"key_portal")>0 then key_portal=loadkey(text)
                
                if instr(lctext,"key_manual")>0 then key_manual=loadkey(text)
                if instr(lctext,"key_messages")>0 then key_messages=loadkey(text)
                if instr(lctext,"key_screenshot")>0 then key_screenshot=loadkey(text)
                if instr(lctext,"key_configuration")>0 then key_configuration=loadkey(text)
                if instr(lctext,"key_autopickup")>0 then key_autopickup=loadkey(text)
                if instr(lctext,"key_autoinspect")>0 then key_autoinspect=loadkey(text)
                if instr(lctext,"key_shipstatus")>0 then key_shipstatus=loadkey(text)
                if instr(lctext,"key_save")>0 then key_save=loadkey(text)
                if instr(lctext,"key_quit")>0 then key_quit=loadkey(text)
                if instr(lctext,"key_tactics")>0 then key_tactics=loadkey(text)
                if instr(lctext,"key_filter")>0 then key_filter=loadkey(text)
                if instr(lctext,"key_comment")>0 then key_comment=loadkey(text)
                if instr(lctext,"key_awayteam")>0 then key_awayteam=loadkey(text)
                if instr(lctext,"key_logbook")>0 then key_logbook=loadkey(text)
                if instr(lctext,"key_equipment")>0 then key_equipment=loadkey(text)
                if instr(lctext,"key_quest")>0 then key_quests=loadkey(text)
                if instr(lctext,"key_tow")>0 then key_tow=loadkey(text)
                
                if instr(lctext,"key_landing")>0 then key_la=loadkey(text)
                if instr(lctext,"key_scanning")>0 then key_sc=loadkey(text)
                if instr(lctext,"key_comment")>0 then key_comment=loadkey(text)
                if instr(lctext,"key_rename")>0 then key_rename=loadkey(text)
                if instr(lctext,"key_targetlanding")>0 then key_tala=loadkey(text)
                if instr(lctext,"key_launchprobe")>0 then key_probe=loadkey(text)
                if instr(lctext,"key_togglehpdisplay")>0 then key_togglehpdisplay=loadkey(text)
                
                if instr(lctext,"key_pickup")>0 then key_pickup=loadkey(text)
                if instr(lctext,"key_dropitem")>0 then key_drop=loadkey(text)
                if instr(lctext,"key_inspect")>0 then key_i=loadkey(text)
                if instr(lctext,"key_examine")>0 then key_ex=loadkey(text)
                if instr(lctext,"key_radio")>0 then key_ra=loadkey(text)
                if instr(lctext,"key_teleport")>0 then key_te=loadkey(text)
                if instr(lctext,"key_jump")>0 then key_ju=loadkey(text)
                if instr(lctext,"key_communicate")>0 then key_co=loadkey(text)
                if instr(lctext,"key_offer")>0 then key_of=loadkey(text)
                if instr(lctext,"key_grenade")>0 then key_gr=loadkey(text)
                if instr(lctext,"key_fire")>0 then key_fi=loadkey(text)
                if instr(lctext,"key_autofire")>0 then key_autofire=loadkey(text)
                if instr(lctext,"key_walk")>0 then key_walk=loadkey(text)
                if instr(lctext,"key_heal")>0 then key_he=loadkey(text)
                if instr(lctext,"key_oxygen")>0 then key_oxy=loadkey(text)
                if instr(lctext,"key_close")>0 then key_close=loadkey(text)
                
                if instr(lctext,"key_dropshield")>0 then key_sh=loadkey(text)
                if instr(lctext,"key_activatesensors")>0 then key_ac=loadkey(text)
                if instr(lctext,"key_run")>0 then key_ru=loadkey(text)
                if instr(lctext,"key_dropmine")>0 then key_dr=loadkey(text)
                if instr(lctext,"key_togglemanjets")>0 then key_togglemanjets=loadkey(text)
                if instr(lctext,"key_yes")>0 then key_yes=loadkey(text)
                if instr(lctext,"key_extendedkey")>0 then key_extended=loadkey(text)

            endif
        next
    else
        color 14,0
        print "File keybindings.txt not found. Using default keys"
        color 15,0
        Sleep 1500
        return 1
    endif
    return 0
end function

function loadkey(byval t2 as string) as string
    dim as short l,i,s
    dim as string t
    t=t2
    l=len(t)
    s=instr(t,"=")
    t=right(t,l-s-1)
    return trim(t)
end function

function numfromstr(t as string) as short
    dim as short a
    dim as string t2
    for a=1 to len(t) 
        if val(mid(t,a,1))<>0 or (mid(t,a,1))="0" then t2=t2 &mid(t,a,1)
    next
    return val(t2)
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
    debug=0
    for a=1 to len(s)
        if mid(s,a,1)=break then
            if debug=1 then dprint word(i)
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
                if instr(text,"_tix")>0 then _tix=numfromstr(text)
                if instr(text,"_tiy")>0 then _tiy=numfromstr(text)
                if instr(text,"gtmwx")>0 then gt_mwx=numfromstr(text)
                if instr(text,"tilefont")>0 then _FoHi1=numfromstr(text)
                if instr(text,"textfont")>0 then _FoHi2=numfromstr(text)
                if instr(text,"lines")>0 then _lines=numfromstr(text)
                if instr(text,"shipcolor")>0 then _shipcolor=numfromstr(text)
                if instr(text,"teamcolor")>0 then _teamcolor=numfromstr(text)
                
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
                if instr(text,"altnum")>0 then
                    if instr(text,"0")>0 then _altnumber=0
                    if instr(text,"1")>0 then _altnumber=1
                endif
                if instr(text,"showvis")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _showvis=0
                    if instr(text,"1")>0 or instr(text,"of") then _showvis=1
                endif
                
                if instr(text,"onbar")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _onbar=0
                    if instr(text,"1")>0 or instr(text,"of") then _onbar=1
                endif
                
                if instr(text,"classic")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _customfonts=0
                    if instr(text,"1")>0 or instr(text,"of") then _customfonts=1
                endif
                
                if instr(text,"transitem")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _transitems=0
                    if instr(text,"1")>0 or instr(text,"of") then _transitems=1
                endif
                
                if instr(text,"savescumming")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _savescumming=0
                    if instr(text,"1")>0 or instr(text,"of") then _savescumming=1
                endif
                
                if instr(text,"warningdam")>0 then
                    if instr(text,"0")>0 or instr(text,"on") then _damscream=0
                    if instr(text,"1")>0 or instr(text,"of") then _damscream=1
                endif
            endif                
        loop until eof(f)
        close #f
    else
        dprint "No Config.txt. Using default configuration"
    endif
    if _tiles=0 then
        _mwx=gt_mwx
    else
        _mwx=60
    endif
    return 0
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
    dim res as string
    dim as short c,d,f
    dim oldtiles as byte
    oldtiles=_tiles
    onoff(0)=" On "
    onoff(1)=" Off"
    warn(0)="On  "
    warn(1)="Off "
    warn(2)="High"
    offon(0)=" Off"
    offon(1)=" On "
    screenshot(1)
    do
        if _customfonts=1 then
            res="tiles:"&_fohi1 &" text:"& _fohi2 &" lines:"&_lines
        else
            res="classic"
        endif
        text="Prospector "&__VERSION__ &" Configuration/ Autopickup :"& onoff(_autopickup)
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
        text=text &"/ Graphic tiles:" & onoff(oldtiles)
        text=text &"/ Easy start:" & onoff(_easy)
        text=text &"/ Volume (0-4):" & _volume
        text=text &"/ Resolution: "&res
        text=text &"/ Underlay for visible tiles: "& onoff(_showvis)
        text=text &"/ Starmap on bar: "& onoff(_onbar)
        text=text &"/ Alternative Numberinput: "& onoff(_altnumber)
        text=text &"/ Transparent Items: "& onoff(_transitems)
        text=text &"/ Main window width(tile mode): "& gt_mwx
        text=text &"/ Savescumming: "& onoff(_savescumming)
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
            select case oldtiles
            case is=1
                oldtiles=0
            case is=0
                oldtiles=1
            end select
            dprint "Change will have effect after restart of the game."
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
            dprint "Select volume (0-4)"
            _volume=getnumber(0,4,_volume)                        
            #ifdef _windows
            IF _volume = 0 THEN FSOUND_SetSFXMasterVolume(0)
            IF _volume = 1 THEN FSOUND_SetSFXMasterVolume(63)
            IF _volume = 2 THEN FSOUND_SetSFXMasterVolume(128)
            IF _volume = 3 THEN FSOUND_SetSFXMasterVolume(190)
            IF _volume = 4 THEN FSOUND_SetSFXMasterVolume(255)
            #endif
        endif
        
        if c=16 then
            d=menu("Resolution/Tiles/Text/Lines/Classic look: "& onoff(_customfonts)&" (overrides if on)/Exit")
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
                select case _customfonts
                case is=1
                    _customfonts=0
                case is=0
                    _customfonts=1
                end select
            endif
            if _fohi2>_fohi1 then _fohi2=_fohi1
            dprint "Resolution will be changed next time you start prospector."
        endif
        
        if c=17 then
            select case _showvis
            case is=1
                _showvis=0
            case is=0
                _showvis=1
            end select
        endif
        if c=18 then 
            
            select case _onbar
            case is=1
                _onbar=0
            case is=0
                _onbar=1
            end select
        endif
        
        if c=19 then 
            
            select case _altnumber
            case is=1
                _altnumber=0
            case is=0
                _altnumber=1
            end select
        endif
        
        if c=20 then 
            
            select case _transitems
            case is=1
                _transitems=0
            case is=0
                _transitems=1
            end select
        endif
        if c=21 then
            gt_mwx=getnumber(20,60,30)
            dprint "Will be changed next time you start prospector."
        endif
        if c=22 then
            
            select case _savescumming
            case is=1
                _savescumming=0
            case is=0
                _savescumming=1
            end select
        endif
    loop until c=23
    
    screenshot(2)
    saveconfig(oldtiles)
    return 0
end function

function saveconfig(oldtiles as short) as short
    dim f as short
    f=freefile
    open "config.txt" for output as #f
    print #f,"# 0 is on, 1 is off"
    print #f,""
    print #f,"_tix:"&_tix
    print #f,"_tiy:"&_tiy
    print #f,"gtmwx:"&gt_mwx
    print #f,"tilefont:"&_FoHi1
    print #f,"textfont:"&_FoHi2
    print #f,"lines:"&_lines
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
    print #f,"tiles:"& oldtiles
    print #f,"easy:"&_easy
    print #f,"volume:"&_volume
    print #f,"altnum:"&_altnumber
    print #f,"showvis:"&_showvis
    print #f,"onbar:"&_onbar
    print #f,"classic:"&_customfonts
    print #f,"transitem:"&_transitems
    print #f,"savescumming:"&_savescumming
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
    c=menu(text,,_mwx-15,10)
    filename=n(c-1)
    return filename    
end function

function savebones(ship as _cords,team as _cords,t as short) as short
    dim f as integer
    dim as short x,y,a,b
    dim bones_item(128) as _items
    if _debug_bones=1 then dprint "Saving bones file"
    if is_special(ship.m) then return 0
    if is_drifter(ship.m) then return 0
    if planets(ship.m).depth=0 then planetmap(ship.x,ship.y,ship.m)=127+player.h_no
    f=freefile
    open "bones/"&player.desig &".bon" for binary as #f
    put #f,,planets(ship.m)
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,ship.m)>0 then planetmap(x,y,ship.m)=-planetmap(x,y,ship.m)
            put #f,,planetmap(x,y,ship.m)
        next
    next
    
    for a=0 to lastitem
        if item(a).w.s=-1 and rnd_range(1,100)<50 then
            b+=1
            item(a).w.s=0
            item(a).w.p=0
            item(a).w.x=team.x
            item(a).w.y=team.y
            if b<=128 then bones_item(b)=item(a)
        endif
    next
    b+=1
    if b>128 then b=128
    bones_item(b)=makeitem(81)
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

function loadbones() as short
    dim s as string
    dim as short d,c,m,f,sys
    dim as _cords p
    dim as _planet pl
    s=getbonesfile
    if _debug_bones=1 then dprint "loading bones file:" &s
    if s<>"" then
        f=freefile
        open "bones/"&s for binary as #f
        get #f,,pl
        if pl.depth=0 then 
            do
                sys=getrandomsystem
                m=getrandomplanet(sys)
            loop until m>0 and isgasgiant(m)=0 and is_special(m)=0
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            map(sys).discovered=4                
        else
            sys=rnd_range(1,lastportal)
            m=portal(sys).dest.m
            for x=0 to 60
                for y=0 to 20
                    get #f,,planetmap(x,y,m)
                    if _debug_bones=1 then planetmap(x,y,m)=-planetmap(x,y,m)
                next
            next
            p=rnd_point(m,0)
            portal(sys).dest.x=p.x
            portal(sys).dest.y=p.y
            map(sysfrommap(portal(sys).from.m)).discovered=4
        endif
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
        planets(m).flavortext="You get a wierd sense of deja vu from this place."
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
    if _debug_bones=2 then print "chance for bones file:"&chance
    d=dir$("bones/*.bon")
    do
        if (rnd_range(1,100)<chance or _debug_bones=1) and s="" then s=d
        d=dir()
    loop until d=""
    if _debug_bones=1 then dprint s
    return s
end function

function savegame() as short
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim desig as string*36
    dim names as string*36
    dim cl as string
    cl=player.h_sdesc
    names=player.desig
    desig="("&cl &", "&player.money &"Cr T:" &player.turn &")"
    
    cls
    back=99
    f=freefile
    fname="savegames/"&player.desig &".sav"
    
    print "Saving "&fname;
    open fname for binary as #f
    print ".";
    'save shortinfo
    put #f,,names
    put #f,,desig
    
    'save player
    put #f,,player
    put #f,,whtravelled
    put #f,,whplanet
    put #f,,ano_money
    put #f,,_autopickup
    put #f,,_autoinspect
    for a=1 to 128
        put #f,,crew(a)
    next
    
    for a=0 to 7
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
    
    for a=0 to 2
        put #f,,shop_order(a)
    next
    
    for a=0 to 20
        for b=0 to 21
            put #f,,shopitem(a,b)
        next
        print ".";
    next
    for a=0 to 5
        for b=0 to 20
            put #f,,makew(b,a)
        next
    next
    
    for x=0 to sm_x
        for y=0 to sm_y
            put #f,,spacemap(x,y)
        next
    next
    
    put #f,,lastdrifting
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
        put #f,,pirateplanet(a)
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
    for a=0 to 9
        put #f,,reward(a)
    next
    print ".";
    
    for a=0 to 20
        put #f,,flag(a)
    next
    
    for a=0 to 20
        put #f,,artflag(a)
    next
    print ".";
    
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
    close f
    
    color 14,0
    cls
    return back
end function


function loadgame(filename as string) as short
    dim from as short
    dim ship as _cords
    dim awayteam as _monster
    dim back as short
    dim a as short
    dim b as short
    dim c as short
    dim fname as string
    dim f as integer
    dim dat as string*36
    dim names as string*36
    dim text as string
    dim p as _planet
    dim debug as byte
    for a=0 to max_maps
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
        planets(a)=p
    next
    
    
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
        get #f,,whtravelled
        get #f,,whplanet
        get #f,,ano_money
        get #f,,_autopickup
        get #f,,_autoinspect
        for a=1 to 128
            get #f,,crew(a)
        next
        
        for a=0 to 7
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
                next
            endif
            get #f,,savefrom(a).ship
            get #f,,savefrom(a).map
            print ".";
        next
        get #f,,wormhole
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
                    
        for a=0 to 2
            Get #f,,shop_order(a)
        next
        
                    
        for a=0 to 20
            for b=0 to 21
                get #f,,shopitem(a,b)
            next
            print ".";
        next
        for a=0 to 5
            for b=0 to 20
                get #f,,makew(b,a)
            next
        next
        
                                        
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
        for a=0 to lastportal
            get #f,,portal(a)
        next
        get #f,,_NoPB
        for a=0 to _NoPB
            get #f,,pirateplanet(a)
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
        for a=0 to 9
            get #f,,reward(a)
            print ".";
        next
        
        for a=0 to 20
            get #f,,flag(a)
        next
        
        for a=0 to 20
            get #f,,artflag(a)
        next
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
        
        close f
        if fname<>"savegames/empty.sav" and _savescumming=1 then kill(fname)
        player.lastvisit.s=-1
    else 
        player.desig=filename
    endif
    cls
    if debug=1 then
        f=freefile
        open "portals.csv" for output as #f
        for a=0 to lastportal
            print #f,portal(a).from.x &";"&portal(a).from.y &";"&portal(a).from.m &";"& portal(a).dest.x &";"&portal(a).dest.y &";"&portal(a).dest.m &";"&portal(a).oneway
        next
        print #f,player.map
        close #f
        
    endif
    
    if debug=10 then
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
    
    
    
    return 0
    
end function
