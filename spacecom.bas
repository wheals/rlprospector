
function spacecombat(defender as _ship, byref atts as _fleet,ter as short) as _ship
    dim attacker(16) as _ship
    dim targets(15) as _ship
    dim speed(15) as short
    dim tick(15) as single
    dim tickr(15) as single
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
    dim t as short
    dim lastenemy as short
    dim target as short
    dim lasttarget as short
    dim x as short
    dim y as short
    dim key as string
    dim rangestr as string
    dim range as short
    dim p as cords
    dim p1 as cords
    dim roll as short
    dim victory as short
    dim astring as string
    dim shieldshut as short
    dim text as string
    dim e_track_p(128) as cords
    dim e_track_v(128) as short
    dim e_last as short
    
    dim mines_p(128) as cords
    dim mines_v(128) as short
    dim mines_last as short
    
    dim old as cords
    for x=0 to 60
        for y=0 to 20
            combatmap(x,y)=0
            if rnd_range(1,100)<ter then 
                combatmap(x,y)=rnd_range(1,5)
                if ter=6 then combatmap(x,y)=6 'Asteroid field 
                if ter=7 then combatmap(x,y)=7 'Gas giant
            endif
            if rnd_range(1,100)<3 and rnd_range(1,100)<3 then
                combatmap(x,y)=rnd_range(1,7)
            endif
        next
    next
    victory=0
    col=12
    for a=1 to 15
        if atts.mem(a).hull>0 then
            lastenemy=lastenemy+1
            attacker(a)=atts.mem(a)
            if attacker(a).shiptype=1 then 'Merchantman exit target
                col=10 'all green now
                attacker(a).target.x=0
                attacker(a).target.y=rnd_range(1,20)
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
    cls
    player=defender
    displayship(0)
    do
        nexsen=senac
        'movement
        speed(0)=speed(0)+defender.engine+2-cint(defender.h_maxhull\15)
        if speed(0)<1 then speed(0)=1
        st=speed(0)
        for a=1 to lastenemy
            speed(a)=speed(a)+attacker(a).engine
            attacker(a).sensors=attacker(a).sensors*3
            if attacker(a).c.x=attacker(a+1).c.x and attacker(a).c.y=attacker(a+1).c.y  then attacker(a).c=movepoint(attacker(a).c,5)
            if st<speed(a) then st=speed(a)
        next
        
        for a=0 to lastenemy
            tickr(a)=10/speed(a)
            tick(a)=0
        next
        player=defender
        displayship(0)
        com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
   '
        for a=1 to 10
    
            if a>=tick(0) and speed(0)>0 and defender.hull>0 then 'playermovement
                    
                color 11,0
                locate 6,63
                print "Engine :"&player.engine &" ("&speed(0)&" MP)"
                if defender.c.x=0 or defender.c.y=0 or defender.c.x=60 or defender.c.y=20 then dprint "Press "&key_ru &" to run and flee."
                key=keyin("1234678"&key_ac &key_sh &key_ru &key_esc &key_dr)
                if key=key_ac then
                    if senac=2 then nexsen=1
                    if senac=1 then nexsen=2
                endif
                if key=key_esc then
                    if askyn("Do you really want to end movement phase? (y/n)") then speed(0)=0
                endif
                if key=key_sh and defender.shieldmax>0 then 
                    if askyn ("Do you really want to shut down your shields? (y/n)") then
                        defender.shield=0
                        shieldshut=1
                    endif
                endif
                
                if key=key_ru then 
                    victory=com_flee(defender,lastenemy)
                    if victory=1 then
                        defender.c=p
                        return defender
                    endif
                endif
                
                if key=key_dr then
                    com_dropmine(defender,mines_p(),mines_v(),mines_last)
                endif
                
                old=defender.c
                defender.c=movepoint(defender.c,getdirection(key))
                
                if old.x<>defender.c.x or old.y<>defender.c.y then
                    e_last=e_last+1
                    if e_last>128 then e_last=1
                    e_track_p(e_last)=old
                    e_track_v(e_last)=defender.engine+2
                    if combatmap(defender.c.x,defender.c.y)>0 and rnd_Range(1,6)+rnd_range(1,6)+player.pilot<combatmap(defender.c.x,defender.c.y)*2 then
                        defender.shield=defender.shield-1
                        if defender.shield<0 then
                            defender.hull=defender.hull+defender.shield
                            defender.shield=0                        
                            if combatmap(defender.c.x,defender.c.y)=1 or combatmap(defender.c.x,defender.c.y)=6 then 
                                dprint "You damage your ship hitting an asteroid!",14,14
                            else
                                dprint "You damage your ship hitting a glas cloud!",14,14
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
                endif      
                
                tick(0)=tick(0)+tickr(0)
                speed(0)=speed(0)-1
                com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
            endif
            for b=1 to lastenemy 'enemymovement
                if a>=tick(b)and speed(b)>0 then
                    if attacker(b).shiptype=0 then                    
                        if distance(defender.c,attacker(b).c)>attacker(b).sensors+(senbat*senac) then
                            attacker(b).target.x=rnd_range(0,60)
                            attacker(b).target.y=rnd_range(0,20)
                        else
                            attacker(b).target.x=player.c.x
                            attacker(b).target.y=player.c.y
                        endif
                    endif
                    
                    c=nearest(attacker(b).target,attacker(b).c)
                    old=attacker(b).c
                    attacker(b).c=movepoint(attacker(b).c,c)
                    if old.x<>attacker(b).c.x or old.y<>attacker(b).c.y then
                        e_last=e_last+1
                        if e_last>128 then e_last=1
                        e_track_p(e_last)=old
                        e_track_v(e_last)=attacker(b).engine
                    endif
                    speed(b)=speed(b)-1
                    tick(b)=tick(b)+tickr(b)
                    if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then
                        'position to board
                        if attacker(b).security<=0 then
                            'unable to board,move away
                            attacker(b).c=old
                            
                        else
                            'boarding attempt
                        endif
                    endif
                    if mines_last>0 then
                        for c=1 to mines_last
                            if attacker(b).c.x=mines_p(c).x and attacker(b).c.y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                            endif
                        next
                    endif
                    com_display(defender, attacker(),lastenemy,0,senac,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
                endif
            next b
            
            
            
                
            
        next a
        
    '
    'fire resolution
    '
    f=0
    for e=1 to lastenemy
        if distance(attacker(e).c,defender.c)<senbat*senac then f=f+1
    next
    for e=1 to mines_last
        if distance(mines_p(e),defender.c)<senbat*senac then f=f+1
    next
    if defender.c.x=0 or defender.c.y=0 or defender.c.x=60 or defender.c.y=20 then f=-1
    if f<>0 and defender.hull>0 then
        dprint key_fi &" to fire weapons, ESC to skip fire, "&key_dr &" to drop mines, "&key_ru & " to run and flee."
        key=keyin(key_fi &key_sh &key_ru &key_dr)
        if key=key_dr then
            com_dropmine(defender,mines_p(),mines_v(),mines_last)
        endif

        if key=key_fi then
            for a=1 to player.h_maxweaponslot
                if com_testweap(defender.weapons(a),defender.c,attacker(),lastenemy,mines_p(),mines_last) then
                    t=com_gettarget(defender,a,attacker(),lastenemy,senac,t,e_track_p(),e_track_v(),e_last,mines_p(),mines_v(),mines_last)
                    if t>0 and t<100 then 
                        if pathblock(defender.c,attacker(t).c,0,2,defender.weapons(a).col)=-1 then
                            attacker(t)=com_fire(attacker(t),defender.weapons(a),defender.gunner+addtalent(3,12,1),distance(defender.c,attacker(t).c),senac)
                            if attacker(t).hull<=0 then
                                dprint "Target destroyed",,10
                                reward(3)=reward(3)+attacker(t).money
                                defender.piratekills=defender.piratekills+attacker(t).money
                                lastenemy=com_remove(attacker(),t,lastenemy)
                                t=0
                                no_key=keyin
                            endif
                            no_key=keyin()
                        endif
                    endif
                    if t>100 then com_detonatemine(t-100,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                endif
            next
            player=defender
            displayship(0)
        endif
        if key=key_ru then victory=com_flee(defender,lastenemy)
        if victory=1 then 
            defender.c=p
            return defender
        endif
    endif
        'enemy fire
        for a=1 to lastenemy
            if distance(attacker(a).c,defender.c)<=attacker(a).sensors then
                'in sensor range
                for b=0 to 25
                    if attacker(a).weapons(b).desig<>"" then
                        'waffe forhanden
                        if distance(attacker(a).c,defender.c)<attacker(a).weapons(b).range*3 then
                            'in reichweite
                            if attacker(a).weapons(b).ammo>0 or attacker(a).weapons(b).ammomax=0 then
                                'muni vorhanden
                                if pathblock(defender.c,attacker(a).c,0,2,attacker(a).weapons(b).col)=-1 then
                                    defender=com_fire(defender,attacker(a).weapons(b),attacker(a).gunner,distance(attacker(a).c,defender.c),senac)
                                    player=defender
                                    displayship(0)
                                endif
                            endif
                        endif
                    endif
                next
            endif
        next
        
        
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
                            dprint text,10,10
                            no_key=keyin
                        endif
                    endif
                next
                if defender.c.x=e_track_p(a).x and defender.c.y=e_track_p(a).y then 
                    defender.shield=defender.shield-e_track_v(a)
                    text="The "&defender.desig &"ran into plasma stream! "
                    if defender.shield<0 and defender.shieldmax>0 then text=text &"Shields penetrated! "
                    if defender.shield<0 then 
                        defender.hull=defender.hull+defender.shield
                        defender.shield=0
                    endif
                    if defender.hull<=0 then text=text &defender.desig &" destroyed!"                        
                    dprint text,12,12
                    no_key=keyin
                endif
                
                if mines_last>0 then
                    for c=1 to mines_last
                        if e_track_p(a).x=mines_p(c).x and e_track_p(a).y=mines_p(c).y then 
                            com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
                        endif
                    next
                endif
            endif
        next
        
        
        if defender.shield<defender.shieldmax and shieldshut=0 then 
            defender.shield=defender.shield+1
            speed(0)=-2
        else
            speed(0)=0
        endif
        
        for a=1 to lastenemy
            if attacker(a).shield<attacker(a).shieldmax then 
                attacker(a).shield=attacker(a).shield+1
                speed(a)=-2
            else
                speed(a)=0
            endif
        next
        
        if key=key_ru and victory<>1 then victory=com_flee(defender,lastenemy)
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
                        dprint "The Merchant got away!",,10
                        fleet(255).mem(a)=attacker(a)
                        for b=a to lastenemy
                            attacker(b)=attacker(b+1)
                        next
                        lastenemy=lastenemy-1
                    else
                        dprint "The Merchant didn't get away",,12
                        attacker(a).c.x=60
                        attacker(a).target.x=0
                        attacker(a).c.y=rnd_range(1,20)
                        attacker(a).target.y=rnd_range(1,20)
                    endif
                endif
            endif
        next
        FSOUND_Update
    loop until victory<>0
    if attacker(16).desig="" and col=10 then atts.con(1)=-1
    cls
    defender.shield=defender.shieldmax
    defender.c=p
    if victory=3 then defender.dead=13
    if victory=2 then defender.dead=0
    if victory=1 and player.towed<>0 then
        dprint "You leave behind the ship you had in tow.",14,14
        player.towed=0
    endif
    for a=1 to 15
        atts.mem(a)=attacker(a)
    next    
    return defender
end function

function com_display(defender as _ship, attacker() as _ship, lastenemy as short, marked as short, senac as short,e_track_p() as cords,e_track_v() as short,e_last as short,mines_p() as cords,mines_v() as short,mines_last as short) as short
    dim as short x,y,a,b,c
    dim p1 as cords
    dim as short senbat,senbat1,senbat2,denemy
    dim list_c(128) as cords
    dim list_e(128) as short
    dim last as short
    
    for a=1 to lastenemy
        'if distance(attacker(a).c,defender.c)<senbat*senac then
            last+=1
            list_c(last)=attacker(a).c
            list_e(last)=a
        'endif
    next
    if mines_last>0 then
        for a=1 to mines_last
            'if distance(mines_p(a),defender.c)<senbat*senac then
                last+=1
                list_c(last)=mines_p(a)
                list_e(last)=a
            'endif
        next
    endif

    senbat=defender.sensors+2
    senbat1=defender.sensors+1
    senbat2=defender.sensors
    for x=defender.c.x-senbat*senac-1 to defender.c.x+senbat*senac+1
        for y=defender.c.y-senbat*senac-1 to defender.c.y+senbat*senac+1
            if x>=0 and y>=0 and x<61 and y<21 then
                p1.x=x
                p1.y=y
                locate y+1,x+1
                print " "
                if distance(p1,defender.c)<=senbat*senac then
                    locate y+1,x+1
                    if distance(p1,defender.c)<=senbat*senac then color 8,0
                    if distance(p1,defender.c)<=senbat1*senac then color 7,0
                    if distance(p1,defender.c)<=senbat2*senac then color 15,0
                    if combatmap(x,y)=0 then print "."
                    if combatmap(x,y)=1 or combatmap(x,y)=6 then print "o"
                    if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then
                        color rnd_range(48,59),0
                        if combatmap(x,y)=7 then color rnd_range(186,210),0
                        print chr(176)
                    endif
                endif
            endif
        next
    next
    
    for b=1 to e_last    
        locate e_track_p(b).y+1,e_track_p(b).x+1,0
        color 0,0
        if e_track_v(b)>=4 then color 15,0
        if e_track_v(b)=3 then color 11,0
        if e_track_v(b)=2 then color 9,0
        if e_track_v(b)=1 then color 1,0
        if distance(e_track_p(b),defender.c)<=senbat*(senac+1) and e_track_v(b)>0 then print "*";
        e_track_v(b)=e_track_v(b)-1
    next
    
    if mines_last>0 then
        for b=1 to mines_last
            locate mines_p(b).y+1,mines_p(b).x+1,0
            color 0,0
            print " ";
            locate mines_p(b).y+1,mines_p(b).x+1,0
            if b+lastenemy=marked then 
                color 8,11
            else
                color 8,0
            endif
            if distance(mines_p(b),defender.c)<senbat*(senac+1) then 
                print "ö";
                denemy+=1
            endif
        next
    endif
    
    for c=1 to last
        if c<=lastenemy then
            b=list_e(c)
            if c=marked then
                color attacker(b).bcol,attacker(b).col
            else
                color attacker(b).col,attacker(b).bcol
            endif
            locate attacker(b).c.y+1,attacker(b).c.x+1
            if distance(attacker(b).c,defender.c)<senbat*senac then
                denemy=denemy+1
                print "?"
            endif
            if distance(attacker(b).c,defender.c)<=senbat1*senac or distance(attacker(b).c,defender.c)<=sqr(2) then
                locate attacker(b).c.y+1,attacker(b).c.x+1
                print attacker(b).icon
            endif
        else
            b=list_e(c)
            if c=marked then
                color 0,7
                locate mines_p(b).y+1,mines_p(b).x+1,0
                print "ö";
            endif
        endif
    next 
    color 15,0
    locate defender.c.y+1,defender.c.x+1
    print "@"
    return denemy
end function

function com_gettarget(defender as _ship, wn as short, attacker() as _ship,lastenemy as short,senac as short,marked as short,e_track_p() as cords,e_track_v() as short,e_last as short,mines_p() as cords,mines_v() as short,mines_last as short) as short
    
    dim targetno as short
    dim as short a,d
    dim as short senbat,senbat1,senbat2
    dim as string key,text,id
    dim list_c(128) as cords
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
            do
                marked=marked+d
                if marked<1 then marked=last
                if marked>last then marked=1
            loop until list_e(marked)<>0 and distance(defender.c,list_c(marked))<senbat*senac
            if key=key_enter then targetno=marked
            if key=key_esc then targetno=-1
            
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

function com_fire(target as _ship, w as _weap, gunner as short, range as short,senac as short) as _ship
    dim as short roll,ROF
    ROF=w.ROF

    if w.ammomax>0 and w.ROF>0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(7)) 'Laser         
    if w.ammomax>0 and w.ROF=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(8)) 'Missile battery          
    if w.ammomax=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(9)) 'Missile                                           
    do
        if w.ammomax>0 then w.ammo=w.ammo-1 
        if w.ammo>0 or w.ammomax=0 then
            roll=rnd_range(1,6)+rnd_range(1,6)+gunner+senac-(target.ecm*w.ecmmod)
            'if range<=w.range*3 then roll=roll+1
            if range<=w.range*2 then roll=roll+1
            if range<=w.range then roll=roll+2
            if roll>12 then 
                target=com_hit(target,w,range, senac)
            else
                if w.p>0 then
                    dprint w.desig &" fired, and misses!"
                else
                    dprint "It missed."
                endif
                no_key=keyin
            endif
        endif
        ROF-=1
    loop until ROF<=0
    return target
end function

function com_hit(target as _ship, w as _weap, range as short, senac as short) as _ship
    dim as string desig, text
    dim as short roll
    
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
    
    target.shield=target.shield-w.dam
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
    dprint text
    if text<>"" then no_key=keyin
    if target.shield<0 then target.shield=0
    return target
end function

function com_dropmine(defender as _ship,mines_p() as cords,mines_v() as short,byref mines_last as short) as short
    dim p as cords
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

function com_detonatemine(d as short,mines_p() as cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship, byref lastenemy as short) as short
    dim as short x,y,t,r,dis,a,dam
    dim as cords p
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
                    locate p.y+1,p.x+1,0
                    color 242+dis,0
                    print "*";
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        locate p.y+1,p.x+1,0
                        color 0,0
                        print " ";
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
                    locate p.y+1,p.x+1,0
                    color 242+dis
                    print "*";
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        locate p.y+1,p.x+1,0
                        color 0,0
                        print " ";
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
                dprint attacker(a).desig &" destroyed",,10
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
    dprint text,,col
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
                dprint "engine hit!",12,12
                t.engine=t.engine-1
            
            endif
        endif
        
        if a=2 then
            if t.sensors<2 then
                t.sensors=1
                a=rnd_range(3,l)
            else
                dprint "Sensors damaged!",12,12
                t.sensors=t.sensors-1
            endif
        endif
        
        if a=3 then 
            if t.shieldmax>0 then
                dprint "Shield generator damaged!",12,12
                t.shieldmax=t.shieldmax+1
            else
                a=rnd_range(3,l)
            endif
        endif
        
        if a=4 then
            t.hulltype=t.hulltype-1
            dprint "critical damage to ship structure!",12,12
            recalcshipsbays
        endif
        
        if a=5 then
            dprint "Cargo bay hit",12,12
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
                dprint t.weapons(b).desig &"hit and destroyed!",12,12
                if t.weapons(b).desig="Fuel tank" then
                    b=rnd_range(1,6)
                    dprint "it explodes! "& b &" points of damage!"
                    player.hull=player.hull-b
                endif
                
                if t.weapons(b).desig="Crew Quarters" then
                    b=rnd_range(1,6)
                    t.security=t.security-b
                    if t.security<0 then
                        b=b+t.security
                        t.security=0
                    endif
                    dprint  b &" casualties!",12,12
                endif
                
                t.weapons(b)=makeweapon(-1)
                recalcshipsbays
            else
                dprint "weapons turret hit but undamaged!",10,10
            endif
        endif
        
        if a=7 then
            b=rnd_range(1,6)
            t.security=t.security-b
            if t.security<0 then
                b=b+t.security
                t.security=0
            endif
            dprint "Crew quaters hit! "& b &" casualties!",12,12
            removemember(b,0)
            player.deadredshirts=player.deadredshirts+1
        endif 

        if a=8 then
            dprint "A direct hit on the bridge!"
            
            if rnd_range(1,6)+rnd_range(1,6)>7 then
                b=rnd_range(1,4)
                if b=1 and t.pilot>0 then 
                    t.pilot=captainskill
                    text="Pilot "
                endif
                if b=2 and t.gunner>0 then 
                    t.gunner=captainskill
                    text="Gunner "
                endif
                if b=3 and t.science>0 then 
                    t.science=captainskill
                    text="Science Officer "
                endif
                if b=4 and t.Doctor>0 then 
                    t.doctor=captainskill
                    text="Doctor "
                endif
                if t.desig=player.desig then 
                    dprint "An Explosion! Our "&text &"was killed!"
                    player.deadredshirts=player.deadredshirts+1
                endif
            endif
        endif
    return t
end function

function com_flee(defender as _ship,lastenemy as short) as short
    dim as short roll,victory 
    if defender.c.x=0 or defender.c.x=60 or defender.c.y=0 or defender.c.y=20 then
        roll=rnd_range(1,6)+rnd_range(1,6)+defender.pilot+addtalent(2,7,1)
        if findbest(25,-1)>0 then roll=roll+5
        if roll>6+lastenemy then
                dprint "you manage to get away",,10
                victory=1            
            else
                cls
                displayship(0)
                dprint "you dont get away",,12
                defender.c.x=30
                defender.c.y=10
            endif
       
    else
        dprint "you need to be at a map border"
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

function com_testweap(w as _weap, p1 as cords,attacker() as _ship,lastenemy as short,mines_p() as cords ,mines_last as short) as short
    dim r as short
    dim a as short
    dim b as short
    
    if w.dam>0 then
        r=-1 'kein cargo bay oder empty slot
        if w.ammomax>0 and w.ammo<=0 then r=0 'waffe braucht ammo und hat keine
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

function com_remove(attacker() as _ship, t as short, lastenemy as short) as short
    dim a as short
    for a=t to lastenemy
        attacker(a)=attacker(a+1)
    next
    lastenemy=lastenemy-1
    return lastenemy
end function
