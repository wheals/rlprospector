
'Master debug switch: Do not touch!
const _debug=0'1211'154'2809'2709

#macro draw_string(ds_x,ds_y,ds_text,ds_font,ds_col)
draw string(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
#endmacro
#IFDEF _FMODSOUND
#inclib "fmod.dll"
#include once "fmod.bi"
#ENDIF

#ifdef _FBSOUND
#include "fbsound.bi"
#endif
#include once "fbgfx.bi"
#include once "zlib.bi"
#include once "file.bi"
#include "cardobj.bi"
#include "string.bi"
#include once "types.bas"

#include once "tiles.bas"
'f=freefile
'open "data/tiles.dat" for binary as #f
'get #f,,tiles()
'close #f
#include once "credits.bas"
#include once "retirement.bas"
#include once "math.bas"
#include once "astar.bas"
#include once "logbook2.bas"
#include once "pirates.bas"
#include once "planet.bas"
#include once "items.bas"
#include once "ProsIO.bas"
#include once "highscore.bas"
#include once "cargotrade.bas"
'#include once "colonies.bas"
#include once "quests.bas"
#include once "spacecom.bas"
#include once "fileIO.bas"
#include once "exploreplanet.bas"
#include once "texts.bas"
#include once "crew.bas"
#include once "space.bas"
#include once "kbinput.bas"
#include once "globals.bas"
#include once "compcolon.bas"
#include once "poker.bas"

on error goto errormessage

screenres 640,320,32
cls
' Load
print
print "Prospector "&__VERSION__
print
check_filestructure
load_config
load_fonts
if configflag(con_tiles)=0 or configflag(con_sysmaptiles)=0 then load_tiles
cls
load_keyset
load_sounds
load_palette()

if not fileexists("register") then
    cls
    if askyn("This is the first time you start prospector. Do you want to see the keybindings before you start?(Y/N)") then
       keybindings
    endif
    cls
    f=freefile
    open "register" for output as f
    print #f,"0"
    print #f,""
    if menu(bg_randompic,"Autonaming:/Standard/Babylon 5 Shipnames")=2 then
        print #f,"b5shipnames.txt"
    endif

    close #f
    set__color(11,0)
    

endif





do
    setglobals
    do
        titlemenu
        key=keyin("1234567abcdefght",3)
        if key="1" or key="a" then
            if count_savegames()>20 then
                key=""
                dprint "Too many Savegames, choose one to overwrite",14
                text=getfilename()
                if text<>"" then
                    if askyn("Are you sure you want to delete "&text &"(y/n)") then
                        kill("savegames/"&text)
                        key="1"
                    endif
                endif
            endif
        endif
        if key="2" or key="b" then key=from_savegame(key)
        if key="3" or key="c" then high_score("")
        if key="4" or key="d" then manual
        if key="5" or key="e" then configuration
        if key="6" or key="f" then keybindings
'           if key="8" then
'            dim i as _items
'            f=freefile
'            open "items.csv" for output as #f
'            for a=0 to 302
'                i=makeitem(a)
'                if i.ldesc<>"" or i.desig<>"" then
'                    print #f,a &";"& i.desig
'                endif
'            next
'            close #f
'        endif
'            'dodialog(1,dummy,0)
'            for b=1 to 1000
'                make_spacemap
'                clear_gamestate
'            next
'        endif
        if _debug>0 then
                if key="t" then
                    screenset 1,1
                    bload "graphics\spacestations.bmp"
                    a=getnumber(0,10000,0)
                    put(30,0),gtiles(gt_no(a)),pset
                    no_key=keyin
                    sleep
                endif
                if key="8" then
                    f=freefile
                    open "monster.csv" for output as #f
                    print #f,"name;hp;speed;atcost;biodata"
                    for a=1 to 400
                        enemy(0)=makemonster(a,1)
                        if enemy(0).sdesc<>"" then print #f,enemy(0).sdesc &";"& int(enemy(0).hp)  &";"& enemy(0).speed  &";"& enemy(0).atcost &";"&get_biodata(enemy(0))
                    next
                    close #f
                    f=freefile
                    open "tiles.csv" for output as #f
                    for a=1 to 400
                        if tiles(a).desc<>"" then print #f,a &";"&tiles(a).desc &";"& tiles(a).movecost
                    next
                    close #f
                end if
                if key="9" then
                    cls
                    set__color(15,0)
                    for a=1 to 10
                        reroll_shops
                        print a
                    next
                endif
        endif
    loop until key="1" or key="2" or key="7"  or key="a"  or key="b" or key="g"
    set__color(11,0)
    cls
    if key="1" or key="a" then start_new_game

    if key="1" or key="2" or key="a" or key="b" and player.dead=0 then
        key=""
        gamerunning=1
        display_stars(1)
        display_ship(1)
        explore_space
    endif

    if key="7" or key="g" then end

    if player.dead>0 then death_message()

    set__color( 15,0)
    if configflag(con_restart)=0 then
        load_game("empty.sav")
        clear_gamestate
        gamerunning=0
    endif
loop until configflag(con_restart)=1
#ifdef _FMODSOUND
fSOUND_close
#endif
end

function titlemenu() as short
    dim as short bg
    dim as any ptr logo
    bg=rnd_range(1,_last_title_pic)

    background(bg &".bmp")
    logo=bmp_load("graphics/prospector.bmp")
    if logo<>NULL then
        put (39,69),logo,trans
    else
        draw string(26,26),"PROSPECTOR",,titlefont,custom,@_col
    endif

    set__color( 15,0)
    draw string(_screenx-22*_FW2,_screeny-10*_FH2),__VERSION__,,FONT2,pset
    draw_string(_screenx-22*_FW2,_screeny-9*_FH2,"a) start new game    ",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-8*_FH2,"b) load saved game   ",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-7*_FH2,"c) display highscore ",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-6*_FH2,"d) read documentation",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-5*_FH2,"e) configuration     ",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-4*_FH2,"f) view/change keys  ",FONT2,_col)
    draw_string(_screenx-22*_FW2,_screeny-3*_FH2,"g) exit              ",FONT2,_col)

    return 0
end function

function start_new_game() as short
    dim as string text
    dim as short a,b,c,f,d
    dim doubleitem(4555) as byte
    dim i as _items
    dim debug as byte
    debug=126
    if _debug>0 then
        artflag(25)=1
    endif
    make_spacemap()
    if debug=1 and _debug=1 then
        f=freefile
        open "planettemp.csv" for output as #f
        for a=0 to laststar
            text=map(a).spec &";"
            for b=1 to 9
                text=text &";"
                if map(a).planets(b)>0 and map(a).planets(b)<1024 then
                    makeplanetmap(map(a).planets(b),b,map(a).spec)
                    text=text &planets(map(a).planets(b)).temp
                endif
            next
            print #f,text
            print ".";
        next
        close #f
    endif
    text="/"&makehullbox(1,"data/ships.csv") &"|Comes with 3 Probes MKI/"&makehullbox(2,"data/ships.csv")&"|Comes with 2 combat drones and fully armored|You get one more choice at a talent if you take this ship/"&makehullbox(3,"data/ships.csv") &"|Comes with paid for cargo to collect on delivery/"&makehullbox(4,"data/ships.csv") &"|Comes with 5 veteran security team members/"&makehullbox(6,"data/ships.csv")&"|You will start as a pirate if you choose this option"
    if configflag(con_startrandom)=1 then
        b=menu(bg_randompic,"Choose ship/Scout/Long Range Fighter/Light Transport/Troop Transport/Pirate Cruiser/Random",text)
    else
        b=rnd_range(1,4)
    endif
    player=make_ship(1)
    if b=6 then b=rnd_range(1,4)
    c=b
    if b=5 then c=6
    upgradehull(c,player)
    player.hull=player.h_maxhull
    dprint "Your ship: "&player.h_desig
    d=0
    do
        d+=1
        i=rnd_item(RI_WeakWeapons)
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Weapons and armor
    loop until equipment_value>750 or d>5 'No more than 6 w&as
    d=0
    do
        d+=1
        do
            i=rnd_item(RI_WeakStuff)
        loop until doubleitem(i.id)=0
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Other stuff
    loop until equipment_value>1000 and d>2 'At least 3 other stuffs

    if _debug=707 then
        placeitem(makeitem(48),0,0,0,0,-1)
        placeitem(makeitem(52),0,0,0,0,-1)
        for c=1 to 10
            placeitem(makeitem(24),0,0,0,0,-1)
            placeitem(makeitem(26),0,0,0,0,-1)
        next
    endif

    if b=1 then
        placeitem(makeitem(100),0,0,0,0,-1)
        placeitem(makeitem(100),0,0,0,0,-1)
        placeitem(makeitem(100),0,0,0,0,-1)
        if _debug>0 then placeitem(makeitem(50),,,,,-1)
        if _debug>0 then placeitem(makeitem(50),,,,,-1)
        if _debug>0 then placeitem(makeitem(50),,,,,-1)
        if _debug>0 then placeitem(makeitem(51),,,,,-1)
        if _debug>0 then placeitem(makeitem(51),,,,,-1)
        if _debug>0 then placeitem(makeitem(52),,,,,-1)
        if _debug>0 then placeitem(makeitem(52),,,,,-1)
        if _debug=1 then placeitem(makeitem(65),,,,,-1)
        if _debug=1 then placeitem(makeitem(66),,,,,-1)
        if _debug=1 then placeitem(makeitem(301),,,,,-1)
        if _debug=1 then placeitem(makeitem(105),,,,,-1)
        if _debug=1 then placeitem(makeitem(64),,,,,-1)
        if _debug=1 then placeitem(makeitem(64),,,,,-1)
        if _debug=1 then placeitem(makeitem(64),,,,,-1)
        if _debug=1211 then placeitem(makeitem(30),,,,,-1)
'        placeitem(makeitem(250),0,0,0,0,-1)
'        placeitem(makeitem(162),0,0,0,0,-1)
'        placeitem(makeitem(162),0,0,0,0,-1)
'        placeitem(makeitem(163),0,0,0,0,-1)
        if debugvacuum=1 and _debug=1 then placeitem(makeitem(23),0,0,0,0,-1)
        'player.cargo(1).x=10
'        placeitem(makeitem(52),0,0,0,0,-1)
'        placeitem(makeitem(52),0,0,0,0,-1)
'        placeitem(makeitem(52),0,0,0,0,-1)
'        for a=0 to 1000
'        i=makeitem(96)
'        placeitem(i,0,0,0,0,-1)
'        reward(2)+=i.v1
'        next
        'player.pilot=3
        'placeitem(makeitem(85),0,0,0,0,-1)
        'placeitem(makeitem(85),0,0,0,0,-1)
    endif

    if b=2 then
        player.equipment(se_shipdetection)=1
        placeitem(makeitem(110),0,0,0,0,-1)
        placeitem(makeitem(110),0,0,0,0,-1)
    endif

    if b=3 then
        player.cargo(1).x=11
        player.cargo(2).x=rnd_range(1,3)
        player.cargo(1).y=nearest_base(player.c)
        player.cargo(2).y=rnd_range(1,5)*player.cargo(2).x
    endif


    add_member(1,0)
    add_member(2,1)
    add_member(3,1)
    add_member(4,1)
    add_member(5,1)
    if debug=3 and _debug=1 then player.questflag(22)=1


    if b=4 then
        player.security=5
        for c=6 to 10
            add_member(7,0)
        next
    endif

    player.turn=-500 'To make starting weapons less powerfull

    select case startingweapon
    case 1
        player.weapons(1)=makeweapon(rnd_range(6,7))
    case 2
        player.weapons(1)=makeweapon(rnd_range(1,3))
    case else
        if rnd_range(1,100)<51 then
            player.weapons(1)=makeweapon(rnd_range(6,7))
        else
            player.weapons(1)=makeweapon(rnd_range(1,3))
        endif
    end select
    if b=5 then
        player.weapons(2)=makeweapon(99)
        player.weapons(3)=makeweapon(99)
        pirateupgrade
        recalcshipsbays()
        player.engine=2
        player.hull=10
        faction(0).war(2)=-100
        faction(0).war(1)=100
        player.c=map(piratebase(0)).c
    endif
    player.turn=0
    if start_teleport=1 then artflag(9)=1
    set__color(11,0)
    cls
    set__color( 11,0)

    if b<5 then
        c=2+textbox("An unexplored sector of the galaxy. You are a private Prospector. You can earn money by mapping planets and finding resources. Your goal is to make sure you can live out your life in comfort in your retirement. || But beware of alien lifeforms and pirates. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        faction(0).war(1)=0
        faction(0).war(2)=100
        faction(0).war(3)=0
        faction(0).war(4)=100
        faction(0).war(5)=100
    else
        c=2+textbox("A life of danger and adventure awaits you, harassing the local shipping lanes as a pirate. It won't be easy but if you manage to avoid the company patrols, and get good loot, it will be very profitable! You will be able to spend the rest of your life in luxury. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        faction(0).war(1)=100
        faction(0).war(2)=0
        faction(0).war(3)=100
        faction(0).war(4)=0
        faction(0).war(5)=100
    endif
    faction(1).war(2)=100
    faction(1).war(4)=100
    faction(2).war(1)=100
    faction(2).war(3)=100
    faction(3).war(2)=100
    faction(3).war(4)=100
    faction(4).war(1)=100
    faction(4).war(3)=100

    player.desig=gettext((5*_fw1+44*_fw2),(5*_fh1+c*_fh2),32,"",1)
    if player.desig="" then player.desig=randomname()
    a=freefile
    if open ("savegames/"&player.desig &".sav" for input as a)=0 then
        close a
        do
            draw_string (50,10*_fh2, "That ship is already registered.",font2,_col)
            draw_string(50,9*_fh2, "You christen the beauty:" &space(25),font2,_col)
            player.desig=gettext((5*_fw1+25*_fw2)/_fw2,(5*_fh1+c*_fh2)/_fh2,13,"")
            if player.desig="" then player.desig=randomname()
        loop until fileexists("savegames/"&player.desig &".sav")=0
    endif
    if (debug=3 or debug=99) and _debug=1 then
        fleet(lastfleet+1)=makealienfleet
        fleet(lastfleet+1).c=basis(0).c
        fleet(lastfleet+2)=makealienfleet
        fleet(lastfleet+2).c=basis(1).c
        fleet(lastfleet+3)=makealienfleet
        fleet(lastfleet+3).c=basis(2).c
        dprint "fleettypes"& fleet(lastfleet+1).ty &":" & fleet(lastfleet+2).ty &":"& fleet(lastfleet+3).ty
        lastfleet+=3
    endif
    if (debug=127 and _debug>0) then
        upgradehull(18,player,0)
        player.hull=10
        player.engine=3
        player.sensors=6
        player.shieldmax=5
        player.weapons(1)=makeweapon(66)
        player.weapons(2)=makeweapon(66)
        for a=1 to 45
            add_member(8,0)
            placeitem(makeitem(97),0,0,0,0,-1)
            placeitem(makeitem(98),0,0,0,0,-1)
        next
        player.money+=10000
        artflag(16)=1

    endif

    if debug=126 and _debug>0 then
        upgradehull(9,player,0)
        player.hull=player.h_maxhull
        player.engine=3
        player.sensors=3
        player.shieldmax=2
        player.weapons(1)=makeweapon(4)
        player.weapons(1)=makeweapon(3)
        for a=1 to 15
            add_member(8,0)
            placeitem(rnd_item(RI_WEAPONS),0,0,0,0,-1)
            placeitem(rnd_item(RI_Armor),0,0,0,0,-1)
        next
        player.money+=6000
    endif
    if _debug>0 then player.money=10000000
    if debug=2 and _debug=1 then dprint disnbase(map(sysfrommap(specialplanet(7))).c) &":"& disnbase(map(sysfrommap(specialplanet(46))).c)
    if _debug=1 then player.cursed=1
    just_run=run_until
    if show_specials>0 then
        player.c=map(sysfrommap(specialplanet(show_specials))).c
    endif
    set__color(11,0)
    if debug=125 and _debug>0 then player.money=3000
    cls
    return 0
end function

function from_savegame(key as string) as string
    dim as short c
    c=count_savegames
    set__color(11,0)
    cls
    if c=0 then
        dprint "No Saved Games"
        no_key=keyin 
        key=""
    else
        load_game(getfilename())
        if player.desig="" then key=""
        player.dead=0
        if savefrom(0).map>0 then
            landing(0)
        endif
    endif
    set__color(11,0)
    cls
    return key
end function

function target_landing(mapslot as short,test as short=0) as short
    dim as _cords p
    dim as string key
    dim as short c,osx
    set__color(11,0)
    cls
    screenset 1,1

    dprint "Choose landing site"
    p.x=30
    p.y=10
    key=get_planet_cords(p,mapslot)
    if key=key__enter then
        do
            p=movepoint(p,5)
            c+=1
            player.fuel-=1
        loop until c>5 or (tiles(abs(planetmap(p.x,p.y,mapslot))).gives=0 and tiles(abs(planetmap(p.x,p.y,mapslot))).walktru=0 and skill_test(player.pilot(0),st_easy+c+planets(mapslot).grav+planets(mapslot).dens,"Pilot:"))
        if c<=5 then
            landing(mapslot,p.x,p.y,c)
        else
            dprint "Couldn't land there, landing aborted",14
        endif
    endif
    return 0
end function


function landing(mapslot as short,lx as short=0,ly as short=0,test as short=0) as short
    dim as short l,m,a,b,c,d,dis,alive,dead,roll,target,xx,yy,slot,sys,landingpad,landinggear,who(128),last2,alle
    dim light as single
    dim p as _cords
    dim as short  last,debug
    dim nextmap as _cords
    dim as _monster delaway
    dim as string reason
    awayteam=delaway
    debug=1

    p.x=lx
    p.y=ly
    if lx=0 and ly=0 then p=rnd_point(mapslot,0)
    sys=sysfrommap(mapslot)
    if savefrom(0).map=0 then
        if mapslot=specialplanet(29) and findbest(89,-1)>0 then mapslot=specialplanet(30)
        if mapslot=specialplanet(30) and findbest(89,-1)=-1 then mapslot=specialplanet(29)
        if mapslot=specialplanet(29) then specialflag(30)=1
        if configflag(con_warnings)=0 and player.hull=1 and planets(mapslot).depth=0 then
            if not askyn("Pilot: 'Are you sure captain? I can't guarantee I get this bucket up again'(Y/N)",14) then return 0
        endif
        if _debug=510 then
            dprint sys &","&mapslot
        endif

        if mapslot>0 then
            set__color(11,0)
            cls

            if planetmap(0,0,mapslot)=0 then makeplanetmap(mapslot,slot,map(sys).spec)
            awayteam.hp=0
            for b=1 to 128
                if crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0 and crew(b).disease=0 then
                    awayteam.hp+=1
                    crew(b).hp=crew(b).hpmax
                endif
            next
            'awayteam.hpmax=awayteam.hp
            if player.dead=0 then
                while tiles(abs(planetmap(p.x,p.y,mapslot))).locked<>0 or _
                    tiles(abs(planetmap(p.x,p.y,mapslot))).gives<>0 or _
                    tiles(abs(planetmap(p.x,p.y,mapslot))).walktru<>0 or _
                    abs(planetmap(p.x,p.y,mapslot))=45 or _
                    abs(planetmap(p.x,p.y,mapslot))=80
                    if lx=0 and ly=0 then
                        p=rnd_point(mapslot,0)
                    else
                        p=movepoint(p,5,,4)'4=Rollover
                    endif
                wend

                'if ((mapslot=pirateplanet(0) or mapslot=pirateplanet(1) or mapslot=pirateplanet(2)) and player.pirate_agr<=0) or isgasgiant(mapslot)<>0 then
                    for x=0 to 60
                        for y=0 to 20
                            if planetmap(x,y,mapslot)=68 and last<128 then
                                last+=1
                                pwa(last).x=x
                                pwa(last).y=y
                            endif
                        next
                    next
                    if last>0 then
                        if askyn("Shall we use the landingpad to land?(y/n)") then
                            p=pwa(rnd_range(1,last))
                            landingpad=5
                        endif
                    endif
                'endif
                player.landed.x=p.x
                player.landed.y=p.y
                player.landed.m=mapslot
                nextmap=player.landed
                equip_awayteam(mapslot)
            endif

            last2=no_spacesuit(who(),alle)
            if last2>0 and ep_needs_Spacesuit(mapslot,player.landed,reason)<>0 then
                if alle=0 then
                    if askyn("You will need spacesuits ("& reason &"). Do you want to leave "&last2 &" crewmembers who have none on the ship? (Y/N)") then
                        remove_no_spacesuit(who(),last2)
                    endif
                else
                    if askyn("You need spacesuits on this planet  ("& reason &") and don't have any. Shall we abort landing? (y/n)") then return 0
                endif
            endif
                        
            if findbest(10,-1)>-1 and is_drifter(m)=0 then
                awayteam.stuff(8)=item(findbest(10,-1)).v1 'Sattelite
                dprint "You deploy your satellite."
            endif
            
            roll=landingpad+player.pilot(0)+add_talent(2,8,1)
            landinggear=findbest(41,-1)
            if landinggear>0 and landingpad=0 then roll=roll+item(landinggear).v1
            if _debug=321 then dprint "Density:"&planets(mapslot).dens
            target=planets(mapslot).dens+2*planets(mapslot).grav^2
            if mapslot<>specialplanet(2) and test=0 then
                if skill_test(roll,target,"Pilot") then
                    if landingpad=0 then
                        dprint ("Your pilot succesfully landed in the difficult terrain",10)
                    else
                        dprint ("You landed on the landinpad",10)
                    endif
                    player.fuel=player.fuel-1
                    dprint gainxp(2),c_gre
                else
                    if landingpad=0 then
                        dprint ("your pilot damaged the ship trying to land in difficult terrain.",12)
                    else
                        dprint ("your pilot actually manged to damage the ship while landing on a landing pad!",12)
                    endif
                    player.hull=player.hull-1
                    player.fuel=player.fuel-2-int(planets(mapslot).grav)
                    if player.hull<=0 then
                        dprint ("A Crash landing. you will never be able to start with that thing again",12)
                        if skill_test(player.pilot(0),st_veryhard,"Pilot") then
                            dprint ("but your pilot wants to try anyway and succeeds!",12)
                            player.hull=1
                        else
                            player.dead=4
                        endif
                        no_key=keyin
                    endif
                endif
            endif
        endif
        if isgardenworld(nextmap.m) then changemoral(3,0)
        awayteam.oxygen=awayteam.oxymax
        awayteam.jpfuel=awayteam.jpfuelmax

        else
            awayteam=savefrom(0).awayteam
            nextmap=savefrom(0).ship
            nextmap.m=savefrom(0).map
        endif
        
        #ifdef _FMODSOUND
        if (configflag(con_sound)=0 or configflag(con_sound)=2) and mapslot>0 then FSOUND_PlaySound(FSOUND_FREE, sound(11))
        #endif
        #ifdef _FBSOUND
        if (configflag(con_sound)=0 or configflag(con_sound)=2) and mapslot>0 then fbs_Play_Wave(sound(11))
        #endif
        
        if player.dead=0 and awayteam.hp>0 then
            
            do
                savegame
                if _debug=1 then dprint "nextmap" & nextmap.m &"x:"&nextmap.x &"y:"&nextmap.y
                equip_awayteam(slot)
                nextmap=explore_planet(nextmap,slot)
                set__color(11,0)
                cls
                removeequip

                for b=6 to 128
                    if crew(b).hp<=0 then
                        crew(b)=crew(0)
                    else
                        c+=1
                    endif
                next
                if c>127 then c=127

                for b=6 to c-1
                    if crew(b).hpmax=0 then
                        swap crew(b),crew(b+1)
                    endif
                next

            loop until nextmap.m=-1 or player.dead<>0
            for c=0 to 127
                for b=6 to 127
                    if crew(b).hp<=0 then swap crew(b),crew(b+1)
                next

            next
            for b=0 to 127
                if crew(b).onship=4 then
                    crew(b).onship=crew(b).oldonship
                endif
            next
            removeequip
            'artifacts?
            if reward(5)>0 then
                if reward(5)=1 then
                    player.fuelmax=200
                endif
                if reward(5)=2 then
                    player.stuff(1)=3
                endif
                if reward(5)=3 then
                    slot=get_random_system()
                    if slot<0 then slot=rnd_range(0,laststar)
                    map(slot).discovered=1
                    for b=1 to 9
                        if map(slot).planets(b)>0 then
                        if planetmap(0,0,map(slot).planets(b))=0 then makeplanetmap(map(slot).planets(b),b,map(sys).spec)
                        reward(0)=reward(0)+1200
                        reward(7)=reward(7)+600
                        for xx=0 to 60
                            for yy=0 to 20
                                if planetmap(xx,yy,map(slot).planets(b))<0 then planetmap(xx,yy,map(slot).planets(b))=planetmap(xx,yy,map(slot).planets(b))*-1
                            next
                        next
                        endif
                    next
                    dprint "the data from the computer describes a system with the coordinates "& map(slot).c.x &":" & map(slot).c.y
                endif
                if reward(5)=4 then
                    player.stuff(2)=3
                endif
                if reward(5)=5 then
                    player.stuff(0)=3
                endif
                reward(5)=0

            endif
        endif
        c=6
        dis=0
        if crew(1).hp<=0 and player.dead=0 then
            crew(1).hp=crew(1).hpmax
            b=rnd_range(1,3)
            if b=1 then dprint "Captain "&crew(1).n &" was just unconcious.",10
            if b=2 then dprint "Captain "&crew(1).n &" got better.",10
            if b=3 then dprint "Captain "&crew(1).n &" miracoulously recovered.",10
        endif
        for b=1 to 128
            if crew(b).hp<crew(b).hpmax and crew(b).hp>0 and crew(b).disease=0 then crew(b).hp=crew(b).hpmax
        next
        for b=6 to 128
            if crew(b).hp<=0 then
                crew(b)=crew(0)
            else
                if crew(b).disease>dis then dis=crew(b).disease
                c+=1
            endif
        next
        awayteam.disease=dis
        d=0
        do
            d+=1
            a=0
            for b=6 to c-1
                if crew(b).hpmax=0 and crew(b+1).hpmax>0 then
                    swap crew(b),crew(b+1)
                    a=1
                endif
            next
        loop until a=0 or d>=1000
        for b=0 to lastitem
            if item(b).w.s<0 then
                item(b).w.s=-1
                item(b).w.m=0
                item(b).w.p=0
            endif
        next
        player.landed.m=0
        display_stars(1)
        display_ship
        if awayteam.stuff(8)=1 and player.dead=0 and test=0 and planets(slot).depth=0 then
            if skill_test(player.pilot(0)+player.tractor,st_easy,"Pilot:") then
                dprint "You rendevouz with your satellite and take it back in",10
            else
                dprint "When trying to rendevouz with your satellite your pilot rams and destroys it.",12
                item(findbest(10,-1))=item(lastitem)
                lastitem=lastitem-1
                no_key=keyin
            endif
        else
            dprint ""
        endif
    return 0
end function

function scanning() as short
    dim mapslot as short
    dim as short slot
    dim sys as short
    dim scanned as short
    dim itemfound as short
    dim a as short
    dim b as short
    dim x as short
    dim y as short
    dim key as string
    dim as short osx
    dim as single roll,target
    dim debug as byte
    dim as short plife,li(255),lastlocalitem
    debug=1
    'if getsystem(player)>0 then
    a=getplanet(get_system())
    slot=a
    update_tmap(slot)
    if a>0 then
        sys=get_system()
        mapslot=map(sys).planets(a)
        if mapslot=specialplanet(29) and findbest(89,-1)>0 then mapslot=specialplanet(30)
        if mapslot=specialplanet(30) and findbest(89,-1)=-1 then mapslot=specialplanet(29)
        if mapslot=specialplanet(29) then specialflag(30)=1
        if mapslot<0 and mapslot>-20000 then map(sys).planets(a)=asteroid_mining(mapslot)
        if mapslot=-20001 then dprint "A helium-hydrogen gas giant"
        if mapslot=-20002 then dprint "A methane-ammonia gas giant"
        if mapslot=-20003 then dprint "A hot jupiter"
        if mapslot<-20000 or isgasgiant(mapslot)>0 then gasgiant_fueling(mapslot,a,sys)
        if mapslot>0 and isgasgiant(mapslot)=0 then
        if planetmap(0,0,mapslot)=0 then
            makeplanetmap(mapslot,a,map(sys).spec)
            'makefinalmap(mapslot)
        endif
        if planets(mapslot).mapstat=0 then planets(mapslot).mapstat=1
        lastlocalitem=make_localitemlist(li(),mapslot)
        if _debug=9 then dprint "moving rovers."
        move_rover(mapslot,li(),lastlocalitem)

        for x=60 to 0 step -1
            for y=0 to 20
                target=st_average+(planets(mapslot).mapped/100*player.sensors)+planets(mapslot).dens
                if abs(planetmap(x,y,mapslot))=8 then target=target-1
                if abs(planetmap(x,y,mapslot))=7 then target=target-2
                if skill_test(minimum(player.science(0)+1,player.sensors),target) and planetmap(x,y,mapslot)<0 then
                    planetmap(x,y,mapslot)=planetmap(x,y,mapslot)*-1
                    tmap(x,y)=tiles(planetmap(x,y,mapslot))
                    reward(0)=reward(0)+.4+player.sensors/10
                    reward(7)=reward(7)+planets(mapslot).mapmod
                    scanned=scanned+1

                endif
            next
        next
        for b=0 to lastitem
            if item(b).w.m=mapslot and item(b).w.p=0 and item(b).w.s=0 then
                target=st_hard+planets(mapslot).dens*item(a).scanmod
                if skill_test(add_talent(4,15,1)+minimum(player.science(0),player.sensors)*item(b).scanmod,target) then
                    item(b).discovered=1
                    itemfound+=1
                endif
            endif
        next
        planets(mapslot).mapped=planets(mapslot).mapped+scanned
        if scanned>50 then dprint gainxp(4),c_gre
        set__color(11,0)
        cls
        if mapslot=player.questflag(7) then dprint "This is the planet Eridiani Explorations wants us to map completely"
        if mapslot=pirateplanet(0) then
            dprint "Science Officer: 'I am picking up signs of civilisation on this planet'",15
        endif
        for a=0 to lastspecial
            if mapslot=specialplanet(a) then
                if specialflag(a)<=1 then
                    if specialplanettext(a,specialflag(a))<>"" then
                        dprint specialplanettext(a,specialflag(a)) &" Key to continue",15
                        no_key=keyin
                    endif
                endif
            endif
        next
        dprint "Scanned "&scanned &" km2"
        if itemfound>0 then
            dprint "Detected "&itemfound &" objects."
        else
            dprint "Detected no objects."
        endif
        if planets(mapslot).flags(22)=1 then dprint "A mining station on this planet sends a distress signal. They need medical help.",15
        if planets(mapslot).flags(22)=2 then dprint "There is a mining station on this planet. They send greetings.",15
        if planets(mapslot).flags(23)>0 then dprint "Science Officer: 'I can detect several ships on this planet.",15
        if planets(mapslot).flags(24)>0 then dprint "Science Officer: 'This planet is completely covered in rain forest. What on first glance appears to be its surface is actually the top layer of a root system.",15
        if planets(mapslot).flags(25)>0 then dprint "Science Officer: 'The biosphere readings for this planet are off the charts. We sure will find some interesting plants here!",15
        if planets(mapslot).flags(26)>0 then dprint "Science Officer: A very deep ocean covers this planet. Sensor readings seem to indicate large cave structures at the bottom.",15
        if planets(mapslot).flags(27)>0 then
            dprint "Science Officer: 'This is a sight you get to see once in a lifetime. The orbit of this planet is unstable and it is about to plunge into its sun! Gravity is ripping open its surface, solar wind blasts its material into space. In a few hours it will be gone.'",15
            planets(mapslot).flags(27)=2
        endif
        if isgardenworld(mapslot) then dprint "This planet is earthlike."
        if planets(mapslot).colflag(0)>0 then dprint "There is "& add_a_or_an(companyname(planets(mapslot).colflag(0)),0) &" colony on this planet. They are sending greetings."
        if debug=1 and _debug=1 then dprint "Map number "&slot &":"& mapslot
        osx=30-_mwx/2

        for a=0 to planets(mapslot).life
            if skill_test(player.science(location),st_hard) then plife=plife+((planets(mapslot).life+1)*3)/100
        next
        if plife>1 then plife=1
        if plife>planets(mapslot).highestlife then
            planets(mapslot).highestlife=plife
            dprint "Revising earlier lifeform estimate",c_yel
        endif
        if planets(mapslot).discovered<2 then planets(mapslot).discovered=2
        do
            screenset 0,1
            cls
            display_planetmap(mapslot,osx,1)
            dplanet(planets(mapslot),slot,scanned,mapslot)
            dprint ""
            flip
            no_key=keyin(key_la & key_tala &" abcdefghijklmnopqrstuvwxyz" &key_east &key_west)
            if no_key=key_east then osx+=1
            if no_key=key_west then osx-=1
            if osx<0 then osx=0
            if osx>60-_mwx then osx=60-_mwx
            set__color(11,0)
            cls

        loop until no_key<>key_east and no_key<>key_west
        if no_key=key_la then key=key_la
        if no_key=key_tala then key=key_tala
        if not(skill_test(player.pilot(location),st_veryeasy,"Pilot:")) and player.fuel>30 then
            dprint "your pilot had to correct the orbit.",14
            x=rnd_range(1,4)-player.pilot(0)
            if x<1 then x=1
            player.fuel=player.fuel-x

        endif
        endif
        if key=key_la then landing(map(sys).planets(slot))
        if key=key_tala then target_landing(map(sys).planets(slot))
    endif
    'show_stars(1,0)
    'displayship
    return 0
end function

function asteroid_mining(slot as short) as short
    dim it as _items
    dim en as _fleet
    dim as short f,q,m,roll
    dim mon(6) as string
    mon(1)="a huge crystaline lifeform, vaguely resembling a spider. It jumps from asteroid to asteroid, it's diet obviously being metal ores. Looks like it has just put our ship on the menu! It is  coming this  way!"
    mon(2)="a huge lifeform made entirely of metal! It is spherical and drifts among the astroids. There are no detectable means of locomotion, except for 3 openenings at the equator. It is radiating high amounts of heat, especially at those openings. Looks like it is a living, moving fission reactor!"
    mon(3)="a dense cloud of living creatures, from microscopic to about 10cm long. They seem to be living insome kind of symbiosis, with different specimen performing different tasks."
    mon(4)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(5)="an enormous blob of living plasma!"
    mon(6)="a gigantic creature resembling a jellyfish!"
    en.ty=2
    m=rnd_range(1,6)
    if show_all then dprint ""&slot
    roll=rnd_range(1,100)
    slot=slot-rnd_range(1,10)
    player.fuel=player.fuel-1
    if skill_test(player.pilot(0),st_hard,"Pilot") then player.fuel=player.fuel-rnd_range(1,3)
    if (slot<-11 and slot>-13) or (slot<-51 and slot>-54)  then
        dprint "you have discovered a dwarf planet among the asteroids!",10
        no_key=keyin
        lastplanet=lastplanet+1
        slot=lastplanet
    else
        if skill_test(player.tractor*2+minimum(player.science(0)+1,player.sensors+1)+3*add_talent(2,9,2)+slot,st_average) then

            do
                it=makeitem(96,f+slot+165,-2)
            loop until it.ty=15
            it.v5=it.v5+100
            it.v2=it.v2+100
            it.desig &=" asteroid"
            if askyn("Science officer: 'There is an asteroid containing a high ammount of "&it.desig &". shall we try to take it aboard?'(y/n)") then
                display_ship()
                q=-1
                do
                    if configflag(con_warnings)=0 and player.hull=1 then
                        q=askyn("Pilot: 'If i make a mistake it could be fatal. Shall I really try?'(y/n)")
                    endif
                    if q=-1 then
                        if skill_test(player.pilot(0)+player.tractor*2,st_average,"Pilot") then
                            q=0
                            placeitem((it),0,0,0,0,-1)
                            reward(2)=reward(2)+it.v5
                            dprint "We got it!",10
                        else
                            player.hull=player.hull-1
                            display_ship()
                            dprint "Your pilot hit the asteroid, damaging the ship, and changing the asteroids trajectory.",14
                            if player.hull>0 then
                                q=askyn("try again? (y/n)")
                                if q=-1 then
                                    dprint "Pilot: 'starting another attempt.'"
                                    sleep 300
                                endif
                            else
                                q=0
                                player.dead=19
                                exit function
                            endif
                        endif
                    endif
                    player.fuel=player.fuel-rnd_range(1,3)
                    roll=roll-1
                    if roll<7 then q=0
                    if player.fuel<10 then player.fuel=10
                loop until q=0
            else
                slot=slot+rnd_range(1,2)
                if slot>=0 then slot =-1
            endif
        else
            dprint "Nothing remarkable."
        endif
    endif
    if roll<4 then
        if rnd_range(1,100)<85 then
            dprint "A ship has been hiding among the asteroids.",14
            if faction(0).war(1)<0 then
                dprint "It hails us.",10
            else
                dprint "It attacks!",12
                no_key=keyin
                if rnd_range(1,6)<5 then
                    en.ty=ft_pirate
                    en.mem(1)=make_ship(3)
                else
                    en.ty=1
                    en.mem(1)=make_ship(4)
                endif
                no_key=keyin
                spacecombat(en,10)
                if player.dead<0 then player.dead=0
            endif
        else
            dprint "A ship has been hiding among the asteroids.",14
            no_key=keyin
            dprint "Wait. that is no ship. It is  "&mon(m) &"!",14
            no_key=keyin
            en.ty=8
            en.mem(1)=make_ship(20+m)
            spacecombat(en,20)

            if player.dead>0 then
                player.dead=20
            else
                if player.dead=0 then
                    dprint "We got very interesting sensor data from that being.",10
                    reward(1)=reward(1)+rnd_range(10,180)*rnd_range(1,maximum(player.science(0),player.sensors))
                    player.alienkills=player.alienkills+1
                else
                    player.dead=0
                endif
            endif
        endif
        set__color(11,0)
        cls
        display_ship()
        display_stars(1)
    endif
    return slot
end function

function gasgiant_fueling(p as short, orbit as short, sys as short) as short
    dim as short fuel,roll,noa,a,mo,m,probe,probeflag,hydrogenscoop,debug,freebay
    dim en as _fleet
    static restfuel as byte
    dim as string mon(6)
    mon(1)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(2)="an enormous blob of living plasma!"
    mon(3)="a gigantic creature resembling a jellyfish!"
    mon(4)="a flock of large tube shaped creatures with wide maws and sharp teeth!"
    mon(5)="a huge balloon floating in the wind with five, thin, several kilometers long tentacles!"
    mon(6)="a circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity."
    if p=-20003 then mo=2
    m=isgasgiant(p)
    if isgasgiant(p)>1 then
        if planetmap(0,0,m)<>0 then make_special_planet(m)
        if askyn("As you dive into the upper atmosphere of the gas giant your sensor pick up a huge metal structure. It is a platform, big enough to land half a fleet on it, connected to struts that extend out into the atmosphere. Do you want to try to land on it? (y/n)") then
            landing(map(sys).planets(orbit))
            return 0
        else
            p=-20001

        endif
    endif
    hydrogenscoop=1
    for a=1 to player.h_maxweaponslot
        if player.weapons(a).made=85 then hydrogenscoop+=1
        if player.weapons(a).made=86 then hydrogenscoop+=2
    next
    if askyn("Do you want to refuel in the gas giants atmosphere?(y/n)") then
        probe=findbest(56,-1)
        if probe>0 then
            if not(askyn("Do you want to use your gas mining probe?(y/n)")) then probe=0
        endif
        if probe<=0 then
            if configflag(con_warnings)=0 and player.hull=1 then
                if not(askyn("Pilot: 'If i make a mistake we are doomed. Do you really want to try it? (Y/N)")) then return 0
            endif
            if skill_test(player.pilot(location)+add_talent(2,9,1),st_average+mo,"Pilot") then
                dprint "Your Pilot damaged the ship diving into the dense atmosphere",12
                player.hull=player.hull-rnd_range(1,2)
                if p=-20003 then player.hull=player.hull-1
                display_ship
            endif
            if player.hull>0 then
                if debug=1 and _debug=1 then dprint ""& hydrogenscoop
                fuel=10+rnd_range(2,7)*hydrogenscoop+add_talent(2,9,3)
                hydrogenscoop-=1
                if hydrogenscoop<=0 then hydrogenscoop=1
                if p=-20001 then fuel=fuel+rnd_range(3,11)*hydrogenscoop
                hydrogenscoop-=1
                if hydrogenscoop<=0 then hydrogenscoop=0
                if p=-20003 then fuel=fuel+rnd_range(5,15)*hydrogenscoop

                display_ship
            else
                player.dead=22
            endif
            if map(sys).spec=10 then rg_icechunk()

            if rnd_range(1,100)<38-orbit*2 and player.dead=0 then
                roll=rnd_range(1,6)
                dprint "While taking up fuel your ship gets attacked by "&mon(roll),14
                no_key=keyin
                noa=1
                if roll=4 then noa=rnd_range(1,6) +rnd_range(1,6)
                if roll=5 then noa=rnd_range(1,3)
                if roll=6 then noa=rnd_range(1,2)
                for a=1 to noa
                    en.ty=9
                    en.mem(a)=make_ship(23+roll)
                next
                spacecombat(en,21)

                if player.dead>0 then
                    player.dead=23
                else
                    if player.dead=0 then
                        dprint "We got very interesting sensor data during this encounter.",10
                        reward(1)=reward(1)+(roll*3+rnd_range(10,80))*rnd_range(1,maximum(player.science(0),player.sensors))
                        player.alienkills=player.alienkills+1
                    else
                        player.dead=0
                    endif
                endif
            endif
        else
            'using probe
            if not(skill_test(player.pilot(0)+add_talent(2,9,1)-3+item(probe).v2,st_average+mo,"Pilot")) then item(probe).v1-=1
            if rnd_range(1,100)<38-orbit*2 then item(probe).v1-=1
            if item(probe).v1<=0 then
                dprint "We lost contact with the probe.",c_yel
                destroyitem(probe)
            else
                fuel=25+rnd_range(3,9)+add_talent(2,9,3)
                if p=-20001 then fuel=fuel+rnd_range(3,9)
                if p=-20003 then fuel=fuel+rnd_range(5,15)
                if fuel>item(probe).v3 then fuel=item(probe).v3
                'if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
            endif
        endif

    endif
    if fuel>0 then
        dprint "you take up "&fuel & " tons of fuel.",10
        player.fuel=player.fuel+fuel
        freebay=getnextfreebay
        if player.fuel>player.fuelmax+player.fuelpod and freebay>0 then
            if askyn("Do you want to store the excess fuel in a cargobay?(y/n)") then
                do
                    player.cargo(freebay).x=10
                    player.cargo(freebay).y=1
                    player.fuel-=30
                    freebay=getnextfreebay
                loop until player.fuel<=player.fuelmax+player.fuelpod or freebay=-1
            endif
        endif
        if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
    endif


    return 0
end function

function rg_icechunk() as short
    dim as short debug,x,y,b
    dim gc as _cords
    if rnd_range(1,100)>5+player.sensors then return 0
    dprint "Your sensors seem to pick up something"
    if rnd_range(1,100)>5+player.sensors then
        dprint "But it is gone again quickly."
        return 0
    endif
    lastplanet+=1
    makemossworld(lastplanet,4)
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,lastplanet))=1 then planetmap(x,y,lastplanet)=-4
            if abs(planetmap(x,y,lastplanet))=2 then planetmap(x,y,lastplanet)=-158
            if abs(planetmap(x,y,lastplanet))=102 then planetmap(x,y,lastplanet)=-4
            if abs(planetmap(x,y,lastplanet))=103 then planetmap(x,y,lastplanet)=-7
            if abs(planetmap(x,y,lastplanet))=104 then planetmap(x,y,lastplanet)=-193
            if abs(planetmap(x,y,lastplanet))=105 then planetmap(x,y,lastplanet)=-145
            if abs(planetmap(x,y,lastplanet))=106 then planetmap(x,y,lastplanet)=-145
            if abs(planetmap(x,y,lastplanet))=146 then planetmap(x,y,lastplanet)=-145
            if rnd_range(1,6)+player.science(0)>9 then planetmap(x,y,lastplanet)=abs(planetmap(x,y,lastplanet))
        next
    next
    planets(lastplanet).grav=.3
    planets(lastplanet).temp=-120
    planets(lastplanet).atmos=1
    planets(lastplanet).death=5+rnd_range(3,6)
    planets(lastplanet).flags(27)=2
    planets(lastplanet).flags(29)=1 'Planet Flag for Ice Chunk
    if rnd_range(1,100)<10 then
        planets(lastplanet).mon_template(0)=makemonster(rnd_range(62,64),0,0)
        planets(lastplanet).mon_noamin(0)=1
        planets(lastplanet).mon_noamax(0)=3

    endif
    for b=0 to 10+rnd_range(0,6)+disnbase(player.c)\4
        gc=rnd_point(lastplanet,1)
        placeitem(makeitem(96,planets(lastplanet).depth+disnbase(player.c)\5,planets(lastplanet).depth+disnbase(player.c)\6),gc.x,gc.y,lastplanet)
    next b
    display_planetmap(lastplanet,30,1)
    dprint "Your sensors pick up a huge chunk of ice in the atmosphere, quickly tumbling down into the denser areas of the gas giant. It is big enough to land on."
    if askyn("Do you want to try to land on it?(y/n)") then
        landing(lastplanet)
        lastplanet-=1
    else
        dprint "You climb back up into free space while the icechunk disintegrates"
    endif
    return 0
end function


function dock_drifting_ship(a as short)  as short
    dim as short m,b,c,x,y,debug
    dim p(1024) as _cords
    dim land as _cords
    dim as short test=0
    debug=1
    m=drifting(a).m
    if a<=3 and rnd_range(1,100)<10+test and player.turn>5 then
        station_event(m)
    endif
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=203 then
                b+=1
                p(b).x=x
                p(b).y=y
            endif
        next
    next
    c=rnd_range(1,b)
    land.x=p(c).x
    land.y=p(c).y
    land.m=m
    if _debug=11 then
        dprint "Got through dock_drifting_ship"
        sleep
    endif
    landing(m,p(c).x,p(c).y,1)
    return 0
end function

function move_rover(pl as short,li()as short,lastlocalitem as short)  as short
    dim as integer a,b,c,i,t,ti,x,y
    dim as integer carn,herb,mins,oxy,food,energy,curr,last
    dim as single minebase
    dim as _cords p1,p2,route(1281)
    dim as _cords pp(9)

    update_tmap(pl)
    t=(player.turn-planets(pl).visited)*10
    if _debug=9 then screenset 1,1
    for i=0 to lastitem
        if item(i).ty=18 and item(i).w.p=0 and item(i).w.s=0 and item(i).w.m=pl and item(i).discovered>0 and t>0 then
            if _debug=9 then dprint "Moving rover "&i
            last=0
            curr=0
            p1.x=item(i).w.x
            p1.y=item(i).w.y
            for a=0 to t*item(i).v4
                curr+=1
                if curr>last then
                    if _debug>0 then dprint "Route:"&last
                    last=ep_autoexploreroute(route(),p1,item(i).v1,pl,li(),lastlocalitem,1)
                    curr=1
                    if _debug>0 and last>0 then dprint "Target:"&cords(route(last))
                else
                    if last>0 then
                        item(i).w.x=route(curr).x
                        item(i).w.y=route(curr).y
                    endif
                endif
                ep_roverreveal(i)
                if a mod 10=0 then
                    screenset 0,1
                    cls
                    display_planetmap(pl,calcosx(item(i).w.x,planets(pl).depth),0)
                    display_ship(0)
                    display_awayteam(1)
                    if _debug>0 then dprint cords(item(i).w) &" curr :"& curr &" last :"&last
                    flip
                endif
            next
            if rnd_range(1,150)<planets(pl).atmos*2 then item(i).discovered=0
            if rnd_range(1,150)<planets(pl).atmos+2 then
                item(i)=makeitem(65)
            else
                dprint "Receiving the homing signal of a rover on this planet",10
            endif
        endif
    next
    i=0
    for a=0 to lastitem
        if item(a).ty=27 and item(a).w.p=0 and item(a).w.s=0 and item(a).w.m=pl then i=a
        if item(a).ty=15 and item(a).w.p=0 and item(a).w.s=0 and item(a).w.m=pl then
            minebase+=1.1
            if rnd_range(1,100)<10 then destroyitem(a)
        endif
    next
    if i>0 and t>0 then
        p1.x=item(i).w.x
        p1.y=item(i).w.y
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if abs(planetmap(x,y,pl))=13 then minebase=minebase+2/distance(p1,p2)
                if abs(planetmap(x,y,pl))=7 or abs(planetmap(x,y,pl))=8 then minebase=minebase+1/distance(p1,p2)
            next
        next
        minebase=minebase+planets(pl).minerals
        minebase=minebase+planets(pl).atmos
        minebase=minebase+planets(pl).grav
        minebase=minebase+planets(pl).depth
        if sysfrommap(pl)>0 then
            minebase=minebase+abs(spacemap(map(sysfrommap(pl)).c.x,map(sysfrommap(pl)).c.y))
        else
            minebase=minebase+planets(pl).depth
        endif
        item(i).v1=item(i).v1+0.01*minebase*t*item(i).v3
        if item(i).v1>item(i).v2 then item(i).v1=item(i).v2
        if rnd_range(1,150)<planets(pl).atmos+2 then item(i)=makeitem(66)
    endif
    planets(pl).visited=player.turn
    return 0
end function

function rescue() as short
    dim as short a,c,dis,beacon,cargo,closest_fleet,dis2
    dim as single b,d
    dim fname(10) as string

    gen_fname(fname())
    d=256
    if getinvbytype(9)>0 then
        dprint ("You ran out of fuel. You use the fuel from the cargo bay.")
        removeinvbytype(9,1)
        player.fuel+=30
        return 0
    endif
    ranoutoffuel+=1
    dis2=9999
    for a=0 to lastfleet
        if _debug=1 then dprint a &":"& fleet(a).con(1)
        if fleet(a).con(1)<>0 then
            if askyn("This is merchant fleet "&a &". Do you need fuel?(y/n)",,1) then
                dprint "2 Cr. per ton. We'll deduct it from the agreed upon payment."
                b=getnumber(0,player.fuelmax,0)
                player.fuel+=b
                fleet(a).con(2)-=b*2
                return 0
            endif
        else
            if distance(fleet(a).c,player.c)<dis2 and faction(0).war(fleet(a).ty)<100 then
                closest_fleet=a
                dis2=distance(fleet(a).c,player.c)
            endif
        endif
    next

    for a=0 to 2
        b=distance(player.c,basis(a).c)
        if b<d then
            d=b
            c=a
        endif
    next
    beacon=findbest(36,-1)
    if beacon>0 then
        dis=item(beacon).v1
        if rnd_range(1,100)<66 then destroyitem(beacon)
    else
        dis=0
    endif
    if d>0 and d<256 then
        dprint "Fuel tanks empty, sending distress signal!",14
        no_key=keyin
        if d<5+dis*2 then
            if faction(0).war(1)<100 then
                dprint "Station " &c+1 &" answered and sent a retrieval team. You are charged "& int(d*(100-dis*10)) & " Cr.",10
                player.money=player.money-int(d*(100-dis*10))'needs to go below 0
                player.fuel=10
                player.c.x=basis(c).c.x
                player.c.y=basis(c).c.y
            else
                dprint "One of the stations answers, explaining that they will not help a known pirate like you.",12
                player.dead=1
            endif
        else
            dprint "You are too far out in space....",12

            if rnd_range(1,100)-(10+dis-dis2)<5+dis*2 then
                dprint "Your distress signal is answered!",10
                b=rnd_range(1,33)+rnd_range(1,33)+rnd_range(1,33)
                if closest_fleet>0 then
                    dprint add_a_or_an(fname(fleet(closest_fleet).ty),1)&" offers to sell you fuel to get back to the nearest base for "& b &" Cr. per ton. ("& int(disnbase(player.c)*b) &" credits for " &int(disnbase(player.c)) &" tons)."
                else
                    dprint add_a_or_an(shiptypes(rnd_Range(0,16)),1) &" offers to sell you fuel to get to the nearest station for "& b &" Cr. per ton. ("& int(disnbase(player.c)*b) &" credits for " &int(disnbase(player.c)) &" tons)."
                endif
                if askyn("Do you accept the offer?(y/n)") then
                    if player.money>=int(disnbase(player.c)*b) then
                        player.money=player.money-disnbase(player.c)*b
                    else
                        dprint "You convince them to lower their price. They only take all your money.",10
                        player.money=0
                    endif
                    player.fuel=disnbase(player.c)+2
                    locate 1,1
                    no_key=keyin
                else
                    if not(askyn("Are you certain? (y/n)")) then
                        if player.money>=int(disnbase(player.c)*b) then
                            player.money=player.money-disnbase(player.c)*b
                        else
                            dprint "You convince them to lower their price. They only take all your money.",10
                            player.money=0
                        endif
                        player.fuel=disnbase(player.c)+2
                        locate 1,1
                        no_key=keyin
                    else
                        dprint "they leave again."
                        locate 1,1
                        no_key=keyin
                        player.dead=1
                    endif
                endif
            else
                player.dead=1
            endif
        endif
        no_key=keyin
        cls
    endif
    return 0
end function



function spacestation(st as short) as _ship
    dim as short a,b,c,d,e,wchance,inspectionchance
    static as short hiringpool,last,muddsshop,botsshop,usedshop
    static inv(lstcomit) as _items
    dim quarantine as short
    dim i as _items
    dim as string key,text,mtext,sn
    dim dum as _basis
    set__color(11,0)
    cls
    basis(st).docked+=1
    comstr.reset
    display_ship
    if _debug=1111 then questroll=14
    if player.turn>0 then
        if basis(st).company=3 then
            inspectionchance=5+faction(0).war(1)+foundsomething
        else
            inspectionchance=33+faction(0).war(1)+foundsomething
        endif
        if rnd_range(1,100)<inspectionchance then
            dprint "The station commander decides to do a routine check on your cargo hold before allowing you to disembark.",14
            no_key=keyin
            d=0
            for b=1 to 10
                c=0
                if player.cargo(b).x=9 and (basis(st).company<>1 or basis(st).company=3) then c=1 'Embargo
                if player.cargo(b).x=8 and (basis(st).company<>2 or basis(st).company=3) then c=1 'Embargo
                if player.cargo(b).x=7 and (basis(st).company<>4 or basis(st).company=3) then c=1 'embargo
                if player.cargo(b).x>1 and player.cargo(b).x<9 and player.cargo(b).y=0 then c=1 'Stolen
                if c=1 and rnd_range(1,100)<30-player.equipment(se_CargoShielding)+player.cargo(b).x then
                    d=1
                    if player.cargo(b).y>0 then
                        dprint "You are informed that there is an import embargo on "& lcase(goodsname(player.cargo(b).x-1)) &" and that the cargo will be confiscated.",12
                    else
                        dprint "Your cargo of "& lcase(goodsname(player.cargo(b).x-1)) &" gets confiscated because you lack proper documentation.",12
                    endif
                    player.cargo(b).x=1
                    player.cargo(b).y=0
                    faction(0).war(1)+=1
                endif
            next
            if d=0 then
                dprint "Everything seems to be ok.",10
                foundsomething-=1
            else
                foundsomething+=5
            endif
        endif
        check_passenger(st)
        if _debug=1 then dprint "Morale change:"&(wage-9-bunk_multi*2)&":"& bunk_multi &":"&(player.h_maxcrew+player.crewpod)*1+player.cryo
        for b=2 to 128
            if Crew(b).paymod>0 and crew(b).hpmax>0 and crew(b).hp>0 then
                a=a+Wage*(Crew(b).paymod/10)
                crew(b).morale=crew(b).morale+(Wage-9-bunk_multi*2)+add_talent(1,4,5)

            endif
        next
        dprint "You pay your crew "&a &" Cr. in wages"
        player.money=player.money-a
        if _debug=1 then dprint "Done"
        player=levelup(player,0)
        if _debug=1 then dprint "Done"
        if shop_order(st)<>0 and rnd_range(1,100)<33 then
            dprint  "Your ordered "&makeitem(shop_order(st)).desig &" has arrived.",12
            b=rnd_range(1,20)
            shopitem(b,st)=makeitem(shop_order(st))
            shopitem(b,st).price=shopitem(b,st).price*2
            shop_order(st)=0
        endif
    endif
    if _debug=1 then dprint "Done"

    ss_sighting(st)
    if _debug=1 then dprint "Done"

    if basis(st).spy=1 or basis(st).spy=2 then
        if askyn("Do you pay 100 cr. for your informant? (y/n)") then
            player.money=player.money-100
            if player.money<0 then
                player.money=0
                dprint "He doesn't seem very happy about you being unable to pay."
            else
                faction(0).war(1)-=5
            endif
        else
            basis(st).spy=3
            faction(0).war(1)+=15
        endif
    endif

    for a=0 to lastfleet
        if distance(fleet(a).c,basis(st).c)<2 and fleet(a).con(1)=1 and st=fleet(a).con(3) then
            select case fleet(a).con(2)
            case is>0
                dprint "The captain of the merchant convoy thanks you and pays you "& fleet(a).con(2) & " Cr. as promised.",c_gre
                addmoney(fleet(a).con(2),mt_escorting)
                if fleet(a).con(4)<0 then fleet(a).con(4)=0
                fleet(a).con(4)+=1

            case is<0
                if askyn("with your fuel costs you actually owe the captain "&abs(fleet(a).con(2)) &"Cr. Do you pay?(y/n)") then
                    addmoney(fleet(a).con(2),mt_escorting)
                else
                    dprint "The captain isn't very pleased."
                    factionadd(0,fleet(a).ty,1)
                    fleet(a).con(4)-=1
                endif
            case is=0
                dprint "The captain informs you that your fuelcosts have eaten up your escorting wage."
            end select
            fleet(a).con(1)=0
            fleet(a).con(2)=0
            fleet(a).con(3)=0

        endif
    next
    if st<>player.lastvisit.s or player.turn-player.lastvisit.t>600 then
        b=count_and_makeweapons(st)

        if b<5 and rnd_range(1,100)<15 then
            reroll_shops
            b=count_and_makeweapons(st)
        endif
    endif

    if st<>player.lastvisit.s or player.turn-player.lastvisit.t>100 then
        dprint gainxp(1),c_gre
        check_questcargo(st)
        for a=0 to 2
            if (player.turn-player.lastvisit.t)\3>1 then change_prices(a,(player.turn-player.lastvisit.t)\3)
            companystats(basis(a).company).rate=0
            for b=0 to 1+(player.turn-player.lastvisit.t)\3
                companystats(basis(a).company).profit=companystats(basis(a).company).profit+((rnd_range(1,6) +rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6))*companystats(basis(a).company).capital/10)
                if companystats(basis(a).company).profit>0 then companystats(basis(a).company).rate=companystats(basis(a).company).rate+rnd_range(1,6)
                if companystats(basis(a).company).profit<0 then companystats(basis(a).company).rate=companystats(basis(a).company).rate-rnd_range(1,6)
            next
            companystats(basis(a).company).rate=companystats(basis(a).company).rate+(companystats(basis(a).company).capital+companystats(basis(a).company).profit)/10
            companystats(basis(a).company).profit=0
            if companystats(basis(a).company).rate<700 then companystats(basis(a).company).rate=700
            if companystats(basis(a).company).rate>5000 then companystats(basis(a).company).rate=5000
        next
        if companystats(basis(st).company).capital<300 then dprint "The spacestation is abuzz with rumors that "&companyname(basis(st).company) &" is in financial difficulties."
        if companystats(basis(st).company).capital<100 then
            dprint companyname(basis(st).company) &" has closed their office in this station."
            dum=makecorp(-basis(st).company)
            basis(st).company=dum.company
            basis(st).repname=dum.repname
            basis(st).mapmod=dum.mapmod
            basis(st).biomod=dum.biomod
            basis(st).resmod=dum.resmod
            basis(st).pirmod=dum.pirmod
            dprint companyname(basis(st).company) &" has taken their place."
        endif
        dividend()
    endif
    girlfriends(st)
    hiringpool=rnd_range(1,4)+rnd_range(1,4)+3
    do
        quarantine=player.disease
        mtext="Station "& st+1 &"/ "
        mtext=mtext & basis(st).repname &" Office "
        if quarantine>6 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Equipment "
        if quarantine>6 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Sickbay / Fuel(" & round_str((basis(st).inv(9).p/30)*(player.fuelmax+player.fuelpod-fix(player.fuel)),2) & " Cr, " & (player.fuelmax+player.fuelpod-fix(player.fuel)) & " tons ) & Ammuniton("& missing_ammo*((player.loadout+1)^2) & "Cr.) / "
        mtext=mtext &"Repair(" &credits(int(max_hull(player)-player.hull)*(basis(st).pricelevel*100*(0.5+0.5*player.armortype))) & "Cr.) / Hire Crew / Trading "
        if quarantine>5 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Casino "
        if quarantine>4 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Retirement"
        mtext=mtext &"/Leave station"
        display_ship()
        bg_parent=bg_shiptxt
        a=menu(bg_shiptxt,mtext,,,,,1)
        if a=1 then
            if quarantine<8 then
                company(st)
            else
                dprint "You are under quarantine and not allowed to enter there"
            endif
        endif
        if a=2 then'refit
            if quarantine<9 then
                do
                    set__color(11,0)
                    cls
                    sn=shopname(basis(st).shop(sh_equipment))
                    usedshop=99
                    muddsshop=99
                    botsshop=99
                    display_ship()
                    mtext="Refit/"&shipyardname(basis(st).shop(sh_shipyard))
                    mtext=mtext &"/"& moduleshopname(basis(st).shop(sh_modules)) &"/" &sn
                    if basis(st).shop(sh_used)=1 then
                        mtext=mtext & "/Used Ships"
                        usedshop=4
                    endif
                    if basis(st).shop(sh_mudds)=1 then
                        mtext=mtext & "/Mudds Incredible Bargains"
                        muddsshop=4+basis(st).shop(sh_used)
                    endif
                    if basis(st).shop(sh_bots)=1 then
                        mtext=mtext & "/The Bot-bin"
                        botsshop=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_used)
                    endif
                    mtext &= "/Exit"

                    b=menu(bg_ship,mtext)
                    if b=1 then shipyard(basis(st).shop(sh_shipyard))
                    if b=2 then shipupgrades(st)
                    'if b= then towingmodules
                    if b=3 then 'awayteam equipment
                        do
                            c=shop(st,basis(st).pricelevel,sn)
                            display_ship
                        loop until c=-1
                        set__color(11,0)
                        cls
                    endif
                    if basis(st).shop(sh_used)=1 and b=usedshop then used_ships
                    if basis(st).shop(sh_mudds)=1 and b=muddsshop then mudds_shop
                    if basis(st).shop(sh_bots)=1 and b=botsshop then botsanddrones_shop
                loop until b=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_bots)+basis(st).shop(sh_used) or b=-1
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=3 then
            player.disease=sick_bay(,basis(st).company)
            mtext="Station "& st+1 &"/ "
            mtext=mtext & basis(st).repname &" Office "
            if quarantine>6 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Equipment "
            if quarantine>6 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Sickbay / Fuel & Ammuniton / Repair / Hire Crew / Trading "
            if quarantine>5 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Casino "
            if quarantine>4 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/Exit"
        endif
        if a=4 then refuel(st,round_nr(basis(st).inv(9).p/30,2))
        if a=5 then repair_hull(basis(st).pricelevel)
        if a=6 then hiring(st,hiringpool,4)
        if a=7 then
            if quarantine<7 then
                trading(st)
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=8 then
            if quarantine<5 then
                b=casino(0,st)
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=9 then retirement()
        if a=10 or a=-1 then
            text=""
            if player.pilot(0)<0 then text=text &"You dont have a pilot. "
            if player.gunner(0)<0 then text=text &"You dont have a gunner. "
            if player.science(0)<0 then text=text &"You dont have a science officer. "
            if player.doctor(0)<0 then text=text &"You dont have a ships doctor. "
            if player.fuel<player.fuelmax*0.5 then text=text &"You only have " &player.fuel & " fuel. "
            if player.money<0 then text=text &"You still have debts of "& player.money &" credits to pay. "
            if (text<>"" and player.dead=0) then
                if askyn(text &"Do you want to leave anyway?(y/n)",14) then
                    a=10
                else
                    a=0
                endif
            endif
            if text="" and a=-1 then
                if askyn("Do you really want to leave?(y/n)",14) then
                    a=10
                else
                    a=0
                endif
            endif
        endif
    loop until a=10
    set__color(11,0)
    cls
    player.lastvisit.s=st
    player.lastvisit.t=player.turn
    return player
end function



function move_ship(key as string) as _ship
    dim as short a,dam,hydrogenscoop
    dim scoop as single
    static fuelcollect as byte
    dim as _cords old,p
    if artflag(23)>0 then
        if player.hull<player.h_maxhull and player.turn mod 10=0 then player.hull+=1
    endif
    hydrogenscoop=0
    for a=1 to player.h_maxweaponslot
        if player.weapons(a).made=85 then hydrogenscoop+=1
        if player.weapons(a).made=86 then hydrogenscoop+=2
    next
    if walking=0 then
        a=getdirection(key)
    else
        if walking<10 then a=walking
    endif
    if walking=10 then
        currapwp+=1
        a=nearest(apwaypoints(currapwp),player.c)
        if currapwp=lastapwp then
            dprint "Target reached"
            walking=0
        endif

    endif
    if a<>0 then player.di=a
    old=player.c
    player.c=movepoint(player.c,a,,1)
    if player.c.x<0 then player.c.x=0
    if player.c.y<0 then player.c.y=0
    if player.c.x>sm_x then player.c.x=sm_x
    if player.c.y>sm_y then player.c.y=sm_y
    if player.c.x<>old.x or player.c.y<>old.y then
        if player.towed<>0 then
            player.fuel-=1
            if not(skill_test(player.pilot(0),st_average,"Pilot")) then player.fuel-=1
        endif
        if spacemap(player.c.x,player.c.y)=-2 then spacemap(player.c.x,player.c.y)=2
        if spacemap(player.c.x,player.c.y)=-3 then spacemap(player.c.x,player.c.y)=3
        if spacemap(player.c.x,player.c.y)=-4 then spacemap(player.c.x,player.c.y)=4
        if spacemap(player.c.x,player.c.y)=-5 then spacemap(player.c.x,player.c.y)=5
        if spacemap(player.c.x,player.c.y)=-6 then spacemap(player.c.x,player.c.y)=6
        if spacemap(player.c.x,player.c.y)=-7 then spacemap(player.c.x,player.c.y)=7
        if spacemap(player.c.x,player.c.y)=-8 then spacemap(player.c.x,player.c.y)=8
        if (spacemap(old.x,old.y)<2 or spacemap(old.x,old.y)>5) and spacemap(player.c.x,player.c.y)>=2 and spacemap(player.c.x,player.c.y)<=5 and configflag(con_warnings)=0 then
            if not(askyn("Do you really want to enter the gascloud?(y/n)")) then player.c=old
        endif
        if spacemap(player.c.x,player.c.y)>=2 and spacemap(player.c.x,player.c.y)<=5 then
            player.towed=0
            if skill_test(player.pilot(0),st_easy+spacemap(player.c.x,player.c.y),"Pilot:") then
                dprint "You succesfully navigate the gascloud",10
                dprint gainxp(2),c_gre
                if hydrogenscoop=0 then player.fuel=player.fuel-rnd_range(1,3)
                fuelcollect+=spacemap(player.c.x,player.c.y)*hydrogenscoop
                if fuelcollect>5 then
                    player.fuel+=fuelcollect/5
                    if player.fuel>player.fuelmax then player.fuel=player.fuelmax
                    fuelcollect=0
                endif
            else
                dam=rnd_range(1,spacemap(player.c.x,player.c.y))
                if dam>player.shieldside(rnd_range(0,7)) then
                    dam=dam-player.shieldside(rnd_range(0,7))
                    dprint "Your Ship is damaged ("&dam &").",12
                    player.hull=player.hull-dam
                    player.fuel=player.fuel-rnd_range(1,5)
                    if player.hull<=0 then player.dead=12
                endif
            endif
        endif
        if spacemap(player.c.x,player.c.y)>=6 and spacemap(player.c.x,player.c.y)<=20 then
            select case spacemap(player.c.x,player.c.y)
            case is=16
                dprint "This anomaly shortens space."
            case is=17
                dprint "This anomaly lengthens space."
            case is=18
                dprint "This anomaly shortnes space, and can damage a ship."
            case is=19
                dprint "This anomaly lengthens space, and can damage a ship."
            case is=20
                dprint "This anomaly can damage a ship and is highly unpredictable."
            end select
            if (spacemap(player.c.x,player.c.y)>=8 and spacemap(player.c.x,player.c.y)<=10) or (spacemap(player.c.x,player.c.y)>=18 and spacemap(player.c.x,player.c.y)<=20) then
                if rnd_range(1,100)<15 then
                    dam=rnd_range(0,3)
                    if dam>player.shieldside(rnd_range(0,7)) then
                        dam=1
                        dprint "Your Ship is damaged ("&dam &").",12
                        player.hull=player.hull-dam
                        player.fuel=player.fuel-rnd_range(1,5)
                        if player.hull<=0 then player.dead=30
                    else
                        if player.shieldmax>0 then dprint "Your shields are hit, but hold",10
                    endif
                endif
            endif
            if spacemap(player.c.x,player.c.y)=8 or spacemap(player.c.x,player.c.y)=6 or spacemap(player.c.x,player.c.y)=18 or spacemap(player.c.x,player.c.y)=16 then
                player.e.tick
                player.fuel+=.5
            endif
            if spacemap(player.c.x,player.c.y)=9 or spacemap(player.c.x,player.c.y)=7 or spacemap(player.c.x,player.c.y)=19 or spacemap(player.c.x,player.c.y)=17 then
                player.e.add_action(10)
                player.fuel-=.5
            endif
            if spacemap(player.c.x,player.c.y)=10 or spacemap(player.c.x,player.c.y)=20 or (spacemap(player.c.x,player.c.y)>=6 and rnd_range(1,100)<5) then
                if rnd_range(1,100)<66 then
                    select case rnd_range(0,100)
                    case is=1
                        dprint "Something strange is happening with your fuel tank reading"
                        player.fuel+=rnd_range(1,6)
                    case is=2
                        dprint "You get swept away in a gravitational current"
                        player.c=old
                    case is=3
                        dprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,player.di,,1)
                    case is=4
                        dprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,5,,1)
                    case is=5
                        dprint "Something strange is happening with the ships chronometer"
                        player.turn=player.turn+rnd_range(1,6)-rnd_range(1,8)
                    case is=6
                        dprint "Your sensors are damaged."
                        player.sensors-=1
                    case is=7
                        if player.shieldmax>0 then
                            dprint "Your shieldgenerator is damaged."
                            player.shieldmax-=1
                        endif
                    case is=8
                        dprint "Time itself seems to speed up"
                        player.e.add_action(player.engine+20-player.engine*2)
                    case is=9
                        dprint "You have trouble keeping your position"
                        player.di=rnd_range(1,8)
                        if player.di=5 then player.di=9
                    case is=10
                        dprint "Something catapults you out of the anomaly!"
                        p=player.c
                        for a=0 to rnd_range(1,6)
                            p=movepoint(p,player.di,,1)
                        next
                        wormhole_ani(p)
                    case is=11
                        if rnd_range(1,100)<10+spacemap(player.c.x,player.c.y) then
                            player.c=map(rnd_range(laststar+1,laststar+wormhole)).c
                            dam=rnd_range(1,6)
                            if dam>player.shieldmax then
                                dam=1
                                dprint "your Ship is damaged ("&dam &").",12
                                player.hull=player.hull-dam
                                player.fuel=player.fuel-rnd_range(1,5)
                                if player.hull<=0 then player.dead=30
                            endif
                        else
                            dprint "A wormhole forms straight ahead, but you manage to avoid it. It disappears again instantly."
                        endif
                    case is=12
                        dprint "There should be a *lot* less fuel in your fueltank"
                        player.fuel+=rnd_range(50,100)
                    case is=13
                        dprint "This strange area of space alters your ships structure"
                        player.h_maxhull-=1
                    case is=14
                        dprint "This strange area of space alters your ships structure"
                        player.h_maxhull+=1
                    case is=15
                        dprint "Your cargo hold is damaged!"
                        player.cargo(rnd_range(1,player.h_maxcargo)).x=1
                    case is =16
                        dprint "Your fuel tank is damaged!"
                        player.h_maxfuel-=1
                        if rnd_range(1,100)<10 then
                            dprint "The damage results in an explosion!"
                            player.hull-=rnd_Range(1,3)
                        endif
                    end select

                endif
            endif
        endif
        if player.towed>0 then
            drifting(player.towed).x=player.c.x
            drifting(player.towed).y=player.c.y
        endif
    endif
    if (player.c.x<>old.x or player.c.y<>old.y) then' and (player.c.x+player.osx<>30 or player.c.y+player.osy<>10) then
        if spacemap(player.c.x,player.c.y)<=5 then player.fuel=player.fuel-player.fueluse
        player.add_move_cost(0)
        for a=0 to 12
            if patrolquest(a).status=1 then patrolquest(a).check
        next
        if player.cursed>0 and rnd_range(1,100)<3+player.cursed+spacemap(player.c.x,player.c.y) and player.turn mod(50-player.cursed)=0 then player=com_criticalhit(player,rnd_range(1,6)+6-player.armortype)
    else
        walking=0
    endif
    return player
end function

function explore_space() as short
    dim as short a,b,d,c,f,fl,pl,x1,y1,x2,y2,lturn,debug,osx,osy
    dim as string key,text,allowed
    dim as _cords p1,p2
    dim as short planetcom,driftercom,fleetcom,wormcom
    lturn=0
    debug=11
    if debug=11 and _debug=1 then dprint basis(0).shop(sh_equipment) &":"& basis(1).shop(sh_equipment) &":"& basis(2).shop(sh_equipment)
    for a=0 to lastitem
        for b=0 to lastitem
            if b<>a then
                if item(a).id=item(b).id and item(a).ty<>item(b).ty then 
                    dprint item(a).desig &";" &item(b).desig
                    'item(a).id+=1
                endif
            endif
        next
    next
    for a=1 to 25
        if player.weapons(a).heat>0 then player.weapons(a).heat=0
    next
    if _debug=11 then
        for a=1 to lastdrifting
            drifting(a).p=1
        next
    endif
    screenset 0,1
    cls
    bg_parent=bg_shipstarstxt
    location=lc_onship
    display_stars(1)
    display_ship
    flip
    screenset 0,1
    cls
    bg_parent=bg_shipstarstxt
    display_stars(1)
    display_ship
    flip
    screenset 0,1
    if debug=10 and _debug=1 then dprint spdescr(7)
    do
        if debug=8 and _debug=1 then dprint "Lastfleet:"&lastfleet
        lturn+=1
        if lturn>=5 then
            player.turn+=1
            lturn=0
        endif
        if show_specials<>0 then dprint "Planet is at " &map(sysfrommap(specialplanet(show_specials))).c.x &":"&map(sysfrommap(specialplanet(show_specials))).c.y
        if player.e.tick=-1 and player.dead=0 then
            fl=0
            allowed=key_awayteam & key_ra & key_drop &key_la &key_tala &key_dock &key_sc & key_rename & key_comment & key_save &key_quit &key_tow &key_walk
            allowed= allowed & key_nw & key_north & key_ne & key_east & key_west & key_se & key_south & key_sw
            if artflag(25)>0 then allowed=allowed &key_te
            if debug=11 and _debug=1 then allowed=allowed &"ü"
            for a=0 to 2
                if player.c.x=basis(a).c.x and player.c.y=basis(a).c.y then
                    dprint "You are at Spacestation-"& a+1 &". Press "&key_dock &" to dock."
                    allowed=allowed & key_fi
                    if walking<10 then walking=0
                    driftercom=1
                endif
            next

            for a=1 to lastfleet
                if distance(player.c,fleet(a).c)<1.5 then
                    fl=meet_fleet(a)
                    fleetcom=1
                    exit for
                endif
            next
            for a=0 to laststar
                if player.c.x=map(a).c.x and player.c.y=map(a).c.y then
                    planetcom=a+1
                    dPrint add_a_or_an(spectralname(map(a).spec),1)&"." & system_text(a) & ". Press "&key_sc &" to scan, "&key_la &" to land, " &key_tala &" to land at a specific spot."
                    if a=piratebase(0) then dprint "Lots of traffic in this system"
                    map(a).discovered=2
                    display_system(a)
                    if walking<10 then walking=0
                endif
            next
            for a=laststar+1 to laststar+wormhole
                if player.c.x=map(a).c.x and player.c.y=map(a).c.y then
                    dprint "A wormhole. Press "&key_la &" to enter it."
                    wormcom=1
                    if walking<10 then walking=0
                endif
            next
            for a=1 to lastdrifting
                if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 and player.towed<>a then
                    if player.tractor>0 and a>3 then
                        dprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock, "&key_tow &" to tow."
                    endif
                    if player.tractor=0 then
                        dprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock."
                    endif
                    drifting(a).p=1
                    driftercom=1
                    if walking<10 then walking=0
                endif
            next
            if fl>0 or _testspacecombat=1 then
                if fleet(fl).ty=1 and fl>5 then
                    if player.turn mod 10=0 then
                        if fleet(fl).con(1)=0 then
                            dprint "There is a merchant convoy in sensor range, hailing us. press "&key_fi &" to attack," &key_ra & " to call by radio."
                        else
                            dprint "This is merchant convoy "&fl &". reporting no incidents."
                        endif
                    endif
                endif
                if fleet(fl).ty=2 then dprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                if fleet(fl).ty=3 then dprint "There is a company anti pirate patrol in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                if fleet(fl).ty=4 then dprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                if fleet(fl).ty=6 then
                    if civ(0).contact=0 then
                        dprint civfleetdescription(fleet(fl)) &" hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    else
                        dprint add_a_or_an(civ(0).n,1) &" fleet, hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    endif
                endif
                allowed=allowed+key_fi
                fleetcom=1
            endif

            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"
            if planetcom>0 then comstr.t=comstr.t & key_sc &" scan;"& key_la &" land;"& key_tala &" target land;"
            if fleetcom=1 then comstr.t=comstr.t &key_fi &" attack;"
            if driftercom=1 then comstr.t=comstr.t &key_dock &" dock;"
            if wormcom=1 then comstr.t=comstr.t &key_la &" enter wormhole;"
            if artflag(25)>0 then comstr.t=comstr.t &key_te &" wormhole generator"
            
            screenset 0,1
            cls
            bg_parent=bg_shipstarstxt
            location=lc_onship
            display_stars(1)
            display_ship(1)
            if planetcom>0 then display_system(planetcom-1)
            dprint ""
            flip
        
            'screenset 1,1
            key=keyin(allowed,walking)
            
            player=move_ship(key)

            planetcom=0
            fleetcom=0
            driftercom=0
            wormcom=0
            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"


            if debug=11 and _debug=1 and key="ü" then
                dprint fleet(1).mem(1).hull &":"&fleet(2).mem(1).hull &":"&fleet(3).mem(1).hull
                lastfleet=8
                fleet(6)=makealienfleet
                fleet(6).c=basis(0).c
                fleet(7)=makealienfleet
                fleet(7).c=basis(1).c
                fleet(8)=makealienfleet
                fleet(8).c=basis(2).c
            endif

            if key=key_fi then
                for a=0 to 2
                    if player.c.x=basis(a).c.x and player.c.y=basis(a).c.y then
                        if askyn( "Do you really want to attack Spacestation-"& a+1 &")(y/n)") then
                            fl=0
                            factionadd(0,fleet(a+1).ty,20)
                            playerfightfleet(a+1)
                            if player.dead=0 then
                                if fleet(a+1).mem(1).hull<=0 then
                                    dprint "Station "&a+1 &" has been destroyed"
                                    basis(a).c.x=-1
                                    fleet(a).c.x=-1
                                endif
                            endif
                        else
                            fl=0
                        endif
                    endif
                next
                if _testspacecombat=1 then fl=rnd_range(4,lastfleet)
                if fl>0 then
                    factionadd(0,fleet(fl).ty,20)

                    playerfightfleet(fl)
                endif
            endif

            if key=key_walk then
                key=keyin
                walking=getdirection(key)
            endif

            if artflag(25)>0 and key=key_te then
                wormhole_travel
            endif

            if key=key_ra then space_radio

            if key=key_drop then launch_probe

            if key=key_la or key=key_tala or key=key_sc then
                pl=-1
                for a=0 to laststar
                    if player.c.x=map(a).c.x and player.c.y=map(a).c.y then pl=a
                next

                if pl>-1 then
                    if key=key_la or key=key_tala then
                        a=getplanet(pl)
                        if a>0 then
                            b=map(pl).planets(a)
                            if isgasgiant(b)=0 and b>0 then
                                if key=key_la then landing(map(pl).planets(a))
                                if key=key_tala then target_landing(map(pl).planets(a))
                            else
                                if isgasgiant(b)=0 then
                                    dprint"You don't find anything big enough to land on"
                                else
                                    gasgiant_fueling(b,a,pl)
                                endif
                            endif
                        endif
                    endif
                    if key=key_sc then scanning()
                    key=""
                endif
                pl=-1

                if key=key_sc and abs(spacemap(player.c.x,player.c.y))>=6 and abs(spacemap(player.c.x,player.c.y))<=10 then
                    if askyn("Do you want to scan the anomaly?(y/n)") then
                        if rnd_range(1,100)=1 then player.cursed+=1
                        if skill_test(player.science(0),st_easy+abs(spacemap(player.c.x,player.c.y)),"Science officer") then
                            dprint "You succesfully identified the anomaly!",c_gre
                            dprint gainxp(4),c_gre
                            ano_money+=abs(spacemap(player.c.y,player.c.y))/2
                            spacemap(player.c.x,player.c.y)=abs(spacemap(player.c.x,player.c.y))+10
                            select case spacemap(player.c.x,player.c.y)
                            case is=16
                                dprint "This anomaly shortens space, slightly reducing fuel consumption when travelling through it."
                            case is=17
                                dprint "This anomaly lengthens space, slightly increasing fuel consumption when travelling through it."
                            case is=18
                                dprint "This anomaly shortens space, slightly reducing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            case is=19
                                dprint "This anomaly lengthens space, slightly increasing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            case is=20
                                dprint "This anomaly can damage a ship and is highly unpredictable."
                            end select
                        else
                            dprint "You are unable to identify the anomaly.",c_yel
                        endif
                    endif
                endif

                if key=key_la then wormhole_travel()
            endif

            if key=key_dock then
                for a=0 to 3
                    if player.c.x=basis(a).c.x and player.c.y=basis(a).c.y then
                        if stationroll=0 or player.lastvisit.s<>a then stationroll=rnd_range(1,20)
                        if faction(0).war(1)+stationroll<100 then
                            b=rnd_range(1,4)
                            if faction(0).war(1)>80 then
                                dprint "You have to beg to get a docking permission, exagerating the sorry state of your ship quite a bit in the process!",14
                                b=15
                            endif
                            if faction(0).war(1)>33 then
                                if b=1 then dprint "After an unusually long waiting period you get your permission to dock.",14
                                if b=2 then dprint "The Station commander questions you extensively about your activities before allowing you to dock.",14
                            endif
                            if faction(0).war(1)>66 then
                                if b=1 then dprint "After you dock you overhear a dock worker remark 'I didn't know we were allowing known pirates on the base.' He looks at you fully aware that you heard him.",14
                                if b=2 then dprint "A patrol boat captain bumps into you snarling 'Pirate scum. Wait till i meet you in space!'",14
                            endif
                            player=spacestation(a)
                            key=""
                            if configflag(con_autosave)=0 and player.dead=0 then
                                screenset 1,1
                                dprint "Saving game",15
                                savegame()
                            endif
                            set__color( 11,0)
                            c=0
                            d=0
                            for b=0 to 10
                                if player.cargo(b).x>1 and player.cargo(b).x<7 then
                                    c=c+basis(a).inv(player.cargo(b).x-1).p
                                endif
                            next
                            c=c\15
                            'dprint "pirate chance:" &c
                            if c>66 then c=66
                            ' Pirate agression test
                            for b=0 to 10
                                if player.cargo(b).x=7 then
                                    c=101
                                    d=1
                                endif
                            next
                            if basis(a).spy=1 then c=0
                            for b=3 to lastfleet
                                if fleet(b).ty=2 and rnd_range(1,100)<c then
                                    fleet(b).t=8
                                    d=1
                                else
                                    fleet(b).t=9
                                endif
                            next
                            'see if pirates notice
                            if d=1 then
                                dprint "As you load your Cargo you notice a worker taking notes. When you want to question him he is gone.",c_yel
                            endif
                            if player.money<0 and player.dead=0 then
                                if skill_test(player.pilot(0),st_hard) then
                                    dprint "As you leave the docking bay you get a message from the station commander to return to 'solve some financial issues' first. Your pilot grins and heads for the docking bay doors, exceeding savety limits. The doors slam close right behind your ship. As you speed into space you get a radio message from the commander. He calmly explains that there *will* be a fee for that next time you dock.",c_yel
                                    player.money=player.money-100
                                    faction(0).war(2)-=1
                                    faction(0).war(1)+=1
                                else
                                    player.dead=2
                                endif
                            endif
                        else
                            dprint "The station commander closes the bay doors and fires upon you!",12
                            player.hull=player.hull-rnd_range(1,6)
                            if player.hull<=0 then player.dead=18
                            no_key=keyin
                        endif
                    endif
                next
                screenset 1,1
                display_stars(1)
            endif

            if key=key_dock then
                for a=1 to lastdrifting
                    if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 then dock_drifting_ship(a)
                next
            endif

            if key=key_tow then
                if player.towed=0 then
                    for a=4 to lastdrifting
                        if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 then
                            if player.tractor>0 then
                                player.towed=a
                                dprint "You tow the other ship."
                            else
                                dprint "You have no tractor beam.",14
                            endif
                        endif
                    next
                else
                    player.towed=0
                    dprint "You release the other ship."
                endif
            endif

            if key=key_awayteam then showteam(0)


            screenset 0,1
            set__color(11,0)
            cls

            display_stars(1)
            display_ship(1)
            dprint ""



        endif

        clearfleetlist

        if lturn=0 then
            if frac(player.turn/10)=0 then
                set_fleet(make_fleet)
                for a=0 to 2
                    change_prices(a,10)
                next
            endif

            if frac(player.turn/250)=0 then
                if rnd_range(1,100)<50 then
                    set_fleet(makecivfleet(0))
                else
                    set_fleet(makecivfleet(1))
                endif
            endif

            if frac(player.turn/100)=0 and player.turn>5000 and player.questflag(3)=0 then
                set_fleet(makealienfleet)
            endif

            if player.turn mod 100=0 then
                for a=1 to lastquestguy
                    if rnd_range(1,100)<25 and questguy(a).job=9 then questguy_newloc(a)
                    if rnd_range(1,100)<25 and questguy(a).job<>1 then questguy_newloc(a)
                    if questguy(a).want.type=qt_travel then
                        questguy(a).location=questguy(a).flag(12)
                        questguy(a).want.given=1
                    endif
                    if questguy(a).want.given=1 then questguy(a).want.type=0
                    if questguy(a).has.given=1 then questguy(a).has.type=0
                    if questguy(a).has.type=0 or questguy(a).want.type=0 and rnd_range(1,100)<10 then
                        questguy_newquest(a)
                    endif
                next
            endif
            move_fleets()
            collide_fleets()
            move_probes()

            for a=0 to 2
                if fleet(a).mem(1).hull<128 and fleet(a).mem(1).hull>0 then fleet(a).mem(1).hull+=3
            next

            diseaserun(0)
            if frac(player.turn/5)=0 then cureawayteam(1)
            if frac(player.turn/250)=0 then reroll_shops
        endif

        if player.hull<=0 and player.dead=0 then player.dead=18
        if player.fuel<=0 and player.dead=0 then rescue()

        if key=key_save then
            if askyn("Do you really want to save the game? (y/n)") then player.dead=savegame()
        endif

        if key=key_rename then
            if askyn("Do you want to rename your ship? (y/n)") then
                screenset 1,1
                set__color( 15,0)
                draw_string(sidebar+(1+len(trim(player.h_sdesc)))*_fw2 ,0, space(25),font2,_col)
                key=gettext(sidebar+(1+len(trim(player.h_sdesc)))*_fw2,1,32,"",1)
                if key<>"" then player.desig=key
                set__color( 11,0)
                player.turn=player.turn-1
            endif
        endif

        if key=key_comment then 'Name or comment on map
            p2.x=player.c.x'-player.osx
            p2.y=player.c.y'-player.osy

            osx=player.osx
            osy=player.osy
            do

                player.osx=p2.x-_mwx/2
                player.osy=p2.y-10
                if player.osx<=0 then player.osx=0
                if player.osy<=0 then player.osy=0
                if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
                if player.osy>=sm_y-20 then player.osy=sm_y-20
                osx=player.osx
                osy=player.osy
                screenset 0,1
                cls
                display_stars(2)
                display_ship(1)
                dprint ""
                flip
                key=cursor(p2,0,osx,osy)


            loop until key=key__esc or key=key__enter or (asc(ucase(key))>64 and asc(key)<132)
            set__color( 11,0)

            b=0
            if key<>key__esc then
                for a=1 to lastcom
                    if p2.y=coms(a).c.y then
                        if p2.x>=coms(a).c.x and p2.x<=coms(a).c.x+coms(a).l then
                                key=trim(coms(a).t)
                                b=a
                                p2.x=coms(a).c.x
                                p2.y=coms(a).c.y
                        endif
                     endif
                next
                screenset 0,1
                cls
                display_stars(2)
                display_ship(1)
                dprint ""
                flip
                screenset 1,1
                if asc(key)<65 or asc(key)>122 then key=""
                text=gettext((p2.x-osx)*_fw1,(p2.y-osy)*_fh1,16,key,1)
                text=trim(text)
                set__color(11,0)
                cls
                display_stars(1)
                display_ship(1)
                if b=0 then
                    lastcom=lastcom+1
                    b=lastcom
                endif
                if p2.x*_tix+len(text)*_fw2>sm_x*_tix then p2.x=cint((sm_x*_tix-len(text)*_fw2)/_tix)
                coms(b).c.x=p2.x
                coms(b).c.y=p2.y
                coms(b).t=text
                coms(b).l=len(text)
            endif
            b=0
            for a=1 to lastcom
                if coms(a).t="" then
                    coms(a)=coms(a+1)
                else
                    b=b+1
                endif
            next
            set__color(11,0)
            cls
            lastcom=b
            display_stars(1)
            display_ship(1)
        endif

        if player.turn mod 20=0 then
            clean_station_event
            questroll=rnd_range(1,100)-10*(crew(1).talents(3))
        endif


        if player.turn mod 10=0 then
            if player.tractor>0 then
                if player.towed>0 and not(skill_test(player.pilot(0),st_easy-player.tractor)) then
                    dprint "Your tractor beam breaks down",14
                    for a=0 to 25
                        if player.weapons(a).rof<0 then 
                            player.weapons(a)=makeweapon(0)
                            exit for
                        endif

                    next
                    player.towed=0
                endif
            endif        
        endif


        if frac(player.turn/500)=0 then
            for a=0 to 2
                colonize_planet(a)
            next
            grow_colonies
            if rnd_range(1,100)<player.turn/1000 then robot_invasion
        endif

        for a=0 to laststar
            if map(a).planets(1)>0 then
                if planets(map(a).planets(1)).flags(27)=2 then
                    planets(map(a).planets(1)).death-=1
                    if planets(map(a).planets(1)).death<=0 then
                        map(a).planets(1)=0
                    endif
                endif
            endif
        next

        if make_files=1 and frac(player.turn/10)=0 then
            f=freefile
            open "fleets.txt" for append as #f
            print #f,player.turn
            for a=1 to lastfleet
                print #f,a;" ";fleet(a).ty;" ";debug_printfleet(fleet(a))
            next
            close #f
        endif


        for a=0 to 7
            for b=0 to 7
                if faction(a).war(b)>100 then faction(a).war(b)=100
                if faction(a).war(b)<0 then faction(a).war(b)=0
            next
        next

        for a=0 to 7
            if faction(a).alli<>0 then
                for b=0 to 7
                    faction(a).war(b)=(faction(a).war(b)+faction(faction(a).alli).war(b))/2
                next

            endif
        next

        driftercom=0
        planetcom=0
        fleetcom=0
        wormcom=0


    loop until player.dead>0

    return 0
end function



function explore_planet(from as _cords, orbit as short) as _cords
    dim as single a,b,c,d,e,f,g,x,y,sf,sf2,vismod

    dim as short slot,r,deadcounter,ship_landing,loadmonsters,allroll(7),osx
    dim as single dawn,dawn2
    dim as string key,dkey,allowed,text,help
    dim dam as single
    dim as _cords p,p1,p2,p3,nextlanding,old,nextmap
    dim towed as _ship
    dim as short skill
    dim mapmask(60,20) as byte
    dim nightday(60) as byte
    dim watermap(60,20) as byte
    dim localtemp(60,20) as single
    dim cloudmap(60,20) as byte
    dim spawnmask(1281) as _cords
    dim lsp as short
    dim ti as short

    bg_parent=bg_awayteamtxt
    'dim localitem(128) as items
    dim li(256) as short
    dim lastlocalitem as short
    dim diesize as short
    dim localturn as short
    dim tb as single
    'dim oxydep as single
    dim lavapoint(5) as _cords
    dim shipfire(16) as _shipfire
    dim areaeffect(16) as _ae
    dim autofire_dir as short
    dim autofire_target as _cords
    dim last_ae as short
    dim del_rec as _rect

    dim as short debug=0
'oob suchen
    for a=1 to 255
        enemy(a)=enemy(0)
    next
    lastenemy=0

    screenset 0,1
    set__color(11,0)
    cls
    flip
    set__color(11,0)
    cls
    if _Debug>0 then
        open "entered" for output as #1
        print #1,time
        close #1
    endif
    slot=from.m
    if _debug=1 then dprint "From:"&from.x &":"& from.y &":"& from.m
    planets(slot).mapstat=2
    deadcounter=0
    awayteam.c=from
    player.map=slot
    osx=calcosx(awayteam.c.x,slot)
    lsp=0
    location=lc_awayteam

    if _debug=11 then
        dprint "make weapons"
    endif

    for a=1 to 20
        if makew(a,1)<>0 then
            b+=1
            wsinv(b)=makeweapon(makew(a,1))
        endif
    next

    if _debug=11 then
        dprint "Made weapons anyhow"
    endif

    if _debug=11 then
        f=freefile
        open "tiles.txt" for output as #f
        print #f,"Hello!"
    endif

    osx=calcosx(awayteam.c.x,planets(slot).depth)

    for x=0 to 60
        for y=0 to 20
            if _debug=11 then print #f,planetmap(x,y,slot)
            if abs(planetmap(x,y,slot))=1 then watermap(x,y)=10
            if abs(planetmap(x,y,slot))=2 then watermap(x,y)=50
            if planets(slot).depth=0 then
                localtemp(x,y)=planets(slot).temp-abs(10-y)*5+10
            else
                localtemp(x,y)=planets(slot).temp
            endif
            if show_all=1 and planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-planetmap(x,y,slot)
            if abs(planetmap(x,y,slot))>512 then
                dprint "ERROR: Tile #"&planetmap(x,y,slot)&"out ofbounds"
                planetmap(x,y,slot)=512
            endif
            tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
            if tmap(x,y).ti_no=2505 then 'Ship walls
                if rnd_range(1,100)<33 then
                    tmap(x,y).ti_no=2504+rnd_range(1,4)
                endif
            endif
            if abs(planetmap(x,y,slot))=267 then
                enemy(0)=makemonster(1,slot)
                tmap(x,y).desc="A cage. Inside is "&first_lc(enemy(0).ldesc)
                enemy(0)=enemy(1) 'Delete monster
            endif
            mapmask(x,y)=0
            if tmap(x,y).walktru=0 then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            endif
            if tmap(x,y).vege>0 then
                tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                if rnd_range(1,100)<tmap(x,y).vege/2 then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
            endif
            if rnd_range(1,100)<planets(slot).atmos and planets(slot).atmos>1 and planets(slot).depth=0 then cloudmap(x,y)=1
            if planetmap(x,y,slot)=0 then
                f=freefile
                open "error.log" for append as #f
                print #f,"Tile at "&x &":"&y &":"&slot &"=0"
                close #f
                planetmap(x,y,slot)=-4
            endif
        next
    next


    if _debug=11 then
        close #f
        dprint "Made tmap"
        sleep
    endif

    'allowed="12346789ULXFSQRWGCHDO"&key_pickup &key__i
    allowed=key_awayteam &key_ju & key_te & key_fi &key_save &key_quit &key_ra &key_walk & key_gr & key_he _
     & key_la & key_pickup & key_inspect & key_ex & key_of & key_co & key_drop & key_gr & key_wait _
     & key_portal &key_oxy &key_close & key_report &key_autofire &key_autoexplore
    comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"_
     & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"_
     & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"

    if rev_map=1 then allowed=allowed &"ä"
    if awayteam.movetype=2 or awayteam.movetype=3 then
        allowed=allowed &key_ju
        comstr.t=comstr.t &key_ju &" Jetpackjump;"
    endif
    if artflag(9)=1 then
        allowed=allowed &key_te
        comstr.t=comstr.t &key_te &" Teleport;"
    endif

    if planets(slot).atmos=0 then planets(slot).atmos=1
    if planets(slot).grav=0 then planets(slot).grav=.5

    if planets(slot).atmos>=3 and planets(slot).atmos<=6 then
        awayteam.helmet=0
        awayteam.oxygen=awayteam.oxymax
    else
        awayteam.helmet=1
    endif

    b=0
    for a=1 to 15 'Look for saved status on this planet
        if savefrom(a).map=slot then
            lastenemy=savefrom(a).lastenemy
            for b=1 to lastenemy
                enemy(b)=savefrom(a).enemy(b)
            next
            loadmonsters=1
        endif
    next

    if _debug=11 then
        dprint "Loadmonsters:" &loadmonsters
        sleep
    endif
    if loadmonsters=0 then 'No saved status, monsters need to be generated
        c=0
        for a=0 to 16
            if planets(slot).mon_noamin(a)>0 and planets(slot).mon_noamax(a)>0 then
                if planets(slot).mon_template(a).made=0 then planets(slot).mon_template(a)=makemonster(1,slot)
                for d=1 to rnd_range(planets(slot).mon_noamin(a),planets(slot).mon_noamax(a))
                    c+=1
                    enemy(c)=setmonster(planets(slot).mon_template(a),slot,spawnmask(),lsp,,,c,1)
                    enemy(c).slot=a
                    enemy(c).no=c
                    if enemy(c).faction=0 then enemy(c).faction=8+a
                    if enemy(c).faction<8 then
                        if allroll(enemy(c).faction)=0 then allroll(enemy(c).faction)=rnd_range(1,100)
                        if faction(0).war(enemy(c).faction)>=allroll(enemy(c).faction) then
                            enemy(c).aggr=0
                        else
                            enemy(c).aggr=1
                        endif
                    endif
                next
            endif
        next
        lastenemy=c

        x=0
        for a=0 to lastspecial
            if specialplanet(a)=slot then x=1
        next
        for a=0 to _NoPB
            if pirateplanet(a)=slot then x=1
        next
        for a=1 to lastdrifting
            if drifting(a).m=slot then x=1
        next

        if planets(slot).visited=0 and planets(slot).depth=0 and x=0 then
            combon(0).value+=1
            adaptmap(slot)
            lsp=0
            for x=0 to 60
                for y=0 to 20
                    if abs(planetmap(x,y,slot))=1 then watermap(x,y)=10
                    if abs(planetmap(x,y,slot))=2 then watermap(x,y)=50
                    localtemp(x,y)=planets(slot).temp-abs(10-y)*5+10
                    if show_all=1 and planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-planetmap(x,y,slot)
                    tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
                    if abs(planetmap(x,y,slot))=267 then tmap(x,y).desc="A cage. Inside is "&makemonster(1,slot).ldesc
                    mapmask(x,y)=0
                    if tmap(x,y).walktru=0 then
                        lsp=lsp+1
                        spawnmask(lsp).x=x
                        spawnmask(lsp).y=y
                    endif
                    if tmap(x,y).vege>0 then
                        tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                        if rnd_range(1,100)<tmap(x,y).vege/2 then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
                    endif
                next
            next

            if rnd_range(1,100)<5 and rnd_range(1,100)<disnbase(player.c) and lastenemy>10 and planets(slot).atmos>1 then
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(46,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).slot=16
                enemy(lastenemy).no=lastenemy
                if rnd_range(1,100)<disnbase(player.c)*2 then placeitem(makeitem(81),enemy(lastenemy).c.x,enemy(lastenemy).c.y,slot)
            endif
            if rnd_range(1,100)<26-disnbase(player.c) then 'deadawayteam
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).hpmax=55
                enemy(lastenemy).slot=16
                if show_all=1 then dprint "corpse at "&enemy(lastenemy).c.x & enemy(lastenemy).c.y
            endif
            if rnd_range(1,100)<26-distance(player.c,civ(0).home) then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(0).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            endif
            if rnd_range(1,100)<26-distance(player.c,civ(1).home) then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(1).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            endif
        endif
        if slot=pirateplanet(0) then
            for x=0 to 60
                for y=0 to 20
                    if abs(planetmap(p.x,p.y,slot))=246 then
                        changetile(p.x,p.y,slot,68)
                        tmap(p.x,p.y)=tiles(68)
                    endif
                next
            next
            if rnd_range(1,100)<25 then
                do
                    p=rnd_point(slot,,68)
                loop until tmap(p.x,p.y).gives=0
                planetmap(p.x,p.y,slot)=-246
                tmap(p.x,p.y)=tiles(246)
            endif
        endif

        for c=0 to 8
        b=(planets(slot).vault(c).h-2)*((planets(slot).vault(c).w-2))
        if b>4 or planets(slot).vault(c).wd(5)=4 then
            if debug=1 and _debug=1 then dprint "Making vault at "&planets(slot).vault(c).x &":"& planets(slot).vault(c).y &":"& planets(slot).vault(c).w &":"& planets(slot).vault(c).h
            if planets(slot).vault(c).wd(16)=99 then specialflag(15)=1
            if planets(slot).vault(c).wd(5)=1 then
                if b>9 then
                    lastenemy=lastenemy-rnd_range(1,6)
                    if lastenemy<1 then lastenemy=1
                    a=lastenemy+1
                    for x=planets(slot).vault(c).x+1 to planets(slot).vault(c).x+planets(slot).vault(c).w-1
                        for y=planets(slot).vault(c).y+1 to planets(slot).vault(c).y+planets(slot).vault(c).h-1
                            if a>255 then a=255
                            enemy(a)=makemonster(9,slot)
                            enemy(a)=setmonster(enemy(a),slot,spawnmask(),lsp,x,y,a,1)
                            a=a+1
                        next
                    next
                    lastenemy=a
                    if lastenemy>255 then lastenemy=255
                endif
            endif

            if planets(slot).vault(c).wd(5)=2 and planets(slot).vault(c).wd(6)<>0 then
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                if debug=1 and _debug=1 then dprint "lastenemy"&lastenemy
                lastenemy=lastenemy+b
                for e=d to lastenemy
                    text=text &d
                    do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    loop until tmap(x,y).walktru=0
                    if debug=1 and _debug=1 then dprint "Set monster at "&x &":"&y
                    if planets(slot).vault(c).wd(6)>0 then
                        enemy(e)=makemonster(planets(slot).vault(c).wd(6),slot)
                        enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,d)
                    else
                        enemy(e)=setmonster(planets(slot).mon_template(-planets(slot).vault(c).wd(6)),slot,spawnmask(),lsp,x,y,e)
                        if debug=1 and _debug=1 then dprint "Enemy "&e &" is at "&enemy(e).c.x &":"&enemy(e).c.y
                    endif
                next
                if debug=1 and _debug=1 then dprint "lastenemy"&lastenemy
            endif

            if planets(slot).vault(c).wd(5)=3 then
                if debug=1 and _debug=1 then dprint "lastenemy"&lastenemy
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                lastenemy=lastenemy+b
                for e=d to lastenemy
                    do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    loop until tmap(x,y).walktru=0
                    if debug=1 and _debug=1 then dprint "Set monster at "&x &":"&y
                    enemy(e)=makemonster(59,slot)
                    enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,e,1)
                next
                if debug=1 and _debug=1 then dprint "lastenemy"&lastenemy
            endif
            if planets(slot).vault(c).wd(5)=4 then
                for x=planets(slot).vault(c).x to planets(slot).vault(c).x+planets(slot).vault(c).w
                    for y=planets(slot).vault(c).y to planets(slot).vault(c).y+planets(slot).vault(c).h
                        if tmap(x,y).walktru=0 then
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(planets(slot).mon_template(abs(planets(slot).vault(c).wd(6))),slot,spawnmask(),lsp,x,y,lastenemy)
                        endif
                    next
                next

            endif
            planets(slot).vault(c)=del_rec
        endif
        next
    for a=0 to _NoPB
        if slot=pirateplanet(a) then
            c=5+rnd_range(1,6)
            for b=lastenemy to lastenemy+c
                enemy(b)=makemonster(3,slot)
                enemy(b)=setmonster(enemy(b),slot,spawnmask(),lsp,,,b,1)
            next
            lastenemy=lastenemy+c
        endif
    next

endif


    if _debug=11 then
        dprint "Move rovers"
        sleep
    endif

    move_rover(slot,li(),lastlocalitem)
    'if planets(slot).colony<>0 then growcolony(slot)

    if planets(slot).visited>0 and planets(slot).visited<player.turn then
        b=planets(slot).visited-player.turn
        for e=1 to lastenemy
            if enemy(e).made=101 and enemy(e).hp>0 then
                for a=1 to b
                    p=rnd_point(slot,,,1)
                    if p.x>=0 then
                        changetile(p.x,p.y,slot,4)
                        tmap(p.x,p.y)=tiles(4)
                    endif
                next

            endif
        next

    endif

    planets(slot).discovered=3
    planets(slot).visited=player.turn
    if planets(slot).flags(27)=1 then planets(slot).flags(27)=2

    if slot=specialplanet(0) and player.towed=4 then
        dprint "The alien generation ship lands next to yours and the insects start exploring and setting up their colony immediately."
        p=movepoint(player.landed,5)
        'questflag(0)=1
        player.towed=0
        planetmap(p.x,p.y,slot)=269
        tmap(p.x,p.y)=tiles(269)
        drifting(4).x=-1 'Move drifting off the map (Can't delete it, since then another ship could get generated there and would trigger the event
        planets(slot).mon_template(1)=makemonster(80,slot)
        planets(slot).mon_noamin(1)=10
        planets(slot).mon_noamax(1)=14
        planets(slot).mon_template(2)=makemonster(25,slot)
        planets(slot).mon_noamin(2)=10
        planets(slot).mon_noamax(2)=14
    endif


    if slot=specialplanet(1) and specialflag(1)=0 then 'apollos planet
        player.landed=rnd_point
        player.landed.m=slot
    endif

    if slot=specialplanet(2) then
        if specialflag(2)=0 then

            specialflag(2)=1
            dprint "As you enter the lower atmosphere a powerful energy beam strikes your ship from the surface below! A planetery defense system has detected you!"
            a=menu(bg_parent,"Flee into:/Space/Below horizon")
            if a=1 then
                if skill_test(player.pilot(location),st_veryhard,"Pilot") then
                    if skill_test(player.pilot(location),st_veryhard,"Pilot") then
                        if skill_test(player.pilot(location),st_veryhard,"Pilot") then
                            nextmap.m=-1
                            return nextmap
                        endif
                    endif
                endif
            endif
            dprint "You are already too low to escape into orbit, so the only way to avoid total destruction is an emergency landing! Your vessel slams into the surface!",15
            if not(skill_test(player.pilot(location),st_veryhard,"Pilot")) then player.hull=player.hull-rnd_range(1,6)
            if player.hull<=0 then
                planetmap(player.landed.x,player.landed.y,slot)=127+player.h_no
                tmap(player.landed.x,player.landed.y)=tiles(127+player.h_no)
                player.landed.m=0
            endif
            for a=0 to rnd_range(1,6) +rnd_range(1,6)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy).hp=-1
            next
        endif
        if specialflag(2)=2 then
            for x=0 to 60
                for y=0 to 20
                    if planetmap(x,y,slot)=-168 then planetmap(x,y,slot)=-169
                    if planetmap(x,y,slot)=168 then planetmap(x,y,slot)=169
                    if abs(planetmap(x,y,slot))=169 then tmap(x,y)=tiles(169)
                next
            next
        endif
    endif

    if specialplanet(8)=slot then 'stormy,less critters
        lastenemy=lastenemy-rnd_range(1,5)
        if lastenemy<0 then lastenemy=0
    endif

    if specialplanet(11)=slot then lastenemy=0 'No critters on dying world

    if specialplanet(15)=slot then
        for a=1 to lastenemy
            for b=1 to lastenemy
            if b<>a then
                if enemy(1).lang=6 then
                    if enemy(b).lang=7 then enemy(a).flags(b)=1
                else
                    if enemy(b).lang=6 then enemy(a).flags(b)=1
                endif
            endif
            next
        next
    endif

    if planets(slot).flags(25)<>0 or specialplanet(40)=slot then
        for x=0 to 60
            for y=0 to 20
                tmap(x,y).disease=13
            next
        next
        if planets(slot).flags(25)=2 then
            awayteam.helmet=1
        else
           planets(slot).mapmod=0
        endif
    endif
    '
    '   loaded game in savefrom
    '
    '    This only if savegame
    '
    if savefrom(0).map>0 then
        awayteam=savefrom(0).awayteam
        player.landed=savefrom(0).ship
        slot=savefrom(0).map
        lastenemy=savefrom(0).lastenemy
        for b=1 to lastenemy
            enemy(b)=savefrom(0).enemy(b)
        next
        equip_awayteam(slot)
        savefrom(0)=savefrom(16)
    endif
    equip_awayteam(slot)

    c=0
    for a=0 to lastitem
        if item(a).ty=47 and item(a).w.m=slot and item(a).w.s=0 then
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(15,slot)
            enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
            enemy(lastenemy).hp=-1
            enemy(lastenemy).hpmax=55
            enemy(lastenemy).slot=16
        endif
    next
    lastlocalitem=make_localitemlist(li(),slot)

    lsp=0
    for x=0 to 60
        for y=0 to 20
            mapmask(x,y)=0
            if tmap(x,y).walktru=0 then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            endif
        next
    next

    if slot=specialplanet(16) then
        if findbest(24,-1)>0 then
            for a=1 to lastenemy
                enemy(a).aggr=0
            next
        else
            for a=1 to lastenemy
                enemy(a).aggr=1
            next
        endif
    endif

    if slot=specialplanet(37) then
        p.x=25
        p.y=5
        invisiblelabyrinth(tmap(),p.x,p.y)
    endif

    if alien_scanner=1 then player.stuff(3)=2

    'outpost trading
    for a=11 to 13
        planets(slot).flags(a)=planets(slot).flags(a)+rnd_range(1,6) +rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6)
        if planets(slot).flags(a)<0 then planets(slot).flags(a)+=1
        if planets(slot).flags(a)>0 then planets(slot).flags(a)-=1
        if planets(slot).flags(a)<-3 then planets(slot).flags(a)=-3
        if planets(slot).flags(a)>3 then planets(slot).flags(a)=3
        if planets(slot).flags(a)>0 then planets(slot).flags(a)-=1
        if planets(slot).flags(a)<0 then planets(slot).flags(a)+=1
    next

    if rnd_range(1,100)<33 then flag(14)=rnd_range(8,20)
    if rnd_range(1,100)<33 then planets(slot).flags(15)=1
    if rnd_range(1,100)<33 then planets(slot).flags(16)=2
    if rnd_range(1,100)<33 then planets(slot).flags(17)=3
    if rnd_range(1,100)<33 then planets(slot).flags(18)=4
    if rnd_range(1,100)<33 then planets(slot).flags(19)=5
    if rnd_range(1,100)<33 then planets(slot).flags(20)=11


    if awayteam.c.x<0 then awayteam.c.x=0
    if awayteam.c.y<0 then awayteam.c.y=0
    if awayteam.c.x>60 then awayteam.c.x=60
    if awayteam.c.y>20 then awayteam.c.y=20

    cls
    display_planetmap(slot,osx,0)
    ep_display (li(),lastlocalitem)
    display_awayteam()
    dprint ""
    '
    ' EXPLORE PLANET
    '

    dawn=rnd_range(1,60)

    if _debug=11 then
        dprint "moving enemies"
        sleep
    endif
    do
        b=0
        for a=1 to lastenemy
            if enemy(a).c.x=awayteam.c.x and enemy(a).c.y=enemy(a).c.y then
                enemy(a).c=movepoint(enemy(a).c,5)
                b=1
            endif
        next
    loop until b=0

    if debug=99 and _debug=1 then dprint "Death in:" &planets(slot).death &"(in)"

    if planets_flavortext(slot)<>"" then
        dprint planets_flavortext(slot),15
        no_key=keyin
    endif
    if slot=specialplanet(1) and specialflag(1)=0 then dodialog(2,enemy(1),0)
    if no_enemys=1 then lastenemy=0

    if _debug=11 then
        dprint "Setting screen"
        sleep
    endif
    screenset 0,1
    set__color(11,0)
    cls
    display_planetmap(slot,osx,0)
    ep_display (li(),lastlocalitem)
    display_awayteam()
    flip
    set__color(11,0)
    cls
    display_planetmap(slot,osx,0)
    ep_display (li(),lastlocalitem)
    display_awayteam()
    flip


    '***********************
    '
    'Planet Exploration Loop
    '
    '***********************

    do
        if show_all=1 then
            set__color( 15,0)
            locate 21,1
            print awayteam.disease;":";player.disease;":";planets(slot).visited;":";slot;"Temp:";localtemp(awayteam.c.x,awayteam.c.y)
        endif
        'dprint "Death"&planets(slot).death
        awayteam.dark=planets(slot).darkness+nightday(awayteam.c.x)
        if artflag(9)=1 and  player.teleportload<15 then player.teleportload+=1
        if awayteam.disease>player.disease then player.disease=awayteam.disease
        if planets(slot).atmos<=1 or planets(slot).atmos>=7 then awayteam.helmet=1
        if (tmap(awayteam.c.x,awayteam.c.y).no=1 or tmap(awayteam.c.x,awayteam.c.y).no=26 or tmap(awayteam.c.x,awayteam.c.y).no=20) and awayteam.hp<=awayteam.nohp*5 then awayteam.oxygen=awayteam.oxygen+tmap(awayteam.c.x,awayteam.c.y).oxyuse
        if tmap(awayteam.c.x,awayteam.c.y).oxyuse<0 then awayteam.oxygen=awayteam.oxygen-tmap(awayteam.c.x,awayteam.c.y).oxyuse
        if awayteam.oxygen>awayteam.oxymax then awayteam.oxygen=awayteam.oxymax

        adislastenemy=lastenemy
        adisloctemp=localtemp(awayteam.c.x,awayteam.c.y)
        adisloctime=nightday(awayteam.c.x)

        if configflag(con_warnings)=0 and nightday(awayteam.c.x)=1 and nightday(old.x)<>1 then dprint "The sun rises"
        if configflag(con_warnings)=0 and nightday(awayteam.c.x)=2 and nightday(old.x)<>2 then dprint "The sun sets"

        lsp=ep_updatemasks(spawnmask(),mapmask(),nightday(),dawn,dawn2)
        mapmask(awayteam.c.x,awayteam.c.y)=-9
        
        com_sinkheat(player,0)
            
        localturn=localturn+1

        if localturn mod 10=0 then
            ep_tileeffects(areaeffect(),last_ae,lavapoint(),nightday(),localtemp(),cloudmap())
            ep_lava(lavapoint())
            lastenemy=ep_spawning(spawnmask(),lsp,diesize,nightday())
            ep_shipfire(shipfire())
            ep_items(li(),lastlocalitem,localturn)
            walking=alerts()
            screenset 0,1
            set__color(11,0)
            cls
            display_planetmap(slot,osx,0)
            ep_display (li(),lastlocalitem)
            display_awayteam()
            ep_display_clouds(cloudmap())

            dprint("")
            flip
        endif
        
        deadcounter=ep_monstermove(li(),lastlocalitem,spawnmask(),lsp,mapmask(),nightday())

        if player.dead>0 or awayteam.hp<=0 then allowed=""

        if ship_landing>0 and nextmap.m<>0 then ship_landing=1 'Lands immediately if you changed maps
        if ship_landing>0 then ep_landship(ship_landing, nextlanding, nextmap)
        
        if  tmap(awayteam.c.x,awayteam.c.y).resources>0 or planetmap(awayteam.c.x,awayteam.c.y,slot)=17 or  (tmap(awayteam.c.x,awayteam.c.y).no>2 and tmap(awayteam.c.x,awayteam.c.y).gives>0 and player.dead=0 and (awayteam.c.x<>old.x or awayteam.c.y<>old.y))  then
            old=awayteam.c
            osx=calcosx(awayteam.c.x,planets(slot).depth)
            screenset 0,1
            set__color(11,0)
            cls
            display_planetmap(slot,osx,0)
            ep_display (li(),lastlocalitem)
            ep_display_clouds(cloudmap())
            display_awayteam()
            dprint ("")

            ep_gives(awayteam,nextmap,shipfire(),li(),lastlocalitem,spawnmask(),lsp,key,localtemp(awayteam.c.x,awayteam.c.y))
            equip_awayteam(slot)
            if awayteam.movetype=2 or awayteam.movetype=3 then allowed=allowed &key_ju
            if awayteam.movetype=4 then allowed=allowed &key_te
            'displayplanetmap(slot,awayteam.c.x-_mwx/2)
            'ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,walking)
            'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x))
            flip
            set__color(11,0)
            cls
            display_planetmap(slot,osx,0)
            ep_display (li(),lastlocalitem)
            display_awayteam()
            ep_display_clouds(cloudmap())

            dprint("")
            walking=0
        endif

        if (player.dead=0 and awayteam.e.tick=-1) then

            screenset 0,1
            set__color(11,0)
            cls
            display_planetmap(slot,osx,0)
            ep_display (li(),lastlocalitem)
            display_awayteam()
            ep_display_clouds(cloudmap())
            dprint("")
            flip
            if nextmap.m=0 then key=(keyin(allowed,walking))
            if key="" then
                cls
                display_planetmap(slot,osx,0)
                ep_display (li(),lastlocalitem)
                display_awayteam()
                ep_display_clouds(cloudmap())
                dprint("")
                flip
            endif
            awayteam.oxygen=awayteam.oxygen-maximum(awayteam.oxydep*awayteam.helmet,tmap(awayteam.c.x,awayteam.c.y).oxyuse)
            if awayteam.oxygen<0 then dprint "Asphyixaction:"&damawayteam(rnd_range(1,awayteam.hp),1),12
            healawayteam(awayteam,0)

            old=awayteam.c
            if walking<>0 then
                if walking<0 then
                    tmap(awayteam.c.x,awayteam.c.y).hp-=1
                    awayteam.add_move_cost
                    for a=1 to _lines
                        if displaytext(a)="" then 
                            displaytext(a-1)&="."
                            exit for
                        endif
                    next
                    if tmap(awayteam.c.x,awayteam.c.y).hp=1 then
                        walking=0
                        dprint "Complete."
                        key=key_inspect
                    endif
                    dprint ""
                else
                    if walking<10 then
                        awayteam.c=movepoint(awayteam.c,walking)
                    endif
                    if walking=12 then
                        if currapwp=lastapwp then
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            lastapwp=ep_autoexplore(slot,li(),lastlocalitem)
                            currapwp=0
                        endif
                        if lastapwp>0 then
                            currapwp+=1
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            if awayteam.movetype>=tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).walktru or tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).onopen<>0 then
                                awayteam.c=apwaypoints(currapwp)
                                awayteam.c.m=old.m
                            else
                                walking=0
                            endif
                        else
                            walking=0
                        endif

                    endif
                endif
            else
                if rnd_range(1,100)<110+countdeadofficers(awayteam.hpmax) then
                    awayteam.c=movepoint(awayteam.c,getdirection(key),3)
                    if getdirection(key)<>0 then
                        key=""
                    endif
                else
                    dprint "Your security personel want to return to the ship.",14
                    if rnd_range(1,100)<66 then
                        awayteam.c=movepoint(awayteam.c,nearest(player.landed,awayteam.c))

                    else
                        awayteam.c=movepoint(awayteam.c,5)
                    endif
                endif
            endif
            ep_playerhitmonster(old,mapmask())
            ep_checkmove(old,key)
            if old.x<>awayteam.c.x or old.y<>awayteam.c.y or key=key_portal or key=key_inspect then nextmap=ep_Portal()
            ep_planeteffect(li(),lastlocalitem,shipfire(),sf,lavapoint(),localturn,cloudmap())
            ep_areaeffects(areaeffect(),last_ae,lavapoint(),li(),lastlocalitem,cloudmap())
            if old.x<>awayteam.c.x or old.y<>awayteam.c.y or key=key_pickup then ep_pickupitem(key,lastlocalitem,li())
            if key=key_inspect or _autoinspect=0 and (old.x<>awayteam.c.x or old.y<>awayteam.c.y) then ep_inspect(li(),lastlocalitem,localturn)

            if vacuum(awayteam.c.x,awayteam.c.y)=1 and awayteam.helmet=0 then ep_helmet()
            if vacuum(awayteam.c.x,awayteam.c.y)=0 and vacuum(old.x,old.y)=1 and awayteam.helmet=1 then ep_helmet
        'Display all stuff
            screenset 0,1
            set__color(11,0)
            cls

            osx=calcosx(awayteam.c.x,planets(slot).depth)

            display_planetmap(slot,osx,0)
            ep_display (li(),lastlocalitem)
            ep_display_clouds(cloudmap())
            display_awayteam()

            ep_atship()

            comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"
            comstr.t=comstr.t & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"
            comstr.t=comstr.t & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"
            if awayteam.movetype=2 or awayteam.movetype=3 then comstr.t=comstr.t &key_ju &" Jetpackjump;"
            if artflag(9)=1 then comstr.t=comstr.t &key_te &" Teleport;"

            set__color( 11,0)
            for x=0 to 60
                if x-osx>=0 and x-osx<=_mwx and nightday(x)=1 then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh2/2,chr(193),Font2,_tcol)
                if x-osx>=0 and x-osx<=_mwx and nightday(x)=2 then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh1/2,chr(193),Font2,_tcol)
            next
            dprint ""
            flip
            'screenset 1,1

            if rnd_range(1,100)<disease(awayteam.disease).nac then
                key=""
                dprint "ZZZZZZZZZZZzzzzzzzz",14
                awayteam.e.add_action(50)
            endif
            
            if key<>"" and walking>0 then walking=0
            
            if rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)

            if key=key_ex  then ep_examine(li(),lastlocalitem)

            if key=key_save then
                if askyn("Do you really want to save the game (y/n?)") then
                   savefrom(0).map=slot
                   savefrom(0).ship=player.landed
                   savefrom(0).awayteam=awayteam
                   savefrom(0).lastenemy=lastenemy
                   for a=1 to lastenemy
                       savefrom(0).enemy(a)=enemy(a)
                   next
                   savefrom(0).lastlocalitem=lastlocalitem
                   player.dead=savegame()
                   'ship.x=-1
                endif
            endif

            if key=key_wait then awayteam.add_move_cost

            if key=key_drop then
                ep_dropitem(li(),lastlocalitem)
            endif

            if key=key_awayteam then
                if awayteam.c.x=player.landed.x and awayteam.c.y=player.landed.y and slot=player.landed.m then
                    showteam(0)
                else
                    showteam(1)
                endif
            endif

            if key=key_report then bioreport(slot)

            if key=key_close then ep_closedoor()

            if key=key_gr then ep_grenade(shipfire(),sf,li(),lastlocalitem)

            if key=key_fi or key=key_autofire or walking=10 then ep_fire(mapmask(),key,autofire_target)

            if key=key_ra then ep_radio(nextlanding,ship_landing,li(),lastlocalitem,shipfire(),lavapoint(),sf,nightday(),localtemp())

            if key=key_oxy then ep_helmet()

            if key=key_ju and awayteam.movetype>=2 then ep_jumppackjump()

            if key=key_la then ep_launch(nextmap)

            if key=key_he then
                if awayteam.disease>0 then
                    cureawayteam(0)
                else
                    if configflag(con_chosebest)=0 then
                        c=findbest(11,-1)
                    else
                        c=get_item(11)
                    endif
                    if c>0 then
                        if item(c).ty<>11 then
                            dprint "you can't use that."
                        else
                            if askyn("Do you want to use the "&item(c).desig &"(y/n)?") then
                                item(c).v1=healawayteam(awayteam,item(c).v1)
                                if item(c).v1<=0 then destroyitem(c)
                            endif
                        endif
                    else
                        dprint "you dont have any medpacks"
                    endif
                endif
            endif

            if key=key_walk or key=key_autoexplore then
                if key<>key_autoexplore then
                    dprint "Direction? (0 for autoexplore)"
                    no_key=keyin
                    walking=getdirection(no_key)
                else
                    no_key="0"
                endif
                if no_key="0" then
                    lastapwp=ep_autoexplore(slot,li(),lastlocalitem)
                    currapwp=0
                    if lastapwp>-1 then
                        walking=12
                    else
                        dprint "All explored here."
                    endif
                endif
            endif

            if key=key_co or key=key_of then ep_communicateoffer(key,li(),lastlocalitem)

            if key=key_te and artflag(9)=1 then awayteam.c=teleport(awayteam.c,slot)

        else
            if player.dead<>0 then allowed=""
        endif



            if lastenemy>255 then lastenemy=255
            if lastlocalitem>255 then lastlocalitem=255

            'clean up item list
            for a=1 to lastlocalitem
                if item(li(a)).w.s<0 then
                    li(a)=li(lastlocalitem)
                    lastlocalitem=lastlocalitem-1
                else
                    if tmap(item(li(a)).w.x,item(li(a)).w.y).no>=175 and tmap(item(li(a)).w.x,item(li(a)).w.y).no<=177 then
                        destroyitem(li(a))
                        li(a)=li(lastlocalitem)
                        lastlocalitem=lastlocalitem-1
                    endif
                endif
            next
            if debug=99 and _debug=1 then dprint "Death in:"&planets(slot).death
            ' and the world moves on
            if frac(localturn/500)=0 then
                player.turn=player.turn+1
                for a=1 to lastplanet
                    if planets(a).flags(27)=2 then
                        planets(a).death-=1
                        if a=slot and planets(a).death<=0 then
                            if planets(a).flags(29)=0 then
                                player.dead=17
                            else
                                player.dead=34
                            endif
                        endif
                    endif
                next
                for a=0 to laststar
                    if map(a).planets(1)>0 then
                        if planets(map(a).planets(1)).flags(27)=2 and planets(map(a).planets(1)).death<=0 then
                            map(a).planets(1)=0
                        endif
                    endif
                next

                diseaserun(1)
                equip_awayteam(slot)
                move_fleets()
                if frac(player.turn/250)=0 then reroll_shops
            endif
            if _debug=2709 then dprint "NM:"&nextmap.m
    loop until awayteam.hp<=0 or nextmap.m<>0 or player.dead<>0

    '
    ' END exploring

    location=lc_onship

    for a=1 to lastlocalitem
        if item(li(a)).ty=45 and item(li(a)).w.p<9999 and item(li(a)).w.s=0 then 'Alien bomb
            if item(li(a)).v2=1 then
                p1.x=item(li(a)).w.x
                p1.y=item(li(a)).w.y
                item(li(a)).w.p=9999
                alienbomb(li(a),slot,li(),lastlocalitem)

            endif
        endif
    next

    for a=0 to lastitem
        if item(a).w.p=9999 then
            item(a)=item(lastitem)
            lastitem=lastitem-1
        endif
    next

    b=0
    for a=1 to lastenemy
        if enemy(a).hp>0 then b=b+1
    next
    if b=0 then planets(slot).genozide=1

    if awayteam.hp<=0 then
        reward(2)=0
        reward(1)=0
        if player.dead=0 then player.dead=3

        for a=1 to lastdrifting
            if slot=drifting(a).m then player.dead=25
        next
        player.landed.s=planets(slot).depth
        if player.dead=25 then player.landed.s=slot
        display_awayteam()
        dprint "The awayteam has been destroyed.",12
        if slot=specialplanet(0) then player.dead=8
        if slot=specialplanet(1) then player.dead=9
        if slot=specialplanet(3) or slot=specialplanet(4) then player.dead=10
        if slot=specialplanet(5) then player.dead=11
        if awayteam.oxygen<1 then player.dead=14
        no_key=keyin
    endif

    if player.dead<>0 then
        old=player.c
        player.c=awayteam.c
        save_bones(1)
        player.c=old'On planet
    endif

    if player.dead=0 and planets(slot).atmos>0 and planets(slot).depth=0 and planets(slot).atmos=player.questflag(10) then
        a=0
        for x=0 to 60
            for y=0 to 20
                a=a+tmap(x,y).vege
                if planetmap(x,y,slot)>0 then b+=1
            next
        next
        if a=0 then
            dprint "This planet would suit Omega Bioengineerings Requirements."
            player.questflag(10)=-slot
        endif
    endif

    if planets(slot).depth=0 and planets(slot).flags(21)=0 then
        a=0
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,slot)>0 then a+=1
            next
        next
        if a>=1199 then
            planets(slot).flags(21)=1
            dprint "You have completely mapped this planet.",10
        endif
    endif

    if specialplanet(10)=slot then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,slot)=-60 then planetmap(x,y,slot)=-4
                if planetmap(x,y,slot)=60 then planetmap(x,y,slot)=4
            next
        next
    endif

    if specialplanet(17)=slot then
        a=1
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,slot))=107 then a=0
            next
        next
        specialflag(17)=a
    endif

    if slot=pirateplanet(0) and planets(slot).genozide=1 then
        dprint "Congratulations! You have destroyed the pirates base!",10
        reward(6)=50000
        piratebase(0)=-1
        pirateplanet(0)=-1
        no_key=keyin
    endif
    if slot=pirateplanet(0) and awayteam.hp<=0 then player.dead=7
    c=0
    for a=1 to _NoPB 'Did main base earlier
        if slot=pirateplanet(a) then
            for b=1 to lastenemy
                if enemy(b).hp>0 then
                    if enemy(b).made=7 or enemy(b).made=3 then c=c+1
                endif
            next
            if c=0 and awayteam.hp>0 then
                reward(8)=reward(8)+10000
                piratebase(a)=-1
                pirateplanet(a)=-1
            endif
        endif
    next

    b=0
    for a=1 to 15
        if slot=savefrom(a).map then b=a
    next
    if b=0 then
        for a=15 to 1 step -1
            if savefrom(a).map=0 then b=a
        next
    endif
    if b=0 then
        for a=1 to 14
            savefrom(a)=savefrom(a+1)
        next
        savefrom(15)=savefrom(16) '16 bleibt immer leer
        b=15
    endif
    a=b
    if lastenemy>129 then lastenemy=129
    savefrom(a).lastenemy=lastenemy
    savefrom(a).map=slot
    for b=1 to lastenemy
        savefrom(a).enemy(b)=enemy(b)
    next
    for x=0 to 60
        for y=0 to 20
            tmap(x,y)=tiles(0)
        next
    next

    'if slot=specialplanet(12) and player.dead<>0 then player.dead=17
    if player.dead<>0 then screenshot(3)
    return nextmap
end function

function alienbomb(c as short,slot as short, li() as short, byref lastlocalitem as short) as short
    dim as short a,b,d,e,f,osx,x2
    dim as _cords p,p1
    p1.x=item(c).w.x
    p1.y=item(c).w.y
    osx=calcosx(awayteam.c.x,planets(slot).depth)

    for e=0 to item(c).v1*6
        screenset 0,1
        display_planetmap(slot,osx,0)
        for x=0 to 60
            for y=0 to 20
                p.x=x
                p.y=y
                f=int(distance(p,p1,1))
                set__color( 0,0)
                if f=e  then set__color( 0,1)
                if f=e+7 then set__color( 236,15)
                if f=e+6 then set__color( 236,237)
                if f=e+5 then set__color( 237,238)
                if f=e+4 then set__color( 238,239)
                if f=e+3 then set__color( 239,240)
                if f=e+2 then set__color( 240,241)
                if f=e+1 then set__color( 241,1)
                if f=e-1 then set__color( 0,0)
                if f=e-2 then set__color( 0,0)
                if f>=e-2 and f<=e+7 then
                    x2=x-osx
                    if x2<0 then x2+=61
                    if x2>60 then x2-=61
                    if configflag(con_tiles)=0 then
                        if x2>=0 and x2<=_mwx then put ((x2)*_tix,y*_tiy),gtiles(gt_no(76+f-e)),trans
                    else
                        draw string(x2*_fw1,y*_fh1), chr(176),,font1,custom,@_col
                    endif
                endif
                if f<e then
                    if tmap(x,y).shootable>0 then
                        d=rnd_range(1,item(c).v1*12)
                        if tmap(p.x,p.y).dr<d then
                            tmap(p.x,p.y).hp=tmap(p.x,p.y).hp-d
                        else
                            tmap(p.x,p.y).dr=tmap(p.x,p.y).dr-d
                        endif
                        if tmap(x,y).hp<=0 then
                            if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).turnsinto
                            if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                            tmap(x,y)=tiles(tmap(x,y).turnsinto)
                        endif
                    endif
                endif
            next
        next
        flip
        sleep 50
    next

    for e=242 to 249
        for x=0 to 60
            for y=0 to 20
                set__color( e,e)
                if configflag(con_tiles)=0 then
                    'if x-osx>=0 and x-osx<=_mwx then put ((x-osx)*_tix,y*_tiy),gtiles(gt_no(rnd_range(63,66))),pset
                else
                    draw_string(x*_fw1,y*_fh1, chr(176),font1,_col)
                endif
            next
        next
        sleep 50
    next

    for e=0 to lastenemy
        if distance(enemy(e).c,p1,1)<item(c).v1*5 then enemy(e).hp=enemy(e).hp-item(c).v1*3
    next
    for e=0 to item(c).v1
        if planets(slot).atmos>1 and item(c).v1>1 then
            planets(slot).atmos-=1
            item(c).v1-=2
            if planets(slot).atmos=6 or planets(slot).atmos=12 then planets(slot).atmos=1
        endif
    next
    for a=1 to lastlocalitem
        p.x=item(li(a)).w.x
        p.y=item(li(a)).w.y
        if a=c or (rnd_range(1,100)+item(c).v1>item(li(a)).res and distance(p,p1,1)<item(c).v1*5) then
            destroyitem(li(a))
            li(a)=li(lastlocalitem)
            lastlocalitem-=1
        endif
    next

    display_planetmap(slot,osx,0)


    return 0
end function


function grenade(from as _cords,map as short,li() as short, lastlocalitem as short) as _cords
    dim as _cords target,ntarget
    dim as single dx,dy,x,y,launcher
    dim as short a,ex,r,t,osx
    dim as string key
    dim as _cords p,pts(60*20)

    dim as short debug=0

    target.x=from.x
    target.y=from.y
    ntarget.x=from.x
    ntarget.y=from.y
    x=from.x
    y=from.y
    p=from
    launcher=findbest(17,-2)
    if debug=1 and _debug=1 then dprint ""&launcher
    if launcher>0 then
        dprint "Choose target"
        do
            key=planet_cursor(target,map,osx,1)
            ep_display(li(),lastlocalitem,osx)
            display_awayteam(,osx)
            key=cursor(target,map,osx,,5+item(launcher).v1-planets(map).grav)
            if key=key_te or ucase(key)=" " or multikey(SC_ENTER) then ex=-1
            if key=key_quit or multikey(SC_ESCAPE) then ex=1
        loop until ex<>0
    else
        dprint "Choose direction"
        key=keyin("12346789"&" "&key__esc)
        if getdirection(key)=0 then
            ex=1
        else
            r=3-planets(map).grav
            if getdirection(key)=1 then
                dx=-.7
                dy=.7
            endif
            if getdirection(key)=2 then
                dx=0
                dy=1
            endif
            if getdirection(key)=3 then
                dx=.7
                dy=.7
            endif
            if getdirection(key)=4 then
                dx=-1
                dy=0
            endif
            if getdirection(key)=6 then
                dx=1
                dy=0
            endif
            if getdirection(key)=7 then
                dx=-.7
                dy=-.7
            endif
            if getdirection(key)=8 then
                dx=0
                dy=-1
            endif
            if getdirection(key)=9 then
                dx=.7
                dy=-.7
            endif
        endif
    endif
    if ex=1 then
        target.x=-1
        target.y=-1
    else
        if launcher>0 then
            r=line_in_points(target,from,pts())
            for a=1 to r
                if tmap(pts(a).x,pts(a).y).firetru=1 then
                    return pts(a)
                endif
            next
            return target
        else

        for a=1 to r
            x=x+dx
            y=y+dy
            t=abs(planetmap(x,y,map))
            if tiles(t).firetru=1 then exit for
        next
        if planets(map).depth=0 then
            if x<0 then x=60
            if x>60 then x=0
        else
            if x<0 then x=0
            if x>60 then x=60
        endif
        if y<0 then y=0
        if y>20 then y=20
        target.x=x
        target.y=y
        endif
    endif
    if debug=1 and _debug=1 then dprint ""&target.x &":"& target.y
    return target
end function

function teleport(from as _cords,map as short) as _cords
    dim target as _cords
    dim ex as short
    dim key as string
    dim osx as short

    if planets(map).teleport<>0 then
        dprint "Something is jamming your teleportation device!",14
        return from
    endif
    if player.teleportload<10 then
        dprint "The teleportation device still needs some time to recharge!"
        return from
    endif
    target=awayteam.c
    do
        key=planet_cursor(target,map,osx,1)
        display_awayteam(,osx)
        key=cursor(target,map,osx,,10)
        if key=key_te or ucase(key)=" " or multikey(SC_ENTER) then ex=1
        if key=key_quit or multikey(SC_ESCAPE) then ex=-1
    loop until ex<>0
    if ex=1 then
            from.x=target.x
            from.y=target.y
            player.teleportload=0
    endif
    return from
end function

function wormhole_ani(target as _cords) as short
    dim p(sm_x*sm_y) as _cords
    dim as short last,a,c
    last=Line_in_points(target,player.c,p())
    for a=1 to last-1
        player.osx=p(a).x-_mwx/2
        player.osy=p(a).y-10
        if player.osx<=0 then player.osx=0
        if player.osy<=0 then player.osy=0
        if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
        if player.osy>=sm_y-20 then player.osy=sm_y-20
        screenset 0,1
        cls
        player.di+=1
        if player.di=5 then player.di=6
        if player.di>9 then player.di=1
        display_stars(2)
        display_ship
        dprint ""
        if configflag(con_tiles)=0 then
            put ((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
        else
            set__color( _shipcolor,0)
            draw_string((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1,"@",font1,_col)
        endif
        flip
        sleep 50
'        set__color( rnd_range(180,214),rnd_range(170,204))
'        if p(a).x-player.osx>=0 and p(a).x-player.osx<=_mwx and p(a).y-player.osy>=0 and p(a).y-player.osy<=20 then
'            if configflag(con_tiles)=0 then
'                put ((p(a).x-player.osx)*_fw1,(p(a).y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
'            else
'                draw_string((p(a).x-player.osx)*_fw1,(p(a).y-player.osy)*_fh1,"@",font1,_col)
'            endif
'            player.di+=1
'            if player.di=5 then player.di=6
'            if player.di>9 then player.di=1
'            sleep 50
'            for c=0 to laststar+wormhole
'                if map(c).discovered>0 then display_star(c,0)
'            next
'        else
'            cls
'            display_ship(1)
'            show_stars(1)
'            dprint ""
'        endif
    next
    player.c=target
    return 0
end function

function wormhole_travel() as short
    dim as short pl,a,near,b,natural
    dim as single d
    d=9999
    natural=1
    for a=laststar+1 to laststar+wormhole
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then
            pl=a
        else
            if distance(map(map(a).planets(1)).c,player.c)<d then
                near=a
                d=distance(map(map(a).planets(1)).c,player.c)
            endif
        endif
    next

    if pl=0 and artflag(25)>0 then
        pl=near
        natural=0 'No anodata for self made WHs
    endif

    if pl>1 and configflag(con_warnings)=0 then
        if askyn("Travelling through wormholes can be dangerous. Do you really want to?(y/n)")=0 then pl=0
    endif
    if pl>1 and rnd_range(1,100)<whtravelled then
        dprint "There is a planet orbiting the wormhole!"
        if askyn("Shall we try to land on it? (y/n)") then
            if whplanet=0 then makewhplanet
            pl=0
            landing(whplanet)
        endif
        whtravelled=101
    endif
    if pl>1 then
        player.towed=0
        if map(pl).planets(2)=0 and whtravelled<101 then whtravelled+=3
        map(pl).planets(2)=1
        if artflag(16)=0 then
            b=map(pl).planets(1)
        else
            dprint "Wormhole navigation system engaged!(+/- to choose wormhole, "&key_la &" to select)",10
            b=wormhole_navigation
        endif
        if b>0 then
        if map(b).planets(2)=0 then
            ano_money+=cint(distance(map(b).c,player.c)*5)*natural
        endif
            map(b).planets(2)=1
            dprint "you travel through the wormhole.",10
            #ifdef _FMODSOUND
            if configflag(con_sound)=0 or configflag(con_sound)=2 then FSOUND_PlaySound(FSOUND_FREE, sound(5))
            #endif
            #ifdef _FBSOUND
            if configflag(con_sound)=0 or configflag(con_sound)=2 then fbs_Play_Wave(sound(5))
            #endif
            if rnd_range(1,100)<distance(map(b).c,player.c)+maximum(abs(spacemap(player.c.x,player.c.y)),5) then
                add_ano(map(b).c,player.c)
            endif
            player.osx=player.c.x-_mwx/2
            player.osy=player.c.y-10
            if player.osx<=0 then player.osx=0
            if player.osy<=0 then player.osy=0
            if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
            if player.osy>=sm_y-20 then player.osy=sm_y-20
            d=0
            if not(skill_test(player.pilot(0),st_easy+int(distance(player.c,map(b).c)/8),"Pilot")) and artflag(13)=0 then d=rnd_range(1,distance(player.c,map(b).c)/5+1)
            player.hull=player.hull-d
            if d>0 then dprint "Your ship is damaged ("&d &").",12
            wormhole_ani(map(b).c)
            display_ship(1)
            display_stars(1)
            dprint ""
            if player.hull<=0 then player.dead=24
        endif
    endif
    return 0
end function


function wormhole_navigation() as short
    dim as short c,d,pl,b,i,wi(wormhole)
    dim as _cords wp(wormhole)
    dim as string key
    for c=laststar+1 to laststar+wormhole
        map(c).discovered=1
        i+=1
        wp(i)=map(c).c
        wi(i)=c
    next
    pl=1
    sort_by_distance(player.c,wp(),wi(),wormhole)
    do
        player.osx=map(wi(pl)).c.x-_mwx/2
        player.osy=map(wi(pl)).c.y-10
        if player.osx<=0 then player.osx=0
        if player.osy<=0 then player.osy=0
        if player.osx>=sm_x-_mwx then player.osx=sm_x-_mwx
        if player.osy>=sm_y-20 then player.osy=sm_y-20
        display_stars(2)
        display_star(wi(pl),1)
        display_ship


        set__color( 0,11)

        if player.c.x-player.osx>=0 and player.c.x-player.osx<=_mwx and player.c.y-player.osy>=0 and .y-player.osy<=20 then
            if configflag(con_tiles)=0 then
                put ((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
            else
                set__color( _shipcolor,0)
                draw_string((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1,"@",font1,_col)
            endif
        endif
        d=int(distance(player.c,map(wi(pl)).c))
        dprint "Wormhole at "&map(wi(pl)).c.x &":"& map(wi(pl)).c.y &". Distance "&d &" Parsec."
        key=keyin
        if keyplus(key) then pl=pl+1
        if keyminus(key) then pl=pl-1
        if pl<1 then pl=wormhole
        if pl>wormhole then pl=1
        set__color( 11,0)
        cls
    loop until key=key__enter or key=key_la or key=key__esc

    if key=key__esc then
        b=-1
    else
        b=wi(pl)
    endif
    return b
end function

function space_radio() as short
    dim as short i,closestfleet,closestdrifter,lc,j,disnum,dis,y
    dim as _cords p
    dim dummy as _monster
    dim du(2) as short
    dim debug as short
    dim c(25) as _cords
    dim contacts(25) as short
    dim as string fname(8),text,dname(2)
    dname(0)=" (Strong signal)"
    dname(1)=""
    dname(2)=" (Weak signal)"

    gen_fname(fname())

    dim as single dd
    ''dim as single df,dd
    ''df=9999
    for i=1 to lastfleet
        if fleet(i).ty=1 or fleet(i).ty=3 or fleet(i).ty=6 or fleet(i).ty=7 then
            if distance(fleet(i).c,player.c)<player.sensors*2 and lc<25 then
                lc+=1
                c(lc)=fleet(i).c
                contacts(lc)=i
            endif
        endif
    next
    dd=9999
    for i=1 to lastdrifting
        p.x=drifting(i).x
        p.y=drifting(i).y
        if i<=3 or (planets(drifting(i).m).mon_template(0).made=32 and planets(drifting(i).m).flags(0)=0) then
            if distance(p,player.c)<player.sensors*2 and lc<25 then
                lc+=1
                c(lc).x=drifting(i).x
                c(lc).y=drifting(i).y
                contacts(lc)=-i 'Drifters are negative
            endif
        endif
    next

    if lc>0 then
        if lc=1 then
            i=contacts(lc)
        else
            text="Contact:"

            sort_by_distance(player.c,c(),contacts(),lc)
            for j=1 to lc
                if contacts(j)>0 then
                    dis=cint(distance(player.c,fleet(contacts(j)).c))
                    select case dis
                    case 0 to player.sensors*2/3
                        disnum=0
                    case player.sensors*2/3 to player.sensors*4/3
                        disnum=1
                    case else
                        disnum=2
                    end select

                    text=text &"/"&fname(fleet(contacts(j)).ty) &dname(disnum)
                else
                    p.x=drifting(abs(contacts(j))).x
                    p.y=drifting(abs(contacts(j))).y
                    dis=cint(distance(player.c,p))
                    select case dis
                    case 0 to player.sensors*2/3
                        disnum=0
                    case player.sensors*2/3 to player.sensors*4/3
                        disnum=1
                    case else
                        disnum=2
                    end select
                    text=text &"/"&shiptypes(drifting(abs(contacts(j))).s)&dname(disnum)
                    if _debug=1310 then text &="("&contacts(j) &")"
                endif
            next
            text=text &"/Cancel"
            y=(20*_fh1-(lc+1)*_fh2)/_fh1
            if _debug=1310 then dprint "Y"&y
            if y<0 then y=0
            if _debug=1310 then dprint "and Y"&y
            i=menu(bg_ship,text,"",0,y)
            if i=lc+1 then return 0
            i=contacts(i)
        endif
    else
        i=0
        dprint "No contact."
    end if
    if _debug=1 then dprint "I="&i
    select case i
    case is>0
        if fleet(i).ty=1 and i>5 then
            if fleet(i).con(1)=0 then
                dodialog(5,dummy,i)
            else
                dodialog(11,dummy,i)
            endif
        endif
        if fleet(i).ty=3 then dodialog(3,dummy,i)
        dummy.lang=fleet(i).ty+26
        dummy.aggr=1
        if debug=2 and _debug=1 then dprint ""&dummy.lang
        if fleet(i).ty=6 then communicate(dummy,1,du(),1,1)
        if fleet(i).ty=7 then communicate(dummy,1,du(),1,1)

    case is<0
        i=abs(i)
        if i<=3 then
            dodialog(10,dummy,-i)
            return 0
        endif
        p.x=drifting(i).x
        p.y=drifting(i).y
        if _debug=1310 then dprint "Contacting drifter "&i
        if planets(drifting(i).m).mon_template(0).made=32 and (planets(drifting(i).m).flags(0)=0 and planets(drifting(i).m).atmos>0) then
            dodialog(4,dummy,-i)
        else
            dprint "They don't answer."
        endif

    end select
    return 0
end function


function launch_probe() as short
    dim as short i,d
    i=get_item(55)
    if i>0 then
        screenset 0,1
        set__color(11,0)
        cls
        display_stars(1)
        display_ship(1)
        dprint "Which direction?"
        flip
        d=getdirection(keyin())
        if d>0 then
            lastprobe+=1
            if lastprobe>100 then lastprobe=1
            probe(lastprobe).x=player.c.x
            probe(lastprobe).y=player.c.y
            probe(lastprobe).m=i
            probe(lastprobe).s=d
            probe(lastprobe).p=item(i).v4
            dprint probe(lastprobe).x &":"&probe(lastprobe).y
            dprint "Probe launched."
            item(i).w.s=0
        else
            dprint "Launch cancelled."
        endif
    else
        dprint "You have no probes."
    endif
    return 0
end function

function move_probes() as short
    dim as short i,x,y,j,navcom,t,d

    if lastprobe>0 then
    navcom=player.equipment(se_navcom)
    for i=1 to lastprobe
        if probe(i).m>0 then
            probe(i).z-=item(probe(i).m).v5
            if probe(i).z<=0 then
                probe(i).z+=10
                for j=laststar+1 to laststar+wormhole
                    if map(j).c.x=probe(i).x and map(j).c.y=probe(i).y then
                        map(j).discovered=1
                        if askyn("Do you want to direct the probe into the wormhole?(y/n)") then
                            if skill_test(player.pilot(0),st_hard) then
                                t=map(j).planets(1)
                                d=distance(map(t).c,probe(i))
                                probe(i).x=map(t).c.x
                                probe(i).y=map(t).c.y
                                dprint "The probe traveled " &d &" parsecs to "&map(t).c.x &":"&map(t).c.y &"."
                                exit for
                            else
                                dprint "You lost contact with the probe."
                                item(probe(i).m).v3=0
                            endif
                        endif
                    endif
                next

                    probe(i)=movepoint(probe(i),probe(i).s,,1)
                    item(probe(i).m).v3-=1
                    for x=probe(i).x-1 to probe(i).x+1
                        for y=probe(i).y-1 to probe(i).y+1
                            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                                if abs(spacemap(x,y))<6 then
                                    spacemap(x,y)=abs(spacemap(x,y))
                                    if spacemap(x,y)=0 and navcom>0 then spacemap(x,y)=1
                                endif
                                for j=1 to laststar
                                    if map(j).c.x=x and map(j).c.y=y and map(j).spec<8 then map(j).discovered=1
                                    if map(j).c.x=probe(i).x and map(j).c.y=probe(i).y then map(j).discovered=1
                                next
                            endif
                        next
                    next
                    if abs(spacemap(probe(i).x,probe(i).y))>=6 and skill_test(player.pilot(0),st_hard) then spacemap(x,y)=abs(spacemap(x,y))


                    for j=1 to lastdrifting
                        if drifting(j).x=probe(i).x and drifting(j).y=probe(i).y then drifting(j).p=1
                    next
                    if spacemap(probe(i).x,probe(i).y)>1 then
                        if skill_test(item(probe(i).m).v2,st_average) then item(probe(i).m).v1-=1
                    endif
                endif
            endif
            if probe(i).x=player.c.x and probe(i).y=player.c.y then
                if askyn("Do you want to take the probe on board?(y/n)") then

                    item(probe(i).m).v3=item(probe(i).m).v6 'Refuel
                    item(probe(i).m).w.s=-1 'Refuel
                    if lastprobe>1 then
                        probe(i)=probe(lastprobe)
                    else
                        probe(i)=probe(0)
                    endif
                    lastprobe-=1
                    screenset 0,1
                    set__color(11,0)
                    cls
                    display_stars(1)
                    display_ship
                    dprint ""
                    flip
                endif
            endif

        next
        for i=1 to lastprobe
            if item(probe(i).m).v3<=0 or item(probe(i).m).v1<=0 then
                dprint "Lost contact with probe at "&probe(i).x &":"&probe(i).y &".",c_yel
                if lastprobe>1 then
                    probe(i)=probe(lastprobe)
                else
                    if _debug<>0 then dprint "Deleting probe "&i
                    probe(i)=probe(0)
                endif
                lastprobe-=1
            endif
        next
    endif
    return 0
end function


function planetflags_toship(m as short) as _ship
    dim s as _ship
    dim as short f,e
    e=0
    for f=6 to 10
        if planets(m).flags(f)>0 then
            e=e+1
            s.weapons(e)=makeweapon(planets(m).flags(f))
        endif
        if planets(m).flags(f)=-1 then
            e=e+1
            s.weapons(e)=makeweapon(99)
        endif
        if planets(m).flags(f)=-2 then
            e=e+1
            s.weapons(e)=makeweapon(98)
        endif
        if planets(m).flags(f)=-3 then
            e=e+1
            s.weapons(e)=makeweapon(97)
        endif
    next
    return s
end function


function poolandtransferweapons(s1 as _ship,s2 as _ship) as short
    dim as short e,f,c,g,d,x,y,bg
    dim as string text,help,desc,key
    dim as _cords crs,h1,h2
    dim weapons(1,10) as _weap
    e=0
    ' old weapons
    for f=1 to 5
        if s1.weapons(f).desig<>"" then
            e=e+1
            weapons(0,e)=s1.weapons(f)
            s1.weapons(f)=makeweapon(0)
        else
            if f<=s1.h_maxweaponslot then weapons(0,f).desig="-empty-"
        endif
    next
    'new weapons
    e=0
    for f=1 to 5
        if s2.weapons(f).desig<>"" then
            e=e+1
            weapons(1,e)=s2.weapons(f)
            s2.weapons(f)=makeweapon(0)
        else
            if f<=s2.h_maxweaponslot then weapons(1,f).desig="-empty-"
        endif
    next
    do
        set__color( 15,0)
        cls
        draw_string(0,0,"New Ship",font2,_col)
        draw_string(35*_fw2,0,"Old Ship",font2,_col)
        for x=0 to 1
            for y=1 to 5
                bg=0
                if h1.x=x and h1.y=y then bg=5
                if h2.x=x and h2.y=y then bg=5
                if crs.x=x and crs.y=y then bg=11
                set__color( 15,bg)
                draw_string(x*35*_fw2,y*_fh2,trim(weapons(x,y).desig)&" ",font2,_col)
            next
        next
        set__color( 15,0)
        draw_string(5*_fw2,6*_fh2,"x to swap, esc to exit",font2,_col)
        if weapons(crs.x,crs.y).desig<>"-empty-" then
            help =weapons(crs.x,crs.y).desig & " | | Damage: "&weapons(crs.x,crs.y).dam &" | Range: "&weapons(crs.x,crs.y).range &"\"&weapons(crs.x,crs.y).range*2 &"\" &weapons(crs.x,crs.y).range*3
        else
            help = "Empty slot"
        endif
        textbox(help,2,8,25,11,1)
        set__color( 15,0)
        key=keyin()
        crs=movepoint(crs,getdirection(key))
        if crs.x<0 then crs.x=1
        if crs.x>1 then crs.x=0
        if crs.y<1 then crs.y=5
        if crs.y>5 then crs.y=1
        if crs.x=0 and crs.y>player.h_maxweaponslot+1 then crs.y=1
        if crs.x=1 and crs.y>s1.h_maxweaponslot+1 then crs.y=1
        if key=key__enter then
            if crs.x=0 then
                h1=crs
                if crs.y<1 then crs.y=5
                if crs.y>5 then crs.y=1
                if crs.y>s2.h_maxweaponslot then crs.y=s2.h_maxweaponslot
            endif
            if crs.x=1 then
                h2=crs
                if crs.y<1 then crs.y=5
                if crs.y>5 then crs.y=1
                if crs.y>s1.h_maxweaponslot then crs.y=s1.h_maxweaponslot
            endif
        endif
        if key="x" and h1.y<>0 and h2.y<>0 then
            swap weapons(h1.x,h1.y),weapons(h2.x,h2.y)
        endif
    loop until key=key__esc
    for f=1 to player.h_maxweaponslot
        if weapons(0,f).desig<>"-empty-" then player.weapons(f)=weapons(0,f)
    next
    recalcshipsbays()
    return 0
end function


function movemonster(enemy as _monster, ac as _cords, mapmask() as byte,tmap() as _tile) as _monster
    dim direction as short
    dim dir2 as short
    dim p1 as _cords
    dim sp1 as _cords
    dim sp2 as _cords
    dim sp3 as _cords
    dim pa as _cords
    dim p(4) as _cords
    dim a as short
    dim ti as short

    enemy.nearest=0
    p1.x=enemy.c.x
    p1.y=enemy.c.y
    'mapmask(ac.x,ac.y)=-9

    if enemy.aggr=0 or enemy.aggr=1 then
        direction=nearest(ac,p1,1)
    endif

    if enemy.aggr=2 then
        direction=nearest(p1,ac,1)
    endif


    '
    ' wirf ne mï¿½nze mach ne kurve
    '


    if enemy.c.y<2 and direction=8 and enemy.aggr<>0  then
        if rnd_range(1,100)<51 then
            direction=7
        else
            direction=9
        endif
    endif

    if enemy.c.y>18 and direction=2 and enemy.aggr<>0  then
        if rnd_range(1,100)<51 then
            direction=1
        else
            direction=3
        endif
    endif

    p(2)=movepoint(p1,bestaltdir(direction,1),3)
    p(3)=movepoint(p1,bestaltdir(direction,0),3)
    p(4)=movepoint(p1,direction,3)

    for a=2 to 4
        ti=tmap(p(a).x,p(a).y).walktru

        if mapmask(p(a).x,p(a).y)>0 then
            enemy.nearest=mapmask(p(a).x,p(a).y)
            p(a).x=-1
            p(a).y=-1
        endif
        if ti>0 then
            select case enemy.movetype
            case mt_climb
                if ti=1 or ti=5 then p(a).x=-1
            case mt_dig
                if ti=1 then p(a).x=-1
            case mt_fly2
                if ti>4 then p(a).x=-1
            case mt_ethereal
                'Can move through anything
            case else
                if ti>enemy.movetype then p(a).x=-1
            end select
        endif
    next
    if p(2).x>=0 then dir2=bestaltdir(direction,1)
    if p(3).x>=0 then dir2=bestaltdir(direction,0)
    if p(4).x>=0 then dir2=direction
    p1.x=enemy.c.x
    p1.y=enemy.c.y

    if dir2>0 then
        enemy.c=movepoint(enemy.c,dir2)
        enemy.add_move_cost
    endif
    if mapmask(enemy.c.x,enemy.c.y)=-9 then
        enemy.c.x=p1.x
        enemy.c.y=p1.y
    endif
    return enemy
end function

function monsterhit(attacker as _monster, defender as _monster,vis as byte) as _monster
    dim mname as string
    dim text as string
    dim a as short
    dim b as short
    dim noa as short
    dim col as short
    dim as short debug
    if vis>0 then
        if attacker.stuff(1)=1 and attacker.stuff(2)=1 then mname="flying "
        mname=mname & attacker.sdesc
        text="The "
    else
        mname="Something"
    endif
    if distance(attacker.c,defender.c)<1.5 then
        text=text &mname &" attacks :"
    else
        text=text &mname &" "&attacker.swhat &":"
        col=14
    endif
    noa=attacker.hp\7
    if noa<1 then noa=1
    for a=1 to noa
        if skill_test(-defender.armor\(6*(defender.hp+1))+attacker.weapon,13+defender.movetype*5) then b=b+1+attacker.weapon
    next
    if b>attacker.weapon+5+noa/2 then b=attacker.weapon+5+noa/2 'max damage
    if defender.made=0 then
        if b>0 then
            text=text & damawayteam(b,,attacker.disease)
            col=12
        else
            text=text & " no casualties."
            col=10
        endif
        if defender.hp<=0 then player.killedby=attacker.sdesc
        dprint text,col
    else
        defender.hp=defender.hp-b 'Monster attacks monster
        if defender.hp<=0 then defender.killedby=attacker.made
    endif
    attacker.e.add_action(attacker.atcost*10)
    if debug=1 and _debug=1 then dprint "DEBUG MESSAGE dam:"& b
    return defender
end function

function hitmonster(defender as _monster,attacker as _monster,mapmask() as byte, first as short=-1, last as short=-1) as _monster
    dim a as short
    dim b as single
    dim as single nonlet
    dim c as short
    dim col as short
    dim noa as short
    dim text as string
    dim wtext as string
    dim mname as string
    dim xpstring as string
    dim SLBonus(255) as byte
    dim as string echo1,echo2
    dim slbc as short
    dim as short slot,xpgained,tacbonus,targetnumber

    slot=player.map
    #ifdef _FMODSOUND
    if configflag(con_sound)=0 or configflag(con_sound)=2 then FSOUND_PlaySound(FSOUND_FREE, sound(3))
    #endif
    #ifdef _FBSOUND
    if configflag(con_sound)=0 or configflag(con_sound)=2 then fbs_Play_Wave(sound(3))
    #endif
    if defender.movetype=mt_fly then
        mname="flying "
        targetnumber=15
    else
        targetnumber=12
    endif
    targetnumber+=defender.speed/2
    mname=mname &defender.sdesc
    if first=-1 or last=-1 then
        first=0
        noa=attacker.hpmax
    else
        noa=last
    endif
    if first<0 then first=0
    if last>attacker.hpmax then last=attacker.hpmax
    if player.tactic=3 then
        tacbonus=0
    else
        tacbonus=player.tactic
    endif

    for a=first to noa
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).talents(27)>0 then
            slbc+=1
            SLBonus(slbc)=1
        endif
    next
    slbc=1
    for a=first to noa
        if noa-first<=5 then
            echo2=crew(a).n &" attacks"
            echo1=crew(a).n &" shoots"
        endif
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).disease=0 and distance(defender.c,attacker.c)<=attacker.secweapran(a)+1.5 then
            slbc+=1
            if distance(defender.c,attacker.c)>1.5 then
                if skill_test(-tacbonus+tohit_gun(a)+attacker.secweapthi(a)+SLBonus(slbc),targetnumber,echo1) then
                    b=b+attacker.secweap(a)+add_talent(3,11,.1)+add_talent(a,26,.1)
                    xpstring=gainxp(a)
                    xpgained+=1
                endif
            else
                if skill_test(-tacbonus+tohit_close(a)+SLBonus(slbc),targetnumber,echo2) then
                    b=b+maximum(attacker.secweapc(a),attacker.secweap(a))+add_talent(3,11,.1)+add_talent(a,25,.1)+crew(a).augment(2)/10
                    xpstring=gainxp(a)
                    xpgained+=1
                endif
            endif
        endif
    next
    if xpgained=1 then dprint xpstring,c_gre
    if xpgained>1 then dprint xpgained &" crewmembers gained 1 Xp.",c_gre
    text="You attack the "&defender.sdesc &"."
    if distance(defender.c,attacker.c)>1.5 then b=b+1-int(distance(defender.c,attacker.c)/2)
    b=cint(b)-player.tactic+add_talent(3,10,1)
    if b<0 then b=0
    if b>0 then
       defender.target=attacker.c
       b=b-defender.armor
       if b>0 then
            if player.tactic<>3 then
                text=text &" You hit for " & b &" points of damage."
                defender.hp=defender.hp-b
            else
                if defender.stunres<10 then
                    b=b/2
                    b=(b*((10-defender.stunres)/10))
                    text=text &" You hit for " & b &" nonlethal points of damage."
                    defender.hpnonlethal+=b
                else
                    b=b/2
                    defender.hp-=b
                endif
            endif
            if defender.hp/defender.hpmax<0.8 then wtext =" The " & mname &" is slightly "&defender.dhurt &". "
            if defender.hp/defender.hpmax<0.5 then wtext =" The " & mname &" is "&defender.dhurt &". "
            if defender.hp/defender.hpmax<0.3 then wtext =" The " & mname &" is badly "&defender.dhurt &". "
            text=text &wtext
            col=10
        else
            text=text &" You don't penetrate the "&mname &"s armor."
            col=14
        endif
    else
        text=text &" Your fire misses. "
        col=14
    endif
    if defender.hp<=0 then
        text=text &" the "& mname &" "&defender.dkill
        if defender.made=44 then player.questflag(12)=28
        if defender.made=83 then player.questflag(20)+=1
        if defender.made=84 then player.questflag(20)+=2
        player.alienkills=player.alienkills+1
        if defender.allied>0 then factionadd(0,defender.allied,1)
        if defender.enemy>0 then factionadd(0,defender.enemy,-1)
        if defender.slot>=0 then planets(slot).mon_killed(defender.slot)+=1
    else
        if defender.hp=1 and b>0 and defender.aggr<>2 then
            if rnd_range(1,6) +rnd_range(1,6)<defender.intel+defender.diet and defender.speed>0 then
                defender.aggr=2
                text=text &"the " &mname &" is critically hurt and tries to FLEE. "
                defender=movemonster(defender, attacker.c, mapmask(),tmap())
            endif
        else
            if defender.aggr>0 and defender.hp<defender.hpmax then
                if distance(defender.c,attacker.c)<=1.5 or defender.intel+rnd_range(1,6)>attacker.invis then
                    defender.aggr=0
                    text=text &" the "&mname &" tries to defend itself."
                else
                    text=text &" the "&mname &" looks confused into your general direction"
                endif
            endif
        endif
    endif
    dprint text,col
    return defender
end function


function clear_gamestate() as short
    dim as short a,x,y
    dim d_crew as _crewmember
    dim d_planet as _planet
    dim d_ship as _ship
    dim d_map as _stars
    dim d_fleet as _fleet
    dim d_basis as _basis
    dim d_drifter as _driftingship
    dim d_item as _items
    dim d_share as _share
    dim d_company as _company
    dim d_portal as _transfer
    set__color(15,0)
    draw string(_screenx/2-7*_fw1,_screeny/2),"Resetting game",,font2,custom,@_col

    player=d_ship

    for a=0 to 128
        crew(a)=d_crew
    next

    for a=0 to laststar+wormhole
        map(a)=d_map
    next
    wormhole=8

    for a=0 to max_maps
        planets(a)=d_planet
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
    next
    lastplanet=0

    for a=0 to lastspecial
        specialplanet(a)=0
    next

    for a=0 to lastfleet
        fleet(a)=d_fleet
    next
    lastfleet=0

    for a=1 to lastdrifting
        drifting(a)=d_drifter
    next
    lastdrifting=16


    for a=0 to 25000
        item(a)=d_item
    next
    lastitem=-1


    Wage=10
    basis(0)=d_basis
    basis(0).c.x=50
    basis(0).c.y=20
    basis(0).discovered=1
    basis(0)=makecorp(0)

    basis(1)=d_basis
    basis(1).c.x=10
    basis(1).c.y=25
    basis(1).discovered=1
    basis(1)=makecorp(0)

    basis(2)=d_basis
    basis(2).c.x=75
    basis(2).c.y=10
    basis(2).discovered=1
    basis(2)=makecorp(0)

    basis(3)=d_basis
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0

    baseprice(1)=50
    baseprice(2)=200
    baseprice(3)=500
    baseprice(4)=1000
    baseprice(5)=2500

    for a=0 to 5
        avgprice(a)=0
    next
    for a=0 to 4
        companystats(a)=d_company
    next
    for a=0 to 2047
        shares(a)=d_share
    next
    lastshare=0


    for a=0 to 20
        flag(a)=0
    next

    for a=0 to lastflag
        artflag(a)=0
    next


    for a=0 to 255
        portal(a)=d_portal
    next


    return 0
end function

dim as byte attempts

ERRORMESSAGE:
e=err
text=*ERMN()
text=mid(text,81)
text=__VERSION__ &" Error #"&e &" in "&erl &":" & *ERFN() &" " &*ERMN() & text
f=freefile
open "error.log" for append as #f

print #f,text
close #f
screenset 1,1
locate 10,10
set__color( 12,0)
print "ERROR: Please inform the author and send him the file error.log"
print "matthias.mennel@gmail.com"
set__color( 14,0)
print text
sleep
if gamerunning=1 then
    if attempts=0 then
        print "Trying to save game"
        savegame()
        attempts=26
    else
        print "Failed to save game."
    endif
endif
print "key to exit"
sleep
