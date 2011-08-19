function crew_bio(i as short) as string
    dim t as string
    select case crew(i).story(0)
    case is =1
        t="Was born to rich parents"
    case is =2
        t="Was born to well to do parents"
    case is =3
        t="Was born to lower class parents"
    case is =4
        t="Was born to poor parents"
    case else
        t="Was born to middle class parents"
    end select
    select case crew(i).story(1)
    case is=2
        t=t &" from earth."
    case is=3
        t=t &" from an asteroid base."
    case is=4
        t=t &" from a space station."
    case else
        t=t &" on a colony world."
    end select
    t=t &" "&crew(i).n
    select case crew(i).story(2)
    case 1 to 3
        t=t &" got very little education."
    case 4 to 5
        t=t &" got a masters degree."
    case else
        t=t &" got a decent education."
    end select
    select case crew(i).story(3)
    case 1 to 3
        t=t &" Always wanted to be a "&crew_desig(crew(i).typ)
    case else
        t=t &" First wanted to be a "&crew_desig(rnd_range(1,6))&", but then became a "&crew_desig(crew(i).typ)&"."
    end select
    select case crew(i).story(4)
    case 1 to 3
        t=t &" Is really happy with the job."
    case 4 to 6
        t=t &" Is unhappy with the job."
    case else
        t=t &" Likes the job well enough."
    end select
    
    return t
end function


function alerts(awayteam as _monster,walking as short) as short
    dim a as short
    static wg as short
    static wj as short
    if awayteam.oxygen=awayteam.oxymax then wg=0
    if awayteam.jpfuel=awayteam.jpfuelmax and awayteam.move=2 then wj=0
    if int(awayteam.oxygen<awayteam.oxymax*.5) and wg=0 then 
        dprint ("Reporting oxygen tanks half empty",14)
        wg=1
        for a=1 to wg
            if _sound=0 or _sound=2 then    
                #ifdef _windows
                FSOUND_PlaySound(FSOUND_FREE, sound(1))                
                #endif
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.25) and wg=1 then 
        dprint ("Oxygen low.",14)
        wg=2
        for a=1 to wg
            if _sound=0 or _sound=2 then
                #ifdef _windows
                FSOUND_PlaySound(FSOUND_FREE, sound(1))   
                sleep 350
                #endif
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)       
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.125) and wg=2 then
        dprint ("Switching to oxygen reserve!",12)
        wg=3
        for a=1 to wg
            if _sound=0 or _sound=2 then 
                #ifdef _windows
                FSOUND_PlaySound(FSOUND_FREE, sound(1)) 
                sleep 350
                #endif
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)    
    endif
    if awayteam.jpfuel<awayteam.jpfuelmax then
        if awayteam.jpfuel/awayteam.jpfuelmax<.5 and wj=0 then 
            wj=1
            for a=1 to wj
                if _sound=0 or _sound=2 then    
                    #ifdef _windows
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    sleep 350
                    #endif
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next  
            walking=0  
            dprint ("Jetpack fuel low",14)
        endif
        if awayteam.jpfuel/awayteam.jpfuelmax<.3 and wj=1 then 
            wj=2
            for a=1 to wj
                if _sound=0 or _sound=2 then    
                    #ifdef _windows
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    sleep 350
                    #endif
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next   
            walking=0 
            dprint ("Jetpack fuel very low",14)
        endif
        
        if awayteam.jpfuel<5 and wj=2 then 
            wj=3
        for a=1 to wj
                if _sound=0 or _sound=2 then    
                    #ifdef _windows
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    sleep 350
                    #endif
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next    
            dprint ("Switching to jetpack fuel reserve",12)
            walking=0
        endif
    else
        wj=0
    endif
    return walking
end function

function makehullbox(t as short,file as string) as string
    dim as _ship s
    dim as string box
    s=gethullspecs(t,file)
    box=s.h_desig & "||"
    if len(s.h_desc)>1 then box=box &s.h_desc 
    box=box &" | | Hull Max.:"&s.h_maxhull &" | Shield Max.:"&s.h_maxshield &" | Engine Max.:"&s.h_maxengine &" | Sensors Max.:"&s.h_maxsensors 
    box=box &" | Crew:"&s.h_maxcrew &" | Cargobays:"&s.h_maxcargo &" | Weapon turrets:" &s.h_maxweaponslot &" | Fuelcapacity:"&s.h_maxfuel &" |"
    return box
end function

function low_morale_message() as short
    dim as short a,total,average,crewmembers,who,dead
    for a=2 to 128
        if crew(a).hp>0 then
            total+=crew(a).morale+addtalent(1,4,10)
            crewmembers+=1
        else
            dead=a
        endif
    next
    average=total/crewmembers
    who=rnd_range(2,crewmembers)
    if rnd_range(1,100)>10+average then return 0
    select case average
        case is<10
            select case rnd_range(1,10)
                case is=1
                    dprint crew(who).n &" thinks aloud about 'retiring the captain by plasma rifle'"
                case is=2
                    dprint "Somebody has painted a message on an airlock:'Crew to captain: Home is this way.'"    
                case is=3
                    dprint crew(who).n &" throws his food in your direction."
                case is=4
                    dprint "You overhear a group of crewmen talking about mutiny"
                case is=5
                    dprint crew(who).n &" has a nervous breakdown."
                case is=6
                    dprint crew(who).n &" freaks out, certain that the whole crew is going to die horribly."
                case is=7
                    dprint "You catch " &crew(who).n &" staring down the barrel of his gun."
                case is=8
                    dprint crew(who).n &" wonders aloud about whether his uniform is strong enough to hang himself with."
                case is=9
                    dprint crew(who).n &" rants about how there's no adventure out here, only death and horror."
                case is=10
                    dprint crew(who).n &" rants about how you're the worst captain ever, and that you couldn't command your way out of a nutsack."

            end select
        case 11 to 20
            select case rnd_range(1,16)
                case is=1
                    dprint "A fight breaks out about the quality of the food."
                case is=2
                    dprint "You hear "& crew(who).n &" mutter 'Why don't you do it yourself, my captain?' before following your order."    
                case is=3
                    dprint "Your speech on tardiness on duty is met with little interest."
                case is=4
                    dprint "You learn that the crew has renamed the ship, and it is ... colorfull"
                case is=5
                    dprint crew(who).n &" states that he will quit the next time you dock, and that everybody who still has a full set of marbles should join him."
                case is=6
                    dprint crew(who).n &" greets you with 'What suicide mission will it be today?'" 
                case is=7
                    dprint "A fight breaks out over the away team equipment."
                case is=8
                    dprint "A fight breaks out over the quality of the crew quarters."
                case is=9
                    dprint "A fight breaks out over which crew member has made the most mistakes so far."
                case is=10
                    dprint "A fight breaks out over who *needs* cybernetic implants."
                case is=11
                    dprint "A fight breaks out over who is getting the most pay."
                case is=12
                    dprint "A fight breaks out over the color of the ship's paint."
                case is=13
                    dprint "You catch " &crew(who).n &" drinking at his post."
                case is=14
                    dprint crew(who).n &" wishes aloud that he had better equipment... or a better leader."
                case is=15
                    dprint crew(who).n &" wonders aloud about whether any amount of money could be worth *this*."
                case is=16    
                    dprint crew(who).n &" obsessively reviews his last will and testament."

            end select
        case 21 to 30
            select case rnd_range(1,9)
                case is=1
                    dprint crew(who).n &" tells you that there is a rather mean joke going around about you."
                case is=2
                    dprint crew(who).n &" asks if he can get a raise."
                case is=3
                    dprint crew(who).n &" reassures you that everybody is 100% behind your decions, no matter what some may say."
                case is=4
                    dprint crew(who).n &" reminds you that everybody makes mistakes, at least some of the time"
                case is=5
                    if dead<>0 then dprint crew(who).n &" is certain that the death of "&crew(dead).n &" was unavoidable."
                case is=6
                    dprint crew(who).n &" is certain that the pay he receives will be better as soon as the ships ventures are a little more successfull."
                case is=7
                    dprint crew(who).n &" mutters something about how this kind of thing was a lot more fun as a holodeck simulation."
                case is=8
                    dprint crew(who).n &" seems a little skittish... more so than when he first signed on."
                case is=9
                    dprint crew(who).n &" says 'Hey, buck up. We're not dead yet, right? ...Right?'"
            end select
        case 110 to 120
            if rnd_range(1,100)<5 then
                select case rnd_range(1,4)
                    case is=1
                        dprint crew(who).n &" starts whistling."
                    case is=2
                        dprint crew(who).n &" tells everybody about the special paintjob he plans to get for his spacesuit."
                    case is=3
                        dprint crew(who).n &" thinks this will be one of the more profitable hauls."
                    case is=4
                        dprint crew(who).n &" bores everyone to tears by explaining in depth how he will invest enough to get a retirement pension out of his (great) wage."
                end select
            endif
        case is>120
            if rnd_range(1,100)<5 then
            select case rnd_range(1,3)
                case is=1
                    dprint crew(who).n &" thinks this expedition is going great so far."
                case is=2
                    dprint crew(who).n &" tells a funny joke."
                case is=3
                    dprint crew(who).n &" thinks you are the best captain ever!"
                case is=4
                    dprint crew(who).n &" explains that he never earned as much money as here."
            end select
            endif
    end select
    return 0
end function

function moneytext() as string
    dim text as string
    dim as short b,a
    dim per(3) as single
    text=text &" || "
    if player.money-500>0 then
        text=text &"Made a profit of {10} "&credits(player.money-500) &" {11} credits in {15} "&player.turn &" {11} turns." 
    endif
    if player.money-500=0 then
        text=text &"Didn't earn any money in {15} "&player.turn &" {11} turns." 
    endif
    if player.money-500<0 then
        text=text &"Made a loss of {12} "&credits(abs(player.money-500)) &" {11} credits in {15} "&player.turn &" {11} turns." 
    endif 
    
    text=text & " | "
    
    if player.tradingmoney<0 then
        text =text & "Made a loss of {12}" &credits(abs(player.tradingmoney)) &" {11} Credits while attempting to be a merchant"
    endif
    if player.tradingmoney=0 then
        text = text & "Didnt try to be a merchant"
    endif
    if player.tradingmoney>0 then
        text = text & "Earned {10} " &credits(player.tradingmoney) &" {11} Credits in trading goods. (" &mercper &" %)"
    endif

    text=text & " | "
    
    if player.piratekills>0 then
        if player.piratekills>0 and player.money>0 then per(2)=100*(player.piratekills/player.money)
        if per(2)>100 then per(2)=100
        text=text &" {10}"& credits(player.piratekills) & " {11} Credits were from bountys for destroyed pirate ships (" &per(2) &")"
    else
        text=Text & "No Pirate ships were destroyed"
    endif
    
    text=text & " | "
    
    if pirateplanet(0)=-1 then
        text =text & "Destroyed the Pirates base of operation! |"
    endif
    b=0
    for a=1 to _NoPB
        if pirateplanet(a)=-1 then b=b+1
    next
    if b=1 then 
        text=text & " Destroyed a pirate outpost. |"
    endif
    if b>1 then 
        text=text & " Destroyed " & b &" pirate outposts. |"
    endif
    
    text=text & " | "
    for a=0 to 9
        b+=combon(a).rank
    next
    if b>0 then text=text &" Made "& credits(b*100) &" Cr. in company bonuses. |"
    text=text &"|"
    if player.money-500>0 then
        'if faction(0).war(1)<=0 then text=text & "Made all money with honest hard work"
        'if player.merchant_agr>0 and player.pirate_agr<50 then text = text & "Found piracy not to be worth the hassle"
        'if player.pirate_agr<=0 and player.merchant_agr>50 then text = text & "Made a name as a bloodthirsty pirate"
    endif
    text=text &" |"
    return text
end function

function uniques() as string
    dim text as string
    dim descr(lastspecial) as string
    dim as short a,platforms
    descr(0)="The destination of a generation ship"
    descr(1)="The home of an alien claiming to be a god"
    descr(2)="An alien city with working defense systems"
    descr(3)="An ancient city"
    descr(4)="Another ancient city"
    descr(5)="A world without water and huge sandworms"
    descr(6)="A world with invisible beasts"
    descr(7)="the homeworld of the "&civ(0).n
    descr(8)="A world with very violent weather"
    descr(9)="An alien base still in good condition"
    descr(10)="An independent colony"
    descr(11)="A casino trying to cheat"
    descr(12)="The prison of an ancient entity"
    descr(13)="Murchesons Ditch"
    descr(14)="The blackmarket"
    descr(15)="A pirate gunrunner operation" 
    descr(16)="A planet with immortal beings" 
    descr(17)="A civilization upon entering the space age"
    descr(18)="The home planet of a civilization about to explore the stars"
    descr(19)="The outpost of an advanced civilization"
    descr(20)="A creepy colony"
    descr(26)="A crystal planet"
    descr(27)="A living planet"
    descr(28)="An ancient city with an intact spaceport"
    descr(29)="A very boring planet"
    descr(30)="The last outpost of an ancient race"
    descr(31)="An asteroid base of an ancient race"
    descr(32)="An asteroid base"
    descr(33)="Another asteroid base"
    descr(34)="A world devastated by war"
    descr(35)="A world populated by peaceful cephalopods"
    descr(36)="A tribe of small green people in trouble"
    descr(37)="An invisible labyrinth"
    descr(39)="A very fertile world plagued by burrowing monsters"
    descr(40)="A world under control of Eridiani Explorations"
    descr(41)="A world under control of Smith Heavy Industries"
    descr(42)="A world under control of Triax Traders"
    descr(43)="A world under control of Omega Bioengineering"
    descr(43)="A world under control of Omega Bioengineering"
    descr(44)="The ruins of an ancient war"
    descr(46)="the homeworld of the "&civ(1).n
    
    text= "|{15}Unique planets discovered:{11}|"
    
    for a=0 to lastspecial
        if specialplanet(a)>0 and specialplanet(a)<=lastplanet then
            if planets(specialplanet(a)).mapstat>0 then 
                select case a
                case is =20
                    if specialflag(20)=1 then
                        text=text &"A colony under the control of an alien lifeform|"
                    else
                        text=text & descr(a) &"|"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    text=text & descr(a) &"|"
                end select
            endif
        endif
    next
    if platforms>1 then text=text & platforms &" ancient refueling platforms"
    if platforms=1 then text=text & "An ancient refueling platform"
    text=text &"|"
    return text
end function


function listartifacts() as string
    dim as short a,c
    dim flagst(16) as string
    dim as short hd,sd
    flagst(1)="Fuel System"
    flagst(2)=" hand disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" ship disintegrator"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" cryochamber"
    flagst(9)="Teleportation device"
    flagst(10)="Air recycler"
    flagst(11)="Data crystal(s)"
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    flagst(16)="Wormhole navigation device"
    color 15,0
    for a=0 to 5
        if player.weapons(a).desig="Disintegrator" then sd+=1
    next
    for a=0 to lastitem
        if item(a).w.s=-1 and item(a).id=97 then hd+=1
    next
    for a=1 to 16
        if artflag(a)>0 then
            if a=2 or a=4 or a=8 then
                if a=2 then 
                    if hd=1 then flagst(0)=flagst(0) & hd & flagst(a)&"|"
                    if hd>1 then flagst(0)=flagst(0) & hd & flagst(a)&"s|"
                endif
                if a=4 then 
                    if sd=1 then flagst(0)=flagst(0) & sd & flagst(a)&"|"
                    if sd>1 then flagst(0)=flagst(0) & sd & flagst(a)&"s|"
                endif
                if a=8 then 
                    if player.cryo=1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"|"
                    if player.cryo>1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"s|"
                endif
            else
                c=c+1
                flagst(0)=flagst(0) &flagst(a) &"|"
            endif
        endif
    next
    if c=0 and sd=0 and hd=0 then
        flagst(0)=flagst(0) &"      {14} None |"
    endif
    
    flagst(0)="{15}Alien Artifacts {11}|"&flagst(0)
    if sd>1 then flagst(0)=flagst(0) &sd &" Ship Disintegrators|"
    if sd=1 then flagst(0)=flagst(0) &sd &" Ship Disintegrator|"
    if hd>1 then flagst(0)=flagst(0) & hd &" portable Disintegrators|"
    if hd=1 then flagst(0)=flagst(0) & hd &" portable Disintegrator|"
    return flagst(0)    
end function

function explorationtext() as string
    dim text as string
    dim as short a,b,c,xx,yy,exps,expp,expl,tp,total,per
    dim discovered(lastspecial) as short
    
    for a=0 to laststar
        if map(a).discovered>0 then exps=exps+1
        for b=1 to 9
            if map(a).planets(b)>0 then
                tp+=1
                if planets(map(a).planets(b)).mapstat<>0 then expp=expp+1
                for xx=0 to 60
                    for yy=0 to 20
                        if planetmap(xx,yy,map(a).planets(b))>0 then expl=expl+1
                        total=total+1
                    next
                next
            endif
        next
    next
    for c=0 to lastspecial
        if specialplanet(c)>=0 and specialplanet(c)<=lastplanet then
            if planets(specialplanet(c)).visited<>0 then discovered(c)=1         
        endif
    next
    text="|{15} Discoveries:{11}|Discovered " & exps & " Systems and mapped " & expp & " of " &tp &" Planets. (" &explper &" %) |"
    
    b=0
    for a=0 to 25
        if discovered(a)=1 then b=b+1
    next
    if b=0 then 
        text=text & "|No remarkable planets discovered."
    endif
    if b>0 then
        if b=1 then
            text=text & "|"& b &" remarkable planet discovered."
        else
            text=text & "|"& b &" remarkable planets discovered."
        endif
    endif
    
    text=text & " |Defeated "
    if player.alienkills=0 then text =text & "no Aliens"
    if player.alienkills=1 then text =text & player.alienkills &" Alien."
    if player.alienkills>1 then text =text & player.alienkills &" Aliens."
    if player.deadredshirts=0 then 
        text=text & " |Set new safety standards for space exploration by losing not a single crewmember."
    else
        text=text & " |{12} "& player.deadredshirts &" {11} casualties among the crew."
    endif
    text=text &" |"
    return text
end function

function missiontype() as string
    dim text as string
    dim per(2) as short
    per(1)=mercper
    per(2)=explper
    per(0)=100-per(1)-per(2)
    text= " |Mission type: "
    'if player.pirate_agr<=0 and player.merchant_agr>50 then 
     '   text=text & "Bloodthristy pirate scum!|"
    'else
        if per(0)>per(1) and per(0)>per(2) then text=text & "Explorer |"
        if per(1)>per(2) and per(1)>per(0) then text=text & "Merchant |"
        if per(2)>per(0) and per(2)>per(1) then text=text & "Pirate Killer |"
'    endif
    return text
end function


function shipstatsblock() as string
    dim t as string
    dim as short c,a,mjs 
    c=10
    if player.hull<(player.h_maxhull+player.addhull)/2 then c= 14
    if player.hull<2 then c=12    
    t= "{15}Hullpoints(max :{11}"&player.h_maxhull+player.addhull &"{15}):{"&c &"}" & player.hull
    if player.shield>0 then
        c= 10
        if player.shield<player.shieldmax/2 then c=14
    else
        c=15
    endif
    t=t &"|{15}Shieldgenerator(max :{11}"&player.shieldmax & "{15}):{"&c &"}"&player.shield
    t=t &"|{15}Engine:{11}"& player.engine
    for a=1 to 5
        if player.weapons(a).made=88 then mjs+=1
        if player.weapons(a).made=89 then mjs+=2
    next
    t = t &"{15}({11}"&player.engine+2-player.h_maxhull\15+mjs &"{15} MP) Sensors:{11}"& player.sensors
    return t 
end function

function Crewblock() as string
    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,a
    for a=6 to 128
       if crew(a).typ=6 then c1=c1+1
       if crew(a).typ=7 then c2=c2+1
       if crew(a).typ=8 then c3=c3+1
       if crew(a).typ=9 then c4=c4+1
       if crew(a).typ=10 then c5=c5+1
       if crew(a).typ=11 then c6=c6+1
       if crew(a).typ=12 then c7=c7+1
       if crew(a).typ=13 then c8=c8+1
       if crew(a).disease>0 then sick+=1
    next
    dim t as string
    t="{15}Crew Summary |"
    t=t & "{15} | Pilot   :{11}"
    if player.pilot(0)<=0 then 
        t=t &"{10} -"
    else
        t=t &player.pilot(0)
    endif
    t=t & "{15} | Gunner  :{11}"
    if player.gunner(0)<=0 then 
        t=t &"{10} -"
    else
        t=t &player.gunner(0)
    endif
    t=t & "{15} | Science :{11}"
    if player.science(0)<=0 then 
        t=t &"{10} -"
    else
        t=t &player.science(0)
    endif
    t=t & "{15} | Doctor  :{11}"
    if player.doctor(0)<=0 then 
        t=t &"{10} -"
    else
        t=t &player.doctor(0)
    endif
    t = t & "{15} || Total bunks:{11}"&player.h_maxcrew+player.crewpod
    if player.cryo>0 then t=t &"{15} || Cryo Chambers:{11}"&player.cryo
    t=t &"{15} || Security :{11}"&c1+c2+c3+c4+c5+c6+c7+c8
    t=t &"{15} | Green    :{11}"&c1
    t=t &"{15} | Veterans :{11}"&c2
    t=t &"{15} | Elite    :{11}"&c3
    if c4>0 then t=t &"{15} | Insectw  :{11}"&c4
    if c5>0 then t=t &"{15} | Cephalop.:{11}"&c5
    if c6>0 then t=t &"{15} | Neodog   :{11}"&c6
    if c7>0 then t=t &"{15} | Neoape   :{11}"&c7
    if c8>0 then t=t &"{15} | Robot    :{11}"&c8
    if sick>0 then t=t &"{14}|| Sick:"&sick
    return t 
end function

function hasassets() as short
    dim a as short
    for a=2 to 8
        if retirementassets(a)>0 then return 1
    next
    return 0
end function

function sellassetts () as string
    dim t as string
    if retirementassets(2)>0 then
        player.money+=500
        retirementassets(2)=0
        return "You have to sell your country manor"
    endif
    
    if retirementassets(3)>0 then
        player.money+=1000
        retirementassets(4)=0
        return "You have to sell your small asteroid base"
    endif
    
    if retirementassets(4)>0 then
        player.money+=2500
        retirementassets(4)=0
        return "You have to sell your asteroid base"
    endif
    
    if retirementassets(5)>0 then
        player.money+=5000
        retirementassets(5)=0
        return "You have to sell your terraformed asteroid"
    endif
    
    if retirementassets(6)>0 then
        player.money+=125000
        retirementassets(6)=0
        return "You have to sell your small planet"
    endif
    
    if retirementassets(7)>0 then
        player.money+=250000
        retirementassets(7)=0
        return "You have to sell your planet"
    endif
    
    if retirementassets(2)>0 then
        player.money+=500000
        retirementassets(2)=0
        return "You have to sell your earthlike planet"
    endif
    return t
end function


function es_part1() as string
    dim t as string
    dim rent as short
    dim mpy as single
    dim pmoney as single
    select case player.money
        case is<=0
            t="You retire with a debt of "&credits(player.money) &" Cr."
        case else
            t="You retire with "&credits(player.money) &" Cr. to your name."
    end select
    t = t &" Your ship doesn't have the range to get back to civilization, you need to book a passage on a long range transport ship for that.|"
    if player.money<500 then
        t=t & " To get a flight back to civilization you sell your ship."
        player.money=player.money+player.h_price/5
        if player.money<500 and retirementassets(0)<>0 then
            t=t &" You sell your Mudds store Franchise License."
            retirementassets(0)=0
            player.money=player.money+250
        endif
        if player.money<500 and retirementassets(1)<>0 then
            t=t &" You even sell your life insurance!"
            retirementassets(1)-=1
            player.money=player.money+250
        endif
    endif
    if player.money<500 then
        t=t &" yet still you don't have enough money to return home."
        if rnd_range(1,6)<=2 then
            t=t &" To make matters worse you are unable to find a job at the station. " 
            if rnd_range(1,6)<=2 then
                t=t &" Finally a colonist takes you in as a farm hand." 
            else
                t=t &" You have no other choice but to sign on as security on another freelancer ship."
                if rnd_range(1,6)<3 then
                    t = t &" Your exprience in planet exploration soon shows, and you survive long enough to make enough money for a ticket back home."
                    player.money=player.money+500
                else
                    t=t &" After several expeditions you finally find yourself were most redshirts end up. On the wrong end of a hungry alien"
                    return t
                endif
            endif
        else
            select case rnd_range(1,6)
            case is =1 
                t=t &" You find a job as a janitor."
            case is =2 
                t=t &" You find a job as a waiter."
            case is =3 
                t=t &" You find a job as a cook."
            case is =4 
                t=t &" You find a job as station security."
            case is =5 
                t=t &" You find a job as a station shop assistant."
            case is =6 
                t=t &" You find a job as a traders assistant."
            end select
            select case rnd_range(1,6)
            case is =1 
                t=t &" Unfortunately your employer goes broke before you get your first wage."
                player.money=player.money+0
            case is =2 
                t=t &" Unfortunately your employer doesn't pay well and rarely on time."
                player.money=player.money+50
            case is =3 
                t=t &" You get an average wage for your position."
                player.money=player.money+100
            case is =4 
                t=t &" You get an average wage for your position"
                player.money=player.money+125
            case is =5 
                t=t &" Luckily you get paid rather well."
                player.money=player.money+250
            case is =6 
                t=t &" Payment is extraordinary and you wonder why you ever decided to become a freelancer."
                player.money=player.money+500
            end select
        endif
    endif
    if player.money>=500 then
        player.money=player.money-500
        t=t &"|You board the next ship back to civilization, and arive back home with "&player.money &" Credits."
    else
        t=t &"|You make enough money to live, but not enough to ever get back to civilization."
        
        t=t &"|"
        if rnd_range(1,100)<33 then
            t=t & "You never find a partner to share your life with. Looks like the only love of a captain is his ship." 
        else
            if rnd_range(1,100)<33 then
                t=t & "You have several relationships but nothing serious. Looks like you are not made for lasting romance."
            else
                t=t & "One day you find the love of your life."
                if rnd_range(1,100)<33 then
                    t=t &" You don't have children. "
                else
                    if rnd_range(1,100)<33 then
                        t=t &" You have children. "
                    else
                        t=t &" You have a child."
                    endif
                endif
            endif
        endif
        t=t & "|"
        return t
    endif
    
    t=t &"||"
    
    mpy=player.money/(20+rnd_range(1,6))
    if mpy<120 and retirementassets(6)=0 and retirementassets(7)=0 and retirementassets(8)=0  then
        if retirementassets(0)>0 then
            t=t &"|You soon realize that you need to open a shop with your mud's store license to make a comfortable living."
            mpy=mpy+rnd_range(200,1000)
        else
            t=t &"|Soon all your money is gone and you start looking for a job."
            select case rnd_range(1,6)
            case is =1 
                t=t &" Your second carreer after being an explorer turns out to be that of a shop assistant."
                mpy=mpy+120
            case is =2 
                t=t &" Your second carreer after being an explorer turns out to be that of an accountant."
                mpy+=240
            case is =3 
                t=t &" Your second carreer after being an explorer turns out to be with the military."
                mpy+=200
            case is =4 
                t=t &" Your second carreer after being an explorer turns out to be that of a industrial designer."
                mpy+=480
            case is =5 
                t=t &" Your second carreer after being an explorer turns out to be in middle management."
                mpy+=960
            case is =6 
                t=t &" Your second carreer after being an explorer turns out to be that of a freighter captain."
                mpy+=240
            end select
            
        endif
    endif
    
    t=t &"|"
    if rnd_range(1,100+mpy)<33 then
        t=t & "You never find a partner to share your life with. Looks like the only love of a captain is his ship." 
    else
        if rnd_range(1,100)<33 then
            t=t & "You have several relationships but nothing serious. Looks like you are not made for lasting romance."
        else
            t=t & "One day you find the love of your life."
            if rnd_range(1,100)<33 then
                t=t &" You don't have children. "
            else
                if rnd_range(1,100)<33 then
                    t=t &" You have children. "
                else
                    t=t &" You have a child."
                endif
            endif
        endif
    endif
    t=t & "|"
    t=t &"|After several years of work it's finally time to retire!|"
    if hasassets>0 then
        pmoney=(player.money+retirementassets(0)*500)/rnd_range(33,44)+retirementassets(1)*250
        if retirementassets(0)>0 then
            if retirementassets(0)=1 then t=t &" |You sell your well going Mud's store and franchise." 'Muds Store
            if retirementassets(0)>1 then t=t &" |You sell your well going Mud's store and franchises." 'Muds Store
        endif
        if retirementassets(1)>0 then
            if retirementassets(1)=1 then t=t &" |Your life insurance finally pays out." 'Life insurance
            if retirementassets(1)>1 then t=t &" |Your life insurances finally pays out." 'Life insurance
        endif
        
        t=t &es_living(pmoney)
        t=t &es_title(pmoney)
        
        if retirementassets(8)>0 then pmoney=pmoney+1000 'Taxing your planet
        mpy=(mpy+pmoney)/2
    endif
    
    if mpy<120 then t=t &" You lead a modest life, with nothing but a small pension and little assets."
    
    if mpy>=120 and mpy<500 then
        t=t &" You lead a life of leasure, you rarely if ever need to take on a job to get through a tight spot."
    endif
    
    if mpy>=500 and mpy<1200 then
        t=t &" You lead a life of leasure, and only work when you want to."
    endif
    
    if mpy>=1200 and mpy<2400 then
        t=t &" You lead a life of leasure and modest luxury."
    endif
    
    if mpy>=2400 and mpy<4800 then
        t=t &" You have enough money to spend the rest of your life in luxury."
    endif
    
    if mpy>=4800 then t=t &" You have more money than you could ever spend."
    
    if player.questflag(3)=2 then
        t=t &" ||During all this time the use of the recovered alien scout ships helps humanity to further reach for the stars. You are near the end of your life as human influence has reached almost every corner of the milkyway galaxy. Finally there are news of a civilization discovered in the magellanic clouds who can equal human prowess in most areas, and even surpass their scientific knowledge in some."
        if rnd_range(1,100)<66 then
            t=t &" ||  Unfortunately the diplomats can't work out a lasting peace. When you lie on your Deathbed the war for the galaxy still rages on, and propably will for many more centuries to come."
        else
            t=t &" ||  Peacefull relations are established quickly, and a joint project is founded: Launching an expedtition to Andromeda! " 
            if rnd_range(1,100)<66 then
                t=t &"|| As you lie on your deathbed you wish you were young enough to join the adventure. But you have led a life, more exciting than most can claim, and the next adventure for you, won't be in space."
            else
                t=t &"|| One day you are approached by the head of the andromeda fleet construction team, and offered a unique position: They want to extract your conciousness, to use in a new sort of bio-electronic computer. Your task will be to guide a ship across the intergalactic void, and command the exploration and colonization efforts."
                if rnd_range(1,100)<66 then
                    t=t & " Immortality is tempting, but you have led a long, and exciting life, and you decide that your next adventure will be your last, and one you will never return from."
                else
                    t=t & " You accept. ||"
                    if rnd_range(1,100)<66 then
                        t=t &" Unfortunately something goes wrong in the extraction process. ||Fortunately you will never know."
                    else
                        t=t &" The next thing you know you take a stroll across the Solar System. You amuse yourself for a second counting the electrons in Saturns lightning storms, take a minute to look for future comets in the Kuiper belt. |Finally you take up your cargo of fragile little human beings, watch every single one of them go into cryo sleep, send your farewells to humanity, aim for Andromeda, and start running! |It is going to be a long time running, but you will occupy yourself by counting the stars in your target, and deciding on which to explore first."
                    endif
                endif
            endif
        endif
    else
        t=t &" | During all this, there are more and more reports of mysterious robot ships attacking explorers, settlers and traders in the sector of space you helped to explore. |Finally the stations are abandoned. |Mankind seems to come to the conclusion that the exploration of space is too dangerous. New expeditions are cancelled, the current holds of humanity fortified. After taking a bloody nose, humans decide to hole up, in case something dangerous is out there. ||And you finally pass on to the next adventure, one you will never return from."
    endif
    t=t &" ||| "&space(_screenx/(_fw2*2)-15)&" T H E  E N D ||"
    return t
end function

function es_living(byref pmoney as single) as string
    dim as string t
    if retirementassets(9)>0 then 
        t=t &" |You finally settle down on your very own planet!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>10000 then t=t &" |There is even enough money to terraform one of it's moons, providing a nice place for weekend vacations."
        return t
    endif
    
    if retirementassets(8)>0 then 
        t=t &" |You finally settle down on your very own planet! It's a bit barren, but it's yours!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>=2500 then t=t &" The place gets a lot nicer after some minor terraforming!"
        return t
    endif
    if retirementassets(7)>0 then
        t=t &" |You finally settle down on your very own - well, dessert, but still - planet!"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>2500 and pmoney<5000 then t=t &" Within a few years you have built a domed settlement on it."
        if pmoney>=5000 then t=t &" The place gets a lot nicer after the terraforming company has done their job!"
        return t
    endif
    if retirementassets(6)>0 then
        t=t &" |You finally settle down on your little planet"
        if pmoney<100 then t=t &" You have to sell some ground to Settlers make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        if pmoney>2500 and pmoney<5000 then t=t &" Within a few years you have built a domed settlement on it."
        if pmoney>=5000 then t=t &" The place gets a lot nicer after the terraforming company has done their job!"
        return t
    endif
    if retirementassets(5)>0 then
        t=t &" |You retire to your terraformed asteroid"
        if pmoney<100 then t=t &" You have to sell some ground to asteroid miners to make ends meet."
        if pmoney>500 then t=t &" Soon you build a nice house on it."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        if pmoney>1200 then t=t &" You also can hire servants for whatever task you do not want to do yourself."
        return t
    endif
    if retirementassets(4)>0 then
        t=t &" |The asteroid base you bought serves you well as a home."
        if pmoney<100 then t=t &" You have to rent some space to asteroid miners to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t'
    endif
    if retirementassets(3)>0 then
        t=t &" |The small asteroid you bought serves as your home." 'Small Asteroid
        if pmoney<100 then t=t &" You have to rent some space to asteroid miners to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t
    endif
    if retirementassets(2)>0 then
        t=t &" |You spend the autumn years of your life in your Country Manor"
        if pmoney<50 then t=t &" You have to rent some rooms to students to make ends meet."
        if pmoney>1000 then t=t &" You are able to equip it with every luxury you could ever dream of."
        return t
    endif
        
end function

function es_title(byref pmoney as single) as string
    dim t as string
    dim landless as short
    dim as short a
    for a=2 to 8
        if retirementassets(a)>0 then landless=landless+a
    next
    if retirementassets(14)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Duke is worth quite a bit even without any assets to go with it. People pay you to show up at their events and give speeches, and want to elect you to high local government positions. "
        if landless>0 and landless<5 then t=t &"|You have power, you have prestige. You are a bit poor for a duke, but few can oppose you."
        if landless>=5 then t=t &"|You are a rich, powerful duke. What you say is law in your community. And that community is pretty large. Nobody can oppose politically or economically"
        pmoney=pmoney+5000*(landless+1)
        return t
    endif
    if retirementassets(13)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Marquese is worth quite a bit even without any assets to go with it. People pay you to show up at their events and give speeches. "
        if landless>0 and landless<5 then t=t &"|Your title of Marquese offers a lot of prestige and power. You cant always back it up with economic might, but you are a political heavyweight in your community"
        if landless>=5 then t=t &"|Only few in your communitiy are more powerfull than you are. You demand taxes, run a policeforce, and have influence on the legeslative process"
        pmoney=pmoney+2500*(landless+1)
    endif
    if retirementassets(12)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Count is worth a bit even without any assets to go with it. It opens doors in politics"
        if landless>0 and landless<5 then t=t &"|You aren't exactly rich for a Count, but still can demand tax money from quite a few people and add your voice to policy making."
        if landless>=5 then t=t &"|You are an important person with considerable fame and wealth. Not a lot goes past you concerning local politics or business."
        pmoney=pmoney+1000*landless+100
    endif
    if retirementassets(11)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a viscount isn't worth much without any assets to go with it. But it opens doors in politics"
        if landless>0 and landless<5 then t=t &"|Your title of viscount opens doors, and your considerable land keeps them open. You make quite a bit of money with taxes"
        if landless>=5 then t=t &"|What you can't do with your title, you can do with your assets. You can collect enough tax money to help building local infrastructure."
        pmoney=pmoney+500*landless+100
        return t
    endif
        
    if retirementassets(10)>0 then
        t=t &""
        if landless=0 then t=t &" |You soon find out the title of a Baron isn't worth much without any assets to go with it."
        if landless>0 and landless<5 then t=t &"|Your title of Baron combined with your meager holdings of real estate allows for a nice additional tax and tarif income."
        if landless>=5 then t=t &"| You are a Baron, you have impressive holdings. You can add tax income to your already impressive assets!"
        pmoney=pmoney+250*landless
    endif
    if retirementassets(9)>0 then 
        t=t &""'adel
        if landless=0 then t=t &" |You soon find out the title of a Lord isn't worth much without any assets to go with it."
        if landless>0 and landless<5 then t=t &"|Your title of Lord and meager holdings allow a tiny tax income."
        if landless>=5 then t=t &"|You are a Lord, you have more than enough land. You are now low nobility, and make a decent penny by taxing."
        pmoney=pmoney+100*landless
    endif
end function
