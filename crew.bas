function captain_perks(slot as short) as short
    dim as short cat,i,j,turret,rask,changeap,changemap,newsm_x,newsm_y,newlaststar,newwormhole
    dim as string text,help
            crew(slot).hpmax=6
            crew(slot).hp=6
            crew(slot).icon="C"
            crew(slot).typ=1
            crew(slot).baseskill(0)=captainskill
            crew(slot).baseskill(1)=captainskill
            crew(slot).baseskill(2)=captainskill
            crew(slot).baseskill(3)=captainskill
            crew(slot).atcost=6
            cat=2
            if equipment_value<1150 then cat+=1
            if player.h_no=2 then cat+=1
            do
                help=""
                if cat>1 then
                    text="Captain("& player.h_sdesc &") "&crew(slot).n & "s talents (" &cat &")"
                else
                    text="Captain("& player.h_sdesc &") " &crew(slot).n & "s talent (" &cat &")"
                endif
                text=text &"/No talent, +100 Cr."
                help=help &"/Start with "& player.money+100 &" Cr. instead of 500||" &list_inventory
                text=text &"/Additional talent, -100 Cr."
                help=help &"/Start with "& player.money-100 &" Cr. instead of 500. Choose one more starting talent||"&list_inventory
                text=text &"/2 Spacesuits"
                help=help &"/Start with 2 standard issue spacesuits||"&list_inventory
                text=text &"/Tribble"
                help=help &"/Start with a pet tribble||"&list_inventory
                text=text &"/Additional random items"
                help=help &"/Start with two more random items||"&list_inventory
                text=text &"/Energy weapon"
                if startingweapon=1 then text=text &"(x)"
                help=help &"/Start with an energy weapon for your ship.|(If you change your mind just select this option again)||"&list_inventory
                if startingweapon=1 then help=help &"|currently selected"
                text=text &"/Missile weapon"
                if startingweapon=2 then text=text &"(x)"
                if startingweapon=2 then help=help &"|currently selected"
                help=help &"/Start with a missile weapon for your ship.|(If you change your mind just select this option again)||"&list_inventory
                if player.cursed=0 then
                    text=text &"/Junk ship"
                    help=help &"/Your starting ship is in need of an overhaul. +1 points||"&list_inventory
                else
                    text=text &"/Decent ship"
                    help=help &"/Your starting ship is in good condition.||"&list_inventory
                endif
                for i=1 to 6
                    text=text &"/"&talent_desig(i)&"("&crew(slot).talents(i)&")"
                    help=help &"/"&talent_desc(i)&"|(2 pts.)||"&list_inventory
                    'help=help &"Ship:"&player.h_sdesc

                next
                for i=20 to 26
                    text=text &"/"&talent_desig(i)&"("&crew(slot).talents(i)&")"
                    help=help &"/"&talent_desc(i)&"|(2 pts.)||"&list_inventory
                    'help=help &"Ship:"&player.h_sdesc
                next
                turret=-2
                rask=22
                changeap=23
                if player.h_no=2 then
                    turret=22
                    rask=23
                    changeap=24                    
                    text=text &"/Additional module(3 pts.)"
                    help=help &"/Pay 3 pts for a module for your fighter ship."
                endif
                changemap=changeap+1
                text=text &"/Random"
                help=help &"/Choose one talent at random (1 pt.)"
                text=text &"/Change captain details"
                help=help &"/Change the appearance and bio details of your captain"
                text=text &"/Change mapsize"
                help=help &"/Mapsize:|Area: "&sm_x &"x"&sm_y &"|Stars: "&laststar &"|Wormholes: "&wormhole
                i=menu(bg_randompictxt,text,help,,,1)
                if i=rask then
                    do
                        i=rnd_range(9,rask-1)
                        j=i-7
                        if j>6 then j+=13
                    loop until crew(1).talents(j)<=3
                    cat+=1
                endif
                select case i
                case 1,-1
                    addmoney(100,mt_startcash)
                    cat-=1
                    dprint "Additional money: +100 Cr."
                case 2
                    if player.money>=100 then
                        addmoney(-100,mt_startcash)
                        cat+=1
                        dprint "Less money: -100 Cr."
                    endif
                case 3
                    cat-=1
                    for j=1 to 2
                        placeitem(make_item(320),0,0,0,0,-1)
                    next
                    dprint "Item: 2 Spacesuits"
                case 4
                    placeitem(make_item(250),0,0,0,0,-1)
                    cat-=1
                    dprint "Item: A tribble"
                case 5
                    for j=1 to 2
                        if rnd_range(1,100)<50 then
                            item(lastitem+1)=rnd_item(RI_WeakStuff)
                        else
                            item(lastitem+1)=rnd_item(RI_WeakWeapons)
                        endif

                        dprint "Item: "&add_a_or_an(item(lastitem+1).desig,1)
                        placeitem(item(lastitem+1),0,0,0,0,-1)
                        item(lastitem+1)=item(lastitem+2)
                    next
                    cat-=1
                case 6
                    select case startingweapon
                    case 0
                        startingweapon=1
                        cat-=1
                    case 1
                        startingweapon=0
                        cat+=1
                    case 2
                        startingweapon=1
                    end select
                    dprint "Guaranteed energy weapon"
                case 7
                    select case startingweapon
                    case 0
                        startingweapon=2
                        cat-=1
                    case 1
                        startingweapon=2
                    case 2
                        startingweapon=0
                        cat+=1
                    end select
                    dprint "Guaranteed missile weapon"
                case 8
                    if player.cursed=1 then
                        cat-=1
                        player.cursed=0
                        Dprint "Your ship is in decent condition"
                    else
                        cat+=1
                        player.cursed=1
                        dprint "Your ship is in need of repair and servicing"
                    endif
                case turret
                    
                    if cat>=3 then
                        player.weapons(2)=starting_turret
                        if player.weapons(2).made<>0 then cat-=3
                    endif
                case changeap
                    change_captain_appearance(20,2)
                case changemap
                    dprint "X:"
                    newsm_x=getnumber(50,255,75)
                    dprint "Y:"
                    newsm_y=getnumber(50,255,50)
                    dprint "Number of stars:"
                    newlaststar=getnumber(50,150,80)
                    dprint "Number of wormholes:"
                    newwormhole=getnumber(2,20,8)
                    if newsm_x<>sm_x or newsm_y<>sm_y then
                        sm_x=newsm_x
                        sm_y=newsm_y
                        redim spacemap(sm_x,sm_y) as short
                        redim vismask(sm_x,sm_y) as byte
                    endif
                    if newlaststar<>laststar or newwormhole<>wormhole then
                        laststar=newlaststar
                        if newwormhole mod 2 <>0 then newwormhole+=1
                        wormhole=newwormhole
                        redim map(laststar+wormhole+1) as _stars
                    endif
                case else
                    if cat>=2 then 
                        j=i-8
    
                        if j>6 then j+=13
                        if crew(slot).talents(j)<3 then
                            dprint gain_talent(slot,j)
                            cat-=2
                        endif
                    endif
                end select

            loop until cat=0
            return 0

    return 0
end function

function gainxp(typ as short,v as short=1) as string
    dim as short a,lowest,slot
    lowest=5000
    if typ>0 then
        for a=0 to 128
            if crew(a).typ=typ and crew(a).hp>0 then
                if crew(a).xp<lowest then
                    slot=a
                    lowest=crew(a).xp
                endif
            endif
        next
    else
        slot=v
    endif
    if crew(slot).hp>0 and crew(slot).xp>=0 then
        crew(slot).xp+=1
        return crew_desig(crew(slot).typ) &" " &crew(slot).n &" has gained 1 Xp."
    endif
    return ""
end function

function skill_test(bonus as short,targetnumber as short,echo as string="") as short
    dim as short roll
    roll=rnd_range(1,20)
    if roll+bonus>=targetnumber then
            if echo<>"" and configflag(con_showrolls)=0 then 
                if bonus>0 then dprint echo &" needed "& targetnumber &", rolled "&roll &"+"& bonus &": Success.",c_gre
                if bonus=0 then dprint echo &" needed "& targetnumber &", rolled "&roll &": Success.",c_gre
                if bonus<0 then dprint echo &" needed "& targetnumber &", rolled "&roll & bonus &": Success.",c_gre
            endif
        return -1
    else
        if echo<>"" and configflag(con_showrolls)=0 then 
            if bonus>0 then dprint echo &" needed "& targetnumber &", rolled "&roll &"+"& bonus &": Failure.",c_red
            if bonus<0 then dprint echo &" needed "& targetnumber &", rolled "&roll & bonus &": Failure.",c_red
            if bonus=0 then dprint echo &" needed "& targetnumber &", rolled "&roll &": Failure.",c_red
        endif
        return 0
    end if
end function



function haggle_(way as string) as single
    if lcase(way)="up" then return (1+crew(1).talents(2)/10)
    if lcase(way)="down" then return (1-crew(1).talents(2)/10)
end function

function can_learn_skill(ci as short,si as short) as short
    if crew(ci).typ=18 then return 0
    if (crew(ci).typ<=8 or (crew(ci).typ>=14)) and si>16 and si<=26 then return -1
    select case crew(ci).typ
    case is=1 'Captain
        if si>=1 and si<=6 then return -1
    case is=2 'Gunny
        if si>6 and si<=9 then return -1
    case is=3 'Pilot
        if si>9 and si<=13 then return -1
    case is=4 'SO
        if si>13 and si<=16 then return -1
    case is=5 'Doctor
        if si>16 and si<=19 then return -1
    end select
    return 0
end function


function best_crew(skill as short, no as short) as short
    dim as short i,j,result,last
    dim skillvals(128) as short
    for i=0 to 128
        if crew(i).baseskill(skill)>0 and crew(i).hp>0 and (crew(i).onship=location or location=lc_onship) then
            j+=1
            skillvals(j)=crew(i).baseskill(skill)
        endif
    next
    last=j
    if last=0 then return crew(1).baseskill(skill) 'Captain takes place if nobody else does
    do
        j=0
        for i=1 to last
            if skillvals(i)<skillvals(i+1) then
                j=1
                swap skillvals(i),skillvals(i+1)
            endif
        next
    loop until j=0
    if no>last then no=last
    for i=1 to no
        result=result+skillvals(i)/i
    next

    return result
end function

function cure_awayteam(where as short) as short
    dim as short bonus,pack,cured,sick,a,biodata
    dim as string text
    for a=0 to 128
        if crew(a).hp>0 and crew(a).disease>0 then sick+=1
    next
    if sick=0 then return 0
    sick=0
    if where=0 then 'On planet=0 On Ship=1
        if configflag(con_chosebest)=0 then
            pack=findbest(19,-1)
        else
            pack=get_item(-1,19)
            if pack>0 then
                if item(pack).ty<>19 then
                    dprint "You can't use that",14
                    pack=-1
                endif
            endif
        endif
        if pack>0 then
            dprint "Using "&item(pack).desig &".",10
            bonus=item(pack).v1
            destroyitem(pack)
        else
            bonus=-3
        endif
    else
        bonus=findbest(21,-1)+3
    endif

    for a=0 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and (crew(a).onship=where or where=1) then
            if crew(a).disease>0 then
                if skill_test(bonus+player.doctor(location)+add_talent(5,17,1),st_average+crew(a).disease/2,"Doctor") then
                    biodata+=crew(a).disease*2
                    crew(a).disease=0
                    crew(a).onship=crew(a).oldonship
                    crew(a).oldonship=0
                    cured+=1
                endif
            endif
            if crew(a).disease>0 then sick+=1
        endif
    next
    reward(1)+=biodata 'Cured a disease
    if crew(1).disease=0 then crew(1).onship=0
    if cured>1 then dprint cured &" members of your crew where cured (gained "& biodata &" biodata).",10
    if cured=1 then dprint cured &" member of your crew was cured (gained "& biodata &" biodata).",10
    if cured=0 and sick>0 then dprint "No members of your crew where cured.",14
    if sick>0 then dprint sick &" are still sick.",14
    if cured>0 then dprint gainxp(5),c_gre
    return 0
end function

function max_security() as short
    dim as short b,total
    total=2*(player.h_maxcrew-5)+2*player.crewpod+player.cryo
    for b=6 to 128
        if crew(b).hp>0 then total-=1
    next
    return total
end function

function total_bunks() as short
    return player.h_maxcrew+player.crewpod+player.cryo-5
end function

function add_talent(cr as short, ta as short, value as single) as single
    dim total as short
    if cr>=0 then
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 and ta=10 then
            if player.tactic>0 then return crew(cr).talents(ta)
            if player.tactic<0 then return -crew(cr).talents(ta)
            return 0
        endif
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 then return value*crew(cr).talents(ta)
    else
        value=0
        for cr=1 to 128
            if crew(cr).hp>0 and crew(cr).onship=0 then
                total+=1
                value=value+crew(cr).talents(ta)
                if ta=24 then value=value+crew(cr).augment(4) 'Speed
            endif
        next
        if total=0 then return 0
        value=value/total
        return value
    endif
    return 0
end function

function changemoral(value as short, where as short) as short
    dim as short a,tribbles
    for a=0 to lastitem
        if item(a).ty=80 and item(a).w.s<0 then
            tribbles+=1
            if rnd_range(1,100)>=99 and rnd_range(1,100)>=99 then
                dprint "Someone overfed a tribble."
                placeitem(make_item(250),,,,,-1)
            endif
        endif
    next
    if value<0 then value=value*bunk_multi
    if value>0 then value=value/bunk_multi
    for a=2 to 128
        if crew(a).hp>0 and crew(a).onship=where and crew(a).equips>-1 then
            crew(a).morale=crew(a).morale+value
            if tribbles>0 then
                tribbles-=1
                crew(a).morale+=1
            endif
        endif
    next
    if tribbles>0 then unattendedtribbles=tribbles
    return 0
end function

function heal_awayteam(byref a as _monster,heal as short) as short
    dim as short b,c,ex,fac,h
    static reg as single
    static doc as single
    for b=1 to a.hpmax
        if crew(b).hp>0 and crew(b).hp<crew(b).hpmax then ex=ex+1
        diseaserun(b)
        if crew(b).hp>0 and crew(b).onship=0 then doc+=crew(b).talents(29)/50 'Paramedics
    next
    fac=findbest(24,-1)

    if fac>0 then
        if item(fac).v1>0 then reg=reg+0.1
    endif
    if player.doctor(1)>0 then
       doc=doc+player.doctor(1)/25+add_talent(5,17,.1)
    endif
    if heal>0 then heal=heal+player.doctor(1)+add_talent(5,19,3)
    if reg>=1 then
        heal=heal+reg
        reg=0
        h=1
    endif
    if doc>=1 then
        if skill_test(player.doctor(1),st_hard) then
            heal=heal+doc
            h=1
        endif
        doc=0
    endif
    do
        ex=0
        for b=1 to 128
            if heal>0 and crew(b).hp<crew(b).hpmax and crew(b).hp>0 then
                heal=heal-1
                if h=1 then h=2
                crew(b).hp=crew(b).hp+1
                ex=ex+1
            endif
        next
    loop until heal=0 or ex=0
    if player.doctor(1)>0 and h=2 then
        dprint "The doctor fixes some cuts and bruises"
        dprint gainxp(5),c_gre
    endif
    if fac>0 and h=2 then
        dprint "the nanobots heal your wounded"
        item(fac).v1=item(fac).v1-1
    endif
    hpdisplay(a)
    return heal
end function

function infect(a as short,dis as short) as short
    dim as short roll
    roll=rnd_range(1,6) +rnd_range(1,6)+player.doctor(location)
    if roll<maximum(3,dis) and crew(a).hp>0 and crew(a).hpmax>0 then
        crew(a).disease=dis
        crew(a).oldonship=crew(a).onship
        crew(a).duration=disease(dis).duration
        crew(a).incubation=disease(dis).incubation
        if dis>player.disease then player.disease=dis
    endif
    return 0
end function

function diseaserun(onship as short) as short
    dim as short a,b,dam,total,affected,dis,distotal
    dim text as string
    for a=2 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and crew(a).disease>0 then
            if crew(a).incubation>0 then
                crew(a).incubation-=1
            else
                if crew(a).duration>0 then
                    crew(a).duration-=1
                    if rnd_range(1,100)<disease(crew(a).disease).contagio then
                        b=rnd_crewmember
                        if crew(a).onship=crew(b).onship and a<>b then
                            crew(b).disease=crew(a).disease
                            crew(b).oldonship=crew(b).onship
                            crew(b).duration=disease(crew(a).disease).duration
                            crew(b).incubation=disease(crew(a).disease).incubation
                        endif
                    endif
                    if crew(a).duration=0 then
                        crew(a).disease=0
                        if rnd_range(1,100)+player.doctor(0)*5<disease(crew(a).disease).fatality then
                            if crew(a).onship=onship then dprint crew(a).n &" dies from disease.",12
                            crew(a)=crew(0)
                            crew(a).disease=0

                        else
                            if crew(a).onship=onship then dprint crew(a).n &" recovers.",10
                            crew(a).onship=crew(a).oldonship
                            crew(a).disease=0
                        endif
                    endif
                endif
            endif
        endif
        if crew(a).disease>dis then dis=crew(a).disease
    next
    player.disease=dis
    return 0
end function

function dam_awayteam_list(target() as short, stored() as short, ap as short, all as short) as short
    dim as short b,last
    awayteam.hp=0
    if ap=5 then
        last=no_spacesuit(target()) 'Don't need the b
        for b=1 to last
            stored(b)=crew(target(b)).hp
        next
    else
        for b=1 to 128
            if all=2 then
                if crew(b).hpmax>0 and crew(b).typ>1 and crew(b).typ<=5 then
                    last+=1
                    target(last)=b
                    stored(b)=crew(b).hp
                endif
            else                
                if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).equips>-1 and (all=1 or crew(b).onship=0)) then
                    awayteam.hp+=1
                    last+=1
                    target(last)=b
                    stored(b)=crew(b).hp
                endif
            endif
        next
    endif
    if last>128 then last=128
    return last
end function 

function dam_awayteam(dam as short, ap as short=0,disease as short=0,all as short=0) as string
    dim text as string
    dim as short ex,b,t,last,last2,armeff,reequip,roll,cc,tacbonus,suitdamage,dealtdam
    dim as short local_debug=0
    dim target(128) as short
    dim stored(128) as short
    dim injured(16) as short
    dim killed(16) as short
    dim desc(16) as string
    desc(1)="Captain"
    desc(2)="Pilot"
    desc(3)="Gunner"
    desc(4)="Science officer"
    desc(5)="Ships doctor"
    desc(6)="Sec. member"
    desc(7)="Sec. member"
    desc(8)="Sec. member"
    desc(9)="Insect warrior"
    desc(10)="Cephalopod"
    desc(11)="Neodog"
    desc(12)="Neoape"
    desc(13)="Robot"
    desc(14)="Squad Leader"
    desc(15)="Sniper"
    desc(16)="Paramedic"
    'ap=1 Ignores Armor
    'ap=2 All on one, carries over
    'ap=3 All on one, no carrying over
    'ap=4 Ignores Armor, Robots immune
    'ap=5 No Spacesuits
    if local_debug=1 then text=text & "in:"&dam

    if abs(player.tactic)=2 then dam=dam-player.tactic
    if dam<0 then dam=1
    
    last=dam_awayteam_list(target(),stored(),ap,all)
    
    cc=0
    do
        cc+=1
        t=rnd_range(1,last)
        if crew(target(t)).hp>0 then
            if ap=5 then
                dam-=1
                crew(target(t)).hp-=1
                dealtdam+=1
            endif
            if ap=2 then
                dam=dam-crew(target(t)).hp
                dealtdam=crew(target(t)).hp
                crew(target(t)).hp=dam
            endif
            if ap=3 then
                crew(target(t)).hp=crew(target(t)).hp-dam
                dealtdam=dam
                dam=0
            endif
            if ap=0 or ap=1 or ap=4 then
                if player.tactic=3 then 'No tactic bonus for using nonlethal
                    tacbonus=0
                else
                    tacbonus=player.tactic
                endif
                roll=rnd_range(1,25)
                if local_debug=1 and _debug=1 then text=text &":" &roll &":"&awayteam.secarmo(target(t))+crew(target(t)).augment(5)+player.tactic+add_talent(3,10,1)+add_talent(t,20,1)
                if roll>2+awayteam.secarmo(target(t))+crew(target(t)).augment(5)+tacbonus+add_talent(3,10,1)+add_talent(t,20,1) or ap=4 or ap=1 or roll=25 then
                    if not(crew(target(t)).typ=13 and ap=4) then crew(target(t)).hp=crew(target(t)).hp-1
                    dam=dam-1
                    dealtdam+=1
                else
                    armeff+=1
                endif
                if crew(target(t)).armo>0 and ap<>1 and ap<>4 then
                    if item(crew(target(t)).armo).ti_no<2019 then 
                        if item(crew(target(t)).armo).v4=0 then item(crew(target(t)).armo).id+=2000
                        item(crew(target(t)).armo).v4+=1
                        suitdamage+=1
                    endif
                endif
            endif
        endif
        
        last=dam_awayteam_list(target(),stored(),ap,0)
    
    loop until dam<=0 or ex=1 or cc>9999 or last=0
    dam=0
    for b=1 to 128
        if crew(b).onship=0 and crew(b).hpmax>0 then
            if stored(b)>crew(b).hp then
                if crew(b).hp<=0 then
                    killed(crew(b).typ)+=1
                    reequip=1
                else
                    injured(crew(b).typ)+=1
                endif
            endif
        endif
    next
    
    if dealtdam>0 then text=text & "Caused "&dealtdam &" points of damage."
    if armeff>0 then text=text &armeff &" prevented by armor. "
    for b=1 to 16
        if injured(b)>0 then
            walking=0
            if injured(b)>1 then
                text=text &injured(b) &" "&desc(b)&"s injured. "
            else
                text=text &desc(b)&" injured. "
            endif
        endif
    next
    for b=1 to 16
        player.deadredshirts=player.deadredshirts+killed(b)
        if killed(b)>0 then
            walking=0
            if killed(b)>1 then
                text=text &killed(b) &" "&desc(b)&"s killed. "
            else
                text=text &desc(b)&" killed. "
            endif
            changemoral(-3*killed(b),0)
        endif
    next
    if suitdamage>0 then text=text &suitdamage &" damage to spacesuits."
    awayteam.leak+=suitdamage
    if awayteam.leak>5 then awayteam.leak=5
    #ifdef _FMODSOUND
    if configflag(con_damscream)=0 then
        FSOUND_PlaySound(FSOUND_FREE, sound(12))
        sleep 100
    endif
    #endif
    #ifdef _FBSOUND
    if configflag(con_damscream)=0 then
        fbs_Play_Wave(sound(12))
        sleep 100
    endif
    #endif
    sleep 25

    if reequip=1 then 
        sort_crew
        equip_awayteam(player.map)
    endif
    if local_debug=1 then text=text & " Out:"&dam
    return trim(text)
end function

function repair_spacesuits() as short
    dim c as short
    c=findbest(51,-1)
    if c>0 then
        If configflag(con_chosebest)=0 Then
            c=findbest(51,-1)
        Else
            c=get_item(51)
        EndIf
        if c>0 then
            if askyn("Do you want to use your "&item(c).desig &" to plug holes in your spacesuit?") then
                item(c).v1=repair_spacesuit(item(c).v1)
            endif
        endif
    endif
    return 0
end function


function repair_spacesuit(v as short=-1) as short
    dim as short b,i,c
    for b=1 to 128
        if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
            if crew(b).armo>0 then
                i=crew(b).armo
                if (v=-1 or v>0) and item(i).v4>0 then 
                    awayteam.leak-=item(i).v4
                    item(i).v4=0
                    item(i).id-=2000
                    if v>0 then v-=1
                    c+=1
                endif
            endif
        endif
    next
    if c=1 then dprint "Repaired a spacesuit."
    if c>1 then dprint "Repaired " &c & " spacesuits."
    return v
end function

function gain_talent(slot as short,talent as short=0) as string
    dim text as string
    dim as short roll,roll2
    ' roll for talent
    if talent=0 then
        roll=rnd_range(1,25)
    else
        roll=talent
    endif
    ' check if can have it
    if can_learn_skill(slot,roll) then
        if crew(slot).talents(roll)<3 or roll=1 then
            crew(slot).talents(roll)+=1
            select case roll
            case 1'Competent
                roll2=rnd_range(0,3)
                if crew(slot).baseskill(roll2)=-5 then
                    crew(slot).baseskill(roll2)=1
                else
                    crew(slot).baseskill(roll2)+=1
                endif
                text=text &crew(slot).n &" is now competent("
                select case roll2
                case 0
                    text=text &"Piloting:"& crew(slot).baseskill(0) &")"
                case 1
                    text=text &"Gunnery:"& crew(slot).baseskill(1) &")"
                case 2
                    text=text &"Science:"& crew(slot).baseskill(2) &")"
                case 3
                    text=text &"Doctor:"&  crew(slot).baseskill(3) &")"
                end select
            case 20 'Tough
                crew(slot).hpmax+=1
                crew(slot).hp+=1
                text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
            case else
                text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
            end select    
        endif
    endif
    return text
end function


function levelup(p as _ship,from as short) as _ship
    dim a as short
    dim text as string
    dim roll as short
    dim secret as short
    dim target as short
    dim _del as _crewmember
    dim rolls(128) as short
    dim lev(128) as byte
    dim ret(46) as byte
    dim conret(46) as byte
    dim levt(46) as byte
    dim debug as byte=0
    if from=1 then dprint "Entering training."
    for a=0 to 16
        levt(a)=0
        ret(a)=0
    next
    for a=1 to 128
        lev(a)=0
        if _showrolls=1 or debug=1 then crew(a).xp+=10
        if crew(a).hp>0 and ((crew(a).typ>0 and crew(a).typ<8) or (crew(a).typ>=14 and crew(a).typ<=16)) then
            roll=rnd_range(1,crew(a).xp)
            if crew(a).xp>0 and (roll+crew(a).augment(10)*2>5+crew(a).hp^2 or debug=1) then
                lev(a)+=1
                rolls(a)=crew(a).augment(10)*2+roll
            endif
            if from=0 then
                if a>1 then
                    if crew(a).hp>0 and crew(a).augment(11)=0 then
                        roll=rnd_range(1,100)
                        if roll>10+crew(a).morale+add_talent(1,4,10) then
                            if crew(a).story(3)=1 and crew(a).morale<60 then
                                ret(crew(a).typ)+=1
                                crew(a)=_del
                                lev(a)=0
                            else
                                crew(a).morale=crew(a).morale-10+add_talent(1,4,5)
                                crew(a).story(3)=1
                                conret(crew(a).typ)+=1
                            endif
                        endif
                    endif
                endif
            endif
        endif
    next

    for a=1 to 46
        if ret(a)=1 then dprint crew_desig(a)&" "&crew(a).n &" retired. ",12
        if ret(a)>1 then dprint ret(a) &" "&crew_desig(a)&"s retired. ",12
        if conret(a)=1 then dprint crew_desig(a)&" "&crew(a).n &" considered retiring but had a change of mind. ",14
        if conret(a)>1 then dprint ret(a) &" "&crew_desig(a)&"s considered retiring but changed their minds. ",14
        if ret(a)=1 and a>=30 then dprint "Your passenger " &crew(a).n & "decided to find another ship."
        if ret(a)>1 and a>=30 then dprint a &" of your passengers decided to find another ship."
    next
    for a=1 to 128
        if _showrolls=1 then text=text &crew(a).n &"Rolled "&rolls(a) &", needed"& 5+crew(a).hp^2

        if crew(a).hp>0 and lev(a)=1 then
            levt(crew(a).typ)+=1
            select case crew(a).typ
            case 1
                if crew(a).talents(1)>0 then
                    if crew(a).baseskill(0)>0 then crew(a).baseskill(0)+=1
                    if crew(a).baseskill(1)>0 then crew(a).baseskill(1)+=1
                    if crew(a).baseskill(2)>0 then crew(a).baseskill(2)+=1
                    if crew(a).baseskill(3)>0 then crew(a).baseskill(3)+=1
                else
                    crew(a).baseskill(rnd_range(0,3))+=1
                endif
            case 2 to 5
                crew(a).baseskill(crew(a).typ-2)+=1
            case 6,7
                crew(a).typ+=1
                if rnd_range(1,100)<crew(a).xp*3 then text=text &gain_talent(a)
            end select
            crew(a).hpmax+=1
            crew(a).hp=crew(a).hpmax
            crew(a).xp=0

        endif
    next
    for a=1 to 16
        if levt(a)=1 then text=text &crew_desig(a)&" "&crew(find_crew_type(a)).n &" got promoted. "
        if levt(a)>1 then text=text & levt(a) &" "&crew_desig(a)&"s got promoted. "
    next
    if text<>"" then dprint text,10
    if text="" and from=1 then dprint "Nobody got a promotion."
    display_ship()
    return p
end function

function find_crew_type(t as short) as short
    dim a as short
    for a=1 to 127
        if crew(a).typ=t then return a
    next
    return 1
end function

function no_spacesuit(who() as short,byref alle as short=0) as short
    dim as short i,last
    alle=1
    for i=1 to 128
        if crew(i).hp>0 then
            if crew(i).onship=0 then awayteam.hp+=1
            if crew(i).onship=0 and crew(i).armo=0 and crew(i).equips=0 and crew(i).typ<>13 then
                last+=1
                who(last)=i
            else
                alle=0 'At least one crewmember has a spacesuit or doesn't need one(Is a robot)
            endif
        endif
    next
    return last
end function

function remove_no_spacesuit(who() as short,last as short) as short
    dim as short i
    for i=1 to last
        crew(who(i)).oldonship=crew(who(i)).onship
        crew(who(i)).onship=4
    next
    return 0
end function

function remove_member(n as short, f as short) as short
    dim as short a,s,todo

    if f=0 then s=6
    if f=1 then s=2
    for a=128 to s step-1
        if crew(a).hp>0 and todo<n then
            crew(a).hp=0
            todo+=1
        endif
    next
    return 0
end function

function rnd_crewmember(onship as short=0) as short
    dim pot(128) as short
    dim as short p,a
    for a=0 to 128
        if crew(a).hp>0 and crew(a).equips>-1 and crew(a).onship=onship then
            p+=1
            pot(p)=a
        endif
    next
    return pot(rnd_range(1,p))
end function

function get_freecrewslot() as short
    dim as short b,slot,debug,max
    max=(player.h_maxcrew+player.crewpod)*player.bunking+player.cryo
    for b=1 to 128
        if crew(b).equips<0 then max+=1
    next
    if debug=1 and _debug=1 then dprint ""&player.h_maxcrew &":"&player.crewpod &":"&player.cryo
    for b=1 to max
        if crew(b).hp<=0 then return b
    next
    Dprint "No room on the ship.",c_yel
    if player.bunking=1 then
        if askyn("Do you want to doublebunk?(y/n)") then
            player.bunking=2
            return get_freecrewslot()
        endif
    endif
    if slot<0 then
        if askyn("Do you want to replace someone?(y/n)") then
            return showteam(0,1,"Replace who?")
        endif
    endif
    return -1
end function

function bunk_multi() as single
    dim as short b,here,max
    max=(player.h_maxcrew+player.crewpod)+player.cryo
    for b=1 to 128
        if crew(b).hp>0 and crew(b).equips<>-1 then here+=1
    next
    if here<=max then
        player.bunking=1
        return 1
    else
        return 1+here/(max*3)
    endif
end function


function add_member(a as short,skill as short) as short
    dim as short slot,b,f,c,cc,debug,nameno,i,j
    dim as string text,help
    dim _del as _crewmember
    dim as string n(200,1)
    dim as short ln(1)
    
    'find empty slot
    slot=get_freecrewslot
    
    if debug=1 and _debug=1 then dprint ""&slot
    if slot<0 then return -1
    if slot>=0 then
        
        f=freefile
        open "data/crewnames.txt" for input as #f
        do
            ln(cc)+=1
            line input #f,n(ln(cc),cc)
            if n(ln(cc),cc)="####" then
                ln(0)-=1
                cc=1
            endif
    
        loop until eof(f) or ln(0)>=199 or ln(1)>=199
        close #f
        
        crew(slot)=_del
        crew(slot).baseskill(0)=-5
        crew(slot).baseskill(1)=-5
        crew(slot).baseskill(2)=-5
        crew(slot).baseskill(3)=-5
        for b=0 to 10
            crew(slot).story(b)=rnd_range(1,10)
        next
        'crew(slot).story(9)=rnd_range(1,3)
        crew(slot).story(3)=configflag(con_captainsprite)
        crew(slot).story(10)=rnd_range(0,1)
        crew(slot).n=character_name(crew(slot).story(10)) '0 female 1 male
'        nameno=(rnd_range(1,ln(1)))
'        if nameno<=23 then
'            'female
'            crew(slot).story(10)=0
'        else
'            'male
'            crew(slot).story(10)=1
'        endif
'
'        if rnd_range(1,100)<80 then
'            crew(slot).n=n(nameno,1)&" "&n((rnd_range(1,ln(0))),0)
'        else
'            crew(slot).n=n(nameno,1)&" "&CHR(rnd_range(65,87))&". "&n((rnd_range(1,ln(0))),0)
'        endif
        crew(slot).morale=100+(Wage-10)^3*(5/100)
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).disease=rnd_range(1,17)

        if a=1 then 'captain
            captain_perks(slot)
        endif
        if a=2 then 'Pilot
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="P"
            crew(slot).typ=2
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(0)=skill
            crew(slot).atcost=8-skill
        endif
        if a=3 then 'Gunner
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="G"
            crew(slot).typ=3
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(1)=skill
            crew(slot).atcost=5-skill
        endif
        if a=4 then 'SO
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="S"
            crew(slot).typ=4
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(2)=skill
            crew(slot).atcost=8-skill
        endif

        if a=5 then 'doctor
            crew(slot).hpmax=skill+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="D"
            crew(slot).typ=5
            crew(slot).paymod=skill^2*10
            crew(slot).baseskill(3)=skill
            crew(slot).atcost=8-skill
        endif

        if a=6 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=6
            crew(slot).paymod=10
            crew(slot).atcost=7
            'crew(slot).disease=rnd_range(1,16)
        endif

        if a=7 then 'vet
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=7
            crew(slot).paymod=10
            crew(slot).atcost=6
        endif

        if a=8 then 'elite
            crew(slot).hpmax=4
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=8
            crew(slot).paymod=10
            crew(slot).atcost=5
        endif

        if a=9 then 'insect warrior
            crew(slot).hpmax=5
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="I"
            crew(slot).typ=9
            crew(slot).paymod=10
            crew(slot).n=ucase(chr(rnd_range(97,122)))
            crew(slot).xp=-1
            for c=0 to rnd_range(1,6)+3
                crew(slot).n=crew(slot).n &chr(rnd_range(97,122))
            next
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=4
        endif

        if a=10 then 'cephalopod
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="Q"
            crew(slot).typ=10
            crew(slot).paymod=0
            crew(slot).xp=-1
            crew(slot).n=alienname(2)
            crew(slot).morale=25000
            crew(slot).augment(7)=1
            crew(slot).story(10)=2
            crew(slot).equips=2'Can use weapons and squidsuit
            if rnd_range(1,100)<15 then placeitem(make_item(123),0,0,0,0,-1)
            crew(slot).atcost=5
        endif

        if a=11 then
            crew(slot).equips=1
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="d"
            crew(slot).typ=11
            crew(slot).paymod=0
            crew(slot).n="Neodog"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=5
        endif

        if a=12 then
            crew(slot).equips=0
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="a"
            crew(slot).typ=12
            crew(slot).paymod=0
            crew(slot).n="Neoape"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).story(10)=2
            crew(slot).atcost=4
        endif

        if a=13 then
            crew(slot).equips=1
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="R"
            crew(slot).typ=13
            crew(slot).paymod=0
            crew(slot).n="Robot"
            crew(slot).xp=-1
            crew(slot).morale=25000
            crew(slot).augment(8)=1
            crew(slot).story(10)=2
            crew(slot).atcost=3
        endif

        if a=14 then 'SO
            crew(slot).hpmax=4
            crew(slot).hp=4
            crew(slot).hp=crew(4).hpmax
            crew(slot).icon="T"
            crew(slot).typ=17
            crew(slot).paymod=0
            crew(slot).n=alienname(1)
            crew(slot).xp=0
            crew(slot).disease=0
            crew(slot).baseskill(2)=3
            crew(slot).story(10)=2
            crew(slot).atcost=9
        endif

        if a=15 then
            crew(slot).typ=5
            crew(slot).icon="D"
            crew(slot).paymod=1
            crew(slot).hpmax=7
            crew(slot).hp=7
            crew(slot).n="Ted Rofes"
            crew(slot).xp=0
            crew(slot).baseskill(3)=6
            crew(slot).story(10)=1
            crew(slot).atcost=20
            crew(slot).story(0)=2
        endif


        if a=16 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="L"
            crew(slot).typ=14
            crew(slot).talents(27)=1
            crew(slot).paymod=25
            crew(slot).atcost=4
        endif

        if a=17 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="N"
            crew(slot).typ=15
            crew(slot).talents(28)=1
            crew(slot).paymod=25
            crew(slot).atcost=12
        endif

        if a=18 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="M"
            crew(slot).typ=16
            crew(slot).talents(29)=1
            crew(slot).paymod=20
            crew(slot).atcost=6
        endif
        
        
        if a=19 then 'squatter
            crew(slot).hpmax=1   
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=6
            crew(slot).paymod=5
            crew(slot).atcost=8
            crew(slot).morale=150
            'crew(slot).disease=rnd_range(1,16)
        endif
        
        if a=20 or a=21 or a=22 or a=23 or a=24 then
            crew(slot).typ=18
            crew(slot).hpmax=1
            crew(slot).icon="A"
            crew(slot).paymod=0
            crew(slot).equips=-1
            crew(slot).morale=200
            if a=20 then crew(slot).n="Piloting"
            if a=21 then crew(slot).n="Gunner"
            if a=22 then crew(slot).n="Science"
            if a=23 then crew(slot).n="Medical"
            if a=20 then crew(slot).baseskill(0)=7
            if a=21 then crew(slot).baseskill(1)=7
            if a=22 then crew(slot).baseskill(2)=7
            if a=23 then crew(slot).baseskill(3)=7
            if a=24 then
                crew(slot).n="General"
                crew(slot).baseskill(0)=7
                crew(slot).baseskill(1)=7
                crew(slot).baseskill(2)=7
                crew(slot).baseskill(3)=7
            endif
        endif
            
        
        crew(slot).hp=crew(slot).hpmax
        if crew(slot).story(10)<2 then 'Is human
            crew(slot).story(9)=-1
            if slot>1 and rnd_range(1,100)<15 then crew(slot).story(9)=rnd_range(1,3) 'Girfriend
        endif
        'crew(slot).morale=rnd_range(1,5)
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gain_talent(slot)
        'if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
        if crew(slot).atcost<=0 then crew(slot).atcost=1
    endif
    sort_crew()
    return 0
end function

function girlfriends(st as short) as short
    dim hisher(1) as string
    dim as short a,gf,whogf,mr,whomr
    hisher(0)=" her "
    hisher(1)=" his "
    for a=0 to 128
        if crew(a).hp>0 and crew(a).story(10)<2 then
            'if crew(a).story(9)>0 and crew(a).story(9)<>st+1 and crew(a).story(9)<>st+3 then crew(a).morale-=1
            if crew(a).story(9)=st+1 then
                gf+=1
                whogf=a
                crew(a).morale+=2
            endif
            if crew(a).story(9)=st+3 then
                mr+=1
                whomr=a
                crew(a).morale+=5
            endif
            if crew(a).story(9)=0 then
                if rnd_range(1,100)<15 then crew(a).story(9)=st+1
            else
                if rnd_range(1,100)<5 then crew(a).story(9)=0
                if rnd_range(1,100)<5 and crew(a).story(9)<=3 then crew(a).story(9)+=3
            endif
        endif
    next
    if gf=1 then dprint crew(whogf).n &" is very happy to see" & hisher(crew(whogf).story(10)) & "girlfriend/boyfriend"
    if gf>1 then dprint gf &" crewmebers are very happy to see their girlfriends/boyfriends"
    if mr=1 then dprint crew(whomr).n &" is very happy to see" & hisher(crew(whomr).story(10)) & "wife/husband"
    if mr>1 then dprint mr &" crewmebers are very happy to see their wifes/husbands"
    return 0
end function


function sort_crew() as short
    dim as short a,f
    do
        f=0
        for a=player.h_maxcrew to 1  step -1
            if crew(a).hp<=0 and crew(a+1).hp>0 then
                f=1 
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    
    do
        f=0
        for a=player.h_maxcrew to 1 step -1
            if crew(a).hp>0 then
                if crew(a).typ>crew(a+1).typ and crew(a+1).hp>0 then
                    f=1
                    swap crew(a),crew(a+1)
                endif
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(27)>crew(a+1).talents(27) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(28)>crew(a+1).talents(28) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0
    do
        f=0
        for a=0 to 127
            if crew(a).talents(29)>crew(a+1).talents(29) and crew(a).hp>0 and crew(a+1).hp>0 then
                f=1
                swap crew(a),crew(a+1)
            endif
        next
    loop until f=0

    return 0
end function


function hiring(st as short,byref hiringpool as short,hp as short) as short
    dim as short b,c,d,e,officers,maxsec,neodog,robots,w,skill
    dim as integer f,g,meni(18),ex,cwage(18)
    dim as string text,help,cname(18)
    
    screenset 1,1

    cname(2)="Pilot"
    cname(3)="Gunner"
    cname(4)="Science Officer"
    cname(5)="Doctor"

    cname(6)="Security"

    cname(11)="Neodog"
    cwage(11)=50
    cname(12)="Neoape"
    cwage(12)=75
    cname(13)="Robot"
    cwage(13)=150

    cname(16)="Squadleader"
    cname(17)="Sniper"
    cname(18)="Paramedic"

    cwage(6)=wage
    cwage(16)=wage*2
    cwage(17)=wage*2
    cwage(18)=wage*2

    meni(1)=2
    meni(2)=3
    meni(3)=4
    meni(4)=5
    meni(5)=6
    meni(6)=16
    meni(7)=17
    meni(8)=18

    ex=8
    text="Hiring/ Pilot/ Gunner/ Science Officer/ Ships Doctor/ Security/ Squad Leader/ Sniper/ Paramedic/"
    help="Nil/Responsible for steering your ship/Fires your weapons and coordinates security team attacks/Operates sensors and collects biodata/Heals injuries and sickness/Your basic grunt/Coordinates the attacks of up to 5 security team members/An excellent marksman/Not worth much in combat, but assists the ships doctor"
    if basis(st).repname="Omega Bioengineering" and player.questflag(1)=3 then neodog=1
    if basis(st).repname="Smith Heavy Industries" and player.questflag(9)=3 then robots=1
    if neodog=1 then
        ex+=1
        meni(ex)=11
        ex+=1
        meni(ex)=12
        text=text & " Neodog/ Neoape/"
        help=help &"/A genetically engeniered lifeform with the basis of a dog/A genetically engeniered lifeform with the basis of a ape"

    endif
    if robots=1 then
        ex+=1
        meni(ex)=13
        text=text & " Robot/"
        help=help &"/Smith Heavy Industries managed to rebuild the robots of the old ones. They aren't as tough as the originals, but formidable killing machines nonetheless"
    endif
    ex+=1
    meni(ex)=101
    ex+=1
    meni(ex)=102
    ex+=1
    meni(ex)=103
    ex+=1

    text=text & " Set Wage/Fire/Train/Exit"
    help=help & " /Set base wage for your crew/Let a crew member go/Try for another promotion"
    cls

    do
        b=menu(bg_shiptxt,text,help)
        if b>0 and b<ex then
            if meni(b)<=5 then 'hire Officer
                select case rnd_range(1,100+player.turn/(7*24*60))
                case is <=50
                    skill=1
                case 51 to 90
                    skill=2
                case 91 to 120
                    skill=3
                case 121 to 140
                    skill=4
                case 141 to 150
                    skill=5
                end select
                if askyn(cname(meni(b))&", Skill:" & skill &" Wage per mission: " & skill*skill*Wage &") hire? (y/n)") then
                    if paystuff(skill*skill*Wage) then
                        hiringpool+=add_member(meni(b),skill)
                    endif
                endif
            endif

            if meni(b)>5 and meni(b)<=18 then 'Hire Crewmember
                maxsec=total_bunks()
                if max_security>0 then
                    dprint "No. of " &cname(meni(b))& " to hire. (Max: "& minimum(maxsec,fix(player.money/cwage(meni(b))))&","&max_security & " with double bunking)"
                    c=getnumber(0,maxsec*2,0)
                    if c>0 then
                        if paystuff(c*cwage(meni(b))) then
                            for d=1 to c
                                hiringpool-=1
                                if add_member(meni(b),0)<>0 then exit for
                            next
                        endif
                    endif
                else
                    dprint "You don't have enough room to hire additional crew.",c_yel
                endif
            endif

            if meni(b)=101 then
                dprint "Set standard wage from "&Wage &" to:"
                w=getnumber(1,20,Wage)
                if w>0 then Wage=w
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod/10
                next
                cwage(6)=wage
                cwage(16)=wage*2
                cwage(17)=wage*2
                cwage(18)=wage*2

                dprint "Set to " &Wage &"Cr. Your crew now gets a total of "&f &" Cr. in wages"
            endif

            if meni(b)=102 then
                'fire
                g=showteam(0,1,"Who do you want to dismiss?")
                if g>1 then
                    if askyn("Do you really want to dismiss "&crew(g).n &"?(y/n)") then
                        for f=g to 127
                            crew(f)=crew(f+1)
                        next
                        crew(128)=crew(0)
                    endif
                endif
            endif

            if meni(b)=103 then
                'Training
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
                next
                f=f/2
                if askyn("Training will cost "&f &" credits.(y/n)") then
                    if paystuff(f) then
                        player=levelup(player,1)
                    endif
                endif
            endif

        endif
    loop until b=ex or b=-1


'        do
'            officers=1
'            if player.pilot(0)>0 then officers=officers+1
'            if player.gunner(0)>0 then officers=officers+1
'            if player.science(0)>0 then officers=officers+1
'            if player.doctor(0)>0 then officers=officers+1
'
'            displayship()
'            b=menu(text,help)
'
'            d=rnd_range(1,100)
'            c=5
'            if d<90 then c=4
'            if d<75 then c=3
'            if d<60 then c=2
'            if d<40 then c=1
'            if c<1 then c=1
'            e=((player.pilot(0)+player.gunner(0)+player.science(0)+player.doctor(0))/4)+1
'            if e<=0 then e=2
'            if c>e then c=e+rnd_range(0,2)-1
'            if c<=0 then c=2
'            if b<5 and hiringpool>0 then
'                if b=1 then
'                    if askyn("Pilot, Skill:" & c &" Wage per mission: "& c*c*Wage &" (Current skill:"&player.pilot(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(2,c)<>0 then exit for
'                        else
'                            dprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=2 then
'                    if askyn("Gunner, Skill:" & c &" Wage per mission: " & c*c*Wage & " (Current skill:"&player.gunner(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(3,c)<>0 then exit for
'                        else
'                            dprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=3 then
'                    if askyn("Science officer, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.science(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(4,c)<>0 then exit for
'                        else
'                           dprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                if b=4 then
'                    if askyn("Ships doctor, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.doctor(0) &") hire? (y/n)") then
'                        if player.money>=c*c*Wage then
'                            player.money=player.money-c*c*Wage
'                            if addmember(5,c)<>0 then exit for
'                        else
'                           dprint "Not enough money for first wage."
'                        endif
'                    endif
'                endif
'                hiringpool=hiringpool-1
'            else
'                if b<5 then dprint "Nobody availiable for the position. try again later."
'            endif
'            if b=5 then
'                maxsec=maxsecurity()
'                dprint "No. of security personel to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if c>0 then
'                if player.money<c*Wage then
'                    dprint "Not enough money for first wage."
'                else
'                    for d=1 to c
'                        if addmember(6,0)<>0 then exit for
'                    next
'                    player.money=player.money-c*Wage
'                endif
'                endif
'            endif
'
'            if b=6 then 'Squad leader
'                maxsec=maxsecurity()
'                dprint "No. of squad leaders to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        dprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            player.money-=wage*2
'                            if addmember(16,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'            if b=7 then 'Sniper
'                maxsec=maxsecurity()
'                dprint "No. of snipers to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        dprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            hiringpool-=1
'                            player.money-=wage*2
'                            if addmember(17,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'            if b=8 then 'Paramedic
'                maxsec=maxsecurity()
'                dprint "No. of paramedics to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
'                c=getnumber(0,maxsec*2,0)
'                if maxsec>0 then
'                    if player.money<wage*2*c then
'                        dprint "Not enough money for first wage."
'                    else
'                        for d=1 to c
'                            player.money-=wage*2
'                            if addmember(18,0)<>0 then exit for
'                        next
'                    endif
'                endif
'            endif
'
'
'            if neodog=1 then
'                if b=9 then
'                    maxsec=maxsecurity()
'                    dprint "How many Neodogs do you want to buy? (Max: "& minimum(maxsec,fix(player.money/50))&")"
'                    c=getnumber(0,maxsec*2,0)
'                    if c>0 then
'                        if player.money<c*50 then
'                            dprint "Not enough Credits."
'                        else
'                            dprint "you buy "&c &" Neodogs."
'                            for d=1 to c
'                                if addmember(11,0)<>0 then exit for
'                            next
'                            player.money=player.money-c*50
'                        endif
'                    endif
'                endif
'
'                if b=10 then
'                    maxsec=maxsecurity()
'                    dprint "How many Neoapes do you want to buy? (Max: "& minimum(maxsec,fix(player.money/75))&")"
'                    c=getnumber(0,maxsec*2,0)
'                    if c>0 then
'                        if player.money<c*75 then
'                            dprint "Not enough Credits."
'                        else
'                            dprint "you buy "&c &" Neoapes."
'                            for d=1 to c
'                                if addmember(12,0)<>0 then exit for
'                            next
'                            player.money=player.money-c*75
'                        endif
'                    endif
'                endif
'            endif
'
'            if b=9 and robots=1 then
'                maxsec=maxsecurity()
'                dprint "How many Robots do you want to buy? (Max: "& minimum(maxsec,fix(player.money/150))&")"
'                c=getnumber(0,maxsec*2,0)
'                if c>0 then
'                    if player.money<c*150 then
'                        dprint "Not enough Credits."
'                    else
'                        dprint "you buy "&c &" Robots."
'                        for d=1 to c
'                            if addmember(13,0)<>0 then exit for
'                        next
'                        player.money=player.money-c*150
'                    endif
'                endif
'            endif
'
'            if (neodog=0 and robots=0 and b=9) or (neodog=1 and b=11) or (robots=1 and b=10) then
'                dprint "Set standard wage from "&Wage &" to:"
'                w=getnumber(1,20,Wage)
'                if w>0 then Wage=w
'                f=0
'                for g=2 to 128
'                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
'                next
'                dprint "Set to " &Wage &"Cr. Your crew now gets a total of "&f &" Cr. in wages"
'            endif
'            if (neodog=0 and robots=0 and b=10) or (neodog=1 and b=12) or (robots=1 and b=11) then
'                'fire
'                g=showteam(0,1,"Who do you want to dismiss?")
'                if g>1 then
'                    if askyn("Do you really want to dismiss "&crew(g).n &".") then
'                        for f=g to 127
'                            crew(f)=crew(f+1)
'                        next
'                        crew(128)=crew(0)
'                    endif
'                endif
'
'            endif
'            if (neodog=0 and robots=0 and b=11) or (neodog=1 and b=13) or (robots=1 and b=12) then
'                'Training
'                f=0
'                for g=2 to 128
'                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
'                next
'                f=f/2
'                if askyn("Training will cost "&f &" credits.(y/n)") then
'                    if player.money>=f then
'                        player.money-=f
'                        player=levelup(player,1)
'                    endif
'                endif
'
'            endif
'
'        loop until (neodog=0 and robots=0 and b=12) or (neodog=1 and b=14) or (robots=1 and b=13)
    return 0
end function

function equip_awayteam(m as short) as short
    dim as short a,b,c,wavg,aavg,tdev,jpacks,hovers,cmove,infra,robots,crewcount,atcost,squadlcount
    dim as single oxytanks,oxy
    dim as short cantswim,cantfly,invisibility
    dim as byte debug=0
    cmove=awayteam.movetype
    awayteam.jpfueluse=0
    awayteam.stuff(1)=0
    awayteam.armor=0
    awayteam.guns_to=0
    awayteam.blades_to=0
    awayteam.light=0
    awayteam.jpfueluse=0
    awayteam.jpfuelmax=0
    for a=0 to lastitem
        if item(a).w.s=-2 then item(a).w.s=-1
    next
    for a=0 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+1
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
    next
    for a=1 to 128 'determine fuel use
        'if crew(a).hp>0 and crew(a).onship=0 then awayteam.hp+=1
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips>-1 then
            crewcount+=1
            if crew(a).typ=13 then robots+=1
            if crew(a).talents(27)>0 then squadlcount+=1
            atcost+=crew(a).atcost
            if jpacks>0 then
                crew(a).jp=1
                awayteam.jpfueluse+=1
                jpacks-=1
            else
                crew(a).jp=0
            endif
        endif
    next
    hovers=0
    jpacks=0

    for a=0 to lastitem
        if item(a).ty=1 and item(a).v1=1 and item(a).w.s=-1 then hovers=hovers+item(a).v2
        if item(a).ty=1 and item(a).v1=2 and item(a).w.s=-1 then jpacks=jpacks+1
    next
    infra=2
    awayteam.invis=6
    awayteam.oxymax=0
    awayteam.oxydep=0
    for a=1 to 128
        crew(a).weap=0
        crew(a).armo=0
        crew(a).blad=0
        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips<>1 then
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
                    wear_armor(a,c)
                    'dprint crew(a).n &" grabs his "&item(c).desig
                endif
            endif
        endif
    next

    for a=1 to 128
        'find best ranged weapon
        'give to redshirt

        if crew(a).hp>0 and crew(a).onship=0 and crew(a).equips>-1 then
            if crew(a).augment(7)=0 then
                cantswim+=1
            else
                hovers+=1
            endif

            if crew(a).augment(8)=0 then
                cantfly+=1
            else
                jpacks+=1
                if crew(a).typ<>13 then awayteam.jpfueluse+=1
            endif

            'Find best Jetpack(V3 lowest value)
            'Give to crewmember
            oxy=.75
            b=findbest(17,-1)
            if b>-1 then
                item(b).w.s=-2
                oxy=oxy-item(b).v1
            endif
            if crew(a).augment(3)>1 then oxy=oxy-.3
            if oxy<0 then oxy=.1
            
            if crew(a).typ=13 then 
                oxy=0
                awayteam.secweap(a)=1
                awayteam.secweapc(a)=1
                awayteam.secweapthi(a)=5
                awayteam.secweapran(a)=5
                awayteam.blades_to+=awayteam.secweapc(a)
                awayteam.guns_to+=awayteam.secweap(a)
            endif
            
            if crew(a).equips=-1 then oxy=0
            
            awayteam.oxydep=awayteam.oxydep+oxy
            

            if crew(a).equips<>1 then
                b=-1
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
                b=-1
                if crew(a).equips=0 then b=findbest(3,-1)
                if crew(a).equips=2 then b=findbest(103,-1)'Squidsuit
                'give to redshirt
                if b>-1 and crew(a).armo=0 then
                    wear_armor(a,b)
                else
                    awayteam.invis=0
                endif
                if crew(a).augment(8)=0 then
                    b=findbest_jetpack()
                    awayteam.jpfueluse=0
                    if b>0 then
                        item(b).w.s=-2
                        awayteam.jpfueluse+=item(b).v3
                    endif
                endif
                
                b=findbest(14,-1)
                if b>-1 then
                    item(b).w.s=-2
                    awayteam.oxymax=awayteam.oxymax+item(b).v1
                endif
                
            endif
            
            if crew(a).hpmax>0 and crew(a).onship=0 and crew(a).jp=1 or crew(a).augment(8)=1 then
                b=findbest(28,-1)
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
    'dprint ""&awayteam.move
    'count teleportation devices
    if findbest(88,-1)>0 then
        awayteam.teleportrange=item(findbest(88,-1)).v1
    else
        awayteam.teleportrange=0
    endif
    
    if findbest(42,-1)>0 then
        awayteam.groundpen=item(findbest(42,-1)).v1
    else
        awayteam.groundpen=0
    endif
    
    awayteam.movetype=0
    if crewcount>0 then
        if awayteam.movetype<4 and cantswim<=hovers then awayteam.movetype=1
        if awayteam.movetype<4 and cantfly<=jpacks*1.5+robots*2 then awayteam.movetype+=2
        awayteam.carried=cantfly-jpacks-robots*2
        if awayteam.carried<0 then awayteam.carried=0
        if cantfly-jpacks-robots*2>0 then awayteam.jpfueluse=awayteam.jpfueluse+(cantfly-jpacks-robots*2) 'The ones that need to be carried use extra fuel
        awayteam.nohp=hovers
        awayteam.nojp=jpacks*1.5+robots*2
    endif
    if findbest(5,-1)>-1 then awayteam.stuff(5)=item(findbest(5,-1)).v1
    if findbest(17,-1)>-1 then awayteam.stuff(4)=.2
    if findbest(46,-1)>-1 then awayteam.invis=7
    awayteam.sight=3
    awayteam.light=0
    if findbest(8,-1)>-1 then awayteam.sight=awayteam.sight+item(findbest(8,-1)).v1
    if findbest(9,-1)>-1 then awayteam.light=item(findbest(9,-1)).v1
    
    awayteam.robots=robots
    
    if awayteam.oxygen>awayteam.oxymax then awayteam.oxygen=awayteam.oxymax
    if awayteam.jpfuel>awayteam.jpfuelmax then awayteam.jpfuel=awayteam.jpfuelmax
    awayteam.jpfueluse=awayteam.jpfueluse*planets(m).grav
    awayteam.oxydep=awayteam.oxydep*awayteam.helmet

    awayteam.atcost=atcost/crewcount
    if _debug>0 then dprint "atcost:"&awayteam.atcost
    crewcount=crewcount-squadlcount*5
    if crewcount<0 then crewcount=0
    awayteam.speed=10+awayteam.movetype+add_talent(-1,24,0)-crewcount/20
    if _debug>0 then dprint "atspeed:"&awayteam.speed

    return 0
end function

function tohit_gun(a as short) as short
    return crew(a).augment(1)+crew(a).talents(28)*3-crew(a).talents(29)*7+add_talent(3,10,1)+add_talent(3,11,1)+add_talent(a,23,1)+maximum(0,player.gunner(1))
end function

function tohit_close(a as short) as short
    return add_talent(3,10,1)+crew(a).talents(28)*3+add_talent(a,21,1)+crew(a).hp-crew(a).talents(29)*7
end function

function showteam(from as short, r as short=0,text as string="") as short
    sort_crew
    return crew_menu(crew(),from,r,text)
end function

function count_crew(crew() as _crewmember) as short
    dim as short b,last
    for b=1 to 128
        if crew(b).hpmax>0 then last+=1
    next
    return last
end function

function wear_armor(a as short,b as short) as short
    dim as short invisibility
    awayteam.secarmo(a)=item(b).v1
    if item(b).v2>crew(a).augment(9) then
        invisibility=item(b).v2
    else
        invisibility=crew(a).augment(9)
    endif
    if awayteam.invis<invisibility then awayteam.invis=invisibility
    crew(a).armo=b
    item(b).w.s=-2
    awayteam.armor+=item(b).v1
    awayteam.oxymax+=item(b).v3
    return 0
end function


function crew_menu(crew() as _crewmember, from as short, r as short=0,text as string="") as short
    dim as short b,bg,last,a,sit,cl,y,lines,xw,xhp,carl,dfirst,dlast,offset2
    dim dummy as _monster
    static p as short
    static offset as short
    dim n as string
    dim skills as string
    dim augments as string
    dim message as string
    dim onoff(2) as string
    dim debug as byte

    onoff(0)="On "
    onoff(1)=" - "
    onoff(2)="Off"
    last=count_crew(crew())
    if p=0 then p=1
    no_key=""
    equip_awayteam(0)
    lines=fix((_screeny)/(_fh2)) ' Stops last crew member for disappearing from screen
    lines-=6
    cls
    do
        set__color( 11,0)
        screenset 0,1
        cls
        message=""
        if no_key=key__enter then
            if r=0 then
                if from=0 then
                    if p>1 then
                        if crew(p).disease=0 then
                            select case crew(p).onship
                            case is=0
                                crew(p).onship=1
                            case is=1
                                crew(p).onship=0
                            end select
                        else
                            draw string (10,_screeny-_fh2*2), "Is sick and must stay on board.",,font2,custom,@_col
                        endif
                    else
                        if crew(p).onship=lc_onship and crew(p).disease=0 then
                            crew(p).onship=0
                            crew(p).oldonship=0
                        else
                            locate 22,1
                            set__color( 14,0)
                            draw string (10,_screeny-_fh2*2), "The captain must stay in the awayteam.",,font2,custom,@_col
                        endif
                    endif
                else
                    locate 22,1
                    set__color( 14,0)
                    draw string (10,_screeny-_fh2*2), "You need to be at the ship to reassign.",,font2,custom,@_col
                endif
            endif
            if r=1 then return p

        endif


        if no_key="e" then
            select case crew(p).equips
                case 0
                    crew(p).equips=2
                case 2
                    crew(p).equips=0
            end select
            equip_awayteam(0)
        endif

        if no_key="a" and r=1 then return -1'Install augment in all


        if no_key="s" then
            sit=get_item(0,0,0,1)
            if sit>0 then
                sit=first_unused(sit)
                for cl=1 to 128
                    if crew(cl).pref_lrweap=item(sit).uid then crew(cl).pref_lrweap=0
                    if crew(cl).pref_ccweap=item(sit).uid then crew(cl).pref_ccweap=0
                    if crew(cl).pref_armor=item(sit).uid then crew(cl).pref_armor=0
                next
                if item(sit).ty=2 then
                    crew(p).pref_lrweap=item(sit).uid
                endif
                if item(sit).ty=4 then
                    crew(p).pref_ccweap=item(sit).uid
                endif
                if item(sit).ty=3 then
                    crew(p).pref_armor=item(sit).uid
                endif
                equip_awayteam(0)
            endif
            cls
        endif

        if no_key="c" then
            crew(p).pref_lrweap=0
            crew(p).pref_ccweap=0
            crew(p).pref_armor=0
            equip_awayteam(0)

        endif
        
        y=0
        b=1
        'for b=1 to lines
        dfirst=0
        
        do
            if b=p+offset then
                bg=5
            else
                bg=0
            endif
            
            if b-offset>0 and b-offset<=128 then
                if dfirst=0 then dfirst=b-offset
                if crew(b-offset).hpmax>0 then
                    skills=""
                    augments=""
                    set__color( 0,bg)
                    draw string (0,y*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+1)*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+2)*_fh2), space(80),,font2,custom,@_col

                    skills=skill_text(crew(b-offset))
                    augments=augment_text(crew(b-offset))

                    if augments <> "" then draw string (0,(y+3)*_fh2), space(80),,font2,custom,@_col

                    if skills<>"" then skills=skills &" "
                    set__color( 15,bg)
                    if b-offset>9 then
                        draw string (0,y*_fh2), b-offset & " ",,font2,custom,@_col
                    else
                        draw string (0,y*_fh2), " " & b-offset & " ",,font2,custom,@_col
                    endif
                    if crew(b-offset).hp>0 then
                        set__color( 10,bg)
                        draw string (3*_fw2,y*_fh2), crew(b-offset).icon,,font2,custom,@_col
                        set__color( 15,bg)
                            if crew(b-offset).talents(27)>0 then draw string (5*_fw2,y*_fh2), "SquLd",,font2,custom,@_col
                            if crew(b-offset).talents(28)>0 then draw string (5*_fw2,y*_fh2), "Snipr",,font2,custom,@_col
                            if crew(b-offset).talents(29)>0 then draw string (5*_fw2,y*_fh2), "Param",,font2,custom,@_col
                            if crew(b-offset).typ=1 then draw string (3*_fw2,y*_fh2), "Captain",,font2,custom,@_col
                            if crew(b-offset).typ=2 then draw string (3*_fw2,y*_fh2), "Pilot  ",,font2,custom,@_col
                            if crew(b-offset).typ=3 then draw string (3*_fw2,y*_fh2), "Gunner ",,font2,custom,@_col
                            if crew(b-offset).typ=4 then draw string (3*_fw2,y*_fh2), "Science",,font2,custom,@_col
                            if crew(b-offset).typ=5 then draw string (3*_fw2,y*_fh2), "Doctor ",,font2,custom,@_col
                            if crew(b-offset).talents(27)=0 and crew(b-offset).talents(28)=0 and crew(b-offset).talents(29)=0 then
                                if crew(b-offset).typ=6 then draw string (3*_fw2,y*_fh2), "Green  ",,font2,custom,@_col
                                if crew(b-offset).typ=7 then draw string (3*_fw2,y*_fh2), "Veteran",,font2,custom,@_col
                                if crew(b-offset).typ=8 then draw string (3*_fw2,y*_fh2), "Elite  ",,font2,custom,@_col
                                if crew(b-offset).typ>=30 then draw string (3*_fw2,y*_fh2), "Passenger",,font2,custom,@_col

                            endif

                    else
                        set__color( 12,0)
                        draw string (3*_fw2,y*_fh2), "X",,font2,custom,@_col
                    endif

                    set__color( 15,bg)
                    if crew(b-offset).hp=0 then set__color( 12,bg)
                    if crew(b-offset).hp<crew(b-offset).hpmax then set__color( 14,bg)
                    if crew(b-offset).hp=crew(b-offset).hpmax then set__color( 10,bg)
                    draw string (10*_fw2,y*_fh2), " "&crew(b-offset).hpmax,,font2,custom,@_col
                    set__color( 15,bg)
                    xhp=0
                    if crew(b-offset).hpmax>9 then xhp=1
                    draw string ((12+xhp)*_fw2,y*_fh2), "/",,font2,custom,@_col
                    if crew(b-offset).hp=0 then set__color( 12,bg)
                    if crew(b-offset).hp<crew(b-offset).hpmax then set__color( 14,bg)
                    if crew(b-offset).hp=crew(b-offset).hpmax then set__color( 10,bg)
                    draw string ((13+xhp)*_fw2,y*_fh2), ""&crew(b-offset).hp,,font2,custom,@_col
                    set__color( 15,bg)
                    draw string (16*_fw2,y*_fh2), " "&crew(b-offset).n,,font2,custom,@_col
                    if (crew(b-offset).onship=lc_onship or crew(b-offset).onship=4 or crew(b-offset).disease>0) and crew(b-offset).hp>0 then
                        set__color( 14,bg)
                        draw string (34*_fw2,y*_fh2) ," On ship ",,font2,custom,@_col
                    endif
                    if crew(b-offset).onship=0 and crew(b-offset).hp>0 then
                        set__color( 10,bg)
                        draw string (34*_fw2,y*_fh2) ," Awayteam ",,font2,custom,@_col
                    endif
                    if debug=1 and _debug=1 then draw string (40*_fw2,y*_fh2),""&crew(b-offset).oldonship,,font2,custom,@_col
                    if crew(b-offset).hp<=0 then
                        set__color( 12,bg)
                        draw string (34*_fw2,y*_fh2) ," Dead ",,font2,custom,@_col
                    endif
                    set__color( 15,bg)
                    if crew(b-offset).xp>=0 then
                        draw string (55*_fw2,y*_fh2)," XP:" &crew(b-offset).xp,,font2,custom,@_col
                    else
                        draw string (55*_fw2,y*_fh2), " XP: -",,font2,custom,@_col
                    endif

                    'Fixes the auto equip messgae so it does not get over writen Also goign to set the highlighting if needed
                    if skills = "" then
                        if crew(b-offset).equips>-1 then
                            draw string(45*_fw2,(y+2)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                        endif
                    elseif augments = "" then
                        set__color( 0,bg)
                        draw string (0,(y+3)*_fh2), space(80),,font2,custom,@_col
                        set__color( 15,bg)
                        if crew(b-offset).equips>-1 then
                            draw string(45*_fw2,(y+2)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                        endif
                    else
                        set__color( 0,bg)
                        draw string (0,(y+4)*_fh2), space(80),,font2,custom,@_col
                        set__color( 15,bg)
                        if crew(b-offset).equips>-1 then
                            draw string(45*_fw2,(y+2)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                        endif
                    endif


                    'print space(70-pos)
                    set__color( 15,bg)

                    y+=1
                    xw=4
                    if crew(b-offset).armo>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_armor>0 then
                            draw string (xw*_fw2,y*_fh2) ,"*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2),trim(item(crew(b-offset).armo).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).armo).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2), " None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).weap>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_lrweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2) ," ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2) , trim(item(crew(b-offset).weap).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).weap).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2) ," None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).blad>0 then
                        set__color( 15,bg)
                        if crew(b-offset).pref_ccweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2), trim(item(crew(b-offset).blad).desig)&" ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).blad).desig))+3
                    else
                        set__color( 14,bg)
                        draw string (xw*_fw2,y*_fh2) ," None",,font2,custom,@_col
                        xw=xw+7
                    endif
                    set__color( 11,bg)
                    if crew(b-offset).jp>0 then draw string (xw*_fw2,y*_fh2) ," Jetpack",,font2,custom,@_col
                    'print space(70-pos)

                    y+=1

                    set__color( 15,bg)
                    draw string (1*_fw2,y*_fh2), skills,,font2,custom,@_col


                    if augments <> "" then 'if we have augments put them below the line for skills as it use to be on the same line
                        y+=1
                        draw string (1*_fw2,y*_fh2), augments,,font2,custom,@_col
                    endif

                    if crew(b-offset).disease>0 then
                        y+=1
                        set__color( 14,bg)
                        draw string (1*_fw2,y*_fh2), "Suffers from "&trim(disease(crew(b-offset).disease).ldesc),,font2,custom,@_col
                    endif
                    'print space(70-pos)

                    'needed to add a space after if the auto equip is moved below skills and augments
                    if skills <> "" then
                        y+=2
                    else
                        y+=1 'adds extra line between crew members was y+=1
                    endif

                    set__color( 11,bg)
                endif
            endif
            b+=1
            y+=1
        loop until y>=lines
        dlast=b-1-offset
        set__color( 11,0)
        locate 25,1
        if r=0 then
            if from=0 then draw string (10,_screeny-_fh2),"enter add/remove from awaytem,"&key_rename &" rename a member, s set Item c clear, e toggle autoequip, esc exit",,font2,custom,@_col
            if from<>0 then draw string (10,_screeny-_fh2),key_rename &" rename a member, s set Item, c clear, e toggle autoequip, esc exit",,font2,custom,@_col
        endif
        if r=1 then draw string (10,_screeny-_fh2),"Installing augment "&text &": Enter to choose crewmember, esc to quit, a for all",,font2,custom,@_col
        if r=2 then draw string (10,_screeny-_fh2),"Training for "&text &": Enter to choose crewmember, esc to quit, a for all",,font2,custom,@_col
        
        'flip
        textbox(crew_bio(p),_mwx,1,20,15,1,,,offset2)
        screenset 0,1
        no_key=keyin(,1)
        if getdirection(no_key)=2 then p+=1
        if getdirection(no_key)=8 then p-=1
        if no_key="+" then offset2+=1
        if no_key="-" then offset2-=1
        if no_key=key_rename then
            screenset 1,1
            if p<6 then
                n=gettext(16,(p-1+offset)*3,16,n)
            else
                n=gettext(10,(p-1+offset)*3,16,n)
            endif
            if n<>"" then crew(p).n=n
            n=""
        endif
        if p<1 then p=1
        if p>last then p=last
        if p>dlast then offset-=1
        if p<dfirst then offset+=1
    loop until no_key=key__esc or no_key=" "
    screenset 0,1
    cls
    flip
    return 0
end function
