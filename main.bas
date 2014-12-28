'Master debug switch: Do not touch!
#Include "debug.bas"

#Macro draw_string(ds_x,ds_y,ds_text,ds_font,ds_col)
Draw String(ds_x,ds_y),ds_text,,ds_font,custom,@ds_col
#EndMacro
#IfDef _FMODSOUND
#IncLib "fmod.dll"
#Include Once "fmod.bi"
#EndIf

#IfDef _FBSOUND
#Include "fbsound.bi"
#EndIf 
#Include Once "fbgfx.bi"
#Include Once "zlib.bi"
#Include Once "file.bi"
#Include "cardobj.bi"
#Include "string.bi"
#Include Once "types.bas"
#include once "stims.bas"
#Include Once "tiles.bas"
'f=freefile
'open "data/tiles.dat" for binary as #f
'get #f,,tiles()
'close #f
#include once "update_world.bas"
#Include Once "credits.bas"
#Include Once "retirement.bas"
#Include Once "math.bas"
#include once "targeting.bas"
#Include Once "astar.bas"
#Include Once "logbook2.bas"
#Include Once "pirates.bas"
#Include Once "planet.bas"
#include once "drifter.bas"
#Include Once "items.bas"
#Include Once "ProsIO.bas"
#Include Once "highscore.bas"
#Include Once "cargotrade.bas"
#include once "fleets.bas"
#include once "monster.bas"
'#include once "colonies.bas"
#Include Once "quests.bas"
#include once "landing.bas"
#Include Once "spacecom.bas"
#Include Once "fileIO.bas"
#Include Once "exploreplanet.bas"
#Include Once "texts.bas"
#Include Once "crew.bas"
#Include Once "space.bas"
#Include Once "kbinput.bas"
#Include Once "globals.bas"
#Include Once "compcolon.bas"
#Include Once "poker.bas"
#include once "shop.bas"
#include once "dialog.bas"
#if _debug>0
#include once "windows.bi"
#endif
On Error Goto errormessage

Screenres 640,320,32
Cls
' Load
Print
Print "Prospector "&__VERSION__
Print
check_filestructure
load_config
load_fonts
If configflag(con_tiles)=0 Or configflag(con_sysmaptiles)=0 Then load_tiles
load_keyset
load_sounds
load_palette()
        
If Not fileexists("config/shipregister.txt") Then
    Cls
    If askyn("This is the first time you start prospector. Do you want to see the keybindings before you start?(Y/N)") Then
       keybindings
    EndIf
    Cls
    f=Freefile
    chdir("config")
    Open "shipregister.txt" For Output As f
    Print #f,"0"
    Print #f,""
    a=Menu(bg_randompic,"Autonaming:/Standard/Babylon 5 shipnames/Star trek shipnames")
    if a=2 Then Print #f,"data/b5shipnames.txt"
    if a=3 then print #f,"data/startreknames.txt"
    Close #f
    chdir("..")
endif

Do
    set_globals
    if _debug>0 then
        f=freefile
        open "questguys.txt" for append as #f
        for b=0 to 100
            print #f,b
            add_questguys
            for a=1 to 3
                print #f,questguy(a).job &";"&questguy(a).location
            next
        next
        close #f
    endif
    
    if _debug=2704 then
        f=Freefile
        Open "tiles.csv" For Output As #f
        For a=1 To 400
            If tiles(a).gives>0 Then Print #f,a &";"&tiles(a).desc &";"& tiles(a).gives
        Next
        Close #f
    End If
    if _debug>0 then add_shop(sh_colonyI,pwa(0),-1)
    Do
        a=Menu(bg_title,__VERSION__ &"/Start new game/Load game/Highscore/Manual/Configuration/Keybindings/Quit",,40,_lines-10*_fh2/_fh1,1)
        If a=1 Then
            If count_savegames()>20 Then
                a=0
                dprint "Too many Savegames, choose one to overwrite",14
                text=getfilename()
                If text<>"" Then
                    If askyn("Are you sure you want to delete "&text &"(y/n)") Then
                        Kill("savegames/"&text)
                        a=1
                    EndIf
                EndIf
            EndIf
        EndIf
        If a=2 Then a=from_savegame(a)
        If a=3 Then high_score("")
        If a=4 Then manual
        If a=5 Then configuration
        If a=6 Then keybindings
'           if key="8" then
'            dim i as _items
'            f=freefile
'            open "items.csv" for output as #f
'            for a=0 to 302
'                i=make_item(a)
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
    Loop Until a=1 or a=2 or a=7
    set__color(11,0)
    Cls
    If a=1 Then start_new_game

    If (a=1 or a=2) And player.dead=0 Then
        Key=""
        gamerunning=1
        display_stars(1)
        display_ship(1)
        explore_space
    EndIf

    If a=7 Then End

    If player.dead>0 Then death_message()
    
    set__color( 15,0)
    If configflag(con_restart)=0 Then
        load_game("empty.sav")
        clear_gamestate
        gamerunning=0
    EndIf

Loop Until configflag(con_restart)=1
#IfDef _FMODSOUND
fSOUND_close
#EndIf
End

Function start_new_game() As Short
    Dim As String text
    Dim As Short a,b,c,f,d
    Dim doubleitem(45550) As Byte
    Dim i As _items
    Dim debug As Byte
    debug=126
    
    if _debug>0 then
        for a=1 to 3
            dprint a &":"&questguy(a).location
        next
    endif
    
    If debug=1 And _debug=1 Then
        f=Freefile
        Open "planettemp.csv" For Output As #f
        For a=0 To laststar
            text=map(a).spec &";"
            For b=1 To 9
                text=text &";"
                If map(a).planets(b)>0 And map(a).planets(b)<1024 Then
                    makeplanetmap(map(a).planets(b),b,map(a).spec)
                    text=text &planets(map(a).planets(b)).temp
                EndIf
            Next
            Print #f,text
            Print ".";
        Next
        Close #f
    EndIf
    text="/"&makehullbox(1,"data/ships.csv") &"|Comes with 3 Probes MKI/"&makehullbox(2,"data/ships.csv")&"|Comes with 2 combat drones and fully armored|You get one more choice at a talent if you take this ship/"&makehullbox(3,"data/ships.csv") &"|Comes with paid for cargo to collect on delivery/"&makehullbox(4,"data/ships.csv") &"|Comes with 5 veteran security team members/"&makehullbox(6,"data/ships.csv")&"|You will start as a pirate if you choose this option"
    If configflag(con_startrandom)=1 Then
        b=Menu(bg_randompic,"Choose ship/Scout/Long Range Fighter/Light Transport/Troop Transport/Pirate Cruiser/Random",text,,,1)
    Else
        b=rnd_range(1,4)
    EndIf
    player=make_ship(1)
    If b=6 Then b=rnd_range(1,4)
    c=b
    If b=5 Then c=6
    
    upgradehull(c,player)
    player.hull=player.h_maxhull
    dprint "Your ship: "&player.h_desig
    
    
    d=0
    Do
        d+=1
        i=rnd_item(RI_WeakWeapons)
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Weapons and armor
    Loop Until equipment_value>750 Or d>5 'No more than 6 w&as
    d=0
    Do
        d+=1
        Do
            i=rnd_item(RI_WeakStuff)
        Loop Until doubleitem(i.id)=0
        doubleitem(i.id)+=1
        placeitem(i,0,0,0,0,-1) 'Other stuff
    Loop Until equipment_value>1000 And d>2 'At least 3 other stuffs
    
    
    If b=1 Then
        placeitem(make_item(100),0,0,0,0,-1)
        placeitem(make_item(100),0,0,0,0,-1)
        placeitem(make_item(100),0,0,0,0,-1)
    EndIf

    If b=2 Then
        player.equipment(se_shipdetection)=1
        placeitem(make_item(110),0,0,0,0,-1)
        placeitem(make_item(110),0,0,0,0,-1)
    EndIf

    If b=3 Then
        player.cargo(1).x=11
        player.cargo(2).x=rnd_range(1,3)
        player.cargo(1).y=nearest_base(player.c)
        player.cargo(2).y=rnd_range(1,5)*player.cargo(2).x
    EndIf


    add_member(1,0)
    add_member(2,1)
    add_member(3,1)
    add_member(4,1)
    add_member(5,1)
    if _debug>0 then add_member(13,0)
    If debug=3 And _debug=1 Then player.questflag(22)=1
    

    If b=4 Then
        player.security=5
        For c=6 To 10
            add_member(7,0)
        Next
    EndIf

    Select Case startingweapon
    Case 1
        player.weapons(1)=make_weapon(rnd_range(6,7))
    Case 2
        player.weapons(1)=make_weapon(rnd_range(1,2))
    Case Else
        If rnd_range(1,100)<51 Then
            player.weapons(1)=make_weapon(rnd_range(6,7))
        Else
            player.weapons(1)=make_weapon(rnd_range(1,2))
        EndIf
    End Select
    
    make_spacemap()
    
    player.turn=0
    
    set__color(11,0)
    Cls
    set__color( 11,0)
    
    
    If b<5 Then
        c=2+textbox("An unexplored sector of the galaxy. You are a private Prospector. You can earn money by mapping planets and finding resources. Your goal is to make sure you can live out your life in comfort in your retirement. || But beware of alien lifeforms and pirates. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        faction(0).war(1)=0
        faction(0).war(2)=100
        faction(0).war(3)=0
        faction(0).war(4)=100
        faction(0).war(5)=100
        player.c.x=drifting(1).x
        player.c.y=drifting(1).y
    Else
        c=2+textbox("A life of danger and adventure awaits you, harassing the local shipping lanes as a pirate. It won't be easy but if you manage to avoid the company patrols, and get good loot, it will be very profitable! You will be able to spend the rest of your life in luxury. You start your career with a nice little "&player.h_desig &".",5,5,50,11,0)
        draw_string(5*_fw1,5*_fh1+c*_fh2, "You christen the beauty (Enter to autoname):",font2,_col)
        player.weapons(2)=make_weapon(99)
        player.weapons(3)=make_weapon(99)
        pirateupgrade
        recalcshipsbays()
        player.engine=2
        player.hull=10
        makeplanetmap(piratebase(0),3,map(sysfrommap(piratebase(0))).spec)
        planets(piratebase(0)).mapstat=1
        player.c=map(sysfrommap(piratebase(0))).c
        faction(0).war(1)=100
        faction(0).war(2)=0
        faction(0).war(3)=100
        faction(0).war(4)=0
        faction(0).war(5)=100
    EndIf
    
    
    faction(1).war(2)=100
    faction(1).war(4)=100
    faction(2).war(1)=100
    faction(2).war(3)=100
    faction(3).war(2)=100
    faction(3).war(4)=100
    faction(4).war(1)=100
    faction(4).war(3)=100 '

    player.desig=gettext((5*_fw1+44*_fw2),(5*_fh1+c*_fh2),32,"",1)
    If player.desig="" Then player.desig=randomname()
    a=Freefile
    If Open ("savegames/"&player.desig &".sav" For Input As a)=0 Then
        Close a
        Do
            draw_string (50,10*_fh2, "That ship is already registered.",font2,_col)
            draw_string(50,9*_fh2, "You christen the beauty:" &Space(25),font2,_col)
            player.desig=gettext((5*_fw1+25*_fw2)/_fw2,(5*_fh1+c*_fh2)/_fh2,13,"")
            If player.desig="" Then player.desig=randomname()
        Loop Until fileexists("savegames/"&player.desig &".sav")=0
    EndIf
    just_run=run_until
    If show_specials>0 Then
        player.c=map(sysfrommap(specialplanet(show_specials))).c
    EndIf
    set__color(11,0)
    update_world(2)
    Cls
    Return 0
End Function

Function from_savegame(a As Short) As Short
    Dim As Short c
    c=count_savegames
    set__color(11,0)
    Cls
    If c=0 Then
        dprint "No Saved Games"
        no_key=keyin 
        a=0
    Else
        load_game(getfilename())
        If player.desig="" Then 
            a=0
        else
            player.dead=0
            civ_adapt_tiles(0)
            civ_adapt_tiles(1)
            If savefrom(0).map>0 Then
                landing(0)
            EndIf
        endif
    EndIf
    set__color(11,0)
    Cls
    Return a
End Function

Function move_rover(pl As Short)  As Short
    Dim As Integer a,b,c,i,t,ti,x,y
    Dim As Integer carn,herb,mins,oxy,food,energy,curr,last
    Dim As Single minebase
    Dim As _cords p1,p2,route(1281)
    Dim As _cords pp(9)

    update_tmap(pl)
    make_locallist(pl)
    t=(player.turn-planets(pl).visited)
    If _debug=9 Then Screenset 1,1
    For i=1 To itemindex.vlast
        If item(itemindex.value(i)).ty=18 And item(itemindex.value(i)).w.p=0 And item(itemindex.value(i)).w.s=0 And item(itemindex.value(i)).w.m=pl And item(itemindex.value(i)).discovered>0 And t>0 Then
            ep_rovermove(itemindex.value(i),pl)
            if rnd_range(1,150)<planets(pl).atmos*2 Then item(itemindex.value(i)).discovered=0
            If rnd_range(1,150)<planets(pl).atmos+2 Then
                item(itemindex.value(i))=make_item(65)
            Else
                dprint "Receiving the homing signal of a rover on this planet from " &cords(item(itemindex.value(i)).w),10
            EndIf
        EndIf
    Next
    i=0
    For a=1 To lastitem
        If item(a).ty=27 And item(a).w.p=0 And item(a).w.s=0 And item(a).w.m=pl Then i=a
        If item(a).ty=15 And item(a).w.p=0 And item(a).w.s=0 And item(a).w.m=pl Then
            minebase+=1.1
            If rnd_range(1,100)<10 Then destroyitem(a)
        EndIf
    Next
    If i>0 And t>0 Then
        p1.x=item(i).w.x
        p1.y=item(i).w.y
        For x=0 To 60
            For y=0 To 20
                p2.x=x
                p2.y=y
                If Abs(planetmap(x,y,pl))=13 Then minebase=minebase+2/distance(p1,p2)
                If Abs(planetmap(x,y,pl))=7 Or Abs(planetmap(x,y,pl))=8 Then minebase=minebase+1/distance(p1,p2)
            Next
        Next
        minebase=minebase+planets(pl).minerals
        minebase=minebase+planets(pl).atmos
        minebase=minebase+planets(pl).grav
        minebase=minebase+planets(pl).depth
        If sysfrommap(pl)>0 Then
            minebase=minebase+Abs(spacemap(map(sysfrommap(pl)).c.x,map(sysfrommap(pl)).c.y))
        Else
            minebase=minebase+planets(pl).depth
        EndIf
        item(i).v1=item(i).v1+0.01*minebase*t*item(i).v3
        If item(i).v1>item(i).v2 Then item(i).v1=item(i).v2
        If rnd_range(1,150)<planets(pl).atmos+2 Then item(i)=make_item(66)
    EndIf
    planets(pl).visited=player.turn
    Return 0
End Function

Function rescue() As Short
    Dim As Short a,c,dis,beacon,cargo,closest_fleet,dis2
    Dim As Single b,d
    Dim fname(10) As String

    gen_fname(fname())
    d=256
    If getinvbytype(9)>0 Then
        dprint ("You ran out of fuel. You use the fuel from the cargo bay.")
        removeinvbytype(9,1)
        player.fuel+=30
        Return 0
    EndIf
    ranoutoffuel+=1
    dis2=9999
    For a=0 To lastfleet
        If fleet(a).con(1)<>0 Then
            If askyn("This is merchant fleet "&a &". Do you need fuel?(y/n)",,1) Then
                dprint "2 Cr. per ton. We'll deduct it from the agreed upon payment."
                b=getnumber(0,player.fuelmax,0)
                player.fuel+=b
                fleet(a).con(2)-=b*2
                Return 0
            EndIf
        Else
            If fleet(a).ty<=7 Then
                If distance(fleet(a).c,player.c)<dis2 And faction(0).war(fleet(a).ty)<100 Then
                    closest_fleet=a
                    dis2=distance(fleet(a).c,player.c)
                EndIf
            EndIf
        EndIf
    Next

    For a=0 To 2
        b=distance(player.c,basis(a).c)
        If b<d Then
            d=b
            c=a
        EndIf
    Next
    beacon=findbest(36,-1)
    If beacon>0 Then
        dis=item(beacon).v1
        If rnd_range(1,100)<66 Then destroyitem(beacon)
    Else
        dis=0
    EndIf
    If d>0 And d<256 Then
        dprint "Fuel tanks empty, sending distress signal!",14
        no_key=keyin
        If d<5+dis*2 Then
            If faction(0).war(1)<100 Then
                dprint "Station " &c+1 &" answered and sent a retrieval team. You are charged "& Int(d*(100-dis*10)) & " Cr.",10
                player.money=player.money-Int(d*(100-dis*10))'needs to go below 0
                player.fuel=10
                player.c.x=basis(c).c.x
                player.c.y=basis(c).c.y
            Else
                dprint "One of the stations answers, explaining that they will not help a known pirate like you.",12
                player.dead=1
            EndIf
        Else
            dprint "You are too far out in space....",12

            If rnd_range(1,100)-(10+dis-dis2)<5+dis*2 Then
                dprint "Your distress signal is answered!",10
                b=rnd_range(1,33)+rnd_range(1,33)+rnd_range(1,33)
                If closest_fleet>0 Then
                    dprint add_a_or_an(fname(fleet(closest_fleet).ty),1)&" offers to sell you fuel to get back to the nearest base for "& b &" Cr. per ton. ("& Int(disnbase(player.c)*b) &" credits for " &Int(disnbase(player.c)) &" tons)."
                Else
                    dprint add_a_or_an(shiptypes(rnd_Range(0,16)),1) &" offers to sell you fuel to get to the nearest station for "& b &" Cr. per ton. ("& Int(disnbase(player.c)*b) &" credits for " &Int(disnbase(player.c)) &" tons)."
                EndIf
                If askyn("Do you accept the offer?(y/n)") Then
                    If player.money>=Int(disnbase(player.c)*b) Then
                        player.money=player.money-disnbase(player.c)*b
                    Else
                        dprint "You convince them to lower their price. They only take all your money.",10
                        player.money=0
                    EndIf
                    player.fuel=disnbase(player.c)+2
                    Locate 1,1
                    no_key=keyin
                Else
                    If Not(askyn("Are you certain? (y/n)")) Then
                        If player.money>=Int(disnbase(player.c)*b) Then
                            player.money=player.money-disnbase(player.c)*b
                        Else
                            dprint "You convince them to lower their price. They only take all your money.",10
                            player.money=0
                        EndIf
                        player.fuel=disnbase(player.c)+2
                        Locate 1,1
                        no_key=keyin
                    Else
                        dprint "they leave again."
                        Locate 1,1
                        no_key=keyin
                        player.dead=1
                    EndIf
                EndIf
            Else
                player.dead=1
            EndIf
        EndIf
        no_key=keyin
        Cls
    EndIf
    Return 0
End Function



Function spacestation(st As Short) As _ship
    Dim As Integer a,b,c,d,e,wchance,inspectionchance
    Static As Short hiringpool,last,muddsshop,botsshop,usedshop,equipshop
    Static inv(lstcomit) As _items
    Dim quarantine As Short
    Dim i As _items
    Dim As String Key,text,mtext,sn
    Dim dum As _basis
    dim p as _cords
    set__color(11,0)
    Cls
    basis(st).docked+=1
    comstr.Reset
    display_ship
    If _debug=1111 Then questroll=14
    If player.turn>0 Then
        If basis(st).company=3 Then
            inspectionchance=5+faction(0).war(1)+foundsomething
        Else
            inspectionchance=33+faction(0).war(1)+foundsomething
        EndIf
        If rnd_range(1,100)<inspectionchance Then
            dprint "The station commander decides to do a routine check on your cargo hold before allowing you to disembark.",14
            no_key=keyin
            d=0
            For b=1 To 10
                c=0
                If player.cargo(b).x=9 And (basis(st).company<>1 Or basis(st).company=3) Then c=1 'Embargo
                If player.cargo(b).x=8 And (basis(st).company<>2 Or basis(st).company=3) Then c=1 'Embargo
                If player.cargo(b).x=7 And (basis(st).company<>4 Or basis(st).company=3) Then c=1 'embargo
                If player.cargo(b).x>1 And player.cargo(b).x<9 And player.cargo(b).y=0 Then c=1 'Stolen
                If c=1 And rnd_range(1,100)<30-player.equipment(se_CargoShielding)+player.cargo(b).x Then
                    d=1
                    If player.cargo(b).y>0 Then
                        dprint "You are informed that there is an import embargo on "& (goodsname(player.cargo(b).x-1)) &" and that the cargo will be confiscated.",12
                    Else
                        dprint "Your cargo of "& LCase(goodsname(player.cargo(b).x-1)) &" gets confiscated because you lack proper documentation.",12
                    EndIf
                    player.cargo(b).x=1
                    player.cargo(b).y=0
                    faction(0).war(1)+=1
                EndIf
            Next
            If d=0 Then
                dprint "Everything seems to be ok.",10
                foundsomething-=1
            Else
                foundsomething+=5
            EndIf
        EndIf
        check_passenger(st)
        For b=2 To 255
            If Crew(b).paymod>0 And crew(b).hpmax>0 And crew(b).hp>0 Then
                a=a+Wage*(Crew(b).paymod/10)
                crew(b).morale=crew(b).morale+(Wage-9-bunk_multi*2)+add_talent(1,4,5)

            EndIf
        Next
        dprint "You pay your crew "&credits(a) &" Cr. in wages"
        player.money=player.money-a
        player=levelup(player,0)
        
    EndIf
    
    ss_sighting(st)
    
    If basis(st).spy=1 Or basis(st).spy=2 Then
        If askyn("Do you pay 100 cr. for your informant? (y/n)") Then
            player.money=player.money-100
            If player.money<0 Then
                player.money=0
                dprint "He doesn't seem very happy about you being unable to pay."
            Else
                faction(0).war(1)-=5
            EndIf
        Else
            basis(st).spy=3
            faction(0).war(1)+=15
        EndIf
    EndIf

    For a=0 To lastfleet
        If distance(fleet(a).c,basis(st).c)<2 And fleet(a).con(1)=1 And st=fleet(a).con(3) Then
            Select Case fleet(a).con(2)
            Case Is>0
                dprint "The captain of the merchant convoy thanks you and pays you "& fleet(a).con(2) & " Cr. as promised.",c_gre
                addmoney(fleet(a).con(2),mt_escorting)
                If fleet(a).con(4)<0 Then fleet(a).con(4)=0
                fleet(a).con(4)+=1

            Case Is<0
                If askyn("with your fuel costs you actually owe the captain "&Abs(fleet(a).con(2)) &"Cr. Do you pay?(y/n)") Then
                    addmoney(fleet(a).con(2),mt_escorting)
                Else
                    dprint "The captain isn't very pleased."
                    factionadd(0,fleet(a).ty,1)
                    fleet(a).con(4)-=1
                EndIf
            Case Is=0
                dprint "The captain informs you that your fuelcosts have eaten up your escorting wage."
            End Select
            fleet(a).con(1)=0
            fleet(a).con(2)=0
            fleet(a).con(3)=0

        EndIf
    Next
    
    If st<>player.lastvisit.s Or player.turn-player.lastvisit.t>600 Then
        b=count_and_make_weapons(st)

        If b<5 And rnd_range(1,100)<15 Then
            reroll_shops
            b=count_and_make_weapons(st)
        EndIf
    EndIf
    
    If st<>player.lastvisit.s Or player.turn-player.lastvisit.t>100 Then
        dprint gainxp(1),c_gre
        check_questcargo(st)
        
        If companystats(basis(st).company).capital<3000 Then dprint "The spacestation is abuzz with rumors that "&companyname(basis(st).company) &" is in financial difficulties."
        If companystats(basis(st).company).capital<1000 Then
            dprint companyname(basis(st).company) &" has closed their office in this station."
            dum=makecorp(-basis(st).company)
            basis(st).company=dum.company
            basis(st).repname=dum.repname
            basis(st).mapmod=dum.mapmod
            basis(st).biomod=dum.biomod
            basis(st).resmod=dum.resmod
            basis(st).pirmod=dum.pirmod
            dprint companyname(basis(st).company) &" has taken their place."
        EndIf
        dividend()
    EndIf
    
    girlfriends(st)
    hiringpool=rnd_range(1,4)+rnd_range(1,4)+3
    Do
        quarantine=player.disease
        mtext="Station "& st+1 &"/ "
        mtext=mtext & basis(st).repname &" Office "
        If quarantine>6 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Equipment "
        If quarantine>6 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Sickbay / Fuel(" & round_str((basis(st).inv(9).p/30)*(player.fuelmax+player.fuelpod-Fix(player.fuel)),2) & " Cr, " & (player.fuelmax+player.fuelpod-Fix(player.fuel)) & " tons ) & Ammuniton("& missing_ammo*((player.loadout+1)^2) & "Cr.) / "
        mtext=mtext &"Repair(" &credits(Int(max_hull(player)-player.hull)*(basis(st).pricelevel*100*(0.5+0.5*player.armortype))) & "Cr.) / Hire Crew / Trading "
        If quarantine>5 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Casino "
        If quarantine>4 Then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Retirement"
        mtext=mtext &"/Leave station"
        display_ship()
        bg_parent=bg_shiptxt
        a=Menu(bg_shiptxt,mtext,,,,,1)
        If a=1 Then
            If quarantine<8 Then
                company(st)
            Else
                dprint "You are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=2 Then'refit
            If quarantine<9 Then
                Do
                    set__color(11,0)
                    Cls
                    for b=0 to 3
                        equipshop=get_shop_index(sh_explorers+b,p,st)
                        if equipshop>0 then exit for
                    next
                    sn=shopname(b+1)
                    if _debug>0 then dprint "Shop:"&shoplist(equipshop).shoptype
                    usedshop=99
                    muddsshop=99
                    botsshop=99
                    display_ship()
                    mtext="Refit/"&shipyardname(basis(st).shop(sh_shipyard))
                    mtext=mtext &"/"& moduleshopname(basis(st).shop(sh_modules)) &"/" &sn
                    If basis(st).shop(sh_used)=1 Then
                        mtext=mtext & "/Used Ships"
                        usedshop=4
                    EndIf
                    If basis(st).shop(sh_mudds)=1 Then
                        mtext=mtext & "/Mudds Incredible Bargains"
                        muddsshop=4+basis(st).shop(sh_used)
                    EndIf
                    If basis(st).shop(sh_bots)=1 Then
                        mtext=mtext & "/The Bot-bin"
                        botsshop=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_used)
                    EndIf
                    mtext &= "/Exit"

                    b=Menu(bg_shiptxt,mtext)
                    If b=1 Then shipyard(basis(st).shop(sh_shipyard))
                    If b=2 Then shipupgrades(st)
                    'if b= then towingmodules
                    If b=3 Then 'awayteam equipment
                        Do
                            c=shop(equipshop,basis(st).pricelevel,sn)
                            display_ship
                        Loop Until c=-1
                        set__color(11,0)
                        Cls
                    EndIf
                    If basis(st).shop(sh_used)=1 And b=usedshop Then used_ships(get_shop_index(sh_used,p,st),get_shop_index(sh_usedships,p,st))
                    If basis(st).shop(sh_mudds)=1 And b=muddsshop Then mudds_shop(get_shop_index(sh_mudds,p,st))
                    If basis(st).shop(sh_bots)=1 And b=botsshop Then botsanddrones_shop(get_shop_index(sh_bots,p,st))
                Loop Until b=4+basis(st).shop(sh_mudds)+basis(st).shop(sh_bots)+basis(st).shop(sh_used) Or b=-1
            Else
                dprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=3 Then
            player.disease=sick_bay(get_shop_index(sh_sickbay,p,st),,basis(st).company)
            mtext="Station "& st+1 &"/ "
            mtext=mtext & basis(st).repname &" Office "
            If quarantine>6 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Equipment "
            If quarantine>6 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Sickbay / Fuel & Ammuniton / Repair / Hire Crew / Trading "
            If quarantine>5 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Casino "
            If quarantine>4 Then mtext=mtext &"(Quar.)"
            mtext=mtext &"/Exit"
        EndIf
        If a=4 Then refuel(st,round_nr(basis(st).inv(9).p/30,2))
        If a=5 Then repair_hull(basis(st).pricelevel)
        If a=6 Then hiring(st,hiringpool,4)
        If a=7 Then
            If quarantine<7 Then
                trading(st)
            Else
                dprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=8 Then
            If quarantine<5 Then
                b=casino(0,st)
            Else
                dprint "you are under quarantine and not allowed to enter there"
            EndIf
        EndIf
        If a=9 Then retirement()
        If a=10 Or a=-1 Then
            text=""
            If player.pilot(0)<0 Then text=text &"You dont have a pilot. "
            If player.gunner(0)<0 Then text=text &"You dont have a gunner. "
            If player.science(0)<0 Then text=text &"You dont have a science officer. "
            If player.doctor(0)<0 Then text=text &"You dont have a ships doctor. "
            If player.fuel<player.fuelmax*0.5 Then text=text &"You only have " &player.fuel & " fuel. "
            If player.money<0 Then text=text &"You still have debts of "& player.money &" credits to pay. "
            If (text<>"" And player.dead=0) Then
                If askyn(text &"Do you want to leave anyway?(y/n)",14) Then
                    a=10
                Else
                    a=0
                EndIf
            EndIf
            If text="" And a=-1 Then
                If askyn("Do you really want to leave?(y/n)",14) Then
                    a=10
                Else
                    a=0
                EndIf
            EndIf
        EndIf
    Loop Until a=10
    set__color(11,0)
    Cls
    player.lastvisit.s=st
    player.lastvisit.t=player.turn
    Return player
End Function



Function move_ship(Key As String) As _ship
    Dim As Short a,dam,hydrogenscoop
    Dim scoop As Single
    Static fuelcollect As Byte
    Dim As _cords old,p
    Dim As _weap delweap
    hydrogenscoop=0
    For a=1 To player.h_maxweaponslot
        If player.weapons(a).made=85 Then hydrogenscoop+=1
        If player.weapons(a).made=86 Then hydrogenscoop+=2
    Next
    If walking=0 Then
        a=getdirection(Key)
    Else
        If walking<10 Then a=walking
    EndIf
    If walking=10 Then
        currapwp+=1
        a=nearest(apwaypoints(currapwp),player.c)
        If currapwp=lastapwp Then
            dprint "Target reached"
            walking=0
        EndIf

    EndIf
    If a<>0 Then player.di=a
    old=player.c
    player.c=movepoint(player.c,a,,1)
    If player.c.x<0 Then player.c.x=0
    If player.c.y<0 Then player.c.y=0
    If player.c.x>sm_x Then player.c.x=sm_x
    If player.c.y>sm_y Then player.c.y=sm_y
    If player.c.x<>old.x Or player.c.y<>old.y Then
        If player.towed<>0 Then
            player.fuel-=1
            If Not(skill_test(player.pilot(0),st_average,"Pilot")) Then player.fuel-=1
        EndIf
        If spacemap(player.c.x,player.c.y)=-2 Then spacemap(player.c.x,player.c.y)=2
        If spacemap(player.c.x,player.c.y)=-3 Then spacemap(player.c.x,player.c.y)=3
        If spacemap(player.c.x,player.c.y)=-4 Then spacemap(player.c.x,player.c.y)=4
        If spacemap(player.c.x,player.c.y)=-5 Then spacemap(player.c.x,player.c.y)=5
        If spacemap(player.c.x,player.c.y)=-6 Then spacemap(player.c.x,player.c.y)=6
        If spacemap(player.c.x,player.c.y)=-7 Then spacemap(player.c.x,player.c.y)=7
        If spacemap(player.c.x,player.c.y)=-8 Then spacemap(player.c.x,player.c.y)=8
        If (spacemap(old.x,old.y)<2 Or spacemap(old.x,old.y)>5) And spacemap(player.c.x,player.c.y)>=2 And spacemap(player.c.x,player.c.y)<=5 And configflag(con_warnings)=0 Then
            If Not(askyn("Do you really want to enter the gascloud?(y/n)")) Then player.c=old
        EndIf
        If spacemap(player.c.x,player.c.y)>=2 And spacemap(player.c.x,player.c.y)<=5 Then
            player.towed=0
            If skill_test(player.pilot(0),st_easy+spacemap(player.c.x,player.c.y),"Pilot:") Then
                dprint "You succesfully navigate the gascloud",10
                dprint gainxp(2),c_gre
                If hydrogenscoop=0 Then player.fuel=player.fuel-rnd_range(1,3)
                fuelcollect+=spacemap(player.c.x,player.c.y)*hydrogenscoop
                If fuelcollect>5 Then
                    player.fuel+=fuelcollect/5
                    If player.fuel>player.fuelmax Then player.fuel=player.fuelmax
                    fuelcollect=0
                EndIf
            Else
                dam=rnd_range(1,spacemap(player.c.x,player.c.y))
                If dam>player.shieldside(rnd_range(0,7)) Then
                    dam=dam-player.shieldside(rnd_range(0,7))
                    if dam>0 then
                        dprint "Your Ship is damaged ("&dam &").",12
                        player.hull=player.hull-dam
                        player.fuel=player.fuel-rnd_range(1,5)
                        If player.hull<=0 Then player.dead=12
                    endif
                EndIf
            EndIf
        EndIf
        If spacemap(player.c.x,player.c.y)>=6 And spacemap(player.c.x,player.c.y)<=20 Then
            Select Case spacemap(player.c.x,player.c.y)
            Case Is=16
                dprint "This anomaly shortens space."
            Case Is=17
                dprint "This anomaly lengthens space."
            Case Is=18
                dprint "This anomaly shortnes space, and can damage a ship."
            Case Is=19
                dprint "This anomaly lengthens space, and can damage a ship."
            Case Is=20
                dprint "This anomaly can damage a ship and is highly unpredictable."
            End Select
            If (spacemap(player.c.x,player.c.y)>=8 And spacemap(player.c.x,player.c.y)<=10) Or (spacemap(player.c.x,player.c.y)>=18 And spacemap(player.c.x,player.c.y)<=20) Then
                If rnd_range(1,100)<15 Then
                    dam=rnd_range(0,3)
                    If dam>player.shieldside(rnd_range(0,7)) Then
                        dam=1
                        dprint "Your Ship is damaged ("&dam &").",12
                        player.hull=player.hull-dam
                        player.fuel=player.fuel-rnd_range(1,5)
                        If player.hull<=0 Then player.dead=30
                    Else
                        If player.shieldmax>0 Then dprint "Your shields are hit, but hold",10
                    EndIf
                EndIf
            EndIf
            If spacemap(player.c.x,player.c.y)=8 Or spacemap(player.c.x,player.c.y)=6 Or spacemap(player.c.x,player.c.y)=18 Or spacemap(player.c.x,player.c.y)=16 Then
                player.e.tick
                player.fuel+=.5
            EndIf
            If spacemap(player.c.x,player.c.y)=9 Or spacemap(player.c.x,player.c.y)=7 Or spacemap(player.c.x,player.c.y)=19 Or spacemap(player.c.x,player.c.y)=17 Then
                player.e.add_action(10)
                player.fuel-=.5
            EndIf
            If spacemap(player.c.x,player.c.y)=10 Or spacemap(player.c.x,player.c.y)=20 Or (spacemap(player.c.x,player.c.y)>=6 And rnd_range(1,100)<5) Then
                If rnd_range(1,100)<66 Then
                    Select Case rnd_range(0,100)
                    Case Is=1
                        dprint "Something strange is happening with your fuel tank reading"
                        player.fuel+=rnd_range(1,6)
                    Case Is=2
                        dprint "You get swept away in a gravitational current"
                        player.c=old
                    Case Is=3
                        dprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,player.di,,1)
                    Case Is=4
                        dprint "You get swept away in a gravitational current"
                        player.c=movepoint(player.c,5,,1)
                    Case Is=5
                        dprint "Something strange is happening with the ships chronometer"
                        player.turn=player.turn+rnd_range(1,6)-rnd_range(1,8)
                    Case Is=6
                        dprint "Your sensors are damaged."
                        player.sensors-=1
                    Case Is=7
                        If player.shieldmax>0 Then
                            dprint "Your shieldgenerator is damaged."
                            player.shieldmax-=1
                        EndIf
                    Case Is=8
                        dprint "Time itself seems to speed up"
                        player.e.add_action(player.engine+20-player.engine*2)
                    Case Is=9
                        dprint "You have trouble keeping your position"
                        player.di=rnd_range(1,8)
                        If player.di=5 Then player.di=9
                    Case Is=10
                        dprint "Something catapults you out of the anomaly!"
                        p=player.c
                        For a=0 To rnd_range(1,6)
                            p=movepoint(p,player.di,,1)
                        Next
                        wormhole_ani(p)
                    Case Is=11
                        If rnd_range(1,100)<10+spacemap(player.c.x,player.c.y) Then
                            player.c=map(rnd_range(laststar+1,laststar+wormhole)).c
                            dam=rnd_range(1,6)
                            If dam>player.shieldmax Then
                                dam=1
                                dprint "your Ship is damaged ("&dam &").",12
                                player.hull=player.hull-dam
                                player.fuel=player.fuel-rnd_range(1,5)
                                If player.hull<=0 Then player.dead=30
                            EndIf
                        Else
                            dprint "A wormhole forms straight ahead, but you manage to avoid it. It disappears again instantly."
                        EndIf
                    Case Is=12
                        dprint "There should be a *lot* less fuel in your fueltank"
                        player.fuel+=rnd_range(50,100)
                    Case Is=13
                        dprint "This strange area of space alters your ships structure"
                        player.h_maxhull-=1
                    Case Is=14
                        dprint "This strange area of space alters your ships structure"
                        player.h_maxhull+=1
                    Case Is=15
                        dprint "Your cargo hold is damaged!"
                        player.cargo(rnd_range(1,player.h_maxcargo)).x=1
                    Case Is =16
                        dprint "Your fuel tank is damaged!"
                        player.h_maxfuel-=1
                        If rnd_range(1,100)<10 Then
                            dprint "The damage results in an explosion!"
                            player.hull-=rnd_Range(1,3)
                        EndIf
                    End Select

                EndIf
            EndIf
        EndIf
        If player.towed>0 Then
            drifting(player.towed).x=player.c.x
            drifting(player.towed).y=player.c.y
        EndIf
    EndIf
    If (player.c.x<>old.x Or player.c.y<>old.y) Then' and (player.c.x+player.osx<>30 or player.c.y+player.osy<>10) then
        player.add_move_cost(0)
        
        If spacemap(player.c.x,player.c.y)<=5 Then player.fuel=player.fuel-player.fueluse
        If player.tractor>0 And player.towed>0 Then
            If skill_test(player.pilot(0),st_veryeasy-player.tractor+Fix(drifting(player.towed).s/4))=0 Then
                If skill_test(player.pilot(0),st_veryeasy-player.tractor+Fix(drifting(player.towed).s/4)) Then
                    dprint "You loose connection to your towed ship."
                    player.towed=0
                Else
                dprint "Your tractor beam breaks down.",14
                    For a=0 To 25
                        If player.weapons(a).rof<0 Then 
                            player.weapons(a)=delweap
                            Exit For
                        EndIf
                    Next
                    player.towed=0
                EndIf
            EndIf
        EndIf
        For a=0 To 12
            If patrolquest(a).status=1 Then patrolquest(a).check
        Next
        If player.cursed>0 then
            if rnd_range(1,100)<player.cursed+spacemap(player.c.x,player.c.y) And player.turn Mod 600=0 Then 
                player=com_criticalhit(player,rnd_range(1,6)+6-player.armortype)
            else
                if rnd_range(1,100)<3+player.cursed then 
                    player.cursed+=1
                    dprint "A minor malfunction in one of the ships systems."
                endif
            endif
        endif
    Else
        walking=0
    EndIf
    Return player
End Function

Function explore_space() As Short
    Dim As Short a,b,d,c,f,fl,pl,x1,y1,x2,y2,lturn,debug,osx,osy
    Dim As String Key,text,allowed
    Dim As _cords p1,p2
    Dim As Short planetcom,driftercom,fleetcom,wormcom
    lturn=0
    For a=0 To lastitem
        For b=0 To lastitem
            If b<>a Then
                If item(a).id=item(b).id And item(a).ty<>item(b).ty Then 
                    dprint item(a).desig &";" &item(b).desig &item(a).id
                    'item(a).id+=1
                EndIf
            EndIf
        Next
    Next
    For a=1 To 25
        If player.weapons(a).heat>0 Then player.weapons(a).heat=0
    Next
    If _debug=11 Then
        For a=1 To lastdrifting
            drifting(a).p=1
        Next
    EndIf
    Screenset 0,1
    Cls
    bg_parent=bg_shipstarstxt
    location=lc_onship
    display_stars(1)
    display_ship
    Flip
    Screenset 0,1
    Cls
    bg_parent=bg_shipstarstxt
    display_stars(1)
    display_ship
    Flip
    Screenset 0,1
    Do
        If debug=8 And _debug=1 Then dprint "Lastfleet:"&lastfleet
        player.turn+=10
        If show_specials<>0 Then dprint "Planet is at " &map(sysfrommap(specialplanet(show_specials))).c.x &":"&map(sysfrommap(specialplanet(show_specials))).c.y
        If player.e.tick=-1 And player.dead=0 Then
            fl=0
            allowed=key_awayteam & key_ra & key_drop &key_la &key_tala &key_dock &key_sc &key_inspect & key_rename & key_comment & key_save &key_quit &key_tow &key_walk &key_wait
            allowed= allowed & key_nw & key_north & key_ne & key_east & key_west & key_se & key_south & key_sw &key_optequip
            If artflag(25)>0 Then allowed=allowed &key_te
            If debug=11 And _debug=1 Then allowed=allowed &"ï¿½"
            For a=0 To 2
                If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                    dprint "You are at Spacestation-"& a+1 &". Press "&key_dock &" to dock."
                    allowed=allowed & key_fi
                    If walking<10 Then walking=0
                    driftercom=1
                EndIf
            Next

            For a=0 To lastfleet
                If distance(player.c,fleet(a).c)<1.5 Then
                    fl=meet_fleet(a)
                    fleetcom=1
                    Exit For
                EndIf
            Next
            For a=0 To laststar
                If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
                    planetcom=a+1
                    dPrint add_a_or_an(spectralname(map(a).spec),1)&"." & system_text(a) & ". Press "&key_sc &" to scan, "&key_la &" to land, " &key_tala &" to land at a specific spot, "&key_optequip &" to change armor priorities."
                    If a=piratebase(0) Then dprint "Lots of traffic in this system"
                    map(a).discovered=2
                    display_system(a)
                    If walking<10 Then walking=0
                EndIf
            Next
            For a=laststar+1 To laststar+wormhole
                If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
                    dprint "A wormhole. Press "&key_la &" to enter it."
                    wormcom=1
                    If walking<10 Then walking=0
                EndIf
            Next
            For a=1 To lastdrifting
                If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 And player.towed<>a Then
                    If player.tractor>0 And a>3 Then
                        dprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock, "&key_tow &" to tow."
                    EndIf
                    If player.tractor=0 Then
                        dprint add_a_or_an(shiptypes(drifting(a).s),1)&" is drifting in space here. "&key_dock &" to dock."
                    EndIf
                    drifting(a).p=1
                    driftercom=1
                    If walking<10 Then walking=0
                EndIf
            Next
            If fl>0 Or _testspacecombat=1 Then
                If fleet(fl).ty=1 And fl>5 Then
                    If player.turn Mod 10=0 Then
                        If fleet(fl).con(1)=0 Then
                            dprint "There is a merchant convoy in sensor range, hailing us. press "&key_fi &" to attack," &key_ra & " to call by radio."
                        Else
                            dprint "This is merchant convoy "&fl &". reporting no incidents."
                        EndIf
                    EndIf
                EndIf
                If fleet(fl).ty=2 Then dprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=3 Then dprint "There is a company anti pirate patrol in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=4 Then dprint "There is a pirate fleet in sensor range, hailing us. press "&key_fi &" to attack, " &key_ra & " to call by radio."
                If fleet(fl).ty=6 Then
                    If civ(0).contact=0 Then
                        dprint civfleetdescription(fleet(fl)) &" hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    Else
                        dprint add_a_or_an(civ(0).n,1) &" fleet, hailing us. Press "& key_fi &"to attack, " &key_ra & " to call by radio."
                    EndIf
                EndIf
                allowed=allowed+key_fi
                fleetcom=1
            EndIf

            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"
            If planetcom>0 Then comstr.t=comstr.t & key_sc &" scan;"& key_la &" land;"& key_tala &" target land;"
            If fleetcom=1 Then comstr.t=comstr.t &key_fi &" attack;"
            If driftercom=1 Then comstr.t=comstr.t &key_dock &" dock;"
            If wormcom=1 Then comstr.t=comstr.t &key_la &" enter wormhole;"
            If artflag(25)>0 Then comstr.t=comstr.t &key_te &" wormhole generator"
            comstr.nextpage
        
            Screenset 0,1
            Cls
            bg_parent=bg_shipstarstxt
            location=lc_onship
            display_stars(1)
            display_ship(1)
            If planetcom>0 Then display_system(planetcom-1)
            dprint ""
            Flip
            explore_space_messages
            'screenset 1,1
            if player.dead=0 then Key=keyin(allowed,walking)
            
            player=move_ship(Key)

            planetcom=0
            fleetcom=0
            driftercom=0
            wormcom=0
            comstr.t=key_ra &" call by radio;"&key_drop &" launch probe;"&key_comment &" comment;"


            If debug=11 And _debug=1 And Key="ï¿½" Then
                dprint fleet(1).mem(1).hull &":"&fleet(2).mem(1).hull &":"&fleet(3).mem(1).hull
                lastfleet=8
                fleet(6)=makealienfleet
                fleet(6).c=basis(0).c
                fleet(7)=makealienfleet
                fleet(7).c=basis(1).c
                fleet(8)=makealienfleet
                fleet(8).c=basis(2).c
            EndIf

            If Key=key_fi Then
                For a=0 To 2
                    If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                        If askyn( "Do you really want to attack Spacestation-"& a+1 &")(y/n)") Then
                            fl=0
                            factionadd(0,fleet(a+1).ty,20)
                            playerfightfleet(a+1)
                            If player.dead=0 Then
                                If fleet(a+1).mem(1).hull<=0 Then
                                    dprint "Station "&a+1 &" has been destroyed"
                                    basis(a).c.x=-1
                                    fleet(a).c.x=-1
                                EndIf
                            EndIf
                        Else
                            fl=0
                        EndIf
                    EndIf
                Next
                If _testspacecombat=1 Then fl=rnd_range(4,lastfleet)
                If fl>0 Then
                    factionadd(0,fleet(fl).ty,20)

                    playerfightfleet(fl)
                EndIf
            EndIf

            If Key=key_walk Then
                Key=keyin
                walking=getdirection(Key)
            EndIf
            
            if key=key_optequip then
                a=menu(bg_shiptxt,"When choosing armor/optimize protection/balanced/optimize oxygen")
                if a=1 then 
                    awayteam.optoxy=0
                    dprint "Now optimizing protection"
                endif
                if a=2 then
                    awayteam.optoxy=1
                    dprint "Balanced"
                endif
                if a=3 then 
                    awayteam.optoxy=2
                    dprint "Now optimizing oxygen"
                endif
            endif
            
            if key=key_wait then
                player.add_move_cost(0)
            endif
            
            If Key=key_ra Then space_radio

            If Key=key_drop Then launch_probe

            If Key=key_la Or Key=key_tala Or Key=key_sc or key=key_inspect Then
                pl=-1
                For a=0 To laststar
                    If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then pl=a
                Next

                If pl>-1 Then
                    If Key=key_la Or Key=key_tala Then
                        a=getplanet(pl)
                        If a>0 Then
                            b=map(pl).planets(a)
                            If is_gasgiant(b)=0 And b>0 Then
                                If Key=key_la Then landing(map(pl).planets(a))
                                If Key=key_tala Then target_landing(map(pl).planets(a))
                            Else
                                If is_gasgiant(b)=0 Then
                                    dprint"You don't find anything big enough to land on"
                                Else
                                    gasgiant_fueling(b,a,pl)
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                    If Key=key_sc or key=key_inspect Then scanning()
                    Key=""
                EndIf
                pl=-1

                If (Key=key_sc or key=key_inspect) And Abs(spacemap(player.c.x,player.c.y))>=6 And Abs(spacemap(player.c.x,player.c.y))<=10 Then
                    If askyn("Do you want to scan the anomaly?(y/n)") Then
                        If rnd_range(1,100)=1 Then player.cursed+=1
                        If skill_test(player.science(0),st_easy+Abs(spacemap(player.c.x,player.c.y)),"Science officer") Then
                            dprint "You succesfully identified the anomaly!",c_gre
                            dprint gainxp(4),c_gre
                            ano_money+=Abs(spacemap(player.c.y,player.c.y))/2
                            spacemap(player.c.x,player.c.y)=Abs(spacemap(player.c.x,player.c.y))+10
                            Select Case spacemap(player.c.x,player.c.y)
                            Case Is=16
                                dprint "This anomaly shortens space, slightly reducing fuel consumption when travelling through it."
                            Case Is=17
                                dprint "This anomaly lengthens space, slightly increasing fuel consumption when travelling through it."
                            Case Is=18
                                dprint "This anomaly shortens space, slightly reducing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            Case Is=19
                                dprint "This anomaly lengthens space, slightly increasing fuel consumption while travelling through it. It also is highly charged and can damage a ship."
                            Case Is=20
                                dprint "This anomaly can damage a ship and is highly unpredictable."
                            End Select
                        Else
                            dprint "You are unable to identify the anomaly.",c_yel
                        EndIf
                    EndIf
                EndIf

                If Key=key_la Then wormhole_travel()
            EndIf

            If Key=key_dock Then
                For a=0 To 3
                    If player.c.x=basis(a).c.x And player.c.y=basis(a).c.y Then
                        If stationroll=0 Or player.lastvisit.s<>a Then stationroll=rnd_range(1,20)
                        If faction(0).war(1)+stationroll<100 Then
                            b=rnd_range(1,4)
                            If faction(0).war(1)>80 Then
                                dprint "You have to beg to get a docking permission, exagerating the sorry state of your ship quite a bit in the process!",14
                                b=15
                            EndIf
                            If faction(0).war(1)>33 Then
                                If b=1 Then dprint "After an unusually long waiting period you get your permission to dock.",14
                                If b=2 Then dprint "The Station commander questions you extensively about your activities before allowing you to dock.",14
                            EndIf
                            If faction(0).war(1)>66 Then
                                If b=1 Then dprint "After you dock you overhear a dock worker remark 'I didn't know we were allowing known pirates on the base.' He looks at you fully aware that you heard him.",14
                                If b=2 Then dprint "A patrol boat captain bumps into you snarling 'Pirate scum. Wait till i meet you in space!'",14
                            EndIf
                            player=spacestation(a)
                            Key=""
                            If configflag(con_autosave)=0 And player.dead=0 Then
                                Screenset 1,1
                                dprint "Saving game",15
                                savegame()
                            EndIf
                            set__color( 11,0)
                            c=0
                            d=0
                            For b=0 To 10
                                If player.cargo(b).x>1 And player.cargo(b).x<7 Then
                                    c=c+basis(a).inv(player.cargo(b).x-1).p
                                EndIf
                            Next
                            c=c\15
                            'dprint "pirate chance:" &c
                            If c>66 Then c=66
                            ' Pirate agression test
                            For b=0 To 10
                                If player.cargo(b).x=7 Then
                                    c=101
                                    d=1
                                EndIf
                            Next
                            If basis(a).spy=1 Then c=0
                            For b=3 To lastfleet
                                If fleet(b).ty=2 And rnd_range(1,100)<c Then
                                    fleet(b).t=8
                                    d=1
                                Else
                                    fleet(b).t=9
                                EndIf
                            Next
                            'see if pirates notice
                            If d=1 Then
                                dprint "As you load your Cargo you notice a worker taking notes. When you want to question him he is gone.",c_yel
                            EndIf
                            If player.money<0 And player.dead=0 Then
                                If skill_test(player.pilot(0),st_hard) Then
                                    dprint "As you leave the docking bay you get a message from the station commander to return to 'solve some financial issues' first. Your pilot grins and heads for the docking bay doors, exceeding savety limits. The doors slam close right behind your ship. As you speed into space you get a radio message from the commander. He calmly explains that there *will* be a fee for that next time you dock.",c_yel
                                    player.money=player.money-100
                                    faction(0).war(2)-=1
                                    faction(0).war(1)+=1
                                Else
                                    player.dead=2
                                EndIf
                            EndIf
                        Else
                            dprint "The station commander closes the bay doors and fires upon you!",12
                            d=rnd_range(1,6)
                            dprint "You take "&d &" points of damage!",c_red
                            player.hull=player.hull-d
                            If player.hull<=0 Then player.dead=18
                            no_key=keyin
                        EndIf
                    EndIf
                Next
                Screenset 1,1
                display_stars(1)
            EndIf

            If Key=key_dock Then
                For a=1 To lastdrifting
                    If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 Then dock_drifting_ship(a)
                Next
            EndIf

            If Key=key_tow Then
                If player.towed=0 Then
                    For a=4 To lastdrifting
                        If player.c.x=drifting(a).x And player.c.y=drifting(a).y And planets(drifting(a).m).flags(0)=0 Then
                            If player.tractor>0 Then
                                player.towed=a
                                dprint "You tow the other ship."
                            Else
                                dprint "You have no tractor beam.",14
                            EndIf
                        EndIf
                    Next
                Else
                    player.towed=0
                    dprint "You release the other ship."
                EndIf
                Key=""
            EndIf
            
            
            If artflag(25)>0 And Key=key_te Then
                wormhole_travel
            EndIf
            
            If Key=key_awayteam Then showteam(0)


            Screenset 0,1
            set__color(11,0)
            Cls

            display_stars(1)
            display_ship(1)
            dprint ""



        EndIf

        update_world(1)

        If player.hull<=0 And player.dead=0 Then player.dead=18
        If player.fuel<=0 And player.dead=0 Then rescue()

        If Key=key_save Then
            If askyn("Do you really want to save the game? (y/n)") Then player.dead=savegame()
        EndIf

        If Key=key_rename Then
            If askyn("Do you want to rename your ship? (y/n)") Then
                Screenset 1,1
                set__color( 15,0)
                draw_string(sidebar+(1+Len(Trim(player.h_sdesc)))*_fw2 ,0, Space(25),font2,_col)
                Key=gettext(sidebar+(1+Len(Trim(player.h_sdesc)))*_fw2,1,32,"",1)
                If Key<>"" Then player.desig=Key
                set__color( 11,0)
                player.turn=player.turn-1
            EndIf
        EndIf

        If Key=key_comment Then 'Name or comment on map
            p2.x=player.c.x'-player.osx
            p2.y=player.c.y'-player.osy

            osx=player.osx
            osy=player.osy
            Do

                player.osx=p2.x-_mwx/2
                player.osy=p2.y-10
                If player.osx<=0 Then player.osx=0
                If player.osy<=0 Then player.osy=0
                If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
                If player.osy>=sm_y-20 Then player.osy=sm_y-20
                osx=player.osx
                osy=player.osy
                Screenset 0,1
                Cls
                display_stars(2)
                display_ship(1)
                dprint ""
                Flip
                Key=Cursor(p2,0,osx,osy)


            Loop Until Key=key__esc Or Key=key__enter Or (Asc(Ucase(Key))>64 And Asc(Key)<132)
            set__color( 11,0)

            b=0
            If Key<>key__esc Then
                For a=1 To lastcom
                    If p2.y=coms(a).c.y Then
                        If p2.x>=coms(a).c.x And p2.x<=coms(a).c.x+coms(a).l Then
                                Key=Trim(coms(a).t)
                                b=a
                                p2.x=coms(a).c.x
                                p2.y=coms(a).c.y
                        EndIf
                     EndIf
                Next
                Screenset 0,1
                Cls
                display_stars(2)
                display_ship(1)
                dprint ""
                Flip
                Screenset 1,1
                If Asc(Key)<65 Or Asc(Key)>122 Then Key=""
                text=gettext((p2.x-osx)*_fw1,(p2.y-osy)*_fh1,16,Key,1)
                text=Trim(text)
                set__color(11,0)
                Cls
                display_stars(1)
                display_ship(1)
                If b=0 Then
                    lastcom=lastcom+1
                    b=lastcom
                EndIf
                If p2.x*_tix+Len(text)*_fw2>sm_x*_tix Then p2.x=CInt((sm_x*_tix-Len(text)*_fw2)/_tix)
                coms(b).c.x=p2.x
                coms(b).c.y=p2.y
                coms(b).t=text
                coms(b).l=Len(text)
            EndIf
            b=0
            For a=1 To lastcom
                If coms(a).t="" Then
                    coms(a)=coms(a+1)
                Else
                    b=b+1
                EndIf
            Next
            set__color(11,0)
            Cls
            lastcom=b
            display_stars(1)
            display_ship(1)
        EndIf
        
        For a=0 To 7
            For b=0 To 7
                If faction(a).war(b)>100 Then faction(a).war(b)=100
                If faction(a).war(b)<0 Then faction(a).war(b)=0
            Next
        Next

        For a=0 To 7
            If faction(a).alli<>0 Then
                For b=0 To 7
                    faction(a).war(b)=(faction(a).war(b)+faction(faction(a).alli).war(b))/2
                Next

            EndIf
        Next

        driftercom=0
        planetcom=0
        fleetcom=0
        wormcom=0


    Loop Until player.dead>0

    Return 0
End Function



Function explore_planet(from As _cords, orbit As Short) As _cords
    Dim As Single a,b,c,d,e,f,g,x,y,sf,sf2,vismod
    Dim As Short slot,r,deadcounter,ship_landing,loadmonsters,allroll(8),osx,wraparound
    Dim As Single dawn,dawn2
    Dim As String Key,dkey,allowed,text,help
    Dim dam As Single
    Dim As _cords p,p1,p2,p3,old,nextmap
    Dim towed As _ship
    Dim As Short skill
    Dim mapmask(60,20) As Byte
    Dim nightday(60) As Byte
    Dim watermap(60,20) As Byte
    Dim localtemp(60,20) As Single
    Dim cloudmap(60,20) As Byte
    Dim spawnmask(1281) As _cords
    Dim lsp As Short
    Dim ti As Short
    
    if _debug=2704 then print #logfile,"Starting ep loop"
    bg_parent=bg_awayteamtxt
    
    Dim diesize As Short
    Dim localturn As Short
    Dim tb As Single
    'dim oxydep as single
    Dim lavapoint(5) As _cords
    Dim shipfire(16) As _shipfire
    Dim areaeffect(16) As _ae
    Dim autofire_dir As Short
    Dim last_ae As Short
    Dim del_rec As _rect

    Dim As Short debug=0
'oob suchen
    For a=1 To 255
        enemy(a)=enemy(0)
    Next
    lastenemy=0

    Screenset 0,1
    set__color(11,0)
    Cls
    Flip
    set__color(11,0)
    Cls
    If _Debug>0 Then
        For a=0 To 9
            dprint planets(slot).mon_template(a).sdesc
        Next
    EndIf
    slot=from.m
    planets(slot).mapstat=2
    deadcounter=0
    awayteam.c=from
    player.map=slot
    osx=calcosx(awayteam.c.x,slot)
    lsp=0
    location=lc_awayteam
    IF planets(slot).depth>0 then 
        wraparound=0
    else
        wraparound=3
    endif
    For a=1 To 20
        If makew(a,1)<>0 Then
            b+=1
            wsinv(b)=make_weapon(makew(a,1))
        EndIf
    Next

    osx=calcosx(awayteam.c.x,planets(slot).depth)
    
    update_tmap(slot)
    
    'allowed="12346789ULXFSQRWGCHDO"&key_pickup &key__i
    allowed=key_awayteam &key_ju & key_te & key_fi &key_save &key_quit &key_ra &key_walk & key_gr & key_he _
     & key_la & key_pickup & key_inspect & key_ex & key_of & key_co & key_drop & key_gr & key_wait _
     & key_portal &key_oxy &key_close & key_report &key_autofire &key_autoexplore
    comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"_
     & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"_
     & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"

    If _debug>0 Then allowed=allowed &"Ü"
    If awayteam.movetype=2 Or awayteam.movetype=3 Then
        allowed=allowed &key_ju
        comstr.t=comstr.t &key_ju &" Jetpackjump;"
    EndIf
    If awayteam.teleportrange>0 Then
        allowed=allowed &key_te
        comstr.t=comstr.t &key_te &" Teleport;"
    EndIf

    If planets(slot).atmos=0 Then planets(slot).atmos=1
    If planets(slot).grav=0 Then planets(slot).grav=.5

    If planets(slot).atmos>=3 And planets(slot).atmos<=6 Then
        awayteam.helmet=0
        awayteam.oxygen=awayteam.oxymax
    Else
        awayteam.helmet=1
    EndIf
    lsp=ep_updatemasks(watermap(),localtemp(),cloudmap(),spawnmask(),mapmask(),nightday(),dawn,dawn2)
        
    b=0
    For a=1 To 15 'Look for saved status on this planet
        If savefrom(a).map=slot Then
            lastenemy=savefrom(a).lastenemy
            For b=1 To lastenemy
                enemy(b)=savefrom(a).enemy(b)
            Next
            loadmonsters=1
        EndIf
    Next
    if _debug=2704 then print #logfile,"loadmonsters:"&loadmonsters
    If loadmonsters=0 Then 'No saved status, monsters need to be generated
        
        c=0
        For a=0 To 16
            If planets(slot).mon_noamin(a)>0 And planets(slot).mon_noamax(a)>0 Then
                If planets(slot).mon_template(a).made=0 Then planets(slot).mon_template(a)=makemonster(1,slot)
                For d=1 To rnd_range(planets(slot).mon_noamin(a),planets(slot).mon_noamax(a))
                    c+=1
                    enemy(c)=setmonster(planets(slot).mon_template(a),slot,spawnmask(),lsp,,,c,1)
                    enemy(c).slot=a
                    enemy(c).no=c
                    if _debug=905 then enemy(c).sleeping=100000
                    If enemy(c).faction=0 Then enemy(c).faction=9+a
                    If enemy(c).faction<9 Then
                        If allroll(enemy(c).faction)=0 Then allroll(enemy(c).faction)=rnd_range(1,100)
                        If faction(0).war(enemy(c).faction)>=allroll(enemy(c).faction) Then
                            enemy(c).aggr=0
                        Else
                            enemy(c).aggr=1
                        EndIf
                    EndIf
                Next
            EndIf
        Next
        lastenemy=c
        
        x=0
        For a=0 To lastspecial
            If specialplanet(a)=slot Then x=1
        Next
        For a=0 To _NoPB
            If piratebase(a)=slot Then x=1
        Next
        For a=1 To lastdrifting
            If drifting(a).m=slot Then x=1
        Next

        If planets(slot).visited=0 And planets(slot).depth=0 And x=0 Then
            combon(0).Value+=1
            adaptmap(slot)
            lsp=0
            
            If rnd_range(1,100)<5 And rnd_range(1,100)<disnbase(player.c) And lastenemy>10 And planets(slot).atmos>1 Then
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(46,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).slot=16
                enemy(lastenemy).no=lastenemy
                If rnd_range(1,100)<disnbase(player.c)*2 Then placeitem(make_item(81),enemy(lastenemy).c.x,enemy(lastenemy).c.y,slot)
            EndIf
            If rnd_range(1,100)<26-disnbase(player.c) Then 'deadawayteam
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).hpmax=55
                enemy(lastenemy).slot=16
                If show_all=1 Then dprint "corpse at "&enemy(lastenemy).c.x & enemy(lastenemy).c.y
            EndIf
            If rnd_range(1,100)<26-distance(player.c,civ(0).home) Then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(0).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            EndIf
            If rnd_range(1,100)<26-distance(player.c,civ(1).home) Then
                lastenemy+=1
                enemy(lastenemy)=setmonster(civ(1).spec,slot,spawnmask(),lsp,,,lastenemy,1)
                enemy(lastenemy).hp=-1
                enemy(lastenemy).slot=16
            EndIf
        EndIf
        If slot=piratebase(0) Then
            For x=0 To 60
                For y=0 To 20
                    If Abs(planetmap(p.x,p.y,slot))=246 Then
                        changetile(p.x,p.y,slot,68)
                        tmap(p.x,p.y)=tiles(68)
                    EndIf
                Next
            Next
            If rnd_range(1,100)<25 Then
                Do
                    p=rnd_point(slot,,68)
                Loop Until tmap(p.x,p.y).gives=0
                planetmap(p.x,p.y,slot)=-246
                tmap(p.x,p.y)=tiles(246)
            EndIf
        EndIf

        For c=0 To 8
        b=(planets(slot).vault(c).h-2)*((planets(slot).vault(c).w-2))
        If b>4 Or planets(slot).vault(c).wd(5)=4 Then
            If debug=1 And _debug=1 Then dprint "Making vault at "&planets(slot).vault(c).x &":"& planets(slot).vault(c).y &":"& planets(slot).vault(c).w &":"& planets(slot).vault(c).h
            If planets(slot).vault(c).wd(16)=99 Then specialflag(15)=1
            If planets(slot).vault(c).wd(5)=1 Then
                If b>9 Then
                    lastenemy=lastenemy-rnd_range(1,6)
                    If lastenemy<1 Then lastenemy=1
                    a=lastenemy+1
                    For x=planets(slot).vault(c).x+1 To planets(slot).vault(c).x+planets(slot).vault(c).w-1
                        For y=planets(slot).vault(c).y+1 To planets(slot).vault(c).y+planets(slot).vault(c).h-1
                            If a>255 Then a=255
                            enemy(a)=makemonster(9,slot)
                            enemy(a)=setmonster(enemy(a),slot,spawnmask(),lsp,x,y,a,1)
                            a=a+1
                        Next
                    Next
                    lastenemy=a
                    If lastenemy>255 Then lastenemy=255
                EndIf
            EndIf

            If planets(slot).vault(c).wd(5)=2 And planets(slot).vault(c).wd(6)<>0 Then
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                If debug=1 And _debug=1 Then dprint "lastenemy"&lastenemy
                lastenemy=lastenemy+b
                For e=d To lastenemy
                    text=text &d
                    Do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    Loop Until tmap(x,y).walktru=0
                    If debug=1 And _debug=1 Then dprint "Set monster at "&x &":"&y
                    If planets(slot).vault(c).wd(6)>0 Then
                        enemy(e)=makemonster(planets(slot).vault(c).wd(6),slot)
                        enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,d)
                    Else
                        enemy(e)=setmonster(planets(slot).mon_template(-planets(slot).vault(c).wd(6)),slot,spawnmask(),lsp,x,y,e)
                        If debug=1 And _debug=1 Then dprint "Enemy "&e &" is at "&enemy(e).c.x &":"&enemy(e).c.y
                    EndIf
                Next
                If debug=1 And _debug=1 Then dprint "lastenemy"&lastenemy
            EndIf

            If planets(slot).vault(c).wd(5)=3 Then
                If debug=1 And _debug=1 Then dprint "lastenemy"&lastenemy
                b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
                d=lastenemy
                lastenemy=lastenemy+b
                For e=d To lastenemy
                    Do
                        x=rnd_range(planets(slot).vault(c).x,planets(slot).vault(c).x+planets(slot).vault(c).w)
                        y=rnd_range(planets(slot).vault(c).y,planets(slot).vault(c).y+planets(slot).vault(c).h)
                    Loop Until tmap(x,y).walktru=0
                    If debug=1 And _debug=1 Then dprint "Set monster at "&x &":"&y
                    enemy(e)=makemonster(59,slot)
                    enemy(e)=setmonster(enemy(d),slot,spawnmask(),lsp,x,y,e,1)
                Next
                If debug=1 And _debug=1 Then dprint "lastenemy"&lastenemy
            EndIf
            If planets(slot).vault(c).wd(5)=4 Then
                For x=planets(slot).vault(c).x To planets(slot).vault(c).x+planets(slot).vault(c).w
                    For y=planets(slot).vault(c).y To planets(slot).vault(c).y+planets(slot).vault(c).h
                        If tmap(x,y).walktru=0 Then
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(planets(slot).mon_template(Abs(planets(slot).vault(c).wd(6))),slot,spawnmask(),lsp,x,y,lastenemy)
                        EndIf
                    Next
                Next

            EndIf
            planets(slot).vault(c)=del_rec
        EndIf
    Next
    For a=0 To _NoPB
        If slot=piratebase(a) Then
            c=5+rnd_range(1,6)
            For b=lastenemy To lastenemy+c
                enemy(b)=makemonster(3,slot)
                enemy(b)=setmonster(enemy(b),slot,spawnmask(),lsp,,,b,1)
            Next
            lastenemy=lastenemy+c
        EndIf
    Next

EndIf
    
    For a=0 To 16
        planets(slot).mon_template(a).slot=a
    Next
    
    awayteam.slot=slot
    
    if _debug=2704 then print #logfile,"Move rovers"
    move_rover(slot)
    'if planets(slot).colony<>0 then growcolony(slot)
    
    If planets(slot).visited>0 And planets(slot).visited<player.turn Then
        b=planets(slot).visited-player.turn
        For e=1 To lastenemy
            If enemy(e).made=101 And enemy(e).hp>0 Then
                For a=1 To b
                    p=rnd_point(slot,,,1)
                    If p.x>=0 Then
                        changetile(p.x,p.y,slot,4)
                        tmap(p.x,p.y)=tiles(4)
                    EndIf
                Next

            EndIf
        Next

    EndIf

    planets(slot).discovered=3
    planets(slot).visited=player.turn
    If planets(slot).flags(27)=1 Then planets(slot).flags(27)=2

    If slot=specialplanet(0) And player.towed=4 Then
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
    EndIf


    If slot=specialplanet(1) And specialflag(1)=0 Then 'apollos planet
        lastenemy+=1
        enemy(lastenemy)=makemonster(5,slot)
        enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,b,1)
        player.landed=rnd_point
        player.landed.m=slot
        do_dialog(2,enemy(lastenemy),0)
        If enemy(b).aggr=0 Then
            dprint enemy(lastenemy).sdesc &" doesn't seem pleased with your response."
        Else
            dprint enemy(lastenemy).sdesc &" does seem pleased with your response."
        EndIf
    EndIf
    
    If slot=specialplanet(2) Then
        If specialflag(2)=0 Then

            specialflag(2)=1
            dprint "As you enter the lower atmosphere a powerful energy beam strikes your ship from the surface below! A planetery defense system has detected you!"
            a=Menu(bg_parent,"Flee into:/Space/Below horizon")
            If a=1 Then
                If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                    If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                        If skill_test(player.pilot(location),st_veryhard,"Pilot") Then
                            nextmap.m=-1
                            Return nextmap
                        EndIf
                    EndIf
                EndIf
            EndIf
            dprint "You are already too low to escape into orbit, so the only way to avoid total destruction is an emergency landing! Your vessel slams into the surface!",15
            If Not(skill_test(player.pilot(location),st_veryhard,"Pilot")) Then player.hull=player.hull-rnd_range(1,6)
            If player.hull<=0 Then
                planetmap(player.landed.x,player.landed.y,slot)=127+player.h_no
                tmap(player.landed.x,player.landed.y)=tiles(127+player.h_no)
                player.landed.m=0
            EndIf
            For a=0 To rnd_range(1,6) +rnd_range(1,6)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,slot)
                enemy(lastenemy).hp=-1
            Next
        EndIf
        If specialflag(2)=2 Then
            For x=0 To 60
                For y=0 To 20
                    If planetmap(x,y,slot)=-168 Then planetmap(x,y,slot)=-169
                    If planetmap(x,y,slot)=168 Then planetmap(x,y,slot)=169
                    If Abs(planetmap(x,y,slot))=169 Then tmap(x,y)=tiles(169)
                Next
            Next
        EndIf
    EndIf

    If specialplanet(8)=slot Then 'stormy,less critters
        lastenemy=lastenemy-rnd_range(1,5)
        If lastenemy<0 Then lastenemy=0
    EndIf

    If planets(slot).flags(25)<>0 Or specialplanet(40)=slot Then
        For x=0 To 60
            For y=0 To 20
                tmap(x,y).disease=13
            Next
        Next
        If planets(slot).flags(25)=2 Then
            awayteam.helmet=1
        Else
           planets(slot).mapmod=0
        EndIf
    EndIf
    '
    '   loaded game in savefrom
    '
    '    This only if savegame
    '
    If savefrom(0).map>0 Then
        awayteam=savefrom(0).awayteam
        player.landed=savefrom(0).ship
        slot=savefrom(0).map
        lastenemy=savefrom(0).lastenemy
        For b=1 To lastenemy
            enemy(b)=savefrom(0).enemy(b)
        Next
    EndIf
    
    if _debug=2704 then print #logfile,"equip"
    equip_awayteam(slot)
    make_vismask(awayteam.c,0,slot,,awayteam.groundpen)        
    c=0
    For a=0 To lastitem
        If item(a).ty=47 And item(a).w.m=slot And item(a).w.s=0 Then
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(15,slot)
            enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,,,lastenemy,1)
            enemy(lastenemy).hp=-1
            enemy(lastenemy).hpmax=55
            enemy(lastenemy).slot=16
        EndIf
    Next
    
    if _debug=2704 then print #logfile,"locallists"
    make_locallist(slot)
    

    If slot=specialplanet(16) Then
        If findbest(24,-1)>0 Then
            For a=1 To lastenemy
                enemy(a).aggr=0
            Next
        Else
            For a=1 To lastenemy
                enemy(a).aggr=1
            Next
        EndIf
    EndIf

    If slot=specialplanet(37) Then
        p.x=25
        p.y=5
        invisiblelabyrinth(p.x,p.y)
    EndIf

    If alien_scanner=1 Then player.stuff(3)=2
    'outpost trading
    For a=11 To 13
        planets(slot).flags(a)=planets(slot).flags(a)+rnd_range(1,6) +rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6)
        If planets(slot).flags(a)<0 Then planets(slot).flags(a)+=1
        If planets(slot).flags(a)>0 Then planets(slot).flags(a)-=1
        If planets(slot).flags(a)<-3 Then planets(slot).flags(a)=-3
        If planets(slot).flags(a)>3 Then planets(slot).flags(a)=3
        If planets(slot).flags(a)>0 Then planets(slot).flags(a)-=1
        If planets(slot).flags(a)<0 Then planets(slot).flags(a)+=1
    Next

    If rnd_range(1,100)<33 Then flag(14)=rnd_range(8,20)
    If rnd_range(1,100)<33 Then planets(slot).flags(15)=1
    If rnd_range(1,100)<33 Then planets(slot).flags(16)=2
    If rnd_range(1,100)<33 Then planets(slot).flags(17)=3
    If rnd_range(1,100)<33 Then planets(slot).flags(18)=4
    If rnd_range(1,100)<33 Then planets(slot).flags(19)=5
    If rnd_range(1,100)<33 Then planets(slot).flags(20)=11


    If awayteam.c.x<0 Then awayteam.c.x=0
    If awayteam.c.y<0 Then awayteam.c.y=0
    If awayteam.c.x>60 Then awayteam.c.x=60
    If awayteam.c.y>20 Then awayteam.c.y=20

    '
    ' EXPLORE PLANET
    '

    dawn=rnd_range(1,60)
    
    Do
        b=0
        For a=1 To lastenemy
            if _debug>0 then dprint cords(enemy(a).c)
            If enemy(a).c.x=awayteam.c.x And enemy(a).c.y=awayteam.c.y Then
                if _debug>0 then dprint "Moving enemies"
                enemy(a).c=movepoint(enemy(a).c,5)
                b=1
            EndIf
        Next
    Loop Until b=0
    if _debug>0 then dprint "lastenemy"&lastenemy
    If debug=99 And _debug=1 Then dprint "Death in:" &planets(slot).death &"(in)"
    
    dprint planets_flavortext(slot),15
        
    If no_enemys=1 Then lastenemy=0
    
    if _debug>0 then dprint slot &":"& bonesflag
    
    If _debug=11 Then
        dprint "Setting screen"
        Sleep
    EndIf
    
    awayteam.slot=slot
    
    If savefrom(0).map=0 Then
        
        nextmap=ep_planetmenu(awayteam.c,slot,shipfire(),spawnmask(),lsp,localtemp(awayteam.c.x,awayteam.c.y))
        If nextmap.m=-1 Then Return nextmap
    EndIf
        
    savefrom(0)=savefrom(16)
    if planets(slot).darkness>0 then 
        if planets(slot).depth=0 then
            awayteam.dark=planets(slot).darkness+nightday(awayteam.c.x)
        else
            awayteam.dark=planets(slot).darkness
        endif
    else
        awayteam.dark=0
    endif
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
    
    if _debug=2704 then print #logfile,"Displaystuff"
    Screenset 0,1
    set__color(11,0)
    Cls
    display_planetmap(slot,osx,0)
    ep_display(,nightday(awayteam.c.x))
    display_awayteam()
    Flip
    set__color(11,0)
    Cls
    display_planetmap(slot,osx,0)
    ep_display(,nightday(awayteam.c.x))
    display_awayteam()
    Flip
    
    
    If planets_flavortext(slot)<>"" Then
        no_key=keyin
    EndIf
    
    '***********************
    '
    'Planet Exploration Loop
    '
    '***********************
    Do
        if _debug>0 then dprint "depth:"&planets(slot).depth
        if planets(slot).darkness>0 then 
            if planets(slot).depth=0 then
                awayteam.dark=planets(slot).darkness+nightday(awayteam.c.x)
            else
                awayteam.dark=planets(slot).darkness
            endif
        else
            awayteam.dark=0
        endif
        if awayteam.c.x<0 then awayteam.c.x=0
        if awayteam.c.y<0 then awayteam.c.y=0
        if awayteam.c.x>60 then awayteam.c.x=60
        if awayteam.c.y>20 then awayteam.c.y=20
        If awayteam.teleportrange>0 And  awayteam.teleportload<15 Then awayteam.teleportload+=1
        If awayteam.disease>player.disease Then player.disease=awayteam.disease
        If planets(slot).atmos<=1 Or planets(slot).atmos>=7 Then awayteam.helmet=1
        If (tmap(awayteam.c.x,awayteam.c.y).no=1 Or tmap(awayteam.c.x,awayteam.c.y).no=26 Or tmap(awayteam.c.x,awayteam.c.y).no=20) And awayteam.hp<=awayteam.nohp*5 Then awayteam.oxygen=awayteam.oxygen+tmap(awayteam.c.x,awayteam.c.y).oxyuse
        If tmap(awayteam.c.x,awayteam.c.y).oxyuse<0 Then awayteam.oxygen=awayteam.oxygen-tmap(awayteam.c.x,awayteam.c.y).oxyuse
        If awayteam.oxygen>awayteam.oxymax Then awayteam.oxygen=awayteam.oxymax

        adislastenemy=lastenemy
        adisloctemp=localtemp(awayteam.c.x,awayteam.c.y)
        adisloctime=nightday(awayteam.c.x)

        If configflag(con_warnings)=0 And nightday(awayteam.c.x)=1 And nightday(old.x)<>1 Then dprint "The sun rises"
        If configflag(con_warnings)=0 And nightday(awayteam.c.x)=2 And nightday(old.x)<>2 Then dprint "The sun sets"
        if _Debug=2704 then print #logfile,"Update masks"
        lsp=ep_updatemasks(watermap(),localtemp(),cloudmap(),spawnmask(),mapmask(),nightday(),dawn,dawn2)
        mapmask(awayteam.c.x,awayteam.c.y)=-9
        
        com_sinkheat(player,0)
            
        localturn=localturn+1
             
        If localturn Mod 10=0 Then
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
            If planets(slot).depth=0 Then
                player.turn+=2
            Else
                player.turn+=1
            EndIf
            
            if _debug=2704 then print #logfile,"2"
            ep_tileeffects(areaeffect(),last_ae,lavapoint(),nightday(),localtemp(),cloudmap())
            ep_lava(lavapoint())
            lastenemy=ep_spawning(spawnmask(),lsp,diesize,nightday())
            ep_shipfire(shipfire())
            ep_items(localturn)
            Screenset 0,1
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            display_awayteam()
            ep_display_clouds(cloudmap())
            walking=alerts()
            dprint("")
            Flip
        EndIf
        
        
        if _debug=2704 then print #logfile,"3 ae"&awayteam.e.e
        deadcounter=ep_monstermove(spawnmask(),lsp,mapmask(),nightday())

        If player.dead>0 Or awayteam.hp<=0 Then allowed=""

        If ship_landing>0 And nextmap.m<>0 Then ship_landing=1 'Lands immediately if you changed maps
        If ship_landing>0 Then ep_landship(ship_landing, nextlanding, nextmap)

        
        if _debug=2704 then print #logfile,"4 ae"&awayteam.e.e
        
        If  tmap(awayteam.c.x,awayteam.c.y).resources>0 Or planetmap(awayteam.c.x,awayteam.c.y,slot)=17 Or  (tmap(awayteam.c.x,awayteam.c.y).no>2 And tmap(awayteam.c.x,awayteam.c.y).gives>0 And player.dead=0 And (awayteam.c.x<>old.x Or awayteam.c.y<>old.y))  Then
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
            old=awayteam.c
            osx=calcosx(awayteam.c.x,planets(slot).depth)
            
            Screenset 0,1
            set__color(11,0)
            Cls
            equip_awayteam(slot)
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            ep_display_clouds(cloudmap())
            display_awayteam()
            dprint ("")

            ep_gives(awayteam,nextmap,shipfire(),spawnmask(),lsp,Key,localtemp(awayteam.c.x,awayteam.c.y))
            If awayteam.movetype=2 Or awayteam.movetype=3 Then allowed=allowed &key_ju
            If awayteam.movetype=4 Then allowed=allowed &key_te
            Flip
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            display_awayteam()
            ep_display_clouds(cloudmap())

            dprint("")
            walking=0
        EndIf

        If (player.dead=0 and awayteam.hp>0 And awayteam.e.tick=-1) Then
            Screenset 0,1
            set__color(11,0)
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
            Cls
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            display_awayteam()
            ep_display_clouds(cloudmap())
            dprint("")
            Flip
            
            Screenset 0,1
            set__color(11,0)
            Cls
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            display_awayteam()
            ep_display_clouds(cloudmap())
            dprint("")
            comstr.nextpage
            Flip
            
            If nextmap.m=0 Then Key=keyin(allowed,walking)
            if _debug=2704 then print #logfile, "&"&key
            If Key="" Then
                screenset 0,1
                Cls
                display_planetmap(slot,osx,0)
                ep_display(,nightday(awayteam.c.x))
                display_awayteam()
                ep_display_clouds(cloudmap())
                dprint("")
                Flip
            EndIf
            awayteam.oxygen=awayteam.oxygen-maximum(awayteam.oxydep*awayteam.helmet,awayteam.oxydep*tmap(awayteam.c.x,awayteam.c.y).oxyuse)-awayteam.leak*awayteam.helmet-awayteam.oxydep*awayteam.helmet*stims.laststim
            If awayteam.oxygen<=0 and (awayteam.helmet=1 or tmap(awayteam.c.x,awayteam.c.y).oxyuse>0) Then 
                text=dam_awayteam(rnd_range(1,awayteam.hp),4)
                if text<>"" then
                    dprint "Asphyxiaction:"&text,12
                    awayteam.oxygen=0
                    if awayteam.hp<=0 and player.dead=0 then player.dead=14
                    text=""
                endif
                if _debug>0 then dprint "PD:"&player.dead & "AHP:"&awayteam.hp
            endif
            
            if _debug=2704 then print #logfile,"&heal"
            
            heal_awayteam(awayteam,0)

            old=awayteam.c
            If walking<>0 Then
                If walking<0 Then
                    tmap(awayteam.c.x,awayteam.c.y).hp-=1
                    awayteam.add_move_cost(-stims.effect)
                    For a=1 To _lines
                        If displaytext(a)="" Then 
                            displaytext(a-1)&="."
                            Exit For
                        EndIf
                    Next
                    If tmap(awayteam.c.x,awayteam.c.y).hp=1 Then
                        walking=0
                        dprint "Complete."
                        Key=key_inspect
                    EndIf
                    dprint ""
                Else
                    If walking<10 Then
                        awayteam.c=movepoint(awayteam.c,walking)
                    EndIf
                    If walking=12 Then
                        If currapwp=lastapwp Then
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            lastapwp=ep_autoexplore(slot)
                            currapwp=0
                        EndIf
                        If lastapwp>0 Then
                            currapwp+=1
                            'awayteam.c=movepoint(awayteam.c,nearest(apwaypoints(currapwp),awayteam.c))
                            If awayteam.movetype>=tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).walktru Or tmap(apwaypoints(currapwp).x,apwaypoints(currapwp).y).onopen<>0 Then
                                awayteam.c=apwaypoints(currapwp)
                                awayteam.c.m=old.m
                            Else
                                walking=0
                            EndIf
                        Else
                            walking=0
                        EndIf

                    EndIf
                EndIf
            Else
                If rnd_range(1,100)<110+countdeadofficers(awayteam.hpmax) Then
                    awayteam.c=movepoint(awayteam.c,getdirection(Key),wraparound)
                    If getdirection(Key)<>0 Then
                        Key=""
                    EndIf
                Else
                    dprint "Your security personel want to return to the ship.",14
                    If rnd_range(1,100)<66 Then
                        awayteam.c=movepoint(awayteam.c,nearest(player.landed,awayteam.c))

                    Else
                        awayteam.c=movepoint(awayteam.c,5)
                    EndIf
                EndIf
            EndIf
            
            if _debug=2704 then print #logfile,"hitmonster"
            ep_playerhitmonster(old,mapmask())
            ep_checkmove(old,Key)
            'If walking>=0 and tmap(awayteam.c.x,awayteam.c.y).no>=128 and tmap(awayteam.c.x,awayteam.c.y).no<=143 and tmap(awayteam.c.x,awayteam.c.y).no<>241 and ((old.x<>awayteam.c.x Or old.y<>awayteam.c.y) Or Key=key_portal Or Key=key_inspect) Then nextmap=ep_Portal()
            ep_planeteffect(shipfire(),sf,lavapoint(),localturn,cloudmap())
            ep_areaeffects(areaeffect(),last_ae,lavapoint(),cloudmap())
            If old.x<>awayteam.c.x Or old.y<>awayteam.c.y Or Key=key_pickup Then ep_pickupitem(Key)
            If old.x<>awayteam.c.x Or old.y<>awayteam.c.y Or Key=key_portal Then nextmap=ep_portal
            if tmap(old.x,old.y).no<>tmap(awayteam.c.x,awayteam.c.y).no and len(trim(tmap(awayteam.c.x,awayteam.c.y).desc))>18 then dprint tmap(awayteam.c.x,awayteam.c.y).desc '&planetmap(awayteam.c.x,awayteam.c.y,map)
        
            If Key=key_inspect Or _autoinspect=0 And (old.x<>awayteam.c.x Or old.y<>awayteam.c.y) Then ep_inspect(localturn)
            If vacuum(awayteam.c.x,awayteam.c.y)=1 And awayteam.helmet=0 Then ep_helmet()
            If vacuum(awayteam.c.x,awayteam.c.y)=0 And vacuum(old.x,old.y)=1 And awayteam.helmet=1 Then ep_helmet
            'Display all stuff
            Screenset 0,1
            set__color(11,0)
            Cls
            if _debug>0 and stims.effect<>0 then dprint "Stims:"&stims.effect &" "&awayteam.e.e
            osx=calcosx(awayteam.c.x,planets(slot).depth)
            
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
            display_planetmap(slot,osx,0)
            ep_display(,nightday(awayteam.c.x))
            ep_display_clouds(cloudmap())
            display_awayteam()
            
            ep_atship()

            comstr.t=key_ex &" examine;" &key_fi &" fire,"&key_autofire &" autofire;" &key_autoexplore &" autoexplore;"
            comstr.t=comstr.t & key_gr &" grenade;" &key_oxy &" open/close helmet;" &key_close &" close door;" &key_drop &" Drop;"
            comstr.t=comstr.t & key_he &" use medpack;" &key_report &" bioreport;"&key_ra &" radio;"
            If awayteam.movetype=2 Or awayteam.movetype=3 Then comstr.t=comstr.t &key_ju &" Jetpackjump;"
            If awayteam.teleportrange>0 Then comstr.t=comstr.t &key_te &" Teleport;"

            set__color( 11,0)
            For x=0 To 60
                If x-osx>=0 And x-osx<=_mwx And nightday(x)=1 Then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh2/2,Chr(193),Font2,_tcol)
                If x-osx>=0 And x-osx<=_mwx And nightday(x)=2 Then draw_string((x-osx)*_fw1,21*_fh1+(_fh1-_fh2)/2-_fh1/2,Chr(193),Font2,_tcol)
            Next
            dprint ""
            Flip
            if _debug=2704 then print logfile,"drew everything again and flipped"
            'screenset 1,1

            If rnd_range(1,100)<disease(awayteam.disease).nac Then
                Key=""
                dprint "ZZZZZZZZZZZzzzzzzzz",14
                awayteam.e.add_action(50-stims.effect)
            EndIf
            
            If Key<>"" And walking>0 Then walking=0
            
            If rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 Then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
            stims.tick
            If Key=key_ex  Then ep_examine()

            If Key=key_save Then
                If askyn("Do you really want to save the game (y/n?)") Then
                   savefrom(0).map=slot
                   savefrom(0).ship=player.landed
                   savefrom(0).awayteam=awayteam
                   savefrom(0).lastenemy=lastenemy
                   For a=1 To lastenemy
                       savefrom(0).enemy(a)=enemy(a)
                   Next
                   player.dead=savegame()
                   'ship.x=-1
                EndIf
            EndIf

            If Key=key_wait Then awayteam.add_move_cost(-stims.effect)

            If Key=key_drop Then ep_dropitem()
            
            If Key=key_awayteam Then
                If awayteam.c.x=player.landed.x And awayteam.c.y=player.landed.y And slot=player.landed.m Then
                    showteam(0)
                Else
                    showteam(1)
                EndIf
            EndIf

            If Key=key_report Then bioreport(slot)

            If Key=key_close Then ep_closedoor()

            If Key=key_gr Then ep_grenade(shipfire(),sf)

            If Key=key_fi Or Key=key_autofire Or walking=10 Then 
                ep_fire(mapmask(),Key,autofire_target)
            else
                target.t.x=-1
            endif
            
            If Key=key_ra Then ep_radio(nextlanding,ship_landing,shipfire(),lavapoint(),sf,nightday(),localtemp())

            If Key=key_oxy Then ep_helmet()

            If Key=key_ju And awayteam.movetype>=2 Then ep_jumppackjump()

            If Key=key_la Then ep_launch(nextmap)

            If Key=key_he Then
                If awayteam.disease>0 Then
                    cure_awayteam(0)
                Else
                    If configflag(con_chosebest)=0 Then
                        c=findbest(11,-1)
                    Else
                        c=get_item(11)
                    EndIf
                    If c>0 Then
                        If item(c).ty<>11 Then
                            dprint "you can't use that."
                        Else
                            If askyn("Do you want to use your "&item(c).desig &"(y/n)?") Then
                                item(c).v1=heal_awayteam(awayteam,item(c).v1)
                                If item(c).v1<=0 Then destroyitem(c)
                            EndIf
                        EndIf
                    Else
                        dprint "you dont have any medpacks"
                    EndIf
                EndIf
                if findbest(30,-1)>0 then
                    if askyn("Do you want to use stims?(y/n)") then
                        If configflag(con_chosebest)=0 Then
                            c=findbest(30,-1)
                        Else
                            c=get_item(30)
                        EndIf
                        if c>0 then 
                            if stims.add(c,awayteam.hp)=0 then
                                if item(c).v2=0 then destroyitem(c)
                            endif
                        endif
                    endif
                endif
                        
                if awayteam.leak>0 then
                    repair_spacesuits
                endif
            EndIf

            If Key=key_walk Or Key=key_autoexplore Then
                If Key<>key_autoexplore Then
                    dprint "Direction? (0 for autoexplore)"
                    no_key=keyin
                    walking=getdirection(no_key)
                Else
                    no_key="0"
                EndIf
                If no_key="0" Then
                    lastapwp=ep_autoexplore(slot)
                    currapwp=0
                    If lastapwp>-1 Then
                        walking=12
                    Else
                        dprint "All explored here."
                    EndIf
                EndIf
            EndIf

            If Key=key_co Or Key=key_of Then ep_communicateoffer(Key)

            If Key=key_te And awayteam.teleportrange>0 Then awayteam.c=teleport(awayteam.c,slot)

        Else
            If player.dead<>0 or awayteam.hp=0 Then allowed=""
        EndIf

        If lastenemy>255 Then lastenemy=255

        'clean up item list
        For a=1 To itemindex.vlast
            If item(itemindex.value(a)).w.s<0 Then
                itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
            Else
                If tmap(item(itemindex.value(a)).w.x,item(itemindex.value(a)).w.y).no>=175 And tmap(item(itemindex.value(a)).w.x,item(itemindex.value(a)).w.y).no<=177 Then
                    destroyitem(itemindex.value(a))
                    itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
                EndIf
            EndIf
        Next
        ' and the world moves on
        update_world(0)
    Loop Until awayteam.hp<=0 or nextmap.m<>0 or player.dead<>0
    if _debug>0 then dprint "Dead:"&player.dead
    if _debug=2704 then print #logfile,"1"&nextmap.m
    '
    ' END exploring

    location=lc_onship
    For a=1 To itemindex.vlast
        If item(itemindex.value(a)).ty=45 And item(itemindex.value(a)).w.p<9999 And item(itemindex.value(a)).w.s=0 Then 'Alien bomb
            If item(itemindex.value(a)).v2=1 Then
                p1.x=item(itemindex.value(a)).w.x
                p1.y=item(itemindex.value(a)).w.y
                item(itemindex.value(a)).w.p=9999
                alienbomb(itemindex.value(a),slot)

            EndIf
        EndIf
    Next

    For a=0 To lastitem
        If item(a).w.p=9999 Then
            item(a)=item(lastitem)
            lastitem=lastitem-1
        EndIf
    Next

    b=0
    For a=1 To lastenemy
        If enemy(a).hp>0 Then b=b+1
    Next
    If b=0 Then planets(slot).genozide=1

    If awayteam.hp<=0 Then
        reward(2)=0
        reward(1)=0
        For a=1 To lastdrifting
            if slot=drifting(a).m and player.dead=3 Then player.dead=25
        Next
        If player.dead=25 Then player.landed.s=slot
        If player.dead=0 Then             
            player.landed.s=planets(slot).depth
            If slot=specialplanet(0) Then player.dead=8
            If slot=specialplanet(1) Then player.dead=9
            If slot=specialplanet(3) Or slot=specialplanet(4) Then player.dead=10
            If slot=specialplanet(5) Then player.dead=11
            if player.dead=0 then player.dead=3
            display_awayteam()
            dprint "The awayteam has been destroyed.",12
            no_key=keyin
        endif
    EndIf
    
    If player.dead<>0 Then
        old=player.c
        player.c=awayteam.c
        save_bones(1)
        player.c=old'On planet
    EndIf

    If player.dead=0 And planets(slot).atmos>0 And planets(slot).depth=0 And planets(slot).atmos=player.questflag(10) Then
        a=0
        For x=0 To 60
            For y=0 To 20
                a=a+tmap(x,y).vege
                If planetmap(x,y,slot)>0 Then b+=1
            Next
        Next
        If a=0 Then
            dprint "This planet would suit Omega Bioengineerings Requirements."
            player.questflag(10)=-slot
        EndIf
    EndIf

    If planets(slot).depth=0 And planets(slot).flags(21)=0 Then
        a=0
        For x=0 To 60
            For y=0 To 20
                If planetmap(x,y,slot)>0 Then a+=1
            Next
        Next
        If a>=1199 Then
            planets(slot).flags(21)=1
            dprint "You have completely mapped this planet.",10
        EndIf
    EndIf

    If specialplanet(10)=slot Then
        For x=0 To 60
            For y=0 To 20
                If planetmap(x,y,slot)=-60 Then planetmap(x,y,slot)=-4
                If planetmap(x,y,slot)=60 Then planetmap(x,y,slot)=4
            Next
        Next
    EndIf

    If specialplanet(17)=slot Then
        a=1
        For x=0 To 60
            For y=0 To 20
                If Abs(planetmap(x,y,slot))=107 Then a=0
            Next
        Next
        specialflag(17)=a
    EndIf

    If slot=piratebase(0) And planets(slot).genozide=1 Then
        dprint "Congratulations! You have destroyed the pirates base!",10
        reward(6)=50000
        piratebase(0)=-1
        no_key=keyin
    EndIf
    If slot=piratebase(0) And awayteam.hp<=0 Then player.dead=7
    c=0
    For a=1 To _NoPB 'Did main base earlier
        If slot=piratebase(a) Then
            For b=1 To lastenemy
                If enemy(b).hp>0 Then
                    If enemy(b).made=7 Or enemy(b).made=3 Then c=c+1
                EndIf
            Next
            If c=0 And awayteam.hp>0 Then
                reward(8)=reward(8)+10000
                piratebase(a)=-1
            EndIf
        EndIf
    Next

    b=0
    For a=1 To 15
        If slot=savefrom(a).map Then b=a
    Next
    If b=0 Then
        For a=15 To 1 Step -1
            If savefrom(a).map=0 Then b=a
        Next
    EndIf
    If b=0 Then
        For a=1 To 14
            savefrom(a)=savefrom(a+1)
        Next
        savefrom(15)=savefrom(16) '16 bleibt immer leer
        b=15
    EndIf
    a=b
    If lastenemy>255 Then lastenemy=255
    savefrom(a).lastenemy=lastenemy
    savefrom(a).map=slot
    For b=1 To lastenemy
        savefrom(a).enemy(b)=enemy(b)
    Next
    For x=0 To 60
        For y=0 To 20
            tmap(x,y)=tiles(0)
        Next
    Next

    'if slot=specialplanet(12) and player.dead<>0 then player.dead=17
    If player.dead<>0 Then screenshot(3)
    
    if _debug=2704 then print #logfile,"exit"&nextmap.m
    Return nextmap
End Function

function trouble_with_tribbles() as short
    dim as short i
    if rnd_range(1,100)<unattendedtribbles and rnd_range(1,100)<unattendedtribbles then
    select case rnd_range(1,100)
    case 1 to 33
        for i=1 to 9
            if player.cargo(i).x=2 then
                dprint "Some unattended tribbles have gotten into the cargo hold and eaten a whole ton of food!",c_yel
                player.cargo(i).x=1
                exit for
            endif
        next
    case 34 to 66
        if player.cursed=0 then player.cursed=1
    case else
        if missing_ammo>0 then
            for i=1 to 10
                if player.weapons(i).ammo<player.weapons(i).ammomax then
                    player.weapons(i).ammo+=1
                    player.tribbleinfested+=1
                    exit for
                endif
            next
        endif
    end select
    endif
    return 0
end function


Function alienbomb(c As Short,slot As Short) As Short
    Dim As Short a,b,d,e,f,osx,x2
    Dim As _cords p,p1
    p1.x=item(c).w.x
    p1.y=item(c).w.y
    osx=calcosx(awayteam.c.x,planets(slot).depth)

    For e=0 To item(c).v1*6
        Screenset 0,1
        display_planetmap(slot,osx,0)
        For x=0 To 60
            For y=0 To 20
                p.x=x
                p.y=y
                f=Int(distance(p,p1,1))
                set__color( 0,0)
                If f=e  Then set__color( 0,1)
                If f=e+7 Then set__color( 236,15)
                If f=e+6 Then set__color( 236,237)
                If f=e+5 Then set__color( 237,238)
                If f=e+4 Then set__color( 238,239)
                If f=e+3 Then set__color( 239,240)
                If f=e+2 Then set__color( 240,241)
                If f=e+1 Then set__color( 241,1)
                If f=e-1 Then set__color( 0,0)
                If f=e-2 Then set__color( 0,0)
                If f>=e-2 And f<=e+7 Then
                    x2=x-osx
                    If x2<0 Then x2+=61
                    If x2>60 Then x2-=61
                    If configflag(con_tiles)=0 Then
                        If x2>=0 And x2<=_mwx Then Put ((x2)*_tix,y*_tiy),gtiles(gt_no(76+f-e)),trans
                    Else
                        Draw String(x2*_fw1,y*_fh1), Chr(176),,font1,custom,@_col
                    EndIf
                EndIf
                If f<e Then
                    If tmap(x,y).shootable>0 Then
                        d=rnd_range(1,item(c).v1*12)
                        If tmap(p.x,p.y).dr<d Then
                            tmap(p.x,p.y).hp=tmap(p.x,p.y).hp-d
                        Else
                            tmap(p.x,p.y).dr=tmap(p.x,p.y).dr-d
                        EndIf
                        If tmap(x,y).hp<=0 Then
                            If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).turnsinto
                            If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                            tmap(x,y)=tiles(tmap(x,y).turnsinto)
                        EndIf
                    EndIf
                EndIf
            Next
        Next
        Flip
        Sleep 50
    Next

    For e=242 To 249
        For x=0 To 60
            For y=0 To 20
                set__color( e,e)
                If configflag(con_tiles)=0 Then
                    'if x-osx>=0 and x-osx<=_mwx then put ((x-osx)*_tix,y*_tiy),gtiles(gt_no(rnd_range(63,66))),pset
                Else
                    draw_string(x*_fw1,y*_fh1, Chr(176),font1,_col)
                EndIf
            Next
        Next
        Sleep 50
    Next

    For e=0 To lastenemy
        If distance(enemy(e).c,p1,1)<item(c).v1*5 Then enemy(e).hp=enemy(e).hp-item(c).v1*3
    Next
    For e=0 To item(c).v1
        If planets(slot).atmos>1 And item(c).v1>1 Then
            planets(slot).atmos-=1
            item(c).v1-=2
            If planets(slot).atmos=6 Or planets(slot).atmos=12 Then planets(slot).atmos=1
        EndIf
    Next
    For a=1 To itemindex.vlast
        p.x=item(itemindex.value(a)).w.x
        p.y=item(itemindex.value(a)).w.y
        If a=c Or (rnd_range(1,100)+item(c).v1>item(itemindex.value(a)).res And distance(p,p1,1)<item(c).v1*5) Then
            destroyitem(itemindex.value(a))
            itemindex.remove(a,p)
        EndIf
    Next

    display_planetmap(slot,osx,0)


    Return 0
End Function


Function grenade(from As _cords,map As Short) As _cords
    Dim As _cords target,ntarget
    Dim As Single dx,dy,x,y,launcher
    Dim As Short a,ex,r,t,osx
    Dim As String Key
    Dim As _cords p,pts(61*21)

    Dim As Short debug=0

    target.x=from.x
    target.y=from.y
    ntarget.x=from.x
    ntarget.y=from.y
    x=from.x
    y=from.y
    p=from
    launcher=findbest(17,-2)
    If debug=1 And _debug=1 Then dprint ""&launcher
    If launcher>0 Then
        dprint "Choose target"
        Do
            Key=planet_cursor(target,map,osx,1)
            ep_display(osx)
            display_awayteam(,osx)
            Key=Cursor(target,map,osx,,5+item(launcher).v1-planets(map).grav)
            If Key=key_te Or Ucase(Key)=" " Or Multikey(SC_ENTER) Then ex=-1
            If Key=key_quit Or Multikey(SC_ESCAPE) Then ex=1
        Loop Until ex<>0
    Else
        dprint "Choose direction"
        Key=keyin("12346789"&" "&key__esc)
        If getdirection(Key)=0 Then
            ex=1
        Else
            r=3-planets(map).grav
            If getdirection(Key)=1 Then
                dx=-.7
                dy=.7
            EndIf
            If getdirection(Key)=2 Then
                dx=0
                dy=1
            EndIf
            If getdirection(Key)=3 Then
                dx=.7
                dy=.7
            EndIf
            If getdirection(Key)=4 Then
                dx=-1
                dy=0
            EndIf
            If getdirection(Key)=6 Then
                dx=1
                dy=0
            EndIf
            If getdirection(Key)=7 Then
                dx=-.7
                dy=-.7
            EndIf
            If getdirection(Key)=8 Then
                dx=0
                dy=-1
            EndIf
            If getdirection(Key)=9 Then
                dx=.7
                dy=-.7
            EndIf
        EndIf
    EndIf
    If ex=1 Then
        target.x=-1
        target.y=-1
    Else
        If launcher>0 Then
            r=line_in_points(target,from,pts())
            For a=1 To r
                If tmap(pts(a).x,pts(a).y).firetru=1 Then
                    Return pts(a)
                EndIf
            Next
            Return target
        Else

        For a=1 To r
            x=x+dx
            y=y+dy
            t=Abs(planetmap(x,y,map))
            If tiles(t).firetru=1 Then Exit For
        Next
        If planets(map).depth=0 Then
            If x<0 Then x=60
            If x>60 Then x=0
        Else
            If x<0 Then x=0
            If x>60 Then x=60
        EndIf
        If y<0 Then y=0
        If y>20 Then y=20
        target.x=x
        target.y=y
        EndIf
    EndIf
    If debug=1 And _debug=1 Then dprint ""&target.x &":"& target.y
    Return target
End Function

Function teleport(from As _cords,map As Short) As _cords
    Dim target As _cords
    Dim As Short ex,osx,device
    Dim Key As String

    If planets(map).teleport<>0 Then
        dprint "Something is jamming your teleportation device!",14
        Return from
    EndIf
    device=find_working_teleporter
    If device=-1 Then
        dprint "The teleportation device still needs some time to recharge!",14
        Return from
    EndIf
    target=awayteam.c
    Do
        Key=planet_cursor(target,map,osx,1)
        display_awayteam(,osx)
        Key=Cursor(target,map,osx,,item(device).v1)
        If Key=key_te Or Ucase(Key)=" " Or key=key__enter Then ex=1
        If Key=key_quit Or key=key__esc Then ex=-1
    Loop Until ex<>0
    If ex=1 Then
        item(device).v2-=distance(awayteam.c,target,planets(map).depth)
        from.x=target.x
        from.y=target.y
        if _debug>0 then dprint "v2."&item(device).v2 &"_"&distance(awayteam.c,target,planets(map).depth)&cords(awayteam.c)&cords(target)
    EndIf
    Return from
End Function

Function wormhole_ani(target As _cords) As Short
    Dim p(sm_x*sm_y) As _cords
    Dim As Short last,a,c
    last=Line_in_points(target,player.c,p())
    For a=1 To last-1
        player.osx=p(a).x-_mwx/2
        player.osy=p(a).y-10
        If player.osx<=0 Then player.osx=0
        If player.osy<=0 Then player.osy=0
        If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
        If player.osy>=sm_y-20 Then player.osy=sm_y-20
        Screenset 0,1
        Cls
        player.di+=1
        If player.di=5 Then player.di=6
        If player.di>9 Then player.di=1
        display_stars(2)
        display_ship
        dprint ""
        If configflag(con_tiles)=0 Then
            Put ((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
        Else
            set__color( _shipcolor,0)
            draw_string((p(a).x-player.osx)*_fw1,( p(a).y-player.osy)*_fh1,"@",font1,_col)
        EndIf
        Flip
        Sleep 50
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
    Next
    player.c=target
    Return 0
End Function

Function wormhole_travel() As Short
    Dim As Short pl,a,near,b,natural
    Dim As Single d
    d=9999
    natural=1
    For a=laststar+1 To laststar+wormhole
        If player.c.x=map(a).c.x And player.c.y=map(a).c.y Then
            pl=a
        Else
            If distance(map(map(a).planets(1)).c,player.c)<d Then
                near=a
                d=distance(map(map(a).planets(1)).c,player.c)
            EndIf
        EndIf
    Next

    If pl=0 And artflag(25)>0 Then
        pl=near
        natural=0 'No anodata for self made WHs
    EndIf

    If pl>1 And configflag(con_warnings)=0 Then
        If askyn("Travelling through wormholes can be dangerous. Do you really want to?(y/n)")=0 Then pl=0
    EndIf
    If pl>1 And rnd_range(1,100)<whtravelled Then
        dprint "There is a planet orbiting the wormhole!"
        If askyn("Shall we try to land on it? (y/n)") Then
            If whplanet=0 Then makewhplanet
            pl=0
            landing(whplanet)
        EndIf
        whtravelled=101
    EndIf
    If pl>1 Then
        player.towed=0
        If map(pl).planets(2)=0 And whtravelled<101 Then whtravelled+=3
        map(pl).planets(2)=1
        If artflag(16)=0 Then
            b=map(pl).planets(1)
        Else
            dprint "Wormhole navigation system engaged!(+/- to choose wormhole, "&key_la &" to select)",10
            b=wormhole_navigation
        EndIf
        If b>0 Then
        If map(b).planets(2)=0 Then
            ano_money+=CInt(distance(map(b).c,player.c)*5)*natural
        EndIf
            map(b).planets(2)=1
            dprint "you travel through the wormhole.",10
            #IfDef _FMODSOUND
            If configflag(con_sound)=0 Or configflag(con_sound)=2 Then FSOUND_PlaySound(FSOUND_FREE, Sound(5))
            #EndIf
            #IfDef _FBSOUND
            If configflag(con_sound)=0 Or configflag(con_sound)=2 Then fbs_Play_Wave(Sound(5))
            #EndIf
            If rnd_range(1,100)<distance(map(b).c,player.c)+maximum(Abs(spacemap(player.c.x,player.c.y)),5) Then
                add_ano(map(b).c,player.c)
            EndIf
            player.osx=player.c.x-_mwx/2
            player.osy=player.c.y-10
            If player.osx<=0 Then player.osx=0
            If player.osy<=0 Then player.osy=0
            If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
            If player.osy>=sm_y-20 Then player.osy=sm_y-20
            d=0
            If Not(skill_test(player.pilot(0),st_easy+Int(distance(player.c,map(b).c)/8),"Pilot")) And artflag(13)=0 Then d=rnd_range(1,distance(player.c,map(b).c)/5+1)
            player.hull=player.hull-d
            If d>0 Then dprint "Your ship is damaged ("&d &").",12
            wormhole_ani(map(b).c)
            display_ship(1)
            display_stars(1)
            dprint ""
            If player.hull<=0 Then player.dead=24
        EndIf
    EndIf
    Return 0
End Function


Function wormhole_navigation() As Short
    Dim As Short c,d,pl,b,i,wi(wormhole)
    Dim As _cords wp(wormhole)
    Dim As String Key
    For c=laststar+1 To laststar+wormhole
        map(c).discovered=1
        map(c).desig=spectralshrt(map(c).spec)&player.discovered(map(c).spec)&"-"&int(disnbase(map(c).c))&"("&map(c).c.x &":"& map(c).c.y &")"
        
        i+=1
        wp(i)=map(c).c
        wi(i)=c
    Next
    pl=1
    sort_by_distance(player.c,wp(),wi(),wormhole)
    Do
        player.osx=map(wi(pl)).c.x-_mwx/2
        player.osy=map(wi(pl)).c.y-10
        If player.osx<=0 Then player.osx=0
        If player.osy<=0 Then player.osy=0
        If player.osx>=sm_x-_mwx Then player.osx=sm_x-_mwx
        If player.osy>=sm_y-20 Then player.osy=sm_y-20
        display_stars(2)
        display_star(wi(pl),1)
        display_ship


        set__color( 0,11)

        If player.c.x-player.osx>=0 And player.c.x-player.osx<=_mwx And player.c.y-player.osy>=0 And .y-player.osy<=20 Then
            If configflag(con_tiles)=0 Then
                Put ((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1),stiles(player.di,player.ti_no),trans
            Else
                set__color( _shipcolor,0)
                draw_string((player.c.x-player.osx)*_fw1,( player.c.y-player.osy)*_fh1,"@",font1,_col)
            EndIf
        EndIf
        d=Int(distance(player.c,map(wi(pl)).c))
        dprint "Wormhole at "&map(wi(pl)).c.x &":"& map(wi(pl)).c.y &". Distance "&d &" Parsec."
        Key=keyin
        If keyplus(Key) Then pl=pl+1
        If keyminus(Key) Then pl=pl-1
        If pl<1 Then pl=wormhole
        If pl>wormhole Then pl=1
        set__color( 11,0)
        Cls
    Loop Until Key=key__enter Or Key=key_la Or Key=key__esc

    If Key=key__esc Then
        b=-1
    Else
        b=wi(pl)
    EndIf
    Return b
End Function

Function space_radio() As Short
    Dim As Short i,closestfleet,closestdrifter,lc,j,disnum,dis,y
    Dim As _cords p
    Dim dummy As _monster
    Dim du(2) As Short
    Dim debug As Short
    Dim c(25) As _cords
    Dim contacts(25) As Short
    Dim As String fname(8),text,dname(2)
    dname(0)=" (Strong signal)"
    dname(1)=""
    dname(2)=" (Weak signal)"

    gen_fname(fname())

    Dim As Single dd
    ''dim as single df,dd
    ''df=9999
    For i=1 To lastfleet
        If fleet(i).ty=1 Or fleet(i).ty=3 Or fleet(i).ty=6 Or fleet(i).ty=7 Then
            If distance(fleet(i).c,player.c)<player.sensors*2 And lc<25 Then
                lc+=1
                c(lc)=fleet(i).c
                contacts(lc)=i
            EndIf
        EndIf
    Next
    dd=9999
    For i=1 To lastdrifting
        p.x=drifting(i).x
        p.y=drifting(i).y
        If i<=3 Or (planets(drifting(i).m).mon_template(0).made=32 And planets(drifting(i).m).flags(0)=0) Then
            If distance(p,player.c)<player.sensors*2 And lc<25 Then
                lc+=1
                c(lc).x=drifting(i).x
                c(lc).y=drifting(i).y
                contacts(lc)=-i 'Drifters are negative
            EndIf
        EndIf
    Next

    If lc>0 Then
        If lc=1 Then
            i=contacts(lc)
        Else
            text="Contact:"

            sort_by_distance(player.c,c(),contacts(),lc)
            For j=1 To lc
                If contacts(j)>0 Then
                    dis=CInt(distance(player.c,fleet(contacts(j)).c))
                    Select Case dis
                    Case 0 To player.sensors*2/3
                        disnum=0
                    Case player.sensors*2/3 To player.sensors*4/3
                        disnum=1
                    Case Else
                        disnum=2
                    End Select

                    text=text &"/"&fname(fleet(contacts(j)).ty) &dname(disnum)
                Else
                    p.x=drifting(Abs(contacts(j))).x
                    p.y=drifting(Abs(contacts(j))).y
                    dis=CInt(distance(player.c,p))
                    Select Case dis
                    Case 0 To player.sensors*2/3
                        disnum=0
                    Case player.sensors*2/3 To player.sensors*4/3
                        disnum=1
                    Case Else
                        disnum=2
                    End Select
                    text=text &"/"&shiptypes(drifting(Abs(contacts(j))).s)&dname(disnum)
                    If _debug=1310 Then text &="("&contacts(j) &")"
                EndIf
            Next
            text=text &"/Cancel"
            y=(20*_fh1-(lc+1)*_fh2)/_fh1
            If y<0 Then y=0
            i=Menu(bg_ship,text,"",0,y)
            If i=lc+1 Then Return 0
            i=contacts(i)
        EndIf
    Else
        i=0
        dprint "No contact."
    End If
    Select Case i
    Case Is>0
        If fleet(i).ty=1 And i>5 Then
            If fleet(i).con(1)=0 Then
                do_dialog(5,dummy,i)
            Else
                do_dialog(11,dummy,i)
            EndIf
        EndIf
        If fleet(i).ty=3 Then do_dialog(3,dummy,i)
        dummy.lang=fleet(i).ty+26
        dummy.aggr=1
        If debug=2 And _debug=1 Then dprint ""&dummy.lang
        If fleet(i).ty=6 Then communicate(dummy,1,1)
        If fleet(i).ty=7 Then communicate(dummy,1,1)

    Case Is<0
        i=Abs(i)
        If i<=3 Then
            do_dialog(10,dummy,-i)
            Return 0
        EndIf
        p.x=drifting(i).x
        p.y=drifting(i).y
        If planets(drifting(i).m).mon_template(0).made=32 And (planets(drifting(i).m).flags(0)=0 And planets(drifting(i).m).atmos>0) Then
            do_dialog(4,dummy,-i)
        Else
            dprint "They don't answer."
        EndIf

    End Select
    Return 0
End Function


Function launch_probe() As Short
    Dim As Short i,d
    i=get_item(55)
    If i>0 Then
        Screenset 0,1
        set__color(11,0)
        Cls
        display_stars(1)
        display_ship(1)
        dprint "Which direction?"
        Flip
        d=getdirection(keyin())
        If d>0 Then
            lastprobe+=1
            If lastprobe>100 Then lastprobe=1
            probe(lastprobe).x=player.c.x
            probe(lastprobe).y=player.c.y
            probe(lastprobe).m=i
            probe(lastprobe).s=d
            probe(lastprobe).p=item(i).v4
            dprint "Probe launched."
            item(i).w.s=0
        Else
            dprint "Launch cancelled."
        EndIf
    Else
        dprint "You have no probes."
    EndIf
    Return 0
End Function

Function move_probes() As Short
    Dim As Short i,x,y,j,navcom,t,d
    if _debug>0 then dprint "Move probes"
    If lastprobe>0 Then
    navcom=player.equipment(se_navcom)
    For i=1 To lastprobe
        if _debug>0 then dprint "Probe "&i &" exists."
        If probe(i).m>0 Then
            probe(i).z-=item(probe(i).m).v5
            If probe(i).z<=0 Then
                if _debug>0 then dprint "Moving probe "&i
                probe(i).z+=10
                For j=laststar+1 To laststar+wormhole
                    If map(j).c.x=probe(i).x And map(j).c.y=probe(i).y Then
                        map(j).discovered=1
                        If askyn("Do you want to direct the probe into the wormhole?(y/n)") Then
                            If skill_test(player.pilot(0),st_hard) Then
                                t=map(j).planets(1)
                                d=distance(map(t).c,probe(i))
                                probe(i).x=map(t).c.x
                                probe(i).y=map(t).c.y
                                dprint "The probe traveled " &d &" parsecs to "&map(t).c.x &":"&map(t).c.y &"."
                                Exit For
                            Else
                                dprint "You lost contact with the probe."
                                item(probe(i).m).v3=0
                            EndIf
                        EndIf
                    EndIf
                Next

                    probe(i)=movepoint(probe(i),probe(i).s,,1)
                    item(probe(i).m).v3-=1
                    For x=probe(i).x-1 To probe(i).x+1
                        For y=probe(i).y-1 To probe(i).y+1
                            If x>=0 And y>=0 And x<=sm_x And y<=sm_y Then
                                If Abs(spacemap(x,y))<6 Then
                                    spacemap(x,y)=Abs(spacemap(x,y))
                                    If spacemap(x,y)=0 And navcom>0 Then spacemap(x,y)=1
                                EndIf
                                For j=1 To laststar
                                    If map(j).c.x=x And map(j).c.y=y And map(j).spec<8 Then map(j).discovered=1
                                    If map(j).c.x=probe(i).x And map(j).c.y=probe(i).y Then map(j).discovered=1
                                Next
                            EndIf
                        Next
                    Next
                    If Abs(spacemap(probe(i).x,probe(i).y))>=6 And skill_test(player.pilot(0),st_hard) Then spacemap(x,y)=Abs(spacemap(x,y))


                    For j=1 To lastdrifting
                        If drifting(j).x=probe(i).x And drifting(j).y=probe(i).y Then drifting(j).p=1
                    Next
                    If spacemap(probe(i).x,probe(i).y)>1 Then
                        If skill_test(item(probe(i).m).v2,st_average) Then item(probe(i).m).v1-=1
                    EndIf
                EndIf
            EndIf
            If probe(i).x=player.c.x And probe(i).y=player.c.y Then
                If askyn("Do you want to take the probe on board?(y/n)") Then

                    item(probe(i).m).v3=item(probe(i).m).v6 'Refuel
                    item(probe(i).m).w.s=-1 'Refuel
                    If lastprobe>1 Then
                        probe(i)=probe(lastprobe)
                    Else
                        probe(i)=probe(0)
                    EndIf
                    lastprobe-=1
                    Screenset 0,1
                    set__color(11,0)
                    Cls
                    display_stars(1)
                    display_ship
                    dprint ""
                    Flip
                EndIf
            EndIf

        Next
        For i=1 To lastprobe
            If item(probe(i).m).v3<=0 Or item(probe(i).m).v1<=0 Then
                dprint "Lost contact with probe at "&probe(i).x &":"&probe(i).y &".",c_yel
                If lastprobe>1 Then
                    probe(i)=probe(lastprobe)
                Else
                    probe(i)=probe(0)
                EndIf
                lastprobe-=1
            EndIf
        Next
    EndIf
    Return 0
End Function


Function planetflags_toship(m As Short) As _ship
    Dim s As _ship
    Dim As Short f,e
    e=0
    For f=6 To 10
        If planets(m).flags(f)>0 Then
            e=e+1
            s.weapons(e)=make_weapon(planets(m).flags(f))
        EndIf
        If planets(m).flags(f)=-1 Then
            e=e+1
            s.weapons(e)=make_weapon(99)
        EndIf
        If planets(m).flags(f)=-2 Then
            e=e+1
            s.weapons(e)=make_weapon(98)
        EndIf
        If planets(m).flags(f)=-3 Then
            e=e+1
            s.weapons(e)=make_weapon(97)
        EndIf
    Next
    Return s
End Function


Function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
    Dim As Short e,f,c,g,d,x,y,bg
    Dim As String text,help,desc,Key
    Dim As _cords crs,h1,h2
    Dim weapons(1,10) As _weap
    e=0
    ' old weapons
    For f=1 To 5
        If s1.weapons(f).desig<>"" Then
            e=e+1
            weapons(0,e)=s1.weapons(f)
            s1.weapons(f)=make_weapon(0)
        Else
            If f<=s1.h_maxweaponslot Then weapons(0,f).desig="-empty-"
        EndIf
    Next
    'new weapons
    e=0
    For f=1 To 5
        If s2.weapons(f).desig<>"" Then
            e=e+1
            weapons(1,e)=s2.weapons(f)
            s2.weapons(f)=make_weapon(0)
        Else
            If f<=s2.h_maxweaponslot Then weapons(1,f).desig="-empty-"
        EndIf
    Next
    Do
        set__color( 15,0)
        Cls
        draw_string(0,0,"New Ship",font2,_col)
        draw_string(35*_fw2,0,"Old Ship",font2,_col)
        For x=0 To 1
            For y=1 To 5
                bg=0
                If h1.x=x And h1.y=y Then bg=5
                If h2.x=x And h2.y=y Then bg=5
                If crs.x=x And crs.y=y Then bg=11
                set__color( 15,bg)
                draw_string(x*35*_fw2,y*_fh2,Trim(weapons(x,y).desig)&" ",font2,_col)
            Next
        Next
        set__color( 15,0)
        draw_string(5*_fw2,6*_fh2,"x to swap, esc to exit",font2,_col)
        If weapons(crs.x,crs.y).desig<>"-empty-" Then
            help =weapons(crs.x,crs.y).desig & " | | Damage: "&weapons(crs.x,crs.y).dam &" | Range: "&weapons(crs.x,crs.y).range &"\"&weapons(crs.x,crs.y).range*2 &"\" &weapons(crs.x,crs.y).range*3
        Else
            help = "Empty slot"
        EndIf
        textbox(help,2,8,25,11,1)
        set__color( 15,0)
        Key=keyin()
        crs=movepoint(crs,getdirection(Key))
        If crs.x<0 Then crs.x=1
        If crs.x>1 Then crs.x=0
        If crs.y<1 Then crs.y=5
        If crs.y>5 Then crs.y=1
        If crs.x=0 And crs.y>player.h_maxweaponslot+1 Then crs.y=1
        If crs.x=1 And crs.y>s1.h_maxweaponslot+1 Then crs.y=1
        If Key=key__enter Then
            If crs.x=0 Then
                h1=crs
                If crs.y<1 Then crs.y=5
                If crs.y>5 Then crs.y=1
                If crs.y>s2.h_maxweaponslot Then crs.y=s2.h_maxweaponslot
            EndIf
            If crs.x=1 Then
                h2=crs
                If crs.y<1 Then crs.y=5
                If crs.y>5 Then crs.y=1
                If crs.y>s1.h_maxweaponslot Then crs.y=s1.h_maxweaponslot
            EndIf
        EndIf
        If Key="x" And h1.y<>0 And h2.y<>0 Then
            Swap weapons(h1.x,h1.y),weapons(h2.x,h2.y)
        EndIf
    Loop Until Key=key__esc
    For f=1 To player.h_maxweaponslot
        If weapons(0,f).desig<>"-empty-" Then player.weapons(f)=weapons(0,f)
    Next
    recalcshipsbays()
    Return 0
End Function

Function move_monster(i As short, target As _cords,flee as byte,rollover as byte,mapmask() As Byte) As short
    dim as short x,y,x1,y1,ti,j,addp,k,t
    dim as _cords p(8)
    dim as single pd(8)
    for x=enemy(i).c.x-1 to enemy(i).c.x+1
        for y=enemy(i).c.y-1 to enemy(i).c.y+1
            if x<>enemy(i).c.x or y<>enemy(i).c.y then
                x1=x
                y1=y
                addp=0
                if y1>=0 and y<=20 then
                    if x1>=0 and x1<=60 or rollover>0 then
                        if x1<0 then x1+=61
                        if x1>60 then x1-=61
                        ti=tmap(x1,y1).walktru
                        If mapmask(x1,y1)<>0 Then addp=1
                        if enemy(i).hasoxy=0 and vacuum(x1,y1)=1 and vacuum(enemy(i).c.x,enemy(i).c.y)=0 then addp=1
                        If ti>0 Then
                            Select Case enemy(i).movetype
                            Case mt_climb
                                If ti=1 Or ti=5 Then addp=1
                            Case mt_dig
                                If ti=1 Then addp=1
                            Case mt_fly2
                                If ti>4 Then addp=1
                            Case mt_ethereal
                                'Can move through anything
                            Case Else
                                If ti>enemy(i).movetype Then addp=1
                            End Select
                        EndIf
                        if tmap(x1,y1).onopen>0 and enemy(i).pumod+rnd_range(1,12)>st_average then addp=0
                        if addp=0 then
                            j+=1
                            p(j).x=x1
                            p(j).y=y1
                            pd(j)=distance(p(j),target,rollover)
                        endif
                    endif
                endif
            endif
        next
    next
    
    if flee=1 then 'move away
        for k=1 to j
            if pd(k)>pd(0) then
                t=k
                pd(0)=pd(k)
            endif
        next
    else
        pd(0)=9999
        for k=1 to j
            if pd(k)<pd(0) then
                t=k
                pd(0)=pd(k)
            endif
        next
    endif
        
    if t>0 then
        mapmask(enemy(i).c.x,enemy(i).c.y)=0
        enemy(i).c=p(t)
        mapmask(enemy(i).c.x,enemy(i).c.y)=i
        enemy(i).add_move_cost
        enemy(i).attacked=0
        if tmap(enemy(i).c.x,enemy(i).c.y).onopen>0 then
            tmap(enemy(i).c.x,enemy(i).c.y)=tiles(tmap(enemy(i).c.x,enemy(i).c.y).onopen)
        endif
    endif
        
'    
    Return 0
End Function

Function monsterhit(attacker As _monster, defender As _monster,vis As Byte) As _monster
    Dim mname As String
    Dim text As String
    Dim a As Short
    Dim b As Short
    Dim noa As Short
    Dim col As Short
    Dim As Short debug,targetnumber
    if attacker.hp<=0 or defender.hp<=0 then return defender
    if _debug>0 then dprint attacker.sdesc &":"&defender.sdesc
    If vis>0 Then
        If attacker.stuff(1)=1 And attacker.stuff(2)=1 Then mname="flying "
        mname=mname & attacker.sdesc
        text="The "
    Else
        mname="Something"
    EndIf
    If distance(attacker.c,defender.c)<=1.5 Then
        text=text &mname &" attacks: "
    Else
        text=text &mname &" "&attacker.swhat &": "
        col=14
    EndIf
    noa=attacker.hp\7
    If noa<1 Then noa=1
    if _debug>0 then dprint noa &":"& -defender.armor\(6*(defender.hp+1))+attacker.weapon
    if defender.made=0 then 
        targetnumber=15+defender.movetype*3
    else
        targetnumber=15+defender.armor+defender.movetype*3
    endif
    text=text &"(needs "&targetnumber &")"
    For a=1 To noa
        If skill_test(attacker.weapon,targetnumber) Then b=b+1+attacker.weapon
    Next
    
    If defender.made=0 Then
        if b>attacker.hp/10+15 then b=attacker.hp/10+15
        If b>0 Then
            text=text & dam_awayteam(b,,attacker.disease)
            if attacker.specialattack=SA_corrodes then corrode_item
            col=12
        Else
            text=text & " no casualties."
            col=10
        EndIf
        If defender.hp<=0 Then 
            player.killedby=attacker.sdesc
            player.dead=3
        endif
        dprint text,col
    Else
        defender.hp=defender.hp-b 'Monster attacks monster
    EndIf
    attacker.e.add_action(attacker.atcost)
    If debug=1 And _debug=1 Then dprint "DEBUG MESSAGE dam:"& b
    Return defender
End Function

Function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
    Dim As Single nonlet,dis,damage,nldamage
    Dim As Short a,c,weaponused,b
    Dim col As Short
    Dim noa As Short
    Dim text As String
    Dim wtext As String
    Dim mname As String
    Dim xpstring As String
    Dim SLBonus(512) As Byte
    Dim As String echo1,echo2
    Dim slbc As Short
    Dim As Short slot,xpgained,tacbonus,targetnumber
    slot=player.map
    #IfDef _FMODSOUND
    If configflag(con_sound)=0 Or configflag(con_sound)=2 Then FSOUND_PlaySound(FSOUND_FREE, Sound(3))
    #EndIf
    #IfDef _FBSOUND
    If configflag(con_sound)=0 Or configflag(con_sound)=2 Then fbs_Play_Wave(Sound(3))
    #EndIf
    If defender.movetype=mt_fly Then
        mname="flying "
        targetnumber=15
    Else
        targetnumber=12
    EndIf
    targetnumber+=defender.speed/2
    mname=mname &defender.sdesc
    If first=-1 Or last=-1 Then
        first=0
        noa=attacker.hpmax
    Else
        noa=last
    EndIf
    If first<0 Then first=0
    If last>attacker.hpmax Then last=attacker.hpmax
    If player.tactic=3 Then
        tacbonus=0
    Else
        tacbonus=player.tactic
    EndIf

    For a=first To noa 
        If crew(a).hp>0 And crew(a).onship=0 And crew(a).talents(27)>0 and slbc<=512 Then
            for b=1 to 5
                slbc+=1
                SLBonus(slbc)=2+crew(a).talents(27)
            next
        EndIf
    Next
    slbc=1
    dis=distance(defender.c,attacker.c)
    For a=first To noa
        If noa-first<=5 Then
            echo2=crew(a).n &" attacks"
            echo1=crew(a).n &" shoots"
        EndIf
        If crew(a).hp>0 And crew(a).onship=0 And crew(a).disease=0 And distance(defender.c,attacker.c)<=attacker.secweapran(a)+1.5 Then
            slbc+=1
            if dis<1.5 then
                if tohit_gun(a)>tohit_close(a) then
                    weaponused=1
                else
                    weaponused=0
                endif
            else
                weaponused=1
            endif
            If weaponused=1 Then
                If skill_test(-tacbonus+tohit_gun(a)+attacker.secweapthi(a)+SLBonus(slbc),targetnumber,echo1) or defender.sleeping>0 Then
                    damage+=attacker.secweap(a)+add_talent(3,11,.1)+add_talent(a,26,.1)
                    if crew(a).weap>0 and player.tactic<>3 then nldamage+=item(crew(a).weap).v4
                    xpstring=gainxp(0,a)
                    xpgained+=1
                EndIf
            Else
                If skill_test(-tacbonus+tohit_close(a)+SLBonus(slbc),targetnumber,echo2) or defender.sleeping>0 Then
                    damage+=attacker.secweapc(a)+add_talent(3,11,.1)+add_talent(a,25,.1)+crew(a).augment(2)/10
                    if crew(a).blad>0 and player.tactic<>3 then nldamage+=item(crew(a).blad).v4
                    xpstring=gainxp(0,a)
                    xpgained+=1
                EndIf
            EndIf
        EndIf
    Next
    If xpgained=1 Then dprint xpstring,c_gre
    If xpgained>1 Then dprint xpgained &" crewmembers gained 1 Xp.",c_gre
    text="You attack the "&defender.sdesc &"."
    If distance(defender.c,attacker.c)>1.5 Then damage=damage+1-Int(distance(defender.c,attacker.c)/2)
    damage=CInt(damage)-player.tactic+add_talent(3,10,1)
    If damage<0 Then damage=0
    If damage>0 or nldamage>0 Then
       damage=damage-defender.armor
       nldamage=nldamage-defender.armor
       if damage<0 then damage=0
       if nldamage<0 then nldamage=0
       If damage>0 or nldamage>0 Then
            If player.tactic<>3 Then
                text=text &" You hit for " & damage &" points of damage"
                if nldamage>0 and defender.stunres<10 then text=text &" and "&nldamage &" points of nonlethal damage"
                text=text &"."
                if defender.stunres<10 then defender.hpnonlethal+=nldamage
                defender.hp=defender.hp-damage
                if defender.sleeping>0 then defender.add_move_cost
                defender.sleeping=0
            Else
                If defender.stunres<10 Then
                    damage=damage+nldamage
                    damage=damage/2
                    damage=(damage*((10-defender.stunres)/10))
                    if damage>0 then
                        text=text &" You hit for " & damage &" nonlethal points of damage."
                        defender.hpnonlethal+=damage
                    endif
                Else
                    if damage>0 then
                        damage=damage/2
                        defender.hp-=damage
                        text=text &" You hit for " & damage &" points of damage."
                    endif
                EndIf
            EndIf
            If defender.hp/defender.hpmax<0.8 Then wtext =" The " & mname &" is slightly "&defender.dhurt &". "
            If defender.hp/defender.hpmax<0.5 Then wtext =" The " & mname &" is "&defender.dhurt &". "
            If defender.hp/defender.hpmax<0.3 Then wtext =" The " & mname &" is badly "&defender.dhurt &". "
            text=text &wtext
            col=10
            If defender.hp>0 Then 
                defender.target=attacker.c
            Else
                defender.target.x=0
                defender.target.y=0
            EndIf
        Else
            text=text &" You don't penetrate the "&mname &"s armor."
            col=14
        EndIf
    Else
        text=text &" Your fire misses. "
        col=14
    EndIf
    If defender.hp<=0 Then
        text=text &" the "& mname &" "&defender.dkill
        If defender.made=44 Then player.questflag(12)=2
        If defender.made=83 Then player.questflag(20)+=1
        If defender.made=84 Then player.questflag(20)+=2
        player.alienkills=player.alienkills+1
        If defender.allied>0 Then factionadd(0,defender.allied,1)
        If defender.enemy>0 Then factionadd(0,defender.enemy,-1)
        If defender.slot>=0 Then planets(slot).mon_killed(defender.slot)+=1
    Else
        If defender.hp=1 And damage>0 And defender.aggr<>2 Then
            If rnd_range(1,6) +rnd_range(1,6)<defender.intel+defender.diet And defender.speed>0 Then
                defender.aggr=2
                text=text &"the " &mname &" is critically hurt and tries to flee. "
            EndIf
        endif
        if defender.hp>1 and damage>0 and defender.aggr>0 then
            If defender.aggr>0 And defender.hp<defender.hpmax Then
                If distance(defender.c,attacker.c)<=1.5 Or defender.intel+rnd_range(1,6)>attacker.invis Then
                    defender.aggr=0
                    text=text &" the "&mname &" tries to defend itself."
                Else
                    text=text &" the "&mname &" looks confused into your general direction"
                EndIf
            EndIf
        EndIf
    EndIf
    dprint text,col
    Return defender
End Function


Function clear_gamestate() As Short
    Dim As Short a,x,y
    Dim d_crew As _crewmember
    Dim d_planet As _planet
    Dim d_ship As _ship
    Dim d_map As _stars
    Dim d_fleet As _fleet
    Dim d_basis As _basis
    Dim d_drifter As _driftingship
    Dim d_item As _items
    Dim d_share As _share
    Dim d_company As _company
    Dim d_portal As _transfer
    set__color(15,0)
    Draw String(_screenx/2-7*_fw1,_screeny/2),"Resetting game",,font2,custom,@_col
    make_eventplanet(0,1) 'Clear static array
    player=d_ship

    For a=0 To 255
        crew(a)=d_crew
    Next
    
    for a=1 to lastshop
        shoplist(a)=shoplist(0)
    next
    lastshop=0
    
    For a=0 To laststar+wormhole
        map(a)=d_map
    Next
    wormhole=8

    For a=0 To max_maps
        planets(a)=d_planet
        For x=0 To 60
            For y=0 To 20
                planetmap(x,y,a)=0
            Next
        Next
    Next
    lastplanet=0

    For a=0 To lastspecial
        specialplanet(a)=0
    Next

    For a=0 To lastfleet
        fleet(a)=d_fleet
    Next
    lastfleet=0

    For a=1 To lastdrifting
        drifting(a)=d_drifter
    Next
    lastdrifting=16


    For a=0 To 25000
        item(a)=d_item
    Next
    lastitem=-1


    Wage=10
    
    baseprice(1)=50
    baseprice(2)=200
    baseprice(3)=500
    baseprice(4)=1000
    baseprice(5)=2500

    For a=0 To 5
        avgprice(a)=0
    Next
    For a=0 To 4
        companystats(a)=d_company
    Next
    For a=0 To 2047
        shares(a)=d_share
    Next
    lastshare=0


    For a=0 To 20
        flag(a)=0
    Next

    For a=0 To lastflag
        artflag(a)=0
    Next

    lastportal=0
    For a=0 To ubound(portal)
        portal(a)=d_portal
    Next
    
    set_globals

    Return 0
End Function

Dim As Byte attempts


' error handling

Dim as Short ErrorNr
Dim as Short ErrorLn
Dim as String ErrText

Function log_error(text as string) As Short
	Dim As integer f
	dim as string logfile
	if gamerunning then 
		logfile= "savegames/" & player.desig & "-"
	else 
		logfile= ""
	EndIf
	
	f=Freefile
	if Open(logfile & "error.log", For Append, As #f)=0 then
		if LOF(f)>32*1024 then
			Close #f	' its getting stupidly large
			f=Freefile	' get a new handle and rewrite it
			if Open("error.log", For Output, As #f)<>0 then
				return -1
			EndIf
	 	EndIf
		Print #f, date + " " + time + " " + __VERSION__  + " " + text
		Close #f
		return 0
	Endif
	
	return -1
End Function

Function error_handler(text as string) As Short
	dim as string logfile
    screenset 1,1
	dprint "Fatal Error: Key to continue",c_red
    no_key=keyin
    log_error(text)
	'
	Screenset 1,1
	Cls
	Locate 10,10
	set__color( 14,0)
	Print text
	Locate 12,10
	set__color( 12,0)
	If gamerunning=1 Then
		logfile= "savegames/" & player.desig 
		Print "Please send " & logfile & "-crash.sav and " & logfile & "-error.log to matthias mennel."
	else
		Print "Please send error.log to matthias mennel."
	endif
	Locate 13,10
	Print "The email address is: matthias.mennel@gmail.com"
	set__color( 14,0)
	'
	If gamerunning=1 Then
		Locate 15,0
     	if savegame(1)<0 then
			text= "Failed to save the crashed game."
			log_error(text)
      	Print text
	   EndIf
	EndIf
	'
	'goto WAITANDEXIT
	return 0
End Function

function stripFileExtension(text as string, delim as string=".") As String 
	dim as Integer i = Instrrev(text,delim)
	if i=0 then return text
	return left(text,i-1)
End Function

function lastword(text as string, delim as string, capacity as short=29) As String
	Dim As String w(capacity)
	return w(string_towords(w(),text,delim))
End Function

#if __FB_DEBUG__
Function log_warning(aFile as string, aFunct as string, iLine as short, text as string) as Short
	aFile= ucase(stripFileExtension(lastword(aFile,"\")))
	return not log_error( "Warning! "+aFile+":"+aFunct +" line " & iLine & ": "+text)
End Function
#endif

ERRORMESSAGE:
	On Error goto 0
	ErrorNr= Err
	ErrorLn= Erl
	ErrText= ucase(stripFileExtension(lastword(*ERMN(),"\")))
	ErrText= ErrText &":" &*ERFN() &" reporting Error #" &ErrorNr &" at line " &ErrorLn &"!"  

	Error_Handler(ErrText)
WAITANDEXIT:
	Print
	Print
	set__color( 12,0)
	Print "Press any key to exit"
	do while inkey<>"" 
		loop
	Sleep
	End ErrorNr