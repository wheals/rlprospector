

Function target_landing(mapslot As Short,Test As Short=0) As Short
    Dim As _cords p
    Dim As String Key
    Dim As Short c,osx
    set__color(11,0)
    Cls
    Screenset 1,1
    
    If mapslot=specialplanet(29) And findbest(89,-1)>0 Then mapslot=specialplanet(30)
    If mapslot=specialplanet(30) And findbest(89,-1)=-1 Then mapslot=specialplanet(29)
    If mapslot=specialplanet(29) Then specialflag(30)=1
    update_tmap(mapslot)
    dprint "Choose landing site"
    p.x=30
    p.y=10
    Key=get_planet_cords(p,mapslot)
    If Key=key__enter Then
        Do
            p=movepoint(p,5)
            c+=1
            player.fuel-=1
        Loop Until c>5 Or (tiles(Abs(planetmap(p.x,p.y,mapslot))).gives=0 And tiles(Abs(planetmap(p.x,p.y,mapslot))).walktru=0 And skill_test(player.pilot(0),st_easy+c+planets(mapslot).grav+planets(mapslot).dens,"Pilot:"))
        If c<=5 Then
            dprint gainxp(2),c_gre
            landing(mapslot,p.x,p.y,0)
        Else
            dprint "Couldn't land there, landing aborted",14
        EndIf
    EndIf
    Return 0
End Function

function landing_landingpads(pads() as _cords, last as short,mapslot as short) as short
    dim as _cords p,p2
    dim as short i,osx,x,j,best
    dim as single d
    dim as string key
    if last=1 then return 1
    p=pads(1)
    i=1
    dprint "Chose landing pad(+/-)"
    do
        screenset 0,1
        cls
        osx=calcosx(p.x,0)
        display_planetmap(mapslot,osx,4)
        display_ship
        dprint("")
        if configflag(con_tiles)=1 then
            set__color( 11,11)
            draw string (p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
        else
            x=p.x-osx
            if x<0 then x+=61
            if x>60 then x-=61
            if x>=0 and x<=_mwx then put ((x)*_tix,(p.y)*_tiy),gtiles(85),trans
        endif
        flip
        key=keyin("+-"&key_north &key_south &key__enter &key__esc)
        if key="+" or key="-" then
            if key="+" or key=key_north then i+=1
            if key="-" or key=key_south then i-=1
            if i<1 then i=last
            if i>last then i=1
        endif
        if key=key_north or key=key_south or key=key_east or key=key_west then
            best=0
            d=9999
            p2=movepoint(p,getdirection(key))'Move p2 into direction
            'find closest point to p2 that isn't p
            for j=1 to last
                if j<>i then
                    if distance(p2,pads(j))<d then
                        if (key=key_north and pads(j).y<=p2.y) or (key=key_south and pads(j).y>=p2.y) or (key=key_west and pads(j).x<=p2.x) or (key=key_east and pads(j).x>=p2.x) then
                            d=distance(p2,pads(j))
                            best=j
                        endif
                    endif
                endif
            next
            if best>0 then
                i=best
            endif
        end if
        
        p=pads(i)
    loop until key=key__enter or key=key__esc
    if key=key__esc then i=-1
    key=""
    return i
end function


Function landing(mapslot As Short,lx As Short=0,ly As Short=0,Test As Short=0) As Short
    Dim As Short l,m,a,b,c,d,dis,alive,dead,roll,target,xx,yy,slot,sys,landingpad,landinggear,who(128),last2,alle
    Dim light As Single
    Dim p As _cords
    Dim As Short  last,debug
    Dim nextmap As _cords
    Dim As _monster delaway
    Dim As String reason
    delaway.optoxy=awayteam.optoxy
    awayteam=delaway
    debug=1

    p.x=lx
    p.y=ly
    If lx=0 And ly=0 Then p=rnd_point(mapslot,0)
    p.m=mapslot
    sys=sysfrommap(mapslot)
    If savefrom(0).map=0 Then
        If mapslot=specialplanet(29) And findbest(89,-1)>0 Then mapslot=specialplanet(30)
        If mapslot=specialplanet(30) And findbest(89,-1)=-1 Then mapslot=specialplanet(29)
        If mapslot=specialplanet(29) Then specialflag(30)=1
        If configflag(con_warnings)=0 And player.hull=1 And planets(mapslot).depth=0 Then
            If Not askyn("Pilot: 'Are you sure captain? I can't guarantee I get this bucket up again'(Y/N)",14) Then Return 0
        EndIf
        If _debug=510 Then
            dprint sys &","&mapslot
        EndIf

        If mapslot>0 Then
            set__color(11,0)
            Cls

            If planetmap(0,0,mapslot)=0 Then makeplanetmap(mapslot,slot,map(sys).spec)
            awayteam.hp=0
            For b=1 To 255
                If crew(b).hpmax>0 And crew(b).hp>0 And crew(b).onship=0 And crew(b).disease=0 Then
                    awayteam.hp+=1
                    crew(b).hp=crew(b).hpmax
                EndIf
            Next
            'awayteam.hpmax=awayteam.hp
            If player.dead=0 Then
                While tiles(Abs(planetmap(p.x,p.y,mapslot))).locked<>0 Or _
                    tiles(Abs(planetmap(p.x,p.y,mapslot))).gives<>0 Or _
                    tiles(Abs(planetmap(p.x,p.y,mapslot))).walktru<>0 Or _
                    Abs(planetmap(p.x,p.y,mapslot))=45 Or _
                    Abs(planetmap(p.x,p.y,mapslot))=80
                    If lx=0 And ly=0 Then
                        p=rnd_point(mapslot,0)
                    Else
                        p=movepoint(p,5,,4)'4=Rollover
                    EndIf
                Wend

                'if ((mapslot=pirateplanet(0) or mapslot=pirateplanet(1) or mapslot=pirateplanet(2)) and player.pirate_agr<=0) or isgasgiant(mapslot)<>0 then
                    For x=0 To 60
                        For y=0 To 20
                            If planetmap(x,y,mapslot)=68 And last<128 Then
                                last+=1
                                pwa(last).x=x
                                pwa(last).y=y
                            EndIf
                        Next
                    Next
                    If last>0 Then
                        If askyn("Shall we use the landingpad to land?(y/n)") Then
                            last=landing_landingpads(pwa(),last,mapslot)
                            if last<0 then return 0
                            p=pwa(last)
                            landingpad=5
                        EndIf
                    EndIf
                'endif
                player.landed.x=p.x
                player.landed.y=p.y
                player.landed.m=mapslot
                nextmap=player.landed
                equip_awayteam(mapslot)
            EndIf

            last2=no_spacesuit(who(),alle)
            If last2>0 And ep_needs_Spacesuit(mapslot,player.landed,reason)<>0 Then
                If alle=0 Then
                    If not(askyn("You will need spacesuits ("& reason &"). Do you want to take "&last2 &" crewmembers who have none with you? (Y/N)")) Then
                        remove_no_spacesuit(who(),last2)
                    EndIf
                Else
                    If not(askyn("You need spacesuits on this planet  ("& reason &") and don't have any. Land anyway? (y/n)")) Then Return 0
                EndIf
            EndIf
                        
            If findbest(10,-1)>-1 And is_drifter(m)=0 Then
                awayteam.stuff(8)=item(findbest(10,-1)).v1 'Sattelite
                dprint "You deploy your satellite."
            EndIf
            
            roll=landingpad+player.pilot(0)+add_talent(2,8,1)
            landinggear=findbest(41,-1)
            If landinggear>0 And landingpad=0 Then roll=roll+item(landinggear).v1
            target=planets(mapslot).dens+2*planets(mapslot).grav^2
            If mapslot<>specialplanet(2) And Test=0 Then
                If skill_test(roll,target,"Pilot") Then
                    If landingpad=0 Then
                        dprint ("Your pilot succesfully landed in the difficult terrain",10)
                    Else
                        dprint ("You landed on the landinpad",10)
                    EndIf
                    player.fuel=player.fuel-1
                    dprint gainxp(2),c_gre
                Else
                    If landingpad=0 Then
                        dprint ("your pilot damaged the ship trying to land in difficult terrain.",12)
                    Else
                        dprint ("your pilot actually manged to damage the ship while landing on a landing pad!",12)
                    EndIf
                    player.hull=player.hull-1
                    player.fuel=player.fuel-2-Int(planets(mapslot).grav)
                    If player.hull<=0 Then
                        dprint ("A Crash landing. you will never be able to start with that thing again",12)
                        If skill_test(player.pilot(0),st_veryhard,"Pilot") Then
                            dprint ("but your pilot wants to try anyway and succeeds!",12)
                            player.hull=1
                        Else
                            player.dead=4
                        EndIf
                        no_key=keyin
                    EndIf
                EndIf
            EndIf
        EndIf
        If is_gardenworld(nextmap.m) Then changemoral(3,0)
        awayteam.oxygen=awayteam.oxymax
        awayteam.jpfuel=awayteam.jpfuelmax

        Else
            awayteam=savefrom(0).awayteam
            nextmap=savefrom(0).ship
            nextmap.m=savefrom(0).map
        EndIf
        
        #IfDef _FMODSOUND
        If (configflag(con_sound)=0 Or configflag(con_sound)=2) And mapslot>0 Then FSOUND_PlaySound(FSOUND_FREE, Sound(11))
        #EndIf
        #IfDef _FBSOUND
        If (configflag(con_sound)=0 Or configflag(con_sound)=2) And mapslot>0 Then fbs_Play_Wave(Sound(11))
        #EndIf
        
        If player.dead=0 And awayteam.hp>0 Then
            
            Do
                savegame
                equip_awayteam(slot)
                nextmap=explore_planet(nextmap,slot)
                removeequip
                
                c=1
                For b=2 To 255
                    If crew(b).hp<=0 Then
                        crew(b)=crew(0)
                    Else
                        c+=1
                    EndIf
                Next
                If c>127 Then c=127

                For b=2 To c-1
                    If crew(b).hpmax=0 Then
                        Swap crew(b),crew(b+1)
                    EndIf
                Next
                
            Loop Until nextmap.m=-1 Or player.dead<>0 or awayteam.hp<=0
            
            For c=0 To 127
                For b=6 To 127
                    If crew(b).hp<=0 Then Swap crew(b),crew(b+1)
                Next

            Next
            For b=0 To 127
                If crew(b).onship=4 Then
                    crew(b).onship=crew(b).oldonship
                EndIf
            Next
            removeequip
            'artifacts?
            If reward(5)>0 Then
                If reward(5)=1 Then
                    player.fuelmax=200
                EndIf
                If reward(5)=2 Then
                    player.stuff(1)=3
                EndIf
                If reward(5)=3 Then
                    slot=get_random_system()
                    If slot<0 Then slot=rnd_range(0,laststar)
                    map(slot).discovered=1
                    For b=1 To 9
                        If map(slot).planets(b)>0 Then
                        If planetmap(0,0,map(slot).planets(b))=0 Then makeplanetmap(map(slot).planets(b),b,map(sys).spec)
                        reward(0)=reward(0)+1200
                        reward(7)=reward(7)+600
                        For xx=0 To 60
                            For yy=0 To 20
                                If planetmap(xx,yy,map(slot).planets(b))<0 Then planetmap(xx,yy,map(slot).planets(b))=planetmap(xx,yy,map(slot).planets(b))*-1
                            Next
                        Next
                        EndIf
                    Next
                    dprint "the data from the computer describes a system with the coordinates "& map(slot).c.x &":" & map(slot).c.y
                EndIf
                If reward(5)=4 Then
                    player.stuff(2)=3
                EndIf
                If reward(5)=5 Then
                    player.stuff(0)=3
                EndIf
                reward(5)=0

            EndIf
        EndIf
        c=6
        dis=0
        
        stims.clear
        
        If crew(1).hp<=0 And player.dead=0 Then
            crew(1).hp=crew(1).hpmax
            b=rnd_range(1,3)
            If b=1 Then dprint "Captain "&crew(1).n &" was just unconcious.",10
            If b=2 Then dprint "Captain "&crew(1).n &" got better.",10
            If b=3 Then dprint "Captain "&crew(1).n &" miracoulously recovered.",10
        EndIf
        For b=1 To 128
            If crew(b).hp<crew(b).hpmax And crew(b).hp>0 And crew(b).disease=0 Then crew(b).hp=crew(b).hpmax
        Next
        For b=6 To 128
            If crew(b).hp<=0 Then
                crew(b)=crew(0)
            Else
                If crew(b).disease>dis Then dis=crew(b).disease
                c+=1
            EndIf
        Next
        awayteam.disease=dis
        d=0
        Do
            d+=1
            a=0
            For b=6 To c-1
                If crew(b).hpmax=0 And crew(b+1).hpmax>0 Then
                    Swap crew(b),crew(b+1)
                    a=1
                EndIf
            Next
        Loop Until a=0 Or d>=1000
        For b=0 To lastitem
            If item(b).w.s<0 Then
                item(b).w.s=-1
                item(b).w.m=0
                item(b).w.p=0
            EndIf
        Next
        player.landed.m=0
        display_stars(1)
        display_ship
        If awayteam.stuff(8)=1 And player.dead=0 And Test=0 And planets(slot).depth=0 Then
            If skill_test(player.pilot(0)+player.tractor,st_easy,"Pilot:") Then
                dprint "You rendevouz with your satellite and take it back in",10
            Else
                dprint "When trying to rendevouz with your satellite your pilot rams and destroys it.",12
                item(findbest(10,-1))=item(lastitem)
                lastitem=lastitem-1
                no_key=keyin
            EndIf
        Else
            dprint ""
        EndIf
    Return 0
End Function

Function scanning() As Short
    Dim mapslot As Short
    Dim As Short slot
    Dim sys As Short
    Dim scanned As Short
    Dim itemfound As Short
    Dim a As Short
    Dim b As Short
    Dim x As Short
    Dim y As Short
    Dim Key As String
    Dim As Short osx
    Dim As Single roll,target
    Dim debug As Byte
    Dim As Short plife,mining
    debug=1
    'if getsystem(player)>0 then
    a=getplanet(get_system())
    slot=a
    update_tmap(slot)
    If a>0 Then
        sys=get_system()
        mapslot=map(sys).planets(a)
        If mapslot=specialplanet(29) And findbest(89,-1)>0 Then mapslot=specialplanet(30)
        If mapslot=specialplanet(30) And findbest(89,-1)=-1 Then mapslot=specialplanet(29)
        If mapslot=specialplanet(29) Then specialflag(30)=1
        If mapslot<0 And mapslot>-20000 Then map(sys).planets(a)=asteroid_mining(mapslot)
        If mapslot=-20001 Then dprint "A helium-hydrogen gas giant"
        If mapslot=-20002 Then dprint "A methane-ammonia gas giant"
        If mapslot=-20003 Then dprint "A hot jupiter"
        If mapslot<-20000 Or is_gasgiant(mapslot)>0 Then gasgiant_fueling(mapslot,a,sys)
        If mapslot>0 And is_gasgiant(mapslot)=0 Then
        If planetmap(0,0,mapslot)=0 Then
            makeplanetmap(mapslot,a,map(sys).spec)
            'makefinalmap(mapslot)
        EndIf
        If planets(mapslot).mapstat=0 Then planets(mapslot).mapstat=1
        make_locallist(mapslot)
        move_rover(mapslot)

        For x=60 To 0 Step -1
            For y=0 To 20
                target=st_average+(planets(mapslot).mapped/100*player.sensors)+planets(mapslot).dens
                If Abs(planetmap(x,y,mapslot))=8 Then target=target-1
                If Abs(planetmap(x,y,mapslot))=7 Then target=target-2
                If Abs(planetmap(x,y,mapslot))=99 Then mining=1
                If skill_test(minimum(player.science(0)+1,player.sensors),target) And planetmap(x,y,mapslot)<0 Then
                    planetmap(x,y,mapslot)=planetmap(x,y,mapslot)*-1
                    tmap(x,y)=tiles(planetmap(x,y,mapslot))
                    reward(0)=reward(0)+.4+player.sensors/10
                    reward(7)=reward(7)+planets(mapslot).mapmod
                    scanned=scanned+1
                    
                EndIf
            Next
        Next
        For b=0 To lastitem
            If item(b).w.m=mapslot And item(b).w.p=0 And item(b).w.s=0 Then
                target=st_hard+planets(mapslot).dens*item(a).scanmod
                If skill_test(add_talent(4,15,1)+minimum(player.science(0),player.sensors)*item(b).scanmod,target) Then
                    item(b).discovered=1
                    itemfound+=1
                EndIf
            EndIf
        Next
        planets(mapslot).mapped=planets(mapslot).mapped+scanned
        If scanned>50 Then dprint gainxp(4),c_gre
        set__color(11,0)
        Cls
        If mapslot=player.questflag(7) Then dprint "This is the planet Eridiani Explorations wants us to map completely"
        If mapslot=piratebase(0) Then
            dprint "Science Officer: 'There is a starport on this planet.'",15
        EndIf
        For a=0 To lastspecial
            If mapslot=specialplanet(a) Then
                If specialflag(a)<=1 Then
                    If specialplanettext(a,specialflag(a))<>"" Then
                        dprint specialplanettext(a,specialflag(a)) &" Key to continue",15
                        no_key=keyin
                    EndIf
                EndIf
            EndIf
        Next
        dprint "Scanned "&scanned &" km2"
        If itemfound>1 Then dprint "Detected "&itemfound &" objects."
        If itemfound=1 Then dprint "Detected an object."
        If itemfound<1 Then dprint "Detected no objects."
        If mining=1 Then
            If planets(mapslot).flags(22)=-1 Then dprint "A mining station on this planet sends a distress signal. They need medical help.",15
            If planets(mapslot).flags(22)>=0 Then dprint "There is a mining station on this planet. They send greetings.",15
        EndIf
        If planets(mapslot).flags(23)>0 Then dprint "Science Officer: 'I can detect several ships on this planet.",15
        If planets(mapslot).flags(24)>0 Then dprint "Science Officer: 'This planet is completely covered in rain forest. What on first glance appears to be its surface is actually the top layer of a root system.",15
        If planets(mapslot).flags(25)>0 Then dprint "Science Officer: 'The biosphere readings for this planet are off the charts. We sure will find some interesting plants here!",15
        If planets(mapslot).flags(26)>0 Then dprint "Science Officer: A very deep ocean covers this planet. Sensor readings seem to indicate large cave structures at the bottom.",15
        If planets(mapslot).flags(27)>0 Then
            dprint "Science Officer: 'This is a sight you get to see once in a lifetime. The orbit of this planet is unstable and it is about to plunge into its sun! Gravity is ripping open its surface, solar wind blasts its material into space. In a few hours it will be gone.'",15
            planets(mapslot).flags(27)=2
        EndIf
        If is_gardenworld(mapslot) Then dprint "This planet is earthlike."
        If planets(mapslot).colflag(0)>0 Then dprint "There is "& add_a_or_an(companyname(planets(mapslot).colflag(0)),0) &" colony on this planet. They are sending greetings."
        If debug=1 And _debug=1 Then dprint "Map number "&slot &":"& mapslot
        osx=30-_mwx/2

        For a=0 To planets(mapslot).life
            If skill_test(player.science(location),st_hard) Then plife=plife+((planets(mapslot).life+1)*3)/100
        Next
        If plife>1 Then plife=1
        If plife>planets(mapslot).highestlife Then
            planets(mapslot).highestlife=plife
            dprint "Revising earlier lifeform estimate",c_yel
        EndIf
        If planets(mapslot).discovered<2 Then planets(mapslot).discovered=2
        Do
            Screenset 0,1
            Cls
            display_planetmap(mapslot,osx,1)
            dplanet(planets(mapslot),slot,scanned,mapslot)
            dprint ""
            Flip
            no_key=keyin(key_la & key_tala &" abcdefghijklmnopqrstuvwxyz" &key_east &key_west)
            If no_key=key_east Then osx+=1
            If no_key=key_west Then osx-=1
            If osx<0 Then osx=0
            If osx>60-_mwx Then osx=60-_mwx
            set__color(11,0)
            Cls

        Loop Until no_key<>key_east And no_key<>key_west
        If no_key=key_la Then Key=key_la
        If no_key=key_tala Then Key=key_tala
        If Not(skill_test(player.pilot(location),st_veryeasy,"Pilot:")) And player.fuel>30 Then
            dprint "your pilot had to correct the orbit.",14
            x=rnd_range(1,4)-player.pilot(0)
            If x<1 Then x=1
            player.fuel=player.fuel-x

        EndIf
        EndIf
        If Key=key_la Then landing(map(sys).planets(slot))
        If Key=key_tala Then target_landing(map(sys).planets(slot))
    EndIf
    'show_stars(1,0)
    'displayship
    Return 0
End Function

Function asteroid_mining(slot As Short) As Short
    Dim it As _items
    Dim en As _fleet
    Dim As Short f,q,m,roll
    Dim mon(6) As String
    mon(1)="a huge crystaline lifeform, vaguely resembling a spider. It jumps from asteroid to asteroid, it's diet obviously being metal ores. Looks like it has just put our ship on the menu! It is  coming this  way!"
    mon(2)="a huge lifeform made entirely of metal! It is spherical and drifts among the astroids. There are no detectable means of locomotion, except for 3 openenings at the equator. It is radiating high amounts of heat, especially at those openings. Looks like it is a living, moving fission reactor!"
    mon(3)="a dense cloud of living creatures, from microscopic to about 10cm long. They seem to be living insome kind of symbiosis, with different specimen performing different tasks."
    mon(4)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(5)="an enormous blob of living plasma!"
    mon(6)="a gigantic creature resembling a jellyfish!"
    en.ty=2
    m=rnd_range(1,6)
    If show_all Then dprint ""&slot
    roll=rnd_range(1,100)
    slot=slot-rnd_range(1,10)
    player.fuel=player.fuel-1
    If not(skill_test(player.pilot(0),st_hard,"Pilot")) Then player.fuel=player.fuel-rnd_range(1,3)
    If (slot<-11 And slot>-13) Or (slot<-51 And slot>-54)  Then
        dprint "you have discovered a dwarf planet among the asteroids!",10
        no_key=keyin
        lastplanet=lastplanet+1
        slot=lastplanet
    Else
        If skill_test(player.tractor*2+minimum(player.science(0)+1,player.sensors+1)+3*add_talent(2,9,2)+slot,st_average) Then

            Do
                it=make_item(96,f+slot+165,-2)
            Loop Until it.ty=15
            it.v5=it.v5+100
            it.v2=it.v2+100
            it.desig &=" asteroid"
            If askyn("Science officer: 'There is an asteroid containing a high ammount of "&it.desig &". shall we try to take it aboard?'(y/n)") Then
                display_ship()
                q=-1
                Do
                    If configflag(con_warnings)=0 And player.hull=1 Then
                        q=askyn("Pilot: 'If i make a mistake it could be fatal. Shall I really try?'(y/n)")
                    EndIf
                    If q=-1 Then
                        If skill_test(player.pilot(0)+player.tractor*2,st_average,"Pilot") Then
                            q=0
                            placeitem((it),0,0,0,0,-1)
                            reward(2)=reward(2)+it.v5
                            dprint "We got it!",10
                        Else
                            player.hull=player.hull-1
                            display_ship()
                            dprint "Your pilot hit the asteroid, damaging the ship, and changing the asteroids trajectory.",14
                            If player.hull>0 Then
                                q=askyn("try again? (y/n)")
                                If q=-1 Then
                                    dprint "Pilot: 'starting another attempt.'"
                                    Sleep 300
                                EndIf
                            Else
                                q=0
                                player.dead=19
                                Exit Function
                            EndIf
                        EndIf
                    EndIf
                    player.fuel=player.fuel-rnd_range(1,3)
                    roll=roll-1
                    If roll<7 Then q=0
                    If player.fuel<10 Then player.fuel=10
                Loop Until q=0
            Else
                slot=slot+rnd_range(1,2)
                If slot>=0 Then slot =-1
            EndIf
        Else
            dprint "Nothing remarkable."
        EndIf
    EndIf
    If roll<4 Then
        If rnd_range(1,100)<85 Then
            dprint "A ship has been hiding among the asteroids.",14
            If faction(0).war(1)<0 Then
                dprint "It hails us.",10
            Else
                dprint "It attacks!",12
                no_key=keyin
                If rnd_range(1,6)<5 Then
                    en.ty=ft_pirate
                    en.mem(1)=make_ship(3)
                Else
                    en.ty=1
                    en.mem(1)=make_ship(4)
                EndIf
                no_key=keyin
                spacecombat(en,10)
                If player.dead<0 Then player.dead=0
            EndIf
        Else
            dprint "A ship has been hiding among the asteroids.",14
            no_key=keyin
            dprint "Wait. that is no ship. It is "&mon(m) &"!",14
            no_key=keyin
            en.ty=8
            en.mem(1)=make_ship(20+m)
            spacecombat(en,20)

            If player.dead>0 Then
                player.dead=20
            Else
                If player.dead=0 Then
                    dprint "We got very interesting sensor data from that being.",10
                    reward(1)=reward(1)+rnd_range(10,180)*rnd_range(1,maximum(player.science(0),player.sensors))
                    player.alienkills=player.alienkills+1
                Else
                    player.dead=0
                EndIf
            EndIf
        EndIf
        set__color(11,0)
        Cls
        display_ship()
        display_stars(1)
    EndIf
    Return slot
End Function

Function gasgiant_fueling(p As Short, orbit As Short, sys As Short) As Short
    Dim As Short fuel,roll,noa,a,mo,m,probe,probeflag,hydrogenscoop,debug,freebay
    Dim en As _fleet
    Static restfuel As Byte
    Dim As String mon(6)
    mon(1)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(2)="an enormous blob of living plasma!"
    mon(3)="a gigantic creature resembling a jellyfish!"
    mon(4)="a flock of large tube shaped creatures with wide maws and sharp teeth!"
    mon(5)="a huge balloon floating in the wind with five, thin, several kilometers long tentacles!"
    mon(6)="a circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity."
    If p=-20003 Then mo=2
    m=is_gasgiant(p)
    If is_gasgiant(p)>1 Then
        If planetmap(0,0,m)<>0 Then make_special_planet(m)
        If askyn("As you dive into the upper atmosphere of the gas giant your sensor pick up a huge metal structure. It is a platform, big enough to land half a fleet on it, connected to struts that extend out into the atmosphere. Do you want to try to land on it? (y/n)") Then
            landing(map(sys).planets(orbit))
            Return 0
        Else
            p=-20001

        EndIf
    EndIf
    hydrogenscoop=1
    For a=1 To player.h_maxweaponslot
        If player.weapons(a).made=85 Then hydrogenscoop+=1
        If player.weapons(a).made=86 Then hydrogenscoop+=2
    Next
    If askyn("Do you want to refuel in the gas giants atmosphere?(y/n)") Then
        probe=findbest(56,-1)
        If probe>0 Then
            If Not(askyn("Do you want to use your gas mining probe?(y/n)")) Then probe=0
        EndIf
        If probe<=0 Then
            If configflag(con_warnings)=0 And player.hull=1 Then
                If Not(askyn("Pilot: 'If i make a mistake we are doomed. Do you really want to try it? (Y/N)")) Then Return 0
            EndIf
            If not(skill_test(player.pilot(location)+add_talent(2,9,1),st_average+mo,"Pilot")) Then
                dprint "Your Pilot damaged the ship diving into the dense atmosphere",12
                player.hull=player.hull-rnd_range(1,2)
                If p=-20003 Then player.hull=player.hull-1
                display_ship
            EndIf
            If player.hull>0 Then
                If debug=1 And _debug=1 Then dprint ""& hydrogenscoop
                fuel=10+rnd_range(2,7)*hydrogenscoop+add_talent(2,9,3)
                hydrogenscoop-=1
                If hydrogenscoop<=0 Then hydrogenscoop=1
                If p=-20001 Then fuel=fuel+rnd_range(3,11)*hydrogenscoop
                hydrogenscoop-=1
                If hydrogenscoop<=0 Then hydrogenscoop=0
                If p=-20003 Then fuel=fuel+rnd_range(5,15)*hydrogenscoop

                display_ship
            Else
                player.dead=22
            EndIf
            If map(sys).spec=10 Then rg_icechunk()

            If rnd_range(1,100)<19-orbit*2 And player.dead=0 Then
                roll=rnd_range(1,6)
                dprint "While taking up fuel your ship gets attacked by "&mon(roll),14
                no_key=keyin
                noa=1
                If roll=4 Then noa=rnd_range(1,6) +rnd_range(1,6)
                If roll=5 Then noa=rnd_range(1,3)
                If roll=6 Then noa=rnd_range(1,2)
                For a=1 To noa
                    en.ty=9
                    en.mem(a)=make_ship(23+roll)
                Next
                spacecombat(en,21)

                If player.dead>0 Then
                    player.dead=23
                Else
                    If player.dead=0 Then
                        dprint "We got very interesting sensor data during this encounter.",10
                        reward(1)=reward(1)+(roll*3+rnd_range(10,80))*rnd_range(1,maximum(player.science(0),player.sensors))
                        player.alienkills=player.alienkills+1
                    Else
                        player.dead=0
                    EndIf
                EndIf
            EndIf
        Else
            'using probe
            If Not(skill_test(player.pilot(0)+add_talent(2,9,1)-3+item(probe).v2,st_average+mo,"Pilot")) Then item(probe).v1-=1
            If rnd_range(1,100)<38-orbit*2 Then item(probe).v1-=1
            If item(probe).v1<=0 Then
                dprint "We lost contact with the probe.",c_yel
                destroyitem(probe)
            Else
                fuel=25+rnd_range(3,9)+add_talent(2,9,3)
                If p=-20001 Then fuel=fuel+rnd_range(3,9)
                If p=-20003 Then fuel=fuel+rnd_range(5,15)
                If fuel>item(probe).v3 Then fuel=item(probe).v3
                'if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
            EndIf
        EndIf

    EndIf
    If fuel>0 Then
        dprint "you take up "&fuel & " tons of fuel.",10
        player.fuel=player.fuel+fuel
        freebay=getnextfreebay
        If player.fuel>player.fuelmax+player.fuelpod And freebay>0 Then
            If askyn("Do you want to store the excess fuel in a cargobay?(y/n)") Then
                Do
                    player.cargo(freebay).x=10
                    player.cargo(freebay).y=1
                    player.fuel-=30
                    freebay=getnextfreebay
                Loop Until player.fuel<=player.fuelmax+player.fuelpod Or freebay=-1
            EndIf
        EndIf
        If player.fuel>player.fuelmax+player.fuelpod Then player.fuel=player.fuelmax+player.fuelpod
    EndIf


    Return 0
End Function

Function dock_drifting_ship(a As Short)  As Short
    Dim As Short m,b,c,x,y,debug
    Dim p(1024) As _cords
    Dim land As _cords
    Dim As Short Test=0
    debug=1
    m=drifting(a).m
    If a<=3 And rnd_range(1,100)<10+Test And player.turn>5 Then
        station_event(m)
    EndIf
    For x=0 To 60
        For y=0 To 20
            If Abs(planetmap(x,y,m))=203 Then
                b+=1
                p(b).x=x
                p(b).y=y
            EndIf
            if player.questflag(11)=1 and abs(planetmap(x,y,m))=226 then player.questflag(11)=2
        Next
    Next
    c=rnd_range(1,b)
    land.x=p(c).x
    land.y=p(c).y
    land.m=m
    If _debug=11 Then
        dprint "Got through dock_drifting_ship"
        Sleep
    EndIf
    landing(m,p(c).x,p(c).y,1)
    Return 0
End Function
