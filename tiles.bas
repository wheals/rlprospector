for a=1 to 512
    tiles(a).movecost=1
next

tiles(1).tile=247
tiles(1).col=17
tiles(1).desc="shallow Water"
tiles(1).walktru=0
tiles(1).oxyuse=1
tiles(1).shootable=1
tiles(1).hp=50
tiles(1).dr=-1
tiles(1).succt="the liquid evaporates"
tiles(1).turnsinto=12
tiles(1).movecost=0

tiles(2).tile=247
tiles(2).col=1
tiles(2).bgcol=229
tiles(2).desc="deep Water"
tiles(2).walktru=1
tiles(2).shootable=1
tiles(2).hp=100
tiles(2).dr=-1
tiles(2).succt="the liquid evaporates"
tiles(2).turnsinto=1
tiles(2).movecost=0

tiles(3).tile=46
tiles(3).col=6
tiles(3).desc="Dirt"
tiles(3).shootable=1
tiles(3).dr=-1
tiles(3).hp=5
tiles(3).turnsinto=4
tiles(3).movecost=1

tiles(4).tile=46
tiles(4).col=7
tiles(4).desc="Rock"
tiles(4).movecost=1

tiles(5).tile=84
tiles(5).col=2
tiles(5).desc="Woods"
tiles(5).seetru=1
tiles(5).vege=1
tiles(5).shootable=1
tiles(5).dr=-1
tiles(5).hp=3
tiles(5).turnsinto=3
tiles(5).movecost=3

tiles(6).tile=84
tiles(6).col=10
tiles(6).bgcol=0
tiles(6).desc="Shrubs"
tiles(6).vege=1
tiles(6).shootable=1
tiles(6).dr=-1
tiles(6).hp=2
tiles(6).turnsinto=3
tiles(6).movecost=2

tiles(7).tile=94
tiles(7).col=215
tiles(7).bgcol=221
tiles(7).desc="High Mountains"
tiles(7).seetru=1
tiles(7).walktru=2
tiles(7).firetru=1
tiles(7).shootable=1
tiles(7).dr=100
tiles(7).hp=100
tiles(7).succt="You bore some tunnels."
tiles(7).turnsinto=244
tiles(7).movecost=5

tiles(8).tile=94
tiles(8).col=217
tiles(8).bgcol=221
tiles(8).desc="Mountains"
tiles(8).seetru=1
tiles(8).walktru=2
tiles(8).firetru=1
tiles(8).dr=100
tiles(8).shootable=1
tiles(8).hp=50
tiles(8).succt="You bore some tunnels."
tiles(8).turnsinto=244
tiles(8).movecost=4

tiles(9).tile=64
tiles(9).col=11
tiles(9).desc="a stranded ship"
tiles(9).survivors=33
tiles(9).resources=66
tiles(9).turnsinto=62
tiles(9).hides=2

tiles(10).tile=46
tiles(10).col=10
tiles(10).bgcol=0
tiles(10).desc="Grass"
tiles(10).vege=1
tiles(10).shootable=1
tiles(10).dr=-1
tiles(10).hp=2
tiles(10).turnsinto=3

tiles(11).tile=46
tiles(11).col=2
tiles(11).desc="Grass"
tiles(11).vege=1
tiles(11).shootable=1
tiles(11).dr=-1
tiles(11).hp=1
tiles(11).turnsinto=3

tiles(12).tile=46
tiles(12).col=14
tiles(12).desc="Sand"


tiles(13).tile=46
tiles(13).col=13
tiles(13).bgcol=0
tiles(13).desc="pink sand"
tiles(13).hides=2

tiles(14).tile=46
tiles(14).col=15
tiles(14).bgcol=0
tiles(14).desc="Ice"
tiles(14).shootable=1
tiles(14).dr=-1
tiles(14).hp=4
tiles(14).turnsinto=4
tiles(14).movecost=2

tiles(16).tile=35
tiles(16).col=7
tiles(16).desc="a building"
tiles(16).dr=4
tiles(16).shootable=1
tiles(16).hp=30
tiles(16).turnsinto=47
tiles(16).seetru=1
tiles(16).firetru=1
tiles(16).locked=2
tiles(16).hides=2
tiles(16).movecost=5

tiles(17).tile=67
tiles(17).col=11
tiles(17).desc="a computer"
tiles(17).turnsinto=84

tiles(18).tile=176
tiles(18).col=13
tiles(18).desc="forcefield"
tiles(18).firetru=1
tiles(18).dam=1
tiles(18).tohit=101
tiles(18).walktru=1
tiles(18).range=0
tiles(18).hitt="You get zapped by a forcefield"

tiles(20).tile=247
tiles(20).desc="acid"
tiles(20).col=243
tiles(20).oxyuse=1
tiles(20).tohit=10
tiles(20).dam=1
tiles(20).range=0
tiles(20).hitt="You get splashed with strong acids!"
tiles(20).shootable=1
tiles(20).hp=50
tiles(20).dr=-1
tiles(20).succt="the liquid evaporates"
tiles(20).turnsinto=13
tiles(20).movecost=0

tiles(21).tile=247
tiles(21).desc="deep acid"
tiles(21).col=245
tiles(21).bgcol=247
tiles(21).tohit=18
tiles(21).walktru=1
tiles(21).dam=1
tiles(21).range=0
tiles(21).hitt="You get splashed with strong acids!"
tiles(21).shootable=1
tiles(21).hp=100
tiles(21).dr=-1
tiles(21).succt="the liquid evaporates"
tiles(21).turnsinto=20
tiles(21).movecost=0

tiles(22).tile=asc(".")
tiles(22).desc="red grass"
tiles(22).col=150
tiles(22).vege=2
tiles(22).shootable=1
tiles(22).dr=-1
tiles(22).hp=1
tiles(22).turnsinto=3

tiles(23).tile=asc("T")
tiles(23).col=162
tiles(23).desc="exotic tree"
tiles(23).seetru=1
tiles(23).vege=4
tiles(23).shootable=1
tiles(23).dr=-1
tiles(23).hp=3
tiles(23).turnsinto=3
tiles(23).movecost=3

tiles(24).tile=asc("T")
tiles(24).col=156
tiles(24).desc="exotic bush"
tiles(24).vege=3
tiles(24).shootable=1
tiles(24).dr=-1
tiles(24).hp=2
tiles(24).turnsinto=3
tiles(24).movecost=2

tiles(25).tile=asc("T")
tiles(25).desc="exotic weeds"
tiles(25).col=150
tiles(25).seetru=1
tiles(25).vege=2
tiles(25).shootable=1
tiles(25).dr=-1
tiles(25).hp=2
tiles(25).turnsinto=3
tiles(25).movecost=2

tiles(26).tile=247
tiles(26).desc="amonnia pool"
tiles(26).col=11
tiles(26).oxyuse=1
tiles(26).tohit=10
tiles(26).dam=1
tiles(26).range=0
tiles(26).hitt="You get splashed with liquid ammonium!"
tiles(26).shootable=1
tiles(26).dr=-1
tiles(26).hp=20
tiles(26).succt="The ammonium evaporates"
tiles(26).turnsinto=4


tiles(27).tile=ASC("=")
tiles(27).desc="frozen water"
tiles(27).col=15
tiles(27).shootable=1
tiles(27).dr=-1
tiles(27).succt="You blast holes into the thick ice"
tiles(27).killt="You blast big holes into the thick ice"
tiles(27).hp=10
tiles(27).turnsinto=2
tiles(27).movecost=2

'Geysers
tiles(28).tile=147
tiles(28).col=137
tiles(28).desc="geyser"
tiles(28).tohit=30
tiles(28).dam=1
tiles(28).hitt="You get sprayed with boiling water!"
tiles(28).causeaeon=16
tiles(28).aetype=3
tiles(28).movecost=5

tiles(29).tile=147
tiles(29).col=56
tiles(29).desc="acid geyser"
tiles(29).tohit=60
tiles(29).dam=2
tiles(29).hitt="You get sprayed with boiling acid!"
tiles(29).causeaeon=8
tiles(29).aetype=4
tiles(29).movecost=5

tiles(30).tile=147
tiles(30).col=63
tiles(30).desc="ammonium geyser"
tiles(30).tohit=50
tiles(30).dam=1
tiles(30).hitt="You get sprayed with boiling ammonium!"
tiles(30).causeaeon=12
tiles(30).aetype=5
tiles(30).movecost=5

tiles(31).tile=186 '|
tiles(31).desc="Street"
tiles(31).col=15
tiles(31).movecost=0

tiles(32).tile=205 '-
tiles(32).desc="Street"
tiles(32).col=15
tiles(32).movecost=0

tiles(33).tile=206 '+
tiles(33).desc="Street"
tiles(33).col=15
tiles(33).movecost=0

tiles(34).tile=187
tiles(34).desc="Street"
tiles(34).col=15
tiles(34).movecost=0

tiles(35).tile=188
tiles(35).desc="Street"
tiles(35).col=15
tiles(35).movecost=0

tiles(36).tile=201
tiles(36).desc="Street"
tiles(36).col=15
tiles(36).movecost=0

tiles(37).tile=200
tiles(37).desc="Street"
tiles(37).col=15
tiles(37).movecost=0

tiles(38).tile=185
tiles(38).desc="Street"
tiles(38).col=15
tiles(38).movecost=0

tiles(39).tile=204
tiles(39).desc="Street"
tiles(39).col=15
tiles(39).movecost=0

tiles(40).tile=203
tiles(40).desc="Street"
tiles(40).col=15
tiles(40).movecost=0

tiles(41).tile=202
tiles(41).desc="Street"
tiles(41).col=15
tiles(41).movecost=0

tiles(42).tile=35
tiles(42).col=15
tiles(42).desc="Building"
tiles(42).seetru=1
tiles(42).firetru=1
tiles(42).gives=4
tiles(42).turnsinto=42
tiles(42).hides=2
tiles(42).movecost=5

tiles(43).tile=35
tiles(43).desc="Building"
tiles(43).col=15
tiles(43).seetru=1
tiles(43).firetru=1
tiles(43).gives=26
tiles(43).turnsinto=43
tiles(43).hides=2
tiles(43).movecost=5

tiles(45).tile=247 'lava
tiles(45).col=12
tiles(45).bgcol=0
tiles(45).desc="Lava"
tiles(45).stopwalking=1
tiles(45).movecost=5

tiles(46).tile=111 'cave
tiles(46).col=7
tiles(46).desc="Cave"

'cavewalls
tiles(47).tile=176
tiles(47).bgcol=0
tiles(47).col=219
tiles(47).desc="rubble"
tiles(47).seetru=0
tiles(47).walktru=2
tiles(47).firetru=1
tiles(47).shootable=1
tiles(47).dr=-1
tiles(47).hp=6
tiles(47).turnsinto=4
tiles(47).succt="You tunnel through the rubble"
tiles(47).failt="Your attempt to losen the ground fails"

tiles(48).tile=178
tiles(48).bgcol=219
tiles(48).col=218
tiles(48).desc="soft rock"
tiles(48).seetru=1
tiles(48).walktru=5
tiles(48).firetru=1
tiles(48).shootable=1
tiles(48).dr=1
tiles(48).hp=7
tiles(48).turnsinto=47
tiles(48).succt="You tunnel through the wall"
tiles(48).failt="The wall is too hard"


tiles(49).tile=178
tiles(49).bgcol=218
tiles(49).col=217
tiles(49).desc="Rock"
tiles(49).seetru=1
tiles(49).walktru=5
tiles(49).firetru=1
tiles(49).shootable=1
tiles(49).dr=2
tiles(49).hp=8
tiles(49).turnsinto=48
tiles(49).succt="You tunnel through the wall"
tiles(49).failt="The wall is too hard"

tiles(50).tile=178
tiles(50).bgcol=217
tiles(50).col=216
tiles(50).desc="hard rock"
tiles(50).seetru=1
tiles(50).walktru=5
tiles(50).firetru=1
tiles(50).shootable=1
tiles(50).dr=3
tiles(50).hp=9
tiles(50).turnsinto=49
tiles(50).succt="You tunnel through the wall"
tiles(50).failt="The wall is too hard"

tiles(51).tile=178
tiles(51).bgcol=216
tiles(51).col=215
tiles(51).desc="hard rock"
tiles(51).seetru=2
tiles(51).walktru=5
tiles(51).firetru=1
tiles(51).shootable=1
tiles(51).dr=4
tiles(51).hp=10
tiles(51).turnsinto=50
tiles(51).succt="You tunnel through the wall"
tiles(51).failt="The wall is too hard"

tiles(52).tile=176
tiles(52).col=137
tiles(52).bgcol=137
tiles(52).desc="steel wall"
tiles(52).seetru=2
tiles(52).walktru=5
tiles(52).firetru=1

tiles(53).tile=asc("+") 'broken door
tiles(53).col=137
tiles(53).desc="door"
tiles(53).seetru=1
tiles(53).walktru=5
tiles(53).firetru=1
tiles(53).dr=11
tiles(53).shootable=1
tiles(53).hp=55
tiles(53).succt="Concentrating enough firepower you melt the door a little"
tiles(53).failt="You dont have enough firepower to damage the door"
tiles(53).killt="You blast the door open"
tiles(53).turnsinto=84

tiles(54).tile=asc("+") 'closed door
tiles(54).col=11
tiles(54).desc="Door"
tiles(54).seetru=1
tiles(54).firetru=1
tiles(54).walktru=5
tiles(54).dr=4
tiles(54).shootable=1
tiles(54).hp=10
tiles(54).succt="Concentrating enough firepower you melt the door a little"
tiles(54).failt="You dont have enough firepower to damage the door"
tiles(54).killt="You blast the door open"
tiles(54).turnsinto=84

tiles(55).tile=asc("/") 'open door
tiles(55).col=11
tiles(55).desc="Door"
tiles(55).seetru=0
tiles(55).firetru=0
tiles(55).onclose=263
tiles(55).walktru=0
tiles(55).dr=4
tiles(55).shootable=1
tiles(55).hp=10
tiles(55).succt="Concentrating enough firepower you melt the door a little"
tiles(55).failt="You dont have enough firepower to damage the door"
tiles(55).killt="You blast the door open"
tiles(55).turnsinto=84
tiles(55).movecost=3


tiles(56).tile=84 'Apollos temple
tiles(56).col=14
tiles(56).bgcol=6
tiles(56).desc="A greek temple"
tiles(56).seetru=1
tiles(56).walktru=5
tiles(56).firetru=1
tiles(56).shootable=1
tiles(56).turnsinto=57
tiles(56).dr=2
tiles(56).hp=100
tiles(56).succt="You damage the structure"
tiles(56).failt="The Temple withstands your fire"
tiles(56).killt="You destroy the temple. There is some very advanced machinery in the rubble."
tiles(56).spawnson=25
tiles(56).spawnswhat=5
tiles(56).spawnsmax=1
tiles(56).spawntext="Apollo appears unhurt in the temples doors!"
tiles(56).hides=2
tiles(56).movecost=3

tiles(57).tile=46
tiles(57).col=15
tiles(57).bgcol=6
tiles(57).desc="ruins of a temple."
tiles(57).gives=1
tiles(57).turnsinto=58
tiles(57).hides=2
tiles(57).movecost=3


tiles(58).tile=46
tiles(58).col=15
tiles(58).bgcol=6
tiles(58).desc="temple ruin"
tiles(58).gives=0
tiles(58).turnsinto=0
tiles(58).hides=2
tiles(58).movecost=3


tiles(59).tile=84 'Leafy tree
tiles(59).col=4
tiles(59).bgcol=0
tiles(59).desc="A big tree with many leafs"
tiles(59).seetru=1
tiles(59).walktru=5
tiles(59).firetru=1
tiles(59).shootable=1
tiles(59).turnsinto=4
tiles(59).dr=-1
tiles(59).hp=8
tiles(59).succt="You slice through the wood like butter"
tiles(59).failt="You dont damage the tree"
tiles(59).killt="You destroy the tree"
tiles(59).spawnson=66
tiles(59).spawnswhat=6
tiles(59).spawnsmax=5
tiles(59).spawntext="A leaf detaches and flies towards you"
tiles(59).hides=2


tiles(60).tile=64 'priate cruiser, landed
tiles(60).col=12
tiles(60).bgcol=0
tiles(60).desc="A landed pirate cruiser"
tiles(60).seetru=1
tiles(60).walktru=5
tiles(60).firetru=1
tiles(60).shootable=1
tiles(60).turnsinto=3
tiles(60).dr=2
tiles(60).hp=25
tiles(60).succt="It is slightly dented now"
tiles(60).failt="Your weapons arent powerful enough to damage a spaceship"
tiles(60).killt="That will teach those pirates a lesson!"
tiles(60).spawnson=33
tiles(60).spawnswhat=7
tiles(60).spawnsmax=5
tiles(60).spawntext="Some pirates leave their ship"
tiles(60).hides=2
tiles(60).movecost=3


tiles(61).tile=64
tiles(61).col=11
tiles(61).desc="a stranded ship"
tiles(61).survivors=33
tiles(61).resources=66
tiles(61).turnsinto=62
tiles(61).hides=2
tiles(61).movecost=3

tiles(62).tile=64
tiles(62).col=11
tiles(62).desc="a stranded ship, beyond repair"
tiles(62).hides=2
tiles(62).movecost=3

tiles(63).tile=asc("#")
tiles(63).col=7
tiles(63).desc="A makeshift bunker with a ships laserbank"
tiles(63).turnsinto=64
tiles(63).dam=-6
tiles(63).range=5
tiles(63).tohit=55
tiles(63).gives=2
tiles(63).hitt="You are under fire from ships grade lasers!"
tiles(63).misst="A ships grade laserbeam sizzles past you! good shot, but a miss!"
tiles(63).deadt="lunatic firing shiplasers at you"
tiles(63).hides=2
tiles(63).movecost=3

tiles(64).tile=asc("#")
tiles(64).col=7
tiles(64).desc="A makeshift bunker with a ships laserbank"
tiles(64).hides=2
tiles(64).movecost=3

tiles(65)=tiles(60)
tiles(65).spawnswhat=3
tiles(65).hides=2
tiles(65).movecost=3

tiles(66)=tiles(65)
tiles(66).walktru=0
tiles(66).gives=3
tiles(66).turnsinto=65
tiles(66).hides=2
tiles(66).movecost=3

tiles(67).tile=64 'priate cruiser, landed
tiles(67).col=12
tiles(67).bgcol=0
tiles(67).desc="A landed pirate cruiser"
tiles(67).seetru=1
tiles(67).walktru=5
tiles(67).firetru=1
tiles(67).shootable=1
tiles(67).turnsinto=3
tiles(67).dr=2
tiles(67).hp=225
tiles(67).succt="It is slightly dented now"
tiles(67).failt="Your handwapons arent powerful enough to damage a spaceship"
tiles(67).killt="That will teach those pirates a lesson!"
tiles(67).hides=2
tiles(67).movecost=3

tiles(68).tile=219
tiles(68).col=8
tiles(68).bgcol=7
tiles(68).desc="landing pad"
tiles(68).movecost=0

tiles(69).tile=asc("B")
tiles(69).col=17
tiles(69).bgcol=2 'bar
tiles(69).desc="Building"
tiles(69).seetru=1
tiles(69).firetru=1
tiles(69).gives=27
tiles(69).turnsinto=69
tiles(69).hides=2
tiles(69).movecost=4
tiles(69).movecost=3

tiles(70)=tiles(69)
tiles(70).tile=asc("F")
tiles(70).col=18
tiles(70).bgcol=7
tiles(70).gives=28
tiles(70).turnsinto=70
tiles(70).hides=2

tiles(71)=tiles(69)
tiles(71).tile=asc("R")
tiles(71).col=12
tiles(71).bgcol=7
tiles(71).gives=29
tiles(71).turnsinto=71
tiles(71).hides=2

tiles(72)=tiles(69)
tiles(72).tile=asc("H")
tiles(72).col=2
tiles(72).bgcol=15
tiles(72).gives=30
tiles(72).turnsinto=72
tiles(72).hides=2


tiles(73)=tiles(69)
tiles(73).tile=asc("U")
tiles(73).col=2
tiles(73).bgcol=15
tiles(73).gives=31
tiles(73).turnsinto=73
tiles(73).hides=2

tiles(74)=tiles(69)
tiles(74).tile=asc("T")
tiles(74).col=2
tiles(74).bgcol=15
tiles(74).gives=5
tiles(74).turnsinto=74
tiles(74).hides=2

tiles(75).tile=asc("X")
tiles(75).col=12
tiles(75).desc="Someone carved an X into the ground here"
tiles(75).shootable=1
tiles(75).turnsinto=57
tiles(75).dr=1
tiles(75).hp=25
tiles(75).succt="You dig"
tiles(75).failt="The ground is too hard to dig"
tiles(75).killt="Ancient ruins of an alien building!"
tiles(75).stopwalking=1
tiles(75).hides=2

tiles(76).tile=35
tiles(76).col=7
tiles(76).desc="abandoned mining building"
tiles(76).seetru=1
tiles(76).firetru=1
tiles(76).hides=2
tiles(76).dr=4
tiles(76).shootable=1
tiles(76).hp=30
tiles(76).turnsinto=47
tiles(76).seetru=1
tiles(76).firetru=1
tiles(76).movecost=4

tiles(78).tile=65
tiles(78).col=14
tiles(78).hides=2

tiles(79).tile=64
tiles(79).col=11
tiles(79).desc="A stranded scoutship"
tiles(79).gives=13
tiles(79).turnsinto=79
tiles(79).hides=2

tiles(80).tile=46
tiles(80).col=11
tiles(80).bgcol=0
tiles(80).desc="Metal floor"

tiles(81).tile=46
tiles(81).col=11
tiles(81).bgcol=0
tiles(81).desc="Metal floor"
tiles(81).turnsinto=80
tiles(81).dam=-4
tiles(81).range=0
tiles(81).tohit=80
tiles(81).hitt="You trigger a trap firing lasers!"
tiles(81).deadt="trap"
tiles(81).shootable=1
tiles(81).dr=-1
tiles(81).hp=8
tiles(81).killt="You destroy the sensors for the trap"
tiles(81).turnsoninspect=153
tiles(81).turntext="You discover sensors for a laser trap"

tiles(82).tile=asc("C")
tiles(82).col=11
tiles(82).desc="a computer"
tiles(82).shootable=1
tiles(82).dr=2
tiles(82).hp=15
tiles(82).spawnson=15
tiles(82).spawnswhat=9
tiles(82).spawnsmax=10
tiles(82).spawntext="A defense robot suddenly appears next to the machine"
tiles(82).turnsinto=83
tiles(82).stopwalking=1

tiles(83).tile=asc(";")
tiles(83).col=4
tiles(83).desc="a heap of some metal. Examining closely you find"
tiles(83).gives=1
tiles(83).turnsinto=84
tiles(83).hides=2

tiles(84).tile=asc(";")
tiles(84).col=4
tiles(84).desc="heap of some metal"
tiles(84).turnsinto=84
tiles(84).hides=2

tiles(86).tile=64 
tiles(86).col=11
tiles(86).bgcol=0
tiles(86).desc="Another scoutship"
tiles(86).seetru=1
tiles(86).walktru=0
tiles(86).firetru=1
tiles(86).shootable=1
tiles(86).locked=3
tiles(86).spawnson=100
tiles(86).spawnswhat=15
tiles(86).spawnsmax=1
tiles(86).spawnblock=1
tiles(86).turnsinto=62
tiles(86).dr=2
tiles(86).hp=25
tiles(86).succt="It is slightly dented now"
tiles(86).failt="Your handwapons arent powerful enough to damage a spaceship"
tiles(86).killt="That will teach them a lesson!"
tiles(86).hides=2

tiles(87).tile=asc(".")
tiles(87).col=8
tiles(87).desc="toxic gas"
tiles(87).oxyuse=2


tiles(88).tile=126
tiles(88).col=10
tiles(88).desc="toxic gas"
tiles(88).oxyuse=2
tiles(88).seetru=1

tiles(89).tile=35 'Mr. Grey
tiles(89).desc="Building"
tiles(89).col=15
tiles(89).bgcol=7
tiles(89).seetru=1
tiles(89).firetru=1
tiles(89).gives=15
tiles(89).turnsinto=89
tiles(89).hides=2
tiles(89).movecost=3
'
' Signs of civilization
'

tiles(90).tile=asc("O")
tiles(90).col=4
tiles(90).desc="a dirt hut"
tiles(90).hides=2
tiles(90).dr=-1
tiles(90).hp=10
tiles(90).turnsinto=4
tiles(90).seetru=1
tiles(90).firetru=1
tiles(90).shootable=1
tiles(90).dr=-1
tiles(90).hp=10
tiles(90).turnsinto=3
tiles(90).movecost=2


tiles(91).tile=asc("O")
tiles(91).col=14
tiles(91).desc="a house made of clay bricks"
tiles(91).hides=2
tiles(91).dr=0
tiles(91).hp=15
tiles(91).turnsinto=4
tiles(91).seetru=1
tiles(91).firetru=1
tiles(91).shootable=1
tiles(91).dr=0
tiles(91).hp=20
tiles(91).turnsinto=3
tiles(91).movecost=2

tiles(92).tile=asc("O")
tiles(92).col=7
tiles(92).desc="a well constructed stone house"
tiles(92).hides=2
tiles(92).dr=1
tiles(92).hp=20
tiles(92).turnsinto=4
tiles(92).seetru=1
tiles(92).firetru=1
tiles(92).shootable=1
tiles(92).dr=1
tiles(92).hp=30
tiles(92).turnsinto=3
tiles(92).movecost=2

tiles(93).tile=asc("O")
tiles(93).col=4
tiles(93).desc="a dirt hut"
tiles(93).locked=1
tiles(93).hides=2
tiles(93).dr=-1
tiles(93).hp=10
tiles(93).turnsinto=4
tiles(93).seetru=1
tiles(93).firetru=1
tiles(93).shootable=1
tiles(93).dr=-1
tiles(93).hp=10
tiles(93).turnsinto=3
tiles(93).movecost=2

tiles(94).tile=asc("O")
tiles(94).col=14
tiles(94).desc="a house made of clay bricks"
tiles(94).locked=2
tiles(94).hides=2
tiles(94).dr=0
tiles(94).hp=15
tiles(94).turnsinto=4
tiles(94).seetru=1
tiles(94).firetru=1
tiles(94).shootable=1
tiles(94).dr=0
tiles(94).hp=20
tiles(94).turnsinto=3
tiles(94).movecost=2

tiles(95).tile=asc("O")
tiles(95).col=7
tiles(95).desc="a well constructed stone house"
tiles(95).locked=3
tiles(95).hides=2
tiles(95).dr=1
tiles(95).hp=30
tiles(95).turnsinto=4
tiles(95).seetru=1
tiles(95).firetru=1
tiles(95).shootable=1
tiles(95).dr=1
tiles(95).hp=40
tiles(95).turnsinto=3
tiles(95).movecost=2

tiles(96).tile=186
tiles(96).col=4
tiles(96).desc="cultivated land"
tiles(96).shootable=1
tiles(96).dr=-1
tiles(96).hp=20
tiles(96).turnsinto=3
tiles(96).movecost=2


tiles(97).tile=asc(".")
tiles(97).col=15
tiles(97).desc="oxygen rich gas bubble"
tiles(97).oxyuse=-2


tiles(98).tile=35 'Black Market
tiles(98).desc="Building"
tiles(98).col=8
tiles(98).seetru=1
tiles(98).firetru=1
tiles(98).gives=17
tiles(98).turnsinto=98
tiles(98).hides=2
tiles(98).movecost=2

tiles(99).tile=35
tiles(99).desc="Building"
tiles(99).col=8
tiles(99).seetru=1
tiles(99).firetru=1
tiles(99).gives=16
tiles(99).turnsinto=99
tiles(99).hides=2
tiles(99).movecost=2

tiles(100).tile=asc("#") 'Apollos temple
tiles(100).col=14
tiles(100).bgcol=0
tiles(100).desc="Factory"
tiles(100).seetru=1
tiles(100).firetru=1
tiles(100).shootable=1
tiles(100).turnsinto=101
tiles(100).dr=1
tiles(100).hp=50
tiles(100).succt="You damage the structure"
tiles(100).failt="The structure withstands your fire"
tiles(100).killt="You destroy the structure"
tiles(100).spawnson=15
tiles(100).spawnswhat=8
tiles(100).spawnsmax=28
tiles(100).spawntext="A door opens and a defense robot apears!"
tiles(100).hides=2
tiles(100).movecost=3

tiles(101).tile=asc("#") 'Apollos temple
tiles(101).col=14
tiles(101).bgcol=0
tiles(101).desc="destroyed factory"
tiles(101).hides=2
tiles(101).movecost=3

tiles(102).tile=asc(".")
tiles(102).col=90
tiles(102).desc="moss"
tiles(102).vege=1
tiles(102).shootable=1
tiles(102).dr=-1
tiles(102).hp=2
tiles(102).turnsinto=3
tiles(102).movecost=2

tiles(103).tile=asc(".")
tiles(103).col=42
tiles(103).desc="moss"
tiles(103).vege=2
tiles(103).shootable=1
tiles(103).dr=-1
tiles(103).hp=2
tiles(103).turnsinto=3
tiles(103).movecost=2


tiles(104).tile=asc(".")
tiles(104).col=120
tiles(104).desc="moss"
tiles(104).vege=3
tiles(104).shootable=1
tiles(104).dr=-1
tiles(104).hp=2
tiles(104).turnsinto=3
tiles(104).movecost=2

tiles(105).tile=asc(".")
tiles(105).col=18
tiles(105).desc="moss"
tiles(105).vege=4
tiles(105).shootable=1
tiles(105).dr=-1
tiles(105).hp=2
tiles(105).turnsinto=3
tiles(105).movecost=2

tiles(106).tile=34
tiles(106).col=60
tiles(106).desc="ferns"
tiles(106).vege=5
tiles(106).shootable=1
tiles(106).dr=-1
tiles(106).hp=2
tiles(106).turnsinto=3
tiles(106).movecost=3

tiles(107).tile=asc("#")
tiles(107).col=218
tiles(107).desc="primitive factory"
tiles(107).causeaeon=22
tiles(107).aetype=5
tiles(107).hides=2
tiles(107).hp=25
tiles(107).dr=1
tiles(107).hitt="you start to shoot up the factory"
tiles(107).turnsinto=4
tiles(107).movecost=2

tiles(108).tile=asc("#")
tiles(108).col=130
tiles(108).desc="A big sleek steel and glass building, with slightly low ceilings"
tiles(108).gives=19
tiles(108).turnsinto=108
tiles(108).hides=2
tiles(108).dr=4
tiles(108).shootable=1
tiles(108).hp=30
tiles(108).turnsinto=108
tiles(108).seetru=1
tiles(108).firetru=1
tiles(108).movecost=3

tiles(109).tile=asc("#") 'Botbin
tiles(109).col=10
tiles(109).gives=59
tiles(109).hp=25
tiles(109).dr=1
tiles(109).hitt="you start to shoot at the Botbin"
tiles(109).turnsinto=109
tiles(109).desc="The Bot-Bin 2nd hand bots and drones"
tiles(109).movecost=3

tiles(110).tile=asc("#")
tiles(110).col=12
tiles(110).hp=25
tiles(110).dr=1
tiles(110).gives=69
tiles(110).hitt="you start to shoot at the Petshop"
tiles(110).turnsinto=110
tiles(110).desc="The Petshop"
tiles(110).movecost=3

tiles(111).tile=asc("#")
tiles(111).col=12
tiles(111).hp=25
tiles(111).dr=1
tiles(111).gives=74
tiles(111).hitt="you start to shoot at Beasts of Burden"
tiles(111).turnsinto=111
tiles(111).desc="Beasts of Burden"
tiles(111).movecost=3

tiles(112).tile=asc("#")
tiles(112).col=10
tiles(112).hp=25
tiles(112).dr=1
tiles(112).gives=75
tiles(112).hitt="you start to shoot at Used Ships"
tiles(112).turnsinto=112
tiles(112).desc="Used Ships"
tiles(112).movecost=3

tiles(113).tile=asc("#")
tiles(113).col=9
tiles(113).hp=5
tiles(113).dr=1
tiles(113).gives=76
tiles(113).hitt="you start to shoot at the gift shop"
tiles(113).turnsinto=113
tiles(113).desc="Gift shop"
tiles(113).movecost=3


tiles(114).tile=238
tiles(114).col=7
tiles(114).desc="An environmental control console. The systems don't seem to be working."
tiles(114).gives=56
tiles(114).turnsinto=114

tiles(115).tile=238
tiles(115).col=7
tiles(115).desc="An environmental control console. All systems working within perimeters"

tiles(116).tile=238
tiles(116).col=7
tiles(116).desc="An environmental control console. It is broken beyond repair."

tiles(117).tile=238
tiles(117).col=12
tiles(117).col=8
tiles(117).desc="A reactor control console."
tiles(117).gives=57
tiles(117).turnsinto=117

tiles(118).tile=238
tiles(118).col=12
tiles(118).col=8
tiles(118).desc="A reactor control console. All systems green"

tiles(119).tile=238
tiles(119).col=12
tiles(119).col=8
tiles(119).desc="A reactor control console. It is broken beyond repair"


tiles(126).tile=64 
tiles(126).col=7
tiles(126).bgcol=0
tiles(126).desc="An alien spaceship"
tiles(126).seetru=1
tiles(126).hides=2
tiles(126).movecost=3

tiles(127).tile=asc("C")
tiles(127).col=15
tiles(127).desc="A computer"
tiles(127).turnsinto=84
tiles(127).gives=999

tiles(128).tile=64
tiles(128).col=11
tiles(128).desc="A stranded light scout"
tiles(128).hides=2
tiles(128).movecost=3

tiles(129).tile=64
tiles(129).col=11
tiles(129).desc="A stranded long range fighter"
tiles(129).hides=2
tiles(129).movecost=3

tiles(130).tile=64
tiles(130).col=11
tiles(130).desc="A stranded light transport"
tiles(130).hides=2
tiles(130).movecost=3

tiles(131).tile=64
tiles(131).col=11
tiles(131).desc="A stranded troop transport"
tiles(131).hides=2
tiles(131).movecost=3

tiles(132).tile=64
tiles(132).col=11
tiles(132).desc="A stranded heavy scout"
tiles(132).hides=2
tiles(132).movecost=3

tiles(133).tile=64
tiles(133).col=11
tiles(133).desc="A stranded cruiser"
tiles(133).hides=2
tiles(133).movecost=3

tiles(134).tile=64
tiles(134).col=11
tiles(134).desc="A stranded heavy transport"
tiles(134).hides=2
tiles(134).movecost=3

tiles(135).tile=64
tiles(135).col=11
tiles(135).desc="A stranded dropship"
tiles(135).hides=2
tiles(135).movecost=3

tiles(136).tile=64
tiles(136).col=11
tiles(136).desc="A stranded explorer"
tiles(136).hides=2
tiles(136).movecost=3

tiles(137).tile=64
tiles(137).col=11
tiles(137).desc="A stranded destroyer"
tiles(137).hides=2
tiles(137).movecost=3

tiles(138).tile=64
tiles(138).col=11
tiles(138).desc="A stranded merchantman"
tiles(138).hides=2
tiles(138).movecost=3

tiles(139).tile=64
tiles(139).col=11
tiles(139).desc="A stranded troop carrier"
tiles(139).hides=2
tiles(139).movecost=3

tiles(140).tile=64
tiles(140).col=11
tiles(140).desc="A stranded heavy explorer"
tiles(140).hides=2
tiles(140).movecost=3

tiles(141).tile=64
tiles(141).col=11
tiles(141).desc="A stranded battleship"
tiles(141).hides=2
tiles(141).movecost=3

tiles(142).tile=64
tiles(142).col=11
tiles(142).desc="A stranded armed merchantman"
tiles(142).hides=2
tiles(142).movecost=3

tiles(143).tile=64
tiles(143).col=11
tiles(143).desc="A stranded heavy troop carrier"
tiles(143).hides=2
tiles(143).movecost=3

tiles(144).tile=35
tiles(144).col=7
tiles(144).desc="a building"
tiles(144).dr=2
tiles(144).hp=60
tiles(144).shootable=1
tiles(144).turnsinto=47
tiles(144).seetru=1
tiles(144).firetru=1
tiles(144).hides=2
tiles(144).movecost=3

tiles(145).tile=34
tiles(145).col=15
tiles(145).desc="snow"
tiles(145).shootable=1
tiles(145).dr=-1
tiles(145).hp=2
tiles(145).turnsinto=14
tiles(145).hides=2
tiles(145).movecost=3

tiles(146).tile=34
tiles(146).col=-9
tiles(146).bgcol=-14
tiles(146).desc="iridescent flowers"
tiles(146).vege=5
tiles(146).shootable=1
tiles(146).dr=-1
tiles(146).hp=1
tiles(146).turnsinto=3

tiles(148).tile=35
tiles(148).col=7
tiles(148).desc="an ancient ruined alien settlement"
tiles(148).dr=2
tiles(148).hp=60
tiles(148).turnsinto=47
tiles(148).seetru=1
tiles(148).firetru=1
tiles(148).locked=2
tiles(148).hides=2
tiles(148).movecost=3

tiles(149).tile=asc("@")
tiles(149).col=7
tiles(149).desc="the ancient wreck of an alien spaceship"
tiles(149).hides=2

tiles(150).tile=asc("^")
tiles(150).bgcol=0
tiles(150).col=14
tiles(150).desc="a primitive stone pyramid"
tiles(150).hides=2
tiles(150).dr=2
tiles(150).shootable=1
tiles(150).hp=60
tiles(150).turnsinto=47
tiles(150).seetru=1
tiles(150).firetru=1

tiles(151).tile=178
tiles(151).col=215
tiles(151).bgcol=216
tiles(151).desc="hard rock"
tiles(151).seetru=2
tiles(151).walktru=5
tiles(151).firetru=1
tiles(151).shootable=1
tiles(151).dr=1
tiles(151).hp=3
tiles(151).turnsinto=50
tiles(151).succt="You tunnel through the wall"
tiles(151).failt="The wall is too hard"
tiles(151).turntext="You discovere a well hidden secret passage!"
tiles(151).turnsoninspect=4


tiles(152).tile=176
tiles(152).col=0
tiles(152).bgcol=4
tiles(152).desc="dense wall of roots"
tiles(152).seetru=0
tiles(152).walktru=5
tiles(152).firetru=1
tiles(152).shootable=1
tiles(152).dr=-1
tiles(152).hp=2
tiles(152).turnsinto=4
tiles(152).succt="You shoot an opening into the roots"
tiles(152).failt="the roots are too thick"


tiles(153).tile=46
tiles(153).col=9
tiles(153).bgcol=0
tiles(153).desc="Metal floor"
tiles(153).turnsinto=80
tiles(153).dam=-4
tiles(153).range=0
tiles(153).tohit=80
tiles(153).hitt="You trigger a trap firing lasers!"
tiles(153).deadt="trap"
tiles(153).shootable=1
tiles(153).dr=-1
tiles(153).hp=8
tiles(153).killt="You destroy the sensors for the trap"


tiles(154).tile=46
tiles(154).col=7
tiles(154).bgcol=0
tiles(154).desc="rock"
tiles(154).turnsinto=4
tiles(154).dam=-3
tiles(154).range=0
tiles(154).tohit=80
tiles(154).hitt="You trigger a mechanical trap!"
tiles(154).deadt="trap"
tiles(154).shootable=1
tiles(154).dr=-1
tiles(154).hp=1
tiles(154).killt="You destroy the tripwire"
tiles(154).turnsoninspect=155
tiles(154).turntext="You find a tripwire for a trap"

tiles(155).tile=asc("_")
tiles(155).col=7
tiles(155).bgcol=0
tiles(155).desc="tripwire"
tiles(155).turnsinto=4
tiles(155).dam=-3
tiles(155).range=0
tiles(155).tohit=60
tiles(155).hitt="You trigger a mechanical trap!"
tiles(155).deadt="trap"
tiles(155).shootable=1
tiles(155).dr=-1
tiles(155).hp=1
tiles(155).killt="You destroy the tripwire"
tiles(155).movecost=2

tiles(156).tile=asc("+") 'closed door
tiles(156).col=8
tiles(156).desc="Door"
tiles(156).seetru=1
tiles(156).firetru=1
tiles(156).locked=2
tiles(156).dr=-1
tiles(156).hp=6
tiles(156).turnsinto=4
tiles(156).onopen=157
tiles(156).shootable=1
tiles(156).dr=-1
tiles(156).hp=30
tiles(156).turnsinto=4


tiles(157).tile=asc("/") 'open door
tiles(157).col=8
tiles(157).desc="Door"
tiles(157).seetru=0
tiles(157).firetru=0
tiles(157).onclose=156
tiles(157).shootable=1
tiles(157).dr=-1
tiles(157).hp=30
tiles(157).turnsinto=4
tiles(157).movecost=3

tiles(158).tile=176
tiles(158).col=1    
tiles(158).bgcol=11
tiles(158).desc="huge block of ice"
tiles(158).seetru=0
tiles(158).walktru=2
tiles(158).firetru=1
tiles(158).shootable=1
tiles(158).dr=1
tiles(158).hp=9
tiles(158).turnsinto=4
tiles(158).succt="You tunnel through the ice"
tiles(158).failt="Your attempt to losen the ice fails"

tiles(159).tile=asc(".")
tiles(159).col=14    
tiles(159).desc="High radiation levels"
tiles(159).dam=-1
tiles(159).range=2
tiles(159).disease=16

tiles(160).tile=asc(".")
tiles(160).col=14    
tiles(160).desc="Sand"
tiles(160).dam=-1
tiles(160).range=2
tiles(160).disease=16

tiles(161).tile=asc("=")
tiles(161).col=125
tiles(161).desc="A shallow pool. the analysis of the liquid shows that it contains all the basic building blocks for life, similiar to a primordeal soup."
tiles(161).movecost=2

tiles(162).tile=asc("*")
tiles(162).col=1
tiles(162).desc="Several pipes come up from the ground and lead to a small device.Your science officer examines it and comes to the conclusion that it produces medical nanobots. 'The air is full of them." 
tiles(162).turnsinto=163

tiles(163).tile=asc("*")
tiles(163).col=1
tiles(163).desc="Several pipes come up from the ground"


tiles(164).tile=35
tiles(164).desc="Warehouse"
tiles(164).col=15
tiles(164).bgcol=7
tiles(164).seetru=1
tiles(164).firetru=1
tiles(164).gives=18
tiles(164).turnsinto=164
tiles(164).hides=2
tiles(164).movecost=3

tiles(165).tile=34
tiles(165).col=121
tiles(165).desc="seatang"
tiles(165).vege=6
tiles(165).turnsoninspect=166
tiles(165).shootable=1
tiles(165).dr=-1
tiles(165).hp=1
tiles(165).turnsinto=3
tiles(165).movecost=2

tiles(166).tile=34
tiles(166).col=121
tiles(166).desc="seatang"
tiles(166).shootable=1
tiles(166).dr=-1
tiles(166).hp=1
tiles(166).turnsinto=3
tiles(166).movecost=2

tiles(167).tile=asc("C")
tiles(167).col=15
tiles(167).desc="A computer"
tiles(167).turnsinto=84
tiles(167).gives=888

tiles(168).tile=157
tiles(168).col=13
tiles(168).bgcol=6
tiles(168).walktru=5
tiles(168).desc="A domeshaped forcefield covers a turret with a disintegrator cannon"
tiles(168).movecost=4

tiles(169).tile=157
tiles(169).col=7
tiles(169).desc="A turret with a disintegrator cannon"
tiles(169).gives=887
tiles(169).turnsinto=170
tiles(169).movecost=3

tiles(170).tile=157
tiles(170).col=7
tiles(170).desc="A turret"
tiles(170).movecost=3

tiles(171).tile=35
tiles(171).desc="Building"
tiles(171).col=77
tiles(171).seetru=1
tiles(171).firetru=1
tiles(171).hides=2
tiles(171).dr=4
tiles(171).shootable=1
tiles(171).hp=30
tiles(171).turnsinto=47
tiles(171).seetru=1
tiles(171).firetru=1
tiles(171).movecost=3


tiles(172).tile=asc("T")
tiles(172).col=10
tiles(172).bgcol=77
tiles(172).seetru=1
tiles(172).firetru=1
tiles(172).gives=6
tiles(172).turnsinto=172
tiles(172).hides=2

tiles(173).tile=asc("@")
tiles(173).col=56
tiles(173).desc="A space ship under construction"
tiles(173).movecost=4

tiles(175).tile=176
tiles(175).walktru=4
tiles(175).col=186
tiles(175).desc="clouds"

tiles(176).tile=176
tiles(176).walktru=4
tiles(176).desc="clouds"
tiles(176).col=198

tiles(177).tile=176
tiles(177).walktru=4
tiles(177).col=210
tiles(177).desc="clouds"

tiles(178).tile=ASC("O")
tiles(178).col=8
tiles(178).desc="fuel tank"
tiles(178).gives=55
tiles(178).turnsinto=178

tiles(179).tile=asc(".")
tiles(179).col=4
tiles(179).desc="spice sand"
tiles(179).vege=10
tiles(179).turnsoninspect=3
tiles(179).hitt="Fermenting gases in the spice sand explode!"
tiles(179).tohit=5
tiles(179).dam=10
tiles(179).movecost=2

tiles(181).tile=35
tiles(181).col=8
tiles(181).desc="a run down building"
tiles(181).dr=1
tiles(181).hp=30
tiles(181).turnsinto=47
tiles(181).seetru=1
tiles(181).firetru=1
tiles(181).locked=2
tiles(181).hides=2
tiles(181).dr=3
tiles(181).shootable=1
tiles(181).hp=20
tiles(181).turnsinto=47
tiles(181).seetru=1
tiles(181).firetru=1
tiles(181).movecost=3

tiles(182).tile=35
tiles(182).col=14
tiles(182).desc="a not working powerplant"
tiles(182).turntext="Nothing seriously wrong, just a software glitch. You restart the system and wonder why the colonists didn't do it themselves." 
tiles(182).dr=1
tiles(182).hp=30
tiles(182).turnsoninspect=184
tiles(182).seetru=1
tiles(182).firetru=1
tiles(182).locked=2
tiles(182).hides=2
tiles(182).movecost=3


tiles(183).tile=asc("T")
tiles(183).col=2
tiles(183).bgcol=15
tiles(183).desc="a run down building"
tiles(183).dr=1
tiles(183).turnsinto=183
tiles(183).gives=7
tiles(183).hides=2
tiles(183).movecost=3

tiles(184).tile=35
tiles(184).col=14
tiles(184).desc="a working powerplant"
tiles(184).dr=1
tiles(184).hp=30
tiles(184).seetru=1
tiles(184).firetru=1
tiles(184).locked=2
tiles(184).hides=2
tiles(184).movecost=3

tiles(185).tile=asc(".")
tiles(185).col=1
tiles(185).desc="a dark spongy surface, consisting of long chains of silicone oxygen molecules."
tiles(185).movecost=4

tiles(186).tile=asc(".")
tiles(186).col=218
tiles(186).desc="smooth rock"
tiles(186).movecost=0

tiles(187).tile=asc("^")
tiles(187).col=-36
tiles(187).bgcol=-53
tiles(187).desc="a giant mound of smooth rock, with veins of silicone oxide running through it."
tiles(187).spawnson=5
tiles(187).spawnswhat=36
tiles(187).shootable=1
tiles(187).hp=60
tiles(187).succt="You tear holes into the mound."
tiles(187).failt="You don't manage to damage the structure."
tiles(187).turnsinto=188

tiles(188).tile=asc("^")
tiles(188).col=36
tiles(188).desc="the remains of a giant mound of rock. It's structure resembles a brain."
tiles(188).gives=33
tiles(188).turnsinto=189

tiles(189).tile=asc("^")
tiles(189).col=36
tiles(189).desc="the remains of a giant mound of rock. It's structure resembles a brain."

tiles(190).tile=asc("*")
tiles(190).col=-180
tiles(190).bgcol=-197
tiles(190).desc="A huge pulsating crystal"
tiles(190).walktru=5
tiles(190).seetru=1
tiles(190).shootable=1
tiles(190).dr=10
tiles(190).hp=80
tiles(190).succt="You feel a searing pain as you shoot into the pulsating crystal. You hear a voice in your head screaming 'PUT DOWN YOUR WEAPONS AND OBEY!'"
tiles(190).failt="Your fire fails to damage the crystal. You feel an uncomfortable tingling."
tiles(190).turnsinto=192
tiles(190).spawnson=5
tiles(190).spawnswhat=31
tiles(190).spawnsmax=10
tiles(190).hides=2

tiles(191)=tiles(190)
tiles(191).spawnswhat=29
tiles(191).spawnson=8
tiles(191).turnsinto=196

tiles(192).tile=asc("*")
tiles(192).col=180
tiles(192).bgcol=0
tiles(192).desc="crystal shards"
tiles(192).gives=40
tiles(192).turnsinto=4
tiles(192).hides=2
tiles(192).movecost=3

tiles(193).tile=asc("^")
tiles(193).col=-1
tiles(193).bgcol=-77
tiles(193).seetru=2
tiles(193).walktru=2
tiles(193).firetru=1
tiles(193).desc="crystal mountains"

tiles(194).tile=176
tiles(194).col=-1
tiles(194).bgcol=-77
tiles(194).seetru=1
tiles(194).walktru=5
tiles(194).firetru=1
tiles(194).desc="crystal wall"

tiles(195)=tiles(151)
tiles(195).col=-1
tiles(195).bgcol=-77
tiles(195).seetru=1
tiles(195).walktru=2
tiles(195).firetru=1
tiles(195).desc="crystal wall"

tiles(196).tile=asc("*")
tiles(196).col=180
tiles(196).bgcol=0
tiles(196).desc="crystal shards"
tiles(196).turnsinto=4

tiles(197).tile=asc("#")
tiles(197).col=2
tiles(197).desc="The villa of the pirate commander."
tiles(197).gives=32
tiles(197).turnsinto=197


tiles(198).tile=asc("#")
tiles(198).col=2
tiles(198).desc="Your villa."
tiles(198).gives=132
tiles(198).turnsinto=198


tiles(199).tile=asc(".")
tiles(199).col=8
tiles(199).desc="damaged wall"

tiles(200).tile=176
tiles(200).col=1
tiles(200).bgcol=0
tiles(200).walktru=2
tiles(200).desc="space"
tiles(200).oxyuse=1
tiles(200).movecost=3

tiles(201).tile=176
tiles(201).col=7
tiles(201).bgcol=7
tiles(201).walktru=5
tiles(201).seetru=1
tiles(201).firetru=1
tiles(201).shootable=1
tiles(201).dr=4
tiles(201).hp=25
tiles(201).succt="You damage the wall"
tiles(201).failt="The walls are too strong for you to seriously damage"
tiles(201).desc="wall"
tiles(201).turnsinto=199

tiles(202).tile=asc(".")
tiles(202).col=8
tiles(202).desc="floor"

tiles(203).tile=asc("O")
tiles(203).col=14
tiles(203).desc="airlock"
tiles(203).shootable=1
tiles(203).dr=3
tiles(203).hp=20
tiles(203).succt="You damage the door"
tiles(203).failt="The doors are too strong for you to seriously damage"
tiles(203).movecost=2

tiles(204).tile=asc("/")
tiles(204).col=7
tiles(204).desc="door"
tiles(204).onclose=205
tiles(204).movecost=2

tiles(205).tile=asc("+")
tiles(205).col=7
tiles(205).desc="door"
tiles(205).locked=2
tiles(205).walktru=5
tiles(205).seetru=1
tiles(205).firetru=1
tiles(205).shootable=1
tiles(205).dr=2
tiles(205).hp=15
tiles(205).succt="You damage the door"
tiles(205).failt="The doors are too strong for you to seriously damage"
tiles(205).onopen=204
tiles(205).turnsinto=202

tiles(206).tile=asc("E")
tiles(206).col=7
tiles(206).desc="engine"
tiles(206).gives=206
tiles(206).turnsinto=206

tiles(207).tile=asc("S")
tiles(207).col=24
tiles(207).desc="sensors"
tiles(207).gives=207
tiles(207).turnsinto=207

tiles(208).tile=asc("S")
tiles(208).col=150
tiles(208).desc="shields"
tiles(208).gives=208
tiles(208).turnsinto=208

for b=209 to 214
    tiles(b).tile=asc("W")
    tiles(b).col=14
    tiles(b).desc="weapons turret"
    tiles(b).gives=210
    tiles(b).turnsinto=b
next

for b=215 to 219
    tiles(b).tile=asc("C")
    tiles(b).col=114
    tiles(b).bgcol=15
    tiles(b).desc="cargo crate"
    tiles(b).gives=211
    tiles(b).turnsinto=b
next

tiles(220).tile=asc("B")
tiles(220).col=102
tiles(220).desc="Bridge"
tiles(220).gives=220
tiles(220).turnsinto=220

tiles(221).tile=179
tiles(221).col=0
tiles(221).bgcol=15
tiles(221).hides=2
tiles(221).desc="locker"
tiles(221).locked=3
tiles(221).shootable=1
tiles(221).dr=-1
tiles(221).hp=2
tiles(221).turnsinto=80

tiles(222).tile=179
tiles(222).col=0
tiles(222).bgcol=15
tiles(222).hides=2
tiles(222).desc="locker"
tiles(222).shootable=1
tiles(222).dr=-1
tiles(222).hp=2
tiles(222).turnsinto=80

tiles(223).tile=asc("C")
tiles(233).col=114
tiles(223).bgcol=15
tiles(223).desc="cargo crate"

tiles(224).tile=asc("0")
tiles(224).col=7
tiles(224).desc="empty fuel tank"

tiles(225).tile=asc("Ö")
tiles(225).col=11
tiles(255).bgcol=1
tiles(225).desc="cryogenic chamber"
tiles(225).gives=886
tiles(225).turnsinto=80
tiles(225).hides=2

tiles(226).tile=asc("*")
tiles(226).col=-180
tiles(226).bgcol=-197
tiles(226).desc="A huge pulsating crystal"
tiles(226).walktru=5
tiles(226).seetru=1
tiles(226).shootable=1
tiles(226).dr=10
tiles(226).hp=80
tiles(226).succt="You feel a searing pain as you shoot into the pulsating crystal. You hear a voice in your head screaming 'PUT DOWN YOUR WEAPONS AND OBEY!'"
tiles(226).failt="Your fire fails to damage the crystal. You feel an uncomfortable tingling."
tiles(226).turnsinto=227
tiles(226).hides=2

tiles(227).tile=asc("*")
tiles(227).col=180
tiles(227).bgcol=0
tiles(227).desc="crystal shards"
tiles(227).gives=41
tiles(227).turnsinto=4
tiles(227).hides=2

tiles(228).tile=asc("#")
tiles(228).col=219
tiles(228).desc="simple building"
tiles(228).dr=2
tiles(228).hp=30
tiles(228).turnsinto=47
tiles(228).seetru=1
tiles(228).firetru=1
tiles(228).hides=2
tiles(228).spawnson=100
tiles(228).spawnswhat=39
tiles(228).spawnsmax=1
tiles(228).spawnblock=1

tiles(229).tile=asc("#")
tiles(229).col=14
tiles(229).desc="town hall"
tiles(229).dr=2
tiles(229).hp=30
tiles(229).turnsinto=229
tiles(229).seetru=1
tiles(229).firetru=1
tiles(229).hides=2
tiles(229).gives=60

tiles(230).tile=asc(".")
tiles(230).col=7
tiles(230).desc="metal floor"
tiles(230).turnsinto=230


tiles(237).tile=asc("W") 'Weapons shop
tiles(237).desc="Building"
tiles(237).col=2
tiles(237).bgcol=15
tiles(237).seetru=1
tiles(237).firetru=1
tiles(237).gives=34
tiles(237).turnsinto=237
tiles(237).hides=2


tiles(238).tile=asc("H") 'Shipyard
tiles(238).desc="Building"
tiles(238).col=7
tiles(238).bgcol=15
tiles(238).seetru=1
tiles(238).firetru=1
tiles(238).gives=35
tiles(238).turnsinto=238
tiles(238).hides=2

tiles(239).tile=asc("#")
tiles(239).desc="A floating wooden platform"
tiles(239).col=156
tiles(239).hides=2


tiles(240).tile=asc("C")
tiles(240).col=11
tiles(240).gives=111
tiles(240).turnsinto=84

tiles(241).tile=64
tiles(241).col=8
tiles(241).desc="An alien scoutship in relatively good condition"
tiles(241).hides=2

tiles(242).tile=238
tiles(242).col=11
tiles(242).desc="A reactor control console."
tiles(242).gives=58
tiles(242).turnsinto=236

tiles(243).tile=176
tiles(243).col=17
tiles(243).bgcol=7
tiles(243).walktru=5
tiles(243).seetru=2
tiles(243).firetru=1
tiles(243).shootable=1
tiles(243).dr=5
tiles(243).hp=45
tiles(243).succt="You damage the wall"
tiles(243).failt="The walls are too strong for you to seriously damage"
tiles(243).desc="wall"
tiles(243).turnsinto=199


tiles(244).tile=94
tiles(244).col=11
tiles(244).bgcol=0
tiles(244).desc="Tunneled Mountains"
tiles(244).seetru=1
tiles(244).walktru=0
tiles(244).firetru=1
tiles(244).shootable=1
tiles(244).dr=4
tiles(244).hp=25
tiles(244).turnsinto=47


tiles(245).tile=147
tiles(245).col=12
tiles(245).desc="Volcano"
tiles(245).tohit=20
tiles(245).dam=1
tiles(245).hitt="You get hit with flying rocks and magma!"
tiles(245).causeaeon=5
tiles(245).aetype=5
tiles(245).walktru=5


tiles(246).tile=64 
tiles(246).col=11
tiles(246).bgcol=0
tiles(246).desc="Another scoutship"
tiles(246).seetru=1
tiles(246).walktru=0
tiles(246).firetru=1
tiles(246).shootable=1
tiles(246).locked=0
tiles(246).turnsinto=246
tiles(246).dr=2
tiles(246).hp=225
tiles(246).succt="It is slightly dented now"
tiles(246).failt="Your handwapons arent powerful enough to damage a spaceship"
tiles(246).killt="That will teach them a lesson!"
tiles(246).hides=2
tiles(246).gives=246

tiles(247).tile=asc("#")
tiles(247).desc="Town hall"
tiles(247).col=14
tiles(247).gives=39
tiles(247).turnsinto=247

tiles(248).tile=46
tiles(248).col=7
tiles(248).bgcol=0
tiles(248).desc="rock"
tiles(248).turnsinto=4
tiles(248).hitt="You trigger am alarm!"
tiles(248).shootable=1
tiles(248).dr=-1
tiles(248).hp=1
tiles(248).gives=51
tiles(248).killt="You destroy the alarm sensors"
tiles(248).turnsoninspect=249
tiles(248).turntext="sensors for an alarm"

tiles(249).tile=asc("_")
tiles(249).col=7
tiles(249).bgcol=0
tiles(249).desc="tripwire"
tiles(249).turnsinto=4
tiles(249).hitt="You trigger an alarm!"
tiles(249).shootable=1
tiles(249).dr=-1
tiles(249).hp=1
tiles(249).gives=51
tiles(249).killt="You destroy the tripwire"

tiles(250).tile=asc("C")
tiles(250).col=11
tiles(250).desc="Computer"
tiles(250).gives=61
tiles(250).turnsinto=251

tiles(251).tile=asc("C")
tiles(251).col=11
tiles(251).desc="Computer"


tiles(252).tile=asc("C")
tiles(252).col=11
tiles(252).desc="Computer"
tiles(252).gives=62
tiles(252).turnsinto=252

tiles(253).tile=asc("C")
tiles(253).col=11
tiles(253).desc="Computer"

tiles(254).tile=asc("C")
tiles(254).col=11
tiles(254).desc="Computer"
tiles(254).gives=63
tiles(254).turnsinto=254


tiles(255).tile=asc("C")
tiles(255).col=11
tiles(255).desc="Computer"
tiles(255).gives=64
tiles(255).turnsinto=256

tiles(256).tile=asc("C")
tiles(256).col=11
tiles(256).desc="Computer"

tiles(257).tile=asc("C")
tiles(257).col=11
tiles(257).desc="Computer"
tiles(257).gives=65
tiles(257).turnsinto=258

tiles(258).tile=asc("C")
tiles(258).col=11
tiles(258).desc="Computer"

tiles(259).tile=ASC("H")
tiles(259).col=0
tiles(259).bgcol=14
tiles(259).desc="Hullrefits"
tiles(259).gives=42
tiles(259).turnsinto=259


tiles(260).tile=ASC("=")
tiles(260).desc="frozen water"
tiles(260).col=15
tiles(260).shootable=1
tiles(260).dr=-1
tiles(260).succt="You blast holes into the thick ice"
tiles(260).killt="You blast big holes into the thick ice"
tiles(260).hp=5
tiles(260).turnsinto=1

tiles(261).tile=ASC("+")
tiles(261).col=12
tiles(261).bgcol=11
tiles(261).desc="hospital"
tiles(261).gives=43
tiles(261).turnsinto=261


tiles(262).tile=asc("M") 'Mudds
tiles(262).col=236
tiles(262).bgcol=7
tiles(262).desc="Mudds"
tiles(262).seetru=1
tiles(262).firetru=1
tiles(262).gives=66
tiles(262).turnsinto=262
tiles(262).hides=2


tiles(263).tile=asc("+") 'open door
tiles(263).col=11
tiles(263).desc="Door"
tiles(263).seetru=0
tiles(263).firetru=0
tiles(263).onopen=55
tiles(263).walktru=5
tiles(263).dr=4
tiles(263).shootable=1
tiles(263).hp=10
tiles(263).succt="Concentrating enough firepower you melt the door a little"
tiles(263).failt="You dont have enough firepower to damage the door"
tiles(263).killt="You blast the door open"
tiles(263).turnsinto=84

tiles(264).tile=asc("@")
tiles(264).col=10
tiles(264).desc="company cruiser"
tiles(264).seetru=1
tiles(264).walktru=5
tiles(264).firetru=1
tiles(264).shootable=1
tiles(264).turnsinto=3
tiles(264).dr=2
tiles(264).hp=225
tiles(264).succt="It is slightly dented now"
tiles(264).failt="Your handwapons arent powerful enough to damage a spaceship"
tiles(264).killt="That will teach those megacorps a lesson!"
tiles(264).hides=2

tiles(265).tile=asc("A") 'Arena
tiles(265).gives=44
tiles(265).col=12

tiles(265).bgcol=7
tiles(265).hides=2
tiles(265).turnsinto=265

tiles(266).tile=asc("$") 'Casino
tiles(266).gives=45
tiles(266).seetru=1
tiles(266).col=14
tiles(266).bgcol=2
tiles(266).turnsinto=266

tiles(267).tile=128
tiles(267).col=9

tiles(268).tile=asc("Z") 'Zoo
tiles(268).gives=46
tiles(268).col=14
tiles(268).bgcol=7
tiles(268).turnsinto=268

tiles(269).tile=asc("@") 'Generation Ship landed
tiles(269).col=56
tiles(269).seetru=1
tiles(269).firetru=1
tiles(269).gives=8
tiles(269).turnsinto=269
tiles(269).hides=2

tiles(270)=tiles(69)
tiles(270).col=7
tiles(270).gives=47
tiles(270).turnsinto=270
tiles(270).hides=2

tiles(271)=tiles(69)
tiles(271).gives=48
tiles(271).turnsinto=271
tiles(271).hides=2

'272-284 taken for alien structures


tiles(286).tile=35 'Customize Item shop
tiles(286).col=17
tiles(286).desc="a building"
tiles(286).dr=4
tiles(286).shootable=1
tiles(286).hp=30
tiles(286).turnsinto=286
tiles(286).seetru=1
tiles(286).firetru=1
tiles(286).locked=0
tiles(286).hides=2
tiles(286).gives=49

tiles(287).tile=asc("O")
tiles(287).col=220
tiles(287).bgcol=7
tiles(287).desc="Admins Office"
tiles(287).shootable=1
tiles(287).hp=30
tiles(287).turnsinto=287
tiles(287).seetru=1
tiles(287).firetru=1
tiles(287).locked=0
tiles(287).hides=2
tiles(287).gives=50

tiles(288).tile=asc("C")
tiles(288).col=15
tiles(288).desc="security camera terminal"
tiles(288).turnsinto=288
tiles(288).gives=167


tiles(289).tile=176
tiles(289).col=137
tiles(289).bgcol=137
tiles(289).desc="steel wall"
tiles(289).seetru=2
tiles(289).seetru=2
tiles(289).walktru=5
tiles(289).firetru=1
tiles(289).failt="The wall is too hard"
tiles(289).turntext="You discover a well hidden secret passage!"
tiles(289).turnsoninspect=54
tiles(289).turnroll=5

tiles(290).tile=asc("R")
tiles(290).col=15
tiles(290).desc="A switched off robot"
tiles(290).turnsinto=290
tiles(290).gives=168

tiles(291).tile=asc("C")
tiles(291).col=15
tiles(291).desc="security terminal"
tiles(291).turnsinto=291
tiles(291).gives=169

tiles(292).tile=asc("C")
tiles(292).col=15
tiles(292).desc="security terminal"
tiles(292).turnsinto=292
tiles(292).gives=170

tiles(293).tile=asc("C")
tiles(293).col=15
tiles(293).desc="security terminal"
tiles(293).turnsinto=293
tiles(293).gives=171

tiles(294).tile=35 'Art Trader
tiles(294).desc="Alien art"
tiles(294).col=15
tiles(294).bgcol=7
tiles(294).seetru=1
tiles(294).firetru=1
tiles(294).gives=67
tiles(294).turnsinto=294
tiles(294).hides=2


tiles(295).tile=147
tiles(295).col=137
tiles(295).desc="geyser"
tiles(295).tohit=30
tiles(295).dam=1
tiles(295).hitt="You get sprayed with boiling water!"
tiles(295).causeaeon=16
tiles(295).aetype=3
tiles(295).spawnson=15
tiles(295).spawnswhat=96


tiles(296).tile=84 'Eris temple
tiles(296).col=14
tiles(296).bgcol=6
tiles(296).desc="A greek temple"
tiles(296).seetru=1
tiles(296).walktru=0
tiles(296).firetru=1
tiles(296).shootable=1
tiles(296).turnsinto=57
tiles(296).gives=68
tiles(296).dr=2
tiles(296).hp=100
tiles(296).succt="You damage the structure"
tiles(296).failt="The Temple withstands your fire"
tiles(296).killt="You destroy the temple. There is some very advanced machinery in the rubble."
tiles(296).hides=2


tiles(297).tile=asc("#")
tiles(297).col=15
tiles(297).desc="primitive factory"
tiles(297).hp=25
tiles(297).dr=1
tiles(297).hitt="you start to shoot up the factory"
tiles(297).turnsinto=4

tiles(298).tile=asc("C")
tiles(298).col=15
tiles(298).desc="security terminal"
tiles(298).turnsinto=298
tiles(298).gives=172

tiles(299).tile=asc("E") 'EE Office
tiles(299).col=9
tiles(299).desc="Eridiani explorations office"
tiles(299).bgcol=5
tiles(299).gives=70
tiles(299).hp=25
tiles(299).dr=1
tiles(299).hitt="you start to shoot at the eridiani explorations office"
tiles(299).turnsinto=299

tiles(300).tile=asc("S") 'SHI Office
tiles(300).desc="Smith heavy industries office"
tiles(300).col=14
tiles(300).bgcol=5
tiles(300).gives=71
tiles(300).hp=25
tiles(300).dr=1
tiles(300).hitt="you start to shoot at the smith heavy industries office"
tiles(300).turnsinto=300

tiles(301).tile=asc("T") 'TT Office
tiles(301).desc="Triax traders office"
tiles(301).col=12
tiles(301).bgcol=5
tiles(301).gives=72
tiles(301).hp=25
tiles(301).dr=1
tiles(301).hitt="you start to shoot at the triax traders office"
tiles(301).turnsinto=301

tiles(302).tile=asc("O") 'OBE Office
tiles(302).col=10
tiles(302).desc="Omega bioengineering office"
tiles(302).bgcol=5
tiles(302).gives=73
tiles(302).hp=25
tiles(302).dr=1
tiles(302).hitt="you start to shoot at the omega bioengineering office"
tiles(302).turnsinto=302

'303 is taken

tiles(304).tile=176
tiles(304).col=1    
tiles(304).bgcol=11
tiles(304).desc="huge block of ice"
tiles(304).seetru=0
tiles(304).walktru=5
tiles(304).firetru=1
tiles(304).shootable=1
tiles(304).dr=1
tiles(304).hp=9
tiles(304).turnsinto=4
tiles(304).succt="This icechunk has strange inner parts. Looks almost like organs."
tiles(304).failt="Your attempt to losen the ice fails"


tiles(305).tile=64
tiles(305).col=8
tiles(305).desc="An alien scoutship in relatively good condition"
tiles(305).hides=2
tiles(305).spawnson=25
tiles(305).spawntext="A battle robot leaves the ship!"
tiles(305).spawnswhat=8
tiles(305).spawnsmax=58
tiles(305).dam=-6
tiles(305).range=5
tiles(305).tohit=80
tiles(305).hitt="The ship fires at you as you approach!"
tiles(305).misst="The ship fires at you as you approach but misses!"
tiles(305).deadt="a landed alien scoutship"
tiles(305).firetru=1
tiles(305).shootable=1
tiles(305).dr=10
tiles(305).hp=90
tiles(305).succt="You damage the ancient alien scoutship"
tiles(305).failt="Your weapons are too weak to seriously damage the ancient alien scoutship."
tiles(305).movecost=3

tiles(306).ti_no=220
tiles(306).tile=asc("B")
tiles(306).col=102
tiles(306).desc="Bridge"
tiles(306).gives=221
tiles(306).turnsinto=306

tiles(401).tile=ASC("#")
tiles(401).col=210
tiles(401).bgcol=230
tiles(401).desc="colony"
tiles(401).gives=401
tiles(401).turnsinto=401

tiles(402).tile=ASC("0")
tiles(402).col=8
tiles(402).desc="mining base"
tiles(402).gives=402
tiles(402).turnsinto=402

tiles(403).tile=157
tiles(403).col=15
tiles(403).desc="defense tower"
tiles(403).gives=403
tiles(403).turnsinto=403

tiles(404).tile=ASC("0")
tiles(404).col=189
tiles(404).desc="raffinery"
tiles(404).gives=404
tiles(404).turnsinto=404

tiles(405).tile=ASC("0")
tiles(405).col=14
tiles(405).desc="factory"
tiles(405).gives=405
tiles(405).turnsinto=405

tiles(406).tile=ASC("#")
tiles(406).col=14
tiles(406).bgcol=3
tiles(406).desc="power plant"
tiles(406).gives=406
tiles(406).turnsinto=406

tiles(407).tile=238
tiles(407).col=10
tiles(407).desc="life support"
tiles(407).gives=407
tiles(407).turnsinto=407

tiles(408).tile=ASC("#")
tiles(408).col=15
tiles(408).desc="storage facility"
tiles(408).gives=408
tiles(408).turnsinto=408

tiles(409).tile=ASC("0")
tiles(409).col=245
tiles(409).desc="hydroponic garden"
tiles(409).gives=409
tiles(409).turnsinto=409

tiles(410).tile=ASC("#")
tiles(410).col=11
tiles(410).bgcol=1
tiles(410).desc="office building"
tiles(410).gives=410
tiles(410).turnsinto=410

tiles(411).tile=ASC("#")
tiles(411).col=7
tiles(411).desc="habitat"
tiles(411).gives=411
tiles(411).turnsinto=411
