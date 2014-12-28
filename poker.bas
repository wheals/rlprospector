function play_poker(st as short) as short
    dim card(52) as integer
    dim as short i,k,x,y,dealer,curcard,j,l,ci,pli,winner,move,debug,speedup,pot,folded,totalrisk,minrisk
    dim p(4) as _pokerplayer
    debug=1
    dim rules as _pokerrules
    pcards.LoadCards("graphics/cards2.bmp")
    p(4).name="You"
    select case st
    case is <0
        rules.bet=10
        rules.limit=5
        minrisk=20
    case 0 to 9
        rules.bet=5
        rules.limit=5
        minrisk=25
    case 10
        rules.bet=50
        rules.limit=10
        minrisk=35
    end select
    minrisk=minrisk-crew(1).talents(5)
    rules.closed=1
    rules.swap=0
    dealer=rnd_range(1,4)

    do
        for i=1 to 3
            pli=get_highestrisk_questguy(st)
            if pli>0 and questguy(pli).money>3*rules.bet*rules.limit then
                p(i).name=questguy(pli).n
                p(i).risk=questguy(pli).risk
                p(i).money=questguy(pli).money
                p(i).in=1
                p(i).qg=pli
                questguy(pli).location=-2
            else
                p(i).in=1
                p(i).name=character_name(rnd_range(0,1))
                p(i).risk=rnd_range(3,9)
                p(i).money=rules.limit*rules.bet*rnd_range(5,10)
            endif
            dprint p(i).name &" joins the game."
        next
        do
            totalrisk=0
            for i=1 to 3
                totalrisk=totalrisk+p(i).risk
            next
            if totalrisk<minrisk then p(rnd_range(1,3)).risk+=rnd_range(1,3)
        loop until totalrisk>=minrisk
        for i=1 to 4
            p(i).bet=0
            p(i).pot=0
            p(i).in=1
            p(i).fold=0
            p(i).rank=0
            for j=1 to 5
                p(i).card(j)=0
            next
        next
        winner=0
        
        for i=1 to 52
            card(i)=i
        next
        card_shuffle(card())
        
        dealer=rnd_range(1,4)
        curcard=1
        pli=dealer
        ci=1
        j=0   
        for k=1 to 5
            for i=1 to 4
                if pli=dealer then j+=1
                pli=poker_next(pli,p())
                p(pli).card(k)=card(curcard)
                curcard+=1
                draw_poker_table(p(),,,rules)
                
                If (ScreenEvent(@evkey)) then speedup=1
                If speedup=0 then sleep 220
            next
        next
        
        for l=1 to 4
            sort_cards(p(l).card(),0)
            p(l).pot=1
        next
        
            
        if not paystuff(rules.bet) then
            dprint "You don't have enough money to enter the game."
            return 0
        end if
        
        
        draw_poker_table(p(),,,rules)
        l=crew(1).talents(5)
        while l>0
            dprint "Swap cards (1-5,0 to exit)"
            do
                no_key=keyin("012345")
            loop until val(no_key)<=5
            if val(no_key)>0 then
                p(4).card(val(no_key))=card(curcard)
                curcard+=1
                l-=1
            else
                l=0
            endif
            sort_cards(p(4).card(),0)
            draw_poker_table(p(),,,rules)
        wend
        
        pli=dealer
    '    for i=1 to 4
    '        if pi=4 then
    '            'Player swap card.
    '            dprint "Do you want to swap a card(1-5,0 for none)"
    '            j=val(keyin)
    '            
    '        else
    '            j=swap_card(p(pi).card())
    '        endif
    '        
    '        p(pi).pot=1
    '        
    '        if j>0 then 
    '            dprint p(pi).name &" swaps card "&j
    '            curcard+=1
    '            p(pi).card(j)=card(curcard)
    '            draw_poker_table(p(),,rules)
    '
    '        endif
    '    next
        do
            screenset 0,1
            cls
            pli=poker_next(pli,p())
            draw_poker_table(p(),,,rules)
            dprint ""
            flip
            if pli>0 then
                if p(pli).fold=0 and p(pli).in=1 then
                    if pli=4 then
                        player_eval(p(),pli,rules)
                        pot=0 
                        for i=1 to 4
                            pot+=p(i).pot
                        next
                        move=menu(bg_noflip,"Your bet (In pot: "& credits(pot*rules.bet) &"):/see(" & (highest_pot(p())-p(4).pot)*rules.bet & "Cr.)/raise(" & (highest_pot(p())+1-p(4).pot)*rules.bet & "Cr.)/fold","",24,2,1)
                        if move=1 then p(4).bet=highest_pot(p())-p(4).pot
                        if move=2 then p(4).bet=highest_pot(p())+1-p(4).pot
                        if move=3 or move=-1 then p(4).fold=1
                        if not paystuff(p(4).bet*rules.bet) then p(4).bet=0
                    else
                        player_eval(p(),pli,rules)
                    endif
                    if p(pli).bet=0 then 
                        p(pli).fold=1
                        if pli=4 then
                            dprint "You fold."
                        else
                            dprint p(pli).name &" folds."
                        endif
                        sleep 250
                    endif
                    if p(pli).bet>0 then
                        if p(pli).bet+p(pli).pot>rules.limit then p(pli).bet=rules.limit-p(pli).pot
                    
                        if p(pli).pot+p(pli).bet>highest_pot(p()) then
                            if pli=4 then
                                dprint "You raise."
                            else
                                dprint p(pli).name &" raises."
                            endif
                        else
                            if pli=4 then
                                dprint "You see."
                            else
                                dprint p(pli).name &" sees."
                            endif
                        endif
                        p(pli).pot+=p(pli).bet
                        p(pli).bet=0
                        sleep 350
                    endif
                endif
                if pli=dealer then 
                    winner=poker_winner(p())
                    if winner=0 then
                        for i=1 to 4
                            if p(i).fold=0 then p(i).pot=highest_pot(p())
                        next
                    endif
                endif
            endif
            folded=0
            for i=1 to 4
                if p(i).fold=1 then folded+=1
            next
        loop until winner<>0 or pli=-1 or folded>=3
        cls
        draw_poker_table(p(),1,winner,rules)
        
        for l=1 to 3
            p(l).money-=(p(l).pot*rules.bet)
        next 
        
        
        if winner=4 or (folded=3 and p(4).fold=0) then
            dprint "You win "&credits((p(1).pot+p(2).pot+p(3).pot+p(4).pot)*rules.bet) &" Cr.",c_gre
            addmoney((p(1).pot+p(2).pot+p(3).pot+p(4).pot)*rules.bet,mt_gambling)
        endif
        
        if winner>0 and winner<4 then 
            dprint "Winner:"&p(winner).name
            p(winner).money=p(winner).money+(p(1).pot+p(2).pot+p(3).pot+p(4).pot)*rules.bet
        endif
        if winner<0 then
            dprint "Tie"
            if winner=-3 or winner=-4 then 
                dprint "You win "&credits((p(1).pot+p(2).pot+p(3).pot+p(4).pot)*rules.bet/2) &" Cr.",c_gre
                addmoney((p(1).pot+p(2).pot+p(3).pot+p(4).pot)*rules.bet/2,mt_gambling)
            endif
        endif
        if folded<4 then
            no_key=keyin
        else
            dprint "No winner."
        endif
        
        for i=1 to 4
            if p(i).qg>0 then
                questguy(p(i).qg).location=st
                questguy(p(i).qg).money=p(i).money
            endif
        next
    loop until not(askyn("Do you want to play another hand?(y/n)"))
        
    return 0
end function


function better_hand(h1 as _handrank,h2 as _handrank) as short
    dim i as short
    if h1.rank>h2.rank then return 1
    if h1.rank<h2.rank then return 2
    for i=1 to 5
        if h1.high(i)>h2.high(i) then return 1
        if h1.high(i)<h2.high(i) then return 2
    next
    return 0
end function



function player_eval(p() as _pokerplayer,i as short,rules as _pokerrules) as short
    dim as _handrank ph(4)
    dim as short pli(4),j,knowall,flag,pir,debug,stillin,price
    debug=2
    for j=1 to 4
        if p(j).fold=0 then stillin+=1
        pli(j)=j
        p(j).win=ace_highlo_eval(p(j).card(),1)
    next
    p(i).bet=0
    if p(i).fold=0 and p(i).win.rank^2/3*p(i).risk>p(i).pot*2 then p(i).bet+=1 'see
    if p(i).fold=0 and p(i).win.rank^2/3*p(i).risk>p(i).pot*3 then p(i).bet+=1 'raise
    if p(i).win.rank=1 then p(i).bet=0 'Never with just high card
    if p(i).money<(p(i).pot+p(i).bet)*rules.bet and p(i).bet>0 then
        'Sell has, else fold
        dprint p(i).name &" is out of money.",c_yel
        if p(i).qg>0 then
            if questguy(p(i).qg).has.given=0 and questguy(p(i).qg).has.it.desig<>"" then 'He is a qg and has not given up his has yet
                price=(p(i).pot+p(i).bet)*rules.bet-p(i).money
                if askyn(p(i).name &" offers to sell you "&add_a_or_an(questguy(p(i).qg).has.it.desig,0) &" for " &price &" Cr. (y/n)") then
                    if paystuff(price) then 
                        p(i).money+=price
                        questguy(p(i).qg).friendly(0)+=1
                        questguy(p(i).qg).money+=price
                        questguy(p(i).qg).has.given+=1
                        placeitem(questguy(p(i).qg).has.it,,,,,-1)
                    else
                        questguy(p(i).qg).friendly(0)-=1
                        p(i).bet=0
                    endif
                else
                    p(i).bet=0
                endif
            else
                p(i).bet=0
            endif
        else
            p(i).bet=0
        endif
    endif
    return 0
end function

function ace_highlo_eval(c() as integer,knowall as short) as _handrank
    dim as _handrank h1,h2
    dim as short debug
    h1=poker_eval(c(),0,knowall)
    h2=poker_eval(c(),1,knowall)
    if debug=1 and _debug=1 then print h1.rank ;":";h2.rank
    if better_hand(h1,h2)=1 then return h1
    return h2
end function
    
function _pokerplayer.firstempty() as short
    ci+=1
    return ci
end function

function card_shuffle(card() as integer) as short
    dim as short i,j,last,first
    last=ubound(card)
    first=1
    for i=last to first step -1
        j=rnd_range(first,i)
        swap card(i),card(j)
    next
    return 0
end function


function swap_card(cardin() as integer) as short
    dim as short c,i,j,low,l
    dim hand as _handrank
    dim card(5) as integer
    dim cc(5) as _cardcount
    for i=1 to 5
        card(i)=cardin(i)
        if pcards.crank(card(i))=1 then pcards.setcardvalue card(i),14
    next
    
    'Got a strait, or a flush or a strait flush dont change. else, change lowest cc1 card
    hand=ace_highlo_eval(card(),1)
    if hand.rank=9 or hand.rank=5 or hand.rank=6 or hand.rank=7 then return 0
    for i=1 to 5
        if card(i)<>0 then
            cc(i).rank=pcards.crank(card(i))
            cc(i).no=1
            for j=i+1 to 5
                if pcards.crank(card(i))=pcards.crank(card(j)) and card(j)<>0 then 
                    cc(i).no+=1
                    cc(i).pos=i
                    card(j)=0
                endif
            next
            card(i)=0
        endif
    next
    low=15
    for i=1 to 5
        if cc(i).no=1 and cc(i).rank<low then
            low=cc(i).rank
            l=i
        endif
    next
    return l
end function


function sort_cards(card() as integer,knowall as short=0) as short
    dim as short i,flag,debug,start
    if knowall=0 then
        start=2
    else
        start=1
    endif
    do
    flag=0
    for i=start to 4
        if pcards.crank(card(i))>pcards.crank(card(i+1)) then
            swap  card(i) , card(i+1)
            flag=1
        endif
    next
    if debug=1 and _debug=1 then print ".";
    loop until flag=0
    return 0
end function

function poker_eval(cardin() as integer, acehigh as short,knowall as short) as _handrank
    dim r as _handrank
    dim card(5) as integer
    dim cc(5) as _cardcount
    dim as short i,flag,debug,flush,strait,countpairs,j,start
    'take card 1, count how often others are there. 
    'Aces are wild would solve the high/lo problem (Just or=1 to every test)
    debug=1
    
    for i=1 to 5
        card(i)=cardin(i)
    next
    
    if acehigh=1 then
        for i=1 to 5
            if pcards.crank(card(i))=1 then pcards.crank(card(i))=14
        next
    else
        for i=1 to 5
            if pcards.crank(card(i))=14 then pcards.crank(card(i))=1
        next
    endif
    
    if knowall=1 then 
        start=1
    else
        start=2
    endif
    do
        flag=0
        for i=start to 4
            if pcards.crank(card(i))>pcards.crank(card(i+1)) then
                swap  card(i) , card(i+1)
                flag=1
            endif
        next
        
    loop until flag=0
    r.high(1)=pcards.crank(card(5))
    'Check if flush
    flush=1
    for i=start to 4
        if pcards.csuit(card(i))<>pcards.csuit(card(i+1)) then flush=0
    next
    strait=1
    for i=start to 4
        if pcards.crank(card(i))<>pcards.crank(card(i+1))-1 then strait=0
    next

    if strait=1 and flush=1 then r.rank=9
    if r.rank<>0 then return r
    
    for i=start to 5
        if card(i)<>0 then
            cc(i).rank=pcards.crank(card(i))
            cc(i).no=1
            for j=i+1 to 5
                if pcards.crank(card(i))=pcards.crank(card(j)) and card(j)<>0 then 
                    cc(i).no+=1
                    card(j)=0
                endif
            next
            card(i)=0
        endif
    next
    
    
    do
        flag=0
        for i=1 to 4
            if cc(i).no<cc(i+1).no then 
                swap cc(i),cc(i+1)
                flag=1
            endif
            
        next
    loop until flag=0
    do
        flag=0
        for i=1 to 4
            if cc(i).no=cc(i+1).no and cc(i).rank<cc(i+1).rank then
                swap cc(i),cc(i+1)
                flag=1
            endif
        next
    loop until flag=0
    
    for i=1 to 5
        r.high(i)=cc(i).rank
    next
    
    'Check four of a kind
    if cc(1).no=4 then
        r.rank=8
        
        return r
    endif
    
    if cc(1).no=3 and cc(2).no=2 then
        r.rank=7
        return r
    endif
    
    'Flush
    if flush=1 then 
        r.rank=6
        return r
    endif
    
    'Strait
    if strait=1 then
        r.rank=5
        return r
    endif
    
    if cc(1).no=3 then
        r.rank=4
        return r
    endif
    
    if cc(1).no=2 and cc(2).no=2 then
        r.rank=3
        return r
    endif
    
    if cc(1).no=2 then
        r.rank=2
        return r
    endif
    
    r.rank=1
    
    return r
    
end function

function poker_next(i as short,p() as _pokerplayer) as short
    dim as short fold
    do
        i+=1
        if i>4 then i=1
        if p(i).fold=1 then fold+=1
    loop until p(i).in=1 or fold=4
    if fold=4 then return -1
    return i
end function



function highest_pot(p() as _pokerplayer) as short
    dim as short i,h
    for i=1 to 4
        if p(i).fold=0 then
            if p(i).pot>h then h=p(i).pot
        endif
    next
    return h
end function


function poker_winner(p() as _pokerplayer) as short
    'Check if 3 have folded
    dim as short i,cfold,winner,cbet,stillin(4),cin,flag,tieat,debug,nop
    
    dim victory as _handrank
    for i=1 to 4
        if p(i).name<>"" then nop+=1
    next
    for i=1 to nop
        if p(i).fold=1 then 
            cfold+=1
        else
            cin+=1
            stillin(cin)=i
        endif
    next
    
    if cfold=nop-1 then return stillin(1)
    'Check if betting over
    for i=2 to cin
        if p(stillin(1)).pot<>p(stillin(i)).pot then return 0
    next
    
    if debug=1 and _debug=1 then
        for i=1 to cin
            draw string(500,i*12),stillin(i) &":"&p(stillin(i)).win.rank &":"& p(stillin(i)).win.high(1)
        next
    endif
    
    
    do
        if debug=1 and _debug=1 then dprint "Entering loop"
        if debug=1 and _debug=1 then
            for i=1 to cin
                draw string(500,i*12),stillin(i) &":"&p(stillin(i)).win.rank &":"& p(stillin(i)).win.high(1)
            next
            sleep
        endif
        
        flag=0
        for i=1 to cin-1
            select case better_hand(p(stillin(i)).win,p(stillin(i+1)).win) 
                case 2
                    if debug=1 and _debug=1 then dprint "swapping pos "&i
                    flag=1
                    'swap p(stillin(i)),p(stillin(i+1))
                    swap stillin(i),stillin(i+1)
                    exit for
                case 0
                    tieat=i
            end select
        next
        
        if debug=1 and _debug=1 and flag=0 then dprint "Leaving loop"
    loop until flag=0
    for i=1 to cin
        p(stillin(i)).rank=i
    next
    if debug=1 and _debug=1 then
        for i=1 to cin
            draw string(500,200+i*12),stillin(i) &":"&p(stillin(i)).win.rank &":"& p(stillin(i)).win.high(1)
        next
    endif
    
    if tieat=0 or tieat>1 then
        return stillin(1)
    else
        return -1
    endif
    return 0
    'Tie....
end function

    
    'find best hand
    
function draw_poker_table(p() as _pokerplayer,reveal as short=0,winner as short=0,r as _pokerrules) as short
    dim as short x,y,i,j
    
    dim as string handname(9),playerinfo,tacticname(9)
    handname(1)="high card"
    handname(2)="pair"
    handname(3)="two pair"
    handname(4)="three of a kind"
    handname(5)="strait"
    handname(6)="flush"
    handname(7)="full house"
    handname(8)="four of a kind"
    handname(9)="strait flush"
    
    tacticname(1)="Coward"
    tacticname(2)="Coward"
    tacticname(3)="Extremly cautious"
    tacticname(4)="Very cautious"
    tacticname(5)="Cautious"
    tacticname(6)="Neutral"
    tacticname(7)="Bold"
    tacticname(8)="Very bold"
    tacticname(9)="Extremly bold"
    
    display_ship(0)
    p(4).win=ace_highlo_eval(p(4).card(),1)
    for i=1 to 4
        set__color(11,0)
        if p(i).in=1 then
            playerinfo=p(i).name &" (In Pot: "& credits(p(i).pot*r.bet) &" Cr.)"
            if crew(1).talents(5)>0 and i<4 then playerinfo &= " (Tactic: "& tacticname(p(i).risk) &", "& p(i).money &" Cr.)"
            if _debug<>22 then draw string (x,y+pcards.cardheight),playerinfo,,font2,custom,@_col
            if p(i).fold=0 then
                for j=1 to 5
                    if p(i).card(j)>0 then 
                        if (i=4 or j>r.closed or reveal=1) then
                            pcards.drawCardfront x,y,p(i).card(j)
                        else
                            if p(i).card(j) mod 2=0 then
                                pcards.drawCardback x,y,1
                            else
                                pcards.drawCardback x,y,2
                            endif
                        endif
                        set__color(15,0)
                        if _debug=22 then draw string(x,y+pcards.cardheight),pcards.csuit(p(i).card(j))&":"&p(i).card(j),,font2,custom,@_col
                        x+=pcards.cardwidth
                    endif
                next
            else
                for j=1 to 5
                    if p(i).card(j) mod 2=0 then
                        pcards.drawCardback x,y,1
                    else
                        pcards.drawCardback x,y,2
                    endif
                    x+=pcards.cardwidth/2
                next
            endif
            
            if (reveal=1 and p(i).fold=0) or i=4 then 
                set__color(15,0)
                if i=winner then set__color(c_gre,0)
                if p(i).fold=0 then 
                    draw string (x,y+pcards.cardheight/2-_fh2/2),space(18),,font2,custom,@_col
                    draw string (x,y+pcards.cardheight/2-_fh2/2)," ("& handname(p(i).win.rank) &")",,font2,custom,@_col
                endif
            endif
            x=0
            y=y+pcards.cardheight+_fh2+2
        endif
    next
    set__color(11,0)
    return 0
end function
