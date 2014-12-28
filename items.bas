function make_locallist(slot as short) as short
    dim as short i,x,y,r
    dim p as _cords
    itemindex.del
    lastteleportdevice=0
    for i=1 to lastitem
        if item(i).w.m=slot and item(i).w.s=0 and item(i).w.p=0 then
            if itemindex.add(i,item(i).w)=-1 then
                item(i).w=movepoint(item(i).w,5)
                i-=1
            endif
        endif
        if item(i).ty=88 and item(i).w.s=-1 then 'We need a quick way to go through teleport devices
            lastteleportdevice+=1
            if lastteleportdevice<1024 then
                teleportdevices(lastteleportdevice)=i
            endif
        endif
    next
    
    portalindex.del
    for i=1 to lastportal
        if _debug>0 and (portal(i).from.m=slot or portal(i).dest.m=slot) then dprint "dest from slot"&portal(i).dest.m &":"&portal(i).from.m &":"&slot
        if portal(i).dest.m=slot and portal(i).oneway=0 then portalindex.add(i,portal(i).dest)
        if portal(i).from.m=slot then
            if _debug>0 then dprint "Adding portal"
            if portal(i).oneway<2 then 
                portalindex.add(i,portal(i).from)
            else
                for x=0 to 60
                    for y=0 to 20
                        p.x=x
                        p.y=y
                        if x=0 or y=0 or x=60 or y=20 then portalindex.add(i,p)
                    next
                next
            endif
        endif
    next
    if _debug>0 then
        for i=1 to portalindex.vlast
            dprint cords(portal(portalindex.value(i)).from)
            dprint cords(portal(portalindex.value(i)).dest)
        next
    endif
    return 0
end function

function rnd_item(t as short) as _items
    dim i as _items
    dim as short r,debug
    dim items(25) as short
    if t=RI_Lamps then 
        if rnd_range(1,100)<66 then
            i=make_item(28)
        else
            i=make_item(29)
        endif
        return i
    endif
    
    if t=RI_SPACEBOTS then
        select case rnd_range(1,100)
        case 1 to 33
            i=rnd_item(RI_Drones)
        case 34 to 66
            i=rnd_item(RI_probes)
        case else
            i=rnd_item(RI_Gasprobes)
        end select
        return i
    end if
    
    if t=RI_Cage then
        select case rnd_range(1,100)
        case 1 to 50
            i=make_item(62)
        case 51 to 80
            i=make_item(63)
        case else
            i=make_item(64)
        end select
        return i
    endif
    
    if t=RI_Tanks then 
        if rnd_range(1,100)<50 then
            i=make_item(21)'Air filter
        else
            if rnd_range(1,100)<66 then
                i=make_item(38)'Aux tank Air
            else
                i=make_item(49)'Aux tank JJ
            endif
        endif
        return i
    endif
    
    if t=RI_Artefact then
        select case rnd_range(1,100)
        case 1 to 20
            i=make_item(97)
        case 21 to 40
            i=make_item(98)
        case 41 to 50
            i=make_item(95)
        case 51 to 55
            i=make_item(301)
        case 55 to 60
            i=make_item(302)
        case 60 to 89
            i=make_item(123)
        case else
            i=make_item(rnd_range(95,98))
        end select
        return i
    endif
        
    if t=RI_ALLDRONESPROBES then
        select case rnd_range(1,100)
        case 1 to 40
            i=rnd_item(RI_Drones)
        case 41 to 80
            i=rnd_item(RI_Probes)
        case else
            i=rnd_item(RI_Gasprobes)
        end select
        return i
    endif
    
    if t=RI_StandardShop then 
        r=rnd_range(1,100)
        if _debug>0 then dprint "R"&r
        select case r
        case 1 to 50
            i=rnd_item(RI_WeaponsArmor)
        case 51 to 60
            i=rnd_item(RI_ALLDRONESPROBES)
        case 61 to 70
            i=rnd_item(RI_Medpacks)
        case 71 to 80
            i=rnd_item(RI_Mining)
        case 81 to 90
            i=rnd_item(RI_ROBOTS)
        case else
            i=make_item(30)
        end select
        return i
    endif
    
    if t=RI_Strandedship then 
        select case Rnd_range(1,100)
        case 1 to 40
            i=rnd_item(RI_WeaponsArmor)
        case 41 to 50
            i=rnd_item(RI_Transport)
        case 51 to 60
            i=rnd_item(RI_Lamps)
        case 61 to 70
            i=rnd_item(RI_Tanks)
        case 71 to 80
            i=rnd_item(RI_Mining)
        case else
            i=rnd_item(RI_Shipequipment)
        end select
        
        return i
    endif
    
    
    if t=RI_Transport then return make_item(rnd_range(1,2)) 'transport
    if t=RI_RangedWeapon then return make_item(urn(0,8,2,player.turn/5000)+3) 'ranged weapons
    if t=RI_CCWeapon then return make_item(urn(0,7,2,player.turn/5000)+40) 'close weapons
    if t=RI_Armor then 'Space suits 
        if rnd_range(1,100)<30-player.turn/5000 then
            i=make_item(320)
        else
            i=make_item(urn(0,8,2,player.turn/5000)+12) 'Armor
        endif
        return i
    endif
    if t=RI_ShopAliens then 
        if rnd_range(1,100)<10 then 
            if rnd_range(1,100)<50 then
                i=make_item(rnd_range(78,80))
            else
                i=make_item(rnd_range(82,84))
            endif
        else
            i=make_item(rnd_range(21,39)) 'misc
        endif
        return i
    endif
    
    if t=RI_Mining then 'misc2 mining
        if rnd_range(1,100)<50 then
            if rnd_range(1,100)<70 then
                i=make_item(22) 'Drill
            else
                i=make_item(23) 'Laser drill
            endif
        else
            i=make_item(152) 'Mining Explosives
        endif
        if rnd_range(1,100)<15 then i=make_item(rnd_range(41,43))
        return i
    endif
    
    if t=RI_KOdrops then i=make_item(rnd_range(36,37)) 'Anaesthetics
    
    if t=RI_Medpacks then 
        if rnd_range(1,100)<50 then
            i=make_item(rnd_range(56,58)) 'meds2
        else
            i=make_item(rnd_range(31,33))
        endif
        return i
    endif
    
    if t=RI_Stims then return make_item(rnd_range(251,253))
    
    if t=RI_WEAPONS then 'weapons
        select case rnd_range(1,100)
        case 1 to 45
            i=make_item(rnd_range(3,11)) 'Ranged weapons
        case 55 to 85
            i=make_item(rnd_range(40,47)) 'CC Weapons
        case else
            i=make_item(rnd_range(181,184))'Nonlethal
        end select
        return i
    endif
    
    if t=RI_Rovers then return make_item(rnd_range(50,52))'fs
    
    if t=RI_Allbutweapons then 'all but weapons
        select case rnd_range(1,100)
            case 1 to 20
                i=make_item(rnd_range(1,2))
            case 21 to 40
                i=make_item(rnd_range(15,33))
            case 41 to 60
                i=make_item(rnd_range(50,58))
            case 61 to 80
                i=make_item(rnd_range(21,30))
            case 80 to 100
                i=make_item(rnd_range(70,71))
            case else
                i=make_item(77)
        end select 
        return i
    endif
    
    if t=RI_Infirmary then
        i=make_item(rnd_range(67,69))
        return i
    endif
    
    if t=RI_ROBOTS then
        if rnd_range(1,100)<50 then
            i=make_item(RI_Rovers)
        else
            i=make_item(RI_Miningbots)
        endif
        return i
    endif
    
    if t=RI_LandingGear then return make_item(rnd_range(75,76))
    
    if t=RI_Probes then return make_item(rnd_range(101,102))
    
    if t=RI_Drones then return make_item(rnd_range(110,112))
    
    if t=RI_GasProbes then return make_item(rnd_range(104,105))
    
    if t=RI_Mining then
        select case rnd_range(1,100)
        case 1 to 55
            i=make_item(152)
        case 56 to 85
            i=make_item(22)
        case 86 to 88
            i=make_item(87)
        case else
            i=make_item(23)
        end select
        return i
    endif
    
    if t=RI_Miningbots then
        select case rnd_range(1,100)
        case 1 to 50
            i=make_item(53)
        case 50 to 80
            i=make_item(54)
        case else
            i=make_item(55)
        end select
        return i
    endif
        
    if t=RI_ShopSpace or t=RI_Shipequipment then
        r=rnd_range(1,11)
        if r=1 then i=make_item(30)'Comsat
        if r=2 then i=rnd_item(RI_Robots)
        if r=3 then i=rnd_item(RI_Infirmary)
        if r=4 then i=make_item(rnd_range(70,71))'Emergency Beacon
        if r=4 then i=rnd_item(RI_LandingGear)
        if r=5 then i=rnd_item(RI_Probes)
        if r=6 then i=rnd_item(RI_GasProbes)
        if r=7 then i=rnd_item(RI_Drones)
        if r=8 then i=rnd_item(RI_Medpacks)
        if r=9 then i=rnd_item(RI_Mining)
        if r=10 then i=rnd_item(RI_Lamps)
        if r=11 then i=rnd_item(RI_tanks)
        return i
    endif
        
    
    if t=RI_AllButWeaponsAndMeds then 'All but weapons and meds
        r=rnd_range(1,32)
        if r=1 then i=make_item(1)
        if r=2 then i=make_item(2)
        if r=3 then i=make_item(21)
        if r=4 then i=make_item(22)
        if r=5 then i=make_item(23)
        if r=6 then i=make_item(24)
        if r=7 then i=make_item(25)
        if r=8 then i=make_item(26)
        if r=9 then i=make_item(27)
        if r=10 then i=make_item(28)
        if r=11 then i=make_item(29)
        if r=12 then i=make_item(30)
        if r=13 then i=make_item(38)
        if r=14 then i=make_item(39)
        if r=15 then i=make_item(48)
        if r=16 then i=make_item(49)
        if r=17 then i=make_item(50)
        if r=18 then i=make_item(51)
        if r=19 then i=make_item(52)
        if r=20 then i=make_item(53)
        if r=21 then i=make_item(54)
        if r=22 then i=make_item(55)
        if r=23 then i=make_item(59)
        if r=24 then i=make_item(60)
        if r=25 then i=make_item(70)
        if r=26 then i=make_item(71)
        if r=27 then i=make_item(72)
        if r=28 then i=make_item(73)
        if r=29 then i=make_item(77)
        if r=30 then i=make_item(100)
        if r=31 then i=make_item(101)
        if r=32 then i=make_item(102)
        return i
    endif
    
    if t=RI_ShopExplorationGear then 'specialty shop exploration gear
        r=rnd_range(1,42)
        if r=1 then i=make_item(49)
        if r=2 then i=make_item(50)
        if r=3 then i=make_item(51)
        if r=4 then i=make_item(52)
        if r=5 then i=make_item(53)
        if r=6 then i=make_item(54)
        if r=7 then i=make_item(55)
        if r=8 then i=make_item(75)
        if r=9 then i=make_item(76)
        if r=10 then i=make_item(77)
        if r=11 then i=make_item(78)
        if r=12 then i=make_item(79)
        if r=13 then i=make_item(80)
        if r=14 then i=make_item(83)
        if r=15 then i=make_item(84)
        if r=16 then i=make_item(85)
        if r=17 then i=make_item(82)
        if r=18 then i=make_item(100)
        if r=19 then i=make_item(101)
        if r=20 then i=make_item(102)
        if r=21 then i=make_item(22)
        if r=22 then i=make_item(23)
        if r=23 then i=make_item(62)
        if r=24 then i=make_item(63)
        if r=25 then i=make_item(162)
        if r=26 then i=make_item(163)
        if r=27 then i=make_item(38)
        if r=28 then i=make_item(30)'Comsat
        if r>=29 and r<=37 then i=make_item(1)
        if r>=38 and r<=40 then i=make_item(2)
        if r>=41 and r<=42 then i=rnd_item(RI_nonlethal)
        return i
    endif
    
    if t=RI_Kits then
        select case rnd_range(1,100)
        case 1 to 30
            i=make_item(82)'Autopsy Kit
        case 31 to 60
            i=make_item(83)'Botany Kit
        case 60 to 90
            i=make_item(84)'Ship Repair
        case else
            i=make_item(85)
        end select
        return i
    endif
    
    if t=RI_ShopWeapons then 'Weapons
        select case rnd_range(1,100)
            case is<33 
                i=rnd_item(RI_weapons) 'Guns and Armor
            case is>90 
                if rnd_range(1,100)<50 then
                    if rnd_range(1,100)<66 then
                        i=make_item(rnd_range(106,107))' Small Grenades
                    else
                        i=make_item(rnd_range(24,25))'grenades
                    endif
                else
                    i=make_item(rnd_range(59,61))'Mines
                endif
            case else
                if rnd_range(1,100)<90 then
                    i=make_item(rnd_range(40,47))'CC weapons
                else
                    i=make_item(48)'Grenade launcher
                endif
        end select
        return i
    endif
    
    if t=RI_WeaponsArmor then 'Weapons or armor
        select case rnd_range(1,100)
        case is<33
            i=make_item(rnd_range(3,11))
        case is>66
            i=make_item(rnd_range(40,47))
        case else
            i=make_item(rnd_range(12,20))
        end select
        return i        
    endif
    
    if t=RI_WeakStuff then 'Starting equipment Weak stuff
        select case rnd_range(1,78)
        case 1 to 5 
            i=make_item(21,,,,1)'1 Airfilters
        case 5 to 9 
            i=make_item(24,,,,1)'2 Grenade
        case 10 to 20 
            i=make_item(26,,,,1)'3 Binocs
        case 21 to 30 
            i=make_item(28,,,,1)'4 Lamp
        case 31 to 38 
            i=make_item(31,,,,1)'5 Medpack
        case 39 to 42 
            i=make_item(34,,,,1)'6 Lockpicks
        case 43 to 47 
            i=make_item(36,,,,1)'7 Anaesthtics
        case 48 to 53 
            i=make_item(38,,,,1)'8 Ox tank
        case 54 to 55 
            i=make_item(56,,,,1)'9 Disease Kit
        case 56 to 58 
            i=make_item(70,,,,1)'10 em beacon
        case 59 to 65 
            i=make_item(78,,,,1)'11 Flash grenade
        case 65 to 69
            select case rnd_range(1,3)
            case is=1
                i=make_item(82,,,,1)'12 Autopsy kit
            case is=2
                i=make_item(83,,,,1)'13 Botany Kit
            case is=3
                i=make_item(84,,,,1)'14 SR Kit
            end select
        case 70 to 72
            i=make_item(31,,,,1)'5 Medpack
        case 72 to 74
            i=make_item(106,,,,1)'15 Grenade
        case 75 to 78
            i=make_item(152,,,,1)'Mining explosives
        end select
        return i
        
    endif
    
    
    if t=RI_WeakWeapons then 'weak weapons and armor
        select case rnd_range(1,100)
        case 1 to 30
            i=make_item(urn(0,4,1,0)+3,,,,1)
        case 31 to 50
            i=make_item(urn(0,4,1,0)+40,,,,1)
        case 51 to 80
            i=make_item(urn(0,2,1,0)+12,,,,1)
        case else
            i=make_item(320)
        end select
        return i
    end if
    
    if t=RI_Nonlethal then return make_item(rnd_range(181,184))'Nonlethal
    
    return i
end function



function sort_items(list() as _items) as short
    dim as short l,i,flag
    l=ubound(list)
    do
    flag=0
    for i=1 to l-1
        if list(i).ty>0 and list(i).ty=list(i+1).ty then
            if list(i).v1>list(i+1).v1 then 
                swap list(i),list(i+1) 
                flag=1
            endif
        endif
    next
    loop until flag=0
    return 0
end function

function roman(i as integer) as string
    select case i
    case 1
        return "I"
    case 2
        return "II"
    case 3
        return "III"
    case 4
        return "IV"
    case 5
        return "V"
    case 6
        return "VI"
    end select
end function

function corrode_item() as short
    dim a as short
    a=getrnditem(-2,0)
        If a>0 Then
        If rnd_range(1,100)>item(a).res Then
            item(a).res=item(a).res-25
            If item(a).res>=0 Then
                dprint "Your "&item(a).desig &" starts to corrode.",14
                if (item(a).ty=3 or item(a).ty=103) and item(a).ti_no<2019 then 
                    item(a).v4+=1
                    awayteam.leak+=1
                    dprint "Your "&item(a).desig &" starts to leak.",c_yel
                endif
            Else
                dprint "Your "&item(a).desig &" corrodes and is no longer usable.",c_red
                destroyitem(a)
                equip_awayteam(awayteam.slot)
                make_vismask(awayteam.c,0,awayteam.slot,,awayteam.groundpen)
                'displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            EndIf
        EndIf
    EndIf
    return 0
end function
    

function destroyitem(b as short) as short     
    if b>=0 and b<=lastitem then
        item(b)=item(lastitem)
        lastitem=lastitem-1
        return 0
    else
        if b>lastitem then
            lastitem=lastitem+1
            item(b)=item(lastitem)
            lastitem=lastitem-1
            'dprint "ERROR: attempted to destroy nonexistent item "& b,14
        endif
        return -1
    endif
end function
    
function destroy_all_items_at(ty as short, wh as short) as short
    dim as short i,d,c
'    do
'        if item(i).ty=ty and item(i).w.s=wh then
'            item(i)=item(lastitem)
'            lastitem-=1
'            d+=1
'        else
'            i+=1
'        endif
'        c+=1
'    loop until i>lastitem or c>lastitem
    do
    d=0
    for i=0 to lastitem
        if item(i).ty=ty and item(i).w.s=wh then 
            item(i)=item(lastitem)
            lastitem-=1
            d+=1
        endif
    next
    loop until d=0
    return d
end function

function calc_resrev() as short
    dim as short i
    static v as integer
    static called as byte
    if called=0 or called mod 10=0 then
        v=0
        for i=0 to lastitem
            if item(i).ty=15 and item(i).w.s<0 then v=v+item(i).v5
        next
    endif
    if called=10 then called=0
    called+=1
    if v>reward(0) then 
        reward(0)=v
    endif
    return 0
end function

function placeitem(i as _items,x as short=0,y as short=0, m as short=0, p as short=0, s as short=0) as short
    if m>0 and s<0 then dprint "m:"&m &"s:"&s &"lp:"&lastplanet
    i.w.x=x
    i.w.y=y
    i.w.m=m
    i.w.p=p
    i.w.s=s
    i.discovered=show_allitems
    dim a as short
    if lastitem<25000 then 'Noch platz f�r neues
        lastitem=lastitem+1
        item(lastitem)=i
        item(lastitem).uid=lastitem
        return lastitem
    else
        for a=0 to lastitem '�berschreibe erstes item das nicht im schiff und keine mm
            item(a).uid=a
            if item(a).w.s>=0 and item(a).ty<>15 then
                item(a)=i
                return a
            endif
        next
    endif
    dprint "ITEM PLACEMENT ERROR!(lastitem="&lastitem &")",14
end function

function item_filter() as short
    dim a as short
    a=menu(bg_parent,"Item type:/Transport/Ranged weapons/Armor/Close combat weapons/Medical supplies/Grenades/Artwork/Resources/Equipment/Ship equipment/All Other/None/Exit","",20,2)
    if a>11 then a=0
    if a<0 then a=0
    return a
end function

function make_item(a as short, mod1 as short=0,mod2 as short=0,prefmin as short=0,nomod as byte=0) as _items
    dim i as _items
    dim as short f,roll,target,rate
    if uid=4294967295 then 
        dprint "Can't make any more items!"
        return i
    endif
    rate=5000-disnbase(player.c)*10
    if rate<1000 then rate=1000'Divisor of turn to determine improved items
    uid=uid+1
    i.uid=uid
    i.scanmod=1
    
    if a=1 then
        i.ti_no=2001
        i.id=1
        i.ty=1
        i.desig="hover platform"
        i.desigp="hover platforms"
        i.icon="_"
        i.col=11
        i.bgcol=0
        i.v1=1
        i.v2=5
        i.price=i.v2*100
        i.res=60
        i.ldesc="A platform held aloft by aircushions. It can transport up to "&i.v2 &" persons and cross water. Going up mountains is impossible though"
    endif
    
    if a=2 then
        i.ti_no=2002
        i.id=2
        i.ty=1
        i.desig="jetpack"
        i.desigp="jetpacks"
        i.ldesc="A simple rocketengine straped to a persons back. Almost but not quite flying, a jump up a mountain is as easy as crossing a large body of water with it."
        i.icon="j"
        i.col=14
        i.bgcol=0
        i.v1=2
        i.v2=1
        i.v3=1
        i.price=600
        i.res=80
    endif
    
    if a=3 then
        i.ti_no=2003
        i.id=3
        i.ty=2
        i.desig="gun"
        i.desigp="guns"
        i.ldesc="A small handheld weapon. An explosion propels a projectile."
        i.icon="-"
        i.col=8
        i.bgcol=0
        i.v1=.4
        i.v2=2
        i.v3=1
        i.price=25
        i.res=15
    endif
    
    if a=4 then
        i.ti_no=2004
        i.id=4
        i.ty=2
        i.desig="rifle"
        i.desigp="rifles"
        i.ldesc="a handheld weapon with a 60cm long barrel. An explosion propels a projectile."
        i.icon="/"
        i.col=8
        i.bgcol=0
        i.v1=.6
        i.v2=2
        i.v3=0
        i.price=75
        i.res=20
    endif
    
    if a=5 then
        i.ti_no=2005
        i.id=5
        i.ty=2
        i.desig="gyro jet gun"
        i.desigp="gyro jet guns"
        i.ldesc="A small handheld weapon. Recoilless because the projectiles carry their own rocket"
        i.icon="-"
        i.col=7
        i.bgcol=0
        i.v1=.8
        i.v2=3
        i.v3=1
        i.price=150
        i.res=25
    endif
    
    if a=6 then
        i.ti_no=2006
        i.id=6
        i.ty=2
        i.desig="gyro jet rifle"
        i.desigp="gyro jet rifles"
        i.ldesc="A handheld weapon with several short barrels. Recoilless because the projectiles carry their own rocket."
        i.icon="/"
        i.col=7
        i.bgcol=0
        i.v1=1
        i.v2=3
        i.v3=0
        i.price=250
        i.res=25
    endif
    
    if a=7 then
        i.ti_no=2007
        i.id=7
        i.ty=2
        i.desig="gauss gun"
        i.desigp="gauss guns"
        i.ldesc="A small handheld weapon. It fires needlelike projectiles using magnetic fields to accelerate them. It makes up for what it lacks in punch in  accuracy."
        i.icon="-"
        i.col=7
        i.bgcol=0
        i.v1=1.2
        i.v2=4
        i.v3=1
        i.price=375
        i.res=25
    endif
    
    if a=8 then
        i.ti_no=2008
        i.id=8
        i.ty=2
        i.desig="gauss rifle"
        i.desigp="gauss rifles"
        i.ldesc="A handheld weapon with several short barrels. It fires a volley of needlelike projectiles using magnetic fields to accelerate them. It makes up for what it lacks in punch in accuracy."
        i.icon="/"
        i.col=7
        i.bgcol=0
        i.v1=1.4
        i.v2=4
        i.v3=0
        i.price=525
        i.res=25
    endif
    
    if a=9 then
        i.ti_no=2009
        i.id=9
        i.ty=2
        i.desig="laser gun"
        i.desigp="laser guns"
        i.ldesc="A energy source that can be attached to a girdle is connected to a small pistolgrip. The laserbeam emmitted by it causes a lot of damage."
        i.icon="-"
        i.col=15
        i.bgcol=0
        i.v1=1.6
        i.v2=5
        i.v3=1
        i.price=700
        i.res=30
    endif
    
    if a=10 then
        i.ti_no=2010
        i.id=10
        i.ty=2
        i.desig="laser rifle"
        i.desigp="laser rifles"
        i.ldesc="A backpack houses the energy source, connected to a pistolgrip with 3 short barrels. The laserbeams cause a lot of damage."
        i.icon="/"
        i.col=15
        i.bgcol=0
        i.v1=1.8
        i.v2=5
        i.v3=0
        i.price=900
        i.res=30
    endif
    
    if a=11 then 
        i.ti_no=2011
        i.id=11
        i.ty=2
        i.desig="plasma rifle"
        i.desigp="plasma rifles"
        i.ldesc="A backpack houses the energy source, connected to a rifle. It emits a beam of superheated plasma."
        i.icon="/"
        i.col=12
        i.bgcol=0
        i.v1=2
        i.v2=6
        i.v3=0
        i.price=1125
        i.res=35
    endif
    
    
    if a=320 then
        i.ti_no=2012
        i.id=12
        i.ty=3
        i.desig="spacesuit"
        i.desigp="spacesuits"
        i.ldesc="Your standard spacesuit."
        i.icon="&"
        i.col=15
        i.bgcol=0
        i.v1=1
        i.v3=300
        i.price=20
        i.res=10
    endif
    
    if a=12 then
        i.ti_no=2012
        i.id=13
        i.ty=3
        i.desig="ballistic suit"
        i.desigp="ballistic suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with ballistic cloth around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=3
        i.v3=250
        i.price=75
        i.res=25
    endif
    
    if a=13 then
        i.ti_no=2013
        i.id=14
        i.ty=3
        i.desig="full ballistic suit"
        i.desigp="full ballistic suits"
        i.ldesc="Your standard spacesuit, but completely covered in ballistic cloth."
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=4
        i.v3=200
        i.price=175
        i.res=25
    endif
    
    if a=14 then
        i.ti_no=2014
        i.id=15
        i.ty=3
        i.desig="protective suit"
        i.desigp="protective suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with hardened shells around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=5
        i.v3=150
        i.price=300
        i.res=25
    endif
    
    if a=15 then
        i.ti_no=2015
        i.id=16
        i.ty=3
        i.desig="full protective suit"
        i.desigp="full protective suits"
        i.ldesc="Your standard spacesuit, covered with hardened shells." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=6
        i.v3=150
        i.price=450
        i.res=25
    endif
    
    if a=16 then
        i.ti_no=2016
        i.id=17
        i.ty=3
        i.desig="fullerene suit"
        i.desigp="fullerene suits"
        i.ldesc="Your standard spacesuit made out of carbon fullerenes." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=7
        i.v3=150
        i.price=625
        i.res=25
    endif
    
    if a=17 then
        i.ti_no=2017
        i.id=18
        i.ty=3
        i.desig="combat armor"
        i.desigp="sets of combat armor"
        i.ldesc="A spacesuit covered in ablative plates." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=8
        i.v3=100
        i.price=825
        i.res=45
    endif
    
    if a=18 then
        i.ti_no=2018
        i.id=19
        i.ty=3
        i.desig="heavy combat armor"
        i.desigp="sets of heavy combat armor"
        i.ldesc="A spacesuit covered in ablative plates. Built in hydraulics increase the strength and speed of the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=9
        i.v3=100
        i.price=1050
        i.res=45
    endif
    
    if a=19 then   
        i.ti_no=2019              
        i.id=20
        i.ty=3
        i.desig="p. Forcefield"
        i.desigp="p. forcefields"
        i.ldesc="A small forcefield surrounds the wearer." 
        i.icon="&"
        i.col=2
        i.bgcol=0
        i.v1=11
        i.v3=200
        i.price=1300
        i.res=65
    endif    
         
    if a=20 then
        i.ti_no=2020
        i.id=21
        i.ty=3
        i.desig="layered p. forcefield"
        i.desigp="layered p. forcefields"
        i.ldesc="The ultimate in protective equipment. Several layered forcefields surround the wearer." 
        i.icon="&"
        i.col=6
        i.v3=200
        i.bgcol=0
        i.v1=13
        i.price=1575
        i.res=65
    endif
    
    
    if a=21 then
        i.ti_no=2021
        i.id=22
        i.ty=17
        i.desig="improved air filter"
        i.desigp="improved air filters"
        i.ldesc="Normal spacesuits have their own oxygen tank. Improved air filters attempt to supplement that with whatever is found in the surrounding atmosphere."
        i.icon="�"
        i.col=14
        i.v1=.3
        i.bgcol=0
        i.price=20
        i.res=25
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+1000
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=.4
                i.price=30
            else
                i.id=i.id+1010
                i.desig="bad "&i.desig
                i.desigp="bad "&i.desigp
                i.v1=.2
                i.price=15
            endif
        endif
    endif   
    
    if a=22 then
        i.ti_no=2022
        i.id=23
        i.ty=5
        i.desig="mining drill"
        i.desigp="mining drills"
        i.ldesc="Highspeed drills for digging tunnels" 
        i.v1=2
        i.icon="["
        i.col=7
        i.bgcol=0
        i.price=1500
        i.res=35
        if rnd_range(1,100)<20+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=122
                i.desig="powerful "&i.desig
                i.desigp="powerful "&i.desigp
                i.v1=3
                i.price=2000
            else
                i.id=124
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=1
                i.price=1000
            endif
        endif
    endif
    
    if a=23 then
        i.ti_no=2023
        i.id=24
        i.ty=5
        i.desig="laser drill"
        i.desigp="laser drills"
        i.ldesc="like normal laserweapons, but they trade damage dealt for a bigger area affected. The result: a convenient tunnel instead of a dead enemy." 
        i.v1=5
        i.icon="["
        i.col=8
        i.bgcol=0
        i.price=2500
        i.res=55
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=123
                i.desig="powerful "&i.desig
                i.desigp="powerful "&i.desigp
                i.v1=6
                i.price=3000
            else
                i.id=125
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=4
                i.price=2000
            endif
        endif
    endif
        
    if a=24 then
        i.ti_no=2024
        i.id=25
        i.ty=7
        i.desig="grenade"
        i.desigp="grenades"
        i.ldesc="small self propelled devices with explosive warheads"
        i.icon="'"
        i.v1=2
        i.col=7
        i.price=50
        i.res=10
    endif 
    
    if a=25 then
        i.ti_no=2025
        i.id=26
        i.ty=7
        i.desig="fusion grenade"
        i.desigp="fusion grenades"
        i.ldesc="small self propelled devices with small matter-antimatter warheads"        
        i.icon="'"
        i.v1=4
        i.col=9
        i.price=160
        i.res=11
    endif
    
    if a=26 then
        i.ti_no=2026
        i.id=27
        i.ty=8
        i.desig="set of binoculars"
        i.desigp="sets of binoculars"
        i.ldesc="a handheld device for magnifiying far away objects."
        i.icon=":"
        i.col=7
        i.v1=2
        i.price=90
        i.res=15
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+100
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=3
                i.price=100
            else
                i.id=i.id+110
                i.desig="cheap "&i.desig
                i.desigp="cheap "&i.desigp
                i.v1=1
                i.price=80
            endif
        endif
    endif
    
    if a=27 then
        i.ti_no=2027
        i.id=28
        i.ty=8
        i.desig="portable sensorset"
        i.desigp="portable sensorsets"
        i.ldesc="Added to a spacesuit this device enhances the sensor input, if you know how to read it." 
        i.icon=":"
        i.col=8
        i.v1=4
        i.price=500
        i.res=25
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+100
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=5
                i.price=600
            else
                i.id=i.id+110
                i.desig="cheap "&i.desig
                i.desigp="cheap "&i.desigp
                i.v1=3
                i.price=400
            endif
        endif
    endif
    
    if a=28 then
        i.ti_no=2028
        i.id=29
        i.ty=9
        i.desig="helmet lamp"
        i.desigp="helmet lamps"
        i.icon=";"
        i.ldesc="A small lamp to lighten up dark places"
        i.col=7
        i.v1=2
        i.price=25
        i.res=35
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+1000
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=3
                i.price=30
            else
                i.id=i.id+1100
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=1
                i.price=15
            endif
        endif
            
    endif
    
    if a=29 then
        i.ti_no=2029
        i.id=30
        i.ty=9
        i.desig="flood light"
        i.desigp="flood lights"
        i.ldesc="A set of strong lamps, shoulder mounted" 
        i.icon=";"
        i.col=14
        i.v1=6
        i.price=50
        i.res=55
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+1000
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=7
                i.price=60
            else
                i.id=i.id+1100
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=5
                i.price=40
            endif
        endif
    endif
    
    if a=30 then
        i.ti_no=2030
        i.id=31
        i.ty=10
        i.desig="communication satellite"
        i.desigp="communication satellites"
        i.ldesc="This small device deploys during landing. It is used as a relay for ship to awayteam communications. It also continuously scans the surface and emits a signal for position triangulation."
        i.icon="s"
        i.col=15
        i.v1=1
        i.price=900
        i.res=105
    endif
    
    if a=31 then
        i.ti_no=2031
        i.id=32
        i.ty=11
        i.desig="medpack"
        i.desigp="medpacks"
        i.ldesc="the basic necessities to treat wounds."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=1
        i.price=50
        i.res=65
    endif
        
    
    if a=32 then
        i.ti_no=2032
        i.id=33
        i.ty=11
        i.desig="medpack II"
        i.desigp="medpacks II"
        i.ldesc="sufficent means to treat wounds."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=3
        i.price=140
        i.res=75
    endif
    
    
    if a=33 then
        i.ti_no=2033
        i.id=34
        i.ty=11
        i.desig="medpack III"
        i.desigp="medpacks III"
        i.ldesc="everything you could need or want to treat wounds, as long as it is portable."
        i.icon="+"
        i.col=12
        i.bgcol=15
        i.v1=9
        i.price=420
        i.res=85
    endif
    
    if a=34 then
        i.ti_no=2034
        i.id=35
        i.ty=12
        i.desig="mechanical lockpicks"
        i.desigp=i.desig
        i.ldesc="A set if tools designed to open primitve mechanical locks"
        i.icon="}"
        i.col=7
        i.v1=1
        i.price=25
        i.res=25
    endif
    
    
    if a=35 then
        i.ti_no=2035
        i.id=36
        i.ty=12
        i.desig="electronic lockpicks"
        i.desigp=i.desig
        i.ldesc="A set if tools designed to find a way to open locks"
        i.icon="}"
        i.col=7
        i.v1=3
        i.price=125
        i.res=55
    endif
    
    if a=36 then
        i.ti_no=2036
        i.id=37
        i.ty=13
        i.desig="anaesthetics"
        i.desigp="anaesthetics"
        i.icon="'"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.col=13
        i.v1=100
        i.price=10
        i.res=5
    endif
    
    if a=37 then
        i.ti_no=2037
        i.id=38
        i.ty=13
        i.desig="strong anaesthetics"
        i.desigp="strong anaesthetics"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.icon="'"
        i.col=13
        i.v1=250
        i.price=50
        i.res=10
    endif
        
    if a=38 then
        i.ti_no=2038
        i.id=39
        i.ty=14
        i.desig="aux. oxygen tank"
        i.desigp="aux. oxygen tanks"
        i.icon="!"
        i.ldesc="A small tank to increase the oxygen supply of spacesuits. Several users can connect to one tank."
        i.col=15
        i.v1=50
        i.price=45
        i.res=65
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+100
                i.desig="big "&i.desig
                i.desigp="big "&i.desigp
                i.v1=75
                i.price=50
            else
                i.id=i.id+110
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v1=40
                i.price=35
            endif
        endif
    endif
        
    if a=39 then
        i.ti_no=2039
        i.id=40
        i.ty=16
        i.desig="seismograph"
        i.desigp="seismographs"
        i.icon=":"
        i.ldesc="Used to predict and pinpoint the location of earthquakes."
        i.col=7
        i.price=850
        i.res=85
    endif
    
    if a=40 then
        i.ti_no=2040
        i.id=41
        i.ty=4
        i.desig="combat knife"
        i.desigp="combat knifes"
        i.icon="("
        i.col=8
        i.v1=.1
        i.v3=3
        i.price=5
        i.ldesc="A short blade to stick into enemies."
        i.res=10
    endif
    
    if a=41 then
        i.ti_no=2041
        i.id=42
        i.ty=4
        i.desig="combat blade"
        i.desigp="combat blades"
        i.icon="("
        i.col=8
        i.v1=.2
        i.v3=3
        i.price=10
        i.ldesc="A long blade for piercing and slashing."
        i.res=15
    endif
    
    if a=42 then
        i.ti_no=2042
        i.id=43
        i.ty=4
        i.desig="vibro knife"
        i.desigp="vibro knives"
        i.icon="("
        i.col=8
        i.v1=.3
        i.v3=3
        i.price=25
        i.ldesc="A blade for slashing and piercing. Sawing motions increase damage."
        i.res=20
    endif

    if a=43 then
        i.ti_no=2043
        i.id=44
        i.ty=4
        i.desig="vibro blade"
        i.desigp="vibro blades"
        i.icon="("
        i.col=8
        i.v1=.4
        i.v3=4
        i.price=50
        i.ldesc="A wide blade connected to a gauntlet. Sawing motions increase damage."
        i.res=25
    endif
    
    if a=44 then
        i.ti_no=2044
        i.id=45
        i.ty=4
        i.desig="vibro sword"
        i.desigp="vibro swords"
        i.icon="("
        i.col=8
        i.v1=.5
        i.v3=4
        i.price=75
        i.ldesc="A long blade connected to a gauntlet. Sawing motions increase damage."
        i.res=35
    endif
    
    if a=45 then
        i.ti_no=2045
        i.id=46
        i.ty=4
        i.desig="mono blade"
        i.desigp="mono blades"
        i.icon="("
        i.col=8
        i.v1=.6
        i.v3=4
        i.price=100
        i.ldesc="A sturdy gauntlet ending in a blade a single molecule wide."
        i.res=45
    endif
    
     
    if a=46 then
        i.ti_no=2046
        i.id=47
        i.ty=4
        i.desig="mono sword"
        i.desigp="mono swords"
        i.icon="("
        i.col=8
        i.v1=.7
        i.v3=4
        i.price=150
        i.ldesc="A gauntlet with a long blade attached. It is a single molecule wide and heated to increase damage."
        i.res=55
    endif
    
    if a=47 then
        i.ti_no=2047
        i.id=48
        i.ty=4
        i.desig="combat gloves"
        i.desigp="combat gloves"
        i.icon="("
        i.col=8
        i.v1=.9
        i.v3=5
        i.price=225
        i.ldesc="A sturdy gauntlet, connected to plastic sleeves going up to the shoulders. Servos increase the wearers strength. mono blades connected to the fingers hurt opponents."
        i.res=65
    endif
    
    
    if a=48 then
        i.ti_no=2048
        i.id=49
        i.ty=17
        i.desig="grenade launcher"
        i.desigp="grenade launchers"
        i.icon="]"
        i.col=7
        i.v1=2
        i.price=500
        i.ldesc="A device to increase the range and improve the aim of grenades."
        i.res=55
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.v1=3
                i.id+=1000
                i.price=800
                i.desig="powerful grenade launcher"
                i.desigp="powerful grenade launchers"
            else
                i.v1=1
                i.id+=1001
                i.price=400
                i.desig="weak grenade launcher"
                i.desigp="weak grenade launchers"
            endif
        endif
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            i.v2=1
            i.id+=1002
            i.price=i.price*2
            i.desig="double "&i.desig
            i.desigp="double "&i.desig
        endif
    endif
    
    if a=49 then
        i.ti_no=2049
        i.id=50
        i.ty=28
        i.v1=25
        i.desig="aux jetpack tanks"
        i.desigp="aux jetpack tanks"
        i.icon="!"
        i.col=14
        i.price=10
        i.ldesc="Small portable tanks to store auxillary jetpack fuel."
        i.res=65
    endif
    
    
    if a=50 then
        i.ti_no=2050
        i.id=51
        i.ty=18
        i.desig="simple rover"
        i.desigp="simple rovers"
        i.ldesc="A small wheeled robot to collect map data autonomously. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=192
        i.v1=2
        i.v2=1
        i.v4=12'Speed
        i.vt.x=-1
        i.vt.y=-1
        i.price=200
        i.res=65
    endif
    
    if a=51 then
        i.ti_no=2051
        i.id=52
        i.ty=18
        i.desig="rover"
        i.desigp="rovers"
        i.ldesc="A small robot with 4 legs and decent sensors to collect map data autonomously. It can also operate under water. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=204
        i.v1=3
        i.v2=2
        i.v4=16
        i.vt.x=-1
        i.vt.y=-1
        i.price=400
        i.res=70
    endif
        
    if a=52 then
        i.ti_no=2052
        i.id=53
        i.ty=18
        i.desig="improved rover"
        i.desigp="improved rovers"
        i.ldesc="A small robot with 6 legs, jets for flying short distances, and good sensors. It is used to collect map data autonomously. It can also operate under water and climb mountains. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=14
        i.v1=4
        i.v2=3
        i.v4=18
        i.vt.x=-1
        i.vt.y=-1
        i.price=600
        i.res=85
    endif
    
    if a=53 then
        i.ti_no=2053
        i.id=54
        i.ty=27
        i.desig="simple mining robot"
        i.desigp="simple mining robots"
        i.ldesc="A small stationary robot, extracting small deposits and traces of ore from its immediate surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=54
        i.v1=0
        i.v2=100
        i.v3=.25
        i.vt.x=-1
        i.vt.y=-1
        i.price=100
        i.res=85
    endif
    
    if a=54 then
        i.ti_no=2054
        i.id=55
        i.ty=27
        i.desig="mining robot"
        i.desigp="mining robots"
        i.ldesc="A small stationary robot, extracting and drilling small deposits and traces of ore from its surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=60
        i.v1=0
        i.v2=250
        i.v3=.5
        i.vt.x=-1
        i.vt.y=-1
        i.price=250
        i.res=90
    endif
        
    if a=55 then
        i.ti_no=2055
        i.id=56
        i.ty=27
        i.desig="improved mining robot"
        i.desigp="improved mining robots"
        i.ldesc="A small stationary robot drilling for ore autonomously, collecting small deposits and traces of ore from the ground and atmosphere. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=66
        i.v1=0
        i.v2=500
        i.v3=1
        i.vt.x=-1
        i.vt.y=-1
        i.price=500
        i.res=95
    endif
    
    if a=56 then
        i.ti_no=2056
        i.id=57
        i.ty=19
        i.desig="disease kit I"
        i.desigp="disease kits I"
        i.ldesc="A basic supply for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=2
        i.price=15
    endif
    
    
    if a=57 then
        i.ti_no=2057
        i.id=58
        i.ty=19
        i.desig="disease kit II"
        i.desigp="disease kits II"
        i.ldesc="A supply of drugs and diagnostic tools for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=4
        i.price=25
    endif
    
    if a=58 then
        i.ti_no=2058
        i.id=59
        i.ty=19
        i.desig="disease kit III"
        i.desigp="disease kits III"
        i.ldesc="Advanced diagnostic tools and drugs for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=6
        i.price=50
    endif
    
    if a=59 then
        i.ti_no=2059
        i.id=60
        i.ty=21
        i.desig="conventional mine"
        i.desigp="conventional mines"
        i.ldesc="A simple, small explosive device, triggered by proximity"
        i.icon="'"
        i.col=10
        i.v1=6
        i.price=25
    endif
        
    if a=60 then
        i.ti_no=2060
        i.id=61
        i.ty=21
        i.desig="improved mine"
        i.desigp="improved mines"
        i.ldesc="A simple, small explosive device, triggered by proximity, blasting into the direction of the target."
        i.icon="'"
        i.col=13
        i.v1=10
        i.price=50
    endif
    
    if a=61 then
        i.ti_no=2061
        i.id=62
        i.ty=22
        i.desig="stun mine"
        i.desigp="stun mines"
        i.ldesc="A simple, small device. Triggered by proximity, a strong electrical field stuns the victim."
        i.icon="'"
        i.col=12
        i.v1=12
        i.price=25
    endif
    
    if a=62 then
        i.ti_no=2062
        i.id=63
        i.ty=26
        i.desig="cage"
        i.desigp="cages"
        i.ldesc="A cage for transporting wild animals."
        i.icon=chr(128)
        i.col=7
        i.v1=0
        i.v2=1
        i.price=25
    endif
        
    if a=63 then
        i.ti_no=2063
        i.id=64
        i.ty=26
        i.desig="stasis field"
        i.desigp="stasis fields"
        i.ldesc="A portable device for storing wild animals. It can hold up to 5 creatures in a compressed form, no matter what size."
        i.icon=chr(128)
        i.col=11
        i.v1=0
        i.v2=5
        i.price=100
    endif
    
    
    if a=64 then
        i.ti_no=2064
        i.id=65
        i.ty=26
        i.desig="improved stasis field"
        i.desigp="improved stasis fields"
        i.ldesc="A portable device for storing wild animals. It can hold up to 10 creatures in a compressed form, no matter what size."
        i.icon=chr(128)
        i.col=11
        i.v1=0
        i.v2=10
        i.price=150
    endif
    
    if a=65 then
        i.ti_no=2065
        i.id=66
        i.ty=20
        i.desig="debris from a destroyed rover"
        i.desigp="debris from destroyed rovers"
        i.ldesc="broken rover"
        i.icon="X"
        i.col=7
        i.res=100
    endif
    
    if a=66 then
        i.ti_no=2066
        i.id=67
        i.ty=20
        i.desig="debris from a destroyed mining robot"
        i.desigp="debris from destroyed mining robots"
        i.ldesc="broken mining robot"
        i.icon="X"
        i.col=8
        i.res=100
    endif
    
    if a=67 then
        i.ti_no=2067
        i.id=68
        i.ty=21
        i.desig="basic infirmary"
        i.desigp="basic infirmaries"
        i.ldesc="The basic supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=1
        i.price=500
        i.bgcol=15
        i.res=100
    endif
    
    
    if a=68 then
        i.ti_no=2068
        i.id=69
        i.ty=21
        i.desig="infirmary"
        i.desigp="infirmaries"
        i.ldesc="The supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=3
        i.price=1000
        i.bgcol=15
        i.res=100
    endif
    
    
    if a=69 then
        i.ti_no=2069
        i.id=70
        i.ty=21
        i.desig="advanced infirmary"
        i.desigp="advanced infirmaries"
        i.ldesc="State of the art supplies and devices for your ships infirmary."
        i.icon="X"
        i.col=10
        i.v1=5
        i.price=1500
        i.bgcol=15
        i.res=100
    endif
    
    if a=70 then
        i.ti_no=2070
        i.id=71
        i.ty=36
        i.desig="emergency beacon"
        i.desigp="emergency beacons"
        i.ldesc="An external transmitter with autonomous energy supply. It transmits a distress signal on a reserved frequency, increases your chances to find help in case of an emergency."
        i.icon="s"
        i.col=15
        i.v1=3
        i.price=500
        i.res=100
    endif
    
    if a=71 then
        i.ti_no=2071
        i.id=72
        i.ty=36
        i.desig="imp. Emergency beacon"
        i.desigp="imp. emergency beacons"
        i.ldesc="An external transmitter with autonomous energy supply. It transmits a distress signal on a reserved frequency and performs a spiral search pattern, to increase your chances to find help in case of an emergency."
        i.icon="s"
        i.col=15
        i.v1=6
        i.price=900
        i.res=100
    endif
    
    if a=72 then
        i.ti_no=2072
        i.id=73
        i.ty=40
        i.desig="anti-ship mine"
        i.desigp="anti-ship mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=5
        i.v2=3
        i.v3=75
        i.res=100
        i.price=50
    endif
    
    if a=73 then
        i.ti_no=2073
        i.id=74
        i.ty=40
        i.desig="anti-ship mine MKII"
        i.desigp="anti-ship mines MKII"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=10
        i.v2=4
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=74 then
        i.ti_no=2074
        i.id=75
        i.ty=40
        i.desig="improvised mine"
        i.desigp="improvised mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="�"
        i.col=7
        i.v1=3
        i.v2=2
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=75 then
        i.ti_no=2075
        i.id=76
        i.ty=41
        i.desig="AT landing gear"
        i.desigp="AT Landing gears"
        i.ldesc="special landing struts designed to make landing in all kinds of terrain easier"
        i.v1=2
        i.icon=chr(208)
        i.col=8
        i.res=100
        i.price=250
    endif
        
    
    if a=76 then
        i.ti_no=2076
        i.id=77
        i.ty=41
        i.desig="Imp. AT landing gear"
        i.desigp="Imp. AT Landing gears"
        i.ldesc="special landing struts designed to make landing in all kinds of terrain easier"
        i.v1=5
        i.icon=chr(208)
        i.col=14
        i.res=100
        i.price=500
    endif
    
    if a=77 then 
        i.ti_no=2077
        i.id=78
        i.ty=42
        i.desig="Ground penetrating radar"
        i.desigp="Ground penetrating radars"
        i.ldesc="A modified portable sensor set. Enables the user to see through walls"
        
        i.v1=2
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            
            if rnd_range(1,100)+player.turn/rate<60 then
                i.v1=3
                i.id+=202
                i.desig="Good ground penetrating radar"
                i.desigp="Good ground penetrating radars"
            else
                i.id+=203
                i.v1=4
                i.desig="Great ground penetrating radar"
                i.desigp="Great ground penetrating radars"
            endif
        endif
        i.icon=":"
        i.col=7
        i.res=80
        i.price=350+100*i.v1
    endif
    
    if a=78 then 
        i.ti_no=2111
        i.id=79
        i.ty=7
        i.desig="Flash grenade"
        i.desigp="Flash grenades"
        i.ldesc="Produces a bright light that illuminates an area."
        i.v1=0
        i.v2=1
        i.v3=66
        i.icon="."
        i.col=7
        i.res=80
        i.price=5
    endif
    
    if a=79 then 
        i.ti_no=2112
        i.id=80
        i.ty=7
        i.desig="Stun grenade"
        i.desigp="Stun grenades"
        i.ldesc="A non-lethal explosive device used to temporarily disorient an enemy's senses. It is designed to produce a blinding flash of light and loud noise without causing permanent injury."
        i.v1=3
        i.v2=2
        i.icon="."
        i.col=7
        i.res=80
        i.price=20
    endif
    
    
    if a=80 then 
        i.ti_no=2112
        i.id=81
        i.ty=7
        i.desig="Improved stun grenade"
        i.desigp="Improved stun grenades"
        i.ldesc=""
        i.v1=5
        i.v2=2
        i.icon="."
        i.col=7
        i.res=80
        i.price=80
    endif
    
    if a=81 then
        i.ti_no=2113
        i.id=82
        i.ty=47
        i.desig="Id Tag"
        i.desigp="Id Tags"
        i.ldesc="An Id Tag of a spaceship crew member"
        i.v1=rnd_range(1,3)
        i.v2=mod1
        i.col=11
        i.res=89
        i.icon="?"
        i.price=0
    endif
    
    if a=82 then
        i.ti_no=2114
        i.ty=48
        i.id=83
        i.desig="Autopsy kit"
        i.desigp="Autopsy kits"
        i.ldesc="Tools for analyzing alien corpses"
        i.v1=20
        i.col=0
        i.bgcol=15
        i.icon="+"
        i.price=25
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.desig="Small autopsy kit"
                i.desigp="Small autopsy kits"
                i.v1=15
                i.id+=100
                i.price=20
            else
                i.id+=110
                i.desig="Good autopsy kit"
                i.desigp="Good autopsy kits"
                i.v1=25
                i.price=30
            endif
        endif
    endif

    if a=83 then
        i.ti_no=2115
        i.ty=49
        i.id=84
        i.desig="Botany kit"
        i.desigp="Botany kits"
        i.ldesc="A kit containing tools for advanced plant analysis"
        i.v1=20
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=25
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.desig="Small botany kit"
                i.desigp="Small botany kits"
                i.v1=15
                i.id+=100
                i.price=20
            else
                i.id+=110
                i.desig="Good botany kit"
                i.desigp="Good botany kits"
                i.v1=25
                i.price=30
            endif
        endif
    endif
    
    
    if a=84 then
        i.ti_no=2116
        i.ty=50
        i.id=85
        i.desig="Ship repair kit"
        i.desigp="Ship repair kits"
        i.ldesc="A kit containing tools for ship repair"
        i.v1=2
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=50
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.desig="Small ship repair kit"
                i.desigp="Small ship repair kits"
                i.id+=100
                i.v1=1
                i.price=25
            else
                i.desig="Good ship repair kit"
                i.desigp="Good ship repair kits"
                i.id+=101
                i.v1=3
                i.price=75
            endif
        endif
    endif
    
    if a=85 then
        i.ty=51
        i.id=151
        i.ti_no=2122
        i.desig="suit repair kit"
        i.desigp="suit repair kits"
        i.ldesc="A kit containing tools for spacesuit repair."
        i.v1=3
        i.col=6
        i.icon="+"
        i.price=25
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.desig="Small suit repair kit"
                i.desigp="Small suit repair kits"
                i.id+=100
                i.v1=2
                i.price=20
            else
                i.desig="Big suit repair kit"
                i.desigp="Big suit repair kits"
                i.id+=101
                i.v1=5
                i.price=40
            endif
        endif
    endif
    if a=104 then
        i.ti_no=2117
        i.ty=56
        i.id=104
        i.v1=1 'Volume
        i.v2=2 'Piloting Bonus
        i.v3=10 'HPs
        i.desig="Gas mining probe MK I"
        i.desigp="Gas mining probes MK I"
        i.icon="s"
        i.col=12
        i.price=100
    
    endif
    
    if a=105 then
        i.ti_no=2117
        i.ty=56
        i.id=105
        i.desig="Gas mining probe MK II"
        i.desigp="Gas mining probes MK II"
        i.v1=2 'HP
        i.v2=0 'Piloting Bonus
        i.v3=20 'Tanksizes
        i.icon="s"
        i.col=12
        i.price=200
    endif
    
    if rnd_range(1,100)<10+player.turn/rate and (a=104 or a=105) then
        if rnd_range(1,100)<50 then
            i.desig="Big "&i.desig
            i.v3=i.v3*1.5
            i.price=i.price*1.2
            i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to " &i.v3 &" tons of fuel"
            i.id+=110
        else
            i.desig="Sturdy "&i.desig
            i.v1+=1
            i.price=i.price*1.1
            i.id+=120
        endif
    endif
    if a=106 then
        i.ti_no=2024
        i.id=106
        i.ty=7
        i.desig="small grenade"
        i.desigp="small grenades"
        i.ldesc="small self propelled devices with explosive warheads"
        i.icon="'"
        i.v1=1
        i.col=7
        i.price=25
        i.res=10
    endif 
    
    if a=107 then
        i.ti_no=2025
        i.id=107
        i.ty=7
        i.desig="small fusion grenade"
        i.desigp="small fusion grenades"
        i.ldesc="small self propelled devices with small matter-antimatter warheads"        
        i.icon="'"
        i.v1=3
        i.col=9
        i.price=80
        i.res=11
    endif
'   
'Typ 51-54 taken

    if a=100 then
        i.ti_no=2117
        i.ty=55
        i.id=600
        i.desig="Probe MK I"
        i.desigp="Probes MK I"
        i.ldesc="A probe for deep space operation. It has a range of 5 parsecs and 1 HP"
        i.v1=1 'Range
        i.v2=1 'Scanning Range
        i.v3=5 'HPs
        i.v4=0 'HPs
        i.v5=4 'Speed
        i.v6=5
        i.icon="s"
        i.col=11
        i.price=50
        i.res=100
    endif
    if a=101 then
        i.ti_no=2118
        i.ty=55
        i.id=601
        i.desig="Probe MK II"
        i.desigp="Probes MK II"
        i.ldesc="A probe for deep space operation. It has a range of 7 parsecs and 2 HP"
        i.v1=2 'Range
        i.v2=2 'Scanning Range
        i.v3=7 'HPs
        i.v4=1 'HPs
        i.v5=5 'Speed
        i.v6=7
        i.icon="s"
        i.col=11
        i.price=100
        i.res=100
    endif
    if a=102 then
        i.ti_no=2119
        i.ty=55
        i.id=602
        i.desig="Probe MK III"
        i.desigp="Probes MK III"
        i.ldesc="A probe for deep space operation. It has a range of 10 parsecs and 3 HP"
        i.v1=3 'Range
        i.v2=3 'Scanning Range
        i.v3=10 'HPs
        i.v4=2 'HPs
        i.v5=6 'speed
        i.v6=10
        i.icon="s"
        i.col=11
        i.res=100
        i.price=150
    endif
    
    if rnd_range(1,100)<10+player.turn/rate and (a=100 or a=101 or a=102) then
        i.desig="Fast "&i.desig
        i.desigp="Fast "&i.desigp
        i.price=i.price*1.1
        i.v5=i.v5+3
        i.id+=50
    endif
    
    if a=103 then
        i.ti_no=2120
        i.desig="ship detection system"
        i.desigp="ship detection systems"
        i.price=1500
        i.id=1001
        i.ty=51
        i.v1=1
    endif
'   
    if a=110 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK I"
        i.desigp="Drones MK I"
        i.ty=67
        i.id=552
        i.v1=2 'HP
        i.v2=1 'Dam
        i.v3=1 'Range
        i.v4=3 'Engine
        i.price=500
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    if a=111 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK II"
        i.desigp="Drones MK II"
        i.ty=67
        i.id=553
        i.v1=3 'HP
        i.v2=2 'Dam
        i.v3=1 'Range
        i.v4=4 'Engine
        i.price=1000
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    
    if a=112 then 'Drone MK1
        i.ti_no=2118
        i.desig="Drone MK III"
        i.desigp="Drones MK III"
        i.ty=67
        i.id=554
        i.v1=4 'HP
        i.v2=3 'Dam
        i.v3=2 'Range
        i.v4=5 'Engine
        i.price=1500
        i.res=100
        i.icon="d"
        i.col=c_gre
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints and is armed with a " &i.v2 &"0 GJ plasma cannon"
    endif
    
    if rnd_range(1,100)<10+player.turn/rate and (a=110 or a=111 or a=112) then
        select case rnd_range(1,100)
        case 1 to 30
            i.desig="Fast "&i.desig
            i.desigp="Fast "&i.desigp
            i.price=i.price*1.1
            i.v5=i.v5+3
            i.id+=50
        case 31 to 60
            i.desig="Sturdy "&i.desig
            i.desigp="Sturdy "&i.desigp
            i.price=i.price*1.1
            i.v1=i.v1+2
            i.id+=100
        case 61 to 90
            i.desig="Powerful "&i.desig
            i.desigp="Powerful "&i.desigp
            i.price=i.price*1.1
            i.v2=i.v2+1
            i.id+=150
        case else
            select case rnd_range(1,100)
            case 1 to 33
                i.desig="Fast sturdy "&i.desig
                i.desigp="Fast sturdy "&i.desigp
                i.price=i.price*1.3
                i.v1=i.v1+2
                i.v5=i.v5+3
                i.id+=250
            
            case 33 to 66
                i.desig="Powerful sturdy "&i.desig
                i.desigp="Powerful sturdy "&i.desigp
                i.price=i.price*1.4
                i.v1=i.v1+2
                i.v2=i.v2+1
                i.id+=350
            case else
                i.desig="Powerful fast "&i.desig
                i.desigp="Powerful fast "&i.desigp
                i.price=i.price*1.2
                i.v5=i.v5+3
                i.v2=i.v2+1
                i.id+=450
            end select
            
        end select
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints, and is armed with a " &i.v2 &"0 GJ plasma cannon"
        
            
    endif
    
    if rnd_range(1,100)<5+player.turn/rate and (a=110 or a=111 or a=112) then
        i.desig=i.desig &"-S"
        i.id+=100
        i.v6=1
        i.ldesc="An autonomous drone for space combat. It has " &i.v1 &" Hullpoints, and is armed with a " &i.v2 &"0 GJ plasma cannon. It also has a shield generator."
        i.price=i.price*1.2
    endif
    
    if a=152 then
        i.ti_no=2025
        i.ty=77
        i.id=556
        i.icon="'"
        i.col=14
        i.desig="mining explosives"
        i.desigp="mining explosives"
        i.ldesc="Cheap explosives to blow holes into rubble and mountains. Just drop to use them"
        i.v1=10
        i.price=25
        i.res=90
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<66 then
                i.v1=7
                i.price=20
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
            else
                i.v1=12
                i.price=30
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
            endif
        endif
    endif
    
    if a=162 then
        i.ti_no=2062
        i.id=62
        i.ty=29
        i.desig="cage trap"
        i.desigp="cage traps"
        i.ldesc="For trapping wild animals. Just place it on the ground and wait for an animal to wander into it. Contains:"
        i.icon=chr(128)
        i.col=13
        i.v1=0
        i.v2=1
        i.price=125
    endif
    
    
    if a=163 then
        i.ti_no=2062
        i.id=63
        i.ty=29
        i.desig="stasis trap"
        i.desigp="stasis traps"
        i.ldesc="For trapping wild animals. Just place it on the ground and wait for an animal to wander into it. Contains:"
        i.icon=chr(128)
        i.col=13
        i.v1=0
        i.v2=5
        i.price=525
    endif
'

    if a=181 then
        i.ti_no=2003
        i.id=81
        i.ty=2
        i.desig="Injector gun"
        i.desigp="Injector guns"
        i.ldesc="A nonlethal weapon. It fires a small dart, filled with a drug paralyzing most lifeforms. It does negligable damage, but may incapacitate an opponent."
        i.v4=.4
        i.v2=2
        i.icon="-"
        i.col=7
        i.res=80
        i.price=100
    endif
    
    
    if a=182 then
        i.ti_no=2003
        i.id=81
        i.ty=2
        i.desig="Injector rifle"
        i.desigp="Injector rifles"
        i.ldesc="A nonlethal weapon. It fires several small darts, filled with a drug paralyzing most lifeforms. It does negligable damage, but may incapacitate an opponent."
        i.v4=.6
        i.v2=2
        i.icon="-"
        i.col=7
        i.res=80
        i.price=250
    endif
    
    if a=183 then
        i.ti_no=2003
        i.id=79
        i.ty=2
        i.desig="Disruptor"
        i.desigp="Disruptors"
        i.ldesc="A nonlethal weapon. A strong magnetic field disrupts nerve signals in the target, leaving only minor damage, but stunning it."
        i.v4=.8
        i.v2=4
        i.icon="-"
        i.col=7
        i.res=80
        i.price=500
    endif

    if a=184 then
        i.ti_no=2003
        i.id=79
        i.ty=2
        i.desig="Disruptor rifle"
        i.desigp="Disruptor rifles"
        i.ldesc="A nonlethal weapon. A strong magnetic field disrupts nerve signals in the target, leaving only minor damage, but stunning it."
        i.v4=1
        i.v2=4
        i.icon="-"
        i.col=7
        i.res=80
        i.price=750
    endif
'    

'    if a=83 then
'        i.ty=4
'        i.desig="Electric baton"
'        i.v4=.2
'    endif
'    
'    if a=84 then
'        i.desig="Sonic Mace"
'        i.v4=.1
'    endif
'        
    if a=86 then
        i.ti_no=2078
        i.id=86
        i.ty=86
        i.v1=1
        i.desig="burrowers eggsack"
        i.desigp="burrowers eggsacks"
        i.ldesc="a skinsack containing about 50 burrowers eggs, carried by the larger female of the species."
        i.icon="o"
        i.col=14
    endif
        
    if a=88 then
        i.ti_no=2079
        i.id=94
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=1
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        i.desig="A bag full of alien coins"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    
    if a=89 then
        i.ti_no=2080
        i.id=89
        i.ty=89
        i.desig="crystal shard"
        i.desigp="crystal shards"
        i.v1=1
        i.ldesc="A shard of an intelligent crystal being. It still emits an electrical field similiar to human brain waves."
        i.icon="*"
        i.col=144
        i.res=120
    endif
        
    if a=90 then
        i.ti_no=2081
        i.id=90
        i.ty=24
        i.desig="nanobot factory"
        i.desigp="nanobot factorys"
        i.col=9
        i.v1=1000
        i.icon="*"
        i.price=35*rnd_range(1,3)
        i.res=100
    endif
    
    if a=91 then
        i.ti_no=2082
        i.id=93
        i.ty=23
        i.desig="bow and arrows"
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="-"
        i.price=135*rnd_range(1,3)
        i.res=100
    endif
    
    if a=92 then
        i.ti_no=2083
        i.id=93
        i.ty=23
        i.desig="primitive handgun"
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="-"
        i.price=335*rnd_range(2,6)
        i.res=100
    endif
    
    if a=93 then
        i.ti_no=2084
        i.id=93
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=3
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        if i.v2=2 then i.desig="alien painting"
        if i.v2=3 then i.desig="pots of burnt clay"
        if i.v2=4 then i.desig="religious idol"
        if i.v2=5 then i.desig="some well worked primitive tools"
        if i.v2=6 then i.desig="wooden box"
        if i.v2=7 then i.desig="small clay statue"
        if i.v2=8 then i.desig="small stone statue"
        if i.v2=9 then i.desig="pretty painting"
        if i.v2=10 then i.desig="hand written book"
        if i.v2=11 then i.desig="some jewelery"
        if i.v2=12 then i.desig="some very well worked jewelery"        
        i.price=i.v1*i.v2*30
        i.res=100
    endif
        
    if a=94 then
        i.ti_no=2084
        i.id=94
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=1
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        if i.v2=2 then i.desig="alien painting"
        if i.v2=3 then i.desig="pots of burnt clay"
        if i.v2=4 then i.desig="religious idol"
        if i.v2=5 then i.desig="metal chains"
        if i.v2=6 then i.desig="wooden box"
        if i.v2=7 then i.desig="small clay statue"
        if i.v2=8 then i.desig="small stone statue"
        if i.v2=9 then i.desig="pretty painting"
        if i.v2=10 then i.desig="hand written book"
        if i.v2=11 then i.desig="jewelery"
        if i.v2=12 then i.desig="very well worked jewelery"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    if a=95 then
        i.ti_no=2085
        i.id=95
        i.ty=12
        i.desig="alien holokeycard"
        i.desigp="alien holokeycards"
        i.icon="}"
        i.col=1
        i.v1=5
        i.res=100
        i.price=2500
    endif
    
    if a=96 then
        i.id=96
        i.ty=15
        
        i.v1=rnd_range(1,4)+mod1
        if rnd_range(1,100)>15 then
            i.v2=rnd_range(1,8+mod2)
        else
            i.v2=prefmin
        endif
        if i.v2>9 then i.v1=i.v1-1
        if i.v2>10 then i.v1=i.v1-1
        if i.v2>11 then i.v1=i.v1-1
        if i.v2>12 then i.v1=i.v1-1
        if i.v2>13 then i.v1=i.v1-1
        if i.v1<1 then i.v1=1
        if i.v2<1 then i.v2=1
        if i.v2>14 then i.v2=14
        
        'used colors 2 3 5 7 10 11 13 14 15 
        'unused 4 6 8 9 12
        if i.v2=1 then i.desig="iron"
        if i.v2=1 then i.col=4
        if i.v2=1 then i.ti_no=2086
        
        if i.v2=2 then i.desig="copper"
        if i.v2=2 then i.col=2
        if i.v2=2 then i.ti_no=2087
        
        if i.v2=3 then i.desig="sulfur"
        if i.v2=3 then i.col=6
        if i.v2=3 then i.ti_no=2088
        
        if i.v2=4 then i.desig="silver"
        if i.v2=4 then i.col=7
        if i.v2=4 then i.ti_no=2089
        
        if i.v2=5 then i.desig="gold"
        if i.v2=5 then i.col=14
        if i.v2=5 then i.ti_no=2090
        
        if i.v2=6 then i.desig="osmium"
        if i.v2=6 then i.col=8
        if i.v2=6 then i.ti_no=2091
        
        if i.v2=7 then i.desig="palladium"
        if i.v2=7 then i.col=15
        if i.v2=7 then i.ti_no=2092
        
        if i.v2=8 then i.desig="gems"
        if i.v2=8 then i.col=5
        if i.v2=8 then i.ti_no=2093
        
        if i.v2=9 then i.desig="transuranic metals"
        if i.v2=9 then i.col=11
        if i.v2=9 then i.ti_no=2094
        
        if i.v2=10 then i.desig="monocrystals"
        if i.v2=10 then i.col=10
        if i.v2=10 then i.ti_no=2095
        
        if i.v2=11 then i.desig="exotic gems"
        if i.v2=11 then i.col=13
        if i.v2=11 then i.ti_no=2096
        
        if i.v2=12 then i.desig="iridium"
        if i.v2=12 then i.col=9
        if i.v2=12 then i.ti_no=2097
        
        if i.v2=13 then i.desig="lutetium"
        if i.v2=13 then i.col=3
        if i.v2=13 then i.ti_no=2098
        
        if i.v2=14 then i.desig="rhodium"
        if i.v2=14 then i.col=12
        if i.v2=14 then i.ti_no=2099
        
        if i.v1<1 then i.v1=1
        
        i.v5=1+(i.v1+rnd_range(1,player.science(0)+i.v2))*(rnd_range(1,5+player.science(0)))
        if i.v5<1 then i.v5=1
        i.price=i.v5/10   
        i.res=i.v5*10         
        
        i.scanmod=rnd_range(1,i.v1)/10
        i.desigp=i.desig
        i.icon="*"
        i.bgcol=0  
        roll=rnd_range(1,100+player.turn/250000+mod1+mod2)
        if (roll>150 and mod1>0 and mod2>0) or roll<minimum(3,player.turn/45000) then i=make_item(99,0,0)
        if make_files=1 then
            f=freefile
            open "artrolls.txt" for append as #f
            print #f,mod1;" ";mod2;" ";roll
            close #f
        endif
            
    endif
    
    if a=87 then
        i.res=120
        i.id=87
        i.ty=25
        i.desig="cloaking device"
        i.desigp="cloaking devices"
        i.v1=5
        i.price=100000
        i.ti_no=2100
    endif
    
    if a=123 then
        i.ti_no=2102
        i.id=523
        i.ty=103
        i.desig="Squidsuit"
        i.desigp="Squidsuits"
        i.ldesc="A limegreen suit, made for creatures with no arms and 9 tentacles. Whenever the wearer is hit that area of the cloth changes corresponding to the nature of the attack."
        i.icon="&"
        i.col=11
        i.v1=8
        i.v3=200
        i.res=120
        i.price=250
    endif
    
    if a=97 then
        i.ti_no=2101
        i.id=97
        i.ty=2
        i.desig="disintegrator"
        i.desigp="disintegrators"
        i.ldesc="A tiny handgun, emitting a pale green ray, that turns everything it touches into thin air."
        i.icon="-"
        i.col=13
        i.bgcol=0
        i.v1=3
        i.v2=6
        i.v3=2
        i.res=120
        i.price=22000
        
    endif
    
    if a=98 then   
        i.ti_no=2102              
        i.id=98
        i.ty=3
        i.desig="adaptive bodyarmor"
        i.desigp="sets of adaptive bodyarmor"
        i.ldesc="A thin limegreen suit with a foldable helmet. Whenever the wearer is hit that area of the cloth changes corresponding to the nature of the attack." 
        i.icon="&"
        i.col=10
        i.bgcol=0
        i.v1=15
        i.v3=250
        i.res=120
        i.price=19000
    endif  
    
    
    if a=99 then
        i.ti_no=2103
        i.id=99
        i.ty=99
        i.icon="*"
        i.col=-1
        i.bgcol=-15
        if mod1>0 then 
            i.v5=mod1
        else
            i=rnd_item(RI_Artefact)
        endif
        i.res=100
    endif
    
    if a=201 then 'Alien civ gun
        i=civ(0).item(0)
        i.ti_no=2104
    endif
    
    if a=202 then 'Alien civ ccweapon
        i=civ(0).item(1)
        i.ti_no=2105
    endif
    
    if a=203 then 'Alien civ gun
        i=civ(1).item(0)
        i.ti_no=2106
    endif
    
    if a=204 then 'Alien civ ccweapon
        i=civ(1).item(1)
        i.ti_no=2107
    endif
    
    if a=205 then
        i.ti_no=2108
        i.id=2005
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=10
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        i.v3=mod1
        i.desig=add_a_or_an(civ(mod1).n,0) & "artifact"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
    if a=250 then
        i.ti_no=2121
        i.id=250
        i.ty=80
        i.desig="tribble"
        i.desigp="tribbles"
        i.ldesc="A most curious creature, its trilling seems to have a tranquilizing effect on the human nervous system." 
        i.v1=1
        i.price=5
        i.res=10
        i.icon="*"
        i.col=7
    endif
    
    if a=251 then
        i.ti_no=2122
        i.id=251
        i.ty=30
        i.desig="Stims I"
        i.desigp="Stims I"
        i.ldesc="A stimulating drug that increases your speed for a short duration. It also increases your oxygen consumption."
        i.v1=15
        i.v2=50
        i.price=50
        i.res=15
        i.icon="."
        i.col=14
    end if
    
    
    if a=252 then
        i.ti_no=2122
        i.id=252
        i.ty=30
        i.desig="Stims II"
        i.desigp="Stims II"
        i.ldesc="A stimulating drug that increases your speed for a medium duration. It also increases your oxygen consumption."
        i.v1=25
        i.v2=50
        i.price=100
        i.res=15
        i.icon="."
        i.col=14
    end if
    
    
    if a=253 then
        i.ti_no=2122
        i.id=253
        i.ty=30
        i.desig="Stims III"
        i.desigp="Stims III"
        i.ldesc="A stimulating drug that increases your speed for a long duration. It also increases your oxygen consumption."
        i.v1=50
        i.v2=50
        i.price=150
        i.res=15
        i.icon="."
        i.col=14
    end if
    
    if a=301 then
        i.ti_no=2109
        i.id=301
        i.ty=45
        i.icon="'"
        i.col=191
        i.desig="ancient alien bomb"
        i.desigp="ancient alien bombs"
        i.v1=rnd_range(0,3)+rnd_range(1,3)+rnd_range(1,3)
        i.price=2000
        i.res=120
    endif
    
    if a=302 then
        i.ti_no=2110
        i.id=302
        i.ty=46
        i.icon="'"
        i.col=11
        i.desig="handheld cloaking device"
        i.desigp="handheld cloaking device"
        i.v1=7
        i.res=120
        i.price=2000
    endif
    
    if a=303 then
        i.ti_no=2123
        i.id=3003
        i.ty=88
        i.icon="'"
        i.col=12
        i.desig="teleportation device"
        i.desigp="teleportation devices"
        i.v1=5+rnd_range(1,6)
        i.v3=rnd_range(10,50)/200
        i.v4=rnd_range(i.v1,i.v1*3)
        i.v2=i.v4
        i.res=120
        i.price=5000
    endif
    
    if a=1002 then
        i.ti_no=2113
        i.id=4002
        i.ty=57
        i.icon="?"
        i.col=15
        i.desig="Autograph of "&questguy(mod1).n
        i.desigp="Autographs"
        i.v1=mod1
    endif
    
    if a=1003 then
        i.ti_no=2113
        i.id=4003
        i.ty=58
        i.icon="?"
        i.col=15
        i.desig="Message for "&questguy(mod2).n
        i.desigp="Messages"
        i.v1=mod1
        i.v2=mod2
    endif
    
    
    if a=1004 then
        i.ti_no=2113
        i.id=4004
        i.ty=59
        i.icon="?"
        i.col=15
        i.desig="Toolkit"
        i.desigp="Tools"
        i.price=mod1*75
        i.v1=mod1
    endif
    
    if a=1005 then
        i.ti_no=2113
        i.id=4005
        i.ty=60
        i.icon="?"
        i.col=15
        select case mod1
        case 1
            i.desig="Sample of Byphodine"
        case 2
            i.desig="Sample of Metazine"
        case 3
            i.desig="Sample of Pylene-50"
        case 4
            i.desig="Sample of Dermaline Gel"
        case 5
            i.desig="Sample of Tri Ox"
        case 6
            i.desig="Sample of Voraxna"
        end select
        i.desigp="Drugsamples"
        i.price=mod1*100
        i.v1=mod1
    endif
    
    if a=1006 then
        i.ti_no=2113
        i.id=4006
        i.ty=61
        i.icon="?"
        i.col=11
        i.desig="Report"
        i.desigp="Reports"
        if mod2=2 then i.desig="Secret "&lcase(i.desig)
        if mod2=3 then i.desig="Top secret "&lcase(i.desig)
        if mod1<1 or mod1>4 then mod1=rnd_range(1,4)
        i.v1=mod1
        i.v2=mod2
        i.desig=i.desig &" ("&companynameshort(mod1)&")"
        i.ldesc=add_a_or_an(lcase(i.desig),1) & " on "&companyname(mod1)
    endif
        
    if a=1007 then
        i.ti_no=2113
        i.id=4007
        i.ty=62
        i.icon="?"
        i.col=11
        i.desig=mod2 &" Cr. for "&questguy(mod1).n
        i.desigp="Receipts"
        i.v1=mod1
        i.v2=mod2
    endif
    
    if a=1008 then
        i.ti_no=2113
        i.id=4008
        i.ty=63
        i.icon="?"
        i.col=15
        if mod1>0 then
            i.desig="Show concept for "&questguy(mod1).n
        else
            i.desig="generic show concept"
        endif
        i.desigp="Show concepts"
        i.v1=mod1
        i.v2=mod2
        i.price=75*mod2
        if mod1=0 then i.price=i.price/2
    endif
    
    if a=1009 then
        i.ti_no=2113
        i.id=4009
        i.ty=64
        i.icon="?"
        i.col=15
        i.desig="PW for station "&mod1+1 &" sensors"
        i.desigp="PWs for station sensors"
        i.v1=mod1
    endif
    
    if a=1010 then
        i.ti_no=2113
        i.id=4010
        i.ty=65
        i.icon="?"
        i.col=15
        i.desig="Research paper by "&questguy(mod1).n
        i.desigp="Research papers"
        i.v1=mod1
        i.price=rnd_range(1,6)*20
    endif
        
        
    if a=1011 then
        i.ti_no=2113
        i.id=4011
        i.ty=66
        i.icon="?"
        i.col=15
        i.desig="Jury rig plans"
        i.desigp="Jury rig plans"
        i.price=rnd_range(1,6)*15
    endif
        
    
    if a=1012 then
        i.ti_no=2113
        i.id=4012
        i.ty=67
        i.icon="?"
        i.col=15
        i.desig="Affidavit for "&questguy(mod1).n
        i.desigp="Affidavits"
        i.v1=mod1
        i.price=0
    endif
    
    i.discovered=show_items
    
    if i.ty=2 and i.v1>0 then
        i.price=i.v1*250+(i.v1-0.1)*250
        if i.v2>0 then i.price=i.price*(10+(i.v2/2))/10
        if i.v3>0 then i.price=i.price*(10+i.v3)/10
    endif
    if i.ty=4 and i.v1>0 then
        i.price=i.v1*75+(i.v1-0.1)*75
        if i.v3>3 then i.price=i.price*((20+i.v3-3)/20)
    endif
    
    'if i.desig="" or i.desigp="" then dprint "ERROR: Item #" &a &" does not exist.",14,14
    if a=320 then return i 'Never modify standard spacesuits
    i=modify_item(i,nomod)
    return i
    
end function

function modify_item(i as _items,nomod as byte) as _items
    dim as short a,rate
    rate=500-disnbase(player.c)
    if rate<100 then rate=100
    rate=rate*60*24
    a=i.id
    if i.id>=13 and i.id<=19 and nomod=0 then
        if rnd_range(1,100)<10+player.turn/rate then
        if rnd_range(1,100)<50+player.turn/rate then
            i.desig="thick "&i.desig
            i.desigp="thick "&i.desigp
            i.id=i.id+1000
            i.v1=i.v1+1
            i.price=i.price*1.2
        else
            if i.v1>1 then
                i.desig="old "&i.desig
                i.desigp="old "&i.desigp
                i.id=i.id+1100
                i.v1=i.v1-1
                i.price=i.price*0.8
            endif
        endif
        endif
    endif
    
    if i.id>=13 and i.id<=21 then
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<66 then
                i.desig="camo "&i.desig
                i.desigp="camo "&i.desigp
                i.v2=1
                i.id=i.id+1200
                i.price=i.price*1.1
            else
                i.desig="imp. camo "&i.desig
                i.desigp="imp. camo "&i.desigp
                i.id=i.id+1300
                i.v2=3
                i.price=i.price*1.25
            endif
        endif
        if rnd_range(1,100)<15+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.id=i.id+1400
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.id=i.id+5500
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.ty=3 or i.ty=103 then
        if rnd_range(1,100)<15+player.turn/rate and nomod=0 then
            i.v3=i.v3*1.1
            i.price=i.price*1.1
        endif
    endif
    
    if i.id>=3 and i.id<=11 then
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+player.turn/rate<75 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+1000
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+1100
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+player.turn/rate<75 then
                    i.desig="powerful "&i.desig
                    i.desigp="powerful "&i.desigp
                    i.id=i.id+1200
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+1300
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        if rnd_range(1,100)<15+player.turn/rate then
            if rnd_range(1,100)+player.turn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.id=i.id+1400
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.id=i.id+5500
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.id=1 then
        if rnd_range(1,100)<20+player.turn/rate  and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v2=4
                i.price=i.v2*115
                i.id=101
            else
                i.desig="large "&i.desig
                i.desigp="large "&i.desigp
                i.v2=6
                i.price=i.v2*85
                i.id=102
            endif
        endif
        i.ldesc="A platform held aloft by aircushions. It can transport up to "&i.v2 &" persons and cross water. Going up mountains is impossible though"
    endif
    
    
    if i.id=2 then
        if rnd_range(1,100)<20+player.turn/rate  and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<50 then
                i.id=211
                i.desig="efficient "&i.desig
                i.desigp="efficient "&i.desigp
                i.price=i.price*1.2
                i.v3=.8
                i.ldesc=i.ldesc &" This particular one has a very efficient fuel system."
            else
                i.id=212
                i.desig="inefficient "&i.desig
                i.desigp="inefficient "&i.desigp
                i.price=i.price*0.8
                i.v3=1.2
                i.ldesc=i.ldesc &" This particular one needs more fuel."
            endif
        endif
    endif
    if i.id>=41 and i.id<=47 then
        if rnd_range(1,100)<10+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+player.turn/rate<75 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+100
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+110
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+player.turn/rate<75 then
                    i.desig="sharp "&i.desig
                    i.desigp="sharp "&i.desigp
                    i.id=i.id+120
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very sharp "&i.desig
                    i.desigp="very sharp "&i.desigp
                    i.id=i.id+130
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        if rnd_range(1,100)<15+player.turn/rate and nomod=0 then
            if rnd_range(1,100)+player.turn/rate<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.id+=1400
                i.res=i.res+50
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.id+=5500
                i.res=i.res+100
                i.price=i.price*1.25
            endif
        endif
    endif
    
    if i.id=49 then 'tanks
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.id=i.id+100
                i.desig="big "&i.desig
                i.desigp="big "&i.desigp
                i.v1=30
                i.price=12
            else
                i.id=i.id+110
                i.desig="small "&i.desig
                i.desigp="small "&i.desigp
                i.v1=20
                i.price=8
            endif
        endif
    endif
    if i.id=97 then
        if rnd_range(1,100)<33+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)+player.turn/rate<50 then
                    i.desig="balanced "&i.desig
                    i.desigp="balanced "&i.desigp
                    i.id=i.id+100
                    i.v3=i.v3+1
                    i.price=i.price*1.2
                else
                    i.desig="well balanced "&i.desig
                    i.desigp="well balanced "&i.desigp
                    i.id=i.id+101
                    i.v3=i.v3+2
                    i.price=i.price*1.5
                endif
            else
                if rnd_range(1,100)+player.turn/rate<50 then
                    i.desig="powerful "&i.desig
                    i.desigp="powerful "&i.desigp
                    i.id=i.id+102
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+103
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
    
    endif
    if i.id=98 or i.id=523 then 
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<5+player.turn/rate then
                if rnd_range(1,100)<50+player.turn/rate then
                    i.desig="thick "&i.desig
                    i.desigp="thick "&i.desigp
                    i.id=i.id+200
                    i.v1=i.v1+1
                    i.price=i.price*1.5
                else
                    i.desig="tattered "&i.desig
                    i.desigp="tattered "&i.desigp
                    i.id=i.id+201
                    i.v1=i.v1-1
                    i.price=i.price*0.75
                endif
            endif
        endif
    endif
    
    if i.ty=18 then
        if rnd_range(1,100)<30+player.turn/rate and nomod=0 then
            if rnd_range(1,100)<50+player.turn/rate then
                i.desig="fast "&i.desig
                i.desigp="fast "&i.desigp
                i.v4+=1
                i.id+=600
                i.price=i.price*1.2
            else
                i.desig="slow "&i.desig
                i.desigp="slow "&i.desigp
                i.v4-=1
                i.id+=610
                i.price=i.price*0.8
            endif
        endif
    endif
    
    return i
end function

function make_shipequip(a as short) as _items
    dim i as _items
    i.id=a+9000
    select case a
    case 1 to 5
        i.ty=150
        i.desig="Sensors "&roman(a)
        i.v1=a
        if a=1 then
            i.price=200
        else
            i.price=800*(a-1)
        endif
    case 6 to 10
        i.ty=151
        i.desig="Engine "&roman(a-5)
        i.v1=a-5
        i.price=(2^(i.v1-1))*300
    case 11 to 14
        i.ty=152
        i.desig="Shield "&roman(a-10)
        i.v1=a-10
        i.price=(2^(i.v1-1))*500
    case 15
        i.desig="ship detection system"
        i.desigp="ship detection systems"
        i.price=1500
        i.id=1001
        i.ty=153
        i.v1=1
        i.ldesc="Filters out ship signatures out of longrange sensor noise."
    case 16
        i.desig="imp. ship detection sys."
        i.desigp="imp. ship detection sys."
        i.price=3000
        i.id=1002
        i.ty=153
        i.v1=2
        i.ldesc="Filters out ship signatures, and friend-foe signals out of longrange sensor noise."
    case 17
        i.desig="Cargo bay shielding MKII"
        i.price=1500
        i.ty=156
        i.id=1007
        i.v1=45
        i.ldesc="Special shielding for cargo bays, making it harder to scan them."
    case 18
        i.desig="ECM I system"
        i.desigp="ECM I systems"
        i.price=3000
        i.ty=155
        i.id=1004
        i.v1=1
        i.ldesc="Designed to prevent sensor locks, especially effective against missiles"
    case 19    
        i.desig="ECM II system"
        i.desigp="ECM II systems"
        i.price=9000
        i.ty=155
        i.id=1005
        i.v1=2
        i.ldesc="Designed to prevent sensor locks, and decrease sensor echo. especially effective against missiles"
    case 20
        i.desig="Cargo bay shielding"
        i.price=500
        i.ty=156
        i.id=1006
        i.v1=30
        i.ldesc="Special shielding for cargo bays, making it harder to scan them."
    case 21
        i.desig="navigational computer"
        i.desigp="navigational computers"
        i.price=350
        i.id=1003
        i.ty=154
        i.v1=1
        i.ldesc="A system keeping track of sensor input. Shows you where you are and allows you to see where you have already been." 

    case 22
        i.desig="Fuel System I"
        i.price=500
        i.ty=157
        i.v1=1
        i.ldesc="Saves fuel by reducing leakage."
    case 23
        i.desig="Fuel System II"
        i.price=750
        i.ty=157
        i.v1=2
        i.ldesc="Saves fuel by reducing leakage and improved engine control."
    end select
    return i
end function


function make_weapon(a as short) as _weap
    'w.made &";"&w.desig &";" &w.range &";"& w.ammo &";"&w.ammomax &";"& w.ecmmod &";"& w.p &";"
    '& w.col &";"& w.heat &";"& w.heatsink &";"& w.heatadd

    dim as _weap w,w2
    dim as string l
    dim as string word(15)
    dim as short f,i,t,j,dam
    f=freefile
    open "data/weapons.csv" for input as #f
    do
        w=w2
        line input #f,l
        j=0
        for t=0 to len(l)
            if mid(l,t,1)=";" then
                j+=1
            else
                word(j)=word(j) &mid(l,t,1)
            endif
        next
        w.made=val(word(0))
        w.desig=trim(word(1))
        dam=val(word(2))
        w.range=val(word(3))
        w.ammo=val(word(4))
        w.ammomax=val(word(5))
        w.ROF=val(word(6))
        w.ecmmod=val(word(7))
        w.p=val(word(8))
        w.col=val(word(9))
        w.heat=val(word(10))
        w.heatsink=val(word(11))
        w.heatadd=val(word(12))
        w.reload=val(word(13))
        for t=0 to 13
            word(t)=""
        next
    loop until w.made=a or eof(f)
    close #f
    if a=w.made then
        if a>=6 and a<=10 then
            w.dam=urn(dam+2,dam-1,1,2-(player.turn/50000))
            if w.dam<1 then w.dam=1
            if w.dam>5 then w.dam=5
            w.desig=w.dam &"0 GJ "&w.desig
            w.p=(w.dam*250+((w.dam-1)*250))*(1+w.range/5)
        else
            w.dam=dam
        endif
        if rnd_range(1,100)-(w.dam-dam)*3<minimum(25,player.turn/50000) and w.reload>0 then '10 % have lower reload rate
            w.desig="IR "&w.desig
            w.reload=w.reload/2
            w.p=w.p*1.2
        endif
        if rnd_range(1,100)-(w.dam-dam)*3<minimum(25,player.turn/50000) and w.reload>0 then
            w.desig="IC "&w.desig
            w.heatsink=w.heatsink+2
        endif
        w.p=w.p+w.heatsink*250
        return w
    else 
        return w2 'return empty weapon instead of last if not found
    endif
end function

function removeequip() as short
    dim a as short
    for a=0 to lastitem
        if item(a).w.s<0 then item(a).w.s=-1
    next
    return 0
end function

function display_item_list(inv() as _items, invn() as short, marked as short, l as short,x as short,y as short) as short
    dim as short last,i,longest,ll,wh
    static offset as short
    screenset 0,1
    last=ubound(inv)
    
    for i=1 to l
        if len(trim(inv(i).desig))>longest then longest=len(trim(inv(i).desig))
        if len(trim(inv(i).desigp))>longest then longest=len(trim(inv(i).desigp))
    next
    for i=1 to last
        if invn(i)<>0 then ll+=1
    next
    if ll>20 then
        wh=20
    else
        wh=ll
    endif
    longest=longest+5
    'Format: invn=1 1 piece, invn>1 plural invn<1 Headline, text color white
    if marked+offset>wh then offset=wh-marked
    if marked+offset<1 then offset=1-marked
    if marked+offset=1 and invn(marked-1)<0 then offset+=1
    for i=1 to wh
        if i-offset>=0 and i-offset<=last then
            set__color(1,1)
            draw string(x*_fw2,(y+i)*_fh2),space(longest),,font2,custom,@_col
            if marked=i-offset then 
                set__color(15,5)
            else
                set__color(11,1)
            endif
            select case invn(i-offset)
            case 1
                draw string(x*_fw2,(y+i)*_fh2),"  "&trim(inv(i-offset).desig),,font2,custom,@_col
            case is>1
                draw string(x*_fw2,(y+i)*_fh2),"  "&invn(i-offset) &" "&trim(inv(i-offset).desigp),,font2,custom,@_col
                
            case is<1
                set__color(15,1)
                draw string(x*_fw2,(y+i)*_fh2)," "&trim(inv(i-offset).desig),,font2,custom,@_col
            end select
        endif
        if ll>wh then scroll_bar(-offset,ll,wh,wh-1,(x+longest)*_fw2,y*_fh2+_fh2,11)
    next
    flip
    return 0
end function

function next_item(c as integer) as integer
    dim i as short
    for i=0 to lastitem
        if i<>c then
            if item(i).w.s<0 and item(i).id=item(c).id and item(i).ty=item(c).ty and item(c).ty<>15 then
                return i
            endif
        endif
    next
    return -1
end function

function uid_pos(uid as uinteger) as integer
    dim i as integer
    for i=0 to lastitem
        if item(i).uid=uid then return i
    next
    return 0
end function

function get_item_list(invit() as _items, invnit()as short,ty as short=0,ty2 as short=0,ty3 as short=0,ty4 as short=0,noequip as short=0) as short
    dim as short b,a,set,lastinv,lastinv2,swapflag,tylabel,c,f,debug,equipnum(1024),isequipment
    dim as _items inv(ubound(invit))
    dim as Short invn(ubound(invit))
    if noequip=1 then
        noequip=0
        for a=0 to 128
            if crew(a).blad>0 then
                noequip+=1
                equipnum(noequip)=crew(a).blad
            endif
            if crew(a).weap>0 then
                noequip+=1
                equipnum(noequip)=crew(a).weap
            endif
            if crew(a).armo>0 then
                noequip+=1
                equipnum(noequip)=crew(a).armo
            endif
            if crew(a).pref_lrweap>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_lrweap)
            endif
            if crew(a).pref_ccweap>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_ccweap)
            endif
            if crew(a).pref_armor>0 then
                noequip+=1
                equipnum(noequip)=uid_pos(crew(a).pref_armor)
            endif
        next
        for a=0 to lastitem
            if item(a).w.s=-2 then 
                noequip+=1
                equipnum(noequip)=a
            endif
        next
    endif
        
    for a=0 to lastitem
        
        if item(a).w.s<0 and ((ty=0 and ty2=0 and ty3=0 and ty4=0) or (item(a).ty=ty or item(a).ty=ty2 or item(a).ty=ty3 or item(a).ty=ty4)) then 'Item on ship
            isequipment=0
            if noequip>0 then
                for b=1 to noequip
                    if equipnum(b)=a then isequipment=1
                next
            endif
            if not(isequipment=1 and noequip=1) then 
                set=0
                if lastinv>0 then
                    for b=1 to lastinv 'Look if we already have one
                        if a<>inv(b).w.s then
                            
                            if inv(b).id=item(a).id and inv(b).ty=item(a).ty and item(a).ty<>15 and item(a).ty<>88 then
                               
                               invn(b)+=1
                               if _debug=1 and debug=22 then inv(b).desigp &=a
                               set=1
                               if _debug=1 and debug=22 then
                                   f=freefile
                                   open "itemadded.txt" for append as #f
                                   print #f,a &";"& b &";"& item(a).desig  &";"& item(a).id &"invn"&invn(b)&"�"& inv(b).desig
                                   close #f
                                endif
                            endif
                            if item(a).ty=15 then 'Resouces
                                if inv(b).ty=15 and inv(b).v2=item(a).v2 and inv(b).v1=item(a).v1 then
                                    invn(b)+=1
                                    set=1
                                endif
                            endif
                            if item(a).ty=88 then 'Teleporter
                                if inv(b).v1=item(a).v1 and inv(b).v2=item(a).v2 and inv(b).v3=item(a).v3 then
                                    invn(b)+=1
                                    set=1
                                endif
                            endif
                        endif
                    next
                endif
                if set=0 then
                    lastinv+=1
                    inv(lastinv)=item(a)
                    inv(lastinv).w.s=a
                    invn(lastinv)=1 
                endif
            endif
        endif
        if debug=22 and _debug=1 then
            f=freefile
            open "GILitems.txt" for append as #f
            print #f,"Turn "&a
            for c=1 to lastinv
                print #f,c &";"& inv(c).desig &";"&invn(c)
            next
            close #f
        endif
    next
    if _debug=1 and debug=22 then
       f=freefile
       open "itemadded.txt" for append as #f
       print #f,"####"
       for a=1 to lastinv
            print #f,a &";"& inv(a).desig  &";"& inv(a).id &"invn"&invn(a)
       next
       print #f,"####"
       close #f
    endif
        
    for a=1 to lastinv
        if inv(a).ty=2 then 
            inv(a).desig &=" [A:"&inv(a).v3 &" D:"&inv(a).v1 &" R:"&inv(a).v2 &"]"
            inv(a).desigp &=" [A:"&inv(a).v3 &" D:"&inv(a).v1 &" R:"&inv(a).v2 &"]"
        endif
        if inv(a).ty=4 then
            inv(a).desig &=" [A:"&inv(a).v3 &" D:"&inv(a).v1  &"]"
            inv(a).desigp &=" [A:"&inv(a).v3 &" D:"&inv(a).v1  &"]"
        endif
        if inv(a).ty=3 or inv(a).ty=103 then 
            inv(a).desig &=" [PV:"&inv(a).v1 &"]"
            inv(a).desigp &=" [PV:"&inv(a).v1 &"]"
        endif
        if inv(a).ty=15 then 
            inv(a).desig &=" ["&inv(a).v2*3 &" kg]"
            inv(a).desigp &=" ["&inv(a).v2*3 &" kg]"
        endif
    next
    
    for b=1 to 11
        swapflag=0
        for a=1 to lastinv
            if check_item_filter(inv(a).ty,b) then
                swapflag=1
                exit for
            endif
        next
        if swapflag=1 then
            c+=1
            invit(c).desig=itemcat(b)
            invnit(c)=-1
            for a=1 to lastinv
                if check_item_filter(inv(a).ty,b) then
                    c+=1
                    invit(c)=inv(a)
                    invnit(c)=invn(a)
                    if _debug=1 and debug=22 then
                       f=freefile
                       open "itemadded.txt" for append as #f
                       print #f,c &";"& invit(c).desig  &"; invn"&invnit(c)
                       close #f
                    endif
                endif
            next
        endif
    next
    if _debug=1 and debug=22 then dprint "lastinv:"&lastinv &":"&c
    return c
end function


function check_item_filter(t as short,f as short) as short
    dim as short r,reverse
    reverse=11
    if f=0 then return 1
    if f<=4 or f=reverse then
        if t=f or (f=reverse and t<=4) then
            r=1
        endif
    endif
    if f=3 and t=103 then r=1 'Squidsuit
    if f=5 or f=reverse then
        if t=11 or t=19 or t=13 or t=30 then
            r=1
        endif
    endif
    if f=6 or f=reverse then
        if t=7 then
            r=1
        endif
    endif
    if f=7 or f=reverse then
        if t=23 then
            r=1
        endif
    endif
    if f=8 or f=reverse then
        if t=15 then
            r=1
        endif
    endif
    if f=9 or f=reverse then
        if t=88 or t=77 or t=50 or t=49 or t=48 or t=42 or t=41 or t=27 or t=18 or t=17 or t=16 or t=14 or t=12 or t=10 or t=9 or t=8 or t=5 then r=1
    endif
    if f=10 or f=reverse then
        if t=51 or t=52 or t=53 or t=21 or t=36 or t=40 or t=41 or t=25 then r=1
    endif
    if f=reverse then
        if r=0 then
            r=1
        else
            r=0
        endif
    endif
    
    return r
end function


function getrnditem(fr as short,ty as short) as short
    dim as short a,i,lst
    dim list(1048) as short
    for a=0 to lastitem
        if item(a).w.s=fr then
            if (ty>0 and item(a).ty=ty) or ty=0 then
                lst=lst+1
                if lst>1048 then lst=rnd_range(1,1048)
                list(lst)=a
            endif
        endif
    next
    if lst>1048 then lst=1048
    if lst>0 then
        i=list(rnd_range(1,lst))
    else 
        i=-1
    endif
    return i
end function

function get_item(ty as short=0,ty2 as short=0,byref num as short=0,noequ as short=0) as short
    dim as short last,marked,i,c,debug,j
    dim as _items inv(1024)
    dim as short invn(1024)
    dim as string key,helptext
    debug=1
    i=1
    if debug=1 and _debug=1 then dprint "Getting itemlist:ty:"&ty &"ty2"&ty2
    last=get_item_list(inv(),invn(),,,,,noequ)
    if ty<>0 or ty2<>0 then
        marked=1
        do
            if invn(i)<0 then
                for j=i to last
                    invn(j)=invn(j+1)
                    inv(j)=inv(j+1)
                next
                c+=1
            endif
            if inv(i).ty<>ty and inv(i).ty<>ty2 and inv(i).ty<>0 then
                if debug=1 and _debug=1 then dprint "Removing "&inv(i).desig
                for j=i to last
                    invn(j)=invn(j+1)
                    inv(j)=inv(j+1)
                next
                c+=1
            else
                i+=1
            endif
        loop until i>last
        if debug=1 and _debug=1 then dprint "removed "&c &" items" &last-c
        last-=c
        if last=1 then return inv(last).w.s
        if last<=0 then return -1
    endif
    if marked=0 then
        do
            
            marked+=1
            if marked>last then marked=0
        loop until invn(marked)>0
    endif
    do
        display_item_list(inv(),invn(),marked,last,2,2)
        helptext=inv(marked).describe
        if inv(marked).ty=26 then helptext=helptext & caged_monster_text
        c=textbox(helptext,22,2,25,11,1)
        key=keyin(key_north &key_south)
        for i=0 to c
            draw string (22*_fw1,2*_fh1+i*_fh2),space(25),,font2,custom,@_col
        next
        if key=key_north then
            do
                marked-=1
                if marked<1 then marked=last
            loop until invn(marked)>0
        endif
        if key=key_south then
            do
                marked+=1
                if marked>last then marked=1
            loop until invn(marked)>0
        endif
    loop until key=key__enter or key=key__esc
    if key=key__enter then
        
        num=invn(marked)
        return inv(marked).w.s
    else
        return -1
    endif
end function
'    dim as short i,offset,a,b,c,li,cu,set,k,filter,l,c2,lasttb
'    dim i_fs(11) as string
'    dim mls(255) as string 'needed to append name
'    dim mdesc(255) as string 'Needed to append desc
'    dim mno(255) as short
'    dim mit(255) as short
'    dim lin(20) as string
'    dim it(20) as short
'    dim as string key,mstr
'    i_fs(0)="None"
'    i_fs(1)="Transport"
'    i_fs(2)="Ranged Weapons"
'    i_fs(3)="Armor"
'    i_fs(4)="Close combat weapons"
'    i_fs(5)="Medical supplies"
'    i_fs(6)="Grenades"
'    i_fs(7)="Artwork"
'    i_fs(8)="Resources"
'    i_fs(9)="Equipment"
'    i_fs(10)="Space ship equipment"
'    i_fs(11)="All other"
'    for a=0 to lastitem
'        if (((fr=999 and item(a).w.s<0) or item(a).w.s=fr) and (item(a).ty=ty or (ty2>0 and item(a).ty=ty2) or ty=999)) then 'fr=999 means 
'            set=0
'            for c=0 to li
'                if item(a).desig=item(mit(c)).desig and item(a).v1=item(mit(c)).v1 and item(a).v2=item(mit(c)).v2 and item(a).v3=item(mit(c)).v3 then
'                    set=1
'                    mno(c)=mno(c)+1
'                endif
'            next
'            if set=0 and b<256 then
'                b=b+1
'                li=li+1
''                mls(b)=item(a).desig
''                mdesc(b)=item(a).ldesc
''                mls(b)=mls(b)
'                mit(b)=a
'                mno(b)=mno(b)+1
'            endif
'        endif
'    next
'    
'    
'    
'    if li=0 then return -1
'    if li=1 and (fr=999 or ty=999) and forceselect=0 then return mit(1)
'    
'    cu=1
'    a=0
'    'Sort by value
'    dprint "Sorting by value"
'    do
'        a+=1
'        set=0
'        for b=1 to li-1
'            if item(mit(b)).ty>item(mit(b+1)).ty or _
'            (item(mit(b)).ty=item(mit(b+1)).ty and better_item(item(mit(b)),item(mit(b+1)))=1) then
'                swap mno(b),mno(b+1)
'                swap mit(b),mit(b+1)
'                set=1
'            endif
'        next
'    loop until set=0
'    
'    dprint "Sorting by filter"
'    
''    do
''        tylabel+=1
''        for a=0 to lastinv
''            if inv(a).ty=tylabel then
''                'Push down one
''                lastinv+=1
''                for b=lastinv to a+1 step -1
''                    invn(b)=invn(b-1)
''                    inv(b)=inv(b-1)
''                next
''                invn(a)=-1
''                'insert label
''                if tylabel<5 then
''                    inv(a).desig=itemcat(tylabel)
''                    tylabel+=1
''                else
''                    tylabel=126
''                    inv(a).desig=itemcat(5)
''                endif
''            endif
''        next
''    loop until tylabel>125
''    
'    'Sort by filter and add headlines
'    filter=0
'    do
'        filter+=1
'        for a=1 to li
'            if check_item_filter(item(mit(a)).ty,filter) then
'                'Push down
'                li+=1
'                for b=li+1 to a+1 step -1
'                    mno(b)=mno(b-1)
'                    mit(b)=mit(b-1)
'                next
'                if filter<=11 then
'                    mno(a)=-1
'                    mit(a)=filter
'                    filter+=1
'                else 
'                    filter=128
'                endif
'            endif
'        next
'    loop until filter>=128
'    
'    filter=0
'    
'    for a=1 to li
'        if mno(a)>1 then
'            mls(a)=" "&item(mit(a)).sdesc
'            mdesc(a)=item(mit(a)).ldesc
'        endif
'    next
'    
'    for a=1 to li
'        if item(mit(a)).ty=2 then mls(a)=" "&mls(a) &"[A:"&item(mit(a)).v3 &" D:"&item(mit(a)).v1 &" R:"&item(mit(a)).v2 &"]"
'        if item(mit(a)).ty=4 then mls(a)=" "&mls(a) &"[A:"&item(mit(a)).v3 &" D:"&item(mit(a)).v1  &"]"
'        if item(mit(a)).ty=3 then mls(a)=" "&mls(a) &"[PV:"&item(mit(a)).v1 &"]"
'        if item(mit(a)).w.m>0 and sysfrommap(item(mit(a)).w.m)>=0 then 
'            mls(a) =mls(a) &map(sysfrommap(item(mit(a)).w.m)).c.x &":"& map(sysfrommap(item(mit(a)).w.m)).c.y   
'        endif
'    next
'    
'    do
'        if k=8 then cu=cu-1
'        if k=2 then cu=cu+1
'        if mno(cu+offset)<0 then
'            if k=8 then cu=cu-1
'            if k=2 then cu=cu+1
'        endif    
'        if key=key_pageup then cu=cu-14
'        if key=key_pagedown then cu=cu+14
'        if cu<1 then 
'            if offset>0 then
'                offset=offset-1
'                cu=1
'            else 
'                cu=15
'                offset=li-15
'            endif
'        endif
'        if cu>15 and li>15 then 
'            if cu+offset>li then
'                cu=1
'                offset=0
'            else
'                offset=offset+1
'                cu=15
'            endif
'        endif
'        if filter<>0 then
'            if check_item_filter(item(mit(cu+offset)).ty,filter)<>1 then
'                if k<>2 and k<>8 then k=2
'                c2=cu+offset
'                do
'                    if k=8 or key=key_pageup then c2-=1
'                    if k=2 or key=key_pagedown then c2+=1
'                loop until check_item_filter(item(mit(c2)).ty,filter)=1 or c2<1 or c2>li
'                if c2>=1 and c2<=li then
'                    cu=c2-offset
'                    if cu>15 then 
'                        offset=c2-15
'                        cu=15
'                    endif
'                    if cu<1 then 
'                        offset=c2
'                        cu=1
'                    endif
'                else 'No item found, one step back to old position
'                    if k=8 then cu+=1
'                    if k=2 then cu-=1
'                endif
'            endif
'        endif
'        screenset 0,1
'        set__color( 15,0)
'        draw string (3*_fw1,3*_fh1), "Select item:",,font2,custom,@_col 
'        for l=0 to lasttb
'            set__color(0,0)
'            draw string (3*_fw1+41*_fw2,3*_fh1+l*_fh2),space(25),,font2,custom,@_col
'        next
'        if offset<0 then offset=0
'        if li>15 and offset>li-cu then offset=li-cu
'        if cu>li then 
'            cu=1
'            offset=0
'        endif
'        if cu<0 then cu=0
'        l=1
'        a=1
'        do
'            if mno(a+offset)<0 then
'                set__color(15,0)
'                draw string (3*_fw1,3*_fh1+l*_fh2),i_fs(mit(a+offset)),,font2,custom,@_col
'                l+=1
'                a+=1
'                set__color(11,0)
'            endif
'            if mls(a+offset)<>"" then
'                if check_item_filter(item(mit(a+offset)).ty,filter)=1 then
'                    set__color( 0,0)
'                    draw string (3*_fw1,3*_fh1+l*_fh2),space(35),,font2,custom,@_col
'                    
'                    if cu=a then
'                        lasttb=textbox(mdesc(a+offset),3+40*_fw2/_fw1,3,25,15,1)
'                        set__color( 15,5)
'                    else
'                        set__color( 11,0)
'                    endif
'                    if mno(a+offset)>1 then
'                        if item(mit(a+offset)).ty=15 then
'                            draw string (3*_fw1,3*_fh1+l*_fh2),mno(a+offset) & " " &item(mit(a+offset)).desigp &" ("& item(mit(a+offset)).desig &")",,font2,custom,@_col
'                        else
'                            draw string (3*_fw1,3*_fh1+l*_fh2),mno(a+offset) & " " &item(mit(a+offset)).desigp,,font2,custom,@_col
'                        endif
'                    else
'                        draw string (3*_fw1,3*_fh1+l*_fh2), trim(item(mit(a+offset)).desig),,font2,custom,@_col
'                    endif
'                    l+=1
'                endif
'                a+=1
'            endif
'        loop until l>15 or mls(a+offset)=""
'        set__color( 15,0)
'        if li>15 then 
'            draw string (3*_fw1,3*_fh1+20*_fh2), "[MORE]",,font2,custom,@_col 
'        endif
'        draw string (3*_fw1,3*_fh1+20*_fh2), "Return to select item, ESC to quit, " &key_filter & " to filter items ("&i_fs(filter) &")",,font2,custom,@_col
'        flip
'        key=keyin(key_filter)
'        k=getdirection(key)
'        if key=key_filter then 
'            filter=item_filter()
'            if filter<>0 then
'                if check_item_filter(item(mit(cu+offset)).ty,filter)=0 then
'                    for a=1 to li
'                        if check_item_filter(item(mit(a)).ty,filter)=1 then
'                            cu=a
'                            if cu>15 then
'                                offset=cu-15
'                                cu=15
'                            endif
'                            exit for
'                        endif
'                    next
'                endif
'            endif
'        endif
'        if cu>li then cu=li
'        if key=key__enter then i=cu+offset
'        if key=key__esc then i=-1
'        if player.dead<>0 then return -1
'        
'        
'    loop until i<>0
'    if i>0 then 
'        if mno(i)<2 then
'            i=mit(i)
'        else
'            i=first_unused(mit(i))
'        endif
'    endif
'    return i

function first_unused(i as short) as short
    dim as short a,debug
    
    if item_assigned(i)=0 then return i
    if debug=1 and _debug=1 then dprint "Item "&i &"assigned, looking for alternative"
    for a=0 to lastitem
        if item(a).w.s=-1 and a<>i then
            if item(a).id=item(i).id and item(a).ty=item(i).ty then
                if debug=1 and _debug=1 and item_assigned(a)=0 then dprint "Item " &a & "is alternative"
                if debug=1 and _debug=1 and item_assigned(a)>0 then dprint "Item " &a & "is used by"&item_assigned(a)-1
                if item_assigned(a)=0 then return a
            endif
        endif
    next
    if debug=1 and _debug=1 then dprint "No alt found"
    return i
end function

function item_assigned(i as short) as short
    dim as short j
    for j=0 to 128
        if crew(j).hp>0 then
            if item(i).ty=2 and crew(j).pref_lrweap=item(i).uid then return j+1
            if item(i).ty=4 and crew(j).pref_ccweap=item(i).uid then return j+1
            if item(i).ty=3 and crew(j).pref_armor=item(i).uid then return j+1
        endif
    next
    return 0
end function

function findbest_jetpack() as short
    dim as short r,i
    dim as single v3
    r=-1
    v3=20
    for i=0 to lastitem
        if item(i).ty=1 and item(i).v1=2 and item(i).w.s=-1 then
            if item(i).v3<v3 then 
                v3=item(i).v3
                r=i
            endif
        endif
    next
    return r
end function

function find_working_teleporter() as short
    dim as short i,j,k
    for i=1 to lastteleportdevice
        j=teleportdevices(i)
        if item(j).w.s=-2 and item(j).ty=88 then item(j).w.s=-1
    next

    If configflag(con_chosebest)=1 Then
        return get_item(88)
    EndIf
    do
        k=findbest(88,-1)
        if _debug>0 then dprint "K:"&k
        if k>0 then
            if _debug>0 then dprint "v2:"&item(k).v2
            if item(k).v2>=item(k).v1 then 
                return k
            else
                item(k).w.s=-2
            endif
        endif
    loop until k=-1
    return k
end function
    
function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
    dim as single a,b,r,v
    r=-1
    if awayteam.optoxy=1 and t=3 then b=999
    for a=1 to lastitem
        if p<>0 then
            if (item(a).w.s=p and item(a).ty=t) then
                if t<>3 or awayteam.optoxy=0 then
                    if item(a).v1>b then
                        r=a
                        b=item(a).v1
                    endif
                endif
                if id<>0 and item(a).ty=id then return a
                if t=3 then 
                    if awayteam.optoxy=1 then
                        v=item(a).v3*0.9*item(a).v1^2*2+item(a).v1/2
                        if v<b then
                            r=a
                            b=v
                        endif
                    endif
                    if awayteam.optoxy=2 then
                        if item(a).v3>b then
                            r=a
                            b=item(a).v3
                        endif
                    endif
                endif
            endif
        endif
        
        if m<>0 then
            if item(a).w.m=m and item(a).w.s=0 and item(a).w.p=0 and item(a).ty=t then
                if item(a).v1>b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
    next
    if id<>0 and r>0 then
        if item(r).id<>id then r=-1
    endif
    return r
end function


function findworst(t as short,p as short=0, m as short=0) as short
    dim as single a,b,r
    r=-1
    b=100
    for a=0 to lastitem
        if p<>0 then
            if item(a).w.s=p and item(a).ty=t then
                if item(a).v1<b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
        
        if m<>0 then
            if item(a).w.m=m and item(a).w.p=0 and item(a).ty=t then
                if item(a).v1<b then
                    r=a
                    b=item(a).v1
                endif
            endif
        endif
    next
    return r
end function

function lowest_by_id(id as short) as short
    dim as short i,best
    dim as single v,cur
    best=-1
    v=99
    for i=0 to lastitem
        if item(i).w.s<0 and item(i).id=id then
            cur=item(i).v1+item(i).v2+item(i).v3
            if cur<v then 
                best=i
                v=cur
            endif
        endif
    next
    return best
end function

function equipment_value() as integer
    dim i as short
    dim as integer m
    for i=0 to lastitem
        if item(i).w.s<0 then m+=item(i).price
    next
    return m
end function

function count_items(i as _items) as short
    dim as short j,r
    for j=0 to lastitem
        if item(j).w.s<0 and item(j).id=i.id and item(j).v1=i.v1 and item(j).v2=i.v2 and item(j).v3=i.v3 then r+=1
    next
    return r
end function

function better_item(i1 as _items,i2 as _items) as short
    dim as short i,l
'    if len(i1.desig)>len(i2.Desig) then 
'        l=len(i1.desig)
'    else
'        l=len(i2.desig)
'    endif
'    for i=1 to l-1
'        if asc(mid(i1.desig,i,1))>asc(mid(i2.desig,i,1)) then return 1
'    next
    if i1.v1+i1.v2+i1.v3+i1.v4+i1.v5>i2.v1+i2.v2+i2.v3+i2.v4+i2.v5 then return 1
    return 0
end function

function count_and_make_weapons(st as short) as short
    dim as short a,b,flag
    
    b=0
    for a=1 to 20
        if makew(a,st)<>0 then 
            b+=1
            wsinv(b)=make_weapon(makew(a,st))
        endif
    next
    
    do
        flag=0
        for a=1 to b-1
            if (wsinv(a).made>wsinv(a+1).made) or (wsinv(a).made=wsinv(a+1).made and wsinv(a).dam>wsinv(a+1).dam) then
                flag=1
                swap wsinv(a),wsinv(a+1)
            endif
        next
    loop until flag=0
    
    return b
end function

function findartifact(v5 as short) as short
            dim c as short
            dprint "After examining closely, your science officer has found an alien artifact."
            
            if all_resources_are=0 then
                if v5=0 then
                    c=rnd_range(1,25)
                    if c=2 or c=5 then
                        c=rnd_range(1,10)
                        if c=2 or c=5 then artflag(c)=1
                    endif
                else
                    c=v5
                endif
            else
                c=all_resources_are
            endif
            if c<0 or c>22 then c=rnd_range(1,25)
            if (skill_test(player.science(1),st_veryhard,"Examining artifact") and artflag(c)=0 and c<>2 and c<>5) or all_resources_are>0 then
                artflag(c)=1                
                artifact(c)
            else
                dprint "Science officer can't figure out what it is.",14
                reward(4)=reward(4)+1
            endif
            return 0
end function

function artifact(c as short) as short
    dim as short a,b,d,e,f
    dim text as string
    if c=1 then
        dprint "It is an improved fuel system!"
        player.equipment(se_fuelsystem)=5
        player.fueluse=0.5
    endif
    
    
    if c=3 then
        dprint "It is a very powerful portable scanner!"
        player.stuff(3)=2
    endif
    
    if c=4 then
        dprint "It is a disintegrator cannon!"
        artflag(4)=0                
        d=player.h_maxweaponslot
        text="Weapon Slots:/"
        for e=1 to d
            if player.weapons(e).desig="" then
                text=text & "-Empty-/"
            else
                text=text & player.weapons(e).desig & "/"
            endif
        next
        text=text+"exit"
        d=d+1
        do 
        f=menu(bg_awayteam,text)
            if player.weapons(f).desig<>"" then 
                if askyn("do you want to replace that weapon? (y/n)") then 
                    player.weapons(f)=make_weapon(66)
                    f=d
                endif
            else
                player.weapons(f)=make_weapon(66)
                f=d
            endif
        loop until f=d
        recalcshipsbays
        cls
    endif
    
    if c=6 then 
        dprint "It is an Improved ships engine!"
        player.engine=6
    endif
    if c=7 then 
        dprint "It is a powerful ships sensor array!"
        player.sensors=6
    endif
    if c=8 then
        dprint "These are cryogenic chambers. They are empty, but still working. You can easily install them on your ship."
        player.cryo=player.cryo+rnd_range(1,6)
        artflag(8)=0
    endif
    if c=9 then
        dprint "This is a portable Teleportation Device!"
        placeitem(make_item(303),0,0,0,0,-1)
        artflag(9)=0
    endif
    
    if c=10 then
        dprint "It is a portable air recycling system!"
        player.stuff(4)=2
    endif
    if c=11 then
        artflag(11)=0
        dprint "its a data crystal containing info on one of the systems in this sector"
        d=rnd_range(1,laststar)
        for e=1 to 9
            if map(d).planets(e)>0 then f=f+1
        next
        if map(d).discovered>=1 then
            dprint "But you have already discovered that system."
        else
            dprint "It is at "&cords(map(d).c) &". It is "&add_a_or_an(spectralname(map(d).spec),0)&" with " & f & " planets."  
            map(d).discovered=1
        endif
    endif 
    if c=12 then
        dprint "It's a ships cloaking device!"
        placeitem(make_item(87),0,0,0,-1)
        
    endif
    
    if c=13 then
        dprint "It's a special shield to protect ships from wormholes!"
    endif
    
    if c=14 then
        dprint "It's a powerful ancient bomb!"
        placeitem(make_item(301),0,0,0,0,-1)
        artflag(14)=0
    endif
    
    if c=15 then
        dprint "It's a portable cloaking device!"
        placeitem(make_item(302),0,0,0,0,-1)
    endif
    
    if c=16 then
        dprint "It's a device that allows to navigate wormholes!"
    endif
    
    if c=17 then
        dprint "It's a sophisticated piloting AI"
        add_member(20,0)
    endif
    
    if c=18 then
        dprint "It's a sophisticated gunner AI"
        add_member(21,0)
    endif
    
    if c=19 then
        dprint "It's a sophisticated science AI"
        add_member(22,0)
    endif
    
    if c=20 then
        dprint "It's a sophisticated medical AI"
        add_member(23,0)
    endif
    
    if c=21 then
        dprint "It's technical specifications on neutronium-production!"
    endif
    if c=22 then
        dprint "It's technical specifications how to build quantum-warheads!"
    endif
    
    if c=23 then
        dprint "It's a batch of hull repairing nanobots!"
    endif
    
    if c=24 then
        dprint "It's an ammo teleportation system!"
        player.reloading=1
    endif
    
    if c=25 then
        dprint "It's a wormhole generator!"
    endif
    
    return 0
end function

