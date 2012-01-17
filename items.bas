function rnd_item(t as short) as _items
    dim i as _items
    dim r as short
    dim items(25) as short
    if t=20 then 
        if rnd_range(1,100)<88 then
            t=rnd_range(1,4) 'weapons and armor
        else
            t=-1
            if rnd_range(1,100)<50 then
                i=makeitem(rnd_range(36,37))
            else
                i=makeitem(rnd_range(100,102))
            endif
        endif
    endif
    if t=21 then 
        t=rnd_range(1,9)
    endif
    
    
    if t=1 then i=makeitem(rnd_range(1,2)) 'transport
    if t=2 then i=makeitem(rnd_range(3,11)) 'ranged weapons
    if t=3 then i=makeitem(rnd_range(40,47)) 'close weapons
    if t=4 then 'Space suits 
        if rnd_range(1,100)<25 then
            i=makeitem(320)
        else
            i=makeitem(rnd_range(12,20)) 'Armor
        endif
    endif
    if t=5 then 
        if rnd_range(1,100)<10 then 
            if rnd_range(1,100)<50 then
                i=makeitem(rnd_range(78,80))
            else
                i=makeitem(rnd_range(82,84))
            endif
        else
            i=makeitem(rnd_range(21,39)) 'misc
        endif
    endif
    if t=6 then 'misc2 mining
        if rnd_range(1,100)<70 then
            i=makeitem(rnd_range(21,23)) 
        else
            i=makeitem(rnd_range(31,33))
        endif
        if rnd_range(1,100)<15 then i=makeitem(rnd_range(41,43))
    endif
    if t=7 then i=makeitem(rnd_range(31,33)) 'meds
    if t=8 then 
        if rnd_range(1,100)<50 then
            i=makeitem(rnd_range(36,37)) 'meds2
        else
            i=makeitem(rnd_range(31,33))
        endif
    endif
    if t=9 then 'weapons
        if rnd_range(1,100)<50 then
            i=makeitem(rnd_range(3,11)) 'meds2
        else
            i=makeitem(rnd_range(40,47))
        endif
    endif
    if t=10 then i=makeitem(rnd_range(50,52))'rovers
    if t=11 then 'all but weapons
        select case rnd_range(1,100)
            case 1 to 20
                i=makeitem(rnd_range(1,2))
            case 21 to 40
                i=makeitem(rnd_range(15,33))
            case 41 to 60
                i=makeitem(rnd_range(50,58))
            case 61 to 80
                i=makeitem(rnd_range(21,30))
            case 80 to 100
                i=makeitem(rnd_range(70,71))
            case else
                i=makeitem(77)
        end select 
    endif
    if t=12 then 'All but weapons and meds
        r=rnd_range(1,33)
        if r=1 then i=makeitem(1)
        if r=2 then i=makeitem(2)
        if r=3 then i=makeitem(21)
        if r=4 then i=makeitem(22)
        if r=5 then i=makeitem(23)
        if r=6 then i=makeitem(24)
        if r=7 then i=makeitem(25)
        if r=8 then i=makeitem(26)
        if r=9 then i=makeitem(27)
        if r=10 then i=makeitem(28)
        if r=11 then i=makeitem(29)
        if r=12 then i=makeitem(30)
        if r=13 then i=makeitem(38)
        if r=14 then i=makeitem(39)
        if r=15 then i=makeitem(48)
        if r=16 then i=makeitem(49)
        if r=17 then i=makeitem(50)
        if r=18 then i=makeitem(51)
        if r=19 then i=makeitem(52)
        if r=20 then i=makeitem(53)
        if r=21 then i=makeitem(54)
        if r=22 then i=makeitem(55)
        if r=23 then i=makeitem(59)
        if r=24 then i=makeitem(60)
        if r=25 then i=makeitem(70)
        if r=26 then i=makeitem(71)
        if r=27 then i=makeitem(72)
        if r=28 then i=makeitem(73)
        if r=29 then i=makeitem(77)
        if r=30 then i=makeitem(100)
        if r=31 then i=makeitem(101)
        if r=32 then i=makeitem(102)
    endif
    if t=21 then 'specialty shop exploration gear
        r=rnd_range(1,23)
        if r=1 then i=makeitem(49)
        if r=2 then i=makeitem(50)
        if r=3 then i=makeitem(51)
        if r=4 then i=makeitem(52)
        if r=5 then i=makeitem(53)
        if r=6 then i=makeitem(54)
        if r=7 then i=makeitem(55)
        if r=8 then i=makeitem(75)
        if r=9 then i=makeitem(76)
        if r=10 then i=makeitem(77)
        if r=11 then i=makeitem(78)
        if r=12 then i=makeitem(79)
        if r=13 then i=makeitem(80)
        if r=14 then i=makeitem(83)
        if r=15 then i=makeitem(84)
        if r=16 then i=makeitem(85)
        if r=18 then i=makeitem(100)
        if r=19 then i=makeitem(101)
        if r=20 then i=makeitem(102)
        if r=21 then i=makeitem(103)
        if r=17 then i=makeitem(104)
        if r=22 then i=makeitem(22)
        if r=23 then i=makeitem(23)
    endif
      
    if t=23 then 'Weapons
        select case rnd_range(1,100)
            case is<33 
                i=makeitem(rnd_range(3,20))
            case is>90 
                if rnd_range(1,100)<50 then
                    if rnd_range(1,100)<66 then
                        i=makeitem(rnd_range(106,107))
                    else
                        i=makeitem(rnd_range(24,25))
                    endif
                else
                    i=makeitem(rnd_range(59,61))
                endif
            case else
                i=makeitem(rnd_range(40,48))
        end select
    endif
    
    return i
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
    i.w.x=x
    i.w.y=y
    i.w.m=m
    i.w.p=p
    i.w.s=s
    i.discovered=show_allitems
    dim a as short
    if lastitem<25000 then 'Noch platz für neues
        lastitem=lastitem+1
        item(lastitem)=i
        item(lastitem).uid=lastitem
        return lastitem
    else
        for a=1 to lastitem 'Überschreibe erstes item das nicht im schiff und keine ressource
            item(a).uid=a
            if item(a).w.s>=0 and item(a).ty<>15 then
                item(a)=i
                return a
            endif
        next
    endif
    dprint "ITEM PLACEMENT ERROR!(lastitem="&lastitem &")",14
end function

function itemfilter() as short
    dim a as short
    a=menu("Item type:/Transport/Ranged weapons/Armor/Close combat weapons/Medical supplies/Grenades/Artwork/Resources/Equipment/Ship equipment/All Other/None/Exit","",20,2)
    if a>11 then a=0
    if a<0 then a=0
    return a
end function

function checkitemfilter(t as short,f as short) as short
    dim as short r,reverse,r1
    reverse=11
    if f=0 then return 1
    if f<=4 or f=reverse then
        if t=f or (f=reverse and t<=4) then
            r=1
        endif
    endif
    if f=5 or f=reverse then
        if t=11 or t=19 then
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
    if f=11 or f=reverse then
        if t=51 or t=52 or t=53 or t=21 or t=36 or t=40 or t=41 or t=25 then r=1
    endif
    r1=r
    if f=9 or f=reverse then
        if t=50 or t=49 or t=48 or t=42 or t=41 or t=27 or t=18 or t=17 or t=16 or t=14 or t=12 or t=10 or t=9 or t=8 or t=5 then r=1
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


function makeitem(a as short, mod1 as short=0,mod2 as short=0,prefmin as short=0) as _items
    dim i as _items
    dim as short f,roll,target
    if uid=4294967295 then 
        dprint "Can't make any more items!"
        return i
    endif
    
    uid=uid+1
    i.uid=uid
    
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
        i.v1=.1
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
        i.v1=.2
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
        i.v1=.3
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
        i.v1=.4
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
        i.v1=.5
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
        i.v1=.6
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
        i.v1=.7
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
        i.v1=.8
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
        i.v1=.9
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
        i.price=25
        i.res=10
    endif
    
    if a=12 then
        i.ti_no=2012
        i.id=12
        i.ty=3
        i.desig="ballistic suit"
        i.desigp="ballistic suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with ballistic cloth around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=3
        i.price=75
        i.res=25
    endif
    
    if a=13 then
        i.ti_no=2013
        i.id=13
        i.ty=3
        i.desig="full ballistic suit"
        i.desigp="full ballistic suits"
        i.ldesc="Your standard spacesuit, but completely covered in ballistic cloth."
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=4
        i.price=175
        i.res=25
    endif
    
    if a=14 then
        i.ti_no=2014
        i.id=14
        i.ty=3
        i.desig="protective suit"
        i.desigp="protective suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with hardened shells around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=5
        i.price=300
        i.res=25
    endif
    
    if a=15 then
        i.ti_no=2015
        i.id=15
        i.ty=3
        i.desig="full protective suit"
        i.desigp="full protective suits"
        i.ldesc="Your standard spacesuit, covered with hardened shells." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=6
        i.price=450
        i.res=25
    endif
    
    if a=16 then
        i.ti_no=2016
        i.id=16
        i.ty=3
        i.desig="fullerene suit"
        i.desigp="fullerene suits"
        i.ldesc="Your standard spacesuit made out of carbon fullerenes." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=7
        i.price=625
        i.res=25
    endif
    
    if a=17 then
        i.ti_no=2017
        i.id=17
        i.ty=3
        i.desig="combat armor"
        i.desigp="sets of combat armor"
        i.ldesc="A spacesuit covered in ablative plates." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=8
        i.price=825
        i.res=45
    endif
    
    if a=18 then
        i.ti_no=2018
        i.id=18
        i.ty=3
        i.desig="heavy combat armor"
        i.desigp="sets of heavy combat armor"
        i.ldesc="A spacesuit covered in ablative plates. Built in hydraulics increase the strength and speed of the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=9
        i.price=1050
        i.res=45
    endif
    
    if a=19 then   
        i.ti_no=2019              
        i.id=19
        i.ty=3
        i.desig="p. Forcefield"
        i.desigp="p. forcefields"
        i.ldesc="A small forcefield surrounds the wearer." 
        i.icon="&"
        i.col=2
        i.bgcol=0
        i.v1=11
        i.price=1300
        i.res=65
    endif    
         
    if a=20 then
        i.ti_no=2020
        i.id=20
        i.ty=3
        i.desig="layered p. forcefield"
        i.desigp="layered p. forcefields"
        i.ldesc="The ultimate in protective equipment. Several layered forcefields surround the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=13
        i.price=1575
        i.res=45
    endif
    
    
    if a=21 then
        i.ti_no=2021
        i.id=21
        i.ty=17
        i.desig="imp. air filters"
        i.desigp="imp. air filters"
        i.ldesc="Normal spacesuits have their own oxygen tank. Improved air filters attempt to supplement that with whatever is found in the surrounding atmosphere."
        i.icon="§"
        i.col=14
        i.v1=.3
        i.bgcol=0
        i.price=20
        i.res=25
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<50 then
                i.id=i.id+100
                i.desig="good "&i.desig
                i.desigp="good "&i.desigp
                i.v1=.4
                i.price=30
            else
                i.id=i.id+110
                i.desig="bad "&i.desig
                i.desigp="bad "&i.desigp
                i.v1=.2
                i.price=15
            endif
        endif
    endif   
    
    if a=22 then
        i.ti_no=2022
        i.id=22
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
        if rnd_range(1,100)<20 then
            if rnd_range(1,100)<50 then
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
        i.id=23
        i.ty=5
        i.desig="laser drill"
        i.desigp="laser drills"
        i.ldesc="like normal laserweapons, but they tradeoff damage dealt for a bigger area affected. The result: a convenient tunnel instead of a dead enemy." 
        i.v1=5
        i.icon="["
        i.col=8
        i.bgcol=0
        i.price=2500
        i.res=55
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                i.id=123
                i.desig="powerful "&i.desig
                i.desigp="powerful "&i.desigp
                i.v1=6
                i.price=3000
            else
                i.id=123
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=4
                i.price=2000
            endif
        endif
    endif
        
    if a=24 then
        i.ti_no=2024
        i.id=24
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
        i.id=25
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
        i.id=26
        i.ty=8
        i.desig="set of binoculars"
        i.desigp="sets of binoculars"
        i.ldesc="a handheld device for magnifiying far away objects."
        i.icon=":"
        i.col=7
        i.v1=2
        i.price=90
        i.res=15
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
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
        i.id=27
        i.ty=8
        i.desig="portable sensorset"
        i.desigp="portable sensorsets"
        i.ldesc="Added to a spacesuit this device enhances the sensor input, if you know how to read it." 
        i.icon=":"
        i.col=8
        i.v1=4
        i.price=500
        i.res=25
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
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
        i.id=28
        i.ty=9
        i.desig="helmet lamp"
        i.desigp="helmet lamps"
        i.icon=";"
        i.ldesc="A small lamp to lighten up dark places"
        i.col=7
        i.v1=3
        i.price=40
        i.res=35
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<50 then
                i.id=i.id+100
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=4
                i.price=50
            else
                i.id=i.id+110
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=2
                i.price=30
            endif
        endif
            
    endif
    
    if a=29 then
        i.ti_no=2029
        i.id=29
        i.ty=9
        i.desig="flood light"
        i.desigp="flood lights"
        i.ldesc="A set of strong lamps, shoulder mounted" 
        i.icon=";"
        i.col=14
        i.v1=6
        i.price=90
        i.res=55
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<50 then
                i.id=i.id+100
                i.desig="strong "&i.desig
                i.desigp="strong "&i.desigp
                i.v1=8
                i.price=100
            else
                i.id=i.id+110
                i.desig="weak "&i.desig
                i.desigp="weak "&i.desigp
                i.v1=5
                i.price=80
            endif
        endif
    endif
    
    if a=30 then
        i.ti_no=2030
        i.id=30
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
        i.id=31
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
        i.id=32
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
        i.id=33
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
        i.id=34
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
        i.id=35
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
        i.id=36
        i.ty=13
        i.desig="anaesthetics"
        i.desigp="anaesthetics"
        i.icon="'"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.col=13
        i.v1=10
        i.price=10
        i.res=5
    endif
    
    if a=37 then
        i.ti_no=2037
        i.id=37
        i.ty=13
        i.desig="strong anaesthetics"
        i.desigp="strong anaesthetics"
        i.ldesc="Most creatures fall unconcious if they eat one of these."
        i.icon="'"
        i.col=13
        i.v1=25
        i.price=50
        i.res=10
    endif
        
    if a=38 then
        i.ti_no=2038
        i.id=38
        i.ty=14
        i.desig="aux. oxygen tank"
        i.desigp="aux. oxygen tanks"
        i.icon="!"
        i.ldesc="A small tank to increase the oxygen supply of spacesuits. Several users can connect to one tank."
        i.col=15
        i.v1=50
        i.price=45
        i.res=65
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<50 then
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
        i.id=39
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
        i.id=40
        i.ty=4
        i.desig="combat knife"
        i.desigp="combat knifes"
        i.icon="("
        i.col=8
        i.v1=.2
        i.price=20
        i.ldesc="A short blade to stick into enemies."
        i.res=10
    endif
    
    if a=41 then
        i.ti_no=2041
        i.id=41
        i.ty=4
        i.desig="combat blade"
        i.desigp="combat blades"
        i.icon="("
        i.col=8
        i.v1=.3
        i.price=50
        i.ldesc="A long blade for piercing and slashing."
        i.res=15
    endif
    
    if a=42 then
        i.ti_no=2042
        i.id=42
        i.ty=4
        i.desig="vibro knife"
        i.desigp="vibro knives"
        i.icon="("
        i.col=8
        i.v1=.4
        i.price=90
        i.ldesc="A blade for slashing and piercing. Sawing motions increase damage."
        i.res=20
    endif

    if a=43 then
        i.ti_no=2043
        i.id=43
        i.ty=4
        i.desig="vibro blade"
        i.desigp="vibro blades"
        i.icon="("
        i.col=8
        i.v1=.5
        i.price=140
        i.ldesc="A wide blade connected to a gauntlet. Sawing motions increase damage."
        i.res=25
    endif
    
    if a=44 then
        i.ti_no=2044
        i.id=44
        i.ty=4
        i.desig="vibro sword"
        i.desigp="vibro swords"
        i.icon="("
        i.col=8
        i.v1=.6
        i.price=200
        i.ldesc="A long blade connected to a gauntlet. Sawing motions increase damage."
        i.res=35
    endif
    
    if a=45 then
        i.ti_no=2045
        i.id=45
        i.ty=4
        i.desig="mono blade"
        i.desigp="mono blades"
        i.icon="("
        i.col=8
        i.v1=.7
        i.price=270
        i.ldesc="A sturdy gauntlet ending in a blade a single molecule wide."
        i.res=45
    endif
    
     
    if a=46 then
        i.ti_no=2046
        i.id=46
        i.ty=4
        i.desig="mono sword"
        i.desigp="mono swords"
        i.icon="("
        i.col=8
        i.v1=.8
        i.price=350
        i.ldesc="A gauntlet with a long blade attached. It is a single molecule wide and heated to increase damage."
        i.res=55
    endif
    
    if a=47 then
        i.ti_no=2047
        i.id=47
        i.ty=4
        i.desig="combat gloves"
        i.desigp="combat gloves"
        i.icon="("
        i.col=8
        i.v1=.9
        i.price=440
        i.ldesc="A sturdy gauntlet, connected to plastic sleeves going up to the shoulders. Servos increase the wearers strength. mono blades connected to the fingers hurt opponents."
        i.res=65
    endif
    
    
    if a=48 then
        i.ti_no=2048
        i.id=48
        i.ty=17
        i.desig="grenade launcher"
        i.desigp="grenade launchers"
        i.icon="]"
        i.col=7
        i.v1=2
        i.price=500
        i.ldesc="A device to increase the range and improve the aim of grenades."
        i.res=55
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                i.v1=1
                i.price=400
                i.desig="weak grenade launcher"
            else
                i.v1=3
                i.price=800
                i.desig="powerful grenade launcher"
            endif
        endif
    endif
    
    if a=49 then
        i.ti_no=2049
        i.id=49
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
        i.id=50
        i.ty=18
        i.desig="simple rover"
        i.desigp="simple rovers"
        i.ldesc="A small wheeled robot to collect map data autonomously. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=192
        i.discovered=1
        i.v1=2
        i.v2=0
        i.v3=.5
        i.v4=1 'Speed
        i.vt.x=-1
        i.vt.y=-1
        i.price=600
        i.res=85
    endif
    
    if a=51 then
        i.ti_no=2051
        i.id=51
        i.ty=18
        i.desig="rover"
        i.desigp="rovers"
        i.ldesc="A small robot with 4 legs and decent sensors to collect map data autonomously. It can also operate under water. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.col=204
        i.discovered=1
        i.v1=3
        i.v2=1
        i.v3=.7
        i.v4=2
        i.vt.x=-1
        i.vt.y=-1
        i.price=1500
        i.res=90
    endif
        
    if a=52 then
        i.ti_no=2052
        i.id=52
        i.ty=18
        i.desig="improved rover"
        i.desigp="improved rovers"
        i.ldesc="A small robot with 6 legs, jets for flying short distances, and good sensors. It is used to collect map data autonomously. It can also operate under water and climb mountains. To use a rover drop it on a planet and collect it later"
        i.icon="X"
        i.discovered=1
        i.col=14
        i.v1=4
        i.v2=2
        i.v3=1
        i.v4=3
        i.vt.x=-1
        i.vt.y=-1
        i.price=3500
        i.res=95
    endif
    
    if a=53 then
        i.ti_no=2053
        i.id=53
        i.ty=27
        i.desig="simple mining robot"
        i.desigp="simple mining robot"
        i.ldesc="A small stationary robot, extracting small deposits and traces of ore from its immediate surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=54
        i.discovered=1
        i.v1=0
        i.v2=100
        i.v3=.25
        i.vt.x=-1
        i.vt.y=-1
        i.price=600
        i.res=85
    endif
    
    if a=54 then
        i.ti_no=2054
        i.id=54
        i.ty=27
        i.desig="mining robot"
        i.desigp="mining robot"
        i.ldesc="A small stationary robot, extracting and drilling small deposits and traces of ore from its surroundings, autonomously. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.col=60
        i.discovered=1
        i.v1=0
        i.v2=250
        i.v3=.5
        i.vt.x=-1
        i.vt.y=-1
        i.price=1500
        i.res=90
    endif
        
    if a=55 then
        i.ti_no=2055
        i.id=55
        i.ty=27
        i.desig="improved mining robot"
        i.desigp="improved mining robot"
        i.ldesc="A small stationary robot drilling for ore autonomously, collecting small deposits and traces of ore from the ground and atmosphere. To use a mining bot drop it on a planet and collect it later"
        i.icon="X"
        i.discovered=1
        i.col=66
        i.v1=0
        i.v2=500
        i.v3=1
        i.vt.x=-1
        i.vt.y=-1
        i.price=3500
        i.res=95
    endif
    
    if a=56 then
        i.ti_no=2056
        i.id=56
        i.ty=19
        i.desig="disease kit I"
        i.desigp="disease kits I"
        i.ldesc="A basic supply for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=2
        i.price=50
    endif
    
    
    if a=57 then
        i.ti_no=2057
        i.id=57
        i.ty=19
        i.desig="disease kit II"
        i.desigp="disease kits II"
        i.ldesc="A supply of drugs and diagnostic tools for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=4
        i.price=100
    endif
    
    if a=58 then
        i.ti_no=2058
        i.id=58
        i.ty=19
        i.desig="disease kit III"
        i.desigp="disease kits III"
        i.ldesc="Advanced diagnostic tools and drugs for the treatment of diseases." 
        i.icon="+"
        i.col=1
        i.bgcol=15
        i.v1=6
        i.price=150
    endif
    
    if a=59 then
        i.ti_no=2059
        i.id=59
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
        i.id=60
        i.ty=21
        i.desig="imp. mine"
        i.desigp="imp. mines"
        i.ldesc="A simple, small explosive device, triggered by proximity, blasting into the direction of the target."
        i.icon="'"
        i.col=13
        i.v1=10
        i.price=50
    endif
    
    if a=61 then
        i.ti_no=2061
        i.id=61
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
        i.id=62
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
        i.id=63
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
        i.id=64
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
        i.id=65
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
        i.id=65
        i.ty=20
        i.desig="debris from a destroyed mining robot"
        i.desigp="debris from destroyed mining robots"
        i.ldesc="broken rover"
        i.icon="X"
        i.col=8
        i.res=100
    endif
    
    if a=67 then
        i.ti_no=2067
        i.id=67
        i.ty=21
        i.desig="basic Infirmary"
        i.desigp="basic Infirmary"
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
        i.id=68
        i.ty=21
        i.desig="infirmary"
        i.desigp="infirmary"
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
        i.id=69
        i.ty=21
        i.desig="advanced Infirmary"
        i.desigp="advanced Infirmary"
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
        i.id=70
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
        i.id=71
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
        i.id=72
        i.ty=40
        i.desig="anti-ship mine"
        i.desigp="anti-ship mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="ö"
        i.col=7
        i.v1=5
        i.v2=3
        i.v3=75
        i.res=100
        i.price=50
    endif
    
    if a=73 then
        i.ti_no=2073
        i.id=73
        i.ty=40
        i.desig="anti-ship mine MKII"
        i.desigp="anti-ship mines MKII"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="ö"
        i.col=7
        i.v1=10
        i.v2=4
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=74 then
        i.ti_no=2074
        i.id=74
        i.ty=40
        i.desig="improvised mine"
        i.desigp="improvised mines"
        i.ldesc="a small device that explodes when in immediate vicinity of a ship"
        i.icon="ö"
        i.col=7
        i.v1=3
        i.v2=2
        i.v3=90
        i.res=100
        i.price=100
    endif
    
    if a=75 then
        i.ti_no=2075
        i.id=75
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
        i.id=76
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
        i.id=77
        i.ty=42
        i.desig="Ground penetrating radar"
        i.desigp="Ground penetrating radars"
        i.ldesc="A modified portable sensor set. Enables the user to see through walls"
        
        i.v1=2
        if rnd_range(1,100)<10 then
            
            if rnd_range(1,100)<60 then
                i.v1=3
                i.desigp="Good ground penetrating radar"
                i.desigp="Good ground penetrating radars"
            else
                i.v1=4
                i.desigp="Great ground penetrating radar"
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
        i.id=78
        i.ty=7
        i.desig="Flash Grenade"
        i.desigp="Flash Grenades"
        i.ldesc=""
        i.v1=66
        i.v2=1
        i.icon="."
        i.col=7
        i.res=80
        i.price=5
    endif
    
    if a=79 then 
        i.ti_no=2112
        i.id=79
        i.ty=7
        i.desig="Stun Grenade"
        i.desigp="Stun Grenades"
        i.ldesc=""
        i.v1=3
        i.v2=2
        i.icon="."
        i.col=7
        i.res=80
        i.price=20
    endif
    
    
    if a=80 then 
        i.ti_no=2112
        i.id=80
        i.ty=7
        i.desig="Imp. Stun Grenade"
        i.desigp="Imp. Stun Grenades"
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
        i.id=81
        i.ty=47
        i.desig="Id Tag"
        i.desigp="Id Tags"
        i.ldesc="An Id Tag of a spaceship crew member"
        i.v1=rnd_range(1,3)
        i.col=11
        i.res=89
        i.icon="?"
        i.price=0
    endif
    
    if a=82 then
        i.ti_no=2114
        i.ty=48
        i.desig="Autopsy kit"
        i.desigp="Autopsy kits"
        i.ldesc="Tools for analyzing alien corpses"
        i.v1=2
        i.col=0
        i.bgcol=15
        i.icon="+"
        i.price=250
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                i.desig="Small autopsy kit"
                i.desigp="Small autopsy kits"
                i.v1=1
                i.price=200
            else
                i.desig="Good autopsy kit"
                i.desigp="Good autopsy kits"
                i.v1=3
                i.price=300
            endif
        endif
    endif

    if a=83 then
        i.ti_no=2115
        i.ty=49
        i.desig="Botany kit"
        i.desigp="Botany kits"
        i.ldesc="A kit containing tools for advanced plant analysis"
        i.v1=2
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=250
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                i.desig="Small botany kit"
                i.desigp="Small botany kits"
                i.v1=1
                i.price=200
            else
                i.desig="Good botany kit"
                i.desigp="Good botany kits"
                i.v1=3
                i.price=300
            endif
        endif
    endif
    
    
    if a=84 then
        i.ti_no=2116
        i.ty=50
        i.desig="Ship repair kit"
        i.desigp="Ship repair kits"
        i.ldesc="A kit containing tools for ship repair"
        i.v1=2
        i.col=4
        i.bgcol=15
        i.icon="+"
        i.price=500
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                i.desig="Small ship repair kit"
                i.desigp="Small ship repair kits"
                i.v1=1
                i.price=250
            else
                i.desig="Good ship kit"
                i.desigp="Good ship kits"
                i.v1=3
                i.price=750
            endif
        endif
    endif
    
    if a=104 then
        i.ti_no=2117
        i.ty=56
        i.desig="MK I Gas mining probe"
        i.desig="MK I Gas mining probes"
        i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to 10 tons of fuel"
        i.v1=10 'Range
        i.v2=2 'Piloting Bonus
        i.v3=1 'HPs
        i.icon="s"
        i.col=12
        i.price=100
    
    endif
    
    if a=105 then
        i.ti_no=2117
        i.ty=56
        i.desig="MK II Gas mining probe"
        i.desig="MK II Gas mining probes"
        i.ldesc="A system for the automatic retrieval of fuel from gas giants. It can hold up to 25 tons of fuel"
        i.v1=25 'Range
        i.v2=0 'Piloting Bonus
        i.v3=1 'HPs
        i.icon="s"
        i.col=12
        i.price=200
    endif
    
    
    if a=106 then
        i.ti_no=2024
        i.id=24
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
        i.id=25
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
        i.desig="MK I Probe"
        i.desigp="MK I Probes"
        i.ldesc="A probe for deep space operation. It has a range of 5 parsecs and 1 HP"
        i.v1=5 'Range
        i.v2=1 'Scanning Range
        i.v3=1 'HPs
        i.v4=0 'HPs
        i.v5=2 'Speed
        i.icon="s"
        i.col=11
        i.price=100
    endif
    if a=101 then
        i.ti_no=2118
        i.ty=55
        i.desig="MK II Probe"
        i.desigp="MK II Probes"
        i.ldesc="A probe for deep space operation. It has a range of 7 parsecs and 2 HP"
        i.v1=7 'Range
        i.v2=2 'Scanning Range
        i.v3=2 'HPs
        i.v4=1 'HPs
        i.v5=3 'Speed
        i.icon="s"
        i.col=11
        i.price=250
    endif
    if a=102 then
        i.ti_no=2119
        i.ty=55
        i.desig="MK III Probe"
        i.desigp="MK III Probes"
        i.ldesc="A probe for deep space operation. It has a range of 10 parsecs and 3 HP"
        i.v1=10 'Range
        i.v2=3 'Scanning Range
        i.v3=3 'HPs
        i.v4=2 'HPs
        i.v5=6 'HPs
        i.icon="s"
        i.col=11
        i.price=500
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

'if a=81 then
'        i.ti_no=2003
'        i.id=81
'        i.ty=2
'        i.desig="Injector gun"
'        i.desitp="injector guns"
'        i.ldesc="A nonlethal weapon. It fires several small darts, filled with a drug paralyzing most lifeforms. It does negligable damage, but may incapacitate an opponent."
'        i.v1=.1
'        i.v2=2
'        i.v4=30
'    endif
'    
'    if a=82 then
'        i.ti_no=2003
'        i.id=79
'        i.ty=2
'        i.desig="Disruptor"
'        i.desigp="Disruptor"
'        i.ldesc="A nonlethal weapon. A strong magnetic field disrupts nerve signals in the target, leaving only minor damage, but stunning it."
'        i.v1=.1
'        i.v2=4
'        i.v4=30
'        i.icon="-"
'        i.col=7
'        i.res=80
'        i.price=80
'    endif
'    
'    if a=83 then
'        i.ty=4
'        i.desig="Electric baton"
'        i.v1=.1
'        i.v4=15
'    endif
'    
'    if a=84 then
'        i.desig="Sonic Mace"
'        i.v1=.1
'        i.v4=30
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
        if i.v2=2 then i.desig="an alien painting"
        if i.v2=3 then i.desig="pots of burnt clay"
        if i.v2=4 then i.desig="a religious idol"
        if i.v2=5 then i.desig="some well worked tools"
        if i.v2=6 then i.desig="a wooden box"
        if i.v2=7 then i.desig="a small clay statue"
        if i.v2=8 then i.desig="a small stone statue"
        if i.v2=9 then i.desig="a pretty painting"
        if i.v2=10 then i.desig="a hand written book"
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
        
        i.desigp="resources"
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
        
        if i.v2=6 then i.desig="osmodium"
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
        
        i.v5=(i.v1+rnd_range(1,player.science(0)+i.v2))*(rnd_range(1,5+player.science(0)))
        i.price=i.v5/10   
        i.res=i.v5*10         
        
        i.scanmod=rnd_range(0,i.v1)
        i.icon="*"
        i.bgcol=0  
        roll=rnd_range(1,100+player.turn/100+mod1+mod2)
        if roll>125 and mod1>0 and mod2>0 then i=makeitem(99,0,0)
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
        i.v1=1.2
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
            if rnd_range(1,100)<35 then i=makeitem(98)
            if rnd_range(1,100)<45 then i=makeitem(97)
            if rnd_range(1,100)<16 then i=makeitem(95)
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
        i.id=205
        i.ty=23
        i.desigp="pieces of alien art"
        i.col=14
        i.icon="?"
        i.v1=10
        i.v2=rnd_range(1,6)+rnd_range(1,6)
        i.v3=mod1
        i.desig="A " & civ(mod1).n & " artifact"
        i.price=i.v1*i.v2*20
        i.res=100
    endif
    
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
        i.id=301
        i.ty=46
        i.icon="'"
        i.col=11
        i.desig="handheld cloaking device"
        i.desigp="handheld cloaking device"
        i.v1=7
        i.res=120
        i.price=2000
    endif
    
    
    
    i.discovered=show_items
    
    'if i.desig="" or i.desigp="" then dprint "ERROR: Item #" &a &" does not exist.",14,14
    i=modify_item(i)
    return i
    
end function

function modify_item(i as _items) as _items
    dim as short a
    a=i.id
    if i.id>=12 and i.id<=18 and rnd_range(1,100)<10 then
        if rnd_range(1,100)<50 then
            i.desig="thick "&i.desig
            i.desigp="thick "&i.desigp
            i.id=i.id+100
            i.v1=i.v1+1
            i.price=i.price*1.2
        else
            if i.v1>1 then
                i.desig="old "&i.desig
                i.desigp="old "&i.desigp
                i.id=i.id+110
                i.v1=i.v1-1
                i.price=i.price*0.8
            endif
        endif
    endif
    
    if i.id>=12 and i.id<=20 then
        if rnd_range(1,100)<10+a then
            if rnd_range(1,100)<66 then
                i.desig="camo "&i.desig
                i.desigp="camo "&i.desigp
                i.v2=1
                i.id=i.id+110
                i.price=i.price*1.1
            else
                i.desig="imp. camo "&i.desig
                i.desigp="imp. camo "&i.desigp
                i.id=i.id+120
                i.v2=3
                i.price=i.price*1.25
            endif
        endif
        if rnd_range(1,100)<15 then
            if rnd_range(1,100)<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.price=i.price*1.25
            endif
        endif
        i.ldesc=i.ldesc &" | | Armor Value: "&i.v1
    endif
    
    if i.id>=3 and i.id<=11 then
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)<75 then
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
                if rnd_range(1,100)<75 then
                    i.desig="powerful "&i.desig
                    i.desigp="powerful "&i.desigp
                    i.id=i.id+120
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="very powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+130
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        if rnd_range(1,100)<15 then
            if rnd_range(1,100)<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.price=i.price*1.25
            endif
        endif
        i.ldesc=i.ldesc &"  | | Accuracy: "&i.v3 &" | Damage: "&i.v1 &" | Range:"&i.v2
    endif
    
    if i.id=1 then
        if rnd_range(1,100)<20 then
            if rnd_range(1,100)<50 then
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
    if i.id>=40 and i.id<=47 then
        if rnd_range(1,100)<10 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)<75 then
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
                if rnd_range(1,100)<75 then
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
        if rnd_range(1,100)<15 then
            if rnd_range(1,100)<75 then
                i.desig="sturdy "&i.desig
                i.desigp="sturdy "&i.desigp
                i.res=i.res+50
                i.price=i.price*1.1
            else
                i.desig="acidproof "&i.desig
                i.desigp="acidproof "&i.desigp
                i.res=i.res+100
                i.price=i.price*1.25
            endif
        endif
        i.ldesc=i.ldesc &" | | Accuracy: "&i.v3 &" | Damage: "&i.v1
    endif
    
    if i.id=49 then
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<50 then
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
        if rnd_range(1,100)<33 then
            if rnd_range(1,100)<50 then
                if rnd_range(1,100)<50 then
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
                if rnd_range(1,100)<50 then
                    i.desig="powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+102
                    i.v1=i.v1+.1
                    i.price=i.price*1.2
                else
                    i.desig="powerful "&i.desig
                    i.desigp="very powerful "&i.desigp
                    i.id=i.id+103
                    i.v1=i.v1+.2
                    i.price=i.price*1.5
                endif
            endif
        endif
        i.ldesc=i.ldesc &" | | Accuracy: "&i.v3 &" | Damage: "&i.v1 &" | Range:"&i.v2
    
    endif
    if i.id=98 then 
        if rnd_range(1,100)<30 then
            if rnd_range(1,100)<5 then
                if rnd_range(1,100)<50 then
                    i.desig="thick "&i.desig
                    i.desigp="thick "&i.desigp
                    i.id=i.id+100
                    i.v1=i.v1+1
                    i.price=i.price*1.5
                else
                    i.desig="tattered "&i.desig
                    i.desigp="tattered "&i.desigp
                    i.id=i.id+101
                    i.v3=i.v3-1
                    i.price=i.price*0.75
                endif
            endif
        endif
        i.ldesc=i.ldesc &" | | Armor Value: "&i.v1
    endif
    return i
end function



function removeequip() as short
    dim a as short
    for a=1 to lastitem
        if item(a).w.s<0 then item(a).w.s=-1
    next
    return 0
end function


function getitemlist(inv() as _items, invn()as short,ty as short=0) as short
    dim as short b,a,set,lastinv
    for a=0 to lastitem
        if item(a).w.s<0 and (ty=0 or item(a).ty=ty) then 'Item on ship
            set=0
            for b=0 to lastinv
                if inv(b).id=item(a).id then
                   invn(b)=invn(b)+1
                   set=1
                endif
            next
            if set=0 then
                inv(lastinv)=item(a)
                invn(lastinv)=1
                lastinv=lastinv+1                
            endif
        endif
    next
    for a=0 to lastinv
        for b=0 to lastinv-2 
            if inv(b).ty>inv(b+1).ty or (inv(b).ty=inv(b+1).ty and better_item(inv(b),inv(b+1))=1) then 
                swap inv(b),inv(b+1)
                swap invn(b),invn(b+1)
            endif
        next
    next
    return lastinv
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

function getitem(fr as short=999,ty as short=999,forceselect as byte=0,ty2 as short=0) as short
    dim as short i,offset,a,b,c,li,cu,set,k,filter,l,c2
    dim i_fs(11) as string
    dim mls(255) as string
    dim mdesc(255) as string
    dim mno(255) as short
    dim mit(255) as short
    dim lin(20) as string
    dim it(20) as short
    dim as string key,mstr
    i_fs(0)="None"
    i_fs(1)="Transport"
    i_fs(2)="Ranged Weapons"
    i_fs(3)="Armor"
    i_fs(4)="Close combat weapons"
    i_fs(5)="Medical supplies"
    i_fs(6)="Grenades"
    i_fs(7)="Artwork"
    i_fs(8)="Resources"
    i_fs(9)="Equipment"
    i_fs(10)="Space ship equipment"
    i_fs(11)="All other"
    for a=0 to lastitem
        if (((fr=999 and item(a).w.s<0) or item(a).w.s=fr) and (item(a).ty=ty or (ty2>0 and item(a).ty=ty2) or ty=999)) then 'fr=999 means 
            set=0
            for c=0 to li
                if item(a).desig=item(mit(c)).desig and item(a).v1=item(mit(c)).v1 and item(a).v2=item(mit(c)).v2 and item(a).v3=item(mit(c)).v3 then
                    set=1
                    mno(c)=mno(c)+1
                endif
            next
            if set=0 and b<256 then
                b=b+1
                li=li+1
                mls(b)=item(a).desig
                mdesc(b)=item(a).ldesc
                mls(b)=mls(b)
                mit(b)=a
                mno(b)=mno(b)+1
            endif
        endif
    next
    
    
    
    if li=0 then return -1
    if li=1 and (fr=999 or ty=999) and forceselect=0 then return mit(1)
    cu=1
    a=0
    do
        a+=1
        set=0
        for b=1 to li-1
            if item(mit(b)).ty>item(mit(b+1)).ty or (item(mit(b)).ty=item(mit(b+1)).ty and better_item(item(mit(b)),item(mit(b+1)))=1) then
                swap mno(b),mno(b+1)
                swap mls(b),mls(b+1)
                swap mit(b),mit(b+1)
                swap mdesc(b),mdesc(b+1)
                set=1
            endif
        next
    loop until set=0 or a>lastitem
    for a=1 to li
        if item(mit(a)).ty=2 then mls(a)=mls(a) &"[A:"&item(mit(a)).v3 &" D:"&item(mit(a)).v1 &" R:"&item(mit(a)).v2 &"]"
        if item(mit(a)).ty=4 then mls(a)=mls(a) &"[A:"&item(mit(a)).v3 &" D:"&item(mit(a)).v1  &"]"
        if item(mit(a)).ty=3 then mls(a)=mls(a) &"[PV:"&item(mit(a)).v1 &"]"
    next
    
    do
        if k=8 then cu=cu-1
        if k=2 then cu=cu+1
        if key=key_pageup then cu=cu-14
        if key=key_pagedown then cu=cu+14
        if cu<1 then 
            if offset>0 then
                offset=offset-1
                cu=1
            else 
                cu=15
                offset=li-15
            endif
        endif
        if cu>15 and li>15 then 
            if cu+offset>li then
                cu=1
                offset=0
            else
                offset=offset+1
                cu=15
            endif
        endif
        if filter<>0 then
            if checkitemfilter(item(mit(cu+offset)).ty,filter)<>1 then
                if k<>2 and k<>8 then k=2
                c2=cu+offset
                do
                    if k=8 or key=key_pageup then c2-=1
                    if k=2 or key=key_pagedown then c2+=1
                loop until checkitemfilter(item(mit(c2)).ty,filter)=1 or c2<1 or c2>li
                if c2>=1 and c2<=li then
                    cu=c2-offset
                    if cu>15 then 
                        offset=c2-15
                        cu=15
                    endif
                    if cu<1 then 
                        offset=c2
                        cu=1
                    endif
                else 'No item found, one step back to old position
                    if k=8 then cu+=1
                    if k=2 then cu-=1
                endif
            endif
        endif
        set_color( 15,0)
        draw string (3*_fw1,3*_fh1), "Select item:",,font2,custom,@_col 
        if offset<0 then offset=0
        if li>15 and offset>li-cu then offset=li-cu
        if cu>li then 
            cu=1
            offset=0
        endif
        if cu<0 then cu=0
        l=1
        a=1
        do
            if mls(a+offset)<>"" then
                if checkitemfilter(item(mit(a+offset)).ty,filter)=1 then
                    set_color( 0,0)
                    draw string (3*_fw1,3*_fh1+l*_fh2),space(35),,font2,custom,@_col
                    if cu=a then
                        textbox(mdesc(a+offset),3+40*_fw2/_fw1,3,25,15,1)
                        set_color( 15,5)
                    else
                        set_color( 11,0)
                    endif
                    draw string (3*_fw1,3*_fh1+l*_fh2),mls(a+offset),,font2,custom,@_col
                    if mno(a+offset)>1 then draw string (3*_fw1,3*_fh1+l*_fh2),mls(a+offset) & "("&mno(a+offset) &")",,font2,custom,@_col
                    l+=1
                endif
                a+=1
            endif
        loop until l>15 or mls(a+offset)=""
        set_color( 15,0)
        if li>15 then 
            draw string (3*_fw1,3*_fh1+20*_fh2), "[MORE]",,font2,custom,@_col 
        endif
        draw string (3*_fw1,3*_fh1+20*_fh2), "Return to select item, ESC to quit, " &key_filter & " to filter items ("&i_fs(filter) &")",,font2,custom,@_col
        key=keyin(key_filter)
        k=getdirection(key)
        if key=key_filter then 
            filter=itemfilter()
            if filter<>0 then
                if checkitemfilter(item(mit(cu+offset)).ty,filter)=0 then
                    for a=1 to li
                        if checkitemfilter(item(mit(a)).ty,filter)=1 then
                            cu=a
                            if cu>15 then
                                offset=cu-15
                                cu=15
                            endif
                            exit for
                        endif
                    next
                endif
            endif
        endif
        if cu>li then cu=li
        if key=key_enter then i=cu+offset
        if key=key_esc then i=-1
        if player.dead<>0 then return -1
        cls
    loop until i<>0
    if i>0 then 
        if mno(i)<2 then
            i=mit(i)
        else
            i=first_unused(mit(i))
        endif
    endif
    return i
end function

function first_unused(i as short) as short
    dim as short a,debug
    debug=0
    if item_assigned(i)=0 then return i
    if debug=1 then dprint "Item "&i &"assigned, looking for alternative"
    for a=0 to lastitem
        if item(a).w.s<0 and a<>i then
            if item(a).desig=item(i).desig and item(a).v1=item(i).v1 and item(a).v2=item(i).v2 and item(a).v3=item(i).v3 then
                if debug=1 and item_assigned(a)=0 then dprint "Item " &a & "is alternative"
                if debug=1 and item_assigned(a)>0 then dprint "Item " &a & "is used by"&item_assigned(a)-1
                if item_assigned(a)=0 then return a
            endif
        endif
    next
    if debug=1 then dprint "No alt found"
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

function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
    dim as single a,b,r
    r=-1
    for a=0 to lastitem
        if p<>0 then
            if (item(a).w.s=p and item(a).ty=t) then
                if item(a).v1>b then
                    r=a
                    b=item(a).v1
                endif
                if id<>0 and item(a).ty=id then return a
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
    for i=1 to lastitem
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

function count_items(i as _items) as short
    dim as short j,r
    for j=1 to lastitem
        if item(j).w.s<0 and item(j).id=i.id and item(j).v1=i.v1 and item(j).v2=i.v2 and item(j).v3=i.v3 then r+=1
    next
    return r
end function

function better_item(i1 as _items,i2 as _items) as short
    dim as short i,l
    if len(i1.desig)>len(i2.Desig) then 
        l=len(i1.desig)
    else
        l=len(i2.desig)
    endif
    for i=1 to l-1
        if asc(mid(i1.desig,i,1))>asc(mid(i2.desig,i,1)) then return 1
    next
    if i1.v1+i1.v2+i1.v3+i1.v4+i1.v5>i2.v1+i2.v2+i2.v3+i2.v4+i2.v5 then return 1
    return 0
end function


function buyweapon(st as short) as _ship
    dim as short a,b,c,d,i,mod1,mod2,mod3,mod4
    dim as short last
    dim inv(20) as _weap
    dim weapons as string
    dim key as string
    dim wmenu as string
    dim help as string
    for a=1 to 20
        if makew(a,st)<>0 then 
            i+=1
            inv(i)=makeweapon(makew(a,st))
        endif
    next
    
    weapons="Weapons:"
    for a=1 to i
        weapons=weapons &"/ " &inv(a).desig &" - "&inv(a).p 
        help=help &"/ "&inv(a).desig &" | | "    
        if makew(a,st)=1 then help=help &"A simple gun firing metal shells propelled by an explosion. "
        if makew(a,st)=2 then help=help &"Metal shells accelerated to high speeds using electric fields "
        if makew(a,st)=3 then help=help &"Self propelled rockets with chemical explosives"
        if makew(a,st)=4 then help=help &"Self propelled rockets with nuclear warheads"
        if makew(a,st)=5 then help=help &"Self propelled rockets with nuclear warheads and increased range"
        if makew(a,st)=6 then help=help &"Ionized hydrogen. Low impact damage, low penetration. A targetable ships drive basically"
        if makew(a,st)=7 then help=help &"Lasers burn through the enemys ships armor"
        if makew(a,st)=8 then help=help &"Higher energy per particle increases the damage of a Laser"
        if makew(a,st)=9 then help=help &"Bremsstrahlung wreaks havocs inside the target even if the particles don't penetrate the hull."
        if makew(a,st)=10 then help=help &"Heavy particles accelerated to near light speeds penetrate and rip apart the enemys armor."
        if makew(a,st)=11 then help=help &"Several light ship guns combined into a battery. "
        if makew(a,st)=12 then help=help &"Several light rail guns combined into a battery "
        if makew(a,st)=13 then help=help &"Several light rockets combined into a battery "
        if makew(a,st)=14 then help=help &"Several rockets combined into a battery "
        if makew(a,st)=85 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
        if makew(a,st)=86 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
        if makew(a,st)=87 then help=help &"Sacrifices a weapon turret to install additional armor | | +5 to HP"
        if makew(a,st)=88 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 4 points of heat dissipation"
        if makew(a,st)=89 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 8 points of heat dissipation"
        if makew(a,st)=90 then help=help &"An auxillary powerplant dedicated to the shield generator, improving their recharging rate. | | Shields recharge at 2 pts per round"
        if makew(a,st)=91 then help=help &"A small auxillary powerplant feeding energy weapons. | | +1 to energy weapons damage"
        if makew(a,st)=92 then help=help &"A large auxillary powerplant feeding energy weapons. | | +2 to energy weapons damage."
        if makew(a,st)=93 then help=help &"A second sensor array directly linked to weapons control | | +1 to hit in space combat"
        if makew(a,st)=94 then help=help &"A powerfull additional sensor array directly linked to weapons control | | +2 to hit in space combat"
        if makew(a,st)=95 then help=help &"A improved tractor beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes. It is more powerfull and sturdier than the normal Tractor beam."
        if makew(a,st)=96 then help=help &"A beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes."
        if makew(a,st)=97 then help=help &"A weapons turret modified to provide lving space. Holds up to 10 additional crewmembers"
        if makew(a,st)=98 then help=help &"Not the safest way to store fuel. It holds 50 tons"
        if makew(a,st)=99 then help=help &"A weapons turret modified to hold an additional ton of cargo."
        
        if makew(a,st)<15 then help=help &" | | Damage: "&inv(a).dam &" | Range: "&inv(a).range &"\"&inv(a).range*2 &"\" &inv(a).range*3 
        if inv(a).ammomax>0 then help=help &" | Ammuniton: "&inv(a).ammomax 
        help=help &"| Heat:"&inv(a).heat &"\"&inv(a).heatadd &"\"& inv(a).heatsink
    next
    weapons=weapons &"/Exit"
    help=help &" /"
    last=i+1
    do
        cls
        displayship()        
        d=menu(weapons,help,2,2)
        if d<last then
            b=player.h_maxweaponslot
            wmenu="Weapon Slot/"
            for a=1 to b
                if player.weapons(a).desig="" then
                    wmenu=wmenu & "-Empty-/"
                else
                    wmenu=wmenu & player.weapons(a).desig & "/"
                endif
            next
            wmenu=wmenu+"Exit"
            b=b+1            
            c=menu(wmenu)
            if c<b then
                if player.weapons(c).desig<>"" and d<>5 then 
                    if not(askyn("Do you want to replace the "&player.weapons(c).desig &"(y/n)")) then c=b
                endif
                if c<b then
                    if paystuff(inv(d).p) then
                        player.weapons(c)=inv(d)
                    else
                        dprint "You don't have enough money"
                    endif
                endif
            endif
        endif
    
           
        recalcshipsbays
        displayship
    loop until d=last
                      
    return player
end function


function makeweapon(a as short) as _weap
    'w.made &";"&w.desig &";" &w.range &";"& w.ammo &";"&w.ammomax &";"& w.ecmmod &";"& w.p &";"
    '& w.col &";"& w.heat &";"& w.heatsink &";"& w.heatadd

    dim as _weap w,w2
    dim as string l
    dim as string word(15)
    dim as short f,i,t,j
    f=freefile
    open "data/weapons.csv" for input as #f
    do
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
        w.desig=word(1)
        w.dam=val(word(2))
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
        return w
    else 
        return w2 'return empty weapon instead of last if not found
    endif
end function

function findartifact(awayteam as _monster,v5 as short) as short
            dim c as short
            dprint "After examining closely, your science officer has found an alien artifact."
            
            if all_resources_are=0 then
                if v5=0 then
                    c=rnd_range(1,20)
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
            if c<0 or c>20 then c=rnd_range(1,20)
            if (rnd_range(1,6)+rnd_range(1,6)+player.science(1)>7 and artflag(c)=0 and c<>2 and c<>5) or all_resources_are>0 then
                artflag(c)=1                
                artifact(c,awayteam)
            else
                dprint "He cant figure out what it is."
                reward(4)=reward(4)+1
            endif
            return 0
end function

function artifact(c as short,awayteam as _monster) as short
    dim as short a,b,d,e,f
    dim text as string
    if c=1 then
        dprint "It is an improved Fuel System!"
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
        f=menu(text)
            if player.weapons(f).desig<>"" then 
                if askyn("do you want to replace that weapon? (y/n)") then 
                    player.weapons(f)=makeweapon(66)
                    f=d
                endif
            else
                player.weapons(f)=makeweapon(66)
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
        awayteam.move=4
        reward(5)=5
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
        if map(d).discovered=1 then
            dprint "But you have already discovered that that system."
        else
            dprint "It is at "&map(d).c.x &":"&map(d).c.y &" It is a "&spectralname(map(d).spec)&" with " & f & " planets."  
            map(d).discovered=1
        endif
    endif 
    if c=12 then
        dprint "It's a ships cloaking device!"
        placeitem(makeitem(87),0,0,0,-1)
        
    endif
    
    if c=13 then
        dprint "It's a special shield to protect ships from wormholes!"
    endif
    
    if c=14 then
        dprint "It's a powerful ancient bomb!"
        placeitem(makeitem(301),0,0,0,0,-1)
        artflag(14)=0
    endif
    
    if c=15 then
        dprint "It's a portable cloaking device!"
        placeitem(makeitem(302),0,0,0,0,-1)
    endif
    
    if c=16 then
        dprint "It's a device that allows to navigate wormholes!"
    endif
    
    if c=17 then
        dprint "It's a sophisticated piloting AI"
        player.pipilot=7
    endif
    
    if c=18 then
        dprint "It's a sophisticated gunner AI"
        player.pigunner=7
    endif
    
    if c=19 then
        dprint "It's a sophisticated science AI"
        player.piscience=7
    endif
    
    if c=20 then
        dprint "It's a sophisticated medical AI"
        player.pidoctor=8
    endif
    return 0
end function

