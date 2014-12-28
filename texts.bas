function get_rumor(i as short=18) as string
    dim as short last=18
    if i=0 then i=last
    select case i
    case 1 'Station Commander
        return ""
    case 2 'Freelancer
        select case rnd_range(1,6)
        case 1
            return "I heard nobody has ever returned from exploring a system at coordinates "&cords(map(sysfrommap(specialplanet(2))).c) &"."
        case 2
            return "There are planets out there where the ice will come after you and kill you! I call them Icetrolls, they freeze during the night, and thaw during the day. Keep in the dark when you are on such a planet."
        case 3
        end select

    case 3 'Security
        return "My tribble helped me cope when a friend of mine was killed by wildlife on some backwater planet"

    case 4 'Science
    case 5 'Gunner
    case 6 'Doctor
    case 7 'Merchant
    case 8 'colonist
    case 9 'Tourist
    case 10 'EE
    case 11 'SHI
    case 12 'TT
    case 13 'OBE
    case 14 'Entertainer
    case 15 'Xenobio
    case 16 'Astro
    case 17 'Engineer
    case 18 'General bar rumor
        return "I heard the leader of the pirates is choosen in a spaceship duel."
    end select
end function

function show_standing() as short
    dim scale(6) as string
    dim as string facname(8),stscore(7)
    dim as short a,debug,l

    facname(ft_merchant)="Merchants"
    facname(ft_pirate)="Pirates"
    facname(ft_patrol)="Company patrols"
    facname(ft_pirate2)="Famous pirates"
    facname(ft_ancientaliens)="ASCS"
    facname(ft_civ1)=civ(0).n
    facname(ft_civ2)=civ(1).n
    facname(ft_monster)="Monster"

    scale(0)=" {10}Excellent{11}"
    scale(1)=" {10}Friendly{11}"
    scale(2)=" {14}Neutral{11}"
    scale(3)=" {12}Hostile{11}"
    scale(4)=" {12}Very hostile{11}"
    scale(5)=" {12}War{11}"
    for a=1 to 7
        stscore(a)=scale(faction(0).war(a)/20)
        if alliance(a)>0 then stscore(a)=stscore(a) &" (Alliance member)"
        if debug=1 and _debug=1 then stscore(a)=stscore(a) '& faction(0).war(a)/20 &"-"&faction(0).war(a)
    next
    l=len(stscore(1))+len("Companies:")
    scale(6)="{15}Faction standing:{11} | Companies:"&space(35-l)&stscore(1)
    l=len(stscore(2))+len("Pirates:")
    scale(6)=scale(6) &" | Pirates:"&space(35-l)&stscore(2)
    l=len(civ(0).n)+len( stscore(6))
    if civ(0).contact>0 then scale(6)=scale(6) &" | "&civ(0).n &space(35-l)&stscore(6)
    l=len(civ(1).n)+len( stscore(7))
    if civ(1).contact>0 then scale(6)=scale(6) &" | "&civ(1).n &space(35-l)&stscore(7)
    scale(6)=scale(6)&"||{15}Battles:|{11}"
    for a=1 to 8
        if battleslost(a,0)>0 then
            l=len(facname(a)& battleslost(a,0))
            scale(6)=scale(6)&" "&facname(a) & ":"&space(26-l)& battleslost(a,0)&"|"
        endif
    next
    textbox(scale(6),2,2,32,1,1)
    no_key=keyin()
    return 0
end function

function make_weap_helptext(w as _weap) as string
    dim help as string
    help=help &"{15}"&w.desig &"{11} | | "
    if w.made=1 then help=help &"Little more than an airlock to throw your ammo in the general direction of your target. "
    if w.made=2 then help=help &"A chemical explosion propels your warhead towards the enemy. "
    if w.made=3 then help=help &"A bigger version of the popular hand weapon: Your rounds are accelerated to high speeds using electric fields. "
    if w.made=4 then help=help &"Small rockets are used to propel your ammunition towards the opposing force. "
    if w.made=5 then help=help &"Similiar to a gauss gun, but instead of using seperate coils it uses continous current.  "
    if w.made=6 then help=help &"Ionized hydrogen. Low impact damage, low penetration. A targetable ships drive basically"
    if w.made=7 then help=help &"Lasers burn through the enemys ships armor"
    if w.made=8 then help=help &"Higher energy per particle increases the damage of a Laser"
    if w.made=9 then help=help &"Bremsstrahlung wreaks havoc inside the target even if the particles don't penetrate the hull."
    if w.made=10 then help=help &"Heavy particles accelerated to near light speeds penetrate and rip apart the enemys armor."
    if w.made=11 then help=help &"Two light ship guns combined into a battery. "
    if w.made=12 then help=help &"Three light gauss guns combined into a battery "
    if w.made=13 then help=help &"Four light rocket launchers combined into a battery "
    if w.made=14 then help=help &"Three rail guns combined into a battery. There are 2 rounds in each "
    if w.made=84 then help=help &"A weapons turret modified to store and feed ammunition to other weapons on the ship. Holds 25 additional projectiles. Any insurance policy for your life or your ship you hold is void if you install this."
    if w.made=85 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
    if w.made=86 then help=help &"Collects fuel from interstellar gas clouds and improves the amount of fuel gained from scooping gas giants "
    if w.made=87 then help=help &"Sacrifices a weapon turret to install additional armor | | +5 to HP"
    if w.made=88 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 4 points of heat dissipation"
    if w.made=89 then help=help &"expandable radiating surfaces, to dissipate weapons heat | | 8 points of heat dissipation"
    if w.made=90 then help=help &"An auxillary powerplant dedicated to the shield generator, improving their recharging rate. | | Shields recharge at 2 pts per round"
    if w.made=91 then help=help &"A small auxillary powerplant feeding energy weapons. | | +1 to energy weapons damage"
    if w.made=92 then help=help &"A large auxillary powerplant feeding energy weapons. | | +2 to energy weapons damage."
    if w.made=93 then help=help &"A second sensor array directly linked to weapons control | | +1 to hit in space combat"
    if w.made=94 then help=help &"A powerfull additional sensor array directly linked to weapons control | | +2 to hit in space combat"
    if w.made=95 then help=help &"An improved tractor beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes. It is more powerfull and sturdier than the normal Tractor beam."
    if w.made=96 then help=help &"A beam weapon that can attract and repel mass. Essential for salvage missions and practical for other purposes."
    if w.made=97 then help=help &"A weapons turret modified to provide lving space. Holds up to 10 additional crewmembers"
    if w.made=98 then help=help &"Not the safest way to store fuel. It holds 50 tons"
    if w.made=99 then help=help &"A weapons turret modified to hold an additional ton of cargo."

    select case w.made
    case 6 to 10
        help=help &" | | Damage: "&w.dam &" | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    case 1 to 5 , 11 to 14
        help=help &" | | Range: "&w.range &"\"&w.range*2 &"\" &w.range*3
    end select
    if w.rof>1 then help &="| Rate of Fire: "&w.rof
    if w.ammomax>0 then help=help &" | Ammuniton: "&w.ammomax
    if w.heatadd>0 or w.heatsink>0 then help=help &"| Heat:"&w.heat &"\"&w.heatadd &" Heatsinks: "& w.heatsink
    return help
end function


function explored_percentage_string() as string
    dim as short x,y,ex
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then ex+=1
        next
    next
    if ex<(sm_x*sm_y) then
        return "Explored {15}"&ex &"{11} parsec ({15}"& int(ex/(sm_x*sm_y)*100) &" %{11} of the sector)"
    else
        return "Explored the complete sector."
    endif
end function

function caged_monster_text() as string
    dim i as short
    dim as string t
    t="Captured lifeforms: "&lastcagedmonster &"|"
    for i=1 to lastcagedmonster
        t=t &"|"&cagedmonster(i).sdesc
        if i<lastcagedmonster and cagedmonster(i).c.s<>cagedmonster(i+1).c.s or i=lastcagedmonster then t=t &" in a "&item(cagedmonster(i).c.s).desig &"."
    next
    return t
end function


function death_text() as string
    dim text as string
    if player.dead=1 then text="You ran out of fuel. Slowly your life support fails while you wait for your end beneath the eternal stars"
    if player.dead=2 then text="The station impounds your ship for outstanding depts. You start a new career as cook at the stations bistro"
    if player.dead=3 then text="Your awayteam was obliterated. your Bones are being picked clean by alien scavengers under a strange sun"
    if player.dead=4 then text="After a few months stranded on an alien world you decide to stop sending distress signals, and try to start a colony with your crew. All works really well untill one day that really big animal shows up..."
    if player.dead=5 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by pirates"
    if player.dead=6 then text="Farewell Captain!"
    if player.dead=7 then text="You didn't think the pirates base would be the size of a city, much less a whole planet. The last thing you see is the muzzle of a pirate gaussgun pointed at you."
    'if player.dead=8 then text= "You think you can see a malicious grin beneath the leaves as the prehensile vines snap your neck"
    if player.dead=9 then text="Apollo convinces you with bare fists and lightningbolts that he in fact is a god"
    if player.dead=10 then text="The robots defending the city are old, but still very well armed and armored. Their long gone masters would have been pleased to learn how easily they repelled the intruders."
    if player.dead=11 then text="The Sandworm swallows the last of your awayteam with one gulp"
    if player.dead=12 then text="Explosions start rocking your ship as the interstellar gas starts ripping holes into the hull. You try to make a quick run out but you aren't fast enough."
    if player.dead=13 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the merchants escort ships"
    if player.dead=14 then text="You run out of oxygen on an airless world. Your death comes quick"
    if player.dead=15 then text="With horror you watch as the ground cracks open beneath the " &player.desig &" and your ship disappears in a sea of molten lava"
    if player.dead=16 then text="Trying to cross the lava field proved to be too much for your crew"
    if player.dead=17 then text="The world around you dissolves into an orgy of flying rock, bright light and fire. Then all is black."
    if player.dead=18 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed while trying to "&space(41)&"ignore the station commanders wishes"
    if player.dead=19 then text="Your pilot crashes the ship into the asteroid. You feel very alone as you drift in your spacesuit among the debris, hoping for someone to pick up your weak distress signal."
    if player.dead=20 then text="When the monster destroys your ship your only hope is to leave the wreck in your spacesuit. With dread you watch it gobble up the debris while totally ignoring the people it just doomed to freezing among the asteroids."
    if player.dead=21 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an ancient alien ship"
    if player.dead=22 then text="A creaking hull shows that your pilot underestimated the pressure and gravity of this gas giant. Heat rises as you fall deeper and deeper into the atmosphere with ground to hit below. Your ship gets crushed. You are long dead when it eventually gets torn apart by winds and evaporated by the rising heat."
    if player.dead=23 then text="The creatures living here tore your ship to pieces. The winds will do the same with you floating through the storms of the gas giant like a leaf in a hurricane."
    if player.dead=24 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the" &space(41)& "strange forces inside the wormhole"
    if player.dead=25 then text="The inhabitants of the ship overpower you. Now two ships will drift through the void till the end of time."
    if player.dead=26 then text="The weapons of the Anne Bonny fire one last time before your proud ship gets turned into a cloud of hot gas."
    if player.dead=27 then text="Within seconds the refueling platform and your ship are high above you. Jetpacks won't suffice to fight against the gas giants gravity. You plunge into your fiery death."
    if player.dead=28 then text="The last thing you remember is the doctor giving you an injection. Your corpse will be disposed of."
    if player.dead=29 then text="A huge wall of light and fire appears on the horizon. Within the blink of an eye it rushes over you, dispersing your ashes in the wind."
    if player.dead=30 then text="High gravity shakes your ship. Suddenly an energy discharge out of nowhere evaporates your ship!"
    if player.dead=31 then text="Hardly damaged the unknown vessel continues it's way across the stars, ignoring the burning wreckage of your ship."
    if player.dead=32 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=33 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=34 then text="Too late you realize that your ride on the icechunk has brought you too deep into the gas giants atmosphere. Rising pressure squashes you, as the iceblock disintegrates around you."
    if player.dead=35 then text="The dangers of spacecombat are manifold. Flying into your own engine exhaust is one of them."
    if player.dead=36 then text="White."&space(41)&"then all black"&space(41)&"Your assault on a space station failed."
    if player.dead=98 then
        endstory=es_part1
        textbox (endstory,2,2,_screenx/_fw2-5)
        text=endstory
    endif
    if player.dead=99 then text="Till next time!"
    return text
end function

function vege_per(slot as short) as single
    dim as short x,y,vege,total
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,slot)>0 then
                total+=1
                if tiles(planetmap(x,y,slot)).vege>0 then vege+=1
            endif
        next
    next
    if total=0 then return 0
    return vege/total
end function

function bounty_quest_text() as string
    dim t as string
    dim i as short
    for i=1 to lastbountyquest
        if bountyquest(i).status=1 then t=t &"Destroy the "& bountyquest(i).desig &", last seen at "&cords(bountyquest(i).lastseen) &".|"
    next
    return t
end function


function plant_name(ti as _tile) as string
    dim s as string
    dim a as byte
    dim pname(7) as string
    dim colors(12) as string
    dim num(5) as string

    num(1)="Some"
    num(2)="A few"
    num(3)="Few"
    num(4)="Numerous"
    num(5)="Many"

    colors(1)="black"
    colors(2)="white"
    colors(3)="red"
    colors(4)="green"
    colors(5)="blue"
    colors(6)="yellow"
    colors(7)="violet"
    colors(8)="purple"
    colors(9)="orange"

    pname(1)="mosses"
    pname(2)="ferns"
    pname(3)="conifers"
    pname(4)="cycads"
    pname(5)="gnetophytes"
    pname(6)="flowering plants"
    pname(7)="mushrooms"

    s=num(rnd_range(1,5))&" interesting " &colors(rnd_range(1,9))&" "&pname(rnd_range(1,7))
    return s
end function

function show_quests() as short
    dim as short a,b,c,d,sys,p
    dim dest(10) as short
    dim as string txt,addtxt,shipcords
    set__color( 15,0)
    cls
    txt="{15}Missions: |{11}"
    set__color( 11,0)
    if player.questflag(11)=1 then
        for a=1 to lastdrifting
            if drifting(a).p>0 then shipcords=drifting(a).x &":"&drifting(a).y
        next
    endif
        
    for a=1 to 10
        if player.cargo(a).x=11 or player.cargo(a).x=12 then
            b+=1
            dest(b)=player.cargo(a).y+1
        endif
    next
    if b>0 then
        set__color( 15,0)
        txt=txt & "Cargo:|"
        for a=1 to b
            set__color( 11,0)
            txt=txt & "  Cargo for Station-"&dest(a) &"|"
        next
    endif
    if player.questflag(8)>0 and player.towed<0 then print " Deliver "&add_a_or_an(shiptypes(-player.towed),0) &" hull to Station "&player.questflag(8)+1

    if player.questflag(7)>0 then
        sys=sysfrommap(player.questflag(7))
        for d=1 to 9
            if map(sys).planets(d)=player.questflag(7) then p=d
        next
        txt=txt & "  Map planet in orbit "&p &" in the system at "&map(sys).c.x &":"&map(sys).c.y &"|"
    endif
    if player.questflag(9)=1 then txt=txt & "  Find a working robot factory"&"|"
    if player.questflag(10)>0 then txt=txt & "  Find a planet without life and "&add_a_or_an(atmdes(player.questflag(10)),0)&" atmosphere."&"|"
    if player.questflag(11)=1 then txt=txt & "  Find a missing company battleship, last seen at "&shipcords &".|"
    if player.questflag(2)=1 then txt=txt & "  Rescue a company executive from pirates"&"|"
    if player.questflag(12)=1 then txt=txt & "  A small green alien told you about a monster in their mushroom caves."
    if player.questflag(26)>0 then
        sys=sysfrommap(player.questflag(26))
        txt=txt & "  Find out what happened to an expedition last reported from "&cords( map(sys).c)&"."&"|"
    endif
    set__color( 15,0)
    txt=txt & "|{15}Headhunting:{11}"&"|"
    set__color( 11,0)
    txt=txt & bounty_quest_text
    if player.questflag(5)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"
    if player.questflag(6)=1 then txt=txt & "  Bring down an unknown alien ship"&"|"

    txt=txt &"|{15}Escorting:{11}|"
    for a=6 to lastfleet
        if fleet(a).con(1)=1 then
            txt=txt &"  Escort merchant fleet "&a &" to station "&fleet(a).con(3)+1 &"."&"|"
        endif
    next
    txt=txt &"|{15}Patrol:{11}|"
    for a=0 to 12
        if _debug=1111 then txt &= patrolquest(a).status &" " 
        if patrolquest(a).status=1 then txt=txt &"  " &patrolquest(a).show &"|"
    next
    txt=txt &"|{15}Other:{11}|"
    for a=1 to lastquestguy
        if questguy(a).talkedto=2 then
        txt=txt &questguy(a).n &", last seen at "
        if questguy(a).location<0 then
            txt=txt &"a small station,"
        else
            txt=txt &"station-"&questguy(a).location+1 &","
        endif
        select case questguy(a).want.type
        case qt_EI'1
            txt=txt &" wants " &add_a_or_an(questguy(a).want.it.ldesc,0) &".|"
        case qt_autograph'3
            txt=txt &" wants to have an autograph from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_outloan'4
            txt=txt &" wants money back from "&questguy(questguy(a).flag(1)).n &".|"
        case qt_stationimp'5
            txt=txt &" is looking for good engineers.|"
        case qt_drug'6
            txt=txt &" wants " &questguy(a).want.it.desig &".|"
        case qt_souvenir'7
            txt=txt &" wants to have a souvenir.|"
        case qt_tools'8
            txt=txt &" wants to have tools.|"
        case qt_showconcept'9
            txt=txt &" wants a showconcept.|"
        case qt_stationsensor'10
            txt=txt &" wants to have access to station sensors.|"
        case qt_locofpirates'13
            txt=txt &" wants to know the location of pirates.|"
        case qt_locofspecial'14
            txt=txt &" wants to know the location of a special planet.|"
        case qt_locofgarden'15
            txt=txt &" wants to know the location of an earthlike planet.|"
        case qt_research'18
            txt=txt &" is interested in "&questguy(questguy(a).flag(1)).n &"s research.|"
        case qt_megacorp'19
            txt=txt &" is lookin for information on "&companyname(questguy(a).flag(6)) &".|"
        case qt_biodata'20
            txt=txt &" buys biodata.|"
        case qt_anomaly'21
            txt=txt &" buys anomaly data.|"
        case qt_juryrig'22
            txt=txt &" buys plans for improvised repairs.|"
            'qt_cargo
        end select

        endif
    next

    textbox(txt,2,2,_mwx*_fw1/_fw2-4,,1)
    display_ship(0)
    no_key=keyin
    return 0
end function

function system_text(a as short) as string
    dim as short o,pl,af,gg
    dim t as string
    for o=1 to 9
        if map(a).planets(o)<>0 then
            if is_gasgiant(map(a).planets(o)) then gg+=1
            if is_asteroidfield(map(a).planets(o)) then af+=1
            pl+=1
        endif
    next
    if pl=0 and af=0 and gg=0 then
        t=" No planets."
    else
        pl=pl-gg-af
        if pl=1 then t=t &" "& pl &" planet"
        if pl>1 then t=t &" "& pl &" planets"
        if gg=1 then t=t &" "& gg &" gas giant"
        if gg>1 then t=t &" "& gg &" gas giants"
        if af=1 then t=t &" "& af &" asteroid field"
        if af>1 then t=t &" "& af &" asteroid fields"
    endif
    return t
end function

function alienname(flag as short) as string
    dim as string n,vokal,cons
    dim as short a,b,f2,i,f
    dim as string txt(2000)
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
    if flag=3 then
        f2=freefile
        open "data/syllables.txt" for input as #f2
        while not eof(f2)
            i+=1
            line input #f2,txt(i)
        wend
        close f2

        for f=0 to rnd_range(1,3)
            if rnd_range(1,100)<50 then
                n=n & txt(rnd_range(1,i))
            else
                n=n & left(txt(rnd_range(1,i)),2)
            endif
            if rnd_range(1,100)<10 then
                if rnd_range(1,100)<50 then
                    n=n &"'"
                else
                    n=n &"-"
                endif
            endif
        next
        n=left(n,1)&lcase(mid(n,2,len(n)))
    endif
    return n
end function


function date_string() as string
    dim as string t,w(3)
    dim as short i,j
    t=date
    for i=1 to len(t)
        if mid(t,i,1)="-" then
            j+=1
        else
            w(j)=w(j)&mid(t,i,1)
        endif
    next
    if val(w(0))=1 then w(0)="JAN"
    if val(w(0))=2 then w(0)="FEB"
    if val(w(0))=3 then w(0)="MAR"
    if val(w(0))=4 then w(0)="APR"
    if val(w(0))=5 then w(0)="MAY"
    if val(w(0))=6 then w(0)="JUN"
    if val(w(0))=7 then w(0)="JUL"
    if val(w(0))=8 then w(0)="AUG"
    if val(w(0))=9 then w(0)="SEP"
    if val(w(0))=10 then w(0)="OKT"
    if val(w(0))=11 then w(0)="NOV"
    if val(w(0))=12 then w(0)="DEZ"
    return w(1)&"-"&w(0)&"-"&w(2)
end function

function crew_bio(i as short) as string
    dim t as string
    dim as short a
    dim as byte debug=0
    if crew(i).typ=18 then
        t="An artificial intelligence"
        if crew(i).baseskill(0)=7 then t=t &"|Pilot   :7"
        if crew(i).baseskill(1)=7 then t=t &"|Gunner  :7"
        if crew(i).baseskill(2)=7 then t=t &"|Science :7"
        if crew(i).baseskill(3)=7 then t=t &"|Doctor  :7"
    endif
    if crew(i).typ<=9 or (crew(i).typ>=14 and crew(i).typ<=16) then
        t="Age: "& 18+crew(i).story(6) &" Size: 1."& 60+crew(i).story(7)*4 &"m Weight: " &50+crew(i).story(8)*4+crew(i).story(7) &" kg. ||"
        select case crew(i).story(0)
        case is =1
            t=t &"Place of Birth: Spaceship in transit"
        case is =2
            t=t &"Place of Birth: Earth"
        case is =3
            t=t &"Place of Birth: Sol system colony"
        case is =4
            t=t &"Place of Birth: Space station"
        case else
            t=t &"Place of Birth: Colony"
        end select
        t=t &" |Education: " &4+fix(crew(i).story(1)/2) &" years. "
        t=t &" |Work experience: " &cint(crew(i).story(2)/3) &" years. |"
        t=t &" ||To hit gun: "&tohit_gun(i) &"|To hit cc: "&tohit_close(i) &"||"
        select case crew(i).morale
        case is >90
            t=t &"Morale :D"
        case 60 to 90
            t=t &"Morale :)"
        case 40 to 59
            t=t &"Morale :/"
        case is <40
            t=t &"Morale :("
        end select
        select case crew(i).story(9)
        case 1 to 3
            t=t &" |Has a girlfriend/boyfriend on station "&crew(i).story(9)
        case 4 to 6
            t=t &" |Has a wife/husband on station "&crew(i).story(9)-3
        end select

        for a=1 to 25
            if crew(i).talents(a)>0 then
                t=t &" | "
                exit for
            endif
        next

        for a=1 to 25
            if crew(i).talents(a)>0 then 
                
                t=t &" |"&talent_desc(a)
                if a=1 then                    
                    if crew(i).baseskill(0)>0 then t=t &"| Pilot   :"&crew(i).baseskill(0)
                    if crew(i).baseskill(1)>0 then t=t &"| Gunner  :"&crew(i).baseskill(1)
                    if crew(i).baseskill(2)>0 then t=t &"| Science :"&crew(i).baseskill(2)
                    if crew(i).baseskill(3)>0 then t=t &"| Doctor  :"&crew(i).baseskill(3)
                endif
            endif
        next
        if crew(a).story(3)=1 and a<>1 then t=t &"|Has considered retiring."
        if debug=1 and _debug=1 then
            if crew(i).story(10)=0 then
                t=t & "W"
            else
                t=t &"M"
            endif
        endif
    endif
    if crew(i).target<>0 then t="Passenger for station "&crew(i).target &"."
    return t
end function


function alerts() as short
    dim a as short
    static wg as short
    static wj as short
    if awayteam.oxygen=awayteam.oxymax then wg=0
    if awayteam.jpfuel=awayteam.jpfuelmax and awayteam.movetype=2 then wj=0
    if int(awayteam.oxygen<awayteam.oxymax*.5) and wg=0 and awayteam.helmet=1 and awayteam.oxygen>0 then
        dprint ("Reporting oxygen tanks half empty",14)
        wg=1
        for a=1 to wg
            if configflag(con_sound)=0 or configflag(con_sound)=2 then
                #ifdef _FMODSOUND
                FSOUND_PlaySound(FSOUND_FREE, sound(1))
                #endif
                #ifdef _FBSOUND
                fbs_Play_Wave(sound(1))
                #endif
            endif
        next
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.25) and wg=1 and awayteam.helmet=1 and awayteam.oxygen>0 then
        dprint ("Oxygen low.",14)
        wg=2
        for a=1 to wg
            if configflag(con_sound=0) or configflag(con_sound)=2 then
                #ifdef _FMODSOUND
                FSOUND_PlaySound(FSOUND_FREE, sound(1))
                sleep 350
                #endif
                #ifdef _FBSOUND
                fbs_Play_Wave(sound(1))
                sleep 350
                #endif
            endif
        next
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.125) and wg=2 and awayteam.helmet=1 and awayteam.oxygen>0 then
        dprint ("Switching to oxygen reserve!",12)
        wg=3
        for a=1 to wg
            if configflag(con_sound)=0 or configflag(con_sound)=2 then
                #ifdef _FMODSOUND
                FSOUND_PlaySound(FSOUND_FREE, sound(1))
                sleep 350
                #endif
                #ifdef _FBSOUND
                fbs_Play_Wave(sound(1))
                sleep 350
                #endif
            endif
        next
        walking=0
        if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
    endif
    if awayteam.jpfuel<awayteam.jpfuelmax and awayteam.jpfuel>0 then
        if awayteam.jpfuel/awayteam.jpfuelmax<.5 and wj=0 then
            wj=1
            for a=1 to wj
                if configflag(con_sound)=0 or configflag(con_sound)=2 then
                    #ifdef _FMODSOUND
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))
                    sleep 350
                    #endif
                    #ifdef _FBSOUND
                    fbs_Play_Wave(sound(1))
                    sleep 350
                    #endif
                    if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
                endif
            next
            walking=0
            dprint ("Jetpack fuel low",14)
        endif
        if awayteam.jpfuel/awayteam.jpfuelmax<.3 and awayteam.jpfuel>0  and wj=1 then
            wj=2
            for a=1 to wj
                if configflag(con_sound)=0 or configflag(con_sound)=2 then
                    #ifdef _FMODSOUND
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))
                    sleep 350
                    #endif
                    #ifdef _FBSOUND
                    fbs_Play_Wave(sound(1))
                    sleep 350
                    #endif
                    if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
                endif
            next
            walking=0
            dprint ("Jetpack fuel very low",14)
        endif

        if awayteam.jpfuel<5 and awayteam.jpfuel>0  and wj=2 then
            wj=3
        for a=1 to wj
                if configflag(con_sound)=0 or configflag(con_sound)=2 then
                    #ifdef _FMODSOUND
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))
                    sleep 350
                    #endif
                    #ifdef _FBSOUND
                    fbs_Play_Wave(sound(1))
                    sleep 350
                    #endif
                    if configflag(con_sound)=2 then no_key=keyin(" "&key__enter &key__esc)
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
    box=box &" | | Hull Max.: "&s.h_maxhull &" || Shield Max.:  "&s.h_maxshield &" | Engine Max.:  "&s.h_maxengine &" | Sensors Max.: "&s.h_maxsensors
    box=box &" || Crew: "&s.h_maxcrew &" || Cargobays:      "&s.h_maxcargo &" | Weapon turrets: " &s.h_maxweaponslot &" || Fuelcapacity: "&s.h_maxfuel &" |"
    return box
end function

function cargo_text() as string
    dim text as string
    dim cargo(12) as string
    dim cc(12) as short
    dim as short a
    cargo(1)="empty bay"
    cargo(2)="Food"
    cargo(3)="Basic goods"
    cargo(4)="Tech goods"
    cargo(5)="Luxury goods"
    cargo(6)="Weapons"
    cargo(7)="Narcotics"
    cargo(8)="Hightech"
    cargo(9)="Computers"
    cargo(10)="Fuel"
    cargo(11)="Mysterious box"
    cargo(12)="Contract Cargo"
    text="{15}Cargo:|{11}"
    for a=1 to 10
        if player.cargo(a).x>0 and player.cargo(a).x<11 then
            cc(player.cargo(a).x)+=1
        endif
    next
    for a=2 to 12
        select case cc(a)
        case 1
            text=text &cc(a) &" ton of "&lcase(cargo(a)) &"|"
        case is>1
            text=text &cc(a) &" tons of "&lcase(cargo(a)) &"|"
        end select
    next

    for a=1 to 10
        if player.cargo(a).x=11 or player.cargo(a).x=12 then
            text=text &cargo(player.cargo(a).x)& " for station "&player.cargo(a).y+1 &"|"
        endif
    next
    if cc(1)=1 then text=text &cc(1) &" "& cargo(1)
    if cc(1)>1 then text=text &cc(1) &" "& cargo(1)&"s"
    if cc(1)=0 then text=text &"No free bays."
    return text
end function

function html_color(c as string, indent as short=0, wid as short=0) as string
    dim t as string
    t= "<span style="&chr(34) &" COLOR:"& c &"; font-family:arial;position:relative"
    if indent>0 then t=t &"; left:"&indent &"px"
    if wid>0 then t=t & ";display:inline-block; width:"&wid &"px"
    t=t & chr(34)& ">"
    return t
end function

function text_to_html(text as string) as string
    dim as string t,w(1024)
    dim as short wcount,i,first,c
    for i=0 to len(text)
        if mid(text,i,1)="{" or mid(text,i,1)="|" then wcount+=1
        w(wcount)=w(wcount)&mid(text,i,1)
        if mid(text,i,1)=" " or mid(text,i,1)="|" or  mid(text,i,1)="}" then wcount+=1
    next

    for i=0 to wcount
        if w(i)="|" then w(i)="<br>"
        if Left(trim(w(i)),1)="{" and Right(trim(w(i)),1)="}" then
            c=numfromstr(w(i))
            if first=1 then
                w(i)="</span>"& html_color("rgb(" &RGBA_R(palette_(c))& ","&RGBA_G(palette_(c))& ","&RGBA_B(palette_(c))& ")")
            else
                w(i)=html_color("rgb(" &RGBA_R(palette_(c))& ","&RGBA_G(palette_(c))& ","&RGBA_B(palette_(c))& ")")
            endif
            first=1
        endif
    next
    for i=0 to wcount
        t=t &w(i)
    next

    return t
end function

function weapon_string() as string
    dim as string t,weaponstring
    dim as short a,turrets
    weaponstring="{15}Weapons:|"
    for a=1 to player.h_maxweaponslot
        if player.weapons(a).desig<>"" then
            weaponstring=weaponstring &weapon_text(player.weapons(a)) &"|"
        else
            turrets+=1
        endif
    next

    if turrets=1 then weaponstring=weaponstring &"1 empty turret"
    if turrets>1 then weaponstring=weaponstring &turrets &" empty turrets"
    return weaponstring
end function

function weapon_text(w as _weap) as string
    dim text as string

    if w.desig="" then
        text=""
    else
        text="{15}"
        if w.dam>0 then
            if w.reloading>0 then text="{7}"
            if w.shutdown>0 then text="{14}"
            text=text &w.desig &"|"
            if w.reloading=0 and w.shutdown=0 then text=text &"{11}"

            if w.ammomax=0 then
                text=text &" D:"&w.dam
            endif
            if w.reloading=0 then
                text=text &" R:"&w.range &"/"&w.range*2 &"/"&w.range*3
                if w.ammomax>0 then text=text &" A:"&w.ammomax &"/"&w.ammo
            else
                if w.ammomax>0 then
                    text=text &" Reloading"
                else
                    text=text &" Recharging"
                endif
            endif
            text=text &"{11} "
            if w.heat>0 then text=text & "|Heat: "
            if w.heat>50 then text=text &"{14}"
            if w.heat>100 then text=text &"{12}"
            if w.heat>0 then text=text & round_nr(w.heat/25,1)
            if w.shutdown>0 then text=text &"- Shutdown"
        else
            text=w.desig
            if w.ammomax>0 then text=text &"| A:"&w.ammomax &"/"&w.ammo
        endif
    endif
    return text
end function


function ship_table() as string
    dim as string t,weaponstring
    dim as short a,turrets
    weaponstring=weapon_string
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td  width=" &chr(34) &"33%" &chr(34)& " valign=" &chr(34)& "top" &chr(34)& "><div>{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig &"<br>"
    t=t & shipstatsblock &"</div></td><td valign=" &chr(34)& "top" &chr(34)& " width=" &chr(34) &"33%" &chr(34)& "><div>" & weaponstring &"</div></td><td valign=" &chr(34)& "top" &chr(34)& " width=" &chr(34) &"33%" &chr(34)& "><div>" & cargo_text &"</div></td></tr></tbody></table><br>"
    t=text_to_html(t)
    return t
end function

function crew_table() as string
    dim as string t
    dim as short l,i,m
    l=count_crew(crew())
    if l mod 2=0 then
        m=cint(l/2)
    else
        m=cint(l/2)+1
    endif
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<div>"
    for i=1 to m
        t=t &crew_html(crew(i))
    next
    t=t &"</div>"
    t=t &"</td><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<div>"
    for i=m+1 to l
        t=t &crew_html(crew(i))
    next
    t=t &"</div>"
    t=t &"</td></tr></tbody></table>"
    return t
end function



function crew_html(c as _crewmember) as string
    dim as string t,cstring,augments,skills
    t="<div style="&chr(34) &"color:#FFFFFF; font-family:verdana" &chr(34)&">"
    if c.hp>0 then
        t=t & html_color("#ffffff",,80)
        if c.talents(27)>0 then t=t & "Squ.Ld "
        if c.talents(28)>0 then t=t & "Sniper "
        if c.talents(29)>0 then t=t & "Paramd "
        if c.typ=1 then t=t & "Captain "
        if c.typ=2 then t=t & "Pilot   "
        if c.typ=3 then t=t & "Gunner  "
        if c.typ=4 then t=t & "Science "
        if c.typ=5 then t=t & "Doctor  "
        if c.typ=6 then t=t & "Green   "
        if c.typ=7 then t=t & "Veteran "
        if c.typ=8 then t=t & "Elite   "
    else
        t=t & html_color("#FF0000",,80) &"X"
    endif
    t=t &"</span>"
    select case c.hp
    case is=c.hpmax
        cstring="#00FF00"
    case 1 to c.hpmax-1
        cstring="#FFFF00"
    case else
        cstring="#FF0000"
    end select
    t=t & html_color(cstring) &c.hpmax &"</span>"& html_color("#ffffff") &"/</span>"& html_color(cstring)&c.hp &"</span>"
    t=t &" "& html_color("#FFFFFF",,180)&" "& c.n  &"</span>"
    if c.hp<=0 then
        t=t & html_color ("#FF0000",,100) &" Dead"
    else
        if c.onship=0 then
            t=t & html_color("#00FF00",,100) &" Awayteam "
        else
            t=t & html_color("#FFFF00",,100) &" On Ship "
        endif
    endif

    t=t & "</span>" & html_color("#FFFFFF",,20) &"XP:"&c.xp &"</span><br> &nbsp;&nbsp;&nbsp;" '
    if c.armo>0 then
        t=t & html_color("#FFFFFF") &item(c.armo).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &", "
    if c.weap>0 then
        t=t & html_color("#FFFFFF") &item(c.weap).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &", "

    if c.blad>0 then
        t=t & html_color("#FFFFFF")&item(c.blad).desig &"</span>"
    else
        t=t & html_color("#FFFF00")&"None"&"</span>"
    endif
    t=t &"<br>"& html_color("#FFFFFF")
    augments=augment_text(c)
    skills=skill_text(c)
    if skills<>"" then t=t &skills &" "
    if augments<>"" then t=t &augments
    if skills<>"" or augments<>"" then t=t &"<br>"
    t=t &"</span></div><br>"
    return t
end function

function crew_text(c as _crewmember) as string
    dim as string t,cstring,augments,skills
    if c.hp>0 then
        t=t &"{15}"
        if c.talents(27)>0 then t=t & "Squ.Ld "
        if c.talents(28)>0 then t=t & "Sniper "
        if c.talents(29)>0 then t=t & "Paramd "
        if c.typ=1 then t=t & "Captain "
        if c.typ=2 then t=t & "Pilot   "
        if c.typ=3 then t=t & "Gunner  "
        if c.typ=4 then t=t & "Science "
        if c.typ=5 then t=t & "Doctor  "
        if c.typ=6 then t=t & "Green   "
        if c.typ=7 then t=t & "Veteran "
        if c.typ=8 then t=t & "Elite   "
    else
        t="{12}X "
    endif

    select case c.hp
    case is=c.hpmax
        cstring="{10}"
    case 1 to c.hpmax-1
        cstring="{14}"
    case else
        cstring="{12}"
    end select
    t=t & cstring &c.hpmax &"{15}" &"/"& cstring &c.hp
    t=t &" "& "{15}"&" "& space(45-len(t)-len(trim(c.n)))&c.n
    if c.hp<=0 then
        t=t &"{12} Dead "
    else
        if c.onship=0 then
            t=t & "{10} Awayteam "
        else
            t=t & "{14} On Ship "
        endif
    endif

    t=t & "{15}XP:"&c.xp &"|"
    if c.armo>0 then
        t=t & "{11}" &item(c.armo).desig
    else
        t=t & "{14}None"
    endif
    t=t &", "
    if c.weap>0 then
        t=t & "{11}" &item(c.weap).desig
    else
        t=t & "{14}None"
    endif

    t=t &", "

    if c.blad>0 then
        t=t & "{11}" &item(c.blad).desig
    else
        t=t & "{14}None"
    endif

    t=t &"|{15}"
    augments=augment_text(c)
    skills=skill_text(c)
    if skills<>"" then t=t &skills &" "
    if augments<>"" then t=t &augments
    if skills<>"" or augments<>"" then t=t &"|"
    t=t &"|"

    return t
end function


function augment_text(c as _crewmember) as string
    dim augments as string

    if c.augment(1)=1 then augments=augments &"Targeting "
    if c.augment(1)=2 then augments=augments &"Targeting II "
    if c.augment(1)=3 then augments=augments &"Targeting III "
    if c.augment(2)=1 then augments=augments &"Muscle Enh. "
    if c.augment(2)=2 then augments=augments &"Muscle Enh. II "
    if c.augment(2)=3 then augments=augments &"Muscle Enh. III "
    if c.augment(3)>0 then augments=augments &"Imp. Lungs "
    if c.augment(4)>0 then augments=augments &"Speed Enh. "
    if c.augment(5)=1 then augments=augments &"Exoskeleton "
    if c.augment(5)=2 then augments=augments &"Exosceleton II "
    if c.augment(5)=3 then augments=augments &"Exosceleton III "
    if c.augment(6)=1 then augments=augments &"Improved Metabolism "
    if c.augment(6)=2 then augments=augments &"Improved Metabolism II "
    if c.augment(6)=3 then augments=augments &"Improved Metabolism III "
    if c.augment(7)>0 then augments=augments &"FloatLegs "
    if c.augment(8)>0 then augments=augments &"Jetpack "
    if c.augment(9)>0 then augments=augments &"Chameleon Skin "
    if c.augment(10)>0 then augments=augments &"Neural Computer "
    if c.augment(11)>0 then augments=augments &"Loyality Chip "
    if c.augment(12)>0 then augments=augments &"Synthetic Nerves "
    return augments
end function

function skill_text(c as _crewmember) as string
    dim skills as string
    dim a as short
    for a=1 to 26
        if c.talents(a)>0 then
            if skills<>"" then
                skills=skills &", "&talent_desig(a)&"("&c.talents(a)&")"
            else
                skills=talent_desig(a)&"("&c.talents(a)&")"
            endif
        endif
    next
    return skills
end function





function list_inventory() as string
    dim as short i,c,b
    dim as _items inv(1024)
    dim as short invn(1024)
    dim text as string
    c=get_item_list(inv(),invn())
    text="{15}Equipment (Value "&Credits(equipment_value) &" Cr.):{11}"
    for i=1 to c
        select case invn(i)
        case is>1
            text=text &"| "&invn(i)&" "&inv(i).desigp
        case is=1
            text=text &"| "&inv(i).desig
        case is<1
            text=text &"|{15}"&inv(i).desig &"{11}"
        end select
    next
    return text
        b+=1
'        select case invn(i)
'        case is >9
'            draw string (_screenx-(len(trim(inv(i).desig))+3)*_fw2,_screeny-((c-b)*_fh2)),invn(i)&" "&inv(i).desigp,,font2,custom,@_col
'        case 2 to 9
'            draw string (_screenx-(len(trim(inv(i).desig))+3)*_fw2,_screeny-((c-b)*_fh2)),invn(i)&" "&inv(i).desigp,,font2,custom,@_col
'        case else
'            draw string (_screenx-len(trim(inv(i).desig))*_fw2,_screeny-((c-b)*_fh2)),inv(i).desig,,font2,custom,@_col
'
'        end select

end function


function low_morale_message() as short
    dim as short a,total,average,crewmembers,who,dead
    dim as string hesheit,hishersits,himselfherself
    for a=2 to 128
        if crew(a).hp>0 then
            total+=crew(a).morale+add_talent(1,4,10)
            crewmembers+=1
        else
            dead=a
        endif
    next
    average=total/crewmembers
    who=rnd_range(2,crewmembers)
    if crew(who).story(10)=0 then
        hesheit="she"
        hishersits="her"
        himselfherself="herself"
    endif
    if crew(who).story(10)=1 then
        hesheit="he"
        hishersits="his"
        himselfherself="himself"
    endif
    if crew(who).story(10)=2 then
        hesheit="it"
        hishersits="its"
        himselfherself="itself"
    endif
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
                    dprint "You catch " &crew(who).n &" staring down the barrel of " & hishersits & " gun."
                case is=8
                    dprint crew(who).n &" wonders aloud about whether " & hishersits & " uniform is strong enough to hang " & himselfherself & " with."
                case is=9
                    dprint crew(who).n &" rants about how there's no adventure out here, only death and horror."
                case is=10
                    dprint crew(who).n &" rants about how you're the worst captain ever, and that you couldn't command your way out of a wet paper bag."

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
                    dprint crew(who).n &" states that " & hesheit & " will quit the next time you dock, and that everybody who still has a full set of marbles should join him."
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
                    dprint "A fight breaks out over the set__color( of the ship's paint."
                case is=13
                    dprint "You catch " &crew(who).n &" drinking at " & hishersits & " post."
                case is=14
                    dprint crew(who).n &" wishes aloud that he had better equipment... or a better leader."
                case is=15
                    dprint crew(who).n &" wonders aloud about whether any amount of money could be worth *this*."
                case is=16
                    dprint crew(who).n &" obsessively reviews " & hishersits & " last will and testament."

            end select
        case 21 to 30
            select case rnd_range(1,10)
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
                    dprint crew(who).n &" seems a little skittish... more so than when " & hesheit & " first signed on."
                case is=9
                    dprint crew(who).n &" says 'Hey, buck up. We're not dead yet, right? ...Right?'"
                case is=10
                    dprint crew(who).n &" complains about " & hishersits & " spacesuit not fitting right."
            end select
        case 110 to 120
            if rnd_range(1,100)<5 then
                select case rnd_range(1,11)
                    case is=1
                        dprint crew(who).n &" starts whistling."
                    case is=2
                        dprint crew(who).n &" tells everybody about the special paintjob " & hesheit & " plans to get for " & hishersits & " spacesuit."
                    case is=3
                        dprint crew(who).n &" thinks this will be one of the more profitable hauls."
                    case is=4
                        dprint crew(who).n &" bores everyone to tears by explaining in depth how " & hesheit & " will invest enough to get a retirement pension out of " & hishersits & " (great) wage."
                    case is=5
                        dprint crew(who).n &" asks excitedly what everyone thinks what we are going to find next!"
                    case is=6
                        dprint crew(who).n &" offers to put this really great series on the ships entertainment system."
                    case is=7
                        dprint crew(who).n &" starts talking about this great book he just read."
                    case is=8
                        dprint crew(who).n &" really liked what was for supper yesterday."
                    case is=9
                        dprint crew(who).n &" points out that the doc did a really good job on that wound" & hesheit & " got that one time."
                    case is=10
                        dprint crew(who).n &" tells a really funny joke."
                    case is=11
                        dprint crew(who).n &" has no complaints."
                end select
            endif
        case is>120
            if rnd_range(1,100)<5 then
            select case rnd_range(1,4)
                case is=1
                    dprint crew(who).n &" thinks this expedition is going great so far."
                case is=2
                    dprint crew(who).n &" tells a funny joke."
                case is=3
                    dprint crew(who).n &" thinks you are the best captain ever!"
                case is=4
                    dprint crew(who).n &" explains that he never earned as much money as here."
                case is=5
                    dprint crew(who).n &" is certain the next thing we are going to find is going to be an artifact or something else equally cool!"
            end select
            endif
    end select
    return 0
end function

function acomp_table() as string
    return "<center>"&get_death & "<br>" & text_to_html(mission_type) &"</center><br><table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& "><tbody><tr width=50%><td>"&exploration_text_html  & text_to_html(money_text) &"</td><td>" & income_expenses_html &"</td></tr></tbody></table>"
end function

function planet_artifacts_table() as string
    dim t as string
    dim as byte unflags(lastspecial)
    make_unflags(unflags())
    t="<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)&">"
    t=t &"<div>" &uniques_html(unflags()) &"</div>"
    t=t &"</td><td valign=" &chr(34)& "top" &chr(34)&">"
    t=t &"<div>" &artifacts_html(artflag()) &"</div>"
    t= t &"</td></tr><tbody></table>"
    return t
end function


function income_expenses_html() as string
    dim t as string
    dim as string desig(mt_last)
    dim as short per(mt_last),l
    dim as integer i,ex
    desig(mt_startcash)="Cash:"
    desig(mt_bonus)="Corp boni:"
    desig(mt_quest)="Corp contracts:"
    desig(mt_pirates)="Pirate bounties:"
    desig(mt_ress)="Resources:"
    desig(mt_bio)="Biodata:"
    desig(mt_map)="Mapping:"
    desig(mt_ano)="Anomalies:"
    desig(mt_trading)="Trading:"
    desig(mt_towed)="Towing:"
    desig(mt_escorting)="Escorting:"
    desig(mt_artifacts)="Artifacts:"
    desig(mt_blackmail)="Blackmail:"
    desig(mt_piracy)="Piracy:"
    desig(mt_gambling)="Gambling:"
    desig(mt_quest2)="Errands:"
    desig(mt_last)="Total:"
    income(mt_last)=0
    for i=0 to mt_last-1
        income(mt_last)+=income(i)
    next
    income(mt_last)+=shares_value
    for i=0 to mt_last-1
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(shares_value/income(mt_last)*100)
    l=l+7
    t="<table><tbody><tr><td>"& html_color("#ffffff") &"Income:</span></td><td></td></tr>"
    i=0

    if income(i)>0 then t=t &"<tr><td>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right>" & html_color("#00ff00")&credits(income(i))&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(i)& "%)</span></div></td></tr>"
    if shares_value>0 then t=t &"<tr><td>"& html_color("#ffffff") &"Stock:</span></td><td align=right>" & html_color("#00ff00")&credits(shares_value)&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(mt_last)& "%)</span></div></td></tr>"

    for i=1 to mt_last-1
        if income(i)>0 then t=t &"<tr><td>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right>" & html_color("#00ff00")&credits(income(i))&" Cr.</span></td><td>"& html_color("#00ff00")&"(" &per(i)& "%)</span></div></td></tr>"
    next
    t=t &"<tr><td><br>"& html_color("#ffffff") &desig(i) &"</span></td><td align=right><br>" & html_color("#00ff00")&credits(income(i))&" Cr.</div></td></tr>"

    ex=player.money-income(mt_last)
    t=t &"<tr><td><br>" & html_color("#ffffff") & "Expenses:</span> </td><td align=right><br>"& html_color("#ff0000") & credits(ex)& " Cr.</span></td></td><td></tr>"
    t=t &"<tr><td><br>" & html_color("#ffffff") & "Revenue:</span></td><td align=right><br>" & html_color("#00ff00")&credits(player.money) &" Cr.</span></td></td><td></tr>"
    t=t &"</tbody></table><br>Equipment value: "& html_color("#00ff00")&credits(equipment_value)&" Cr.</span>"

    return t
end function


function income_expenses() as string
    dim text as string
    dim as string desig(mt_last)
    dim as short per(mt_last),l
    dim as integer i,ex
    desig(mt_startcash)="Cash:"
    desig(mt_bonus)="Corp boni:"
    desig(mt_quest)="Corp contracts:"
    desig(mt_pirates)="Pirate bounties:"
    desig(mt_ress)="Resources:"
    desig(mt_bio)="Biodata:"
    desig(mt_map)="Mapping:"
    desig(mt_ano)="Anomalies:"
    desig(mt_trading)="Trading:"
    desig(mt_towed)="Towing:"
    desig(mt_escorting)="Escorting:"
    desig(mt_artifacts)="Artifacts:"
    desig(mt_blackmail)="Blackmail:"
    desig(mt_piracy)="Piracy:"
    desig(mt_gambling)="Gambling:"
    desig(mt_quest2)="Errands:"
    desig(mt_last)="Total:"
    income(mt_last)=0
    for i=0 to mt_last-1
        income(mt_last)+=income(i)
    next
    income(mt_last)+=shares_value()
    for i=0 to mt_last
        per(i)=int((income(i)/income(mt_last))*100)
        if len(desig(i)&credits(income(i)))>l then l=len(desig(i)&credits(income(i)))
    next
    per(mt_last)=int(shares_value/income(mt_last)*100)
    l=l+7
    text="{15}Income:|"
    if shares_value>0 then text=text &"  {11}"&"Stock" &space(l-len(credits(shares_value))-len("Stock"))&"{" & c_gre &  "}"&credits(shares_value) & " Cr. (" &per(mt_last)& "%)|"

    for i=0 to mt_last-1
        if income(i)>0 then text=text &"  {11}"&desig(i) &space(l-len(desig(i))-len(credits(income(i))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr. (" &per(i)& "%)|"
    next
    text=text &"|  {11}"&desig(mt_last) &space(l-len(desig(mt_last))-len(credits(income(mt_last))))&"{" & c_gre &  "}"&credits(income(i)) & " Cr.|"
    ex=player.money-income(mt_last)
    text=text &"|{15}Expenses:|  {"&c_red & "}" & space(l-len(credits(ex)))&credits(ex)&_
    " Cr.|{15}Revenue:|  "&space(l-len(credits(player.money))) &"{11}"&credits(player.money) &" Cr."

    return text
end function

function money_text() as string
    dim text as string
    dim as short b,a

    text=text & " | "
    for a=1 to st_last-1
        piratekills(0)+=piratekills(a)
    next
    if piratekills(0)=0 then
        text=text &"Did not win any space battles"
    else
        text=text &"Fought "&piratekills(0) &" space battles:|"
        for a=1 to st_last-1
            if piratekills(a)=1 then text=text & "Won a battle against "&add_a_or_an(piratenames(a),0) &"s|"
            if piratekills(a)>1 then text=text & "Won " &piratekills(a)& " battles against "&piratenames(a) &"s|"
        next
    endif
'    if player.piratekills>0 then
'    if player.piratekills>0 then
'        if player.piratekills>0 and player.money>0 then per(2)=100*(player.piratekills/player.money)
'        if per(2)>100 then per(2)=100
'        text=text &" {10}"& credits(player.piratekills) & " {11} Credits were from bountys for destroyed pirate ships (" &per(2) &")"
'    else
'        text=Text & "No Pirate ships were destroyed"
'    endif

    text=text & " | "

    if piratebase(0)=-1 then
        text =text & "Destroyed the Pirates base of operation! |"
    endif
    b=0
    for a=1 to _NoPB
        if piratebase(a)=-1 then b=b+1
    next
    if b=1 then
        text=text & " Destroyed a pirate outpost. |"
    endif
    if b>1 then
        text=text & " Destroyed " & b &" pirate outposts. |"
    endif

        'if faction(0).war(1)<=0 then text=text & "Made all money with honest hard work"
        'if player.merchant_agr>0 and player.pirate_agr<50 then text = text & "Found piracy not to be worth the hassle"
        'if player.pirate_agr<=0 and player.merchant_agr>50 then text = text & "Made a name as a bloodthirsty pirate"
    text=text &" |"
    return text
end function

function make_unflags(unflags() as byte) as short
    dim as short a,debug,foundspec
    for a=0 to lastspecial
        if specialplanet(a)>0 and specialplanet(a)<=lastplanet then
            if planets(specialplanet(a)).mapstat>0 or (debug=1 and _debug=1) then
                unflags(a)=1
                foundspec=1
            endif
        endif
    next
    return foundspec
end function

function uniques_html(unflags() as byte) as string
    dim t as string
    dim as short a,platforms,none


    t= html_color("#ffffff") &"Unique planets discovered:</span><br>"& html_color("#00ffff")

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        t=t &"A colony under the control of an alien lifeform<br>"
                    else
                        t=t & spdescr(a) &"<br>"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then t=t & spdescr(a) &"<br>"
                end select
        endif
    next
    if platforms>1 then t=t & platforms &" ancient refueling platforms<br>"
    if platforms=1 then t=t & "An ancient refueling platform<br>"
    if none=0 then t=t & html_color("#ffff00")&"None</span><br>"

    return t
end function

function uniques(unflags() as byte) as string
    dim text as string
    dim as short a,platforms,none


    text= "{15}Unique planets discovered:{11}|"

    for a=0 to lastspecial
        if unflags(a)=1 then
                none=1
                select case a
                case is =20
                    if specialflag(20)=1 then
                        text=text &"A colony under the control of an alien lifeform|"
                    else
                        text=text & spdescr(a) &"|"
                    endif
                case 21 to 25
                    platforms+=1
                case else
                    if spdescr(a)<>"" then text=text & spdescr(a) &"|"
                end select
        endif
    next
    if platforms>1 then text=text & platforms &" ancient refueling platforms"
    if platforms=1 then text=text & "An ancient refueling platform"
    if none=0 then text=text &"      {14} None"
    text=text &"|"
    return text
end function

function artifacts_html(artflags() as short) as string
    dim as short a,c
    dim flagst(22) as string
    dim as short hd,sd,ar,ss,bombs,cd,td
    flagst(1)="Fuel System"
    flagst(2)=" hand disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" ship disintegrator"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" cryochamber"
    'flagst(9)="Teleportation device"
    flagst(10)="Air recycler"
    flagst(11)="Data crystal(s)"
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    '14 Ancient bomb
    '15 Cloaking device
    flagst(16)="Wormhole navigation device"
    flagst(17)="Piloting AI"
    flagst(18)="Gunner AI"
    flagst(19)="Science AI"
    flagst(20)="Medical AI"
    flagst(21)="Neutronium armor"
    flagst(22)="Quantum warhead"
    set__color( 15,0)
    for a=0 to 5
        if instr(player.weapons(a).desig,"Disintegrator")>0 then sd+=1
    next
    for a=0 to lastitem
        if item(a).w.s=-1 then
            if (item(a).id=97 or item(a).id=197 or item(a).id=198 or item(a).id=199 or item(a).id=200) then hd+=1
            if (item(a).id=98 or item(a).id=298 or item(a).id=299) then ar+=1
            if item(a).id=523 or item(a).id=623 or item(a).id=624 then ss+=1
            if item(a).id=301 then bombs+=1
            if item(a).id=87 then CD+=1
            if item(a).ty=88 then td+=1
        endif
    next
    flagst(0)=html_color("#ffffff") &"Artifacts:</span><br>"& html_color("#00ffff")
    for a=1 to 22
        if artflag(a)>0 then
            if a=2 or a=4 or a=8 or a=14 or a=15 or a=5 then

                if a=8 then
                    if player.cryo=1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"<br>"
                    if player.cryo>1 then flagst(0)=flagst(0) & player.cryo & flagst(a)&"<br>"
                endif
            else
                c=c+1
                flagst(0)=flagst(0) &flagst(a) &"<br>"
            endif
        endif
    next
    if c=0 and sd=0 and hd=0 and ar=0 and ss=0 and bombs=0 and CD=0 and player.cryo=0 then
        flagst(0)=flagst(0) & html_color("#ffff00")&"None</span><br>"
    endif

    if sd>1 then flagst(0)=flagst(0) &sd &" ship disintegrators<br>"
    if sd=1 then flagst(0)=flagst(0) &sd &" ship disintegrator<br>"
    if hd>1 then flagst(0)=flagst(0) & hd &" portable disintegrators<br>"
    if hd=1 then flagst(0)=flagst(0) & hd &" portable disintegrator<br>"
    if ar=1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmor<br>"
    if ar>1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmors<br>"
    if ss=1 then flagst(0)=flagst(0) & ss &" squid-suit<br>"
    if ss>1 then flagst(0)=flagst(0) & ss &" squid-suits<br>"
    if bombs=1 then flagst(0)=flagst(0) & bombs &" ancient bomb<br>"
    if bombs>1 then flagst(0)=flagst(0) & bombs &" ancient bombs<br>"
    if CD>0 then flagst(0)=flagst(0) &"cloaking device<br>"
    if td=1 then flagst(0)=flagst(0)&"teleport device<br>"
    if td>1 then flagst(0)=flagst(0)&td &" teleport devices<br>"
    if reward(4)>0 then flagst(0)=flagst(0) & reward(4) &" unidentified artifacts<br></span>."
    return flagst(0)
end function

function list_artifacts(artflags() as short) as string
    dim as short a,c
    dim flagst(25) as string
    dim as short td,hd,sd,ar,ss,bombs,cd
    flagst(1)="Fuel System"
    flagst(2)=" hand disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" ship disintegrator"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" cryochamber"
    'flagst(9)="Teleportation device"
    flagst(10)="Air recycler"
    flagst(11)="Data crystal(s)"
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    '14 Ancient bomb
    '15 Cloaking device
    flagst(16)="Wormhole navigation device"
    flagst(17)="Piloting AI"
    flagst(18)="Gunner AI"
    flagst(19)="Science AI"
    flagst(20)="Medical AI"
    flagst(21)="Neutronium armor"
    flagst(22)="Quantum warhead"
    flagst(23)="Repair-nanobots"
    flagst(24)="Ammo teleportation device"
    flagst(25)="Wormhole generator"
    set__color( 15,0)
    for a=0 to 5
        if instr(player.weapons(a).desig,"Disintegrator")>0 then sd+=1
    next
    for a=0 to lastitem
        if item(a).w.s=-1 then
            if (item(a).id=97 or item(a).id=197 or item(a).id=198 or item(a).id=199 or item(a).id=200) then hd+=1
            if (item(a).id=98 or item(a).id=298 or item(a).id=299) then ar+=1
            if item(a).id=523 or item(a).id=623 or item(a).id=624 then ss+=1
            if item(a).id=301 then bombs+=1
            if item(a).id=87 then CD+=1
            if item(a).id=3003 then TD+=1
        endif
    next
    for a=1 to 22
        if artflag(a)>0 then
            if a=2 or a=4 or a=8 or a=14 or a=15 or a=5 then

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
    if c=0 and sd=0 and hd=0 and ar=0 and ss=0 and bombs=0 and CD=0 and TD=0 and player.cryo=0 then
        flagst(0)=flagst(0) &"      {14} None |"
    endif

    flagst(0)="{15}Alien Artifacts {11}|"&flagst(0)
    if sd>1 then flagst(0)=flagst(0) &sd &" ship disintegrators|"
    if sd=1 then flagst(0)=flagst(0) &sd &" ship disintegrator|"
    if hd>1 then flagst(0)=flagst(0) & hd &" portable disintegrators|"
    if hd=1 then flagst(0)=flagst(0) & hd &" portable disintegrator|"
    if ar=1 then flagst(0)=flagst(0) & ar &" adaptive bodyarmor|"
    if ar>1 then flagst(0)=flagst(0) & ar &" sets of adaptive bodyarmor|"
    if ss=1 then flagst(0)=flagst(0) & ss &" squid-suit|"
    if ss>1 then flagst(0)=flagst(0) & ss &" squid-suits|"
    if bombs=1 then flagst(0)=flagst(0) & bombs &" ancient bomb|"
    if bombs>1 then flagst(0)=flagst(0) & bombs &" ancient bombs|"
    if CD=1 then flagst(0)=flagst(0) &"Cloaking device|"
    if CD>1 then flagst(0)=flagst(0) &"Cloaking devices|"
    if TD=1 then flagst(0)=flagst(0) &"Teleportation device|"
    if TD>1 then flagst(0)=flagst(0) &TD &" Teleportation devices|"
    
    if reward(4)>0 then flagst(0)=flagst(0) & reward(4) &" unidentified artifacts."
    if _debug>0 then flagst(0)=flagst(0)&td &":"&cd &":"& bombs &":"&ss &":"&ar &":"& hd &":"&sd
    return flagst(0)
end function

function first_lc(t as string) as string
    return lcase(left(t,1))&right(t,len(t)-1)
end function

function first_uc(t as string) as string
    return Ucase(left(t,1))&right(t,len(t)-1)
end function

function exploration_text_html() as string
    return text_to_html(exploration_text)
end function

function items_table() as string
    dim as string t
    dim as _items inv(1024)
    dim as short invn(1024),lastitem,i,d,c
    lastitem=get_item_list(inv(),invn())
    d=cint((lastitem+1)/3)

    t=t &"<table width=" &chr(34) &"80%"&chr(34)& " align=" &chr(34) &"center"&chr(34)& "><tbody><tr><td valign=" &chr(34)& "top" &chr(34)& ">"
    t=t &"<td valign=" &chr(34)& "top" &chr(34)&"><div>"& html_color("#00ffff")
    c=1
    for i=1 to lastitem
        if inv(i).desig<>"" then
            select case invn(i)
            case is>1
                t=t &"&nbsp;"&invn(i)&" "&inv(i).desigp &"<br>"
            case is=1
                t=t &"&nbsp;"&inv(i).desig &"<br>"
            case is<1
                t=t & html_color("#ffffff") &inv(i).desig &"</span>"& html_color("#00ffff")&"<br>"
            end select

            if c>=d and invn(i)>0 then
                d=c
                c=1
                t=t &"</div></td><td valign=" &chr(34)& "top" &chr(34)&"><div>"& html_color("#00ffff")
            else
                c+=1
            endif
        endif
    next
    t=t &"</span></div></tbody></table>"


    return t
end function


function exploration_text() as string
    dim text as string
    dim as short a,b,c,xx,yy,exps,expp,expl,tp,total,per,visited,docked,alldockings,wormdis,wormtra
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
                if planets(map(a).planets(b)).visited>0 then visited+=1
            endif
        next
    next
    for c=0 to lastspecial
        if specialplanet(c)>=0 and specialplanet(c)<=lastplanet then
            if planets(specialplanet(c)).visited<>0 then discovered(c)=1
        endif
    next
    for c=laststar+1 to laststar+wormhole
        if map(c).discovered>0 then wormdis+=1
        if map(c).planets(2)>0 and map(c).planets(3)=0 then
            wormtra+=1
            map(map(c).planets(1)).planets(3)=-1 'Dont count twice
        endif
    next

    text="{15}Exploration log:{11}|"& explored_percentage_string
    if exps=0 then text=text &"|Discovered no systems and mapped "
    if exps=1 then text=text &"|Discovered {15}" & exps & "{11} system ({15}" &int((exps/laststar)*100) & "%{11}) and mapped "
    if exps>1 and exps<laststar then text=text &"|Discovered {15}" & exps & "{11} systems ({15}" &int((exps/laststar)*100) & "%{11}) and mapped "
    if exps=laststar then text=text &"|Discovered all systems and mapped "

    if expp=0 then  text = text & "{15}none{11} of " &tp &" planets. ({15}" &explper &"{11} %) "
    if expp=1 then  text = text &"{15}"& expp & "{11} of " &tp &" planets. ({15}" &explper &" %{11}) "
    if expp>1 and expp<tp then  text = text &"{15}"& expp & "{11} of " &tp &" planets. ({15}" &explper &" %{11}) "
    if expp=tp then  text = text & expp & "{15}all{11} of " &tp &" planets. ({15}" &explper &" %{11}) "

    if wormdis=0 then text=text &"|Didn't discover any wormholes"
    if wormdis=1 then text=text &"|Discovered {15}a{11} wormhole"
    if wormdis>1 and wormdis<wormhole then text=text &"|Discovered {15}" & wormdis & "{11} wormholes"
    if wormdis=wormhole then text=text &"|Discovered {15}all{11} wormholes"
    if wormtra=0 then text = text &"."
    if wormdis=1 and wormtra=1 then text=text &" and travelled through {15}it{11}."
    if wormdis>1 and wormtra=1 then text=text &" and travelled through {15}one{11} of them."
    if wormdis>1 and wormtra>1 and wormtra<wormhole/2 then text=text &" and travelled through {15}" & wormtra & "{11} of them."
    if wormdis=wormhole and wormtra=wormhole/2 then text =text &" and travelled through {15}all{11} of them."
    text=text &"|"
    for c=0 to 3
        if basis(c).docked>0 then docked+=1
        alldockings+=basis(c).docked
    next

    if alldockings=0 then text=text &"|Never docked at a major space station"
    if docked=4 then text=text &"|Docked at all major space stations and helped establish a new one"
    if docked=3 then text=text &"|Docked at all major space stations"
    if docked>1 and docked<3 then text=text &"|Docked at "&docked &" major space stations"
    if docked=1 then text=text &"|Docked at a major space station"
    if alldockings=1 then text=text &" once."
    if alldockings>1 then text=text &" for a total of {15}"&alldockings &"{11} times."
    if ranoutoffuel=0 then text=text &"|Always had a full tank."
    if ranoutoffuel=1 then text=text &"|Forgot to fill up his spaceship that one time."
    if ranoutoffuel>1 then text=text &"|Ran out of fuel {15}" &ranoutoffuel & "{11} times."
    if visited=0 then text=text &"|Never set foot on an alien world."
    if visited=1 then text=text &"|Landed on {15}"&visited &"{11} planet."
    if visited>1 and visited<tp then text=text &"|Landed on {15}"&visited &"{11} planets."
    if visited=tp then text=text &"|Landed on every planet in the sector."
    text=text &"||The farthest expedition took the "&player.desig &" {15}"&farthestexpedition &"{11} parsec out from the nearest spacestation."
    
    b=0
    for a=0 to 25
        if discovered(a)=1 then b=b+1
    next
    if b=0 then
        text=text & "|No remarkable planets discovered."
    endif
    if b>0 then
        if b=1 then
            text=text & "|One remarkable planet discovered."
        else
            text=text & "|{15}"& b &"{11} remarkable planets discovered."
        endif
    endif

    text=text & " |Defeated "
    if player.alienkills=0 then text =text & "no aliens"
    if player.alienkills=1 then text =text & "{15}"&player.alienkills &"{11} alien."
    if player.alienkills>1 then text =text & "{15}"&player.alienkills &"{11} aliens."

    if player.deadredshirts=0 and player.dead=98 then text=text & " |Set new safety standards for space exploration by not losing a single crewmember."
    if player.deadredshirts=1 then text=text & " |{12}One{11} casualty among the crew."
    if player.deadredshirts>1 then text=text & " |{12}"& player.deadredshirts &"{11} casualties among the crew."
    return text
end function

function mission_type() as string
    dim text as string
    dim per(5) as uinteger
    dim as uinteger i,h,highest

    per(0)=income(mt_ress)+income(mt_bio)+income(mt_map)+income(mt_ano)+income(mt_artifacts)
    per(1)=income(mt_trading)+income(mt_quest)+income(mt_bonus)+income(mt_escorting)+income(mt_towed)
    per(2)=income(mt_pirates)
    per(3)=income(mt_piracy)+income(mt_blackmail)
    per(4)=income(mt_quest)+income(mt_quest2)+income(mt_escorting)
    per(5)=income(mt_gambling)
    text= "{15}Mission type: {11}"
    for i=0 to 5
        if per(i)>highest then
            highest=per(i)
            h=i
        endif
    next
    if h=0 then text &="Explorer|"
    if h=1 then text &="Merchant|"
    if h=2 then text &="Pirate hunter|"
    if h=3 then text &="Pirate|"
    if h=4 then text &="Errand boy|"
    if h=5 then text &="Gambler|"

    return text
end function


function shipstatsblock() as string
    dim t as string
    dim as short c,a,mjs
    c=10
    if player.hull<(player.h_maxhull+player.addhull)/2 then c= 14
    if player.hull<2 then c=12
    t= "{15}Hullpoints"
    if player.armortype=1 then t=t &"(Standard)"
    if player.armortype=2 then t=t &"(Laminate)"
    if player.armortype=3 then t=t &"(Nanocomposite)"
    if player.armortype=4 then t=t &"(Diamanoid)"
    if player.armortype=5 then t=t &"(Neutronium)"
    t=t &"|(max :{11}"&max_hull(player)&"{15}):{"&c &"}" & player.hull
    if player.shieldmax>0 then
        t=t &"|{15}Shieldgenerator:{11}"&player.shieldmax & "{15}"
    else
        t=t &"|{15}Shieldgenerator:{11} None{15}"
    endif
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
        t=t &"{12}-"
    else
        t=t &player.pilot(0)
    endif
    t=t & "{15} | Gunner  :{11}"
    if player.gunner(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.gunner(0)
    endif
    t=t & "{15} | Science :{11}"
    if player.science(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.science(0)
    endif
    t=t & "{15} | Doctor  :{11}"
    if player.doctor(0)<=0 then
        t=t &"{12}-"
    else
        t=t &player.doctor(0)
    endif
    t = t & "{15} || Total bunks:{11}"&player.h_maxcrew+player.crewpod
    if player.cryo>0 then t=t &"{15}| Cryo Chambers:{11}"&player.cryo
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

function add_a_or_an(t as string,beginning as short) as string
    dim as short i
    dim as string t2,t3
    t=lcase(t)
    i=asc(t,1)
    t2=ucase(chr(i))
    if beginning=1 then
        if t2="A" or t2="I" or t2="E" or t2="O" or t2="U" then
            t3="An"
        else
            t3="A"
        endif
    else
        if t2="A" or t2="I" or t2="E" or t2="O" or t2="U" then
            t3="an"
        else
            t3="a"
        endif
    endif
    return t3 &" "&t
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
    dim as single mpy,pmoney
    dim as short i,allsum,rent

    for i=1 to 7
        allsum+=alliance(i)
    next

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
        t=t &"|You board the next ship back to civilization, and arrive back home with "&credits(player.money) &" Credits."
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
                t=t &" Your second carreer after being an explorer turns out to be that of an industrial designer."
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
            if retirementassets(0)=1 then t=t &" |You sell your well going Mudds store franchise." 'Muds Store
            if retirementassets(0)>1 then t=t &" |You sell your well going Mudds store franchises." 'Muds Store
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
        if rnd_range(1,100)<66-allsum*10 then
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
        if allsum>0 then
            if rnd_range(1,100)<allsum*20 then
                t=t &" The alliance you brokered holds and is successful at keeping the robot ships in check.|"
            else
                t=t &" The alliance you helped form just isn't big enough to keep the robot ships in check.|"
            endif
        endif
        if rnd_range(1,100)<66 then
            t=t &" | During all this, there are more and more reports of mysterious robot ships"_
            &" attacking explorers, settlers and traders in the sector of space you helped to"_
            &" explore. |Finally the stations are abandoned. "_
            &"|Mankind seems to come to the conclusion that the exploration of space is too "_
            &"dangerous. New expeditions are cancelled, the current holds of humanity fortified. "_
            &"After taking a bloody nose, humans decide to hole up, in case something dangerous is out there."
        else
            t=t &" | You pay little attention to news that come out of the sector where you earned your riches. "_
            &" That changes when SHI announces that they managed to control a type of automated alien scoutships, that was a threat to exploration and commerce in the sector before."_
            &" Automated exploration becomes standard, and much safer for humans, but you are too old to be part of this new adventure."
        endif
        t=t &" ||And you finally pass on to the next adventure, one you will never return from."
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
        if landless>=5 then t=t &"|You are a rich, powerful duke. What you say is law in your community. And that community is pretty large. Nobody can oppose you politically or economically"
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
