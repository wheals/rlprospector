function ep_areaeffects(areaeffect() as _ae,byref last_ae as short,lavapoint() as _cords,enemy() as _monster, lastenemy as short, li() as short, byref lastlocalitem as short,cloudmap() as byte) as short
    dim as short a,b,c,x,y,slot
    dim as _cords p1
    slot=player.map
    if rnd_range(1,100)<planets(slot).grav+planets(slot).depth+planets(slot).temp\100 and planets(slot).grav>1 then
        'Earthquake
        last_ae=last_ae+1
        if last_ae>16 then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,planets(slot).grav*3)*rnd_range(1,planets(slot).grav)
        areaeffect(last_ae).dam=areaeffect(last_ae).rad
        if areaeffect(last_ae).rad>5 then areaeffect(last_ae).rad=5
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
        areaeffect(last_ae).typ=1
    endif
    
    if rnd_range(1,100)<planets(slot).atmos/5+(planets(slot).water/10)+planets(slot).weat and planets(slot).atmos>3 and planets(slot).temp<0 and planets(slot).depth=0 then
        'snow
        last_ae=last_ae+1
        if last_ae>16 then last_ae=0
        areaeffect(last_ae).c=rnd_point
        areaeffect(last_ae).rad=rnd_range(1,4)*rnd_range(1,planets(slot).atmos)
        areaeffect(last_ae).dam=0 
        areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
        if areaeffect(last_ae).rad>5 then
           areaeffect(last_ae).dur=areaeffect(last_ae).dur+areaeffect(last_ae).rad-5
           areaeffect(last_ae).rad=5
        endif
        areaeffect(last_ae).typ=2
    endif
    
    
    for a=0 to last_ae
        if areaeffect(a).typ=1 and areaeffect(a).dur>0 then
            areaeffect(a).dur=areaeffect(a).dur-1
            if areaeffect(a).typ=1 and areaeffect(a).dur=0 then dprint "The ground rumbles",14'eartquake
            if areaeffect(a).typ=1 and areaeffect(a).dur=0 and findbest(16,-1)>0 and skill_test(player.science(1),st_average) then dprint "Originating at "&cords(areaeffect(a).c) &".",14
            for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
                for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                    p1.x=x
                    p1.y=y
                        if distance(p1,areaeffect(a).c)<areaeffect(a).rad then
                            if show_eq=1 then
                                locate p1.y+1,p1.x+1
                                print "."
                            endif
                            'Inside radius, inside map
                            if areaeffect(a).typ=1 then 'eartquake
                                if areaeffect(a).dur>0 then
                                    if x=awayteam.c.x and y=awayteam.c.y and skill_test(player.science(1),9) then
                                        dprint "A tremor",14
                                        if findbest(16,-1)>0 and skill_test(player.science(1),st_average) then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14
                                    endif
                                else
                                    areaeffect(a).dam=areaeffect(a).dam-distance(p1,areaeffect(a).c)
                                    if areaeffect(a).dam=0 then areaeffect(a).dam=0
                                    tmap(x,y)=earthquake(tmap(x,y),areaeffect(a).dam-distance(p1,areaeffect(a).c))                                                
                                    if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).no
                                    if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).no
                                    if rnd_range(1,100)<15-distance(p1,areaeffect(a).c) then lavapoint(rnd_range(1,5))=p1
                                    if rnd_range(1,100)<3 then 
                                        lastlocalitem=lastlocalitem+1
                                        lastitem=lastitem+1
                                        li(lastlocalitem)=lastitem
                                        item(lastitem)=makeitem(96,-3,-3)
                                        item(lastitem).w.x=x
                                        item(lastitem).w.y=y
                                        item(lastitem).w.m=slot
                                    endif
                                            
                                    for b=1 to lastenemy
                                        if enemy(b).c.x=x and enemy(b).c.y=y then enemy(b).hp=enemy(b).hp-areaeffect(a).dam+distance(p1,areaeffect(a).c)
                                    next
                                    if x=awayteam.c.x and y=awayteam.c.y and areaeffect(a).dam>distance(p1,areaeffect(a).c) then 
                                        dprint "An Earthquake! "& damawayteam(rnd_range(1,areaeffect(a).dam-distance(p1,areaeffect(a).c))),12
                                        player.killedby="Earthquake"
                                    endif
                                    areaeffect(a).dam=areaeffect(a).rad
                                endif
                                    
                            endif    
                        endif
                    endif
                next
            next
        endif
        if areaeffect(a).typ=2 and areaeffect(a).dur>0 then
            areaeffect(a).dur=areaeffect(a).dur-1
            for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
               for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                   if x>=0 and y>=0 and x<=60 and y<=20 then
                        p1.x=x
                        p1.y=y
                        if distance(p1,areaeffect(a).c)<= areaeffect(a).rad then
                            if show_eq=1 then
                                locate p1.y+1,p1.x+1
                                set__color( 15,0)
                                print "."
                            endif
                            if tmap(x,y).no=1 or tmap(x,y).no=2 then tmap(x,y).hp=tmap(x,y).hp+10
                            if tmap(x,y).no<>7 and tmap(x,y).no<>8 and tmap(x,y).no>2 and tmap(x,y).no<15 and rnd_range(1,100)<8+planets(slot).atmos then
                                tmap(x,y)=tiles(145)
                                changetile(x,y,slot,145)
                            endif
                            If awayteam.c.x=x and awayteam.c.y=y then dprint "It is snowing."
                        endif
                   endif
               next
            next
        endif
        if areaeffect(a).typ=3 or areaeffect(a).typ=4 or areaeffect(a).typ=5 then
            areaeffect(a).dur=areaeffect(a).dur-1
            for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
               for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                   if x>=0 and y>=0 and x<=60 and y<=20 then
                        p1.x=x
                        p1.y=y
                        if distance(p1,areaeffect(a).c)<= areaeffect(a).rad then
                            if areaeffect(a).dur=0 then 
                                tmap(x,y)=tiles(0)
                                tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
                            else
                                tmap(x,y).ti_no=385
                                tmap(x,y).tile=asc("~")
                                tmap(x,y).seetru=1
                                tmap(x,y).desc="steam"
                                if planets(slot).atmos>1 then cloudmap(x,y)+=1
                                if areaeffect(a).typ=3 then tmap(x,y).col=15
                                if areaeffect(a).typ=4 then 
                                    tmap(x,y).col=104
                                    tmap(x,y).tohit=34
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Acidic steam!"
                                endif
                                if areaeffect(a).typ=4 then 
                                    tmap(x,y).col=179
                                    tmap(x,y).tohit=27
                                    tmap(x,y).dam=1
                                    tmap(x,y).hitt="Ammonium steam!"
                                endif
                                if areaeffect(a).typ=5 then 
                                    tmap(x,y).col=219
                                    tmap(x,y).desc="smoke"
                                endif
                            endif
                        endif
                    endif
                next
            next
        endif 
    next
    return 0
end function

function ep_atship() as short
    dim as short slot,a
    slot=player.map
    if awayteam.c.y=player.landed.y and awayteam.c.x=player.landed.x and slot=player.landed.m then 
        location=lc_onship
        dprint "You are at the ship. Press "&key_la &" to launch."
        if awayteam.oxygen<awayteam.oxymax then dprint "Refilling oxygen.",10
        awayteam.oxygen=awayteam.oxymax
        if (awayteam.move=2 or awayteam.move=3) and awayteam.jpfuel<awayteam.jpfuelmax then 
            dprint "Refilling Jetpacks",10
            awayteam.jpfuel=awayteam.jpfuelmax
        endif
        for a=1 to 128
            if crew(a).hp>0 then
                if crew(a).disease>0 and crew(a).onship=0 then
                    crew(a).oldonship=crew(a).onship
                    crew(a).onship=1
                    dprint crew(a).n &" is sick and stays at the ship."
                endif
                if crew(a).disease=0 and crew(a).onship=0 then
                    crew(a).onship=crew(a).oldonship
                    crew(a).oldonship=0
                endif
            endif
        next
        alerts()
        return 0
    else 
        location=lc_awayteam
        'dprint ""&ep_Needs_spacesuit(slot,awayteam.c)
        if ep_Needs_spacesuit(slot,awayteam.c)>0 then
            dam_no_spacesuit(rnd_range(1,ep_needs_spacesuit(slot,awayteam.c)))
        endif
        return 0
    endif
end function

function ep_autoexplore(slot as short, li() as short,lastlocalitem as short) as short
    dim as short x,y,astarmap(60,20),candidate(60,20),explored,notargets,x1,y1,i
    dim vismask(60,20) as byte
    dim d as single
    dim as _cords p,target,astarpath(1281)
    dim as byte debug=0
    for x=0 to 1024
        apwaypoints(x).x=0
        apwaypoints(x).y=0
    next
    
    lastapwp=ep_autoexploreroute(astarpath(),awayteam.c,awayteam.move,slot,li(),lastlocalitem)
    if lastapwp>0 then
        for i=1 to lastapwp
            apwaypoints(i).x=astarpath(i).x
            apwaypoints(i).y=astarpath(i).y
        next
    endif
    return lastapwp
end function

function ep_autoexploreroute(astarpath() as _cords,start as _cords,move as short, slot as short,li() as short,lastlocalitem as short) as short
    dim as short candidate(60,20)
    dim as short x,y,explored,notargets,last,i,debug,rollover
    dim as single d2,d
    dim as _cords target,target2,p,path(1281)
    for x=0 to 60
        for y=0 to 20
            if move<tmap(x,y).walktru then candidate(x,y)=1
            if tmap(x,y).onopen<>0 then candidate(x,y)=0 
        next
    next
    flood_fill(start.x,start.y,candidate(),3)
    if planets(slot).depth>0 then
        rollover=0
    else
        rollover=1
    endif
    d2=61*21
    for i=1 to lastlocalitem
        if item(li(i)).discovered>0 and candidate(item(li(i)).w.x,item(li(i)).w.y)=255 then
            if item(li(i)).w.s=0 and item(li(i)).w.p=0 then
                p.x=item(li(i)).w.x
                p.y=item(li(i)).w.y
                if distance(p,start,rollover)<d2 then
                    d2=distance(p,start)
                    notargets+=1
                    target2.x=item(li(i)).w.x
                    target2.y=item(li(i)).w.y
                endif
            endif
        endif
    next
    
    d=61*21
    for x=0 to 60
        for y=0 to 20
            if x<>start.x or y<>start.y then
                 if candidate(x,y)=255 then
                 explored=0
                 if planetmap(x,y,slot)<0 then explored=1

                 if explored=1 then
                    p.x=x
                    p.y=y
                    if distance(p,start,rollover)<d then
                        target.x=p.x
                        target.y=p.y
                        d=distance(p,start,rollover)
                        notargets+=1
                    endif
                endif
                endif
            endif
        next
    next

    if notargets=0 then 
        target.x=player.landed.x
        target.y=player.landed.y
    else
        if debug=1 and _debug=1 then dprint d &":"& target.x &":"&target.y &"-"&d2 &":"& target2.x &":"&target2.y
        if d2<d then
            target.x=target2.x
            target.y=target2.y
        endif
    endif
    if target.x=start.x and target.y=start.y then return -1
    last=ep_planetroute(path(),move,start,target,rollover)
    if last=-1 then return -1
    for i=0 to last
        astarpath(i+1).x=path(i).x
        astarpath(i+1).y=path(i).y
    next
    last+=1
    return last
end function

function ep_planetroute(route() as _cords,move as short,start as _cords, target as _cords,rollover as short) as short
    dim as short x,y,astarmap(60,20)
    for x=0 to 60
        for y=0 to 20
            astarmap(x,y)=tmap(x,y).walktru+tmap(x,y).gives+tmap(x,y).dam
            if move<tmap(x,y).walktru then astarmap(x,y)=1500
            if tmap(x,y).onopen<>0 then astarmap(x,y)=0 
            if tmap(x,y).no=45 then astarmap(x,y)=1500
        next
    next
    return a_star(route(),target,start,astarmap(),60,20,0,rollover)
end function 

function ep_checkmove(byref old as _cords,key as string) as short
    dim as short slot,a,b,c,who(128)
    slot=player.map
    if planetmap(awayteam.c.x,awayteam.c.y,slot)=18 then
        dprint "you get zapped by a forcefield:"&damawayteam(rnd_range(1,6)),12
        if awayteam.armor/awayteam.hp<13 then awayteam.c=old
        walking=0
    endif
    if tmap(awayteam.c.x,awayteam.c.y).locked>0 then
        b=findbest(12,-1) 'Find best key
        if b>0 then
            c=item(b).v1
        else
            c=0
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).no=45 and tmap(old.x,old.y).no<>45 and configflag(con_warnings)=0 then
        if not(askyn("do you really want to walk into hot lava?(y/n)")) then awayteam.c=old
    endif
    
    if vacuum(awayteam.c.x,awayteam.c.y)=1 and vacuum(old.x,old.y)=0 and configflag(con_warnings)=0 then
        if no_spacesuit(who())>0 then
            if not(askyn("do you really want to walk out into the vacuum?(y/n)")) then awayteam.c=old
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).onopen>0 then
        planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).onopen
        tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).locked>0 then
        if not(skill_test(player.science(1)+c,7+tmap(awayteam.c.x,awayteam.c.y).locked,"Science")) then' or (tmap(awayteam.c.x,awayteam.c.y).onopen>0 and tmap(awayteam.c.x,awayteam.c.y).locked=0) then
        dprint "Your science officer can't bypass the doorlocks"
        awayteam.c=old
        walking=0
        endif
    else
        tmap(awayteam.c.x,awayteam.c.y).locked=0
        if tmap(awayteam.c.x,awayteam.c.y).onopen>0 then tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
        if tmap(awayteam.c.x,awayteam.c.y).no=16 then planetmap(awayteam.c.x,awayteam.c.y,slot)=144
        if tmap(awayteam.c.x,awayteam.c.y).no=93 then planetmap(awayteam.c.x,awayteam.c.y,slot)=90
        if tmap(awayteam.c.x,awayteam.c.y).no=94 then planetmap(awayteam.c.x,awayteam.c.y,slot)=91
        if tmap(awayteam.c.x,awayteam.c.y).no=95 then planetmap(awayteam.c.x,awayteam.c.y,slot)=92
    endif
    
    if planetmap(awayteam.c.x,awayteam.c.y,slot)=54 then
        if c>0 then 
            item(b)=item(lastitem)
            lastitem=lastitem-1
        endif
        if skill_test(player.science(location)+c,st_average) then
            if skill_test(player.science(location)+c,st_average,"Science") then
                dprint "You managed to open the door"
                planetmap(awayteam.c.x,awayteam.c.y,slot)=55
                tmap(awayteam.c.x,awayteam.c.y)=tiles(55)
            else
                dprint "Your science officer cant open the door"
                if rnd_range(1,6)+ rnd_range(1,6)>6 then
                    dprint "But he sets off an ancient defense mechanism! "&damawayteam(rnd_range(1,6))
                    player.killedby="trapped door"
                endif
                walking=0
                awayteam.c=old
            endif
        else
            dprint "Your fiddling with the ancient lock destroys it. You will never be able to open that door."
            planetmap(awayteam.c.x,awayteam.c.y,slot)=53
            walking=0
            awayteam.c=old
        endif
    endif
    
    
    if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru and configflag(con_diagonals)=0 then 
        awayteam.c=movepoint(old,bestaltdir(getdirection(key),0),3)
        if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru then awayteam.c=movepoint(old,bestaltdir(getdirection(key),1))
    endif
    if tmap(awayteam.c.x,awayteam.c.y).walktru>awayteam.move then '1= can swim 2= can fly 3=can swim and fly 4= can teleport
        awayteam.c=old
    else
        'Terrain needs flying or swimmint
        if tmap(awayteam.c.x,awayteam.c.y).walktru=1 then
            if awayteam.move=2 then
                if awayteam.hp<=awayteam.nojp then
                    if awayteam.jpfuel>=awayteam.jpfueluse then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.lastaction+=awayteam.carried
                    else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    endif
                else
                    awayteam.c=old
                    dprint "blocked"
                endif
            endif
        endif
        'Terrain needs flying
        if tmap(awayteam.c.x,awayteam.c.y).walktru=2 then
            if awayteam.move<4 then
                if awayteam.hp<=awayteam.nojp then
                    if awayteam.jpfuel>=awayteam.jpfueluse then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                        awayteam.lastaction+=awayteam.carried/5
                    else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    endif
                else
                    awayteam.c=old
                    dprint "blocked"
                endif
            endif
        endif
        if tmap(awayteam.c.x,awayteam.c.y).walktru=4 then 
            if not(askyn("Do you really want to step over the edge?(y/n)")) then awayteam.c=old
        endif
    endif
    if old.x=awayteam.c.x and old.y=awayteam.c.y then
        if walking>0 and walking<10 then walking=0
    else
        awayteam.lastaction+=1
    endif
    return 0
end function

function ep_communicateoffer(key as string, enemy() as _monster,lastenemy as short, li() as short,byref lastlocalitem as short) as short
    dim as short a,b,slot,x,y,cm,monster
    dim as _cords p2
    dim as string dkey
    slot=player.map
    b=0
    for x=awayteam.c.x-1 to awayteam.c.x+1
        for y=awayteam.c.y-1 to awayteam.c.y+1
            for a=1 to lastenemy
                if enemy(a).c.x=x and enemy(a).c.y=y and enemy(a).hp>0 then
                    cm+=1
                    monster=a
                endif
            next
            
        next
    next
    if cm=1 then
        p2.x=enemy(monster).c.x
        p2.y=enemy(monster).c.y
    else
        dprint "direction?"
        do
            dkey=keyin
        loop until getdirection(dkey)>0 or dkey=key__esc
        p2=movepoint(awayteam.c,getdirection(dkey))
    endif
    locate p2.y+1,p2.x+1
    if key=key_co and planetmap(p2.x,p2.y,slot)=190 then 
        dprint "You hear a voice in your head: 'SUBJUGATE OF BE ANNIHILATED'"
        b=-1
    endif
    if key=key_co and planetmap(p2.x,p2.y,slot)=191 then dodialog(1,enemy(lastenemy+1),0)
    for a=1 to lastenemy
        if p2.x=enemy(a).c.x and p2.y=enemy(a).c.y and enemy(a).hp>0 and enemy(a).sleeping<=0 then b=a
    next
    if b=0 then
        if key=key_co then dprint "Nobody there to communicate"
        if key=key_of then dprint "Nobody there to give something to"
    endif
    if b>0 then awayteam.lastaction+=1
    if b>0 and key=key_co then communicate(enemy(b),slot,li(),lastlocalitem,b)
    if b>0 and key=key_of then giveitem(enemy(b),b,li(),lastlocalitem)
    return 0
end function

function ep_display_clouds(cloudmap() as byte,vismask() as byte) as short
    dim as short x,y,slot,osx,debug,i
    
    dim p as _cords
    debug=1
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    
    for x=0 to _mwx 
        for y=0 to 20
            if debug=1 and _debug=1 then
                color cloudmap(x,y)
                pset (x,y)
            endif
            p.x=x+osx
            p.y=y
            if p.x>60 then p.x=p.x-61
            if p.x<0 then p.x=p.x+61
            if vismask(p.x,p.y)>0 and cloudmap(p.x,p.y)>0 then 
                if configflag(con_tiles)=0 then
                    for i=1 to cloudmap(p.x,p.y)/2
                        put ((x*_tix)+rnd_range(1,_tix/2)-rnd_range(1,_tix/2),(y*_tiy)+rnd_range(1,_tiy/2)-rnd_range(1,_tiy/2)),gtiles(gt_no(403)),trans
                    next
                else
                    set__color( 15,0)
                    draw string(x*_fw1,y*_fh1),"~",,Font1,custom,@_col
                endif
            endif
        next
    next
    return 0
end function

            

function ep_display(vismask()as byte, enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short,osx as short=555) as short
    dim as short a,b,x,y,slot,fg,bg,debug,alp
    dim as byte comitem,comdead,comalive,comportal 
    dim as _cords p,p1,p2
    slot=player.map
    if osx=555 then osx=calcosx(awayteam.c.x,planets(slot).depth)
    if _debug=1 then dprint awayteam.c.x &":"& awayteam.c.y
    if disease(awayteam.disease).bli>0 then 
        x=awayteam.c.x
        y=awayteam.c.y
        vismask(x,y)=1
        dtile(x,y,tmap(x,y),vismask(x,y))
        return 0
    endif
    ' Stuff on ground    
    make_vismask(vismask(),awayteam.c,awayteam.sight,slot)        
    
            
    for a=1 to lastlocalitem
        if item(li(a)).ty=7 and item(li(a)).v2=1 then 'flash grenade
            item(li(a)).v1-=1
            p2=item(li(a)).w
            
            if item(li(a)).v3>0 then
                if vismask(p2.x,p2.y)>0 then
                    for x=item(li(a)).w.x-8 to item(li(a)).w.x+8
                        for y=item(li(a)).w.y-8 to item(li(a)).w.y+8 
                            p1.x=x
                            p1.y=y
                            if x>=0 and x<=60 and y>=0 and y<=20 then
                                if distance(p1,p2)<=item(li(a)).v3/10 and tmap(x,y).seetru=0 then
                                    if x>=0 and y>=0 and x<=60 and y<=20 then vismask(x,y)=1
                                endif
                            endif
                        next
                    next
                endif
            else
                'Burnt out, destroy
                destroyitem(li(a))
                item(li(a))=item(li(lastlocalitem))
                lastlocalitem-=1
            endif
        endif
    next
           
    for x=0 to _mwx 
        for y=0 to 20
            p.x=x+osx
            p.y=y
            if p.x>60 then p.x=p.x-61
            if p.x<0 then p.x=p.x+61
            
            'if awayteam.sight>cint(distance(awayteam.c,p)) then
            if vismask(p.x,y)>0 then 
                if planetmap(p.x,y,slot)<0 then 
                    planetmap(p.x,y,slot)=planetmap(p.x,y,slot)*-1
                    reward(0)=reward(0)+1
                    reward(7)=reward(7)+planets(slot).mapmod
                    if tiles(planetmap(p.x,y,slot)).stopwalking>0 and walking<11 then walking=0
                    if player.questflag(9)=1 and planetmap(p.x,y,slot)=100 then player.questflag(9)=2
                endif
                if rnd_range(1,100)<disease(awayteam.disease).hal then
                    dtile(x,y,tiles(rnd_range(1,255)),1)
                    planetmap(x,y,slot)=planetmap(x+osx,y,slot)*-1 
                else
                    dtile(x,y,tmap(p.x,y),vismask(p.x,y))
                endif
            endif
        
        next
    next
    
    for a=0 to lastportal
        if portal(a).from.m=slot and portal(a).oneway<2 then
            p.x=portal(a).from.x
            p.y=portal(a).from.y
            if awayteam.c.x=p.x and awayteam.c.y=p.y and comportal=0 then 
                comstr=comstr &key_portal &" Enter"
                comportal=1
            endif
            if debug=1 and _debug=1 then dprint p.x &":"&p.y
            if vis_test(awayteam.c,p,planets(slot).depth)=-1 then
                    if (vismask(portal(a).from.x,portal(a).from.y)>0) or portal(a).discovered=1 then
                        if portal(a).discovered=0 then walking=0
                        portal(a).discovered=1
                        if configflag(con_tiles)=0 then
                            x=portal(a).from.x-osx
                            if x<0 then x+=61
                            if x>60 then x-=61
                            put (x*_tix,portal(a).from.y*_tiy),gtiles(gt_no(portal(a).ti_no)),trans
                        else
                            set__color( portal(a).col,0)
                            draw string(portal(a).from.x*_fw1,portal(a).from.y*_fh1),chr(portal(a).tile),,Font1,custom,@_col
                        endif
                endif
            endif
        endif
        if portal(a).oneway=0 then
            if portal(a).dest.m=slot then
                p.x=portal(a).dest.x
                p.y=portal(a).dest.y
                if awayteam.c.x=p.x and awayteam.c.y=p.y and comportal=0 then 
                    comstr=comstr &key_portal &" Enter"
                    comportal=1
                endif
                if vis_test(awayteam.c,p,planets(slot).depth)=-1 then
                    if (vismask(portal(a).dest.x,portal(a).dest.y)>0) or portal(a).discovered=1 then
                            if portal(a).discovered=0 then walking=0
                            portal(a).discovered=1   
                            if configflag(con_tiles)=0 then
                                if vismask(p.x,p.y)=0 then 
                                    alp=197
                                else
                                    alp=255
                                endif
                                x=portal(a).dest.x-osx
                                if x<0 then x+=61
                                if x>60 then x-=61
                                put (x*_tix,portal(a).dest.y*_tiy),gtiles(gt_no(portal(a).ti_no)),alpha,alp
                            else
                                set__color( portal(a).col,0)
                                draw string(portal(a).dest.x*_fw1,portal(a).dest.y*_fh1),chr(portal(a).tile),,Font1,custom,@_col
                            endif
                        endif  
                    endif
                endif
        endif
    next
    
    for a=1 to lastlocalitem
        if item(li(a)).w.m=slot and item(li(a)).w.s=0 and item(li(a)).w.p=0 then
            p.x=item(li(a)).w.x
            p.y=item(li(a)).w.y
                if awayteam.c.x=p.x and awayteam.c.y=p.y and comitem=0 then 
                    comstr=comstr &key_pickup &" Pick up;"
                    comitem=1
                endif
            
                if  (tiles(abs(planetmap(p.x,p.y,slot))).hides=0  or item(li(a)).discovered=1) and ((vismask(item(li(a)).w.x,item(li(a)).w.y)>0)) then
                    if item(li(a)).discovered=0 and walking<11 then walking=0
                    item(li(a)).discovered=1
                    if tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).walktru>0 and item(li(a)).bgcol=0 then
                        bg=tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).col
                    else
                        if item(li(a)).bgcol>=0 then bg=item(li(a)).bgcol
                    endif
                    if item(li(a)).col>0 then
                        fg=item(li(a)).col
                    else
                        fg=rnd_range(abs(item(li(a)).col),abs(item(li(a)).bgcol))
                    endif
                    set__color( fg,bg)
                    if configflag(con_tiles)=0 then
                        p.x=item(li(a)).w.x
                        p.y=item(li(a)).w.y
                        if vismask(p.x,p.y)=0 then 
                            alp=197
                        else
                            alp=255
                        endif
                        x=item(li(a)).w.x-osx
                        if x<0 then x+=61
                        if x>60 then x-=61
                        put (x*_tix,item(li(a)).w.y*_tiy),gtiles(gt_no(item(li(a)).ti_no)),alpha,alp
                        if _debug=1 then draw string(x*_tix,item(li(a)).w.y*_tiy),item(li(a)).w.p &":"&item(li(a)).w.m,,font1,custom,@_tcol'REMOVE
                    else
                        if configflag(con_transitem)=1 then
                            draw string(p.x*_fw1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_col
                        else
                            if item(li(a)).bgcol<=0 then
                                set__color( 241,0)
                                draw string(p.x*_fw1-1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_tcol
                                draw string(p.x*_fw1+1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_tcol
                                draw string(p.x*_fw1,P.y*_fh1+1), item(li(a)).icon,,font1,custom,@_tcol
                                draw string(p.x*_fw1,P.y*_fh1-1), item(li(a)).icon,,font1,custom,@_tcol
                                set__color( fg,bg)
                                draw string(p.x*_fw1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_tcol
                            else
                                draw string(p.x*_fw1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_col
                            endif
                        endif
                    endif
                 endif
             
        endif
    next
    
    for a=1 to lastenemy
        if enemy(a).hp<=0 then
            p.x=enemy(a).c.x
            p.y=enemy(a).c.y
            if awayteam.c.x=p.x and awayteam.c.y=p.y and comdead=0 then 
                comstr=comstr &key_inspect &" Inspect;"
                comdead=1 'only add it once
            endif
            if  p.y>=0 and p.y<=20 then 'vis_test(awayteam.c,p,planets(slot).depth)=-1 and
                if vismask(p.x,p.y)>0 then
                    set__color( 12,0)
                    if configflag(con_tiles)=0 then
                        if enemy(a).hpmax>0 then put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(1093)),trans
                    else
                        if enemy(a).hpmax>0 then draw string(p.x*_fw1,P.y*_fh1), "%",,font1,custom,@_col
                    endif
                endif
            endif
        endif
    next
    
    for a=1 to lastenemy
        if enemy(a).ti_no=-1 then enemy(a).ti_no=rnd_range(0,8)+1500 'Assign sprite range
        if enemy(a).hp>0 then
            p=enemy(a).c
            if comalive=0 and awayteam.c.x>=p.x-1 and awayteam.c.x<=p.x+1 and awayteam.c.y>=p.y-1 and awayteam.c.y<=p.y+1 then 
                comstr=comstr & key_co &" Chat, " & key_of &" Offer;"
                comalive=1
            endif
            if p.x-osx>=0 and p.x-osx<=_mwx and p.y>=0 and p.y<=20 then                
                if (vismask(p.x,p.y)>0) or player.stuff(3)=2 then
                    if enemy(a).cmshow=1 then
                        enemy(a).cmshow=0    
                        set__color( enemy(a).col,179)
                    else
                        set__color( enemy(a).col,0)
                    endif
                    if enemy(a).invis=0 or (enemy(a).invis=3 and distance(enemy(a).c,awayteam.c)<2) then
                        if configflag(con_tiles)=0 then
                            put ((p.x-osx)*_tix,p.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                        else
                            draw string(p.x*_fw1,P.y*_fh1),chr(enemy(a).tile),,font1,custom,@_col
                        endif
                        if enemy(a).sleeping>0 or enemy(a).hpnonlethal>enemy(a).hp then 
                            if configflag(con_tiles)=0 then
                                set__color(  203,0)
                                draw string ((p.x-osx)*_tix,P.y*_fh1),"z",,font2,custom,@_tcol
                            else
                                set__color(  203,0)
                                draw string ((p.x-osx)*_fw1,P.y*_fh1),"z",,font2,custom,@_tcol
                            endif
                        endif
                        if player.stuff(3)<>2 and enemy(a).sleeping=0 and enemy(a).aggr=0 then walking=0
                    endif
                endif
            endif
        endif                    
    next
    
    if debug=2  and _debug=1 and lastapwp>=0 then
        for b=0 to lastapwp
            if apwaypoints(b).x-osx>=0 and apwaypoints(b).x-osx<=_mwx then
                set__color( 11,0)
                draw string((apwaypoints(b).x-osx)*_tix,apwaypoints(b).y*_tiy),""& b,,Font1,custom,@_col
                if tmap(apwaypoints(b).x,apwaypoints(b).y).onopen<>0 then 
                    draw string((apwaypoints(b).x-osx)*_tix+_fw1,apwaypoints(b).y*_tiy),""& b,,Font1,custom,@_col 
                endif            
            endif
        next
        endif
        if debug=2 and _debug=1 then
        for x=0 to 60
            for y=0 to 20
                if x-osx>=0 and x-osx<=_mwx then

                    if tmap(x,y).onopen<>0 then 
                        draw string((x-osx)*_tix+_fw1,y*_tiy),"*",,Font1,custom,@_col 
                    endif            
                endif
            next
        next
    endif
    
    return 0
end function

function ep_needs_spacesuit(slot as short,c as _cords) as short
    dim dam as short
    dam=0
    if planets(slot).atmos=1 or vacuum(c.x,c.y)=1 then dam=10
    if planets(slot).atmos=2 or planets(slot).atmos=7 or planets(slot).atmos=12 then dam=5
    if planets(slot).atmos>12 then dam+=planets(slot).atmos/2
    if planets(slot).temp<-60 or planets(slot).temp>60 then dam=dam+abs(planets(slot).temp/60)
    if dam>50 then dam=50
    return dam
end function

function ep_dropitem(li() as short,byref lastlocalitem as short,enemy() as _monster,byref lastenemy as short,vismask() as byte) as short
    dim as short c,d,slot,i
    dim as string text
    dim as _cords ship
    awayteam.lastaction+=1
    slot=player.map
    d=1
    if player.towed<-100 then
        text="Do you want to build the "
        if player.towed=-101 then text=text & "base module here?(y/n)"
        if player.towed=-102 then text=text & "mining station here?(y/n)"
        if player.towed=-103 then text=text & "defense tower here?(y/n)"
        if player.towed=-104 then text=text & "raffinery here?(y/n)"
        if player.towed=-105 then text=text & "factory here?(y/n)"
        if player.towed=-106 then text=text & "power plant here?(y/n)"
        if player.towed=-107 then text=text & "life support here?(y/n)"
        if player.towed=-108 then text=text & "storage facilities here?(y/n)"
        if player.towed=-109 then text=text & "hydroponic garden?(y/n)"
        if player.towed=-110 then text=text & "office building here?(y/n)"
        if askyn(text) then
            planetmap(awayteam.c.x,awayteam.c.y,slot)=-300+player.towed
            tmap(awayteam.c.x,awayteam.c.y)=tiles(-(player.towed-300))
            planets(slot).colony=1
            if player.towed=-101 then planets(slot).colonystats(0)=10
            if player.towed=-102 then planets(slot).colonystats(1)+=1
            if player.towed=-103 then planets(slot).colonystats(2)+=1
            if player.towed=-104 then planets(slot).colonystats(3)+=1
            if player.towed=-105 then planets(slot).colonystats(4)+=1
            if player.towed=-106 then planets(slot).colonystats(5)+=1
            if player.towed=-107 then planets(slot).colonystats(6)+=1
            if player.towed=-108 then planets(slot).colonystats(7)+=1
            if player.towed=-109 then planets(slot).colonystats(8)+=1
            if player.towed=-110 then planets(slot).colonystats(9)+=1
            player.towed=0
            d=0
        else
            if askyn("Do you want to drop an item?(y/n)") then 
                d=1
            else
                d=0
            endif
        endif
    endif
    if d=1 then
        c=get_item()
        ep_display(vismask(),enemy(),lastenemy,li(),lastlocalitem)
        display_awayteam(0)
        dprint ""
        if c>=0 then
            select case item(c).ty
            case is=45
                if askyn("Do you really want to drop the alien bomb?(y/n)") then
                    item(c).w.x=awayteam.c.x
                    item(c).w.y=awayteam.c.y
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    lastlocalitem+=1
                    li(lastlocalitem)=c
                    item(c).v2=1
                    dprint "What time do you want to set it to?"
                    item(c).v3=getnumber(1,99,1)
                endif
            case is=77 
                dprint "Where do you want to drop the "&item(c).desig &"?"
                d=getdirection(keyin)
                if d<>-1 or 5 then
                    item(c).w=movepoint(awayteam.c,d)
                    if tmap(item(c).w.x,item(c).w.y).shootable<>0 then
                        tmap(item(c).w.x,item(c).w.y).hp-=item(c).v1
                        dprint tmap(item(c).w.x,item(c).w.y).desc &" takes "&item(c).v1 &" points of damage."
                        destroyitem(c)
                        if tmap(item(c).w.x,item(c).w.y).hp<=0 and tmap(item(c).w.x,item(c).w.y).turnsinto<>0 then
                            planetmap(item(c).w.x,item(c).w.y,slot)=tmap(item(c).w.x,item(c).w.y).turnsinto
                            tmap(item(c).w.x,item(c).w.y)=tiles(tmap(item(c).w.x,item(c).w.y).turnsinto)
                        endif
                    else
                        dprint "Can't blow that up."
                    endif
                endif
            case else
                dprint "dropping " &item(c).desig &"." 
                for i=0 to 128
                    if crew(i).pref_lrweap=item(c).uid then crew(i).pref_lrweap=0
                    if crew(i).pref_ccweap=item(c).uid then crew(i).pref_ccweap=0
                    if crew(i).pref_armor=item(c).uid then crew(i).pref_armor=0
                next
                
                item(c).w.x=awayteam.c.x
                item(c).w.y=awayteam.c.y
                item(c).w.m=slot
                item(c).w.s=0
                item(c).w.p=0
                if item(c).ty=15 then
                    reward(2)=reward(2)-item(c).v5
                    combon(2).value-=item(c).v5
                endif
                if item(c).ty=24 and tmap(item(c).w.x,item(c).w.y).no=162 then
                    dprint("you reconnect the machine to the pipes. you notice the humming sound.")
                    no_key=keyin
                    item(c).v1=100
                endif
                
                if item(c).ty=26 or item(c).ty=29 then
                    reward(1)-=item(c).v3
                endif
                
                if item(c).ty=80 then 'Dropping a tribble
                    lastenemy+=1
                    enemy(lastenemy)=makemonster(101,slot)
                    enemy(lastenemy).slot=16
                    planets(slot).mon_template(enemy(lastenemy).slot)=enemy(lastenemy)
                    enemy(lastenemy).c=item(c).w
                    destroyitem(c)
                endif
                lastlocalitem=lastlocalitem+1
                li(lastlocalitem)=c
            end select
            equip_awayteam(slot)
        endif
        screenshot(2)
    endif
    return 0
end function


function ep_inspect(enemy() as _monster, lastenemy as short, li() as short,byref lastlocalitem as short,byref localturn as short) as short
    dim as short a,b,c,slot,skill,js,kit,rep
    dim as _cords p
    dim as _driftingship addship
    slot=player.map
    awayteam.lastaction+=1
    b=0
    if _autoinspect=1 and walking=0 and not((tmap(awayteam.c.x,awayteam.c.y).no>=128 and tmap(awayteam.c.x,awayteam.c.y).no<=143) or tmap(awayteam.c.x,awayteam.c.y).no=241) then dprint "You search the area: "&tmap(awayteam.c.x,awayteam.c.y).desc
    if awayteam.c.x=player.landed.x and awayteam.c.y=player.landed.y and awayteam.c.m=player.landed.m then
        a=findbest(50,1)
        if a>0 and player.hull<player.h_maxhull then 
            if askyn("Do you want to use your ship repair kit to repair your ship?(y/n)") then
                rep=minimum(player.h_maxhull-player.hull,item(a).v1)
                item(a).v1-=rep
                player.hull+=rep
                if item(a).v1<=0 then destroyitem(a)
            endif
        endif
    endif
    if (tmap(awayteam.c.x,awayteam.c.y).no>=128 and tmap(awayteam.c.x,awayteam.c.y).no<=143) or tmap(awayteam.c.x,awayteam.c.y).no=241 then 
        'Jump ship
        if tmap(awayteam.c.x,awayteam.c.y).hp>1 then
            If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") then 
                walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                dprint "Starting repair"
            endif
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).hp=0 then
            tmap(awayteam.c.x,awayteam.c.y).hp=15+rnd_range(1,6)+rnd_range(0,tmap(awayteam.c.x,awayteam.c.y).no-128)
            if skill_test(maximum(player.pilot(1)-1,player.science(1)),st_hard,"Repair ship") then
                dprint "This ship is beyond repair"
                if tmap(awayteam.c.x,awayteam.c.y).no=241 then
                    b=18
                else
                    b=tmap(awayteam.c.x,awayteam.c.y).no-127
                endif
                changetile(awayteam.c.x,awayteam.c.y,slot,62)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                addship.x=awayteam.c.x
                addship.y=awayteam.c.y
                addship.m=slot
                addship.s=b
                make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot),1)
            else
                If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") then 
                    walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                    dprint "Starting repair"
                endif
            endif
        endif
        if tmap(awayteam.c.x,awayteam.c.y).hp=1 then
            a=findbest(50,-1)
            if a>0 then 
                kit=item(a).v1
                destroyitem(a)
            else
                kit=0
            endif
            
            if skill_test(maximum(player.pilot(1)-1,player.science(1))+kit,st_hard,"Repair ship") then
                dprint "The repair was succesfull!",c_gre
                set__color( 15,0)
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
                if tmap(awayteam.c.x,awayteam.c.y).no=241 then b=18
                textbox(shiptypes(b) &"||"&makehullbox(b,"data/ships.csv"),2,5,25,15,1)
                if askyn("Do you want to abandon your ship and use this one?") then                            
                    a=player.h_no
                    if upgradehull(b,player) then
                        player.hull=int(player.hull*0.8)
                        tmap(player.landed.x,player.landed.y)=tiles(127+a)
                        changetile(player.landed.x,player.landed.y,slot,127+a)
                        player.landed.x=awayteam.c.x
                        player.landed.y=awayteam.c.y
                        player.landed.m=slot
                        tmap(player.landed.x,player.landed.y)=tiles(4)
                        planetmap(player.landed.x,player.landed.y,slot)=4
                        if player.hull<1 then player.hull=1
                        js=1
                    endif
                endif   
                if js=0 then
                    changetile(awayteam.c.x,awayteam.c.y,slot,4)
                    tmap(awayteam.c.x,awayteam.c.y)=tiles(4)
                
                    addship.x=awayteam.c.x
                    addship.y=awayteam.c.y
                    addship.m=slot
                    addship.s=b
                    make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot))
                    'planets(lastplanet)=planets(slot)
                    planets(lastplanet).depth=1
                    planets(lastplanet).atmos=planets(slot).atmos
                    planets(lastplanet).grav=planets(slot).grav
                    planets(lastplanet).temp=30
                    for a=1 to 16
                        planets(lastplanet).mon_template(a)=planets(slot).mon_template(a)
                        planets(lastplanet).mon_noamin(a)=planets(slot).mon_noamin(a)/3-1
                        planets(lastplanet).mon_noamax(a)=planets(slot).mon_noamax(a)/3-1 
                    next
                    
                endif
            else
                dprint "You couldn't repair the ship."
                make_drifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot),1)
                planets(lastplanet).depth=1
                planets(lastplanet).atmos=planets(slot).atmos
                planets(lastplanet).grav=planets(slot).grav
                planets(lastplanet).temp=30
                for a=1 to 16
                    planets(lastplanet).mon_template(a)=planets(slot).mon_template(a)
                    planets(lastplanet).mon_noamin(a)=planets(slot).mon_noamin(a)/3-1
                    planets(lastplanet).mon_noamax(a)=planets(slot).mon_noamax(a)/3-1 
                next
                
                changetile(awayteam.c.x,awayteam.c.y,slot,4)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(4)
            endif
        endif
        b=1
    endif
    
    for a=1 to lastenemy
        if b=0 and awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
            if enemy(a).hpmax>0 and enemy(a).hp<=0 and enemy(a).biomod>0 then
                awayteam.lastaction+=2
                skill=maximum(player.science(1),player.doctor(1)/2)
                if rnd_range(1,100)<enemy(a).disease*2-awayteam.helmet*3 then infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                if enemy(a).disease>0 and skill_test(maximum(player.doctor(1),player.science(1)/2),enemy(a).disease/2+7) then dprint "The creature seems to be a host to dangerous "&disease(enemy(a).disease).cause &"."
                if enemy(a).disease>0 and not(skill_test(maximum(player.doctor(1),player.science(1)/2)+awayteam.helmet*3,enemy(a).disease)) then 
                    infect(rnd_crewmember,enemy(a).disease)
                    dprint "This creature is infected with "&disease(enemy(a).disease).desig,14
                endif
                if (player.science(1)>0) or (player.doctor(1)>0) then
                    combon(1).value+=1
                    kit=findbest(48,-1)
                    if kit>0 then 
                        kit=item(kit).v1
                    else
                        kit=0
                    endif
                    
                    dprint "Recording biodata: "&enemy(a).ldesc 
                    if enemy(a).slot>=0 then planets(slot).mon_disected(enemy(a).slot)+=1
                    if enemy(a).lang=8 then dprint "While this beings biochemistry is no doubt remarkable it does not explain it's extraordinarily long lifespan"
                    if enemy(a).hpmax<0 then enemy(a).hpmax=0
                    if enemy(a).slot>=0 then reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+get_biodata(enemy(a)))/(planets(slot).mon_disected(enemy(a).slot)/2)
                    enemy(a).hpmax=0
                    b=1            
                    if kit>0 and not(skill_test(maximum(player.doctor(1)/2,player.science(location)),st_average)) then
                        kit=findbest(48,-1)
                        dprint "The autopsy kit is empty",c_yel
                        destroyitem(kit)
                    endif
                else
                    dprint "No science officer or doctor in the team.",c_yel
                endif
            else
                if (player.science(1)>0) or (player.doctor(1)>0) then
                    if enemy(a).hp>0 then dprint "The " &enemy(a).sdesc &" doesn't want to be dissected alive."
                    if enemy(a).biomod>0 then dprint "Nothing left to learn here."
                    if enemy(a).biomod=0 then dprint "Dissecting "&add_a_or_an(enemy(a).sdesc,0) &" doesn't yield any biodata."
                else
                    dprint "No science officer or doctor in the team.",c_yel
                endif
            endif
        endif
    next            
    if b=0 and tmap(awayteam.c.x,awayteam.c.y).vege>0 and planets(slot).flags(32)<=planets(slot).life+1+add_talent(4,15,3) then
        if (player.science(1)>0) or (player.doctor(1)>0) then
            skill=maximum(player.science(1),player.doctor(1)/2)                        
            'dprint ""&tmap(awayteam.c.x,awayteam.c.y).vege
            
            kit=findbest(49,-1)
            if kit>0 then 
                kit=item(kit).v1
            else
                kit=0
            endif
                
            if skill_test(skill+tmap(awayteam.c.x,awayteam.c.y).vege+add_talent(4,15,1)+kit,st_average+planets(a).plantsfound) then
                awayteam.lastaction+=2
                planets(slot).flags(32)=planets(slot).flags(32)+1
                b=1
                if tmap(awayteam.c.x,awayteam.c.y).no<>179 then
                    dprint "you have found "&plant_name(tmap(awayteam.c.x,awayteam.c.y))
                    if rnd_range(1,80)-player.science(1)-add_talent(4,14,1)<tmap(awayteam.c.x,awayteam.c.y).vege then
                        dprint "The plants in this area have developed a biochemistry you have never seen before. Scientists everywhere will find this very interesting."
                        reward(1)=reward(1)+(10+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                    endif
                    if rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 then
                        if not(skill_test(maximum(player.science(1)/2,player.doctor(1)),st_average)) then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
                        dprint "This area is contaminated with "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).ldesc
                    endif
                    if tmap(awayteam.c.x,awayteam.c.y).disease>0 and skill_test(maximum(player.doctor(1),player.science(1)/2),st_easy+tmap(awayteam.c.x,awayteam.c.y).disease/2) then dprint "The plants here seem to be a host to dangerous "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).cause &"."
                else
                    dprint "You collect some spice sand."
                    reward(1)+=rnd_range(1,10)
                endif
                reward(1)=reward(1)+(10+kit+skill+add_talent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                planets(slot).plantsfound=planets(slot).plantsfound+1
                if kit>0 and not(skill_test(maximum(player.doctor(1)/2,player.science(1)),st_average)) then
                    kit=findbest(49,-1)
                    dprint "The botany kit is empty",c_yel
                    destroyitem(kit)
                endif
            endif
            tmap(awayteam.c.x,awayteam.c.y).vege=0
        else
            dprint "No science officer or doctor on the team.",c_yel
        endif
    endif
    if b=0 then
        for c=1 to 9
            if c<>5 then 
                p=movepoint(awayteam.c,c)
            else
                p=awayteam.c
            endif
            if tmap(p.x,p.y).turnsoninspect<>0  and skill_test(player.science(1),st_average+tmap(p.x,p.y).turnroll) then
                awayteam.lastaction+=2
                b=1
                if tmap(p.x,p.y).turntext<>"" then dprint tmap(p.x,p.y).turntext
                planetmap(p.x,p.y,slot)=tmap(p.x,p.y).turnsoninspect
                tmap(p.x,p.y)=tiles(tmap(p.x,p.y).turnsoninspect)
            endif
        next
    endif
    if b=0 then
        if planetmap(awayteam.c.x,awayteam.c.y,slot)=107 then
            b=1
            if askyn("You could propably enhance some of the processes in this factory, to dimnish pollution. (y/n)") then
                awayteam.lastaction+=10
                if skill_test(player.science(location),st_hard) then
                    planets(slot).flags(28)+=1
                    if planets(slot).flags(28)>=5 then
                        dprint "You manage to reduce the emissions of this factory to sustainable levels.",10
                        planets(slot).flags(28)-=5
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(297)
                        planetmap(awayteam.c.x,awayteam.c.y,slot)=297
                    endif
                else
                    dprint "You do not succeed",14
                endif
            endif
        endif
    endif
    if b=0 and _autoinspect=1 then 
        dprint "Nothing of interest here."
    endif
    return 0
end function

function ep_items(li() as short, byref lastlocalitem as short,enemy() as _monster,lastenemy as short, localturn as short,vismask()as byte) as short
    dim as short a,slot,i,x,y,curr,last
    dim as _cords p1,p2,route(1281)
    dim as single dam
    dim as short debug=1
    
    slot=player.map
    for a=1 to lastlocalitem 'Drop items of dead monsters
            if item(li(a)).w.p>0 and item(li(a)).w.p<9999 then
            'if item(li(a)).w.p>0 and item(li(a)).w.p<9999 and item(li(a)).w.s>=0 then
             
                if enemy(item(li(a)).w.p).hp<=0 then
                    item(li(a)).w.x=enemy(item(li(a)).w.p).c.x
                    item(li(a)).w.y=enemy(item(li(a)).w.p).c.y
                    item(li(a)).w.p=0
                    item(li(a)).w.m=slot
                    item(li(a)).w.s=0
                endif
            endif
            
            if item(li(a)).ty=45 and item(li(a)).w.p<9999 and item(li(a)).w.s=0 then 'Alien bomb
                if item(li(a)).v2=1 then
                    item(li(a)).v3-=1
                    if item(li(a)).v3<10 or frac(item(li(a)).v3/10)=0 then dprint item(li(a)).v3 &""
                    if item(li(a)).v3<=0 then 
                        p1.x=item(li(a)).w.x
                        p1.y=item(li(a)).w.y
                        dam=10/(1+distance(awayteam.c,p1))*item(li(a)).v1*10
                        alienbomb(li(a),slot,enemy(),lastenemy,li(),lastlocalitem)
                        if dam>0 then dprint damawayteam(dam)
                        if awayteam.hp<=0 then player.dead=29
                        li(a)=li(lastlocalitem)
                        lastlocalitem-=1
                    endif
                endif
            endif
            
            if debug=1 and _debug=1 and item(li(a)).ty=18 then dprint "Rover stats:"&item(li(a)).discovered &":"& item(li(a)).w.p &":"& item(li(a)).w.s &":"& item(li(a)).v5
            if item(li(a)).ty=18 and item(li(a)).discovered=1 and item(li(a)).w.p=0 and item(li(a)).w.s>=0  and item(li(a)).v5=0 then 'Rover
                p1.x=item(li(a)).w.x
                p1.y=item(li(a)).w.y
                for i=1 to item(li(a)).v4
                    curr+=1
                    if item(li(a)).vt.x=-1 then
                        if curr>last then
                            last=ep_autoexploreroute(route(),p1,item(li(a)).v2,slot,li(),lastlocalitem)
                            curr=1
                        endif
                    else
                        if item(li(a)).w.x=item(li(a)).vt.x and item(li(a)).w.y=item(li(a)).vt.y then item(li(a)).vt.x=-1 
                        if curr>last then
                            last=ep_planetroute(route(),item(li(a)).v2,p1,item(li(a)).vt,planets(slot).depth)
                            curr=1
                        endif
                        
                    endif
                    if last>0 then
                        item(li(a)).w.x=route(curr).x
                        item(li(a)).w.y=route(curr).y
                    endif
                    
                    ep_roverreveal(li(a))
                next
                
                
            endif
            
            
            
        next
        return 0
end function

function ep_landship(byref ship_landing as short,nextlanding as _cords,nextmap as _cords,vismask() as byte,enemy() as _monster,lastenemy as short) as short
    dim as short r,slot,a,d
    slot=player.map
    ship_landing=ship_landing-1
    if ship_landing<=0 then
        if vismask(nextlanding.x,nextlanding.y)>0 and nextmap.m=0 then dprint "She is coming in"
        if skill_test(player.pilot(location),st_easy+planets(slot).dens+planets(slot).grav,"Pilot") then
            if vismask(nextlanding.x,nextlanding.y)>0 and nextmap.m=0 then dprint "Hard touchdown!",14
            player.hull=player.hull-1
            player.fuel=player.fuel-2-int(planets(slot).grav)
            d=rnd_range(1,8)
            if d=5 then d=9
            if r<-2 then r=-2
            for a=1 to r*-1
                nextlanding=movepoint(nextlanding,d)
            next
            if player.hull=0 then
                dprint ("A Crash landing. you will never be able to start with that thing again",12)
                if skill_test(player.pilot(1),st_veryhard) then
                    dprint ("but your pilot wants to try anyway and succeeds!",12)
                    player.hull=1
                    dprint gainxp(2),c_gre
                else
                    player.dead=4
                endif
                no_key=keyin
            endif
        else
            dprint gainxp(2),c_gre
        endif
        player.landed.m=slot
        player.landed.x=nextlanding.x
        player.landed.y=nextlanding.y
        for a=0 to lastenemy
            if distance(enemy(a).c,nextlanding)<2 then
                enemy(a).hp=enemy(a).hp-(player.h_no+planets(slot).grav)/(1+distance(enemy(a).c,nextlanding))
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" gets caught in the blast of the landing ship."
                if rnd_range(1,6)+ rnd_range(1,6)>enemy(a).intel then
                    enemy(a).aggr=2
                    enemy(a).target=nextlanding
                endif
            endif
        next
    endif
    return 0
end function

function ep_launch(byref nextmap as _cords) as short
    dim slot as short
    slot=player.map
    if awayteam.c.y=player.landed.y and awayteam.c.x=player.landed.x and slot=player.landed.m then 
        if slot=specialplanet(2) or slot=specialplanet(27)  then
            if slot=specialplanet(27) then
                if specialflag(27)=0 then 
                    dprint "As you attempt to start you realize that your landing struts have sunk into the surface of the planet. You try to dig free, but the surface closes around them faster than you can dig. You are stuck!"
                else
                    dprint "You successfully break free of the living planet."
                    nextmap.m=-1
                    'if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                endif
            endif
            if slot=specialplanet(2) then
                if specialflag(2)<>2 then 
                    dprint "As soon as you attempt to start the planetary defense system fires. You won't be able to start until you disable it."
                else
                    dprint "You start without incident"
                    nextmap.m=-1
                    #ifdef _FMODSOUND
                    if configflag(con_sound)=0 or configflag(con_sound)=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                    #endif
                endif                    
            endif
        else
            nextmap.m=-1
            #ifdef _FMODSOUND
            if configflag(con_sound)=0 or configflag(con_sound)=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
            #endif
        endif
    endif
    return 0
end function

function ep_planeteffect(enemy() as _monster, lastenemy as short,li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single,lavapoint() as _cords,vismask() as byte,localturn as short,cloudmap() as byte) as short
    dim as short slot,a,b,r,debug,x,y
    dim as string text
    static lastmet as short
    dim as _cords p1,p2
    slot=player.map
    lastmet=lastmet+1
    if planets(slot).death>0 then 'Exploding planet
        if planets(slot).death=8 then 
            if planets(slot).flags(28)=0 then
                if crew(4).hp>0 then dprint "Science officer: I wouldn't recommend staying much longer.",15
            else
                if player.pilot(0)>0 then dprint "Pilot: I am starting to worry. We are getting pretty deep into the gravity well of this planet."
            endif
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        endif
        if planets(slot).death=4 and crew(4).hp>0 then 
            if planets(slot).flags(28)=0 then
                if crew(4).hp>0 then dprint "Science officer: We really should get back to the ship now!",14
            else
                if player.pilot(0)>0 then dprint "Pilot: This thing is falling faster than I thought. Let's get out of here!",c_yel
            endif
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        endif
        if planets(slot).death=2 and crew(4).hp>0 then 
            if planets(slot).flags(28)=0 then
                if crew(4).hp>0 then dprint "Science officer: This planet is about to fall apart! We must leave! NOW!",12
            else
                if player.pilot(0)>0 then dprint "Pilot: We need to get of this icechunk! Now!",c_red
            endif
            no_key=keyin
            planets(slot).death=planets(slot).death-1
        endif
        if rnd_range(1,100)<33 then
            if sf>15 then sf=0
            shipfire(sf).where=rnd_point
            shipfire(sf).when=1
            shipfire(sf).what=10+sf
            player.weapons(shipfire(sf).what)=makeweapon(rnd_range(1,5))
            sf=sf+1
        endif

    endif    
    
    
    if slot=specialplanet(8) and rnd_range(1,100)<33 then
        set__color( 11,0)
        dprint "lightning strikes you "& damawayteam(1),12            
        player.killedby="lightning strike"
    endif
    
    
    
    if planets(slot).flags(25)=1 and awayteam.helmet=0 then
        if skill_test(player.science(location),st_hard) and crew(5).hp>0 then
            dprint "Your science officer has figured out that the hallucinations are caused by pollen. You switch to spacesuit air supply."
            awayteam.helmet=1
            planets(slot).flags(25)=2
        else
            if rnd_range(1,100)<60 then
                a=rnd_range(1,4)
                if a=1 then text="Your science officer remarks: "
                if a=2 then text="Your pilot remarks: "
                if a=3 then text="Your gunner says: "
                if a=4 then text="Your doctor finds some "
                for a=0 to rnd_range(10,20)
                    text=text &chr(rnd_range(33,200))
                next
                dprint text
            endif
        endif
    endif
    
    if slot=specialplanet(1) and rnd_range(1,100)<33 then
        b=0
        for a=1 to lastenemy
            if enemy(a).made=5 and enemy(a).hp>0 and enemy(a).aggr=0 then b=1
        next
        if b=1 then
            if rnd_range(1,6)+ rnd_range(1,6)+2>8 then
                dprint "Apollo calls down lightning and strikes you, infidel!"
                dprint damawayteam(1)
            else
                dprint "Apollo calls down lightning .... and misses"
            endif
        endif
    endif
    
    if isgardenworld(slot) and rnd_range(1,100)<5 then
        a=rnd_range(1,awayteam.hpmax)
        if crew(a).hp>0 and crew(a).typ<9 then 
            b=rnd_range(1,6)
            if b=1 then dprint crew(a).n &" remarks: 'What a beautiful world this is!'"
            if b=2 then dprint crew(a).n &" points out a particularly beautiful part of the landscape"
            if b=3 then dprint crew(a).n &" says: 'I guess I'll settle down here when i retire!'"
            if b=4 then dprint crew(a).n &" asks: 'How about some extended R&R here?"
            if b=5 then dprint crew(a).n &" remarks: 'Wondefull'"
            if b=6 then dprint crew(a).n &" starts picking flowers."
        endif
    endif
    if sysfrommap(slot)>=0 then 
        if (planets(slot).dens<4 and planets(slot).depth=0 and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))+countasteroidfields(sysfrommap(slot))*2-map(sysfrommap(slot)).spec and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))) or more_mets=1 then 
            if lastmet>1000 and rnd_range(1,100)<30 or more_mets=1 then 
                ep_crater(li(),lastlocalitem,shipfire(),sf)
                lastmet=0
            else
                lastmet+=1
            endif
            if more_mets=1 then dprint ""&lastmet
        endif
    endif
    if cloudmap(awayteam.c.x,awayteam.c.y)>0 and planets(slot).atmos>6 and rnd_range(1,150)<(planets(slot).dens*planets(slot).weat) and slot<>specialplanet(28) then            
        if planets(slot).temp<300 then
            dprint "It's raining sulphuric acid! "&damawayteam(1),14
        else
            dprint "It's raining molten lead! "&damawayteam(1),14
        endif
        player.killedby=" hostile environment"
    endif
    
    if planets(slot).atmos>11 and rnd_range(1,100)<planets(slot).atmos*2 and frac(localturn/10)=0 then
        a=getrnditem(-2,0)
        if a>0 then
            if rnd_range(1,100)>item(a).res then
                item(a).res=item(a).res-25
                if item(a).res>=0 then
                    dprint "Your "&item(a).desig &" starts to corrode.",14
                else
                    dprint "Your "&item(a).desig &" corrodes and is no longer usable.",14
                    destroyitem(a)
                    equip_awayteam(slot)
                    'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                endif
            endif
        endif
        for a=1 to lastlocalitem
            if item(li(a)).ty<20 then
                if item(li(a)).w.s=0 and rnd_range(1,100)>item(li(a)).res then item(li(a)).res-=25
                if item(li(a)).res<=0 then item(li(a)).w.p=9999
                if item(li(a)).ty=18 and item(li(a)).w.p=9999 then item(li(a))=makeitem(65) 'Rover debris
            endif
        next
    endif
    
    if specialplanet(5)=slot or specialplanet(8)=slot then
        if awayteam.c.x<>player.landed.x or awayteam.c.y<>player.landed.y then
            if rnd_range(1,250)-(awayteam.move)<((planets(slot).atmos-3)*planets(slot).weat) and planets(slot).depth=0 then
                'for a=1 to rnd_range(1,3)
                dprint "High speed winds set you of course!",14
                awayteam.c=movepoint(awayteam.c,5)
                'next
            endif
        endif
    endif
    
    return 0    
end function
 
function ep_pickupitem(key as string, byref lastlocalitem as short, li() as short,enemy() as _monster,byref lastenemy as short) as short
    dim a as short
    dim text as string
    for a=1 to lastlocalitem
        if item(li(a)).w.p=0 and item(li(a)).w.s=0 and item(li(a)).w.x=awayteam.c.x and item(li(a)).w.y=awayteam.c.y then 
            if item(li(a)).ty<>99 then 
                if _autopickup=1 then text=text &item(li(a)).desig &". " 
                if _autopickup=0 or key=key_pickup then
                    if item(li(a)).ty=15 then
                        if item(li(a)).v1<5 then text=text &" You pick up the small amount of "&item(li(a)).desig &". "
                        if item(li(a)).v1>=5 and item(li(a)).v1<=10 then text=text &" You pick up the "&item(li(a)).desig &". "
                        if item(li(a)).v1>10 then text=text &" You pick up the large amount of "&item(li(a)).desig &". "
                    else
                        text=text &" You pick up the "&item(li(a)).desig &". " 
                    endif
                    reward(2)=reward(2)+item(li(a)).v5
                    combon(2).value+=item(li(a)).v5
                    item(li(a)).w.s=-1
                endif
                if item(li(a)).ty=18 then 
                    text=text &" You transfer the map data from the rover robot ("&fix(item(li(a)).v6) &"). "
                    reward(0)=reward(0)+item(li(a)).v6
                    reward(7)=reward(7)+item(li(a)).v6
                    item(li(a)).v6=0
                endif
                if item(li(a)).ty=27 then 
                    text=text &" You gather the resources from the mining robot ("&fix(item(li(a)).v1) &"). "
                    reward(2)=reward(2)+item(li(a)).v1
                    combon(2).value+=item(li(a)).v1
    
                    item(li(a)).v1=0
                endif
                if item(li(a)).ty=26 then
                    if item(li(a)).v1>0 then
                        text=text &" There is something in it."
                        text=text & item(li(a)).ldesc
                        reward(1)+=item(li(a)).v3
                    endif
                endif
                'awayteam.lastaction+=1
            else
                dprint "An alien artifact!",10
                if _autopickup=0 or key=key_pickup then
                    
                    findartifact(item(li(a)).v5)
                    item(li(a)).w.p=9999
                    li(a)=li(lastlocalitem)
                    lastlocalitem=lastlocalitem-1
                    'awayteam.lastaction+=1
                endif
            endif
        endif
    next
    if key=key_pickup then
        for a=1 to lastenemy
            if enemy(a).c.x=awayteam.c.x and enemy(a).c.y=awayteam.c.y and enemy(a).made=101 and enemy(a).hp>0 then
                text=text &" You pick up the tribble."
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
                placeitem(makeitem(250),0,0,0,0,-1)
                exit for
            endif
        next
    endif
    if text<>"" then 
        dprint trim(text),15
    endif
    return 0
end function

function ep_portal() as _cords
    dim as short a,ti,slot
    dim as _cords nextmap
    dim as _cords p
    slot=player.map
    for a=0 to lastportal
        if portal(a).from.m=slot then
            if awayteam.c.x=portal(a).from.x and awayteam.c.y=portal(a).from.y then
                if askyn(portal(a).desig &" Enter?(y/n)") then
                    dprint "going through."
                    'walking=-1
                    if planetmap(0,0,portal(a).dest.m)=0 then
                        'dprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).dest.m)=planets(slot)
                        planets(portal(a).dest.m).weat=0
                        planets(portal(a).dest.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).dest.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        if rnd_range(1,100)>planets(portal(a).from.m).depth*12 then
                            makecavemap(portal(a).dest,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        else
                            if rnd_range(1,100)<71 then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).dest.m).temp=25
                                planets(portal(a).dest.m).atmos=3
                                planets_flavortext(portal(a).dest.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute" 
                            else
                                makecanyons(portal(a).dest.m,9)
                                p=rnd_point(portal(a).dest.m,0)
                                portal(a).dest.x=p.x
                                portal(a).dest.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts." 
                            endif
                        endif
                        if planets(portal(a).dest.m).depth>7 then 
                            makefinalmap(portal(a).dest.m)
                            portal(a).dest.x=30
                            portal(a).dest.y=2
                        endif
                    endif
                    nextmap=portal(a).dest
                    'dprint " "&portal(a).dest.m
                endif
            endif
        endif
        if portal(a).oneway=0 and portal(a).dest.m=slot then
            if awayteam.c.x=portal(a).dest.x and awayteam.c.y=portal(a).dest.y then
                if askyn(portal(a).desig &" Enter?(y/n)") then
                    dprint "going through."
                    'walking=-1
                    if planetmap(0,0,portal(a).from.m)=0 then
                        'dprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                        ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                        planets(portal(a).from.m)=planets(slot)
                        planets(portal(a).from.m).depth=planets(portal(a).dest.m).depth+1
                        planets(portal(a).from.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                        if rnd_range(1,100)>planets(portal(a).dest.m).depth*12 then
                            makecavemap(portal(a).from,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti,0)
                        else
                            if rnd_range(1,100)<71 then
                                makecomplex(portal(a).dest,0)
                                planets(portal(a).from.m).temp=25
                                planets(portal(a).from.m).atmos=3
                                planets_flavortext(portal(a).from.m)="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute" 
                            else
                                makecanyons(portal(a).from.m,9)
                                p=rnd_point(portal(a).from.m,0)
                                portal(a).from.x=p.x
                                portal(a).from.y=p.y
                                planets_flavortext(portal(a).dest.m)="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts." 
                            endif
                        endif
                        if planets(portal(a).from.m).depth>7 then 
                            makefinalmap(portal(a).from.m)
                            portal(a).from.x=30
                            portal(a).from.y=2
                        endif
                    endif
                    nextmap=portal(a).from
                endif
            endif
        endif
        if portal(a).oneway=2 and portal(a).from.m=slot then
            if awayteam.c.x=0 or awayteam.c.x=60 or awayteam.c.y=0 or awayteam.c.y=20 then
                if askyn("Do you want to leave the area?(y/n)") then nextmap=portal(a).dest
            endif
        endif
    next
    return nextmap
end function
        
function ep_tileeffects(areaeffect() as _ae, byref last_ae as short,lavapoint() as _cords, nightday() as byte, localtemp() as single,cloudmap() as byte,vismask() as byte) as short
    dim as short a,x,y,dam,slot,orbit
    dim as _cords p,p2
    dim as single tempchange
    slot=player.map
    orbit=orbitfrommap(slot)
    if orbit=-1 then
        tempchange=0
    else
        tempchange=11-planets(slot).dens*2/orbit
    endif
    for x=0 to 60
        if nightday(x)=3 then localtemp(x)=localtemp(x)-tempchange
        if nightday(x)=0 then localtemp(x)=localtemp(x)+tempchange
        for y=0 to 20
            if x>0 and x<60 and y>0 and y<20 then
                if tmap(x,y).no=204 or tmap(x,y).no=202 then
                    if vacuum(x-1,y)=1 or vacuum(x+1,y)=1 or vacuum(x,y-1)=1 or vacuum(x,y+1)=1 then vacuum(x,y)=1
                    if vacuum(x-1,y-1)=1 or vacuum(x-1,y+1)=1 or vacuum(x+1,y-1)=1 or vacuum(x+1,y+1)=1 then vacuum(x,y)=1
                endif
            endif
            if tmap(x,y).dam<>0 then
                p2.x=x 
                p2.y=y
                player.killedby=tmap(x,y).deadt
                if player.killedby="" then player.killedby=tmap(x,y).desc
                if distance(awayteam.c,p2)<=tmap(x,y).range then
                    if tmap(x,y).dam<0 then
                        dam=rnd_range(1,abs(tmap(x,y).dam))
                    else
                        dam=tmap(x,y).dam
                    endif
                    if rnd_range(1,100)<tmap(x,y).tohit then
                        dprint tmap(x,y).hitt &" "&  damawayteam(dam),12
                    else
                        dprint tmap(x,y).misst,14
                    endif
                endif
            endif
            
            a=rnd_range(1,100)
            if a<tmap(x,y).causeaeon then
                last_ae=last_ae+1
                if last_ae>16 then last_ae=0
                areaeffect(last_ae).c.x=x
                areaeffect(last_ae).c.y=y
                areaeffect(last_ae).rad=rnd_range(1,2)
                areaeffect(last_ae).dam=0 
                areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
                areaeffect(last_ae).typ=tmap(x,y).aetype
            endif
                if localtemp(x,y)<-10 and tmap(x,y).no=1 or tmap(x,y).no=2 then
                    tmap(x,y).gives=tmap(x,y).gives+(localtemp(x,y)/25)
                    if rnd_range(0,100)<abs(tmap(x,y).gives) and tmap(x,y).gives<-50 then
                        if vismask(x,y)>0 then dprint "The water freezes again."
                        if tmap(x,y).no=2 then
                            tmap(x,y)=tiles(27)
                            changetile(x ,y ,slot ,27)
                        else
                            tmap(x,y)=tiles(260)
                            changetile(x ,y ,slot ,260)
                        endif
                    endif
                endif
                
                if localtemp(x)>10 and tmap(x,y).no=27 or tmap(x,y).no=260 then
                    tmap(x,y).hp-=localtemp(x,y)/25
                    if tmap(x,y).hp<0 then 
                        tmap(x,y)=tiles(2)
                        changetile(x ,y ,slot ,2)
                        if vismask(x,y)>0 then dprint "The ice melts."
                    endif
                endif
                
                if localtemp(x)>30 and planets(slot).atmos>1 then
                    if tmap(x,y).walktru=1 then
                        if rnd_range(1,100)<localtemp(x,y)+planets(slot).weat then cloudmap(x,y)+=1
                        
                    endif
                endif
                if x>0 and y>0 and x<60 and y<20 then
                    if cloudmap(x,y)>0 then
                        if tmap(x,y).walktru=2 or tmap(x-1,y).walktru=2 or tmap(x+1,y).walktru=2 or tmap(x,y-1).walktru=2 or tmap(x,y+1).walktru=2 then
                            cloudmap(x,y)-=1
                        endif
                        if planets(slot).dens<3 then cloudmap(x,y)-=2
                    endif
                endif
                if cloudmap(x,y)>0 then
                    p.x=x
                    p.y=y
                    if rnd_range(1,100)<(1+planets(slot).weat)*5 then
                        cloudmap(x,y)-=1
                        p=movepoint(p,5,1)
                        cloudmap(p.x,p.y)+=1
                    endif
                endif
                    
                
                if tmap(x,y).no=245 and rnd_range(1,100)<9+planets(slot).grav then
                    p.x=x
                    p.y=y
                    p=movepoint(p,5)
                    lavapoint(rnd_range(1,5))=p
                endif
        next
    next
    
    if planetmap(awayteam.c.x,awayteam.c.y,slot)=45 then
        dprint "smoldering lava:" &damawayteam(rnd_range(1,6-awayteam.move)),12
        if awayteam.hp<=0 then player.dead=16 
        player.killedby="lava"
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).no=175 or tmap(awayteam.c.x,awayteam.c.y).no=176 or tmap(awayteam.c.x,awayteam.c.y).no=177 then
        dprint "Aaaaaaaaaaaaaaaahhhhhhhhhhhhhhh",12
        player.dead=27
    endif
    
    if (tmap(awayteam.c.x,awayteam.c.y).no=260 or tmap(awayteam.c.x,awayteam.c.y).no=27) and player.dead=0 then
        tmap(awayteam.c.x,awayteam.c.y).gives=tmap(awayteam.c.x,awayteam.c.y).gives-rnd_range(0,awayteam.hp\5)
        if tmap(awayteam.c.x,awayteam.c.y).hp<=awayteam.hp/3 then dprint "The ice creaks",14
        if tmap(awayteam.c.x,awayteam.c.y).hp<=0 then 
            dprint "...and breaks! "&damawayteam(rnd_range(1,3)),12
            tmap(awayteam.c.x,awayteam.c.y)=tiles(2)
            planetmap(awayteam.c.x,awayteam.c.y,slot)=2
        endif
    endif
    
    return 0
end function

function ep_lava(lavapoint() as _cords,vismask() as byte) as short
    dim as short a,slot
    slot=player.map
    if planets(slot).temp+rnd_range(0,10)>350 then 'lava            
        a=rnd_range(1,5)
        if lavapoint(a).x=0 and lavapoint(a).y=0 then
            lavapoint(a).x=rnd_range(1,60)
            lavapoint(a).y=rnd_range(1,20)
        endif
        if rnd_range(1,100)<75 then
            if lavapoint(a).x<>player.landed.x and lavapoint(a).y<>player.landed.y then 
                if planets(slot).depth=0 then
                    if rnd_range(1,100)<50 then
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                    else
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-8
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(8)
                    endif
                else
                    planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                    tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                endif
            endif
        endif
        lavapoint(a)=movepoint(lavapoint(a),5)
        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-45
        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(45)
        if vismask(lavapoint(a).x,lavapoint(a).y)>0 then
            walking=0
            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=45
            dprint "The ground breaks open, releasing fountains of lava"                
        endif
        if lavapoint(a).x=player.landed.x and lavapoint(a).y=player.landed.y then
            player.hull=player.hull-1
            if distance(lavapoint(a),awayteam.c)<awayteam.sight then dprint "Your ship was damaged!"
            if player.hull<=0 then player.dead=15
        endif
    endif
    return 0
end function


function ep_updatemasks(spawnmask() as _cords,mapmask() as byte,nightday() as byte, byref dawn as single, byref dawn2 as single) as short
    dim as short lsp,x,y,slot,sys,hasnosun
    slot=player.map
    sys=sysfrommap(slot)
    hasnosun=0
    if sys<0 then 
        hasnosun=1
    else
        if map(sys).spec=9 or map(sys).spec=10 then hasnosun=1
    endif
    if planets(slot).depth>0 then hasnosun=1
    if hasnosun=0 then
        dawn=dawn+planets(slot).rot/5
        if dawn>60 then dawn=dawn-60
        dawn2=dawn+30
        if dawn2>60 then dawn2=dawn2-60
        for x=60 to 0 step -1
            nightday(x)=0
            if (dawn<dawn2 and (x>dawn and x<dawn2))  then nightday(x)=3
            if (dawn>dawn2 and (x>dawn or x<dawn2)) then nightday(x)=3
            if x=int(dawn) then nightday(x)=1
            if x=int(dawn2) then nightday(x)=2
        next
    else
        for x=0 to 60
            nightday(x)=4
        next
    endif
        
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
    return lsp
end function

function ep_monstermove(enemy() as _monster, m() as single, byref lastenemy as short, li() as short,byref lastlocalitem as short,spawnmask() as _cords, lsp as short, vismask() as byte, mapmask() as byte,nightday() as byte) as short
    dim deadcounter as short
    dim as short a,b,c,slot,ti,f,osx,cmoodto
    dim moa as byte 'monster attack
    dim as _cords p1,p2
    dim as single tb,dam
    dim as string text
    dim as byte debug=120
    slot=player.map
    deadcounter=0
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    if makemoodlog=1 then
        f=freefile
        open "monstermood.txt" for append as #f
        print +f," "
    endif
    for a=1 to lastenemy        
        if player.questflag(25)<>0 then
            if enemy(a).made=66 or enemy(a).made=67 or enemy(a).made=68 then
                enemy(a).faction=1
                enemy(a).aggr=1
            endif
        endif
        if makemoodlog=1 then print #f,enemy(a).aggr;" ";enemy(a).made;" ";enemy(a).faction
        if enemy(a).c.x<0 then enemy(a).c.x=0
        if enemy(a).c.y<0 then enemy(a).c.y=0
        if enemy(a).c.x>60 then enemy(a).c.x=60
        if enemy(a).c.y>20 then enemy(a).c.x=20
        locate enemy(a).c.y+1,enemy(a).c.x+1
        if enemy(a).hp>0 then            
            'changes mood
            if enemy(a).aggr=1 and enemy(a).made<>101 then
                if rnd_range(1,100)>(20+enemy(a).diet)*distance(enemy(a).c,awayteam.c) then 
                    if rnd_range(1,6)+rnd_range(1,6)>8+enemy(a).diet+awayteam.invis+enemy(a).cmmod and enemy(a).sleeping<1 then
                        select case enemy(a).diet
                        case is=1
                            cmoodto=1
                        case is=2
                            if rnd_range(1,100)<50-enemy(a).hp then
                                cmoodto=2
                            else
                                cmoodto=1
                            endif
                        case is=3
                            if rnd_range(1,100)<75-enemy(a).hp then
                                cmoodto=2
                            else
                                cmoodto=1
                            endif
                        end select
                        enemy(a).aggr=cmoodto
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                            enemy(a).cmshow=1
                            if cmoodto=1 then dprint "The "&enemy(a).sdesc &" suddenly seems agressive",14
                            if cmoodto=2 then dprint "The "&enemy(a).sdesc &" suddenly seems afraid",14
                        endif
                        for b=1 to lastenemy
                            if a<>b and enemy(b).hp>0 then 
                                if enemy(a).faction=enemy(b).faction and vismask(enemy(b).c.x,enemy(b).c.y)>0 then 
                                    enemy(b).aggr=cmoodto
                                    enemy(a).cmshow=1
                                    dprint "The "&enemy(b).sdesc &" tries to help his friend!",14
                                endif
                            endif
                        next
                    endif
                endif
            endif
            if enemy(a).aggr=1 then
                if enemy(a).nocturnal<>0 then 
                    if enemy(a).nocturnal=1 then 
                        if nightday(enemy(a).c.x)=3 then
                            if enemy(a).sleeping<=0 and rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel then enemy(a).invis=3
                            enemy(a).sleeping=2
                        else
                            enemy(a).sleeping-=1
                            if enemy(a).sleeping<=0 and enemy(a).invis=3 then enemy(a).invis=0
                        endif
                    endif
                    if enemy(a).nocturnal=2 then
                        if nightday(enemy(a).c.x)=0 then
                            if enemy(a).sleeping<=0 and rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel then enemy(a).invis=3
                            enemy(a).sleeping=2
                        else
                            enemy(a).sleeping-=1
                            if enemy(a).sleeping<=0 and enemy(a).invis=3 then enemy(a).invis=0
                        endif
                    endif
                endif
            endif
            if enemy(a).made=102 and nightday(enemy(a).c.x)=3 then
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The icetroll slowly stops moving."
                changetile(enemy(a).c.x,enemy(a).c.y,slot,304)
                enemy(a).hp=0
                enemy(a).hpmax=0
            endif
            if rnd_range(1,100)<enemy(a).breedson and enemy(a).breedson>0 and lastenemy<128 then
                if enemy(a).made<>101 or tmap(enemy(a).c.x,enemy(a).c.y).vege>0 then 
                    if enemy(a).made=101 then
                        tmap(enemy(a).c.x,enemy(a).c.y).vege-=1 'Tribbles only multiply when they have something to eat
                        if tmap(enemy(a).c.x,enemy(a).c.y).vege<=0 then changetile(enemy(a).c.x,enemy(a).c.y,slot,4)
                    endif
                    lastenemy=lastenemy+1
                    enemy(lastenemy).c=movepoint(enemy(a).c,5)
                    if tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru=0 or enemy(a).stuff(tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru)>0 then
                        enemy(lastenemy)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,vismask(),enemy(lastenemy).c.x,enemy(lastenemy).c.y,c)
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 or vismask(enemy(lastenemy).c.x,enemy(lastenemy).c.y)>0 then dprint "the "&enemy(a).sdesc &" multiplies!"
                    else
                        lastenemy-=1
                    endif
                endif
            endif
            if enemy(a).hp<enemy(a).hpmax then
                enemy(a).hp=enemy(a).hp+enemy(a).hpreg
                if enemy(a).hp>enemy(a).hpmax then
                    enemy(a).hp=enemy(a).hpmax
                    if enemy(a).aggr>0 and rnd_range(1,distance(enemy(a).c,awayteam.c))>enemy(a).intel then enemy(a).aggr=enemy(a).aggr-1 
                endif
            endif
            
            for b=1 to lastenemy
                if b<>a then
                    if enemy(a).c.x=enemy(b).c.x and enemy(a).c.y=enemy(b).c.y then
                        if enemy(b).hp<=0 and enemy(b).hpmax>0 then
                            if enemy(a).faction<>enemy(b).faction then
                                if enemy(a).diet=1 then
                                    enemy(b).hpmax=enemy(b).hpmax-1
                                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc & " eats of the dead "&enemy(b).sdesc &"."
                                endif
                            else
                                if rnd_range(1,6)+rnd_range(1,6)<5+enemy(a).intel and enemy(b).killedby=0 then
                                    enemy(a).aggr=0
                                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc & " gets angry looking at the dead "&enemy(b).sdesc &"."
                                endif
                            endif
                        endif
                    endif
                endif
            next
            
            if enemy(a).diet=2 and tmap(enemy(a).c.x,enemy(a).c.y).vege>0 then
                tmap(enemy(a).c.x,enemy(a).c.y).vege=tmap(enemy(a).c.x,enemy(a).c.y).vege-1
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc & " eats some of the plants growing here."
            endif
            if enemy(a).diet=3 and enemy(a).aggr=1 then
                c=-1
                for b=1 to lastenemy
                    if b<>a then
                        if enemy(b).hp<=0 then c=b
                    endif
                next
                if c=-1 then
                    enemy(a).target=rnd_point
                else 
                    enemy(a).target=enemy(c).c
                endif
            endif
            if enemy(a).diet=4 and enemy(a).aggr=1 or enemy(a).aggr=2 then
                c=-1
                for b=1 to lastlocalitem
                    if item(li(b)).w.x=enemy(a).c.x and item(li(b)).w.y=enemy(a).c.y and item(li(b)).w.p=0 and item(li(b)).w.s=0 then 
                        item(li(b)).w.p=a
                        item(li(b)).discovered=0
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                            if enemy(a).made=15 then 
                                dprint "The awayteam picks up the "&item(li(b)).desig &"."
                            else
                                dprint "The alien awayteam picks up the "&item(li(b)).desig &"."
                            endif
                        endif
                    
                    endif
                    if item(li(b)).ty=15 and item(li(b)).w.s=0 and item(li(b)).w.p=0 then c=b
                    
                next
                if enemy(a).aggr=2 then c=-1
                if c=-1 then
                    for x=0 to 60
                        for y=0 to 20
                            if tmap(x,y).spawnswhat=enemy(a).made then 
                               enemy(a).target.x=x
                               enemy(a).target.y=y
                               if show_all=1 then dprint "set target at "&x &":"&y
                            endif
                        next
                    next
                    enemy(a).aggr=1
                    if skill_test(player.science(location),st_average+planets(slot).dens) then dprint "Recieving radio transmission: 'Returning to ship'"
                else
                    enemy(a).target.x=item(li(c)).w.x
                    enemy(a).target.y=item(li(c)).w.y
                    if skill_test(player.science(location),st_average+planets(slot).dens) then dprint "Recieving radio transmission: 'Going for ore at "&enemy(a).target.x &":"&enemy(a).target.y &"'"
                endif
            endif
            
            'm(a)=m(a)+enemy(a).move
            tb=planets(slot).grav/10
            if enemy(a).aggr=2 then tb=tb+0.1 
            if awayteam.hp<3 then tb=tb-0.6
            if abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=7 or abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=8 then tb=tb-0.5
            tb=tb-(awayteam.move/10)-add_talent(-1,24,0)
            tb=tb+player.tactic/10
            if tb>enemy(a).move and enemy(a).move>0 then
                tb=enemy(a).move-0.1
            endif
            m(a)=m(a)-tb
            if enemy(a).move=-1 then m(a)=0
            for x=0 to 60
                for y=0 to 20
                    mapmask(x,y)=0
                next
            next
            mapmask(awayteam.c.x,awayteam.c.y)=-9
            for b=1 to lastenemy
                if enemy(b).c.x<0 then enemy(b).c.x=0
                if enemy(b).c.y<0 then enemy(b).c.y=0
                if enemy(b).c.x>60 then enemy(b).c.x=60
                if enemy(b).c.y>20 then enemy(b).c.y=20
                if enemy(b).hp>0 then mapmask(enemy(b).c.x,enemy(b).c.y)=b
                if b<>a and enemy(a).aggr=2 and enemy(a).hp<enemy(a).hpmax and enemy(a).faction=enemy(b).faction then
                    if distance(enemy(a).c,enemy(b).c)<1.6 then
                        if rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel then
                            enemy(b).aggr=0
                            enemy(a).aggr=0
                            if vismask(enemy(a).c.x,enemy(a).c.y)>0 or vismask(enemy(b).c.x,enemy(b).c.y)>0 then dprint "The "&enemy(a).sdesc &" asks the other "& enemy(b).sdesc &" for help!" 
                        endif
                    endif
                endif
            next
            
            if configflag(con_tiles)=0 then
                'Nothing
            else
                if planetmap(enemy(a).c.x,enemy(a).c.y,slot)>0 then 
                    dtile(enemy(a).c.x,enemy(a).c.y,tiles(planetmap(enemy(a).c.x,enemy(a).c.y,slot)),1)
                else
                    set__color( 0,0)
                    draw string(enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), " ",,font1,custom,@_col
                endif
            endif
            
            if enemy(a).sleeping>0 then enemy(a).sleeping-=m(a)
            
            while m(a)>0.9 and enemy(a).sleeping<=0 and enemy(a).hpnonlethal<=enemy(a).hp and enemy(a).invis<2
                x=enemy(a).c.x
                y=enemy(a).c.y
                mapmask(enemy(a).c.x,enemy(a).c.y)=0
                ti=abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))
                if ti=1 or ti=2 then mapmask(enemy(a).c.x,enemy(a).c.y)=1
                if ti=7 or ti=8 then mapmask(enemy(a).c.x,enemy(a).c.y)=2
                if ti>46 and ti<55 then mapmask(x,y)=3
                if enemy(a).track>0 and tmap(enemy(a).c.x,enemy(a).c.y).gives=0 then 
                    changetile(enemy(a).c.x,enemy(a).c.y,slot,enemy(a).track)
                    tmap(enemy(a).c.x,enemy(a).c.y)=tiles(enemy(a).track)
                endif
                if enemy(a).target.x=0 and enemy(a).target.y=0 then
                    p1=rnd_point
                else
                    p1=enemy(a).target
                endif
                enemy(a).reg+=enemy(a).regrate
                if enemy(a).reg>10 and enemy(a).hp<enemy(a).hpmax then
                    enemy(a).hp+=1
                    enemy(a).reg=0
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).desc &" regenerates."
                endif
                enemy(a)=movemonster(enemy(a), p1, mapmask(),tmap())
                mapmask(enemy(a).c.x,enemy(a).c.y)=3
                m(a)=m(a)-1
            wend
            
            if enemy(a).hasoxy=0 and (planets(slot).atmos=1 or vacuum(enemy(a).c.x,enemy(a).c.y)=1) then
                enemy(a).hp=enemy(a).hp-1
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" is struggling for air!"
            endif
        else
            deadcounter=deadcounter+1
        endif
    
    if makemoodlog=1 then close #f
    
        if enemy(a).c.x<0 then enemy(a).c.x=0
        if enemy(a).c.y<0 then enemy(a).c.y=0
        if enemy(a).c.y>20 then enemy(a).c.y=20
        if enemy(a).c.x>60 then enemy(a).c.x=60
        if enemy(a).aggr=0 or enemy(a).aggr=2 then
            if distance(enemy(a).c,awayteam.c)<enemy(a).sight-awayteam.invis/2 then enemy(a).target=awayteam.c                            
        endif    
        if distance(enemy(a).c,awayteam.c)<enemy(a).range and enemy(a).hp>0 then
            if debug=1 and _debug=1 then text=text &"sl:"&enemy(a).sleeping &"move"&enemy(a).move &"m:"&m(a)
            if enemy(a).sleeping<=0 and (enemy(a).move=-1 or m(a)>0) then
                if enemy(a).invis=2 then
                    dprint "A clever "&enemy(a).sdesc &" has been hiding here, waiting for prey!",14
                    enemy(a).invis=0
                endif
                walking=0
                
                if enemy(a).invis=0 and vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                    if configflag(con_tiles)=0 then
                        put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                    else
                        draw string(enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), chr(enemy(a).tile),,font1,custom,@_col
                    endif
                endif
                if (enemy(a).aggr=0 or enemy(a).aggr=2) then 
                    if pathblock(awayteam.c,enemy(a).c,slot)<>0 then                         
                        walking=0
                        pathblock(awayteam.c,enemy(a).c,slot,,enemy(a).scol,,planets(slot).depth)
                        awayteam=monsterhit(enemy(a),awayteam,vismask(enemy(a).c.x,enemy(a).c.y))
                        if debug=1 and _debug=1 then text=text &""&a
                        m(a)=m(a)-enemy(a).atcost
                    endif
                endif
            endif
        endif
        if enemy(a).nearest>0 and enemy(a).made<>101 then
            if m(a)>0 and enemy(a).faction<>enemy(enemy(a).nearest).faction and enemy(a).hp>0 and enemy(enemy(a).nearest).hp>0 then
                moa=0
                if enemy(a).faction>7 or enemy(enemy(a).nearest).faction>7 then 
                    moa=1
                else
                    if faction(enemy(a).faction).war(enemy(enemy(a).nearest).faction)>rnd_range(1,100) then moa=1
                    if faction(enemy(enemy(a).nearest).faction).war(enemy(a).faction)>rnd_range(1,100) then moa=1
                endif
                if moa=1 then
                    enemy(enemy(a).nearest)=monsterhit(enemy(a),enemy(enemy(a).nearest),vismask(enemy(a).c.x,enemy(a).c.y))
                    enemy(a).target=enemy(enemy(a).nearest).c
                    enemy(enemy(a).nearest).target=enemy(a).c
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 or vismask(enemy(enemy(a).nearest).c.x,enemy(enemy(a).nearest).c.y)>0 then dprint "The "&enemy(a).sdesc &" attacks the "&enemy(enemy(a).nearest).sdesc &"."
                    m(a)=m(a)-enemy(a).atcost
                    if enemy(enemy(a).nearest).hp<=0 and enemy(a).diet=4 or rnd_range(1,6)+enemy(a).cmmod<7 then enemy(a).aggr=1
                endif
            endif
        endif
        if enemy(a).diet=4 then 'awayteam
            if enemy(a).c.x>=0 and enemy(a).c.x<=60 and enemy(a).c.y>=0 and enemy(a).c.y<=20 then
                if tmap(enemy(a).c.x,enemy(a).c.y).spawnswhat=enemy(a).made then
                    enemy(a).stuff(16)=enemy(a).stuff(16)+1
                    if enemy(a).stuff(16)>1 then
                        tmap(enemy(a).c.x,enemy(a).c.y)=tiles(4)
                        if planetmap(enemy(a).c.x,enemy(a).c.y,slot)>0 then planetmap(enemy(a).c.x,enemy(a).c.y,slot)=4
                        if planetmap(enemy(a).c.x,enemy(a).c.y,slot)<0 then planetmap(enemy(a).c.x,enemy(a).c.y,slot)=-4
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=86 then 
                                dprint "The other scoutship launches."
                                companystats(basis(nearest_base(player.c)).company).profit+=1
                            endif
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=272 or tmap(enemy(a).c.x,enemy(a).c.y).no=273 then dprint "The alien ship launches."
                        else
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=86 then 
                                dprint "You see a scoutship starting in the distance."                                                        
                                companystats(basis(nearest_base(player.c)).company).profit+=1
                            endif
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=272 or tmap(enemy(a).c.x,enemy(a).c.y).no=273 then dprint "You see an alien ship starting in the distance."                                                        
                            companystats(basis(nearest_base(player.c)).company).profit+=1
                        endif
                        enemy(a)=enemy(lastenemy)
                        lastenemy=lastenemy-1
                        
                    endif
                endif
            endif
       endif
       for b=1 to lastlocalitem
           'if debug=120 then dprint b &";"& item(li(b)).w.s
            if item(li(b)).w.x=enemy(a).c.x and item(li(b)).w.y=enemy(a).c.y and enemy(a).hp>0 and item(li(b)).w.s=0 and item(li(b)).w.p<>9999 then
                select case item(li(b)).ty
                case 21 or 22
                    item(li(b)).w.p=9999
                    if item(li(b)).ty=21 then enemy(a).hp=enemy(a).hp-rnd_range(1,item(li(b)).v1)
                    if item(li(b)).ty=22 then enemy(a).sleeping=enemy(a).sleeping+rnd_range(1,item(li(b)).v1)
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                        locate item(li(b)).w.y+1,item(li(b)).w.x+1
                        set__color( item(li(b)).col,1)
                        draw string (item(li(b)).w.x*_fw1,item(li(b)).w.y*_fh1), chr(176),,font2,custom,@_col
                        dprint "The mine explodes under the "&enemy(a).sdesc &"!"
                    endif
                case 29 'Monster steps on Trap
                    if item(li(b)).v1<item(li(b)).v2 then
                        if rnd_range(1,6)+rnd_range(1,6)+item(li(b)).v2-enemy(a).hp/2-enemy(a).intel>0 and enemy(a).intel<5 then
                            'caught
                            item(li(b)).v3=50*enemy(a).biomod+cint(2*enemy(a).biomod*(enemy(a).hpmax^2)/3)'reward
                            item(li(b)).v1+=1
                            item(li(b)).ldesc = item(li(b)).ldesc & " | "&enemy(a).sdesc 
                            if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" gets caught in the trap."
                            enemy(a)=enemy(lastenemy)
                            lastenemy-=1
                        else
                            'evaded
                            if rnd_range(1,6)+rnd_range(1,6)+item(li(b)).v2-enemy(a).hp/2-enemy(a).intel<0 then'
                                'monster destroys trap
                                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" notices the trap and destroys it."
                                item(li(b)).w.p=9999
                            else
                                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" notices the trap."
                            endif
                        endif
                    endif
                case else
                    if rnd_range(1,6)+enemy(a).pumod>7 and item(li(b)).ty<>23 and item(li(b)).w.p=0 then
                        item(li(b)).w.p=a
                        item(li(b)).discovered=0
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" picks up the "&item(li(b)).desig &"."
                    endif
                end select
            endif    
       next
    next
    if debug=1 and _debug=1 then dprint "Attacked this turn:"&text
    adisdeadcounter=deadcounter
    return deadcounter
end function

function ep_spawning(enemy() as _monster,lastenemy as short,spawnmask() as _cords,lsp as short, diesize as short,vismask() as byte,nightday() as byte) as short
    dim as short a,b,c,x,y,d,slot
    if _spawnoff=1 then return 0
    slot=player.map
    for x=0 to 60
        for y=0 to 20
            a=rnd_range(1,100)
            if a<tmap(x,y).spawnson and tmap(x,y).spawnblock>=0 then
                if tmap(x,y).spawnblock>0 then tmap(x,y).spawnblock=tmap(x,y).spawnblock-3
                b=0
                for c=1 to lastenemy
                    if enemy(c).made=tmap(x,y).spawnswhat and enemy(c).hp>0 then b=b+1
                next
                if b<tmap(x,y).spawnsmax then
                    d=getmonster(enemy(),lastenemy)
                    enemy(d)=setmonster(makemonster(tmap(x,y).spawnswhat,slot),slot,spawnmask(),lsp,vismask(),x,y,d)
                    if vismask(x,y)>0 then dprint tmap(x,y).spawntext,14
                endif
            endif
            if tmap(x,y).no=304 and nightday(x)=0 then
                changetile(x,y,slot,4)
                d=getmonster(enemy(),lastenemy)
                enemy(d)=setmonster(makemonster(102,slot),slot,spawnmask(),lsp,vismask(),x,y,d)
                if vismask(x,y)>0 then dprint "The iceblock suddenly starts to move."
            endif
        next
    next
    for a=1 to lastenemy
        if enemy(a).hp<=0 and planets(slot).atmos>12 and rnd_range(1,100)>planets(slot).atmos then enemy(a).hpmax=enemy(a).hpmax-1
        if enemy(a).hp<=0 then enemy(a).hp=enemy(a).hp-1
        if enemy(a).hp<-45-diesize and enemy(a).respawns=1 and rnd_range(1,100)<(1+planets(slot).life)*5 then 
            enemy(a)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,vismask(),,,a)
            planets(slot).life-=1
            if planets(slot).life<0 then planets(slot).life=0
        endif
    next
    return lastenemy
end function

function ep_shipfire(shipfire() as _shipfire,vismask() as byte,enemy() as _monster,byref lastenemy as short) as short
    dim as short sf2,a,b,c,x,y,r,dam,slot,osx,ani,f,debug,icechunkhole,dambonus,ed
    dim p2 as _cords
    if rnd_range(1,100)<10 and planets(slot).flags(29)>0  then icechunkhole=1
    if debug=2 and _debug=1 then icechunkhole=1
    if debug=1 and _debug=1 then
        f=freefile
        open "sflog.txt" for append as #f
            for a=0 to 16
                print #f,shipfire(a).when;":";shipfire(a).where.x;":";shipfire(a).where.y;":"
            next
        close #f
    endif
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    display_planetmap(slot,osx,0)
    for sf2=0 to 16
        if shipfire(sf2).when>0 then  
            shipfire(sf2).when-=1
            if shipfire(sf2).tile<>"" and vismask(shipfire(sf2).where.x,shipfire(sf2).where.y)>0 then
                set__color( 7,0)
                draw string (shipfire(sf2).where.x*_fw1,shipfire(sf2).where.y*_fh1),shipfire(sf2).tile,,Font1,custom,@_col
            endif
            if shipfire(sf2).when=0 then
                screenset 1,1
                shipfire(sf2).tile=""
                b=rnd_range(1,6)+rnd_range(1,6)+maximum(player.sensors,player.gunner(0))
                if b>13 then dprint gainxp(2),c_gre
                b=b-8
                if b<0 then
                    b=b*-1
                    c=rnd_range(1,8)
                    if c=5 then c=9
                    for a=1 to b
                        if shipfire(sf2).what>10 then shipfire(sf2).where=movepoint(shipfire(sf2).where,c)
                    next
                endif
                r=player.weapons(shipfire(sf2).what).dam/2
                dam=1
                if r<1 then r=1
                if player.weapons(shipfire(sf2).what).ammomax>0 then dambonus=player.loadout
                for a=1 to player.weapons(shipfire(sf2).what).dam+dambonus
                    dam=dam+rnd_range(0,2)
                next
                do
                    ani+=1
                for x=shipfire(sf2).where.x-5 to shipfire(sf2).where.x+5
                    for y=shipfire(sf2).where.y-5 to shipfire(sf2).where.y+5
                        p2.x=x
                        p2.y=y
                        if x>=0 and y>=0 and x<=60 and y<=20 then
                            if distance(shipfire(sf2).where,p2)<=r then
                                'Deal damage
                                for a=1 to lastenemy
                                    if enemy(a).c.x=x and enemy(a).c.y=y then
                                        if shipfire(sf2).stun=0 then
                                            enemy(a).hp=enemy(a).hp-dam
                                            if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint enemy(a).sdesc &" takes " &dam &" points of damage.",10
                                        else
                                            enemy(a).hpnonlethal=enemy(a).hpnonlethal+(dam*((10-enemy(a).stunres)/10))
                                        endif
                                        if enemy(a).hp<=0 then
                                            player.alienkills=player.alienkills+1
                                        endif
                                         exit for
                                    endif
                                next
                                if awayteam.c.x=x and awayteam.c.y=y then 
                                    dprint "you got caught in the blast! "
                                    if shipfire(sf2).stun=0 then dprint damawayteam(dam),12
                                    if shipfire(sf2).stun=1 then awayteam.lastaction+=15
                                endif
                                'Show
                                locate y+1,x+1
                                if player.weapons(shipfire(sf2).what).ammomax>0 then
                                    if x=shipfire(sf2).where.x and y=shipfire(sf2).where.y then set__color( 15,15)
                                    if distance(shipfire(sf2).where,p2)>0 then set__color( 12,14)
                                    if distance(shipfire(sf2).where,p2)>1 then set__color( 12,0)
                                else
                                    if x=shipfire(sf2).where.x and y=shipfire(sf2).where.y then set__color( 15,15)
                                    if distance(shipfire(sf2).where,p2)>0 then set__color( 11,9)
                                    if distance(shipfire(sf2).where,p2)>1 then set__color( 9,1)
                                endif                        
                                if shipfire(sf2).stun=1 then
                                    if distance(shipfire(sf2).where,p2)>0 then set__color( 242,244)
                                    if distance(shipfire(sf2).where,p2)>1 then set__color( 246,248)
                                endif
                                if configflag(con_tiles)=0 then
                                    ed=distance(p2,shipfire(sf2).where)
                                    if ani-ed<1 then ed=ani-1
                                    put((x-osx)*_tix,y*_tiy),gtiles(gt_no(77+ani-ed)),trans
                                else
                                    draw string ((x-osx)*_fw1,y*_fh1), chr(178),,Font1,custom,@_col
                                endif
                                if tmap(x,y).no=3 or tmap(x,y).no=5 or tmap(x,y).no=6 or tmap(x,y).no=10  or tmap(x,y).no=11 or tmap(x,y).no=14 then 
                                    tmap(x,y)=tiles(4)
                                    if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=4
                                    if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-4
                                endif
                                if tmap(x,y).shootable>0 and shipfire(sf2).stun=0 then
                                    tmap(x,y).hp=tmap(x,y).hp-dam
                                    if tmap(x,y).succt<>"" and vismask(x,y)>0 then dprint "The "&tmap(x,y).desc &" is damaged.",12
                                    if tmap(x,y).hp<=0 then
                                        if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).turnsinto
                                        if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                                        tmap(x,y)=tiles(tmap(x,y).turnsinto)
                                    endif
                                    if icechunkhole=1 then
                                        if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=200
                                        if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-200
                                        tmap(x,y)=tiles(200)
                                    endif
                                endif
                            endif
                        endif
                    next
                next
                sleep 15
                loop until ani>=8 or configflag(con_tiles)=1
                sleep 100+distance(awayteam.c,shipfire(sf2).where)*6
                #ifdef _FMODSOUND
                if (configflag(con_sound)=0 or configflag(con_sound)=2) and planets(slot).atmos>1 then FSOUND_PlaySound(FSOUND_FREE, sound(4))
                #endif
            endif
            if shipfire(sf2).what>10 then 
                player.weapons(shipfire(sf2).what)=makeweapon(0)
                player.killedby="short thrown grenade"
            else
                player.killedby="explosion"
            endif
        endif
    next
    return 0
end function

function ep_radio(byref nextlanding as _cords,byref ship_landing as short, li() as short,lastlocalitem as short,enemy() as _monster,lastenemy as short,shipfire() as _shipfire,lavapoint() as _cords, byref sf as single,vismask() as byte,nightday() as byte,localtemp() as single) as short
    dim as _cords p,p1,p2,pc
    dim as string text
    dim as short a,b,slot,debug
    dim osx as short
    dim as _weap del
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    screenset 1,1    
    p2.x=player.landed.x
    p2.y=player.landed.y
    dprint "Engaging remote control."
    if (pathblock(awayteam.c,p2,slot,1)=-1 or awayteam.stuff(8)=1 or distance(awayteam.c,p2)<2) and player.landed.m=slot then
        dprint "Your command?"
        text=" "
        pc=locEOL
        text=ucase(gettext(pc.x,pc.y,46,text))
        if instr(text,"ROVER")>0 then
            if debug=1 and _debug=1 then dprint "Contacting Rover"
            b=0
            for a=1 to lastlocalitem
                if item(li(a)).ty=18 and item(li(a)).w.p=0 and item(li(a)).w.s=0 then b=li(a)
            next
            if debug=1  and _debug=1 then dprint b &" Rover found."
            if b>0 then
                p1.x=item(b).w.x
                p1.y=item(b).w.y
                if pathblock(p2,p1,slot,1)=-1 or (awayteam.stuff(8)=1 and player.landed.m=slot) then
                    if instr(text,"STOP")>0 then 
                        dprint "Sending stop command to rover"
                        item(b).v5=1
                    endif
                    if instr(text,"START")>0 then 
                        dprint "sending start command to rover."
                        item(b).v5=0
                    endif
                    if instr(text,"TARGET")>0 then 
                        dprint "Get target for rover:"
                        text=get_planet_cords(p1,slot)
                        if text=key__enter then item(b).vt=p1
                        text=""
                    endif
                    if instr(text,"POSITI")>0 or instr(text,"WHERE")>0 then
                        dprint "Rover is at "& item(b).w.x &":"& item(b).w.y &"."
                    endif
                else
                    dprint "No radio contact with rover"
                endif
            else
                dprint "No rover to contact"
            endif
            text=""
        endif
        if instr(text,"HELP")>0 then dprint "How shall we help you? come to you or fire on something or launch?"
        if instr(text,"SELFDESTRUCT")>0 then dprint "We don't have a selfdestruct device. Guess we could make the reactor go critical, but why would we want to?"
        if instr(text,"SCAN")>0 or instr(text,"ORBITAL")>0 or instr(text,"SATELLI")>0 then
            if awayteam.stuff(8)=0 then
                dprint "We don't have a satellite in orbit"
            else
                if instr(text,"LIFE")>0 then
                    ep_heatmap(enemy(),lastenemy,lavapoint(),5)
                else
                    a=rnd_range(0,lastlocalitem)
                    if item(li(a)).ty=15 and item(li(a)).w.p=0 and item(li(a)).w.s=0 then
                        item(li(a)).discovered=1
                        dprint "We have indications that there is an ore deposit at "& item(li(a)).w.x &":"& item(li(a)).w.y
                    else
                        dprint "No new information from orbital scans."
                    endif
                endif
            endif
        endif
        if instr(text,"POSIT")>0 or instr(text,"LOCATI")>0 or instr(text,"WHERE")>0 then
            dprint "We are at " &player.landed.x &":" &player.landed.y
        endif
        if instr(text,"LAUNC")>0 or instr(text,"START")>0 then
            if (slot=specialplanet(2) and specialflag(2)<2) or (slot=specialplanet(27) and specialflag(27)=0) then
                if slot=specialplanet(2) then dprint "We can't start untill we disabled the automatic defense system."
                if slot=specialplanet(27) then dprint "Can't get her up from this surface. She is stuck."
            else
                if askyn("Are you certain? you want to launch on remote and leave you behind? (y/n)") then 
                    if planets(slot).depth=0 then 
                        player.dead=4
                    else
                        dprint "Good luck then."
                        player.landed.m=0
                    endif
                endif
            endif
        endif
        if instr(text,"HELLO")>0 then dprint "Yes?"
        if instr(text,"STATUS")>0 or instr(text,"REPORT")>0 then                                            
            screenshot(1)
            shipstatus()
            screenshot(2)
            dprint "The ship is fine, like you left her"
            for a=1 to 5
                if distance(p2,lavapoint(a))<2 and lavapoint(a).x>0 and lavapoint(a).y>0 then
                    dprint "Lava is coming a bit close though"
                    exit for
                endif
            next
        endif
        if instr(text,"GET")>0 or instr(text,"COME")>0 or instr(text,"LAND")>0 or instr(text,"RESCUE")>0 then
            if (slot=specialplanet(2) and specialflag(2)<2) or (slot=specialplanet(27) and specialflag(27)=0) or planets(slot).depth>0 then
                if slot=specialplanet(2) then dprint "We can't start untill we disabled the automatic defense system."
                if slot=specialplanet(27) then dprint "Can't get her up from this surface. She is stuck."
                if planets(slot).depth>0 then dprint "I think you are slightly overestimating the size of the airlock, captain!"
            else                        
                p.x=player.landed.x
                p.y=player.landed.y
                if instr(text,"HERE")>0 then
                    nextlanding.x=awayteam.c.x
                    nextlanding.y=awayteam.c.y
                    player.landed.m=0
                else
                    dprint "Roger. Where do you want me to land?"
                    nextlanding=awayteam.c
                    text=get_planet_cords(nextlanding,slot,1)
                    if text=key__enter then
                        player.landed.m=0
                    else
                        nextlanding.x=p.x
                        nextlanding.y=p.y
                    endif
                endif
                if nextlanding.x=player.landed.x and nextlanding.y=player.landed.y then
                    dprint "We already are at that position."
                    player.landed.m=slot
                else
                    ship_landing=distance(p,nextlanding)/2
                    if ship_landing<1 then ship_landing=1
                    if crew(2).onship=lc_onship then
                        dprint "ETA in "&ship_landing &". See you there."
                    else
                        dprint "ETA in "&ship_landing &". Putting her down there by remote control."
                    endif
                endif
            endif
        endif
        if instr(text,"FIR")>0 or instr(text,"NUKE")>0 or instr(text,"SHOOT")>0 then
            sf=sf+1
            if sf>15 then sf=0
            dprint "Roger. Designate target."
            shipfire(sf).where=awayteam.c
            text=get_planet_cords(shipfire(sf).where,slot,1)
            if text=key__enter then
                if pathblock(p2,shipfire(sf).where,slot,1)=0 then
                    dprint "No line of sight to that target."
                    shipfire(sf).where.x=-1
                    shipfire(sf).where.y=-1
                else
                    shipfire(sf).when=(distance(awayteam.c,p2)\10)+1
                    cls
                    display_ship
                    shipfire(sf).what=com_getweapon 
                    if shipfire(sf).what<0 then
                        shipfire(sf).what=6
                        shipfire(sf).when=-1
                    endif
                    if player.weapons(shipfire(sf).what).ammomax=0 and distance(shipfire(sf).where,p2,1)>10 then shipfire(sf).when=-5
                        
                    if player.weapons(shipfire(sf).what).desig="" then shipfire(sf).when=-1
                    if player.weapons(shipfire(sf).what).ammomax>0 then 
                        if player.useammo=0 then shipfire(sf).when=-2
                    endif
                    if player.weapons(shipfire(sf).what).shutdown<>0 then shipfire(sf).when=-3
                    if player.weapons(shipfire(sf).what).reloading<>0 then shipfire(sf).when=-4 
                    if shipfire(sf).when>0 then 
                        dprint player.weapons(shipfire(sf).what).desig &" fired"
                        player.weapons(shipfire(sf).what).heat+=player.weapons(shipfire(sf).what).heatadd*25
                        player.weapons(shipfire(sf).what).reloading=player.weapons(shipfire(sf).what).reload
                        if not(skill_test(player.gunner(0),player.weapons(shipfire(sf).what).heat/25)) then
                        
                            dprint player.weapons(shipfire(sf).what).desig &" shuts down due to heat."
                            player.weapons(shipfire(sf).what).shutdown=1
                            if not(skill_test(player.gunner(location),player.weapons(shipfire(sf).what).heat/20,"Gunner: Shutdown")) then
                                dprint player.weapons(shipfire(sf).what).desig &" is irreperably damaged."
                                player.weapons(shipfire(sf).what)=del
                            endif
                        endif
                    endif
                    if shipfire(sf).when=-1 then dprint "Fire order canceled"
                    if shipfire(sf).when=-2 then dprint "I am afraid we are out of ammunition"
                    if shipfire(sf).when=-3 then dprint "Can't fire that weapon at this time."
                    if shipfire(sf).when=-5 then dprint "That target is below the horizon."
                    if shipfire(sf).when=-4 then 
                        if player.weapons(shipfire(sf).what).ammomax=0 then
                            dprint "That weapon is currently recharging."
                        else
                            dprint "That weapon is currently reloading."
                        endif
                    endif
                endif
            endif                            
        endif
        awayteam.lastaction+=2
    else
        dprint "No contact possible"
    endif
    return 0
end function

function ep_roverreveal(i as integer) as short
    dim as short x,y,slot,debug
    dim as single d
    dim as _cords p1
    slot=item(i).w.m
    for x=item(i).w.x-item(i).v1-3 to item(i).w.x+item(i).v1+3
        for y=item(i).w.y-item(i).v1-3 to item(i).w.y+item(i).v1+3
            if x>=0 and y>=0 and x<=60 and y<=20 then
                p1.x=x
                p1.y=y
                d=distance(p1,item(i).w)
                if pathblock(p1,item(i).w,slot,5)=0 or d<1.5 then
                    if d<=item(i).v1+1 and planetmap(x,y,slot)<0 then
                        planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                        item(i).v6=item(i).v6+0.5*item(i).v3*planets(slot).mapmod
                    endif
                endif
            endif
        next
    next
    
    return 0
end function


function ep_heatmap(enemy() as _monster,lastenemy as short,lavapoint() as _cords,lastlavapoint as short) as short
    dim as short map(60,20),heatmap(60,20)
    dim as short x,y,x1,y1,a,sensitivity,dis
    dim as _cords p1,p2
    for a=0 to lastenemy
        if enemy(a).hp>0 then map(enemy(a).c.x,enemy(a).c.y)+=enemy(a).hp
    next
    for a=0 to lastlavapoint
        if lavapoint(a).x>0 and lavapoint(a).y>0 then map(lavapoint(a).x,lavapoint(a).y)+=50-player.sensors*4
    next        
    for x=0 to 60
        for y=0 to 20
            if map(x,y)>0 then
                heatmap(x,y)=map(x,y)
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if x1>=0 and y1>=0 and x1<=60 and y1<=20 then
                            heatmap(x,y)=heatmap(x,y)+map(x1,y1)/2
                        endif
                    next
                next
            endif
        next
    next
    
    for x=0 to 60
        for y=0 to 20
            if heatmap(x,y)>0 then
                for x1=x-1 to x+1
                    for y1=y-1 to y+1
                        if x1>=0 and y1>=0 and x1<=60 and y1<=20 and (x1<>x or y1<>y) then
                            if heatmap(x,y)>=heatmap(x1,y1) then heatmap(x1,y1)=0
                        endif
                    next
                next
            endif
        next
    next
    sensitivity=24-player.sensors*2
    dis=9999
    p2.x=-1
    p2.y=-1
    for x=0 to 60
        for y=0 to 20
            if heatmap(x,y)>sensitivity then
                p1.x=x
                p1.y=y
                if distance(p1,awayteam.c)<dis then
                    p2=p1
                    dis=distance(p1,awayteam.c)
                endif
            endif
        next
    next
    if p2.x>0 or p2.y>0 then
        dprint "There is a source of heat at "&p2.x &":"&p2.y &". It might be a lifeform." 
    endif
    return 0
end function

function ep_helmet() as short
    dim as short slot
    slot=player.map
    if awayteam.helmet=0 then
        dprint "Switching to suit oxygen supply.",c_yel
        awayteam.helmet=1
        'oxydep
    else                
        'Opening Helmets
        if planets(slot).atmos>1 and planets(slot).atmos<8 and vacuum(awayteam.c.x,awayteam.c.y)=0 then
            awayteam.helmet=0
            awayteam.oxygen=awayteam.oxymax
            dprint "Opening helmets",c_gre
        else
            dprint "We can't open our helmets here",c_yel
        endif
    endif
    equip_awayteam(slot)
    return 0
end function


function ep_grenade(shipfire() as _shipfire, byref sf as single,vismask() as byte,enemy() as _monster,lastenemy as short,li() as short ,byref lastlocalitem as short) as short
    dim as short c,slot,i,launcher,rof
    slot=player.map
    dim as _cords p
    if configflag(con_chosebest)=0 then
        c=findbest(7,-1)
    else
        c=get_item(-1,7)
    endif
    launcher=findbest(17,-1)
    if c>0 then
        if _debug=707 then dprint "throwing "&item(c).desig
        if item(c).ty=7 then
            p=grenade(awayteam.c,slot,vismask(),enemy(),lastenemy,li(),lastlocalitem)
            if p.x>=0 then
                
                select case item(c).v2
                case 0,2
                    if launcher>0 then rof=item(launcher).v2
                    for i=1 to 1+rof
                        if c>0 then
                            sf=sf+1
                            if sf>15 then sf=0
                        
                            shipfire(sf).where=p
                            dprint "Delay for the grenade?"
                            shipfire(sf).when=getnumber(1,5,1)
                            shipfire(sf).what=11+sf
                            if item(c).v2=2 then shipfire(sf).stun=1
                            shipfire(sf).tile=item(c).icon
                            player.weapons(shipfire(sf).what)=makeweapon(item(c).v1)
                            player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
                            item(c)=item(lastitem)
                            lastitem=lastitem-1
                            c=findbest(7,-1)
                        endif
                    next
                case 1
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    item(c).w.x=p.x
                    item(c).w.y=p.y
                    lastlocalitem+=1
                    li(lastlocalitem)=c
                end select
            else
                dprint "canceled"
            endif
        else
            dprint "That's not a grenade."
        endif
        awayteam.lastaction+=2
    else
        dprint"You dont have any grenades"
    endif
    return 0
end function

function ep_playerhitmonster(old as _cords, enemy() as _monster, lastenemy as short,vismask() as byte,mapmask() as byte) as short
    dim as short a,b,slot
    slot=player.map
    for a=1 to lastenemy
        if vismask(enemy(a).c.x,enemy(a).c.y)>0 and enemy(a).slot>=0 then planets(slot).mon_seen(enemy(a).slot)=1
        if enemy(a).hp>0 then
            if awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
                if enemy(a).made<>101 then
                    awayteam.lastaction+=1
                    awayteam.c=old
                        if enemy(a).sleeping>0 or enemy(a).hpnonlethal>enemy(a).hp then
        '                if _tiles=0 then
        '                    put (awayteam.c.x*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(1000)),pset
        '                else
        '                    set__color( _teamcolor,0
        '                    draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,Font1,custom,@_col
        '                endif
                        if enemy(a).sleeping>0 or enemy(a).hpnonlethal>enemy(a).hp then
                            b=findworst(26,-1)
                            if b=-1 then b=findworst(29,-1) 'Using traps
                            if b>0 then
                                if askyn("The "&enemy(a).sdesc &" is unconcious. Do you want to capture it alive?(y/n)") then
                                    if item(b).v1<item(b).v2 then
                                        item(b).v1+=1
                                        lastcagedmonster+=1
                                        cagedmonster(lastcagedmonster)=enemy(a)
                                        cagedmonster(lastcagedmonster).c.s=b
                                        'if _debug=1 then dprint "reward"&(50)&"*"&(enemy(a).stunres/2)&"*"&enemy(a).biomod &"+cint("&2*enemy(a).biomod*(enemy(a).hpmax^2)/3
                                        reward(1)=reward(1)+get_biodata(enemy(a))
                                        item(b).v3+=get_biodata(enemy(a))
                                        enemy(a).hp=0
                                        enemy(a).hpmax=0
                                        if enemy(a).slot>=0 then planets(slot).mon_caught(enemy(a).slot)+=1
                                        awayteam.lastaction+=2
                                    else
                                        dprint "You don't have any unused cages."
                                    endif
                                endif
                            else 
                                dprint "The "&enemy(a).sdesc &" is asleep."
                            endif
                        else
                            if enemy(a).aggr=1 then 
                                if (askyn("Do you really want to attack the "&enemy(a).sdesc &"?(y/n)")) then
                                    enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                                    if rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel then enemy(a).aggr=0
                                    for b=1 to lastenemy
                                        if a<>b then
                                            if enemy(a).faction=enemy(b).faction and vismask(enemy(b).c.x,enemy(b).c.y)>0 then 
                                                enemy(b).aggr=0
                                                dprint "The "&enemy(b).sdesc &" tries to help his friend!",14
                                            endif
                                        endif
                                    next
                                else
                                    dprint "You squeeze past the "&enemy(a).sdesc &"."
                                    swap awayteam.c,enemy(a).c
                                    awayteam.lastaction+=1
                                endif
                            else
                                enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                                awayteam.lastaction+=1
                            endif                        
                        endif
                    endif
                endif
            endif
        endif
    next
    return 0
end function

function ep_fire(enemy() as _monster,lastenemy as short,vismask() as byte,mapmask() as byte,key as string,byref autofire_target as _cords) as short
    static autofire_dir as short
    dim enlist(128) as short
    dim shortlist as short
    dim wp(80) as _cords
    dim dam as short
    dim as short first,last,lp,osx
    dim as short a,b,c,d,e,f,slot
    dim as short scol
    dim as single range
    dim fired(60,20) as byte
    dim as _cords p,p1,p2
    dim text as string
    slot=player.map
    osx=calcosx(awayteam.c.x,planets(slot).depth)
    
    
    if configflag(con_tiles)=0 then
        put ((awayteam.c.x-osx)*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(990+(abs(awayteam.helmet-1)*3+crew(0).story(10)*3))),trans
    else
        set__color( _teamcolor,0)
        draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col                
    endif
    range=1.5
    if walking=0 then
        if key=key_fi then dprint "Fire direction ("& key_wait &" to chose target. "&key_layfire &" to divide fire)?"
        if key=key_autofire then dprint "Fire direction?"
        no_key=keyin
        autofire_dir=getdirection(no_key)
    endif
    for a=1 to 128'awayteam.hp
        if crew(a).hp>0 and crew(a).onship=0 then 
            if awayteam.secweapran(a)>range then range=awayteam.secweapran(a)
        endif
    next
    
    scol= 7
    if range>=3 then scol=11
    if range>=4 then scol=12
    if range>=5 then scol=10
    
    screenset 1,1
    
    if autofire_dir>0 and autofire_dir<>5 then
        awayteam.lastaction+=1
        e=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        do
            if configflag(con_tiles)=0 then
                put ((awayteam.c.x-osx)*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(990+(abs(awayteam.helmet-1)*3+crew(0).story(10)*3))),trans
            else
                set__color( _teamcolor,0)
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col                
            endif
            p2=movepoint(p2,autofire_dir,4)
            set__color( scol,0)
            if vismask(p2.x,p2.y)>0 then 
                if configflag(con_tiles)=0 then
                    if range<4 then
                        put((p2.x-osx)*_tix,p2.y*_tiy),gtiles(gt_no(75)),trans
                    else
                        put((p2.x-osx)*_tix,p2.y*_tiy),gtiles(gt_no(76)),trans
                    endif
                else
                    draw string((p2.x-osx)*_fw1,p2.y*_fh1), "*",,Font1,custom,@_col
                endif
            endif
            c=c+1
            c=ep_fireeffect(p2,slot,c,range,enemy(),lastenemy,mapmask())
        loop until c>=range
        if e=0 then sleep 100
        c=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        if key=key_autofire then walking=10
    else
        autofire_dir=-1
    endif
    
    if no_key=key_wait then
        dprint "Choose target" &range
        p=awayteam.c
        a=0
        do 
            if configflag(con_tiles)=0 then
                put ((awayteam.c.x-osx)*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(990+(abs(awayteam.helmet-1)*3+crew(0).story(10)*3))),trans
            else
                set__color( _teamcolor,0)
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col                
            endif
            p1=p
            no_key=cursor(p,slot,osx)
            if distance(p,awayteam.c)>range then p=p1
            if no_key=key_te or ucase(no_key)=" " or multikey(SC_ENTER) then a=1
            if no_key=key_quit or multikey(SC_ESCAPE) then a=-1    
        loop until a<>0
        autofire_target=p
        
        if a>0 then
            if distance(awayteam.c,autofire_target)<=range then
                awayteam.lastaction+=1              
                lp=line_in_points(autofire_target,awayteam.c,wp())
                for b=1 to lp
                    set__color( scol,0)
                    if configflag(con_tiles)=0 then
                        if range<4 then
                            put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                        else
                            put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                        endif
                    else
                        draw string((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                    endif
                    b=ep_fireeffect(wp(b),slot,b,lp,enemy(),lastenemy,mapmask())
                    sleep 15
                next
            else
                dprint "Target out of range.",14
            endif
            sleep 100
        endif
        if key=key_autofire then walking=11
    endif
    
    if no_key=key_layfire then
        for a=1 to lastenemy
            if vismask(enemy(a).c.x,enemy(a).c.y)>0 and enemy(a).hp>0 and enemy(a).aggr=0 and distance(awayteam.c,enemy(a).c)<=range then
                if pathblock(awayteam.c,enemy(a).c,slot,1) then
                    enlist(shortlist)=a
                    shortlist+=1
                endif
            endif
        next
        if shortlist>0 then
            awayteam.lastaction+=1
            first=1
            last=fix(awayteam.hpmax/shortlist)
            if last<1 then last=1
            for a=0 to shortlist-1
                lp=line_in_points(enemy(enlist(a)).c,awayteam.c,wp())
                dprint ""&lp
                if lp>=1 then
                    for b=1 to lp
                        if wp(b).x>=0 and wp(b).x<=60 and wp(b).y>=0 and wp(b).y<=20 then
                            set__color( scol,0)
                            if configflag(con_tiles)=0 then
                                if range<4 then
                                    put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(75)),trans
                                else
                                    put((wp(b).x-osx)*_tix,wp(b).y*_tiy),gtiles(gt_no(76)),trans
                                endif
                            else
                                draw string((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                            endif
                            if vismask(wp(b).x,wp(b).y)>0 and b<lp then draw string((wp(b).x-osx)*_fw1,wp(b).y*_fh1), "*",,Font1,custom,@_col
                            fired(wp(b).x,wp(b).y)=1
                            b=ep_fireeffect(wp(b),slot,b,lp-1,enemy(),lastenemy,mapmask(),first,last)
                        endif
                    next
                endif
                first=first+last+1
            next
            sleep 100
        else
            dprint "No hostile targets in sight."
        endif
        autofire_dir=0

    endif
    return 0
end function

function ep_fireeffect(p2 as _cords,slot as short, c as short, range as short,enemy() as _monster, lastenemy as short,  mapmask() as byte, first as short=0,last as short=0) as short
    dim as short d,f,x,y,vacc
    dim as single dam
    if first=0 and last=0 then 
        first=1
        last=awayteam.hpmax
    endif
    for d=1 to lastenemy
        if enemy(d).c.x=p2.x and enemy(d).c.y=p2.y and enemy(d).hp>0 then 
            enemy(d)=hitmonster(enemy(d),awayteam,mapmask(),first,first+last)
            'e=1
        endif
    next   
    if tmap(p2.x,p2.y).shootable=1 then
        dam=0
        for f=first to last
            if crew(f).hp>0 and crew(f).onship=0 then dam=dam+awayteam.secweap(f)
        next
        dam=cint(dam-tmap(p2.x,p2.y).dr)
        'dprint "in here with dam "&dam
        if dam>0 or (awayteam.stuff(5)>0 and c=1) then
            dam=dam+awayteam.stuff(5)
            if dam<=0 then dam=awayteam.stuff(5)
            dprint tmap(p2.x,p2.y).succt &" ("&dam &" damage)"
            tmap(p2.x,p2.y).hp=tmap(p2.x,p2.y).hp-dam
            if tmap(p2.x,p2.y).hp>=1 and tmap(p2.x,p2.y).hp<=tiles(tmap(p2.x,p2.y).no).hp*.25 then dprint "The "&tmap(p2.x,p2.y).desc &" is showing signs of serious damage."
            if tmap(p2.x,p2.y).hp<=0 then 
                if tmap(p2.x,p2.y).no=243 then
                    if vacuum(p2.x,p2.y)=0 then
                        for x=p2.x-1 to p2.x+1
                            for y=p2.y-1 to p2.y+1 
                                if x>=0 and x<=60 and y>=0 and y<=20 then
                                    if vacuum(x,y)=1 then vacc=1
                                endif
                            next
                        next
                        if vacc=1 then 
                            dprint "The air rushes out of the ship!",14
                            awayteam.helmet=1
                        endif
                    endif
                endif
                dprint tmap(p2.x,p2.y).killt,10
                tmap(p2.x,p2.y)=tiles(tmap(p2.x,p2.y).turnsinto)
                if planetmap(p2.x,p2.y,slot)>0 then planetmap(p2.x,p2.y,slot)=tmap(p2.x,p2.y).no
                if planetmap(p2.x,p2.y,slot)<0 then planetmap(p2.x,p2.y,slot)=-tmap(p2.x,p2.y).no                        
            endif
        else
            dprint tmap(p2.x,p2.y).failt,14
        endif
    endif 
    if tmap(p2.x,p2.y).firetru=1 then
        c=range+1                 
    endif
    return c
end function

function ep_closedoor() as short
    dim as short a,slot
    dim p1 as _cords
    slot=player.map
    awayteam.lastaction+=1
    for a=1 to 9
        if a<>5 then
            p1=movepoint(awayteam.c,a)
            if tmap(p1.x,p1.y).onclose<>0 then
                dprint "You close the "&tmap(p1.x,p1.y).desc &"."
                planetmap(p1.x,p1.y,slot)=tmap(p1.x,p1.y).onclose
                tmap(p1.x,p1.y)=tiles(abs(planetmap(p1.x,p1.y,slot)))
                tmap(p1.x,p1.y).locked=0
            endif
        endif
    next
    return 0
end function

function ep_examine(vismask() as byte, li() as short,enemy() as _monster,lastenemy as short,lastlocalitem as short) as short
    dim as _cords p2,p3
    dim as string key,text
    dim as short a,deadcounter,slot,osx,x
    dim debug as short
    dim as _cords ship
    ship=player.landed
    slot=player.map
    p2.x=awayteam.c.x
    p2.y=awayteam.c.y
    do
        p3=p2
        key=planet_cursor(p2,slot,osx,1)
        ep_display(vismask(),enemy(),lastenemy,li(),lastlocalitem,osx)
        display_awayteam(,osx)
        key=cursor(p2,slot,osx)
    
        if p3.x<>p2.x or p3.y<>p2.y then
            if p2.x<0 then p2.x=0
            if p2.y<0 then p2.y=0
            if p2.x>60 then p2.x=60
            if p2.y>20 then p2.y=20
            if distance(p2,awayteam.c)<=awayteam.sight and vismask(p2.x,p2.y)>0 then
                for a=0 to lastportal
                    if p2.x=portal(a).from.x and p2.y=portal(a).from.y and slot=portal(a).from.m then text=text & portal(a).desig &". "
                    if p2.x=portal(a).dest.x and p2.y=portal(a).dest.y and slot=portal(a).dest.m and portal(a).oneway=0 then text= text &portal(a).desig &". "
                    if debug=9 and _debug=1 and p2.x=portal(a).from.x and p2.y=portal(a).from.y and slot=portal(a).from.m then text=text &a &":"&portal(a).from.m &"dest:"& portal(a).dest.m &":"& portal(a).dest.x &":"& portal(a).dest.y &"oneway:"&portal(a).oneway
                next
                                
                for a=1 to lastlocalitem
                    if item(li(a)).w.x=p2.x and item(li(a)).w.y=p2.y and item(li(a)).w.p=0 and item(li(a)).w.s=0 then 
                        text=text & item(li(a)).desig & ". " 
                        'if show_all=1 then text=text &"("&item(li(a)).w.x &" "&item(li(a)).w.y &" "&item(li(a)).w.p &" "&localitem(a).w.s &" "&localitem(a).w.m &")"
                    endif
                next
                
                for a=1 to lastenemy
                    if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y and enemy(a).hpmax>0 then
                        if enemy(a).hp>0 then
                            if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y then
                                set__color( enemy(a).col,9)
                                text=text &" "& mondis(enemy(a)) '&"faction"&enemy(a).faction &"aggr" &enemy(a).aggr
                            else
                                set__color( enemy(a).col,0)
                            endif
                            if configflag(con_tiles)=0 then
                                put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),trans
                            else
                                draw string (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), chr(enemy(a).tile),,Font1,custom,@_col
                            endif
                        else
                            set__color( 12,0)
                            if configflag(con_tiles)=0 then
                                 put ((enemy(a).c.x-osx)*_tix,enemy(a).c.y*_tix),gtiles(261),trans
                            else
                                draw string (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), "%",,Font1,custom,@_col
                            endif
                            text=text & mondis(enemy(a)) 
                            if _debug=1 and _debug=1 then text=text &"("&a &" of "&lastenemy &")"
                        endif
                        exit for 'there won't be more than one monster on one tile
                    endif
                next
            endif
            if text<>"" then dprint text
            text=""
        endif
    loop until key=key__enter or key=key__esc or ucase(key)="Q" 
    return 0
end function

function ep_jumppackjump() as short
    dim as short a,b,d,slot
    slot=player.map
    awayteam.lastaction+=1
    if awayteam.jpfuel>2 then
        awayteam.jpfuel=awayteam.jpfuel-3
        if planets(slot).depth=0 or slot=specialplanet(9) or slot=specialplanet(4) or slot=specialplanet(3) then
            b=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
            dprint "Direction?"                
            d=getdirection(keyin())
            if d=4 then d=d+1
            if b<2 then b=2
            for a=1 to b 
                if rnd_range(1,6)+rnd_range(1,6)>7 then d=bestaltdir(d,rnd_range(0,1))
                dtile(awayteam.c.x,awayteam.c.y,tmap(awayteam.c.x,awayteam.c.y),1)
        
                awayteam.c=movepoint(awayteam.c,d)
                set__color( _teamcolor,0)
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
                sleep 50
            next
            awayteam.oxygen=awayteam.oxygen-5
            if rnd_range(1,6)+rnd_range(1,6)+planets(slot).grav>7 then
                dprint "Crash Landing! " &damawayteam(rnd_range(1,1+planets(slot).grav))
            else
                dprint "You land savely"
            endif
        else
            dprint "you hit the ceiling pretty fast! "&damawayteam(rnd_range(1,1+planets(slot).grav))
        endif
    else
        dprint "Not enough jetpack fuel"
    endif
    return 0
end function

function ep_crater(li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single) as short
    dim as short b,r,x,y,c
    dim as _cords p2,p1
    dim m(60,20) as short
    b=rnd_range(1,15)-countgasgiants(sysfrommap(player.landed.m))+countasteroidfields(sysfrommap(player.landed.m))
    b=b-planets(player.landed.m).atmos
    if b>0 then
        c=0
        dprint "A meteorite streaks across the sky and slams into the planets surface!",14
        do            
            c+=1
            r=5
            if rnd_range(1,100)<66 then r=3
            if rnd_range(1,100)<66 then r=2
            
            p2.x=player.landed.x
            p2.y=player.landed.y
            p1=rnd_point
            
            for x=0 to 60
                for y=0 to 20
                    m(x,y)=0
                    if tmap(x,y).walktru>0 then m(x,y)=1
                    p2.x=x
                    p2.y=y
                    if cint(distance(p2,p1))=r+1 then m(x,y)=0
                    if cint(distance(p2,p1))=r then m(x,y)=1
                next
            next
            flood_fill(player.landed.x,player.landed.y,m(),2)
        loop until m(awayteam.c.x,awayteam.c.y)=255 or c>=25
        if c=25 then return 0
        
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if cint(distance(p2,p1))=r+1 then
                    if planetmap(p2.x,p2.y,player.landed.m)<0 then planetmap(p2.x,p2.y,player.landed.m)=-4
                    if planetmap(p2.x,p2.y,player.landed.m)>0 then planetmap(p2.x,p2.y,player.landed.m)=4
                    tmap(p2.x,p2.y)=tiles(4)
                endif
                if cint(distance(p2,p1))=r then
                    if planetmap(p2.x,p2.y,player.landed.m)<0 then planetmap(p2.x,p2.y,player.landed.m)=-8
                    if planetmap(p2.x,p2.y,player.landed.m)>0 then planetmap(p2.x,p2.y,player.landed.m)=8
                    tmap(p2.x,p2.y)=tiles(8)
                endif
            next
        next
        
        sf=sf+1
        if sf>15 then sf=0
        shipfire(sf).when=1
        shipfire(sf).what=10+sf
        shipfire(sf).where=p1                
        player.weapons(shipfire(sf).what)=makeweapon(1)
        player.weapons(shipfire(sf).what).ammomax=1 'Sets set__color( to redish
        player.weapons(shipfire(sf).what).dam=r 'Sets set__color( to redish
        if rnd_range(1,100)<33+r then
            lastlocalitem=lastlocalitem+1
            lastitem=lastitem+1
            li(lastlocalitem)=lastitem
            item(lastitem)=makeitem(96,-3,b\3)
            item(lastitem).w.x=p1.x
            item(lastitem).w.y=p1.y
            item(lastitem).w.m=player.landed.m
            if rnd_range(1,100)<=2 then 
                planetmap(p1.x,p1.y,player.landed.m)=-191
                tmap(p1.x,p1.y)=tiles(191)
            endif
        endif
    else
        dprint "A meteor streaks across the sky"
    endif
    return 0 
end function
   

function ep_gives(awayteam as _monster,vismask() as byte, byref nextmap as _cords, shipfire() as _shipfire,enemy() as _monster,byref lastenemy as short,li() as short, byref lastlocalitem as short,spawnmask() as _cords,lsp as short,key as string, loctemp as single) as short
    dim as short a,b,c,d,e,r,sf,slot,st,debug
    dim as single fuelsell,fuelprice
    dim towed as _ship 
    dim as string text
    dim as _cords p,p1,p2
    awayteam.lastaction+=1
    slot=player.map
    if debug=1 and _debug=1 then dprint ""&tmap(awayteam.c.x,awayteam.c.y).gives
    st=nearest_base(player.c)
    fuelprice=round_nr(basis(st).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
    if fuelprice<1 then fuelprice=1
    if planets(slot).flags(26)=9 then fuelprice=fuelprice*3 
    fuelsell=fuelprice/2
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=1 then
        if specialplanet(1)=slot then specialflag(1)=1
        findartifact(0)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=2 then 
        dprint "'Ah great. Imagining people again are we?' the occupant of this bunker looks like he had a pretty bad time. 'No wait. You are real? I am not imagining you?' He explains to you that he managed to survive for months, alone, after the sandworms had demolished his ship, and eaten his crewmates." 
        if askyn("He is quite a good gunner and wants to join your crew. do you let him? (y/n)") then 
            add_member(2,6)
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=3 then
        dprint "The pirates are holding the executive in this ship!"
        if rnd_range(1,100)<55 then 
            dprint "He is still alive!",10
            player.questflag(2)=2
        else
            dprint "They killed him.",12
            player.questflag(2)=3
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives>=4 and tmap(awayteam.c.x,awayteam.c.y).gives<=8 then
        if tmap(awayteam.c.x,awayteam.c.y).gives<>8 then dprint "The local stock exchange."
        if tmap(awayteam.c.x,awayteam.c.y).gives=8 then dprint "The insect colonists are eager to trade."
        if slot<>pirateplanet(0) or faction(0).war(2)<=0 then
            if tmap(awayteam.c.x,awayteam.c.y).gives=7 and specialflag(20)=0 then
                for a=1 to 8
                    basis(8).inv(a).v=0
                next
            endif
            if tmap(awayteam.c.x,awayteam.c.y).gives=8 then
                for a=1 to 8
                    basis(9).inv(a).v=rnd_range(1,8-a)
                next
            endif
            if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 or player.turn-player.lastvisit.t>100 then
                change_prices(tmap(awayteam.c.x,awayteam.c.y).gives+1,(player.turn-player.lastvisit.t)\5)
            endif 
            trading(tmap(awayteam.c.x,awayteam.c.y).gives+1)
            player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
            player.lastvisit.t=player.turn
        else
            dprint "they dont want to trade with you."
        endif
    endif
    
    
    
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=12 then              
        dprint "you found some still working laser drills"
        player.stuff(5)=2
        placeitem(makeitem(15),0,0,0,0,-1)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=13 then
        dprint "The crew of this ship not only survived the crash landing, they opened a casino here!"
        if specialflag(11)=0 then              
            no_key=keyin
            b=casino(1)
            if b>0 then 
                if b>1000 then b=1100
                for a=0 to b step 100
                p1=movepoint(awayteam.c,5)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(23,slot)
                enemy(lastenemy)=setmonster(enemy(lastenemy),slot,spawnmask(),lsp,vismask(),p1.x,p1.y,lastenemy)
                next
                specialflag(11)=1
            endif
        else
            dprint "you are informed that you are barred from the casino."
        endif
    endif
    
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=15 then
        buysitems("This house is stuffed floor to ceiling with antiquities. Paintings, statues, furniture, jewelery, some is of earth origin, some clearly not.","Do you think you have anything to sell him?(y/n)",23)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=16 then
        buysitems("There was an explosion in the mine. A lot of the workers have been injured. The medical officer offers to buy any medical supplies you may have.","Do you want to sell your medpacks?",11,1.25)
        specialflag(13)=1
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=17 then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying weapons of any kind, especially without going through the hassle a purchase at one of the stations would cause.'","Do you want to sell weapons?",2,1.15,1)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=18 then
        buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying raw materials we can use to repair ships.'","Do you want to sell Resources?",15,0.95,1)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=19 then
        dprint "This is where the leaders of the planet meet. They express interest in high tech goods, and are willing to offer some automated gadgets they have been building." 
        dprint "They are actually very sophisticated! The technology of these creatures is behind that of humanity in term of energy generation mainly, but everything else they seem to be equal or even surpassing."
        if rnd_range(1,100)>planets(slot).flags(28) then
            if askyn ("Do you want to trade your tech goods for luxury goods?(y/n)") then
                b=0
                for a=0 to 9
                    if player.cargo(a).x=4 then
                        player.cargo(a).x=5
                        player.cargo(a).y=0
                        b=b+1
                    endif
                next
                if b=0 then dprint "You don't have any high tech goods to trade"
                if b>0 then dprint "You trade "& b &" tons of high tech goods for luxury goods."
                planets(slot).flags(28)+=b
                if planets(slot).flags(28)>=5 then
                
                    p.x=-1
                    p=rnd_point(slot,107)
                    if p.x>0 then
                        planets(slot).flags(28)-=5
                        planetmap(p.x,p.y,slot)=297
                        tmap(p.x,p.y)=tiles(297)
                    else
                        dprint "The leaders tell you that they managed to upgrade all factories on their planet"
                        specialflag(17)=1
                    endif
                endif
                no_key=keyin
            endif
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=26 then              
        dprint "A Weapons and Equipment store"
        if slot<>pirateplanet(0) or faction(0).war(2)<=0 then
            do
                cls
                display_ship
                if slot=pirateplanet(0) then
                    c=shop(5,0.8,"Equipment")   
                else
                    if slot=specialplanet(14) then
                        c=shop(6,0.9,"Equipment")
                    else
                        c=shop(4,0.9,"Equipment")
                    endif
                endif
            loop until c=-1
        else
            dprint "they dont want to trade with you"& faction(0).war(2)
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=27 then              
        dprint "A Bar"
        if slot=pirateplanet(0) then
            if faction(0).war(2)<=30 then
                if rnd_range(1,100)>10+crew(2).morale+add_talent(1,4,10) then
                    dprint "Pilot "&crew(2).n &" doesnt want to come out again.",14
                    crew(2)=crew(0)
                endif
                if rnd_range(1,100)>10+crew(3).morale+add_talent(1,4,10) then
                    dprint "Gunner "&crew(3).n &" reckons he can make a fortune playing darts and decides to stay.",14
                    crew(3)=crew(0)
                endif
                if rnd_range(1,100)>10+crew(4).morale+add_talent(1,4,10) then
                    dprint "Science Officer "&crew(4).n &" has discovered an unknown drink. He decides to make a new carreer in barkeeping to study it.",14
                    crew(4)=crew(0)
                endif
                if rnd_range(1,100)>10+crew(5).morale+add_talent(1,4,10) then
                    dprint "Doctor "&crew(5).n &" comes to the conclusion that he is needed more here than on your ship." ,14
                    crew(5)=crew(0)
                endif
            else
                dprint "they dont want to serve you"& faction(0).war(2)
            endif
        endif
        if slot<>pirateplanet(0) or faction(0).war(2)<=30 then 
            hiring(0,rnd_range(0,5),maximum(4,awayteam.hp))
            equip_awayteam(slot)
            if awayteam.oxygen<awayteam.oxymax then awayteam.oxygen=awayteam.oxymax
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=28 then              
        dprint "Spaceship fuel for sale"
        if planets(slot).flags(26)=9 then dprint "Due to a fuel shortage the price has been increased."
        if slot<>pirateplanet(0) or faction(0).war(2)<=0 then
            if askyn("Do you want to refuel (" &fuelprice &" Cr. per ton) and reload ammo? (y/n)") then refuel(planets(slot).flags(29),fuelprice)
        else
            dprint "they deny your request"& faction(0).war(2)
        endif
    endif
    
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=29 then              
        dprint "Ships Repair"
        if slot<>pirateplanet(0) or faction(0).war(2)<=20 then
            repair_hull(0.8)
        else
            dprint "they dont want to repair a ship they shot up themselves"& faction(0).war(2)
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=30 then              
        dprint Shipyardname(sy_pirates)
        if slot<>pirateplanet(0) or faction(0).war(2)<=20 then
            no_key=keyin
            if slot=pirateplanet(0) then
                shipupgrades(4)
            else
                shipupgrades(5)
            endif
        else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=31 then              
        dprint Shipyardname(sy_pirates)
        
        if slot<>pirateplanet(0) or faction(0).war(2)<=20 then
            no_key=keyin
            shipyard(sy_pirates)
        else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"& faction(0).war(2)
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=32 then  
        dprint "This is the Villa of the Pirate Leader."
        if faction(0).war(2)<=20 then
            
            
            reward_bountyquest(1)
            if questroll<25 or _debug=707 then give_bountyquest(1)
            if player.towed<>0 then
                towed=gethullspecs(drifting(player.towed).s,"data/ships.csv")
                a=towed.h_price
                if planets(drifting(player.towed).m).genozide<>1 then a=a/2
                a=cint(a)
                if askyn ("the pirate chief offers you "&a &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") then
                    drifting(player.towed)=drifting(lastdrifting)
                    lastdrifting-=1
                    addmoney(a,mt_piracy)
                    player.towed=0
                endif
            endif
            dprint "You sit down for some drinks and discuss your travels."
            planet_bounty()
            if askyn("Do you want to challenge him to a duel?(y/n)") then
                dprint "He accepts. The Anne Bonny launches and awaits you in orbit."
                no_key=keyin
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(1)
                spacecombat(fleet(lastfleet),3)
                if player.dead=0 then 
                    addmoney(100000,mt_piracy)
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=198
                else
                    player.dead=26
                endif
            endif
        else
            dprint "He does not want to talk to you"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=33 then specialflag(27)=1              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=34 then buy_weapon(1)              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=35 then shipyard(sy_blackmarket)              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=36 then
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            dprint "The captain of this scoutship says: 'Got any bio or mapdata? I can sell that stuff at the space station and offer to split the money 50:50"
            if askyn("Do you want to sell data(y/n)") then
                dprint "you transfer new map data on "&reward(0)&" km2. you get paid "&cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))&" credits"
                addmoney(cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2))),mt_map)
                reward(0)=0
                reward(7)=0
                dprint "you transfer data on alien lifeforms worth "& cint(reward(1)*.5*(1+0.1*crew(1).talents(2))) &" credits."
                addmoney(cint(reward(1)*.5*(1+0.1*crew(1).talents(2))),mt_bio)
                reward(1)=0
                for a=0 to lastitem
                    if item(a).ty=26 and item(a).w.s=-1 then item(a).v1=0
                next   
            endif
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=39 then
        'Food planet
        if player.questflag(25)=0 then
            if player.questflag(20)>0 then
                if player.questflag(20)=1 then dprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrower."
                if player.questflag(20)>1 then dprint "The colonists pay you "&player.questflag(20)*10 &" Cr. for the killed burrowers."
                addmoney(player.questflag(20)*10,mt_trading)
                player.questflag(20)=0
            endif    
            
            if findbest(87,-1)>0 then
                if askyn("The colonists would buy the burrowers eggsacks for 50 Credits a piece. Do you want to sell?(y/n)") then
                    for a=0 to lastitem
                        if item(a).ty=87 and item(a).w.s=-1 then 
                            destroyitem(a)
                            addmoney(50,mt_bio)
                        endif
                    next
                endif
            endif
        else
            if player.questflag(25)=1 then
                player.questflag(25)=2
                dprint "The colonists leader accepts the burrowers terms. They offer you 1000 Cr. for your help in negotiating a peace"
                addmoney(1000,mt_quest2)
            endif
        endif
        if askyn("Do you want to trade with the colonists?(y/n)") then
            if player.questflag(25)=0 then
                basis(9).inv(1).v=10
                basis(9).inv(1).p=10
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                for a=2 to 8
                    basis(9).inv(a).v=0
                next
            else
                basis(9).inv(1).v=5
                basis(9).inv(1).p=15
                basis(9).inv(2).p=100
                basis(9).inv(3).p=300
                for a=2 to 8
                    basis(9).inv(a).v=0
                next
            endif
            trading(9)
        endif
       
    endif
        
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=40 then
        dprint "A nagging feeling in the back of your head you had since you landed on this planet suddenly dissapears."
        specialflag(20)=1
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=41 then
        dprint "A nagging feeling in the back of your head you had since you entered this ship suddenly dissapears."
        player.questflag(11)=2
    endif
    
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=42 then              
        if slot<>pirateplanet(0) or faction(0).war(2)<=0 then
            if askyn("This shop offers hullrefits, turning 5 crew bunks into an additional cargo hold for 1000 Cr. Do you want your ship modified?(y/n)") then
                if paystuff(1000) then pirateupgrade
            endif
        else
            dprint "they dont want to repair a ship they are going to shoot up themselves."
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=43 then
        player.disease=sick_bay(1)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=44 then
        if planets(slot).mon_killed(1)=0 then
            if askyn("Do you want to fight in the arena? (y/n)") then
                planets(slot).depth=0
                enemy(1)=makemonster(2,slot)
                enemy(1)=setmonster(enemy(1),slot,spawnmask(),lsp,vismask(),awayteam.c.x+3,awayteam.c.y,1)
                enemy(1).slot=1
                planets(slot).plantsfound=(enemy(1).hpmax^2+enemy(1).armor+enemy(1).weapon+rnd_range(1,2))*10
            
                planets(slot).depth=1
                
                for x=awayteam.c.x+1 to awayteam.c.x+5
                    for y=awayteam.c.y-2 to awayteam.c.y+2
                        if rnd_range(1,100)<66 then
                            planetmap(x,y,slot)=rnd_range(2,4)
                        else
                            planetmap(x,y,slot)=rnd_range(1,7)
                        endif
                        tmap(x,y)=tiles(planetmap(x,y,slot))
                    next
                next
            endif
            if askyn("Do you want to sell your aliens as arena contestants?(y/n)") then
                sell_alien(slse_arena)
            endif
            
        else
            addmoney(planets(slot).plantsfound,mt_gambling)
            dprint "You get "& planets(slot).plantsfound &" Cr. for the fight.",10
            planets(slot).mon_killed(1)=0
            planets(slot).plantsfound=0
            for x=awayteam.c.x+1 to awayteam.c.x+5
                for y=awayteam.c.y-2 to awayteam.c.y+2
                    planetmap(x,y,slot)=4
                    tmap(x,y)=tiles(planetmap(x,y,slot))
                next
            next
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=45 then casino(,-1)
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=46 then
        sell_alien(slse_zoo)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=47 then retirement()
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=48 then buytitle()
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=49 then customize_item()
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=50 then
        if planets(slot).flags(26)=1 then dprint "The admin informs you that there is a alien lifeform lose on the station, and advises you to stay clear of dark corners."
        if planets(slot).flags(26)=4 then dprint "The admin informs you that there is a mushroom infestation on the station, and that he pays 50 credits for each dead one."
        if planets(slot).flags(26)=5 then dprint "The admin informs you that the station is under attack from pirates"
        if planets(slot).flags(26)=6 then dprint "The admin informs you that the station has been hit by an asteroid and is currently leaking. He apologizes for the inconvenience."
        if planets(slot).flags(26)=9 then dprint "The admin informs you that there is a fuel shortage and the prices have been increased to "&fuelprice &" for buying and 5 Cr. a ton for selling"
        if planets(slot).flags(26)=10 then dprint "The admin is very excited: There is a party of civilized aliens on board!"
        if planets(slot).flags(26)=12 then dprint "The admin informs you that there is a tribble infestation on the station, and that he pays 10 credits for each dead one."
        for a=1 to lastenemy
            if enemy(a).hp<=0 then
                if enemy(a).made=2 then planets(slot).flags(26)=2
                if enemy(a).made=7 then planets(slot).flags(27)+=1
                if enemy(a).made=34 then planets(slot).flags(27)+=1
                if enemy(a).made=101 then planets(slot).flags(27)+=1
                enemy(a)=enemy(lastenemy)
                lastenemy-=1
            endif
        next
        if planets(slot).flags(26)=2 then
            planets(slot).flags(26)=3 
            player.money=player.money=100
            dprint "The Admininstrator thanks you for dispatching the beast, and gives you 100 Cr."
        endif
        if planets(slot).flags(27)>0 and planets(slot).flags(26)=4 then
            dprint "You get "&50*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(50*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        endif
        if planets(slot).flags(27)>0 and planets(slot).flags(26)=5 then
            dprint "'Thanks for helping to fight back the pirates' You get "&250*planets(slot).flags(27) &" Cr. for the destroyed mushrooms."
            addmoney(250*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        endif
        
        if planets(slot).flags(27)>0 and planets(slot).flags(26)=12 then
            dprint "You get "&10*planets(slot).flags(27) &" Cr. for the killed tribbles."
            addmoney(10*planets(slot).flags(27),mt_quest2)
            planets(slot).flags(27)=0
        endif
        
        if askyn("Do you want to sell fuel for " &fuelsell &" Credits per ton? (y/n)") then
            if getinvbytype(9)>0 then
                if askyn( "Do you want to sell fuel stored in your cargo hold?") then
                    dprint "How much fuel do you want to sell?"
                    a=getnumber(0,getinvbytype(9),0)
                    addmoney(int(a*30*fuelsell),mt_trading)
                    removeinvbytype(9,a)
                    if planets(slot).flags(26)=9 then
                        if rnd_range(1,100)<planets(slot).flags(27) then planets(slot).flags(26)=0
                    endif
                    dprint "You sell "&30*a &" tons of fuel for "& int(30*a*fuelsell) &" Cr."
                endif
            endif
            dprint "How much fuel do you want to sell? (" &player.fuel &")"
            a=getnumber(0,player.fuel,0)
            if a>0 then
                player.fuel=player.fuel-a
                addmoney(int(a*fuelsell),mt_trading)
                if planets(slot).flags(26)=9 then
                    if rnd_range(1,100)<planets(slot).flags(27) then planets(slot).flags(26)=0
                endif
                dprint "You sell "&a &" tons of fuel for "& int(a*fuelsell) &" Cr."
            endif
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=51 then
        dprint tmap(awayteam.c.x,awayteam.c.y).hitt
        for a=0 to lastenemy
            if enemy(a).made<>73 then enemy(a).aggr=0
        next
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=55 then
        if askyn("A tank full of processed ship fuel. Do you want to use it?(y/n)") then 
            player.fuel=player.fuelmax+player.fuelpod
            dprint "You refuel your ship."
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=56 then
        if askyn("Do you want to repair it?(y/n)") then
            if skill_test(player.science(location),st_average,"Repair") then
                if skill_test(player.science(location),st_average,"Repair") then
                    dprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=232
                    planets(slot).atmos=5
                else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=231
                    dprint "You fail."
                endif
            else
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=233
                dprint "You destroy the console in your attempt to repair it."
            endif
                
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=57 then 'repairing reactor
        if askyn("Do you want to repair it?(y/n)") then
            if skill_test(player.science(location),st_average,"Repair") then
                if skill_test(player.science(location),st_average,"Repair") then
                    dprint "You succeed!"
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=235
                    specialflag(31)=1
                    'hide map
                    'put station 3 in positon
                endif
            else 
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=236
                dprint "You destroy the console in your attempt to repair it."
            endif
            if tmap(awayteam.c.x,awayteam.c.y).turnsinto=234 then dprint "You fail."
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=58 then 'shutting down reactor
        if askyn("Do you want to shut it down? (y/n)") then
            for x=0 to 60
                for y=0 to 20
                    if planetmap(x,y,specialplanet(9))=-18 then planetmap(x,y,specialplanet(9))=-4 
                    if planetmap(x,y,specialplanet(9))=18 then planetmap(x,y,specialplanet(9))=4
                next
            next
            if not(skill_test(player.science(location),st_easy)) then
                dprint "Something went wrong... this thing is about to blow up!"
                sf=sf+1
                if sf>15 then sf=0
                shipfire(sf).where=awayteam.c
                shipfire(sf).when=3
                shipfire(sf).what=10+sf
                player.weapons(shipfire(sf).what)=makeweapon(rnd_range(1,5))
                sf=sf+1 'Sets set__color( to blueish
            endif
        endif
    endif
            if tmap(awayteam.c.x,awayteam.c.y).gives=59 then 'Scrapyard
                botsanddrones_shop
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=60 then 'Town hall in settlements
                if askyn("Do you want to trade with the locals?(y/n)") then 
                    '
                    ' Trading
                    '
                    for a=11 to 13
                        if planets(slot).flags(a)<0 then 
                            c=int(baseprice(a-10)*(rnd_range(1,2)+abs(planets(slot).flags(a))))
                            if a=11 then text="The colonists are in dire need of food. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            if a=12 then text="The colonists are in dire need of basic goods. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            if a=13 then text="The colonists are in dire need of tech goods. They are willing to pay "&c &" per ton.Do you want to sell? (y/n)"
                            if getinvbytype(a-10)>0 then
                                if askyn(text) then
                                    for b=1 to player.h_maxcargo
                                        if player.cargo(b).x=a-9 then
                                            dprint "You sell a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                            player.cargo(b).x=1
                                            addmoney(c,mt_trading)
                                            planets(slot).flags(a)=0
                                        endif
                                    next
                                endif
                            endif
                        elseif planets(slot).flags(a)>0 then
                            c=int(baseprice(a-10)/(rnd_range(1,2)+abs(planets(slot).flags(a))))
                            if a=11 then text="The colonists have a surplus of food. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=12 then text="The colonists have a surplus of basic goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=13 then text="The colonists have a surplus of tech goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if askyn(text) then
                                d=getnextfreebay()
                                if d>0 then
                                    if paystuff(c) then
                                        dprint "You buy a ton of "& goodsname(a-10) &" for "& c &" Cr."
                                        player.cargo(d).x=a-9
                                        player.cargo(d).y=c
                                        planets(slot).flags(a)=0
                                    else
                                        dprint "You don't have enough money."
                                    endif
                                else
                                    dprint "You don't have enough room."
                                endif
                            endif
                        endif
                    next
                    if planets(slot).flags(14)>0 then
                        if askyn("The colonists have some equipment they no longer need. Do you want to look at it?(y/n)") then shop(planets(slot).flags(14),.75,"Equipment for sale")
                    endif
                    for a=15 to 20
                        if planets(slot).flags(a)>0 then
                            'selling equipment
                            text=""
                            if planets(slot).flags(a)=1 then text="They need jetpacks and hoverplatforms. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=2 then text="They need long range weapons. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=3 then text="They need armor. They are offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=4 then text="They need melee weapons. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=5 then text="They need mining equipment. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=11 then text="They need medical supplies. They offer to pay 150% of station prices. "
                            if text<>"" then buysitems(text,"Do you want to sell?(y/n)",planets(slot).flags(a),1.5)
                        endif
                    next
                endif
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=61 then
                dprint "This computer contains files detailing how eridiani explorations uses the plants on this planet to produce a powerfull halluzinogenic drug, and smuggles it onto space stations. If this information went public it could seriously harm their business."
                player.questflag(21)=1
            endif

            if tmap(awayteam.c.x,awayteam.c.y).gives=62 then
                dprint "This computer runs a database, containing all the 'workers' in this complex. They all were 'convicted' for violating Smith Heavy Industries company policies, and have to work off their fine here. There is an alarmingly high number of 'work related accidents' Money paid for food for the workers is on the other hand alarmingly low. No wonder SHI doesn't advertise about this place."
                player.questflag(22)=1
            endif

            if tmap(awayteam.c.x,awayteam.c.y).gives=63 then                
                x=player.c.x-basis(0).c.x/2
                y=player.c.y-basis(0).c.y/2
                x=basis(0).c.x+x
                y=basis(0).c.y+y
                if player.questflag(23)=0 then
                    lastdrifting=lastdrifting+1
                    if lastdrifting>128  then lastdrifting=128
                    
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
                endif
                player.questflag(23)=1
                dprint "At this terminal the routes of a big number of freelance traders are displayed. Triax Traders Ships are specially marked. Also the pirates are supposed to rendezvous with a ship at "&x &":"&y &" at regulare intervals."
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=64 then                
                player.questflag(23)=2
                dprint "This computer details the plan that Triax Traders is sponsoring Pirates."
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=65 then                
                player.questflag(24)=1
                dprint "Here are detailed experiments by Omega Bionegineering to breed crystal/human hybrids. They buy 'Volunteers' from a pirate captain. If this gets public it would break their neck."
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=66 then                
                mudds_shop
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=67 then
                buysitems("We buy all pieces of art you may 'find'.","Do you think you have anything to sell?(y/n)",23,.25)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=68 then
                dprint "The center of this temple contains a forcefield. In it is a beautiful, 3m tall woman, with long black hair, wearing a white robe.",15
                if askyn("A generator seems to provide the energy for the forcefield, do you want to try to turn it off?(y/n)") then
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=297
                    dprint "You manage to switch it off"
                    no_key=keyin
                    dprint "As soon as the forcefield collapses the figure flies up through the cieling of the temple, shattering it.",15
                    lastfleet+=1
                    fleet(lastfleet).c=player.c
                    fleet(lastfleet).ty=10
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=57
                else
                    dprint "She looks at you pleading, and pointing at the generator."
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=296
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=69 then sell_alien(slse_zoo)
            
            if tmap(awayteam.c.x,awayteam.c.y).gives>=70 and tmap(awayteam.c.x,awayteam.c.y).gives<=73 then
                if planets(slot).colflag(0)=0 then
                    basis(10)=makecorp(tmap(awayteam.c.x,awayteam.c.y).no-298)
                else
                    basis(10)=makecorp(planets(slot).colflag(0))
                    planets(slot).colflag(1)+=reward(0)/10
                    planets(slot).colflag(1)+=reward(1)/10
                    planets(slot).colflag(1)+=reward(2)/10
                    planets(slot).colflag(1)+=reward(3)/10
                    planets(slot).colflag(1)+=reward(4)/10
                    planets(slot).colflag(1)+=reward(5)/10
                    planets(slot).colflag(1)+=reward(6)/10
                    planets(slot).colflag(1)+=reward(7)/10
                endif
                basis(10).mapmod=basis(10).mapmod*0.75
                basis(10).biomod=basis(10).biomod*0.75
                basis(10).resmod=basis(10).resmod*0.75
                basis(10).pirmod=basis(10).pirmod*0.75
                company(10)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=74 then sell_alien(slse_slaves)
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=75 then used_ships
            
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=167 then
                if askyn("A working security camera terminal. Do you want to try to use it?(y/n)") then
                    if skill_test(player.science(location),st_average) then
                        p1=awayteam.c
                        awayteam.c=rnd_point(slot,0)
                        dprint "You manage to access a camera at "&awayteam.c.x &":" &awayteam.c.y &"."
                        do 
                            make_vismask(vismask(),awayteam.c,awayteam.sight,slot)
                            display_planetmap(slot,awayteam.c.x-_mwx/2,0)
                            ep_display (vismask(),enemy(),lastenemy,li(),lastlocalitem)
                            display_awayteam()
                            dprint ""
                            no_key=keyin
                            p2=movepoint(awayteam.c,getdirection(no_key))
                            if tmap(p2.x,p2.y).walktru=0 then awayteam.c=p2
                        loop until no_key=key__esc or not(skill_test(player.science(location),st_easy))
                        awayteam.c=p1
                    else
                        dprint "You do not get it to work properly."
                        if not(skill_test(player.science(location),11)) then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=168 then
                if askyn("A switched off security robot. Do you want to try and reprogram it and turn it on again?(y/n)") then
                    if skill_test(player.science(location),st_veryhard,"Repair") then
                        dprint "You manage!"
                        if get_freecrewslot>-1 then
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            add_member(13,0)
                        else
                            dprint "But you don't have enough room on your ship for the robot."
                        endif
                    else
                        if skill_test(player.science(location),st_average) then
                            'Failure
                            dprint "This robot is beyond repair"
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
            
                        else
                            'Catastrophic Failure
                            dprint "You manage to switch it on but not to reprogram it!",c_red
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=80
                            lastenemy+=1
                            enemy(lastenemy)=setmonster(makemonster(9,slot),slot,spawnmask(),lsp,vismask(),awayteam.c.x,awayteam.c.y)
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=169 then
                if askyn("A working security terminal. Do you want to try to use it?(y/n)") then
                    if skill_test(player.science(location),st_average) then
                        if skill_test(player.science(location),st_hard) then
                            dprint "You manage to shut down the traps on this level."
                            for x=0 to 60
                                for y=0 to 20
                                    if tmap(x,y).tohit<>0 then 
                                        tmap(x,y).tohit=0
                                        tmap(x,y).dam=0
                                        tmap(x,y).hitt=""
                                    endif
                                next
                            next
                        else
                            dprint "You manage to shut down some of the traps on this level."
                            for x=0 to 60
                                for y=0 to 20
                                    if skill_test(player.science(location),st_veryhard) and tmap(x,y).tohit<>0 then
                                        tmap(x,y).tohit=0
                                        tmap(x,y).hitt=""
                                    endif
                                next
                            next
                        endif
                    else
                        dprint "You do not get it to work properly."
                        if not(skill_test(player.science(1),11)) then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=170 then
                if askyn("A working security terminal. Do you want to try to use it?(y/n)") then
                    if skill_test(player.science(location),st_hard) then
                        dprint "You manage to reveal hidden doors on this level."
                        for x=0 to 60
                            for y=0 to 20
                                if tmap(x,y).turnsoninspect=54 then 
                                    planetmap(x,y,slot)=tmap(x,y).turnsoninspect
                                    tmap(x,y)=tiles(tmap(x,y).turnsoninspect)
                                endif
                            next
                        next
                    else
                        dprint "You do not get it to work properly."
                        if not(skill_test(player.science(location),st_easy)) then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=171 then
                if askyn("A working security terminal. Do you want to try to use it?(y/n)") then
                    if skill_test(player.science(location),st_average) then
                        dprint "You get it to display a map of this complex."
                        for x=0 to 60
                            for y=0 to 20
                                if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                            next
                        next
                    else
                        dprint "You do not get it to work properly."
                        if not(skill_test(player.science(location),st_easy)) then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=172 then
                if askyn("A working computer terminal. Do you want to try to use it?(y/n)") then
                    if skill_test(player.science(location),st_veryhard) then
                        dprint "It's a database on the technology of the ancient aliens."
                        if reward(4)>0 then
                            reward(4)-=1
                            findartifact(0)
                        else
                            dprint "Unfortunately you do not have any technology of the ancient aliens."
                        endif
                    else
                        dprint "You do not get it to work properly."
                        if not(skill_test(player.science(location),st_hard)) then
                            dprint "Actually you manged to break it completely."
                            tmap(awayteam.c.x,awayteam.c.y).turnsinto=84
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=111 then
                dprint "This is a data collection about all the 'enhanced pets' of the ancient aliens. They used the tree beings as scientific advisors, and made a silicium based lifeform they were somehow able to use as a powersource. It doesn't really go into detail about that. Also missing is any information on the aliens themselves."
                player.questflag(1)=1
            endif
            
            b=0
            if tmap(awayteam.c.x,awayteam.c.y).gives=205 then
                'Just don't land here
            endif
            if tmap(awayteam.c.x,awayteam.c.y).gives=206 then
                if planets(slot).flags(3)>0 then
                    if askyn("A grade "&planets(slot).flags(3) &" engine. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(3)<player.engine then
                            dprint "You already have a better engine than this."
                        else
                            if planets(slot).flags(3)<=player.h_maxengine or planets(slot).flags(3)=6 then
                                player.engine=planets(slot).flags(3)
                                planets(slot).flags(3)=0
                                b=1
                                if player.engine=6 then artflag(6)=1
                            else
                                dprint "This engine is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty engine case."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=207 then
                if planets(slot).flags(4)>0 then
                    if askyn("A grade "&planets(slot).flags(4) &" sensor suite. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(4)<player.sensors then
                            dprint "You already have a better sensors than this."
                        else
                            if planets(slot).flags(4)<=player.h_maxsensors or planets(slot).flags(4)=6 then
                                player.sensors=planets(slot).flags(4)
                                planets(slot).flags(4)=0
                                b=1
                                if player.sensors=6 then artflag(7)=1
                            else
                                dprint "This sensor array is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty sensor case."
                endif
            endif

            if tmap(awayteam.c.x,awayteam.c.y).gives=208 then
                if planets(slot).flags(5)>0 then
                    if askyn("A grade "&planets(slot).flags(5) &" shield generator. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(5)<player.shieldmax then
                            dprint "You already have a better shields than this."
                        else
                            if planets(slot).flags(5)<=player.h_maxshield then
                                player.shieldmax=planets(slot).flags(5)
                                planets(slot).flags(5)=0
                                b=1
                            else
                                dprint "This shield generator is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty shield generator case."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=210 then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-209
                dprint c & " " & planets(slot).flags(c)
                if planets(slot).flags(c+6)=0 then
                    dprint "An empty weapons turret."
                else
                    if askyn(add_a_or_an((planets(slot).weapon(c)).desig,1) &". Do you want to transfer it to your ship?(y/n)") then
                        d=player.h_maxweaponslot
                        text="Weapon Slot/"
                        for a=1 to d
                            if player.weapons(a).desig="" then
                                text=text & "-Empty-/"
                            else
                                text=text & player.weapons(a).desig & "/"
                            endif
                        next
                        text=text+"Exit"
                        d=d+1            
                        e=menu(bg_awayteam,text)
                        if e<d then
                            player.weapons(e)=(planets(slot).weapon(c))
                            b=1
                            planets(slot).flags(c)=0
                            recalcshipsbays
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=211 then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203
                if planets(slot).flags(c)>1 then
                    if planets(slot).flags(c)=2 then text="Food"
                    if planets(slot).flags(c)=3 then text="Basic goods"
                    if planets(slot).flags(c)=4 then text="Tech goods"
                    if planets(slot).flags(c)=5 then text="Luxury goods"
                    if planets(slot).flags(c)=6 then text="Weapons"
                    if askyn("A cargo crate with "& text &". Do you want to transfer it to your ship?(y/n)") then
                        for a=1 to 10
                            if player.cargo(a).x=1 and b=0 then
                                b=1
                                player.cargo(a).x=planets(slot).flags(c)
                                planets(slot).flags(c)=0
                            endif
                            if b=0 then dprint "Your cargo hold is full."
                        next
                    endif
                else
                    dprint "An empty cargo crate"
                endif
                if planets(slot).flags(26)=8 then b=0 'Small spacestation abandoned cargo
            endif
            
            if b>0 then 
                for a=0 to lastenemy
                    if enemy(a).hp>0 then 
                        enemy(a).aggr=0
                    endif
                next
                if planets(slot).atmos>1 then dprint "You hear alarm sirens!",14
                if planets(slot).atmos=1 then dprint "You see a red alert light flashing!",14
            endif
            
            for a=1 to lastdrifting
                if slot=drifting(a).m then c=drifting(a).s
            next
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=220 then
                textbox(shiptypes(planets(slot).flags(1)) &" | | " &makehullbox(planets(slot).flags(1),"data/ships.csv"),3,5,25)
                if askyn("The bridge. Do you want to abandon your ship and take over this one?(y/n)") then
                    b=0
                    for a=0 to lastenemy
                        if enemy(a).hp>0 then 
                            enemy(a).aggr=1
                            b=b+1
                        endif
                    next
                    if b=0 then
                        if upgradehull(planets(slot).flags(1),player)=-1 then
                            player.hull=planets(slot).flags(2)
                            planets(slot).flags(0)=1
                            nextmap.m=-1
                            if player.hull<1 then player.hull=1
                            dprint "You take over the ship."
                            key=key_north
                            walking=1
                            'Weapons...
                            poolandtransferweapons(player,planetflags_toship(slot))
                            
                            if planets(slot).flags(3)>player.engine then player.engine=planets(slot).flags(3) 
                            if planets(slot).flags(4)>player.sensors then player.sensors=planets(slot).flags(4) 
                            if planets(slot).flags(5)>player.shieldmax then player.shieldmax=planets(slot).flags(5) 
                            recalcshipsbays
                            if player.landed.m<>slot then
                                for c=0 to lastportal
                                    if portal(c).from.m=slot or portal(c).dest.m=slot then
                                        player.landed=portal(c).from
                                        nextmap=portal(c).from
                                        deleteportal(portal(c).from.m,portal(c).dest.m)
                                        deleteportal(portal(c).dest.m,portal(c).from.m)
                                    endif
                                next
                            endif
                        endif
                    else
                        dprint "You better make sure this ship is really abandoned before moving in.",14
                    endif
                endif
            endif
            
            '
            ' Alien Civs
            '
            if tmap(awayteam.c.x,awayteam.c.y).gives=301 then
                if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 then
                    change_prices(11,(player.turn-player.lastvisit.t)\5)
                endif 
                trading(11)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,6,-5)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=302 then
                if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 then
                    change_prices(12,(player.turn-player.lastvisit.t)\5)
                endif 
                trading(12)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,7,-5)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=311 then
                if civ(0).phil=1 then dprint "This is the house where the "&civ(0).n & "council meets."
                if civ(0).phil=2 then dprint "This is the "&civ(0).n &" parliament" 
                if civ(0).phil=3 then dprint "This is the "&civ(0).n &" leaders home"
                foreignpolicy(0,0)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=312 then
                if civ(0).phil=1 then dprint "This is the house where the "&civ(1).n & "council meets."
                if civ(0).phil=2 then dprint "This is the "&civ(1).n &" parliament" 
                if civ(0).phil=3 then dprint "This is the "&civ(1).n &" leaders home"
                foreignpolicy(1,0)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=321 then
                dprint add_a_or_an(civ(0).n,1) &" shop"
                if faction(0).war(6)<50 then
                    shop(26,1,civ(0).n &" shop")
                else
                    dprint "They don't want to trade with you"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=322 then
                dprint add_a_or_an(civ(1).n,1) &" shop"
                if faction(0).war(7)<50 then
                    shop(27,1,civ(1).n &" shop")
                else
                    dprint "They don't want to trade with you"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=330 then
                buysitems("They are very interested in buying living creatures for the Zoo."," Do you want to sell?(y/n)",26,8,0)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=401 then
                dprint "Population:"&planets(slot).colonystats(0) &" Food:"&planets(slot).colonystats(10)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=886 then
                if askyn("Do you want to install the cryo chamber on your ship?(y/n)") then
                    player.cryo=player.cryo+1
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=202
                else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=tmap(awayteam.c.x,awayteam.c.y).no
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=887 then
                dprint "With the forcefield down it is easy to remove the disintegrator canon"
                artifact(4)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=888 then
                dprint "This computer controls the planetary defense system."
                no_key=keyin
                dprint "Your science officer manages to disable it!"
                no_key=keyin
                specialflag(2)=2
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=999 then
                dprint "This terminal displays information on the status of this sector. The computer is obviously interpreting the human presence as an invasion!"
                no_key=keyin
                dprint "The spaceships are being made ready to repell the invaders!"
                no_key=keyin
                dprint "Your science officer tries to reprogram the computer"
                no_key=keyin
                dprint "He succeeds! you can now use the robot ships to explore this sector and beyond without risking human life!"
                player.questflag(3)=1
                no_key=keyin
            endif
        
        if tmap(awayteam.c.x,awayteam.c.y).survivors>rnd_range(1,44) then
            dprint "you have found a crashed spaceship!"
            no_key=keyin
            dprint "there are survivors! You offer to take them to the space station."
            b=rnd_range(1,6) +rnd_range(1,6)-3
            no_key=keyin
            if b>0 then
                if askyn( b &" security personel want to join your crew. (y/n)") then 
                    if b>max_security then b=max_security
                    for a=1 to b
                        add_member(8,0)
                    next
                endif
            endif
            b=rnd_range(5,7)
            if b>6 then b=6
            c=rnd_range(1,100)
            if c<33 then 
                if askyn("a pilot, skillevel " & b & " wants to join you. (y/n)") then 
                    add_member(2,b)
                endif
            endif
            if c>32 and c<66 then 
                if askyn("a gunner, skillevel " & b & " wants to join you. (y/n)") then 
                    add_member(3,b)
                endif
            endif
            if c>65 then 
                if askyn("a science officer, skillevel " & b & " wants to join you. (y/n)") then 
                    add_member(4,b)
                endif
            endif
            planetmap(awayteam.c.x,awayteam.c.y,slot)=62 
        endif
    
    if tmap(awayteam.c.x,awayteam.c.y).resources>rnd_range(1,100) then
        dprint "you plunder the resources of the ship and move on."
        for a=0 to 2
            reward(a)=reward(a)+rnd_range(10,50)+rnd_range(10,50)+500
        next
        planetmap(awayteam.c.x,awayteam.c.y,slot)=62
    endif
    
    if planetmap(awayteam.c.x,awayteam.c.y,slot)=17 then
        walking=0
        if skill_test(player.science(location),st_hard) then
            dprint "you find an ancient computer, your Science officer manages to get map data out of it!"
            reward(5)=3
        else
            dprint "you find an ancient computer, but you cant get it to work"
        endif
        planetmap(awayteam.c.x,awayteam.c.y,slot)=16            
    endif
    
    tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).turnsinto)
    planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).no
    return 0
end function
