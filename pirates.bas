function merc_dis(fl as short,byref goal as short) as short
    dim as short i,j,dis
    for i=fleet(fl).t to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    
    for i=0 to lastwaypoint
        dis+=1
        for j=0 to 2
            if targetlist(i).x=basis(j).c.x and targetlist(i).y=basis(j).c.y then
                goal=j
                return dis
            end if
        next
    next
    return -1
end function

function ss_sighting(i as short) as short
    dim as string text,text2,text3
    dim as short fn,fn2,a,s,c,debug
    dim as _cords p
    if basis(i).lastsighting=0 then return 0
    fn=basis(i).lastsighting
    fn2=basis(i).lastfight
    debug=1
    if debug=1 and _debug=1 then dprint fn &":"&fn2
    c=11
    
    'if rnd_range(1,100)>basis(i).lastsightingturn-player.turn then
        if basis(i).lastsightingturn-player.turn<25 then
            text ="There are some rumors about"
            if basis(i).lastsightingturn-player.turn<10 then text="You hear a lot of people talking about"
            if basis(i).lastsightingturn-player.turn<5 then text="The station is abuzz with talk about"
        else
            return 0
        endif
        if basis(i).lastsightingdis>5 then
            text=text & " a long distance unidentified sensor contact, "& basis(i).lastsightingdis &" parsecs out."
        else
            if basis(i).lastsightingdis>2 and basis(i).lastsightingdis<=5  then
                text = text &" mid range sensor contact with"
            endif
            if basis(i).lastsightingdis<=2  then
                text = text &" short range sensor contact with"
            endif
            if fleet(fn).ty=2 then text=text &" a pirate fleet."
            if fleet(fn).ty=4 then 
                if basis(i).lastsightingdis<=3  then
                    text=text &" the pirate ship "& fleet(fn).mem(1).desig &"!"
                else
                    text=text &" a pirate fleet."
                endif
            endif
            if fleet(fn).ty=5 then text=text &" a mysterious huge and fast ship with high energy readings."
            if fleet(fn).ty=6 or fleet(fn).ty=7 then
                s=fleet(fn).ty-6
                if civ(s).contact=1 then
                    text=text &add_a_or_an(civ(s).n,0) &" ship."
                else
                    text =text &" a ship of unknown configuration."
                endif
            endif
            '8 and 9 are GG and asteroid belt monsters. 
            if fleet(fn).ty=10 then text=text &" an entity calling herself eris."
        endif
    'endif
    if fleet(i).mem(1).hull<300 then
        text3="There is some damage from a fight being repaired."
    endif
    if fleet(i).mem(1).hull<200 then
        c=c_yel
        text3="There is some heavy damage from a fight being repaired."
    endif
    if fleet(i).mem(1).hull<50 then
        c=c_red
        text3="The station is heavily damaged, barely operational."
    endif
    if fleet(i).con(2)>0 then
        select case fleet(fleet(i+1).con(2)).ty
            case is=2
                text3=text3 &" Word on the station is pirates have attacked!"
            case is=4
                text3=text3 &" Word on the station is the pirate ship "& fleet(fn).mem(1).desig &" attacked!"
            case is=5
                text3=text3 &" Word on the station is that a single, huge ship, with powerful weapons attacked!"
            case 6,7
                s=fleet(fleet(i+1).con(2)).ty-6
                if civ(s).contact=1 then
                    text3=text3 &" Word on the station is " &civ(s).n &" ships have attacked."
                else
                    text3=text3 &" Word on the station is an unknown civilisation has attacked."
                endif
        end select
    endif
    if rnd_range(1,100)>alienattacks and player.questflag(3)=0 then
        if alienattacks>5 then text2=" You hear a rumor about disappearing scout ships." 
        if alienattacks>10 then text2=" You hear a rumor about disappearing merchant convoys." 
        if alienattacks>25 then text2=" You hear a rumor about disappearing patrol ships." 
        if alienattacks>50 then text2=" Every conversation you overhear seems to be about disappearing ships and fleets." 
        if alienattacks>75 then
            if sysfrommap(specialplanet(29))>0 then
                p=map(sysfrommap(specialplanet(29))).c
            else
                p=map(sysfrommap(specialplanet(30))).c
            endif
            for a=0 to rnd_range(1,6)
                p=movepoint(p,5)
            next
            text2=" The station is abuzz with talk about ships disappearing around coordinates "&p.x &":"&p.y &"." 
        endif
    endif
    'text=text & fn &"typ:"&fleet(fn).ty
    if text<>"" or text3<>"" or text2<>"" then 
        dprint (text3),c
        dprint (text),c
        dprint (text2),c
    endif
    return 0
end function
    
function random_pirate_system() as short
    dim pot(_NoPB+2) as short
    dim as short i,l
    for i=0 to _NoPB
        if piratebase(i)>0 then
            l+=1
            pot(l)=sysfrommap(piratebase(i))
            if i=0 then 'Main base twice
                l+=1
                pot(l)=sysfrommap(piratebase(i))
            endif
        endif
    next
    if l=0 then
        return -1
    else
        return pot(rnd_range(1,l))
    endif
end function

function makecorp(a as short) as _basis
    dim basis as _basis
    dim as short b
    if a=0 then a=rnd_range(1,4)
    if a<0 then
        b=abs(a)
        do 
            a=rnd_range(1,4)
        loop until a<>b
    endif
    basis.company=a
    if a=1 then
        basis.repname="Eridiani Explorations"
        basis.mapmod=1.8
        basis.biomod=1
        basis.resmod=1.5
        basis.pirmod=1
    endif
    if a=2 then
        basis.repname="Smith Heavy Industries"
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.75
        basis.pirmod=0.95
    endif
    if a=3 then 
        basis.repname="Triax Traders Its."
        basis.mapmod=1
        basis.biomod=1
        basis.resmod=1.55
        basis.pirmod=1.1
    endif
    if a=4 then
        basis.repname="Omega Bioengineering"
        basis.mapmod=1
        basis.biomod=1.5
        basis.resmod=1.5
        basis.pirmod=1
    endif
    return basis 
end function

function make_ship(a as short) as _ship
dim p as _ship
dim as short c,b
    p.loadout=urn(0,3,12,0)
    if a=1 then
        'players ship    
        'retirementassets(9)=1
        'retirementassets(6)=1
        'retirementassets(11)=1
        'p.questflag(3)=1
        'artflag(5)=1
        'artflag(7)=1
        p.c=targetlist(firstwaypoint)
        p.di=nearest(basis(0).c,p.c)
        p.sensors=1
        p.hull=5
        p.hulltype=10
        p.ti_no=1
        p.fuel=100
        p.fuelmax=100
        p.fueluse=1
        p.money=Startingmoney
        income(mt_startcash)=startingmoney
        p.loadout=0
        p.engine=1
        p.weapons(1)=make_weapon(1)
        p.lastvisit.s=-1
    endif
    
    if a=2 then
        p.st=st_pfighter
        'pirate fighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.ti_no=18
        p.pipilot=1
        p.pigunner=3
        p.engine=4
        p.desig="Pirate Fighter"
        p.icon="F"
        p.money=200
        p.weapons(1)=make_weapon(7)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=3 then
        p.st=st_pcruiser
        'pirate Cruiser
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=10
        p.ti_no=19
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Pirate Cruiser"
        p.icon="C"
        p.money=1000
        p.weapons(3)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(2)
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=4 then
        p.st=st_pdestroyer
        'pirate Destroyer
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=15
        p.ti_no=20
        p.shieldmax=1
        p.pipilot=2
        p.pigunner=5
        p.engine=4
        p.desig="Pirate Destroyer"
        p.icon="D"
        p.money=3000
        
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(3)
        p.weapons(3)=make_weapon(1)
        p.weapons(4)=make_weapon(8)       
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    if a=5 then
        p.st=st_pbattleship
        'pirate Battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.ti_no=21
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=6
        p.engine=4
        p.desig="Pirate Battleship"
        p.icon="B"
        p.money=5000
        p.equipment(se_ecm)=1
               
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(4)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(9)
        
        p.col=12
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif
    
    if a=6 then
        c=rnd_range(1,10)
        p.turnrate=1
        if c<5 then   
            p.st=st_lighttransport
            p.hull=3
            p.shieldmax=0
            
            p.sensors=2
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            p.cargo(1).x=rarest_good+1
            for b=2 to 3
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="light transport"
            p.icon="t"
            p.ti_no=22
        endif
        if c>4 then
            p.st=st_heavytransport
            p.hull=8
            p.shieldmax=0
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=1
            p.engine=1
            for b=1 to 2
                p.cargo(b).x=rarest_good+1
            next
            for b=3 to 4
                p.cargo(b).x=rnd_range(2,6)
            next
            p.desig="heavy transport"
            p.weapons(1)=make_weapon(1)
            p.icon="T"
            p.ti_no=23
        endif
        if c>7 and c<10 then
            p.st=st_merchantman
            p.hull=12
            p.shieldmax=1
            
            p.sensors=3
            p.pipilot=1
            p.pigunner=2
            p.engine=2
            
            for b=1 to 3
                p.cargo(b).x=rarest_good+1
            next
            for b=4 to 5
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(1)=make_weapon(2)
            p.desig="merchantman"
            p.icon="m"
            p.ti_no=24
        endif
        if c=10 then 
            p.st=st_armedmerchant
            p.hull=15
            p.shieldmax=2
            
            p.sensors=4
            p.pipilot=1
            p.pigunner=2
            p.engine=3
            
            for b=1 to 4
                p.cargo(b).x=rarest_good+1
            next
            for b=5 to 6
                p.cargo(b).x=rnd_range(2,6)
            next
            p.weapons(2)=make_weapon(2)
            p.weapons(3)=make_weapon(2)
            p.desig="armed merchantman"
            p.icon="M"
            p.ti_no=25
        endif
        
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
        'Merchant
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.weapons(0)=make_weapon(1)
        
        p.money=0
        p.security=20
        p.shiptype=1
        p.col=10
        p.bcol=0
        p.mcol=12
    endif
    
    if a=7 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=2
        p.shieldmax=1
        p.pipilot=4
        p.pigunner=3
        p.engine=3
        p.weapons(3)=make_weapon(7)
        p.weapons(1)=make_weapon(1)
        p.weapons(2)=make_weapon(1)
        p.desig="Escort"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.hull=p.hull*(1+urn(0,3,2,0)*.5)
    endif

    if a=8 then
        p.st=st_annebonny
        'The dreaded Anne Bonny
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=30
        p.shieldmax=3
        p.pipilot=3
        p.pigunner=5
        p.engine=5
        p.desig="Anne Bonny"
        p.icon="A"
        p.ti_no=27
        p.money=15000
        p.loadout=3
        p.equipment(se_ecm)=2
        p.weapons(6)=make_weapon(9)       
        p.weapons(1)=make_weapon(9)
        p.weapons(2)=make_weapon(10)
        p.weapons(3)=make_weapon(5)
        p.weapons(4)=make_weapon(5)
        p.weapons(5)=make_weapon(5)
        p.col=8
        p.bcol=0
        p.mcol=10
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.cargo(6).x=1
        p.turnrate=2
    endif
    if a=9 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.desig="Company Battleship"
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=1
        p.weapons(4)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=1
        p.hull=p.hull*(1+urn(0,2,2,0)*.5)
    endif
    
    if a=10 then
        p.st=st_blackcorsair
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=25
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=5
        p.engine=3
        p.desig="Black Corsair"
        p.icon="D"
        p.ti_no=29
        p.money=8000
        
        p.equipment(se_ecm)=1
        
        p.weapons(6)=make_weapon(7)       
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.cargo(4).x=1
        p.cargo(5).x=1
        p.turnrate=3
    endif
    
    if a=11 then
        p.st=st_alienscoutship
        'Alien scoutship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=6
        p.hull=35
        p.shieldmax=4
        p.pipilot=4
        p.pigunner=3
        p.engine=5
        p.desig="Ancient Alien Ship"
        p.icon="8"
        p.ti_no=30
        
        p.equipment(se_ecm)=3
        p.weapons(1)=make_weapon(66)
        p.weapons(2)=make_weapon(66)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.loadout=4
        p.col=7
        p.bcol=0
        p.mcol=14
        p.turnrate=3
    endif
    
    if a=12 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=2
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="Fighter"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(7)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=21 then
        p.st=st_spacespider
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=10
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=5
        p.icon="S"
        p.ti_no=37
        p.desig="crystal spider"
        p.col=11
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=22 then
        'Sphere
        p.st=st_livingsphere
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=12
        p.hulltype=-1
        p.engine=0
        p.sensors=15
        p.pigunner=5
        p.icon="Q"
        p.ti_no=38
        p.desig="living sphere"
        p.col=8
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(102)
        p.weapons(3)=make_weapon(102)
        p.turnrate=3
    endif
    
    if a=23 then
        'cloud
        p.st=st_cloud
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=15
        p.hulltype=-1
        p.engine=4
        p.sensors=2
        p.pigunner=2
        p.icon=chr(176)
        p.ti_no=39
        p.desig="symbiotic cloud"
        p.col=14
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.turnrate=3
    endif
    
    
    if a=24 then
        'Spacespider
        p.st=st_hydrogenworm
        p.c.x=rnd_range(25,35)
        p.c.y=9
        p.hull=4
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=3
        p.icon="W"
        p.ti_no=40
        p.desig="hydrogen worm"
        p.col=121
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=1
    endif
    
    
    if a=25 then
        p.st=st_livingplasma
        p.c.x=rnd_range(25,35)
        p.c.y=12
        p.c=movepoint(p.c,5)
        p.hull=18
        p.hulltype=-1
        p.engine=5
        p.sensors=4
        p.pigunner=4
        p.icon=chr(176)
        p.ti_no=41
        p.desig="living plasma"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=26 then
        p.st=st_starjellyfish
        p.c.x=rnd_range(25,35)
        p.c.y=11
        p.hull=8
        p.hulltype=-1
        p.engine=3
        p.sensors=3
        p.pigunner=2
        p.icon="J"
        p.ti_no=42
        p.desig="starjellyfish"
        p.col=11
        p.mcol=14
        p.weapons(1)=make_weapon(101)
        p.weapons(2)=make_weapon(101)
        p.weapons(3)=make_weapon(101)
        p.turnrate=2
    endif
    
    
    if a=27 then
        p.st=st_cloudshark
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=2
        p.hulltype=-1
        p.engine=5
        p.sensors=3
        p.pigunner=2
        p.icon="S"
        p.desig="cloudshark"
        p.ti_no=43
        p.col=205
        p.mcol=1
        p.weapons(1)=make_weapon(101)
        p.turnrate=3
    endif
    
    if a=28 then
        p.st=st_gasbubble
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="O"
        p.ti_no=44
        p.desig="Gasbubble"
        p.col=203
        p.mcol=1
        p.weapons(1)=make_weapon(103)
        p.turnrate=3
    endif
    
    
    if a=29 then
        p.st=st_floater
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.hull=10
        p.hulltype=-1
        p.engine=2
        p.sensors=3
        p.pigunner=2
        p.icon="F"
        p.ti_no=45
        p.desig="Floater"
        p.col=138
        p.mcol=1
        p.weapons(1)=make_weapon(104)
        p.weapons(2)=make_weapon(104)
        p.turnrate=1
    endif
    
    if a=30 then
        p.st=st_hussar
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=15
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=2
        p.desig="Hussar"
        p.icon="C"
        p.ti_no=34
        p.money=5000
        p.equipment(se_ecm)=1
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(3)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(1)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.cargo(3).x=1
        p.turnrate=3
    endif
    
    if a=31 then
        p.st=st_adder
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=1
        p.pipilot=1
        p.pigunner=4
        p.engine=3
        p.desig="Adder"
        p.icon="F"
        p.ti_no=35
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=2
    endif
    
    if a=32 then
        p.st=st_blackwidow
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=5
        p.hull=5
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=4
        p.engine=2
        p.desig="Black Widow"
        p.icon="F"
        p.ti_no=36
        p.money=2500
        
        p.equipment(se_ecm)=1
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(13)
        p.col=4
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.cargo(2).x=1
        p.turnrate=3
    endif
    
    if a=33 then
        p.st=st_spacestation
        p.c.x=30
        p.c.y=10
        p.shiptype=2
        p.sensors=7
        p.hull=500
        p.shieldmax=8
        p.pigunner=4
        p.engine=0
        
        p.equipment(se_ecm)=0
        p.desig="Spacestation"
        p.icon="S"
        p.ti_no=46
        p.col=15
        p.weapons(1)=make_weapon(7)
        p.weapons(2)=make_weapon(7)
        p.weapons(3)=make_weapon(7)
        p.weapons(4)=make_weapon(3)
        p.weapons(5)=make_weapon(3)
        p.weapons(6)=make_weapon(3)
        p.turnrate=1
        p.loadout=3
    endif
    
    if a=34 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=1
        p.pigunner=1
        p.engine=4
        p.desig="LRF Striker"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.loadout=2
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    if a=35 then
        p.st=st_cfighter
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.shieldmax=1
        p.hull=8
        p.pipilot=3
        p.pigunner=3
        p.engine=4
        p.desig="LRF Lightning"
        p.icon="F"
        p.ti_no=31
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.col=10
        p.bcol=0
        p.mcol=14
        p.cargo(1).x=1
        p.turnrate=3
    endif
    
    
    if a=36 then
        'Escort
        p.st=st_Cescort
        p.c.x=60
        p.c.y=rnd_range(0,20)
        p.sensors=2
        p.hull=12
        p.shieldmax=2
        p.pipilot=4
        p.pigunner=5
        p.engine=5
        p.weapons(4)=make_weapon(89)
        p.weapons(3)=make_weapon(8)
        p.weapons(1)=make_weapon(3)
        p.weapons(2)=make_weapon(3)
        p.desig="EC Kursk"
        p.icon="E"
        p.ti_no=26
        p.money=0
        p.security=20
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=3
    endif
    
    if a=37 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=3
        p.hull=25
        p.shieldmax=2
        p.pipilot=1
        p.pigunner=5
        p.engine=4
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(4)=make_weapon(8)       
        p.weapons(1)=make_weapon(8)
        p.weapons(2)=make_weapon(8)
        p.weapons(3)=make_weapon(5)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=2
        p.desig="DS Argus"
    endif
    
    if a=38 then
        p.st=st_cbattleship
        'company battleship
        p.c.x=rnd_range(0,60)
        p.c.y=rnd_range(0,20)
        p.sensors=4
        p.hull=35
        p.shieldmax=3
        p.pipilot=1
        p.pigunner=4
        p.engine=5
        p.icon="U"
        p.ti_no=28
        p.money=0
        
        p.equipment(se_ecm)=2
        p.weapons(1)=make_weapon(9)       
        p.weapons(2)=make_weapon(9)
        p.weapons(3)=make_weapon(9)
        p.weapons(4)=make_weapon(89)
        p.weapons(5)=make_weapon(89)
        p.col=10
        p.bcol=0
        p.mcol=12
        p.turnrate=2
        p.loadout=3
        p.desig="BS Tyger"
    endif
    
    
    return p
end function
    
function debug_printfleet(f as _fleet) as string
    dim text as string
    dim a as short
    for a=1 to 15
        text=text &f.mem(a).icon
    next
    return text
end function
