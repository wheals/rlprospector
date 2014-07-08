function buytitle() as short
    dim as short a,b
    dim as integer price
    dim as string title
    dim sameorbetter as byte
    a=menu(bg_parent,"Buy title /Lord - 1,000 Cr./Baron - 5,000 Cr./Viscount - 10,000 Cr./Count 25,000 Cr./Marquees - 50,000 Cr./Duke - 100,000 Cr./Exit")
    if a>0 and a<7 then
        if a=1 then
            title="Lord"
            price=1000
        endif
        if a=2 then
            title="Baron"
            price=5000
        endif
        if a=3 then
            title="Viscount"
            price=10000
        endif    
        if a=4 then
            title="Count"
            price=25000
        endif
        if a=5 then
            title="Marquese"
            price=50000
        endif
        if a=6 then
            title="Duke"
            price=100000
        endif
        for b=1 to 6
            if retirementassets(b+8)=1 and a<b then sameorbetter=1
        next
        if retirementassets(a+8)=0 and sameorbetter=0 then
            if paystuff(price) then
                retirementassets(a+8)=1
            endif
        else
            dprint "You already have a better title."
        endif
    endif
    
    return 0
end function



function retirement() as short
    dim as short a,b
    dim price(9) as integer
    dim asset(9) as string
    dim desc(9) as string
    dim as string mtext,htext
    asset(1)="Mudds store franchise"
    desc(1)="A permit to operate a store under the well known 'Mudds' brand name. The opportunity to make a living by buying at insanely low prices, at negligable risk!"
    price(1)=500
    asset(2)="life insurance"
    desc(2)="A small rent to be paid until your death, from your 60th birthday onwards."
    price(2)=1000
    asset(3)="country manor"
    desc(3)="A nice estate in the country on a civilized World. Perfect to spend the autumn years of life."
    price(3)=2500
    asset(4)="small asteroid"
    desc(4)="A small asteroid in a colonized star system. Several rooms with lifesupport already carved out."
    price(4)=5000
    asset(5)="hollowed asteroid base"
    desc(5)="A small asteroid, hollowed out, with a small self sufficient ecosystem. Enough room in the shell to house a small towns population."
    price(5)=50000
    asset(6)="big terraformed asteroid"
    desc(6)="A large asteroid, big enough to hold a thin atmosphere, terraformed, self sufficient, and yet uninhabited."
    price(6)=100000
    asset(7)="small planet"
    desc(7)="A small, arid planet. Thin oxygen atmosphere. Further terraforming possible"
    price(7)= 250000
    asset(8)="planet"
    desc(8)="A medium sized planet with an oxygen atmosphere. It's habitable, but further terraforming would be a good investment"
    price(8)=500000
    asset(9)="Earthlike planet"
    desc(9)="A planet with an oxygen atmosphere, oceans and continents. Lifeforms are present, but nothing dangerous."
    price(9)=1000000
    mtext="Assets/"
    htext="/"
    for a=1 to 9
        mtext=mtext &asset(a) &space(_swidth-len(asset(a))-len(credits(price(a))))&credits(price(a))& "Cr./"
        htext=htext &desc(a) &"/"
    next
    mtext=mtext &"back"
    htext=htext &"/"
    do
        a=menu(bg_parent,"Retirement/ retire now/ buy assets/back")
        if a=1 then
            if askyn("Do you really want to retire now? (y/n)") then
                if askyn("Are you sure? (y/n)") then 
                    player.dead=98
                endif
            endif
        endif
        if a=2 then
            do
                b=menu(bg_parent,mtext,htext)
                
                if b>0 and b<10 then
                    if retirementassets(b-1)=0 or b=2 or b=1 then
                        if paystuff(price(b)) then
                            dprint "You buy "&add_a_or_an(asset(b),0) &"." 
                
                            if retirementassets(b-1)<255 then retirementassets(b-1)+=1
                        endif
                    else
                        dprint "You already have that"
                    endif
                endif
            loop until b=-1 or b=10
        endif
    loop until player.dead<>0 or a=3
    return 0
end function