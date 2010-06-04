function rnd_item(t as short) as _items
    dim i as _items
    dim r as short
    if t=20 then 
        if rnd_range(1,100)<88 then
            t=rnd_range(1,4) 'weapons and armor
        else
            t=-1
            i=makeitem(rnd_range(31,33))
        endif
    endif
    if t=21 then 
        t=rnd_range(1,9)
    endif
    
    
    if t=1 then i=makeitem(rnd_range(1,2)) 'transport
    if t=2 then i=makeitem(rnd_range(3,11)) 'ranged weapons
    if t=3 then i=makeitem(rnd_range(40,47)) 'close weapons
    if t=4 then i=makeitem(rnd_range(12,20)) 'Armor
    if t=5 then i=makeitem(rnd_range(21,39)) 'misc
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
        if rnd_range(1,100)<33 then
            i=makeitem(rnd_range(1,2))
        else
            if rnd_range(1,100)<33 then
                i=makeitem(rnd_range(15,33))
            else
                if rnd_range(1,100)<50 then
                    i=makeitem(rnd_range(50,58))
                else
                    if rnd_range(1,100)<75 then
                        i=makeitem(rnd_range(21,30))
                    else
                        i=makeitem(rnd_range(70,71))
                    endif
                endif
            endif
        endif
    endif
    if t=12 then 'All but weapons and meds
        r=rnd_range(1,28)
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
    endif
        
    return i
end function


function destroyitem(b as short) as short     
    if b>=0 and b<=lastitem then
        item(b)=item(lastitem)
        lastitem=lastitem-1
        return 0
    else
        if b>0 then
            lastitem=lastitem+1
            item(b)=item(lastitem)
            lastitem=lastitem-1
        endif
        dprint "ERROR: attempted to destroy nonexistent item "& b,14
        return -1
    endif
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
        return lastitem
    else
        for a=1 to lastitem 'Überschreibe erstes item das nicht im schiff und keine ressource
            if item(a).w.s>0 and item(a).ty<>15 then
                item(a)=i
                return a
            endif
        next
    endif
    dprint "ITEM PLACEMENT ERROR!(lastitem="&lastitem &")",14
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
    
    if a=2 then
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
        i.price=50
        i.res=15
    endif
    
    if a=4 then
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
        i.price=100
        i.res=20
    endif
    
    if a=5 then
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
        i.price=200
        i.res=25
    endif
    
    if a=6 then
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
        i.price=300
        i.res=25
    endif
    
    if a=7 then
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
        i.price=400
        i.res=25
    endif
    
    if a=8 then
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
        i.price=500
        i.res=25
    endif
    
    if a=9 then
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
        i.price=600
        i.res=30
    endif
    
    if a=10 then
        i.id=10
        i.ty=2
        i.desig="laser rifle"
        i.desigp="laser rifles"
        i.ldesc="A tornister houses the energy source, connected to a pistolgrip with 3 short barrels. The laserbeams cause a lot of damage."
        i.icon="/"
        i.col=15
        i.bgcol=0
        i.v1=.8
        i.v2=5
        i.v3=0
        i.price=700
        i.res=30
    endif
    
    if a=11 then 
        i.id=11
        i.ty=2
        i.desig="plasma rifle"
        i.desigp="plasma rifles"
        i.ldesc="A tornister houses the energy source, connected to a rifle. It emits a beam of superheated plasma."
        i.icon="/"
        i.col=12
        i.bgcol=0
        i.v1=.9
        i.v2=6
        i.v3=0
        i.price=800
        i.res=35
    endif
    
    if a>=3 and a<=11 then
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
        i.ldesc=i.ldesc &"  | | Accuracy: "&i.v3 &" | Damage: "&i.v1 &" | Range:"&i.v2
    endif
    
    if a=12 then
        i.id=12
        i.ty=3
        i.desig="ballistic suit"
        i.desigp="ballistic suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with ballistic cloth around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=1
        i.price=50
        i.res=25
    endif
    
    if a=13 then
        i.id=13
        i.ty=3
        i.desig="full ballistic suit"
        i.desigp="full ballistic suits"
        i.ldesc="Your standard spacesuit, but completely covered in ballistic cloth."
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=2
        i.price=100
        i.res=25
    endif
    
    if a=14 then
        i.id=14
        i.ty=3
        i.desig="protective suit"
        i.desigp="protective suits"
        i.ldesc="Your standard spacesuit. Made combatworthy with hardened shells around vital areas." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=3
        i.price=150
        i.res=25
    endif
    
    if a=15 then
        i.id=15
        i.ty=3
        i.desig="full protective suit"
        i.desigp="full protective suits"
        i.ldesc="Your standard spacesuit, covered with hardened shells." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=4
        i.price=200
        i.res=25
    endif
    
    if a=16 then
        i.id=16
        i.ty=3
        i.desig="fullerene suit"
        i.desigp="fullerene suits"
        i.ldesc="Your standard spacesuit made out of carbon fullerenes." 
        i.icon="&"
        i.col=14
        i.bgcol=0
        i.v1=5
        i.price=400
        i.res=25
    endif
    
    if a=17 then
        i.id=17
        i.ty=3
        i.desig="combat armor"
        i.desigp="sets of combat armor"
        i.ldesc="A spacesuit covered in ablative plates." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=6
        i.price=600
        i.res=45
    endif
    
    if a=18 then
        i.id=18
        i.ty=3
        i.desig="heavy combat armor"
        i.desigp="sets of heavy combat armor"
        i.ldesc="A spacesuit covered in ablative plates. Built in hydraulics increase the strength and speed of the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=7
        i.price=800
        i.res=45
    endif
    
    if a>=12 and a<=18 and rnd_range(1,100)<10 then
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
    
            
    
    if a=19 then                 
        i.id=19
        i.ty=3
        i.desig="p. Forcefield"
        i.desigp="p. forcefields"
        i.ldesc="A small forcefield surrounds the wearer." 
        i.icon="&"
        i.col=2
        i.bgcol=0
        i.v1=8
        i.price=1000
        i.res=65
    endif    
         
    if a=20 then
        i.id=20
        i.ty=3
        i.desig="layered p. forcefield"
        i.desigp="layered p. forcefields"
        i.ldesc="The ultimate in protective equipment. Several layered forcefields surround the wearer." 
        i.icon="&"
        i.col=6
        i.bgcol=0
        i.v1=9
        i.price=1200
        i.res=45
    endif
    
    if a>=12 and a<=20 then
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
        i.ldesc=i.ldesc &" | | Armor Value: "&i.v1
    endif
    
    if a=21 then
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
        i.id=24
        i.ty=7
        i.desig="grenade"
        i.desigp="grenades"
        i.ldesc="small self propelled devices with explosive warheads"
        i.icon="'"
        i.v1=1
        i.col=7
        i.price=25
        i.res=10
    endif 
    
    if a=25 then
        i.id=25
        i.ty=7
        i.desig="fusion grenade"
        i.desigp="fusion grenades"
        i.ldesc="small self propelled devices with small matter-antimatter warheads"        
        i.icon="'"
        i.v1=2
        i.col=9
        i.price=80
        i.res=11
    endif
    
    if a=26 then
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
        i.id=40
        i.ty=4
        i.desig="combat knife"
        i.desigp="combat knifes"
        i.icon="("
        i.col=8
        i.v1=.2
        i.price=25
        i.ldesc="A short blade to stick into enemies."
        i.res=10
    endif
    
    if a=41 then
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
        i.id=42
        i.ty=4
        i.desig="vibro knife"
        i.desigp="vibro knives"
        i.icon="("
        i.col=8
        i.v1=.4
        i.price=100
        i.ldesc="A blade for slashing and piercing. Sawing motions increase damage."
        i.res=20
    endif

    if a=43 then
        i.id=43
        i.ty=4
        i.desig="vibro blade"
        i.desigp="vibro blades"
        i.icon="("
        i.col=8
        i.v1=.5
        i.price=200
        i.ldesc="A wide blade connected to a gauntlet. Sawing motions increase damage."
        i.res=25
    endif
    
    if a=44 then
        i.id=44
        i.ty=4
        i.desig="vibro sword"
        i.desigp="vibro swords"
        i.icon="("
        i.col=8
        i.v1=.6
        i.price=300
        i.ldesc="A long blade connected to a gauntlet. Sawing motions increase damage."
        i.res=35
    endif
    
    if a=45 then
        i.id=45
        i.ty=4
        i.desig="mono blade"
        i.desigp="mono blades"
        i.icon="("
        i.col=8
        i.v1=.7
        i.price=400
        i.ldesc="A sturdy gauntlet ending in a blade a single molecule wide."
        i.res=45
    endif
    
     
    if a=46 then
        i.id=46
        i.ty=4
        i.desig="mono sword"
        i.desigp="mono swords"
        i.icon="("
        i.col=8
        i.v1=.8
        i.price=500
        i.ldesc="A gauntlet with a long blade attached. It is a single molecule wide and heated to increase damage."
        i.res=55
    endif
    
    if a=47 then
        i.id=47
        i.ty=4
        i.desig="combat gloves"
        i.desigp="combat gloves"
        i.icon="("
        i.col=8
        i.v1=.9
        i.price=650
        i.ldesc="A sturdy gauntlet, connected to plastic sleeves going up to the shoulders. Servos increase the wearers strength. mono blades connected to the fingers hurt opponents."
        i.res=65
    endif
    
    if a>=40 and a<=47 then
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
        i.ldesc=i.ldesc &" | | Accuracy: "&i.v3 &" | Damage: "&i.v1
    endif
    
    if a=48 then
        i.id=48
        i.ty=17
        i.desig="grenade launcher"
        i.desigp="grenade launchers"
        i.icon="]"
        i.col=7
        i.price=500
        i.ldesc="A device to increase the range and improve the aim of grenades."
        i.res=55
    endif
    
    if a=49 then
        i.id=49
        i.ty=19
        i.v1=25
        i.desig="aux jetpack tanks"
        i.desigp="aux jetpack tanks"
        i.icon="!"
        i.col=14
        i.price=10
        i.ldesc="Small portable tanks to store auxillary jetpack fuel."
        i.res=65
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
    
    
    if a=50 then
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
        i.vt.x=-1
        i.vt.y=-1
        i.price=600
        i.res=85
    endif
    
    if a=51 then
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
        i.vt.x=-1
        i.vt.y=-1
        i.price=1500
        i.res=90
    endif
        
    if a=52 then
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
        i.vt.x=-1
        i.vt.y=-1
        i.price=3500
        i.res=95
    endif
    
    if a=53 then
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
    
    if a=86 then
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
        
        if i.v2=2 then i.desig="copper"
        if i.v2=2 then i.col=2
        
        if i.v2=3 then i.desig="sulfur"
        if i.v2=3 then i.col=6
        
        if i.v2=4 then i.desig="silver"
        if i.v2=4 then i.col=7
        
        if i.v2=5 then i.desig="gold"
        if i.v2=5 then i.col=14
        
        if i.v2=6 then i.desig="osmodium"
        if i.v2=6 then i.col=8
        
        if i.v2=7 then i.desig="palladium"
        if i.v2=7 then i.col=15
        
        if i.v2=8 then i.desig="gems"
        if i.v2=8 then i.col=5
        
        if i.v2=9 then i.desig="transuranic metals"
        if i.v2=9 then i.col=11
        
        if i.v2=10 then i.desig="monocrystals"
        if i.v2=10 then i.col=10
        
        if i.v2=11 then i.desig="exotic gems"
        if i.v2=11 then i.col=13
        
        if i.v2=12 then i.desig="iridium"
        if i.v2=12 then i.col=9
        
        if i.v2=13 then i.desig="lutetium"
        if i.v2=13 then i.col=3
        
        if i.v2=14 then i.desig="rhodium"
        if i.v2=14 then i.col=12
        
        i.v5=(i.v1+rnd_range(1,player.science+i.v2))*(rnd_range(1,5+player.science))
        i.price=i.v5/10   
        i.res=i.v5*10         
        
        i.scanmod=rnd_range(0,i.v1)
        i.icon="*"
        i.bgcol=0  
        roll=rnd_range(1,100+player.turn/100+mod1+mod2)
        if roll>125 and mod1>0 and mod2>0 then i=makeitem(99)
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
    endif

    if a=97 then
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
    
    if a=98 then                 
        i.id=98
        i.ty=3
        i.desig="adaptive bodyarmor"
        i.desigp="sets of adaptive bodyarmor"
        i.ldesc="A thin limegreen suit with a foldable helmet. Whenever the wearer is hit that area of the cloth changes corresponding to the nature of the attack." 
        i.icon="&"
        i.col=10
        i.bgcol=0
        i.v1=10
        i.res=120
        i.price=19000
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
    
    
    if a=99 then
        i.id=99
        i.ty=99
        i.icon="*"
        i.col=1
        if rnd_range(1,100)<35 then i=makeitem(98)
        if rnd_range(1,100)<45 then i=makeitem(97)
        if rnd_range(1,100)<16 then i=makeitem(95)
        i.res=100
    endif
    
    if a=301 then
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
    
    return i
    
end function

function equip_awayteam(player as _ship,awayteam as _monster, m as short) as short
    dim as short a,b,c,wavg,aavg,tdev,jpacks,hovers,cmove,infra
    dim as single oxytanks,oxy
    dim as short cantswim,cantfly
    cmove=awayteam.move
    awayteam.jpfueluse=0
    awayteam.stuff(1)=0
    awayteam.armor=0
    awayteam.guns_to=0
    awayteam.blades_to=0
    awayteam.light=0
    awayteam.jpfueluse=0
    awayteam.jpfuelmax=0
    for a=1 to lastitem
        if item(a).w.s=-2 then item(a).w.s=-1
    next
    for a=1 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+1
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
        if item(a).ty=1 and item(a).v1=3 and item(a).w.s=-1 then awayteam.move=3        
    next
    for a=1 to 128
        if crew(a).hp>0 and crew(a).onship=0 and jpacks>0 then
        crew(a).jp=1
        awayteam.jpfueluse+=1
        jpacks-=1
        else
        crew(a).jp=0
        endif
    next
    hovers=0
    jpacks=0
    
    for a=1 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+item(a).v2
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
        if item(a).ty=1 and item(a).v1=3 and item(a).w.s=-1 then awayteam.move=3        
    next
    infra=2
    awayteam.invis=6
    awayteam.oxymax=0
    awayteam.oxydep=0
    for a=1 to 128
        crew(a).weap=0
        crew(a).armo=0
        crew(a).blad=0
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips=0 then
            if crew(a).pref_ccweap>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_ccweap then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    awayteam.secweapc(a)=item(c).v1
                    awayteam.blades_to=awayteam.blades_to+item(c).v1
                    crew(a).blad=c
                    item(c).w.s=-2
                    'dprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
            if crew(a).pref_lrweap>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_lrweap then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    awayteam.secweap(a)=item(c).v1
                    awayteam.secweapran(a)=item(c).v2
                    awayteam.secweapthi(a)=item(c).v3
                    awayteam.guns_to=awayteam.guns_to+item(c).v1
                    crew(a).weap=c
                    item(c).w.s=-2
                    'dprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
            if crew(a).pref_armor>0 then
                c=0
                for b=0 to lastitem
                    if item(b).uid=crew(a).pref_armor then
                        c=b
                        exit for
                    endif
                next
                if c>0 then
                    awayteam.secarmo(a)=item(c).v1
                    if awayteam.invis>item(c).v2 then awayteam.invis=item(b).v2
                    awayteam.armor=awayteam.armor+item(c).v1
                    crew(a).armo=c
                    item(c).w.s=-2
                    'dprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
        endif
    next
    
    for a=1 to 128
        'find best ranged weapon
        'give to redshirt

        if crew(a).hp>0 and crew(a).onship=0 then 
            if crew(a).typ<>10 and crew(a).typ<>13 then cantswim+=1
            if crew(a).typ<>13 then cantfly+=1
            if crew(a).equips=0 then
                b=findbest(2,-1)        
                if b>-1 and crew(a).weap=0 then
                    'dprint "Equipping "&item(b).desig & b
                    awayteam.secweap(a)=item(b).v1
                    awayteam.secweapran(a)=item(b).v2
                    awayteam.secweapthi(a)=item(b).v3
                    awayteam.guns_to=awayteam.guns_to+item(b).v1
                    crew(a).weap=b
                    item(b).w.s=-2
                endif
                'find best armor        
                b=findbest(3,-1)
                'give to redshirt
                if b>-1 and crew(a).armo=0 then
                    awayteam.secarmo(a)=item(b).v1
                    if awayteam.invis>item(b).v2 then awayteam.invis=item(b).v2
                    awayteam.armor=awayteam.armor+item(b).v1
                    crew(a).armo=b
                    item(b).w.s=-2
                else
                    awayteam.invis=0
                endif
            endif
            oxy=.75
            b=findbest(17,-1)
            if b>-1 then
                item(b).w.s=-2
                oxy=oxy-item(b).v1
            endif
            if crew(a).augment(3)>1 then oxy=oxy-.3
            if oxy<0 then oxy=.1
            if crew(a).typ=13 then oxy=0
            awayteam.oxydep=awayteam.oxydep+oxy
            if crew(a).hpmax>0 and crew(a).onship=0 and crew(a).equips=0 then
                b=findbest(14,-1)
                if b>-1 then 
                    item(b).w.s=-2
                    awayteam.oxymax=awayteam.oxymax+200+item(b).v1
                else
                    awayteam.oxymax=awayteam.oxymax+200
                endif
            endif
            if crew(a).hpmax>0 and crew(a).onship=0 and crew(a).jp=1 then
                b=findbest(19,-1)
                if b>-1 then 
                    item(b).w.s=-2
                    awayteam.jpfuelmax=awayteam.jpfuelmax+50+item(b).v1
                else
                    awayteam.jpfuelmax=awayteam.jpfuelmax+50
                endif
            endif
        endif
        
    next
    
    for a=128 to 1 step -1
        b=findbest(4,-1)
        'give to redshirt
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips=0 and crew(a).blad=0 then
            if b>-1 then
                'dprint "Equipping "&item(b).desig & b
                awayteam.secweapc(a)=item(b).v1
                awayteam.blades_to=awayteam.blades_to+item(b).v1
                crew(a).blad=b
                item(b).w.s=-2
            endif
        endif
    next
    'count teleportation devices
    if artflag(9)>0 then awayteam.move=3
    'dprint "hovers:" & hovers &" Jetpacks:"&jpacks
    if awayteam.move<3 and cantswim<=hovers then awayteam.move=1
    if awayteam.move<3 and cantfly<=jpacks then awayteam.move=2
        
    awayteam.nohp=hovers
    awayteam.nojp=jpacks
    if findbest(5,-1)>-1 then awayteam.stuff(5)=item(findbest(5,-1)).v1
    if findbest(17,-1)>-1 then awayteam.stuff(4)=.2
    if findbest(10,-1)>-1 then awayteam.stuff(8)=item(findbest(10,-1)).v1 'Sattelite
    if findbest(46,-1)>-1 then awayteam.invis=7
    awayteam.sight=3+infra
    awayteam.light=0
    if findbest(8,-1)>-1 then awayteam.sight=awayteam.sight+item(findbest(8,-1)).v1
    if findbest(9,-1)>-1 then awayteam.light=item(findbest(9,-1)).v1
    if awayteam.oxymax<200 then awayteam.oxymax=200
    if awayteam.oxygen>awayteam.oxymax then awayteam.oxygen=awayteam.oxymax
    if awayteam.jpfuel>awayteam.jpfuelmax then awayteam.jpfuel=awayteam.jpfuelmax
    if artflag(9)=1 then awayteam.move=3
    awayteam.oxydep=awayteam.oxydep*planets(m).grav
    awayteam.oxydep=awayteam.oxydep*awayteam.helmet
    return 0
end function

function removeequip() as short
    dim a as short
    for a=1 to lastitem
        if item(a).w.s<0 then item(a).w.s=-1
    next
    return 0
end function

function listartifacts() as string
    dim as short a,c
    dim flagst(16) as string
    flagst(1)="Fuel System"
    flagst(2)="Disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" Ion canon"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" Cryochamber"
    flagst(9)="Teleportation device"
    flagst(10)=""
    flagst(11)=""
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    flagst(16)="Wormhole navigation device"
    color 15,0
    flagst(0)=" {15} Alien Artifacts {11}|"
    for a=1 to 16
        if artflag(a)>0 then
            c=c+1
            flagst(0)=flagst(0) &flagst(a) &"|"
        endif
    next
    if c=0 then
        flagst(0)=flagst(0) &"      {14} None |"
    endif
    return flagst(0)    
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
    dim list(128) as short
    for a=0 to lastitem
        if item(a).w.s=fr then
            if (ty>0 and item(a).ty=ty) or ty=0 then
                lst=lst+1
                list(lst)=a
            endif
        endif
    next
    if lst>0 then
        i=list(rnd_range(1,lst))
    else 
        i=-1
    endif
    return i
end function

function getitem(fr as short=999,ty as short=999,forceselect as byte=0) as short
    dim as short i,offset,a,b,c,li,cu,set,k
    dim mls(127) as string
    dim mno(127) as short
    dim mit(127) as short
    dim lin(20) as string
    dim it(20) as short
    dim as string key,mstr
    screenshot(1)
    for a=0 to lastitem
        if ((fr=999 and item(a).w.s<0) or item(a).w.s=fr) and (item(a).ty=ty or ty=999) then 'fr=999 means 
            set=0
            for c=0 to li
                if item(a).desig=mls(c) then
                    set=1
                    mno(c)=mno(c)+1
                endif
            next
            if set=0 then
                b=b+1
                li=li+1
                mls(b)=item(a).desig
                mls(b)=mls(b)
                mit(b)=a
                mno(b)=mno(b)+1
            endif
        endif
    next
    
    
    
    if li=0 then return -1
    if li=1 and (fr=999 or ty=999) and forceselect=0 then return mit(1)
    cu=1
    for a=1 to li
        for b=1 to li-1
            if item(mit(b)).ty>item(mit(b+1)).ty or (item(mit(b)).ty=item(mit(b+1)).ty and better_item(item(mit(b)),item(mit(b+1)))=1) then
                swap mno(b),mno(b+1)
                swap mls(b),mls(b+1)
                swap mit(b),mit(b+1)
            endif
        next
    next
    do
        if k=8 then cu=cu-1
        if k=2 then cu=cu+1
        if cu<1 then 
            if offset>0 then
                offset=offset-1
                cu=1
            else 
                cu=li
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
        
        Color 15,0
        locate 3,3
        draw string (3*_fw1,3*_fh1), "Select item:",,font2,custom,@_col 
        if offset<0 then offset=0
        if li>15 and offset>li-cu then offset=li-cu
        if cu>li then 
            cu=1
            offset=0
        endif
        if cu<0 then cu=0
        for a=1 to 15
            if mls(a+offset)<>"" then
                color 0,0
                draw string (3*_fw1,3*_fh1+a*_fh2),space(35),,font2,custom,@_col
                if cu=a then
                    color 15,5
                else
                    color 11,0
                endif
                draw string (3*_fw1,3*_fh1+a*_fh2),mls(a+offset),,font2,custom,@_col
                if mno(a+offset)>1 then draw string (3*_fw1,3*_fh1+a*_fh2),mls(a+offset) & "("&mno(a+offset) &")",,font2,custom,@_col
            endif
        next
        color 15,0
        if li>15 then 
            draw string (3*_fw1,3*_fh1+20*_fh2), "[MORE]",,font2,custom,@_col 
        endif
        draw string (3*_fw1,3*_fh1+20*_fh2), "Return to select item, ESC to quit",,font2,custom,@_col
        key=keyin
        k=getdirection(key)
        
        if cu>li then cu=li
        if key=key_enter then i=cu+offset
        if key=key_esc then i=-1
        if player.dead<>0 then return -1
    loop until i<>0
    if i>0 then i=mit(i)
    screenshot(2)
    return i
end function


function findbest(t as short,p as short=0, m as short=0) as short
    dim as single a,b,r
    r=-1
    for a=0 to lastitem
        if p<>0 then
            if item(a).w.s=p and item(a).ty=t then
                if item(a).v1>b then
                    r=a
                    b=item(a).v1
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
        if makew(a,st)=87 then help=help &"Sacrifices a weapon turret to install additional armor | | +5 to HP"
        if makew(a,st)=88 then help=help &"Additional thrusters increasing maneuverability in space combat. | | +1 to MP"
        if makew(a,st)=89 then help=help &"Additional thrusters and an auxillary power plant increasing maneuverability in space combat. | | +2 to MP"
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
    dim w as _weap
    w.made=a
        
    if a=1 then
        w.desig="Ship Gun"
        w.dam=1
        w.range=2
        w.ammo=20
        w.ammomax=20
        w.ecmmod=1
        w.p=1000
        w.col=7
   '     w.desc="A simple gun firing metal shells propelled by an explosion. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=2 then
        w.desig="Rail Gun"
        w.dam=2
        w.range=3
        w.ammo=20
        w.ammomax=20
        w.ecmmod=1
        w.p=2000
        w.col=7
  '      w.desc="Metal shells accelerated to high speeds using electric fields.  | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=3 then
        w.desig="Rocketlauncher"
        w.dam=3
        w.range=3
        w.ammo=10
        w.ammomax=10
        w.ecmmod=2
        w.p=3000
        w.col=7
 '       w.desc="Self propelled rockets with chemical explosives. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif    
    
    if a=4 then
        w.desig="Imp. Rockets"
        w.dam=4
        w.range=4
        w.ammo=10
        w.ammomax=10
        w.ecmmod=2
        w.p=4000
        w.col=7
'        w.desc="Self propelled rockets with nuclear warheads. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=5 then
        w.desig="LR Launcher"
        w.dam=5
        w.range=5
        w.ammo=5
        w.ammomax=5
        w.ecmmod=1
        w.p=5000
        w.col=7
       ' w.desc="Self propelled rockets with nuclear warheads and increased range. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=6 then
        w.desig="Plasma Gun"
        w.dam=1
        w.range=1
        w.ammo=0
        w.ammomax=0
        w.ecmmod=1
        w.p=1250
        w.col=14
      '  w.desc="Ionized hydrogen. Low impact damage, low penetration. A targetable ships drive basically. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=7 then 
        w.desig="Laser Bank"
        w.dam=2
        w.range=1
        w.ammo=0
        w.ammomax=0
        w.ecmmod=1
        w.p=2500
        w.col=14
     '   w.desc="Lasers burn through the enemys ships armor. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=8 then
        w.desig="X-Ray Laser"
        w.dam=3
        w.range=1
        w.ammo=0
        w.ammomax=0
        w.ecmmod=1
        w.p=3750
        w.col=14
    '    w.desc="Higher energy per particle increases the damage of a Laser. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=9 then
        w.desig="Gammaray Laser"
        w.dam=4
        w.range=2
        w.ammo=0
        w.ammomax=0
        w.ecmmod=1
        w.p=5000
        w.col=14
   '     w.desc="Bremsstrahlung wreaks havocs inside the target even if the particles don't penetrate the hull. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=10 then
        w.desig="ParticleCannon"
        w.dam=5
        w.range=2
        w.ammo=0
        w.ammomax=0
        w.ecmmod=1
        w.p=6250
        w.col=9
  '      w.desc="Heavy particles accelerated to near light speeds penetrate and rip apart the enemys armor. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
        
        
    if a=11 then
        w.desig="Gunbattery"
        w.dam=1
        w.range=1
        w.ROF=3
        w.ammo=20
        w.ammomax=20
        w.ecmmod=2
        w.p=2000
        w.col=15
  '      w.desc="Metal shells accelerated to high speeds using electric fields.  | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
        
    if a=12 then
        w.desig="Railgunbat."
        w.dam=2
        w.range=1
        w.ROF=3
        w.ammo=20
        w.ammomax=20
        w.ecmmod=2
        w.p=4000
        w.col=15
  '      w.desc="Metal shells accelerated to high speeds using electric fields.  | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    
    if a=13 then
        w.desig="Rocketbat."
        w.dam=3
        w.range=1
        w.ROF=2
        w.ammo=10
        w.ammomax=10
        w.ecmmod=2
        w.p=6000
        w.col=15
  '      w.desc="Metal shells accelerated to high speeds using electric fields.  | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=14 then
        w.desig="I. Rocketbat."
        w.dam=4
        w.range=1
        w.ROF=2
        w.ammo=10
        w.ammomax=10
        w.ecmmod=1
        w.p=8000
        w.col=15
  '      w.desc="Metal shells accelerated to high speeds using electric fields.  | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=66 then
        w.desig="Disintegrator"
        w.dam=6
        w.range=6
        w.ammo=0
        w.ecmmod=0
        w.ammomax=0
        w.p=25000
        w.col=12
 '       w.desc="You are uncertain how this wapon works, but it seems to disrupt the bonds formed by strong interaction in subatomic particles. | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    endif
    
    if a=87 then
        w.desig="Armor Plates"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=100
    endif
    
    if a=88 then
        w.desig="Man-Jets I"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=500
    endif
    
    if a=89 then
        w.desig="Man-Jets II"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=1500
    endif
    
    if a=90 then
        w.desig="Aux.Shield Gen."
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=800
    endif
        
    if a=91 then
        w.desig="Aux. Power Gen."
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=1000
    endif
    
    if a=92 then
        w.desig="Aux.Pow.MKII"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=2500
    endif
    
    if a=93 then
        w.desig="Ded. Sensors"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=800
    endif
    
    if a=94 then
        w.desig="Ded. Sens MKII"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=2000
    endif
    
    if a=95 then
        w.desig="Imp Trac Beam"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.ROF=-3
        w.p=1500
    endif
    
    if a=96 then
        w.desig="Tractor Beam"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.ROF=-1
        w.p=500
'        w.desc="Crew Quaters | | A weapons turret modified to provide lving space. Holds up to 10 additional crewmembers"
    endif
    
    if a=97 then
        w.desig="Crew Quarters"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=1500
'        w.desc="Crew Quaters | | A weapons turret modified to provide lving space. Holds up to 10 additional crewmembers"
    endif
    
    if a=98 then
        w.desig="Fuel Tank"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=1000
        'w.desc="Fuel Tank | | Not the safest way to store fuel. It holds 50 tons"
    endif
    
    if a=99 then
        w.desig="Cargo Bay"
        w.dam=0
        w.range=0
        w.ammo=0
        w.ammomax=0
        w.p=500
        'w.desc="Cargo Bay | | A weapons turret modified to hold an additional ton of cargo."
    endif
    
    if a=101 then
        w.desig="It bites"
        w.dam=2
        w.range=.5
        w.ammomax=0
        w.ammo=0
        w.p=-1
        w.col=2
    endif
    
    if a=102 then
        w.desig="It fires a concentrated beam of radiation"
        w.dam=3
        w.range=4
        w.ammomax=0
        w.ammo=0
        w.p=-1
        w.col=2
    endif
    
    if a=103 then
        w.desig="It hits with a tentacle"
        w.dam=2
        w.range=1
        w.ammomax=0
        w.ammo=0
        w.p=-1
        w.col=2
    endif
    
    if a=104 then
        w.desig="It fires a lightning bolt"
        w.dam=2
        w.range=3
        w.ammomax=0
        w.ammo=0
        w.p=-1
        w.col=11
    endif
    
    return w
end function

function findartifact(awayteam as _monster) as short
            dim c as short
            dprint "After examining closely, your science officer has found an alien artifact."
            do
            loop until inkey<>""
            
            if all_resources_are=0 then
                c=rnd_range(1,16)
                if c=2 or c=5 then
                    c=rnd_range(1,10)
                    if c=2 or c=5 then artflag(c)=1
                endif
            else
                c=all_resources_are
            endif
            if rnd_range(1,6)+rnd_range(1,6)+player.science>7 and artflag(c)=0 or all_resources_are>0 then
                artflag(c)=1                
                artifact(c,awayteam)
            else
                dprint "He cant figure out what it is."
                reward(4)=reward(4)+(rnd_range(1,3)+rnd_range(1,3))*1000
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
        awayteam.move=3
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
        placeitem(makeitem(301),0,0,0,-1)
        artflag(14)=0
    endif
    
    if c=15 then
        dprint "It's a portable cloaking device!"
        placeitem(makeitem(302),0,0,0,-1)
        artflag(15)=0
    endif
    
    if c=16 then
        dprint "It's a device that allows to navigate wormholes!"
    endif
    
    
    return 0
end function

