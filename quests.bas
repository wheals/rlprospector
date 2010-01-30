
function alienname(flag as short) as string
    dim as string n,vokal,cons
    dim as short a,b
    if flag=1 then
        for a=1 to 2
            if len(n)>0 then n=n &"-"
            do
                vokal=CHR(rnd_range(65,90))
            loop until vokal="A" or vokal="E" or vokal="I" or vokal="O" or vokal="U"
            do
                cons=CHR(rnd_range(65,90))
            loop until cons<>"A" and cons<>"E" and cons<>"I" and cons<>"O" and cons<>"U"
            n=n &cons
            if flag=2 then n=n &"l"
            for b=1 to rnd_range(1,5)
                n=n &lcase(vokal)
            next
        next
    endif
    if flag=2 then
        for a=1 to 2
            do
                vokal=CHR(rnd_range(65,90))
            loop until vokal="A" or vokal="E" or vokal="I" or vokal="O" or vokal="U"
            do
                cons=CHR(rnd_range(65,90))
            loop until cons<>"A" and cons<>"E" and cons<>"I" and cons<>"O" and cons<>"U"
            if len(n)>1 then 
                n=n &lcase(cons)
            else
                n=n &cons 
            endif
            n=n &"l"
            for b=1 to rnd_range(1,2)
                n=n &lcase(vokal)
            next
        next
    if rnd_range(1,100)<50 then n=n &lcase(cons)
    endif
    return n
end function 

function dodialog(no as short) as short
    dim text as string
    dim flags(128) as byte
    dim p as short
    if no=1 then
        
        dprint "SUBJUGATE OR BE DESTROYED."
        do
            text=ucase(gettext(pos,csrlin-1,46," "))
            if instr(text,"HELLO")>0 or instr(text,"WHO")>0 or instr(text,"YOU")>0 then dprint "WE ARE THE INTELLIGENCE INHABITING THIS WORLD" 
            if instr(text,"PURPOSE")>0 or instr(text,"DOING")>0 then dprint "WE SEEK TO EXPAND OUR SPHERE OF INFLUENCE TO INCREASE OUR CHANCE OF SURVIVAL."
            if instr(text,"LEADER")>0 then dprint "WE ARE WHAT YOU WOULD CALL THE LEADER OF OUR SOCIETY"
            if instr(text,"HYBRID")>0 then dprint "YOUR PHYSICAL FORMS ARE WEAK BUT VERY ADAPTIVE. WE CAN COMBINE FORMING A STRONGER LIFEFORM WITH A HIGHER CHANCE OF SURVIVAL"
            if instr(text,"ANCIENTS")>0 or instr(text,"RUINS") or instr(text,"ALIENS") then dprint "OUR ANCESTORS REPORTED CONTACT WITH ANOTHER CIVILIZATION BEFORE. BUT THEY DISSAPEARED. THEY WERE WEAK"
            if instr(text,"WEAK")>0 then dprint "WE HAVE NO WEAKNESS. JOIN TO SHARE OUR STRENGTH"
        loop until text="" or text="BYE"

    endif
        
    return 0
end function

function dirdesc(f as cords,t as cords) as string
    dim d as string
    dim as single dx,dy
    dx=(f.x-t.x)
    dy=(f.y-t.y)
    if dy<-2 then d=d &"south"
    if dy>2 then d=d &"north"
    if dx<-2 then d=d &"east"
    if dx>2 then d=d &"west"
    if d="" then 
        d="nearby"
    else
        d=d &" from here."
    endif
    return d
end function
  
function communicate(awayteam as _monster, e as _monster,mapslot as short,li()as short,lastlocalitem as short,monslot as short) as short
    dim as short roll,a,b
    dim it as _items
    dim p as cords
    roll=rnd_range(1,6)+rnd_range(1,6)+player.science+e.intel+addtalent(4,14,2)
    if e.lang<0 then
        if roll>9 then
            dprint "Your Science Officer established communication with the " & e.sdesc &"."
            e.lang=-e.lang
            e.cmmod=e.cmmod+1
        else
            dprint "Your Science Officer cant make any sense out of the " &e.sdesc &"s sounds and actions."
            e.cmmod=e.cmmod-1
        endif
    endif
    if e.lang=1 then
        select case e.intel
        case is>4
            if e.aggr=0 then dprint rndsentence(e.aggr,e.intel)
            if e.aggr=1 then
                if findbest(23,1)<>-1 and rnd_range(1,6)+rnd_range(1,6)<2*e.intel then
                    if item(findbest(23,-1)).v1=3 then 
                        dprint "It says 'That doesnt belong to you, give it back!'"
                        e.cmmod=e.cmmod-rnd_range(1,4)
                    else
                        dprint "It says 'You have pretty things!'"
                        e.cmmod=e.cmmod+1
                    endif
                endif
                if rnd_range(1,100)>(e.intel-addtalent(4,14,1))*6 then
                    dprint rndsentence(e.aggr,e.intel)
                else
                    select case rnd_range(1,100)
                    case is<22
                        'Tell about caves
                        roll=-1
                        for a=0 to lastportal
                            if portal(a).from.m=mapslot then roll=a
                        next
                        
                        if roll=-1 then
                            dprint "It says 'I dont know of any tunnels'"
                        else
                            p.x=portal(roll).from.x
                            p.y=portal(roll).from.y
                            dprint "It says 'There is a tunnel  "&dirdesc(e.c,p) &"'"
                        endif
                    case 22  to 44
                        'Tell about item
                        if lastlocalitem>0 then
                            roll=rnd_range(1,lastlocalitem)
                            if item(li(roll)).w.s=0 and item(li(roll)).w.p=0 then
                                p.x=item(li(roll)).w.x
                                p.y=item(li(roll)).w.y
                                if item(li(roll)).ty=15 then
                                    dprint "It says 'There are sparkling stones at "& dirdesc(e.c,p) &"'"
                                else
                                    dprint "It says 'There is something strange at "& dirdesc(e.c,p) &"'"
                                endif
                            else
                                dprint "It says 'An animal here owns someting shiny'"
                            endif
                        else
                            dprint "It says 'this is a boring place'"
                        endif
                    case 45 to 55
                        if askyn("It says 'do you want to trade?'(y/n)") then
                            dprint "What do you want to offer to the "&e.sdesc &"?"
                            b=getitem
                            if b>0 then
                                item(b).w.s=0
                                item(b).w.p=monslot
                                reward(2)=reward(2)-item(b).v5
                                lastlocalitem=lastlocalitem+1
                                li(lastlocalitem)=b
                                it=makeitem(94)
                                placeitem(it,0,0,0,0,-1)
                                dprint "It takes the "&item(b).desig &" and hands you "&it.desig &"."   
                                e.cmmod=e.cmmod+2
                            else
                                dprint "It seems dissapointed."
                                e.cmmod=e.cmmod-1
                            endif
                        else
                            dprint("It seems dissapointed.")
                            e.cmmod=e.cmmod-1
                        endif
                    case else
                        dprint "It says 'You are not from around here'"
                    end select
                endif
            endif
            if e.aggr=2 then 
                if rnd_range(1,100)>e.intel*9 then 
                    dprint rndsentence(e.aggr,e.intel)
                else
                    dprint "It says 'take this, and let me live!"
                    e.aggr=1
                    if rnd_range(1,100)<66 then
                        it=makeitem(94)
                    else
                        it=makeitem(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                    dprint "It hands you "&it.desig &"."   
                
                        
                endif  
            endif
        case else 
            if e.aggr=0 then dprint "It says 'You food!'"
            if e.aggr=1 then
                b=findbest(13,-1)
                if b>0 then 
                    if askyn("It says 'Got food?'. Do you want to give it a an anastaethic?") then
                        dprint "The "&e.sdesc &" eats the "& item(b).desig
                        e.sleeping=e.sleeping+item(b).v1
                        if e.sleeping>0 then dprint "And falls asleep!"
                        destroyitem(b)
                    endif
                else
                    dprint "It says 'Got food?'"
                endif
            endif
            if e.aggr=2 then dprint "It says 'Me not food!'"
        end select
    endif
    if e.lang=2 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then dprint "The Citizen says: 'You are an offworlder, aren't you? You should visit Mr. Grey, he collects native art.'"
            if a=4 then dprint "The Citizen says: 'We are independent and neutral. Has served us good in the past years.' "
            if a=5 then dprint "The Citizen says: 'When we settled here we found alien ruins. In an underground vault was a cache with weapons and armor. we don't need it. We sell it.' "
            if a=6 then dprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    if e.lang=3 then 
        dprint "The Robot says 'Annihilate alien invaders!'"
    endif
    if e.lang=4 then
        dprint "Apollo thunders 'Worship me!'"
    endif
    if e.lang=5 then
        if e.aggr=0 then dprint "'Surrender or be destroyed!'"
        if e.aggr=1 then dprint "'Found any good ore deposits on this planet?'"
        if e.aggr=2 then dprint "'The company will hear about this attack!'"
    endif
    if e.lang=6 then
        if e.aggr=0 then dprint "It says: 'Die red-helmet-friend!"
        if e.aggr=1 then dprint "It says: 'Will you help us destroy the red-helmets too? we can give you metals for weapons too, just like we did with the others of your kind!" 
        if e.aggr=2 then dprint "It says: 'I surrender!" 
    endif
    if e.lang=7 then
        if e.aggr=0 then dprint "It says: 'Die blue-helmet-friend!"
        if e.aggr=1 then dprint "It says: 'Will you help us destroy the blue-helmets too? we can give you metals for weapons too, just like we did with the others of your kind!"
        if e.aggr=2 then dprint "It says: 'I surrender!"
    endif 
    if e.lang=8 then
        if e.aggr=0 or e.aggr=2 then dprint "It says: 'We haven't harmed you yet you wish to destroy us?'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It says 'My people have abandoned the ways of technology long ago.'"
            if a=2 then dprint "It says 'Since i was hatched my planet has circled the sun 326 times' Thats about 600 years."
            if a=3 then dprint "It says 'I hope you find the exploration of this planet interesting.'"
            if a=4 then dprint "It says 'Do you wish to discuss the teachings of gzrollazasd?'"
            if a=5 then dprint "It says 'My, you look remarkably similiar to the visitors we had 1300 cycles ago. you both share the same lack of limbs.'"
            if a=6 then dprint "It says 'We have a secret, but i can't tell you since if i did it wouldn't be a secret anymore.'"
        endif
    endif
    if e.lang=9 then
        if e.aggr=0 then dprint "They snarl and growl."
        if e.aggr=1 then 
            a=rnd_range(1,6)
            if a=1 then dprint "They ask if you got good booty lately."
            if a=2 then dprint "They ask if you know of any merchant routes."
            if a=3 then dprint "They ask if you know of any good bars here."
            if a=4 then dprint "They ask if you read the review of the new Plasma rifle."
            if a=5 then dprint "They ask if you how the drinks in space stations are."
            if a=6 then dprint "'Have you already visited the base at "&map(piratebase(rnd_range(0,_NoPB))).c.x &":"&map(piratebase(rnd_range(0,_NoPB))).c.y &"?'"
        endif
        if e.aggr=2 then dprint "They yell 'We are going to get you!' as they retreat."
    endif
    if e.lang=10 then
        if e.aggr=0 then dprint "It says: 'Die alien!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It says: 'We are using the best technology that we can use'"
            if a=2 then dprint "It says: 'Have you found our space probe?'"
            if a=3 then dprint "It says: 'Has your kind solved the technological problems our species is facing?'"
            if a=4 then dprint "It says: 'Do you always have to turn around when you want to see what is behind you?'"
            if a=5 then dprint "It says: 'I think our only hope is to find exploitable resources on other planets.'"
            if a=6 then dprint "It says: 'Our leaders would be very interested in trading for advanced power sources and production methods'"
        endif        
        if e.aggr=2 then dprint "It says: 'I surrender.'"
    endif
    if e.lang=11 then
        if e.aggr=0 then dprint "It says: 'Warriors fight!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Workers work, warriors fight and scientists research. Breeders breed.'"
            if a=2 then dprint "It says: 'Does your species have warriors too?'"
            if a=3 then dprint "It says: 'Does your species have workers too?'"
            if a=4 then dprint "It says: 'Does your species have scientists too?'"
            if a=5 then dprint "It says: 'Does your species have breeders too?'"
            if a=6 then dprint "It says: 'We are working on our first faster than light ship. It is called 'feeler'"
            if a=7 then dprint "It says: 'We are looking forward to trade with your kind'"
            if a=8 then dprint "It says: 'We are looking forward to exchange knowledge with your kind'"
        endif        
        if e.aggr=2 then dprint "It says: 'We will work and fight and research for you!'"
    endif
    if e.lang=12 then
        if e.aggr=0 then dprint "It says: 'The time for negotiations is over!'"
        if e.aggr=2 then dprint "It says: 'We surrender for now.'"
        if e.aggr=1 then
            dprint "It says: 'I am a warrior. I would be interested in joining your crew to learn about your kind and other worlds'"
            if askyn("Do you want to let the insect warrior join your crew?(y/n)") then
                if maxsecurity>0 then
                    e.hp=0
                    e.hpmax=0
                    addmember(9)
                else
                    dprint "You don't have enough room for the insect warrior"
                endif
            else
                dprint "It seems dissapointed but says it understands."
            endif
        endif
    endif
    if e.lang=13 then
        if e.aggr=0 then dprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then dprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Do you like our research station?'"
            if a=2 then dprint "It says: 'We do pick up signals from 3 gigantic artificial structures in space. Are they yours?'"
            if a=3 then dprint "It says: 'You should visit our main world. Its the third planet in this system.'"
            if a=4 then dprint "It says: 'FTL technology is still very new for our kind. We hope you come in peace and we can learn a lot from you'"
            if a=5 then dprint "It says: 'This is a research station. There are no warriors here."
            if a=6 then dprint "It says: 'Some of my colleagues thought the answer to the xixrit paradox would be that we were the first to advance this far in technology. I knew they were wrong! Ha!'"
            if a=7 then dprint "It says: 'How far away is your home planet?'"
            if a=8 then dprint "It says: 'Economics isn't my specialty but i am certain we can work out a way to trade goods & services with your species.'"
        endif
    endif
    if e.lang=14 then
        if specialflag(20)=0 then
            if e.aggr=0 then dprint "He says with a monotone voice: 'Leave now or be destroyed!'"
            if e.aggr=2 then dprint "He says with a monotone voice: 'Don't kill me!'"
            if e.aggr=1 then
                a=rnd_range(1,8)
                if a=1 then dprint "The colonist says: 'We need to buy supplies. our powerplant is broken.'"
                if a=2 then dprint "The colonist looks at you with a puzzled expression on his face. 'Have you been to the cave?'"
                if a=3 then dprint "The colonist just stares at you."
                if a=4 then dprint "The colonist just stares at you."
                if a=5 then dprint "The colonist looks as if what you just said made no sense."
                if a=6 then dprint "The colonist asks: 'Are you bringing supplies?.'"
                if a=7 then dprint "The colonist in a monotone voice: 'Unload your cargo and then leave. Everything is alright here.'"
                if a=8 then dprint "The colonist in a monotone voice: 'Everything is alright here. We don't need your help.'"
            endif
        else
            if e.aggr=0 then dprint "He screams: 'THE VOICES ARE GONE! DID YOU MAKE THE VOICES GO??'"
            if e.aggr=2 then dprint "The colonists runs away crying."
            if e.aggr=1 then
                a=rnd_range(1,7)
                if a=1 then dprint "The colonist says: 'It started slow, and when we realized what was happening it was too late'"
                if a=2 then dprint "The colonist says: 'Thank you for freeing us from this influence!'"
                if a=3 then dprint "The colonist says: 'Now we can start developing our colony again! Thank you!'."
                if a=4 then dprint "The colonist says: 'If you want to know what the crystals goals were: no idea.'"
                if a=5 then dprint "The colonist says: 'I wonder if there are other beings like that out there'."
                if a=6 then dprint "The colonist says: 'Thank you! You guys are heroes!'"
                if a=7 then dprint "The colonist says: 'A lot of hard work ahead for us now.'"
            endif
        endif
    endif
    if e.lang=15 then dprint "You hear a voice in your head: 'Subjugate or be annihilated.'"
    if e.lang=16 then
        if e.aggr=0 then dprint "The crewmember yells: 'Repell the intruders!'"
        if e.aggr=2 then dprint "The crewmember yells: 'Help! Help!'"
        if e.aggr=1 then
            if planets(mapslot).flags(0)=0 then
            if askyn("The crewmember says: 'are you willing to sell us enough fuel to return to the nearest station?' (y/n)") then
                player.merchant_agr=player.merchant_agr-rnd_range(1,4)*rnd_range(1,4)
                player.pirate_agr=player.pirate_agr+rnd_range(1,4)*rnd_range(1,4)
                If player.fuel>disnbase(player.c) then
                    dprint "How much do you want to charge per ton of fuel?"
                    a=getnumber(0,99,0)
                    if a>0 then
                        if rnd_range(10,50)+rnd_range(5,50)>a-awayteam.hp then
                            player.fuel=player.fuel-disnbase(player.c)
                            player.money=player.money+cint(disnbase(player.c)*a)
                            dprint "You sell fuel for "&cint(disnbase(player.c)*a) &" credits."
                            planets(mapslot).flags(0)=1
                        else
                            dprint "They decide to rather take what they want by force than pay this outragous price."
                            e.aggr=0
                            e.target=awayteam.c
                        endif
                    endif
                else
                    dprint "You don't have enough fuel yourself... that's actually quite alarming."
                endif
            else
                dprint "you have doomed us!"
            endif
            endif
            if planets(mapslot).flags(0)=1 then
                dprint "The crewmember is busy starting the ship up again. 'Thank you so much for saving our lifes!'"
            endif
        endif
    endif 
    if e.lang=17 then
        if e.aggr=0 then dprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then dprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,5)
            if a=1 then dprint "It says: 'Warriors fight, breeders breed, sientists research.'"
            if a=2 then dprint "It says: 'We left our home 500 timeunits ago. It will take us 800 more timeunits to reach our goal.'"
            if a=3 then dprint "It says: 'We hope conditions for a colony are favourable at our destination.'"
            if a=4 then dprint "It says: '12 breeders have died since we left home.'"
            if a=5 then dprint "It says: 'I am proud to be one of the few of our species to go on this great adventure! though i will not see the end of it.'"
        endif
    endif    
    
    if e.lang=18 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then dprint "The Citizen says: 'You are an offworlder, aren't you? We don't get visitors often'"
            if a=4 then dprint "The Citizen says: 'We only settled here recently.' "
            if a=5 then dprint "The Citizen says: 'Did you bring supplies?' "
            if a=6 then dprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=19 then
        if e.aggr=0 then dprint "He growls:'Flee or be shredded!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It says: 'Is there a lot of water on your world?'"
            if a=2 then dprint "It says 'You have a very low number of arms, maybe we should lend you some'"
            if a=3 then dprint "It says: 'Traveling among the stars, must be exciting!'"
            if a>3 then 
                dprint "It says: 'I can help you! I would love to travel with you! May I?'"
                if askyn("Do you want to let the cephalopod join your crew?(y/n)") then
                    if maxsecurity>0 then
                        e.hp=0
                        e.hpmax=0
                        addmember(10)
                    else
                        dprint "You don't have enough room for the cephalopod"
                    endif
                else
                    dprint "It seems dissapointed but says it understands."
                endif
            endif
        endif
        if e.aggr=2 then dprint "He sobs: 'Take whatever you want! Just leave us in peace!"
    endif
    
    if e.lang=20 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if player.questflag(12)=0 or player.questflag(12)=1 then 
                dprint "We love mushrooms. The best mushrooms grow in the caves. But there is a monster there."
                player.questflag(12)=1
            endif
            if player.questflag(12)=2 then 
                dprint "'Thank you very much for killing the monster! Take this as a reward!' It hands you a huge heap of random art pieces."
                player.questflag(12)=3
                for a=0 to rnd_range(1,6)+rnd_range(1,6)+rnd_range(1,6)+3
                    placeitem(makeitem(93),0,0,0,0,-1)
                next
            endif
            if player.questflag(12)=3 then dprint "Thank you very much for killing the monster!"
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=21 then
        if e.aggr=0 then dprint "It howls: 'We will defeat you!"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Interesting! Talking bipeds! They seem to rely on other producers much like the primitve life on our world does.'"
            if a=2 then dprint "It says: 'We had a discussion about experimenting with fire, but we deemed it too dangerous.'" 
            if a=3 then 
                if askyn("It says: 'Do you want to exchange scientific knowledge?(y/n)'") then
                    dprint "These creatures seem to be incredibly smart! While they have gaps in the practical application they seem to be at least comparable to humanitys science. You find nothing you could teach them."
                else
                    dprint "it seems dissapointed"
                endif
            endif
            if a=4 then dprint "It says: 'A lot of our knowledge was never tested. It's origins are lost in the mists of time.'"
            if a=5 then dprint "It says: 'There is a legend that our kind was artificially created as pets for a species that has dissapeared.'"
            if a>=6 then 
                if askyn("It says: 'I'd love to see other worlds! I would volunteer to serve as a science officer for you.' Do you accept(y/n)") then
                    if player.science>3 then
                        if askyn("Your science officer is better than the tree creature. Do you want to take it with you regardless? (y/n)") then
                            player.science=3
                            addmember(14)
                            e.hp=0
                            e.hpmax=0
                        endif
                    else
                        player.science=3
                        addmember(14)
                        dprint ""&crew(4).disease
                        e.hp=0
                        e.hpmax=0
                    endif
                else
                    dprint "It seems dissapointed."
                endif
            endif
        endif
        if e.aggr=2 then dprint "It sobs: 'We don't want a war with your kind!"
    endif
    
    if e.lang=22 then
        if e.aggr=0 then dprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=2 then dprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=1 then
            a=rnd_range(1,12)
            if a=1 then dprint "Ted Rofes, the shipsdoctor tells how he crashlanded on this planet."
            if a=2 then dprint "Ted Rofes, the shipsdoctor explains that the tree creatures are very smart. 'I have learned a lot on this planet.'"
            if a=3 then dprint "Ted Rofes, the shipsdoctor says 'The rest of the crew wanted to 'defend' themselves against the tree creatures. I warned them but they didn't hear.'"
            if a=4 then dprint "Ted Rofes, the shipsdoctor explains that he would be dead without the aid of the tree creatures."
            if a=5 then dprint "Ted Rofes, the shipsdoctor explains that the tree creatures seem to be connected to the ancient alien ruins somehow."
            if a=6 then dprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens are their creators.'"
            if a=7 then dprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens have had a very complex nerval system, with several nodes distributed about their body, making them very suspectible to telepathy.'"
            if a=8 then dprint "Ted Rofes, the shipsdoctor says 'There is a cave here that leads to an underground complex of the ancient aliens. I haven't fully explored it. When I found it an ancient robot almost killed me.'"
            if a=9 then dprint "Ted Rofes, the shipsdoctor says 'Staying here was interesting, but I would like to get back on a ship. I am a doctor, not a tourist.'"
            if a>9 then
                if askyn("Ted Rofes asks if you would let him join your crew 'you seem more reasonable than my old captain' (y/n)") then
                    addmember(15)
                    e.hp=0
                    e.hpmax=0
                endif        
            endif
        endif
    endif
    
    
    if e.lang=23 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!'"
        if e.aggr=1 then
            a=rnd_range(1,9)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'The soil, the weather, the plants, everything on this world is perfect for growing crops! As if someone made it for that!'"
            if a=3 then dprint "The Citizen says: 'The only problem we have are the burrowers: Huge insects that hide in the soil and eat whatever comes their way.'"
            if a=4 then dprint "The Citizen says: 'Burrowers aside, this world is a paradise.' "
            if a=5 then dprint "The Citizen says: 'We have got more food than we could ever need' "
            if a=6 then dprint "The Citizen says: 'There is a bounty of 10 Cr. per dead burrower' "
            if a=7 then dprint "The Citizen says: 'Pssst... I am hunting burrowers! Its a bounty of 10 Cr. per dead burrower' "
            if a=8 then dprint "The Citizen says: 'The crops are great this year, but they are always great here.' "
            if a=9 then dprint "The Citizen says: 'If you killed a burrower you can get your bounty at the town hall.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=24 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This planet belongs to eridiani explorations.'"
            if a=5 then dprint "They say 'This planet belongs to eridiani explorations.'"
            if a=6 then dprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=25 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This is Smith Heavy Industries property.'"
            if a=5 then dprint "They say 'This planet belongs to Smith Heavy Industries.'"
            if a=6 then dprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!"
    endif
    
    
    if e.lang=26 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This Ship belongs to Triax Traders.'"
            if a=5 then dprint "They say 'You need a Triax Traders authorization.'"
            if a=6 then dprint "They say 'They look at you suspicously"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=27 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=5 then dprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=6 then dprint "They look at you suspicously"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=28 then
        if e.aggr=0 then dprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "He says in a sarcastic tone 'You sure you want to talk to a hardened criminal like me?'"
            if a=2 then dprint "He says 'We are being held here against our will'"
            if a=3 then dprint "He says 'The food is bad, the work is worse, and sometimes the guards take out their frustration on us.'"
            if a=4 then dprint "He says 'This can't be legal! Forcing us to live like this!'"
            if a=5 then dprint "He says 'I know, i made a mistake, but I don't think they can treat us like this!'."
            if a=6 then dprint "He says 'Don't owe SHI money, or you'll end up here too!'"
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    return 0
end function

function giveitem(e as _monster,nr as short, li() as short, byref lastlocalitem as short) as short
    dim as short a
    dim it as _items
    dprint "What do you want to offer the "&e.sdesc &"."
    a=getitem()
    if a>0 then
     if (e.lang=6 or e.lang=7) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
         item(a).w.p=nr
         item(a).w.s=0
         it=makeitem(96,-1,-3)
         placeitem(it,0,0,0,0,-1)
         reward(2)=reward(2)+it.v5
         dprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
         return 0
     endif
     
     if (e.lang=28) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
         item(a).w.p=nr
         item(a).w.s=0
         dprint "The worker hides the "&item(a).sdesc &"quickly saying 'Thank you, now if i only had a way to get off this rock'" 
         if rnd_range(1,6)<3 then e.faction=2
         return 0
     endif
     
     
     select case e.intel
        case is>6
            if rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" accepts the gift."
                e.cmmod=e.cmmod+2
                if rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then e.aggr=1
                lastlocalitem=lastlocalitem+1
                item(a).w.p=nr
                item(a).w.s=0
                li(lastlocalitem)=a
                if e.aggr=1 and rnd_range(1,6)+rnd_range(1,6)<e.intel then
                    dprint "The "&e.sdesc &" gives you something in return."
                    if rnd_range(1,100)<66 then
                        it=makeitem(94)
                    else
                        it=makeitem(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                endif
            else
               dprint "The "&e.sdesc &" doesnt want the "& item(a).desig
            endif
        case else
            if item(a).ty=13 and rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" eats the "& item(a).desig
                e.sleeping=e.sleeping+item(a).v1
                if e.sleeping>0 then dprint "And falls asleep!"
                item(a)=item(lastitem)
                lastitem=lastitem-1
            else
                dprint "The "&e.sdesc &" doesnt want the "& item(a).desig
            endif
        end select
    endif
        
    return 0
end function


  
function rndsentence(aggr as short, intel as short) as string
    
    dim s as string
    dim r as short
    if aggr=0 then
    r=rnd_range(1,8)
        if r=1 then s="It says: 'Die monster from another world!'"
        if r=2 then s="It says: 'You look tasty!'"
        if r=3 then s="It says: 'The metal gods of old demand your death!'"
        if r=4 then s="It says: 'Intruder! Flee or be destroyed'"
        if r=5 then s="It says: 'Your magic is powerfull but my arms are strong!'"
        if r=6 then s="It says: 'The time for talking is over!'"
        if r=7 then s="It says: 'I am going to kill you!'"
        if r=8 then s="It says: 'Resistance is useless!'"
    endif
    if aggr=1 then
    r=rnd_range(1,11)
        if r=1 then s="It says: 'Your fur is funny!'"
        if r=2 then s="It says: 'You are not from around, are you?'"
        if r=3 then s="It says: 'Do you have a gift for me?'"
        if r=4 then s="It says: 'I always wondered if there were other beings out there.'"
        if r=5 then s="It says: 'You can't be from another world! Faster than light travel is impossible!'"
        if r=6 then s="It says: 'I haven't seen a creature like you before!'"
        if r=7 then s="It says: 'Are you here for the festival?'"
        if r=8 then s="It says: 'You can have my food if you want.'"
        if r=9 then s="It says: 'I always wondered if there were other beings like us up there.'"
        if r=10 then 
            if askyn("It says: 'I pay you 5000 zrongs if you tell me all your technological secrets.' Do you agree? (y/n)") then
                placeitem(makeitem(88),0,0,0,0,-1)
                s="it hands you a bag of local currency while you"
                if rnd_range(1,6)+rnd_range(1,6)+player.science>10 then
                    r=rnd_range(1,6)
                    if r=1 then s=s &" teach it some basic newtonian physics."
                    if r=2 then s=s &" teach it some basic chemistry."
                    if r=3 then s=s &" teach it some basic biology."
                    if r=4 then s=s &" teach it some basic astronomy."
                    if r=5 then s=s &" teach it some how to make fire."
                    if r=6 then s=s &" teach it some how to make wheels."
                else 
                    s=s &" fail to teach it anything because you just can't find the terms it would understand."
                endif
            endif
        endif
        if r=11 then s="It says: 'Are you one of the metal gods who have returned?'"
    endif
    if aggr=2 then
    r=rnd_range(1,7)
        if r=1 then s="It says: 'Help! Help! It's an alien invasion!'"
        if r=2 then s="It says: 'Don't kill me!'"
        if r=3 then s="It says: 'Don't point those things at me!'"
        if r=4 then s="It says: 'Don't eat me!'"
        if r=5 then s="It says: 'I surrender!'"
        if r=6 then s="It says: 'Have mercy!'"
        if r=7 then s="It says: 'Gods! Save me from the evil aliens!'"
    endif
    return s
end function

function getunusedplanet() as short
    dim as short a,b,c,potential
    for a=0 to laststar
        for b=1 to 9
            potential=map(a).planets(b)
            if potential>0 then
                if planetmap(0,0,potential)=0 then
                    for c=0 to lastspecial
                        if potential=specialplanet(c) then potential=0
                    next
                    if potential>0 then return potential
                endif
            else
            endif
        next
    next
    return -1
end function

function plantname(ti as _tile) as string
    dim s as string
    dim a as byte
    dim parts(5,4) as string
    dim colors(12) as string
    dim num(5) as string
    
    num(1)="no"
    num(2)="a single"
    num(3)="few"
    num(4)="numerous"
    num(5)="many"
    
    colors(1)="black"
    colors(2)="white"
    colors(3)="red"
    colors(4)="green"
    colors(5)="blue"
    colors(6)="yellow"
    colors(7)="violet"
    colors(8)="purple"
    colors(9)="orange"
    
    parts(1,0)="single surface root"
    parts(2,0)="single deep root"
    parts(3,0)="twin root"
    parts(4,0)="branching rootsystem"
    parts(5,0)="branching surface rootsystem"
    
    parts(1,1)="short stem"
    parts(2,1)="long stem"
    parts(3,1)="wide stem"
    parts(4,1)="no stem"
    
    parts(1,2)="short twig"
    parts(2,2)="wide twig"
    parts(3,2)="thick twig"
    parts(4,2)="thin twig"
    parts(5,2)=" twig"
    
    parts(1,3)="leaves"
    parts(2,3)="wide leaves"
    parts(3,3)="thick leaves"
    parts(4,3)="sharp leaves"
    parts(5,3)="curled leaves"
    
    parts(1,4)="tiny flower"
    parts(2,4)="mushroom hat"
    parts(3,4)="wide flower"
    parts(4,4)="long flower"
    parts(5,4)="huge flower"
    
    
    s="some interesting plants"
    if ti.no=10 or ti.no=14 then 'grass
        a=rnd_range(1,4)
        if a=1 then s="grass with a very high oxygen output."
        if a=2 then s="grass with a very high nutritonal value."
        if a=3 then s="grass expelling poisonous fumes."
        if a=4 then s="grass storing high amounts of liquids."
    endif
    if ti.no=6 then 'shrubs
        
    endif
    if ti.no=7 then 'woods
    
    endif
    return s
end function


function randomcritterdescription(enemy as _monster, spec as short,weight as short,flies as short,byref pumod as byte,diet as byte,water as short,depth as short) as _monster

dim as string text
dim as string heads(4),eyes(4),mouths(4),necks(4),bodys(4),Legs(8),Feet(4),Arms(4),Hands(4),skin(6),wings(4),horns(4),tails(5)
dim as short a,w1,w2
dim as string species(12)
dim as short limbsbyspec(12),eyesbyspec(12)
dim as short noeyes,nolimbs,add,nolegs,noarms,armor,roll
if water=1 then
    w1=4
    w2=1
endif
spec=spec+1
species(1)="Avian"
species(2)="Arachnide"
species(3)="Insect"
species(4)="Mammal"
species(5)="Reptile"
species(6)="Snake"
species(7)="Humanoid"
species(8)="Cephalopod"
species(9)="Centipede"
species(10)="Amphibian"
species(11)="Gastropod"
species(12)="Fish"

limbsbyspec(1)=2
limbsbyspec(2)=8
limbsbyspec(3)=6
limbsbyspec(4)=4
limbsbyspec(5)=4
limbsbyspec(6)=0
limbsbyspec(7)=2
limbsbyspec(8)=10
limbsbyspec(9)=50
limbsbyspec(10)=4
limbsbyspec(11)=0
limbsbyspec(12)=6

eyesbyspec(1)=2
eyesbyspec(2)=8
eyesbyspec(3)=4
eyesbyspec(4)=2
eyesbyspec(5)=2
eyesbyspec(6)=2
eyesbyspec(7)=2
eyesbyspec(8)=2
eyesbyspec(9)=6
eyesbyspec(10)=2
eyesbyspec(11)=2
eyesbyspec(12)=2



add=2-rnd_range(1,4)
nolimbs=rnd_range(limbsbyspec(spec),limbsbyspec(spec)+add)
if frac(nolimbs/2)<>0 then nolimbs=nolimbs+1
add=2-rnd_range(1,4)
noeyes=rnd_range(eyesbyspec(spec),eyesbyspec(spec)+add)
noeyes=noeyes-depth
if depth=0 and noeyes<2 then noeyes=2
heads(1)="round"
heads(2)="elongated"
heads(3)="cone shaped"
heads(4)="flat"

horns(1)="short horns"
horns(2)="long horns"
horns(3)="curved horns"
horns(4)="antlers"

eyes(1)="pit eyes"
eyes(2)="compound eyes"
eyes(3)="lens eyes"
eyes(4)="occeli"

mouths(1)="elongated mouth"
mouths(2)="small mouth"
mouths(3)="big mouth"
mouths(4)="trunk"

necks(1)=""
necks(2)="long"
necks(3)="short"
necks(4)="thick"

bodys(1)="wide"
bodys(2)="long"
bodys(3)="thick"
bodys(4)="thin"

arms(1)="long arms"
arms(2)="short arms"
arms(3)="thick arms"
arms(4)="tentacles"

legs(1)="thin legs"
legs(2)="short legs"
legs(3)="tubular legs"
legs(4)="tentacles"
legs(5)="broad fins"
legs(6)="long fins"
legs(7)="legs with webbed feet"
legs(8)="skin sacks for water jets"

skin(1)=" fur"
skin(2)=" scales"
skin(3)=" leathery skin"
skin(4)=" an exoskeleton"
skin(5)=" a chitin shell"
skin(6)=" scales"

wings(4)=" Skin flaps"
wings(3)=" leather wings"
wings(2)=" feathered wings"
wings(1)=" an inflatable skin sack"

tails(1)="prehensile tail"
tails(2)="short tail"
tails(3)="long tail"
tails(4)="spiked tail"
tails(5)="prehensile tail with a stinger"

text="A "&species(spec) &" with a " & heads(rnd_range(1,4)) &" head, with "
if noeyes>0 then text=text & noeyes &" "&eyes(rnd_range(1,4))
if noeyes=0 then text=text &" no eyes"
if rnd_range(1,10)<7+w2 then
    text=text & " and a " &mouths(rnd_range(1,4))
else
    text=text &", "&rnd_range(1,2)*2 &" "& horns(rnd_range(1,4)) & " and a " &mouths(rnd_range(1,4))
    enemy.weapon=enemy.weapon+1
endif
text=text &". A "&necks(rnd_range(1,4)) &" neck leads to a " & bodys(rnd_range(1,4)) &" body, with " 
nolegs=rnd_range(1,6)*2
if nolegs>nolimbs then 
    nolegs=nolimbs
    nolimbs=0
else
    nolimbs=nolimbs-nolegs
endif

noarms=rnd_range(1,6)
if nolimbs=0 then noarms=0
if noarms>nolimbs then noarms=nolimbs

if pumod<0 and noarms=0 then noarms=2
pumod=noarms
if noarms>0 then
    text=text & noarms &" "& arms(rnd_range(1,4)) 
else
    text=text &"no arms"
endif

if nolegs>0 then
    text=text & " and " & nolegs &" "&legs(rnd_range(1,4)+w1)
else
    text=text & " and no legs"
endif

armor=rnd_range(1,5)+w2
text=text &". Its whole body is covered in"&skin(armor)&"."
if armor=1 then enemy.col=rnd_range(204,209)
if armor=2 then 
    enemy.col=rnd_range(1,3)
    if enemy.col=1 then enemy.col=78
    if enemy.col=2 then enemy.col=114
    if enemy.col=3 then enemy.col=120
endif
if armor=3 then enemy.col=rnd_range(90,94)
if armor=4 then enemy.col=rnd_range(156,159)
if armor=5 then 
    enemy.col=rnd_range(215,217)
    enemy.armor+=1
endif
if armor=6 then 
    enemy.col=rnd_range(74,77)
    enemy.armor+=2
endif
    
if rnd_range(1,6)<3 then
    if rnd_range(1,6)<3 then
        roll=rnd_range(1,3)
        text=text &" It has " & roll &" "&tails(rnd_range(1,5))&"s."
        enemy.weapon=enemy.weapon+1
    else
        roll=rnd_range(1,5)
        text=text &" It has a "&tails(roll)&"."
        if roll=4 then enemy.weapon=enemy.weapon+1
        if roll=5 then
            enemy.weapon=enemy.weapon+1
            enemy.atcost=enemy.atcost-0.2
        endif
    endif    
endif

text=text &" It weighs appr. "&weight*rnd_range(1,8)*rnd_range(1,10) &" Kg."
if flies=1 then text= text &" It flies using "&wings(rnd_range(1,3)) &"."
if diet=1 then text=text &" It is a predator."
if diet=2 then text=text &" It is a herbivour."
if diet=3 then text=text &" It is a scavenger."
enemy.ldesc=text
return enemy
end function


function givequest(st as short, byref questroll as short) as short
    dim as short a,b,bay, s,pl,car,st2,m,o,m2,o2,x,y
    dim as cords p
    static stqroll as short
    if st<>player.lastvisit.s then stqroll=rnd_range(0,2)
    do
        st2=rnd_range(0,2)
    loop until st2<>st
    a=stqroll
    if questroll>8 then
        'standard quest by office
        if basis(st).company=1 then
            do
                m=rnd_range(0,laststar)
                o=rnd_range(1,9)
            loop until map(m).planets(o)>0
            if player.questflag(7)=0 then
                if askyn("The company rep offers you a contract to deliver complete maps of a newly discovered planet in orbit " & o &" around a star at "&map(m).c.x &":" &map(m).c.y &". They will pay 1000 cr. Do you accept?(y/n)") then
                    m=map(m).planets(o)
                    player.questflag(7)=m 
                    questroll=999'save m in .... a quest?
                endif
            else
                for m=0 to laststar
                    for o=1 to 9
                        if map(m).planets(o)=player.questflag(7) then 
                            m2=m
                            o2=o
                        endif
                    next
                next
                dprint "The company rep reminds you that you still have a contract open to map a planet at "&map(m2).c.x &":" &map(m2).c.y &" orbit " & o2 &"."
            endif
        endif
        
        if basis(st).company=2 then
            if player.questflag(9)=0 then
                if askyn("The rep says:'We have learned that there are still working robot factories found on some planets on this sector. We would like to send a team of scientists to one of these. Would you be willing to find a suitable target for 5000 credits?('(y/n)") then 
                    player.questflag(9)=1
                    questroll=999
                endif
            else
                dprint "The company rep reminds you that you have yet to locate a factory of the ancients"
            endif    
        endif
        
        if basis(st).company=3 then
            car=rnd_range(3,4)
            dprint "The company rep offers you a contract to deliver "&car &" tons of cargo to station " &st2+1 &"."
            if askyn(" They will pay 200 cr per ton. Do you accept?(y/n)") then
                do
                    bay=getnextfreebay
                    if bay>0 then
                        player.cargo(bay).x=11
                        player.cargo(bay).y=st2
                        car=car-1
                    endif
                loop until getnextfreebay=0 or car=0
                if car>0 then dprint "You don't have enough room for all the cargo, and leave "&car &" tons behind."
                questroll=999
            endif
        endif
        
        if basis(st).company=4 then
            if player.questflag(10)=0 then
                m=rnd_range(2,16)
                if askyn("Omega Bioengineering's scientists want to conduct an experiment. They need a planet with a "&atmdes(m) &" atmosphere, and without plant life for that. They are willing to pay 2500 credits for the position of a possible candidate. Do you want to help in the search (y/n)?") then 
                    player.questflag(10)=m
                    questroll=999
                endif
            else 
                dprint "The company rep reminds you that you have yet to find a planet with an "&atmdes(player.questflag(10))&" atmosphere without life."
            endif
        endif
    else
        'other quests
        a=rnd_range(0,2)
        if a<>st and player.h_maxcargo>0 then
            'Deliver package
            if rnd_range(1,100)<50 or player.questflag(8)<>0 then
                if askyn("The company rep needs some cargo delivered to station "&a+1 &". He is willing to pay 500 credits. Do you accept? (y/n)" ) then
                    bay=getnextfreebay
                    if bay<=0 then 
                        if askyn("Do you want to make room for the cargo (losing "& basis(st).inv(player.cargo(1).x-1).n &")?(y/n)") then bay=1
                    endif
                    if bay>0 then
                        player.cargo(bay).x=10 'type=specialcargo
                        player.cargo(bay).y=a 'Destination
                    endif
                endif
            else
                b=rnd_range(1,16)
                if askyn("The company rep needs a "&shiptypes(b) &" hull towed to station "&a+1 &" for refits. He is willing to pay "& b*50 &" Cr. Do you accept(y/n)?") then
                    if player.tractor=0 then
                        dprint "You need a tractor beam for this job.",14,14
                    else
                        player.towed=-b
                        player.questflag(8)=a
                    endif
                endif
            endif
        else
            
            if st<>player.lastvisit.s then stqroll=rnd_range(1,9)
            a=stqroll
            
            if a=1 and player.questflag(2)=0 then
                dprint "The company rep informs you that one of the local executives has been abducted by pirates. They demand ransom, but it is company policy to not give in to such demands. There is a bounty of 10.000 CR on the pirates, and a bonus of 5000 CR to bring back the exec alive.",15,15
                no_key=keyin
                player.questflag(2)=1
                s=getrandomsystem
                if s=-1 then s=rnd_range(0,laststar)
                pl=getrandomplanet(s)
                if pl<0 then pl=rnd_range(1,9)
                makeplanetmap(pl,3,map(s).spec)
                for a=1 to rnd_range(1,3)
                    planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-65
                next
                planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-66
            endif
            
            if a=2 and player.questflag(5)=0 then
                dprint "The company rep warns you about a ship that has reportedly been preying on pirates and merchants alike. 'It's fast, it's dangerous, and a confirmed kill is worth 15.000 credits to my company."
                player.questflag(5)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=makeship(11)
                fleet(lastfleet).flag=5
                fleet(lastfleet).c=rnd_point            
            endif
            
            if a=3 and player.questflag(5)=2 then
                dprint "The company rep warns you that there are reports about another ship prowling space of the type you destroyed before. The company again pays 15.000 Credits if you bring it down"
                player.questflag(6)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=makeship(11)
                fleet(lastfleet).mem(2)=makeship(11)
                fleet(lastfleet).mem(3)=makeship(11)
                fleet(lastfleet).flag=6
                fleet(lastfleet).c=rnd_point            
            endif
            
            if a=4 and player.questflag(11)=0 then
                player.questflag(11)=1
                x=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.x
                y=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.y
                if x<0 then x=0
                if y<0 then y=0
                if x>sm_x then x=sm_x
                if y>sm_y then y=sm_y
                dprint "The company rep tells you about a battleship that has gone missing. It's last known position was " & x &":" &y & ". There is a 5000 Credit reward for finding out what happened to it."
                lastdrifting=lastdrifting+1
                m=lastdrifting
                drifting(m).s=14
                drifting(m).x=x
                drifting(m).y=y
                drifting(m).m=lastplanet+1
                lastplanet=lastplanet+1
                loadmap(14,lastplanet)
                makedrifter(drifting(m))
                p=rnd_point(lastplanet,0)
                planetmap(p.x,p.y,lastplanet)=-226
                player.questflag(11)=1
                m=lastplanet
                planets(m).darkness=0
                planets(m).depth=1
                planets(m).atmos=6
        
                planets(m).mon_template(0)=makemonster(29,m)
                planets(m).mon_noamin(0)=10
                planets(m).mon_noamax(0)=20
                planets(m).flavortext="No hum from the engines is heard as you enter the Battleship. Emergency lighting bathes the corridors in red light, and the air smells stale."
            endif
            
            if a=5 and player.questflag(16)>0 and player.questflag(15)=0 then'other quests
                dprint "The company rep informs you that there is a special 10000 Cr bounty for bringing down the infamous 'Anne Bonny', a pirate battleship.",15,15
                player.questflag(15)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(1)
            endif
            
            if a=6 and player.questflag(17)>0 and player.questflag(16)=0 then'other quests
                dprint "The company rep informs you that there is a special 8000 Cr bounty for bringing down a pirate destroyer, called 'The Black Corsair'.",15,15
                player.questflag(16)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(2)
            endif
            
            if a=7 and (player.questflag(18)>0 or player.questflag(19)>0) and player.questflag(17)=0 then'other quests
                dprint "The company rep informs you that there is a special 5000 Cr bounty for bringing down a pirate cruiser, called 'Hussar'.",15,15
                player.questflag(17)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(3)
            endif
            
            if a=8 and player.questflag(18)=0 then'other quests
                dprint "The company rep informs you that there is a special 2500 Cr bounty for bringing down a pirate fighter, called 'Adder'.",15,15
                player.questflag(18)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(4)
            endif
            
            if a=9 and player.questflag(19)=0 then'other quests
                dprint "The company rep informs you that there is a special 2500 Cr bounty for bringing down a pirate fighter, called 'Widow'.",15,15
                player.questflag(19)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(5)
            endif
            
            questroll=999
        endif
    endif
return questroll
end function

function planetbounty() as short
    dim p as cords
    
    if planets(specialplanet(2)).visited>0 and planets(specialplanet(2)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            player.money=player.money+2500
            planets(specialplanet(2)).flags(21)=1
            planets(specialplanet(2)).mon_template(8)=makemonster(7,specialplanet(2))
            planets(specialplanet(2)).mon_noamin(8)=10
            planets(specialplanet(2)).mon_noamax(8)=15
            p=rnd_point(specialplanet(2),0)
            planetmap(p.x,p.y,specialplanet(2))=-67
        endif
    endif
    
    if planets(specialplanet(3)).visited>0 and planets(specialplanet(3)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            player.money=player.money+2500
            planets(specialplanet(3)).flags(21)=1
            planets(specialplanet(3)).mon_template(8)=makemonster(7,specialplanet(3))
            planets(specialplanet(3)).mon_noamin(8)=10
            planets(specialplanet(3)).mon_noamax(8)=15
            p=rnd_point(specialplanet(3),0)
            planetmap(p.x,p.y,specialplanet(3))=-67
        endif
    endif
    
    if planets(specialplanet(4)).visited>0 and planets(specialplanet(4)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            player.money=player.money+2500
            planets(specialplanet(4)).flags(21)=1
            planets(specialplanet(4)).mon_template(8)=makemonster(7,specialplanet(4))
            planets(specialplanet(4)).mon_noamin(8)=10
            planets(specialplanet(4)).mon_noamax(8)=15
            p=rnd_point(specialplanet(4),0)
            planetmap(p.x,p.y,specialplanet(4))=-67
        endif
    endif
    
    if planets(specialplanet(16)).visited>0 and planets(specialplanet(16)).flags(21)=0 then
        if askyn("He's interested in the position of Eden. Do you want to sell the coordinates for 10000 Cr?(y/n)") then
            player.money=player.money+10000
            planets(specialplanet(16)).flags(21)=1
            planets(specialplanet(16)).mon_template(8)=makemonster(7,specialplanet(16))
            planets(specialplanet(16)).mon_noamin(8)=10
            planets(specialplanet(16)).mon_noamax(8)=15
            p=rnd_point(specialplanet(16),0)
            planetmap(p.x,p.y,specialplanet(16))=-67
        endif
    endif
    
    if planets(specialplanet(21)).visited>0 and planets(specialplanet(21)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            player.money=player.money+1000
            planets(specialplanet(21)).flags(21)=1
            planets(specialplanet(21)).mon_template(8)=makemonster(7,specialplanet(21))
            planets(specialplanet(21)).mon_noamin(8)=10
            planets(specialplanet(21)).mon_noamax(8)=15
            p=rnd_point(specialplanet(21),0)
            planetmap(p.x,p.y,specialplanet(21))=-67
        endif
    endif
    
    if planets(specialplanet(22)).visited>0 and planets(specialplanet(22)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            player.money=player.money+1000
            planets(specialplanet(22)).flags(21)=1
            planets(specialplanet(22)).mon_template(8)=makemonster(7,specialplanet(22))
            planets(specialplanet(22)).mon_noamin(8)=10
            planets(specialplanet(22)).mon_noamax(8)=15
            p=rnd_point(specialplanet(22),0)
            planetmap(p.x,p.y,specialplanet(22))=-67
        endif
    endif
    
    if planets(specialplanet(23)).visited>0 and planets(specialplanet(23)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            player.money=player.money+1000
            planets(specialplanet(23)).flags(21)=1
            planets(specialplanet(23)).mon_template(8)=makemonster(7,specialplanet(23))
            planets(specialplanet(23)).mon_noamin(8)=10
            planets(specialplanet(23)).mon_noamax(8)=15
            p=rnd_point(specialplanet(23),0)
            planetmap(p.x,p.y,specialplanet(23))=-67
        endif
    endif
    
    if planets(specialplanet(24)).visited>0 and planets(specialplanet(24)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            player.money=player.money+1000
            planets(specialplanet(24)).flags(21)=1
            planets(specialplanet(24)).mon_template(8)=makemonster(7,specialplanet(24))
            planets(specialplanet(24)).mon_noamin(8)=10
            planets(specialplanet(24)).mon_noamax(8)=15
            p=rnd_point(specialplanet(24),0)
            planetmap(p.x,p.y,specialplanet(24))=-67
        endif
    endif
    
    if planets(specialplanet(25)).visited>0 and planets(specialplanet(25)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            player.money=player.money+1000
            planets(specialplanet(25)).flags(21)=1
            planets(specialplanet(25)).mon_template(8)=makemonster(7,specialplanet(25))
            planets(specialplanet(25)).mon_noamin(8)=10
            planets(specialplanet(25)).mon_noamax(8)=15
            p=rnd_point(specialplanet(25),0)
            planetmap(p.x,p.y,specialplanet(25))=-67
        endif
    endif
    
    
    return 0
end function


function showquests() as short
    dim as short a,b,c,d,sys,p
    dim dest(10) as short
    cls
    color 15,0
    print "Missions:"
    print
    color 11,0
    for a=1 to 10
        if player.cargo(a).x=10 or player.cargo(a).x=11 then 
            b+=1
            dest(b)=player.cargo(a).y+1
        endif
    next
    if b>0 then
        color 15,0
        print "Cargo:"
        for a=1 to b
            color 11,0
            print "  Cargo for Station-"&dest(a)
        next
    endif
    if player.questflag(8)>0 and player.towed<0 then print " Deliver a "&shiptypes(-player.towed) &" hull to Station "&player.questflag(8)+1
    print
    if player.questflag(7)>0 then 
        sys=sysfrommap(player.questflag(7))
        for d=1 to 9
            if map(sys).planets(d)=player.questflag(7) then p=d
        next
        print "  Map planet in orbit "&p &" in the system at "&map(sys).c.x &":"&map(sys).c.y
    endif
    if player.questflag(9)=1 then print "  Find a working robot factory"
    if player.questflag(10)>0 then print "  Find a planet without life and a "&atmdes(player.questflag(10))&" atmosphere."
    if player.questflag(11)=1 then print "  Find a missing company battleship"
    if player.questflag(2)=1 then print "  Rescue a company executive from pirates"
    if player.questflag(12)=1 then print "  A small green alien told you about a monster in their mushroom caves."
    print
    color 15,0
    print "Headhunting"
    color 11,0
    if player.questflag(15)=1 then print "  Bring down the pirate battleship 'Anne Bonny'"
    if player.questflag(16)=1 then print "  Bring down the pirate destroyer 'Black Corsair'"
    if player.questflag(17)=1 then print "  Bring down the pirate cruiser 'Hussar'"
    if player.questflag(18)=1 then print "  Bring down the pirate fighter 'Adder'"
    if player.questflag(19)=1 then print "  Bring down the pirate fighter 'Black Widow'"
    if player.questflag(5)=1 then print "  Bring down an unknown alien ship"
    if player.questflag(6)=1 then print "  Bring down an unknown alien ship"
    
    no_key=keyin
    return 0
end function

            

function checkquestcargo(player as _ship, st as short) as _ship
    dim as short a,b
    for a=1 to 10
        if player.cargo(a).x=10 and player.cargo(a).y=st then
            player.cargo(a).x=1
            player.cargo(a).y=0
            player.money=player.money+500
            dprint "the local representative pays you for delivering the cargo",15,15
        endif
        if player.cargo(a).x=11 and player.cargo(a).y=st then
            player.cargo(a).x=1
            player.cargo(a).y=0
            player.money=player.money+200
            b=b+1
        endif
    next
    if player.questflag(8)=st then
        if player.towed<0 then
            dprint "you deliver the " &shiptypes(-player.towed) &" hull and get payed "&abs(player.towed)*50 &" Cr."
            player.money=player.money+abs(player.towed)*50
        endif
        player.towed=0
        player.questflag(8)=0
    endif
    
    if b>0 then dprint "You deliver "& b &" tons of cargo for triax traders and get payed "& b*200 &" credits."
    return player
end function
