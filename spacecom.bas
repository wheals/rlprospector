
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

    dim as short a,b,c,d,e,f,l,last,osx
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
    dim text as string
    dim e_track_p(128) as _cords
    dim e_track_v(128) as short
    dim e_last as short
    dim e_map(60,20) as byte
    dim as short noenemies
    dim mines_p(128) as _cords
    dim mines_v(128) as short
    dim mines_last as short
    dim as uinteger localturn
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
    if _debug>0 then dprint atts.ty &"<- atts.ty"
    combatmap(30,10)=0
    victory=0
    col=12
    exitcords.x=player.c.x
    exitcords.y=player.c.y
    player.aggr=1 '1= one of the good guys
    b=0
    for a=1 to 15
        if atts.mem(a).hull>0 then
            for c=0 to 7
                if c<>4 then attacker(b).shieldside(c)=attacker(b).shieldmax
            next
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
    for c=0 to 7
        if c<>4 then player.shieldside(c)=player.shieldmax
    next


    for a=1 to 15
        if attacker(a).shiptype=2 then
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
    last=string_towords(ws(),comstr.t,";")
    for d=1 to last
        set__color(15,0)
        draw string((_mwx+2)*_fw1,(d+l)*_fh2),ws(d),,Font2,custom,@_col
    next
    com_display(player, attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
    dprint ""
    flip
    do

        screenset 0,1
        cls
        display_ship(0)
        com_display(player, attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        dprint ""
        flip

        key=""
        player.e.tick
        for d=1 to 14
            if attacker(d).hull>0 then attacker(d).e.tick
        next

        if debug=9 and _debug=1 then dprint dbugstring

   '
        if player.hull>0 then 'playermovement
            if player.e.e=0 then

                if debug=9 and _debug=1 then dprint ""&f
                if player.c.x=0 or player.c.y=0 or player.c.x=60 or player.c.y=20 then f=-1

                comstr.t= key_fi &" to fire weapons;"&key_drop &" to drop mines;"&key_sc &" to scan enemy ships;"& key_ra & " to call opponents;" &key_ru & " to run and flee."
                'set__color( 11,0
                'draw string(62*_fw1,5*_fh2), "Engine :"&player.engine &" ("&speed(0) &" MP)",,Font2,custom,@_col
                'flip
                comstr.nextpage
        
                key=keyin("1234678"&key_ac &key_ra &key_dropshield &key_sc &key_ru &key__esc &key_drop &key_fi &key_ru &key_togglemanjets &key_cheat)
                'screenset 0,1
                if key=key_ac then
                    select case player.senac
                    case 2
                        player.senac=1
                    case 1
                        player.senac=2
                    end select
                    player.e.add_action(1)
                endif

                if key=key_ra then
                    dprint "Calling other ships"
                    victory=com_radio(player,attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                endif

                if key=key_cheat then com_cheat=1

                if key=key_togglemanjets then
                    if player.manjets=0 then
                        dprint "You have no manjets"
                    else
                        player.e.add_action(1)
                        if manjetson=0 then
                            manjetson=1
                            dprint "You turn on your maneuvering jets"
                        else
                            manjetson=0
                            dprint "You turn off your maneuvering jets"
                        endif
                    endif
                endif

                if key=key_dropshield and player.shieldmax>0 then
                    if askyn ("Do you really want to shut down your shields? (y/n)") then
                        for a=0 to 7
                            player.shieldside(a)=0
                        next
                        player.shieldshut=1
                        player.e.add_action(1)
                    endif
                endif

                if key=key_ru then
                    victory=com_flee(player,attacker())
                endif

                if key=key_drop then
                    com_dropmine(player,mines_p(),mines_v(),mines_last,attacker())
                    player.e.add_action(1)
                endif

                if player.hull>0 then
                    if key=key_sc then
                        player.e.add_action(1)
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
                            player.e.add_action(1)
                            no_key=keyin
                        endif
                    endif

                    if key=key_fi then
                        player.e.add_action(1)
                        e=1
                        do
                            t=com_gettarget(player,w,attacker(),t,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                            if t>0 then
                                w=com_getweapon(e)
                                if w>0 then 
                                    if player.weapons(w).ammomax>0 and player.tribbleinfested>0 then
                                        if rnd_range(1,player.ammo)<player.tribbleinfested then
                                            dprint "That wasn't a shell that was just a bunch of tribbles in the tube!",c_yel
                                            w=0
                                        endif
                                    endif
                                endif
                                if w>0 then
                                    if com_testweap(player.weapons(w),player.c,attacker(),mines_p(),mines_last,1) then
                                        com_playerfire(t,w,attacker(),mines_p(),mines_v(),mines_last)
                                    else
                                        t=-1
                                    endif
                                endif
                                screenset 0,1
                                cls
                                display_ship(0)
                                com_display(player, attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
                                'dprint ""
                                flip
                            endif
                            e=0
                            
                        loop until t=-1 or w=0 or f=0
                        key=""
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
                        if combatmap(player.c.x,player.c.y)=1 or combatmap(player.c.x,player.c.y)=6 then
                            dprint "You have hit an asteroid!",14
                        else
                            dprint "You have hit a glas cloud!",14
                        endif
                        player=com_damship(player,1,c_red)
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
                            text=""
                            c=e_map(player.c.x,player.c.y)
                            if e_track_v(c)=0 then
                                e_map(player.c.x,player.c.y)=0
                            else
                                text="The "&player.desig &" runs into a plasma stream! "
                                player=com_damship(player,e_track_v(c),c_red)
                                osx=calcosx(player.c.x,1)
                                if configflag(con_tiles)=0 then
                                    if e_track_v(C)>=4 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(81),trans
                                    if e_track_v(C)=3 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(82),trans
                                    if e_track_v(C)=2 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(83),trans
                                    if e_track_v(C)=1 then put ((e_track_p(C).x-osx)*_tix,e_track_p(C).y*_tiy),gtiles(84),trans
                                else
                                endif
                                if player.hull<=0 then
                                    text=text &player.desig &" destroyed!"
                                    if e_track_p(c).m=1 then atts.ty=10

                                endif
                                if text<>"" then dprint text,c_red
                                if player.hull<=0 then no_key=keyin
                            endif
                        endif
                    if old.x<>player.c.x or old.y<>player.c.y then player.add_move_cost(manjetson)
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

        if localturn mod 5=0 then
            for b=e_last to 1 step -1
                e_track_v(b)=cint(e_track_v(b)*.6)-1
                if e_track_v(b)<=0 then
                    e_map(e_track_p(b).x,e_track_p(b).y)=0 'Set current one to 0
                    e_track_v(b)=e_track_v(e_last)'Overwrite with last
                    e_track_p(b)=e_track_p(e_last)
                    if e_last>0 then 
                        e_last-=1
                        e_map(e_track_p(e_last).x,e_track_p(e_last).y)=e_last'Put counter in map
                    endif
                endif
            next
        endif

        if localturn mod 5=0 then
            com_regshields(player)
            com_sinkheat(player,manjetson)
            for a=1 to 14
                if attacker(a).hull>0 then
                    com_regshields(attacker(a))
                    com_sinkheat(attacker(a),0)
                endif
            next
        endif

        localturn+=1
        if key=key_ru and victory<>1 then victory=com_flee(player,attacker())
        if victory=1 then
            player.dead=0
            player.c=exitcords
            return 0
        endif

        if com_victory(attacker())<=0 then victory=2
        if player.hull<=0 then victory=3

        'merchant flee atempt
        for a=1 to 14
            if attacker(a).shiptype=1 then
                if attacker(a).c.x=attacker(a).target.x and attacker(a).c.y=attacker(a).target.y then
                    if skill_test(attacker(a).pilot(0),st_average+player.pilot(0)) then
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

'        screenset 0,1
'        cls
'        display_ship(0)
'        f=com_display(player, attacker(),0,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
'        dprint ""


        #ifdef FMODSOUND
        FSOUND_Update
        #endif


        if victory=3 then
            dprint "Any key to continue."
            no_key=keyin
        endif
    loop until victory<>0 or player.dead=6
    if attacker(16).desig="" and col=10 then atts.con(1)=-1
    player.c=p
    if victory=3 then
        if atts.ty=1 or atts.ty=3 then player.dead=13 'merchants
        if atts.ty=2 or atts.ty=4 then player.dead=5 'Pirates
        if atts.ty=8 then player.dead=20 'Asteroid belt monster '
        if atts.ty=5 then player.dead=21 'ACSC
        if atts.ty=9 then player.dead=23 'GG monster
        if atts.ty=6 then player.dead=31 'Civ 1
        if atts.ty=7 then player.dead=32 'Civ 2
        if atts.ty=10 then player.dead=35 'Own exhaust
    endif
    if victory=2 then
        player.dead=0
        if atts.ty=ft_pirate or atts.ty=ft_pirate2 then combon(8).value+=noenemies
        if atts.ty<8 then battleslost(atts.ty,0)+=1
        dprint "All enemy ships fled or destroyed.",c_gre
    endif
    if victory=1 and player.towed<>0 then
        dprint "You leave behind the ship you had in tow.",14
        player.towed=0
    endif
    if victory=2 or victory=1 then
        for a=0 to lastitem
            if (item(a).ty=67 or item(a).ty=55 or item(a).ty=56) and item(a).w.p<0 then
                b=abs(item(a).w.p)
                if attacker(b).hull<=0 or victory=1 then
                    if victory=1 then dprint "You leave behind "&add_a_or_an(item(a).desig,0) &".",14
                    destroyitem(a)
                else
                    dprint "You take "&add_a_or_an(item(a).desig,0) &" on board.",c_gre
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
    player.senac=0
    player.shieldshut=0

    screenset 0,1

    cls
    display_stars(1)
    display_ship(1)
    dprint ""

    flip
    screenset 1,1

    return 0
end function

function com_playerfire(t as short,w as short,attacker() as _ship,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    if _debug>0 then dprint "t:"&t &" w:"&w
    if t>0 and t<100 then
        player.e.add_action(1)
        if pathblock(player.c,attacker(t).c,0,2,player.weapons(w).col)=-1 then
            attacker(t)=com_fire(attacker(t),player,w,player.gunner(0)+add_talent(3,12,1),distance(player.c,attacker(t).c))
            player.weapons(w).reloading=player.weapons(w).reload
            if attacker(t).hull<=0 then
                dprint "Target destroyed",10
                reward(3)=reward(3)+attacker(t).money
                piratekills(attacker(t).st)+=1
                piratekills(0)+=attacker(t).money
                com_remove(attacker(),t)
                t=0
                'no_key=keyin
            endif
            'no_key=keyin()
        endif
    endif
    if t>100 then com_detonatemine(t-100,mines_p(), mines_v() ,mines_last, player , attacker())
    return 0
end function


function com_add_e_track(ship as _ship,e_track_p() as _cords,e_track_v() as short, e_map() as byte,e_last as short) as short
    dim p as _cords
    dim i as short
    p=ship.c
    p=movepoint(p,ship.diop())
    if p.x<0 or p.x>60 or p.y<0 or p.y>60 then return e_last
    e_last+=1
    if e_last>128 then
        e_last=1
    endif
    e_track_p(e_last).x=p.x
    e_track_p(e_last).y=p.y
    e_track_p(e_last).m=ship.aggr'Who did it?
    e_track_v(e_last)=ship.engine+2
    e_map(p.x,p.y)=e_last
    return e_last
end function

function draw_shield(ship as _ship,osx as short) as short
    dim as short i,di,ti,value,x,y
    di=ship.di
    for i=0 to 7
        ti=di-1
        if ti>=5 then ti-=1

        if ship.shieldside(i)>0 then
            value=ship.shieldside(i)-1
            if value>4 then value=4
            if configflag(con_tiles)=0 then
                select case di
                case 1
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy+16+4
                case 2
                    x=(ship.c.x-osx)*_tix+4
                    y=ship.c.y*_tiy+16+4
                case 3
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy+16+4
                case 4
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy+4
                case 6
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy+4
                case 7
                    x=(ship.c.x-osx)*_tix-16+4
                    y=ship.c.y*_tiy-16+4
                case 8
                    x=(ship.c.x-osx)*_tix+4
                    y=ship.c.y*_tiy-16+4
                case 9
                    x=(ship.c.x-osx)*_tix+16+4
                    y=ship.c.y*_tiy-16+4
                end select
                if x>=0 and y>=0 and x<=_mwx*_tix-16 and y<=20*_tiy then put (x,y),shtiles(ti,value),trans
            else
                _fgcolor_=rgb((ship.shieldside(i)+1)*64,(ship.shieldside(i)+1)*32,0)
                select case di
                case 1
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y+1)*_fh1),"\",,font1,custom,@_tcol
                case 2
                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y+1)*_fh1),"-",,font1,custom,@_tcol
                case 3
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y+1)*_fh1),"/",,font1,custom,@_tcol
                case 4
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y)*_fh1),"|",,font1,custom,@_tcol
                case 6
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y)*_fh1),"|",,font1,custom,@_tcol
                case 7
                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y-1)*_fh1),"/",,font1,custom,@_tcol
                case 8
                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y-1)*_fh1),"-",,font1,custom,@_tcol
                case 9
                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y-1)*_fh1),"\",,font1,custom,@_tcol
                    '                case 1
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 2
'                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 3
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y+1)*_fh1),""&i,,font1,custom,@_col
'                case 4
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y)*_fh1),""&i,,font1,custom,@_col
'                case 6
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y)*_fh1),""&i,,font1,custom,@_col
'                case 7
'                    draw string ((ship.c.x-osx-1)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'                case 8
'                    draw string ((ship.c.x-osx)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'                case 9
'                    draw string ((ship.c.x-osx+1)*_fw1,(ship.c.y-1)*_fh1),""&i,,font1,custom,@_col
'
                end select
            endif
        endif
        di=bestaltdir(di,1)
    next

    return 0
end function

function com_radio(defender as _ship, attacker() as _ship, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short)  as short
    dim as short victory,hp,a,cargo,od,friendly(14),friendlies,osx
    dim as string text
    dim p as _cords
    for a=0 to 15
        if attacker(a).hull>0 then
            if attacker(a).aggr<>1 then
                hp+=attacker(a).hull
            else
                friendlies+=1
                friendly(friendlies)=a
            endif
        endif
    next
    for a=0 to 10
        if player.cargo(a).x>1 then cargo+=1
    next
    od=player.dead
    player.dead=0
    if friendlies>0 then
        for a=1 to friendlies
            text=text &"Call "&attacker(friendly(a)).desig &"("&attacker(friendly(a)).c.x &":"& attacker(friendly(a)).c.y & ")/"
        next
    endif
    text="Calling other ships/" &text &"Ask oppenents for surrender/Offer surrender to opponents/Never mind"
    a=menu(bg_ship,text,"",2,2)
    player.dead=od
    select case a
    case is<=friendlies
        osx=calcosx(p.x,1)
        dprint "Set target for "&attacker(friendly(a)).desig &"."
        p=attacker(friendly(a)).c
        do
            screenset 0,1
            cls
            osx=calcosx(player.c.x,1)
            com_display(player, attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
            flip
            no_key=cursor(p,-1,osx)
        loop until no_key=key__esc or no_key=key__enter
        if no_key=key__enter then attacker(friendly(a)).target=p
        dprint "Target set "&attacker(friendly(a)).target.x &":"& attacker(friendly(a)).target.y & ". Roger."
    case is=1+friendlies
        if hp<player.hull+rnd_range(0,player.hull) then
            dprint "They agree"
            victory=1
        else
            dprint "They don't agree"
        endif
    case is=2+friendlies
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
    if debug=1 and _debug=1 then
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

    if debug=1 and _debug=1 then
        f=freefile
        open "turningdata.csv" for output as #f
    endif
    if turnrate=-1 then return dircur 'Probes can't turn
    if dircur<>dirdest  then

        tdir=dircur
        do
            tdir=bestaltdir(tdir,0)
            disright+=1
            if debug=1 and _debug=1 then print #f,dirdest &";"&tdir
        loop until tdir=dirdest or disright>9

        tdir=dircur
        do
            tdir=bestaltdir(tdir,1)
            disleft+=1
            if debug=1 and _debug=1 then print #f,dirdest &";"&tdir
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
    if debug=1 and _debug=1 then close #f
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
            if attacker(b).e.e=0 and attacker(b).engine>0 then
                if attacker(b).target.x<>attacker(b).c.x or attacker(b).target.y<>attacker(b).c.y then
                   attacker(b).di=com_turn(attacker(b).di,com_direction(attacker(b).c,attacker(b).target),attacker(b).turnrate)
                   if debug=1 and _debug=1 then dprint ""&com_direction(attacker(b).c,attacker(b).target)
                   old=attacker(b).c
                   attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                   if (e_map(attacker(b).c.x,attacker(b).c.y)>0 or combatmap(attacker(b).c.x,attacker(b).c.y)>0) and rnd_range(1,attacker(b).pilot(0))+rnd_range(1,6)>8 then
                        attacker(b).di=bestaltdir(attacker(b).di,rnd_range(0,1))
                        attacker(b).c=old
                        attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                        attacker(b).e.add_action(1)
                   endif
                   if old.x<>attacker(b).c.x or old.y<>attacker(b).c.y then
                        attacker(b).add_move_cost(0)
                        e_last=com_add_e_track(attacker(b),e_track_p() ,e_track_v() , e_map() ,e_last)
                   endif
                endif
                if attacker(b).c.x=defender.c.x and attacker(b).c.y=defender.c.y then attacker(b).c=movepoint(attacker(b).c,attacker(b).di)
                if e_map(attacker(b).c.x,attacker(b).c.y)>0 then
                    a=e_map(attacker(b).c.x,attacker(b).c.y)
                    if e_track_v(a)>0 then
                        attacker(b)=com_damship(attacker(b),e_track_v(a),c_gre)
                        text=attacker(b).desig &" runs into plasma stream! "
                        if _debug=1 then text=text &"Nr."&a &"C:"&cords(attacker(b).c) &" "&cords(e_track_p(a))
                        if distance(attacker(b).c,player.c)<=player.sensors*player.senac then
                            if text<>"" then dprint text,10
                        else
                            if attacker(b).hull<=0 then dprint "Registering explosion at "&attacker(b).c.x &":"&attacker(b).c.y &"!",c_gre
                        endif
                    else
                        e_map(attacker(b).c.x,attacker(b).c.y)=0
                    endif
                endif
            endif
        endif
    next b
    return 0
end function

function com_NPCFire(defender as _ship,attacker() as _ship) as short
    dim as short a,b,t,d

                for a=1 to 14
                if attacker(a).hull>0 then
                    for b=0 to 25
                        if attacker(a).weapons(b).desig<>"" then
                            if attacker(a).weapons(b).heat<5*attacker(a).gunner(0) then

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
        if pathblock(attacker.c,defender.c,0,2,attacker.weapons(b).col)=-1 then
            defender=com_fire(defender,attacker,b,attacker.gunner(0),distance(attacker.c,defender.c))
            display_ship(0)
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

function com_targetlist(defender as _ship, attacker() as _ship, mines_p() as _cords,mines_v() as short, mines_last as short) as _target
    dim as short a,last
    dim target as _target
    for a=1 to 14
        if attacker(a).hull>0 and distance(attacker(a).c,defender.c)<=(defender.sensors+2)*defender.senac and vismask(attacker(a).c.x,attacker(a).c.y)=1 then
            target.add(attacker(a).c,a)
        endif
    next
    if mines_last>0 then
        for a=1 to mines_last
            if distance(mines_p(a),defender.c)<=(defender.sensors+2)*defender.senac and vismask(mines_p(a).x,mines_p(a).y)=1 then
                target.add(mines_p(a),a+100)
            endif
        next
    endif
    if target.targets.vlast>1 then target.sort(defender.c,0)
    return target
end function

function com_vismask(c as _cords) as short
    dim as short x,y,d,i,mask
    for x=0 to 60
        for y=0 to 20
            vismask(x,y)=0
        next
    next

    dim as _cords p,pts(128)
        for x=c.x-20 to c.x+20
        for y=c.y-20 to c.y+20
            if x=c.x-20 or x=c.x+20 or y=c.y-20 or y=c.y+20 then
                mask=1
                p.x=x
                p.y=y
                d=line_in_points(p,c,pts())
                for i=1 to d
                    if pts(i).x>=0 and pts(i).x<=60 and pts(i).y>=0 and pts(i).y<=20 then
                        if mask>0 then
                            vismask(pts(i).x,pts(i).y)=1
                        else
                            vismask(pts(i).x,pts(i).y)=0
                        endif
                        if combatmap(pts(i).x,pts(i).y)>0 and distance(c,pts(i))>player.sensors*player.senac then mask=0
                    endif
                next

            endif
        next
    next
    vismask(c.x,c.y)=1
    return 0
end function

function com_display(defender as _ship, attacker() as _ship,  e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    dim as short x,y,a,b,c,f,osx
    dim as single d
    dim p1 as _cords
    dim as short senbat,senbat1,senbat2
    dim as _cords p,pts(128),list_c(64)
    dim debug as byte
    dim target as _target
    debug=2
    osx=calcosx(defender.c.x,1)
    com_vismask(player.c)
    senbat =(defender.sensors+2)*defender.senac
    senbat1=(defender.sensors+1)*defender.senac
    senbat2= defender.sensors   *defender.senac


    for x=defender.c.x-senbat-1 to defender.c.x+senbat+1
        for y=defender.c.y-senbat-1 to defender.c.y+senbat+1
            if x>=osx and y>=0 and x<=_mwx+osx and x<=60 and x>=0 and y<=20 then
                p1.x=x
                p1.y=y
                if vismask(p1.x,p1.y)=1 then
                    'draw string((x-osx)*_fw1,y*_fh1)," ",,font1,custom,@_col
                    if distance(p1,defender.c)<=senbat or com_cheat=1 then
                        if configflag(con_tiles)=0 then
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
                            if combatmap(x,y)=1 or combatmap(x,y)=6 then draw string(x*_fw1,y*_fh1),chr(167),,font1,custom,@_col
                            if (combatmap(x,y)>1 and combatmap(x,y)<6) or combatmap(x,y)=7 then
                                set__color( rnd_range(48,59),0)
                                if combatmap(x,y)=7 then set__color( rnd_range(186,210),0)
                                draw string(x*_fw1,y*_fh1), chr(176),,font1,custom,@_col
                            endif
                        endif
                    endif
                endif
            endif
        next
    next
    if e_last>0 then
        for b=1 to e_last
            if vismask(e_track_p(b).x,e_track_p(b).y)=1 then
                if distance(e_track_p(b),defender.c)<=senbat+e_track_v(b)*2 and e_track_v(b)>0 then
                    if configflag(con_tiles)=0 then
                        if e_track_v(b)>6 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(81),trans
                        if e_track_v(b)=5 or e_track_v(b)=6 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(82),trans
                        if e_track_v(b)=3 or e_track_v(b)=4 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(83),trans
                        if e_track_v(b)=1 or e_track_v(b)=2 then put ((e_track_p(b).x-osx)*_tix,e_track_p(b).y*_tiy),gtiles(84),trans
                        if debug=2 and _debug=1 then draw string(_tix+(e_track_p(b).x-osx)*_fw1,_tiy+e_track_p(b).y*_fh1),"B"& b &"V:"&e_track_v(b),,font1,custom,@_tcol
                    else
                        set__color( 0,0)
                        if e_track_v(b)>6 then set__color( 15,0)
                        if e_track_v(b)=5 or e_track_v(b)=6 then set__color( 11,0)
                        if e_track_v(b)=3 or e_track_v(b)=4 then set__color( 9,0)
                        if e_track_v(b)=1 or e_track_v(b)=2 then set__color( 1,0 )
                        draw string(e_track_p(b).x*_fw1,e_track_p(b).y*_fh1),"*",,font1,custom,@_col
                    endif
                endif
            endif
        next
    endif

    for b=1 to 15
        if attacker(b).hull>0 then
            if vismask(attacker(b).c.x,attacker(b).c.y)=1 then
                if distance(attacker(b).c,defender.c)<=senbat1 then attacker(b).questflag(11)=1
                if configflag(con_tiles)=0 then
                    if debug=1 and _debug=1 then
                        f=freefile
                        open "tileerror" for output as #f
                        print #f,"attacker(b).di " &attacker(b).di &"attacker(b).ti_no:"&attacker(b).ti_no
                        close #f
                    endif
                    if attacker(b).di=0 then attacker(b).di=rnd_range(1,8)
                    if attacker(b).di=5 then attacker(b).di=9
                    d=distance(attacker(b).c,defender.c)
                    if d>=senbat1 and d<senbat then
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(86),trans
                    endif
                    if d<=senbat1 or d<=1.4 or show_enemyships=1 then
                        if attacker(b).aggr=0 then 'Friend/Foe
                            put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(87)),trans
                        else
                            put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),gtiles(gt_no(88)),trans
                        endif
                        put ((attacker(b).c.x-osx)*_tix,attacker(b).c.y*_tiy),stiles(attacker(b).di,attacker(b).ti_no),trans
                        draw_shield(attacker(b),osx)
                    endif
                    
                    if debug=3 and _debug=1 then
                        if attacker(b).target.x<>0 then
                            line ((attacker(b).c.x-osx)*_tix+_tix/2,attacker(b).c.y*_tiy+_tiy/2)-((attacker(b).target.x-osx)*_tix+_tix/2,attacker(b).target.y*_tiy+_tiy/2),rgb(255,0,0)
                        endif
                    endif

                else
                    set__color( attacker(b).col,attacker(b).bcol)
                    if distance(attacker(b).c,defender.c)<senbat then
                        draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),"?",,font1,custom,@_col
                    endif
                    if distance(attacker(b).c,defender.c)<=senbat1 or distance(attacker(b).c,defender.c)<=sqr(2) or show_enemyships=1 then
                        draw string(attacker(b).c.x*_fw1,attacker(b).c.y*_fh1),attacker(b).icon,,font1,custom,@_col
                        draw_shield(attacker(b),osx)
                    endif
                endif
            endif
        endif
    next
    for b=1 to mines_last'Mines
        if vismask(mines_p(b).x,mines_p(b).y)=1 then
            if configflag(con_tiles)=0 then
                if distance(mines_p(b),defender.c)<=senbat then
                    put ((mines_p(b).x-osx)*_fw1,mines_p(b).y*_fh1),gtiles(gt_no(item(mines_v(b)).ti_no)),trans
                endif
            else
                set__color( 8,0)
                if distance(mines_p(b),defender.c)<=senbat then
                    draw string(mines_p(b).x*_fw1,mines_p(b).y*_fh1),"m",,font1,custom,@_col
                endif
            endif
        endif
    next
    draw_shield(defender,osx)
    if configflag(con_tiles)=0 then
        put ((defender.c.x-osx)*_tix,defender.c.y*_tiy),stiles(player.di,player.ti_no),trans
        if debug=2 and _debug=1 then draw string((defender.c.x-osx)*_fw1+_fw1,defender.c.y*_fh1),defender.c.x &":"&defender.c.y,,font2,custom,@_col
    else
        set__color( _shipcolor,0)
        draw string(defender.c.x*_fw1,defender.c.y*_fh1),"@",,font1,custom,@_col
    endif
    'flip
    return 0
end function

function com_getweapon(echo as byte=1) as short
    dim as short a,c,lastslot,re,r
    static as short m,d
    if m=0 then m=1
    c=0
    if d=0 then d=1
    for a=1 to player.h_maxweaponslot

        if player.weapons(a).dam>0 then
            if (player.useammo(0)=-1 or player.weapons(a).ammomax=0) and player.weapons(a).reloading=0 and player.weapons(a).shutdown=0 then
                c+=1 'waffe hat ammo
                lastslot=a
            endif
            if player.weapons(a).reloading>0 then re+=1
        endif
    next
    if c=0 then
        if echo=1 then
            if re=0 then
                dprint "You do not have any weapons you can fire!",14
            else
                dprint "All your weapons are reloading or recharging at this time.",14
            endif
        endif
        return 0
    endif
'    if c=1 then
'        display_ship_weapons(lastslot)
'        return lastslot
'    endif
    do
        display_ship_weapons(m)
        dprint ""
        no_key=keyin(key__esc & key__enter &key__up &key__lt &key__dn &key__rt &"+-123456789")
        if keyplus(no_key) then m+=1
        if keyminus(no_key) then m-=1
        if m<1 then m=lastslot
        if m>lastslot then m=1
    loop until no_key=key__esc or no_key=key__enter
    if no_key=key__enter then
        r=m
        m+=1
        if m<1 then m=lastslot
        if m>lastslot then m=1
        return r
    endif
    return 0
end function

function com_gettarget(defender as _ship, wn as short, attacker() as _ship,marked as short,e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
    dim as short osx,x,i,j
    dim as string key
    target=com_targetlist(defender,attacker(),mines_p(),mines_v(),mines_last)
    target.t=defender.c
    if target.targets.vlast>0 then target.t=target.targets.cordindex(1)
    osx=calcosx(defender.c.x,1)
    do
        screenset 0,1
        cls
        display_ship(0)
        com_display(defender,attacker(),e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
        if configflag(con_tiles)=1 then
            set__color( 11,11)
            draw string (target.t.x*_fw1,target.t.y*_fh1)," ",,font1,custom,@_col
        else
            x=target.t.x-osx
            if x>=0 and x<=_mwx then put ((x)*_tix,(target.t.y)*_tiy),gtiles(85),trans
        endif
        dprint ""
        flip
        key=keyin
        if _debug>0 then dprint "KEy:"&key &" cords:"&cords(target.t)
        target.t=target.move(key,0)
        if key="+" or key="-" then target.t=target.plusminus(key)
    loop until key=key__esc or key=key__enter or key=key_layfire
    if key=key__enter then
        if _debug>0 then dprint ""&target.targets.vindex(target.t.x,target.t.y,1)
        if target.targets.last(target.t.x,target.t.y)>0 then
            return target.targets.vindex(target.t.x,target.t.y,1)
        endif
    endif
    if key=key_layfire then
        for j=1 to 25
            for i=1 to target.targets.vlast
                if com_testweap(player.weapons(j),player.c,attacker(),mines_p(),mines_last,1) then
                    com_playerfire(i,j,attacker(),mines_p(),mines_v(),mines_last)
                    exit for
                endif
            next            
        next
    endif
'
'    dim as short a,d,ex,sort
'    dim as string key,text,id
'    dim list_c(128) as _cords
'    dim list_e(128) as short
'    dim last as short
'    com_vismask(defender.c)
'    last=com_targetlist(list_c(),list_e(),defender,attacker(),mines_p(),mines_v(),mines_last)
'    if last=1 then return list_e(1)
'    if marked=0 and last>0 then marked=1
'
'    do
'        if marked<1 then marked=last
'        if marked>last then marked=1
'
'        screenset 0,1
'        cls
'        display_ship(0)
'        a=com_display(defender,attacker(),marked,e_track_p(),e_track_v(),e_map(),e_last,mines_p(),mines_v(),mines_last)
'        flip
'        if last>1 then 'More than 1ships to target
'            text="+/- to move, enter to select, esc to skip. "&last
'            if list_e(marked)<100 then
'                if distance(defender.c,attacker(list_e(marked)).c)<senbat then id="?"
'                if distance(defender.c,attacker(list_e(marked)).c)<senbat1 then id=attacker(marked).desig
'                text=text &ucase(left(id,1))&right(id,len(id)-1) &com_wstring(defender.weapons(wn),distance(attacker(list_e(marked)).c,defender.c))
'            endif
'            if list_e(marked)>100 then
'                text="Mine "&com_wstring(defender.weapons(wn),distance(list_c(marked),defender.c))
'            endif
'            if text<>"" then dprint text
'            key=keyin("+-"&key__esc &key__enter,1)
'            if keyplus(key) then marked+=1
'            if keyminus(key) then marked-=1
'            if key=key__enter then return list_e(marked)
'            if key=key__esc or ex>last then return -1
'
'        endif
'
'    loop until a=0 or last=0
    return -1
end function

function com_fire(byref target as _ship,byref attacker as _ship,byref w as short, gunner as short, range as short) as _ship
    dim del as _weap
    dim wp(255) as _cords
    dim as short roll,a,ROF,dambonus,rangebonus,tohitbonus,i,l,c,osx,j,col,col2,col3,firefree
    dim as string echo
    'screenset 1,1
    if target.desig=player.desig then
        col=c_gre
        col2=c_yel
        col3=c_red
        echo=""
    else
        col=c_yel
        col2=c_gre
        col3=c_gre
        echo="Firing "&attacker.weapons(w).desig &":" 
    endif


    osx=calcosx(player.c.x,1)
    ROF=attacker.weapons(w).ROF
    for a=1 to 25
        if attacker.weapons(a).made=91 then dambonus+=1
        if attacker.weapons(a).made=92 then dambonus+=2
        if attacker.weapons(a).made=93 then tohitbonus+=1
        if attacker.weapons(a).made=94 then tohitbonus+=2
    next
    #ifdef _FMODSOUND
    if distance(target.c,attacker.c)<(attacker.sensors+2)*attacker.senac then
        if attacker.weapons(w).ammomax>0 and ROF>0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then FSOUND_PlaySound(FSOUND_FREE, sound(7)) 'Laser
        if attacker.weapons(w).ammomax>0 and ROF=0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then FSOUND_PlaySound(FSOUND_FREE, sound(8)) 'Missile battery
        if attacker.weapons(w).ammomax=0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then FSOUND_PlaySound(FSOUND_FREE, sound(9)) 'Missile
    endif
    #endif
    #ifdef _FBSOUND
    if distance(target.c,attacker.c)<(attacker.sensors+2)*attacker.senac then
        if attacker.weapons(w).ammomax>0 and attacker.weapons(w).ROF>0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then fbs_Play_Wave(sound(7)) 'Laser
        if attacker.weapons(w).ammomax>0 and attacker.weapons(w).ROF=0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then fbs_Play_Wave(sound(8)) 'Missile battery
        if attacker.weapons(w).ammomax=0 and (configflag(con_sound)=0 or configflag(con_sound)=2) then fbs_Play_Wave(sound(9)) 'Missile
    endif
    #endif
    do
        firefree=0
        if attacker.weapons(w).ammo=0 then
            firefree=1
        else
            if attacker.useammo(0) then firefree=1
        endif

        if firefree=1 then
            if attacker.weapons(w).ammomax=0 then
                if attacker.weapons(w).made=66 then
                    attacker.e.add_action(attacker.weapons(w).dam/2)
                else
                    attacker.e.add_action(attacker.weapons(w).dam) '
                endif
            endif
            attacker.weapons(w).heat=attacker.weapons(w).heat+attacker.weapons(w).heatadd*10
            attacker.weapons(w).reloading+=attacker.weapons(w).reload
            if skill_test(gunner,attacker.weapons(w).heat/25) then
                rangebonus=0
                if range<=attacker.weapons(w).range*2 then rangebonus+=1
                if range<=attacker.weapons(w).range then rangebonus+=2
                if skill_test(gunner+attacker.senac+tohitbonus+rangebonus-target.pilot(0)/2-(target.equipment(se_ecm)*attacker.weapons(w).ecmmod),st_average,echo) then
                    if attacker.weapons(w).ammomax=0 then
                        c=185
                    else
                        c=7
                    endif
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac and distance(target.c,player.c)>0 then

                        l=line_in_points(target.c,attacker.c,wp())
                        for i=1 to l-1
                            if combatmap(wp(i).x,wp(i).y)>0 then roll-=1
                            sleep 5
                            set__color( c,0)
                            if configflag(con_tiles)=0 then
                                if attacker.weapons(w).ammomax=0 then
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75)),trans
                                else
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76)),trans
                                endif
                            else
                                draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                            endif
                        next

                        if l>1 then
                            wp(255)=wp(1)
                        else
                            wp(255)=attacker.c
                        endif
                    endif
                    if attacker.weapons(w).ammomax=0 then
                        target=com_hit(target,attacker.weapons(w),dambonus,range,attacker.desig,com_side(target,wp(255)))
                        c=185
                    else
                        target=com_hit(target,attacker.weapons(w),attacker.loadout,range,attacker.desig,com_side(target,wp(255)))
                        c=7
                    endif                                    
                else
                    if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                        l=line_in_points(movepoint(target.c,5),attacker.c,wp())
                        if attacker.weapons(w).ammomax=0 then
                            c=185
                        else
                            c=7
                        endif
                        for i=1 to l-1
                            sleep 5
                            if configflag(con_tiles)=0 then
                                if attacker.weapons(w).ammomax=0 then
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(75)),trans
                                else
                                    put ((wp(i).x-osx)*_tix,wp(i).y*_tix),gtiles(gt_no(76)),trans
                                endif
                            else
                                draw string((wp(i).x-osx)*_fw1,wp(i).y*_fh1), "*",,Font1,custom,@_col
                            endif
                        next
                        if attacker.weapons(w).p>0 then
                            if attacker.weapons(w).ammomax>0 then
                                dprint attacker.desig &" fires "&ammotypename(attacker.loadout) &" and misses!",col
                            else
                                dprint attacker.desig &" fires "&attacker.weapons(w).desig &" and misses!",col
                            endif
                        else
                            if configflag(con_showrolls)=1 then dprint "It missed.",col
                        endif
                    endif
                endif
            else
                dprint attacker.weapons(w).desig &" shuts down due to heat.",col
                attacker.weapons(w).shutdown=1
                if not(skill_test(gunner,attacker.weapons(w).heat/20,"Gunner:Shutdown")) then
                    dprint attacker.weapons(w).desig &" is irreperably damaged."&attacker.weapons(w).heat/20,col3
                    attacker.weapons(w)=del
                endif
            endif
        endif
        ROF-=1
    loop until ROF<=0
    return target
end function

function com_side(target as _ship,c as _cords) as short
    dim as _cords c2
    dim as short r,di,i
    di=target.di
    while abs(c.x-target.c.x)>1 or abs(c.y-target.c.y)>1
        if c.x>target.c.x then c.x-=1
        if c.y>target.c.y then c.y-=1
        if c.x<target.c.x then c.x+=1
        if c.y<target.c.y then c.y+=1
    wend

    for i=0 to 7
        c2=movepoint(target.c,di)
        if c2.x=c.x and c2.y=c.y then return i
        di=bestaltdir(di,1)
    next
    return 0
end function


function com_hit(target as _ship, w as _weap, dambonus as short, range as short,attn as string,side as short) as _ship
    dim as string desig, text
    dim as short roll,osx,j,c,sright,sleft,sdam,ad
    if side>4 then
        ad=2
    else
        ad=1
    endif
    sright=bestaltdir(side+ad,1)'Shieldsides are 0-7, bestaltdir=1-4
    sleft=bestaltdir(side+ad,0)
    if sright>4 then
        sright-=2
    else
        sright-=1
    endif
    if sleft>4 then
        sleft-=2
    else
        sleft-=1
    endif
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
        dprint gainxp(3),c_gre
        c=c_gre
    endif
    if target.shieldside(side)>0 then
        select case w.made
        case 6 to 10
            target.shieldside(side)-=fix((w.made-6)/3)
        case 66
            target.shieldside(side)=0
            target.shieldside(sright)=0
            target.shieldside(sleft)=0
        case else
            target.shieldside(side)-=1
            target.shieldside(sright)-=1
            target.shieldside(sleft)-=1
        end select

        if target.shieldside(side)<0 then target.shieldside(side)=0
        if target.shieldside(sright)<0 then target.shieldside(sright)=0
        if target.shieldside(sleft)<0 then target.shieldside(sleft)=0
    endif
    target.shieldside(side)=target.shieldside(side)-w.dam-dambonus
    if target.shieldside(side)<0 then
        if target.shieldmax>0 then
            text=desig &" is hit, shields penetrated! "
        else
            text=desig &" is hit! "
        endif
        target.hull=target.hull+target.shieldside(side)
        text=text &" "& abs(target.shieldside(side)) & " damage!"
        roll=rnd_range(1,6)+6-target.armortype-target.shieldside(side)
        if roll>8 and target.hull>0 then
            if roll+rnd_range(1,6)>13 then
                text=text & " Critical hit!"
                dprint text,c
                target=com_criticalhit(target,roll)
            endif
        else
            if w.made<100 then
                if w.ammomax>0 then
                    dprint attn &" fires "& ammotypename(dambonus) &". " & text,c
                else
                    dprint attn &" fires "&w.desig &". " & text,c
                endif
            else
                if w.made=101 then dprint attn &" bites. "&text,c
                if w.made=102 then dprint attn &" fires a concentrated radiation beam. "&text,c
                if w.made=103 then dprint attn &" hits with a tentacle. "&text,c
                if w.made=104 then dprint attn &" sfires a lightning bolt. "&text,c
            endif
        endif
        text=""
        'no_key=keyin
    endif
    if target.shieldside(side)=0 and w.ammomax=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, shields are down!"
    if target.shieldside(side)=0 and w.ammomax>0 and w.p>0 then text=ammotypename(dambonus) &" fired, "&desig &" is hit, shields are down!"
    if target.shieldside(side)=0 and w.p<=0 then text=attn &" "&desig &" is hit, shields are down!"
    if target.shieldside(side)>0 and w.ammomax=0 and w.p>0 then text=w.desig &" fired, "&desig &" is hit, but shields hold!"
    if target.shieldside(side)>0 and w.ammomax>0 and w.p>0 then text=ammotypename(dambonus) &" fired, "&desig &" is hit, but shields hold!"
    if target.shieldside(side)>0 and w.p<=0 then text=w.desig &" "&desig &" is hit, but shields hold!"

    if configflag(con_tiles)=0 then
        'screenset 1,1
        if target.c.x-osx>=0 and target.c.x-osx<=_mwx then
            if distance(target.c,player.c)<(player.sensors+2)*player.senac then
                com_explosion_ani(target.c.x-osx,target.c.y)
            endif
        endif
    endif
    if text<>"" then dprint text,c
    'if text<>"" then no_key=keyin
    if target.shieldside(side)<0 then target.shieldside(side)=0
    return target
end function

function com_explosion_ani(x as short,y as short) as short
    dim j as short
    for j=1 to 8
        put ((x)*_tix,y*_tiy),gtiles(gt_no(76+j)),trans
        sleep 5
    next
    return 0
end function

function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short ,attacker() as _ship) as short
    dim p as _cords
    dim del as _ship
    dim as short a,b,c,mine,mtype(15),no(15),storedead,dam,i,impmine
    dim mdesig(15) as _items
    dim as string text,key
    c=get_item_list(mdesig(),no(),67,40,55,56)
    for a=1 to c
        if no(a)<0 then
            for b=a to c
                no(b)=no(b+1)
                mdesig(b)=mdesig(b+1)
            next
            c-=1
        endif
    next
    for a=1 to c
        if no(a)>0 then
            if no(a)>1 then
                text=text &"/"&no(a) &" " &mdesig(a).desigp
            else
                text=text &"/"&mdesig(a).desig
            endif
            if _debug=1 then text=text &mdesig(a).w.s
        endif
    next
    if _debug=1 then crew(2).talents(13)=1
    if add_talent(2,13,1)>0 then
        text=text &"/Improvised mine"
        impmine=c+1
    endif
    if text<>"" then
        text="Choose mine or drone:"&text &"/Exit"
        storedead=player.dead
        player.dead=0
        a=menu(bg_ship,text)
        player.dead=storedead
        if a<=0 or a>maximum(c,impmine) then return 0
        if a=impmine and (add_talent(2,13,1)>0) then
            b=5-add_talent(2,13,1)
            if b<1 then b=1
            if player.fuel>=b then
                player.fuel=player.fuel-b
                mine=placeitem(make_item(74),0,0,0,0,-1)
                item(mine).v1+=add_talent(2,13,1)
            else
                dprint "You don't have enough fuel to improvise a mine."
            endif
        else
            mine=mdesig(a).w.s
        endif
    else
        dprint "You don't have mines or drones",c_yel
        return 0
    endif
    dprint "Dropping "&item(mine).desig &" Direction?"
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
                attacker(i).desig=item(mine).desig
                attacker(i).col=c_gre
                attacker(i).hull=item(mine).v1
                attacker(i).c=p
                attacker(i).aggr=1
                attacker(i).di=a
                attacker(i).icon=item(mine).icon
                if item(mine).ty=55 or item(mine).ty=56 then
                    attacker(i).engine=1
                    attacker(i).turnrate=-1
                    attacker(i).ti_no=50
                else
                    attacker(i).weapons(1).desig="Plasma cannon"
                    attacker(i).weapons(1).dam=item(mine).v2
                    attacker(i).weapons(1).range=item(mine).v3
                    attacker(i).weapons(1).heatadd=3
                    attacker(i).weapons(1).reload=8
                    attacker(i).weapons(1).heatsink=1
                    attacker(i).engine=item(mine).v4
                    attacker(i).ti_no=51
                    attacker(i).turnrate=1
                    attacker(i).sensors=4
                    attacker(i).shieldmax=item(mine).v6
                    attacker(i).senac=1
                    attacker(i).pigunner=3
                    attacker(i).pipilot=player.pilot(15)-1
                endif
                p=movepoint(attacker(i).c,attacker(i).diop)
                if p.x=player.c.x and p.y=player.c.y then
                    attacker(i).di+=1
                    if attacker(i).di>9 or attacker(i).di=5 then attacker(i).di=1
                endif
            endif


        endif
    endif
    return 0
end function

function com_regshields(s as _ship) as short
    dim as short a,i,low,r
    dim shieldreg as short
    if s.shieldmax=0 or s.shieldshut=1 then return 0
    shieldreg=1
    for a=1 to 25
        if s.weapons(a).made=90 then shieldreg+=1
    next
    do
        low=s.shieldmax
        r=-1
        for i=7 to 0 step -1 'Favors front shields
            if s.shieldside(i)<low and (i<>4) then
                low=s.shieldside(i)
                r=i
            endif
        next
        if r>-1 and shieldreg>0 then
            s.shieldside(r)+=1
            shieldreg-=1
            s.e.add_action(1)
        endif
    loop until r=-1 or shieldreg=0
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
    for a=0 to 7
        if sink>0 and s.shieldside(a)<s.shieldmax then
            sink-=1
        endif
    next
    if sink<=0 then sink=1
    sink=sink*3
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
            'if s.weapons(a).heat>0 then heat=1
        next
    loop until sink<=0 or heat<=0
    for a=1 to 25
        if s.weapons(a).reloading>0 then
            if s.weapons(a).ammomax>0 then
                s.weapons(a).reloading-=(3*s.reloading/10)
            else
                s.weapons(a).reloading-=3
            endif
        endif
        if s.weapons(a).reloading<0 then s.weapons(a).reloading=0
    next
    return 0
end function


function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship) as short
    dim as short x,y,t,r,dis,a,dam,osx
    dim as _cords p
    osx=calcosx(player.c.x,1)

    if mines_last<=0 then
        mines_last=0
        return 0
    end if
    if _debug=1 then
        dprint "detonating mine"
        sleep
    endif
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
        screenset 0,1
        cls
        display_ship

        for x=mines_p(d).x-6 to mines_p(d).x+6
            for y=mines_p(d).y-6 to mines_p(d).y+6
                p.x=x
                p.y=y
                dis=distance(p,mines_p(d))
                if configflag(con_tiles)=0 then
                    if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=_mwx and p.y<=20 then
                        set__color( 242+dis,0)
                        put((p.x-osx)*_fw1,p.y*_fh1),gtiles(76+t),trans
                    endif
                else

                if dis<=r and t>dis and p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                    set__color( 242+dis,0)
                    draw string((p.x-osx)*_fw1,p.y*_fh1),"*",,font1,custom,@_col
                else
                    if p.x>=0 and p.y>=0 and p.x<=60 and p.y<=20 then
                        set__color( 0,0)
                        draw string((p.x-osx)*_fw1,p.y*_fh1)," ",,font1,custom,@_col
                    endif
                endif
                endif
            next
        next
        flip
        sleep 50
    next
    if configflag(con_tiles)=1 then
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
    endif
    if distance(mines_p(d),defender.c)<r then
        defender=com_damship(defender,dam-2*distance(mines_p(d),defender.c),c_red)
        player=defender
        display_ship(0)
    endif
    for a=1 to 14
        if distance(mines_p(d),attacker(a).c)<r and attacker(a).hull>0 then
            attacker(a)=com_damship(attacker(a),dam-2*distance(mines_p(d),attacker(a).c),c_gre)
            if attacker(a).hull<=0 then
                dprint attacker(a).desig &" destroyed",10
                reward(3)=reward(3)+attacker(a).money
                piratekills(attacker(a).st)+=1
                piratekills(0)+=attacker(a).money
                com_remove(attacker(),a)
                t=0
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
    dim side as short
    side=rnd_range(0,7)
    if dam<0 then return t

    t.shieldside(side)=t.shieldside(side)-dam
    dprint t.desig &" is hit! ",col
    if t.shieldside(side)<0 then
        if t.shieldmax>0 then
            text=t.desig &" is hit, shields penetrated! "
        else
            text=t.desig &" is hit! "
        endif
        t.hull=t.hull+t.shieldside(side)
        text=text & -t.shieldside(side) & " Damage!"
    else
        text="shields hold!"
    endif
    if t.shieldside(side)<0 then t.shieldside(side)=0
    if text<>"" then dprint text,col
    return t
end function

function com_criticalhit(t as _ship, roll as short) as _ship
    dim as short a,b,l,dam
    dim text as string
    if t.hulltype=-1 then return t
    l=9

        a=rnd_range(1,l)
        if a=1 then
            if t.engine<2 then
                t.engine=1
                a=rnd_range(2,l)
            else
                dprint "Engine damaged!",12
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
            if t.hull>max_hull(player) then t.hull=max_hull(player)
            dprint "Critical damage to ship structure!",12
        endif

        if a=5 then
            dprint "Explosion in cargo bay!",12
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
                dprint t.weapons(b).desig &" destroyed!",12
                if t.desig=player.desig then

                    if t.weapons(b).desig="Fuel tank" then
                        dam=rnd_range(1,6)
                        dprint "it explodes! "& b &" points of damage!",12
                        player.hull=player.hull-b
                    endif

                    if t.weapons(b).made=84 then
                        dam=rnd_range(1,6)+ rnd_range(1,6)
                        t.hull-=dam
                        dprint "It explodes! "& b &" points of damage!",12
                    endif

                    if t.weapons(b).desig="Crew Quarters" then
                        b=rnd_range(1,6)
                        t.security=t.security-b
                        if t.security<0 then
                            b=b+t.security
                            t.security=0
                        endif
                        dprint  b &" casualties!",12
                        player.deadredshirts=player.deadredshirts+b
                    endif

                endif
                t.weapons(b)=make_weapon(-1)
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
                dprint "An explosion in the crew quaters! "
                dprint dam_awayteam(b,2,,1)
            else
                dprint "Crew quaters hit!"
            endif
        endif

        if a=8 then
            dprint "An explosion on the bridge!",12

            if t.desig=player.desig then

                if rnd_range(1,6)+ rnd_range(1,6)>7 then
                    dprint dam_awayteam(b,2,,2)
                endif
            endif
        endif

        if a=9 then
            dprint "Fuel system damaged!",c_red
            t.fueluse=t.fueluse*1.1
        endif

    return t
end function

function com_flee(defender as _ship,attacker() as _ship) as short
    dim as short cloak,victory,i,hostiles
    for i=1 to 14
        if attacker(i).hull>0 and attacker(i).aggr=0 then hostiles+=1
    next
    if defender.c.x=0 or defender.c.x=60 or defender.c.y=0 or defender.c.y=20 then
        if findbest(25,-1)>0 then cloak=5
        if skill_test(defender.pilot(0)+add_talent(2,7,1)+cloak,6+hostiles,"Pilot") or attacker(1).shiptype=2 then
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
    return text &"."
end function

function com_shipbox(s as _ship,di as short) as string
    dim text as string
    dim as short a,heat
    '' Storing in questflag array if things already have been IDed
    if skill_test(player.science(0),di-5) or s.questflag(11)=1 then
        text="|" & s.desig &"||"
        s.questflag(11)=1
    else
        text="| ???? ||"
    endif
    text=text &"MP: "& s.movepoints(s.manjets) &"|"
    if s.shieldmax>player.sensors then
        text=text &"Shield:"&s.shieldmax
    else
        if s.shieldmax>0 then
            text=text &"Shield:"&s.shieldmax
        else
            text=text &"No shield |"
        endif
        if skill_test(player.science(0),di-5) or s.questflag(0)=1 then
            text=text &"Hull: "&s.hull &" | "
            s.questflag(0)=1
        else
            text=text &"Hull: ?? | "
        endif
        for a=1 to 10
            if s.weapons(a).desig<>"" then
                if skill_test(player.science(0),di-5) or s.questflag(a)=1 then
                    text=text & s.weapons(a).desig &" | "
                    heat=heat+s.weapons(a).heat
                    s.questflag(a)=1
                else
                    text=text &" Weapon: ?? |"
                endif
            endif
        next
        if skill_test(player.science(0),di-5) or s.questflag(12)=1 then
            s.questflag(12)=1
            text=text &"Engine: "&s.engine &" |"
        endif
        if skill_test(player.science(0),di-5) then
            text=text &"Heat: "& int(heat/10)
        else
            text=text &"Heat: ??"
        endif
        text=text &" | | "
    endif
    return text
end function

function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,mines_p() as _cords,mines_last as short,echo as short=0) as short
    dim as short r,a,b

    if w.dam>0 then
        r=-1 'kein cargo bay oder empty slot
        if w.ammomax>0 then
            if player.useammo(1)=0 then b=1 'waffe braucht ammo und hat keine
        endif
        if w.shutdown<>0 then b=2
        if w.reloading<>0 then b=3
        
    endif
    if b>0 then r=0
    if r=-1 then
        for a=1 to 14
            if attacker(a).hull>0 then
                if distance(p1,attacker(a).c)<=w.range*3 then b=4
            endif
        next
        for a=1 to mines_last
            if distance(p1,mines_p(a))<=w.range*3 then b=4
        next
        if b=0 then r=0
    endif
    if echo=1 then
        if b=0 then dprint "No target within range.",c_yel
        if b=1 then dprint "Out of ammunition.",c_yel
        if b=2 then dprint "Weapon shut down.",c_yel
        if b=3 then dprint "Weapon reloading.",c_yel
        if b=3 then dprint "Weapon reloading.",c_yel
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
        if debug=1 and _debug=1 and attacker(a).hull>0 then dprint a &":x:"&attacker(a).c.x &":y:"&attacker(a).c.y
    next

    if debug=1 and _debug=1 then dprint "Enemycount"&enemycount
    return enemycount
end function

function com_remove(attacker() as _ship, t as short,flag as short=0) as short
    dim a as short
    if flag=0 then attacker(t)=unload_s(attacker(t),10)
    if attacker(a).bounty>0 then bountyquest(attacker(a).bounty).status=2
    for a=t to 14 'This works since 15 is empty
        attacker(a)=attacker(a+1)
    next
    return 0
end function
