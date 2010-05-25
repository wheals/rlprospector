
function drawroulettetable() as short
    dim as short x,y,z
    dim coltable(36) as short
    coltable(0)=10
    coltable(1)=12
    coltable(2)=15
    coltable(3)=12
    coltable(4)=15
    coltable(5)=12
    coltable(6)=15
    coltable(7)=12
    coltable(8)=15
    coltable(9)=12
    coltable(10)=15
    coltable(11)=15
    coltable(12)=12
    coltable(13)=15
    coltable(14)=12
    coltable(15)=15
    coltable(16)=12
    coltable(17)=15
    coltable(18)=12
    coltable(19)=12
    coltable(20)=15
    coltable(21)=12
    coltable(22)=15
    coltable(23)=12
    coltable(24)=15
    coltable(25)=12
    coltable(26)=15
    coltable(27)=12
    coltable(28)=15
    coltable(29)=15
    coltable(30)=12
    coltable(31)=15
    coltable(32)=12
    coltable(33)=15
    coltable(34)=12
    coltable(35)=15
    coltable(36)=12

    z=0
    for y=1 to 12
        for x=1 to 3
            z=z+1
            locate y+2,x*3+45,0
            if coltable(z)=12 then
                color 12,2
            else
                color 0,2
            endif
            if z<10 then
                if x<3 then
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2)," "&z &" ",,font2,custom,@_col
                else
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2)," "&z,,font2,custom,@_col
                endif
            else
                if x<3 then
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2),z &" ",,font2,custom,@_col
                else
                    draw string ((x*3+45)*_fw2,(y+2)*_fh2),""&z ,,font2,custom,@_col
                endif
            endif
        next
    next
    color 15,0
    return 0
end function


function makehullbox(t as short) as string
    dim as _ship s
    dim as string box
    s=gethullspecs(t)
    box=s.h_desc &" | | Hull:"&s.h_maxhull &" | Shield:"&s.h_maxshield &" | Engine:"&s.h_maxengine &" | Sensors:"&s.h_maxsensors 
    box=box &" | Crew:"&s.h_maxcrew &" | Cargobays:"&s.h_maxcargo &" | Weapon turrets:" &s.h_maxweaponslot &" | Fuelcapacity:"&s.h_maxfuel &" |"
    return box
end function

function gethullspecs(t as short) as _ship
    dim as short f,a,b
    dim as string word(11)
    dim as string l
    dim as _ship n
    f=freefile
    open "data/ships.csv" for input as #f
    line input #f,l
    for a=1 to t
        line input #f,l
    next
    close #f
    for a=1 to len(l)
        if mid(l,a,1)=";" then
            b=b+1
        else
            word(b)=word(b)&mid(l,a,1)
        endif
    next
    n.h_no=t
    n.h_desig=word(0)
    n.h_price=val(word(1))
    n.h_maxhull=val(word(2))
    n.h_maxshield=val(word(3))
    n.h_maxengine=val(word(4))
    n.h_maxsensors=val(word(5))
    n.h_maxcargo=val(word(6))
    n.h_maxcrew=val(word(7))
    n.h_maxweaponslot=val(word(8))
    n.h_maxfuel=val(word(9))    
    n.h_sdesc=word(10)
    n.h_desc=word(11)
    return n
end function

function upgradehull(t as short,byref s as _ship) as short
    dim as short f,flg,a,b,cargobays,weapons,tfrom,tto,m
    dim n as _ship
    dim d as _crewmember
    dim as string ques
    dim as string word(10)
    dim as string text
    n=gethullspecs(t)
    for a=1 to 10
        if s.cargo(a).x>0 then cargobays=cargobays+1
        if s.weapons(a).desig<>"" then weapons=weapons+1
    next
    
    'compare
    if s.h_maxhull>n.h_maxhull then ques=ques &"The new ship will have a lower maximum armor capacity than your current one. "
    if s.engine>n.h_maxengine and s.engine<6 then ques=ques &"You will need to downgrade your engine for the new hull. "
    if s.shieldmax>n.h_maxshield then ques=ques &"You will need to downgrade your shield generators for the new hull."
    if s.sensors>n.h_maxsensors and s.sensors<6 then ques=ques &"You will need to downgrade your sensors for the new hull."
    if cargobays>n.h_maxcargo then ques=ques &"The new ship will have less cargo space. "
    if s.h_maxcrew>n.h_maxcrew then ques=ques &"The new ship will have less space for crewmen. "
    if s.h_maxweaponslot>n.h_maxweaponslot then ques=ques &"The new ship will have fewer weapon turrets. "
    if s.h_maxfuel>n.h_maxfuel then ques=ques &"The new ship will have a lower fuel capacity than your current one."
    
    if ques<>"" then
        dprint ques,14 
        if askyn("Do you really want to transfer to the new hull?") then 
            flg=-1
        else
            flg=0
        endif
    else
        flg=-1
    endif
    if flg=-1 then
        s.h_no=n.h_no
        s.h_desig=n.h_desig
        s.h_sdesc=n.h_sdesc
        s.h_maxhull=n.h_maxhull
        s.h_maxengine=n.h_maxengine
        s.h_maxsensors=n.h_maxsensors
        s.h_maxshield=n.h_maxshield
        s.h_maxcargo=n.h_maxcargo
        s.h_maxcrew=n.h_maxcrew
        if s.engine<6 and s.engine>s.h_maxengine then s.engine=s.h_maxengine
        if s.sensors<6 and s.sensors>s.h_maxsensors then s.sensors=s.h_maxsensors
        if s.shield>s.h_maxshield then s.shield=s.h_maxshield
        
        s.h_maxweaponslot=n.h_maxweaponslot
        s.h_maxfuel=n.h_maxfuel
        if s.hull=0 then s.hull=s.h_maxhull*0.8
        if s.hull>s.h_maxhull then s.hull=s.h_maxhull
        if s.fuel=0 or s.fuel>s.h_maxfuel then s.fuel=s.h_maxfuel
        if s.h_maxweaponslot<weapons then
            poolandtransferweapons(n,s)
'            do
'                tfrom=(s.h_maxweaponslot -tto)
'                text="Chose weapons to transfer ("&tfrom &"):"
'                b=1
'                for a=1 to 10
'                    if s.weapons(a).desig<>"" then 
'                        text=text &"/"&s.weapons(a).desig
'                        b=b+1
'                    endif
'                next
'                text=text &"/Exit"
'                a=menu(text)
'                if a<b then
'                    tto=tto+1
'                    n.weapons(tto)=s.weapons(a)
'                    dprint "Transfering "&s.weapons(a).desig &" to slot "&tto
'                    weapons=weapons-1
'                endif
'                if a=b then
'                    if not(askyn("Do you really want to lose your remaining weapons(y/n)?")) then a=0
'                endif
'            loop until a=b or tto=s.h_maxweaponslot
'            for a=0 to 10
'                s.weapons(a)=n.weapons(a)
'            next
        endif
        
        recalcshipsbays
        
        if s.security>s.h_maxcrew+player.crewpod+player.cryo then
            s.security=s.h_maxcrew
            for a=s.h_maxcrew+player.crewpod+player.cryo to 128
                crew(a)=d
            next
        endif
        s.fuelmax=s.h_maxfuel+s.fuelpod
    endif
    return flg
end function

function findcompany(c as short) as short
    dim a as short
    for a=0 to 2
        if basis(a).company=c then return 1
    next
    return 0
end function

function company(st as short,byref questroll as short) as short
    dim as short b,c,q,m,complete
    dim as single a
    dim as string s,k
    dim towed as _ship
    dim p as _cords
    m=player.money
    if _autosell=0 then q=-1
    dprint "you enter the administrator's office"                    
    if player.questflag(1)=1 then
        if basis(st).repname="Omega Bioengineering" then
            a=25000
        else
            a=15000
        endif
        if askyn("The Rep offers to buy your data on the ancients pets for "&a &" Cr. Do you accept?(y/n)") then
            player.money=player.money+a
            player.questflag(1)=2
            if a=25000 then player.questflag(1)=3
        endif
        a=0
    endif
    if player.questflag(2)=2 then
        dprint "The Company Rep congratulates you on a job well done and pays you 15.000 Cr.",10
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+15000
        player.questflag(2)=4
        no_key=keyin
    endif
    if player.questflag(2)=3 then
        dprint "The Company Rep congratulates you on a job well done and pays you 10.000 Cr.",10
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+10000
        player.questflag(2)=4
        no_key=keyin
    endif
    if player.questflag(3)=1 then
        dprint "After some negotiations you convince the company rep to buy the secret of controling the alien ships for ... 1.000.000 CR!",10
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+1000000
        player.questflag(3)=2
        no_key=keyin
    endif
    if player.questflag(5)=2 then
        dprint "The Company Rep congratulates you on a job well done and pays you 15.000 Cr.",10
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+15000
        player.questflag(5)=3
        no_key=keyin
    endif 
    if player.questflag(6)=2 then
        dprint "The Company Rep congratulates you on a job well done and pays you 15.000 Cr.",10
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+15000
        player.questflag(6)=3
        no_key=keyin
    endif
    if player.questflag(7)>0 and basis(st).company=1 and planets(player.questflag(7)).flags(21)=1 then
        player.money=player.money+1000
        player.merchant_agr=player.merchant_agr-5
        dprint "The company rep pays your contract for mapping the planet",10
        player.questflag(7)=0
    endif
    if player.questflag(9)=2 and basis(st).company=2 then 
        player.money=player.money+5000
        player.merchant_agr=player.merchant_agr-5
        dprint "The company rep pays your contract for finding a robot factory.",10
        player.questflag(9)=3
    endif
    if player.questflag(10)<0 and basis(st).company=4 then
        player.money=player.money+2500
        player.merchant_agr=player.merchant_agr-5
        dprint "The company rep pays you for finding a planet to conduct their experiment on.",10
        planetmap(rnd_range(0,60),rnd_range(0,20),abs(player.questflag(10)))=16
        player.questflag(10)=0
    endif
    if player.questflag(11)=2 then 
        player.money=player.money+5000
        player.merchant_agr=player.merchant_agr-15
        dprint "The company rep remarks that these crystal creatures could be a threat to colonizing this sector and pays you your reard.",10
        player.questflag(11)=3
    endif
    if player.questflag(12)=0 and checkcomplex(specialplanet(33),1)=4 then 
        player.questflag(12)=1
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+10000
        dprint "The company rep pays you 10.000 Cr. for destroying the pirates asteroid hideout.",10
    endif
    
    if player.questflag(15)=2 then 
        player.questflag(15)=3
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+10000
        dprint "The company rep pays you 10.000 Cr. for destroying the pirate Battleship 'Anne Bonny'.",10
    endif
    
    if player.questflag(16)=2 then 
        player.questflag(16)=3
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+8000
        dprint "The company rep pays you 8.000 Cr. for destroying the pirate Destroyer 'Black corsair'.",10
    endif
    
    if player.questflag(17)=2 then 
        player.questflag(17)=3
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+5000
        dprint "The company rep pays you 5.000 Cr. for destroying the pirate Cruiser 'Hussar'.",10
    endif
    
    if player.questflag(18)=2 then 
        player.questflag(18)=3
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+2500
        dprint "The company rep pays you 2.500 Cr. for destroying the pirate fighter 'Adder'.",10
    endif
    
    if player.questflag(19)=2 then 
        player.questflag(19)=3
        player.merchant_agr=player.merchant_agr-15
        player.money=player.money+2500
        dprint "The company rep pays you 2.500 Cr. for destroying the pirate fighter 'Widow'.",10
    endif
    
    if player.questflag(21)=1 then
        if basis(st).company=1 then
            if askyn("Do you want to blackmail Eridiani Explorations with your information on their Drug business?(y/n)") then
                player.merchant_agr+=1
                player.money=player.money+1000
                companystats(1).capital=companystats(1).capital-rnd_range(1,100)
                dprint "The Rep pays 1000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Eridiani Explorations Drug business?(y/n)") then
                dprint "The Rep pays 10000 Cr. for your the information"
                companystats(1).capital=companystats(1).capital-500
                player.questflag(21)=2
                player.money=player.money+10000
            endif
        endif
    endif
    
    
    if player.questflag(22)=1 then
        if basis(st).company=2 then
            if askyn("Do you want to blackmail Smith Heavy Industries with your informatin on their slave work?(y/n)") then
                player.merchant_agr+=1
                player.money=player.money+1000
                companystats(2).capital=companystats(2).capital-rnd_range(1,100)
                dprint "The Rep pays 1000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Smith Heavy Industries slave business?(y/n)") then
                dprint "The Rep pays 10000 Cr. for your the information"
                companystats(2).capital=companystats(1).capital-500
                player.questflag(22)=2
                player.money=player.money+10000
            endif
        endif
    endif
    
    if player.questflag(23)=2 then
        if basis(st).company=3 then
            if askyn("Do you want to blackmail Triax Traders with your information on their agreement with pirates?(y/n)") then
                player.merchant_agr+=1
                player.money=player.money+1000
                companystats(3).capital=companystats(3).capital-rnd_range(1,100)
                dprint "The Rep pays 1000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" your information on Triax Traders agreement with pirates?(y/n)") then
                dprint "The Rep pays 10000 Cr. for your the information"
                companystats(3).capital=companystats(1).capital-500
                player.questflag(23)=3
                player.money=player.money+10000
            endif
        endif
    endif
    
    if player.questflag(24)=1 then
        if basis(st).company=4 then
            if askyn("Do you want to blackmail Omega Bioengineering with your informatin on their experiments?(y/n)") then
                player.merchant_agr+=1
                player.money=player.money+1000
                companystats(4).capital=companystats(4).capital-rnd_range(1,100)
                dprint "The Rep pays 1000 Cr. for your Silence"
            endif
        else
            if askyn("Do you want to sell "&companyname(basis(st).company) &" the secret of Omega Bioengineerings experiments?(y/n)") then
                dprint "The Rep pays 10000 Cr. for your the information"
                companystats(4).capital=companystats(4).capital-500
                player.questflag(24)=2
                player.money=player.money+10000
            endif
        endif
    endif
    
    if specialflag(31)=1 then
        if askyn("The company rep is fascinated about your report on the ancient space station in the asteroid belt. He offers you 75.000 Credits for the coordinates. Do you accept?(y/n)") then
            player.money=player.money+75000
            a=sysfrommap(specialplanet(31))
            player.merchant_agr=player.merchant_agr-25
            basis(4)=makecorp(0)
            basis(4).discovered=1
            basis(4).c=map(a).c
            for b=1 to 9
                if map(a).planets(b)=specialplanet(31) then map(a).planets(b)=-rnd_range(1,8)
            next
            specialflag(31)=2
        endif
    endif 
    
    if findbest(24,-1)>0 then
        dprint "The company Rep is highly interested in buying that portable nanobot factory. He offers you "&25000*basis(st).biomod &" credits."
        if askyn("Accept(y/n)") then
            player.merchant_agr=player.merchant_agr-35
            player.money=player.money+25000*basis(st).biomod
            destroyitem(findbest(24,-1))
        else
            dprint "The offer stands."
        endif
    endif    
    
    if findbest(87,-1)>0 and basis(st).company=4 then
        if askyn("The company rep would buy the burrowers eggsacks for 100 Credits a piece. Do you want to sell?(y/n)") then
            for a=0 to lastitem
                if item(a).ty=87 and item(a).w.s=-1 then 
                    destroyitem(a)
                    player.money=player.money+100
                endif
            next
        endif
    endif
    
    if basis(st).company=2 then
        c=0
        for a=1 to lastplanet
            if planets(a).flags(23)=2 then c=a
        next
        if c>0 then
            dprint "Thanks for helping wiping out those pirates!"
            planets(c).flags(23)=3
            player.money=player.money+2500
        endif
    endif
    
    if player.towed<>0 then
        if player.towed>0 then
            towed=gethullspecs(drifting(player.towed).s)
            a=towed.h_price
            if planets(drifting(player.towed).m).genozide<>1 then a=a/2
            a=a/2
            a=int(a)
            if planets(drifting(player.towed).m).mon_template(0).made<>32 then
                if askyn ("the company offers you "&a &" Cr. for the "&towed.h_desig &" you have in tow. Do you accept?(y/n)") then
                    drifting(player.towed)=drifting(lastdrifting)
                    lastdrifting-=1
                    player.money=player.money+a
                    player.towed=0
                endif
            else
                a=disnbase(drifting(player.towed).start)
                a=int(a*100)
                dprint "The company pays you "&a &" Cr. for towing in the ship."
                drifting(player.towed)=drifting(lastdrifting)
                lastdrifting-=1
                player.money=player.money+a
                player.towed=0
            endif
        endif
        a=0
    endif
            
    c=0
    for b=0 to 4
        c=c+reward(b)
    next
    if c=0 then 
        dprint "You have nothing to sell to "& basis(st).repname
    else
        companystats(basis(st).company).profit=companystats(basis(st).company).profit+c
        dprint basis(st).repname &":"
    endif
    
    if questroll<33 then questroll=givequest(st,questroll)    
    
    if reward(0)>1 then
        if _autosell=1 then q=askyn("do you want to sell map data? (y/n)")
        for a=0 to laststar
            for b=1 to 9
                if map(a).planets(b)>0 then
                    if planets(map(a).planets(b)).flags(21)=1 then
                        complete+=1
                        planets(map(a).planets(b)).flags(21)=2
                    endif
                endif
            next
        next
        if q=-1 and basis(st).repname="Eridiani Explorations" then
            if complete>1 then dprint "Eridiani explorations pays "&complete*50 &" Cr. for the complete maps of "&complete &"planets"
            if complete=1 then dprint "Eridiani explorations pays "&complete*50 &" Cr. for the complete maps of a planet"
            player.money=player.money+complete*50
        endif
        
        if q=-1 then
            dprint "you transfer new map data on "&reward(0)&" km2. you get paid "&cint((reward(7)/15)*basis(st).mapmod*(1+0.1*crew(1).talents(2)))&" credits"
            player.money=player.money+cint((reward(7)/15)*basis(st).mapmod*(1+0.1*crew(1).talents(2)))
            reward(0)=0
            reward(7)=0
            k=keyin
        endif
    endif
    if reward(1)>1 then
        if _autosell=1 then q=askyn("do you want to sell bio data? (y/n)")
        if q=-1 then
            dprint "you transfer data on alien lifeforms worth "& cint(reward(1)*basis(st).biomod*(1+0.1*crew(1).talents(2))) &" credits."
            player.money=player.money+cint(reward(1)*basis(st).biomod*(1+0.1*crew(1).talents(2)))
            reward(1)=0
            for a=1 to lastitem
                if item(a).ty=26 and item(a).w.s=-1 then item(a).v1=0
            next
            k=keyin
        endif
    endif
    if reward(2)>1 then
        if _autosell=1 then q=askyn("do you want to sell resources? (y/n)")
        if q=-1 then
            dprint "you transfer resources for "& cint(reward(2)*basis(st).resmod*(1+0.1*crew(1).talents(2))) &" credits."
            player.money=player.money+cint(reward(2)*basis(st).resmod*(1+0.1*crew(1).talents(2)))
            reward(2)=0
            for b=0 to 1
                for a=0 to lastitem
                    if item(a).ty=15 and item(a).w.s<0 then
                        item(a)=item(lastitem)
                        lastitem=lastitem-1
                    endif
                next
            next
            k=keyin
        endif
    endif
    if reward(3)>1 then
        if _autosell=1 then q=askyn("do you want to collect your bounty for destroyed pirate ships? (y/n)")
        if q=-1 then
            dprint "You recieve "&cint(reward(3)*basis(st).pirmod*(1+0.1*crew(1).talents(2))) &" credits as bounty for destroyed pirate ships."
            player.money=player.money+cint(reward(3)*basis(st).pirmod*(1+0.1*crew(1).talents(2)))
            reward(3)=0
            no_key=keyin
        endif
    endif
    if reward(4)>1 then
        if _autosell=1 then q=askyn("do you want to sell your artifacts? (y/n)")
        if q=-1 then
            dprint basis(st).repname &" pays " &reward(4) &" credits for the alien curiosity"
            player.money=player.money+reward(4)
            reward(4)=0
            no_key=keyin
        endif
    endif
    if reward(6)>1 then
        dprint "The Company pays you 50.000 Cr. for eliminating the pirate threat in this sector!"
        player.money=player.money+50000
        player.piratekills=player.piratekills+50000
        reward(6)=-1
        no_key=keyin
    endif
    if reward(8)>0 then
        dprint "The Company pays "&reward(8) &" Cr. for destroying pirate outposts"
        player.money=player.money+reward(8)
        player.piratekills=player.piratekills+reward(8)
        reward(8)=0
        no_key=keyin
    endif
    dprint "you leave the company office"
    if m<0 and player.money>0 then player.merchant_agr=player.merchant_agr-1
    return 0
end function

function casino(staked as short=0, st as short=-1) as short
    dim as short a,b,c,d,bet,num,fi,col,times,mbet,gpld,asst,x,y,z
    dim as uinteger mwon,mlos
    dim as integer result
    dim p as _cords
    dim coltable(36) as short
    coltable(0)=10
    coltable(1)=12
    coltable(2)=15
    coltable(3)=12
    coltable(4)=15
    coltable(5)=12
    coltable(6)=15
    coltable(7)=12
    coltable(8)=15
    coltable(9)=12
    coltable(10)=15
    coltable(11)=15
    coltable(12)=12
    coltable(13)=15
    coltable(14)=12
    coltable(15)=15
    coltable(16)=12
    coltable(17)=15
    coltable(18)=12
    coltable(19)=12
    coltable(20)=15
    coltable(21)=12
    coltable(22)=15
    coltable(23)=12
    coltable(24)=15
    coltable(25)=12
    coltable(26)=15
    coltable(27)=12
    coltable(28)=15
    coltable(29)=15
    coltable(30)=12
    coltable(31)=15
    coltable(32)=12
    coltable(33)=15
    coltable(34)=12
    coltable(35)=15
    coltable(36)=12
    screenset 1,1
    do
        drawroulettetable()
        a=menu("Casino:/Play Roulette/Have a drink/Leave")
        if a=1 then
        do 
            locate 14,25
            print "Your bets please "
            drawroulettetable()
            b=menu("Roulette:/Bet on Number/Bet on Pair/Bet on Impair/Bet on Rouge/Bet on Noir/Don't play")
            if b<>6 then 
                drawroulettetable()
                if b=1 then 
                    dprint "which number?"
                    fi=getnumber(1,36,18)
                endif
                dprint "how much?"
                if player.money>50+staked*50 then 
                    mbet=50+staked*50
                else
                    mbet=player.money
                endif
                bet=getnumber(0,mbet,0)
                player.money=player.money-bet
                if bet>0 then
                    changemoral(bet/3,0)
                    locate 14,25
                    print "Rien Ne va plus "
                    for d=1 to rnd_range(1,6)+10
                        num=rnd_range(0,36)
                        col=coltable(num)
                        locate 15,25
                        color col,0
                        print " "&num &" "
                        sleep d*d*2
                    next
                    if staked=1 then
                        if gpld<10 then
                            if b=1 then num=fi
                            if b=2 and frac(num/2)<>0 then 
                                num=num+1
                                if num>36 then num=36
                            endif
                            if b=3 and frac(num/2)=0 then 
                                num=num+1
                            endif
                            if b=4 and coltable(num)=15 then
                               do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=12
                            endif
                            if b=5 and coltable(num)=12 then 
                                do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=15
                            endif
                        else
                            if b=1 and num=fi then num=num+1
                            if b=2 and frac(num/2)<>0 then 
                                num=num+1
                                if num>36 then num=36
                            endif
                            if b=3 and frac(num/2)<>0 then 
                                num=num+1
                            endif
                            if b=4 and coltable(num)=12 then
                               do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=15
                            endif
                            if b=5 and coltable(num)=15 then 
                                do 
                                   num=rnd_range(0,36)
                               loop until coltable(num)=12
                            endif
                        endif
                        col=coltable(num)
                        locate 15,25
                        color col,0
                        print " "&num &" "
                        sleep d*d*2
                    endif
                    if crew(1).talents(5)=1 then
                        if b=1 and fi<>num then num=rnd_range(0,36)
                        if b=2 and frac(num/2)<>0 then num=rnd_range(0,36)
                        if b=3 and frac(num/2)=0 then num=rnd_range(0,36)
                        if b=4 and coltable(num)=15 then num=rnd_range(0,36)
                        if b=5 and coltable(num)=12 then num=rnd_range(0,36)                        
                        col=coltable(num)
                        locate 15,25
                        color col,0
                        print " "&num &" "
                        sleep d*d*2
                    endif
                    times=0
                    if num=0 then dprint "Bank wins"
                    if b=1 and fi=num then times=35
                    if b=2 and frac(num/2)=0 then times=2
                    if b=3 and frac(num/2)<>0 then times=2
                    if b=4 and coltable(num)=12 then times=2
                    if b=5 and coltable(num)=15 then times=2
                    if times>0 then
                        dprint "you win " & bet*times & " Credits!"
                        player.money=player.money+bet*times
                        mwon=mwon+bet*times
                    else
                        dprint "You lose"
                        mlos=mlos+bet
                    endif
                    gpld=gpld+1
                endif
                
            endif
            displayship
            drawroulettetable()
            if b=6 and staked=1 then
                drawroulettetable()
                if gpld<3 or mwon>mlos then 
                    if asst<5 then
                        dprint "cmon, play another one"
                        b=0
                        asst=asst+1
                    endif
                else
                    if askyn("I am sure your luck will return! do you really want to leave?(y/n)") then
                       b=6
                       gpld=2
                    else
                        dprint "good decision!"
                        b=0
                    endif
                endif
            endif
            loop until b=6
        endif
        if a=2 then
            drawroulettetable()
            player.money=player.money-1
            if player.money<0 then                 
                player.money=player.money+1
                dprint "you can't even afford a drink."
                if rnd_range(1,100)<20 then 
                    dprint "The barkeep has pity and hands you 5 credits to bet at the roulette table."
                    player.money=5
                endif
            else
                dprint "you have a drink."
                changemoral(1,0)
            endif
            if rnd_range(1,100)<66 and player.money>=0 then
                b=rnd_range(1,28)
                c=rnd_range(0,2)
                d=rnd_range(1,5)
                if player.merchant_agr>50 or player.tradingmoney/player.money>0.5 then 
                    if basis(st).spy=0 and rnd_range(1,100)<50 and st>-1 then b=30
                    if player.tradingmoney=0 and player.merchant_agr<51 then b=rnd_range(1,26)
                endif
                p=fleet(rnd_range(1,lastfleet)).c
                if p.x=0 and p.y=0 then p=rnd_point
                if b=16 and rnd_range(1,100)<66 then p=map(piratebase(rnd_range(0,_NoPB))).c
                if b=1 then dprint "An old miner tells you a tall tale about a planet he worked on. Short version: they dug to deep and released invisible monsters that drove them off the planet."
                if b=2 then dprint "Another prospector tells you that he used ground radar to locate the ruins of an alien temple. Unfortunately the weather on the planet was so harsh his crew muntinied and demanded to return to the station immediately."
                if b=3 then dprint "A merchant captain claims to have outrun the infamous 'Anne Bonny' at coordinates "&p.x &":" &p.y
                if b=4 then dprint "A patrol captain claims to have shot down the infamous 'Anne Bonny' at coordinates "&p.x &":" &p.y
                if b=5 then dprint "Your science officer finds no drinks he hasnt seen yet."
                if b=6 then dprint "Your pilot wants to leave."
                if b=7 then dprint "Your gunner thinks the owners could put up a dartboard here for practice."
                if b=8 then dprint "A lone drunk informs you that the roulette wheel is rigged! He then asks you to buy him a drink."
                if b=9 then dprint "A scoutship captain claims to have found a lutetium deposit at "&rnd_range(1,59) &":" &rnd_range(1,19) &" that was too large to load into his ship."
                if b=10 then dprint "A security team member tells you a tall tale about fighting alien robots in an ancient city ruin 'They aren't gone. they are sleeping is what i say!'"
                if b=11 then dprint "Another prospector and a patrol ship captain are discussing an incident on a planet at "&rnd_range(1,59) &":" &rnd_range(1,19) &". Two freelance prospectors had landed on it at the same time and got into a dispute over a palladium deposit. The patrol captain remarks that 'those guys should be taught a lesson'" 
                if b=12 then dprint "A young man shows pictures of his brother. He was last seen on Station "&rnd_range(1,3)&", leaving with a scoutship, and hasn't returned."
                if b=13 then dprint "you get told that the weather in the stations hydroponic garden was remarkably pleasant lately!"
                if b=14 then dprint "you learn that the view from port E on the 5th ring of the station is spectacular"
                if b=15 then dprint "You hear a story about an ancient robot ship prowling the sector, attacking everything on sight. The Anne Bonny is said to have escaped it once. Everything else is destroyed."
                if b=16 then dprint "A patrolboat captain claims to have fought a big pirate fleet at "&p.x &":"&p.y
                if b=17 then dprint "A light transport captain claims in a discussion on traderoutes that the average price for  "& basis(st).inv(1).n &" is "&avgprice(1) &"."
                if b=18 then dprint "A Merchantman captain claims in a discussion on traderoutes that the average price for  "& basis(st).inv(2).n &" is "&avgprice(2) &"."
                if b=19 then dprint "A heavy transport captain claims in a discussion on traderoutes that the average price for  "& basis(st).inv(3).n &" is "&avgprice(3) &"."
                if b=20 then dprint "A Merchantman captain claims in a discussion on traderoutes that the average price for  "& basis(st).inv(4).n &" is "&avgprice(4) &"."
                if b=21 then dprint "A armed merchantman captain claims in a discussion on traderoutes that the average price for  "& basis(st).inv(5).n &" is "&avgprice(5) &"."
                if b=22 and st<>c then dprint "In a discussion about traderoutes a heavy transport captain claims that at station "& c+1 &" the price for  "& basis(c).inv(d).n &" is "& basis(c).inv(d).p &"."
                if b=23 and st<>c then dprint "In a discussion about traderoutes a light transport captain claims that at station "& c+1 &" the price for  "& basis(c).inv(d).n &" is "& basis(c).inv(d).p &"."
                if b=24 and st<>c then dprint "In a discussion about traderoutes a merchantman captain claims that at station "& c+1 &" the there is a  "& basis(c).inv(d).v &" ton stock of "& basis(c).inv(d).n &"."
                if b=25 and st<>c then dprint "In a discussion about traderoutes a armed merchantman captain claims that at station "& c+1 &" the there is a  "& basis(c).inv(d).v &" ton stock of "& basis(c).inv(d).n &"."
                if b=26 then dprint "Another prospector tells you that there is a rumor about a planet who's inhabitants are immortal."
                if b=27 then dprint "A science officer tells you that most animals on earth live for about 5 million heartbeats. 'Life expectancy is mainly a function of metabolism. A mouse just uses them up a little faster than an elephant.'"
                if b=28 then dprint "A scout captain tells you that he went refueling on a gas giant when his sensors picked up a huge metallic structure. He decided discretion was the better part of valor and left, barely making it back to base."
                if b=30 then 
                    if player.merchant_agr>50 then
                        if askyn ("A seedy looking indivdual comes up to you. 'If you are interested i could keep you informed about what the merchants are loading. What do you say? 100 Cr. each time you come here?'(y/n)") then
                            player.merchant_agr=player.merchant_agr-5
                            basis(st).spy=1 
                            dprint "'Deal then. Of course we never had this conversation'"
                        else
                            dprint "He says: 'I must have mistaken you for someone else. I apologize' and dissapears in the crowd."
                            player.merchant_agr=player.merchant_agr+5
                        endif
                    else
                        if askyn ("A seedy looking indivdual comes up to you. 'If you are interested i could see to it that the pirates don't get information about your cargo. what do you say? 100 Cr. each time you come here?'(y/n)") then
                            player.merchant_agr=player.merchant_agr-5
                            basis(st).spy=2 
                            dprint "'Deal then. Of course we never had this conversation'"
                        else
                            dprint "He says: 'I must have mistaken you for someone else. I apologize' and dissapears in the crowd."
                            player.merchant_agr=player.merchant_agr+5
                        endif
                    endif
                endif
           endif
        endif
        displayship
        drawroulettetable()
    loop until a=3
    cls
    result =mwon-mlos
    if result>30000 then result=30000
    return mwon-mlos
end function

function refuel() as short
    dim as short c,b
    c=player.money
    if player.money>0 and player.fuel<player.fuelmax+player.fuelpod then
        do
            player.fuel=player.fuel+1
            player.money=player.money-1
            if player.fuel>player.fuelmax+player.fuelpod then 
                player.fuel=player.fuelmax+player.fuelpod
                player.money=player.money+1
            endif
        loop until player.fuel=player.fuelmax+player.fuelpod or player.money=0
        for b=0 to 5
            if player.weapons(b).desig<>"" then
                if player.weapons(b).ammomax>0 then
                    if player.money>=player.weapons(b).ammomax-player.weapons(b).ammo then
                        player.money=player.money-player.weapons(b).ammomax+player.weapons(b).ammo
                        player.weapons(b).ammo=player.weapons(b).ammomax
                    endif
                endif
            endif
        next
    else
        dprint "You don't have any money." 
    endif
    if player.money=c and c>=0 then dprint "Your tanks and ammo bins are full."
    return 0
end function

function repairhull() as short
    dim as short a,b,c,d,add
    player.addhull=0
    for a=1 to 5
        if player.weapons(a).made=87 then player.addhull=player.addhull+5
    next
    displayship
    if player.hull<player.h_maxhull+player.addhull then
        dprint "you can add up to " & player.h_maxhull+player.addhull-player.hull &" Hull points (100 Cr per point)"
        b=getnumber(player.hull,player.h_maxhull+player.addhull,player.hull)
        if b>0 then
            b=b-player.hull
            if b+player.hull>player.h_maxhull+player.addhull then b=player.h_maxhull-player.hull
            if b*100>player.money then
                dprint "you dont have enough credits"
            else
                player.money=player.money-b*100
                player.hull=player.hull+b
            endif
        endif
    else
        dprint "your ship is fully armored"
    endif

    return 0
end function

function sickbay(st as short=0) as short
    dim text as string
    dim augn(6) as string
    dim augp(6) as short
    dim augd(6) as string
    '"Augments/ Targeting - 100 Cr/ Muscle Enhancement - 100 Cr/ Infrared Vision - 100 Cr/ Speed Enhancement - 100 Cr/ Exosceleton - 100 Cr/ Damage resistance - 100Cr/Exit")
                
    augn(1)="Targeting"
    augp(1)=100-st*20
    augd(1)="A targeting computer linked directly to the brain"
    augn(2)="Muscle Enhancement"
    augp(2)=100-st*20
    augd(2)="Artificial glands producing adrenalin on demand, increasing strength."
    augn(3)="Improved lungs"
    augp(3)=80-st*20
    augd(3)="User has lower oxygen requirement." 
    augn(4)="Speed Enhancement"
    augp(4)=150-st*20
    augd(4)="Artificial muscular tissue, increasing running speed"
    augn(5)="Exosceleton"
    augp(5)=100-st*20
    augd(5)="An artificial exosceleton to prevent damage."
    augn(6)="Metabolism Enhancement"
    augp(6)=150-st*20
    augd(6)="Increased pain threshholds and higher hormone output enable to withstand wounds longer."
    
    dim as short a,b,c,price,cured,c2
    for a=1 to 6
        augn(0)=augn(0)&augn(a)&" - "&augp(a)&"Cr. /"
        augd(0)=augd(0)&augd(a)&"/"
    next
    do
        cls
        displayship()
        a=menu("Sick bay/ Buy supplies / Treat crewmembers/ Buy crew augments/Exit")
        if a=1 then
            shop(21,1,"Medical Supplies")
        endif
        if a=2 then
            'if player.disease>0 then price=price+10*player.disease
            for b=1 to 128
                if crew(b).disease>0 and crew(b).hp>0 and crew(b).hpmax>0 then
                    price=price+10*crew(b).disease-st*3
                endif
            next
            if player.disease>0 then price=price+10*player.disease
            if price>0 then
                if askyn("Treatment will cost "&price &" Cr. Do you want the treatment to begin?") then
                    if price<=player.money then
                        player.money=player.money-price
                        for b=1 to 128
                            if crew(b).disease>0 and crew(b).hp>0 and crew(b).hpmax>0 then
                                cured+=1
                                crew(b).disease=0
                            endif
                        next
                        dprint cured &" crewmembers were cured."
                        player.disease=0
                    else
                        dprint "You don't have enough money"
                    endif
                endif
            else
                dprint "You have no sick crewmembers."
                player.disease=0
            endif
        endif
        if a=3 then
            do
                cls
                displayship()
                dprint ""
                b=menu("Augments/"&augn(0)&"Exit","/"&augd(0))
                if b>0 and b<7 then
                    do
                        c=showteam(0,1,augn(b)&c)
                        if c>0 then c2=1
                        if c=-1 then
                            if crew(6).hpmax>0 then
                                c=6
                            else
                                c=1
                            endif
                            c2=0
                        endif
                        screenset 0,1
                        cls
                        displayship()
                        flip
                        screenset 1,1
                        if c<>0 then
                            do

                                if crew(c).typ<=9 and b>0 and c>0 then
                                    if crew(c).augment(b)=0 then
                                        if player.money>=augp(b) and crew(c).hp>0 then
                                            if crew(c).augment(9)<3 or st<>0 then
                                                if st<>0 and crew(c).augment(9)>=3 then 
                                                    if not(askyn("Installing more than 3 augmentations can be dangerous, even kill the recipient. shall we proceed? (y/n)")) then c=-1
                                                endif        
                                                    if c>0 then
                                                    crew(c).augment(9)+=1
                                                    player.money=player.money-augp(b)
                                                    crew(c).augment(b)=1
                                                    if b=6 then 
                                                        crew(c).hp+=1
                                                        crew(c).hpmax+=1
                                                    endif
                                                    dprint augn(b) & " installed in "&crew(c).n &"."
                                                    if crew(c).augment(9)>3 and rnd_range(1,6)+rnd_range(1,6)>11-crew(c).augment(9) then
                                                        dprint crew(c).n &" has died during the operation."
                                                        crew(c).hp=0
                                                        no_key=keyin
                                                        if c=1 then player.dead=28
                                                    endif
                                                endif
                                            else
                                                dprint "We can't install more than 3 augmentations."
                                                no_key=keyin
                                            endif
                                        else
                                            if crew(c).hp>0 then 
                                                dprint "You don't have enough money.",14
                                                no_key=keyin
                                            else 
                                                dprint crew(c).n &" is dead."
                                                no_key=keyin
                                            endif
                                        endif
                                    else
                                        dprint crew(c).n &" already has "&augn(b)&"."
                                        no_key=keyin
                                    endif
                                else
                                    dprint "We can only install augments in humans."
                                    no_key=keyin
                                endif
                                c+=1
                            loop until crew(c).hpmax<=0 or c2>0 or player.money<augp(b)
                        endif
                    loop until c=0
                endif
            loop until b=7 or b=-1 or player.dead<>0
        endif
    loop until a=4
    return player.disease
end function


function shipyard(pir as short=1) as short
    dim as short a,b,c,d,e,last
    dim as string men,des
    dim s as _ship
    dim pr(16) as ushort
    dim ds(16) as string
    dim st(16) as short
    men="New Hull/"
    des="Nil/"
    a=1
    'Pir =2 even numbers only = Fighters/troop carriers
    if pir=1 then
        for b=pir to 12
            s=gethullspecs(b)
            st(a)=b
            pr(a)=s.h_price
            ds(a)=s.h_desig
            a+=1
            men=men & s.h_desig & " - " &s.h_price &"Cr./"
            des=des &makehullbox(b) &"/"
            last=last+1
        next
    endif
    
    if pir=2 then
        for b=pir to 16 step pir            
            s=gethullspecs(b)
            st(a)=b
            pr(a)=s.h_price
            ds(a)=s.h_desig
            a+=1
            men=men & s.h_desig & " - " &s.h_price &"Cr./"
            des=des &makehullbox(b) &"/"
            last=last+1
        next
    endif
    if pir=3 then
        for b=13 to 16
            s=gethullspecs(b)
            st(a)=b
            pr(a)=s.h_price
            ds(a)=s.h_desig
            men=men & s.h_desig & " - " &s.h_price &"Cr./"
            des=des &makehullbox(b) &"/"
            a+=1
            last=last+1
        next
    endif
    men=men &"Exit"
    des=des &"/"
    do 
        displayship
        c=menu(men,des)
        if c<last+1 then
            if paystuff(pr(c)) then
                if st(c)<>player.h_no then
                    if upgradehull(st(c),player)=-1 then
                        dprint "you buy a "&ds(c)&" hull"
                    else
                        player.money=player.money+pr(c)
                    endif             
                else
                    dprint "You already have that hull."
                    player.money=player.money+pr(c)
                endif
            endif
            displayship
        endif
    loop until c>last
    cls
    return 0
end function

function shipupgrades(st as short) as short
    dim as short b,c,d,e
    shopitem(1,20).desig="sensors MK I"
    shopitem(1,20).price=200
    shopitem(1,20).v1=1
    shopitem(1,20).ty=50
    shopitem(1,20).ldesc="Basic ship sensor set. 1 Parsec Range" 
    
    shopitem(2,20).desig="sensors MK II"
    shopitem(2,20).price=800
    shopitem(2,20).v1=2
    shopitem(2,20).v4=1
    shopitem(2,20).ty=50
    shopitem(2,20).ldesc="Basic ship sensor set. 2 Parsec Range" 
    
    shopitem(3,20).desig="Sensors MK III"
    shopitem(3,20).price=1600
    shopitem(3,20).v1=3
    shopitem(3,20).ty=50
    shopitem(3,20).ldesc="Ship sensor set. 3 Parsec Range" 
    
    
    shopitem(4,20).desig="sensors MK IV"
    shopitem(4,20).price=3200
    shopitem(4,20).v1=4
    shopitem(4,20).ty=50
    shopitem(4,20).ldesc="Advanced ship sensor set. 4 Parsec Range" 
    
    shopitem(5,20).desig="sensors MK V"
    shopitem(5,20).price=6400                        
    shopitem(5,20).ty=50
    shopitem(5,20).v1=5
    shopitem(5,20).ldesc="Advanced ship sensor set. 5 Parsec Range" 
    
    shopitem(6,20).desig="ship detection system"
    shopitem(6,20).desigp="ship detection systems"
    shopitem(6,20).price=1500
    shopitem(6,20).id=1001
    shopitem(6,20).ty=51
    shopitem(6,20).v1=1
    shopitem(6,20).ldesc="Filters out ship signatures out of longrange sensor noise."
    
    shopitem(7,20).desig="imp. ship detection sys."
    shopitem(7,20).desigp="imp. ship detection sys."
    shopitem(7,20).price=3000
    shopitem(7,20).id=1002
    shopitem(7,20).ty=51
    shopitem(7,20).v1=2
    shopitem(7,20).ldesc="Filters out ship signatures, and friend-foe signals out of longrange sensor noise."
    
    shopitem(8,20).desig="navigational computer"
    shopitem(8,20).desigp="navigational computers"
    shopitem(8,20).price=350
    shopitem(8,20).id=1003
    shopitem(8,20).ty=52
    shopitem(8,20).v1=1
    shopitem(8,20).ldesc="A system keeping track of sensor input. Shows you where you are and allows you to see where you have already been." 
    
    shopitem(9,20).desig="ECM I system"
    shopitem(9,20).desigp="ECM I systems"
    shopitem(9,20).price=3000
    shopitem(9,20).ty=53
    shopitem(9,20).id=1004
    shopitem(9,20).v1=1
    shopitem(9,20).ldesc="Designed to prevent sensor locks, especially effective against missiles"
        
    shopitem(10,20).desig="ECM II system"
    shopitem(10,20).desigp="ECM II systems"
    shopitem(10,20).price=9000
    shopitem(10,20).ty=53
    shopitem(10,20).id=1005
    shopitem(10,20).v1=2
    shopitem(10,20).ldesc="Designed to prevent sensor locks, and decrease sensor echo. especially effective against missiles"
    
    shopitem(11,20).desig="Cargo bay shielding"
    shopitem(11,20).price=500
    shopitem(11,20).ty=54
    shopitem(11,20).id=1006
    shopitem(11,20).v1=30
    shopitem(11,20).ldesc="Special shielding for cargo bays, making it harder to scan them."
    
    
    shopitem(12,20).desig="Cargo bay shielding MKII"
    shopitem(12,20).price=1500
    shopitem(12,20).ty=54
    shopitem(12,20).id=1007
    shopitem(12,20).v1=45
    shopitem(12,20).ldesc="Special shielding for cargo bays, making it harder to scan them."
    
    do 
        displayship
        c=menu("Ship Upgrades:/Sensors/Shields/Engine/Weapons & Modules/Exit")
        if c=1 then 'Sensors
             
            
            
            do
            d=menu("Sensors:/ Sensors MKI   -  200 Cr/ Sensors MKII  -  800 Cr/ Sensors MKIII - 1600 Cr/ Sensors MKIV  - 3200 Cr/ Sensors MKV   - 6400 Cr/ Ship detection system - 1500 Cr / Imp. ship detection system - 3000 Cr/ Navigational computer - 350 Cr/ ECM System I - 3000 Cr/ ECM System II - 9000 Cr/ Cargo shielding I - 500 Cr/ Cargo shielding II - 1500 Cr/Exit")
                    
            displayship
            if d<>-1 then
                if d>0 and d<13 then
                    if player.money>=shopitem(d,20).price then
                        if shopitem(d,20).ty=50 then
                            if shopitem(d,20).v1>player.h_maxsensors then dprint "Your ship is too small for those"
                            if shopitem(d,20).v1<player.sensors then dprint "You already have better sensors"
                            if shopitem(d,20).v1=player.sensors then dprint "That is the same as your current sensor system"
                            if shopitem(d,20).v1>player.sensors and shopitem(d,20).v1<=player.h_maxsensors then
                                player.sensors=shopitem(d,20).v1
                                player.money=player.money-shopitem(d,20).price
                                dprint "You buy "&shopitem(d,20).desig
                            endif
                        endif
                        if shopitem(d,20).ty>50 and shopitem(d,20).ty<53 then
                            if findbest(shopitem(d,20).ty,-1)<0 then
                                placeitem(shopitem(d,20),0,0,0,0,-1)
                                player.money=player.money-shopitem(d,20).price
                                dprint "You buy "&shopitem(d,20).desig
                            else
                                if item(findbest(shopitem(d,20).ty,-1)).v1<shopitem(d,20).v1 then
                                    dprint "You already have a better "&shopitem(d,20).desig
                                else
                                    dprint "You already have a "&shopitem(d,20).desig
                                endif
                            endif
                        endif
                        if shopitem(d,20).ty=53 then
                            if shopitem(d,20).v1<player.ecm then
                                dprint "you already have a better ECM system"
                                player.money=player.money+shopitem(d,20).price
                            endif
                            if shopitem(d,20).v1=player.ecm then
                                dprint "That is the same as your current ECM system"
                                player.money=player.money+shopitem(d,20).price
                            endif
                            if shopitem(d,20).v1>player.ecm then 
                                player.ecm=shopitem(d,20).v1
                                player.money=player.money-shopitem(d,20).price
                                dprint "You buy "&shopitem(d,20).desig
                            endif
                        endif
                        if shopitem(d,20).ty=54 then
                            if shopitem(d,20).v1<player.shieldedcargo then
                            dprint "you already have a better cargo shielding"
                                player.money=player.money+shopitem(d,20).price
                            endif
                            if shopitem(d,20).v1=player.shieldedcargo then
                                dprint "That is the same as your current cargo shielding"
                                player.money=player.money+shopitem(d,20).price
                            endif
                            if shopitem(d,20).v1>player.shieldedcargo then 
                                player.shieldedcargo=shopitem(d,20).v1
                                player.money=player.money-shopitem(d,20).price
                                dprint "You buy "&shopitem(d,20).desig
                            endif
                        endif
                    else
                        dprint "You don't have enough money."
                    endif
                endif
            endif
            displayship()
            loop until d=-1 or d=13
            for b=1 to lastitem
                if item(b).ty=50 then
                    item(b)=item(lastitem)
                    lastitem=lastitem-1
                endif
            next
            displayship()
        endif
            
            if c=2 then 'Shields
                do
                    d=menu("Shields:/ Shields MKI   -  300 Cr/ Shields MKII  - 1200 Cr/ Shields MKIII - 2700 Cr/ Shields MKIV  - 4800 Cr/ Shields MKV   - 7500 Cr/ Exit")
                    if d<6 and d<=player.h_maxshield then
                        if d<player.shieldmax then dprint "you already have better shields"
                        if d=player.shieldmax then dprint "You already have this shieldgenerator"
                        if d>player.shieldmax and d<6 then
                            if player.money>=d*d*300 then
                                player.money=player.money-d*d*300
                                player.shieldmax=d
                                player.shield=d
                                dprint "You upgrade your shields"
                                d=6
                            else
                                dprint "Not enough money"
                            endif
                        endif
                    else
                        if d<6 then dprint "That shieldgenerator doesnt fit in your hull"
                    endif
                    displayship()
                loop until d=6
                
            endif
            
            if c=3 then 'engine
                do
                    d=menu("Engine:/ Engine MKI    -  300 Cr/ Engine MKII   - 1200 Cr/ Engine MKIII  - 2700 Cr/ Engine MKIV   - 4800 Cr/ Engine MKV    - 7500 Cr/ AT Landing Gear - 500Cr/ Imp. AT Landing Gear - 500Cr/ Exit")
                    if d<6 and d<=player.h_maxengine then
                        if d<player.engine then dprint "You already have a better engine"
                        if d=player.engine then dprint "You already have this engine"
                        if d>player.engine and d<6 then
                            if player.money>=d*d*300 then
                                player.money=player.money-d*d*300
                                player.engine=d
                                dprint "You upgrade your engine"
                                displayship()
                                d=6
                            else
                                dprint "Not enough money"
                            endif
                        endif
                    else
                        if d<6 then dprint "That engine doesnt fit in your hull"
                        if d=6 then 
                            if paystuff(250) then
                            dprint "You buy all terrain landing gear"
                            placeitem(makeitem(75),,,,,-1)
                            endif
                        endif
                        if d=7 then 
                            if paystuff(500) then
                            dprint "You buy an improved all terrain landing gear"
                            placeitem(makeitem(76),,,,,-1)
                            endif
                        endif
                    endif
                loop until d=8
            endif
                
            if c=4 then 'weapons
                player=buyweapon(st)
                
            endif
            displayship()
        loop until c=5
    return 0
end function
    
function pirateupgrade() as short
    dim a as short
    if player.h_maxcrew>=10 then
        player.h_maxcrew=player.h_maxcrew-5
        player.h_maxcargo=player.h_maxcargo+1
        for a=1 to 9
            if player.cargo(a).x=0 then
                player.cargo(a).x=1
                recalcshipsbays()
                return 0
            endif
        next
    endif
    recalcshipsbays()
    return 0
end function


function hiring(st as short,byref hiringpool as short,hp as short) as short
    dim as short b,c,d,e,officers,maxsec,neodog,robots,w
    dim as short f,g
    dim as string text
    text="Hiring/ Pilot/ Gunner/ Science Officer/ Ships Doctor/ Security/"
    if basis(st).repname="Omega Bioengineering" and player.questflag(1)=3 then neodog=1
    if basis(st).repname="Smith Heavy Industries" and player.questflag(9)=3 then robots=1
    if neodog=1 then text=text & " Neodog/ Neoape/"
    if robots=1 then text=text & " Robot/"
    text=text & " Set Wage/Exit"
    cls        
        do
            officers=1
            if player.pilot>0 then officers=officers+1
            if player.gunner>0 then officers=officers+1
            if player.science>0 then officers=officers+1
            if player.doctor>0 then officers=officers+1
        
            displayship()
            b=menu(text)
                
            d=rnd_range(1,100)
            c=5
            if d<90 then c=4
            if d<75 then c=3
            if d<60 then c=2
            if d<40 then c=1
            if c<1 then c=1
            e=((player.pilot+player.gunner+player.science+player.doctor)/4)+1
            if e<=0 then e=2
            if c>e then c=e+rnd_range(0,2)-1
            if c<=0 then c=2
            if b<5 and hiringpool>0 then
                if b=1 then
                    if askyn("Pilot, Skill:" & c &" Wage per mission: "& c*c*Wage &" (Current:"&player.pilot &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.pilot=c
                            hiringpool+=addmember(2)
                        else
                            dprint "Not enough Credits for first wage."
                        endif
                    endif
                endif
                if b=2 then
                    if askyn("Gunner, Skill:" & c &" Wage per mission: " & c*c*Wage & " (Current:"&player.gunner &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.gunner=c
                            hiringpool+=addmember(3)
                        else
                            dprint "Not enough Credits for first wage."
                        endif
                    endif
                endif
                if b=3 then
                    if askyn("Science officer, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current:"&player.science &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.science=c
                            hiringpool+=addmember(4)
                        else
                           dprint "Not enough Credits for first wage."
                        endif
                    endif
                endif
                if b=4 then
                    if askyn("Ships doctor, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current:"&player.doctor &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.doctor=c
                            hiringpool+=addmember(5)
                        else
                           dprint "Not enough Credits for first wage."
                        endif
                    endif
                endif
                hiringpool=hiringpool-1
            else
                if b<5 then dprint "Nobody availiable for the position. try again later."
            endif
            if b=5 then
                dprint "No. of security personel to hire."
                maxsec=maxsecurity()
                c=getnumber(0,maxsec,0)
                if c>0 then
                if player.money<c*Wage then
                    dprint "Not enough Credits for first wage."
                else
                    for d=1 to c
                        hiringpool+=addmember(6)
                    next
                    player.money=player.money-c*Wage
                endif
                endif
            endif
            if neodog=1 then
                if b=6 then
                    dprint "How many Neodogs do you want to buy?"
                    maxsec=maxsecurity()
                    c=getnumber(0,maxsec,0)
                    if c>0 then
                        if player.money<c*50 then
                            dprint "Not enough Credits."
                        else
                            dprint "you buy "&c &" Neodogs."
                            for d=1 to c
                                addmember(11)
                            next
                            player.money=player.money-c*50
                        endif
                    endif
                endif
                
                if b=7 then
                    dprint "How many Neoapes do you want to buy?"
                    maxsec=maxsecurity()
                    c=getnumber(0,maxsec,0)
                    if c>0 then
                        if player.money<c*75 then
                            dprint "Not enough Credits."
                        else
                            dprint "you buy "&c &" Neoapes."
                            for d=1 to c
                                addmember(12)
                            next
                            player.money=player.money-c*75
                        endif
                    endif
                endif
            endif
            
            if b=6 and robots=1 then
                dprint "How many Robots do you want to buy?"
                maxsec=maxsecurity()
                c=getnumber(0,maxsec,0)
                if c>0 then
                    if player.money<c*150 then
                        dprint "Not enough Credits."
                    else
                        dprint "you buy "&c &" Robots."
                        for d=1 to c
                            addmember(13)
                        next
                        player.money=player.money-c*150
                    endif
                endif
            endif
            
            if (neodog=0 and robots=0 and b=6) or (neodog=1 and b=8) or (robots=1 and b=7) then
                dprint "Set standard wage from "&Wage &" to:"
                w=getnumber(1,20,Wage)
                if w>0 then Wage=w
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
                next
                dprint "Set to " &Wage &"Cr. Your crew now gets "&f &" Cr. in wages"        
            endif
        loop until (neodog=0 and robots=0 and b=7) or (neodog=1 and b=9) or (robots=1 and b=8)
    return 0
end function

function stockmarket(st as short) as short
    dim dis(4) as byte
    dim as short a,b,c,d,amount,last
    dim cn(5) as short
    dim text as string
    
    do
        for b=0 to 4
            dis(b)=0
        next
        cls
        displayship
        color 15,0
        locate 2,2
        draw string(2*_fw1,2*_fh1), "Company",,font2,custom,@_col
        locate 2,30
        draw string(2*_fw1+28*_fw2,2*_fh1), "Price",,font2,custom,@_col
        color 11,0
        text="Company" &space(18) &"Price"
        last=0
        for a=0 to 2
            color 11,0
            if dis(basis(a).company)=0 then
                last+=1
                locate 2+last,2
                cn(last)=basis(a).company
                draw string(2*_fw1,2*_fh1+last*_fh2), companyname(basis(a).company),,font2,custom,@_col
                text=text &"/"& companyname(basis(a).company)
                locate 2+last,30
                draw string(2*_fw1+28*_fw2,2*_fh1+last*_fh2), ""&companystats(basis(a).company).rate,,font2,custom,@_col
                text=text &space(32-len(companyname(basis(a).company)))&companystats(basis(a).company).rate 
            endif
            dis(basis(a).company)=1
        next
        portfolio(2,17)
        a=menu("/Buy/Sell/Exit","",2,12)
        if a=1 then
            b=menu(text &"/Exit",,2,2)
            if b>0 and b<last+1 then
                if cn(b)>0 then
                    dprint "How many shares of "&companyname(cn(b))&" do you want to buy?"
                    amount=getnumber(0,99,0)
                    if player.money>=companystats(cn(b)).rate*amount and amount>0 then
                        amount=buyshares(cn(b),amount)
                        companystats(cn(b)).capital=companystats(cn(b)).capital+amount
                        player.money=player.money-companystats(cn(b)).rate*amount
                        player.tradingmoney=player.tradingmoney-companystats(cn(b)).rate*amount
                    else
                        if amount>0 then dprint "You don't have enough money",14
                    endif
                endif
            endif
        endif
        if a=2 then
            cls
            displayship
            b=getsharetype
            if b>0 then
                c=getshares(b)
                if c>99 then c=99
                dprint "How many shares of "&companyname(cn(b))&" do you want to sell?"
                    
                d=getnumber(0,c,0)
                if d>0 then
                    sellshares(b,d)
                endif
            endif
        endif
    loop until a=3
    return 0
end function

function getsharetype() as short
    dim n(4) as integer
    dim cn(4) as integer
    dim as short a,b
    dim text as string
    for a=0 to lastshare
        n(shares(a).company)+=1
    next
    for a=1 to 4
        if n(a)>0 then
            text=text &companyname(a) &" ("&n(a) &") - "&companystats(a).rate &"/"
            b+=1
            cn(b)=a
        endif
    next
    b=b+1
    if text<>"" then
        text="Company/"&text &"Exit"
        a=menu(text,"",2,2)
        if a<b then 
            return cn(a)
        else
            return -1
        endif
    else
        dprint "You don't own any shares to sell"
    endif
    return -1
end function

function portfolio(x as short,y2 as short) as short
    dim n(4) as integer
    dim as short a,y
    for a=0 to lastshare
        n(shares(a).company)+=1
    next
    locate y,x
    color 15,0
    draw string(x*_fw1,y2*_fh1), "Portfolio:",,font2,custom,@_col
    color 11,0
    y=1
    for a=1 to 4
        if n(a)>0 then 
            locate y,x
            draw string(x*_fw1,y2*_fh1+y*_fh2), companyname(a) &": "& n(a),,font2,custom,@_col
            y+=1
        endif
    next
    
    return 0
end function

function dividend() as short
    dim payout(4) as single
    dim a as short
    for a=0 to lastshare
        if shares(a).company>0 and shares(a).lastpayed<=player.turn-100 then
            payout(shares(a).company)=payout(shares(a).company)+companystats(shares(a).company).rate/10
            shares(a).lastpayed=player.turn
        endif
    next
    for a=1 to 4
        payout(0)=payout(0)+payout(a)
    next
    if payout(0)>1 then
        for a=1 to 4
            if payout(a)>0 then dprint "Your share in "&companyname(a) &" has payed a dividend of "&payout(a) &" Cr."
        next
        player.money=player.money+int(payout(0))
        player.tradingmoney=player.tradingmoney+int(payout(0))
    endif
        
    return 0
end function

function cropstock() as short
    dim as short s,a
    
    for a=0 to 2
        if companystats(basis(a).company).profit>0 then
            if s=0 or companystats(basis(a).company).profit<s then s=companystats(basis(a).company).profit
        endif
    next
    s=s/2
    if s<1 then s=1
    for a=0 to 2
        if companystats(basis(a).company).profit>0 then
            companystats(basis(a).company).profit=companystats(basis(a).company).profit/s
        endif
    next
    return 0
end function

function buyshares(comp as short,n as short) as short
    dim a as short
    if lastshare+n>2048 then n=2048-lastshare
    if n>0 then
        for a=1 to n
            lastshare=lastshare+1
            shares(lastshare).company=comp
            shares(lastshare).bought=player.turn
            shares(lastshare).lastpayed=player.turn
        next
    else
        n=0
    endif
    return n
end function

function sellshares(comp as short,n as short) as short
    dim as short a,b,c
    for a=0 to lastshare
        if shares(a).company=comp and n>0 then
            companystats(shares(a).company).capital-=1
            player.money=player.money+companystats(shares(a).company).rate
            player.tradingmoney=player.tradingmoney+companystats(shares(a).company).rate
            shares(a).company=-1
            n=n-1
        endif
    next
    c=lastshare
    do
        b=0
        for a=0 to c
            if shares(a).company=-1 and lastshare>=0 then
                shares(a)=shares(lastshare)
                lastshare-=1
                b=1
            endif
        next
    loop until b=0 or lastshare<=0
    if lastshare<0 then lastshare=0
    
    return 0
end function

function getshares(comp as short) as short
    dim as short r,a
    for a=0 to lastshare
        if shares(a).company=comp then r+=1
    next
    return r
end function


' trading
function merctrade(f as _fleet) as _fleet
    dim as short st,a
    st=-1
    for a=0 to 2
        if f.c.x=basis(a).c.x and f.c.y=basis(a).c.y then st=a
    next
    if st<>-1 then
        f=unload_f(f,st)
        f=load_f(f,st)
    endif
    return f
end function

function load_f(f as _fleet, st as short) as _fleet
    dim as short curship,curgood,buylevel,vol,suc,a
    dim loaded(5) as short
    dim text as string
    buylevel=11
    do
        vol=0
        for a=1 to 5
            vol=vol+basis(st).inv(a).v
        next
        if vol>0 then
            for a=1 to 5
                if basis(st).inv(a).v>buylevel and curship<16 then
                    do 
                        suc=load_s(f.mem(curship),a,st)
                        if suc=-1 then 
                            curship=curship+1
                        else
                            'save what was loaded
                            loaded(a)=loaded(a)+1
                        endif
                    loop until suc<>-1 or curship>=15
                endif
            next
        endif
        buylevel=buylevel-1
    loop until vol<5 or buylevel<3 or curship>=15
    if basis(st).spy=1 then
        for a=1 to 4
            if loaded(a)>0 then text=text & loaded(a) &" tons of "& basis(st).inv(a).n
            if loaded(a)>0 and loaded(a+1)>0 then text=text &", "
        next
        if loaded(5)>0 then text=text & loaded(a) &" tons of "& basis(st).inv(a).n &"."
        if player.landed.m=0 then dprint "We have a transmission from station "&st+1 &". A trader just left with "&text &".",15    
    endif
    
    return f
end function

function unload_f(f as _fleet, st as short) as _fleet
    dim as short a
    for a=1 to 15
        f.mem(a)=unload_s(f.mem(a),st)
    next
    return f
end function

function unload_s(s as _ship,st as short) as _ship    
    dim as short a,b,c,d,e,f,t
    
    for a=1 to 10
        if s.cargo(a).x>1 then
            if st<=2 then companystats(basis(st).company).profit+=1
            t=s.cargo(a).x-1 'type of cargo
            basis(st).inv(t).v=basis(st).inv(t).v+1  
            s.cargo(a).x=1
            'dprint "sold " &t
        endif
    next
    return s
end function

function load_s(s as _ship, good as short, st as short) as short
    dim as short bay,result,a
    for a=1 to 10
        if s.cargo(a).x=1 and bay=0 then bay=a
    next
    if bay=0 then result=-1
    if bay>0 then
        result=bay
        basis(st).inv(good).v=basis(st).inv(good).v-1
        s.cargo(bay).x=s.cargo(bay).x+good
        'dprint "bought " &good &" stored in "& bay &" Inv:"& basis(st).inv(good).v 
    endif
    return result
end function


'function merctrade(basis as station, merc as pirates) as pirates
'    dim a as short
'    dim f as integer
'    dim high as short
'    dim bought as short
'    dim text as string
'    dim tot as short
'    if merc.con(1)<>9 then 'Not a patrol
'        for a=1 to 5
'            tot=tot+basis.inv(a).v
'        next
'        
'        text="basis inv total:" &tot &"sold:"
'        for a=1 to 14
'            if merc.con(a)>0 then
'                basis.inv(merc.con(a)).v=basis.inv(merc.con(a)).v+1
'                merc.con(15)=merc.con(15)+basis.inv(merc.con(a)).p
'                text=text &merc.con(a) &","
'                merc.con(a)=0
'            endif
'        next
'        high=15
'        bought=0
'        text=text &"bought:"
'        do 
'            for a=1 to 5
'                if basis.inv(a).v>high then
'                    basis.inv(a).v=basis.inv(a).v-1
'                    bought=bought+1
'                    if bought<15 then
'                        merc.con(bought)=a
'                        merc.con(15)=merc.con(15)-basis.inv(a).p
'                        text=text & a &","
'                    endif
'                endif
'            next
'            high=high-1
'        loop until high=0 or bought>3
'        if make_files=1 then
'            f=freefile
'            open "traders.txt" for append as #f
'            print #f,text
'            text="Merc leaves with("& bought &")"
'            for a=1 to 14
'                text=text &merc.con(a)&","
'            next
'            print #f,text
'            print #f,"money:"&merc.con(15)
'            close #f
'        endif
'    endif
'    return merc
'end function
'
sub trading(st as short)
    dim a as short
    if st<3 then
        do
            cls
            displayship()
            displaywares(st)
            a=menu(" /Buy/Sell/Stock Market/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
            if a=3 then stockmarket(st)
        loop until a=4
    else
        do
            cls
            displayship()
            displaywares(st)
            a=menu(" /Buy/Sell/Exit",,2,14)
            if a=1 then buygoods(st)
            if a=2 then sellgoods(st)
            
        loop until a=3
    endif
    cls
end sub

sub buygoods(st as short) 
    dim a as short
    dim c as short
    dim m as short
    dim d as short
    dim p as short
    dim f as short
    dim text as string
    text=stationgoods(st)
        cls
        displayship
        displaywares(st)
        c=menu(text,"",2,3)
        if c<9 then
            
            m=basis(st).inv(c).v
            if basis(st).inv(c).v>0 then
            if m>getfreecargo() then m=getfreecargo
            if m>0 then
                displayship
                displaywares(st)
                dprint "how many tons of "& basis(st).inv(c).n &" do you want to buy?"
                d=getnumber(0,m,0)
                p=basis(st).inv(c).p
                if d>0 and d<=m then 
                    if paystuff(p*d) then
                        for a=1 to d
                            f=getnextfreebay
                            player.cargo(f).x=c+1
                            player.cargo(f).y=basis(st).inv(c).p
                        next
                        player.tradingmoney=player.tradingmoney-(p*d)
                        basis(st).inv(c).v=basis(st).inv(c).v-d
                    endif
                endif
            else
                dprint "No room for additional cargo.",14
                no_key=keyin
            endif
        endif
    endif
    displayship
end sub

sub sellgoods(st as short) 
    dim text as string
    dim a as short
    dim b as short
    dim c as short
    dim em as short
    dim sold as short
    dim m as short
    do
        text=cargobay(st)
        b=0
        em=0
        for a=1 to 10
            if player.cargo(a).x>=1 then b=b+1
            if player.cargo(a).x>1 then em=em+1
        next

        cls
        displaywares(st)
        displayship
        if em>0 then
            c=menu(text,,2,14)
            if c>0 and c<=b then
                if player.cargo(c).x>1 and player.cargo(c).x<10 then
                    m=getinvbytype(player.cargo(c).x-1) ' wie viele insgesamt
                    if player.cargo(c).x<10 then
                        dprint "how many tons of "& basis(st).inv(c).n &" do you want to sell?"
                        sold=getnumber(0,m,0)
                        if sold>0 then
                            player.money=player.money+sold*basis(st).inv(player.cargo(c).x-1).p*(0.8+addtalent(1,6,.01))
                            player.tradingmoney=player.tradingmoney+cint((0.8+addtalent(1,6,.01))*sold*basis(st).inv(player.cargo(c).x-1).p)
            
                            basis(st).inv(player.cargo(c).x-1).v=basis(st).inv(player.cargo(c).x-1).v+sold
                            dprint "sold " & sold & " tons of " & basis(st).inv(player.cargo(c).x-1).n & " for " & cint(basis(st).inv(player.cargo(c).x-1).p*sold*(0.8+addtalent(1,6,.01))) &" Cr."
                            removeinvbytype(player.cargo(c).x-1,sold)
                            no_key=keyin
                            c=b+1
                        endif
                    endif
                endif
            endif
        else
            c=1
        endif
    loop until c>b or em=0
    displayship
end sub

function displaywares(st as short) as short
    dim a as short
    dim t as string
    color 15,0 
    draw string (2*_fw1,2*_fh1),"Wares",,font2,custom,@_col
    draw string (2*_fw1+22*_fw2,2*_fh1),"Price",,font2,custom,@_col
    draw string (2*_fw1+35*_fw2,2*_fh1),"Qut.",,font2,custom,@_col
    draw string (2*_fw1+17*_fw2,2*_fh1+_fh2),"Buy",,font2,custom,@_col
    draw string (2*_fw1+25*_fw2,2*_fh1+_fh2),"Sell",,font2,custom,@_col
    for a=1 to 8
        color 11,0
        draw string(2*_fw1+0*_fw2,3*_fh1+a*_fh2),basis(st).inv(a).n,,font2,custom,@_col
        t=""
        if basis(st).inv(a).p<1000 then t=t &" "
        if basis(st).inv(a).p<100 then t=t &" "
        if basis(st).inv(a).p<10 then t=t &" "
        draw string(2*_fw1+18*_fw2,3*_fh1+a*_fh2),t & basis(st).inv(a).p,,font2,custom,@_col
        t=""
        if cint(basis(st).inv(a).p*.8+addtalent(1,6,.01))<1000 then t=t &" "
        if cint(basis(st).inv(a).p*.8+addtalent(1,6,.01))<100 then t=t &" "
        if cint(basis(st).inv(a).p*.8+addtalent(1,6,.01))<10 then t=t &" "
        draw string(2*_fw1+26*_fw2,3*_fh1+a*_fh2),t &cint(basis(st).inv(a).p*.8+addtalent(1,6,.01)),,font2,custom,@_col
        if basis(st).inv(a).v<10 then
            draw string(2*_fw1+34*_fw2,3*_fh1+a*_fh2)," "& basis(st).inv(a).v,,font2,custom,@_col
        else
            draw string(2*_fw1+34*_fw2,3*_fh1+a*_fh2),""& basis(st).inv(a).v,,font2,custom,@_col
        endif
    next
    return 0
end function

function getfreecargo() as short
    dim re as short
    dim a as short
    for a=1 to 10
        if player.cargo(a).x=1 then re=re+1
    next
    return re
end function

function getnextfreebay() as short
    dim re as short
    dim a as short
    dim b as short
    for a=1 to 10
        if player.cargo(a).x=1 and b=0 then b=a
    next
    return b
end function

function nextemptyc() as short
dim re as short
    dim a as short
    dim b as short
    for a=1 to 10
        if player.cargo(a).x=0 and b=0 then b=a
    next
    return b
end function
function changeprices(st as short,etime as short) as short
    dim a as short
    dim b as short
    dim supply as short
    dim demand as short
    dim change as short
    dim c1 as single
    dim c2 as single
    dim c3 as single
    for a=1 to 8
        basis(st).inv(a).test2=basis(st).inv(a).p
        supply=0
        demand=0
        if basis(st).company=3 then supply+=1
        for b=1 to etime
            if a<6 then
                supply=supply+rnd_range(1,6)
            else
                if st<=5 then
                    if basis(st).company=1 and a=8 then 
                        supply=supply+rnd_range(1,7)
                        demand-=1
                    endif
                    if basis(st).company=2 and a=7 then 
                        supply=supply+rnd_range(1,7)
                        demand-=1
                    endif
                    if basis(st).company=4 and a=6 then 
                        supply=supply+rnd_range(1,7)
                        demand-=1
                    endif
                    if basis(st).company=3 then supply=supply+rnd_range(1,4)
                else
                    demand=-4
                    supply=0
                endif
            endif
            demand=demand+rnd_range(1,6)
        next
        change=supply-demand
        basis(st).inv(a).v=basis(st).inv(a).v+change
        change=demand-supply
        if change>5 then change=5
        if change<-5 then change=-5
        if basis(st).inv(a).v<0 then
            basis(st).inv(a).v=0
            change=change+2
        endif
        if basis(st).inv(a).v>10 then
            basis(st).inv(a).v=10
            change=change-2
        endif
        'market extremes
        basis(st).inv(a).p=basis(st).inv(a).p+fix(basis(st).inv(a).p*change/10)
        if basis(st).inv(a).p<baseprice(a)/2 then 
            basis(st).inv(a).p=baseprice(a)/2
            basis(st).inv(a).v=basis(st).inv(a).v-rnd_range(1,3)
        endif
        if basis(st).inv(a).v<1 then basis(st).inv(a).v=rnd_range(1,3)
        if basis(st).inv(a).p>baseprice(a)*3 then 
            basis(st).inv(a).v=basis(st).inv(a).v+rnd_range(1,3)
            basis(st).inv(a).p=baseprice(a)*3
        endif
    next
    for b=1 to 8
        avgprice(b)=0
        for a=0 to 4
            if a<>3 then
                avgprice(b)=avgprice(b)+basis(a).inv(b).p
            endif
        next
        avgprice(b)=avgprice(b)/4
    next
    return 0
end function

function stationgoods(st as short) as string
    dim as string text,pl 
    dim a as short
    dim off as short
    text=space(18)&"Buy     Sell/"
    for a=1 to 8
        text=text & trim(basis(st).inv(a).n)&space(17-len(trim(basis(st).inv(a).n))) 
        pl=""& basis(st).inv(a).p
        text=text & space(5-len(pl))
        text=text & basis(st).inv(a).p 
        pl=""& cint(basis(st).inv(a).p*.8+addtalent(1,6,.01))
        text=text & space(8-len(pl))
        text=text & cint(basis(st).inv(a).p*.8+addtalent(1,6,.01)) &space(4)
        if basis(st).inv(a).v>=10 then
            text=text & basis(st).inv(a).v
        else
            text=text & " "& basis(st).inv(a).v
        endif
        text=text & "/"
    next
    text=text & "Exit"
    return text
end function

function cargobay(st as short) as string
    dim text as string
    dim a as short
    text="Sell:/"
    for a=1 to 10        
        if player.cargo(a).x=1  then text=text &"Empty/"
        if player.cargo(a).x>1 and player.cargo(a).x<=9 then
            text=text & basis(st).inv(player.cargo(a).x-1).n
            if player.cargo(a).y=0 then
                text=text &" found/"
            else
                text=text & " bought at " &player.cargo(a).y &"/"
            endif
        endif
        if player.cargo(a).x=10 then text=text &"Sealed Box/"
        if player.cargo(a).x=11 then text=text &"TriaxTraders Cargo/"
    next
    text=text &"Exit"
    return text
end function

function getinvbytype(t as short) as short
    dim a as short
    dim r as short
    t=t+1
    for a=1 to 10
        if player.cargo(a).x=t then
            r=r+1
        endif
    next
    return r
end function

function removeinvbytype( t as short, am as short) as short
    dim a as short
    dim b as short
    t=t+1
    for a=1 to 10
        if player.cargo(a).x=t and am>0 then
            player.cargo(a).x=1
            am=am-1
        endif
    next
    return am
end function

sub recalcshipsbays()
    dim soll as short
    dim haben as short
    dim as short a,b,c
    
    dim dif as short
    
    for c=0 to 9
        for b=1 to 9
            if player.weapons(b).desig="" then swap player.weapons(b),player.weapons(b+1) 
            'if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
        next
    next
    
    player.fuelpod=0
    player.crewpod=0
    soll=player.h_maxcargo
    for a=1 to 10
        if a>player.h_maxweaponslot then player.weapons(a)=makeweapon(-1)
        if player.weapons(a).desig="Cargo Bay" then soll=soll+1
        if player.weapons(a).desig="Fuel Tank" then player.fuelpod=player.fuelpod+50
        if player.weapons(a).desig="Crew Quarters" then player.crewpod=player.crewpod+10
    next
    for a=1 to 10
        if player.cargo(a).x>0 then haben=haben+1
    next
    if soll>haben then
        dif=soll-haben
        do
        for a=1 to 10
            if player.cargo(a).x=0 and dif>0 then
                player.cargo(a).x=1
                dif=dif-1
            endif
        next
        loop until dif<=0
    endif
    if haben>soll then
        dif=haben-soll
        for b=1 to 5
            for a=1 to 10
                if player.cargo(a).x=b and dif>0 then
                    player.cargo(a).x=0 
                    dif=dif-1
                endif
            next
        next
    endif
    for c=1 to 9
        for b=1 to 9
          if player.cargo(b).x<player.cargo(b+1).x then swap player.cargo(b),player.cargo(b+1)
      next        
    next
    if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
    if player.security>player.h_maxcrew+player.crewpod+player.cryo then
        player.security=player.h_maxcrew+player.crewpod+player.cryo
        for c=player.security to 128
            crew(c).hp=0
        next    
    endif
    player.addhull=0
    for a=1 to 5
        if player.weapons(a).made=87 then player.addhull=player.addhull+5
    next
    if player.hull>player.h_maxhull+player.addhull then player.hull=player.h_maxhull+player.addhull
end sub

function paystuff(price as integer) as integer
    dim r as short
    r=0
    if player.money<price then
        dprint "you dont have enough money"
    else
        player.money=player.money-price
        displayship()
        r=-1
    endif
    return r
end function

function shop(sh as short,pmod as short,t as string) as short
    dim as short a,b,c,e,v,i
    dim inv(20) as _items
    dim lonest as short
    dim desc as string
    dim l as string
    c=1
    i=20
    for a=1 to 99
        for b=1 to i
        if shopitem(b,sh).ty=a then
            inv(c)=shopitem(b,sh)
            c=c+1
        endif
        next
    next
    
    for b=1 to i
        for a=1 to i-1
            if inv(a).desig="" then inv(a)=inv(a+1)
        next
    next
    b=0
        
    for a=1 to c-1
            l="/" &inv(a).desig & " - "& int(inv(a).price*pmod)
            t=t &l 
            desc=desc &"/"&inv(a).ldesc
            b=b+1
    next
    t=t & "/Exit"
    desc=desc &"/"
    displayship()
    c=menu(t,desc,2,2)
    if c<=b then
        if paystuff(int(inv(a).price*pmod))=-1 then
            player.money=player.money+int(inv(a).price*pmod)
            dprint "How many "&inv(c).desigp &" do you want to buy?"
            v=getnumber(1,99,1)
            if v>0 then
                if paystuff(inv(c).price*v)=-1 then
                    for a=1 to .v
                        e=placeitem(inv(c),0,0,0,0,-1)
                    next
                    if v=1 then
                        dprint "you buy a "&inv(c).desig
                    else
                        dprint "you buy "& v &" "&inv(c).desigp
                    endif
                endif
            endif
        else
            dprint "You don't have enough money"
        endif
    else
        c=-1
    endif
    return c
end function

function rerollshops() as short
    dim as short a,b,i,c,sh,flag,roll
    dim it as _items 
    for a=0 to 20
        for b=0 to 21
            shopitem(a,b)=makeitem(-1)
        next
    next
    
    for i=0 to 19
        a=0
        do
            flag=0
            it=makeitem(0)
            if i<=3 then 'Station Shops
                if a<10 then
                    it=rnd_item(20)
                else
                    it=rnd_item(12)
                endif
            endif
            if i=4 then 'Colony I
                if a=19 then it=makeitem(97)
                if a=18 then it=makeitem(98)
                if a<17 then
                    it=makeitem(rnd_range(1,lstcomit))
                endif
            endif
            if i=5 then 'Pirate Planet
                it=makeitem(rnd_range(1,lstcomit))
            endif
            if i=6 then 'Black market
                it=rnd_item(12)
            endif
            if i=7 then
                it=makeitem(rnd_range(1,73))
            endif
            if i>7 then
                it=rnd_item(rnd_range(1,11))
            endif
            a=1
            do
                if shopitem(a,i).id=it.id then it.desig=""
                if shopitem(a,i).desig="" and it.desig<>"" then 
                    shopitem(a,i)=it
                    it.desig=""
                endif
                a+=1
            loop until it.desig="" or a=20
        loop until a=20
    next
    a=1
    if rnd_range(1,100)<85 then    
        shopitem(a,21)=makeitem(31)
        a+=1
    endif
    
    if rnd_range(1,100)<55 then    
        shopitem(a,21)=makeitem(32)
        a+=1
    endif
    if rnd_range(1,100)<15 then    
        shopitem(a,21)=makeitem(33)
        a+=1
    endif
    
    if rnd_range(1,100)<85 then    
        shopitem(a,21)=makeitem(56)
        a+=1
    endif
    if rnd_range(1,100)<55 then    
        shopitem(a,21)=makeitem(57)
        a+=1
    endif
    if rnd_range(1,100)<15 then    
        shopitem(a,21)=makeitem(58)
        a+=1
    endif
    if rnd_range(1,100)<85 then    
        shopitem(a,21)=makeitem(36)
        a+=1
    endif
    if rnd_range(1,100)<55 then    
        shopitem(a,21)=makeitem(37)
        a+=1
    endif
    if rnd_range(1,100)<35 then    
        shopitem(a,21)=makeitem(62)
        a+=1
    endif
    if rnd_range(1,100)<25 then    
        shopitem(a,21)=makeitem(63)
        a+=1
    endif
    if rnd_range(1,100)<15 then    
        shopitem(a,21)=makeitem(64)
        a+=1
    endif
    if rnd_range(1,100)<55 then    
        shopitem(a,21)=makeitem(67)
        a+=1
    endif
    if rnd_range(1,100)<25 then    
        shopitem(a,21)=makeitem(68)
        a+=1
    endif
    if rnd_range(1,100)<15 then    
        shopitem(a,21)=makeitem(69)
        a+=1
    endif
    for b=0 to 5
        i=0
        c=0
        if b=5 then sh=1
        for a=1 to 4+sh
            if rnd_range(1,100)<(130-(c*10)+(sh*20)) then
                i=i+1
                if i>20 then i=20
                makew(i,b)=a
            endif
            c=c+1
        next
        c=0
        for a=6 to 9+sh
            if rnd_range(1,100)<(130-(c*10)+(sh*20)) then
                i=i+1
                if i>20 then i=20
                makew(i,b)=a
            endif
            c=c+1
        next
        c=0
        if sh>0 then
            for a=11 to 14
                if rnd_range(1,100)<(100-(c*10)+(sh*20)) then
                    i=i+1
                    if i>20 then i=20
                    makew(i,b)=a
                endif
                c=c+1
            next
        endif
        
        for a=87 to 99
            if rnd_range(1,100)<55 then
                i+=1
                if i>20 then i=20
                makew(i,b)=a
            endif
        next
    next
    
    return 0
end function

function buysitems(desc as string,ques as string, ty as short, per as single=1,aggrmod as short=0) as short
    dim as short a,b,answer,price
    dim text as string
    if _autosell=0 then 
        dprint desc & " (autoselling on)"
    else
        dprint desc & " (autoselling off)"
    endif
    if ques<>"" then
        answer=askyn(ques)
    else
        answer=-1
    endif
        
    if  answer=-1 then
        if _autosell=1 or ty=999 then
            do
                a=getitem(-1,ty,1)
                if a>0 then 
                    if (item(a).ty=ty or ty=999) and item(a).w.s=-1  then
                        if item(a).ty<>26 then
                            price=cint(item(a).price*per)
                        else
                            price=cint(item(a).v1*50*per)
                        endif
                        if _autosell=1 or b=0 then b=askyn("Do you want to sell the "&item(a).desig &" for "& price &" Cr.?(y/n)")             
                        if b=-1 then    
                            dprint "you sell the "&item(a).desig &" for " &price & " Cr."
                            player.money=player.money+price
                            reward(2)=reward(2)-item(a).v5                        
                            player.tradingmoney=player.tradingmoney+price
                            player.merchant_agr=player.merchant_agr+(item(a).price/disnbase(player.c))/100*aggrmod
                            player.pirate_agr=player.pirate_agr-(item(a).price/dispbase(player.c))/100*aggrmod
                            destroyitem(a)                
                        endif
                    endif
                endif
            loop until a<0
        else            
            for a=0 to lastitem
                if item(a).ty<>26 then
                    price=cint(item(a).price*per)
                else
                    price=cint(item(a).v1*50*per)
                endif
                if item(a).ty=ty and item(a).w.s=-1 then
                    text=text &"You sell the "&item(a).desig &" for "& price & " Cr. "
                    player.money=player.money+price
                    reward(2)=reward(2)-item(a).v5                        
                    player.tradingmoney=player.tradingmoney+price
                    player.merchant_agr=player.merchant_agr+(item(a).price/disnbase(player.c))/100*aggrmod
                    player.pirate_agr=player.pirate_agr-(item(a).price/dispbase(player.c))/100*aggrmod
                    destroyitem(a)
                endif
            next
            if text<>"" then
                dprint text
            else
                dprint "You couldn't sell anything."
            endif
            
        endif
    endif
    return 0
end function

    
