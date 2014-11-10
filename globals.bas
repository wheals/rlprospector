function set_globals() as short
    dim as short a,b,c,d,f        
    dim as string text
    '
    ' Variables
    '
    
    wage=10
    
    for a=0 to 5
        companystats(a).capital=25000
        companystats(a).profit=0
        companystats(a).rate=0
        companystats(a).shares=50
    next
    
    bountyquestreason(1)="for repeated acts of piracy."
    bountyquestreason(2)="for damaging company property."
    bountyquestreason(3)="for repeated acts of piracy."
    bountyquestreason(4)="since she has become dangerously close to discover one of our bases."
    bountyquestreason(5)="because she has shown no mercy in spacecombat and shall be afforded none."
    bountyquestreason(6)=". She is the most dangerous pirate hunter out there at this time and must be dealt with."
    
    shopname(1) ="Explorers Gear"
    shopname(2) ="Cheap Chunks"
    shopname(3) ="Space'n'Stuff"
    shopname(4) ="YeOlde Weapons Locker"
    
    shipyardname(sy_military)="SHI Vessels Division ltd."
    shipyardname(sy_civil)="Eridiani Exploratory Craft ltd."
    shipyardname(sy_pirates)="Lost and Found"
    shipyardname(sy_blackmarket)="LeOfInCo ltd."'Leago of independant contractors
    
    moduleshopname(ms_energy)="OBE High Energy Research Lab"
    moduleshopname(ms_projectile)="SHI Weapons Division ltd."
    moduleshopname(ms_modules)="Triax Ship-Accesoirs"
    
    ammotypename(0)="Kinetic projectile"
    ammotypename(1)="Explosive shell"
    ammotypename(2)="Fission Warhead"
    ammotypename(3)="Fusion Warhead"
    ammotypename(4)="Quantum Warhead"
    
    awayteamcomp(0)=1
    awayteamcomp(1)=1
    awayteamcomp(2)=1
    awayteamcomp(3)=1
    awayteamcomp(4)=1
    
    piratenames(ST_PFighter)="pirate fighter"                  
    piratenames(ST_PCruiser)="pirate cruiser"                  
    piratenames(ST_PDestroyer)="pirate destroyer" 
    piratenames(ST_PBattleship)="pirate battleship"
    piratenames(ST_lighttransport)="light transport"                 
    piratenames(ST_heavytransport)="heavy transport"                 
    piratenames(ST_merchantman)="merchantman"                 
    piratenames(ST_armedmerchant)="armed merchantman"                 
    piratenames(ST_CFighter)="company fighter"                         
    piratenames(ST_CEscort)="company escort"                          
    piratenames(ST_Cbattleship)="company battleship"                         
    piratenames(ST_AnneBonny)="Anne Bonny"                      
    piratenames(ST_BlackCorsair)="Black Corsair"                   
    piratenames(st_hussar)="Hussar"
    piratenames(st_blackwidow)="Black Widow"
    piratenames(st_adder)="Adder"
    piratenames(ST_AlienScoutShip)="ancient alien scoutship"              
    piratenames(ST_spacespider)="space spider"                  
    piratenames(ST_livingsphere)="living sphere"                   
    piratenames(ST_hydrogenworm)="hydrogen worm"   
    piratenames(ST_livingplasma)="living plasma"
    piratenames(ST_starjellyfish)="star jellyfish"        
    piratenames(ST_cloudshark)="cloudshark"         
    piratenames(ST_Gasbubble)="gas bubble"
    piratenames(ST_cloud)="symbiotic cloud"
    piratenames(ST_Floater)="floater"
    piratenames(st_spacestation)="space station"
    
    tacdes(1)="reckless" '-2
    tacdes(2)="agressive" '-1
    tacdes(3)="neutral" '0
    tacdes(4)="cautious" '1
    tacdes(5)="defensive" '2
    tacdes(6)="nonlethal" '3
    
    questguyjob(1)="Station Commander"
    questguyjob(2)="Freelancer"
    questguyjob(3)="Security"
    questguyjob(4)="Science Officer"
    questguyjob(5)="Gunner"
    questguyjob(6)="Doctor"
    questguyjob(7)="Merchant"
    questguyjob(8)="Colonist"
    questguyjob(9)="Tourist"
    questguyjob(10)="Megacorp rep for EE"
    questguyjob(11)="Megacorp rep for SHI"
    questguyjob(12)="Megacorp rep for TT"
    questguyjob(13)="Megacorp rep for OBE"
    questguyjob(14)="Entertainer"
    questguyjob(15)="Xenobiologist"
    questguyjob(16)="Astrophysicist"
    questguyjob(17)="Engineer"
'    qt_EI'1
'    qt_autograph'3
'    qt_outloan'4
'    qt_stationimp'5
'    qt_drug'6
'    qt_souvenir'7
'    qt_tools'8
'    qt_showconcept'9
'    qt_stationsensor'10
'    qt_alibi'11
'    qt_message'12
'    qt_locofpirates'!3
'    qt_locofspecial'14
'    qt_locofgarden'15
'    qt_locofperson'16
'    qt_goodpaying'17
'    qt_research'18
'    qt_megacorp'19
'    qt_biodata'20
'    qt_anomaly'21
'    qt_juryrig'22
'
    standardphrase(sp_greetfriendly,0)="Hello! Glad to meet you!"
    standardphrase(sp_greetfriendly,1)="Greetings! How do you do?"
    standardphrase(sp_greetfriendly,2)="How do you do? Happy to see you!"
    standardphrase(sp_greetneutral,0)="Hello. How can I help you?"
    standardphrase(sp_greetneutral,1)="Hi. Everything OK?"
    standardphrase(sp_greetneutral,2)="Erm. Can I help you?"
    standardphrase(sp_greethostile,0)="What do you want?"
    standardphrase(sp_greethostile,1)="What's up?"
    standardphrase(sp_greethostile,2)="Why do you disturb me?"
    standardphrase(sp_gotalibi,0)="I got you an alibi."
    standardphrase(sp_gotalibi,1)="I think I can help you with your problem."
    standardphrase(sp_gotalibi,2)="I think I found somebody who can vouch for you."    
    standardphrase(sp_gotmoney,0)="I have got your money."
    standardphrase(sp_gotmoney,1)="I met 1<CHAR>. He sends you your money."
    standardphrase(sp_gotmoney,2)="I got your money."
    standardphrase(sp_gotreport,0)="Of course I have information on <CORP>. I have this report here."
    standardphrase(sp_gotreport,1)="There is some interesting things in this report, if you know where to look."
    standardphrase(sp_gotreport,2)="This report should cover the things you are interested in."
    standardphrase(sp_cantpayback,0)="I would love to pay it back, but I can't at this time."
    standardphrase(sp_cantpayback,1)="Sorry. Don't have enough money to pay it back right now."
    standardphrase(sp_cantpayback,2)="Things haven't been easy lately. I am afraid I can't spare a single credit!"
       
    itemcat(0)="None"
    itemcat(1)="Transport"
    itemcat(2)="Ranged Weapons"
    itemcat(3)="Armor"
    itemcat(4)="Close combat weapons"
    itemcat(5)="Medical supplies"
    itemcat(6)="Grenades"
    itemcat(7)="Artwork"
    itemcat(8)="Resources"
    itemcat(9)="Equipment"
    itemcat(10)="Space ship equipment"
    itemcat(11)="Miscellaneous"
    
    companyname(1)="Eridiani Explorations"
    companyname(2)="Smith Heavy Industries"
    companyname(3)="Triax Traders"
    companyname(4)="Omega Bionegineering"
    companynameshort(1)="EE"
    companynameshort(2)="SHI"
    companynameshort(3)="TT"
    companynameshort(4)="OB"
    
    talent_desig(1)="Competent"
    talent_desc(1)="Competent: Is better suited to take over other officers jobs."
    talent_desig(2)="Haggler"
    talent_desc(2)="Haggler: Gets better prices at shops"
    talent_desig(3)="Confident"
    talent_desc(3)="Confident: Better chance to get company quests"
    talent_desig(4)="Charming"
    talent_desc(4)="Charming: Better morale for crewmembers"
    talent_desig(5)="Gambler"
    talent_desc(5)="Gambler: Better chance to win in the casino"
    talent_desig(6)="Merchant"
    talent_desc(6)="Merchant: Gets better prices when buying and selling cargo"
    
    talent_desig(7)="Evasion" 
    talent_desig(8)="High grav training"
    talent_desig(9)="Asteroid miner"
    talent_desc(7)="Evasion: Has a better chance to get away when fleeing from space battles"
    talent_desc(8)="High grav training: Has a better chance to land successfully"
    talent_desc(9)="Asteroid miner: Finds more ore in asteroids, and catches them easier"

    talent_desig(10)="Tactics expert"
    talent_desc(10)="Tactics expert: Increases effect from tactics setting"
    talent_desig(11)="Leadership"
    talent_desc(11)="Leadership: +1 on all to hit rolls for entire awayteam"
    talent_desig(12)="Ships weapons expert"
    talent_desc(12)="+1 to hit for ship weapons."
    talent_desig(13)="Improvise mines"
    talent_desc(13)="Improvise mines: Can turn a certain amount of ship fuel into jury rigged mines"
    
    talent_desig(14)="Linguist"
    talent_desig(15)="Biologist"
    talent_desig(16)="Sensor expert"
    talent_desc(14)="Linguist: Better chance to understand aliens"
    talent_desc(15)="Biologist: Better results from scanning plants and recording alien biodata"
    talent_desc(16)="Sensor expert: Is better at using sensors"    

    talent_desig(17)="Disease expert"
    talent_desig(18)="First aid expert"
    talent_desig(19)="Field medic"
    talent_desc(17)="Disease expert: Increased chance to cure diseases"
    talent_desc(18)="First aid expert: Better results from using medpacks"
    talent_desc(19)="Field medic: Higher regeneration rate"
    
    talent_desig(20)="Tough"
    talent_desig(21)="Defensive"
    talent_desig(22)="Close combat expert"
    talent_desig(23)="Sharp shooter"
    talent_desig(24)="Fast"
    talent_desig(25)="Strong"
    talent_desig(26)="Aim"
    
    talent_desc(20)="Tough: +1 to hitpoints"
    talent_desc(21)="Defensive: -1 on enemies to hit rolls"
    talent_desc(22)="Close combat expert: +1 to close combat to hit"
    talent_desc(23)="Sharpshooter: +.1 to ranged weapons damage"
    talent_desc(24)="Fast: Increased speed"
    talent_desc(25)="Strong: +.1 to close combat damage"
    talent_desc(26)="Aim: +1 to ranged weapons to hit"
    
    talent_desig(27)="Squad Leader"
    talent_desig(28)="Sniper"
    talent_desig(29)="Paramedic"
    
    species(1)="avian"
    species(2)="arachnide"
    species(3)="insect"
    species(4)="mammal"
    species(5)="reptile"
    species(6)="snake"
    species(7)="humanoid"
    species(8)="cephalopod"
    species(9)="centipede"
    species(10)="amphibian"
    species(11)="gastropod"
    species(12)="fish"

    
    crew_desig(1)="Captain"
    crew_desig(2)="Pilot"
    crew_desig(3)="Gunner"
    crew_desig(4)="Science"
    crew_desig(5)="Doctor"
    crew_desig(6)="Green"
    crew_desig(7)="Veteran"
    crew_desig(8)="Elite"
    crew_desig(9)="Insect Warrior"
    crew_desig(10)="Cephalopod"
    crew_desig(11)="Neodog"
    crew_desig(12)="Neoape"
    crew_desig(13)="Robot"
    crew_desig(14)="Squad Leader"
    crew_desig(15)="Sniper"
    crew_desig(16)="Paramedic"
    crew_desig(17)="Tree"
    crew_desig(18)="A.I."
    
    specialplanettext(1,0)="I got some strange sensor readings here sir. can't make any sense of it."
    specialplanettext(1,1)="The readings are gone. must have been that temple."
    specialplanettext(2,0)="There is a ruin of an anient city here, but I get no signs of life. Some high energy readings though."
    specialplanettext(2,1)="With the planetary defense systems disabled it is safe to land here."
    specialplanettext(3,0)="Ruins of buildings cover the whole planet, but I get no readings on life forms"
    specialplanettext(4,0)="Ruins of buildings cover the whole planet, but I get no readings on life forms"
    specialplanettext(5,0)="Readings indicate almost no water, and extremly high winds. Also very strong readings for lifeforms"
    specialplanettext(6,0)="The atmosphere of this planet is very peculiar. It only lets light in the UV range to the surface"
    specialplanettext(8,0)="Extremly high winds and severe lightning storms on this planet"
    specialplanettext(10,0)="There is a settlement on this planet. Humans."
    specialplanettext(10,1)="The colony sends us greetings."
    specialplanettext(11,0)="There is a ship here sending a distress signal."
    specialplanettext(11,1)="They are still sending a distress signal"
    specialplanettext(12,0)="I got some very strange sensor readings here sir. can't make any sense of it. They seem to come from a structure at the equator."
    specialplanettext(12,1)="The readings are gone. must have been that temple."
    specialplanettext(13,0)="There is a modified emergency beacon on this planet. It broadcasts this message: 'Visit Murchesons Ditch, best Entertainment this side of the coal sack nebula'"
    specialplanettext(14,0)="A human settlement dominates this planet. There is a big shipyard too."
    specialplanettext(15,0)="I am getting a high concentration of valuable ore here, but it seems to be underground. i can not pinpoint it."
    specialplanettext(15,1)="Nothing special about this  world."
    specialplanettext(16,0)="Mild climate, dense vegetation, atmosphere composition almost exactly like earth, gravity slightly lower. Shall we call this planet 'eden'?"
    specialplanettext(17,0)="There are signs of civilization on this planet. Technology seems to be similiar to mid 20th century earth. There are lots of factories with higly toxic emissions. The planet also seems to start suffering from a runaway greenhouse effect."
    specialplanettext(17,1)="It will still take several decades before the climate on this planet normalizes again."
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
    
    spdescr(0)="The destination of a generation ship"
    spdescr(1)="The home of an alien claiming to be a god"
    spdescr(2)="An alien city with working defense systems"
    spdescr(3)="An ancient city"
    spdescr(4)="Another ancient city"
    spdescr(5)="A world without water and huge sandworms"
    spdescr(6)="A world with invisible beasts"
    spdescr(8)="A world with very violent weather"
    spdescr(9)="An alien base still in good condition"
    spdescr(10)="An independent colony"
    spdescr(11)="A casino trying to cheat"
    spdescr(12)="The prison of an ancient entity"
    spdescr(13)="Murchesons Ditch"
    spdescr(14)="The blackmarket"
    spdescr(15)="A pirate gunrunner operation" 
    spdescr(16)="A planet with immortal beings" 
    spdescr(17)="A civilization upon entering the space age"
    spdescr(18)="The home planet of a civilization about to explore the stars"
    spdescr(19)="The outpost of an advanced civilization"
    spdescr(20)="A creepy colony"
    spdescr(21)="An ancient refueling platform"
    spdescr(22)="An ancient refueling platform"
    spdescr(23)="An ancient refueling platform"
    spdescr(24)="An ancient refueling platform"
    spdescr(25)="An ancient refueling platform"
    spdescr(26)="A crystal planet"
    spdescr(27)="A living planet"
    spdescr(28)="An ancient city with an intact spaceport"
    spdescr(29)="A very boring planet"
    spdescr(30)="The last outpost of an ancient race"
    spdescr(31)="An asteroid base of an ancient race"
    spdescr(32)="An asteroid base"
    spdescr(33)="Another asteroid base"
    spdescr(34)="A world devastated by war"
    spdescr(35)="A world populated by peaceful cephalopods"
    spdescr(36)="A tribe of small green people in trouble"
    spdescr(37)="An invisible labyrinth"
    spdescr(38)="A world with intelligent trees"
    spdescr(39)="A very fertile world plagued by burrowing monsters"
    spdescr(40)="A world under control of Eridiani Explorations"
    spdescr(41)="A world under control of Smith Heavy Industries"
    spdescr(42)="A world under control of Triax Traders"
    spdescr(43)="A world under control of Omega Bioengineering"
    spdescr(44)="The ruins of an ancient war"
    
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
    
    foundsomething=0
    
    '0=right,1=left
    
    bestaltdir(1,0)=4
    bestaltdir(1,1)=2
    
    bestaltdir(2,0)=1
    bestaltdir(2,1)=3
    
    bestaltdir(3,0)=2
    bestaltdir(3,1)=6
    
    bestaltdir(4,0)=7
    bestaltdir(4,1)=1
    
    bestaltdir(6,0)=3
    bestaltdir(6,1)=9
    
    bestaltdir(7,0)=8
    bestaltdir(7,1)=4
    
    bestaltdir(8,0)=9
    bestaltdir(8,1)=7
    
    bestaltdir(9,0)=6
    bestaltdir(9,1)=8
    
    
    spectraltype(1)=12
    spectraltype(2)=192
    spectraltype(3)=14
    spectraltype(4)=15
    spectraltype(5)=10
    spectraltype(6)=137
    spectraltype(7)=9
    spectraltype(8)=0
    spectraltype(9)=11
    spectraltype(10)=0
    
    
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
    spectralname(10)="rogue gasgiant"
    spectralshrt(10)="R"
    
    basis(0)=makecorp(0)
    basis(0).c.x=sm_x/2
    basis(0).c.y=sm_y/2
    basis(0).discovered=1
    
    basis(1)=makecorp(0)
    basis(1).c.x=10
    basis(1).c.y=sm_y-10
    basis(1).discovered=1
    
    basis(2)=makecorp(0)
    basis(2).c.x=sm_x-10
    basis(2).c.y=10
    basis(2).discovered=1
    
    basis(3)=makecorp(0)
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0
    
    combon(0).base=10 'Planets Landed on
    combon(1).base=5 'Aliens scanned
    combon(2).base=150 'Minerals turned in
    combon(3).base=5 'Only sells to Smith
    combon(4).base=5 'Only sells to Erdidani
    combon(5).base=5 'Only sells to Triax
    combon(6).base=5 'Only sells to omega
    combon(7).base=100 'Turns survived
    combon(8).base=5 'Pirate Ships destroyed
    
    baseprice(1)=100
    baseprice(2)=250
    baseprice(3)=500
    baseprice(4)=750
    baseprice(5)=1000
    baseprice(6)=500
    baseprice(7)=500
    baseprice(8)=500
    baseprice(9)=30
    
    for a=1 to 5
        avgprice(a)=baseprice(a)
    next
    
    goodsname(1)="Food"
    goodsname(2)="Basic Goods"
    goodsname(3)="Tech Goods"
    goodsname(4)="Luxury Goods"
    goodsname(5)="Weapon Parts"
    goodsname(6)="OBE Narcotics"
    goodsname(7)="SHI Hightech"
    goodsname(8)="EE Computers"
    goodsname(9)="Fuel"
    
    for a=0 to 12
        basis(a).inv(1).v=rnd_range(1,6)+4
        basis(a).inv(1).p=baseprice(1)
        
        basis(a).inv(2).v=rnd_range(1,7)+3
        basis(a).inv(2).p=baseprice(2)
        
        basis(a).inv(3).v=rnd_range(1,8)+2
        basis(a).inv(3).p=baseprice(3)
        
        basis(a).inv(4).v=rnd_range(1,8)+1
        basis(a).inv(4).p=baseprice(4)
        
        basis(a).inv(5).v=rnd_range(1,8)
        basis(a).inv(5).p=baseprice(5)
        
        basis(a).inv(6).p=baseprice(6)
        if  basis(a).company=4 then
            basis(a).inv(6).v=rnd_range(1,8)
        else
            basis(a).inv(6).v=0
        endif
        
        basis(a).inv(7).p=baseprice(7)
        if  basis(a).company=2 then
            basis(a).inv(7).v=rnd_range(1,8)
        else
            basis(a).inv(7).v=0
        endif
        
        basis(a).inv(8).p=baseprice(8)
        if  basis(a).company=1 then
            basis(a).inv(8).v=rnd_range(1,8)
        else
            basis(a).inv(8).v=0
        endif
        
        basis(a).inv(9).p=baseprice(9)
        basis(a).inv(9).v=5
    next
    
    for a=0 to 1024
        portal(a).ti_no=3001
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
        shiptypes(20)="small space station"
    else
        set__color( 14,0)
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
    
    load_dialog_quests
    
    for a=1 to 512
        tiles(a).no=a
        tiles(a).ti_no=100+a
    next
    
    tiles(243).ti_no=2500
    tiles(201).ti_no=2505
    tiles(202).ti_no=2501
    tiles(203).ti_no=2502
    tiles(204).ti_no=2503
    tiles(205).ti_no=2504
    tiles(199).ti_no=2509
    tiles(199).ti_no=2509
    tiles(199).ti_no=2509
    for a=1 to max_maps
        planets(a)=planets(0)
        planets(a).grav=1
    next
    for a=0 to 255
        dtextcol(a)=11
    next
    for a=0 to fix((22*_fh1)/_fh2)
        displaytext(a)=" "
    next
    
    player.desig=""
    
    return 0
end function
