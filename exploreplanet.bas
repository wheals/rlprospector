function gets_entry(x as short,y as short, slot as short) as short
    if planetmap(x,y,slot)<=2 then return 0 'Water uses gives for ice
    If tmap(x,y).no<2 then return 0
    if tmap(x,y).gives>=69 and tmap(x,y).gives<=76 then return -1
    if tmap(x,y).gives=66 or tmap(x,y).gives=67 then return -1
    if tmap(x,y).gives=59 or tmap(x,y).gives=60 then return -1
    if tmap(x,y).gives=49 then return -1
    if tmap(x,y).gives=50 then return -1
    if tmap(x,y).gives=55 then return -1
    if tmap(x,y).gives>=43 and tmap(x,y).gives<=46 then return -1
    if tmap(x,y).gives>=13 and tmap(x,y).gives<=31 then return -1
    if tmap(x,y).gives>=4 and tmap(x,y).gives<=8 then return -1
    return 0
end function
    
Function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire,spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords
    Dim As Short x,y,entry,launch,explore,a
    Dim As _cords mgcords(24),nextmap
    Dim As String text,Key
    'screenset 1,1
    text="Facilities"
    For x=0 To 60
        For y=0 To 20
            if gets_entry(x,y,slot)=-1 and entry<23 then
                entry+=1
                mgcords(entry).x=x
                mgcords(entry).y=y
                Select Case tmap(x,y).gives
                Case 4 To 8
                    text=text &"/Trading"
                Case 26
                    text=text &"/Store"
                Case 27
                    text=text &"/Bar"
                Case 28
                    text=text &"/Fuel & Ammo"
                Case 29
                    text=text &"/Repair ship"
                Case 30
                    text=text &"/Ship modules"
                Case 31
                    text=text &"/Hulls"
                Case 34
                    text=text &"/Shipweapons"
                Case 35
                    text=text &"/Shipyard"
                Case 42
                    text=text &"/Refits"
                Case 43
                    text=text &"/Sickbay"
                Case 44
                    text=text &"/Arena"
                Case 45
                    text=text &"/Casino"
                Case 46
                    text=text &"/Zoo"
                Case 47
                    text=text &"/Retirement"
                Case 48
                    text=text &"/Titles & Deeds"
                Case 49
                    text=text &"/Custom Items"
                Case 50
                    text=text &"/Administration"
                Case 59
                    text=text &"/Botbin"
                Case Else
                    text=text &"/"&tmap(x,y).desc
                End Select
            EndIf
        Next
    Next
    If entry>2 Then 'Not if there are only a few giving tiles.
        explore=entry+1
        launch=entry+2
        text=text &"/Explore area/Launch"
        Do
            a=Menu(bg_shiptxt,text)
            Select Case a
            Case explore
            Case launch,-1
                nextmap.m=-1
            Case Else
                awayteam.c=mgcords(a)
                awayteam.c.m=awayteam.slot
                ep_gives(awayteam,nextmap,shipfire(),spawnmask(),lsp,Key,loctemp)
            End Select
        Loop Until a=-1 Or a=launch Or a=explore
        If a=explore Then awayteam.c=entrycords
    EndIf
    Return nextmap
End Function


Function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords,cloudmap() As Byte) As Short
    Dim As Short a,b,c,x,y,slot
    Dim As _cords p1
    slot=player.map
    If rnd_range(1,100)<planets(slot).grav+planets(slot).depth+planets(slot).temp\100 And planets(slot).grav>1 Then
        'Earthquake
        last_ae=last_ae+1
        If last_ae>16 Then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,planets(slot).grav*3)*rnd_range(1,planets(slot).grav)
        areaeffect(last_ae).dam=areaeffect(last_ae).rad
        If areaeffect(last_ae).rad>5 Then areaeffect(last_ae).rad=5
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
        areaeffect(last_ae).typ=1
    EndIf

    If rnd_range(1,100)<planets(slot).atmos/5+(planets(slot).water/10)+planets(slot).weat And planets(slot).atmos>3 And planets(slot).temp<0 And planets(slot).depth=0 Then
        'snow
        last_ae=last_ae+1
        If last_ae>16 Then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,4)*rnd_range(1,planets(slot).atmos)
        areaeffect(last_ae).dam=0
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
        If areaeffect(last_ae).rad>5 Then
           areaeffect(last_ae).dur=areaeffect(last_ae).dur+areaeffect(last_ae).rad-5
           areaeffect(last_ae).rad=5
        EndIf
        areaeffect(last_ae).typ=2
    EndIf


    For a=0 To last_ae
        If areaeffect(a).typ=1 And areaeffect(a).dur>0 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            If areaeffect(a).dur=0 Then dprint "The ground rumbles",14'eartquake
            If areaeffect(a).dur=0 And findbest(16,-1)>0 And skill_test(player.science(1),st_average) Then dprint "Originating at "&cords(areaeffect(a).c) &".",14
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
                For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                    If x>=0 And y>=0 And x<=60 And y<=20 Then
                    p1.x=x
                    p1.y=y
                        If distance(p1,areaeffect(a).c)<areaeffect(a).rad Then
                            If show_eq=1 Then
                                Locate p1.y+1,p1.x+1
                                Print "."
                            EndIf
                            'Inside radius, inside map
                            If areaeffect(a).typ=1 Then 'eartquake
                                If areaeffect(a).dur>0 Then
                                    If x=awayteam.c.x And y=awayteam.c.y And skill_test(player.science(1),9) Then
                                        dprint "A tremor",14
                                        If findbest(16,-1)>0 And skill_test(player.science(1),st_average) Then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14
                                    EndIf
                                Else
                                    areaeffect(a).dam=areaeffect(a).dam-distance(p1,areaeffect(a).c)
                                    If areaeffect(a).dam=0 Then areaeffect(a).dam=0
                                    tmap(x,y)=earthquake(tmap(x,y),areaeffect(a).dam-distance(p1,areaeffect(a).c))
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).no
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).no
                                    If rnd_range(1,100)<15-distance(p1,areaeffect(a).c,planets(slot).depth) Then lavapoint(rnd_range(1,5))=p1
                                    If rnd_range(1,100)<3 Then
                                        b=placeitem(make_item(96,-3,-3),x,y,slot)
                                        itemindex.add(b,item(b).w)
                                    EndIf

                                    For b=1 To lastenemy
                                        If enemy(b).c.x=x And enemy(b).c.y=y Then enemy(b).hp=enemy(b).hp-areaeffect(a).dam+distance(p1,areaeffect(a).c)
                                    Next
                                    If x=awayteam.c.x And y=awayteam.c.y And areaeffect(a).dam>distance(p1,areaeffect(a).c) Then
                                        dprint "An Earthquake! "& dam_awayteam(rnd_range(1,areaeffect(a).dam-distance(p1,areaeffect(a).c,planets(slot).depth))),12
                                        player.killedby="Earthquake"
                                    EndIf
                                    areaeffect(a).dam=areaeffect(a).rad
                                EndIf

                            EndIf
                        EndIf
                    EndIf
                Next
            Next
        EndIf
        If areaeffect(a).typ=2 And areaeffect(a).dur>0 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
               For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                   If x>=0 And y>=0 And x<=60 And y<=20 Then
                        p1.x=x
                        p1.y=y
                        If distance(p1,areaeffect(a).c,planets(slot).depth)<= areaeffect(a).rad Then
                            If show_eq=1 Then
                                Locate p1.y+1,p1.x+1
                                set__color( 15,0)
                                Print "."
                            EndIf
                            If tmap(x,y).no=1 Or tmap(x,y).no=2 Then tmap(x,y).hp=tmap(x,y).hp+10
                            If tmap(x,y).no<>7 And tmap(x,y).no<>8 And tmap(x,y).no>2 And tmap(x,y).no<15 And rnd_range(1,100)<8+planets(slot).atmos Then
                                changetile(x,y,slot,145)
                            EndIf
                            If awayteam.c.x=x And awayteam.c.y=y Then dprint "It is snowing."
                        EndIf
                   EndIf
               Next
            Next
        EndIf
        If areaeffect(a).typ=3 Or areaeffect(a).typ=4 Or areaeffect(a).typ=5 Then
            areaeffect(a).dur=areaeffect(a).dur-1
            For x=areaeffect(a).c.x-areaeffect(a).rad To areaeffect(a).c.x+areaeffect(a).rad
               For y=areaeffect(a).c.y-areaeffect(a).rad To areaeffect(a).c.y+areaeffect(a).rad
                   If x>=0 And y>=0 And x<=60 And y<=20 Then
                        p1.x=x
                        p1.y=y
                        If distance(p1,areaeffect(a).c)<= areaeffect(a).rad Then
                            If areaeffect(a).dur=0 Then
                                tmap(x,y)=tiles(0)
                                tmap(x,y)=tiles(Abs(planetmap(x,y,slot)))
                            Else
                                tmap(x,y).ti_no=385
                                tmap(x,y).tile=Asc("~")
                                tmap(x,y).seetru=1
                                tmap(x,y).desc="steam"
                                If planets(slot).atmos>1 Then cloudmap(x,y)+=1
                                If areaeffect(a).typ=3 Then tmap(x,y).col=15
                                If areaeffect(a).typ=4 Then
                                    tmap(x,y).col=104
                                    tmap(x,y).tohit=34
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Acidic steam!"
                                EndIf
                                If areaeffect(a).typ=4 Then
                                    tmap(x,y).col=179
                                    tmap(x,y).tohit=27
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Ammonium steam!"
                                EndIf
                                If areaeffect(a).typ=5 Then
                                    tmap(x,y).col=219
                                    tmap(x,y).desc="smoke"
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                Next
            Next
        EndIf
    Next
    Return 0
End Function

Function ep_atship() As Short
    Dim As Short slot,a,who(128)
    slot=player.map
    If awayteam.c.y=player.landed.y And awayteam.c.x=player.landed.x And slot=player.landed.m Then
        location=lc_onship
        dprint "You are at the ship. Press "&key_la &" to launch."
        If awayteam.oxygen<awayteam.oxymax Then dprint "Refilling oxygen.",10
        awayteam.oxygen=awayteam.oxymax
        If (awayteam.movetype=2 Or awayteam.movetype=3) And awayteam.jpfuel<awayteam.jpfuelmax Then
            dprint "Refilling Jetpacks",10
            awayteam.jpfuel=awayteam.jpfuelmax
        EndIf
        For a=1 To 128
            If crew(a).hp>0 Then
                If crew(a).disease>0 And crew(a).onship=0 Then
                    crew(a).oldonship=crew(a).onship
                    crew(a).onship=1
                    dprint crew(a).n &" is sick and stays at the ship."
                EndIf
                If crew(a).disease=0 And crew(a).onship=0 Then
                    crew(a).onship=crew(a).oldonship
                EndIf
            EndIf
        Next
        if awayteam.leak>0 then repair_spacesuit()
        check_tasty_pretty_cargo
        alerts()
        Return 0
    Else
        location=lc_awayteam
        If no_spacesuit(who())>0 and ep_Needs_spacesuit(slot,awayteam.c)>0 Then
            dprint dam_awayteam(rnd_range(1,ep_needs_spacesuit(slot,awayteam.c)),5),c_red
            if awayteam.hp<=0 then player.dead=14
        EndIf
        Return 0
    EndIf
End Function

Function ep_autoexplore(slot As Short) As Short
    Dim As Short x,y,astarmap(60,20),candidate(60,20),explored,notargets,x1,y1,i

    Dim d As Single
    Dim As _cords p,target,astarpath(1284)
    Dim As Byte debug=0
    For x=0 To 1024
        apwaypoints(x).x=0
        apwaypoints(x).y=0
    Next

    lastapwp=ep_autoexploreroute(astarpath(),awayteam.c,awayteam.movetype,slot)
    If lastapwp>0 Then
        For i=1 To lastapwp
            apwaypoints(i).x=astarpath(i).x
            apwaypoints(i).y=astarpath(i).y
        Next
    EndIf
    Return lastapwp
End Function

Function ep_autoexploreroute(astarpath() As _cords,start As _cords,move As Short, slot As Short, rover As Short=0) As Short
    Dim As Short candidate(60,20)
    Dim As Short x,y,explored,notargets,last,i,debug
    Dim As Single d2,d
    Dim As _cords target,target2,p,path(1283)
    For x=0 To 60
        For y=0 To 20
            If move<tmap(x,y).walktru Then candidate(x,y)=1
            If tmap(x,y).onopen<>0 Then candidate(x,y)=0
        Next
    Next
    flood_fill(start.x,start.y,candidate(),3)
    
    If _debug>0 Then
        Screenset 1,1
        For x=0 To 60
            For y=0 To 20
                If candidate(x,y)=255 Then Pset(x,y)
            Next
        Next
    EndIf
    d2=61*21
    If rover=0 Then
        For i=1 To itemindex.vlast'Can't look up location
            If item(itemindex.value(i)).discovered>0 And candidate(item(itemindex.value(i)).w.x,item(itemindex.value(i)).w.y)=255 Then
                If item(itemindex.value(i)).w.s=0 And item(itemindex.value(i)).w.p=0 Then
                    p.x=item(itemindex.value(i)).w.x
                    p.y=item(itemindex.value(i)).w.y
                    If distance(p,start,planets(slot).depth)<d2 And distance(p,start,planets(slot).depth)>0 Then
                        d2=distance(p,start)
                        notargets+=1
                        target2.x=item(itemindex.value(i)).w.x
                        target2.y=item(itemindex.value(i)).w.y
                    EndIf
                EndIf
            EndIf
        Next
    EndIf
    
    d=61*21
    For x=0 To 60
        For y=0 To 20
            If x<>start.x Or y<>start.y Then
                 If candidate(x,y)=255 And planetmap(x,y,slot)<0 Then
                    p.x=x
                    p.y=y
                    If distance(p,start,planets(slot).depth)<d Then
                        target.x=p.x
                        target.y=p.y
                        d=distance(p,start,planets(slot).depth)
                        notargets+=1
                    EndIf
                EndIf
            EndIf
        Next
    Next
    If notargets=0 Then
        if rover=0 then
            target.x=player.landed.x
            target.y=player.landed.y
        else
            target.x=start.x
            target.y=start.y
            return -1
        endif
    Else
        If debug=1 And _debug=1 Then dprint d &":"& target.x &":"&target.y &"-"&d2 &":"& target2.x &":"&target2.y
        If d2<d Then
            target.x=target2.x
            target.y=target2.y
        EndIf
    EndIf
    If target.x=start.x And target.y=start.y Then Return -1
    last=ep_planetroute(path(),move,start,target,planets(slot).depth)
    If last=-1 Then Return -1
    For i=0 To last
        astarpath(i+1).x=path(i).x
        astarpath(i+1).y=path(i).y
    Next
    last+=1
    Return last
End Function

Function ep_planetroute(route() As _cords,move As Short,start As _cords, target As _cords,rollover As Short) As Short
    Dim As Short x,y,astarmap(60,20)
    For x=0 To 60
        For y=0 To 20
            astarmap(x,y)=tmap(x,y).walktru+tmap(x,y).gives+tmap(x,y).dam
            If move<tmap(x,y).walktru Then astarmap(x,y)=1500
            If tmap(x,y).onopen<>0 Then astarmap(x,y)=0
            If tmap(x,y).no=45 Then astarmap(x,y)=1500
        Next
    Next
    Return a_star(route(),target,start,astarmap(),60,20,0,rollover)
End Function

Function ep_checkmove(ByRef old As _cords,Key As String) As Short
    Dim As Short slot,a,b,c,who(128)
    slot=player.map
    If planetmap(awayteam.c.x,awayteam.c.y,slot)=18 Then
        dprint "you get zapped by a forcefield:"&dam_awayteam(rnd_range(1,6)),12
        If awayteam.armor/awayteam.hp<13 Then awayteam.c=old
        walking=0
    EndIf
    If tmap(awayteam.c.x,awayteam.c.y).locked>0 Then
        b=findbest(12,-1) 'Find best key
        If b>0 Then
            c=item(b).v1
        Else
            c=0
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).no=45 And tmap(old.x,old.y).no<>45 And configflag(con_warnings)=0 Then
        If Not(askyn("do you really want to walk into hot lava?(y/n)")) Then awayteam.c=old
    EndIf

    If vacuum(awayteam.c.x,awayteam.c.y)=1 And vacuum(old.x,old.y)=0 And configflag(con_warnings)=0 Then
        If no_spacesuit(who())>0 Then
            If Not(askyn("do you really want to walk out into the vacuum?(y/n)")) Then awayteam.c=old
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).onopen>0 Then
        planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).onopen
        tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).locked>0 Then
        If Not(skill_test(player.science(1)+c,7+tmap(awayteam.c.x,awayteam.c.y).locked,"Science")) Then' or (tmap(awayteam.c.x,awayteam.c.y).onopen>0 and tmap(awayteam.c.x,awayteam.c.y).locked=0) then
            dprint "Your science officer can't bypass the doorlocks"
            awayteam.c=old
            walking=0
        EndIf
    Else
        tmap(awayteam.c.x,awayteam.c.y).locked=0
        If tmap(awayteam.c.x,awayteam.c.y).onopen>0 Then tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
        If tmap(awayteam.c.x,awayteam.c.y).no=16 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=144
        If tmap(awayteam.c.x,awayteam.c.y).no=93 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=90
        If tmap(awayteam.c.x,awayteam.c.y).no=94 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=91
        If tmap(awayteam.c.x,awayteam.c.y).no=95 Then planetmap(awayteam.c.x,awayteam.c.y,slot)=92
    EndIf

    If planetmap(awayteam.c.x,awayteam.c.y,slot)=54 Then
        If c>0 Then
            item(b)=item(lastitem)
            lastitem=lastitem-1
        EndIf
        If skill_test(player.science(location)+c,st_average) Then
            If skill_test(player.science(location)+c,st_average,"Science") Then
                dprint "You managed to open the door"
                planetmap(awayteam.c.x,awayteam.c.y,slot)=55
                tmap(awayteam.c.x,awayteam.c.y)=tiles(55)
            Else
                dprint "Your science officer cant open the door"
                If rnd_range(1,6)+ rnd_range(1,6)>6 Then
                    dprint "But he sets off an ancient defense mechanism! "&dam_awayteam(rnd_range(1,6))
                    player.killedby="trapped door"
                EndIf
                walking=0
                awayteam.c=old
            EndIf
        Else
            dprint "Your fiddling with the ancient lock destroys it. You will never be able to open that door."
            planetmap(awayteam.c.x,awayteam.c.y,slot)=53
            walking=0
            awayteam.c=old
        EndIf
    EndIf


    If awayteam.movetype<tmap(awayteam.c.x,awayteam.c.y).walktru And configflag(con_diagonals)=0 Then
        awayteam.c=movepoint(old,bestaltdir(getdirection(Key),0),3)
        If awayteam.movetype<tmap(awayteam.c.x,awayteam.c.y).walktru Then awayteam.c=movepoint(old,bestaltdir(getdirection(Key),1))
    EndIf
    If tmap(awayteam.c.x,awayteam.c.y).walktru>awayteam.movetype Then '1= can swim 2= can fly 3=can swim and fly 4= can teleport
        awayteam.c=old
    Else
        'Terrain needs flying or swimmint
        If tmap(awayteam.c.x,awayteam.c.y).walktru=1 Then
            If awayteam.movetype=2 Then
                If awayteam.hp<=awayteam.nojp Then
                    If awayteam.jpfuel>=awayteam.jpfueluse Then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.e.add_action(awayteam.carried-stims.effect)
                    Else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    EndIf
                Else
                    awayteam.c=old
                    dprint "blocked"
                EndIf
            EndIf
        EndIf
        'Terrain needs flying
        If tmap(awayteam.c.x,awayteam.c.y).walktru=2 Then
            If awayteam.movetype<4 Then
                If awayteam.hp<=awayteam.nojp Then
                    If awayteam.jpfuel>=awayteam.jpfueluse Then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.e.add_action(awayteam.carried-stims.effect)
                    Else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    EndIf
                Else
                    awayteam.c=old
                    dprint "blocked"
                EndIf
            EndIf
        EndIf
        If tmap(awayteam.c.x,awayteam.c.y).walktru=4 Then
            If Not(askyn("Do you really want to step over the edge?(y/n)")) Then awayteam.c=old
        EndIf
    EndIf
    If old.x=awayteam.c.x And old.y=awayteam.c.y Then
        If walking>0 And walking<10 Then walking=0
    Else
        awayteam.add_move_cost(-stims.effect)
        awayteam.e.add_action(tmap(awayteam.c.x,awayteam.c.y).movecost)
    EndIf
    Return 0
End Function

Function ep_communicateoffer(Key As String) As Short
    Dim As Short a,b,slot,x,y,cm,monster
    Dim As _cords p2
    Dim As String dkey
    slot=player.map
    b=0
    For x=awayteam.c.x-1 To awayteam.c.x+1
        For y=awayteam.c.y-1 To awayteam.c.y+1
            For a=1 To lastenemy
                If enemy(a).c.x=x And enemy(a).c.y=y And enemy(a).hp>0 Then
                    cm+=1
                    monster=a
                EndIf
            Next

        Next
    Next
    If cm=1 Then
        p2.x=enemy(monster).c.x
        p2.y=enemy(monster).c.y
    Else
        dprint "direction?"
        Do
            dkey=keyin
        Loop Until getdirection(dkey)>0 Or dkey=key__esc
        p2=movepoint(awayteam.c,getdirection(dkey))
    EndIf
    Locate p2.y+1,p2.x+1
    If Key=key_co And planetmap(p2.x,p2.y,slot)=190 Then
        dprint "You hear a voice in your head: 'SUBJUGATE OF BE ANNIHILATED'"
        b=-1
    EndIf
    If Key=key_co And planetmap(p2.x,p2.y,slot)=191 Then do_dialog(1,enemy(lastenemy+1),0)
    For a=1 To lastenemy
        If p2.x=enemy(a).c.x And p2.y=enemy(a).c.y And enemy(a).hp>0 And enemy(a).sleeping<=0 Then b=a
    Next
    If b=0 Then
        If Key=key_co Then dprint "Nobody there to communicate"
        If Key=key_of Then dprint "Nobody there to give something to"
    EndIf
    If b>0 Then awayteam.e.add_action(10-stims.effect)
    If b>0 And Key=key_co Then communicate(enemy(b),slot,b)
    If b>0 And Key=key_of Then giveitem(enemy(b),b)
    Return 0
End Function

Function ep_display_clouds(cloudmap() As Byte) As Short
    Dim As Short x,y,slot,osx,debug,i,x2,y2

    Dim p As _cords
    debug=1
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)

    For x=0 To _mwx
        For y=0 To 20
            If debug=1 And _debug=1 Then
                Color cloudmap(x,y)
                Pset (x,y)
            EndIf
            p.x=x+osx
            p.y=y
            If p.x>60 Then p.x=p.x-61
            If p.x<0 Then p.x=p.x+61
            If vismask(p.x,p.y)>0 And cloudmap(p.x,p.y)>0 Then
                If configflag(con_tiles)=0 Then
                    For i=1 To cloudmap(p.x,p.y)/2
                        select case i
                        case 1
                            x2=2
                            y2=0
                        case 2
                            x2=-2
                            y2=0
                        case 3
                            x2=0
                            y2=2
                        case 4
                            x2=0
                            y2=-2
                        case 5
                            x2=2
                            y2=2
                        case 6
                            x2=-2
                            y2=2
                        case 7
                            x2=2
                            y2=-2
                        case 8
                            x2=-2
                            y2=-2
                        case else
                            x2=0
                            y2=0
                        end select
                        
                    
                        Put ((x*_tix)+x2*i,(y*_tiy)+y2*i),gtiles(gt_no(403)),trans
                    Next
                Else
                    set__color( 15,0)
                    Draw String(x*_fw1,y*_fh1),"~",,Font1,custom,@_col
                EndIf
            EndIf
        Next
    Next
    Return 0
End Function



Function ep_display(osx As Short=555,nightday as short=0) As Short
    Dim As Short a,b,x,y,slot,fg,bg,debug,alp,x2
    Dim As Byte comitem,comdead,comalive,comportal
    Dim As _cords p,p1,p2
    slot=player.map
    If osx=555 Then osx=calcosx(awayteam.c.x,planets(slot).depth)
    
    If disease(awayteam.disease).bli>0 Then
        x=awayteam.c.x
        y=awayteam.c.y
        vismask(x,y)=1
        dtile(x,y,tmap(x,y),vismask(x,y))
        Return 0
    EndIf
    ' Stuff on ground
    make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
    
    For a=1 To itemindex.vlast'Cant use index because unseen grenades burn out too
        If item(itemindex.value(a)).ty=7 And item(itemindex.value(a)).v2=1 Then 'flash grenade
            item(itemindex.value(a)).v3-=1
            p2=item(itemindex.value(a)).w

            If item(itemindex.value(a)).v3>0 Then
                If vismask(p2.x,p2.y)>0 Then
                    make_vismask(item(itemindex.value(a)).w,item(itemindex.value(a)).v3/10,slot,1)
                EndIf
            Else
                'Burnt out, destroy
                destroyitem(itemindex.value(a))
                itemindex.remove(itemindex.value(a),item(itemindex.value(a)).w)
            EndIf
        EndIf
        If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).discovered=1 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s>=0  And item(itemindex.value(a)).v5=0 Then 'Rover
            make_vismask(item(itemindex.value(a)).w,item(itemindex.value(a)).v1+3,slot,1)
        endif
    Next
        
    For x=0 To _mwx
        For y=0 To 20
            p.x=x+osx
            p.y=y
            If p.x>60 Then p.x=p.x-61
            If p.x<0 Then p.x=p.x+61

            'if awayteam.sight>cint(distance(awayteam.c,p)) then
            If vismask(p.x,y)>0 Then
                If planetmap(p.x,y,slot)<0 Then
                    planetmap(p.x,y,slot)=planetmap(p.x,y,slot)*-1
                    reward(0)=reward(0)+1
                    reward(7)=reward(7)+planets(slot).mapmod
                    If tiles(planetmap(p.x,y,slot)).stopwalking>0 And walking<11 Then walking=0
                    If player.questflag(9)=1 And planetmap(p.x,y,slot)=100 Then player.questflag(9)=2
                EndIf
                If rnd_range(1,100)<disease(awayteam.disease).hal Then
                    dtile(x,y,tiles(rnd_range(1,255)),1)
                    planetmap(x,y,slot)=planetmap(x+osx,y,slot)*-1
                Else
                    dtile(x,y,tmap(p.x,y),vismask(p.x,y))
                EndIf
                if _debug=1312 then draw string(p.x*_tix,p.y*_tiy),distance(awayteam.c,p,0)&""
            endif
            
            a=0
            if portalindex.last(p.x,p.y)>0 then 
                display_portal((portalindex.index(p.x,p.y,1)),slot,osx)
                If portal(a).from.m=slot And portal(a).oneway<2 and awayteam.c.x=portal(a).from.x And awayteam.c.y=portal(a).from.y And comstr.comportal=0 Then
                    comstr.t=comstr.t &key_portal &" Enter"
                    comstr.comportal=1
                endif
                If portal(a).oneway=0 and portal(a).dest.m=slot and awayteam.c.x=portal(a).dest.x And awayteam.c.y=portal(a).dest.y And comstr.comportal=0 Then
                    comstr.t=comstr.t &key_portal &" Enter"
                    comstr.comportal=1
                EndIf
            endif
        
            if itemindex.last(p.x,p.y)>0 then
                for b=1 to itemindex.last(p.x,p.y)
                    display_item(itemindex.index(p.x,p.y,b),osx,slot)
                next
            endif
        Next
    Next
    
    display_monsters(osx)
    
    Return 0
End Function

Function ep_needs_spacesuit(slot As Short,c As _cords,ByRef reason As String="") As Short
    Dim dam As Short
    dam=0
    If planets(slot).atmos=1 Or vacuum(c.x,c.y)=1 Then
        reason="vacuum, "
        dam=10
    EndIf
    If planets(slot).atmos=2 Or planets(slot).atmos>=7 Then
        If planets(slot).atmos=2 Then
            reason &= "not enough oxygen, "
        Else
            reason &="no oxygen, "
        EndIf
        dam=5
    EndIf
    If planets(slot).atmos>12 Then dam+=planets(slot).atmos/2
    If planets(slot).temp<-60 Or planets(slot).temp>60 Then
        dam=dam+Abs(planets(slot).temp/60)
        reason=reason &"extreme temperatures, "
    EndIf
    If reason<>"" Then reason=first_uc(Left(reason,Len(reason)-2))
    If dam>50 Then dam=50
    Return dam
End Function

Function ep_dropitem() As Short
    Dim As Short c,d,slot,i,num,j,osx
    Dim As String text
    Dim As _cords ship
    awayteam.e.add_action(10)
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    d=1
    If player.towed<-100 Then
        text="Do you want to build the "
        If player.towed=-101 Then text=text & "base module here?(y/n)"
        If player.towed=-102 Then text=text & "mining station here?(y/n)"
        If player.towed=-103 Then text=text & "defense tower here?(y/n)"
        If player.towed=-104 Then text=text & "raffinery here?(y/n)"
        If player.towed=-105 Then text=text & "factory here?(y/n)"
        If player.towed=-106 Then text=text & "power plant here?(y/n)"
        If player.towed=-107 Then text=text & "life support here?(y/n)"
        If player.towed=-108 Then text=text & "storage facilities here?(y/n)"
        If player.towed=-109 Then text=text & "hydroponic garden?(y/n)"
        If player.towed=-110 Then text=text & "office building here?(y/n)"
        If askyn(text) Then
            planetmap(awayteam.c.x,awayteam.c.y,slot)=-300+player.towed
            tmap(awayteam.c.x,awayteam.c.y)=tiles(-(player.towed-300))
            planets(slot).colony=1
            If player.towed=-101 Then planets(slot).colonystats(0)=10
            If player.towed=-102 Then planets(slot).colonystats(1)+=1
            If player.towed=-103 Then planets(slot).colonystats(2)+=1
            If player.towed=-104 Then planets(slot).colonystats(3)+=1
            If player.towed=-105 Then planets(slot).colonystats(4)+=1
            If player.towed=-106 Then planets(slot).colonystats(5)+=1
            If player.towed=-107 Then planets(slot).colonystats(6)+=1
            If player.towed=-108 Then planets(slot).colonystats(7)+=1
            If player.towed=-109 Then planets(slot).colonystats(8)+=1
            If player.towed=-110 Then planets(slot).colonystats(9)+=1
            player.towed=0
            d=0
        Else
            If askyn("Do you want to drop an item?(y/n)") Then
                d=1
            Else
                d=0
            EndIf
        EndIf
    EndIf
    If d=1 Then
        c=get_item(,,num)
        ep_display()
        display_awayteam(0)
        dprint ""
        If c>=0 Then
            Select Case item(c).ty
            Case Is=45
                If askyn("Do you really want to drop the alien bomb?(y/n)") Then
                    item(c).w.x=awayteam.c.x
                    item(c).w.y=awayteam.c.y
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    itemindex.add(c,awayteam.c)
                    item(c).v2=1
                    dprint "What time do you want to set it to?"
                    item(c).v3=getnumber(1,99,1)
                EndIf
            Case Is=77
                display_awayteam()
                dprint "Where do you want to drop the "&item(c).desig &"?"
                d=getdirection(keyin)
                If d<>-1 Or d<>5 Then
                    item(c).w=movepoint(awayteam.c,d)
                    If tmap(item(c).w.x,item(c).w.y).shootable<>0 Then
                        screenset 1,1
                        com_explosion_ani(item(c).w.x-osx,item(c).w.y)
                        tmap(item(c).w.x,item(c).w.y).hp-=item(c).v1
                        dprint tmap(item(c).w.x,item(c).w.y).desc &" takes "&item(c).v1 &" points of damage."
                        destroyitem(c)
                        If tmap(item(c).w.x,item(c).w.y).hp<=0 And tmap(item(c).w.x,item(c).w.y).turnsinto<>0 Then
                            planetmap(item(c).w.x,item(c).w.y,slot)=tmap(item(c).w.x,item(c).w.y).turnsinto
                            tmap(item(c).w.x,item(c).w.y)=tiles(tmap(item(c).w.x,item(c).w.y).turnsinto)
                        EndIf
                    Else
                        dprint "Can't blow that up."
                    EndIf
                EndIf
            Case Else
                dprint "Dropping " &item(c).desig &"."
                If num>1 Then
                    dprint "How many do you want to drop?(0-"&num &")"
                    num=getnumber(1,num,0)
                EndIf
                If num>0 Then
                    For j=1 To num
                        If c>=0 Then
                            For i=0 To 128
                                If crew(i).pref_lrweap=item(c).uid Then crew(i).pref_lrweap=0
                                If crew(i).pref_ccweap=item(c).uid Then crew(i).pref_ccweap=0
                                If crew(i).pref_armor=item(c).uid Then crew(i).pref_armor=0
                            Next
                            If item(c).ty=18 Then item(c).v5=0
                            item(c).w.x=awayteam.c.x
                            item(c).w.y=awayteam.c.y
                            item(c).w.m=slot
                            item(c).w.s=0
                            item(c).w.p=0
                            If item(c).ty=15 Then
                                reward(2)=reward(2)-item(c).v5
                                combon(2).Value-=item(c).v5
                            EndIf
                            If item(c).ty=24 And tmap(item(c).w.x,item(c).w.y).no=162 Then
                                dprint("you reconnect the machine to the pipes. you notice the humming sound.")
                                no_key=keyin
                                item(c).v1=100
                            EndIf

                            If item(c).ty=26 Or item(c).ty=29 Then
                                reward(1)-=item(c).v3
                            EndIf

                            If item(c).ty=80 Then 'Dropping a tribble
                                lastenemy+=1
                                enemy(lastenemy)=makemonster(101,slot)
                                enemy(lastenemy).slot=16
                                planets(slot).mon_template(enemy(lastenemy).slot)=enemy(lastenemy)
                                enemy(lastenemy).c=item(c).w
                                destroyitem(c)
                            EndIf
                            itemindex.add(c,awayteam.c)
                            c=next_item(c)
                        EndIf
                    Next
                EndIf
            End Select
            equip_awayteam(slot)
            if _debug>0 then dprint "Groundpen:"&awayteam.groundpen
            make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
        EndIf
    EndIf
    Return 0
End Function


Function ep_inspect(ByRef localturn As Short) As Short
    Dim As Short a,b,c,slot,skill,js,kit,rep,freebay
    Dim As _cords p
    slot=player.map
    awayteam.e.add_action(10-stims.effect)
    freebay=getnextfreebay
    b=0
    If _autoinspect=1 And walking=0 And Not((tmap(awayteam.c.x,awayteam.c.y).no>=128 And tmap(awayteam.c.x,awayteam.c.y).no<=143) Or tmap(awayteam.c.x,awayteam.c.y).no=241) Then dprint "You search the area: "&tmap(awayteam.c.x,awayteam.c.y).desc
    If awayteam.c.x=player.landed.x And awayteam.c.y=player.landed.y And awayteam.c.m=player.landed.m Then
        a=findbest(50,1)
        If a>0 And player.hull<player.h_maxhull Then
            If askyn("Do you want to use your ship repair kit to repair your ship?(y/n)") Then
                rep=minimum(player.h_maxhull-player.hull,item(a).v1)
                item(a).v1-=rep
                player.hull+=rep
                If item(a).v1<=0 Then destroyitem(a)
            EndIf
        EndIf
    EndIf
    if awayteam.leak>0 then repair_spacesuits
    If (tmap(awayteam.c.x,awayteam.c.y).no>=128 And tmap(awayteam.c.x,awayteam.c.y).no<=143) Or tmap(awayteam.c.x,awayteam.c.y).no=241 Then
        'Jump ship
        If tmap(awayteam.c.x,awayteam.c.y).hp>1 Then
            If askyn("it will take " &display_time(tmap(awayteam.c.x,awayteam.c.y).hp) & " hours to repair this ship. Do you want to start now? (y/n)") Then
                walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                dprint "Starting repair"
            EndIf
        EndIf

        If tmap(awayteam.c.x,awayteam.c.y).hp=0 Then
            If tmap(awayteam.c.x,awayteam.c.y).no=241 Then
                b=18
            Else
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
            EndIf
            tmap(awayteam.c.x,awayteam.c.y).hp=15+rnd_range(1,6)+rnd_range(0,tmap(awayteam.c.x,awayteam.c.y).no-128)
            If skill_test(maximum(player.pilot(1)-1,player.science(1)),st_hard+b/4,"Repair ship")=-1 Then
                If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") Then
                    walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                    dprint "Starting repair"
                EndIf
            Else
                dprint "This ship is beyond repair"
                
                changetile(awayteam.c.x,awayteam.c.y,slot,62)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                
            EndIf
        EndIf
        If tmap(awayteam.c.x,awayteam.c.y).hp=1 Then
            a=findbest(50,-1)
            If a>0 Then
                kit=item(a).v1
                destroyitem(a)
            Else
                kit=0
            EndIf

            If skill_test(maximum(player.pilot(1)-1,player.science(1))+kit,st_hard,"Repair ship") Then
                dprint "The repair was succesfull!",c_gre
                set__color( 15,0)
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
                If tmap(awayteam.c.x,awayteam.c.y).no=241 Then b=18
                textbox(shiptypes(b) &"||"&makehullbox(b,"data/ships.csv"),2,5,25,15,1)
                If askyn("Do you want to abandon your ship and use this one?") Then
                    a=player.h_no
                    If upgradehull(b,player) Then
                        player.hull=Int(player.hull*0.8)
                        tmap(player.landed.x,player.landed.y)=tiles(127+a)
                        changetile(player.landed.x,player.landed.y,slot,127+a)
                        player.landed.x=awayteam.c.x
                        player.landed.y=awayteam.c.y
                        player.landed.m=slot
                        tmap(player.landed.x,player.landed.y)=tiles(4)
                        planetmap(player.landed.x,player.landed.y,slot)=4
                        If player.hull<1 Then player.hull=1
                        js=1
                        deleteportal(slot,0,awayteam.c.x,awayteam.c.y)
                        make_locallist(slot)
                    else
                        deleteportal(slot,0,awayteam.c.x,awayteam.c.y)
                        add_stranded_ship(b,awayteam.c,slot,0)
                        
                    EndIf
                EndIf
                If js=0 Then
                    changetile(awayteam.c.x,awayteam.c.y,slot,4)
                    tmap(awayteam.c.x,awayteam.c.y)=tiles(4)

                    'planets(lastplanet)=planets(slot)

                EndIf
            Else
                dprint "You couldn't repair the ship.",c_red
                changetile(awayteam.c.x,awayteam.c.y,slot,4)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(4)
            EndIf
        EndIf
        b=1
    EndIf

    For a=1 To lastenemy
        If b=0 And awayteam.c.x=enemy(a).c.x And awayteam.c.y=enemy(a).c.y Then
            If enemy(a).hpmax>0 And enemy(a).hp<=0 And enemy(a).biomod>0 Then
                awayteam.e.add_action(25-stims.effect)
                skill=maximum(player.science(1),player.doctor(1)/2)
                If rnd_range(1,100)<enemy(a).disease*2-awayteam.helmet*3 Then infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                If enemy(a).disease>0 And skill_test(maximum(player.doctor(1),player.science(1)/2),enemy(a).disease/2+7) Then dprint "The creature seems to be a host to dangerous "&disease(enemy(a).disease).cause &"."
                If enemy(a).disease>0 And Not(skill_test(maximum(player.doctor(1),player.science(1)/2)+awayteam.helmet*3,enemy(a).disease)) Then
                    infect(rnd_crewmember,enemy(a).disease)
                    dprint "This creature is infected with "&disease(enemy(a).disease).desig,14
                EndIf
                If (player.science(1)>0) Or (player.doctor(1)>0) Then
                    combon(1).Value+=1
                    kit=findbest(48,-1)
                    If kit>0 Then
                        kit=item(kit).v1
                    Else
                        kit=0
                    EndIf

                    dprint "Recording biodata: "&enemy(a).ldesc
                    If enemy(a).slot>=0 Then
                        If planets(slot).mon_disected(enemy(a).slot)<255  Then planets(slot).mon_disected(enemy(a).slot)+=1
                    EndIf
                    If enemy(a).lang=8 Then dprint "While this beings biochemistry is no doubt remarkable it does not explain it's extraordinarily long lifespan"
                    If enemy(a).hpmax<0 Then enemy(a).hpmax=0
                    If enemy(a).slot>=0 Then reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+get_biodata(enemy(a)))/(planets(slot).mon_disected(enemy(a).slot)/2)
                    If enemy(a).disease=0 Then
                        
                        If enemy(a).hpmax*enemy(a).pretty/10>0 Then dprint "Some parts of this creature would make fine luxury items! You store them seperately."
                        If enemy(a).hpmax*enemy(a).tasty/10>0 Then dprint "Some parts of this creature would make fine food items! You store them seperately."
                        reward(rwrd_pretty)+=enemy(a).hpmax*enemy(a).pretty/10
                        reward(rwrd_tasty)+=enemy(a).hpmax*enemy(a).tasty/10
                        check_tasty_pretty_cargo
                    EndIf
                    enemy(a).hpmax=0
                    b=1
                    If kit>0 And Not(skill_test(maximum(player.doctor(1)/2,player.science(location)),st_average)) Then
                        kit=findbest(48,-1)
                        dprint "The autopsy kit is empty",c_yel
                        destroyitem(kit)
                    EndIf
                Else
                    dprint "No science officer or doctor in the team.",c_yel
                EndIf
            Else
                If (player.science(1)>0) Or (player.doctor(1)>0) Then
                    If enemy(a).hp>0 Then dprint "The " &enemy(a).sdesc &" doesn't want to be dissected alive."
                    If enemy(a).biomod>0 Then dprint "Nothing left to learn here."
                    If enemy(a).biomod=0 Then dprint "Dissecting "&add_a_or_an(enemy(a).sdesc,0) &" doesn't yield any biodata."
                Else
                    dprint "No science officer or doctor in the team.",c_yel
                EndIf
            EndIf
        EndIf
        if distance(awayteam.c,enemy(a).c)<2 and enemy(a).invis=3 then
            if skill_test(player.science(1),st_average) then
                dprint "You discover a sleeping animal hiding here."
                enemy(a).invis=0
            endif
        endif
    Next
    If b=0 And tmap(awayteam.c.x,awayteam.c.y).vege>0 And planets(slot).flags(32)<=planets(slot).life+1+add_talent(4,15,3) Then
        If (player.science(1)>0) Or (player.doctor(1)>0) Then
            skill=maximum(player.science(1),player.doctor(1)/2)
            'dprint ""&tmap(awayteam.c.x,awayteam.c.y).vege

            kit=findbest(49,-1)
            If kit>0 Then
                kit=item(kit).v1
            Else
                kit=0
            EndIf

            If skill_test(skill+tmap(awayteam.c.x,awayteam.c.y).vege+add_talent(4,15,1)+kit,st_average+planets(a).plantsfound) Then
                awayteam.e.add_action(25-stims.effect)
                planets(slot).flags(32)=planets(slot).flags(32)+1
                b=1
                If tmap(awayteam.c.x,awayteam.c.y).no<>179 Then
                    dprint "you have found "&plant_name(tmap(awayteam.c.x,awayteam.c.y))
                    If rnd_range(1,80)-player.science(1)-add_talent(4,14,1)<tmap(awayteam.c.x,awayteam.c.y).vege Then
                        dprint "The plants in this area have developed a biochemistry you have never seen before. Scientists everywhere will find this very interesting."
                        reward(1)=reward(1)+(10+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                    EndIf
                    If rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 Then
                        If Not(skill_test(maximum(player.science(1)/2,player.doctor(1)),st_average)) Then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
                        dprint "This area is contaminated with "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).ldesc
                    EndIf
                    If tmap(awayteam.c.x,awayteam.c.y).disease>0 And skill_test(maximum(player.doctor(1),player.science(1)/2),st_easy+tmap(awayteam.c.x,awayteam.c.y).disease/2) Then dprint "The plants here seem to be a host to dangerous "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).cause &"."
                Else
                    dprint "You collect some spice sand."
                    reward(1)+=rnd_range(1,10)
                EndIf
                reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                planets(slot).plantsfound=planets(slot).plantsfound+1
                If kit>0 And Not(skill_test(maximum(player.doctor(1)/2,player.science(1)),st_average)) Then
                    kit=findbest(49,-1)
                    dprint "The botany kit is empty",c_yel
                    destroyitem(kit)
                EndIf
            EndIf
            tmap(awayteam.c.x,awayteam.c.y).vege=0
        Else
            dprint "No science officer or doctor on the team.",c_yel
        EndIf
    EndIf
    If b=0 Then
        For c=1 To 9
            If c<>5 Then
                p=movepoint(awayteam.c,c)
            Else
                p=awayteam.c
            EndIf
            If tmap(p.x,p.y).turnsoninspect<>0  And skill_test(player.science(1),st_average+tmap(p.x,p.y).turnroll) Then
                awayteam.e.add_action(25-stims.effect)
                b=1
                If tmap(p.x,p.y).turntext<>"" Then dprint tmap(p.x,p.y).turntext
                planetmap(p.x,p.y,slot)=tmap(p.x,p.y).turnsoninspect
                tmap(p.x,p.y)=tiles(tmap(p.x,p.y).turnsoninspect)
            EndIf
        Next
    EndIf
    If b=0 Then
        If planetmap(awayteam.c.x,awayteam.c.y,slot)=107 Then
            b=1
            If askyn("You could propably enhance some of the processes in this factory, to dimnish pollution. (y/n)") Then
                awayteam.e.add_action(200-stims.effect)
                If skill_test(player.science(location),st_hard) Then
                    planets(slot).flags(28)+=1
                    If planets(slot).flags(28)>=5 Then
                        dprint "You manage to reduce the emissions of this factory to sustainable levels.",10
                        planets(slot).flags(28)-=5
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(297)
                        planetmap(awayteam.c.x,awayteam.c.y,slot)=297
                    EndIf
                Else
                    dprint "You do not succeed",14
                EndIf
            EndIf
        EndIf
    EndIf
    If b=0 And _autoinspect=1 Then
        dprint "Nothing of interest here."
    EndIf
    Return 0
End Function

Function ep_items(localturn As Short) As Short
    Dim As Short a,slot,i,x,y,curr,last
    Dim As _cords p1,p2,route(1284)
    Dim As Single dam
    Dim As Short debug=1
    if _debug>0 then dprint "EP ITEMS:"&itemindex.vlast
    for a=1 to itemindex.vlast
            If item(itemindex.value(a)).ty=45 And item(itemindex.value(a)).w.p<9999 And item(itemindex.value(a)).w.s=0 Then 'Alien bomb
                If item(itemindex.value(a)).v2=1 Then
                    item(itemindex.value(a)).v3-=1
                    If item(itemindex.value(a)).v3<10 Or frac(item(itemindex.value(a)).v3/10)=0 Then dprint item(itemindex.value(a)).v3 &""
                    If item(itemindex.value(a)).v3<=0 Then
                        p1.x=item(itemindex.value(a)).w.x
                        p1.y=item(itemindex.value(a)).w.y
                        dam=10/(1+distance(awayteam.c,p1,planets(slot).depth))*item(itemindex.value(a)).v1*10
                        alienbomb(itemindex.value(a),slot)
                        If dam>0 Then dprint dam_awayteam(dam),c_red
                        If player.dead=0 and awayteam.hp<=0 Then player.dead=29
                        itemindex.remove(a,p1)
                    EndIf
                EndIf
            EndIf

            If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).discovered=1 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s>=0  And item(itemindex.value(a)).v5=0 Then 'Rover
                for i=1 to 10
                    ep_rovermove(itemindex.value(a),slot)
                next
            EndIf
            
        Next
        for a=1 to lastteleportdevice
            i=teleportdevices(a)
            if item(i).v2<item(i).v4 then item(i).v2+=item(i).v3
        next
        Return 0
End Function

Function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
    Dim As Short r,slot,a,d
    slot=player.map
    ship_landing=ship_landing-1
    If ship_landing<=0 Then
        If vismask(nextlanding.x,nextlanding.y)>0 And nextmap.m=0 Then dprint "She is coming in"
        If skill_test(player.pilot(location),st_easy+planets(slot).dens+planets(slot).grav,"Pilot") Then
            dprint gainxp(2),c_gre
        Else
            If vismask(nextlanding.x,nextlanding.y)>0 And nextmap.m=0 Then dprint "Hard touchdown!",14
            player.hull=player.hull-1
            player.fuel=player.fuel-2-Int(planets(slot).grav)
            d=rnd_range(1,8)
            If d=5 Then d=9
            If r<-2 Then r=-2
            For a=1 To r*-1
                nextlanding=movepoint(nextlanding,d)
            Next
            If player.hull=0 Then
                dprint ("A Crash landing. you will never be able to start with that thing again",12)
                If skill_test(player.pilot(1),st_veryhard) Then
                    dprint ("but your pilot wants to try anyway and succeeds!",12)
                    player.hull=1
                    dprint gainxp(2),c_gre
                Else
                    if player.dead=0 then player.dead=4
                EndIf
                no_key=keyin
            EndIf
        EndIf
        player.landed.m=slot
        player.landed.x=nextlanding.x
        player.landed.y=nextlanding.y
        For a=1 To lastenemy
            If distance(enemy(a).c,nextlanding,planets(slot).depth)<2 Then
                enemy(a).hp=enemy(a).hp-(player.h_no+planets(slot).grav)/(1+distance(enemy(a).c,nextlanding,planets(slot).depth))
                If vismask(enemy(a).c.x,enemy(a).c.y)>0 Then dprint "The "&enemy(a).sdesc &" gets caught in the blast of the landing ship."
                If rnd_range(1,6)+ rnd_range(1,6)>enemy(a).intel Then
                    enemy(a).aggr=2
                    enemy(a).target=nextlanding
                EndIf
            EndIf
        Next
    EndIf
    Return 0
End Function

Function ep_launch(ByRef nextmap As _cords) As Short
    Dim slot As Short
    slot=player.map
    If awayteam.c.y=player.landed.y And awayteam.c.x=player.landed.x And slot=player.landed.m Then
        If slot=specialplanet(2) Or slot=specialplanet(27)  Then
            If slot=specialplanet(27) Then
                If specialflag(27)=0 Then
                    dprint "As you attempt to start you realize that your landing struts have sunk into the surface of the planet. You try to dig free, but the surface closes around them faster than you can dig. You are stuck!"
                Else
                    dprint "You successfully break free of the living planet."
                    nextmap.m=-1
                    'if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                EndIf
            EndIf
            If slot=specialplanet(2) Then
                If specialflag(2)<>2 Then
                    dprint "As soon as you attempt to start the planetary defense system fires. You won't be able to start until you disable it."
                Else
                    dprint "You start without incident"
                    nextmap.m=-1
                    #IfDef _FMODSOUND
                    If configflag(con_sound)=0 Or configflag(con_sound)=2 Then FSOUND_PlaySound(FSOUND_FREE, Sound(10))
                    #EndIf
                    #IfDef _FBSOUND
                    If configflag(con_sound)=0 Or configflag(con_sound)=2 Then fbs_Play_Wave(Sound(10))
                    #EndIf
                EndIf
            EndIf
        Else
            nextmap.m=-1
            #IfDef _FMODSOUND
            If configflag(con_sound)=0 Or configflag(con_sound)=2 Then FSOUND_PlaySound(FSOUND_FREE, Sound(10))
            #EndIf
            #IfDef _FBSOUND
            If configflag(con_sound)=0 Or configflag(con_sound)=2 Then fbs_Play_Wave(Sound(10))
            #EndIf
        EndIf
    EndIf
    Return 0
End Function

Function ep_planeteffect(shipfire() As _shipfire, ByRef sf As Single,lavapoint() As _cords,localturn As Short,cloudmap() As Byte) As Short
    Dim As Short slot,a,b,r,debug,x,y
    Dim As String text
    Static lastmet As Short
    Dim As _cords p1,p2
    slot=player.map
    lastmet=lastmet+1
    If planets(slot).death>0 Then 'Exploding planet
        If planets(slot).death=8 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then dprint "Science officer: I wouldn't recommend staying much longer.",15
            Else
                If player.pilot(0)>0 Then dprint "Pilot: I am starting to worry. We are getting pretty deep into the gravity well of this planet."
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).death=4 And crew(4).hp>0 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then dprint "Science officer: We really should get back to the ship now!",14
            Else
                If player.pilot(0)>0 Then dprint "Pilot: This thing is falling faster than I thought. Let's get out of here!",c_yel
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).death=2 And crew(4).hp>0 Then
            If planets(slot).flags(28)=0 Then
                If player.science(0)>0 And planets(slot).depth=0 Then dprint "Science officer: This planet is about to fall apart! We must leave! NOW!",12
            Else
                If player.pilot(0)>0 Then dprint "Pilot: We need to get of this icechunk! Now!",c_red
            EndIf
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        EndIf
        If planets(slot).depth=0 And rnd_range(1,100)<33 Then
            sf+=1
            If sf>15 Then sf=0
            shipfire(sf).where=rnd_point
            shipfire(sf).when=1
            shipfire(sf).what=10+sf
            player.weapons(shipfire(sf).what)=make_weapon(rnd_range(1,5))
        EndIf

    EndIf


    If slot=specialplanet(8) And rnd_range(1,100)<33 Then
        set__color( 11,0)
        dprint "lightning strikes you "& dam_awayteam(1),12
        player.killedby="lightning strike"
    EndIf



    If planets(slot).flags(25)=1 And awayteam.helmet=0 Then
        If skill_test(player.science(location),st_hard) And crew(5).hp>0 Then
            dprint "Your science officer has figured out that the hallucinations are caused by pollen. You switch to spacesuit air supply."
            awayteam.helmet=1
            planets(slot).flags(25)=2
        Else
            If rnd_range(1,100)<60 Then
                a=rnd_range(1,4)
                If a=1 Then text="Your science officer remarks: "
                If a=2 Then text="Your pilot remarks: "
                If a=3 Then text="Your gunner says: "
                If a=4 Then text="Your doctor finds some "
                For a=0 To rnd_range(10,20)
                    text=text &Chr(rnd_range(33,200))
                Next
                dprint text
            EndIf
        EndIf
    EndIf

    If slot=specialplanet(1) And rnd_range(1,100)<33 Then
        b=0
        For a=1 To lastenemy
            If enemy(a).made=5 And enemy(a).hp>0 And enemy(a).aggr=0 And pathblock(awayteam.c,enemy(a).c,slot) Then b=a
        Next
        If b>0 Then
            sf+=1
            If sf>15 Then sf=0
            shipfire(sf).when=1
            shipfire(sf).what=10+sf
            player.weapons(shipfire(sf).what)=make_weapon(6)
            player.weapons(shipfire(sf).what).dam=rnd_range(1,4)
            If rnd_range(1,6)+ rnd_range(1,6)+2>8 Then
                dprint "Apollo calls down lightning and strikes you, infidel!"
                shipfire(sf).where=awayteam.c
            Else
                dprint "Apollo calls down lightning .... and misses"
                shipfire(sf).where=movepoint(awayteam.c,5)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
            EndIf
            While distance(shipfire(sf).where,enemy(b).c,planets(slot).depth)<=CInt(player.weapons(shipfire(sf).what).dam/2)
                shipfire(sf).where=movepoint(shipfire(sf).where,5)
            Wend
        EndIf
    EndIf

    If is_gardenworld(slot) And rnd_range(1,100)<5 Then
        a=rnd_range(1,awayteam.hpmax)
        If crew(a).hp>0 And crew(a).typ<9 Then
            b=rnd_range(1,6)
            If b=1 Then dprint crew(a).n &" remarks: 'What a beautiful world this is!'"
            If b=2 Then dprint crew(a).n &" points out a particularly beautiful part of the landscape"
            If b=3 Then dprint crew(a).n &" says: 'I guess I'll settle down here when i retire!'"
            If b=4 Then dprint crew(a).n &" asks: 'How about some extended R&R here?"
            If b=5 Then dprint crew(a).n &" remarks: 'Wondefull'"
            If b=6 Then dprint crew(a).n &" starts picking flowers."
        EndIf
    EndIf
    If sysfrommap(slot)>=0 Then
        If (planets(slot).dens<4 And planets(slot).depth=0 And rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))+countasteroidfields(sysfrommap(slot))*2-map(sysfrommap(slot)).spec And rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))) Or more_mets=1 Then
            If lastmet>1000 And countgasgiants(sysfrommap(slot))=0 And rnd_range(1,100)<countasteroidfields(sysfrommap(slot)) Then
                lastmet=-rnd_range(1,6) 'asteroid shower
                dprint "Suddenly dozens of meteors illuminate the sky!",14
            EndIf
            If lastmet<0 Or (lastmet>1000 And rnd_range(1,100)<30) Or more_mets=1 Then
                ep_crater(shipfire(),sf)
                If lastmet<0 Then 
                    lastmet+=1
                Else
                    lastmet=0
                EndIf
            Else
                lastmet+=1
            EndIf
            If more_mets=1 Then dprint ""&lastmet
            
        EndIf
    EndIf
    If cloudmap(awayteam.c.x,awayteam.c.y)>0 And planets(slot).atmos>6 And rnd_range(1,150)<(planets(slot).dens*planets(slot).weat) And slot<>specialplanet(28) Then
        If planets(slot).temp<300 Then
            dprint "It's raining sulphuric acid! "&dam_awayteam(1),14
        Else
            dprint "It's raining molten lead! "&dam_awayteam(1),14
        EndIf
        player.killedby=" hostile environment"
    EndIf

    If planets(slot).atmos>11 And rnd_range(1,100)<planets(slot).atmos*2 And frac(localturn/20)=0 Then
        corrode_item()
        For a=1 To itemindex.vlast 'Corrosion need to go through all
            If item(itemindex.value(a)).ty<20 Then
                If item(itemindex.value(a)).w.s=0 And rnd_range(1,100)>item(itemindex.value(a)).res Then item(itemindex.value(a)).res-=25
                If item(itemindex.value(a)).res<=0 Then 
                    item(itemindex.value(a)).w.p=9999
                    if vismask(item(itemindex.value(a)).w.x,item(itemindex.value(a)).w.y)>0 then dprint "The "& item(itemindex.value(a)).desig &" dissolves in the corrosive atmosphere."
                endif
                If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).w.p=9999 Then item(itemindex.value(a))=make_item(65) 'Rover debris
            EndIf
        Next
    EndIf

    If specialplanet(5)=slot Or specialplanet(8)=slot Then
        If awayteam.c.x<>player.landed.x Or awayteam.c.y<>player.landed.y Then
            If rnd_range(1,250)-(awayteam.movetype)<((planets(slot).atmos-3)*planets(slot).weat) And planets(slot).depth=0 Then
                'for a=1 to rnd_range(1,3)
                dprint "High speed winds set you of course!",14
                awayteam.c=movepoint(awayteam.c,5)
                'next
            EndIf
        EndIf
    EndIf

    Return 0
End Function

Function ep_pickupitem(Key As String) As Short
    Dim a As Short
    Dim text As String
    For a=1 to itemindex.last(awayteam.c.x,awayteam.c.y) 
        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=0 and item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.s=0 Then
            If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty<>99 Then
                If _autopickup=1 Then text=text &item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                If _autopickup=0 Or Key=key_pickup Then
                    
                    If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=15 Then
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1<5 Then text=text &" You pick up the small amount of "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>=5 And item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1<=10 Then text=text &" You pick up the "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                        If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>10 Then text=text &" You pick up the large amount of "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                    Else
                        text=text &" You pick up the "&item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).desig &". "
                    EndIf
                    reward(2)=reward(2)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5
                    combon(2).Value+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.s=-1
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.m=-0
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=-0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=18 Then
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5=0
                    text=text &" You transfer the map data from the rover robot ("&Fix(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6) &"). "
                    reward(0)=reward(0)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6
                    reward(7)=reward(7)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v6=0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=27 Then
                    text=text &" You gather the resources from the mining robot ("&Fix(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1) &"). "
                    reward(2)=reward(2)+item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1
                    combon(2).Value+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1

                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1=0
                EndIf
                If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty=26 Then
                    If item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v1>0 Then
                        text=text &" There is something in it."
                        text=text & item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ldesc
                        reward(1)+=item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v3
                    EndIf
                EndIf
            Else
                dprint "An alien artifact!",10
                If _autopickup=0 Or Key=key_pickup Then

                    findartifact(item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).v5)
                    item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).w.p=9999
                EndIf
            EndIf
            if item(itemindex.index(awayteam.c.x,awayteam.c.y,a)).ty<>53 then itemindex.remove(itemindex.index(awayteam.c.x,awayteam.c.y,a),awayteam.c)
        EndIf
    Next
    If Key=key_pickup Then
        For a=1 To lastenemy
            If enemy(a).c.x=awayteam.c.x And enemy(a).c.y=awayteam.c.y And enemy(a).made=101 And enemy(a).hp>0 Then
                text=text &" You pick up the tribble."
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
                placeitem(make_item(250),0,0,0,0,-1)
                Exit For
            EndIf
        Next
    EndIf
    If text<>"" Then
        dprint Trim(text),15
        equip_awayteam(awayteam.slot)
    EndIf
    Return 0
End Function

Function ep_portal() As _cords
    Dim As Short a,ti,slot
    Dim As _cords nextmap
    Dim As _cords p
    slot=player.map
    if walking<0 then return nextmap 
    a=portalindex.index(awayteam.c.x,awayteam.c.y,1)
    if _debug>0 then dprint "A:"&a
    if a>0 then
        
        If portal(a).oneway=2 And portal(a).from.m=slot Then
            If awayteam.c.x=0 Or awayteam.c.x=60 Or awayteam.c.y=0 Or awayteam.c.y=20 Then
                If askyn("Do you want to leave the area?(y/n)") Then nextmap=portal(a).dest
                return nextmap
            EndIf
        EndIf
        
        If portal(a).from.m=slot and portal(a).oneway<2 Then
                If askyn(portal(a).desig &" Enter?(y/n)") Then
                    dprint "going through."
                    'walking=-1
                    If planetmap(0,0,portal(a).dest.m)=0 Then
                        'dprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).dest.m)=planets(slot)
                        planets(portal(a).dest.m).weat=0
                        planets(portal(a).dest.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).dest.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        If rnd_range(1,100)>planets(portal(a).from.m).depth*12 Then
                            makecavemap(portal(a).dest,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        Else
                            If rnd_range(1,100)<71 Then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).dest.m).temp=25
                                planets(portal(a).dest.m).atmos=3
                                planets_flavortext(portal(a).dest.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute"
                            Else
                                makecanyons(portal(a).dest.m,9)
                                p=rnd_point(portal(a).dest.m,0)
                                portal(a).dest.x=p.x
                                portal(a).dest.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts."
                            EndIf
                        EndIf
                        If planets(portal(a).dest.m).depth>7 Then
                            makefinalmap(portal(a).dest.m)
                            portal(a).dest.x=30
                            portal(a).dest.y=2
                        EndIf
                    EndIf
                    nextmap=portal(a).dest
                    If planets(portal(a).from.m).death>0 Then
                        deleteportal(portal(a).from.m,portal(a).dest.m)
                        planetmap(nextmap.x,nextmap.y,nextmap.m)=-4
                    EndIf
                    'dprint " "&portal(a).dest.m
                EndIf
            
        EndIf
        If portal(a).oneway=0 And portal(a).dest.m=slot Then
            If awayteam.c.x=portal(a).dest.x And awayteam.c.y=portal(a).dest.y Then
                If askyn(portal(a).desig &" Enter?(y/n)") Then
                    dprint "going through."
                    'walking=-1
                    If planetmap(0,0,portal(a).from.m)=0 Then
                        'dprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).from.m)=planets(slot)
                        planets(portal(a).from.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).from.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        If rnd_range(1,100)>planets(portal(a).dest.m).depth*12 Then
                            makecavemap(portal(a).from,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        Else
                            If rnd_range(1,100)<71 Then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).from.m).temp=25
                                planets(portal(a).from.m).atmos=3
                                planets_flavortext(portal(a).from.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute"
                            Else
                                makecanyons(portal(a).from.m,9)
                                p=rnd_point(portal(a).from.m,0)
                                portal(a).from.x=p.x
                                portal(a).from.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts."
                            EndIf
                        EndIf
                        If planets(portal(a).from.m).depth>7 Then
                            makefinalmap(portal(a).from.m)
                            portal(a).from.x=30
                            portal(a).from.y=2
                        EndIf
                    EndIf
                    nextmap=portal(a).from
                    If planets(portal(a).dest.m).death>0 Then
                        deleteportal(portal(a).from.m,portal(a).dest.m)
                        planetmap(nextmap.x,nextmap.y,nextmap.m)=-4
                    EndIf
                EndIf
            EndIf
        EndIf
        endif
    Return nextmap
End Function

Function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
    Dim As Short a,x,y,dam,slot,orbit,d
    Dim As _cords p,p2
    Dim As Single tempchange
    slot=player.map
    orbit=orbitfrommap(slot)
    If orbit=-1 Then
        tempchange=0
    Else
        tempchange=11-planets(slot).dens*2/orbit
    EndIf
    d=rnd_range(1,8)
    if d>4 then d+=1
    For x=0 To 60
        For y=0 To 20
            If nightday(x)=3 Then localtemp(x,y)=localtemp(x,y)+tempchange'Day
            If nightday(x)=0 Then localtemp(x,y)=localtemp(x,y)-tempchange'Night

            If x>0 And x<60 And y>0 And y<20 Then
                If tmap(x,y).no=204 Or tmap(x,y).no=202 Then
                    If vacuum(x-1,y)=1 Or vacuum(x+1,y)=1 Or vacuum(x,y-1)=1 Or vacuum(x,y+1)=1 Then vacuum(x,y)=1
                    If vacuum(x-1,y-1)=1 Or vacuum(x-1,y+1)=1 Or vacuum(x+1,y-1)=1 Or vacuum(x+1,y+1)=1 Then vacuum(x,y)=1
                EndIf
            EndIf
            
            if awayteam.c.x>=0 then
                If tmap(x,y).dam<>0 Then
                    p2.x=x
                    p2.y=y
                    player.killedby=tmap(x,y).deadt
                    If player.killedby="" Then player.killedby=tmap(x,y).desc
                    If distance(awayteam.c,p2,planets(slot).depth)<=tmap(x,y).range Then
                        If tmap(x,y).dam<0 Then
                            dam=rnd_range(1,Abs(tmap(x,y).dam))
                        Else
                            dam=tmap(x,y).dam
                        EndIf
                        If rnd_range(1,100)<tmap(x,y).tohit Then
                            dprint tmap(x,y).hitt &" "&  dam_awayteam(dam),12
                        Else
                            dprint tmap(x,y).misst,14
                        EndIf
                    EndIf
                EndIf
            
                a=rnd_range(1,100)
                If a<tmap(x,y).causeaeon Then
                    last_ae=last_ae+1
                    If last_ae>16 Then last_ae=0
                    areaeffect(last_ae).c.x=x
                    areaeffect(last_ae).c.y=y
                    areaeffect(last_ae).rad=rnd_range(1,2)
                    areaeffect(last_ae).dam=0
                    areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
                    areaeffect(last_ae).typ=tmap(x,y).aetype
                EndIf
            endif
        

            If localtemp(x)>30 And planets(slot).atmos>1 Then
                If tmap(x,y).walktru=1 Then
                    If rnd_range(1,100)<localtemp(x,y)+planets(slot).weat Then cloudmap(x,y)+=1

                EndIf
            EndIf
            If x>0 And y>0 And x<60 And y<20 Then
                If cloudmap(x,y)>0 Then
                    If tmap(x,y).walktru=2 Or tmap(x-1,y).walktru=2 Or tmap(x+1,y).walktru=2 Or tmap(x,y-1).walktru=2 Or tmap(x,y+1).walktru=2 Then
                        cloudmap(x,y)-=1
                    EndIf
                    If planets(slot).dens<3 Then cloudmap(x,y)-=2
                EndIf
            EndIf
            if player.turn mod 10=0 then
                
                If localtemp(x,y)<-10 And tmap(x,y).no=1 Or tmap(x,y).no=2 Then
                    tmap(x,y).gives=tmap(x,y).gives+(localtemp(x,y)/25)
                    If rnd_range(0,100)<Abs(tmap(x,y).gives) And tmap(x,y).gives<-50 Then
                        If vismask(x,y)>0 Then dprint "The water freezes again."
                        If tmap(x,y).no=2 Then
                            tmap(x,y)=tiles(27)
                            changetile(x ,y ,slot ,27)
                        Else
                            tmap(x,y)=tiles(260)
                            changetile(x ,y ,slot ,260)
                        EndIf
                    EndIf
                EndIf
    
                If localtemp(x,y)>10 And tmap(x,y).no=27 Or tmap(x,y).no=260 Then
                    tmap(x,y).hp-=localtemp(x,y)/25
                    If tmap(x,y).hp<0 Then
                        tmap(x,y)=tiles(2)
                        changetile(x ,y ,slot ,2)
                        If vismask(x,y)>0 Then dprint "The ice melts."
                    EndIf
                EndIf
                
                If cloudmap(x,y)>0 Then
                    p.x=x
                    p.y=y
                    If rnd_range(1,100)<(1+planets(slot).weat)*10 Then
                        cloudmap(x,y)-=1
                        p=movepoint(p,d,1)
                        cloudmap(p.x,p.y)+=1
                    EndIf
                EndIf
    
    
                If tmap(x,y).no=245 And rnd_range(1,100)<9+planets(slot).grav Then
                    p.x=x
                    p.y=y
                    p=movepoint(p,5)
                    lavapoint(rnd_range(1,5))=p
                EndIf
            endif
        Next
    Next

    if awayteam.c.x<0 then return 0
    
    If planetmap(awayteam.c.x,awayteam.c.y,slot)=45 Then
        dprint "Smoldering lava:" &dam_awayteam(rnd_range(1,6-awayteam.movetype)),12
        If player.dead=0 and awayteam.hp<=0 Then player.dead=16
        player.killedby="lava"
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).no=175 Or tmap(awayteam.c.x,awayteam.c.y).no=176 Or tmap(awayteam.c.x,awayteam.c.y).no=177 Then
        dprint "Aaaaaaaaaaaaaaaahhhhhhhhhhhhhhh",12
        if player.dead=0 then player.dead=27
    EndIf

    If (tmap(awayteam.c.x,awayteam.c.y).no=260 Or tmap(awayteam.c.x,awayteam.c.y).no=27) And player.dead=0 Then
        tmap(awayteam.c.x,awayteam.c.y).gives=tmap(awayteam.c.x,awayteam.c.y).gives-rnd_range(0,awayteam.hp\5)
        if awayteam.movetype=mt_walk then
            If tmap(awayteam.c.x,awayteam.c.y).hp<=awayteam.hp/3 Then dprint "The ice creaks",14
            If tmap(awayteam.c.x,awayteam.c.y).hp<=0 Then
                dprint "...and breaks! "&dam_awayteam(rnd_range(1,3)),12
                tmap(awayteam.c.x,awayteam.c.y)=tiles(2)
                planetmap(awayteam.c.x,awayteam.c.y,slot)=2
            EndIf
        endif
    EndIf

    Return 0
End Function

Function ep_lava(lavapoint() As _cords) As Short
    Dim As Short a,slot
    slot=player.map
    If planets(slot).temp+rnd_range(0,10)>350 Then 'lava
        a=rnd_range(1,5)
        If lavapoint(a).x=0 And lavapoint(a).y=0 Then
            lavapoint(a).x=rnd_range(1,60)
            lavapoint(a).y=rnd_range(1,20)
        EndIf
        If rnd_range(1,100)<75 Then
            If lavapoint(a).x<>player.landed.x And lavapoint(a).y<>player.landed.y Then
                If planets(slot).depth=0 Then
                    If rnd_range(1,100)<50 Then
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                    Else
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-8
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(8)
                    EndIf
                Else
                    planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                    tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                EndIf
            EndIf
        EndIf
        lavapoint(a)=movepoint(lavapoint(a),5)
        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-45
        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(45)
        If vismask(lavapoint(a).x,lavapoint(a).y)>0 Then
            If walking<11 Then walking=0
            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=45
            dprint "The ground breaks open, releasing fountains of lava"
        EndIf
        If lavapoint(a).x=player.landed.x And lavapoint(a).y=player.landed.y Then
            player.hull=player.hull-1
            If vismask(player.landed.x,player.landed.y)>0 Then dprint "Your ship was damaged!"
            If player.hull<=0 Then player.dead=15
        EndIf
    EndIf
    Return 0
End Function


Function ep_updatemasks(watermap() as byte,localtemp() as single, cloudmap() as byte, spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
    Dim As Short lsp,x,y,slot,sys,hasnosun
    slot=player.map
    sys=sysfrommap(slot)
    hasnosun=0
    If sys<0 Then
        hasnosun=1
    Else
        If map(sys).spec=9 or map(sys).spec=8 Or map(sys).spec=10 Then hasnosun=1
    EndIf
    If planets(slot).depth>0 Then hasnosun=1
    If hasnosun=0 Then
        dawn=dawn+(1/(10*24*planets(slot).rot))
        If dawn>60 Then dawn=dawn-60
        dawn2=dawn+30
        If dawn2>60 Then dawn2=dawn2-60
        For x=60 To 0 Step -1
            nightday(x)=0
            If (dawn<dawn2 And (x>dawn And x<dawn2))  Then nightday(x)=3
            If (dawn>dawn2 And (x>dawn Or x<dawn2)) Then nightday(x)=3
            If x=Int(dawn) Then nightday(x)=1
            If x=Int(dawn2) Then nightday(x)=2
        Next
    Else
        For x=0 To 60
            nightday(x)=4
        Next
    EndIf
    
    lsp=0
    For x=0 To 60
        For y=0 To 20
            spawnmask(0).x=x
            spawnmask(0).y=y
            If Abs(planetmap(x,y,slot))=1 Then watermap(x,y)=10
            If Abs(planetmap(x,y,slot))=2 Then watermap(x,y)=50
            If planets(slot).depth=0 Then
                localtemp(x,y)=planets(slot).temp-Abs(10-y)*5+10
            Else
                localtemp(x,y)=planets(slot).temp
            EndIf
            If tmap(x,y).walktru=0 and distance(spawnmask(0),awayteam.c)>5 Then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            EndIf
            mapmask(x,y)=0
            If rnd_range(1,100)<planets(slot).atmos And planets(slot).atmos>1 And planets(slot).depth=0 Then cloudmap(x,y)=1
            
        Next
    Next
    
    Return lsp
End Function

Function ep_friendfoe(i As Short,j As Short) As Short
    dim as short fact
    if enemy(i).allied>0 then
        fact=enemy(i).allied
    else
        fact=enemy(i).faction
    endif
    If j=-1 Then Return enemy(i).aggr
    If enemy(j).attacked=i Then Return 0 'Not my friend!     
    If fact<>enemy(j).faction then 
        If fact<=8 And enemy(j).faction<=8 Then
            if (faction(fact).war(enemy(j).faction)>80 or faction(enemy(j).faction).war(fact)>80) Then return 0
        endif
        Select Case enemy(i).diet
        Case 1  'Herbivour
            If enemy(j).diet=2 And rnd_range(1,10)<enemy(i).intel Then return 0
        Case 2  'Carnivour
            If enemy(i).hp>enemy(j).hp And rnd_range(1,10)<2+enemy(i).intel Then return 0    
        Case 3  'Scavenger
            If enemy(i).hp>enemy(j).hp And rnd_range(1,10)<enemy(i).intel Then return 0
        case 4
            if enemy(i).hp>enemy(j).hp and rnd_range(1,10)>enemy(i).intel Then Return 0
        case 5
            if enemy(j).attacked<>0 then return 0
        End Select
    endif
    return 1 'Dont see you as foe, going to see you as friend
End Function


Function ep_nearest(i As Short) As Short
    Dim As Single d,dd,d2,dd2,ddd,d3,x,y,slot
    Dim As Short j,k
    slot=player.map
    d=9999       
    dd=9999
    ddd=9999
    For j=1 To lastenemy
        If j<>i Then
            If enemy(j).hp>0 Then
                If ep_friendfoe(i,j)=1 Then
                    d2=distance(enemy(j).c,enemy(i).c,planets(slot).depth)
                    If d2<d Then
                        d=d2
                        enemy(i).nearestfriend=j
                    EndIf
                Else
                    d3=distance(enemy(j).c,enemy(i).c,planets(slot).depth)
                    If d3<ddd Then
                        ddd=d3
                        enemy(i).nearestenemy=j
                    EndIf
                EndIf
            Else
                dd2=distance(enemy(j).c,enemy(i).c,planets(slot).depth)
                If dd2<dd Then
                    dd=dd2
                    enemy(i).nearestdead=j
                EndIf
            EndIf
        EndIf
    Next
    d2=distance(enemy(i).c,awayteam.c,planets(slot).depth)
    If ep_friendfoe(i,-1)=1 Then
        if d2<d then
            d=d2
            enemy(i).nearestfriend=-1
        endif
    Else
        if d2<ddd then
            ddd=d2
            enemy(i).nearestenemy=-1
        EndIf
    endif
    enemy(i).denemy=ddd
    enemy(i).dfriend=d
    enemy(i).ddead=dd
    dd=9999
    enemy(i).nearestitem=0
    for x=enemy(i).c.x-enemy(i).sight to enemy(i).c.x+enemy(i).sight
        for y=enemy(i).c.y-enemy(i).sight to enemy(i).c.y+enemy(i).sight
            if x>=0 and y>=0 and x<=60 and y<=20 then
                if itemindex.last(x,y)>0 then
                    for k=1 to itemindex.last(x,y)
                        j=itemindex.index(x,y,k)
        
                        If item(j).w.p=0 And item(j).w.s=0 and (item(j).ty<>21 and item(j).ty<>22 and item(j).ty<>29) Then
                            if enemy(i).diet<>4 or item(j).ty=15 then
                                d2=distance(enemy(i).c,item(j).w,planets(slot).depth)
                                If d2<dd Then
                                    enemy(i).nearestitem=j
                                    dd=d2
                                EndIf
                            endif
                        endif
                    next
                endif
            endif
        next
    Next    
    
    enemy(i).ditem=dd
    if enemy(i).diet=4 and enemy(i).nearestitem=0 then
        enemy(i).pickup=-1
        for x=0 to 60
            for y=0 to 20
                if tmap(x,y).spawnswhat=enemy(i).made then 
                    enemy(i).target.y=y
                    enemy(i).target.x=x
                endif
            next
        next
    endif
    Return 0
End Function

Function ep_changemood(i As Short,message() As Byte) As Short
    Dim As Short b,cmoodto,slot
    slot=player.map
    If distance(awayteam.c,enemy(i).c,planets(slot).depth)<enemy(i).sight Then 
        If enemy(i).aggr=1 And enemy(i).made<>101 Then
            If rnd_range(1,100)>(20+enemy(i).diet)*distance(enemy(i).c,awayteam.c,planets(slot).depth) Then
                If rnd_range(1,6)+rnd_range(1,6)>8+enemy(i).diet+awayteam.invis+enemy(i).cmmod And enemy(i).sleeping<1 Then
                    Select Case enemy(i).diet
                    Case Is=1
                        cmoodto=1
                    Case Is=2
                        If rnd_range(1,100)<50-enemy(i).hp Then
                            cmoodto=2
                        Else
                            cmoodto=1
                        EndIf
                    Case Is=3
                        If rnd_range(1,100)<75-enemy(i).hp Then
                            cmoodto=2
                        Else
                            cmoodto=1
                        EndIf
                    Case Else
                        cmoodto=1
                    End Select
                    enemy(i).aggr=cmoodto
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 And message(0)=0 Then
                        enemy(i).cmshow=1
                        message(0)=1
                        If cmoodto=1 Then dprint "The "&enemy(i).sdesc &" suddenly seems agressive",14
                        If cmoodto=2 Then dprint "The "&enemy(i).sdesc &" suddenly seems afraid",14
                    EndIf                         
                    b=enemy(i).nearestfriend
                    If b>0 Then
                        message(1)=1
                        enemy(b).aggr=cmoodto
                        enemy(b).cmshow=1
                        dprint "The "&enemy(b).sdesc &" tries to help its friend!",14
                    EndIf
                EndIf
            EndIf
            
        EndIf
    EndIf
    Return 0
End Function

Function ep_monsterupdate(i As Short, spawnmask() as _cords,lsp as short,mapmask() As Byte,nightday() As Byte,message() As Byte) As Short
    Dim As Short slot,b,j
    slot=awayteam.slot
    mapmask(enemy(i).c.x,enemy(i).c.y)=i
    
    if enemy(i).hp<0 and enemy(i).stuff(8)=0 then
        ep_dropdeaditem(i)
        enemy(i).stuff(8)=1
    endif
    
    If enemy(i).made=102 And nightday(enemy(i).c.x)=3 Then
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 And message(2)=0 Then
            dprint "The icetroll slowly stops moving."
            message(2)=1
        EndIf
        changetile(enemy(i).c.x,enemy(i).c.y,slot,304)
        enemy(i).hp=0
        enemy(i).hpmax=0
    EndIf
    
    if (enemy(i).made=39 or enemy(i).made=79) and specialflag(27)>0 then
        enemy(i).hp-=1
        if enemy(i).hp<=0 and vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint "The "&enemy(i).sdesc &" drops dead."
    endif
    
    If enemy(i).hasoxy=0 And (planets(slot).atmos=1 Or vacuum(enemy(i).c.x,enemy(i).c.y)=1) Then
        enemy(i).hp=enemy(i).hp-1
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then dprint "The "&enemy(i).sdesc &" is struggling for air!"
    EndIf
    
    If rnd_range(1,100)<enemy(i).breedson And enemy(i).breedson>0 And lastenemy<255 Then
        If enemy(i).made<>101 Or tmap(enemy(i).c.x,enemy(i).c.y).vege>0 Then
            If enemy(i).made=101 Then
                tmap(enemy(i).c.x,enemy(i).c.y).vege-=1 'Tribbles only multiply when they have something to eat
                If tmap(enemy(i).c.x,enemy(i).c.y).vege<=0 Then changetile(enemy(i).c.x,enemy(i).c.y,slot,4)
                lastenemy+=1
                enemy(lastenemy).c=movepoint(enemy(i).c,5)
                enemy(lastenemy)=setmonster(makemonster(101,slot),slot,spawnmask(),lsp,enemy(lastenemy).c.x,enemy(lastenemy).c.y)
            Else
                lastenemy=lastenemy+1
                enemy(lastenemy)=enemy(0)
                enemy(lastenemy).c=movepoint(enemy(i).c,5)
                If tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru=0 Or enemy(i).movetype>=tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru Then
                    enemy(lastenemy)=setmonster(planets(slot).mon_template(enemy(i).slot),slot,spawnmask(),lsp,enemy(lastenemy).c.x,enemy(lastenemy).c.y,enemy(i).slot)
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 Or vismask(enemy(lastenemy).c.x,enemy(lastenemy).c.y)>0 Then dprint "the "&enemy(i).sdesc &" multiplies!"
                Else
                    lastenemy-=1
                EndIf
            EndIf
        EndIf
    EndIf
    
    If enemy(i).hp<enemy(i).hpmax Then
        enemy(i).hp=enemy(i).hp+enemy(i).hpreg
        If enemy(i).hp>enemy(i).hpmax Then
            enemy(i).hp=enemy(i).hpmax
            If enemy(i).aggr>0 And rnd_range(1,distance(enemy(i).c,awayteam.c,planets(slot).depth))>enemy(i).intel Then enemy(i).aggr=enemy(i).aggr-1
        EndIf
    EndIf    
    
    If enemy(i).sleeping>0 Then enemy(i).sleeping-=(1+enemy(i).reg)
    
    if enemy(i).teleportrange>0 and enemy(i).teleportload<15 and enemy(i).e.e<=0 then enemy(i).teleportload+=1
    
    If enemy(i).nocturnal=1 Then
        If nightday(enemy(i).c.x)=3 Then
            If enemy(i).sleeping<=0 And rnd_range(1,6)+rnd_range(1,6)<enemy(i).intel Then enemy(i).invis=3
            enemy(i).sleeping=2
        Else
            enemy(i).sleeping-=1
            If enemy(i).sleeping<=0 And enemy(i).invis=3 Then enemy(i).invis=0
        EndIf
    EndIf
    If enemy(i).nocturnal=2 Then
        If nightday(enemy(i).c.x)=0 Then
            If enemy(i).sleeping<=0 And rnd_range(1,6)+rnd_range(1,6)<enemy(i).intel Then enemy(i).invis=3
            enemy(i).sleeping=2
        Else
            enemy(i).sleeping-=1
            If enemy(i).sleeping<=0 And enemy(i).invis=3 Then enemy(i).invis=0
        EndIf
    EndIf
    if itemindex.last(enemy(i).c.x,enemy(i).c.y)>0 then
        for j=1 to itemindex.last(enemy(i).c.x,enemy(i).c.y)
            b=itemindex.index(enemy(i).c.x,enemy(i).c.y,j)
        'if debug=120 then dprint b &";"& item(li(b)).w.s
            If item(b).w.x=enemy(i).c.x And item(b).w.y=enemy(i).c.y And enemy(i).hp>0 And item(b).w.s=0 And item(b).w.p<>9999 Then
                Select Case item(b).ty
                Case 21 Or 22
                    item(b).w.p=9999
                    If item(b).ty=21 Then enemy(i).hp=enemy(i).hp-rnd_range(1,item(b).v1)
                    If item(b).ty=22 Then enemy(i).sleeping=enemy(i).sleeping+rnd_range(1,item(b).v1)
                    If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then
                        set__color( item(b).col,1)
                        Draw String (item(b).w.x*_fw1,item(b).w.y*_fh1), Chr(176),,font2,custom,@_col
                        dprint "The mine explodes under the "&enemy(i).sdesc &"!"
                    EndIf
                Case 29 'Monster steps on Trap
                    If item(b).v1<item(b).v2 Then
                        If rnd_range(1,6)+rnd_range(1,6)+item(b).v2-enemy(i).hp/2-enemy(i).intel>0 And enemy(i).intel<5 Then
                            'caught
                            item(b).v3=50*enemy(i).biomod+CInt(2*enemy(i).biomod*(enemy(i).hpmax^2)/3)'reward
                            item(b).v1+=1
                            item(b).ldesc = item(b).ldesc & " | "&enemy(i).sdesc
                            If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then dprint "The "&enemy(i).sdesc &" gets caught in the trap."
                            enemy(i)=enemy(lastenemy)
                            lastenemy-=1
                        Else
                            'evaded
                            If rnd_range(1,6)+rnd_range(1,6)+item(b).v2-enemy(i).hp/2-enemy(i).intel<0 Then'
                                'monster destroys trap
                                If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then dprint "The "&enemy(i).sdesc &" notices the trap and destroys it."
                                item(b).w.p=9999
                            Else
                                If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then dprint "The "&enemy(i).sdesc &" notices the trap."
                            EndIf
                        EndIf
                    EndIf
                end select
            endif
        next
    endif
    
    if enemy(i).invis=2 and enemy(i).aggr=0 and distance(enemy(i).c,awayteam.c,planets(slot).depth)<2 then
        enemy(i).invis=0
        dprint "A clever "&enemy(i).sdesc &" has been hiding here, waiting for prey!",c_yel
    endif
    
    
    if enemy(i).diet=4 and enemy(i).pickup=-1 and enemy(i).target.x=enemy(i).c.x and enemy(i).target.y=enemy(i).c.y then
        'Launch
        tmap(enemy(i).c.x,enemy(i).c.y)=tiles(4)
        If planetmap(enemy(i).c.x,enemy(i).c.y,slot)>0 Then planetmap(enemy(i).c.x,enemy(i).c.y,slot)=4
        If planetmap(enemy(i).c.x,enemy(i).c.y,slot)<0 Then planetmap(enemy(i).c.x,enemy(i).c.y,slot)=-4
        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Then
            If tmap(enemy(i).c.x,enemy(i).c.y).no=86 Then
                dprint "The other scoutship launches."
                companystats(basis(nearest_base(player.c)).company).profit+=1
            EndIf
            If tmap(enemy(i).c.x,enemy(i).c.y).no=272 Or tmap(enemy(i).c.x,enemy(i).c.y).no=273 Then dprint "The alien ship launches."
        Else
            If tmap(enemy(i).c.x,enemy(i).c.y).no=86 Then
                dprint "You see a scoutship starting in the distance."
                companystats(basis(nearest_base(player.c)).company).profit+=1
            EndIf
            If tmap(enemy(i).c.x,enemy(i).c.y).no=272 Or tmap(enemy(i).c.x,enemy(i).c.y).no=273 Then dprint "You see an alien ship starting in the distance."
            companystats(basis(nearest_base(player.c)).company).profit+=1
        EndIf
        enemy(i)=enemy(lastenemy)
        lastenemy=lastenemy-1

    endif
    
    Return 0
End Function
    

Function ep_monstermove(spawnmask() As _cords, lsp As Short, mapmask() As Byte,nightday() As Byte) As Short
    Dim As Short deadcounter,i,j,flee,slot
    dim as string text
    Dim As Byte message(8),see1,see2
    slot=awayteam.slot
    for i=1 to lastenemy
        if enemy(i).hp>0 then
            ep_monsterupdate(i,spawnmask(),lsp,mapmask(),nightday(),message())
        endif
    next
    mapmask(awayteam.c.x,awayteam.c.y)=-1
    
    For i=1 To lastenemy
        flee=0
        If enemy(i).hp>0 Then
            
            If enemy(i).e.tick<0 And enemy(i).sleeping=0 Then
                'Nearest critter, dead, item?
                ep_nearest(i)
                'Reaction to critter
                if enemy(i).nearestitem>0 and enemy(i).c.x=item(enemy(i).nearestitem).w.x and item(enemy(i).nearestitem).w.p=0 and item(enemy(i).nearestitem).w.s=0 and enemy(i).c.y=item(enemy(i).nearestitem).w.y and (rnd_range(1,10)<enemy(i).pumod or enemy(i).pickup=1) then
                    item(enemy(i).nearestitem).w.p=i
                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint "The "&enemy(i).sdesc &" picks up the "&item(enemy(i).nearestitem).desig &"."
                    itemindex.remove(enemy(i).nearestitem,enemy(i).c)
                    enemy(i).pickup=0
                    enemy(i).nearestitem=0
                    enemy(i).add_move_cost
                endif

                If enemy(i).denemy>enemy(i).sight or enemy(i).nearestenemy=0 Then
                    'Can't see it
                    If (enemy(i).aggr=0 Or enemy(i).aggr=2) And enemy(i).diet>0 and rnd_range(1,20)+enemy(i).cmmod<enemy(i).intel And enemy(i).faction>8 Then
                        enemy(i).aggr=1
                        If vismask(enemy(i).c.x,enemy(i).c.y)>0 Or _debug>0 Then dprint "The "&enemy(i).sdesc &" seems to calm down."
                    EndIf
                    
                    if enemy(i).pickup>=0 then enemy(i).target=rnd_point
                    
                    if (enemy(i).nearestitem>0 and enemy(i).diet=4) or (enemy(i).sight<enemy(i).ditem and enemy(i).nearestitem>0 and (rnd_range(1,10)<enemy(i).pumod or enemy(i).pickup=1)) then
                        enemy(i).pickup=1
                        enemy(i).target=item(enemy(i).nearestitem).w
                    endif
                Else
                    If enemy(i).nearestenemy=-1 Or enemy(i).nearestfriend=-1 Then
                        'Nearest is player
                        
                        'If its an animal does it change it's mood?
                        if enemy(i).faction>8 then ep_changemood(i,message())
                        
                        If enemy(i).aggr=0 Then 
                            enemy(i).attacked=-1
                        Else
                            enemy(i).attacked=0
                        EndIf
                        If enemy(i).aggr=1 Then enemy(i).target=rnd_point
                        If enemy(i).aggr=2 Then 
                            enemy(i).target=awayteam.c
                            flee=1
                        endif
                    Else
                        If enemy(i).denemy>enemy(i).sight Then
                            enemy(i).target=rnd_point
                        Else
                            enemy(i).attacked=enemy(i).nearestenemy
                        EndIf
                        if enemy(i).dfriend<enemy(i).sight then
                            if enemy(i).nearestfriend=-1 then
                                if awayteam.attacked>0 then
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint enemy(i).desc &" decides to help you!"
                                    enemy(i).attacked=awayteam.attacked
                                endif
                            else
                                if enemy(enemy(i).nearestfriend).attacked<>0 then
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint "The "&enemy(i).sdesc &" decides to help the " &enemy(enemy(i).nearestfriend).sdesc &"."
                                    enemy(i).attacked=enemy(enemy(i).nearestfriend).attacked
                                endif
                            endif
                        endif
                    EndIf
                    
                    if enemy(i).made=36 and enemy(i).nearestenemy=-1 then
                        if enemy(i).nearestfriend>0 then enemy(enemy(i).nearestfriend).nearestenemy=-1
                    endif
                    
                    
                EndIf
                'Move
                'Monster k�nnen nur 3 dinge tun: Angreifen, auf ein ziel zugehen/weggehen, irgendwohin gehen
                If enemy(i).attacked<>0 Then
                    If enemy(i).denemy<=enemy(i).range Then
                        If enemy(i).attacked=-1 Then
                            if (pathblock(awayteam.c,enemy(i).c,awayteam.slot,1)=-1 and enemy(i).range<enemy(i).denemy) or enemy(i).denemy<2 then
                                awayteam=monsterhit(enemy(i),awayteam,vismask(enemy(i).c.x,enemy(i).c.y))
                            endif
                        Else
                            if pathblock(enemy(i).c,enemy(enemy(i).attacked).c,awayteam.slot,1)=-1 or distance(enemy(i).c,enemy(enemy(i).attacked).c,planets(slot).depth)<2 then
                                if enemy(enemy(i).attacked).hp>0 then
                                    enemy(enemy(i).attacked)=monsterhit(enemy(i),enemy(enemy(i).attacked),vismask(enemy(i).c.x,enemy(i).c.y))
                                    see1=0
                                    see2=0
                                    if vismask(enemy(i).c.x,enemy(i).c.y)>0 then see1=1
                                    if vismask(enemy(enemy(i).attacked).c.x,enemy(enemy(i).attacked).c.y)>0 then see2=1
                                    if see1=1 and see2=1 then dprint "The "&enemy(i).sdesc &" attacks the "&enemy(enemy(i).attacked).sdesc &"."
                                    if see1=0 and see2=1 then dprint "Something attacks the "&enemy(enemy(i).attacked).sdesc &"."
                                    if see1=1 and see2=0 then dprint "The "&enemy(i).sdesc &" attacks something."
                                    If enemy(enemy(i).attacked).hp<=0 Then enemy(i).attacked=0
                                else
                                    enemy(i).attacked=0
                                endif
                            endif
                        EndIf
                        enemy(i).e.add_action(enemy(i).atcost)
                    Else
                        If enemy(i).attacked=-1 Then
                            enemy(i).target=awayteam.c
                        Else
                            enemy(i).target=enemy(enemy(i).attacked).c
                        EndIf
                        enemy(i).attacked=0
                    EndIf
                EndIf
                If enemy(i).attacked=0 And enemy(i).e.e<=0 Then
                    if enemy(i).diet<>2 and enemy(i).ddead=0 and enemy(i).faction<>enemy(enemy(i).nearestdead).faction and enemy(i).nearestdead>0 then
                        if enemy(i).faction>8 and enemy(enemy(i).nearestdead).faction>8 then
                            if vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint "The "&enemy(i).sdesc &" eats of the "&enemy(enemy(i).nearestdead).sdesc
                            enemy(enemy(i).nearestdead).hpmax-=1
                            enemy(i).add_move_cost
                        endif
                    elseif enemy(i).diet=1 and tmap(enemy(i).c.x,enemy(i).c.y).vege>0 then
                        if vismask(enemy(i).c.x,enemy(i).c.y)>0 then dprint "The "&enemy(i).sdesc &" eats of the plants in this area"
                        tmap(enemy(i).c.x,enemy(i).c.y).vege-=1
                        enemy(i).add_move_cost
                    else
                        if enemy(i).teleportrange<=distance(enemy(i).c,enemy(i).target,planets(slot).depth) and enemy(i).teleportload>distance(enemy(i).c,enemy(i).target) then
                            if flee=0 then
                                text=""
                                if vismask(enemy(i).c.x,enemy(i).c.y)>0 then text="The "&enemy(i).sdesc &" disappears."
                                if vismask(enemy(i).target.x,enemy(i).target.y)>0 then text=text &"A "&enemy(i).sdesc &" appears"
                                dprint text
                                enemy(i).teleportload-=distance(enemy(i).c,enemy(i).target,planets(slot).depth)
                                enemy(i).c=enemy(i).target
                            else
                                if vismask(enemy(i).c.x,enemy(i).c.y)>0 then text="The "&enemy(i).sdesc &" disappears."
                                if enemy(i).c.x>30 then
                                    enemy(i).c.x+=enemy(i).teleportrange
                                else
                                    enemy(i).c.y-=enemy(i).teleportrange
                                endif
                                enemy(i).teleportload-=enemy(i).teleportrange
                                if enemy(i).c.x<=0 then enemy(i).c.x=0
                                if enemy(i).c.x>60 then enemy(i).c.x=60
                                if vismask(enemy(i).target.x,enemy(i).target.y)>0 then text=text &"A "&enemy(i).sdesc &" appears"
                            endif
                        else
                            if enemy(i).speed>0 then move_monster(i,enemy(i).target,flee,planets(slot).depth,mapmask())
                        endif
                    endif
                EndIf
            EndIf 
        Else
            deadcounter+=1
        EndIf
    Next
    
    Return deadcounter
End Function

Function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
    Dim As Short a,b,c,x,y,d,slot
    If _spawnoff=1 Then Return 0
    slot=player.map
    For x=0 To 60
        For y=0 To 20
            a=rnd_range(1,100)
            if _debug>0 and tmap(x,y).spawnson>0 then dprint "Roled a"& a &" need:"&tmap(x,y).spawnson
            If a<tmap(x,y).spawnson And tmap(x,y).spawnblock>=0 Then
                If tmap(x,y).spawnblock>0 Then tmap(x,y).spawnblock=tmap(x,y).spawnblock-3
                b=0
                For c=1 To lastenemy
                    If enemy(c).made=tmap(x,y).spawnswhat And enemy(c).hp>0 Then b=b+1
                Next
                If b<tmap(x,y).spawnsmax Then
                    d=getmonster()
                    if _debug>0 then dprint "D:"&d &"X:"&x &"Y:"&y
                    enemy(d)=setmonster(makemonster(tmap(x,y).spawnswhat,slot),slot,spawnmask(),lsp,x,y,d)
                    if _debug>0 then dprint "Lastmonster:"&lastenemy
                    If vismask(x,y)>0 Then dprint tmap(x,y).spawntext,14
                EndIf
            EndIf
            If tmap(x,y).no=304 And nightday(x)=0 Then
                changetile(x,y,slot,4)
                d=getmonster()
                enemy(d)=setmonster(makemonster(102,slot),slot,spawnmask(),lsp,x,y,d)
                If vismask(x,y)>0 Then dprint "The iceblock suddenly starts to move."
            EndIf
        Next
    Next
    For a=1 To lastenemy
        If enemy(a).hp<=0 And planets(slot).atmos>12 And rnd_range(1,100)>planets(slot).atmos Then enemy(a).hpmax=enemy(a).hpmax-1
        If enemy(a).hp<=0 Then enemy(a).hp=enemy(a).hp-1
        If enemy(a).hp<-45-diesize And enemy(a).respawns=1 And rnd_range(1,100)<(1+planets(slot).life)*5 Then
            enemy(a)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,,,a)
            planets(slot).life-=1
            If planets(slot).life<0 Then planets(slot).life=0
        EndIf
    Next
    Return lastenemy
End Function

function ep_dropdeaditem(mi as short) as short
    dim as short slot,a
    slot=player.map
    For a=1 To lastitem 'Drop items of dead monsters
        If item(a).w.p=mi  Then
            If enemy(item(a).w.p).hp<=0 Then
                item(a).w.x=enemy(item(a).w.p).c.x
                item(a).w.y=enemy(item(a).w.p).c.y
                item(a).w.p=0
                item(a).w.m=slot
                item(a).w.s=0
                itemindex.add(a,item(a).w)
            EndIf
        EndIf
    next
    return 0
end function

Function ep_shipfire(shipfire() As _shipfire) As Short
    Dim As Short sf2,a,b,c,x,y,dam,slot,osx,ani,f,debug,icechunkhole,dambonus,col
    Dim As Short dammap(60,20)
    Dim As String txt
    Dim As Single r,ed
    Dim p2 As _cords
    If rnd_range(1,100)<10 And planets(slot).flags(29)>0  Then icechunkhole=1
    If debug=2 And _debug=1 Then icechunkhole=1
    If debug=1 And _debug=1 Then
        f=Freefile
        Open "sflog.txt" For Append As #f
            For a=0 To 16
                Print #f,shipfire(a).when;":";shipfire(a).where.x;":";shipfire(a).where.y;":"
            Next
        Close #f
    EndIf
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    display_planetmap(slot,osx,0)
    For sf2=0 To 16
        If shipfire(sf2).when>0 Then
            shipfire(sf2).when-=1
            If shipfire(sf2).tile<>"" And vismask(shipfire(sf2).where.x,shipfire(sf2).where.y)>0 Then
                set__color( 7,0)
                Draw String (shipfire(sf2).where.x*_fw1,shipfire(sf2).where.y*_fh1),shipfire(sf2).tile,,Font1,custom,@_col
            EndIf
            If shipfire(sf2).when=0 Then
                Screenset 1,1
                shipfire(sf2).tile=""
                b=rnd_range(1,6)+rnd_range(1,6)+maximum(player.sensors,player.gunner(0))
                If b>13 Then dprint gainxp(2),c_gre
                b=b-8
                If b<0 Then
                    b=b*-1
                    c=rnd_range(1,8)
                    If c=5 Then c=9
                    For a=1 To b
                        If shipfire(sf2).what>10 Then shipfire(sf2).where=movepoint(shipfire(sf2).where,c)
                    Next
                EndIf
                r=CInt(player.weapons(shipfire(sf2).what).dam/2)
                dam=1
                If r<1 Then r=1
                If player.weapons(shipfire(sf2).what).ammomax>0 Then dambonus=player.loadout
                For a=1 To player.weapons(shipfire(sf2).what).dam+dambonus
                    dam=dam+rnd_range(1,3)
                Next
                Do
                    ani+=1
                    For x=shipfire(sf2).where.x-5 To shipfire(sf2).where.x+5
                        For y=shipfire(sf2).where.y-5 To shipfire(sf2).where.y+5
                            p2.x=x
                            p2.y=y
                            If x>=0 And y>=0 And x<=60 And y<=20 Then
                                If distance(shipfire(sf2).where,p2,planets(slot).depth)<=r Then
                                    dammap(x,y)=dam/(1+distance(shipfire(sf2).where,p2,planets(slot).depth))
                                    If dammap(x,y)<1 Then dammap(x,y)=1
                                    If configflag(con_tiles)=0 Then
                                        ed=2*distance(p2,shipfire(sf2).where,planets(slot).depth)
                                        If ani-ed<1 Then ed=ani-1
                                        Put((x-osx)*_tix,y*_tiy),gtiles(gt_no(77+ani-ed)),trans
                                        Sleep 5
                                    Else
                                        If player.weapons(shipfire(sf2).what).ammomax>0 Then
                                            If x=shipfire(sf2).where.x And y=shipfire(sf2).where.y Then set__color( 15,15)
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>0 Then set__color( 12,14)
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>1 Then set__color( 12,0)
                                        Else
                                            If x=shipfire(sf2).where.x And y=shipfire(sf2).where.y Then set__color( 15,15)
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>0 Then set__color( 11,9)
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>1 Then set__color( 9,1)
                                        EndIf
                                        If shipfire(sf2).stun=1 Then
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>0 Then set__color( 242,244)
                                            If distance(shipfire(sf2).where,p2,planets(slot).depth)>1 Then set__color( 246,248)
                                        EndIf
                                        
                                        Draw String ((x-osx)*_fw1,y*_fh1), Chr(178),,Font1,custom,@_col
                                    EndIf
                                EndIf
                            EndIf
                        Next
                    Next
                    
                    
                Loop Until ani>=8 Or configflag(con_tiles)=1
                                'Deal damage
                For a=1 To lastenemy
                    If dammap(enemy(a).c.x,enemy(a).c.y)>0 and enemy(a).hp>0 Then
                        If shipfire(sf2).stun=0 Then
                            enemy(a).hp=enemy(a).hp-dammap(enemy(a).c.x,enemy(a).c.y)
                            If vismask(enemy(a).c.x,enemy(a).c.y)>0 Then txt &= enemy(a).sdesc &" takes " &dammap(enemy(a).c.x,enemy(a).c.y)&" points of damage. "
                        Else
                            enemy(a).hpnonlethal=enemy(a).hpnonlethal+(dam*((10-enemy(a).stunres)/10))
                        EndIf
                        If enemy(a).hp<=0 Then
                            player.alienkills=player.alienkills+1
                            ep_dropdeaditem(a)
                        EndIf
                    EndIf
                Next
                            
                For x=shipfire(sf2).where.x-5 To shipfire(sf2).where.x+5
                    For y=shipfire(sf2).where.y-5 To shipfire(sf2).where.y+5
                        p2.x=x
                        p2.y=y
                        If x>=0 And y>=0 And x<=60 And y<=20 Then
                
                            If tmap(x,y).shootable>0 And shipfire(sf2).stun=0 And dammap(x,y)>0 Then
                                tmap(x,y).hp=tmap(x,y).hp-dammap(x,y)
                                If tmap(x,y).succt<>"" And vismask(x,y)>0 Then txt =txt & "The "&tmap(x,y).desc &" is damaged. " 
                                If tmap(x,y).hp<=0 Then
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=tmap(x,y).turnsinto
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                                    tmap(x,y)=tiles(tmap(x,y).turnsinto)
                                EndIf
                                If icechunkhole=1 Then
                                    If planetmap(x,y,slot)>0 Then planetmap(x,y,slot)=200
                                    If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=-200
                                    tmap(x,y)=tiles(200)
                                EndIf
                            EndIf
                        EndIf
                    
                    Next
                Next
                col=11
                If dammap(awayteam.c.x,awayteam.c.y)>0 Then
                    dprint txt,col
                    col=c_red
                    txt="you got caught in the blast! "
                    If shipfire(sf2).stun=0 Then txt = txt & dam_awayteam(dammap(awayteam.c.x,awayteam.c.y),1) &" "
                    If shipfire(sf2).stun=1 Then awayteam.e.add_action(150-stims.effect)
                EndIf
                
                dprint txt,col
                #IfDef _FMODSOUND
                If (configflag(con_sound)=0 Or configflag(con_sound)=2) And planets(slot).atmos>1 Then FSOUND_PlaySound(FSOUND_FREE, Sound(4))
                #EndIf
                #IfDef _FBSOUND
                'sleep 100+distance(awayteam.c,shipfire(sf2).where)*6
                If (configflag(con_sound)=0 Or configflag(con_sound)=2) And planets(slot).atmos>1 Then fbs_Play_Wave(Sound(4))
                #EndIf
            EndIf
            If shipfire(sf2).what>10 Then
                player.weapons(shipfire(sf2).what)=make_weapon(0)
                player.killedby="short thrown grenade"
            Else
                player.killedby="explosion"
            EndIf
        EndIf
    Next
    Return 0
End Function

Function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single,nightday() As Byte,localtemp() As Single) As Short
    Dim As _cords p,p1,p2,pc
    Dim As String text,mtext
    Dim As Short a,b,slot,debug,osx,ex,shipweapon,roverlist(128),c
    Dim As _weap del
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    Screenset 1,1
    p2.x=player.landed.x
    p2.y=player.landed.y
    dprint "Engaging remote control."
    If (pathblock(awayteam.c,p2,slot,1)=-1 Or awayteam.stuff(8)=1 Or distance(awayteam.c,p2,planets(slot).depth)<2) And player.landed.m=slot Then
        dprint "Your command?"
        text=" "
        pc=locEOL
        text=Ucase(gettext(pc.x,pc.y,46,text))
        If Instr(text,"ROVER")>0 Then
            If debug=1 And _debug=1 Then dprint "Contacting Rover"
            b=0
            mtext="Rovers:/"
            For a=1 To itemindex.vlast 'Looking for Rover
                If item(itemindex.value(a)).ty=18 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s=0 Then 
                    b=itemindex.value(a)
                    p1.x=item(b).w.x
                    p1.y=item(b).w.y
                    If pathblock(p2,p1,slot,1)=-1 Or (awayteam.stuff(8)=1 And player.landed.m=slot) Then
                        c+=1
                        roverlist(c)=b
                        mtext=mtext &item(b).desig &" "&cords(item(b).w) &"/"
                    endif
                endif
            Next
            if c>1 then
                b=menu(bg_awayteamtxt,mtext,"",2,2)
                if b>0 then b=roverlist(b)
            endif
            if c=1 then b=roverlist(1)
            If b>0 Then
                If Instr(text,"STOP")>0 Then
                    dprint "Sending stop command to rover"
                    item(b).v5=1
                EndIf
                If Instr(text,"START")>0 Then
                    dprint "sending start command to rover."
                    item(b).v5=0
                EndIf
                If Instr(text,"TARGET")>0 Then
                    dprint "Get target for rover:"
                    text=get_planet_cords(p1,slot)
                    If text=key__enter Then 
                        item(b).v5=0
                        item(b).vt=p1
                    endif
                    text=""
                EndIf
                If Instr(text,"POSITI")>0 Or Instr(text,"WHERE")>0 Then
                    dprint "Rover is at "& item(b).w.x &":"& item(b).w.y &"."
                EndIf
            Else
                dprint "No rover to contact"
            EndIf
            text=""
        EndIf
        If Instr(text,"HELP")>0 Then dprint "How shall we help you? come to you or fire on something or launch?"
        If Instr(text,"SELFDESTRUCT")>0 Then dprint "We don't have a selfdestruct device. Guess we could make the reactor go critical, but why would we want to?"
        If Instr(text,"SCAN")>0 Or Instr(text,"ORBITAL")>0 Or Instr(text,"SATELLI")>0 Then
            If awayteam.stuff(8)=0 Then
                dprint "We don't have a satellite in orbit"
            Else
                If Instr(text,"LIFE")>0 Then
                    ep_heatmap(lavapoint(),5)
                Else
                    if itemindex.vlast>0 then
                        a=rnd_range(1,itemindex.vlast)
                        If item(itemindex.value(a)).ty=15 And item(itemindex.value(a)).w.p=0 And item(itemindex.value(a)).w.s=0 Then
                            item(itemindex.value(a)).discovered=1
                            dprint "We have indications that there is an ore deposit at "& cords(item(itemindex.value(a)).w) &"."
                        Else
                            dprint "No new information from orbital scans."
                        EndIf
                    Else
                        dprint "No new information from orbital scans."
                    EndIf
                EndIf
            EndIf
        EndIf
        If Instr(text,"POSIT")>0 Or Instr(text,"LOCATI")>0 Or Instr(text,"WHERE")>0 Then
            dprint "We are at " &player.landed.x &":" &player.landed.y
        EndIf
        If Instr(text,"LAUNC")>0 Or Instr(text,"START")>0 Then
            If (slot=specialplanet(2) And specialflag(2)<2) Or (slot=specialplanet(27) And specialflag(27)=0) Then
                If slot=specialplanet(2) Then dprint "We can't start untill we disabled the automatic defense system."
                If slot=specialplanet(27) Then dprint "Can't get her up from this surface. She is stuck."
            Else
                If askyn("Are you certain? you want to launch on remote and leave everybody behind? (y/n)") Then
                    if player.dead=0 then player.dead=4
                EndIf
            EndIf
        EndIf
        If Instr(text,"HELLO")>0 Then dprint "Yes?"
        If Instr(text,"STATUS")>0 Or Instr(text,"REPORT")>0 Then
            screenshot(1)
            shipstatus()
            screenshot(2)
            dprint "The ship is fine, like you left her"
            For a=1 To 5
                If distance(p2,lavapoint(a),planets(slot).depth)<2 And lavapoint(a).x>0 And lavapoint(a).y>0 Then
                    dprint "Lava is coming a bit close though"
                    Exit For
                EndIf
            Next
        EndIf
        If Instr(text,"GET")>0 Or Instr(text,"COME")>0 Or Instr(text,"LAND")>0 Or Instr(text,"RESCUE")>0 Or Instr(text,"MOVE")>0 Or Instr(text,"FETCH")>0 Then
            If (slot=specialplanet(2) And specialflag(2)<2) Or (slot=specialplanet(27) And specialflag(27)=0) Or planets(slot).depth>0 Then
                If slot=specialplanet(2) Then dprint "We can't start untill we disabled the automatic defense system."
                If slot=specialplanet(27) Then dprint "Can't get her up from this surface. She is stuck."
                If planets(slot).depth>0 Then dprint "I think you are slightly overestimating the size of the airlock, captain!"
            Else
                p.x=player.landed.x
                p.y=player.landed.y
                If Instr(text,"HERE")>0 Then
                    nextlanding.x=awayteam.c.x
                    nextlanding.y=awayteam.c.y
                    player.landed.m=0
                Else
                    dprint "Roger. Where do you want me to land?"
                    nextlanding=awayteam.c
                    text=get_planet_cords(nextlanding,slot,1)
                    If text=key__enter Then
                        player.landed.m=0
                    Else
                        nextlanding.x=p.x
                        nextlanding.y=p.y
                    EndIf
                EndIf
                If nextlanding.x=player.landed.x And nextlanding.y=player.landed.y Then
                    dprint "We already are at that position."
                    player.landed.m=slot
                Else
                    ship_landing=20*distance(p,nextlanding,0)/2
                    If ship_landing<1 Then ship_landing=1
                    If crew(2).onship=lc_onship Then
                        dprint "ETA in "&Int(ship_landing/20) &". See you there."
                    Else
                        dprint "ETA in "&Int(ship_landing/20) &". Putting her down there by remote control."
                    EndIf
                EndIf
            EndIf
        EndIf
        If Instr(text,"FIR")>0 Or Instr(text,"NUKE")>0 Or Instr(text,"SHOOT")>0 Then
            sf=sf+1
            If sf>15 Then sf=0
            display_ship(0)
            shipweapon=com_getweapon
            If shipweapon>0 Then
                shipfire(sf).where=awayteam.c
                dprint "Choose target"
                Do
                    text=planet_cursor(shipfire(sf).where,slot,osx,1)
                    ep_display(osx)
                    display_awayteam(,osx)
                    text=Cursor(shipfire(sf).where,slot,osx)
                    If text=key__enter Then ex=-1
                    If text=key_quit Or text=key__esc Then ex=1
                Loop Until ex<>0
                If text=key__enter Then
                    If pathblock(p2,shipfire(sf).where,slot,1)=0 Then
                        dprint "No line of sight to that target."
                        shipfire(sf).where.x=-1
                        shipfire(sf).where.y=-1
                    Else
                        shipfire(sf).when=(distance(awayteam.c,p2,planets(slot).depth)\10)+1
                        Cls
                        display_ship
                        shipfire(sf).what=shipweapon
                        If shipfire(sf).what<0 Then
                            shipfire(sf).what=6
                            shipfire(sf).when=-1
                        EndIf
                        If player.weapons(shipfire(sf).what).ammomax=0 And distance(shipfire(sf).where,p2,planets(slot).depth)>10 Then shipfire(sf).when=-5
    
                        If player.weapons(shipfire(sf).what).desig="" Then shipfire(sf).when=-1
                        If player.weapons(shipfire(sf).what).ammomax>0 Then
                            If player.useammo(0)=0 Then shipfire(sf).when=-2
                        EndIf
                        If player.weapons(shipfire(sf).what).shutdown<>0 Then shipfire(sf).when=-3
                        If player.weapons(shipfire(sf).what).reloading<>0 Then shipfire(sf).when=-4
                        If shipfire(sf).when>0 Then
                            dprint player.weapons(shipfire(sf).what).desig &" fired"
                            If player.weapons(shipfire(sf).what).ammomax>0 Then player.useammo(1)
                            player.weapons(shipfire(sf).what).heat+=player.weapons(shipfire(sf).what).heatadd*25
                            player.weapons(shipfire(sf).what).reloading=player.weapons(shipfire(sf).what).reload
                            If Not(skill_test(player.gunner(0),player.weapons(shipfire(sf).what).heat/25)) Then
    
                                dprint player.weapons(shipfire(sf).what).desig &" shuts down due to heat."
                                player.weapons(shipfire(sf).what).shutdown=1
                                If Not(skill_test(player.gunner(location),player.weapons(shipfire(sf).what).heat/20,"Gunner: Shutdown")) Then
                                    dprint player.weapons(shipfire(sf).what).desig &" is irreperably damaged."
                                    player.weapons(shipfire(sf).what)=del
                                EndIf
                            EndIf
                        EndIf
                        If shipfire(sf).when=-1 Then dprint "Fire order canceled"
                        If shipfire(sf).when=-2 Then dprint "I am afraid we are out of ammunition"
                        If shipfire(sf).when=-3 Then dprint "Can't fire that weapon at this time."
                        If shipfire(sf).when=-5 Then dprint "That target is below the horizon."
                        If shipfire(sf).when=-4 Then
                            If player.weapons(shipfire(sf).what).ammomax=0 Then
                                dprint "That weapon is currently recharging."
                            Else
                                dprint "That weapon is currently reloading."
                            EndIf
                        EndIf
                    EndIf
                Else
                    dprint "Fire order canceled."
                EndIf
            EndIf
        EndIf
        awayteam.e.add_action(25-stims.effect)
    Else
        dprint "No contact possible"
    EndIf
    Return 0
End Function

Function ep_roverreveal(i As Integer) As Short
    Dim As Short x,y,slot,debug,j
    Dim As Single d
    Dim As _cords p1
    slot=item(i).w.m
    make_vismask(item(i).w,item(i).v1+3,slot)
    For x=0 To 60
        For y=0 To 20
            If vismask(x,y)>0 And planetmap(x,y,slot)<0 Then
                If _Debug>0 Then debug+=1
                planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                item(i).v6=item(i).v6+0.5*(item(i).v1/3)*planets(slot).mapmod
                if itemindex.last(x,y)>0 then
                    for j=1 to itemindex.last(x,y)
                        item(itemindex.index(x,y,j)).discovered=1
                    next
                endif
            EndIf
        Next
    Next
    Return 0
End Function

function ep_rovermove(a as short, slot as short) as short
    dim as _cords p1,route(1024)
    dim as short i,cost,last               
    p1.x=item(a).w.x
    p1.y=item(a).w.y
    if item(a).v3<=0 then
        If item(a).vt.x=-1 Then
            last=ep_autoexploreroute(route(),p1,item(a).v2,slot,1)
            if _debug>0 then dprint "last:"&last
            if last=-1 then return 0
            item(a).vt=route(last)
        Else
            If item(a).w.x=item(a).vt.x And item(a).w.y=item(a).vt.y Then 
                item(a).vt.x=-1
                return 0
            else
                last=ep_planetroute(route(),item(a).v2,p1,item(a).vt,planets(slot).depth)
            endif
        EndIf
        If last>1 Then
            itemindex.move(a,item(a).w,route(2))
            item(a).w.x=route(2).x
            item(a).w.y=route(2).y
        EndIf
        if last=1 then
            itemindex.move(a,item(a).w,route(1))
            item(a).w.x=route(1).x
            item(a).w.y=route(1).y
        endif
        ep_roverreveal(a)
        
        cost=(20-item(a).v4)*planets(slot).grav
        cost+=tmap(item(a).w.x,item(a).w.y).movecost
        if cost<=0 then cost=1
        item(a).v3+=cost
    else
        item(a).v3-=1
        if item(a).v3<0 then item(a).v3=0
        if _debug>0 then dprint "V6"&item(a).v3
    endif
    return 0
end function

Function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
    Dim As Short map(60,20),heatmap(60,20)
    Dim As Short x,y,x1,y1,a,sensitivity,dis,slot
    Dim As _cords p1,p2
    slot=player.map
    For a=0 To lastenemy
        If enemy(a).hp>0 Then map(enemy(a).c.x,enemy(a).c.y)+=enemy(a).hp
    Next
    For a=0 To lastlavapoint
        If lavapoint(a).x>0 And lavapoint(a).y>0 Then map(lavapoint(a).x,lavapoint(a).y)+=50-player.sensors*4
    Next
    For x=0 To 60
        For y=0 To 20
            If map(x,y)>0 Then
                heatmap(x,y)=map(x,y)
                For x1=x-1 To x+1
                    For y1=y-1 To y+1
                        If x1>=0 And y1>=0 And x1<=60 And y1<=20 Then
                            heatmap(x,y)=heatmap(x,y)+map(x1,y1)/2
                        EndIf
                    Next
                Next
            EndIf
        Next
    Next

    For x=0 To 60
        For y=0 To 20
            If heatmap(x,y)>0 Then
                For x1=x-1 To x+1
                    For y1=y-1 To y+1
                        If x1>=0 And y1>=0 And x1<=60 And y1<=20 And (x1<>x Or y1<>y) Then
                            If heatmap(x,y)>=heatmap(x1,y1) Then heatmap(x1,y1)=0
                        EndIf
                    Next
                Next
            EndIf
        Next
    Next
    sensitivity=24-player.sensors*2
    dis=9999
    p2.x=-1
    p2.y=-1
    For x=0 To 60
        For y=0 To 20
            If heatmap(x,y)>sensitivity Then
                p1.x=x
                p1.y=y
                If distance(p1,awayteam.c,planets(slot).depth)<dis Then
                    p2=p1
                    dis=distance(p1,awayteam.c,planets(slot).depth)
                EndIf
            EndIf
        Next
    Next
    If p2.x>0 Or p2.y>0 Then
        dprint "There is a source of heat at "&p2.x &":"&p2.y &". It might be a lifeform."
    EndIf
    Return 0
End Function

Function ep_helmet() As Short
    Dim As Short slot
    slot=player.map
    If awayteam.helmet=0 Then
        dprint "Switching to suit oxygen supply.",c_yel
        awayteam.helmet=1
        'oxydep
    Else
        'Opening Helmets
        If planets(slot).atmos>=3 And planets(slot).atmos<=6 And vacuum(awayteam.c.x,awayteam.c.y)=0 Then
            awayteam.helmet=0
            awayteam.oxygen=awayteam.oxymax
            dprint "Opening helmets",c_gre
        Else
            dprint "We can't open our helmets here",c_yel
        EndIf
    EndIf
    equip_awayteam(slot)
    make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
    Return 0
End Function


Function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
    Dim As Short c,slot,i,launcher,rof
    slot=player.map
    Dim As _cords p
    If configflag(con_chosebest)=0 Then
        c=findbest(7,-1)
    Else
        c=get_item(-1,7)
    EndIf
    launcher=findbest(17,-1)
    If c>0 Then
        
        If item(c).ty=7 Then
            p=grenade(awayteam.c,slot)
            If p.x>=0 Then

                Select Case item(c).v2
                Case 0,2
                    If launcher>0 Then rof=item(launcher).v2
                    For i=1 To 1+rof
                        If c>0 Then
                            sf=sf+1
                            If sf>15 Then sf=0

                            shipfire(sf).where=p
                            dprint "Delay for the grenade?"
                            shipfire(sf).when=getnumber(1,5,1)
                            shipfire(sf).what=11+sf
                            If item(c).v2=2 Then shipfire(sf).stun=1
                            shipfire(sf).tile=item(c).ICON
                            player.weapons(shipfire(sf).what)=make_weapon(item(c).v1)
                            player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
                            item(c)=item(lastitem)
                            lastitem=lastitem-1
                            c=findbest(7,-1)
                        EndIf
                    Next
                Case 1
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    item(c).w.x=p.x
                    item(c).w.y=p.y
                    itemindex.add(c,item(c).w)
                End Select
            Else
                dprint "canceled"
            EndIf
        Else
            dprint "That's not a grenade."
        EndIf
        awayteam.e.add_action(25-stims.effect)
    Else
        dprint"You dont have any grenades"
    EndIf
    Return 0
End Function

Function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
    Dim As Short a,b,slot,hitflag
    slot=player.map
    For a=1 To lastenemy
        If vismask(enemy(a).c.x,enemy(a).c.y)>0 And enemy(a).slot>=0 Then planets(slot).mon_seen(enemy(a).slot)=1
        If enemy(a).hp>0 Then
            If awayteam.c.x=enemy(a).c.x And awayteam.c.y=enemy(a).c.y and enemy(a).invis<>3 Then
                If enemy(a).made<>101 Then
                    awayteam.e.add_action(10-stims.effect)
                    awayteam.c=old
                        If enemy(a).sleeping>0 Or enemy(a).hpnonlethal>enemy(a).hp Then
                            b=findworst(26,-1)
                            If b=-1 Then b=findworst(29,-1) 'Using traps
                            If b>0 Then
                                If askyn("The "&enemy(a).sdesc &" is unconcious. Do you want to capture it alive?(y/n)") Then
                                    If item(b).v1<item(b).v2 Then
                                        item(b).v1+=1
                                        lastcagedmonster+=1
                                        cagedmonster(lastcagedmonster)=enemy(a)
                                        cagedmonster(lastcagedmonster).c.s=b
                                        '
                                        reward(1)=reward(1)+get_biodata(enemy(a))
                                        item(b).v3+=get_biodata(enemy(a))
                                        enemy(a).hp=0
                                        enemy(a).hpmax=0
                                        If enemy(a).slot>=0 Then planets(slot).mon_caught(enemy(a).slot)+=1
                                        awayteam.e.add_action(25-stims.effect)
                                    Else
                                        dprint "You don't have any unused cages."
                                    EndIf
                                EndIf
                                return 0
                            EndIf
                        endif
                    
                        If enemy(a).aggr=1 Then
                            If (askyn("Do you really want to attack the "&enemy(a).sdesc &"?(y/n)")) Then
                                enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                                hitflag=1
                                If rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel Then enemy(a).aggr=0
                                For b=1 To lastenemy
                                    If a<>b Then
                                        If enemy(a).faction=enemy(b).faction and enemy(b).sleeping=0 and enemy(b).hpnonlethal<enemy(b).hp And vismask(enemy(b).c.x,enemy(b).c.y)>0 Then
                                            enemy(b).aggr=0
                                            dprint "The "&enemy(b).sdesc &" tries to help his friend!",14
                                        EndIf
                                    EndIf
                                Next
                            Else
                                dprint "You squeeze past the "&enemy(a).sdesc &"."
                                Swap awayteam.c,enemy(a).c
                                enemy(a).add_move_cost
                                awayteam.e.add_action(2-stims.effect)
                                
                            EndIf
                        Else
                            awayteam.attacked=a
                            awayteam.e.add_action(awayteam.atcost-stims.effect)
                            enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                            hitflag=1
                        EndIf
                    EndIf
                EndIf
            EndIf
    Next
    if hitflag=0 then awayteam.attacked=0
    Return 0
End Function

Function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
    Dim enlist(128) As Short
    Dim shortlist As Short
    Dim wp(60*20) As _cords
    Dim dam As Short
    Dim As Short first,last,lp,osx,rollover
    Dim As Short a,b,c,d,e,f,slot,x,i,l
    Dim As Short scol
    Dim As Single range
    Dim fired(60,20) As Byte
    Dim As _cords p,p1,p2
    Dim text As String
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    make_locallist(slot)
    if planets(slot).depth=0 then rollover=1
    If configflag(con_tiles)=0 Then
        x=awayteam.c.x-osx
        If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put (x*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
        Put (x*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
        If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put (x*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
    Else
        set__color( _teamcolor,0)
        Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
    EndIf
    range=1.5
    For a=1 To 128'awayteam.hp
        If crew(a).hp>0 And crew(a).onship=0 Then
            If awayteam.secweapran(a)>range Then range=awayteam.secweapran(a)
        EndIf
    Next
    
    scol= 7
    If range>=3 Then scol=11
    If range>=4 Then scol=12
    If range>=5 Then scol=10

    Screenset 1,1
    if _debug>0 then dprint "range:"&range
    If autofire_target.m>0 Then
        awayteam.e.add_action(awayteam.atcost-stims.effect)

        e=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        l=line_in_points(autofire_target,awayteam.c,wp(),planets(slot).depth)
        if l>range then l=range
        for i=1 to l
            if _debug>0 then dprint i  &" "& cords(wp(i))
            If configflag(con_tiles)=0 Then
                If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
            Else
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
            EndIf
            p2=wp(i)
            set__color( scol,0)
            If vismask(p2.x,p2.y)>0 Then
                If configflag(con_tiles)=0 Then
                    x=p2.x-osx
                    if x<0 then x+=61
                    if x>60 then x-=61
    
                    If range<4 Then
                        Put((x)*_tix,p2.y*_tiy),gtiles(gt_no(75)),trans
                    Else
                        Put((x)*_tix,p2.y*_tiy),gtiles(gt_no(76)),trans
                    EndIf
                Else
                    Draw String((p2.x-osx)*_fw1,p2.y*_fh1), "*",,Font1,custom,@_col
                EndIf
            EndIf
            c=c+1
            c=ep_fireeffect(p2,slot,c,range,mapmask())
        next
        
        If e=0 Then Sleep 100
        c=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
    else
        for i=1 to lastenemy
            if enemy(i).hp>0 and vismask(enemy(i).c.x,enemy(i).c.y)>0 and distance(awayteam.c,enemy(i).c,planets(slot).depth)<=range and enemy(i).invis=0 then target.add(enemy(i).c,i)
        next
        target.sort(awayteam.c,planets(slot).depth)
        if target.ti=0 and target.targets.vlast>0 then target.ti=1
        dprint "Choose target:"
        if target.t.x=-1 or distance(target.t,awayteam.c)>range then target.t=awayteam.c
    
        a=0
        
        Do
            p=target.t
            p1=p
            screenset 0,1
            cls
            display_planetmap(slot,osx,0)
            ep_display()
            display_awayteam()
            dprint ""
            If configflag(con_tiles)=0 Then
                If awayteam.movetype=mt_fly Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(gt_no(2002)),trans
                Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy),gtiles(captain_sprite),trans
                If awayteam.movetype=mt_hover Or awayteam.movetype=mt_flyandhover Then Put ((awayteam.c.x-osx)*_tix,awayteam.c.y*_tiy+4),gtiles(gt_no(2001)),trans
            Else
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
            EndIf
            flip
            no_key=Cursor(p,slot,osx)
            If _debug>0 then dprint "dus"&distance(p,awayteam.c,planets(slot).depth)
            If distance(p,awayteam.c,planets(slot).depth)>range Then p=p1
            target.t=p
            if no_key="+" or no_key="-" then target.t=target.plusminus(no_key)
            If no_key=key_te Or Ucase(no_key)=" " Or no_key=key__enter Then a=1
            If no_key=key_quit Or no_key=key__esc Then return 0
        Loop Until a<>0 or no_key=key_layfire
        
        if no_key<>key_layfire then
            if a=1 then 
                autofire_target=p
                if key=key_autofire then autofire_target.m=1
            endif
            
            if _debug>0 then dprint "range:"&range
            If a>0 Then
                if _debug>0 then dprint "dist:"&distance(awayteam.c,autofire_target,planets(slot).depth)
                If distance(awayteam.c,autofire_target,planets(slot).depth)<=range Then
                    awayteam.e.add_action(awayteam.atcost-stims.effect)
                    lp=line_in_points(autofire_target,awayteam.c,wp(),planets(slot).depth)
                    For b=1 To lp
                        set__color( scol,0)
                        If configflag(con_tiles)=0 Then
                            If range<4 Then
                                Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                            Else
                                Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                            EndIf
                        Else
                            Draw String((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                        EndIf
                        b=ep_fireeffect(wp(b),slot,b,lp,mapmask())
                        Sleep 15
                    Next
                    target.t=autofire_target
                Else
                    dprint "Target out of range.",14
                EndIf
                Sleep 100
            EndIf
            If Key=key_autofire Then walking=10
        endif
        
        If no_key=key_layfire Then
            awayteam.e.add_action(awayteam.atcost-stims.effect)
            For a=1 To lastenemy
                If vismask(enemy(a).c.x,enemy(a).c.y)>0 And enemy(a).hp>0 And enemy(a).aggr=0 And distance(awayteam.c,enemy(a).c,planets(slot).depth)<=range Then
                    If pathblock(awayteam.c,enemy(a).c,slot,1) Then
                        shortlist+=1
                        enlist(shortlist)=a
                    EndIf
                EndIf
            Next
            If shortlist>0 Then
                first=1
                last=Fix(awayteam.hpmax/shortlist)
                If last<1 Then last=1
                For a=1 To shortlist
                    lp=line_in_points(enemy(enlist(a)).c,awayteam.c,wp())
                    If lp>=1 Then
                        For b=1 To lp
                            If wp(b).x>=0 And wp(b).x<=60 And wp(b).y>=0 And wp(b).y<=20 Then
                                set__color( scol,0)
                                If configflag(con_tiles)=0 Then
                                    If range<4 Then
                                        Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                                    Else
                                        Put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                                    EndIf
                                Else
                                    Draw String((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                                EndIf
                                fired(wp(b).x,wp(b).y)=1
                                b=ep_fireeffect(wp(b),slot,b,lp-1,mapmask(),first,last)
                            EndIf
                        Next
                    EndIf
                    first=first+last+1
                Next
                Sleep 100
            Else
                dprint "No hostile targets in sight."
            EndIf
            autofire_target.m=0
        endif
    EndIf
    Return 0
End Function

Function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short
    Dim As Short d,f,x,y,vacc
    Dim As Single dam
    If first=0 And last=0 Then
        first=1
        last=awayteam.hpmax
    EndIf
    For d=1 To lastenemy
        If enemy(d).c.x=p2.x And enemy(d).c.y=p2.y And enemy(d).hp>0 Then
            enemy(d)=hitmonster(enemy(d),awayteam,mapmask(),first,first+last)
            'e=1
        EndIf
    Next
    If tmap(p2.x,p2.y).shootable=1 Then
        dam=0
        For f=first To last
            If crew(f).hp>0 And crew(f).onship=0 Then dam=dam+awayteam.secweap(f)
        Next
        dam=CInt(dam-tmap(p2.x,p2.y).dr)
        'dprint "in here with dam "&dam
        If dam>0 Or (awayteam.stuff(5)>0 And c=1) Then
            dam=dam+awayteam.stuff(5)
            If dam<=0 Then dam=awayteam.stuff(5)
            dprint tmap(p2.x,p2.y).succt &" ("&dam &" damage)"
            tmap(p2.x,p2.y).hp=tmap(p2.x,p2.y).hp-dam
            If tmap(p2.x,p2.y).hp>=1 And tmap(p2.x,p2.y).hp<=tiles(tmap(p2.x,p2.y).no).hp*.25 Then dprint "The "&tmap(p2.x,p2.y).desc &" is showing signs of serious damage."
            If tmap(p2.x,p2.y).hp<=0 Then
                If tmap(p2.x,p2.y).no=243 Then
                    If vacuum(p2.x,p2.y)=0 Then
                        For x=p2.x-1 To p2.x+1
                            For y=p2.y-1 To p2.y+1
                                If x>=0 And x<=60 And y>=0 And y<=20 Then
                                    If vacuum(x,y)=1 Then vacc=1
                                EndIf
                            Next
                        Next
                        If vacc=1 Then
                            dprint "The air rushes out of the ship!",14
                            awayteam.helmet=1
                        EndIf
                    EndIf
                EndIf
                dprint tmap(p2.x,p2.y).killt,10
                tmap(p2.x,p2.y)=tiles(tmap(p2.x,p2.y).turnsinto)
                If planetmap(p2.x,p2.y,slot)>0 Then planetmap(p2.x,p2.y,slot)=tmap(p2.x,p2.y).no
                If planetmap(p2.x,p2.y,slot)<0 Then planetmap(p2.x,p2.y,slot)=-tmap(p2.x,p2.y).no
            EndIf
        Else
            dprint tmap(p2.x,p2.y).failt,14
        EndIf
    EndIf
    If tmap(p2.x,p2.y).firetru=1 Then
        c=range+1
    EndIf
    Return c
End Function

Function ep_closedoor() As Short
    Dim As Short a,slot
    Dim p1 As _cords
    slot=player.map
    awayteam.e.add_action(5-stims.effect)
    For a=1 To 9
        If a<>5 Then
            p1=movepoint(awayteam.c,a)
            If tmap(p1.x,p1.y).onclose<>0 Then
                dprint "You close the "&tmap(p1.x,p1.y).desc &"."
                planetmap(p1.x,p1.y,slot)=tmap(p1.x,p1.y).onclose
                tmap(p1.x,p1.y)=tiles(Abs(planetmap(p1.x,p1.y,slot)))
                tmap(p1.x,p1.y).locked=0
            EndIf
        EndIf
    Next
    Return 0
End Function

Function ep_examine() As Short
    Dim As _cords p2,p3
    Dim As String Key,text
    Dim As Short a,deadcounter,slot,osx,x
    Dim debug As Short
    Dim As _cords ship
    ship=player.landed
    slot=player.map
    p2.x=awayteam.c.x
    p2.y=awayteam.c.y
    Do
        Cls
        p3=p2
        osx=calcosx(p3.x,planets(slot).depth)
        make_vismask(awayteam.c,0,slot,,awayteam.groundpen)
        display_planetmap(slot,osx,0)
        ep_display(osx)
        display_awayteam(,osx)
        dprint ""
        Key=Cursor(p2,slot,osx)
        If p3.x<>p2.x Or p3.y<>p2.y Then
            If p2.x<0 Then
                If planets(slot).depth=0 Then
                    p2.x=60
                Else
                    p2.x=0
                EndIf
            EndIf
            If p2.x>60 Then
                If planets(slot).depth=0 Then
                    p2.x=0
                Else
                    p2.x=60
                EndIf
            EndIf
            If p2.y<0 Then p2.y=0
            If p2.y>20 Then p2.y=20
            If distance(p2,awayteam.c,planets(slot).depth)<=awayteam.sight And vismask(p2.x,p2.y)>0 Then
                if tmap(p2.x,p2.y).desc<>"" then text=first_uc(tmap(p2.x,p2.y).desc)&". "
                if _debug>0 then text=text & planetmap(p2.x,p2.y,slot)
                
                For a=0 To lastportal
                    If p2.x=portal(a).from.x And p2.y=portal(a).from.y And slot=portal(a).from.m Then text=text & portal(a).desig &". "
                    If p2.x=portal(a).dest.x And p2.y=portal(a).dest.y And slot=portal(a).dest.m And portal(a).oneway=0 Then text= text &portal(a).desig &". "
                    If debug=9 And _debug=1 And p2.x=portal(a).from.x And p2.y=portal(a).from.y And slot=portal(a).from.m Then text=text &a &":"&portal(a).from.m &"dest:"& portal(a).dest.m &":"& portal(a).dest.x &":"& portal(a).dest.y &"oneway:"&portal(a).oneway
                Next
                
                if itemindex.last(p2.x,p2.y)>0 then
                    For a=1 To itemindex.last(p2.x,p2.y)
                        If item(itemindex.index(p2.x,p2.y,a)).w.p=0 And item(itemindex.index(p2.x,p2.y,a)).w.s=0 Then
                            text=text & item(itemindex.index(p2.x,p2.y,a)).desig & ". "
                            'if show_all=1 then text=text &"("&item(li(a)).w.x &" "&item(li(a)).w.y &" "&item(li(a)).w.p &" "&localitem(a).w.s &" "&localitem(a).w.m &")"
                        EndIf
                    Next
                endif
                
                For a=1 To lastenemy
                    If enemy(a).c.x=p2.x And enemy(a).c.y=p2.y And enemy(a).hpmax>0 Then
                        'dprint enemy(a).hpmax &":"&enemy(a).hp &enemy(a).invis & monster_description(enemy(a))
                        If enemy(a).hp>0 Then
                            if enemy(a).invis=0 then
                                set__color( enemy(a).col,9)
                                text=text &" "& monster_description(enemy(a)) '&"faction"&enemy(a).faction &"aggr" &enemy(a).aggr
                                If configflag(con_tiles)=0 Then
                                    Put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                                Else
                                    Draw String (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), Chr(enemy(a).tile),,Font1,custom,@_col
                                EndIf
                            endif
                        Else
                            set__color( 12,0)
                            If configflag(con_tiles)=0 Then
                                 Put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tix),gtiles(261),trans
                            Else
                                Draw String (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), "%",,Font1,custom,@_col
                            EndIf
                            text=text & monster_description(enemy(a))
                            If _debug=1 And _debug=1 Then text=text &"("&a &" of "&lastenemy &")"
                        EndIf
                        Exit For 'there won't be more than one monster on one tile
                    EndIf
                Next
            EndIf
            If text<>"" Then dprint text
            text=""
        EndIf
    Loop Until Key=key__enter Or Key=key__esc Or Ucase(Key)="Q"
    Return 0
End Function

Function ep_jumppackjump() As Short
    Dim As Short a,b,d,slot
    slot=player.map
    awayteam.e.add_action(10-stims.effect)
    If awayteam.jpfuel>2 Then
        awayteam.jpfuel=awayteam.jpfuel-3
        If planets(slot).depth=0 Or slot=specialplanet(9) Or slot=specialplanet(4) Or slot=specialplanet(3) Then
            b=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
            dprint "Direction?"
            d=getdirection(keyin())
            If d=4 Then d=d+1
            If b<2 Then b=2
            For a=1 To b
                If rnd_range(1,6)+rnd_range(1,6)>7 Then d=bestaltdir(d,rnd_range(0,1))
                dtile(awayteam.c.x,awayteam.c.y,tmap(awayteam.c.x,awayteam.c.y),1)

                awayteam.c=movepoint(awayteam.c,d)
                set__color( _teamcolor,0)
                Draw String (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
                Sleep 50
            Next
            awayteam.oxygen=awayteam.oxygen-5
            If rnd_range(1,6)+rnd_range(1,6)+planets(slot).grav>7 Then
                dprint "Crash Landing! " &dam_awayteam(rnd_range(1,1+planets(slot).grav))
            Else
                dprint "You land savely"
            EndIf
        Else
            dprint "you hit the ceiling pretty fast! "&dam_awayteam(rnd_range(1,1+planets(slot).grav))
        EndIf
    Else
        dprint "Not enough jetpack fuel"
    EndIf
    Return 0
End Function

Function ep_crater(shipfire() As _shipfire, ByRef sf As Single) As Short
    Dim As Short b,r,x,y,c,slot
    Dim As _cords p2,p1
    Dim m(60,20) As Short
    slot=player.landed.m
    b=rnd_range(1,15)-countgasgiants(sysfrommap(player.landed.m))+countasteroidfields(sysfrommap(player.landed.m))
    b=b-planets(player.landed.m).atmos
    If b>0 Then
        c=0
        dprint "A meteorite streaks across the sky and slams into the planets surface!",14
        Do
            c+=1
            r=5
            If rnd_range(1,100)<66 Then r=3
            If rnd_range(1,100)<66 Then r=2

            p2.x=player.landed.x
            p2.y=player.landed.y
            p1=rnd_point

            For x=0 To 60
                For y=0 To 20
                    m(x,y)=0
                    If tmap(x,y).walktru>0 Then m(x,y)=1
                    p2.x=x
                    p2.y=y
                    If CInt(distance(p2,p1,planets(slot).depth))=r+1 Then m(x,y)=0
                    If CInt(distance(p2,p1,planets(slot).depth))=r Then m(x,y)=1
                Next
            Next
            flood_fill(player.landed.x,player.landed.y,m(),2)
        Loop Until m(awayteam.c.x,awayteam.c.y)=255 Or c>=25
        If c=25 Then Return 0

        For x=0 To 60
            For y=0 To 20
                p2.x=x
                p2.y=y
                If CInt(distance(p2,p1,planets(slot).depth))=r+1 Then
                    If planetmap(p2.x,p2.y,player.landed.m)<0 Then planetmap(p2.x,p2.y,player.landed.m)=-4
                    If planetmap(p2.x,p2.y,player.landed.m)>0 Then planetmap(p2.x,p2.y,player.landed.m)=4
                    tmap(p2.x,p2.y)=tiles(4)
                EndIf
                If CInt(distance(p2,p1,planets(slot).depth))=r Then
                    If planetmap(p2.x,p2.y,player.landed.m)<0 Then planetmap(p2.x,p2.y,player.landed.m)=-8
                    If planetmap(p2.x,p2.y,player.landed.m)>0 Then planetmap(p2.x,p2.y,player.landed.m)=8
                    tmap(p2.x,p2.y)=tiles(8)
                EndIf
            Next
        Next

        sf=sf+1
        If sf>15 Then sf=0
        shipfire(sf).when=1
        shipfire(sf).what=10+sf
        shipfire(sf).where=p1
        player.weapons(shipfire(sf).what)=make_weapon(6)
        player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
        player.weapons(shipfire(sf).what).dam=r 'Sets set__color( to redish
        If rnd_range(1,100)<33+r Then
            placeitem(make_item(96,-3,b\3),p1.x,p1.y,player.landed.m)
            itemindex.add(lastitem,item(lastitem).w)
            If rnd_range(1,100)<=2 Then
                planetmap(p1.x,p1.y,player.landed.m)=-191
                tmap(p1.x,p1.y)=tiles(191)
            EndIf
        EndIf
    Else
        dprint "A meteor streaks across the sky"
    EndIf
    Return 0
End Function


Function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String, loctemp As Single) As Short
    Dim As Short a,b,c,d,e,r,sf,slot,st,debug
    dim as integer money
    Dim As Single fuelsell,fuelprice,minprice
    Dim towed As _ship
    Dim As String text
    Dim As _cords p,p1,p2
    awayteam.e.add_action(10-stims.effect)
    slot=player.map
    If debug=1 And _debug=1 Then dprint ""&tmap(awayteam.c.x,awayteam.c.y).gives
    st=nearest_base(player.c)
    fuelprice=round_nr(basis(st).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
    If fuelprice<1 Then fuelprice=1
    If planets(slot).flags(26)=9 Then fuelprice=fuelprice*3
    fuelsell=fuelprice/2

    If tmap(awayteam.c.x,awayteam.c.y).gives=1 Then
        If specialplanet(1)=slot Then specialflag(1)=1
        findartifact(0)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=2 Then
        dprint "'Ah great. Imagining people again are we?' the occupant of this bunker looks like he had a pretty bad time. 'No wait. You are real? I am not imagining you?' He explains to you that he managed to survive for months, alone, after the sandworms had demolished his ship, and eaten his crewmates."
        If askyn("He is quite a good gunner and wants to join your crew. do you let him? (y/n)") Then
            add_member(3,6)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=3 Then
        dprint "The pirates are holding the executive in this ship!"
        If rnd_range(1,100)<55 Then
            dprint "He is still alive!",10
            player.questflag(2)=2
        Else
            dprint "They killed him.",12
            player.questflag(2)=3
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives>=4 And tmap(awayteam.c.x,awayteam.c.y).gives<=8 Then
        If tmap(awayteam.c.x,awayteam.c.y).gives<>8 Then dprint "The local stock exchange."
        If tmap(awayteam.c.x,awayteam.c.y).gives=8 Then dprint "The insect colonists are eager to trade."
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            If tmap(awayteam.c.x,awayteam.c.y).gives=7 And specialflag(20)=0 Then
                For a=1 To 8
                    basis(8).inv(a).v=0
                Next
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).gives=8 Then
                For a=1 To 8
                    basis(9).inv(a).v=rnd_range(1,8-a)
                Next
            EndIf
            trading(tmap(awayteam.c.x,awayteam.c.y).gives+1)
            player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
            player.lastvisit.t=player.turn
        Else
            dprint "they dont want to trade with you."
        EndIf
    EndIf




    If tmap(awayteam.c.x,awayteam.c.y).gives=12 Then
        dprint "you found some still working laser drills"
        player.stuff(5)=2
        placeitem(make_item(15),0,0,0,0,-1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=13 Then
        dprint "The crew of this ship not only survived the crash landing, they opened a casino here!"
        If specialflag(11)=0 Then
            no_key=keyin
            b=casino(1)
            If b>0 Then
                If b>1000 Then b=1100
                For a=0 To b Step 100
                p1=movepoint(awayteam.c,5)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(23,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,p1.x,p1.y,lastenemy)
                Next
                specialflag(11)=1
            EndIf
        Else
            dprint "you are informed that you are barred from the casino."
        EndIf
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=15 Then
        buysitems("This house is stuffed floor to ceiling with antiquities. Paintings, statues, furniture, jewelery, some is of earth origin, some clearly not.","Do you think you have anything to sell him?(y/n)",23)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=16 Then
        If planets(slot).flags(22)=0 Then dprint "The miners inform you that they have just shipped all their ore to the nearest spacestation."
        If planets(slot).flags(22)=-1 Then
            buysitems("There was an explosion in the mine. A lot of the workers have been injured. The medical officer offers to buy any medical supplies you may have.","Do you want to sell your medpacks?",11,1.25)
            planets(slot).flags(22)=0
        EndIf
        If planets(slot).flags(22)>0 Then
            b=planets(slot).flags(22)
            For a=lastitem+1 To lastitem+1+b
                Do
                    item(a)=make_item(96)
                Loop Until item(a).ty=15
                item(a).v5+=10
                item(a).v2+=10
                minprice+=item(a).v5
                
            Next
            minprice=10+CInt(minprice*(5/(5+disnbase(player.c))))
            If askyn("The miners are willing to sell some ore for "&credits(minprice)&" Cr. Do you want to buy it? (y/n)") Then
                If paystuff(minprice) Then
                    For a=lastitem+1 To lastitem+1+b
                        item(a).w.s=-1
                        reward(2)+=item(a).v5
                    Next
                    lastitem=lastitem+1+b        
                    planets(slot).flags(22)=0
                EndIf
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=17 Then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying weapons of any kind, especially without going through the hassle a purchase at one of the stations would cause.'","Do you want to sell weapons?",2,1.15,1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=18 Then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying raw materials we can use to repair ships.'","Do you want to sell Resources?",15,0.95,1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=19 Then
        dprint "This is where the leaders of the planet meet. They express interest in high tech goods, and are willing to offer some automated gadgets they have been building."
        dprint "They are actually very sophisticated! The technology of these creatures is behind that of humanity in term of energy generation mainly, but everything else they seem to be equal or even surpassing."
        If rnd_range(1,100)>planets(slot).flags(28) Then
            If askyn ("Do you want to trade your tech goods for luxury goods?(y/n)") Then
                b=0
                For a=0 To 9
                    If player.cargo(a).x=4 Then
                        player.cargo(a).x=5
                        player.cargo(a).y=0
                        b=b+1
                    EndIf
                Next
                If b=0 Then dprint "You don't have any high tech goods to trade"
                If b>0 Then dprint "You trade "& b &" tons of high tech goods for luxury goods."
                planets(slot).flags(28)+=b
                If planets(slot).flags(28)>=5 Then

                    p.x=-1
                    p=rnd_point(slot,107)
                    If p.x>0 Then
                        planets(slot).flags(28)-=5
                        planetmap(p.x,p.y,slot)=297
                        tmap(p.x,p.y)=tiles(297)
                    Else
                        dprint "The leaders tell you that they managed to upgrade all factories on their planet"
                        specialflag(17)=1
                    EndIf
                EndIf
                no_key=keyin
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=26 Then
        dprint "A Weapons and Equipment store"
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            for b=0 to 3
                d=get_shop_index(sh_explorers+b,awayteam.c,-1)
                if d>0 then exit for
            next
            if d=0 then d=get_shop_index(sh_colonyI,awayteam.c,-1)
            Do
                Cls
                display_ship
                dprint ""
                c=shop(d,0.8,"Equipment")
            Loop Until c=-1
        Else
            dprint "they dont want to trade with you"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=27 Then
        dprint "A Bar"
        If slot=piratebase(0) Then
            If faction(0).war(2)<=30 Then
                If rnd_range(1,100)>10+crew(2).morale+add_talent(1,4,10) Then
                    dprint "Pilot "&crew(2).n &" doesn't want to come out again.",14
                    crew(2)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(3).morale+add_talent(1,4,10) Then
                    dprint "Gunner "&crew(3).n &" reckons he can make a fortune playing darts and decides to stay.",14
                    crew(3)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(4).morale+add_talent(1,4,10) Then
                    dprint "Science Officer "&crew(4).n &" has discovered an unknown drink. He decides to make a new carreer in barkeeping to study it.",14
                    crew(4)=crew(0)
                EndIf
                If rnd_range(1,100)>10+crew(5).morale+add_talent(1,4,10) Then
                    dprint "Doctor "&crew(5).n &" comes to the conclusion that he is needed more here than on your ship." ,14
                    crew(5)=crew(0)
                EndIf
            Else
                dprint "they dont want to serve you"& faction(0).war(2)
            EndIf
        EndIf
        If slot<>piratebase(0) Or faction(0).war(2)<=30 Then
            hiring(0,rnd_range(0,5),maximum(4,awayteam.hp))
            equip_awayteam(slot)
            make_vismask(awayteam.c,calc_sight(),slot)
            If awayteam.oxygen<awayteam.oxymax Then awayteam.oxygen=awayteam.oxymax
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=28 Then
        dprint "Spaceship fuel for sale"
        If planets(slot).flags(26)=9 Then dprint "Due to a fuel shortage the price has been increased."
        If slot<>piratebase(0) Or faction(0).war(2)<=30 Then
            If askyn("Do you want to refuel (" &fuelprice &" Cr. per ton) and reload ammo? (y/n)") Then refuel(planets(slot).flags(29),fuelprice)
        Else
            dprint "they deny your request"& faction(0).war(2)
        EndIf
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=29 Then
        dprint "Ships Repair"
        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            repair_hull(0.8)
        Else
            dprint "they dont want to repair a ship they shot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=30 Then
        dprint "Entering "&Shipyardname(sy_pirates)
        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            If slot=piratebase(0) Then
                shipupgrades(4)
            Else
                shipupgrades(5)
            EndIf
        Else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=31 Then
        dprint "Entering "&Shipyardname(sy_pirates)

        If slot<>piratebase(0) Or faction(0).war(2)<=20 Then
            shipyard(sy_pirates)
        Else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=132 Then
        If alliance(0)=1 And alliance(2)=0 Then
            If askyn("Do you want to order your pirates to join the alliance against the robot ships?(y/n)") Then
                dprint "We stand by your side."
                alliance(2)=1
                factionadd(0,2,-100)
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=32 Then
        dprint "This is the Villa of the Pirate Leader."
        If faction(0).war(2)<=20 Then
            reward_bountyquest(1)
            reward_patrolquest()
            Select Case questroll
            Case 10 To 25 
                give_bountyquest(1)
            Case 1 To 10
                give_patrolquest(1)
            End Select
            
            If player.towed<>0 Then
                towed=gethullspecs(drifting(player.towed).s,"data/ships.csv")
                a=towed.h_price
                If planets(drifting(player.towed).m).genozide<>1 Then a=a/2
                a=CInt(a)
                If askyn ("the pirate chief offers you "&a &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") Then
                    drifting(player.towed)=drifting(lastdrifting)
                    lastdrifting-=1
                    addmoney(a,mt_piracy)
                    player.towed=0
                EndIf
            EndIf
            dprint "You sit down for some drinks and discuss your travels."
            planet_bounty()
        EndIf
        If faction(0).war(2)<=60 Then                    
            if player.questflag(3)=1 then
                dprint "After some negotiations you convince him to buy the secret of controling the alien ships for ... 1,000,000 CR!",10
                factionadd(0,1,-15)
                addmoney(1000000,mt_artifacts)
                player.questflag(3)=3
            endif
            If askyn("Do you want to challenge him to a duel?(y/n)") Then
                dprint "He accepts. The Anne Bonny launches and awaits you in orbit."
                no_key=keyin
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(5)
                spacecombat(fleet(lastfleet),3)
                If player.dead=0 Then
                    dprint "Defeating the pirate chief makes you the new pirate chief!",c_gre
                    addmoney(100000,mt_piracy)
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=198
                Else
                    player.dead=26
                EndIf
            EndIf
            
            ask_alliance(2)

        EndIf
        If faction(0).war(2)>60 Then
            dprint "He does not want to talk to you"
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=33 Then specialflag(27)=1

    If tmap(awayteam.c.x,awayteam.c.y).gives=34 Then buy_weapon(1)

    If tmap(awayteam.c.x,awayteam.c.y).gives=35 Then shipyard(sy_blackmarket)

    If tmap(awayteam.c.x,awayteam.c.y).gives=36 Then
        If slot<>piratebase(0) Or faction(0).war(1)<=0 Then
            dprint "The captain of this scoutship says: 'Got any bio or mapdata? I can sell that stuff at the space station and offer to split the money 50:50"
            If askyn("Do you want to sell data(y/n)") Then
                dprint "you transfer new map data on "&reward(0)&" km2. you get paid "&CInt((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))&" credits"
                addmoney(CInt((reward(7)/15)*.5*(1+0.1*crew(1).talents(2))),mt_map)
                reward(0)=0
                reward(7)=0
                dprint "you transfer data on alien lifeforms worth "& CInt(reward(1)*.5*(1+0.1*crew(1).talents(2))) &" credits."
                addmoney(CInt(reward(1)*.5*(1+0.1*crew(1).talents(2))),mt_bio)
                reward(1)=0
                For a=0 To lastitem
                    If item(a).ty=26 And item(a).w.s=-1 Then item(a).v1=0
                Next
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=39 Then
        'Food planet
        If player.questflag(25)=0 Then
            If player.questflag(20)>0 Then
                If player.questflag(20)=1 Then dprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrower."
                If player.questflag(20)>1 Then dprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrowers."
                addmoney(player.questflag(20)*10,mt_trading)
                player.questflag(20)=0
            EndIf

            If findbest(87,-1)>0 Then
                If askyn("The colonists would buy the burrowers eggsacks for 50 Credits a piece. Do you want to sell?(y/n)") Then
                    For a=0 To lastitem
                        If item(a).ty=87 And item(a).w.s=-1 Then
                            destroyitem(a)
                            addmoney(50,mt_bio)
                        EndIf
                    Next
                EndIf
            EndIf
        Else
            If player.questflag(25)=1 Then
                player.questflag(25)=2
                dprint "The colonists leader accepts the burrowers terms. They offer you 1000 Cr. for your help in negotiating a peace"
                addmoney(1000,mt_quest2)
            EndIf
        EndIf
        If askyn("Do you want to trade with the colonists?(y/n)") Then
            If player.questflag(25)=0 Then
                basis(9).inv(1).v=10
                basis(9).inv(1).p=10
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                For a=2 To 8
                    basis(9).inv(a).v=0
                Next
            Else
                basis(9).inv(1).v=5
                basis(9).inv(1).p=15
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                For a=2 To 8
                    basis(9).inv(a).v=0
                Next
            EndIf
            trading(9)
        EndIf

    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=40 Then
        dprint "A nagging feeling in the back of your head you had since you landed on this planet suddenly dissapears."
        specialflag(20)=1
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=41 Then
        dprint "A nagging feeling in the back of your head you had since you entered this ship suddenly dissapears."
        player.questflag(11)=3
    EndIf


    If tmap(awayteam.c.x,awayteam.c.y).gives=42 Then
        If slot<>piratebase(0) Or faction(0).war(2)<=0 Then
            If askyn("This shop offers hullrefits, turning 5 crew bunks into an additional cargo hold for 1000 Cr. Do you want your ship modified?(y/n)") Then
                If paystuff(1000) Then pirateupgrade
            EndIf
        Else
            dprint "they dont want to repair a ship they are going to shoot up themselves."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=43 Then
        player.disease=sick_bay(get_shop_index(sh_sickbay,awayteam.c,-1),1)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=44 Then
        If planets(slot).mon_killed(1)=0 Then
            If askyn("Do you want to fight in the arena? (y/n)") Then
                planets(slot).depth=0
                enemy(1)=enemy(0)
                enemy(1)=makemonster(2,slot)
                enemy(1)=setmonster(enemy(1),slot,spawnmask(),lsp,awayteam.c.x+3,awayteam.c.y,1)
                enemy(1).slot=1
                
                money=(enemy(1).hpmax^2+enemy(1).armor+enemy(1).weapon+rnd_range(1,2))*10
                if money>30000 then money=30000
                planets(slot).plantsfound=money
                
                planets(slot).depth=1

                For x=awayteam.c.x+1 To awayteam.c.x+5
                    For y=awayteam.c.y-2 To awayteam.c.y+2
                        If rnd_range(1,100)<66 Then
                            planetmap(x,y,slot)=rnd_range(2,4)
                        Else
                            planetmap(x,y,slot)=rnd_range(1,7)
                        EndIf
                        tmap(x,y)=tiles(planetmap(x,y,slot))
                    Next
                Next
            else
                If askyn("Do you want to sell your aliens as arena contestants?(y/n)") Then
                    sell_alien(slse_arena)
                EndIf
            endif
        Else
            
            addmoney(planets(slot).plantsfound,mt_gambling)
            dprint "You get "& planets(slot).plantsfound &" Cr. for the fight.",10
            planets(slot).mon_killed(1)=0
            planets(slot).plantsfound=0
            For x=awayteam.c.x+1 To awayteam.c.x+5
                For y=awayteam.c.y-2 To awayteam.c.y+2
                    planetmap(x,y,slot)=4
                    tmap(x,y)=tiles(planetmap(x,y,slot))
                Next
            Next
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=45 Then 
        If is_drifter(slot) Then
            casino(,-1)
        Else
            casino(,10)
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=46 Then
        sell_alien(slse_zoo)
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=47 Then retirement()

    If tmap(awayteam.c.x,awayteam.c.y).gives=48 Then buytitle()

    If tmap(awayteam.c.x,awayteam.c.y).gives=49 Then customize_item()

    If tmap(awayteam.c.x,awayteam.c.y).gives=50 Then
        If planets(slot).flags(26)=1 Then dprint "The admin informs you that there is a alien lifeform lose on the station, and advises you to stay clear of dark corners."
        If planets(slot).flags(26)=4 Then dprint "The admin informs you that there is a mushroom infestation on the station, and that he pays 50 credits for each dead one."
        If planets(slot).flags(26)=5 Then dprint "The admin informs you that there is a group of pirates on the station and asks you to be polite."
        If planets(slot).flags(26)=6 Then dprint "The admin informs you that the station has been hit by an asteroid and is currently leaking. He apologizes for the inconvenience."
        If planets(slot).flags(26)=9 Then dprint "The admin informs you that there is a fuel shortage and the prices have been increased to "&fuelprice &" for buying and " &fuelsell & " Cr. a ton for selling"
        If planets(slot).flags(26)=10 Then dprint "The admin is very excited: There is a party of civilized aliens on board!"
        If planets(slot).flags(26)=12 Then dprint "The admin informs you that there is a tribble infestation on the station, and that he pays 10 credits for each dead one."
        For a=1 To lastenemy
            If enemy(a).hp<=0 Then
                If enemy(a).made=2 Then planets(slot).flags(26)=2
                If enemy(a).made=7 Then planets(slot).flags(27)+=1
                If enemy(a).made=34 Then planets(slot).flags(27)+=1
                If enemy(a).made=101 Then planets(slot).flags(27)+=1
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
            EndIf
        Next
        If planets(slot).flags(26)=2 Then
            planets(slot).flags(26)=3
            player.money=player.money=100
            dprint "The Admininstrator thanks you for dispatching the beast, and gives you 100 Cr."
        EndIf
        If planets(slot).flags(27)>0 And planets(slot).flags(26)=4 Then
            dprint "You get "&50*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(50*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf
        If planets(slot).flags(27)>0 And planets(slot).flags(26)=5 Then
            dprint "'Thanks for helping to fight back the pirates' You get "&250*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(250*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf

        If planets(slot).flags(27)>0 And planets(slot).flags(26)=12 Then
            dprint "You get "&10*planets(slot).flags(27) &" Cr. for the killed tribbles."
            addmoney(10*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        EndIf

        If askyn("Do you want to sell fuel for " &fuelsell &" Credits per ton? (y/n)") Then
            If getinvbytype(9)>0 Then
                If askyn( "Do you want to sell fuel stored in your cargo hold?") Then
                    dprint "How much fuel do you want to sell?"
                    a=getnumber(0,getinvbytype(9),0)
                    addmoney(Int(a*30*fuelsell),mt_trading)
                    removeinvbytype(9,a)
                    If planets(slot).flags(26)=9 Then
                        If rnd_range(1,100)<planets(slot).flags(27) Then planets(slot).flags(26)=0
                    EndIf
                    dprint "You sell "&30*a &" tons of fuel for "& Int(30*a*fuelsell) &" Cr."
                EndIf
            EndIf
            dprint "How much fuel do you want to sell? (" &player.fuel &")"
            a=getnumber(0,player.fuel,0)
            If a>0 Then
                player.fuel=player.fuel-a
                addmoney(Int(a*fuelsell),mt_trading)
                If planets(slot).flags(26)=9 Then
                    If rnd_range(1,100)<planets(slot).flags(27) Then planets(slot).flags(26)=0
                EndIf
                dprint "You sell "&a &" tons of fuel for "& Int(a*fuelsell) &" Cr."
            EndIf
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=51 Then
        dprint tmap(awayteam.c.x,awayteam.c.y).hitt
        For a=0 To lastenemy
            If enemy(a).made<>73 Then enemy(a).aggr=0
        Next
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=55 Then
        If askyn("A tank full of processed ship fuel. Do you want to use it?(y/n)") Then
            player.fuel=player.fuelmax+player.fuelpod
            dprint "You refuel your ship."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=56 Then
        If askyn("Do you want to repair it?(y/n)") Then
            If skill_test(player.science(location),st_average,"Repair") Then
                If skill_test(player.science(location),st_average,"Repair") Then
                    dprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=232
                    planets(slot).atmos=5
                Else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=231
                    dprint "You fail."
                EndIf
            Else
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=233
                dprint "You destroy the console in your attempt to repair it."
            EndIf

        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=57 Then 'repairing reactor
        If askyn("Do you want to repair it?(y/n)") Then
            If skill_test(player.science(location),st_average,"Repair") Then
                If skill_test(player.science(location),st_average,"Repair") Then
                    dprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=235
                    specialflag(31)=1
                    'hide map
                    'put station 3 in positon
                EndIf
            Else
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=236
                dprint "You destroy the console in your attempt to repair it."
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).turnsinto=234 Then dprint "You fail."
        EndIf
    EndIf

    If tmap(awayteam.c.x,awayteam.c.y).gives=58 Then 'shutting down reactor
        If askyn("Do you want to shut it down? (y/n)") Then
            For x=0 To 60
                For y=0 To 20
                    If planetmap(x,y,specialplanet(9))=-18 Then planetmap(x,y,specialplanet(9))=-4
                    If planetmap(x,y,specialplanet(9))=18 Then planetmap(x,y,specialplanet(9))=4
                Next
            Next
            If Not(skill_test(player.science(location),st_easy)) Then
                dprint "Something went wrong... this thing is about to blow up!"
                sf=sf+1
                If sf>15 Then sf=0
                shipfire(sf).where=awayteam.c
                shipfire(sf).when=3
                shipfire(sf).what=10+sf
                player.weapons(shipfire(sf).what)=make_weapon(rnd_range(1,5))
                sf=sf+1 'Sets set__color( to blueish
            EndIf
        EndIf
    EndIf
            
            If tmap(awayteam.c.x,awayteam.c.y).gives=59 Then 'Scrapyard
                botsanddrones_shop(get_shop_index(sh_bots,awayteam.c,-1))
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=60 Then 'Town hall in settlements
                If askyn("Do you want to trade with the locals?(y/n)") Then
                    '
                    ' Trading
                    '
                    For a=11 To 13
                        If planets(slot).flags(a)<0 Then
                            c=Int(baseprice(a-10)*(rnd_range(1,2)+Abs(planets(slot).flags(a))))
                            If a=11 Then text="The colonists are in dire need of food. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            If a=12 Then text="The colonists are in dire need of basic goods. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            If a=13 Then text="The colonists are in dire need of tech goods. They are willing to pay "&c &" per ton.Do you want to sell? (y/n)"
                            If getinvbytype(a-10)>0 Then
                                If askyn(text) Then
                                    For b=1 To player.h_maxcargo
                                        If player.cargo(b).x=a-9 Then
                                            dprint "You sell a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                            player.cargo(b).x=1
                                            addmoney(c,mt_trading)
                                            planets(slot).flags(a)=0
                                        EndIf
                                    Next
                                EndIf
                            EndIf
                        ElseIf planets(slot).flags(a)>0 Then
                            c=Int(baseprice(a-10)/(rnd_range(1,2)+Abs(planets(slot).flags(a))))
                            If a=11 Then text="The colonists have a surplus of food. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If a=12 Then text="The colonists have a surplus of basic goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If a=13 Then text="The colonists have a surplus of tech goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)"
                            If askyn(text) Then
                                d=getnextfreebay()
                                If d>0 Then
                                    If paystuff(c) Then
                                        dprint "You buy a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                        player.cargo(d).x=a-9
                                        player.cargo(d).y=c
                                        planets(slot).flags(a)=0
                                    Else
                                        dprint "You don't have enough money."
                                    EndIf
                                Else
                                    dprint "You don't have enough room."
                                EndIf
                            EndIf
                        EndIf
                    Next
                    If planets(slot).flags(14)>0 Then
                        If askyn("The colonists have some equipment they no longer need. Do you want to look at it?(y/n)") Then shop(planets(slot).flags(14),.75,"Equipment for sale")
                    EndIf
                    For a=15 To 20
                        If planets(slot).flags(a)>0 Then
                            'selling equipment
                            text=""
                            If planets(slot).flags(a)=1 Then text="They need jetpacks and hoverplatforms. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=2 Then text="They need long range weapons. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=3 Then text="They need armor. They are offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=4 Then text="They need melee weapons. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=5 Then text="They need mining equipment. They offer to pay 150% of station prices. "
                            If planets(slot).flags(a)=11 Then text="They need medical supplies. They offer to pay 150% of station prices. "
                            If text<>"" Then buysitems(text,"Do you want to sell?(y/n)",planets(slot).flags(a),1.5)
                        EndIf
                    Next
                EndIf
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=61 Then
                dprint "This computer contains files detailing how eridiani explorations uses the plants on this planet to produce a powerfull halluzinogenic drug, and smuggles it onto space stations. If this information went public it could seriously harm their business."
                player.questflag(21)=1
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=62 Then
                dprint "This computer runs a database, containing all the 'workers' in this complex. They all were 'convicted' for violating Smith Heavy Industries company policies, and have to work off their fine here. There is an alarmingly high number of 'work related accidents' Money paid for food for the workers is on the other hand alarmingly low. No wonder SHI doesn't advertise about this place."
                player.questflag(22)=1
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=63 Then
                x=player.c.x-basis(0).c.x/2
                y=player.c.y-basis(0).c.y/2
                x=basis(0).c.x+x
                y=basis(0).c.y+y
                If player.questflag(23)=0 Then
                    lastdrifting=lastdrifting+1
                    If lastdrifting>128  Then lastdrifting=128

                    drifting(lastdrifting).s=14
                    drifting(lastdrifting).x=x
                    drifting(lastdrifting).y=y
                    drifting(lastdrifting).m=lastplanet+1
                    lastplanet=lastplanet+1
                    load_map(13,lastplanet)
                    p=rnd_point(lastplanet,0)
                    planetmap(p.x,p.y,lastplanet)=-255
                    planets(lastplanet).mon_template(0)=makemonster(74,lastplanet)
                    planets(lastplanet).mon_noamin(0)=10
                    planets(lastplanet).mon_noamax(0)=16
                    planets(lastplanet).mon_template(1)=makemonster(75,lastplanet)
                    planets(lastplanet).mon_noamin(1)=5
                    planets(lastplanet).mon_noamin(1)=6
                EndIf
                player.questflag(23)=1
                dprint "At this terminal the routes of a big number of freelance traders are displayed. Triax Traders Ships are specially marked. Also the pirates are supposed to rendezvous with a ship at "&x &":"&y &" at regulare intervals."
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=64 Then
                player.questflag(23)=2
                dprint "This computer details the plan that Triax Traders is sponsoring Pirates."
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=65 Then
                player.questflag(24)=1
                dprint "Here are detailed experiments by Omega Bionegineering to breed crystal/human hybrids. They buy 'Volunteers' from a pirate captain. If this gets public it would break their neck."
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=66 Then
                mudds_shop(get_shop_index(sh_mudds,awayteam.c,-1))
            EndIf


            If tmap(awayteam.c.x,awayteam.c.y).gives=67 Then
                buysitems("We buy all pieces of art you may 'find'.","Do you think you have anything to sell?(y/n)",23,.25)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=68 Then
                dprint "The center of this temple contains a forcefield. In it is a beautiful, 3m tall woman, with long black hair, wearing a white robe.",15
                If askyn("A generator seems to provide the energy for the forcefield, do you want to try to turn it off?(y/n)") Then
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=297
                    dprint "You manage to switch it off"
                    no_key=keyin
                    dprint "As soon as the forcefield collapses the figure flies up through the cieling of the temple, shattering it.",15
                    lastfleet+=1
                    fleet(lastfleet).c=player.c
                    fleet(lastfleet).ty=10
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=57
                Else
                    dprint "She looks at you pleading, and pointing at the generator."
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=296
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=69 Then sell_alien(slse_zoo)

            If tmap(awayteam.c.x,awayteam.c.y).gives>=70 And tmap(awayteam.c.x,awayteam.c.y).gives<=73 Then
                If planets(slot).colflag(0)=0 Then
                    basis(10)=makecorp(tmap(awayteam.c.x,awayteam.c.y).no-298)
                Else
                    basis(10)=makecorp(planets(slot).colflag(0))
                    planets(slot).colflag(1)+=reward(0)/10
                    planets(slot).colflag(1)+=reward(1)/10
                    planets(slot).colflag(1)+=reward(2)/10
                    planets(slot).colflag(1)+=reward(3)/10
                    planets(slot).colflag(1)+=reward(4)/10
                    planets(slot).colflag(1)+=reward(5)/10
                    planets(slot).colflag(1)+=reward(6)/10
                    planets(slot).colflag(1)+=reward(7)/10
                EndIf
                basis(10).mapmod=basis(10).mapmod*0.75
                basis(10).biomod=basis(10).biomod*0.75
                basis(10).resmod=basis(10).resmod*0.75
                basis(10).pirmod=basis(10).pirmod*0.75
                company(10)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=74 Then sell_alien(slse_slaves)

            If tmap(awayteam.c.x,awayteam.c.y).gives=75 Then used_ships(get_shop_index(sh_used,awayteam.c,-1),get_shop_index(sh_usedships,awayteam.c,-1))
            
            If tmap(awayteam.c.x,awayteam.c.y).gives=76 Then 
                do
                    b=shop(get_shop_index(sh_giftshop,awayteam.c,-1),.9,"Giftshop")
                loop until b=-1
            endif
            
            If tmap(awayteam.c.x,awayteam.c.y).gives=167 Then
                If askyn("A working security camera terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        p1=awayteam.c
                        awayteam.c=rnd_point(slot,0)
                        dprint "You manage to access a camera at "&awayteam.c.x &":" &awayteam.c.y &"."
                        Do
                            make_vismask(awayteam.c,0,slot)
                            display_planetmap(slot,calcosx(awayteam.c.x,1),0)
                            ep_display()
                            display_awayteam()
                            dprint ""
                            no_key=keyin
                            p2=movepoint(awayteam.c,getdirection(no_key))
                            If tmap(p2.x,p2.y).walktru=0 Then awayteam.c=p2
                        Loop Until no_key=key__esc Or Not(skill_test(player.science(location),st_easy))
                        awayteam.c=p1
                    Else
                        dprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),11)) Then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=168 Then
                If askyn("A switched off security robot. Do you want to try and reprogram it and turn it on again?(y/n)") Then
                    If skill_test(player.science(location),st_veryhard,"Repair") Then
                        dprint "You manage!"
                        If get_freecrewslot>-1 Then
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            add_member(13,0)
                        Else
                            dprint "But you don't have enough room on your ship for the robot."
                        EndIf
                    Else
                        If skill_test(player.science(location),st_average) Then
                            'Failure
                            dprint "This robot is beyond repair"
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84

                        Else
                            'Catastrophic Failure
                            dprint "You manage to switch it on but not to reprogram it!",c_red
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(makemonster(9,slot),slot,spawnmask(),lsp,awayteam.c.x,awayteam.c.y)
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=169 Then
                d=0
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        If skill_test(player.science(location),st_hard) Then
                            dprint "You manage to shut down the traps on this level."
                            For x=0 To 60
                                For y=0 To 20
                                    If tmap(x,y).tohit<>0 Then
                                        changetile(x,y,slot,4)
                                    EndIf
                                Next
                            Next
                        Else
                            For x=0 To 60
                                For y=0 To 20
                                    if tmap(x,y).tohit<>0 then
                                        If skill_test(player.science(location),st_veryhard) Then
                                            changetile(x,y,slot,4)
                                            d+=1
                                        EndIf
                                    endif
                                Next
                            Next
                            if d=0 then dprint "You do not manage to shut down any traps on this level."
                            if d=1 then dprint "You manage to shut down a trap on this level."
                            if d>1 then dprint "You manage to shut down "& d &" traps on this level."
                        EndIf
                    Else
                        dprint "You do not get it to work properly."
                        If Not(skill_test(player.science(1),11)) Then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=170 Then
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_hard) Then
                        dprint "You manage to reveal hidden doors on this level."
                        For x=0 To 60
                            For y=0 To 20
                                If tmap(x,y).turnsoninspect=54 Then
                                    planetmap(x,y,slot)=tmap(x,y).turnsoninspect
                                    tmap(x,y)=tiles(tmap(x,y).turnsoninspect)
                                EndIf
                            Next
                        Next
                    Else
                        dprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_easy)) Then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=171 Then
                If askyn("A working security terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_average) Then
                        dprint "You get it to display a map of this complex."
                        For x=0 To 60
                            For y=0 To 20
                                If planetmap(x,y,slot)<0 Then planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                            Next
                        Next
                    Else
                        dprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_easy)) Then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=172 Then
                If askyn("A working computer terminal. Do you want to try to use it?(y/n)") Then
                    If skill_test(player.science(location),st_veryhard) Then
                        dprint "It's a database on the technology of the ancient aliens."
                        If reward(4)>0 Then
                            reward(4)-=1
                            findartifact(0)
                        Else
                            dprint "Unfortunately it does not contain any new information about the technology of the ancient aliens."
                        EndIf
                    Else
                        dprint "You do not get it to work properly."
                        If Not(skill_test(player.science(location),st_hard)) Then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        EndIf
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=111 Then
                dprint "This is a data collection about all the 'enhanced pets' of the ancient aliens. They used the tree beings as scientific advisors, and made a silicium based lifeform they were somehow able to use as a powersource. It doesn't really go into detail about that. Also missing is any information on the aliens themselves."
                player.questflag(1)=1
            EndIf

            b=0
            If tmap(awayteam.c.x,awayteam.c.y).gives=205 Then
                'Just don't land here
            EndIf
            If tmap(awayteam.c.x,awayteam.c.y).gives=206 Then
                If planets(slot).flags(3)>0 Then
                    If askyn("A grade "&planets(slot).flags(3) &" engine. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(3)<player.engine Then
                            dprint "You already have a better engine than this."
                        Elseif planets(slot).flags(3)=player.engine then
                            dprint "You already have the same type of engine."
                        else
                            If planets(slot).flags(3)<=player.h_maxengine Or planets(slot).flags(3)=6 Then
                                player.engine=planets(slot).flags(3)
                                planets(slot).flags(3)=0
                                b=1
                                If player.engine=6 Then artflag(6)=1
                            Else
                                dprint "This engine is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                    
                Else
                    dprint "An empty engine case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=207 Then
                If planets(slot).flags(4)>0 Then
                    If askyn("A grade "&planets(slot).flags(4) &" sensor suite. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(4)<player.sensors Then
                            dprint "You already have a better sensors than this."
                        Elseif planets(slot).flags(4)=player.sensors Then
                            dprint "You already have the same type of sensors."
                        else
                            If planets(slot).flags(4)<=player.h_maxsensors Or planets(slot).flags(4)=6 Then
                                player.sensors=planets(slot).flags(4)
                                planets(slot).flags(4)=0
                                b=1
                                If player.sensors=6 Then artflag(7)=1
                            Else
                                dprint "This sensor array is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                Else
                    dprint "An empty sensor case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=208 Then
                If planets(slot).flags(5)>0 Then
                    If askyn("A grade "&planets(slot).flags(5) &" shield generator. Do you want to transfer it to your ship?(y/n)") Then
                        If planets(slot).flags(5)<player.shieldmax Then
                            dprint "You already have a better shields than this."
                        Elseif planets(slot).flags(5)=player.shieldmax Then
                            dprint "You already have the same type of shields."
                        else
                            If planets(slot).flags(5)<=player.h_maxshield Then
                                player.shieldmax=planets(slot).flags(5)
                                planets(slot).flags(5)=0
                                b=1
                            Else
                                dprint "This shield generator is too big for your ship"
                            EndIf
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                Else
                    dprint "An empty shield generator case."
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=210 Then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-209
                dprint c & " " & planets(slot).flags(c)
                If planets(slot).flags(c+6)=0 Then
                    dprint "An empty weapons turret."
                Else
                    If askyn(add_a_or_an((planets(slot).weapon(c)).desig,1) &". Do you want to transfer it to your ship?(y/n)") Then
                        d=player.h_maxweaponslot
                        text="Weapon Slot/"
                        For a=1 To d
                            If player.weapons(a).desig="" Then
                                text=text & "-Empty-/"
                            Else
                                text=text & player.weapons(a).desig & "/"
                            EndIf
                        Next
                        text=text+"Exit"
                        d=d+1
                        e=Menu(bg_awayteam,text)
                        If e<d Then
                            player.weapons(e)=(planets(slot).weapon(c))
                            b=1
                            planets(slot).flags(c)=0
                            recalcshipsbays
                        EndIf
                    Else
                        b=scrap_component
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=211 Then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203'Flags 12 to 16
                If planets(slot).flags(c)>1 Then
                    If planets(slot).flags(c)=2 Then text="Food"
                    If planets(slot).flags(c)=3 Then text="Basic goods"
                    If planets(slot).flags(c)=4 Then text="Tech goods"
                    If planets(slot).flags(c)=5 Then text="Luxury goods"
                    If planets(slot).flags(c)=6 Then text="Weapons"
                    If askyn("A cargo crate with "& text &". Do you want to transfer it to your ship?(y/n)") Then
                        For a=1 To 10
                            If player.cargo(a).x=1 And b=0 Then
                                b=1
                                player.cargo(a).x=planets(slot).flags(c)
                                planets(slot).flags(c)=0
                            EndIf
                            If b=0 Then dprint "Your cargo hold is full."
                        Next
                    EndIf
                Else
                    dprint "An empty cargo crate"
                EndIf
                If planets(slot).flags(26)=8 Then b=0 'Small spacestation abandoned cargo
            EndIf

            If b>0 Then
                For a=0 To lastenemy
                    If enemy(a).hp>0 Then
                        enemy(a).aggr=0
                    EndIf
                Next
                If planets(slot).atmos>1 Then dprint "You hear alarm sirens!",14
                If planets(slot).atmos=1 Then dprint "You see a red alert light flashing!",14
            EndIf

            For a=1 To lastdrifting
                If slot=drifting(a).m Then c=drifting(a).s
            Next

            If tmap(awayteam.c.x,awayteam.c.y).gives=221 Then
                If askyn("These seem to be the controls of this ship. Do you want to try to use them?(y/n)") Then
                    If skill_test(player.science(1),st_veryhard) Then
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(220)
                        planetmap(awayteam.c.x,awayteam.c.y,slot)=220
                    Else
                        dprint "It looks like it started some sort of countdown"
                        tmap(awayteam.c.x,awayteam.c.y).gives=0
                        planets(slot).death=5
                    EndIf
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=220 Then
                textbox(shiptypes(planets(slot).flags(1)) &" | | " &makehullbox(planets(slot).flags(1),"data/ships.csv"),3,5,25)
                If askyn("The bridge. Do you want to abandon your ship and take over this one?(y/n)") Then
                    b=0
                    For a=0 To lastenemy
                        If enemy(a).hp>0 Then
                            enemy(a).aggr=1
                            if abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))<>200 then b=b+1'Only count inside ship
                        EndIf
                    Next
                    If b=0 Then
                        If upgradehull(planets(slot).flags(1),player)=-1 Then
                            player.hull=planets(slot).flags(2)
                            planets(slot).flags(0)=1
                            nextmap.m=-1
                            If player.hull<1 Then player.hull=1
                            dprint "You take over the ship."
                            Key=key_north
                            walking=1
                            'Weapons...
                            poolandtransferweapons(player,planetflags_toship(slot))

                            If planets(slot).flags(3)>player.engine Then player.engine=planets(slot).flags(3)
                            If planets(slot).flags(4)>player.sensors Then player.sensors=planets(slot).flags(4)
                            If planets(slot).flags(5)>player.shieldmax Then player.shieldmax=planets(slot).flags(5)
                            recalcshipsbays
                            If player.landed.m<>slot Then
                                For c=0 To lastportal
                                    If portal(c).from.m=slot Or portal(c).dest.m=slot Then
                                        player.landed=portal(c).from
                                        nextmap=portal(c).from
                                        deleteportal(portal(c).from.m,portal(c).dest.m)
                                        deleteportal(portal(c).dest.m,portal(c).from.m)
                                    EndIf
                                Next
                            EndIf
                        EndIf
                    Else
                        dprint "You better make sure this ship is really abandoned before moving in.",14
                    EndIf
                EndIf
            EndIf

            '
            ' Alien Civs
            '
            If tmap(awayteam.c.x,awayteam.c.y).gives=301 Then
                trading(11)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,6,-5)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=302 Then
                trading(12)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,7,-5)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=311 Then
                If civ(0).phil=1 Then dprint "This is the house where the "&civ(0).n & "council meets."
                If civ(0).phil=2 Then dprint "This is the "&civ(0).n &" parliament"
                If civ(0).phil=3 Then dprint "This is the "&civ(0).n &" leaders home"
                foreignpolicy(0,0)
                ask_alliance(6)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=312 Then
                If civ(1).phil=1 Then dprint "This is the house where the "&civ(1).n & "council meets."
                If civ(1).phil=2 Then dprint "This is the "&civ(1).n &" parliament"
                If civ(1).phil=3 Then dprint "This is the "&civ(1).n &" leaders home"
                foreignpolicy(1,0)
                ask_alliance(7)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=321 Then
                dprint add_a_or_an(civ(0).n,1) &" shop"
                If faction(0).war(6)<50 Then
                    shop(get_shop_index(sh_aliens1,awayteam.c,-1),1,civ(0).n &" shop")
                Else
                    dprint "They don't want to trade with you"
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=322 Then
                dprint add_a_or_an(civ(1).n,1) &" shop"
                If faction(0).war(7)<50 Then
                    shop(get_shop_index(sh_aliens2,awayteam.c,-1),1,civ(1).n &" shop")
                Else
                    dprint "They don't want to trade with you"
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=330 Then
                buysitems("They are very interested in buying living creatures for the Zoo."," Do you want to sell?(y/n)",26,8,0)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=401 Then
                dprint "Population:"&planets(slot).colonystats(0) &" Food:"&planets(slot).colonystats(10)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=886 Then
                If askyn("Do you want to install the cryo chamber on your ship?(y/n)") Then
                    player.cryo=player.cryo+1
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=202
                Else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=tmap(awayteam.c.x,awayteam.c.y).no
                EndIf
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=887 Then
                dprint "With the forcefield down it is easy to remove the disintegrator canon"
                artifact(4)
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=888 Then
                dprint "This computer controls the planetary defense system."
                no_key=keyin
                dprint "Your science officer manages to disable it!"
                no_key=keyin
                specialflag(2)=2
            EndIf

            If tmap(awayteam.c.x,awayteam.c.y).gives=999 Then
                dprint "This terminal displays information on the status of this sector. The computer is obviously interpreting the human presence as an invasion!"
                no_key=keyin
                dprint "The spaceships are being made ready to repell the invaders!"
                no_key=keyin
                dprint "Your science officer tries to reprogram the computer"
                no_key=keyin
                dprint "He succeeds! you can now use the robot ships to explore this sector and beyond without risking human life!"
                player.questflag(3)=1
                no_key=keyin
            EndIf

        If tmap(awayteam.c.x,awayteam.c.y).survivors>rnd_range(1,44) Then
            dprint "you have found a crashed spaceship!"
            no_key=keyin
            dprint "there are survivors! You offer to take them to the space station."
            b=rnd_range(1,6) +rnd_range(1,6)-3
            no_key=keyin
            If b>0 Then
                If askyn( b &" security personel want to join your crew. (y/n)") Then
                    If b>max_security Then b=max_security
                    For a=1 To b
                        add_member(8,0)
                    Next
                EndIf
            EndIf
            b=rnd_range(5,7)
            If b>6 Then b=6
            c=rnd_range(1,100)
            If c<33 Then
                If askyn("a pilot, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(2,b)
                EndIf
            EndIf
            If c>32 And c<66 Then
                If askyn("a gunner, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(3,b)
                EndIf
            EndIf
            If c>65 Then
                If askyn("a science officer, skillevel " & b & " wants to join you. (y/n)") Then
                    add_member(4,b)
                EndIf
            EndIf
            planetmap(awayteam.c.x,awayteam.c.y,slot)=62
        EndIf

    If tmap(awayteam.c.x,awayteam.c.y).resources>rnd_range(1,100) Then
        dprint "you plunder the resources of the ship and move on."
        For a=0 To 2
            reward(a)=reward(a)+rnd_range(10,50)+rnd_range(10,50)+500
        Next
        planetmap(awayteam.c.x,awayteam.c.y,slot)=62
    EndIf

    If planetmap(awayteam.c.x,awayteam.c.y,slot)=17 Then
        walking=0
        If skill_test(player.science(location),st_hard) Then
            dprint "you find an ancient computer, your Science officer manages to get map data out of it!"
            reward(5)=3
        Else
            dprint "you find an ancient computer, but you cant get it to work"
        EndIf
        planetmap(awayteam.c.x,awayteam.c.y,slot)=16
    EndIf

    tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).turnsinto)
    planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).no
    Return 0
End Function
