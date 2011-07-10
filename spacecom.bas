
function spacecombat(defender as _ship, byref atts as _fleet,ter as short) as _ship
    dim attacker(16) as _ship
    dim targets(15) as _ship
    dim direction(15) as byte
    dim dontgothere(15) as byte
    dim speed(15) as short
    dim tick(15) as single
    dim tickr(15) as single
    dim as byte manjetson
    dim lastaction(15) as short
    dim movementcost(15) as short
    dim col as short
    dim st as integer
    dim senac as short
    dim nexsen as short
    dim senbat as short
    dim senbat1 as short
    dim senbat2 as short
    dim a as short
    dim b as short
    dim c as short
    dim f as short
    dim e as short
    dim as short tic,t,w
    dim lastenemy as short
    dim target as short
    dim lasttarget as short
    dim x as short
    dim y as short
    dim key as string
    dim rangestr as string
    dim range as short
    dim p as _cords
    dim p1 as _cords
    dim roll as short
    dim victory as short
    dim astring as string
    dim shieldshut as short
    dim text as string
    dim e_track_p(128) as _cords
    dim e_track_v(128) as short
    dim e_last as short
    dim as short noenemies
    dim mines_p(128) as _cords
    dim mines_v(128) as short
    dim mines_last as short
    dim as byte localturn
    dim old as _cords
    dim as byte debug=0
    for x=0 to 60
        for y=0 to 20
            combatmap(x,y)=0
            if rnd_range(1,100)<ter then 
                combatmap(x,y)=rnd_range(1,5)
                if ter=10 then combatmap(x,y)=6 'Asteroid field 
                if ter=11 then combatmap(x,y)=7 'Gas giant
            endif
            if rnd_range(1,100)<3 and rnd_range(1,100)<3 then
                combatmap(x,y)=rnd_range(1,7)
            endif
        next
    next
    victory=0
    col=12
    
    b=0
    for a=1 to 15
        if atts.mem(a).hull>0 then
            b+=1
            noenemies+=1
            lastenemy=lastenemy+1
            attacker(b)=atts.mem(a)
            attacker(b).di=rnd_range(1,8)
            if attacker(b).di=5 then attacker(b).di=9
            if attacker(b).shiptype=1 then 'Merchantman exit target
                col=10 'all green now
                attacker(b).target.x=0
                attacker(B).target.y=rnd_range(1,20)
            endif
        endif
    next
    p=defender.c
    defender.dead=-1
    defender.c.x=30
    defender.c.y=10
    senac=1
    senbat=defender.sensors+2
    senbat1=defender.sensors+1
    senbat2=defender.sensors
    if attacker(1).shiptype=2 then defender.c.x=0
    cls
    player=defender
    displayship(0)
    do
        if com_log=1 then
            f=freefile
            open "combatlog.txt" for append as #f
            key=""
            for a=0 to lastenemy
                key=key &lastaction(a)&":"
            next
            print #f,key
            close #f
            key=""
        endif
        nexsen=senac
        'movement
        movementcost(0)=defender.engine+2-cint(defender.h_maxhull\15)+defender.manjets*(1+manjetson)
        if movementcost(0)<1 then movementcost(0)=1
        lastaction(0)-=1
        speed(0)=speed(0)+defender.engine+2-cint(defender.h_maxhull\15)+defender.manjets
        if speed(0)<1 then speed(0)=1
        st=speed(0)
        for a=1 to lastenemy
            movementcost(a)=10-attacker(a).engine
            lastaction(a)-=1
            speed(a)=speed(a)+attacker(a).engine
            if attacker(a).c.x=attacker(a+1).c.x and attacker(a).c.y=attacker(a+1).c.y  then attacker(a).c=movepoint(attacker(a).c,5)
            if st<speed(a) then st=speed(a)
        next
        
        for a=0 to lastenemy
            tickr(a)=10/speed(a)
            tick(a)=0
        next
        player=defender
        screenset 0,1
        cls
        displayship(0)
        com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
   '
            key=""
            if lastaction(0)<=0 and defender.hull>0 then 'playermovement
                
                f=0
                for e=1 to lastenemy
                    if distance(attacker(e).c,defender.c)<senbat*senac then f=f+1
                next
                for e=1 to mines_last
                    if distance(mines_p(e),defender.c)<senbat*senac then f=f+1
                next
                if defender.c.x=0 or defender.c.y=0 or defender.c.x=60 or defender.c.y=20 then f=-1
                if f<>0 then dprint key_fi &" to fire weapons, "&key_dr &" to drop mines, "&key_sc &" to scan enemy ships, "&key_ru & " to run and flee."
                    
                'color 11,0
                'draw string(62*_fw1,5*_fh2), "Engine :"&player.engine &" ("&speed(0) &" MP)",,Font2,custom,@_col
    
                key=keyin("1234678"&key_ac &key_sh &key_sc &key_ru &key_esc &key_dr &key_fi &key_sh &key_ru &key_togglemanjets &key_cheat)
                if key=key_ac then
                    if senac=2 then nexsen=1
                    if senac=1 then nexsen=2
                endif
                
                if key=key_cheat then com_cheat=1
                
                if key=key_togglemanjets then
                    if defender.manjets=0 then 
                        dprint "you have no manjets"
                    else
                        if manjetson=0 then
                            manjetson=1
                            dprint "you turn on maneuvering jets"
                            lastaction(0)+=1
                        else
                            manjetson=0
                            dprint "you turn off your maneuvering jets"
                            lastaction(0)+=1
                        endif
                    endif
                endif
                
                if key=key_sh and defender.shieldmax>0 then 
                    if askyn ("Do you really want to shut down your shields? (y/n)") then
                        defender.shield=0
                        shieldshut=1
                        lastaction(0)+=1
                    endif
                endif
                
                if key=key_ru then 
                    victory=com_flee(defender,attacker(),lastenemy)
                    if victory=1 then
                        defender.c=p
                        return defender
                    endif
                endif
                
                if key=key_dr then
                    com_dropmine(defender,mines_p(),mines_v(),mines_last)
                    lastaction(0)+=1
                endif
                
                if f<>0 and defender.hull>0 then
                    if key=key_sc then
                        t=com_gettarget(defender,w,attacker(),lastenemy,senac,t,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
                        if t>0 then
                            if attacker(t).c.x>30 then 
                                x=attacker(t).c.x-21
                            else
                                x=attacker(t).c.x+1
                            endif
                            if attacker(t).c.y>10 then
                                y=attacker(t).c.y-5
                            else
                                y=attacker(t).c.y+1
                            endif
                            if x<1 then x=1
                            if y<1 then y=1
                            textbox(com_shipbox(attacker(t),distance(defender.c,attacker(t).c)),x,y,20,15,1)
                            lastaction(0)=lastaction(0)+1
                            no_key=keyin
                        endif
                    endif
                    if key=key_fi then
                        w=com_getweapon()
                        if w>0 then
                            if defender.weapons(w).ammomax>0 and defender.weapons(w).ammo<=0 then dprint defender.weapons(w).desig &" is out of ammunition.",14
                            if com_testweap(defender.weapons(w),defender.c,attacker(),lastenemy,mines_p(),mines_last) then
                                t=com_gettarget(defender,w,attacker(),lastenemy,senac,t,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
                                if t>0 then lastaction(0)+=5
                                if t>0 and t<100 then 
                                    if pathblock(defender.c,attacker(t).c,0,2,defender.weapons(w).col)=-1 then
                                        attacker(t)=com_fire(attacker(t),defender,defender.weapons(w),defender.gunner+addtalent(3,12,1),distance(defender.c,attacker(t).c),senac)
                                        lastaction(0)=lastaction(0)+1
                                        defender.weapons(w).reloading=defender.weapons(w).reload
                                        if attacker(t).hull<=0 then
                                            dprint "Target destroyed",10
                                            reward(3)=reward(3)+attacker(t).money
                                            defender.piratekills=defender.piratekills+attacker(t).money
                                            attacker(t)=unload_s(attacker(t),10)
                                            lastenemy=com_remove(attacker(),t,lastenemy)
                                            t=0
                                            no_key=keyin
                                        endif
                                        no_key=keyin()
                                    endif
                                endif
                                if t>100 then com_detonatemine(t-100,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                            endif
                        endif    
                        player=defender
                        displayship(0)
                    endif
                    if key=key_ru then victory=com_flee(defender,attacker(),lastenemy)
                    if victory=1 then 
                        defender.c=p
                        return defender
                    endif
                endif
                
                
                if getdirection(key)<>0 then 
                    player.di=getdirection(key)
                
                    old=defender.c
                    defender.c=movepoint(defender.c,getdirection(key))
                    
                    lastaction(0)+=movementcost(0)
                    e_last=e_last+1
                    if e_last>128 then e_last=1
                    e_track_p(e_last)=movepoint(defender.c,10-getdirection(key))
                    e_track_v(e_last)=defender.engine+2
                    if combatmap(defender.c.x,defender.c.y)>0 and rnd_Range(1,6)+rnd_range(1,6)+player.pilot<combatmap(defender.c.x,defender.c.y)*2 then
                        defender.shield=defender.shield-1
                        if defender.shield<0 then
                            defender.hull=defender.hull+defender.shield
                            defender.shield=0                        
                            if combatmap(defender.c.x,defender.c.y)=1 or combatmap(defender.c.x,defender.c.y)=6 then 
                                dprint "You damage your ship hitting an asteroid!",14
                            else
                                dprint "You damage your ship hitting a glas cloud!",14
                            endif
                        endif
                    endif
                    if mines_last>0 then
                        for c=1 to mines_last
                            if defender.c.x=mines_p(c).x and defender.c.y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                            endif
                        next
                    endif
                    
                    for c=1 to e_last
                        if defender.c.x=e_track_p(c).x and defender.c.y=e_track_p(c).y and e_track_v(c)>0 then 
                            defender.shield=defender.shield-e_track_v(c)
                            text="The "&defender.desig &" ran into a plasma stream! "
                            if defender.shield<0 and defender.shieldmax>0 then text=text &"Shields penetrated! "
                            if defender.shield<0 then 
                                defender.hull=defender.hull+defender.shield
                                defender.shield=0
                            endif
                            if defender.hull<=0 then text=text &defender.desig &" destroyed!"                        
                            dprint text,12
                            no_key=keyin
                        endif
                    next
                endif      
                
                tick(0)=tick(0)+tickr(0)
                speed(0)=speed(0)-1
                screenset 0,1
                cls
                displayship(0)
                com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
            endif
            
            for a=1 to lastenemy
                if distance(attacker(a).c,defender.c)<=attacker(a).sensors and lastaction(a)<=0 then
                    'in sensor range
                    for b=0 to 25
                        if attacker(a).weapons(b).desig<>"" then
                            if attacker(a).weapons(b).heat<attacker(a).gunner then
                                'waffe forhanden
                                if distance(attacker(a).c,defender.c)<attacker(a).weapons(b).range*3 then
                                    'in reichweite
                                    if attacker(a).weapons(b).ammo>0 or attacker(a).weapons(b).ammomax=0 then
                                        'muni vorhanden
                                        if pathblock(attacker(a).c,defender.c,0,2,attacker(a).weapons(b).col)=-1 then
                                            defender=com_fire(defender,attacker(a),attacker(a).weapons(b),attacker(a).gunner,distance(attacker(a).c,defender.c),senac)
                                            lastaction(a)+=attacker(a).weapons(b).reload
                                            player=defender
                                            displayship(0)
                                        endif
                                    endif
                                endif
                            endif
                        endif
                    next b
                endif
            next a
            
            for b=1 to lastenemy 'enemymovement
                if lastaction(b)<=0 and attacker(b).hull>0 then
                    if attacker(b).shiptype=0 then                    
                        if distance(defender.c,attacker(b).c)<attacker(b).sensors+defender.sensors*(senac-1) then
                            attacker(b).target.x=defender.c.x
                            attacker(b).target.y=defender.c.y
                        else
                            attacker(b).target.x=-1
                            attacker(b).target.y=-1
                        endif
                    endif
                    if attacker(b).shiptype=1 then
                        attacker(b).target.x=0
                        attacker(b).target.y=attacker(b).c.y
                    endif
                    if attacker(b).target.x=-1 and attacker(b).target.y=-1 then
                        if rnd_range(1,100)<33 then 
                            if rnd_range(1,100)<50 then
                                attacker(b).di-=1
                            else
                                attacker(b).di+=1
                            endif
                        endif
                        if attacker(b).di<1 then attacker(b).di=9
                        if attacker(b).di>9 then attacker(b).di=1
                    
                        if attacker(b).c.x=0 and (attacker(b).di=7 or attacker(b).di=4 or attacker(b).di=1) then
                            if rnd_range(1,20)<attacker(b).c.y then
                                attacker(b).di=9   
                            else
                                attacker(b).di=3   
                            endif
                        endif
                        if attacker(b).c.x=60 and (attacker(b).di=9 or attacker(b).di=6 or attacker(b).di=3) then
                            if rnd_range(1,20)<attacker(b).c.y then
                                attacker(b).di=7   
                            else
                                attacker(b).di=1   
                            endif
                        endif   
                        if attacker(b).c.y=0 and (attacker(b).di=7 or attacker(b).di=8 or attacker(b).di=9) then 
                            if rnd_range(1,60)<attacker(b).c.x then
                                attacker(b).di=1   
                            else
                                attacker(b).di=3   
                            endif
                        endif   
                        if attacker(b).c.y=20 and (attacker(b).di=1 or attacker(b).di=2 or attacker(b).di=3) then 
                            if rnd_range(1,60)<attacker(b).c.x then
                                attacker(b).di=7   
                            else
                                attacker(b).di=9   
                            endif
                        endif   
                    else
                        attacker(b).di=nearest(attacker(b).target,attacker(b).c)
                    endif
                    if dontgothere(b)=attacker(b).di then
                        if rnd_range(1,100)>50 then
                            attacker(b).di+=1
                            if attacker(b).di>9 then attacker(b).di=6
                        else
                            attacker(b).di-=1
                            if attacker(b).di<1 then attacker(b).di=4
                        endif
                    endif
                    if attacker(b).di<>0 then
                        old=attacker(b).c
                        dontgothere(b)=10-attacker(b).di
                        attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                        e_last=e_last+1
                        if e_last>128 then e_last=1
                        e_track_p(e_last)=movepoint(attacker(b).c,10-attacker(b).di)
                        e_track_v(e_last)=attacker(b).engine
                        speed(b)=speed(b)-1
                        tick(b)=tick(b)+tickr(b)
                    endif
                    if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then attacker(b).c=old
                    if mines_last>0 then
                        for c=1 to mines_last
                            if attacker(b).c.x=mines_p(c).x and attacker(b).c.y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                            endif
                        next
                    endif
                    if old.x<>attacker(b).c.x or old.y<>attacker(b).c.y then lastaction(b)+=movementcost(b)
                    screenset 0,1
                    cls
                    displayship(0)
                    com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
                endif
            next b

            
            'boarding
    
            
            for a=1 to e_last
                if e_track_v(a)>0 then
                    for b=1 to lastenemy
                        if attacker(b).c.x=e_track_p(a).x and attacker(b).c.y=e_track_p(a).y and rnd_range(1,6)+rnd_range(1,6)+attacker(b).pilot<11 then 
                            attacker(b).shield=attacker(b).shield-e_track_v(a)
                            text=attacker(b).desig &" ran into plasma stream! "
                            if attacker(b).shield<0 and attacker(b).shieldmax>0 then text=text &"Shields penetrated! "
                            if attacker(b).shield<0 then
                                attacker(b).hull=attacker(b).hull+attacker(b).shield
                                attacker(b).shield=0
                            endif
                            if attacker(b).hull<=0 then 
                                text=text &attacker(b).desig &" destroyed!"
                                defender.piratekills=defender.piratekills+attacker(b).money
                                attacker(b)=attacker(lastenemy)
                                lastenemy=lastenemy-1
                            endif
                            if distance(attacker(b).c,defender.c)<=senbat*senac then 
                                dprint text,10
                                no_key=keyin
                            endif
                        endif
                    next
                    
                    if mines_last>0 then
                        for c=1 to mines_last
                            if e_track_p(a).x=mines_p(c).x and e_track_p(a).y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                            endif
                        next
                    endif
                endif
            next
            
            
        if localturn mod 4=0 then
            for b=1 to e_last
                e_track_v(b)=e_track_v(b)-1
            next
        endif
        
        if localturn mod 5=0 then
            for a=1 to lastenemy
                com_regshields(attacker(a))
            next
            com_regshields(defender)
        endif
        
        com_sinkheat(defender,manjetson)
        for a=1 to lastenemy
            com_sinkheat(attacker(a),0)
        next

        localturn+=1
        if key=key_ru and victory<>1 then victory=com_flee(defender,attacker(),lastenemy)
        if victory=1 then
            defender.c=p
            return defender
        endif
        senac=nexsen
        if lastenemy<=0 then victory=2
        if defender.hull<=0 then victory=3
        
        'merchant flee atempt
        for a=1 to lastenemy
            if attacker(a).shiptype=1 then
                if attacker(a).c.x=attacker(a).target.x and attacker(a).c.y=attacker(a).target.y then
                    if rnd_range(1,6)+rnd_range(1,6)+attacker(a).pilot>6+defender.pilot then
                        dprint "The Merchant got away!",10
                        fleet(255).mem(a)=attacker(a)
                        for b=a to lastenemy
                            attacker(b)=attacker(b+1)
                        next
                        lastenemy=lastenemy-1
                    else
                        dprint "The Merchant didn't get away",12
                        attacker(a).c.x=60
                        attacker(a).target.x=0
                        attacker(a).c.y=rnd_range(1,20)
                        attacker(a).target.y=rnd_range(1,20)
                    endif
                endif
            endif
        next
        #ifdef _windows
        FSOUND_Update
        #endif
    loop until victory<>0
    
    if attacker(16).desig="" and col=10 then atts.con(1)=-1
    cls
    defender.shield=defender.shieldmax
    defender.c=p
    if victory=3 then 
        if player.dead<>0 then screenshot(3)
        if atts.ty=1 or atts.ty=3 then defender.dead=5 'merchants
        if atts.ty=2 or atts.ty=4 then defender.dead=13 'Pirates
        if atts.ty=8 then defender.dead=20 'Asteroid belt monster '
        if atts.ty=5 then defender.dead=21 'ACSC
        if atts.ty=9 then defender.dead=23 'GG monster
        if atts.ty=6 then defender.dead=31 'Civ 1
        if atts.ty=7 then defender.dead=32 'Civ 2
    endif
    if victory=2 then 
        defender.dead=0
        if atts.ty=2 or atts.ty=8 then combon(8).value+=noenemies
    endif
    if victory=1 and player.towed<>0 then
        dprint "You leave behind the ship you had in tow.",14
        player.towed=0
    endif
    for a=1 to 15
        atts.mem(a)=attacker(a)
    next    
    for a=1 to 5
        defender.weapons(a).reloading=0
        defender.weapons(a).heat=0
    next
    return defender
end function

function com_display(defender as _ship, attacker() as _ship, lastenemy as short, marked as short, senac as short,e_track_p() as _cords,e_track_v() as short,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    dim as short x,y,a,b,c,f,osx
    dim p1 as _cords
    dim as short senbat,senbat1,senbat2,denemy
    dim list_c(128) as _cords
    dim list_e(128) as short
    dim last as short
    dim debug as byte
    debug=1
    
    for a=1 to lastenemy
            last+=1
            list_c(last)=attacker(a).c
            list_e(last)=a
    next
    if mines_last>0 then
        for a=1 to mines_last
            last+=1
            list_c(last)=mines_p(a)
            list_e(last)=a        
        next
    endif
    osx=defender.c.x-_mwx/2
    if osx<0 then osx=0
    if osx>_mwx then osx=60-_mwx
    senbat=defender.sensors+2
    senbat1=defender.sensors+1
    senbat2=defender.sensors
    for x=defender.c.x-senbat*senac-1 to defender.c.x+senbat*senac+1
        for y=defender.c.y-senbat*senac-1 to defender.c.y+senbat*senac+1
            if x>=osx and y>=0 and x<=_mwx+osx and x<=60 and x>=0 and y<=20 then
                p1.x=x
                p1.y=y
                draw string((x-osx)*_fw1,y*_fh1)," ",,font1,custom,@_col
                if distance(p1,defender.c)<=senbat*senac or com_cheat=1 then
                    if _tiles=0 then
                        if distance(p1,defender.c)<=senbat*senac and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(78),pset
                        if distance(p1,defender.c)<=senbat1*senac and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(79),pset
                        if distance(p1,defender.c)<=senbat2*senac and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(80),pset
                        if combatmap(x,y)=1 or combatmap(x,y)=6 then put ((x-osx)*_tix,y*_tiy),gtiles(76),pset
                        if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then put ((x-osx)*_tix,y*_tiy),gtiles(51),pset
                    else
                        if distance(p1,defender.c)<=senbat*senac then color 8,0
                        if distance(p1,defender.c)<=senbat1*senac then color 7,0
                        if distance(p1,defender.c)<=senbat2*senac then color 15,0
                        if combatmap(x,y)=0 then draw string(x*_fw1,y*_fh1),".",,font1,custom,@_col
                        if combatmap(x,y)=1 or combatmap(x,y)=6 then draw string(x*_fw1,y*_fh1),chr(183),,font1,custom,@_col
                        if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then
                            color rnd_range(48,59),0
                            if combatmap(x,y)=7 then color rnd_range(186,210),0
                            draw string(x*_fw1,y*_fh1), chr(176),,font1,custom,@_col
                        endif
                    endif
                endif
            endif
        next
    next
    
    for b=1 to e_last    
        if distance(e_track_p(b),defender.c)<=senbat*(senac+1) and e_track_v(b)>0 then 
            if _tiles=0 then
                if e_track_v(b)>=4 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(81),pset
                if e_track_v(b)=3 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(82),pset
                if e_track_v(b)=2 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(83),pset
                if e_track_v(b)=1 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(84),pset
            else
                color 0,0
                if e_track_v(b)>=4 then color 15,0
                if e_track_v(b)=3 then color 11,0
                if e_track_v(b)=2 then color 9,0
                if e_track_v(b)=1 then color 1,0 
                draw string(e_track_p(b).x*_fw1,e_track_p(b).y*_fh1),"*",,font1,custom,@_col 
            endif
        endif
    next
    
    if mines_last>0 then
        for b=1 to mines_last
            color 0,0
            draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1)," ",,font1,custom,@_col
            if _tiles=0 then
                if distance(mines_p(b),defender.c)<senbat*(senac+1) then 
                    put ((mines_p(b).x-osx)*_fw1,mines_p(b).y*_fh1),gtiles(gt_no(item(mines_v(b)).ti_no)),pset
                    denemy+=1
                endif
                if b+lastenemy=marked then put (mines_p(b).x*_fw1,mines_p(b).y*_fh1),gtiles(85),trans
            else
                if b+lastenemy=marked then 
                    color 8,11
                else
                    color 8,0
                endif
                if distance(mines_p(b),defender.c)<senbat*(senac+1) then 
                    draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1),"ö",,font1,custom,@_col
                    denemy+=1
                endif
            endif
        next
    endif
    
    for c=1 to last
        if c<=lastenemy then
            b=list_e(c)
            if distance(attacker(b).c,defender.c)<=senbat1*senac then attacker(b).questflag(11)=1
            if _tiles=0 then
                if debug=1 then
                    f=freefile
                    open "tileerror" for output as #f
                    print #f,"attacker(b).di " &attacker(b).di &"attacker(b).ti_no:"&attacker(b).ti_no
                    close #f
                endif
                if attacker(b).di=0 then attacker(b).di=rnd_range(1,8)
                if attacker(b).di=5 then attacker(b).di=9
                if distance(attacker(b).c,defender.c)<senbat*senac then
                    denemy=denemy+1
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(86),pset
                endif
                if distance(attacker(b).c,defender.c)<=senbat1*senac or distance(attacker(b).c,defender.c)<=sqr(2) or show_enemyships=1 then
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),stiles(attacker(b).di,attacker(b).ti_no),pset
                endif
                if c=marked then 
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(85),trans
                endif
            else
                if c=marked then
                    color attacker(b).bcol,attacker(b).col
                else
                    color attacker(b).col,attacker(b).bcol
                endif
                if distance(attacker(b).c,defender.c)<senbat*senac then
                    denemy=denemy+1
                    draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),"?",,font1,custom,@_col
                endif
                if distance(attacker(b).c,defender.c)<=senbat1*senac or distance(attacker(b).c,defender.c)<=sqr(2) or show_enemyships=1 then
                    draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),attacker(b).icon,,font1,custom,@_col
                endif
            endif
        endif
    next
    if _tiles=0 then
        put ((defender.c.x-osx)*_tix,defender.c.y*_tiy),stiles(player.di,player.ti_no)
    else
        color _shipcolor,0
        draw string(defender.c.x*_fw1,defender.c.y*_fh1),"@",,font1,custom,@_col
    endif
    flip
    return denemy
end function

function com_getweapon() as short
    dim as short a,c,lastslot
    static as short m
    dim key as string
    if m=0 then m=1
    for a=1 to player.h_maxweaponslot
            
        if player.weapons(a).dam>0 then
            if (player.weapons(a).ammo>0 or player.weapons(a).ammomax=0) then 
                c+=1 'waffe braucht ammo und hat keine
                lastslot=a
            endif
        endif
    next
    if c=0 then 
        dprint "No weapons fireable"
        return 0
    endif
    do
        display_ship_weapons(m)
        key=keyin(key_esc & key_enter &key_up &key_lt &key_dn &key_rt &"+-123456789")
        if keyplus(key) then m+=1
        if keyminus(key) then m-=1
        if m>lastslot then m=1
        if m<1 then m=lastslot
    loop until key=key_esc or key=key_enter
    if key=key_enter then return m
    return 0
end function

function com_gettarget(defender as _ship, wn as short, attacker() as _ship,lastenemy as short,senac as short,marked as short,e_track_p() as _cords,e_track_v() as short,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    
    dim targetno as short
    dim as short a,d,ex
    dim as short senbat,senbat1,senbat2
    dim as string key,text,id
    dim list_c(128) as _cords
    dim list_e(128) as short
    dim last as short
    
    senbat=defender.sensors+2
    senbat1=defender.sensors+1
    senbat2=defender.sensors
    
    if marked=0 then
        for a=1 to lastenemy
            if distance(attacker(a).c,defender.c)<senbat*senac then marked=a
        next        
    endif
    
    for a=1 to lastenemy
        'if distance(attacker(a).c,defender.c)<senbat*senac then
            last+=1
            list_e(last)=a
            list_c(last)=attacker(a).c
        'endif
    next
    if mines_last>0 then
        for a=1 to mines_last
        '    if distance(mines_p(a),defender.c)<senbat*senac then
                last+=1
                list_e(last)=a
                list_c(last)=mines_p(a)
        '    endif
        next
    endif
    
    
            
    do
        a=com_display(defender,attacker(),lastenemy,marked,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
        if a>0 then 'ships to target
            d=0
            text="+/- to move, enter to select, esc to skip. "
            if marked>0 and marked<=lastenemy then
                if distance(defender.c,attacker(list_e(marked)).c)<senbat*senac then id="?"
                if distance(defender.c,attacker(list_e(marked)).c)<senbat1*senac then id=attacker(marked).desig
                text=text &id &com_wstring(defender.weapons(wn),distance(attacker(list_e(marked)).c,defender.c))
            endif
            if marked>lastenemy and marked<=last then 
                text="Mine"&com_wstring(defender.weapons(wn),distance(list_c(marked),defender.c))
            endif
            dprint text 
            key=keyin("+-"&key_esc &key_enter,,1)
            if keyplus(key) then d=1
            if keyminus(key) then d=-1
            ex=0
            do
                marked=marked+d
                if marked<1 then marked=last
                if marked>last then marked=1
                ex+=1
            loop until (list_e(marked)<>0 and distance(defender.c,list_c(marked))<senbat*senac) or ex>last
            if key=key_enter then targetno=marked
            if key=key_esc or ex>last then targetno=-1
            
        endif
        
    loop until targetno<>0 or a=0 or last=0
    if targetno>0 then
        if targetno<=lastenemy then 
            targetno=list_e(marked)
        else
            targetno=list_e(marked)+100
        endif
    endif
    return targetno
end function

function com_fire(target as _ship, attacker as _ship,byref w as _weap, gunner as short, range as short,senac as short) as _ship
    dim del as _weap
    dim wp(255) as _cords
    dim as short roll,a,ROF,dambonus,tohitbonus,i,l,c,osx,j
    osx=calcosx(attacker.c.x)
    ROF=w.ROF
    for a=1 to 25
        if attacker.weapons(a).made=91 then dambonus+=1
        if attacker.weapons(a).made=92 then dambonus+=2
        if attacker.weapons(a).made=93 then tohitbonus+=1
        if attacker.weapons(a).made=94 then tohitbonus+=2
    next
    #ifdef _windows
    if w.ammomax>0 and w.ROF>0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(7)) 'Laser         
    if w.ammomax>0 and w.ROF=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(8)) 'Missile battery          
    if w.ammomax=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(9)) 'Missile                                           
    #endif
    do
        if w.ammomax>0 then w.ammo=w.ammo-1 
        if w.ammo>0 or w.ammomax=0 then
            w.heat=w.heat+w.heatadd*25
            w.reloading=w.reload
            if rnd_range(1,6)+rnd_range(1,6)+gunner>=w.heat/25  then
                roll=rnd_range(1,6)+rnd_range(1,6)+gunner+senac+tohitbonus-(target.ecm*w.ecmmod)
                'if range<=w.range*3 then roll=roll+1
                if range<=w.range*2 then roll=roll+1
                if range<=w.range then roll=roll+2
                if roll>11 then
                    if w.ammomax=0 then
                        c=185
                    else
                        c=7
                    endif
                    l=line_in_points(target.c,attacker.c,wp())
                    for i=1 to l-1
                        sleep 25
                        color c,0
                        if _tiles=0 then
                            if w.ammomax=0 then 
                                put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75))
                            else
                                put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76))
                            endif
                        else
                            draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                        endif
                    next
                    if w.ammomax=0 then
                        target=com_hit(target,w,dambonus,range, senac)
                        c=185
                    else
                        target=com_hit(target,w,0,range, senac)
                        c=7
                    endif
                else
                    l=line_in_points(movepoint(target.c,5),attacker.c,wp())
                    if w.ammomax=0 then
                        c=185
                    else
                        c=7
                    endif
                    for i=1 to l-1
                        sleep 25
                        if _tiles=0 then
                            if w.ammomax=0 then 
                                put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75))
                            else
                                put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76))
                            endif
                        else
                            draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                        endif    
                    next
                    if w.p>0 then
                        dprint w.desig &" fired, and misses!"
                    else
                        dprint "It missed."
                    endif
                endif
            else
                dprint w.desig &" shuts down due to heat."
                w.shutdown=1
                if rnd_range(1,6)+rnd_range(1,6)+gunner<w.heat/10 then
                    dprint w.desig &" is irreperably damaged."
                    w=del
                endif
            endif
        endif
        ROF-=1
    loop until ROF<=0
    return target
end function

function com_hit(target as _ship, w as _weap,dambonus as short, range as short, senac as short) as _ship
    dim as string desig, text
    dim as short roll,osx,j
    osx=calcosx(target.c.x)
    if target.desig=player.desig then
        desig=player.desig
    else
        if range>(player.sensors+2)*senac then
            desig="?"
        else
            desig=target.desig 
        endif
        gainxp(3)
    endif
    
    target.shield=target.shield-w.dam-dambonus
    if target.shield<0 then
        if target.shieldmax>0 then
            text=desig &" is hit, shields penetrated! " 
        else
            text=desig &" is hit! "
        endif
        target.hull=target.hull+target.shield
        text=text & -target.shield & " Damage!"
        roll=rnd_range(1,6)+rnd_range(1,6)-target.shield
        if roll>8 and target.hull>0 then
            if roll+rnd_range(1,6)>13 then
                text=text & " Critical hit!"
                dprint text
                target=com_criticalhit(target,roll)
            endif
        else 
            if w.p>0 then 
                dprint w.desig &" fired, "& text
            else
                dprint w.desig &", " & text
            endif
        endif
        text=""
        no_key=keyin
    endif
    if target.shield=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, shields are down!"
    if target.shield=0 and w.p<0 then text=w.desig &" "&desig &" is hit, shields are down!"
    if target.shield>0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, but shields hold!"
    if target.shield>0 and w.p<0 then text=w.desig &" "&desig &" is hit, but shields hold!"
    
    if _tiles=0 then
        screenset 1,1
        for j=1 to 8
            put ((target.c.x-osx)*_tix,target.c.y*_tix),gtiles(gt_no(76+j)),trans
            sleep 5
        next
    endif
    dprint text
    if text<>"" then no_key=keyin
    if target.shield<0 then target.shield=0
    return target
end function

function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short) as short
    dim p as _cords
    dim as short a,b,c,mine,mtype(15),no(15),mwhere(15),storedead,dam
    dim mdesig(15) as _items
    dim as string text,key
    c=getitemlist(mdesig(),no(),40)
    for a=0 to c-1
        text=text &"/ "&mdesig(a).desig &"(" &no(a) &")"
        for b=1 to lastitem
            if mdesig(a).id=item(b).id and item(b).w.s=-1 then 
                mwhere(a+1)=b
                exit for
            endif
        next
    next    
    
    if addtalent(3,13,1)>0 then 
        text=text &"/ Improvised mine"
        c+=1
        mwhere(c)=-1
    endif
    if text<>"" then
        text="Choose mine:"&text &"/Exit"
        storedead=player.dead
        player.dead=0
        mine=menu(text)
        player.dead=storedead
        if mine<=0 or mine>c then return 0
        if addtalent(3,13,1)>0 and mine=c then
            player.fuel=player.fuel-5
            placeitem(makeitem(74),0,0,0,0,-1)
            for b=1 to lastitem
                if item(b).id=74 and item(b).ty=40 and item(b).w.s=-1 then 
                    mwhere(mine)=b
                    exit for
                endif                
            next
        endif
            
        mine=mwhere(mine)
    else
        dprint "You don't have mines"
        return 0
    endif
    dprint "Direction"&mine &lastitem
    key=keyin("12345678")
    a=getdirection(key)
        
    if a>0 then
        p=movepoint(defender.c,a)
        mines_last+=1
        if mines_last<=128 then
            mines_p(mines_last).x=p.x
            mines_p(mines_last).y=p.y
            mines_v(mines_last)=mine
            item(mine).w.s=0
        endif
    endif
    return 0
end function

function com_regshields(s as _ship) as short
    dim a as short
    dim shieldreg as short
    shieldreg=1
    for a=1 to 25
        if s.weapons(a).made=90 then shieldreg=2
    next
    if s.shield<s.shieldmax then s.shield=s.shield+shieldreg
    if s.shield>s.shieldmax then s.shield=s.shieldmax
    return 0
end function


function com_sinkheat(s as _ship,manjets as short) as short
    dim as short a,sink,heat,shieldreg
    sink=s.h_maxweaponslot
    for a=1 to 25
        sink=sink+s.weapons(a).heatsink
        if s.weapons(a).made=90 then shieldreg=2
    next
    if sink>0 and manjets>0 then
        sink=sink-s.manjets*(manjets+1)
    endif
    if sink>0 and s.shield<s.shieldmax then
        sink-=3
    endif
    if sink<=0 then sink=1
    do
        heat=0
        for a=1 to 25
            if s.weapons(a).heat>0 then 
                if sink>0 then
                    sink-=1
                    s.weapons(a).heat-=1
                endif
            else
                s.weapons(a).shutdown=0
            endif
            if s.weapons(a).heat>0 then heat=1
        next
    loop until sink<=0 or heat<=0
    for a=1 to 25
        if s.weapons(a).reloading>0 then s.weapons(a).reloading-=1
    next
    return 0
end function


function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship, byref lastenemy as short) as short
    dim as short x,y,t,r,dis,a,dam
    dim as _cords p
    if mines_last<=0 then
        mines_last=0
        return 0
    end if
    if rnd_range(1,100)>item(mines_v(d)).v3 then
        dprint "The mine was a dud"
        destroyitem(mines_v(d))
        mines_p(d)=mines_p(mines_last)
        mines_v(d)=mines_v(mines_last)
        mines_last-=1
        return 0
    endif
    dam=item(mines_v(d)).v1
    r=item(mines_v(d)).v2
    
    for t=1 to 5
        for x=mines_p(d).x-6 to mines_p(d).x+6
            for y=mines_p(d).y-6 to mines_p(d).y+6
                p.x=x
                p.y=y
                dis=distance(p,mines_p(d))
                if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                    color 242+dis,0
                    draw string(p.x*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        color 0,0
                        draw string(p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
            next
        next
        sleep 50
    next
    
    for t=5 to 1 step -1
        for x=mines_p(d).x-5 to mines_p(d).x+5
            for y=mines_p(d).y-5 to mines_p(d).y+5
                p.x=x
                p.y=y
                dis=distance(p,mines_p(d))
                if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                    color 242+dis
                    draw string(p.x*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        color 0,0
                        draw string(p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
            next
        next
        sleep 50
    next
    
    if distance(mines_p(d),defender.c)<r then 
        defender=com_damship(defender,dam-2*distance(mines_p(d),defender.c),12)
        player=defender
        displayship(0)
    endif
    for a=1 to lastenemy
        if distance(mines_p(d),attacker(a).c)<r then 
            attacker(a)=com_damship(attacker(a),dam-2*distance(mines_p(d),attacker(a).c),10)
            if attacker(a).hull<=0 then
                dprint attacker(a).desig &" destroyed",10
                attacker(a)=unload_s(attacker(a),10)
                reward(3)=reward(3)+attacker(a).money
                defender.piratekills=defender.piratekills+attacker(a).money
                lastenemy=com_remove(attacker(),a,lastenemy)
                t=0
                no_key=keyin
            endif
        endif
    next
    
    p=mines_p(d)    
    destroyitem(mines_v(d))
    mines_p(d)=mines_p(mines_last)
    mines_v(d)=mines_v(mines_last)
    mines_last-=1
    
    
    for a=1 to mines_last
        if distance(p,mines_p(a))<r then com_detonatemine(a,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
    next
    
    
    return 0
    
end function
    
function com_damship(byref t as _ship, dam as short, col as short) as _ship
    dim text as string
    if dam<0 then return t
    t.shield=t.shield-dam
    dprint t.desig &" is hit! ",col
    if t.shield<0 then
        if t.shieldmax>0 then
            text=t.desig &" is hit, shields penetrated! " 
        else
            text=t.desig &" is hit! "
        endif
        t.hull=t.hull+t.shield
        text=text & -t.shield & " Damage!"
    else
        text="shields hold!"
    endif
    if t.shield<0 then t.shield=0
    dprint text,col
    return t
end function

function com_criticalhit(t as _ship, roll as short) as _ship
    dim as short a,b,l
    dim text as string
    if t.hulltype=-1 then return t
    l=8
    
        a=rnd_range(1,l)
        if a=1 then
            if t.engine<2 then 
                t.engine=1
                a=rnd_range(2,l)
            else
                dprint "engine hit!",12
                t.engine=t.engine-1
            
            endif
        endif
        
        if a=2 then
            if t.sensors<2 then
                t.sensors=1
                a=rnd_range(3,l)
            else
                dprint "Sensors damaged!",12
                t.sensors=t.sensors-1
            endif
        endif
        
        if a=3 then 
            if t.shieldmax>0 then
                dprint "Shield generator damaged!",12
                t.shieldmax=t.shieldmax-1
            else
                a=rnd_range(3,l)
            endif
        endif
        
        if a=4 then
            t.h_maxhull-=1
            if t.hull>t.h_maxhull then t.hull=t.h_maxhull
            dprint "critical damage to ship structure!",12
        endif
        
        if a=5 then
            dprint "Cargo bay hit",12
            for b=0 to 10
                if t.cargo(b).x>1 then
                    t.cargo(b).x=1
                    exit for
                endif
            next
        endif
        
        if a=6 then 
            b=rnd_range(1,5)
            if t.weapons(b).desig<>"" then
                dprint t.weapons(b).desig &"hit and destroyed!",12
                if t.desig=player.desig then 

                    if t.weapons(b).desig="Fuel tank" then
                        b=rnd_range(1,6)
                        dprint "it explodes! "& b &" points of damage!",12
                        player.hull=player.hull-b
                    endif
                    
                    if t.weapons(b).desig="Crew Quarters" then
                        b=rnd_range(1,6)
                        t.security=t.security-b
                        if t.security<0 then
                            b=b+t.security
                            t.security=0
                        endif
                        dprint  b &" casualties!",12
                    endif
                    
                endif
                t.weapons(b)=makeweapon(-1)
                if t.desig=player.desig then recalcshipsbays
            else
                dprint "weapons turret hit but undamaged!",10
            endif
        endif
        
        if a=7 then
            if t.desig=player.desig then 
                b=rnd_range(1,6)
                t.security=t.security-b
                if t.security<0 then
                    b=b+t.security
                    t.security=0
                endif
                dprint "Crew quaters hit! "& b &" casualties!",12
                removemember(b,0)
                player.deadredshirts=player.deadredshirts+b
            else
                dprint "Crew quaters hit!"
            endif
        endif 

        if a=8 then
            dprint "A direct hit on the bridge!",12
            
            if t.desig=player.desig then 
                
                if rnd_range(1,6)+rnd_range(1,6)>7 then
                    b=rnd_range(1,4)
                    if b=1 and t.pilot>0 then 
                        crew(2).hp=0
                        t.pilot=captainskill
                        text="Pilot "
                    endif
                    if b=2 and t.gunner>0 then
                        crew(3).hp=0
                        t.gunner=captainskill
                        text="Gunner "
                    endif
                    if b=3 and t.science>0 then
                        crew(4).hp=0
                        t.science=captainskill
                        text="Science Officer "
                    endif
                    if b=4 and t.Doctor>0 then 
                        crew(5).hp=0
                        t.doctor=captainskill
                        text="Doctor "
                    endif
                    if t.desig=player.desig then 
                        dprint "An Explosion! Our "&text &"was killed!",12
                        player.deadredshirts=player.deadredshirts+1
                    endif
                endif
            endif
        endif
    return t
end function

function com_flee(defender as _ship,attacker() as _ship,lastenemy as short) as short
    dim as short roll,victory 
    if defender.c.x=0 or defender.c.x=60 or defender.c.y=0 or defender.c.y=20 then
        roll=rnd_range(1,6)+rnd_range(1,6)+defender.pilot+addtalent(2,7,1)
        if findbest(25,-1)>0 then roll=roll+5
        if roll>6+lastenemy or attacker(1).shiptype=2 then
            dprint "you manage to get away",10
            victory=1            
        else
            cls
            displayship(0)
            dprint "you dont get away",12
            defender.c.x=30
            defender.c.y=10
        endif
    else
        dprint "you need to be at a map border",14
    endif
    return victory
end function

function com_wstring(w as _weap, range as short) as string
    dim text as string
    if range<=w.range*3 then text=" is at long range for "&w.desig
    if range<=w.range*2 then text=" is at medium range for "&w.desig    
    if range<=w.range then text=" is at optimum range for "&w.desig
    return text
end function

function com_shipbox(s as _ship,di as short) as string
    dim text as string
    dim as short a,heat
    '' Storing in questflag array if things already have been IDed
    if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science or s.questflag(11)=1 then 
        text="|" & s.desig &"||"
        s.questflag(11)=1
    else
        text="| ???? ||"
    endif
    if s.shield>player.sensors then
        text=text &"Shield:"&s.shield
    else
        if s.shield>0 then
            text=text &"Shield:"&s.shield
        else
            text=text &"No shield |"
        endif
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science or s.questflag(0)=1 then 
            text=text &"Hull: "&s.hull &" | "
            s.questflag(0)=1
        else
            text=text &"Hull: ?? | "
        endif    
        for a=1 to 10
            if s.weapons(a).desig<>"" then
                if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science/2 or s.questflag(a)=1 then
                    text=text & s.weapons(a).desig &" | "
                    heat=heat+s.weapons(a).heat 
                    s.questflag(a)=1
                else 
                    text=text &" Weapon: ?? |"
                endif
            endif
        next
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science or s.questflag(12)=1 then
            s.questflag(12)=1
            text=text &"Engine: "&s.engine &" |"
        endif
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science then
            text=text &"Heat: "& int(heat/10) 
        else
            text=text &"Heat: ??"
        endif
        text=text &" | | "
    endif
    return text
end function

function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,lastenemy as short,mines_p() as _cords,mines_last as short) as short
    dim r as short
    dim a as short
    dim b as short
    
    if w.dam>0 then
        r=-1 'kein cargo bay oder empty slot
        if w.ammomax>0 and w.ammo<=0 then r=0 'waffe braucht ammo und hat keine
        if w.shutdown<>0 then r=0
        if w.reloading<>0 then r=0
    endif
    if r=-1 then
        for a=1 to lastenemy
            if distance(p1,attacker(a).c)<w.range*3 then b=1
        next
        for a=1 to mines_last
            if distance(p1,mines_p(a))<w.range*3 then b=1
        next
        if b=0 then r=0
    endif
    return r
end function

function com_mindist(s as _ship) as short
    dim as short d,a
    d=999
    for a=1 to 10
        if s.weapons(a).range>0 and s.weapons(a).range<d then d=s.weapons(a).range
    next
    return d
end function

function com_remove(attacker() as _ship, t as short, lastenemy as short) as short
    dim a as short
    for a=t to lastenemy
        attacker(a)=attacker(a+1)
    next
    lastenemy=lastenemy-1
    return lastenemy
end function
