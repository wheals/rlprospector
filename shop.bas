function reroll_shops() as short
    dim as short a,b,i,c,sh,flag,roll,spec,shopno
    dim  as _items it,delit
    dim sortinvlist(20) as _items
    dim dummynumber(20) as short
    for shopno=0 to 29
        for a=0 to 20
            shopitem(a,shopno)=delit 'Delete Item
        next
    next
    
    for i=0 to 24
        if i<>20 then
        b=0
        a=1
        do
            b+=1
            flag=0
            it=delit 'Delete Item
            if i<=3 then 'Station Shops
                spec=basis(i).shop(sh_equipment)
                if a<=5 then
                    it=rnd_item(RI_StandardShop)
                else
                    if spec=1 then it=rnd_item(RI_ShopExplorationGear)
                    if spec=2 then 
                        if rnd_range(1,100)<50 then 
                            it=rnd_item(RI_WeakWeapons)
                        else
                            it=rnd_item(RI_WeakStuff)
                        endif
                    endif
                    if spec=3 then it=rnd_item(RI_ShopSpace)
                    if spec=4 then it=rnd_item(RI_ShopWeapons)
                endif
                it.w.x=rnd_range(10,50-it.v1)
            endif
            if i=4 then 'Colony I
                if b=19 then it=make_item(97)'Disintegrator
                if b=18 then it=make_item(98)'adaptive bodyarmor
                if b<17 then
                    it=make_item(RI_Standardshop)
                endif
                it.w.x=rnd_range(1,15-it.v1)
            endif
            if i=6 then 'Black market
                it=rnd_item(RI_AllButWeaponsAndMeds)
                it.w.x=rnd_range(1,15-it.v1)
            endif
            if i=7 then 'Mudds
                if b=1 then 
                    it=make_item(250)
                else
                    it=make_item(rnd_range(1,80))
                endif
                it.w.x=rnd_range(5,10)
            endif
            if i=5 or (i>7 and i<21) then
                if a<=3 then
                    it=make_item(31+a)
                endif
                it=rnd_item(RI_StandardShop)
                it.w.x=rnd_range(5,10-it.v1)
            endif
            
            if i>=21 and i<=24 then 'Medical supplies
                select case rnd_range(1,100)
                case 1 to 18
                    it=rnd_item(RI_Infirmary)
                    it.w.x=rnd_range(1,3)
                case 19 to 60
                    it=rnd_item(RI_Medpacks)
                    it.w.x=rnd_range(10,60)
                case 61 to 80
                    it=rnd_item(RI_KODrops)
                    it.w.x=rnd_range(10,60)
                case else
                    it=rnd_item(RI_Cage)
                    it.w.x=rnd_range(10,25)
                end select
            endif
            
            for c=1 to 20
                if shopitem(c,i).desig="" then
                    shopitem(c,i)=it
                    a+=1
                    exit for
                endif
                if shopitem(c,i).id=it.id then exit for
            next
        loop until a>=20 or (i=20 and a>=15) or (i>=21 and a>=10)
        endif
    next
    
    'Engine Sensors Shieldshop
    a=0
    roll=rnd_range(1,90)+player.turn/2500
    if roll>0 then 
        a+=1
        shopitem(a,20)=make_shipequip(1)
    endif
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(2)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(3)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(4)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(5)
    endif
    
    roll=rnd_range(1,90)+player.turn/2500
    if roll>0 then 
        a+=1
        shopitem(a,20)=make_shipequip(6)
    endif
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(7)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(8)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(9)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(10)
    endif
    
    roll=rnd_range(1,90)+player.turn/2500
    if roll>10 then 
        a+=1
        shopitem(a,20)=make_shipequip(11)
    endif
    if roll>25 then 
        a+=1
        shopitem(a,20)=make_shipequip(12)
    endif
    if roll>75 then 
        a+=1
        shopitem(a,20)=make_shipequip(13)
    endif
    if roll>90 then 
        a+=1
        shopitem(a,20)=make_shipequip(14)
    endif
    for b=15 to 23
        if rnd_range(1,100)<50 and a<=19 then 
            a+=1
            shopitem(a,20)=make_shipequip(b)
        endif
    next
    a+=1
    if a>20 then a=20
    shopitem(a,20)=make_shipequip(21)
    'Droneshop
    c=1
    
    for b=50 to 55 
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b)
            shopitem(c,25).w.x=rnd_range(1,20)
            c+=1
        endif
    next
    if rnd_range(1,100)<77 then 
        c+=1
        shopitem(c,25)=make_item(30)'Comsat
        shopitem(c,25).w.x=rnd_range(1,20)
    endif
    
    for b=100 to 102
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b,,25)
            shopitem(c,25).w.x=rnd_range(1,20)
            c+=1
        endif
    next
    
    for b=104 to 105
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b)
            shopitem(c,25).w.x=rnd_range(1,20)
            c+=1
        endif
    next
    
    for b=110 to 112
        if rnd_range(1,100)<77 then
            shopitem(c,25)=make_item(b,,25)
            shopitem(c,25).w.x=rnd_range(1,20)
            c+=1
        endif
    next
    
    for b=0 to 3 'Module Stores in spacestations
        for i=1 to 10
            select case basis(b).shop(sh_modules)
            case ms_energy
                makew(i,b)=rnd_range(6,10)
            case ms_projectile
                makew(i,b)=rnd_range(1,5)
            case ms_modules
                if rnd_range(1,100)<66 then
                    makew(i,b)=rnd_range(84,99)
                else
                    makew(i,b)=rnd_range(97,99)
                endif
            end select
        next
        for i=11 to 15
            makew(i,b)=rnd_range(84,99)
        next
        c=16
        for i=16 to 19
            if rnd_range(1,100)<20+player.turn/1000 then
                select case rnd_range(1,100)
                case 1 to 33
                    makew(c,b)=rnd_range(4,5)
                case 34 to 66
                    makew(c,b)=rnd_range(9,10)
                case else
                    makew(c,b)=rnd_range(84,99)
                end select
                c+=1
            endif
        next
    next
    
    
    for b=4 to 5 'Shipweapons shops
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
        
        for a=84 to 99
            if rnd_range(1,100)<55 then
                i+=1
                if i>20 then i=20
                makew(i,b)=a
            endif
        next
    next
    
    
    
    for b=26 to 29
        i=0
        i+=1
        shopitem(i,b)=make_item(75)
        shopitem(i,b).w.x=rnd_range(1,6)
        if rnd_range(1,100)<50 then
           i+=1
           shopitem(i,b)=make_item(76)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        
        i+=1
        shopitem(i,b)=make_item(104)
        shopitem(i,b).w.x=rnd_range(1,6)
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(105)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        
        i+=1
        shopitem(i,b)=make_item(100)
        if rnd_range(1,100)<75 then
           i+=1
           shopitem(i,b)=make_item(101)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(102)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        
        i+=1
        shopitem(i,b)=make_item(110)
        shopitem(i,b).w.x=rnd_range(1,6)
        if rnd_range(1,100)<75 then
           i+=1
           shopitem(i,b)=make_item(111)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        if rnd_range(1,100)<25 then
           i+=1
           shopitem(i,b)=make_item(112)
           shopitem(i,b).w.x=rnd_range(1,6)
        endif
        
        'sort_items(shopitem(,b))
    next
    for i=1 to 8
        usedship(i).x=rnd_range(1,12)
        usedship(i).y=rnd_range(0,3)
    next
    
    for i=1 to 12
        select case rnd_range(1,100)
        case 1 to 50
            it=rnd_item(RI_weakweapons)
        case 51 to 90
            it=rnd_item(RI_weakstuff)
        case else
            it=rnd_item(RI_shopexplorationgear)
        end select
        it.res=it.res/1.2
        it.w.x=1
        shopitem(i,30)=it
    next
            
    
    return 0
end function

function buysitems(desc as string,ques as string, ty as short, per as single=1,aggrmod as short=0) as short
    dim as integer a,b,answer,price,really
    dim text as string
    if configflag(con_autosale)=0 then 
        dprint desc & " (autoselling on)"
    else
        dprint desc & " (autoselling off)"
    endif
    if ques<>"" then
        answer=askyn(ques)
    else
        answer=-1
    endif
    if answer=-1 then
        if configflag(con_autosale)=1 or ty=0 then
            do
                set__color(11,0)
                cls
                a=get_item()
                if a>0 then 
                    if (item(a).ty=ty or ty=0) and item(a).w.s<0  then
                        if item(a).ty<>26 then
                            price=cint(item(a).price*per)
                        else
                            price=cint(item(a).v1*25*per)
                        endif
                        if configflag(con_autosale)=1 or b=0 then b=askyn("Do you want to sell the "&item(a).desig &" for "& price &" Cr.?(y/n)")             
                        if item(a).w.s=-2 and b=-1 then b=askyn("The "&item(a).desig &" is in use. do you really want to sell it?(y/n)")
                        if b=-1 then    
                            dprint "you sell the "&item(a).desig &" for " &price & " Cr."
                            addmoney(price,mt_trading)
                            reward(2)=reward(2)-item(a).v5               
                            factionadd(0,1,item(a).price/disnbase(player.c)/100*aggrmod)
                            factionadd(0,2,-item(a).price/disnbase(player.c)/100*aggrmod)
                            destroyitem(a)    
                            b=0
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
                    addmoney(price,mt_trading)
                    if item(a).ty=15 then reward(2)=reward(2)-item(a).v5                        
                    factionadd(0,1,item(a).price/disnbase(player.c)/100*aggrmod)
                    factionadd(0,2,-item(a).price/disnbase(player.c)/100*aggrmod)
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

function customize_item() as short
    dim as integer a,b,i,i2,j,price,c,nr
    dim as string t
    dim as byte debug=0
    do
        set__color(11,0)
        cls
        display_ship()
        a=menu(bg_awayteamtxt,"Customize item/Increase accuracy/Add camo/Add imp. Camo/Acidproof/Exit")
        set__color(11,0)
        cls
        display_ship()
        if a=1 then
            i=get_item(2,4)
            if i>0 then
                dprint "Let's take a look at your "&item(i).desig &"."
                if item(i).v3<4 then
                    nr=count_items(item(i))
                    if nr>1 then 
                        dprint "How many?(1-"&nr &")"
                        nr=getnumber(0,nr,0)
                    endif
                    if debug=1 and _debug=1 then dprint ""&nr
                    price=(item(i).v3+1)*(item(i).v3+1)*100*nr*haggle_("down")
                    if askyn("That will cost "&price &" Cr.(y/n)") then
                        if paystuff(price) then 
                            for j=1 to nr
                                i=lowest_by_id(item(i).id)
                                item(i).id+=2000
                                item(i).v3+=1
                                t=left(item(i).ldesc,instr(item(i).ldesc,"| |"))
                                for c=1 to len(item(i).ldesc)
                                    if mid(item(i).ldesc,c,1)<>"|" then
                                        t=t &mid(item(i).ldesc,c,1)
                                    else
                                        exit for
                                    endif
                                next
                            next
                        endif
                    endif
                endif
            else
                dprint "Come back when you have a weapon to modify."
            endif
        endif
        if a=2 or a=3 then
            i=get_item(3)
            if i>0 then
                dprint "Let's take a look at your "&item(i).desig &"."
                nr=count_items(item(i))
                if nr>1 then 
                    dprint "How many?(1-"&nr &")"
                    nr=getnumber(0,nr,0)
                endif
                i2=lowest_by_id(item(i).id)
                if i2>0 then i=i2
                if a=2 then price=100
                if a=3 then price=250
                if item(i).v2>0 then 
                    dprint "That suit is already camoflaged."
                else
                    price=price*nr*haggle_("down")
                    if askyn("that will cost "&price &" Cr.(y/n)") then
                        if paystuff(price) then
                            if a=2 then 
                                item(i).id+=1200
                                item(i).v2=1
                                item(i).desig="Camo "&item(i).desig
                            endif
                            if a=3 then 
                                item(i).id+=1300
                                item(i).v2=3
                                item(i).desig="Imp. Camo "&item(i).desig
                            endif
                        endif
                    endif
                endif
            else
                dprint "Come back when you have a suit to modify."
            endif
        endif
        if a=4 then
            i=get_item()
            if i>0 then
                dprint "Let's take a look at your "&item(i).desig &"."
                price=50*haggle_("down")
                if askyn("That will cost " &price & " cr.(y/n)") then
                    if paystuff(price) then
                        item(i).id+=1500
                        item(i).res=120
                        item(i).desig="Acidproof "&item(i).desig
                    endif
                endif
            else
                dprint "Come back when you have something to acidproof."
            endif
        endif
    loop until a=5
    return 0
    
end function

function used_ships() as short
    dim as short yourshipprice,i,a,yourshiphull,price(8),l
    dim s as _ship
    dim as single pmod
    dim as string mtext,htext,desig(8)
    do
        yourshiphull=player.h_no
        s=gethullspecs(yourshiphull,"data/ships.csv")
        yourshipprice=s.h_price*.1
        mtext="Used ships (" &credits(yourshipprice)& " Cr. for your ship.)/"
        htext="/"
        for i=1 to 8
            pmod=(80-usedship(i).y*3)/100
            s=gethullspecs(usedship(i).x,"data/ships.csv")
            l=len(trim(s.h_desig))+len(credits(s.h_price*pmod))
            mtext=mtext &s.h_desig &space(45-l)&credits(s.h_price*pmod) &" Cr./"
            price(i)=s.h_price*pmod-yourshipprice
            desig(i)=s.h_desig
            htext=htext &makehullbox(s.h_no,"data/ships.csv") &"/"
        next
        mtext=mtext &"Bargain bin/Sell equipment/Exit"
        a=menu(bg_shiptxt,mtext,htext,2,2)
        if a>=1 and a<=8 then
            if buy_ship(usedship(a).x,desig(a),price(a)) then
                usedship(a).x=yourshiphull
                player.cursed=usedship(a).y
                usedship(a).y=0
            endif
        endif
        if a=9 then 
            do
                cls
            loop until shop(30,0.8,"Bargain bin")=-1
        endif
        if a=10 then buysitems("","",0,.5)
    loop until a=11 or a=-1        
    return 0
end function

function make_shop_menu(sh as short,pmod as single,inv() as _items,c as short,byref order as short,byref ex as short,t as string,desc as string) as short
    dim as short a,b
    b=1
    for a=1 to c-1
        if inv(a).w.x>1 then
            t=t &"/" &inv(a).w.x &" "&inv(a).desigp & space(_swidth-len(" "&inv(a).w.x)-len(trim(inv(a).desigp))-len(credits(inv(a).price*pmod))) & credits(int(inv(a).price*pmod)) &" Cr." 
        else
            t=t &"/" &inv(a).w.x &" "&inv(a).desig & space(_swidth-len(" "&inv(a).w.x)-len(trim(inv(a).desig))-len(credits(inv(a).price*pmod))) & credits(int(inv(a).price*pmod)) &" Cr." 
        endif
        desc=desc &"/"&inv(a).describe
        b=b+1
    next
    if sh<=3 then
        order=b
        b+=1
        t=t &"/Order Item"
        desc=desc &"/Order an item not in stock for double the price"
    endif
    ex=b
    t=t & "/Exit"
    desc=desc &"/"
    return 0
end function


function shop(sh as short,pmod as single,shopn as string,qty as byte=0) as short
    dim as short a,b,c,e,v,i,best,order,ex
    dim as string t
    dim inv(20) as _items
    dim lonest as short
    dim desc as string
    dim l as string
    if _debug>0 then qty=1
    c=1
    i=20
    order=-2
    if sh<=2 then
        if shoporder(sh)<0 then
            dprint  "Your ordered "&make_item(abs(shoporder(sh))).desig &" has arrived.",c_gre
            shoporder(sh)=0
        endif
    endif
    for a=1 to 9999
        for b=1 to i
            if shopitem(b,sh).ty=a then
                inv(c)=shopitem(b,sh)
                if inv(c).w.x<=0 then inv(c).w.x=1
                c=c+1
            endif
        next
    next
        
    sort_items(inv())
    
    for b=1 to i
        for a=1 to i-1
            if inv(a).desig="" then inv(a)=inv(a+1)
        next
    next
    t=shopn
    make_shop_menu(sh,pmod,inv(),c,order,ex,t,desc)    
    display_ship()
    dprint("")
    c=menu(bg_parent,t,desc,2,2)
    dprint "C:"&c
    select case c
    case order
        place_shop_order(sh)
    case ex,-1
        return -1
    case else
        select case inv(c).ty
        case 150'sensors
            if inv(c).v1<player.sensors then dprint "You already have better sensors."
            if inv(c).v1=player.sensors then dprint "These sensors aren't better than the one you already have."
            if inv(c).v1>player.h_maxsensors then dprint "These sensors don't fit in your ship."
            if inv(c).v1>player.sensors and inv(c).v1<=player.h_maxsensors then
                if paystuff(inv(c).price*pmod) then 
                    player.sensors=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 151'engine
            if inv(c).v1<player.engine then dprint "You already have a better engine."
            if inv(c).v1=player.engine then dprint "this engine isn't better than the one you already have."
            if inv(c).v1>player.h_maxengine then dprint "This engine doesn't fit in your ship."
            if inv(c).v1>player.engine and inv(c).v1<=player.h_maxengine then
                if paystuff(inv(c).price*pmod) then
                    player.engine=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 152'shield
            if inv(c).v1<player.shieldmax then dprint "You already have a better shieldgenerator."
            if inv(c).v1=player.shieldmax then dprint "This shield generator isn't better than the one you already have."
            if inv(c).v1>player.h_maxshield then dprint "This shield generator doesn't fit in your ship."
            if inv(c).v1>player.shieldmax and inv(c).v1<=player.h_maxshield then
                if paystuff(inv(c).price*pmod) then
                    player.shieldmax=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 153 'Shipdetection
            if inv(c).v1<player.equipment(se_shipdetection) then dprint "You already have a better ship detection system."
            if inv(c).v1=player.equipment(se_shipdetection) then dprint "You already have the same ship detection system."
            if inv(c).v1>player.equipment(se_shipdetection) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_shipdetection)=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
        case 154 'navcomp
            if inv(c).v1=player.equipment(se_navcom) then dprint "You already have a navigational computer."
            if inv(c).v1>player.equipment(se_navcom) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_navcom)=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
            
        case 155 'ECM
            if inv(c).v1<player.equipment(se_ECM) then dprint "You already have a better ECM system."
            if inv(c).v1=player.equipment(se_ECM) then dprint "You already have the same ECM system."
            if inv(c).v1>player.equipment(se_ECM) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_ECM)=inv(c).v1
                    dprint "You buy a "&inv(c).desig &"."
                endif
            endif
            
        case 156 'Cargoshielding
            if inv(c).v1<player.equipment(se_CargoShielding) then dprint "You already have better cargo shielding."
            if inv(c).v1=player.equipment(se_CargoShielding) then dprint "You already have the same cargo shielding."
            if inv(c).v1>player.equipment(se_CargoShielding) then 
                if paystuff(inv(c).price*pmod) then player.equipment(se_CargoShielding)=inv(c).v1
            endif
        case 157 'Fuelsystem
            if inv(c).v1<player.equipment(se_Fuelsystem) then dprint "You already have a better fuel system."
            if inv(c).v1=player.equipment(se_Fuelsystem) then dprint "You already have the same fuel system."
            if inv(c).v1>player.equipment(se_Fuelsystem) then 
                if paystuff(inv(c).price*pmod) then 
                    player.equipment(se_fuelsystem)=inv(c).v1
                    player.fueluse=1-inv(c).v1/10
                    dprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
            
                endif
            endif
        case 21
            best=findbest(21,-1)
            if best>0 then
                if item(best).v1>inv(c).v1 then dprint "you already have a better infirmary"
                if item(best).v1=inv(c).v1 then dprint "you already have such an infirmary"
                if item(best).v1<inv(c).v1 then 
                    if paystuff(inv(c).price*pmod) then 
                        placeitem(inv(c),inv(c).w.x,0,0,0,-1)'player already has one and t his one is better
                        inv(c).w.x-=1
                        dprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
                    endif
                endif
            else
                if paystuff(inv(c).price*pmod) then 
                    placeitem(inv(c),inv(c).w.x,0,0,0,-1)'player already has one and t his one is better
                    inv(c).w.x-=1
                    dprint "You buy " &add_a_or_an(inv(c).desig,0) & "."
                endif
            endif
        
        case else
            if paystuff(int(inv(c).price*pmod))=-1 then
                player.money=player.money+int(inv(c).price*pmod)'Giving back
                dprint "How many "&inv(c).desigp &" do you want to buy? (Max: " &minimum(inv(c).w.x,fix(player.money/(inv(c).price*pmod))) &")"
                v=getnumber(0,minimum(inv(c).w.x,fix(player.money/(inv(c).price*pmod))) ,0)
                if v>0 then
                    if paystuff(inv(c).price*pmod*v)=-1 then
                        for a=1 to v
                            uid+=1
                            inv(c).uid=uid
                            placeitem(inv(c),inv(c).w.x,0,0,0,-1) 'X is necesarry because that is where we store the number of items in the shop
                        next
                        if v=1 then
                            dprint "you buy "&add_a_or_an(inv(c).desig,0) & " for "& credits(int(inv(c).price*pmod))&" Cr."
                        else
                            dprint "you buy "& v &" "&inv(c).desigp &" for "&credits(int(inv(c).price*pmod*v)) &" Cr."
                        endif
                        inv(c).w.x=inv(c).w.x-v
                        if inv(c).w.x=0 then
                            for a=c to 19 
                                inv(a)=inv(a+1)
                            next
                            inv(20)=inv(0)
                            t=shopn
                            desc=""
                            make_shop_menu(sh,pmod,inv(),c,order,ex,t,desc)    
    
                        endif
                    endif
                endif
            endif
        end select
    end select
    for b=1 to 20
        shopitem(b,sh)=inv(b)
    next
    return c
end function

function place_shop_order(sh as short) as short
    dim as string t,w
    dim as short a,b,f
    dim as single bestmatch,bmc,candidate,s,l
    dim tried(1080) as byte
    dim as _cords p
    dim as _items i
    p=locEOL
    dprint "What would you like to order?"
    dprint t,15
    t=gettext(p.x,p.y,26,t)
    t=ucase(t)
    f=0
    do
    bestmatch=9999
    f+=1
    for a=1 to 1080
        i=make_item(a)
        i.desig=ucase(i.desig)
        l=len(i.desig)
        w=""
        if i.desig<>"" then
            if trim(ucase(i.desig))=trim(ucase(t)) and tried(a)=0 then
                candidate=a
                bestmatch=0
            else
                for b=1 to l
                    w=w &mid(i.desig,b,1)
                    print #f,w
                    if mid(i.desig,b,1)=" " or b=l then
                        s=fuzzymatch(w,t)
                        if s<bestmatch and tried(a)=0 then
                            candidate=a
                            bestmatch=s
                        endif
                        w=""
                    endif
                next
            endif
        endif
    next
    if bestmatch<0.4 then
        i=make_item(candidate)
        if askyn("Do you want to order "&add_a_or_an(i.desig,0) &"? (y/n)") then
            shoporder(sh)=candidate
            dprint "I can't say for certain when it will arive, but it should be here soon."
            f=3
            candidate=0
        else
            tried(candidate)=1
        endif
    else
        dprint "I don't think I ever heard of those."
        f=3
    endif
    loop until f=3
    return 0
end function


Function fuzzymatch( s As String, t As String ) As single
    dim as string dic
    Dim As Integer k, i, j, n, m, cost
    dim as single dis
    Dim As Integer Ptr d
    dim as short  f
        f=freefile
        open "data/dictionary.txt" for input as #f
        while not eof(f)
            line input #f,dic
            if ucase(trim(t))=ucase(trim(dic)) then t=""
        wend
        close f
       s=trim(s)
       t=trim(t)
    n = Len(s)
    m = Len(t)
    
    If (n <> 0) And (m <> 0) Then
       
       d = allocate( sizeof(Integer) * (m+1) * (n+1) )
       m += 1
       n += 1
       k = 0
    
       While k < n
          d[k]=k
          k += 1
       Wend
    
       k = 0
       While k < m
          d[k*n]=k
          k += 1
       Wend
    
       i = 1
       While i < n
          j = 1
    
          While j<m
             If (s[i-1] = t[j-1]) Then
                cost = 0
    
             Else
                cost = 1
    
             End If
    
             d[j*n+i] = lev_minimum(d[(j-1)*n+i]+1, d[j*n+i-1]+1, d[(j-1)*n+i-1]+cost)
    
             j += 1
          Wend
    
          i += 1
       Wend
    
       dis = d[n*m-1]
       deallocate d
        if n>m then 
            dis=dis/n
        else
            dis=dis/m
        endif
       Return dis
    
    Else
       Return -1
    
    End If
    
End Function

function mudds_shop() as short
    dim as short a,b
    dprint "An overweight gentleman greets you 'Welcome to Mudds Incredible Bargains' Do you wish to buy or sell?"
    do
        display_ship
        a=menu(bg_parent,"Mudds Shop/Buy/Sell/Exit")
        if a=1 then 
            do
                b=shop(7,2.5,"Mudds Incredible Bargains")
                display_ship
            loop until b=-1
        endif
        if a=2 then buysitems("","",0,.1)
    loop until a=3 or a=-1
    return 0
end function

function sell_alien(sh as short) as short
    dim t as string
    dim as short i,c,biodata
    if lastcagedmonster=0 then
        dprint "You have nothing to sell."
        return 0
    endif
    do
        t="Sell liveform:"
        for i=1 to lastcagedmonster
            t=t &"/"&cagedmonster(i).sdesc
        next
        t=t & "/Exit"
        c=menu(bg_parent,t)
        if c>0 and c<=lastcagedmonster then
            biodata=get_biodata(cagedmonster(c))
            select case sh
            case slse_arena
                biodata=biodata*(cagedmonster(c).weapon+cagedmonster(c).armor)
            case slse_zoo
                biodata=biodata*1.1
            case slse_slaves
                if cagedmonster(c).lang>1 or (cagedmonster(c).intel>1 and cagedmonster(c).intel<5) then
                    biodata=cagedmonster(c).hpmax*cagedmonster(c).intel*cagedmonster(c).pumod/5
                else
                    biodata=0
                endif
            end select
            if biodata>0 then
                if askyn("I would give you "&credits(biodata)&"Cr. for your "&cagedmonster(c).sdesc &"(y/n)") then
                    addmoney(biodata,mt_piracy)
                    biodata=get_biodata(cagedmonster(c))
                    item(cagedmonster(c).c.s).v3-=biodata'Remove the biodata from the cage
                    reward(1)-=biodata
                    cagedmonster(c)=cagedmonster(lastcagedmonster)
                    lastcagedmonster-=1
                endif
            else
                dprint "I wouldn't know what to do with that."
            endif
            c=0
        endif
    loop until c=-1 or c=lastcagedmonster+1 or lastcagedmonster=0
    return 0
end function

function botsanddrones_shop() as short
    dim as integer a,b,c,il(lastitem),price
    dim as string wreckquestion
    price=15*haggle_("UP")
    do
    display_ship
    dprint "Welcome to the Bot-Bin! This sectors most sophisticated 2nd hand robot store."
    a=menu(bg_parent,"The Bot-bin/Buy/Sell/Exit")
    if a=1 then 
        do
            b=shop(25,0.8,"The Bot-bin")
            display_ship
        loop until b=-1
    endif
    if a=2 then
        if askyn("Always looking for spare parts we offer " &price & " Cr. for bot and rover debris. Do you want to sell? (y/n)") then
            for b=0 to lastitem
                if item(b).w.s<0 then
                    if item(b).id=65 then
                        c+=1
                        il(c)=b
                    endif
                endif
            next
            if c>0 then
                if c=1 then wreckquestion="You have "&c &" wreck. Do you want to sell them?(y/n)"
                if c>1 then wreckquestion="You have "&c &" wrecks. Do you want to sell them?(y/n)"
                if askyn(wreckquestion) then
                    addmoney(c*price,mt_quest2)
                    for b=1 to c
                        item(il(b)).w.s=99
                    next
                    for b=0 to lastitem
                        if item(b).w.s=99 then
                            item(b)=item(lastitem)
                            lastitem-=1
                        endif
                    next
                endif
            else
                dprint "You don't have any debris to sell."
            endif
        endif
    endif
    loop until a=3
    return 0
end function

