function setglobals() as short
    dim as short a,b,c,d,f        
    dim as string text
    '
    ' Variables
    '
    
    wage=10
    
    for a=0 to 4
        companystats(a).capital=1000
        companystats(a).profit=0
        companystats(a).rate=0
        companystats(a).shares=100
    next
    
    awayteamcomp(0)=1
    awayteamcomp(1)=1
    awayteamcomp(2)=1
    awayteamcomp(3)=1
    awayteamcomp(4)=1
    
    tacdes(1)="reckless"
    tacdes(2)="agressive"
    tacdes(3)="neutral"
    tacdes(4)="cautious"
    tacdes(5)="defensive"
    
    talent_desig(1)="Competent"
    talent_desig(2)="Haggler"
    talent_desig(3)="Confident"
    talent_desig(4)="Charming"
    talent_desig(5)="Gambler"
    talent_desig(6)="Merchant"
    
    talent_desig(7)="Evasion" 
    talent_desig(8)="High grav training"
    talent_desig(9)="Asteroid miner"
    
    talent_desig(10)="Tactics expert"
    talent_desig(11)="Leadership"
    talent_desig(12)="Ships weapons expert"
    talent_desig(13)="Improvise mines"
    
    talent_desig(14)="Linguist"
    talent_desig(15)="Biologist"
    talent_desig(16)="Sensor expert"
    
    talent_desig(17)="Disease expert"
    talent_desig(18)="First aid expert"
    talent_desig(19)="Field medic"
    
    talent_desig(20)="Tough"
    talent_desig(21)="Defensive"
    talent_desig(22)="Close combat expert"
    talent_desig(23)="Sharp shooter"
    talent_desig(24)="Fast"
    talent_desig(25)="Strong"
    talent_desig(26)="Aim"
    
    talent_desig(27)="Squad Leader"
    talent_desig(28)="Sniper"
    talent_desig(29)="Paramedic"
    
    
    specialplanettext(1,0)="I got some strange sensor readings here sir. cant make any sense of it"
    specialplanettext(1,1)="The readings are gone. must have been that temple."
    specialplanettext(2,0)="There is a ruin of an anient city here, but i get no signs of life. Some high energy readings though."
    specialplanettext(2,1)="With the planetary defense systems disabled it is safe to land here."
    specialplanettext(3,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
    specialplanettext(4,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
    specialplanettext(5,0)="Readings indicate almost no water, and extremly high winds. Also very strong readings for lifeforms"
    specialplanettext(6,0)="The atmosphere of this planet is very peculiar. It only lets light in the UV range to the surface"
    specialplanettext(8,0)="Extremly high winds and severe lightning storms on this planet"
    specialplanettext(10,0)="There is a settlement on this planet. Humans."
    specialplanettext(10,1)="The colony sends us greetings."
    specialplanettext(11,0)="There is a ship here sending a distress signal."
    specialplanettext(11,1)="They are still sending a distress signal"
    specialplanettext(12,0)="This is a sight you get once in a lifetime. The orbit of this planet is unstable and it is about to plunge into its sun! Gravity is ripping open its surface, solar wind blasts its material into space. In a few hours it will be gone."
    specialplanettext(13,0)="There is a modified emergency beacon on this planet. It broadcasts this message: 'Visit Murchesons Ditch, best Entertainment this side of the coal sack nebula'"
    specialplanettext(14,0)="A human settlement dominates this planet. There is a big shipyard too."
    specialplanettext(15,0)="I am getting a high concentration of valuable ore here, but it seems to be underground. i can not pinpoint it."
    specialplanettext(15,1)="Nothing special about this  world."
    specialplanettext(16,0)="Mild climate, dense vegetation, atmosphere composition almost exactly like earth, gravity slightly lower. Shall we call this planet 'eden'?"
    specialplanettext(17,0)="There are signs of civilization on this planet. Technology seems to be similiar to mid 20th century earth. There are lots of factories with higly toxic emissions. The planet also seems to start suffering from a runaway greenhouse effect."
    specialplanettext(18,0)="There are several big building complexes on this planet. I also get the signatures of advanced energy sources."
    specialplanettext(19,0)="There are buildings on this planet and a big sensor array. Advanced technology, propably FTL capable." 
    specialplanettext(20,0)="There is a human colony on this planet."
    specialplanettext(20,1)="There is a human colony on this planet. Also some signs of beginning construction since we were last here."
    specialplanettext(26,0)="No water, but the mountains on this planet are high rising spires of crystal and quartz. This place is lifeless, but beautiful!"
    specialplanettext(27,0)="This small planet has no atmosphere. A huge and unusually deep crater dominates its surface."
    specialplanettext(27,1)="The Planetmonster is dead."
    specialplanettext(28,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
    specialplanettext(29,0)="This is the most boring piece of rock I ever saw. Just a featureless plain of stone."
    specialplanettext(30,0)="I don't know why, but this planet has a temperate climate now. There are signs of life and a huge structure on the western hemishpere."
    specialplanettext(30,1)="I don't know why, but this planet has a temperate climate now. There are signs of life and a huge structure on the western hemishpere."
    specialplanettext(31,0)="There is a perfectly spherical large asteroid here. 2km diameter it shows no signs of any impact craters and readings indicate a very high metal content"
    specialplanettext(32,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures."
    specialplanettext(33,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures. There are ships on the surface"
    specialplanettext(34,0)="I am getting very, very high radiaton readings for this planet. Landing here might be dangerous."
    specialplanettext(35,0)="This planets surface is covered completely in liquid."
    specialplanettext(37,0)="There is a huge lutetium deposit here."
    specialplanettext(39,0)="A beautiful world with a mild climate. Huge areas of cultivated land are visible, even from orbit, along with some small buildings."
    specialplanettext(40,0)="A beautiful world with a mild climate. There is one big artificial structure."
    specialplanettext(41,0)="There is a big asteroid with a landing pad and some buildings here."
    atmdes(1)="No"
    
    atmdes(2)="remnants of an"
    atmdes(3)="thin"
    atmdes(4)="earthlike"
    atmdes(5)="dense"
    atmdes(6)="very dense"
    
    atmdes(7)="remnants of an exotic"
    atmdes(8)="thin, exotic"
    atmdes(9)="exotic"
    atmdes(10)="dense, exotic"
    atmdes(11)="very dense, exotic"
    
    atmdes(12)="remnants of a corrosive"
    atmdes(13)="thin, corrosive"
    atmdes(14)="corrosive"
    atmdes(15)="dense, corrosive"
    atmdes(16)="very dense, corrosive"
    
    bestaltdir(1,0)=4
    bestaltdir(1,1)=2
    
    bestaltdir(2,0)=1
    bestaltdir(2,1)=3
    
    bestaltdir(3,0)=6
    bestaltdir(3,1)=2
    
    bestaltdir(4,0)=7
    bestaltdir(4,1)=1
    
    bestaltdir(6,0)=9
    bestaltdir(6,1)=3
    
    bestaltdir(7,0)=8
    bestaltdir(7,1)=4
    
    bestaltdir(8,0)=7
    bestaltdir(8,1)=9
    
    bestaltdir(9,0)=8
    bestaltdir(9,1)=6
    
    
    spectraltype(1)=12
    spectraltype(2)=192
    spectraltype(3)=14
    spectraltype(4)=15
    spectraltype(5)=10
    spectraltype(6)=137
    spectraltype(7)=9
    spectraltype(8)=0
    spectraltype(9)=11
    
    
    spectralname(1)="red sun (spectral class M)"
    spectralshrt(1)="M"
    spectralname(2)="orange sun (spectral class K)"
    spectralshrt(2)="K"
    spectralname(3)="yellow sun (spectral class G)"
    spectralshrt(3)="G"
    spectralname(4)="white sun (spectral class F)"
    spectralshrt(4)="F"
    spectralname(5)="green sun (spectral class A)"
    spectralshrt(5)="A"
    spectralname(6)="white giant (spectral class N)"
    spectralshrt(6)="N"
    spectralname(7)="blue giant (spectral class O)"
    spectralshrt(7)="O"
    spectralname(8)="a rogue planet"
    spectralshrt(8)="r"
    spectralname(9)="a wormhole"
    spectralshrt(9)="w"
    
    basis(0)=makecorp(0)
    basis(0).c.x=35
    basis(0).c.y=20
    basis(0).discovered=1
    
    basis(1)=makecorp(0)
    basis(1).c.x=10
    basis(1).c.y=30
    basis(1).discovered=1
    
    basis(2)=makecorp(0)
    basis(2).c.x=60
    basis(2).c.y=10
    basis(2).discovered=1
    
    basis(3)=makecorp(0)
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0
    
    baseprice(1)=50
    baseprice(2)=100
    baseprice(3)=250
    baseprice(4)=500
    baseprice(5)=1000
    baseprice(6)=500
    baseprice(7)=500
    baseprice(8)=500
    
    companyname(1)="Eridiani Explorations"
    companyname(2)="Smith Heavy Industries"
    companyname(3)="Triax Traders"
    companyname(4)="Omega Bionegineering"
    
    for a=1 to 5
        avgprice(a)=baseprice(a)
    next
    
    for a=0 to 12
        basis(a).inv(1).n="Food"
        basis(a).inv(1).v=rnd_range(1,6)+4
        basis(a).inv(1).p=baseprice(1)
        
        basis(a).inv(2).n="Basic Goods"
        basis(a).inv(2).v=rnd_range(1,7)+3
        basis(a).inv(2).p=baseprice(2)
        
        basis(a).inv(3).n="Tech Goods"
        basis(a).inv(3).v=rnd_range(1,8)+2
        basis(a).inv(3).p=baseprice(3)
        
        basis(a).inv(4).n="Luxury Goods"
        basis(a).inv(4).v=rnd_range(1,8)+1
        basis(a).inv(4).p=baseprice(4)
        
        basis(a).inv(5).n="Weapons"
        basis(a).inv(5).v=rnd_range(1,8)
        basis(a).inv(5).p=baseprice(5)
        
        basis(a).inv(6).n="Narcotics"
        basis(a).inv(6).p=baseprice(6)
        if  basis(a).company=4 then
            basis(a).inv(6).v=rnd_range(1,8)
        else
            basis(a).inv(6).v=0
        endif
        
        basis(a).inv(7).n="Hightech "
        basis(a).inv(7).p=baseprice(7)
        if  basis(a).company=2 then
            basis(a).inv(7).v=rnd_range(1,8)
        else
            basis(a).inv(7).v=0
        endif
        
        basis(a).inv(8).n="Computers"
        basis(a).inv(8).p=baseprice(8)
        if  basis(a).company=1 then
            basis(a).inv(8).v=rnd_range(1,8)
        else
            basis(a).inv(8).v=0
        endif
    next
    
    
    if fileexists("data/ships.csv") then
        f=freefile
        open "data/ships.csv" for input as #f
        b=1
        c=0
        for c=0 to 16
            line input #f,text
            shiptypes(c)=""
            do
                shiptypes(c)=shiptypes(c)&mid(text,b,1)
                b=b+1
            loop until mid(text,b,1)=";"
            b=1
        next
        close #f
        shiptypes(17)="alien vessel"
        shiptypes(18)="ancient alien scoutship. It's hull covered in tiny impact craters"
        shiptypes(19)="primitve alien spaceprobe, hundreds of years old travelling sublight through the void"
        shiptypes(20)="a small space station"
    else
        color 14,0
        print "ships.csv not found. Can't start game"
        sleep
        end
    endif
    
    disease(1).no=1
    disease(1).desig="gets a light cough"
    disease(1).ldesc="a light cough"
    disease(1).incubation=2
    disease(1).duration=3
    disease(1).contagio=5
    disease(1).cause="bacteria"
    disease(1).fatality=5
    disease(1).att=-1
    
    disease(2).no=2
    disease(2).desig="gets a heavy cough"
    disease(2).ldesc="a heavy cough"
    disease(2).incubation=3
    disease(2).duration=4
    disease(2).contagio=5
    disease(2).cause="viri"
    disease(2).fatality=5
    
    disease(3).no=3
    disease(3).desig="gets a fever and a light cough"
    disease(3).ldesc="a light cough and fever"
    disease(3).incubation=3
    disease(3).duration=5
    disease(3).contagio=10
    disease(3).cause="bacteria"
    disease(3).fatality=8
    
    
    disease(4).no=4
    disease(4).desig="gets a heavy fever and a light cough"
    disease(4).ldesc="a heavy cough and fever"
    disease(4).incubation=3
    disease(4).duration=6
    disease(4).contagio=10
    disease(4).cause="bacteria"
    disease(4).fatality=12
    
    disease(5).no=5
    disease(5).desig="gets a fever and starts shivering"
    disease(5).ldesc="a light fever and shivering"
    disease(5).incubation=3
    disease(5).duration=15
    disease(5).contagio=5
    disease(5).cause="viri"
    disease(5).fatality=15
    
    disease(6).no=6
    disease(6).desig="suddenly gets shivering and boils"
    disease(6).ldesc="shivering and boils"
    disease(6).incubation=1
    disease(6).duration=15
    disease(6).contagio=15
    disease(6).cause="microscopic parasitic lifeforms"
    disease(6).fatality=25
    
    disease(7).no=7
    disease(7).desig="gets muscle cramps"
    disease(7).ldesc="shivering and muscle cramps"
    disease(7).incubation=3
    disease(7).duration=15
    disease(7).contagio=15
    disease(7).cause="viri"
    disease(7).fatality=25
    disease(7).att=-4
    disease(7).oxy=4
    
    disease(8).no=8
    disease(8).desig="starts vomiting and coughing blood"
    disease(8).ldesc="vomiting and coughing of blood"
    disease(8).incubation=5
    disease(8).duration=15
    disease(8).contagio=15
    disease(8).cause="bacteria"
    disease(8).fatality=25
    
    disease(9).no=9
    disease(9).desig="suddenly turns blind"
    disease(9).ldesc="blindness"
    disease(9).incubation=5
    disease(9).duration=15
    disease(9).contagio=15
    disease(9).cause="bacteria"
    disease(9).fatality=5
    disease(9).bli=55
    
    disease(10).no=10
    disease(10).desig="has fever and suicidal thoughts"
    disease(10).ldesc="a strong fever, shivering and boils"
    disease(10).incubation=1
    disease(10).duration=15
    disease(10).contagio=15
    disease(10).cause="mircroscopic parasitic lifeforms"
    disease(10).fatality=5
    
    disease(11).no=11
    disease(11).desig="has a strong fever and balance impairment"
    disease(11).ldesc="a strong fever and balance impairment"
    disease(11).incubation=5
    disease(11).duration=15
    disease(11).contagio=15
    disease(11).cause="viri"
    disease(11).fatality=5
    disease(11).att=-7
    
    disease(12).no=12
    disease(12).desig="gets a rash"
    disease(12).ldesc="a rash caused"
    disease(12).incubation=2
    disease(12).duration=25
    disease(12).contagio=35
    disease(12).cause="bacteria"
    disease(12).fatality=5
    
    disease(13).no=13
    disease(13).desig="suffers from hallucinations"
    disease(13).ldesc="severe hallucinations"
    disease(13).incubation=1
    disease(13).duration=25
    disease(13).duration=45
    disease(13).cause="mircroscopic parasitic lifeforms"
    disease(13).fatality=5
    disease(13).hal=25
    
    disease(14).no=14
    disease(14).desig="starts falling asleep randomly"
    disease(14).ldesc="narcolepsy"
    disease(14).incubation=5
    disease(14).duration=255
    disease(14).contagio=25
    disease(14).cause="viri"
    disease(14).fatality=45
    disease(14).nac=45
    
    disease(15).no=15
    disease(15).desig="suddenly starts bleeding from eye sockets and mouth."
    disease(15).ldesc="bleeding from eye sockets, mouth, nose, ears and fingernails"
    disease(15).incubation=1
    disease(15).duration=3
    disease(15).contagio=40
    disease(15).cause="agressive bacteria"
    disease(15).fatality=65
    
    disease(16).no=16
    disease(16).desig="suffers from radiation sickness"
    disease(16).ldesc="radiation sickness"
    disease(16).incubation=0
    disease(16).duration=255
    disease(16).contagio=0
    disease(16).cause="radiation"
    disease(16).fatality=55
    
    disease(17).no=17
    disease(17).desig="gets a bland expression"
    disease(17).ldesc="a wierd brain disease"
    disease(17).incubation=5
    disease(17).duration=15
    disease(17).contagio=75
    disease(17).fatality=85
        
    for a=1 to 512
        tiles(a).no=a
        tiles(a).ti_no=100+a
    next
    
    for a=1 to max_maps
        planets(a)=planets(0)
        planets(a).grav=1
    next
    for a=0 to 255
        dtextcol(a)=11
    next
    for a=0 to fix((22*_fh1)/_fh2)
        displaytext(a)=""&a
    next
    return 0
end function
