
function spacecombat(byref atts as _fleet,ter as short) as short
    dim attacker(16) as _ship
    'dim direction(15) as byte
    'dim dontgothere(15) as byte
    'dim speed(15) as short
    'dim tick(15) as single
    'dim tickr(15) as single
    dim as byte manjetson
    'dim movementcost(15) as short
    dim col as short
    dim st as integer
'    dim nexsen as short
'    dim senbat as short
'    dim senbat1 as short
'    dim senbat2 as short

    dim as short a,b,c,d,e,f,l,last
    dim as string ws(15)
    dim as short tic,t,w
    'dim lastenemy as short
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
    dim e_map(60,20) as byte
    dim as short noenemies
    dim mines_p(128) as _cords
    dim mines_v(128) as short
    dim mines_last as short
    dim as byte localturn
    dim old as _cords
    dim as _cords exitcords
    dim as byte debug=11
    dim as string dbugstring
    'debug=10
    if debug=10 then
        for a=0 to 128
            if e_track_v(a)>0 then dprint ""&e_track_v(a)
        next
    endif
    for x=0 to 60
        for y=0 to 20
            combatmap(x,y)=0
            if rnd_range(1,100)<ter/2 then 
                combatmap(x,y)=rnd_range(1,5)
                if ter=20 then combatmap(x,y)=6 'Asteroid field 
                if ter=21 then combatmap(x,y)=7 'Gas giant
            endif
            if rnd_range(1,100)<13 and (rnd_range(1,100)<3 or ter>=20) then
                combatmap(x,y)=rnd_range(1,7)
            endif
        next
    next
    victory=0
    col=12
    exitcords.x=player.c.x
    exitcords.y=player.c.y
    player.aggr=1 '1= one of the good guys
    b=0
    for a=1 to 15
        if atts.mem(a).hull>0 then
            
            b+=1
            noenemies+=1
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
    p=player.c
    player.dead=-1
    player.c.x=30
    player.c.y=10
    player.senac=1
    for a=1 to 15
        if attacker(a).shiptype=2 then
            dprint player.aggr &"§:&"&attacker(a).aggr
            if attacker(a).aggr=0 then 'This is where you start when you attack a spacestation 
                player.c.x=0
                player.c=movepoint(player.c,5)
            else
                player.c.y=11
                player.c.x=31
            endif
        endif
    next
    
    com_NPCMove(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last)
'    senac=1
'    senbat=defender.sensors+2
'    senbat1=defender.sensors+1
'    senbat2=defender.sensors
'    if attacker(1).shiptype=2 then 
'        dprint "Attacking station"
'        attacker(1).c.x=30
'        attacker(1).c.y=10
'        defender.c.x=0
'        defender.c.y=10
'    endif
    screenset 0,1
    cls
    l=display_ship(0)
    last=string_towords(ws(),comstr,";")
    for d=1 to last
        set__color(15,0)
        draw string((_mwx+2)*_fw1,(d+l)*_fh2),ws(d),,Font2,custom,@_col
    next
    f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
    dprint ""
    
    do
'        
'        nexsen=senac
'        'movement
'        movementcost(0)=defender.engine+2-cint(defender.h_maxhull\15)+defender.manjets*(1+manjetson)
'        if movementcost(0)<1 then movementcost(0)=1
'        lastaction(0)-=1
'        speed(0)=speed(0)+defender.engine+2-cint(defender.h_maxhull\15)+defender.manjets
'        if speed(0)<1 then speed(0)=1
'        st=speed(0)
'        for a=1 to lastenemy
'            movementcost(a)=10-attacker(a).engine
'            lastaction(a)-=1
'            speed(a)=speed(a)+attacker(a).engine
'            if attacker(a).c.x=attacker(a+1).c.x and attacker(a).c.y=attacker(a+1).c.y  then attacker(a).c=movepoint(attacker(a).c,5)
'            if st<speed(a) then st=speed(a)
'        next
'        
'        for a=0 to lastenemy
'            tickr(a)=10/speed(a)
'            tick(a)=0
'        next
        
        player.energy-=1
        if player.energy<0 then player.energy=0
        if debug=9 then dbugstring="Player:"&player.energy
        for a=1 to 14
            attacker(a).energy-=1
            if attacker(a).energy<0 then attacker(a).energy=0
            if debug=9 then dbugstring=dbugstring & " " & a &"-"&attacker(a).energy
        next
        if debug=9 then dprint dbugstring
        
   '        
            key=""
            if player.hull>0 then 'playermovement
                if player.energy<=0 then 
               
                if debug=9 then dprint ""&f
                if player.c.x=0 or player.c.y=0 or player.c.x=60 or player.c.y=20 then f=-1
                
                if f<>0 then 
                    comstr= key_fi &" to fire weapons;"&key_dr &" to drop mines;"&key_sc &" to scan enemy ships;"& key_ra & " to call opponents;" &key_ru & " to run and flee."
                else
                    comstr= key_dr &" to drop mines;"& key_ra & " to call opponents;" &key_ru & " to run and flee."
                endif
                'set__color( 11,0
                'draw string(62*_fw1,5*_fh2), "Engine :"&player.engine &" ("&speed(0) &" MP)",,Font2,custom,@_col
    
                key=keyin("1234678"&key_ac &key_ra &key_sh &key_sc &key_ru &key__esc &key_dr &key_fi &key_sh &key_ru &key_togglemanjets &key_cheat)
                if key=key_ac then
                    if player.senac=2 then player.senac=1
                    if player.senac=1 then player.senac=2
                    player.energy+=1
                endif
                                
                if key=key_ra then 
                    dprint "Calling other ships"
                    victory=com_radio(attacker())
                endif
                
                if key=key_cheat then com_cheat=1
                
                if key=key_togglemanjets then
                    if player.manjets=0 then 
                        dprint "you have no manjets"
                    else
                        player.energy+=1 
                        if manjetson=0 then
                            manjetson=1
                            dprint "you turn on maneuvering jets"
                        else
                            manjetson=0
                            dprint "you turn off your maneuvering jets"
                        endif
                    endif
                endif
                
                if key=key_sh and player.shieldmax>0 then 
                    if askyn ("Do you really want to shut down your shields? (y/n)") then
                        player.shield=0
                        shieldshut=1
                        player.energy+=1
                    endif
                endif
                
                if key=key_ru then 
                    victory=com_flee(player,attacker())
                    'if victory=1 then
                        'player.c=exitcords
                        'return 0
                    'endif
                endif
                
                if key=key_dr then
                    com_dropmine(player,mines_p(),mines_v(),mines_last,attacker())
                    player.energy+=1
                endif
                
                if f<>0 and player.hull>0 then
                    if key=key_sc then
                        player.energy+=1
                        t=com_gettarget(player,w,attacker(),t,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
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
                            textbox(com_shipbox(attacker(t),distance(player.c,attacker(t).c)),x,y,20,15,1)
                            player.energy+=1
                            'no_key=keyin
                        endif
                    endif
                    if key=key_fi then
                        player.energy+=1
                        do 
                            w=com_getweapon()
                            if w>0 then
                                if player.weapons(w).ammomax>0 and player.weapons(w).ammo<=0 then dprint player.weapons(w).desig &" is out of ammunition.",14
                                if com_testweap(player.weapons(w),player.c,attacker(),mines_p(),mines_last) then
                                    t=com_gettarget(player,w,attacker(),t,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                                    if t>0 and t<100 then 
                                        if pathblock(player.c,attacker(t).c,0,2,player.weapons(w).col)=-1 then
                                            attacker(t)=com_fire(attacker(t),player,player.weapons(w),player.gunner(0)+addtalent(3,12,1),distance(player.c,attacker(t).c))
                                            'lastaction(0)=lastaction(0)+1
                                            player.weapons(w).reloading=player.weapons(w).reload
                                            if attacker(t).hull<=0 then
                                                dprint "Target destroyed",10
                                                reward(3)=reward(3)+attacker(t).money
                                                player.piratekills=player.piratekills+attacker(t).money
                                                com_remove(attacker(),t)
                                                t=0
                                                'no_key=keyin
                                            endif
                                            'no_key=keyin()
                                        endif
                                    endif
                                    if t>100 then com_detonatemine(t-100,mines_p(), mines_v() ,mines_last, player , attacker())
                                endif
                            endif    
                            screenset 0,1
                            cls
                            
                            f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                            dprint ""
                            flip
                            
                            key=""
                        loop until t=0 or w=0
                        
                    endif
                    if key=key_ru then victory=com_flee(player,attacker())
                    if victory=1 then 
                        player.c=exitcords
                        return 0
                    endif
                endif
                
                
                if getdirection(key)<>0 then 
                    player.di=getdirection(key)
                
                    old=player.c
                    player.c=movepoint(player.c,getdirection(key))
                    e_last=com_add_e_track(player,e_track_p(),e_track_v(),e_map(),e_last)
                        
                    if combatmap(player.c.x,player.c.y)>0 and rnd_Range(1,6)+rnd_range(1,6)+player.pilot(0)<combatmap(player.c.x,player.c.y)*2 then
                        player.shield=player.shield-1
                        if player.shield<0 then
                            player.hull=player.hull+player.shield
                            player.shield=0                        
                            if combatmap(player.c.x,player.c.y)=1 or combatmap(player.c.x,player.c.y)=6 then 
                                dprint "You damage your ship hitting an asteroid!",14
                            else
                                dprint "You damage your ship hitting a glas cloud!",14
                            endif
                        endif
                    endif
                    if mines_last>0 then
                        for c=1 to mines_last
                            if player.c.x=mines_p(c).x and player.c.y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, player , attacker() )
                            endif
                        next
                    endif
                    
                        '
                        if e_map(player.c.x,player.c.y)>0 then
                            
                            c=e_map(player.c.x,player.c.y)
                            if e_track_v(c)=0 then 
                                e_map(player.c.x,player.c.y)=0
                            else
                                player.shield=player.shield-e_track_v(c)
                                text="The "&player.desig &" runs into a plasma stream! "
                                if debug=10 then text=text &c &":"&e_track_v(c) &"_" &e_track_p(c).y &":"&e_track_p(c).y
                                if player.shield<0 and player.shieldmax>0 then text=text &"Shields penetrated! "
                                if player.shield<0 then 
                                    player.hull=player.hull+player.shield
                                    player.shield=0
                                endif
                                if player.hull<=0 then text=text &player.desig &" destroyed!"                        
                                dprint text,c_red
                            'no_key=keyin
                            endif
                        endif
                    if old.x<>player.c.x or old.y<>player.c.y then player.energy=player.energy+10-player.movepoints(manjetson)
                endif      
                
'                screenset 0,1
'                cls
'                displayship(0)
'                com_display(player, attacker(),lastenemy,0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                endif
            endif
            
            'Other ships fire
            com_NPCFire(player,attacker())
            
            com_NPCMove(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last)
            
            
            if mines_last>0 then
                for b=1 to 14
                    if attacker(b).hull>0 then
                        for c=1 to mines_last
                            if attacker(b).c.x=mines_p(c).x and attacker(b).c.y=mines_p(c).y then 
                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, player , attacker())
                            endif
                        next
                    endif
                next
            endif
                    
        if localturn mod 2=0 then
            for b=1 to e_last
                e_track_v(b)=e_track_v(b)-1
                if e_track_v(b)<=0 then
                    e_map(e_track_p(b).x,e_track_p(b).y)=0
                    e_track_v(b)=e_track_v(e_last)
                    e_track_p(b)=e_track_p(e_last)
                    e_last-=1
                    e_map(e_track_p(b).x,e_track_p(b).y)=e_last
                endif
            next
        endif
        
        if localturn mod 5=0 then
            for a=1 to 14
                if attacker(a).hull>0 then com_regshields(attacker(a))
            next
            com_regshields(player)
        
            com_sinkheat(player,manjetson)
            for a=1 to 14
                com_sinkheat(attacker(a),0)
            next
        endif
        
        localturn+=1
        if key=key_ru and victory<>1 then victory=com_flee(player,attacker())
        if victory=1 then
            player.c=exitcords
            return 0
        endif

        if com_victory(attacker())<=0 then victory=2
        if player.hull<=0 then victory=3
        
        'merchant flee atempt
        for a=1 to 14
            if attacker(a).shiptype=1 then
                if attacker(a).c.x=attacker(a).target.x and attacker(a).c.y=attacker(a).target.y then
                    if rnd_range(1,6)+rnd_range(1,6)+attacker(a).pilot(0)>6+player.pilot(0) then
                        dprint "The Merchant got away!",10
                        fleet(255).mem(a)=attacker(a)
                        com_remove(attacker(),a,1)
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
        
        screenset 0,1
        cls
        display_ship(0)
        f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        dprint ""

        
        #ifdef FMODSOUND
        FSOUND_Update
        #endif
        
        
        
    loop until victory<>0 or player.dead=6
    
    if attacker(16).desig="" and col=10 then atts.con(1)=-1
    player.shield=player.shieldmax
    player.c=p
    if victory=3 then 
        if player.dead<>0 then screenshot(3)
        if atts.ty=1 or atts.ty=3 then player.dead=5 'merchants
        if atts.ty=2 or atts.ty=4 then player.dead=13 'Pirates
        if atts.ty=8 then player.dead=20 'Asteroid belt monster '
        if atts.ty=5 then player.dead=21 'ACSC
        if atts.ty=9 then player.dead=23 'GG monster
        if atts.ty=6 then player.dead=31 'Civ 1
        if atts.ty=7 then player.dead=32 'Civ 2
    endif
    if victory=2 then 
        player.dead=0
        if atts.ty=2 or atts.ty=8 then combon(8).value+=noenemies
        dprint "All enemy ships destroyed",c_gre
    endif
    if victory=1 and player.towed<>0 then
        dprint "You leave behind the ship you had in tow.",14
        player.towed=0
    endif
    if victory=2 or victory=1 then
        for a=0 to lastitem
            if item(a).ty=67 and item(a).w.p<0 then
                b=abs(item(a).w.p)
                if attacker(b).hull<=0 or victory=1 then 
                    if victory=1 then dprint "You leave behind a "&item(a).desig &".",14
                    destroyitem(a)
                else
                    dprint "You take a "&item(a).desig &" on board.",c_gre
                    item(a).w.s=-1
                    item(a).w.p=0
                    item(a).v1=attacker(b).hull
                    attacker(b)=attacker(0)
                endif
            endif
        next
    endif
    for a=1 to 15
        atts.mem(a)=attacker(a)
    next    
    for a=1 to 5
        player.weapons(a).reloading=0
        player.weapons(a).heat=0
    next
        
    'screenset 0,1
'    cls
'    displayship(0)
'    f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
'    dprint ""
'    flip
'    
    'no_key=keyin
    
    screenset 0,1
    
    cls
    show_stars(1)
    display_ship(1)
    dprint ""
    
    flip
    screenset 1,1
    
    return 0
end function

function com_add_e_track(ship as _ship,e_track_p() as _cords,e_track_v() as short, e_map() as byte,e_last as short) as short
    dim p as _cords
    dim i as short
    p=ship.c
    p=movepoint(p,ship.diop())
    e_last+=1
    if e_last>128 then e_last=1
    e_track_p(e_last)=p
    e_track_v(e_last)=ship.engine+2
    e_map(p.x,p.y)=e_last
    return e_last
end function

function com_radio(attacker() as _ship) as short
    dim as short victory,hp,a,cargo,od
    for a=0 to 15
        hp+=attacker(a).hull
    next
    for a=0 to 10
        if player.cargo(a).x>1 then cargo+=1
    next
    od=player.dead
    player.dead=0
    a=menu("Calling other ships/Ask for Surrender/Offer Surrender/Never mind","",2,2)
    player.dead=od
    select case a
    case is=1
        if hp<player.hull+rnd_range(0,player.hull) then
            dprint "They agree"
            victory=1
        else
            dprint "They don't agree"
        endif
    case is=2
        if cargo>0 then
            if askyn("Do you agree to give up your cargo?(y/n)") then
                victory=2
                for a=0 to 10
                    if player.cargo(a).x>0 then player.cargo(a).x=1
                    player.cargo(a).y=0
                next
            else
                dprint "They refuse."
            endif
        else
            dprint "You have nothing to offer"
        endif
    end select
    
    return victory
end function


function com_direction(dest as _cords,target as _cords) as short
    
    dim as short dx,dy,direction,debug,osx
    
    dx=target.x-dest.x
    dy=target.y-dest.y
    if dx<0 and dy>0 then direction=1
    if dx=0 and dy>0 then direction=2
    if dx>0 and dy>0 then direction=3
    if dx<0 and dy=0 then direction=4
    if dx>0 and dy=0 then direction=6
    if dx<0 and dy<0 then direction=7
    if dx=0 and dy<0 then direction=8
    if dx>0 and dy<0 then direction=9
    if debug=1 then
        set__color(11,0)
        screenset 1,1
        osx=calcosx(player.c.x,1)
        draw string((target.x-osx)*_fw1,target.y*_fh1),""&direction,,font1,custom,@_col
                
    endif
    return direction
    
end function

function com_turn(dircur as byte,dirdest as byte,turnrate as byte) as short
    'Returns the direction to get from dircur to dirdest
    dim as short disright,disleft,tdir,rightleft,debug,f
    
    if debug=1 then
        f=freefile
        open "turningdata.csv" for output as #f
    endif
    if dircur<>dirdest then
        
        tdir=dircur
        do
            tdir=bestaltdir(tdir,0)
            disright+=1
            if debug=1 then print #f,dirdest &";"&tdir
        loop until tdir=dirdest or disright>9
        
        tdir=dircur
        do
            tdir=bestaltdir(tdir,1)
            disleft+=1
            if debug=1 then print #f,dirdest &";"&tdir
        loop until tdir=dirdest or disleft>9
        if disright=disleft then
            return bestaltdir(dircur,rnd_range(0,1))
        else
            if disright<disleft then rightleft=0'return bestaltdir(dircur,0)
            if disright>disleft then rightleft=1'return bestaltdir(dircur,1)
            do
                dircur=bestaltdir(dircur,rightleft)
                turnrate-=1
            loop until dircur=dirdest or turnrate=0
            return dircur
        endif
    endif
    if debug=1 then close #f
    return dirdest
end function

function com_NPCMove(defender as _ship,attacker() as _ship,e_track_p() as _cords,e_track_v() as short,e_map() as byte,byref e_last as short) as short
    dim as short b,c,debug,i,a
    dim as string text
    dim dontgothere(15) as short
    dim as _cords old 
    debug=2
    com_findtarget(defender,attacker())
    for b=1 to 14 'enemymovement
        if attacker(b).hull>0 then
            if attacker(b).energy<=0 and attacker(b).engine>0 then
                if attacker(b).target.x<>attacker(b).c.x or attacker(b).target.y<>attacker(b).c.y then
                   attacker(b).di=com_turn(attacker(b).di,com_direction(attacker(b).c,attacker(b).target),attacker(b).turnrate)
                   if debug=1 then dprint ""&com_direction(attacker(b).c,attacker(b).target)
                   old=attacker(b).c
                   attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                   if (e_map(attacker(b).c.x,attacker(b).c.y)>0 or combatmap(attacker(b).c.x,attacker(b).c.y)>0) and rnd_range(1,attacker(b).pilot(0))+rnd_range(1,6)>8 then
                        attacker(b).di=bestaltdir(attacker(b).di,rnd_range(0,1))
                        attacker(b).c=old
                        attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                        attacker(b).energy+=1
                   endif         
                   if old.x<>attacker(b).c.x or old.y<>attacker(b).c.y then 
                        attacker(b).energy=attacker(b).energy+(10-attacker(b).movepoints(0))
                        e_last=com_add_e_track(attacker(b),e_track_p() ,e_track_v() , e_map() ,e_last)
                   endif
                endif
                if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                if e_map(attacker(b).c.x,attacker(b).c.y)>0 then
                    a=e_map(attacker(b).c.x,attacker(b).c.y)
                    attacker(b).shield=attacker(b).shield-e_track_v(a)
                    text=attacker(b).desig &" runs into plasma stream! "
                    if attacker(b).shield<0 and attacker(b).shieldmax>0 then text=text &"Shields penetrated! "
                    if attacker(b).shield<0 then
                        attacker(b).hull=attacker(b).hull+attacker(b).shield
                        attacker(b).shield=0
                    endif
                    if attacker(b).hull<=0 then 
                        text=text &attacker(b).desig &" destroyed!"
                        player.piratekills=player.piratekills+attacker(b).money
                        com_remove(attacker(),b)
                    endif
                    if distance(attacker(b).c,player.c)<=player.sensors*player.senac then 
                        dprint text,10
                    else
                        if attacker(b).hull<=0 then dprint "Registering explosion at "&attacker(b).c.x &":"&attacker(b).c.y &"!",c_gre
                    endif
                endif
            endif
        endif
    next b
    return 0
end function

'                    if attacker(b).shiptype=0 then                    
'                        if distance(defender.c,attacker(b).c)<attacker(b).sensors+defender.sensors*(senac-1) then
'                            attacker(b).target.x=defender.c.x
'                            attacker(b).target.y=defender.c.y
'                        else
'                            attacker(b).target.x=-1
'                            attacker(b).target.y=-1
'                        endif
'                    endif
'                    if attacker(b).shiptype=1 then
'                        attacker(b).target.x=0
'                        attacker(b).target.y=attacker(b).c.y
'                    endif
'                    if attacker(b).target.x=-1 and attacker(b).target.y=-1 then
'                        if rnd_range(1,100)<33 then 
'                            if rnd_range(1,100)<50 then
'                                attacker(b).di-=1
'                            else
'                                attacker(b).di+=1
'                            endif
'                        endif
'                        if attacker(b).di<1 then attacker(b).di=9
'                        if attacker(b).di>9 then attacker(b).di=1
'                    
'                        if attacker(b).c.x=0 and (attacker(b).di=7 or attacker(b).di=4 or attacker(b).di=1) then
'                            if rnd_range(1,20)<attacker(b).c.y then
'                                attacker(b).di=9   
'                            else
'                                attacker(b).di=3   
'                            endif
'                        endif
'                        if attacker(b).c.x=60 and (attacker(b).di=9 or attacker(b).di=6 or attacker(b).di=3) then
'                            if rnd_range(1,20)<attacker(b).c.y then
'                                attacker(b).di=7   
'                            else
'                                attacker(b).di=1   
'                            endif
'                        endif   
'                        if attacker(b).c.y=0 and (attacker(b).di=7 or attacker(b).di=8 or attacker(b).di=9) then 
'                            if rnd_range(1,60)<attacker(b).c.x then
'                                attacker(b).di=1   
'                            else
'                                attacker(b).di=3   
'                            endif
'                        endif   
'                        if attacker(b).c.y=20 and (attacker(b).di=1 or attacker(b).di=2 or attacker(b).di=3) then 
'                            if rnd_range(1,60)<attacker(b).c.x then
'                                attacker(b).di=7   
'                            else
'                                attacker(b).di=9   
'                            endif
'                        endif   
'                    else
'                        attacker(b).di=nearest(attacker(b).target,attacker(b).c)
'                    endif
'                    if dontgothere(b)=attacker(b).di then
'                        if rnd_range(1,100)>50 then
'                            attacker(b).di+=1
'                            if attacker(b).di>9 then attacker(b).di=6
'                        else
'                            attacker(b).di-=1
'                            if attacker(b).di<1 then attacker(b).di=4
'                        endif
'                    endif
'                    if attacker(b).di<>0 then
'                        old=attacker(b).c
'                        dontgothere(b)=10-attacker(b).di
'                        attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
'                        e_last=e_last+1
'                        if e_last>128 then e_last=1
'                        e_track_p(e_last)=movepoint(attacker(b).c,10-attacker(b).di)
'                        e_track_v(e_last)=attacker(b).engine
'                        'speed(b)=speed(b)-1
'                        'tick(b)=tick(b)+tickr(b)
'                    endif
'                    if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then attacker(b).c=old
''                    if mines_last>0 then
''                        for c=1 to mines_last
''                            if attacker(b).c.x=mines_p(c).x and attacker(b).c.y=mines_p(c).y then 
''                                com_detonatemine(c,mines_p(), mines_v() ,mines_last, defender , attacker() ,lastenemy)
''                            endif
''                        next
''                    endif

function com_NPCFire(defender as _ship,attacker() as _ship) as short
    dim as short a,b,t,d
    
                for a=1 to 14
                if attacker(a).hull>0 then
                'if distance(attacker(a).c,defender.c)<=attacker(a).sensors and lastaction(a)<=0 then
                    'in sensor range
                    for b=0 to 25
                        if attacker(a).weapons(b).desig<>"" then
                            if attacker(a).weapons(b).heat<attacker(a).gunner(0) then
                                
                                'waffe forhanden
                                t=attacker(a).target.m
                                if t>=0 then
                                    if t=0 then 
                                        d=distance(defender.c,attacker(a).c)
                                    else
                                        d=distance(attacker(a).c,attacker(t).c)
                                    endif
                                    if d<=attacker(a).sensors then
                                        if t=0 then com_NPCFireweapon(defender,attacker(a),b)
                                        if t>0 then com_NPCFireweapon(attacker(t),attacker(a),b)
                                    endif
                                endif
                            endif
                        endif
                    next b
                endif
            next a
    return 0
end function

function com_NPCfireweapon(byref defender as _ship, byref attacker as _ship,b as short) as short
    if attacker.weapons(b).reloading<=0 then
    if distance(attacker.c,defender.c)<attacker.weapons(b).range*3 then
        'in reichweite
        if attacker.weapons(b).ammo>0 or attacker.weapons(b).ammomax=0 then
            'muni vorhanden
            if pathblock(attacker.c,defender.c,0,2,attacker.weapons(b).col)=-1 then
                defender=com_fire(defender,attacker,attacker.weapons(b),attacker.gunner(0),distance(attacker.c,defender.c))
                display_ship(0)
            endif
        endif
    endif
    endif
    return 0
end function


function com_findtarget(defender as _ship,attacker() as _ship) as short
    dim targettable(14,14) as short
    dim as short a,b,t,v,dx,dy
    for a=1 to 14
        if attacker(a).hull>0 then
            if attacker(a).shiptype=0 or attacker(a).shiptype=2 then
                attacker(a).target.x=-1
                attacker(a).target.y=-1
                targettable(a,0)=com_evaltarget(attacker(a),defender)
                if targettable(a,0)>0 then
                    t=0
                    v=targettable(a,0)
                else
                    t=-1
                    v=0
                endif
                for b=1 to 14
                    if b<>a then
                        targettable(a,b)=com_evaltarget(attacker(a),attacker(b))
                        if targettable(a,b)>v then
                            t=b
                            v=targettable(a,b)
                        endif
                    endif
                next
                dprint attacker(a).desig &" evals target result:"&t
                if t>0 then attacker(a).target=attacker(t).c
                if t=0 then attacker(a).target=defender.c
                if t=-1 then 
                    attacker(a).target=rnd_point
                    attacker(a).senac=2
                else
                    attacker(a).senac=1
                endif
                dx=(attacker(a).target.x-attacker(a).c.x)
                dy=(attacker(a).target.y-attacker(a).c.y)
                if dx>0 then dx=-1
                if dx<0 then dx=+1
                if dy<0 then dy=-1
                if dy>0 then dy=+1
                attacker(a).target.x+=dx
                attacker(a).target.y+=dy
                if attacker(a).target.x<0 then attacker(a).target.x=0
                if attacker(a).target.x>60 then attacker(a).target.x=60
                if attacker(a).target.y<0 then attacker(a).target.y=0
                if attacker(a).target.y>20 then attacker(a).target.y=20
                attacker(a).target.m=t
            else
                attacker(a).target.x=0
                attacker(a).target.y=rnd_range(1,20)
                attacker(a).target.m=attacker(a).aggr
            endif
        endif
    next
    return 0
end function

function com_shipfromtarget(target as _cords,defender as _ship,attacker() as _ship) as short
    dim a as short
    if defender.c.x=target.x and defender.c.y=target.y then return -1
    for a=1 to 14
        if attacker(a).hull>0 and attacker(a).c.x=target.x and attacker(a).c.y=target.y then return a
    next
    return 0
end function

function com_evaltarget(attacker as _ship,defender as _ship) as short
    dim as short d,h
    if attacker.aggr=defender.aggr then return -1 'Ships are in the same group
    if distance(attacker.c,defender.c)>attacker.sensors*attacker.senac+defender.sensors*(defender.senac-1) then return -1
    return distance(attacker.c,defender.c)*10/defender.hull
end function

function com_display(defender as _ship, attacker() as _ship,  marked as short, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    dim as short x,y,a,b,c,f,osx
    dim as single d
    dim p1 as _cords
    dim as short senbat,senbat1,senbat2,denemy
    dim list_c(128) as _cords
    dim list_e(128) as short
    dim last as short
    dim debug as byte
    debug=3
    for a=1 to 14
        if attacker(a).hull>0 then
            last+=1
            list_c(last)=attacker(a).c
            list_e(last)=a
        endif
    next
    if mines_last>0 then
        for a=1 to mines_last
            last+=1
            list_c(last)=mines_p(a)
            list_e(last)=100+a        
        next
    endif
    osx=calcosx(defender.c.x,1)
    
    senbat =(defender.sensors+2)*defender.senac
    senbat1=(defender.sensors+1)*defender.senac
    senbat2= defender.sensors   *defender.senac
    for x=defender.c.x-senbat-1 to defender.c.x+senbat+1
        for y=defender.c.y-senbat-1 to defender.c.y+senbat+1
            if x>=osx and y>=0 and x<=_mwx+osx and x<=60 and x>=0 and y<=20 then
                p1.x=x
                p1.y=y
                draw string((x-osx)*_fw1,y*_fh1)," ",,font1,custom,@_col
                if distance(p1,defender.c)<=senbat or com_cheat=1 then
                    if _tiles=0 then
                        if distance(p1,defender.c)<=senbat and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(78),trans
                        if distance(p1,defender.c)<=senbat1 and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(79),trans
                        if distance(p1,defender.c)<=senbat2 and combatmap(x,y)=0 then put ((x-osx)*_tix,y*_tiy),gtiles(80),trans
                        if combatmap(x,y)=1 or combatmap(x,y)=6 then put ((x-osx)*_tix,y*_tiy),gtiles(76),trans
                        if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then put ((x-osx)*_tix,y*_tiy),gtiles(51),trans
                    else
                        if distance(p1,defender.c)<=senbat then set__color( 8,0)
                        if distance(p1,defender.c)<=senbat1 then set__color( 7,0)
                        if distance(p1,defender.c)<=senbat2 then set__color( 15,0)
                        if combatmap(x,y)=0 then draw string(x*_fw1,y*_fh1),".",,font1,custom,@_col
                        if combatmap(x,y)=1 or combatmap(x,y)=6 then draw string(x*_fw1,y*_fh1),chr(183),,font1,custom,@_col
                        if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then
                            set__color( rnd_range(48,59),0)
                            if combatmap(x,y)=7 then set__color( rnd_range(186,210),0)
                            draw string(x*_fw1,y*_fh1), chr(176),,font1,custom,@_col
                        endif
                    endif
                endif
            endif
        next
    next
    if e_last>0 then
        for b=1 to e_last
            if distance(e_track_p(b),defender.c)<=senbat+e_track_v(b)*2 and e_track_v(b)>0 then 
                if _tiles=0 then
                    if e_track_v(b)>=4 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(81),trans
                    if e_track_v(b)=3 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(82),trans
                    if e_track_v(b)=2 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(83),trans
                    if e_track_v(b)=1 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(84),trans
                    if debug=2 then draw string(e_track_p(b).x*_fw1,e_track_p(b).y*_fh1),""&e_track_v(b),,font1,custom,@_col 
                else
                    set__color( 0,0)
                    if e_track_v(b)>=4 then set__color( 15,0)
                    if e_track_v(b)=3 then set__color( 11,0)
                    if e_track_v(b)=2 then set__color( 9,0)
                    if e_track_v(b)=1 then set__color( 1,0 )
                    draw string(e_track_p(b).x*_fw1,e_track_p(b).y*_fh1),"*",,font1,custom,@_col 
                endif
            endif
        next
    endif
    if mines_last>0 then
        for b=1 to mines_last
            set__color( 0,0)
            draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1)," ",,font1,custom,@_col
            if _tiles=0 then
                if distance(mines_p(b),defender.c)<senbat then 
                    put ((mines_p(b).x-osx)*_fw1,mines_p(b).y*_fh1),gtiles(gt_no(item(mines_v(b)).ti_no)),trans
                    denemy+=1
                endif
                if b=marked then put (mines_p(b).x*_fw1,mines_p(b).y*_fh1),gtiles(85),trans
            else
                if b=marked then 
                    set__color( 8,11)
                else
                    set__color( 8,0)
                endif
                if distance(mines_p(b),defender.c)<senbat then 
                    draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1),"ö",,font1,custom,@_col
                    denemy+=1
                endif
            endif
        next
    endif
    
    for c=1 to last
        if c<=14 then
            b=list_e(c)
            if distance(attacker(b).c,defender.c)<=senbat1 then attacker(b).questflag(11)=1
            if _tiles=0 then
                if debug=1 then
                    f=freefile
                    open "tileerror" for output as #f
                    print #f,"attacker(b).di " &attacker(b).di &"attacker(b).ti_no:"&attacker(b).ti_no
                    close #f
                endif
                if attacker(b).di=0 then attacker(b).di=rnd_range(1,8)
                if attacker(b).di=5 then attacker(b).di=9
                d=distance(attacker(b).c,defender.c)
                if d>=senbat1 and d<senbat then
                    denemy=denemy+1
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(86),trans
                endif
                if d<=senbat1 or d<=1.4 or show_enemyships=1 then
                    denemy=denemy+1
                    if attacker(b).aggr=0 then 'Friend/Foe
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(87)),trans
                    else
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(88)),trans
                    endif
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),stiles(attacker(b).di,attacker(b).ti_no),trans
                endif
                if c=marked then 
                    put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(85),trans
                endif
                if debug=2 then draw string((attacker(b).c.x-osx)*_fw1+_fw1,attacker(b).c.y*_fh1),attacker(b).aggr &"-"&attacker(b).target.x &":"& attacker(b).target.y &":"&attacker(b).movepoints(0) &":"&attacker(b).engine,,font2,custom,@_col
                if debug=3 then 
                    if attacker(b).target.x<>0 then
                        line ((attacker(b).c.x-osx)*_tix+_tix/2,attacker(b).c.y*_tiy+_tiy/2)-((attacker(b).target.x-osx)*_tix+_tix/2,attacker(b).target.y*_tiy+_tiy/2),rgb(255,0,0)
                    endif
                endif
            else
                if c=marked then
                    set__color( attacker(b).bcol,attacker(b).col)
                else
                    set__color( attacker(b).col,attacker(b).bcol)
                endif
                if distance(attacker(b).c,defender.c)<senbat then
                    denemy=denemy+1
                    draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),"?",,font1,custom,@_col
                endif
                if distance(attacker(b).c,defender.c)<=senbat1 or distance(attacker(b).c,defender.c)<=sqr(2) or show_enemyships=1 then
                    draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),attacker(b).icon,,font1,custom,@_col
                endif
            endif
        endif
    next
    if _tiles=0 then
        put ((defender.c.x-osx)*_tix,defender.c.y*_tiy),stiles(player.di,player.ti_no),trans
        if debug=2 then draw string((defender.c.x-osx)*_fw1+_fw1,defender.c.y*_fh1),defender.c.x &":"&defender.c.y,,font2,custom,@_col
    else
        set__color( _shipcolor,0)
        draw string(defender.c.x*_fw1,defender.c.y*_fh1),"@",,font1,custom,@_col
    endif
    flip
    return denemy
end function

function com_getweapon() as short
    dim as short a,c,lastslot,re
    static as short m
    if m=0 then m=1
    c=0
    for a=1 to player.h_maxweaponslot
            
        if player.weapons(a).dam>0 then
            if (player.weapons(a).ammo>0 or player.weapons(a).ammomax=0) and player.weapons(a).reloading=0 and player.weapons(a).shutdown=0 then 
                c+=1 'waffe braucht ammo und hat keine
                lastslot=a
            endif
            if player.weapons(a).reloading>0 then re+=1
        endif
    next
    if c=0 then 
        if re=0 then
            dprint "You do not have any weapons you can fire!",14
        else
            dprint "All your weapons are reloading at this time!",14
        endif
        return 0
    endif
    do
        display_ship_weapons(m)
        no_key=keyin(key__esc & key__enter &key__up &key__lt &key__dn &key__rt &"+-123456789")
        if keyplus(no_key) then m+=1
        if keyminus(no_key) then m-=1
        if m>lastslot then m=1
        if m<1 then m=lastslot
    loop until no_key=key__esc or no_key=key__enter
    if no_key=key__enter then return m
    return 0
end function

function com_gettarget(defender as _ship, wn as short, attacker() as _ship,marked as short,e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    
    dim targetno as short
    dim as short a,d,ex,sort
    dim as short senbat,senbat1,senbat2
    dim as string key,text,id
    dim list_c(128) as _cords
    dim list_e(128) as short
    dim last as short
    
    senbat=(defender.sensors+2)*defender.senac
    senbat1=(defender.sensors+1)*defender.senac
    senbat2=(defender.sensors)*defender.senac
    
    if marked=0 then
        for a=1 to 14
            if attacker(a).hull>0 then
                if distance(attacker(a).c,defender.c)<senbat then marked=a
            endif
        next        
    endif
    
    for a=1 to 14
        if attacker(a).hull>0 then
        'if distance(attacker(a).c,defender.c)<senbat*senac then
            last+=1
            list_e(last)=a
            list_c(last)=attacker(a).c
        endif
    next
    
    if mines_last>0 then
        for a=1 to mines_last
        '    if distance(mines_p(a),defender.c)<senbat*senac then
                last+=1
                list_e(last)=100+a
                list_c(last)=mines_p(a)
        '    endif
        next
    endif
    
    if last>1 then 'If there are more than 1 sort by distance
        do
            sort=0
            for a=1 to last-1
                if distance(defender.c,list_c(a))<distance(defender.c,list_c(a+1)) then
                    swap list_c(a),list_c(a+1)
                    swap list_e(a),list_e(a+1)
                    sort=1
                endif
            next
        loop until sort=0
    endif
    
    screenset 0,1
    cls
    display_ship(0)
    a=com_display(defender,attacker(),marked,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
    flip
    
            
    do
        if a>0 then 'ships to target
            d=0
            text="+/- to move, enter to select, esc to skip. "
            if marked>0 and marked<=14 then
                if distance(defender.c,attacker(list_e(marked)).c)<senbat then id="?"
                if distance(defender.c,attacker(list_e(marked)).c)<senbat1 then id=attacker(marked).desig
                text=text &id &com_wstring(defender.weapons(wn),distance(attacker(list_e(marked)).c,defender.c))
            endif
            if marked>14 and marked<=last then 
                text="Mine"&com_wstring(defender.weapons(wn),distance(list_c(marked),defender.c))
            endif
            dprint text 
            key=keyin("+-"&key__esc &key__enter,1)
            if keyplus(key) then d=1
            if keyminus(key) then d=-1
            ex=0
            do
                marked=marked+d
                if marked<1 then marked=last
                if marked>last then marked=1
                ex+=1
            loop until (list_e(marked)<>0 and distance(defender.c,list_c(marked))<senbat) or ex>last
            if key=key__enter then targetno=marked
            if key=key__esc or ex>last then targetno=-1
            
        endif
        screenset 0,1
        cls
        display_ship(0)
        a=com_display(defender,attacker(),marked,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        flip
        
    loop until targetno<>0 or a=0 or last=0
    if targetno>0 then targetno=list_e(marked)
        
    return targetno
end function

function com_fire(byref target as _ship,byref attacker as _ship,byref w as _weap, gunner as short, range as short) as _ship
    dim del as _weap
    dim wp(255) as _cords
    dim as short roll,a,ROF,dambonus,tohitbonus,i,l,c,osx,j,col,col2
    if target.desig=player.desig then
        col=c_gre
        col2=c_yel
    else
        col=c_yel
        col2=c_gre
    endif
    
    
    osx=calcosx(attacker.c.x,1)
    ROF=w.ROF
    for a=1 to 25
        if attacker.weapons(a).made=91 then dambonus+=1
        if attacker.weapons(a).made=92 then dambonus+=2
        if attacker.weapons(a).made=93 then tohitbonus+=1
        if attacker.weapons(a).made=94 then tohitbonus+=2
    next
    #ifdef _FMODSOUND
    if distance(target.c,player.c)<(player.sensors+2)*player.senac then                    
        if w.ammomax>0 and w.ROF>0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(7)) 'Laser         
        if w.ammomax>0 and w.ROF=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(8)) 'Missile battery          
        if w.ammomax=0 and (_sound=0 or _sound=2) then FSOUND_PlaySound(FSOUND_FREE, sound(9)) 'Missile                                           
    endif
    #endif
    do
        if w.ammomax>0 then w.ammo=w.ammo-1 
        if w.ammo>0 or w.ammomax=0 then
            w.heat=w.heat+w.heatadd*25
            w.reloading=w.reload
            if rnd_range(1,6)+rnd_range(1,6)+gunner>=w.heat/25  then
                roll=rnd_range(1,6)+rnd_range(1,6)+gunner+attacker.senac+tohitbonus-(target.ecm*w.ecmmod)
                'if range<=w.range*3 then roll=roll+1
                if range<=w.range*2 then roll=roll+1
                if range<=w.range then roll=roll+2
                if roll>11 then
                    if w.ammomax=0 then
                        c=185
                    else
                        c=7
                    endif
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                    
                        l=line_in_points(target.c,attacker.c,wp())
                        for i=1 to l-1
                            if combatmap(wp(i).x,wp(i).y)>0 then roll-=1
                            sleep 5
                            set__color( c,0)
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
                    endif
                    if roll>11 then
                        if w.ammomax=0 then
                            target=com_hit(target,w,dambonus,range,attacker.desig)
                            c=185
                        else
                            target=com_hit(target,w,attacker.loadout,range,attacker.desig)
                            c=7
                        endif
                    endif
                else
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                        l=line_in_points(movepoint(target.c,5),attacker.c,wp())
                        if w.ammomax=0 then
                            c=185
                        else
                            c=7
                        endif
                            for i=1 to l-1
                                sleep 5
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
                            dprint attacker.desig &" fires "&w.desig &", and misses!",col
                        else
                            dprint "It missed.",col
                        endif
                    endif
                endif
            else
                dprint w.desig &" shuts down due to heat.",col2
                w.shutdown=1
                if rnd_range(1,6)+rnd_range(1,6)+gunner<w.heat/10 then
                    dprint w.desig &" is irreperably damaged.",col2
                    w=del
                endif
            endif
        endif
        ROF-=1
    loop until ROF<=0
    return target
end function

function com_hit(target as _ship, w as _weap, dambonus as short, range as short,attn as string) as _ship
    dim as string desig, text
    dim as short roll,osx,j,c
    osx=calcosx(target.c.x,1)
    if target.desig=player.desig then
        desig=player.desig
        c=c_red
    else
        if range>(player.sensors+2)*player.senac then
            desig="?"
            attn="???"
        else
            desig=target.desig 
        endif
        gainxp(3)
        c=c_gre
    endif
    
    target.shield=target.shield-w.dam-dambonus
    if target.shield<0 then
        if target.shieldmax>0 then
            text=desig &" is hit, shields penetrated! "
        else
            text=desig &" is hit! "
        endif
        target.hull=target.hull+target.shield
        text=text &" "& -target.shield & " Damage!"
        roll=rnd_range(1,6)+rnd_range(1,6)-target.shield
        if roll>8 and target.hull>0 then
            if roll+rnd_range(1,6)>13 then
                text=text & " Critical hit!"
                dprint text,c
                target=com_criticalhit(target,roll)
            endif
        else 
            if w.p>0 then 
                dprint attn &" fires "&w.desig &". " & text,c
            else
                dprint attn &" "&w.desig &", " & text,c
            endif
        endif
        text=""
        'no_key=keyin
    endif
    if target.shield=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, shields are down!"
    if target.shield=0 and w.p<0 then text=w.desig &" "&desig &" is hit, shields are down!"
    if target.shield>0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, but shields hold!"
    if target.shield>0 and w.p<0 then text=w.desig &" "&desig &" is hit, but shields hold!"
    
    if _tiles=0 then
        screenset 1,1
        if target.c.x-osx>=0 and target.c.x-osx<=_mwx then
            if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                for j=1 to 8
                    put ((target.c.x-osx)*_tix,target.c.y*_tix),gtiles(gt_no(76+j)),trans
                    sleep 5
                next
            endif
        endif
    endif
    dprint text,c
    'if text<>"" then no_key=keyin
    if target.shield<0 then target.shield=0
    return target
end function

function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short ,attacker() as _ship) as short
    dim p as _cords
    dim del as _ship
    dim as short a,b,c,mine,mtype(15),no(15),mwhere(15),storedead,dam,i
    dim mdesig(15) as _items
    dim as string text,key
    c=getitemlist(mdesig(),no(),67,40)
    dprint "c="&c
    for a=0 to c-1
        text=text &"/ "&mdesig(a).desig &"(" &no(a) &")"
        for b=0 to lastitem
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
        text="Choose mine or drone:"&text &"/Exit"
        storedead=player.dead
        player.dead=0
        mine=menu(text)
        player.dead=storedead
        if mine<=0 or mine>c then return 0
        if addtalent(3,13,1)>0 and mine=c then
            player.fuel=player.fuel-5
            placeitem(makeitem(74),0,0,0,0,-1)
            for b=0 to lastitem
                if item(b).id=74 and item(b).ty=40 and item(b).w.s=-1 then 
                    mwhere(mine)=b
                    exit for
                endif                
            next
        endif
            
        mine=mwhere(mine)
    else
        dprint "You don't have mines or drones",c_yel
        return 0
    endif
    dprint "Direction"
    key=keyin("12345678")
    a=getdirection(key)
    if a>0 then
        p=movepoint(defender.c,a)
        if item(mine).ty=40 then
            mines_last+=1
            if mines_last<=128 then
                mines_p(mines_last).x=p.x
                mines_p(mines_last).y=p.y
                mines_v(mines_last)=mine
                item(mine).w.s=0
            endif
        else
            'Add drone as ship
            for a=1 to 14
                if attacker(a).hull<=0 then
                    i=a
                    exit for
                endif
            next

            if i<=14 then
                attacker(i)=attacker(0)
                item(mine).w.s=0
                item(mine).w.p=-i 'Store drone position in attacker list
                attacker(i).hull=item(mine).v1
                attacker(i).weapons(1).dam=item(mine).v2
                attacker(i).weapons(1).range=item(mine).v3
                attacker(i).engine=item(mine).v4
                attacker(i).c=p
                attacker(i).ti_no=51
                attacker(i).aggr=1
                attacker(i).turnrate=3
                attacker(i).sensors=4
            endif
        
            
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


function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship) as short
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
                    set__color( 242+dis,0)
                    draw string(p.x*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        set__color( 0,0)
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
                    set__color( 242+dis,0)
                    draw string(p.x*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        set__color( 0,0)
                        draw string(p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
            next
        next
        sleep 50
    next
    
    if distance(mines_p(d),defender.c)<r then 
        defender=com_damship(defender,dam-2*distance(mines_p(d),defender.c),c_red)
        player=defender
        display_ship(0)
    endif
    for a=1 to 14
        if distance(mines_p(d),attacker(a).c)<r then 
            attacker(a)=com_damship(attacker(a),dam-2*distance(mines_p(d),attacker(a).c),c_gre)
            if attacker(a).hull<=0 then
                dprint attacker(a).desig &" destroyed",10
                reward(3)=reward(3)+attacker(a).money
                defender.piratekills=defender.piratekills+attacker(a).money
                com_remove(attacker(),a)
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
        if distance(p,mines_p(a))<r then com_detonatemine(a,mines_p(), mines_v() ,mines_last, defender , attacker())
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
                    b=rnd_range(2,t.h_maxcrew)
                    if crew(b).hp>0 then
                    crew(b).hp=0
                    dprint "An Explosion! "& crew_desig(crew(b).typ) &" "&crew(b).n &" was killed!",12
                    player.deadredshirts=player.deadredshirts+1
                    endif
                endif
            endif
        endif
    return t
end function

function com_flee(defender as _ship,attacker() as _ship) as short
    dim as short roll,victory,i,hostiles
    for i=1 to 14
        if attacker(i).hull>0 and attacker(i).aggr=0 then hostiles+=1
    next
    if defender.c.x=0 or defender.c.x=60 or defender.c.y=0 or defender.c.y=20 then
        roll=rnd_range(1,6)+rnd_range(1,6)+defender.pilot(0)+addtalent(2,7,1)
        if findbest(25,-1)>0 then roll=roll+5
        if roll>6+hostiles or attacker(1).shiptype=2 then
            dprint "You manage to get away.",10
            victory=1            
        else
            cls
            display_ship(0)
            dprint "You dont get away.",12
            defender.c.x=30
            defender.c.y=10
        endif
    else
        dprint "You need to be at a map border.",14
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
    if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science(0) or s.questflag(11)=1 then 
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
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science(0) or s.questflag(0)=1 then 
            text=text &"Hull: "&s.hull &" | "
            s.questflag(0)=1
        else
            text=text &"Hull: ?? | "
        endif    
        for a=1 to 10
            if s.weapons(a).desig<>"" then
                if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science(0)/2 or s.questflag(a)=1 then
                    text=text & s.weapons(a).desig &" | "
                    heat=heat+s.weapons(a).heat 
                    s.questflag(a)=1
                else 
                    text=text &" Weapon: ?? |"
                endif
            endif
        next
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science(0) or s.questflag(12)=1 then
            s.questflag(12)=1
            text=text &"Engine: "&s.engine &" |"
        endif
        if rnd_range(1,6)+rnd_range(1,6)+di-5<player.sensors+player.science(0) then
            text=text &"Heat: "& int(heat/10) 
        else
            text=text &"Heat: ??"
        endif
        text=text &" | | "
    endif
    return text
end function

function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,mines_p() as _cords,mines_last as short) as short
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
        for a=1 to 14
            if attacker(a).hull>0 then
                if distance(p1,attacker(a).c)<w.range*3 then b=1
            endif
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

function com_victory(attacker() as _ship) as short
    dim as short a,enemycount
    dim as short debug,f
    debug=2
    for a=1 to 14
        if attacker(a).hull>0 and attacker(a).aggr=0 then enemycount+=1
        if debug=1 and attacker(a).hull>0 then dprint a &":x:"&attacker(a).c.x &":y:"&attacker(a).c.y
    next
    if debug=2 then
        f=freefile
        open "enemycount" for output as #f
        print #f,enemycount
        close #f
    endif
    
    if debug=1 then dprint "Enemycount"&enemycount
    if enemycount>0 then return enemycount
    return 0
end function

function com_remove(attacker() as _ship, t as short,flag as short=0) as short
    dim a as short
    if flag=0 then attacker(t)=unload_s(attacker(t),10)
                    
    for a=t to 14
        attacker(a)=attacker(a+1)
    next
    return 0
end function
