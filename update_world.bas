function update_world(location as short) as short
    if location=1 and player.turn mod 10<>0 then player.turn=cint(player.turn/10)*10 'Needs to be multiple of 10 for events to trigger
    
    dim as short a,b
    diseaserun(1)
    clearfleetlist
    
    
    if player.turn mod 60=0 then
        if artflag(23)>0 and player.hull<player.h_maxhull then player.hull+=1
        move_fleets()
        collide_fleets()
        move_probes()
        cure_awayteam(location)
        
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
        
    endif
    
    if player.turn mod (24*60)=0 or location=2 then 'Daily,loc2=forced
        for a=0 to 12
            change_prices(a,10)
        next
        
        for a=0 to 2
            if fleet(a).mem(1).hull<128 and fleet(a).mem(1).hull>0 then fleet(a).mem(1).hull+=3
        next
        if location=1 then trouble_with_tribbles
        clean_station_event
        questroll=rnd_range(1,100)-10*(crew(1).talents(3))
    endif
    
    if player.turn mod (24*60*7)=0 then 'Weekly
        set_fleet(make_fleet)
        if rnd_range(1,100)<50 then
            if rnd_range(1,100)>80+countfleet(6) then set_fleet(makecivfleet(0))
        else
            if rnd_range(1,100)>80+countfleet(7) then set_fleet(makecivfleet(1))
        endif
        if player.turn>6*30*24*60 and player.questflag(3)=0 then
            if rnd_range(1,100)>80+countfleet(5) then set_fleet(makealienfleet)
        endif
        reroll_shops
        
        for a=0 to 2
            colonize_planet(a)
        next
        grow_colonies
        
        if player.turn>2*30*24*60 and rnd_range(1,100)<1+cint(player.turn/10000) then robot_invasion
            
        for a=1 to lastquestguy
            if rnd_range(1,100)<25 and questguy(a).job=9 then questguy_newloc(a)
            if rnd_range(1,100)<25 and questguy(a).job<>1 then questguy_newloc(a)
            if questguy(a).want.type=qt_travel and rnd_range(1,100)<33 then
                questguy(a).location=questguy(a).flag(12)
                questguy(a).want.given=1
            endif
            if questguy(a).want.given=1 then questguy(a).want.type=0
            if questguy(a).has.given=1 then questguy(a).has.type=0
            if (questguy(a).has.type=0 or questguy(a).want.type=0) and rnd_range(1,100)<10 then
                questguy_newquest(a)
            endif
        next
        for b=1 to lastshop
            if rnd_range(1,100)<33 then
                if shoplist(b).shoporder>0 then
                    a=rnd_range(1,20)
                    shopitem(a,b)=make_item(shoplist(b).shoporder)
                    shopitem(a,b).price=shopitem(a,b).price*2
                    shopitem(a,b).w.x=rnd_range(1,6)
                    shoplist(b).shoporder=-shoplist(b).shoporder
                endif
            endif
            if b<3 then
                a=basis(b).company
                companystats(a).profit=companystats(a).profit+(rnd_range(1,6)+rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6))
                if companystats(a).profit>0 then 
                    companystats(a).profit=(companystats(a).profit+rnd_range(0,1))*(companystats(a).capital/50)
                else
                    companystats(a).profit=companystats(a).profit*(companystats(a).capital/50)
                endif
                companystats(a).capital=companystats(a).capital+companystats(a).profit
                companystats(a).rate=companystats(a).capital/companystats(a).shares
                if companystats(a).profit>0 then companystats(a).rate+=1'rnd_range(1,6)
                if companystats(a).profit<=0 then companystats(a).rate-=1'rnd_range(1,6)
                companystats(a).profit=0
                if companystats(a).capital>50000 then companystats(a).capital=50000
            endif
        next
        
    endif
    
    return 0
end function
