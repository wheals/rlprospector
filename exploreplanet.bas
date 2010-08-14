function ep_redraw(awayteam as _monster,ship as _cords, vismask()as byte,ndval as short, enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short, byref walking as short,deadcounter as short) as short
    dim as short slot
    slot=player.map
    displayplanetmap(slot)
    ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,walking)
    displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,ndval)
    dprint("")
    return 0
end function

function ep_launch(awayteam as _monster, byref ship as _cords,byref nextmap as _cords) as short
    dim slot as short
    slot=player.map
    if awayteam.c.y=ship.y and awayteam.c.x=ship.x and slot=player.landed.m then 
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
                    if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                endif                    
            endif
        else
            nextmap.m=-1
            if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
        endif
    endif
    return 0
end function

function ep_dropitem(awayteam as _monster, li() as short,byref lastlocalitem as short) as short
    dim as short c,d,slot
    dim as string text
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
        screenshot(1)
        c=getitem()
        if c>0 then
            if item(c).ty=45 then
                if askyn("Do you really want to drop the alien bomb?(y/n)") then
                    item(c).w.x=awayteam.c.x
                    item(c).w.y=awayteam.c.y
                    item(c).w.m=slot
                    item(c).w.s=0
                    item(c).w.p=0
                    lastlocalitem+=1
                    li(lastlocalitem)=c
                    item(c).v2=1
                    dprint "What time do you want to set it to"
                    item(c).v3=getnumber(1,99,1)
                endif
            else
            dprint "dropping " &item(c).desig 
            item(c).w.x=awayteam.c.x
            item(c).w.y=awayteam.c.y
            item(c).w.m=slot
            item(c).w.s=0
            item(c).w.p=0
            if item(c).ty=24 and tmap(item(c).w.x,item(c).w.y).no=162 then
                dprint("you reconnect the machine to the pipes. you notice the humming sound.")
                no_key=keyin
                item(c).v1=100
            endif
            reward(2)=reward(2)-item(c).v5
            lastlocalitem=lastlocalitem+1
            li(lastlocalitem)=c
            endif
            equip_awayteam(player,awayteam,slot)
        endif
        screenshot(2)
    endif
    return 0
end function


function ep_inspect(awayteam as _monster,ship as _cords, enemy() as _monster, lastenemy as short, li() as short,byref lastlocalitem as short,byref localturn as short,byref walking as short) as short
    dim as short a,b,c,slot,skill,js
    dim as _cords p
    dim as _driftingship addship
    slot=player.map
    awayteam.lastaction+=1
    b=0
    if _autoinspect=1 and walking=0 and not((tmap(awayteam.c.x,awayteam.c.y).no>=128 and tmap(awayteam.c.x,awayteam.c.y).no<=143) or tmap(awayteam.c.x,awayteam.c.y).no=241) then dprint "You search the area: "&tmap(awayteam.c.x,awayteam.c.y).desc

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
            if rnd_range(1,6)+rnd_range(1,6)+maximum(player.pilot-1,player.science)<9 then
                dprint "This ship is beyond repair"
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
                
                changetile(awayteam.c.x,awayteam.c.y,slot,62)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                
                
                addship.x=awayteam.c.x
                addship.y=awayteam.c.y
                addship.m=slot
                addship.s=b
                makedrifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot),1)
            else
                If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") then 
                    walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                    dprint "Starting repair"
                endif
            endif
        endif
        if tmap(awayteam.c.x,awayteam.c.y).hp=1 then
            if rnd_range(1,6)+rnd_range(1,6)+maximum(player.pilot-1,player.science)>8 then
                dprint "The repair was succesfull!"
                color 15,0
                b=tmap(awayteam.c.x,awayteam.c.y).no-127
                if tmap(awayteam.c.x,awayteam.c.y).no=241 then b=18
                textbox(shiptypes(b) &"||"&makehullbox(b),awayteam.c.x+1,5,78-awayteam.c.x,15,1)
                if askyn("Do you want to abandon your ship and use this one?") then                            
                    a=player.h_no
                    if upgradehull(b,player) then
                        player.hull=int(player.hull*0.8)
                        tmap(ship.x,ship.y)=tiles(127+a)
                        changetile(ship.x,ship.y,slot,127+a)
                        ship.x=awayteam.c.x
                        ship.y=awayteam.c.y
                        ship.m=slot
                        tmap(ship.x,ship.y)=tiles(4)
                        planetmap(ship.x,ship.y,slot)=4
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
                    makedrifter(addship,dominant_terrain(awayteam.c.x,awayteam.c.y,slot))
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
                changetile(awayteam.c.x,awayteam.c.y,slot,62)
                tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
            endif
        endif
        b=1
    endif
    
    for a=1 to lastenemy
        if b=0 and awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
            if enemy(a).hpmax>0 and enemy(a).hp<=0 and enemy(a).biomod>0 then
                awayteam.lastaction+=2
                skill=maximum(player.science,player.doctor/2)
                if rnd_range(1,100)<enemy(a).disease*2-awayteam.helmet*3 then infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                if enemy(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)>enemy(a).disease/2+7 then dprint "The creature seems to be a host to dangerous "&disease(enemy(a).disease).cause &"."
                if enemy(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)+awayteam.helmet*3<enemy(a).disease then 
                    infect(rnd_crewmember,enemy(a).disease)
                    dprint "This creature is infected with "&disease(enemy(a).disease).desig,14
                endif
                if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
                    dprint "Recording biodata: "&enemy(a).ldesc 
                    if enemy(a).slot>=0 then planets(slot).mon_disected(enemy(a).slot)+=1
                    if enemy(a).lang=8 then dprint "While this beings biochemistry is no doubt remarkable it does not explain it's extraordinarily long lifespan"
                    if enemy(a).hpmax<0 then enemy(a).hpmax=0
                    if enemy(a).slot>=0 then reward(1)=reward(1)+(10+skill+addtalent(4,14,1)+enemy(a).biomod*enemy(a).hpmax)/planets(slot).mon_disected(enemy(a).slot)
                    enemy(a).hpmax=0
                    b=1                    
                else
                    dprint "No science officer or doctor in the team."
                endif
            else
                if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
                    if enemy(a).hp>0 then dprint "The " &enemy(a).sdesc &" doesn't want to be dissected alive."
                    if enemy(a).biomod>0 then dprint "Nothing left to learn here."
                    if enemy(a).biomod=0 then dprint "There is no bio data to be gained from a dead "&enemy(a).sdesc &"."
                else
                    dprint "No science officer or doctor in the team."
                endif
            endif
        endif
    next            
    if b=0 and tmap(awayteam.c.x,awayteam.c.y).vege>0 and planets(slot).flags(32)<=planets(slot).life+1+addtalent(4,15,3) then
        if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
            skill=maximum(player.science,player.doctor/2)                        
            if rnd_range(1,6)+rnd_range(1,6)+maximum(player.science,player.doctor/2)+tmap(awayteam.c.x,awayteam.c.y).vege+addtalent(4,15,1)>9+planets(a).plantsfound then
                awayteam.lastaction+=2
                planets(slot).flags(32)=planets(slot).flags(32)+1
                b=1
                dprint "you have found "&plantname(tmap(awayteam.c.x,awayteam.c.y))
                reward(1)=reward(1)+(10+skill+addtalent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                if rnd_range(1,80)-player.science-addtalent(4,14,1)<tmap(awayteam.c.x,awayteam.c.y).vege then
                    dprint "The plants in this area have developed a biochemistry you have never seen before. Scientists everywhere will find this very interesting."
                    reward(1)=reward(1)+(10+skill+addtalent(4,14,1)+tmap(awayteam.c.x,awayteam.c.y).vege)/planets(slot).flags(32)
                endif
                if rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-awayteam.helmet*3 then
                    if rnd_range(1,6)+rnd_range(1,6)+maximum(player.science/2,player.doctor)<9 then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
                    dprint "This area is contaminated with "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).ldesc
                endif
                if tmap(awayteam.c.x,awayteam.c.y).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)>tmap(awayteam.c.x,awayteam.c.y).disease/2+7 then dprint "The plants here seem to be a host to dangerous "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).cause &"."
                planets(slot).plantsfound=planets(slot).plantsfound+1
            endif
            tmap(awayteam.c.x,awayteam.c.y).vege=0
        else
            dprint "Your science officer is dead."
        endif
    endif
    if b=0 then
        for c=1 to 9
            if c<>5 then 
                p=movepoint(awayteam.c,c)
            else
                p=awayteam.c
            endif
            if tmap(p.x,p.y).turnsoninspect<>0  and rnd_range(1,6)+rnd_range(1,6)+player.science>8 then
                awayteam.lastaction+=2
                b=1
                if tmap(p.x,p.y).turntext<>"" then dprint tmap(p.x,p.y).turntext
                planetmap(p.x,p.y,slot)=tmap(p.x,p.y).turnsoninspect
                tmap(p.x,p.y)=tiles(tmap(p.x,p.y).turnsoninspect)
            endif
        next
    endif
    if b=0 and _autoinspect=1 then 
        dprint "Nothing of interest here."
    endif
    return 0
end function
    
function ep_communicateoffer(key as string, awayteam as _monster,enemy() as _monster,lastenemy as short, li() as short,byref lastlocalitem as short) as short
    dim as short a,b,slot
    dim as _cords p2
    dim as string dkey
    slot=player.map
    b=0
    dprint "direction?"
    do
        dkey=keyin
    loop until getdirection(dkey)>0 or dkey=key_esc
    p2=movepoint(awayteam.c,getdirection(dkey))
    locate p2.y+1,p2.x+1
    if key=key_co and planetmap(p2.x,p2.y,slot)=190 then 
        dprint "You hear a voice in your head: 'Subjugate or be annihilated'"
        b=-1
    endif
    if key=key_co and planetmap(p2.x,p2.y,slot)=191 then dodialog(1)
    for a=1 to lastenemy
        if p2.x=enemy(a).c.x and p2.y=enemy(a).c.y and enemy(a).hp>0 then b=a
    next
    if b=0 then
        if key=key_co then dprint "Nobody there to communicate"
        if key=key_of then dprint "Nobody there to give something to"
    endif
    if b>0 then awayteam.lastaction+=1
    if b>0 and key=key_co then communicate(awayteam,enemy(b),slot,li(),lastlocalitem,b)
    if b>0 and key=key_of then giveitem(enemy(b),b,li(),lastlocalitem)
    return 0
end function

function ep_atship(awayteam as _monster,ship as _cords,walking as short) as short
    dim as short slot
    slot=player.map
    if awayteam.c.y=ship.y and awayteam.c.x=ship.x and slot=player.landed.m then 
        dprint "You are at the ship. Press "&key_la &" to launch."
        if awayteam.oxygen<awayteam.oxymax then dprint "Refilling oxygen.",10
        awayteam.oxygen=awayteam.oxymax
        if awayteam.move=2 and awayteam.jpfuel<awayteam.jpfuelmax then 
            dprint "Refilling Jetpacks",10
            awayteam.jpfuel=awayteam.jpfuelmax
        endif
        alerts(awayteam, walking)
        return 0
    else 
        return walking
    endif
end function

function ep_planeteffect(awayteam as _monster, ship as _cords, enemy() as _monster, lastenemy as short,li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single,lavapoint() as _cords,vismask() as byte,localturn as short) as short
    dim as short slot,a,b,r
    dim as string text
    static lastmet as short
    dim as _cords p1,p2
    slot=player.map
    lastmet=lastmet+1
    if slot=specialplanet(12) then 'Exploding planet warnings
        if planets(specialplanet(12)).death=8 then 
            dprint "Science officer: I wouldn't recommend staying much longer.",15
            no_key=keyin
            planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
        endif
        if planets(specialplanet(12)).death=4 then 
            dprint "Science officer: We really should get back to the ship now!",14
            no_key=keyin
            planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
        endif
        if planets(specialplanet(12)).death=2 then 
            dprint "Science officer: This planet is about to fall apart! We must leave! NOW!",12
            no_key=keyin
            planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
        endif
    endif    

    if slot=specialplanet(8) and rnd_range(1,100)<33 then
        locate awayteam.c.y+1,awayteam.c.x+1
        color 15,11
        print "*"
        color 11,0
        dprint "lightning strikes you "& damawayteam(awayteam,1),12            
        player.killedby="lightning strike"
    endif
    
    if slot=specialplanet(12) and rnd_range(1,100)<33 then
        if sf>15 then sf=0
        shipfire(sf).where=rnd_point
        shipfire(sf).when=1
        shipfire(sf).what=10+sf
        player.weapons(shipfire(sf).what)=makeweapon(rnd_range(1,5))
        sf=sf+1
    endif
    
    
    if planets(slot).flags(25)=1 and awayteam.helmet=0 then
        if rnd_range(1,6)+rnd_range(1,6)+player.science>15 and crew(5).hp>0 then
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
            if enemy(a).made=5 and enemy(a).hp>0 then b=1
        next
        if b=1 then
            draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"*",,font1,custom,@_col
            sleep 50
            if rnd_range(1,6)+rnd_range(1,6)+2>8 then
                dprint "Apollo calls down lightning and strikes you, infidel!"
                dprint damawayteam(awayteam,1)
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
     
    if (planets(slot).atmos<4 and planets(slot).depth=0 and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))+countasteroidfields(sysfrommap(slot))*2-map(sysfrommap(slot)).spec and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot))) or more_mets=1 then 
        if lastmet>500 or more_mets=1 then ep_crater(slot,ship,awayteam,li(),lastlocalitem,shipfire(),sf)
        lastmet+=1
        if more_mets=1 then dprint ""&lastmet
    endif
        
        if planets(slot).atmos>6 and rnd_range(1,150)<(planets(slot).dens*planets(slot).weat) and slot<>specialplanet(28) then            
            if planets(slot).temp<300 then
                dprint "It's raining sulphuric acid! "&damawayteam(awayteam,1),14
            else
                dprint "It's raining molten lead! "&damawayteam(awayteam,1),14
            endif
            player.killedby=" hostile environment"
        endif
        
        if planets(slot).atmos>11 and rnd_range(1,100)<planets(slot).atmos*2 and frac(localturn/10)=0 then
            a=getrnditem(-2,0)
            if a>0 then
                if rnd_range(1,100)>item(a).res then
                    item(a).res=item(a).res-25
                    dprint "Your "&item(a).desig &" corrodes.",14
                    if item(a).res<0 then
                        dprint "Your "&item(a).desig &" corrodes and is no longer usable.",14
                        destroyitem(a)
                        equip_awayteam(player,awayteam,slot)
                        'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                    endif
                endif
            endif
            for a=0 to lastlocalitem
                if item(li(a)).ty<20 and item(li(a)).w.s=0 and rnd_range(1,100)<item(li(a)).res and rnd_range(1,100)<planets(slot).atmos*2 then item(li(a)).w.p=9999
            next
        endif
        
        if specialplanet(5)=slot or specialplanet(8)=slot then
            if awayteam.c.x<>ship.x and awayteam.c.y<>ship.y then
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
 

function ep_display(awayteam as _monster, vismask()as byte, enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short, byref walking as short) as short
    dim as short a,b,x,y,slot
    dim as _cords p
    slot=player.map
    if disease(awayteam.disease).bli>0 then 
        x=awayteam.c.x
        y=awayteam.c.y
        vismask(x,y)=1
        dtile(x,y,tmap(x,y),vismask(x,y))
        return 0
    endif
    ' Stuff on ground    
    makevismask(vismask(),awayteam,slot)        
    for x=awayteam.c.x-2-awayteam.sight to awayteam.c.x+2+awayteam.sight 
        for y=awayteam.c.y-2-awayteam.sight to awayteam.c.y+2+awayteam.sight
            if x>=0 and x<=60 and y>=0 and y<=20 then
                p.x=x
                p.y=y
                'if awayteam.sight>cint(distance(awayteam.c,p)) then
                if planetmap(x,y,slot)>0 then dtile(x,y,tmap(x,y))
            endif
        next
    next
           
    for x=0 to 60 
        for y=0 to 20
            p.x=x
            p.y=y
            'if awayteam.sight>cint(distance(awayteam.c,p)) then
            if vismask(x,y)>0 and awayteam.sight>cint(distance(awayteam.c,p)) then 
                if planetmap(x,y,slot)<0 then 
                    planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                    reward(0)=reward(0)+1
                    reward(7)=reward(7)+planets(slot).mapmod
                    if tiles(planetmap(x,y,slot)).stopwalking>0 then walking=0
                    if player.questflag(9)=1 and planetmap(x,y,slot)=100 then player.questflag(9)=2
                endif
                if rnd_range(1,100)<disease(awayteam.disease).hal then
                    dtile(x,y,tiles(rnd_range(1,255)))
                    planetmap(x,y,slot)=planetmap(x,y,slot)*-1 
                else
                    dtile(x,y,tmap(x,y),vismask(x,y))
                endif
            endif
        
        next
    next
    
    for a=0 to lastportal
        if portal(a).from.m=slot then
            p.x=portal(a).from.x
            p.y=portal(a).from.y
            if (vismask(portal(a).from.x,portal(a).from.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or portal(a).discovered=1 then
                if portal(a).discovered=0 then walking=0
                portal(a).discovered=1
                if _tiles=0 then
                    put (portal(a).from.x*_tix,portal(a).from.y*_tiy),gtiles(gt_no(portal(a).ti_no)),pset
                else
                    color portal(a).col,0
                    draw string(portal(a).from.x*_fw1,portal(a).from.y*_fh1),chr(portal(a).tile),,Font1,custom,@_col
                endif
            endif
        endif
        if portal(a).oneway=0 then
            if portal(a).dest.m=slot then
                p.x=portal(a).dest.x
                p.y=portal(a).dest.y
                if (vismask(portal(a).dest.x,portal(a).dest.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or portal(a).discovered=1 then
                    if portal(a).discovered=0 then walking=0
                    portal(a).discovered=1   
                    if _tiles=0 then
                        put (portal(a).dest.x*_tix,portal(a).dest.y*_tiy),gtiles(gt_no(portal(a).ti_no)),pset
                    else
                        color portal(a).col,0
                        draw string(portal(a).dest.x*_fw1,portal(a).dest.y*_fh1),chr(portal(a).tile),,Font1,custom,@_col
                    endif
                endif    
            endif
        endif
    next
    
    for a=1 to lastlocalitem
        if item(li(a)).w.m=slot and item(li(a)).w.s=0 and item(li(a)).w.p=0 then
            p.x=item(li(a)).w.x
            p.y=item(li(a)).w.y
            if  tiles(abs(planetmap(p.x,p.y,slot))).hides=0 and ((vismask(item(li(a)).w.x,item(li(a)).w.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or item(li(a)).discovered=1) then
                if item(li(a)).discovered=0 then walking=0
                item(li(a)).discovered=1
                if tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).walktru>0 and item(li(a)).bgcol=0 then
                    color item(li(a)).col,tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).col
                else
                    color item(li(a)).col,item(li(a)).bgcol
                endif
                    
                locate item(li(a)).w.y+1,item(li(a)).w.x+1
                if _tiles=0 then
                    put (item(li(a)).w.x*_tix,item(li(a)).w.y*_tiy),gtiles(gt_no(item(li(a)).ti_no)),trans
                else
                    if _transitems=1 then
                        draw string(p.x*_fw1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_col
                    else
                        if item(li(a)).bgcol=0 then
                            color 241,0
                            draw string(p.x*_fw1-1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_tcol
                            draw string(p.x*_fw1+1,P.y*_fh1), item(li(a)).icon,,font1,custom,@_tcol
                            draw string(p.x*_fw1,P.y*_fh1+1), item(li(a)).icon,,font1,custom,@_tcol
                            draw string(p.x*_fw1,P.y*_fh1-1), item(li(a)).icon,,font1,custom,@_tcol
                            color item(li(a)).col,item(li(a)).bgcol
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
            if p.x>=0 and p.x<=60 and p.y>=0 and p.y<=20 then
                if vismask(p.x,p.y)>0 and awayteam.sight>cint(distance(awayteam.c,p)) then
                    color 12,0
                    if _tiles=0 then
                        if enemy(a).hpmax>0 then put (enemy(a).c.x*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(1093)),trans
                    else
                        if enemy(a).hpmax>0 then draw string(p.x*_fw1,P.y*_fh1), "%",,font1,custom,@_col
                    endif
                endif
            endif
        endif
    next
    
    for a=1 to lastenemy
        if enemy(a).hp>0 then
            p=enemy(a).c
            if p.x>=0 and p.x<=60 and p.y>=0 and p.y<=20 then                
                if (vismask(p.x,p.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or player.stuff(3)=2 then
                    if enemy(a).cmshow=1 then
                        enemy(a).cmshow=0    
                        color enemy(a).col,203
                    else
                        color enemy(a).col,0
                    endif
                    if enemy(a).invis=0 then
                        if _tiles=0 then
                            put (enemy(a).c.x*_tix,enemy(a).c.y*_tiy),gtiles(gt_no(enemy(a).ti_no)),pset
                        else
                            draw string(p.x*_fw1,P.y*_fh1),chr(enemy(a).tile),,font1,custom,@_col
                        endif
                        if player.stuff(3)<>2 then walking=0
                    endif
                endif
            endif
        endif                    
    next
    return 0
end function


function ep_portal(awayteam as _monster, byref walking as short) as _cords
    dim as short a,ti,slot
    dim as _cords nextmap
    dim as _cords p
    slot=player.map
    for a=0 to lastportal
        if portal(a).from.m=slot then
            if awayteam.c.x=portal(a).from.x and awayteam.c.y=portal(a).from.y then
                if askyn(portal(a).desig &" Enter?(y/n)") then
                    dprint "going through."
                    walking=-1
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
                                planets(portal(a).dest.m).flavortext="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute" 
                            else
                                makecanyons(portal(a).dest.m,9)
                                p=rnd_point(portal(a).dest.m,0)
                                portal(a).dest.x=p.x
                                portal(a).dest.y=p.y
                                planets(portal(a).dest.m).flavortext="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts." 
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
                    walking=-1
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
                                planets(portal(a).from.m).flavortext="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute" 
                            else
                                makecanyons(portal(a).from.m,9)
                                p=rnd_point(portal(a).from.m,0)
                                portal(a).from.x=p.x
                                portal(a).from.y=p.y
                                planets(portal(a).dest.m).flavortext="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts." 
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
    next
    return nextmap
end function
        
function ep_pickupitem(key as string,awayteam as _monster, byref lastlocalitem as short, li() as short) as short
    dim a as short
    dim text as string
    for a=1 to lastlocalitem
        if item(li(a)).w.p=0 and item(li(a)).w.s=0 and item(li(a)).w.x=awayteam.c.x and item(li(a)).w.y=awayteam.c.y and item(li(a)).w.m=awayteam.c.m then 
            if item(li(a)).ty<>99 then 
                if _autopickup=1 then text=text &item(li(a)).desig &". " 
                if _autopickup=0 or key=key_pickup then
                    text=text &" You pick up the "&item(li(a)).desig &". " 
                    reward(2)=reward(2)+item(li(a)).v5
                    item(li(a)).w.s=-1
                endif
                if item(li(a)).ty=18 then 
                    text=text &" You transfer the map data from the rover robot. "
                    item(li(a)).v4=0
                    reward(0)=reward(0)+item(li(a)).v6
                    reward(7)=reward(7)+item(li(a)).v6
                    item(li(a)).v6=0
                endif
                if item(li(a)).ty=27 then 
                    text=text &" You gather the resources from the mining robot. "&item(li(a)).v1
                    reward(2)=reward(2)+item(li(a)).v1
                    item(li(a)).v1=0
                endif
                'awayteam.lastaction+=1
            else
                dprint "An alien artifact!"
                if _autopickup=0 or key=key_pickup then
                    
                    findartifact(awayteam,item(li(a)).v5)
                    item(li(a)).w.p=9999
                    li(a)=li(lastlocalitem)
                    lastlocalitem=lastlocalitem-1
                    'awayteam.lastaction+=1
                endif
            endif
        endif
    next
    if text<>"" then 
        dprint text
    endif
    return 0
end function

function ep_checkmove(byref awayteam as _monster,byref old as _cords,key as string,byref walking as short) as short
    dim as short slot,a,b,c
    slot=player.map
    if planetmap(awayteam.c.x,awayteam.c.y,slot)=18 then
        dprint "you get zapped by a forcefield:"&damawayteam(awayteam,rnd_range(1,6)),12
        if awayteam.armor<3 then awayteam.c=old
        walking=0
    endif
    b=findbest(12,-1) 'Find best key
    if b>0 then
        c=item(b).v1
    else
        c=0
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).no=45 and tmap(old.x,old.y).no<>45 and _warnings=0 then
        if not(askyn("do you really want to walk into hot lava?(y/n)")) then awayteam.c=old
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).onopen>0 then
        planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).onopen
        tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).locked>0 and rnd_range(1,6)+rnd_range(1,6)+player.science+c<7+tmap(awayteam.c.x,awayteam.c.y).locked then' or (tmap(awayteam.c.x,awayteam.c.y).onopen>0 and tmap(awayteam.c.x,awayteam.c.y).locked=0) then
        dprint "Your science officer can't bypass the doorlocks"
        awayteam.c=old
        walking=0
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
        a=rnd_range(1,6)+rnd_range(1,6)+player.science+c
        if a>=7 and a<12 then
            dprint "Your science officer cant open the door"
            if rnd_range(1,6)+rnd_range(1,6)>6 then
                dprint "But he sets off an ancient defense mechanism! "&damawayteam(awayteam,rnd_range(1,6))
                player.killedby="trapped door"
            endif
            walking=0
            awayteam.c=old
        endif
        if a>12 then
            dprint "You managed to open the door"
            planetmap(awayteam.c.x,awayteam.c.y,slot)=55
            tmap(awayteam.c.x,awayteam.c.y)=tiles(55)
        endif
        if a<7 then 
            dprint "Your fiddling with the ancient lock destroys it. You will never be able to open that door."
            planetmap(awayteam.c.x,awayteam.c.y,slot)=53
            walking=0
            awayteam.c=old
        endif
    endif
    
    
    if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru and _diagonals=0 then 
        awayteam.c=movepoint(old,bestaltdir(getdirection(key),0))
        if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru then awayteam.c=movepoint(old,bestaltdir(getdirection(key),1))
    endif
    select case tmap(awayteam.c.x,awayteam.c.y).walktru
        case is=0
        case is=1
            if awayteam.hp>awayteam.nohp*5 and awayteam.move<3 then
                if awayteam.hp<=awayteam.nojp then
                    if awayteam.jpfuel>awayteam.jpfueluse then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                    else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    endif
                else
                    awayteam.c=old
                    dprint "blocked"
                endif
            endif
        case is=2
            if awayteam.move<3 then
                if awayteam.hp<=awayteam.nojp then
                    if awayteam.jpfuel>awayteam.jpfueluse then
                        awayteam.jpfuel=awayteam.jpfuel-awayteam.jpfueluse
                    else
                        dprint "Jetpacks empty",14
                        awayteam.c=old
                    endif
                else
                    awayteam.c=old
                    dprint "blocked"
                endif
            endif
        case else
            awayteam.c=old
    end select
    if old.x=awayteam.c.x and old.y=awayteam.c.y then
        if walking>0 and walking<10 then walking=0
    else
        awayteam.lastaction+=1
    endif
    return 0
end function

function ep_landship(byref ship_landing as short,nextlanding as _cords,ship as _cords,nextmap as _cords,vismask() as byte,enemy() as _monster,lastenemy as short) as short
    dim as short r,slot,a,d
    slot=player.map
    ship_landing=ship_landing-1
    if ship_landing<=0 then
        r=rnd_range(player.pilot,6)+rnd_range(1,6)+player.pilot-(planets(slot).dens+planets(slot).grav*2)
        if vismask(nextlanding.x,nextlanding.y)>0 and nextmap.m=0 then dprint "She is coming in"
        if r<0 then
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
                if rnd_range(1,6)+rnd_range(1,6)+player.pilot>10 then
                    dprint ("but your pilot wants to try anyway and succeeds!",12)
                    player.hull=1
                    gainxp(2)
                else
                    player.dead=4
                endif
                no_key=keyin
            endif
        else
            gainxp(2)
        endif
        player.landed.m=slot
        ship.m=slot
        ship.x=nextlanding.x
        ship.y=nextlanding.y
        player.landed.x=ship.x
        player.landed.y=ship.y
        for a=0 to lastenemy
            if distance(enemy(a).c,nextlanding)<2 then
                enemy(a).hp=enemy(a).hp-(player.h_no+planets(slot).grav)/(1+distance(enemy(a).c,nextlanding))
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" gets caught in the blast of the landing ship."
                if rnd_range(1,6)+rnd_range(1,6)>enemy(a).intel then
                    enemy(a).aggr=2
                    enemy(a).target=nextlanding
                endif
            endif
        next
    endif
    return 0
end function

function ep_areaeffects(awayteam as _monster,areaeffect() as _ae,byref last_ae as short,lavapoint() as _cords,enemy() as _monster, lastenemy as short, li() as short, byref lastlocalitem as short) as short
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
            if areaeffect(a).typ=1 and areaeffect(a).dur=0 then dprint "the ground rumbles",14'eartquake
            if areaeffect(a).typ=1 and areaeffect(a).dur=0 and findbest(16,-1)>0 and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14
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
                                    if x=awayteam.c.x and y=awayteam.c.y and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then
                                        dprint "A tremor",14
                                        if findbest(16,-1)>0 and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14
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
                                        dprint "An Earthquake! "& damawayteam(awayteam,rnd_range(1,areaeffect(a).dam-distance(p1,areaeffect(a).c))),12
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
                                color 15,0
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
                                tmap(x,y).tile=asc("~")
                                tmap(x,y).seetru=1
                                tmap(x,y).desc="steam"
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


function ep_tileeffects(awayteam as _monster,areaeffect() as _ae, byref last_ae as short,lavapoint() as _cords, nightday() as byte, localtemp() as single,vismask() as byte) as short
    dim as short a,x,y,dam,slot
    dim as _cords p,p2
    slot=player.map
    for x=0 to 60
        for y=0 to 20
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
                        dprint tmap(x,y).hitt &" "&  damawayteam(awayteam,dam),12
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
                
                if nightday(x)=3 then localtemp(x,y)=localtemp(x)-.0005'rnd_range(1,(10-planets(slot).dens))/15+orbit
                if nightday(x)=0 then localtemp(x,y)=localtemp(x)+.0005'rnd_range(1,(10-planets(slot).dens))/15+orbit
                
                if localtemp(x,y)>10 and tmap(x,y).no=27 or tmap(x,y).no=260 then
                    tmap(x,y).hp-=localtemp(x,y)/25
                    if tmap(x,y).hp<0 then 
                        tmap(x,y)=tiles(2)
                        changetile(x ,y ,slot ,2)
                        if vismask(x,y)>0 then dprint "The ice melts."
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
        dprint "smoldering lava:" &damawayteam(awayteam,rnd_range(1,6-awayteam.move)),12
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
            dprint "...and breaks! "&damawayteam(awayteam,rnd_range(1,3)),12
            tmap(awayteam.c.x,awayteam.c.y)=tiles(2)
            planetmap(awayteam.c.x,awayteam.c.y,slot)=2
        endif
    endif
    
    return 0
end function

function ep_lava(awayteam as _monster,lavapoint() as _cords,ship as _cords, vismask() as byte, byref walking as short) as short
    dim as short a,slot
    slot=player.map
    if planets(slot).temp+rnd_range(0,10)>350 then 'lava            
        a=rnd_range(1,5)
        if lavapoint(a).x=0 and lavapoint(a).y=0 then
            lavapoint(a).x=rnd_range(1,60)
            lavapoint(a).y=rnd_range(1,20)
        endif
        if rnd_range(1,100)<75 then
            if lavapoint(a).x<>ship.x and lavapoint(a).y<>ship.y then 
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
        if lavapoint(a).x=ship.x and lavapoint(a).y=ship.y then
            player.hull=player.hull-1
            if distance(lavapoint(a),awayteam.c)<awayteam.sight then dprint "Your ship was damaged!"
            if player.hull<=0 then player.dead=15
        endif
    endif
    return 0
end function


function ep_updatemasks(spawnmask() as _cords,mapmask() as byte,nightday() as byte, byref dawn as single, byref dawn2 as single) as short
    dim as short lsp,x,y,slot
    slot=player.map
    if planets(slot).depth=0 and planets(slot).rot>0 then
        dawn=dawn+planets(slot).rot
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

        

function ep_items(awayteam as _monster, li() as short, byref lastlocalitem as short,enemy() as _monster,lastenemy as short, localturn as short) as short
    dim as short a,slot
    dim as _cords p1,p2
    dim as single dam
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
                        alienbomb(awayteam,li(a),slot,enemy(),lastenemy,li(),lastlocalitem)
                        if dam>0 then dprint damawayteam(awayteam,dam)
                        if awayteam.hp<=0 then player.dead=29
                    endif
                endif
            endif
            
            if item(li(a)).ty=18 and item(li(a)).discovered=1 and item(li(a)).w.p=0 and item(li(a)).w.s>=0 then 'Rover
                p1.x=item(li(a)).w.x
                p1.y=item(li(a)).w.y
                if planetmap(p1.x,p1.y,slot)<0 then
                    color 0,0
                    draw string(p1.x*_fw1,p1.y*_fh1), " ",,font1,custom,@_col
                else
                    color tmap(p1.x,p1.y).col,tmap(p1.x,p1.y).bgcol
                    draw string(p1.x*_fw1,p1.y*_fh1), chr(tmap(p1.x,p1.y).tile),,Font1,custom,@_col
                endif
                if frac(localturn/10)=0 and item(li(a)).v4=0 then
                    if item(li(a)).vt.x<0 then
                        p1=movepoint(p1,5)
                    else
                        p1=movepoint(p1,nearest(item(li(a)).vt,p1))
                        if p1.x=item(li(a)).vt.x and p1.y=item(li(a)).vt.y then item(li(a)).vt.y=-1 
                    endif
                    if tmap(p1.x,p1.y).walktru<=item(li(a)).v2 then
                        item(li(a)).w.x=p1.x
                        item(li(a)).w.y=p1.y
                        for x=item(li(a)).w.x-item(li(a)).v1-3 to item(li(a)).w.x+item(li(a)).v1+3
                            for y=item(li(a)).w.y-item(li(a)).v1-3 to item(li(a)).w.y+item(li(a)).v1+3
                                if x>=0 and y>=0 and x<=60 and y<=20 then
                                    p2.x=x
                                    p2.y=y
                                    if distance(p1,p2)<=item(li(a)).v1+1 and planetmap(x,y,slot)<0 then
                                        planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                                        item(li(a)).v6=item(li(a)).v6+0.5*item(li(a)).v3
                                    endif
                                endif
                            next
                        next
                    endif
                endif
            endif
        next
        return 0
    end function
    

function ep_monstermove(awayteam as _monster, enemy() as _monster, m() as single, byref lastenemy as short, li() as short,byref lastlocalitem as short,spawnmask() as _cords, lsp as short, vismask() as byte, mapmask() as byte, byref walking as short) as short
    dim deadcounter as short
    dim as short a,b,c,slot,ti
    dim moa as byte 'monster attack
    dim as _cords p1,p2
    dim as single tb,dam
    slot=player.map
    deadcounter=0
    for a=1 to lastenemy        
        if player.questflag(25)<>0 then
            if enemy(a).made=66 or enemy(a).made=67 or enemy(a).made=68 then
                enemy(a).faction=1
                enemy(a).aggr=1
            endif
        endif
        if enemy(a).c.x<0 then enemy(a).c.x=0
        if enemy(a).c.y<0 then enemy(a).c.y=0
        if enemy(a).c.x>60 then enemy(a).c.x=60
        if enemy(a).c.y>20 then enemy(a).c.x=20
        locate enemy(a).c.y+1,enemy(a).c.x+1
        if enemy(a).hp>0 then            
            'changes mood
            if enemy(a).aggr=1 then
                if rnd_range(1,100)>25*distance(enemy(a).c,awayteam.c) then 
                    if rnd_range(1,6)+rnd_range(1,6)>6+awayteam.invis+enemy(a).cmmod and enemy(a).sleeping<1 then
                        enemy(a).aggr=0
                        if distance(enemy(a).c,awayteam.c)<=awayteam.sight then 
                            enemy(a).cmshow=1
                            dprint "The "&enemy(a).sdesc &" suddenly seems agressive",14
                        endif
                        for b=1 to lastenemy
                            if a<>b then
                                if enemy(a).faction=enemy(b).faction and vismask(enemy(b).c.x,enemy(b).c.y)>0 then 
                                    enemy(b).aggr=0
                                    enemy(a).cmshow=1
                                    dprint "The "&enemy(b).sdesc &" tries to help his friend!",14
                                endif
                            endif
                        next
                    endif
                endif
            endif                
            if rnd_range(1,100)<enemy(a).breedson and enemy(a).breedson>0 and lastenemy<128 then
                lastenemy=lastenemy+1
                enemy(lastenemy).c=movepoint(enemy(a).c,5)
                if tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru=0 or enemy(a).stuff(tmap(enemy(lastenemy).c.x,enemy(lastenemy).c.y).walktru)>0 then
                    enemy(lastenemy)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,vismask(),enemy(lastenemy).c.x,enemy(lastenemy).c.y,c)
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 or vismask(enemy(lastenemy).c.x,enemy(lastenemy).c.y)>0 then dprint "the "&enemy(a).sdesc &" multiplies!"
                else
                    lastenemy-=1
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
                                if rnd_range(1,6)+rnd_range(1,6)>enemy(a).intel then
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
                    if rnd_range(1,6)+rnd_range(1,6)+player.science>3+planets(slot).atmos then dprint "Recieving radio transmission: 'Returning to ship'"
                else
                    enemy(a).target.x=item(li(c)).w.x
                    enemy(a).target.y=item(li(c)).w.y
                    if rnd_range(1,6)+rnd_range(1,6)+player.science>3+planets(slot).atmos then dprint "Recieving radio transmission: 'Going for ore at "&enemy(a).target.x &":"&enemy(a).target.y &"'"
                endif
            endif
            
            'm(a)=m(a)+enemy(a).move
            tb=planets(slot).grav/10
            if enemy(a).aggr=2 then tb=tb+0.1 
            if awayteam.hp<3 then tb=tb-0.6
            if abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=7 or abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=8 then tb=tb-0.5
            tb=tb-(awayteam.move/10)-addtalent(-1,24,0)
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
            
            if _tiles=0 then
                'Nothing
            else
                if planetmap(enemy(a).c.x,enemy(a).c.y,slot)>0 then 
                    dtile(enemy(a).c.x,enemy(a).c.y,tiles(planetmap(enemy(a).c.x,enemy(a).c.y,slot)))
                else
                    color 0,0
                    draw string(enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), " ",,font1,custom,@_col
                endif
            endif
            
            if enemy(a).sleeping>0 then enemy(a).sleeping=enemy(a).sleeping-m(a)
            
            while m(a)>0.9 and enemy(a).sleeping<=0 and enemy(a).invis<2
                x=enemy(a).c.x
                y=enemy(a).c.y
                mapmask(enemy(a).c.x,enemy(a).c.y)=0
                ti=abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))
                if ti=1 or ti=2 then mapmask(enemy(a).c.x,enemy(a).c.y)=1
                if ti=7 or ti=8 then mapmask(enemy(a).c.x,enemy(a).c.y)=2
                if ti>46 and ti<55 then mapmask(x,y)=3
                if enemy(a).track>0 then 
                    changetile(enemy(a).c.x,enemy(a).c.y,slot,enemy(a).track)
                    tmap(enemy(a).c.x,enemy(a).c.y)=tiles(enemy(a).track)
                endif
                if enemy(a).target.x=0 and enemy(a).target.y=0 then
                    p1=rnd_point
                else
                    p1=enemy(a).target
                endif
                enemy(a)=movemonster(enemy(a), p1, mapmask(),tmap())
                mapmask(enemy(a).c.x,enemy(a).c.y)=3
                m(a)=m(a)-1
            wend
            
            if enemy(a).hasoxy=0 and planets(slot).atmos=1 then
                enemy(a).hp=enemy(a).hp-1
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" is struggling for air!"
            endif
        else
            deadcounter=deadcounter+1
        endif
    next
    
    for a=1 to lastenemy
        if enemy(a).c.x<0 then enemy(a).c.x=0
        if enemy(a).c.y<0 then enemy(a).c.y=0
        if enemy(a).c.y>20 then enemy(a).c.y=20
        if enemy(a).c.x>60 then enemy(a).c.x=60
        if enemy(a).aggr=0 or enemy(a).aggr=2 then
            if distance(enemy(a).c,awayteam.c)<enemy(a).sight-awayteam.invis/2 then enemy(a).target=awayteam.c                            
        endif    
        if distance(enemy(a).c,awayteam.c)<enemy(a).range and enemy(a).hp>0 then
            if enemy(a).sleeping=0 and (enemy(a).move=-1 or m(a)>0) then
                if enemy(a).invis=2 then
                    dprint "A clever "&enemy(a).sdesc &" has been hiding here, waiting for prey!",14
                    enemy(a).invis=0
                endif
                walking=0
                
                color enemy(a).col,0
                
                if enemy(a).invis=0 then 
                    if _tiles=0 then
                        put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                    else
                        draw string(enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), chr(enemy(a).tile),,font1,custom,@_col
                    endif
                endif
                if (enemy(a).aggr=0 or enemy(a).aggr=2) then 
                    b=1
                    if pathblock(awayteam.c,enemy(a).c,slot)=0 then b=0
                    if b=1 then 
                        walking=0
                        pathblock(enemy(a).c,awayteam.c,slot,,enemy(a).scol)
                        awayteam=monsterhit(enemy(a),awayteam)
                        m(a)=m(a)-enemy(a).atcost
                    endif
                endif
            endif
        endif
        if enemy(a).nearest>0 then
            if m(a)>0 and enemy(a).faction<>enemy(enemy(a).nearest).faction and enemy(a).hp>0 and enemy(enemy(a).nearest).hp>0 then
                moa=0
                if enemy(a).faction>7 or enemy(enemy(a).nearest).faction>7 then 
                    moa=1
                else
                    if faction(enemy(a).faction).war(enemy(enemy(a).nearest).faction)>rnd_range(1,100) then moa=1
                    if faction(enemy(enemy(a).nearest).faction).war(enemy(a).faction)>rnd_range(1,100) then moa=1
                endif
                if moa=1 then
                    enemy(enemy(a).nearest)=monsterhit(enemy(a),enemy(enemy(a).nearest))
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
                                companystats(basis(nearestbase(player.c)).company).profit+=1
                            endif
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=272 or tmap(enemy(a).c.x,enemy(a).c.y).no=273 then dprint "The alien ship launches."
                        else
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=86 then 
                                dprint "You see a scoutship starting in the distance."                                                        
                                companystats(basis(nearestbase(player.c)).company).profit+=1
                            endif
                            if tmap(enemy(a).c.x,enemy(a).c.y).no=272 or tmap(enemy(a).c.x,enemy(a).c.y).no=273 then dprint "You see an alien ship starting in the distance."                                                        
                            companystats(basis(nearestbase(player.c)).company).profit+=1
                        endif
                        enemy(a)=enemy(lastenemy)
                        lastenemy=lastenemy-1
                        
                    endif
                endif
            endif
       endif
       for b=1 to lastlocalitem
            if item(li(b)).w.x=enemy(a).c.x and item(li(b)).w.y=enemy(a).c.y and enemy(a).hp>0 and item(li(b)).w.s=0 then
                if item(li(b)).ty=21 or item(li(b)).ty=22 and item(li(b)).w.p<>9999 then
                    item(li(b)).w.p=9999
                    if item(li(b)).ty=21 then enemy(a).hp=enemy(a).hp-rnd_range(1,item(li(b)).v1)
                    if item(li(b)).ty=22 then enemy(a).sleeping=enemy(a).sleeping+rnd_range(1,item(li(b)).v1)
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                        locate item(li(b)).w.y+1,item(li(b)).w.x+1
                        color item(li(b)).col,1
                        draw string (item(li(b)).w.x*_fw1,item(li(b)).w.y*_fh1), chr(176),,font2,custom,@_col
                        dprint "The mine explodes under the "&enemy(a).sdesc &"!"
                        sleep 50
                    endif
                else
                    if rnd_range(1,6)+enemy(a).pumod>7 and item(li(b)).ty<>23 and item(li(b)).w.p=0 then
                        item(li(b)).w.p=a
                        item(li(b)).discovered=0
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" picks up the "&item(li(b)).desig &"."
                    endif
                endif
            endif    
       next
    next
    return deadcounter
end function

function ep_spawning(enemy() as _monster,lastenemy as short,spawnmask() as _cords,lsp as short, diesize as short,vismask() as byte) as short
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
        next
    next
    for a=1 to lastenemy
        if enemy(a).hp<=0 and planets(slot).atmos>12 and rnd_range(1,100)>planets(slot).atmos then enemy(a).hpmax=enemy(a).hpmax-1
        if enemy(a).hp<=0 then enemy(a).hp=enemy(a).hp-1
        if enemy(a).hp<-45-diesize and enemy(a).respawns=1 and rnd_range(1,100)<(1+planets(slot).life)*10 then 
            enemy(a)=setmonster(planets(slot).mon_template(enemy(a).slot),slot,spawnmask(),lsp,vismask(),,,a)
            planets(slot).life-=1
            if planets(slot).life<0 then planets(slot).life=0
        endif
    next
    return lastenemy
end function

function ep_shipfire(shipfire() as _shipfire,vismask() as byte,enemy() as _monster,byref lastenemy as short, byref awayteam as _monster) as short
    dim as short sf2,a,b,c,x,y,r,dam,slot
    dim p2 as _cords
    slot=player.map
    for sf2=0 to 16
        if shipfire(sf2).when>0 then  
            shipfire(sf2).when-=1
            if shipfire(sf2).tile<>"" and vismask(shipfire(sf2).where.x,shipfire(sf2).where.y)>0 then
                color 7,0
                draw string (shipfire(sf2).where.x*_fw1,shipfire(sf2).where.y*_fh1),shipfire(sf2).tile,,Font1,custom,@_col
            endif
            if shipfire(sf2).when=0 then
                shipfire(sf2).tile=""
                b=rnd_range(1,6)+rnd_range(1,6)+maximum(player.sensors,player.gunner)
                if b>13 then gainxp(2)
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
                dam=0
                if r<1 then r=1
                for a=1 to player.weapons(shipfire(sf2).what).dam
                    dam=dam+rnd_range(1,6)
                next
                for x=shipfire(sf2).where.x-5 to shipfire(sf2).where.x+5
                    for y=shipfire(sf2).where.y-5 to shipfire(sf2).where.y+5
                        p2.x=x
                        p2.y=y
                        if x>=0 and y>=0 and x<=60 and y<=20 then
                            if distance(shipfire(sf2).where,p2)<=r then
                                'Deal damage
                                for a=1 to lastenemy
                                    if enemy(a).c.x=x and enemy(a).c.y=y then
                                        enemy(a).hp=enemy(a).hp-dam
                                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint enemy(a).sdesc &" takes " &dam &" points of damage.",10
                                        if enemy(a).hp<=0 then
                                            player.alienkills=player.alienkills+1
                                         endif
                                         exit for
                                    endif
                                next
                                if awayteam.c.x=x and awayteam.c.y=y then dprint "you got caught in the blast! " & damawayteam(awayteam,dam),12
                                'Show
                                locate y+1,x+1
                                if player.weapons(shipfire(sf2).what).ammomax>0 then
                                    if x=shipfire(sf2).where.x and y=shipfire(sf2).where.y then color 15,15
                                    if distance(shipfire(sf2).where,p2)>0 then color 12,14
                                    if distance(shipfire(sf2).where,p2)>1 then color 12,0
                                else
                                    if x=shipfire(sf2).where.x and y=shipfire(sf2).where.y then color 15,15
                                    if distance(shipfire(sf2).where,p2)>0 then color 11,9
                                    if distance(shipfire(sf2).where,p2)>1 then color 9,1
                                endif                                
                                draw string (x*_fw1,y*_fh1), chr(178),,Font1,custom,@_col
                                if tmap(x,y).no=3 or tmap(x,y).no=5 or tmap(x,y).no=6 or tmap(x,y).no=10  or tmap(x,y).no=11 or tmap(x,y).no=14 then 
                                    tmap(x,y)=tiles(4)
                                    if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=4
                                    if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-4
                                endif
                                if tmap(x,y).shootable>0 then
                                    tmap(x,y).hp=tmap(x,y).hp-dam
                                    if tmap(x,y).succt<>"" and vismask(x,y)>0 then dprint tmap(x,y).succt,12
                                    if tmap(x,y).hp<=0 then
                                        if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).turnsinto
                                        if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                                        tmap(x,y)=tiles(tmap(x,y).turnsinto)
                                    endif
                                endif
                            endif
                        endif
                    next
                next
                sleep 100+distance(awayteam.c,shipfire(sf2).where)*6
                if (_sound=0 or _sound=2) and planets(slot).atmos>1 then FSOUND_PlaySound(FSOUND_FREE, sound(4))
                
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

function ep_radio(awayteam as _monster,byref ship as _cords, byref nextlanding as _cords,byref ship_landing as short, li() as short,lastlocalitem as short,shipfire() as _shipfire,lavapoint() as _cords, byref sf as single) as short
    dim as _cords p,p1,p2,pc
    dim as string text
    dim as short a,b,slot
    slot=player.map
    p2.x=ship.x
    p2.y=ship.y
    dprint "Calling ship."
    if (pathblock(awayteam.c,p2,slot,1)=-1 or awayteam.stuff(8)=1 or (awayteam.c.x=p2.x and awayteam.c.y=p2.y)) and ship.m=slot then
        dprint "Your command?"
        text=" "
        pc=locEOL
        text=ucase(gettext(pc.x,pc.y,46,text))
        if instr(text,"ROVER")>0 then
            b=0
            for a=0 to lastlocalitem
                if item(li(a)).ty=18 and item(li(a)).w.p=0 and item(li(a)).w.s=0 then b=li(a)
            next
            if b>0 then
                p1.x=item(b).w.x
                p1.y=item(b).w.y
                if pathblock(p2,p1,slot,1)=-1 or (awayteam.stuff(8)=1 and ship.m=slot) then
                    if instr(text,"STOP")>0 then 
                        dprint "Sending stop command to rover"
                        item(b).v4=1
                    endif
                    if instr(text,"START")>0 then 
                        dprint "sending start command to rover."
                        item(b).v4=0
                    endif
                    if instr(text,"TARGET")>0 then 
                        dprint "Get target for rover:"
                        do
                            'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                            text=cursor(p1,slot)
                        loop until text=key_enter or text=key_esc
                        if text=key_enter then item(b).vt=p1
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
        if instr(text,"SELFDESTERUCT")>0 then dprint "We don't have a selfdestruct device. Guess we could make the reactor go critical, but why would we want to?"
        if instr(text,"SCAN")>0 or instr(text,"ORBITAL")>0 or instr(text,"SATELLI")>0 then
            if awayteam.stuff(8)=0 then
                dprint "We don't have a satellite in orbit"
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
        if instr(text,"POSIT")>0 or instr(text,"LOCATI")>0 or instr(text,"WHERE")>0 then
            dprint "We are at " &ship.x &":" &ship.y
        endif
        if instr(text,"LAUNC")>0 or instr(text,"START")>0 then
            if askyn("Are you certain? you want us to launch and leave you behind?") then 
                if planets(slot).depth=0 then 
                    player.dead=4
                else
                    dprint "Good luck then."
                    ship.m=0
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
                p.x=ship.x
                p.y=ship.y
                if instr(text,"HERE")>0 then
                    nextlanding.x=awayteam.c.x
                    nextlanding.y=awayteam.c.y
                    player.landed.m=0
                else
                    dprint "Roger. Where do you want me to land?"
                    nextlanding=awayteam.c
                    do
                        text=cursor(nextlanding,slot)
                    loop until text=key_enter or text=key_esc
                    if text=key_enter then
                        player.landed.m=0
                    else
                        nextlanding.x=p.x
                        nextlanding.y=p.y
                    endif
                endif
                if nextlanding.x=ship.x and nextlanding.y=ship.y then
                    dprint "We already are at that position."
                    ship.m=slot
                    ship.x=nextlanding.x
                    ship.y=nextlanding.y
                
                else
                    ship_landing=distance(p,nextlanding)/2
                    if ship_landing<1 then ship_landing=1
                    if crew(2).onship=1 then
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
            do
                'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                text=cursor(shipfire(sf).where,slot)
            loop until text=key_enter or text=key_esc
            if text=key_enter then
                if pathblock(p2,shipfire(sf).where,slot,1)=0 then
                    dprint "No line of sight to that target."
                    shipfire(sf).where.x=-1
                    shipfire(sf).where.y=-1
                else
                    shipfire(sf).when=(distance(awayteam.c,p2)\10)+1
                    shipfire(sf).what=getshipweapon                            
                    if shipfire(sf).what<0 then
                        shipfire(sf).what=6
                        shipfire(sf).when=-1
                    endif
                    if player.weapons(shipfire(sf).what).desig="" then shipfire(sf).when=-1
                    if player.weapons(shipfire(sf).what).ammomax>0 then 
                        player.weapons(shipfire(sf).what).ammo=player.weapons(shipfire(sf).what).ammo-1
                        if player.weapons(shipfire(sf).what).ammo<0 then 
                            shipfire(sf).when=-2
                            player.weapons(shipfire(sf).what).ammo=0
                        endif
                    endif
                    if shipfire(sf).when>0 then dprint player.weapons(shipfire(sf).what).desig &" fired"
                    if shipfire(sf).when=-1 then dprint "Fire order canceled"
                    if shipfire(sf).when=-2 then dprint "I am afraid that weapon is out of ammunition"
                endif
            endif                            
        endif
        awayteam.lastaction+=2
    else
        dprint "No contact possible"
    endif
    return 0
end function


function ep_helmet(awayteam as _monster) as short
    dim as short slot
    slot=player.map
            if awayteam.helmet=0 then
                dprint "Switching to suit oxygen supply."
                awayteam.helmet=1
                'oxydep
            else                
                'Opening Helmets
                if planets(slot).atmos>1 and planets(slot).atmos<8 then
                    awayteam.helmet=0
                    dprint "Opening helmets"
                else
                    dprint "We can't open our helmets here"
                endif
            endif
            equip_awayteam(player,awayteam,slot)
    return 0
end function

function ep_grenade(awayteam as _monster, shipfire() as _shipfire, byref sf as single) as short
    dim as short c,slot
    slot=player.map
    dim as _cords p
    if _chosebest=0 then
        c=findbest(7,-1)
    else
        c=getitem(-1,7)
    endif
    if c>0 then
        if item(c).ty=7 then
            p=grenade(awayteam.c,slot)
            if p.x>=0 then
                
                sf=sf+1
                if sf>15 then sf=0
                shipfire(sf).where=p
                dprint "Delay for the grenade?"
                shipfire(sf).when=getnumber(1,5,1)
                shipfire(sf).what=11+sf
                shipfire(sf).tile=item(c).icon
                player.weapons(shipfire(sf).what)=makeweapon(item(c).v1)
                player.weapons(shipfire(sf).what).ammomax=1 'Sets color to redish
                item(c)=item(lastitem)
                lastitem=lastitem-1
            else
                dprint "canceled"
            endif
        else
            dprint "That's not a grenade."
        endif
    else
        dprint"You dont have any grenades"
    endif
    return 0
end function

function ep_playerhitmonster(awayteam as _monster,old as _cords, enemy() as _monster, lastenemy as short,vismask() as byte,mapmask() as byte) as short
    dim as short a,b,slot
    slot=player.map
    for a=1 to lastenemy
        if vismask(enemy(a).c.x,enemy(a).c.y)>0 and enemy(a).slot>=0 then planets(slot).mon_seen(enemy(a).slot)=1
        if enemy(a).hp>0 then
            if awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
                awayteam.lastaction+=1
                awayteam.c=old
                color _teamcolor,0
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
                if enemy(a).sleeping>0 then
                    if askyn("The "&enemy(a).sdesc &" is unconcious. Do you want to capture it alive?(y/n)") then
                        b=findworst(26,-1)
                        if b>0 then
                            if item(b).v1<item(b).v2 then
                                item(b).v1+=1
                                enemy(a).hp=0
                                enemy(a).hpmax=0
                                reward(1)=reward(1)+50+cint(2*enemy(a).biomod*enemy(a).hpmax)
                                if enemy(a).slot>=0 then planets(slot).mon_caught(enemy(a).slot)+=1
                                awayteam.lastaction+=2
                            else
                                dprint "You don't have any free cages left."
                            endif
                        else
                            dprint "You don't have any cages for the "&enemy(a).sdesc
                        endif
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
                        endif
                    else
                        enemy(a)=hitmonster(enemy(a),awayteam,mapmask())
                        awayteam.lastaction+=1
                    endif                        
                endif
            endif
        endif
    next
    return 0
end function

function ep_fire(awayteam as _monster,enemy() as _monster,lastenemy as short,vismask() as byte,mapmask() as byte,byref walking as short,key as string,byref autofire_target as _cords) as short
    static autofire_dir as short
    dim enlist(128) as short
    dim shortlist as short
    dim wp(80) as _cords
    dim dam as short
    dim as short first,last,lp
    dim as short a,b,c,d,e,f,slot
    dim as short scol
    dim as single range
    dim fired(60,20) as byte
    dim as _cords p,p1,p2
    dim text as string
    slot=player.map
    if _tiles=0 then
        put (awayteam.c.x*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(1000)),pset
    else
        color _teamcolor,0
        draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col                
    endif
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

    if autofire_dir>0 and autofire_dir<>5 then
        awayteam.lastaction+=1
        e=0
        p2.x=awayteam.c.x
        p2.y=awayteam.c.y
        do
            color _teamcolor,0
            draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col                
            p2=movepoint(p2,autofire_dir,2)
            color scol,0
            if vismask(p2.x,p2.y)>0 then draw string(p2.x*_fw1,p2.y*_fh1), "*",,Font1,custom,@_col
            c=c+1
            c=ep_fireeffect(p2,slot,c,range,enemy(),lastenemy,awayteam,mapmask())
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
        dprint "Choose target"
        p=awayteam.c
        a=0
        do 
            color _teamcolor,0
            draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
            p1=p
            no_key=cursor(p,slot)
            if distance(p,awayteam.c)<b then p=p1
            if no_key=key_te or ucase(no_key)=" " or multikey(SC_ENTER) then a=1
            if no_key=key_quit or multikey(SC_ESCAPE) then a=-1    
        loop until a<>0
        autofire_target=p1
        
        if a>0 then
            if distance(awayteam.c,enemy(a).c)<=range then
                awayteam.lastaction+=1              
                pathblock(awayteam.c,autofire_target,slot,3,scol)
                lp=line_in_points(awayteam.c,autofire_target,wp())
                for b=1 to lp
                    b=ep_fireeffect(wp(b),slot,b,lp+1,enemy(),lastenemy,awayteam,mapmask())
                next
            else
                dprint "Target out of range.",14
            endif
        endif
        if key=key_autofire then walking=11
    endif
    
    if no_key=key_layfire then
        for a=1 to lastenemy
            if vismask(enemy(a).c.x,enemy(a).c.y)>0 and enemy(a).hp>0 and enemy(a).aggr=0 and awayteam.sight>cint(distance(awayteam.c,enemy(a).c)) and distance(awayteam.c,enemy(a).c)<=range then
                if pathblock(awayteam.c,enemy(a).c,slot,1) then
                    enlist(shortlist)=a
                    shortlist+=1
                endif
            endif
        next
        if shortlist>0 then
            awayteam.lastaction+=1
            first=0
            last=fix(awayteam.hpmax/shortlist)
            if last<1 then last=1
            for a=0 to shortlist-1
                lp=line_in_points(awayteam.c,enemy(enlist(a)).c,wp())
                pathblock(awayteam.c,enemy(enlist(a)).c,slot,3,scol,0)                
                for b=1 to lp
                    if fired(wp(b).x,wp(b).y)=0 then b=ep_fireeffect(wp(b),slot,b,lp+1,enemy(),lastenemy,awayteam,mapmask(),first,last)
                    fired(wp(b).x,wp(b).y)=1
                next
                first=first+last+1
            next
        else
            dprint "No hostile targets in sight."
        endif
        autofire_dir=0
    endif
    return 0
end function

function ep_fireeffect(p2 as _cords,slot as short, c as short, range as short,enemy() as _monster, lastenemy as short, awayteam as _monster, mapmask() as byte, first as short=0,last as short=0) as short
    dim as short d,f
    dim as single dam
    if first=0 and last=0 then 
        first=1
        last=awayteam.hpmax
    endif
    for d=1 to lastenemy
        if enemy(d).c.x=p2.x and enemy(d).c.y=p2.y and enemy(d).hp>0 then 
            enemy(d)=hitmonster(enemy(d),awayteam,mapmask())
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
            if tmap(p2.x,p2.y).hp<=0 then 
                if tmap(p2.x,p2.y).no=243 then
                    if planets(slot).atmos>1 then dprint "The air rushes out of the ship!",14
                    awayteam.helmet=1
                    planets(slot).atmos=1
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
        c=range                 
    endif
    return c
end function

function ep_closedoor(awayteam as _monster) as short
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

function ep_examine(awayteam as _monster,ship as _cords,vismask() as byte, li() as short,enemy() as _monster,lastenemy as short,lastlocalitem as short, byref walking as short) as short
    dim as _cords p2,p3
    dim as string key,text
    dim as short a,deadcounter,slot
    slot=player.map
    p2.x=awayteam.c.x
    p2.y=awayteam.c.y
    do
        ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,walking)               
        color _teamcolor,0
        draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
        if planetmap(ship.x,ship.y,slot)>0 and slot=player.landed.m then
            locate ship.y+1,ship.x+1
            color _shipcolor,0
            draw string(ship.x*_fw1,ship.y*_fh1), "@",,font1,custom,@_col
        endif
        p3=p2
        key=cursor(p2,slot)
        if p3.x<>p2.x or p3.y<>p2.y then
            if distance(p2,awayteam.c)<=awayteam.sight and vismask(p2.x,p2.y)>0 then
                text=tmap(p2.x,p2.y).desc &". "
                for a=0 to lastportal
                    if p2.x=portal(a).from.x and p2.y=portal(a).from.y and slot=portal(a).from.m then text=text & portal(a).desig &". "
                    if p2.x=portal(a).dest.x and p2.y=portal(a).dest.y and slot=portal(a).dest.m and portal(a).oneway=0 then text= text &portal(a).desig &". "
                next
                                
                for a=1 to lastlocalitem
                    if item(li(a)).w.x=p2.x and item(li(a)).w.y=p2.y and item(li(a)).w.p=0 and item(li(a)).w.s=0 then 
                        text=text & item(li(a)).desig &". " 
                        'if show_all=1 then text=text &"("&item(li(a)).w.x &" "&item(li(a)).w.y &" "&item(li(a)).w.p &" "&localitem(a).w.s &" "&localitem(a).w.m &")"
                    endif
                next
                
                for a=1 to lastenemy
                    if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y and enemy(a).hpmax>0 then
                        if enemy(a).hp>0 then
                            if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y then
                                color enemy(a).col,9
                                text=text &" "& mondis(enemy(a))
                            else
                                color enemy(a).col,0
                            endif
                            locate enemy(a).c.y+1,enemy(a).c.x+1,0
                            if _tiles=0 then
                                put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                            else
                                draw string (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), chr(enemy(a).tile),,Font1,custom,@_col
                            endif
                        else
                            color 12,0
                            locate enemy(a).c.y+1,enemy(a).c.x+1
                            if _tiles=0 then
                                 put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(261),trans
                            else
                                draw string (enemy(a).c.x*_fw1,enemy(a).c.y*_fh1), "%",,Font1,custom,@_col
                            endif
                            text=text & mondis(enemy(a))
                            if _debug=1 then text=text &"("&a &" of "&lastenemy &")"
                        endif
                        exit for 'there won't be more than one monster on one tile
                    endif
                next
            endif
            if text<>"" then dprint text
            text=""
        endif
    loop until key=key_enter or key=key_esc or ucase(key)="Q"
    return 0
end function

function ep_jumppackjump(awayteam as _monster) as short
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
                color _teamcolor,0
                draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,font1,custom,@_col
                sleep 50
            next
            awayteam.oxygen=awayteam.oxygen-5
            if rnd_range(1,6)+rnd_range(1,6)+planets(slot).grav>7 then
                dprint "Crash Landing! " &damawayteam(awayteam,rnd_range(1,1+planets(slot).grav))
            else
                dprint "You land savely"
            endif
        else
            dprint "you hit the ceiling pretty fast! "&damawayteam(awayteam,rnd_range(1,1+planets(slot).grav))
        endif
    else
        dprint "Not enough jetpack fuel"
    endif
    return 0
end function

function ep_crater(slot as short,ship as _cords,awayteam as _monster,li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single) as short
    dim as short b,r,x,y,c
    dim as _cords p2,p1
    dim m(60,20) as short
    b=rnd_range(5,15)
    b=b-planets(slot).atmos
    if b>0 then
        c=0
        dprint "A meteorite streaks across the sky and slams into the planets surface!",14
        do            
            c+=1
            r=5
            if rnd_range(1,100)<66 then r=3
            if rnd_range(1,100)<66 then r=2
            
            p2.x=ship.x
            p2.y=ship.y
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
            flood_fill(ship.x,ship.y,m(),2)
        loop until m(awayteam.c.x,awayteam.c.y)=255 or c=255
        if c=255 then return 0
        
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if cint(distance(p2,p1))=r+1 then
                    if planetmap(p2.x,p2.y,slot)<0 then planetmap(p2.x,p2.y,slot)=-4
                    if planetmap(p2.x,p2.y,slot)>0 then planetmap(p2.x,p2.y,slot)=4
                    tmap(p2.x,p2.y)=tiles(4)
                endif
                if cint(distance(p2,p1))=r then
                    if planetmap(p2.x,p2.y,slot)<0 then planetmap(p2.x,p2.y,slot)=-8
                    if planetmap(p2.x,p2.y,slot)>0 then planetmap(p2.x,p2.y,slot)=8
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
        player.weapons(shipfire(sf).what).ammomax=1 'Sets color to redish
        player.weapons(shipfire(sf).what).dam=r 'Sets color to redish
        if rnd_range(1,100)<66+r then
            lastlocalitem=lastlocalitem+1
            lastitem=lastitem+1
            li(lastlocalitem)=lastitem
            item(lastitem)=makeitem(96,-3,b\3)
            item(lastitem).w.x=p1.x
            item(lastitem).w.y=p1.y
            item(lastitem).w.m=slot
            if rnd_range(1,100)<=2 then 
                planetmap(p1.x,p1.y,slot)=-191
                tmap(p1.x,p1.y)=tiles(191)
            endif
        endif
    else
        dprint "A meteor streaks across the sky"
    endif
    return 0 
end function
   

function ep_gives(awayteam as _monster, byref nextmap as _cords, shipfire() as _shipfire,enemy() as _monster,lastenemy as short,spawnmask() as _cords,lsp as short,key as string,byref walking as short, byref ship as _cords) as short
    dim as short a,b,c,d,e,r,sf,slot
    dim towed as _ship 
    dim as string text
    dim as _cords p,p1
    dim vismask() as byte
    awayteam.lastaction+=1
    slot=player.map
    if tmap(awayteam.c.x,awayteam.c.y).gives=1 then
        if specialplanet(1)=slot then specialflag(1)=1
        findartifact(awayteam,0)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=2 then 
        dprint "'Ah great. Imagining people again are we?' the occupant of this bunker looks like he had a pretty bad time. 'No wait. You are real? I am not imagining you?' He explains to you that he managed to survive for months, alone, after the sandworms had demolished his ship, and eaten his crewmates." 
        if askyn("He is quite a good gunner and wants to join your crew. do you let him? (y/n)") then 
            player.gunner=6
            crew(3).hp=7
            crew(3).hpmax=7
            crew(3).paymod=0
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
                    basis(8).inv(a).v=rnd_range(1,8-a)
                next
            endif
            if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 then
                changeprices(tmap(awayteam.c.x,awayteam.c.y).gives+1,(player.turn-player.lastvisit.t)\5)
            endif 
            if tmap(awayteam.c.x,awayteam.c.y).gives=7 and specialflag(20)=0 then
                for a=1 to 8
                    basis(8).inv(a).v=0
                next
            endif
            trading(tmap(awayteam.c.x,awayteam.c.y).gives+1)
            player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
        else
            dprint "they dont want to trade with you"
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
        buysitems("This house is stuffed floor to ceiling with antiquities. Paintings, statues, furniture, jewelery, some is of earth origin, some clearly not.","Do you think you have anything to sell him?",23)
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
            no_key=keyin
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=26 then              
        dprint "A Weapons and Equipment store"
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            do
                cls
                displayship
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
            dprint "they dont want to trade with you"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=27 then              
        dprint "A Bar"
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            if player.pilot*2>rnd_range(1,100) then
                player.pilot=captainskill
                dprint "Pilot "&crew(2).n &" doesnt want to come out again.",14
                crew(2)=crew(0)
            endif
            if player.gunner*2>rnd_range(1,100) then
                player.gunner=captainskill
                dprint "Gunner "&crew(3).n &" reckons he can make a fortune playing darts and decides to stay.",14
                crew(3)=crew(0)
            endif
            if player.science*2>rnd_range(1,100) then
                player.science=captainskill
                dprint "Science Officer "&crew(4).n &" has discovered an unknown drink. He decides to make a new carreer in barkeeping to study it.",14
                crew(4)=crew(0)
            endif
            if player.doctor*2>rnd_range(1,100) then
                player.doctor=captainskill
                dprint "Doctor "&crew(2).n &" comes to the conclusion that he is needed more here than on your ship." ,14
                crew(5)=crew(0)
            endif
            no_key=keyin
            hiring(0,rnd_range(0,5),maximum(4,awayteam.hp))
        else
            dprint "they dont want to serve you"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=28 then              
        dprint "Spaceship fuel for sale"
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            refuel()
        else
            dprint "they deny your request"
        endif
    endif
    
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=29 then              
        dprint "Ships Repair"
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            repairhull()
        else
            dprint "they dont want to repair a ship they shot up themselves"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=30 then              
        dprint "Shipyard"
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            no_key=keyin
            if slot=pirateplanet(0) then
                shipupgrades(4)
            else
                shipupgrades(5)
            endif
        else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"
        endif
    endif
    if tmap(awayteam.c.x,awayteam.c.y).gives=31 then              
        dprint "Shipyard"
        
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            no_key=keyin
            shipyard(2)
        else
            dprint "they dont want to upgrade a ship they are going to shoot up themselves"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=32 then  
        if player.towed<>0 then
            towed=gethullspecs(drifting(player.towed).s)
            a=towed.h_price
            if planets(drifting(player.towed).m).genozide<>1 then a=a/2
            a=cint(a)
            if askyn ("the pirate king offers you "&a &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") then
                drifting(player.towed)=drifting(lastdrifting)
                lastdrifting-=1
                player.money=player.money+a
                player.towed=0
            endif
        endif
        dprint "You sit down for some drinks and discuss your travels."
        planetbounty()
        if askyn("Do you want to challenge him to a duel?(y/n)") then
            dprint "He accepts. The Anne Bonny starts and awaits you in orbit."
            no_key=keyin
            lastfleet=lastfleet+1
            fleet(lastfleet)=makequestfleet(1)
            player=spacecombat(player,fleet(lastfleet),3)
            if player.dead=0 then 
                player.money=player.money+100.000
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=198
            else
                player.dead=26
            endif
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=33 then specialflag(27)=1              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=34 then player=buyweapon(1)              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=35 then shipyard(3) 'Special ship weapons shop              
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=36 then
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            dprint "The captain of this scoutship says: 'Got any bio or mapdata? I can sell that stuff at the space station and offer to split the money 50:50"
            if askyn("Do you want to sell data(y/n)") then
                dprint "you transfer new map data on "&reward(0)&" km2. you get paid "&cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))&" credits"
                player.money=player.money+cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))
                reward(0)=0
                reward(7)=0
                dprint "you transfer data on alien lifeforms worth "& cint(reward(1)*.5*(1+0.1*crew(1).talents(2))) &" credits."
                player.money=player.money+cint(reward(1)*.5*(1+0.1*crew(1).talents(2)))
                reward(1)=0
                for a=1 to lastitem
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
                player.money=player.money+player.questflag(20)*10
                player.questflag(20)=0
            endif    
            
            if findbest(87,-1)>0 then
                if askyn("The colonists would buy the burrowers eggsacks for 50 Credits a piece. Do you want to sell?(y/n)") then
                    for a=0 to lastitem
                        if item(a).ty=87 and item(a).w.s=-1 then 
                            destroyitem(a)
                            player.money=player.money+50
                        endif
                    next
                endif
            endif
        else
            if player.questflag(25)=1 then
                player.questflag(25)=2
                dprint "The colonists leader accepts the burrowers terms. They offer you 1000 Cr. for your help in negotiating a peace"
                player.money=player.money+1000
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
        if slot<>pirateplanet(0) or faction(0).war(1)<=0 then
            if askyn("This shop offers hullrefits, turning 5 crew bunks into an additional cargo hold for 1000 Cr. Do you want your ship modified?(y/n)") then
                if player.money>1000 then
                    pirateupgrade
                    player.money=player.money-1
                else
                    dprint "You dont have enough money."
                endif
            endif
        else
            dprint "they dont want to repair a ship they are going to shoot up themselves"
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=43 then
        player.disease=sickbay(1)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=44 then
        if planets(slot).mon_killed(1)=0 then
            if askyn("Do you want to fight in the arena? (y/n)") then
                planets(slot).depth=0
                enemy(1)=makemonster(2,slot)
                enemy(1)=setmonster(enemy(1),slot,spawnmask(),lsp,vismask(),awayteam.c.x+3,awayteam.c.y,1)
                enemy(1).slot=1
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
        else
            planets(slot).mon_killed(1)=0
            b=(enemy(1).hpmax+enemy(1).armor+enemy(1).weapon+rnd_range(1,2))*10
            player.money=player.money+b
            dprint "You get "& b &" Cr. for the fight.",10
            for x=awayteam.c.x+1 to awayteam.c.x+5
                for y=awayteam.c.y-2 to awayteam.c.y+2
                    planetmap(x,y,slot)=4
                    tmap(x,y)=tiles(planetmap(x,y,slot))
                next
            next
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=45 then casino()
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=46 then
        buysitems("They are very interested in buying living creatures for the zoo and arena fights."," Do you want to sell?(y/n)",26,5,0)
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=47 then retirement()
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=48 then buytitle()
    
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
            a=rnd_range(1,6)+rnd_range(1,6)+player.science
            if a>12 then
                dprint "You succeed!"
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=232
                planets(slot).atmos=5
            endif
            if a<6 then 
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=233
                dprint "You destroy the console in your attempt to repair it."
            endif
            if tmap(awayteam.c.x,awayteam.c.y).turnsinto=231 then dprint "You fail."
        endif
    endif
    
    if tmap(awayteam.c.x,awayteam.c.y).gives=57 then 'repairing reactor
        if askyn("Do you want to repair it?(y/n)") then
            a=rnd_range(1,6)+rnd_range(1,6)+player.science
            if a>12 then
                dprint "You succeed!"
                tmap(awayteam.c.x,awayteam.c.y).turnsinto=235
                specialflag(31)=1
                'hide map
                'put station 3 in positon
            endif
            if a<6 then 
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
            if rnd_range(1,6)+rnd_range(1,6)+player.science<10 then
                dprint "Something went wrong... this thing is about to blow up!"
                sf=sf+1
                if sf>15 then sf=0
                shipfire(sf).where=awayteam.c
                shipfire(sf).when=3
                shipfire(sf).what=10+sf
                player.weapons(shipfire(sf).what)=makeweapon(rnd_range(1,5))
                sf=sf+1 'Sets color to blueish
            endif
        endif
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
                            if askyn(text) then
                                for b=1 to player.h_maxcargo
                                    if player.cargo(b).x=a-9 then
                                        dprint "You sell a ton of "& basis(0).inv(a-10).n &" for "& c &" Cr."
                                        player.cargo(b).x=1
                                        player.money=player.money+c
                                        planets(slot).flags(a)=0
                                    endif
                                next
                                
                            endif
                        elseif planets(slot).flags(a)>0 then
                            c=int(baseprice(a-10)/(rnd_range(1,2)+abs(planets(slot).flags(a))))
                            if a=11 then text="The colonists have a surplus of food. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=12 then text="The colonists have a surplus of basic goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=13 then text="The colonists have a surplus of tech goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if askyn(text) then
                                d=getnextfreebay()
                                if d>0 then
                                    if player.money>=c then
                                        dprint "You buy a ton of "& basis(0).inv(a-10).n &" for "& c &" Cr."
                                        player.cargo(d).x=a-9
                                        player.cargo(d).y=c
                                        player.money=player.money-c
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
                dprint "This computer runs a database, containing all the 'workers' in this complex. They all were 'convicted' for violating Smith Heavy Industries company policies, and have to work off their fine here. There is an alarmingly high number of 'work related accidents' Money payed for food for the workers is on the other hand alarmingly low. No wonder SHI doesn't advertise about this place."
                player.questflag(22)=1
            endif

            if tmap(awayteam.c.x,awayteam.c.y).gives=63 then                
                x=player.c.x-basis(0).c.x/2
                y=player.c.y-basis(0).c.y/2
                x=basis(0).c.x+x
                y=basis(0).c.y+y
                if player.questflag(23)=0 then
                    lastdrifting=lastdrifting+1
                    
                    drifting(lastdrifting).s=14
                    drifting(lastdrifting).x=x
                    drifting(lastdrifting).y=y
                    drifting(lastdrifting).m=lastplanet+1
                    lastplanet=lastplanet+1
                    loadmap(13,lastplanet)
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
                dprint "At this terminal the routes of a big number of free lance traders are displayed. Triax Traders Ships are specially marked. Also the pirates are supposed to rendezvous with a ship at "&x &":"&y &" at regulare intervals."
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=64 then                
                player.questflag(23)=2
                dprint "Proof that Triax Traders is sponsoring Pirates."
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=65 then                
                player.questflag(24)=1
                dprint "Here are detailed experiments by Omega Bionegineering to breed crystal/human hybrids. They buy 'Volunteers' from a pirate captain. If this gets public it would break their neck."
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=66 then                
                dprint "An overweight gentleman greets you 'Welcome to Mudds Incredible Bargains' Do you wish to buy or sell?(b/s)"
                key=keyin("bs")
                if key="s" then
                    buysitems("","",999,.1)
                endif
                if key="b" then
                    shop(7,1.5,"Mudds Incredible Bargains")
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
                            if planets(slot).flags(3)<=player.h_maxengine then
                                player.engine=planets(slot).flags(3)
                                planets(slot).flags(3)=0
                                b=1
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
                            if planets(slot).flags(4)<=player.h_maxsensors then
                                player.sensors=planets(slot).flags(4)
                                planets(slot).flags(4)=0
                                b=1
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
                        if planets(slot).flags(5)<player.shield then
                            dprint "You already have a better shields than this."
                        else
                            if planets(slot).flags(5)<=player.h_maxshield then
                                player.shield=planets(slot).flags(5)
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
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203
                dprint c & " " & planets(slot).flags(c)
                if planets(slot).flags(c)=0 then
                    dprint "An empty weapons turret."
                else
                    if askyn("A "&makeweapon(planets(slot).flags(c)).desig &". Do you want to transfer it to your ship?(y/n)") then
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
                        e=menu(text)
                        if e<d then
                            player.weapons(e)=makeweapon(planets(slot).flags(c))
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
            
            for a=0 to lastdrifting
                if slot=drifting(a).m then c=drifting(a).s
            next
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=220 then
                locate 3,awayteam.c.x+1
                color 15,0
                print shiptypes(planets(slot).flags(1))
                textbox(makehullbox(planets(slot).flags(1)),awayteam.c.x+1,5,78-awayteam.c.x)
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
                            if planets(slot).flags(5)>player.shield then player.shield=planets(slot).flags(5) 
                            recalcshipsbays
                            if ship.m<>slot then
                                for c=0 to lastportal
                                    if portal(c).from.m=slot or portal(c).dest.m=slot then
                                        ship=portal(c).from
                                        player.landed=ship
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
                    changeprices(11,(player.turn-player.lastvisit.t)\5)
                endif 
                trading(11)
                player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                factionadd(0,6,-5)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=302 then
                if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 then
                    changeprices(12,(player.turn-player.lastvisit.t)\5)
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
                dprint "A "&civ(0).n &" shop"
                if faction(0).war(6)<50 then
                    shop(22,1,civ(0).n &" shop")
                else
                    dprint "They don't want to trade with you"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=322 then
                dprint "A "&civ(1).n &" shop"
                if faction(0).war(7)<50 then
                    shop(23,1,civ(1).n &" shop")
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
                else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=tmap(awayteam.c.x,awayteam.c.y).no
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=887 then
                dprint "With the forcefield down it is easy to remove the disintegrator canon"
                artifact(4,awayteam)
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
            b=rnd_range(1,6)+rnd_range(1,6)-3
            no_key=keyin
            if b>0 then
                if askyn( b &" security personel want to join your crew. (y/n)") then 
                    if b>maxsecurity then b=maxsecurity
                    for a=1 to b
                        addmember(8)
                    next
                endif
            endif
            b=rnd_range(5,7)
            if b>6 then b=6
            c=rnd_range(1,100)
            if c<33 then 
                if askyn("a pilot, skillevel " & b & " wants to join you. (y/n)") then 
                    player.pilot=b
                    addmember(2)
                endif
            endif
            if c>32 and c<66 then 
                if askyn("a gunner, skillevel " & b & " wants to join you. (y/n)") then 
                    player.gunner=b
                    addmember(3)
                endif
            endif
            if c>65 then 
                if askyn("a science officer, skillevel " & b & " wants to join you. (y/n)") then 
                    player.science=b
                    addmember(4)
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
            if rnd_range(1,6)+rnd_range(1,6)+player.science>9 then
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
