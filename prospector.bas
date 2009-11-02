#include once "fbgfx.bi" 
#include once "file.bi"
#include once "types.bas"
#include once "tiles.bas"
#include once "fmod.bi"
#include once "math.bas" 
#include once "pirates.bas"
#include once "planet.bas" 
#include once "items.bas"
#include once "ProsIO.bas"
#include once "highscore.bas"
#include once "cargotrade.bas"
#include once "quests.bas"
#include once "spacecom.bas"
#include once "fileIO.bas"
 
on error goto errormessage

cls
' Load 
print
loadconfig
if _tiles=0 then
    if _resolution=0 then screenres 640,25*8,,GFX_FULLSCREEN
    if _resolution=1 then screenres 640,25*14,,GFX_FULLSCREEN
    if _resolution=2 then screenres 640,25*16,,GFX_FULLSCREEN
else
    if _resolution=0 then screenres 640,25*8,,GFX_WINDOWED
    if _resolution=1 then screenres 640,25*14,,GFX_WINDOWED
    if _resolution=2 then screenres 640,25*16,,GFX_WINDOWED
endif
width 80,25

for a=1 to 255
    tiles(a).no=a
next
for a=1 to 512
    gtiles(a)=imagecreate(8,16)
next

bload "tiles.bmp"
d=0
a=1
for y=0 to 96 step 16
    for x=0 to 392 step 8
        get (x,y)-(x+7,y+15),gtiles(a)
        a=a+1 
    next
next
scr=imagecreate(600,300)
cls

if chdir("savegames")=-1 then
    mkdir("savegames")
else
    chdir("..")
endif

if not fileexists("savegames/empty.sav") then
    player.desig="empty"
    savegame()
endif
print
loadkeyset
print
fsound_init(48000,11,0)
print FSOUND_geterror();
IF _Volume = 0 THEN FSOUND_SetSFXMasterVolume(0)
IF _Volume = 1 THEN FSOUND_SetSFXMasterVolume(63)
IF _Volume = 2 THEN FSOUND_SetSFXMasterVolume(128)
IF _Volume = 3 THEN FSOUND_SetSFXMasterVolume(190)
IF _Volume = 4 THEN FSOUND_SetSFXMasterVolume(255)
sound(1)= FSOUND_Sample_Load(FSOUND_FREE, "data/alarm_1.wav", 0, 0, 0)
sound(2)= FSOUND_Sample_Load(FSOUND_FREE, "data/alarm_2.wav", 0, 0, 0)
sound(3)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_1.wav", 0, 0, 0)
sound(4)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_2.wav", 0, 0, 0)
sound(5)= FSOUND_Sample_Load(FSOUND_FREE, "data/wormhole.wav", 0, 0, 0)
sound(7)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_4.wav", 0, 0, 0)
sound(8)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_3.wav", 0, 0, 0)
sound(9)= FSOUND_Sample_Load(FSOUND_FREE, "data/weap_5.wav", 0, 0, 0)
sound(10)= FSOUND_Sample_Load(FSOUND_FREE, "data/start.wav", 0, 0, 0)
sound(11)= FSOUND_Sample_Load(FSOUND_FREE, "data/land.wav", 0, 0, 0)
'
do
    
'
' Variables
'

awayteamcomp(0)=1
awayteamcomp(1)=1
awayteamcomp(2)=1
awayteamcomp(3)=1
awayteamcomp(4)=1
fightmatrix(1,2)=1
fightmatrix(1,4)=1
fightmatrix(2,1)=1
fightmatrix(2,3)=1
fightmatrix(3,2)=1
fightmatrix(3,4)=1
fightmatrix(4,1)=1
fightmatrix(4,3)=1
fightmatrix(5,1)=1
fightmatrix(5,2)=1
fightmatrix(5,3)=1
fightmatrix(5,4)=1
fightmatrix(1,5)=1
fightmatrix(2,5)=1
fightmatrix(3,5)=1
fightmatrix(4,5)=1

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

talent_desig(13)="Linguist"
talent_desig(14)="Biologist"
talent_desig(15)="Sensor expert"

talent_desig(16)="Disease expert"
talent_desig(17)="First aid expert"
talent_desig(18)="Field medic"

talent_desig(19)="Tough"
talent_desig(20)="Defensive"
talent_desig(21)="Close combat expert"
talent_desig(22)="Sharp shooter"
talent_desig(23)="Fast"
talent_desig(24)="Strong"
talent_desig(25)="Aim"


specialplanettext(0,0)=""
specialplanettext(1,0)="I got some strange sensor readings here sir. cant make any sense of it"
specialplanettext(1,1)="The readings are gone. must have been that temple."
specialplanettext(2,0)="There is a ruin of an anient city here, but i get no signs of life. Some high energy readings though."
specialplanettext(2,1)="With the planetary defense systems disabled it is safe to land here."
specialplanettext(3,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
specialplanettext(4,0)="Ruins of buildings cover the whole planet, but i get no readings on life forms"
specialplanettext(5,0)="Readings indicate almost no water, and extremly high winds. Also very strong readings for lifeforms"
specialplanettext(6,0)="The atmosphere of this planet is very peculiar. It only lets light in the UV range to the surface"
specialplanettext(7,0)="I am getting a large mass of modern alloys"
specialplanettext(7,1)="The ship is still there."
specialplanettext(8,0)="Extremly high winds and severe lightning storms on this planet"
specialplanettext(10,0)="There is a settlement on this planet. Humans"
specialplanettext(10,1)="There colony sends us greetings."
specialplanettext(11,0)="There is a ship here sending a distress signal"
specialplanettext(11,1)="They are still sending a distress signal"
specialplanettext(12,0)="This is a sight you get once in a lifetime. The orbit of this planet is unstable and it is about to plunge into its sun! Gravity is ripping open its surface, solar wind blasts its material into space. In a few hours it will be gone."
specialplanettext(13,0)="A mining station on this planet sends a distress signal. They need medical help."
specialplanettext(13,1)="The mining station signals that everything is alright."
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
specialplanettext(27,0)="This small planet has no atmosphere. A huge and unusually deep crater dominates it's surface."
specialplanettext(27,1)="The Planetmonster is dead."
specialplanettext(28,1)="The plants on this planet cause hallucinations."
specialplanettext(29,0)="This is the most boring piece of rock I ever saw. Just a featureless plain of stone."
specialplanettext(30,0)="I don't know why, but this planet has a temperate climate now. There are signs of life and a huge structure on the western hemishpere."
specialplanettext(31,0)="There is a perfectly spherical large asteroid here. 2km diameter it shows no signs of any impact craters and reads very high metals"
specialplanettext(32,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures."
specialplanettext(33,0)="There is a huge asteroid here. It has a very low mass though. I am also getting faint energy signatures. There are ships on the surface"
specialplanettext(34,0)="I am getting very, very high radiaton readings for this planet. Landing here might be dangerous."
specialplanettext(35,0)="This planets surface is covered completely in liquid."
specialplanettext(37,0)="There is a huge lutetium deposit here."

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

for a=1 to 5
    avgprice(a)=baseprice(a)
next

for a=0 to 10
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
next


if fileexists("data/ships.csv") then
    f=freefile
    open "data/ships.csv" for input as #f
    b=1
    do
        line input #f,text
        do
            shiptypes(c)=shiptypes(c)&mid(text,b,1)
            b=b+1
        loop until mid(text,b,1)=";"
        c=c+1
        b=1
    loop until eof(f)
    close #f
    shiptypes(17)="an alien vessel"
    shiptypes(18)="An ancient alien scoutship. It's hull covered in tiny impact craters"
    shiptypes(19)="A primitve alien spaceprobe, hundreds of years old travelling sublight through the void"
else
    color 14,0
    print "ships.csv not found. Can't start game"
    sleep
    end
endif

disease(1).no=1
disease(1).desig="light cough"
disease(1).ldesc="a light cough caused by airborne bacteria"
disease(1).duration=3
disease(1).cause="bacteria"
disease(1).fatality=5
disease(1).att=-1

disease(2).no=2
disease(2).desig="heavy cough"
disease(2).ldesc="a heavy cough caused by airborne virii"
disease(2).duration=4
disease(2).cause="viri"
disease(2).fatality=5
disease(2).att=-1
disease(2).oxy=1

disease(3).no=3
disease(3).desig="fever and light cough"
disease(3).ldesc="a light cough and fever caused by airborne bacteria"
disease(3).duration=5
disease(3).cause="bacteria"
disease(3).fatality=8
disease(3).att=-1
disease(3).dam=-1
disease(3).oxy=1


disease(4).no=4
disease(4).desig="heavy fever and light cough"
disease(4).ldesc="a heavy cough and fever caused by airborne bacteria"
disease(4).duration=6
disease(4).cause="bacteria"
disease(4).fatality=12
disease(4).att=-1
disease(4).dam=-2
disease(4).oxy=2

disease(5).no=5
disease(5).desig="fever and shivering"
disease(5).ldesc="a light fever and shivering caused by virii"
disease(5).duration=15
disease(5).cause="viri"
disease(5).fatality=15
disease(5).att=-2
disease(5).dam=-2
disease(5).oxy=2

disease(6).no=6
disease(6).desig="shivering and boils"
disease(6).ldesc="shivering and boils caused by parasitic lifeforms"
disease(6).duration=15
disease(6).cause="mircroscopic parasitic lifeforms"
disease(6).fatality=25
disease(6).att=-3
disease(6).dam=-2
disease(6).oxy=3

disease(7).no=7
disease(7).desig="muscle cramps"
disease(7).ldesc="shivering and muscle cramps caused by virii"
disease(7).duration=15
disease(7).cause="viri"
disease(7).fatality=25
disease(7).att=-4
disease(7).dam=-2
disease(7).oxy=4

disease(8).no=8
disease(8).desig="vomiting and coughing of blood"
disease(8).ldesc="vomiting and coughing of blood caused by bacteria"
disease(8).duration=15
disease(8).cause="bacteria"
disease(8).fatality=25
disease(8).att=-5
disease(8).dam=-2

disease(9).no=9
disease(9).desig="blindness"
disease(9).ldesc="blindness, caused by bacteria attacking the optic nerve"
disease(9).duration=15
disease(9).cause="bacteria"
disease(9).fatality=5
disease(9).bli=55

disease(10).no=10
disease(10).desig="fever and suicidal thoughts"
disease(10).ldesc="a strong fever, shivering and boils caused by a parasitic lifeform attacking the brain."
disease(10).duration=15
disease(10).cause="mircroscopic parasitic lifeforms"
disease(10).fatality=5
disease(10).att=-6
disease(10).dam=-1

disease(11).no=11
disease(11).desig="balance impairment"
disease(11).ldesc="a strong fever and balance impairment caused by virii infecting the inner ear"
disease(11).duration=15
disease(11).cause="viri"
disease(11).fatality=5
disease(11).att=-7
disease(11).dam=-1

disease(12).no=12
disease(12).desig="rash"
disease(12).ldesc="a rash caused by bacteria nesting on the patients skin"
disease(12).duration=25
disease(12).cause="bacteria"
disease(12).fatality=5
disease(12).att=-1
disease(12).dam=-1

disease(13).no=13
disease(13).desig="hallucinations"
disease(13).ldesc="severe hallucinations caused by virii attacking the central nervous system"
disease(13).duration=25
disease(13).cause="mircroscopic parasitic lifeforms"
disease(13).fatality=5
disease(13).hal=25

disease(14).no=14
disease(14).desig="narcolepsy"
disease(14).ldesc="a virus triggers the sleep center of the victims brain."
disease(14).duration=255
disease(14).cause="viri"
disease(14).fatality=45
disease(14).nac=45

disease(15).no=15
disease(15).desig="bleeding from eye sockets and mouth."
disease(15).ldesc="bleeding from eye sockets, mouth, nose, ears and fingernails caused by very agressive fast breeding bacteria, consuming the patients tissue."
disease(15).duration=3
disease(15).cause="agressive bacteria"
disease(15).fatality=65
disease(15).att=-3
disease(15).dam=-3
disease(15).bli=10

disease(16).no=16
disease(16).desig="radiation sickness"
disease(16).ldesc="coughing, loosing of hair, caused by damage to the cells through radiation"
disease(16).duration=255
disease(16).cause="radiation"
disease(16).fatality=35
disease(16).att=-8
disease(16).dam=-3

disease(17).no=17
disease(17).desig="zombie disease"
disease(17).duration=15
disease(17).fatality=85

lastwaypoint=6

targetlist(0)=basis(0).c
targetlist(1).x=rnd_range(0,30)
targetlist(1).y=rnd_range(15,20)
targetlist(2)=basis(1).c

targetlist(3).x=rnd_range(0,60)
targetlist(3).y=rnd_range(1,20)

targetlist(4).x=rnd_range(30,59)
targetlist(4).y=rnd_range(15,20)
targetlist(5)=basis(2).c
targetlist(6).x=rnd_range(0,60)
targetlist(6).y=rnd_range(0,20)

rerollshops
'generate starmap
color 14,0
print
Print " generating "
color 7,0
c=0
for a=0 to laststar
    print ".";
        map(a).c.x=rnd_range(0,sm_x)
        map(a).c.y=rnd_range(0,sm_y)
        if rnd_range(1,100)<36 then
            map(a).spec=rnd_range(2,4)
        else
            map(a).spec=rnd_range(1,7)
        endif
        if rnd_range(1,100)<91 then
            for b=1 to 9
                map(a).planets(b)=rnd_range(1,24)-((map(a).spec-3)^2+rnd_range(1,12))
                if map(a).planets(b)>0 then                    
                    if rnd_range(1,100)<77 then
                        c=c+1
                        map(a).planets(b)=c
                    else
                        if rnd_range(1,100)<64 then
                            map(a).planets(b)=-rnd_range(1,6)
                            astcou=astcou+1
                        else
                            if rnd_range(1,100)<45+b*5 then
                                if b<7 then
                                    map(a).planets(b)=-20001
                                else
                                    map(a).planets(b)=-20002
                                endif
                                if b=1 then map(a).planets(b)=-20003
                                gascou=gascou+1
                            endif
                        endif
                    endif
                else
                    map(a).planets(b)=0
                endif
            next
        else
            c=c+1
            map(a).spec=8
            map(a).planets(1)=c
        endif
next
for a=laststar+1 to laststar+wormhole-1 step 2
    map(a).c.x=rnd_range(0,sm_x)
    map(a).c.y=rnd_range(0,sm_y)
    map(a).spec=9
    map(a).planets(1)=a+1
    map(a).discovered=show_all
    map(a+1).planets(1)=a
    map(a+1).c.x=rnd_range(0,sm_x)
    map(a+1).c.y=rnd_range(0,sm_y)
    map(a+1).spec=9
    map(a+1).discovered=show_all
    
next
lastplanet=c
lastportal=22

for a=0 to lastspecial
    do
        b=getrandomsystem()
        print ".";
    loop until  map(b).spec<8 
    c=getrandomplanet(b)
    if c=-1 then 
        c=rnd_range(1,9)
        map(b).planets(c)=lastplanet+1
        lastplanet=lastplanet+1
        c=lastplanet
    endif
    map(b).discovered=2
    if a=12 then
        if map(b).planets(1)<=0 then 
            map(b).planets(1)=lastplanet+1
            lastplanet=lastplanet+1
        endif
        specialplanet(a)=map(b).planets(1)
    else        
        specialplanet(a)=c
    endif
    if a=18 then
        map(b).planets(3)=lastplanet+1
        specialplanet(18)=lastplanet+1
        map(b).planets(9)=lastplanet+2
        specialplanet(19)=lastplanet+2
        lastplanet=lastplanet+2
        a=19
    endif
        
    print ".";
    if specialplanet(a)<0 then
        color 12,0
        print a;" ";b;" ";c
        print lastplanet
        no_key=keyin
        color 15,0
    endif
next

specialplanet(30)=lastplanet+1
lastplanet=lastplanet+1

for a=0 to lastportal
     
        portal(a).desig="A natural tunnel. "
        portal(a).tile=111
        portal(a).col=7
        print ".";
        portal(a).from.s=getrandomsystem
        portal(a).from.m=getrandomplanet(portal(a).from.s)
        
        if portal(a).from.m<=0 then
            b=rnd_range(1,9)
            if portal(a).from.s=-1 then
                do
                    portal(a).from.s=rnd_range(0,laststar)
                loop until map(portal(a).from.s).discovered<>2
            endif
            if map(portal(a).from.s).planets(b)<=0 then
                'makenewplanet
                lastplanet=lastplanet+1
                map(portal(a).from.s).planets(b)=lastplanet
                'print portal(a).from.s &":" & map(portal(a).from.s).planets(b)
            else
                portal(a).from.m=map(portal(a).from.s).planets(b)
            endif                
        endif
        'portal(a).from.m=map(portal(a).from.s).planets(portal(a).from.p)
        portal(a).from.x=rnd_range(1,59)
        portal(a).from.y=rnd_range(1,19)
        portal(a).dest.m=lastplanet+1
        portal(a).dest.s=portal(a).from.s
        portal(a).dest.x=rnd_range(1,59)
        portal(a).dest.y=rnd_range(1,19)
        portal(a).discovered=show_portals
        portal(a).dimod=2-rnd_range(1,4)
        portal(a).tumod=4-rnd_range(1,8)
        map(portal(a).from.s).discovered=-3
        lastplanet=lastplanet+1
        print ".";
next

for a=0 to _NoPB
    lastplanet=lastplanet+1
    pirateplanet(a)=lastplanet
    piratebase(a)=getrandomsystem
    if piratebase(a)=-1 then piratebase(a)=rnd_range(0,laststar)
    map(piratebase(a)).discovered=show_pirates
    map(piratebase(a)).planets(rnd_range(1,9))=pirateplanet(a)
    print ".";
next

'print pirateplanet
'sleep
print
print "distributing ";
for a=0 to laststar+wormhole
    map(a).discovered=show_all
    pwa(a)=map(a).c
    print ".";
next
a=distributepoints(pwa(),pwa(),laststar+wormhole)
for a=0 to laststar+wormhole
    map(a).c=pwa(a)
    print ".";
next
makeclouds
do
    c=c+1
    b=0
    for a=0 to _nopb
       if _minsafe=0 and disnbase(map(piratebase(a)).c)<4 then 
           d=rnd_range(0,laststar)
           swap map(piratebase(a)),map(d)
           piratebase(a)=d
       endif
       if abs(spacemap(map(piratebase(a)).c.x,map(piratebase(a)).c.y))>1 then 
           d=rnd_range(0,laststar)
           swap map(piratebase(a)),map(d)
           piratebase(a)=d
       endif
       b=b+disnbase(map(piratebase(a)).c)
    next
loop until b>24 or c>255


a=sysfrommap(specialplanet(20))
c=999
for b=0 to laststar
    if b<>a then
        if cint(distance(map(a).c,map(b).c))<c then
            c=cint(distance(map(a).c,map(b).c))
            d=b
        endif
    endif
next

a=sysfrommap(specialplanet(26))
swap map(a).c,map(d).c

for a=0 to laststar
    if map(a).discovered=2 then map(a).discovered=1'map(a).discovered=show_specials
    if map(a).discovered=-3 then map(a).discovered=show_portals
    if abs(spacemap(map(a).c.x,map(a).c.y))>1 then
        map(a).spec=map(a).spec+abs(spacemap(map(a).c.x,map(a).c.y))/2
        if map(a).spec>7 then map(a).spec=7
    endif
    scount(map(a).spec)+=1
    'map(a).discovered=1
next


print
for e=0 to 2
print "Moving Base ";e    
if abs(spacemap(basis(e).c.x,basis(e).c.y))<>1 then
    p2.x=0
    p2.y=0
    p1.x=basis(e).c.x
    p1.y=basis(e).c.y        
    c=1000
    for x=0 to sm_x
        for y=0 to sm_y
            if abs(spacemap(x,y))<2 then
                p2.x=x
                p2.y=y
                b=0
                for a=1 to 9
                    if a<>5 then
                        p3=movepoint(p2,a)
                        if abs(spacemap(p3.x,p3.y))<2 then b=b+1
                    endif
                next
                if b>3 and distance(p2,p1)<c then
                    basis(e).c=p2
                    c=distance(p2,p1)
                endif
            endif
        next
    next
    
endif
player.c=basis(e).c
next

print "checking for starmap errors: ";
fixstarmap()


' The probesp

for a=1 to lastdrifting
    lastplanet=lastplanet+1
    drifting(a).x=rnd_range(0,sm_x)
    drifting(a).y=rnd_range(0,sm_y)
    drifting(a).s=rnd_range(1,16)
    drifting(a).m=lastplanet
    if a=1 then drifting(a).s=17
    if a=2 then drifting(a).s=18 
    if a=3 then drifting(a).s=19 
    if drifting(a).s<=19 then makedrifter(drifting(a))
    drifting(a).p=show_all
next
drifting(1).x=map(sysfrommap(specialplanet(18))).c.x-5+rnd_range(1,10)
drifting(1).y=map(sysfrommap(specialplanet(18))).c.y-5+rnd_range(1,10)
if drifting(1).x<0 then drifting(lastdrifting).x=0
if drifting(1).y<0 then drifting(lastdrifting).y=0
if drifting(1).x>sm_x then drifting(lastdrifting).x=sm_x
if drifting(1).y>sm_y then drifting(lastdrifting).y=sm_y
planets(drifting(1).m).flavortext="You enter the alien vessel. The air is breathable. Most of the ship seems to be a huge hall illuminated in blue light. Strange trees grow in orderly rows and stranger insect creatures scurry about." 
planets(drifting(1).m).atmos=6
planets(drifting(1).m).depth=1
planets(drifting(1).m).mon=37
planets(drifting(1).m).mon2=37
planets(drifting(1).m).noamin=16
planets(drifting(1).m).noamax=26

planets(drifting(2).m).flavortext="This ship has been drifting here for millenia. The air is gone. Propably some asteroid punched a hole into the hull. Dim green lights on the floor barely illuminate the corridors."
planets(drifting(2).m).darkness=5
planets(drifting(2).m).atmos=1
planets(drifting(2).m).depth=1
planets(drifting(2).m).mon=9
planets(drifting(2).m).noamin=16
planets(drifting(2).m).noamax=26
planets(drifting(2).m).flags(6)=66
planets(drifting(2).m).flags(7)=66
planets(drifting(2).m).flags(4)=6

planets(drifting(3).m).flavortext="You dock at the ancient space probe."
planets(drifting(3).m).darkness=5
planets(drifting(3).m).atmos=1
planets(drifting(3).m).depth=1
planets(drifting(3).m).mon=0
planets(drifting(3).m).noamin=0
planets(drifting(3).m).noamax=0

if map(sysfrommap(specialplanet(17))).c.x>=sm_x-4 then map(sysfrommap(specialplanet(17))).c.x-=4
if map(sysfrommap(specialplanet(17))).c.y>=sm_y-4 then map(sysfrommap(specialplanet(17))).c.y-=4
drifting(3).x=map(sysfrommap(specialplanet(17))).c.x+rnd_range(1,3)
drifting(3).y=map(sysfrommap(specialplanet(17))).c.y+rnd_range(1,3)


do
    for c=0 to 2    
        d=0
        for a=0 to lastdrifting
            for b=0 to 2
                if drifting(a).x=basis(b).c.x and drifting(a).y=basis(b).c.y then
                    d=d+1
                    drifting(a).x=rnd_range(0,sm_x)
                    drifting(a).y=rnd_range(0,sm_y)
                endif
            next
        next
    next
loop until d=0

for a=0 to 15
    p1=rnd_point(drifting(2).m,0)
    planetmap(p1.x,p1.y,drifting(2).m)=-81
next
for a=0 to 15
    p1=rnd_point(drifting(2).m,0)
    planetmap(p1.x,p1.y,drifting(2).m)=-158
next

color 14,0
print "Universe created with "&laststar &" stars and "&lastplanet-lastdrifting &" planets."
color 15,0
print "Star distribution:"
for a=1 to 8
    print spectralname(a);":";scount(a)
next
print "Asteroid belts:";astcou
print "Gas giants:";gascou
sleep 1250
cls

if _resolution=0 then a=9
if _resolution=1 then a=13
if _resolution=2 then a=17
do
    background("title.gfx")
    color 11,0
    'draw string(457,244),"P R O S P E C T O R"
    color 15,0
    draw string(462,15*a),"1) start new game" 
    draw string(462,16*a),"2) load saved game"
    draw string(462,17*a),"3) display highscore"
    draw string(462,18*a),"4) read documentation"
    draw string(462,19*a),"5) configuration"
    draw string(462,20*a),"6) exit"
    key=keyin("123456")
    if key="2" then
        c=0
        chdir "savegames"
        text=dir$("*.sav")
        while text<>""      
            
            text=dir$()
            c=c+1
        wend
        chdir ".."
        cls
        if c=0 then 
            dprint "No Saved Games"
            no_key=keyin
            key=""
        else
    
        loadgame(getfilename())
        if player.desig="" then key=""
            player.dead=0
            if savefrom(0).map>0 then            
                landing(0)
            endif
        endif
        cls
    endif
    if key="3" then 
        player.desig=""
        highsc()
    endif
    if key="4" then manual
    if key="5" then configuration
    if key="1" then
        c=0
        chdir "savegames"
        text=dir$("*.sav")
        while text<>""      
            
            text=dir$()
            c=c+1
        wend
        chdir ".."
        cls
        
        if c>8 then
            key=""
            dprint "Too many Savegames, chose one to overwrite",14,14
            text=getfilename()
            if text<>"" then
                if askyn("Are you sure you want to delete "&text &"(y/n)") then
                    kill("savegames\"&text)
                    key="1"
                endif
            endif     
            
        endif
    endif
    
loop until key="1" or key="6" or key="2"
cls
if key="1" then
    background("chshp.gfx")
    
    text="Nil/"&makehullbox(1) &"/"&makehullbox(2) &"/"&makehullbox(3) &"/"&makehullbox(4) &"/"&makehullbox(6)
    'background("ships.gfx")
    if _startrandom=1 then b=menu("Choose ship/Scout/Long Range Fighter/Light Transport/Troop Transport/Pirate Cruiser/Random",text)
    player=makeship(1)
    addmember(1)
    addmember(2)
    addmember(3)
    addmember(4)
    addmember(5)
    if b=6 then b=rnd_range(1,4)
    c=b
    if b=5 then c=6
    upgradehull(c,player)
    if b=4 then
        player.security=5
        for c=6 to 10
            addmember(7)
        next
    endif
    for a=1 to 8
        if rnd_range(1,100)<60 then
            placeitem(rnd_item(20),0,0,0,0,-1)
        else
            placeitem(makeitem(rnd_range(3,lstcomty)),0,0,0,0,-1)
        endif
    next
    if rnd_range(1,100)<51 then
        player.weapons(1)=makeweapon(rnd_range(6,7))
    else
        player.weapons(1)=makeweapon(rnd_range(1,3))
    endif
    if b=5 then
        player.weapons(1)=makeweapon(rnd_range(1,7))
        player.weapons(2)=makeweapon(99)
        recalcshipsbays()
        player.security=1
        player.engine=2
        player.pirate_agr=-100
        player.merchant_agr=100
        player.c=map(piratebase(0)).c
        lastfleet=5
        for a=1 to 5
            fleet(a)=makemerchantfleet
            fleet(a).c=basis(rnd_range(0,2)).c
        next
    endif
    'placeitem(makeitem(49),0,0,0,0,-1)
    'placeitem(makeitem(89),0,0,0,0,-1)
    cls
    color 11,0
    if b<5 then
        print 
        print "An unexplored sector of the galaxy. You are a private Prospector."
        print "You can earn money by mapping planets and finding resources."
        print "Your goal is to earn 100.000 Credits"
        print ""
        print "But beware of alien lifeforms and pirates"
        print "You start your career with a nice little "&player.h_desig
        print "You christen the beauty:"
    else
        print
        print "A life of danger and adventure awaits you, harassing the local"
        print "shipping lanes as a pirate. It won't be easy but if you manage to get"  
        print "100.000 Credits you will be able to spend the rest of your life in luxury."
        print
        print "You start your career with a nice little "&player.h_desig
        print "You christen the beauty:"
    endif
    player.desig=gettext(0,10,13,"")
    if player.desig="" then player.desig=randomname()
    a=freefile
    text="savegames\"&player.desig &".sav"
    if open (text for input as a)=0 then
        close a
        do
            print "That ship is already registered."
            player.desig=gettext(1,10,13,"")
            if player.desig="" then player.desig=randomname()
            text="savegames\"&player.desig &".sav"    
        loop until fileexists(text)=0    
    endif
    cls
endif
if key="6" then end
if key="1" or key="2" and player.dead=0 then
if key="2" then show_stars(1)  
key=""
bload "tiles.bmp"
flip
cls
show_stars(1)
displayship(1)
do
    for a=0 to 2
        if player.c.x=basis(a).c.x and player.c.y=basis(a).c.y then
            dprint "You are at Spacestation-"& a+1 &". Press "&key_do &" to dock."
        endif
    next
    for a=0 to laststar
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then
            dPrint "A "&spectralname(map(a).spec)& ". Press "&key_sc &" to scan, "&key_la &" to land."
            if a=piratebase(0) then dprint "Lots of traffic in this system"
            displaysystem(map(a))
        endif
    next
    for a=laststar+1 to laststar+wormhole
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then
            dprint "A wormhole. Press "&key_la &" to enter it."
        endif
    next
    for a=1 to lastdrifting
        if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 and player.towed<>a then
            if player.tractor=1 then dprint "A "&shiptypes(drifting(a).s)&" is drifting in space here. "&key_do &" to dock. "&key_tow &" to tow."
            if player.tractor=0 then dprint "A "&shiptypes(drifting(a).s)&" is drifting in space here. "&key_do &" to dock."
            drifting(a).p=1
        endif
    next
    
    key=keyin(key_awayteam &key_la &key_do &key_sc & key_rename & key_comment & key_save &key_quit &key_tow)
    player=move_ship(key)
    
    if key=key_la or key=key_sc then
        pl=-1
        for a=0 to laststar
            if player.c.x=map(a).c.x and player.c.y=map(a).c.y then pl=a
        next
        
        if pl>-1 then
            if key=key_la then 
                a=getplanet(pl)
                if a>0 then
                    b=map(pl).planets(a)
                    if isgasgiant(b)=0 and b>0 then
                        landing(map(pl).planets(a))
                    else
                        if isgasgiant(b)=0 then
                            dprint"You don't find anything big enough to land on"
                        else
                            gasgiantfueling(b,a,pl)
                        endif
                    endif
                endif
            endif    
            if key=key_sc then scanning()
            key=""
        endif
        pl=-1
        for a=laststar+1 to laststar+wormhole
            if player.c.x=map(a).c.x and player.c.y=map(a).c.y then pl=a
        next
        if pl>1 and key=key_la and _warnings=0 then
            if askyn("Travelling through wormholes can be dangerous. Do you really want to?(y/n)")=0 then pl=0 
        endif
        if pl>1 and key=key_la then
            player.towed=0
            dprint "you travel through the wormhole",10,10
            if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(5))                    
    
            d=0
            if rnd_range(1,6)+rnd_range(1,6)+player.pilot<10 and artflag(13)=0 then d=rnd_range(1,6)+rnd_range(1,6)
            player.hull=player.hull-d
            if player.hull>0 then
                x2=player.c.x
                y2=player.c.y
                p1.x=x2
                p1.y=y2
                b=map(pl).planets(1)
                player.c=map(b).c
                map(b).discovered=2
                x=player.c.x-p1.x
                y=player.c.y-p1.y
                x1=x/distance(p1,player.c)
                y1=y/distance(p1,player.c)
                for b=1 to distance(p1,player.c)
                    x2=x2+x1
                    y2=y2+y1
                    color rnd_range(180,214),rnd_range(170,204)
                    if x2-player.osx>=0 and x2-player.osx<=60 and y2-player.osy>=0 and y2-player.osy<=20 then
                        locate y2+1-player.osy,x2+1-player.osx
                        print "@"
                        sleep 50
                        for c=0 to laststar+wormhole
                            if map(c).discovered>0 then displaystar(c)
                        next
                    else
                        cls
                        displayship(1)
                        show_stars(1)
                        dprint ""
                    endif
                next
                cls
                if d>0 then dprint "Your ship is damaged ("&d &").",14,14
                displayship(1)
                show_stars(1)
                dprint ""
            else
                player.dead=24
            endif
        endif
    endif
    
    if key=key_do then
        for a=0 to 3
            if player.c.x=basis(a).c.x and player.c.y=basis(a).c.y then
                if stationroll=0 or player.lastvisit.s<>a then stationroll=rnd_range(1,20)
                if player.merchant_agr+stationroll<100 then
                    b=rnd_range(1,4)
                    if player.merchant_agr>80 then
                        dprint "You have to beg to get a docking permission, exagerating the sorry state of your ship quite a bit in the process!",14,14
                        b=15
                    endif
                    if player.merchant_agr>33 then
                        if b=1 then dprint "After an unusually long waiting period you get your permission to dock.",14,14
                        if b=2 then dprint "The Station commander questions you extensively about your activities before allowing you to dock.",14,14
                    endif
                    if player.merchant_agr>66 then
                        if b=1 then dprint "After you dock you overhear a dock worker remark 'I didn't know we were allowing known pirates on the base.' He looks at you fully aware that you heard him.",14,14
                        if b=2 then dprint "A patrol boat captain bumps into you snarling 'Pirate scum. Wait till i meet you in space!'",14,14
                    endif
                    player=spacestation(a)
                    if _autosave=0 then savegame()
                    color 11,0
                    c=0
                    d=0
                    for b=0 to 10
                        if player.cargo(b).x>1 and player.cargo(b).x<7 then
                            c=c+basis(a).inv(player.cargo(b).x-1).p
                        endif
                    next
                    c=c\15
                    'dprint "pirate chance:" &c
                    if c>66 then c=66
                    ' Pirate agression test
                    for b=0 to 10
                        if player.cargo(b).x=7 then 
                            c=101
                            d=1
                        endif
                    next
                    if basis(a).spy=1 then c=0
                    for b=1 to lastfleet
                        if fleet(b).ty=2 and rnd_range(1,100)<c then
                            fleet(b).t=8
                            d=1
                        else
                            fleet(b).t=9
                        endif
                    next
                    'see if pirates notice
                    if d=1 then 
                        dprint "As you load your Cargo you notice a worker taking notes. When you want to question him he is gone."
                        no_key=keyin
                    endif
                    if player.money<0 and player.dead=0 then
                        if rnd_range(1,6)+rnd_range(1,6)+player.pilot>12 then
                            dprint "As you leave the docking bay you get a message from the station commander to return to 'solve some financial issues' first. Your pilot grins and heads for the docking bay doors, exceeding savety limits. The doors slam close right behind your ship. As you speed into space you get a radio message from the commander. He calmly explains that there *will* be a fee for that next time you dock."
                            player.money=player.money-100
                            player.pirate_agr-=1
                            player.merchant_agr+=1
                        else
                            player.dead=2
                        endif
                    endif
                else
                    dprint "The station commander closes the bay doors and fires upon you!",,12
                    player.hull=player.hull-rnd_range(1,6)
                    if player.hull<=0 then player.dead=18
                    no_key=keyin
                endif
            endif
        next
        for a=1 to lastdrifting
            if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 then driftingship(a)
        next
        
        show_stars(1)
    endif
    
    if key=key_tow then
        if player.towed=0 then
            for a=1 to lastdrifting
                if player.c.x=drifting(a).x and player.c.y=drifting(a).y and planets(drifting(a).m).flags(0)=0 then 
                    if player.tractor>0 then
                        player.towed=a
                        dprint "You tow the other ship."
                    else
                        dprint "You have no tractor beam.",14,14
                    endif
                endif
            next
        else
            player.towed=0
            dprint "You release the other ship."
        endif
    endif
    
    if key=key_awayteam then
        screenshot(1)
        showteam(0)
        screenshot(2)
    endif
    
    clearfleetlist
    if frac(player.turn/10)=0 then 
        lastfleet=lastfleet+1
        fleet(lastfleet)=makefleet(fleet(lastfleet))
    endif
    movefleets()
    collidefleets()
    for a=1 to lastfleet
        if distance(player.c,fleet(a).c)<1.5 then 
            player=meetfleet(a,player)
            exit for
        endif
    next    
    diseaserun(0)
    if frac(player.turn/10)=0 then cureawayteam(1) 
    if frac(player.turn/250)=0 then rerollshops 
    
    if player.hull<=0 and player.dead=0 then player.dead=18
    if player.fuel<=0 and player.dead=0 then rescue()
    
    if player.money>=100000 and player.dead=0 and flag(20)=0 then 
        if askyn("You have enough money to retire. Do you want to end the game? (y/n)") then
            player.dead=98
        else
            flag(20)=1
            player.score=score()
        endif
    endif
    
    if key=key_save then
        if askyn("Do you really want to save the game? (y/n)") then player.dead=savegame()
    endif
    if key=key_rename then
        if askyn("Do you want to rename your ship? (y/n)") then
            color 15,0
            locate 1,63
            print space(16)
            key=gettext(63,0,16,"")
            if key<>"" then player.desig=key
            color 11,0
            player.turn=player.turn-1
        endif
    endif
    if key=key_comment then 'Name or comment on map
        p2.x=player.c.x
        p2.y=player.c.y
        do
            key=cursor(p2,0)
            show_stars(1)
            displayship(1)
            
        loop until key=key_esc or key=key_enter or (asc(ucase(key))>64 and asc(key)<132)
        color 11,0
        
        locate p2.y+1,p2.x+1 
        b=0
        if key<>key_esc then
            for a=1 to lastcom
                if p2.y=coms(a).c.y-player.osy then
                    if p2.x>=coms(a).c.x-player.osx and p2.x<=coms(a).c.x-player.osx+coms(a).l then
                            key=trim(coms(a).t)
                            b=a
                            p2.x=coms(a).c.x
                            p2.y=coms(a).c.y
                            
                    endif
                 endif
            next
            locate p2.y+1,p2.x+1
            text=gettext(p2.x,p2.y,16,key)
            
            text=trim(text)
            cls
            show_stars(1)
            displayship(1)
            if b=0 then
                lastcom=lastcom+1
                b=lastcom
            endif
            if p2.x+player.osx+len(text)>sm_x then p2.x=sm_x-len(text)
            coms(b).c.x=p2.x+player.osx
            coms(b).c.y=p2.y+player.osy
            coms(b).t=text
            coms(b).l=len(text)
            dprint " "& b
        endif
        b=0
        for a=1 to lastcom
            if coms(a).t="" then
                coms(a)=coms(a+1)
            else
                b=b+1
            endif
        next
        cls
        lastcom=b
        show_stars
        displayship(1)
        player.turn=player.turn-1
    endif    
    player.turn=player.turn+1
    if planetmap(0,0,specialplanet(12))<>0 then planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
    if planets(specialplanet(12)).death<0 then map(sysfrommap(specialplanet(12))).planets(1)=0
    if make_files=1 and frac(player.turn/10)=0 then
        f=freefile
        open "fleets.txt" for append as #f
        print #f,player.turn
        for a=1 to lastfleet
            print #f,debug_printfleet(fleet(a))
        next
        close #f
    endif
    

    fmod_error=FSOUND_geterror()         
    if fmod_error<>0 then dprint "FMOD ERROR: "&fmod_error,14,14
    cls
    show_stars(1)
    displayship(1)
    dprint ""
loop until player.dead>0
endif
if player.dead>0 then
    text=""
    cls
    
    background("death.gfx")
    locate 3,5,0
    color 12,0
    if player.fuel<=0 then player.dead=1
    if player.dead=1 then text="You ran out of fuel. Slowly your life support fails while you wait for your end beneath the eternal stars"
    if player.dead=2 then text= "The station impounds your ship for outstanding depts. You start a new career as cook at the stations bistro"
    if player.dead=3 then text= "Your awayteam was obliterated. your Bones are being picked clean by alien scavengers under a strange sun"
    if player.dead=4 then text= "After a few months stranded on an alien world you decide to stop sending distress signals, and try to start a colony with your crew. All works really well untill one day that really big animal shows up..."
    if player.dead=5 then
        text=" "
        print "White."
        locate 4,7
        print "then all black."
        locate 5,9
        print "your ship got destroyed by pirates"
    endif
    if player.dead=6 then
        text=" "
        if flag(20)=0 then
            color 11,0
            print "Farewell Captain"
        else
            player.dead=98
        endif
    endif
    
    if player.dead=7 then text= "You didnt think the pirates base would be the size of a city, much less a whole planet. The last thing you see is the muzzle of a pirate gaussgun pointed at you."
    if player.dead=8 then text= "You think you can see a malicious grin beneath the leaves as the prehensile vines snap your neck"
    if player.dead=9 then text= "Apollo convinces you with bare fists and lightningbolts that he in fact is a god"
    if player.dead=10 then text= "The robots defending the city are old, but still very well armed and armored. Their long gone masters would have been pleased to learn how easily they repelled the intruders."
    if player.dead=11 then text= "The Sandworm swallows the last of your awayteam with one gulp"
    if player.dead=12 then text= "Too late you realize that your ship was already too damaged to further explore the gascloud. A quick run for the edge wasnt quick enough" 
    if player.dead=13 then
        print "White."
        locate 4,7
        print "then all black."
        locate 5,9
        print "your ship got destroyed by the merchants escort ships"
    endif
    if player.dead=14 then text= "You run out of oxygen on an airless world. Your death comes quick"
    if player.dead=15 then text= "With horror you watch as the ground cracks open beneath the " &player.desig &" and your ship disappears in a sea of molten lava"
    if player.dead=16 then text= "Trying to cross the lava field proved to be too much for your crew"
    if player.dead=17 then text= "The world around you dissolves into an orgy of flying rock, bright light and fire. Then all is black."
    if player.dead=18 then
        print "White."
        locate 4,7
        print "then all black."
        locate 5,9
        print "your ship got destroyed while trying to "
        locate 6,11
        print "ignore the station commanders wishes"
    endif
    if player.dead=19 then text="Your pilot crashes the ship into the asteroid. You feel very alone as you drift in your spacesuit among the debris, hoping for someone to pick up your weak distress signal."
    if player.dead=20 then text="When the monster destroys your ship your only hope is to leave the wreck in your spacesuit. With dread you watch it gobble up the debris while totally ignoring the people it just doomed to freezing among the asteroids."    
    if player.dead=21 then
        text=" "
        print "White."
        locate 4,7
        print "then all black."
        locate 5,9
        print "your ship got destroyed by an alien scoutship"
    endif
    if player.dead=22 then text="A creaking hull shows that your pilot underestimated the pressure and gravity of this gas giant. Heat rises as you fall deeper and deeper into the atmosphere with ground to hit below. Your ship gets crushed. You are long dead when it eventually gets torn apart by winds and evaporated by the rising heat."
    if player.dead=23 then text="The creatures living here tore your ship to pieces. The winds will do the same with you floating through the storms of the gas giant like a leaf in a hurricane."
    if player.dead=24 then
        text=" "
        print "White."
        locate 4,7
        print "then all colors of the rainbow."
        locate 5,9
        print "your ship got destroyed by the"
        locate 6,11
        print "strange forces inside the wormhole"
    endif
    if player.dead=25 then text="The inhabitants of the ship overpower you. Now two ships will drift through the void till the end of time."
    if player.dead=26 then text="The weapons of the Anne Bonny fire one last time before your proud ship gets turned into a cloud of hot gas."
    if player.dead=27 then text="Within seconds the refueling platform and your ship are high above you. Jetpacks won't suffice to fight against the gas giants gravity. You plunge into your fiery death."
    if player.dead=98 then 
        for a=0 to 30
            color spectraltype(map(a).spec)
            locate map(a).c.y,map(a).c.x
            print "*"
        next
        for a=1 to 80
            color 11,0
            locate 1,a
            print chr(196);
            locate 25,a
            print chr(196);
        next 
        for a=1 to 25
            locate a,1
            print chr(179);
            locate a,80
            print chr(179);
        next
        locate 1,1
        print chr(218)
        locate 1,80
        print chr(191);
        locate 25,1
        print chr(192);
        locate 25,80
        print chr(217);
        color 10,0
        locate 10,10
        print "***********************"
        locate 11,10
        print "* CONGRATULATIONS!!!! *"
        locate 12,10
        print "***********************"
        color 11,0
        locate 15,8
        print "You have enough money to retire now."
        locate 16,8
        print "you settle down in the country and bore"
        locate 17,8
        print "your children and grandchildren to death"
        locate 18,8
        print "with tall tales about your adventures under the stars..."
    endif
    if text<>"" then
        
    b=0
    while len(text)>40
        a=40
        do 
            a=a-1
        loop until mid(text,a,1)=" "        
        draw string (50,50+b*18),left(text,a)
        text=mid(text,a,(len(text)-a+1))
        b=b+1
    wend
    draw string (50,50+b*18),text
    endif
    
    if player.dead<99 then 
        no_key=keyin
        if askyn("Do you want to see the last messages again?(y/n)") then messages
        highsc()
    endif
endif
color 15,0
p1=movepoint(p1,5,0,0) 'show statistics on movepoint
if _restart=0 then 
    for a=0 to lastplanet
        planets(a)=planets(lastplanet+1)
        for x=0 to 60
            for y=0 to 20
                planetmap(x,y,a)=0
            next
        next
    next    
    loadgame("empty.sav")
        
    basis(0).c.x=50
    basis(0).c.y=20
    basis(0).discovered=1
    basis(0)=makecorp(0)
    
    basis(1).c.x=10
    basis(1).c.y=25
    basis(1).discovered=1
    basis(1)=makecorp(0)
    
    basis(2).c.x=75
    basis(2).c.y=10
    basis(2).discovered=1
    basis(2)=makecorp(0)
    
    basis(3).c.x=-1
    basis(3).c.y=-1
    basis(3).discovered=0
    
    baseprice(1)=50
    baseprice(2)=200
    baseprice(3)=500
    baseprice(4)=1000
    baseprice(5)=2500
    
    for a=0 to 10
        basis(a).inv(1).n="Food"
        basis(a).inv(1).v=rnd_range(1,6)+4
        basis(a).inv(1).p=50
        
        basis(a).inv(2).n="Basic Goods"
        basis(a).inv(2).v=rnd_range(1,7)+3
        basis(a).inv(2).p=200
        
        basis(a).inv(3).n="Tech Goods"
        basis(a).inv(3).v=rnd_range(1,8)+2
        basis(a).inv(3).p=500
        
        basis(a).inv(4).n="Luxury Goods"
        basis(a).inv(4).v=rnd_range(1,8)+1
        basis(a).inv(4).p=1000
        
        basis(a).inv(5).n="Weapons"
        basis(a).inv(5).v=rnd_range(1,8)
        basis(a).inv(5).p=2500
    next
    
    lastwaypoint=6
    
    targetlist(0)=basis(0).c
    targetlist(1).x=rnd_range(0,30)
    targetlist(1).y=rnd_range(15,20)
    targetlist(2)=basis(1).c
    
    targetlist(3).x=rnd_range(0,60)
    targetlist(3).y=rnd_range(1,20)
    
    targetlist(4).x=rnd_range(30,59)
    targetlist(4).y=rnd_range(15,20)
    targetlist(5)=basis(2).c
    targetlist(6).x=rnd_range(0,60)
    targetlist(6).y=rnd_range(0,20)
    endif
loop until _restart=1
fSOUND_close
end


sub landing(mapslot as short,lx as short=0,ly as short=0,test as short=0)
    dim as short l,m,a,b,c,dis,alive,dead,roll,target,xx,yy,slot,sys
    dim light as single
    dim p as cords
    dim last as short
    dim awayteam as _monster
    dim nextmap as gamecords
    p.x=lx
    p.y=ly
    if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(11))
    for b=0 to laststar
        for c=1 to 9
            if mapslot=map(b).planets(c) then 
                slot=c
                sys=b
            endif
        next
    next
    if savefrom(0).map=0 then
        if mapslot=specialplanet(29) and findbest(89,-1)>0 then mapslot=specialplanet(30)
        if mapslot=specialplanet(30) and findbest(89,-1)=-1 then mapslot=specialplanet(29)
        if mapslot=specialplanet(29) then specialflag(30)=1
        if _warnings=0 and player.hull=1 then
            if not askyn("Pilot: 'Are you sure captain? I can't guarantee i get this bucket up again'(Y/N)",14) then return
        endif
        if mapslot>0 then
            cls
            if planetmap(0,0,mapslot)=0 then makeplanetmap(mapslot,slot,map(sys).spec)
            displayplanetmap(mapslot)
            awayteam.hp=0
            for b=1 to 128
                if crew(b).hpmax>0 and crew(b).disease>0 then crew(b).onship=1
                if crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0 then 
                    awayteam.hp+=1
                    crew(b).hp=crew(b).hpmax
                endif
            next
            'awayteam.hpmax=awayteam.hp
            if player.dead=0 then
                do
                    if lx=0 and ly=0 then p=rnd_point(mapslot,0)
                loop until tiles(abs(planetmap(p.x,p.y,mapslot))).locked=0 and tiles(abs(planetmap(p.x,p.y,mapslot))).gives=0 and abs(planetmap(p.x,p.y,mapslot))<>45 
                if ((mapslot=pirateplanet(0) or mapslot=pirateplanet(1) or mapslot=pirateplanet(2)) and player.pirate_agr<=0) or isgasgiant(mapslot)<>0 then
                    for x=0 to 60
                        for y=0 to 20
                            if abs(planetmap(x,y,mapslot))=68 and last<128 then
                                last+=1
                                pwa(last).x=x
                                pwa(last).y=y
                            endif
                        next
                    next
                    p=pwa(rnd_range(1,last))
                endif
                player.landed.x=p.x
                player.landed.y=p.y
                player.landed.m=mapslot
                nextmap=player.landed
                equipawayteam(player,awayteam,mapslot)
                awayteam.oxygen=awayteam.oxymax
                awayteam.jpfuel=awayteam.jpfuelmax
            endif
            if awayteam.stuff(8)=1 then dprint "You deploy your satellite"
            roll=rnd_range(1,6)+rnd_range(1,6)+player.pilot+addtalent(2,8,1)
            target=planets(mapslot).dens+2*planets(mapslot).grav
            if mapslot<>specialplanet(2) and test=0 then
                if roll>target then
                    dprint ("Your pilot succesfully landed in the difficult terrain",,10) 
                    player.fuel=player.fuel-1
                    gainxp(2)
                else
                    dprint ("your pilot damaged the ship trying to land in difficult terrain.",,12)
                    player.hull=player.hull-1
                    player.fuel=player.fuel-2-int(planets(mapslot).grav)
                    if player.hull=0 then
                        dprint ("A Crash landing. you will never be able to start with that thing again",,12)
                        if rnd_range(1,6)+rnd_range(1,6)+player.pilot>10 then
                            dprint ("but your pilot wants to try anyway and succeeds!",,12)
                            player.hull=1
                        else
                            player.dead=4
                        endif
                        no_key=keyin
                    endif
                endif
            endif
        endif
        else
            awayteam=savefrom(0).awayteam
            nextmap=savefrom(0).ship
            nextmap.m=savefrom(0).map
        endif
        if player.dead=0 and awayteam.hp>0 then
            if isgardenworld(nextmap.m) then changemoral(3,0)
            do
                
                equipawayteam(player,awayteam,mapslot)
                nextmap=exploreplanet(awayteam,nextmap,slot)
                cls
                removeequip
                
                for b=6 to 128
                    if crew(b).hp=0 then
                        crew(b)=crew(0)
                    else
                        c+=1
                    endif
                next
                if c>127 then c=127
                for b=6 to c-1
                    if crew(b).hpmax=0 then swap crew(b),crew(b+1)
                next
            loop until nextmap.m=-1 or player.dead<>0
            for c=0 to 127
                for b=5 to 127
                    if crew(b).hp<=0 then swap crew(b),crew(b+1)
                next
                
            next
            
            removeequip
            'artifacts?
            if reward(5)>0 then
                if reward(5)=1 then 
                    player.fuelmax=200
                endif
                if reward(5)=2 then
                    player.stuff(1)=3
                endif
                if reward(5)=3 then
                    slot=getrandomsystem()
                    if slot<0 then slot=rnd_range(0,laststar)
                    map(slot).discovered=1
                    for b=1 to 9
                        if map(slot).planets(b)>0 then
                        if planetmap(0,0,map(slot).planets(b))=0 then makeplanetmap(map(slot).planets(b),b,map(sys).spec)
                        reward(0)=reward(0)+1200
                        reward(7)=reward(7)+600
                        for xx=0 to 60
                            for yy=0 to 20
                                if planetmap(xx,yy,map(slot).planets(b))<0 then planetmap(xx,yy,map(slot).planets(b))=planetmap(xx,yy,map(slot).planets(b))*-1
                            next
                        next
                        endif
                    next
                    dprint "the data from the computer describes a system with the coordinates "& map(slot).c.x &":" & map(slot).c.y
                endif
                if reward(5)=4 then 
                    player.stuff(2)=3
                endif
                if reward(5)=5 then
                    player.stuff(0)=3
                endif
                reward(5)=0
                
            endif
        endif
        c=6
        dis=0
        for b=6 to 128
            if crew(b).hp=0 then
                crew(b)=crew(0)
            else
                if crew(b).disease>dis then dis=crew(b).disease
                c+=1
            endif
        next
        awayteam.disease=dis
        for a=0 to c-1
            for b=6 to c-1
                if crew(b).hpmax=0 then swap crew(b),crew(b+1)
            next
        next
        for b=1 to lastitem
            if item(b).w.s<0 then 
                item(b).w.s=-1
                item(b).w.m=0
                item(b).w.p=0
            endif
        next
        player.landed.m=0
        show_stars(1)
        displayship
        if awayteam.stuff(8)=1 then 
            if rnd_range(1,6)+rnd_range(1,6)+player.pilot+player.tractor>6 then
                dprint "You rendevouz with your satellite and take it back in"
            else
                dprint "When trying to rendevouz with your satellite your pilot rams and destroys it.",12,12
                item(findbest(10,-1))=item(lastitem)
                lastitem=lastitem-1
                no_key=keyin
            endif
        else
            dprint ""
        endif
    
end sub

sub scanning()
    dim mapslot as short
    dim as short slot
    dim sys as short
    dim scanned as short
    dim a as short
    dim b as short
    dim x as short
    dim y as short
    dim key as string
    dim as single roll,target
    'if getsystem(player)>0 then
    a=getplanet(getsystem(player))
    slot=a
    if a>0 then 
        sys=getsystem(player)
        mapslot=map(sys).planets(a)
        if mapslot=specialplanet(29) and findbest(89,-1)>0 then mapslot=specialplanet(30)
        if mapslot=specialplanet(30) and findbest(89,-1)=-1 then mapslot=specialplanet(29)
        if mapslot=specialplanet(29) then specialflag(30)=1
        if mapslot<0 and mapslot>-20000 then asteroidmining(mapslot)
        if mapslot=-20001 then dprint "A helium-hydrogen gas giant"
        if mapslot=-20002 then dprint "A methane-ammonia gas giant"
        if mapslot=-20003 then dprint "A hot jupiter"
        if mapslot<-20000 or isgasgiant(mapslot)>0 then gasgiantfueling(mapslot,a,sys)
        if mapslot>0 and isgasgiant(mapslot)=0 then
        if planetmap(0,0,mapslot)=0 then
            makeplanetmap(mapslot,a,map(sys).spec)
            'makefinalmap(mapslot)
        endif
        
        for x=60 to 0 step -1
            for y=0 to 20
                target=10+(planets(mapslot).mapped/100*player.sensors)+planets(mapslot).dens 
                if abs(planetmap(x,y,mapslot))=8 then target=target-1 
                if abs(planetmap(x,y,mapslot))=7 then target=target-2 
                roll=rnd_range(1,6)+rnd_range(1,6)+minimum(player.science+1,player.sensors)
                if  roll>target and planetmap(x,y,mapslot)<0 then
                    planetmap(x,y,mapslot)=planetmap(x,y,mapslot)*-1
                    reward(0)=reward(0)+.5
                    reward(7)=reward(7)+planets(mapslot).mapmod
                    scanned=scanned+1
                endif
            next
        next
        for b=1 to lastitem
            if item(b).w.m=mapslot and item(b).w.p=0 and item(b).w.s=0 then
                target=(7+planets(mapslot).dens)*item(a).scanmod 
                roll=(rnd_range(1,6)+rnd_range(1,6)+addtalent(4,15,1)+minimum(player.science,player.sensors))*item(b).scanmod
                if roll>target then item(b).discovered=1
            endif
        next
        planets(mapslot).mapped=planets(mapslot).mapped+scanned
        if scanned>50 then gainxp(4)
        cls
        displayplanetmap(mapslot)
        dplanet(planets(mapslot),a,scanned)
        if mapslot=pirateplanet(0) then
            dprint "Science Officer: 'I am picking up signs of civilisation on this planet'"
        endif
        for a=0 to lastspecial
            if mapslot=specialplanet(a) then 
                dprint specialplanettext(a,specialflag(a))
            endif
        next
        no_key=keyin
        cls
        if no_key=key_la then key=key_la
        if rnd_range(player.pilot,6)+rnd_range(1,6)+player.pilot<8 and player.fuel>30 then
            dprint "your pilot had to correct the orbit.",14,14
            x=rnd_range(1,4)-player.pilot
            if x<1 then x=1
            player.fuel=player.fuel-x
            displayship
        endif
        endif
        if key=key_la then landing(map(sys).planets(slot))
    endif
    show_stars(1)
end sub

sub asteroidmining(byref slot as short)
    dim it as _items
    dim en as _fleet
    dim as short f,q,m,roll
    dim mon(6) as string
    mon(1)="a huge crystaline lifeform, vaguely resembling a spider. It jumps from asteroid to asteroid, it's diet obviously being metal ores. Looks like it has just put our ship on the menu! It is  coming this  way!"
    mon(2)="a huge lifeform made entirely of metal! It is spherical and drifts among the astroids. There are no detectable means of locomotion, except for 3 openenings at the equator. It is radiating high amounts of heat, especially at those openings. Looks like it is a living, moving fission reactor!"
    mon(3)="a dense cloud of living creatures, from microscopic to about 10cm long. They seem to be living insome kind of symbiosis, with different specimen performing different tasks."
    mon(4)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(5)="an enormous blob of living plasma!"
    mon(6)="a gigantic creature resembling a jellyfish!"
    m=rnd_range(1,6)
    roll=rnd_range(1,100)
    slot=slot-rnd_range(1,3)
    player.fuel=player.fuel-1
    if rnd_range(1,6)+rnd_range(1,6)+player.pilot<9 then player.fuel=player.fuel-rnd_range(1,3)
    if slot<-21 and slot>-25 then
        dprint "you have discovered a dwarf planet among the asteroids!"
        no_key=keyin
        lastplanet=lastplanet+1
        slot=lastplanet
    else
        f=rnd_range(1,6)+rnd_range(1,6)+player.tractor*2+minimum(player.science+1,player.sensors+1)+addtalent(2,9,2)
        if f+slot>5 then
            do
                it=makeitem(96,f+slot+15,-2)
            loop until it.ty=15
            if askyn("Science officer: 'There is an asteroid containing a high ammount of "&it.desig &". shall we try to take it aboard?'(y/n)") then 
                displayship()                            
                q=-1
                do                                        
                    if _warnings=0 and player.hull=1 then 
                        q=askyn("Pilot: 'If i make a mistake it could be fatal. Shall I really try?'(y/n)")
                    endif
                    if q=-1 then
                        if rnd_range(1,6)+rnd_range(1,6)+player.pilot+player.tractor*2>7+rnd_range(1,6) then
                            q=0
                            placeitem((it),0,0,0,0,-1)
                            reward(2)=reward(2)+it.v5
                            dprint "We got it!",10,10
                        else
                            player.hull=player.hull-1
                            displayship()
                            dprint "Your pilot hit the asteroid, damaging the ship, and changing the asteroids trajectory.",14,14
                            if player.hull>0 then
                                q=askyn("try again? (y/n)")
                                if q=-1 then 
                                    dprint "Pilot: 'starting another attempt.'"
                                    sleep 300
                                endif
                            else
                                q=0
                                player.dead=19
                                exit sub
                            endif
                        endif
                    endif
                    player.fuel=player.fuel-rnd_range(1,3)
                    roll=roll-1
                    if roll<7 then q=0
                    if player.fuel<10 then player.fuel=10
                loop until q=0
            else
                slot=slot+rnd_range(1,2)
                if slot>=0 then slot =-1
            endif
        else
            dprint "Nothing remarkable."
        endif
    endif
    if roll<4 then
        if rnd_range(1,100)<85 then
            dprint "A ship has been hiding among the asteroids.",14,14
            if player.pirate_agr<0 then
                dprint "It hails us.",10,10
            else
                dprint "It attacks!",12,12
                no_key=keyin
                if rnd_range(1,6)<5 then
                    en.mem(1)=makeship(3)
                else
                    en.mem(1)=makeship(4)
                endif
                no_key=keyin
                player=spacecombat(player,en,6)
                if player.dead<0 then player.dead=0
            endif
        else
            dprint "A ship has been hiding among the asteroids.",14,14
            no_key=keyin
            dprint "Wait. that is no ship. It is  "&mon(m) &"!",14,14
            no_key=keyin
            en.mem(1)=makeship(20+m)
            player=spacecombat(player,en,6)
            
            if player.dead>0 then 
                player.dead=20
            else
                if player.dead=0 then
                    dprint "We got very interesting sensor data from that being.",10,10
                    reward(1)=reward(1)+rnd_range(10,180)*rnd_range(1,maximum(player.science,player.sensors))
                    player.alienkills=player.alienkills+1
                else
                    player.dead=0
                endif
            endif
        endif
        cls
        displayship()
        show_stars(1)
    endif
end sub

sub gasgiantfueling(p as short, orbit as short, sys as short)
    dim as short fuel,roll,noa,a,mo,m
    dim en as _fleet
    dim as string mon(6)
    mon(1)="a giant wormlike creature. It's biochemistry is based on liquid hydrogen. The heat of our engines is attracting it."
    mon(2)="an enormous blob of living plasma!"
    mon(3)="a gigantic creature resembling a jellyfish!"
    mon(4)="a flock of large tube shaped creatures with wide maws and sharp teeth!"
    mon(5)="a huge balloon floating in the wind with five, thin, several kilometers long tentacles!"
    mon(6)="a circular flat being floating among the clouds. Three bulges on the top are glowing with static electricity." 
    if p=-20003 then mo=2
    m=isgasgiant(p)
    if isgasgiant(p)>1 then
        if planetmap(0,0,m)<>0 then makespecialplanet(m)
        if askyn("As you dive into the upper atmosphere of the gas giant your sensor pick up a huge metal structure. It is a platform, big enough to land half a fleet on it, connected to struts that extend out into the atmosphere. Do you want to try to land on it? (y/n)") then
            landing(map(sys).planets(orbit))
            return
        else
            p=-20001
            
        endif
    endif
        
    if player.fuel<player.fuelmax then
        if askyn("Do you want to refuel in the gas giants atmosphere?(y/n)") then
            if _warnings=0 and player.hull=1 then
                if not(askyn("Pilot: 'If i make a mistake we are doomed. Do you really want to try it? (Y/N)")) then exit sub
            endif
            if rnd_range(1,6)+rnd_range(1,6)+player.pilot+addtalent(2,9,1)<=8+mo then
                dprint "Your Pilot damaged the ship diving into the dense atmosphere",12,12
                player.hull=player.hull-rnd_range(1,2)
                if p=-20003 then player.hull=player.hull-1
                displayship
            endif
            if player.hull>0 then
                fuel=rnd_range(3,9)+addtalent(2,9,3)
                if p=-20001 then fuel=fuel+rnd_range(3,9)
                if p=-20003 then fuel=fuel+rnd_range(5,15)
                dprint "You take up "&fuel & " tons of fuel.",10,10
                player.fuel=player.fuel+fuel
                if player.fuel>player.fuelmax+player.fuelpod then player.fuel=player.fuelmax+player.fuelpod
                displayship
            else
                player.dead=22
            endif
        
            if rnd_range(1,100)<38-orbit*2 and player.dead=0 then
                roll=rnd_range(1,6)
                dprint "While taking up fuel your ship gets attacked by "&mon(roll)
                no_key=keyin
                noa=1
                if roll=4 then noa=rnd_range(1,6)+rnd_range(1,6)
                if roll=5 then noa=rnd_range(1,3)
                if roll=6 then noa=rnd_range(1,2)
                for a=1 to noa
                    en.mem(a)=makeship(23+roll)
                next
                player=spacecombat(player,en,7)
            
                if player.dead>0 then 
                    player.dead=23
                else
                    if player.dead=0 then
                        dprint "We got very interesting sensor data during this encounter.",10,10
                        reward(1)=reward(1)+(roll*3+rnd_range(10,80))*rnd_range(1,maximum(player.science,player.sensors))
                        player.alienkills=player.alienkills+1
                    else
                        player.dead=0
                    endif
                endif
            endif
        endif
    endif
end sub    

sub driftingship(a as short)
    dim as short m,b,c,x,y
    dim p(1024) as cords
    dim land as gamecords
    m=drifting(a).m
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,m))=203 then 
                b+=1
                p(b).x=x
                p(b).y=y
            endif
        next
    next
    c=rnd_range(1,b)
    land.x=p(c).x
    land.y=p(c).y
    land.m=m
    landing(m,p(c).x,p(c).y,1)
end sub

sub moverover(pl as short)
    dim as integer a,b,c,i,t,ti,x,y
    dim as single minebase
    dim as cords p1,p2
    dim as cords pp(9)
    t=(player.turn-planets(pl).visited)*5
    for a=0 to lastitem
        if item(a).ty=18 and item(a).w.p=0 and item(a).w.s=0 and item(a).w.m=pl then i=a
    next
    if i>0 and t>0 then
        p1.x=item(i).w.x
        p1.y=item(i).w.y
        for a=0 to t
            for x=item(i).w.x-item(i).v1-3 to item(i).w.x+item(i).v1+3
                for y=item(i).w.y-item(i).v1-3 to item(i).w.y+item(i).v1+3
                    if x>=0 and y>=0 and x<=60 and y<=20 then
                        p2.x=x
                        p2.y=y
                        if distance(p1,p2)<=item(i).v1+1 and planetmap(x,y,pl)<0 then
                            planetmap(x,y,pl)=planetmap(x,y,pl)*-1
                            item(i).v6=item(i).v6+0.5*item(i).v3
                        endif
                    endif
                next
            next
            'make list
            c=0
            for b=1 to 9
                if b<>5 then
                    pp(c)=movepoint(p1,b)
                    ti=abs(planetmap(pp(c).x,pp(c).y,pl))
                    if tiles(ti).walktru<=item(i).v2 then c=c+1
                endif
            next
            if c>0 then p1=pp(rnd_range(0,c-1))
            
        next
        item(i).w.x=p1.x
        item(i).w.y=p1.y
        if rnd_range(1,150)<planets(pl).atmos*2 then item(i).discovered=0
        if rnd_range(1,150)<planets(pl).atmos+2 then 
            item(i)=makeitem(65)
        else
            dprint "Receiving the homing signal of a rover on this planet",10,10
        endif
    endif
    i=0
    for a=0 to lastitem
        if item(a).ty=27 and item(a).w.p=0 and item(a).w.s=0 and item(a).w.m=pl then i=a
        if item(a).ty=15 and item(a).w.p=0 and item(a).w.s=0 and item(a).w.m=pl then 
            minebase+=1.1
            if rnd_range(1,100)<10 then destroyitem(a)
        endif
    next
    if i>0 and t>0 then
        p1.x=item(i).w.x
        p1.y=item(i).w.y
        for x=0 to 60
            for y=0 to 20
                p2.x=x
                p2.y=y
                if abs(planetmap(x,y,pl))=13 then minebase=minebase+2/distance(p1,p2)
                if abs(planetmap(x,y,pl))=7 or abs(planetmap(x,y,pl))=8 then minebase=minebase+1/distance(p1,p2)
            next
        next
        minebase=minebase+planets(pl).atmos
        minebase=minebase+planets(pl).grav
        minebase=minebase+planets(pl).depth
        minebase=minebase+abs(spacemap(map(sysfrommap(pl)).c.x,map(sysfrommap(pl)).c.y))
        item(i).v1=item(i).v1+0.01*minebase*t*item(i).v3
        if item(i).v1>item(i).v2 then item(i).v1=item(i).v2
        if rnd_range(1,150)<planets(pl).atmos+2 then item(i)=makeitem(66)
    endif
end sub

sub rescue()
    dim a as short
    dim b as short
    dim c as short
    dim d as short
    b=256
    for a=0 to 2 'search nearest base first
        d=distance(player.c,basis(a).c)
        if d<b then
            b=d
            c=a
        endif
    next
    if b>0 and b<256 then
        dprint "Fuel tanks empty, sending distress signal!"
        no_key=keyin
        if b<5 then 
            if player.merchant_agr<100 then
                dprint "Station " &c &" answered and sent a retrieval team. You are charged "& b*100 & " Cr."
                player.money=player.money-b*100
                player.fuel=10
                player.c.x=basis(c).c.x
                player.c.y=basis(c).c.y
            else
                dprint "One of the stations answers, explaining that they will not help a known pirate like you."
                player.dead=1
            endif
        else
            dprint "You are too far out in space...."
            if rnd_range(1,100)<5 then
                dprint "Your distress signal is answered!",10,10
                b=rnd_range(1,33)+rnd_range(1,33)+rnd_range(1,33)
                dprint "A "&shiptypes(rnd_Range(0,16)) &" offers to sell you fuel to get to the nearest station for "& b &" credits per ton. ("& int(disnbase(player.c)*b) &" credits for " &int(disnbase(player.c)) &" tons)."
                if askyn("Do you accept the offer?(y/n)") then
                    if player.money>=int(disnbase(player.c)*b) then
                        player.money=player.money-disnbase(player.c)*b
                    else
                        dprint "You convince them to lower their price."
                        player.money=0
                    endif
                    player.fuel=disnbase(player.c)+2
                    no_key=keyin
                else
                    dprint "they leave again."
                    no_key=keyin
                    player.dead=1
                endif
            else
                player.dead=1
            endif
        endif
        no_key=keyin
    endif
end sub



function spacestation(st as short) as _ship
    dim as short a,b,c,d,e,wchance
    static as short hiringpool,questroll,last
    static inv(lstcomit) as _items
    dim quarantine as short
    dim i as _items
    dim key as string
    dim text as string
    dim mtext as string
    cls
    displayship
    if player.turn>0 then
        for b=2 to 128
            if Crew(b).paymod>0 and crew(b).hpmax>0 and crew(b).hp>0 then
                a=a+Wage*Crew(b).paymod
                crew(b).morale=crew(b).morale+(Wage-10)^3*(9/100)+addtalent(1,4,5)
            endif
        next
        dprint "your crew gets "&a &" Cr. in wages"        
        player.money=player.money-a
        player=levelup(player)
    endif
    if basis(st).spy=1 or basis(st).spy=2 then
        if askyn("Do you pay 100 cr. for your informant? (y/n)") then
            player.money=player.money-100
            if player.money<0 then 
                player.money=0
                dprint "He doesn't seem very happy about you being unable to pay."
            else
                player.merchant_agr=player.merchant_agr-5
            endif
        else
            basis(st).spy=3
            player.merchant_agr=player.merchant_agr+15
        endif
    endif
    if st<>player.lastvisit.s then
        gainxp(1)
        player=checkquestcargo(player,st)
        changeprices(st,(player.turn-player.lastvisit.t)\3)
        questroll=rnd_range(1,100)+10*(crew(1).talents(3))
    endif
    hiringpool=rnd_range(1,4)+rnd_range(1,4)+3       
    do
        quarantine=player.disease
        mtext="Station "& st+1 &"/ "
        mtext=mtext & basis(st).repname &" Office "
        if quarantine>6 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Equipment "
        if quarantine>6 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Sickbay / Fuel & Ammuniton / Repair / Hire Crew / Trading "
        if quarantine>5 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/ Casino "
        if quarantine>4 then mtext=mtext &"(Quar.)"
        mtext=mtext &"/Exit"
        displayship()
        a=menu(mtext)
        if a=1 then 
            if quarantine<8 then
                company(st,questroll)
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=2 then'refit
            if quarantine<9 then
                do
                    cls
                    displayship()
                    b=menu("Refit/Hull/Ships Upgrades & Weapons/Personal Equipment/Exit")
                    if b=1 then shipyard()            
                    if b=2 then shipupgrades
                    if b=3 then 'awayteam equipment
                        do
                            c=shop(st,1,"Equipment")
                            displayship
                        loop until c=-1
                        cls
                    endif
                loop until b=4
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=3 then 
            player.disease=sickbay()
            mtext="Station "& st+1 &"/ "
            mtext=mtext & basis(st).repname &" Office "
            if quarantine>6 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Equipment "
            if quarantine>6 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Sickbay / Fuel & Ammuniton / Repair / Hire Crew / Trading "
            if quarantine>5 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/ Casino "
            if quarantine>4 then mtext=mtext &"(Quar.)"
            mtext=mtext &"/Exit"            
        endif
        if a=4 then refuel()
        if a=5 then repairhull()            
        if a=6 then hiring(st,hiringpool,4)            
        if a=7 then 
            if quarantine<7 then
                trading(st)
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=8 then 
            if quarantine<5 then
                b=casino(0,st)
            else
                dprint "you are under quarantine and not allowed to enter there"
            endif
        endif
        if a=9 then
            text=""
            if player.pilot<0 then text=text &"You dont have a pilot. "
            if player.gunner<0 then text=text &"You dont have a gunner. "
            if player.science<0 then text=text &"You dont have a science officer. "
            if player.doctor<0 then text=text &"You dont have a ships doctor. "
            if player.fuel<player.fuelmax*0.5 then text=text &"You only have " &player.fuel & " fuel. "
            if player.money<0 then text=text &"You still have debts of "& player.money &" credits to pay. "
            if text<>"" and player.dead=0 then
                if askyn(text &"Do you want to leave anyway?(y/n)",14) then
                    a=9
                else 
                    a=0
                endif
            endif
        endif
    loop until a=9
    cls
    player.lastvisit.s=st
    player.lastvisit.t=player.turn
    show_stars(1)
    return player
end function



function move_ship(key as string) as _ship
    dim as short a,dam
    dim scoop as single
    dim old as cords
    a=getdirection(key)
    old=player.c
    player.c=movepoint(player.c,a,,1)
    if player.c.x<>old.x or player.c.y<>old.y then 
        if player.towed<>0 then player.fuel-=1
        if player.towed<>0 and rnd_range(1,6)+rnd_range(1,6)+player.pilot<9 then player.fuel-=1
        if spacemap(player.c.x,player.c.y)=-2 then spacemap(player.c.x,player.c.y)=2
        if spacemap(player.c.x,player.c.y)=-3 then spacemap(player.c.x,player.c.y)=3
        if spacemap(player.c.x,player.c.y)=-4 then spacemap(player.c.x,player.c.y)=4
        if spacemap(player.c.x,player.c.y)=-5 then spacemap(player.c.x,player.c.y)=5
        if spacemap(player.c.x,player.c.y)>=2 and spacemap(player.c.x,player.c.y)<=5 and _warnings=0 then        
            if not(askyn("Do you really want to enter the gascloud?(y/n)")) then player.c=old
        endif
        if spacemap(player.c.x,player.c.y)>=2 and spacemap(player.c.x,player.c.y)<=5 then        
            player.towed=0
            if rnd_range(1,6)+rnd_range(1,6)+player.pilot>6+spacemap(player.c.x,player.c.y) then
                dprint "You succesfully navigate the gascloud",,10
                player.fuel=player.fuel-rnd_range(1,3)
            else
                dam=rnd_range(1,3)+spacemap(player.c.x,player.c.y)
                if dam>player.shield then
                    dprint "your Ship is damaged",,12
                    player.hull=player.hull-dam
                    player.fuel=player.fuel-rnd_range(1,5)
                    if player.hull<=0 then player.dead=12
                endif
            endif
        endif
        drifting(player.towed).x=player.c.x
        drifting(player.towed).y=player.c.y
    endif
    if (player.c.x<>old.x or player.c.y<>old.y) and (player.c.x+player.osx<>30 or player.c.y+player.osy<>10) then 
        if player.c.x>old.x then player.osx=player.osx+1
        if player.c.x<old.x then player.osx=player.osx-1
        if player.c.y>old.y then player.osy=player.osy+1
        if player.c.y<old.y then player.osy=player.osy-1
        player.fuel=player.fuel-player.fueluse
        locate old.y+1,old.x+1
        print " "
    endif
    return player
end function

function exploreplanet(awayteam as _monster, from as gamecords, orbit as short) as gamecords
    dim as single a,b,c,d,e,f,g,x,y,sf,sf2,vismod
     
    dim as short slot,r,walking,deadcounter,ship_landing
    dim sf_what(16) as short
    dim sf_tile(16) as string*1
    dim sf_when(16) as short
    dim shipfire(16) as cords
    dim as single dawn,dawn2
    dim as string key,dkey,allowed,text,help
    dim dam as single
    dim as cords p,p1,p2,p3,nextlanding,old
    dim as gamecords ship,nextmap
    
    dim enemy(255) as _monster
    dim m(255) as single
    dim lastmet as short
    dim as single biomod
    dim mapmask(60,20) as byte
    dim vismask(60,20) as byte
    dim nightday(60,20) as byte
    dim localtemp as single
    dim spawnmask(1281) as cords
    dim lsp as short
    dim ti as short
    'dim localitem(128) as items
    dim li(128) as short
    dim lastlocalitem as short
    dim lastenemy as short
    dim diesize as short
    dim localturn as short
    dim tb as single
    dim oxydep as single
    dim lavapoint(5) as cords
    dim areaeffect(16) as _ae
    dim last_ae as short
    dim del_rec as _rect
'oob suchen

    
    
    deadcounter=0
    awayteam.c.x=from.x
    awayteam.c.y=from.y
    slot=from.m
    ship.x=player.landed.x
    ship.y=player.landed.y
    ship.m=player.landed.m
    
    lsp=0    
    for x=0 to 60
        for y=0 to 20
            if show_all=1 and planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-planetmap(x,y,slot)
            tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
            mapmask(x,y)=0
            if tmap(x,y).walktru=0 then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            endif
            if tmap(x,y).vege>0 then 
                tmap(x,y).vege=rnd_range(0,tmap(x,y).vege)
                if rnd_range(1,100)<tmap(x,y).vege/2 and slot<>specialplanet(16) then tmap(x,y).disease=rnd_range(0,tmap(x,y).vege/2)
            endif
            if planetmap(x,y,slot)=0 then
                f=freefile
                open "error.log" for append as #f
                print #f,"Tile at "&x &":"&y &":"&slot &"=0"
                close #f
                planetmap(x,y,slot)=-4
            endif
        next
    next
    
    
    
    'allowed="12346789ULXFSQRWGCHDO"&key_pickup &key_I
    allowed=key_awayteam &key_ju & key_te & key_fi &key_save &key_quit &key_ra &key_walk &key_gr &key_he &key_la &key_pickup &key_I &key_ex &key_of &key_co &key_drop & key_gr &key_wait & key_portal &key_weapons &key_oxy &key_close
    if awayteam.move=2 then allowed=allowed &key_ju
    if awayteam.move=3 then allowed=allowed &key_te
    
    if planets(slot).atmos>1 and planets(slot).atmos<7 then
        oxydep=(3-planets(slot).dens)/2
    else
        oxydep=1
    endif
    oxydep=oxydep*(planets(slot).grav/1.8)
    oxydep=oxydep-awayteam.stuff(4)-(awayteam.move/10)
    if oxydep<0 then oxydep=0
    
    diesize=planets(slot).life+rnd_range(1,3)
    lastenemy=diesize+rnd_range(0,diesize)+rnd_range(0,diesize)+rnd_range(0,diesize)+rnd_range(0,diesize)
    
    if planets(slot).noamax=0 then
        if orbit=1 then lastenemy=lastenemy-rnd_range(1,8)-rnd_range(1,5)
        if orbit=2 then lastenemy=lastenemy-rnd_range(1,8)
        if orbit=3 then lastenemy=lastenemy-rnd_range(1,6)
        if orbit=4 then lastenemy=lastenemy-rnd_range(1,6)
        if orbit=5 then lastenemy=lastenemy-rnd_range(1,8)
        if orbit=6 then lastenemy=lastenemy-rnd_range(1,8)-rnd_range(1,3)
        if orbit=7 then lastenemy=lastenemy-rnd_range(1,8)-rnd_range(1,4)
        if orbit=8 then lastenemy=lastenemy-rnd_range(1,8)-rnd_range(1,5)
        if orbit=9 then lastenemy=lastenemy-rnd_range(1,8)-rnd_range(1,6)
        lastenemy=(lastenemy*planets(slot).life)/10
        if planets(slot).atmos=1 then lastenemy=lastenemy-rnd_range(1,10)
        if lastenemy<0 then lastenemy=0
        if lastenemy>25 then lastenemy=25        
        biomod=1.1-lastenemy*4/100
    else
        lastenemy=rnd_range(planets(slot).noamin,planets(slot).noamax)
        biomod=1
    endif
    if planets(slot).atmos=0 then planets(slot).atmos=1
    if _debug=1 then
        print lastenemy
        no_key=keyin
    endif
    b=0
    for a=1 to 15
        if savefrom(a).map=slot then
            lastenemy=savefrom(a).lastenemy
            for b=1 to lastenemy
                enemy(b)=savefrom(a).enemy(b)
            next
            b=1
        endif
    next
    
    if b=0 then
        for a=1 to lastenemy
            if planets(slot).mon<>1 then
                enemy(a)=makemonster(planets(slot).mon,awayteam,slot,spawnmask(),lsp,0,0,a)
                if enemy(a).faction=0 then enemy(a).faction=1
            else
                if a=1 or rnd_range(1,100)>45+lastenemy then
                    enemy(a)=makemonster(planets(slot).mon,awayteam,slot,spawnmask(),lsp,0,0,a)
                    b=b+1
                else
                    enemy(a)=enemy(a-1)
                    enemy(a).c=movepoint(enemy(a-1).c,5)
                    if enemy(a).faction=0 then enemy(a).faction=b
                endif
            endif
        next
            
        if lastenemy>0 then
            for a=1 to lastenemy
                pwa(a)=enemy(a).c
            next
            pwa(lastenemy+1)=awayteam.c
            a=distributepoints(pwa(),pwa(),lastenemy+1)
            for a=1 to lastenemy
                enemy(a).c=pwa(a)
            next
        endif
        
        if rnd_range(1,100)<10 then 'Chance for mon2 always 10
            if planets(slot).mon2<=0 then planets(slot).mon2=planets(slot).mon
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(planets(slot).mon2,awayteam,slot,spawnmask(),lsp)
        endif
        if planets(slot).mon3>0 then 'chance for mon 3 always 100
            lastenemy+=1
            enemy(lastenemy)=makemonster(planets(slot).mon3,awayteam,slot,spawnmask(),lsp)
        endif
    endif
    x=0
    for a=0 to lastspecial
        if specialplanet(a)=slot then x=1
    next
    for a=0 to _NoPB
        if pirateplanet(a)=slot then x=1
    next
    for a=0 to lastdrifting
        if drifting(a).m=slot then x=1
    next
    
    if planets(slot).visited=0 and planets(slot).depth=0 and x=0 then 
        adaptmap(slot,enemy(),lastenemy)  
        if rnd_range(1,100)<5 and rnd_range(1,100)<disnbase(player.c) and lastenemy>10 and planets(slot).atmos>1 then
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(46,awayteam,slot,spawnmask(),lsp,0,0,lastenemy)
        endif        
        if rnd_range(1,100)<66-disnbase(player.c) then 'deadawayteam 
            lastenemy=lastenemy+1
            enemy(lastenemy)=makemonster(15,awayteam,slot,spawnmask(),lsp)
            enemy(lastenemy).hp=-1
            enemy(lastenemy).hpmax=55
            dprint ""&enemy(lastenemy).c.x & enemy(lastenemy).c.y
        endif    
    else
        moverover(slot)
    endif
    planets(slot).visited=player.turn    

    if slot=pirateplanet(0) then
        lastenemy=25
        for a=1 to 25
            if player.pirate_agr>50 then
                enemy(a)=makemonster(3,awayteam,slot,spawnmask(),lsp,,,a)
                enemy(a).faction=1
            else
                enemy(a)=makemonster(7,awayteam,slot,spawnmask(),lsp,0,0,a)
                enemy(a).faction=1
            endif
        next
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(p.x,p.y,slot))=246 then
                    changetile(p.x,p.y,slot,68)
                    tmap(p.x,p.y)=tiles(68)
                endif
            next
        next
        if rnd_range(1,100)<25 then
            p=rnd_point(slot,,68)
            planetmap(p.x,p.y,slot)=-246
            tmap(p.x,p.y)=tiles(246)
        endif
    endif
    
    for a=1 to _NoPB
        if slot=pirateplanet(a) then
            c=5+rnd_range(1,6)
            for b=lastenemy to lastenemy+c
                if player.pirate_agr>0 then
                    enemy(b)=makemonster(3,awayteam,slot,spawnmask(),lsp,,,b)
                else
                    enemy(b)=makemonster(7,awayteam,slot,spawnmask(),lsp,0,0,b)
                endif
            next
            lastenemy=lastenemy+c
        endif
    next
        
    
    if slot=specialplanet(1) then 'apollos planet
        lastenemy=rnd_range(1,5)+rnd_range(1,5)
        ship.x=rnd_range(0,60)
        ship.y=rnd_range(0,20)
    endif
    
    if slot=specialplanet(2) then
        if specialflag(2)=0 then
            specialflag(2)=1
            dprint "As you enter the lower atmosphere a powerful energy beam strikes your ship from the surface below! A planetery defense system has detected you! You are already to low to escape into orbit, so the only way to avoid total destruction is an emergency landing! Your vessel slams into the surface!",15,15
            player.hull=player.hull-rnd_range(1,6)
            if player.hull<=0 then
                planetmap(ship.x,ship.y,slot)=127+player.h_no
                tmap(ship.x,ship.y)=tiles(127+player.h_no)
                player.landed.m=0
            endif
            for a=0 to rnd_range(1,6)+rnd_range(1,6)
                lastenemy=lastenemy+1
                enemy(lastenemy)=makemonster(15,awayteam,slot,spawnmask(),lsp)
                enemy(lastenemy).hp=-1
            next
        else
            for x=0 to 60
                for y=0 to 20
                    if planetmap(x,y,slot)=-168 then planetmap(x,y,slot)=-169
                    if planetmap(x,y,slot)=168 then planetmap(x,y,slot)=169
                next
            next
        endif
    endif
    
    if slot=specialplanet(7) then 'stranded ship
        for x=0 to 60
            for y=0 to 20
                if abs(planetmap(x,y,slot))=9 then
                    p1.x=x
                    p1.y=y
                endif
            next
        next
        for a=1 to 9
            enemy(a)=makemonster(12,awayteam,slot,spawnmask(),lsp,p1.x,p1.y)
            enemy(a).c=movepoint(enemy(a).c,a)
        next
        for a=10 to lastenemy
            enemy(a)=makemonster(1,awayteam,slot,spawnmask(),lsp)
        next
    endif
    
    if specialplanet(8)=slot then 'stormy,less critters
        lastenemy=lastenemy-rnd_range(1,5)
        if lastenemy<0 then lastenemy=0
    endif
    
    if specialplanet(11)=slot then lastenemy=0 'No critters on dying world
    
    if specialplanet(15)=slot then
        for a=1 to lastenemy
            for b=1 to lastenemy
            if b<>a then
                if enemy(1).lang=6 then
                    if enemy(b).lang=7 then enemy(a).flags(b)=1
                else
                    if enemy(b).lang=6 then enemy(a).flags(b)=1
                endif
            endif
            next
        next
    endif
        
    if specialplanet(28)=slot then
        for x=0 to 60
            for y=0 to 20
                tmap(x,y).disease=13
            next
        next
        
        if specialflag(28)=1 then 
           oxydep=1
        else
           planets(slot).mapmod=0
        endif
    endif
    
    
    '
    ' add vault
    b=(planets(slot).vault.h-2)*((planets(slot).vault.w-2))
    if b>4 then
        if planets(slot).vault.wd(16)=99 then specialflag(15)=1
        if planets(slot).vault.wd(5)=1 then
            if b>9 then
                lastenemy=lastenemy-rnd_range(1,6)
                if lastenemy<1 then lastenemy=1
                a=lastenemy+1
                for x=planets(slot).vault.x+1 to planets(slot).vault.x+planets(slot).vault.w-1
                    for y=planets(slot).vault.y+1 to planets(slot).vault.y+planets(slot).vault.h-1
                        if a>128 then a=128
                        enemy(a)=makemonster(9,awayteam,slot,spawnmask(),lsp,x,y)
                        a=a+1
                    next
                next 
                lastenemy=a
                if lastenemy>128 then lastenemy=128
            endif
        endif
        if planets(slot).vault.wd(5)=2 and planets(slot).vault.wd(6)>0 then
            b=rnd_range(1,4)+rnd_range(1,4)+planets(slot).depth
            c=lastenemy
            lastenemy=lastenemy+b
            for d=c to lastenemy
                do
                x=rnd_range(planets(slot).vault.x,planets(slot).vault.x+planets(slot).vault.w)
                y=rnd_range(planets(slot).vault.y,planets(slot).vault.y+planets(slot).vault.h)
                loop until tmap(x,y).walktru=0
                enemy(d)=makemonster(planets(slot).vault.wd(6),awayteam,slot,spawnmask(),lsp,x,y)
            next
        endif
        planets(slot).vault=del_rec
    endif
    
    

    '   loaded game in savefrom
    '
    '    This only if savegame
    '    
    if savefrom(0).map>0 then
        awayteam=savefrom(0).awayteam
        ship=savefrom(0).ship
        slot=savefrom(0).map
        lastenemy=savefrom(0).lastenemy
        for b=1 to lastenemy
            enemy(b)=savefrom(0).enemy(b)
        next
        equipawayteam(player,awayteam,slot)
        savefrom(0)=savefrom(16)
    endif        
    equipawayteam(player,awayteam,slot)

    
    c=0
    for a=1 to lastitem
        if item(a).w.m=slot and item(a).w.s=0 then
            c=c+1
            li(c)=a
        endif
    next
    lastlocalitem=c
    
    lsp=0    
    for x=0 to 60
        for y=0 to 20
            tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
            mapmask(x,y)=0
            if tmap(x,y).walktru=0 and planets(slot).mon<>24 then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            endif
            if tmap(x,y).walktru=1 and planets(slot).mon=24 then
                lsp=lsp+1
                spawnmask(lsp).x=x
                spawnmask(lsp).y=y
            endif 
        next
    next
    
    if slot=specialplanet(16) then
        if findbest(24,-1)>0 then
            for a=1 to lastenemy
                enemy(a).aggr=0
            next
        else
            for a=1 to lastenemy
                enemy(a).aggr=1
            next
        endif
    endif
    
    if slot=specialplanet(37) then
        p.x=25
        p.y=5
        invisiblelabyrinth(tmap(),p.x,p.y)
    endif
    
    if alien_scanner=1 then player.stuff(3)=2
    
    'outpost trading
    for a=11 to 13
        planets(slot).flags(a)=planets(slot).flags(a)+rnd_range(1,6)+rnd_range(1,6)-rnd_range(1,6)-rnd_range(1,6)
        if planets(slot).flags(a)<0 then planets(slot).flags(a)+=1 
        if planets(slot).flags(a)>0 then planets(slot).flags(a)-=1 
        if planets(slot).flags(a)<-3 then planets(slot).flags(a)=-3
        if planets(slot).flags(a)>3 then planets(slot).flags(a)=3
        if planets(slot).flags(a)>0 then planets(slot).flags(a)-=1 
        if planets(slot).flags(a)<0 then planets(slot).flags(a)+=1 
    next
    if rnd_range(1,100)<33 then flag(14)=rnd_range(7,20)
    if rnd_range(1,100)<33 then planets(slot).flags(15)=1
    if rnd_range(1,100)<33 then planets(slot).flags(16)=2 
    if rnd_range(1,100)<33 then planets(slot).flags(17)=3 
    if rnd_range(1,100)<33 then planets(slot).flags(18)=4  
    if rnd_range(1,100)<33 then planets(slot).flags(19)=5 
    if rnd_range(1,100)<33 then planets(slot).flags(20)=11
    displayplanetmap(slot)
    ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
    displayawayteam(awayteam, slot, lastenemy, deadcounter, ship, nightday(awayteam.c.x,awayteam.c.y))
    dprint ""
    '
    ' EXPLORE PLANET
    '
    'testing:
    if make_files=1 then 
        x=freefile
        open "critters.txt" for append as #x
        print #x,lastenemy
        for a=1 to lastenemy
            print #x,enemy(a).hp &","&enemy(a).move &"," &enemy(a).weapon
        next
        close x
        
        x=freefile
        open "items.txt" for append as #x
        print #x,lastitem
        for a=1 to lastitem
            print #x,item(a).desig &" "&item(a).w.m &" "&item(a).w.s &" "&item(a).w.p
        next
        print #x,"-"
        close x
    endif
    if show_critters=1 then
        dprint "used 1d" &diesize &" to generate "&lastenemy &" Critters"
    endif
    
    if _debug=1 then
    print lastenemy
    no_key=keyin
    endif
    dawn=rnd_range(1,60)
    dprint planets(slot).flavortext
    
    do
        if planets(slot).depth=0 then
            dawn=dawn+planets(slot).rot
            if dawn>60 then dawn=dawn-60
            dawn2=dawn+30
            if dawn2>60 then dawn2=dawn2-60
            for x=60 to 0 step -1
                for y=0 to 20
                    nightday(x,y)=0
                    if (dawn<dawn2 and (x>dawn and x<dawn2))  then nightday(x,y)=3
                    if (dawn>dawn2 and (x>dawn or x<dawn2)) then nightday(x,y)=3
                    if x=int(dawn) then nightday(x,y)=1
                    if x=int(dawn2) then nightday(x,y)=2
                next
            next
        endif
        awayteam.dark=planets(slot).darkness+nightday(awayteam.c.x,awayteam.c.y)
        
        if show_all=1 then
            color 15,0
            locate 21,1
            print awayteam.disease;":";player.disease;":";planets(slot).visited
        endif
        if awayteam.disease>player.disease then player.disease=awayteam.disease
        old=awayteam.c
        if walking<>0 then
            if walking>0 then awayteam.c=movepoint(awayteam.c,walking)
            if walking<0 then
                displaytext(24)=displaytext(24)&"."
                dprint ""
                walking=walking+1
                tmap(awayteam.c.x,awayteam.c.y).hp=tmap(awayteam.c.x,awayteam.c.y).hp-1
                if walking=0 then
                    dprint "complete."
                    key=key_i
                endif                
            endif
        else
            awayteam.c=movepoint(awayteam.c,getdirection(key))
        endif
        
        
        for a=1 to lastenemy
            if enemy(a).hp>0 then
                if awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
                    awayteam.c=old
                    if enemy(a).sleeping>0 then
                        if askyn("The "&enemy(a).sdesc &" is unconcious. Do you want to capture it alive?(y/n)") then
                            b=findworst(26,-1)
                            if b>0 then
                                if item(b).v1<item(b).v2 then
                                    item(b).v1+=1
                                    enemy(a).hp=0
                                    enemy(a).hpmax=0
                                    reward(1)=reward(1)+cint((enemy(a).hpmax*15*enemy(a).biomod*biomod))+5*2+addtalent(4,14,1)
                                else
                                    dprint "You don't have any free cages left."
                                endif
                            else
                                dprint "You don't have any cages for the "&enemy(a).sdesc
                            endif
                        endif
                    else
                        if enemy(a).aggr=1 then 
                            if (askyn("Do you really want to attack the "&enemy(a).sdesc &"?(y/n)")) then
                                enemy(a)=hitmonster(enemy(a),awayteam,mapmask(),slot)
                                if rnd_range(1,6)+rnd_range(1,6)<enemy(a).intel then enemy(a).aggr=0
                                for b=1 to lastenemy
                                    if a<>b then
                                        if enemy(a).faction=enemy(b).faction and vismask(enemy(b).c.x,enemy(b).c.y)>0 then 
                                            enemy(b).aggr=0
                                            dprint "The "&enemy(b).sdesc &" tries to help his friend!",14,14
                                        endif
                                    endif
                                next
                            endif
                        else
                            enemy(a)=hitmonster(enemy(a),awayteam,mapmask(),slot)
                        endif                        
                    endif
                endif
            endif
        next
        
        if key=key_awayteam then
            screenshot(1)
            showteam(1)
            screenshot(2)
        endif
        
        if key=key_close then
            for a=1 to 9
                if a<>5 then
                    p1=movepoint(awayteam.c,a)
                    if tmap(p1.x,p1.y).onclose<>0 then
                        dprint "You close the "&tmap(p1.x,p1.y).desc &"."
                        planetmap(p1.x,p1.y,slot)=tmap(p1.x,p1.y).onclose
                        tmap(p1.x,p1.y)=tiles(abs(planetmap(p1.x,p1.y,slot)))
                        tmap(p1.x,p1.y).locked=0
                    endif
                endif
            next
        endif
        
        if key=key_gr then
            if _chosebest=0 then
                c=findbest(7,-1)
            else
                c=getitem
            endif
            if c>0 then
                if item(c).ty=7 then
                    p=grenade(awayteam.c,slot)
                    if p.x>=0 then
                        
                        sf=sf+1
                        if sf>15 then sf=0
                        shipfire(sf)=p
                        dprint "Delay for the grenade?"
                        sf_when(sf)=getnumber(1,5,1)
                        sf_what(sf)=11+sf
                        sf_tile(sf)=item(c).icon
                        player.weapons(sf_what(sf))=makeweapon(item(c).v1)
                        player.weapons(sf_what(sf)).ammomax=1 'Sets color to redish
                        item(c)=item(lastitem)
                        lastitem=lastitem-1
                    else
                        dprint "canceled"
                    endif
                else
                    dprint "That's not a grenade."
                endif
            else
                dprint"You dont have any grenades"
            endif
            key=""
        endif
            
        if key=key_fi then
            dprint "Fire direction"
            a=getdirection(keyin)
            if a>0 then
                b=1
                for c=0 to awayteam.hp
                    if awayteam.secweapran(c)>b then b=awayteam.secweapran(c)
                next
                c=0
                e=0
                p2.x=awayteam.c.x
                p2.y=awayteam.c.y
                awayteam.oxygen=awayteam.oxygen-oxydep
                do
                    p2=movepoint(p2,a,2)
                    color 7,0
                    if b>=3 then color 11,0
                    if b>=4 then color 12,0
                    if b>=5 then color 10,0
                
                    locate p2.y+1,p2.x+1
                    if vismask(p2.x,p2.y)>0 then print "*":
                    c=c+1
                    for d=1 to lastenemy
                        if enemy(d).c.x=p2.x and enemy(d).c.y=p2.y and enemy(d).hp>0 then 
                            enemy(d)=hitmonster(enemy(d),awayteam,mapmask(),slot)
                            e=1
                        endif
                    next   
                    if tmap(p2.x,p2.y).shootable=1 then
                        dam=0
                        for f=1 to awayteam.hpmax
                            if crew(f).hp>0 and crew(f).onship=0 then dam=dam+awayteam.secweap(f)
                        next
                        dam=cint(dam-tmap(p2.x,p2.y).dr)
                        'dprint "in here with dam "&dam
                        if dam>0 or (awayteam.stuff(5)>0 and c=1) then
                            dam=dam+awayteam.stuff(5)
                            if dam<=0 then dam=awayteam.stuff(5)
                            dprint tmap(p2.x,p2.y).succt &" ("&dam &" damage)"
                            awayteam.oxygen=awayteam.oxygen-oxydep
                            tmap(p2.x,p2.y).hp=tmap(p2.x,p2.y).hp-dam
                            if tmap(p2.x,p2.y).hp<=0 then 
                                if tmap(p2.x,p2.y).no=243 then
                                    if planets(slot).atmos>1 then dprint "The air rushes out of the ship!",14,14
                                    oxydep=1
                                    planets(slot).atmos=1
                                endif
                            
                                dprint tmap(p2.x,p2.y).killt,,10
                                tmap(p2.x,p2.y)=tiles(tmap(p2.x,p2.y).turnsinto)
                                if planetmap(p2.x,p2.y,slot)>0 then planetmap(p2.x,p2.y,slot)=tmap(p2.x,p2.y).no
                                if planetmap(p2.x,p2.y,slot)<0 then planetmap(p2.x,p2.y,slot)=-tmap(p2.x,p2.y).no                        
                            endif
                        else
                            dprint tmap(p2.x,p2.y).failt,,14
                        endif
                    endif 
                    if tmap(p2.x,p2.y).firetru=1 then
                        c=b                 
                    endif
                loop until c>=b
                if e=0 then sleep 100
                c=0
                p2.x=awayteam.c.x
                p2.y=awayteam.c.y
                cls
                displayplanetmap(slot)
                ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
                displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                dprint ""
            endif
        endif        

        
        
        lsp=0
        for x=0 to 60
            for y=0 to 20
                mapmask(x,y)=0
                if tmap(x,y).walktru=0 then
                    lsp=lsp+1
                    spawnmask(lsp).x=x
                    spawnmask(lsp).y=y
                endif
                
                if tmap(x,y).dam<>0 then
                    p2.x=x 
                    p2.y=y
                    player.killedby=tmap(x,y).deadt
                    if player.killedby="" then player.killedby=tmap(x,y).desc
                    if distance(awayteam.c,p2)<=tmap(x,y).range then
                        if tmap(x,y).dam<0 then
                            dam=rnd_range(1,abs(tmap(x,y).dam))
                        else
                            dam=tmap(x,y).dam
                        endif
                        if rnd_range(1,100)<tmap(x,y).tohit then
                            dprint tmap(x,y).hitt &" "&  damawayteam(awayteam,dam),,12
                        else
                            dprint tmap(x,y).misst,,14
                        endif
                    endif
                endif
                    
            next
        next
        mapmask(awayteam.c.x,awayteam.c.y)=-9
        deadcounter=0
        
        
        if planetmap(awayteam.c.x,awayteam.c.y,slot)=18 then
            dprint "you get zapped by a forcefield:"&damawayteam(awayteam,rnd_range(1,6)),,12
            if awayteam.armor<3 then awayteam.c=old
            walking=0
        endif
        b=findbest(12,-1) 'Find best key
        if b>0 then
            c=item(b).v1
        else
            c=0
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).no=45 and tmap(old.x,old.y).no<>45 and _warnings=0 then
            if not(askyn("do you really want to walk into hot lava?(y/n)")) then awayteam.c=old
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).onopen>0 then
            planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).onopen
            tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).locked>0 and rnd_range(1,6)+rnd_range(1,6)+player.science+c<7+tmap(awayteam.c.x,awayteam.c.y).locked then' or (tmap(awayteam.c.x,awayteam.c.y).onopen>0 and tmap(awayteam.c.x,awayteam.c.y).locked=0) then
            dprint "Your science officer can't bypass the doorlocks"
            awayteam.c=old
            walking=0
        else
            tmap(awayteam.c.x,awayteam.c.y).locked=0
            if tmap(awayteam.c.x,awayteam.c.y).onopen>0 then tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).onopen)
            if tmap(awayteam.c.x,awayteam.c.y).no=16 then planetmap(awayteam.c.x,awayteam.c.y,slot)=144
            if tmap(awayteam.c.x,awayteam.c.y).no=93 then planetmap(awayteam.c.x,awayteam.c.y,slot)=90
            if tmap(awayteam.c.x,awayteam.c.y).no=94 then planetmap(awayteam.c.x,awayteam.c.y,slot)=91
            if tmap(awayteam.c.x,awayteam.c.y).no=95 then planetmap(awayteam.c.x,awayteam.c.y,slot)=92
        endif
        
        if planetmap(awayteam.c.x,awayteam.c.y,slot)=54 then
            if c>0 then 
                item(b)=item(lastitem)
                lastitem=lastitem-1
            endif
            a=rnd_range(1,6)+rnd_range(1,6)+player.science+c
            if a>=7 and a<12 then
                dprint "Your science officer cant open the door"
                if rnd_range(1,6)+rnd_range(1,6)>6 then
                    dprint "But he sets off an ancient defense mechanism! "&damawayteam(awayteam,rnd_range(1,6))
                    player.killedby="trapped door"
                endif
                walking=0
                awayteam.c=old
            endif
            if a>12 then
                dprint "You managed to open the door"
                planetmap(awayteam.c.x,awayteam.c.y,slot)=55
                tmap(awayteam.c.x,awayteam.c.y)=tiles(55)
            endif
            if a<7 then 
                dprint "Your fiddling with the ancient lock destroys it. You will never be able to open that door."
                planetmap(awayteam.c.x,awayteam.c.y,slot)=53
                walking=0
                awayteam.c=old
            endif
        endif
        
        
        if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru and _diagonals=0 then 
            awayteam.c=movepoint(old,bestaltdir(getdirection(key),0))
            if awayteam.move<tmap(awayteam.c.x,awayteam.c.y).walktru then awayteam.c=movepoint(old,bestaltdir(getdirection(key),1))
        endif
        '       
        select case tmap(awayteam.c.x,awayteam.c.y).walktru
            case is=0
            case is=1
                if awayteam.hp>awayteam.nohp*5 then
                    if awayteam.hp<=awayteam.nojp then
                        if awayteam.jpfuel>0 then
                            awayteam.jpfuel=awayteam.jpfuel-1
                        else
                            dprint "Jetpacks empty",14,14
                            awayteam.oxygen=awayteam.oxygen+oxydep
                            awayteam.c=old
                        endif
                    else
                        awayteam.oxygen=awayteam.oxygen+oxydep
                        awayteam.c=old
                        dprint "blocked"
                    endif
                endif
            case is=2
                if awayteam.hp<=awayteam.nojp then
                    if awayteam.jpfuel>0 then
                        awayteam.jpfuel=awayteam.jpfuel-1
                    else
                        dprint "Jetpacks empty",14,14
                        awayteam.oxygen=awayteam.oxygen+oxydep
                        awayteam.c=old
                    endif
                else
                    awayteam.oxygen=awayteam.oxygen+oxydep
                    awayteam.c=old
                    dprint "blocked"
                endif
            case else
                awayteam.oxygen=awayteam.oxygen+oxydep
                awayteam.c=old
        end select
        
        if old.x=awayteam.c.x and old.y=awayteam.c.y and walking>0 then walking=0
        
        for sf2=0 to 16
        if sf_when(sf2)>0 then  
            sf_when(sf2)=sf_when(sf2)-1
            if sf_tile(sf2)<>"" and vismask(shipfire(sf2).x,shipfire(sf2).y)>0 then
                locate shipfire(sf2).y+1,shipfire(sf2).x+1
                color 7,0
                print sf_tile(sf2)
            endif
            if sf_when(sf2)=0 then
                sf_tile(sf2)=""
                'if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(4))
                b=rnd_range(1,6)+rnd_range(1,6)+maximum(player.sensors,player.gunner)
                if b>13 then gainxp(2)
                b=b-8
                if b<0 then
                    b=b*-1
                    c=rnd_range(1,8)
                    if c=5 then c=9
                    for a=1 to b
                        if sf_what(sf2)>10 then shipfire(sf2)=movepoint(shipfire(sf2),c)
                    next
                endif
                r=player.weapons(sf_what(sf2)).dam/2
                dam=0
                if r<1 then r=1
                for a=1 to player.weapons(sf_what(sf2)).dam
                    dam=dam+rnd_range(1,6)
                next
                for x=shipfire(sf2).x-5 to shipfire(sf2).x+5
                    for y=shipfire(sf2).y-5 to shipfire(sf2).y+5
                        p2.x=x
                        p2.y=y
                        if x>=0 and y>=0 and x<=60 and y<=20 then
                            if distance(shipfire(sf2),p2)<=r then
                                'Deal damage
                                for a=1 to lastenemy
                                    if enemy(a).c.x=x and enemy(a).c.y=y then
                                        enemy(a).hp=enemy(a).hp-dam
                                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint enemy(a).sdesc &" takes " &dam &" points of damage.",10,10
                                        if enemy(a).hp<=0 then
                                            player.alienkills=player.alienkills+1
                                         endif
                                         exit for
                                    endif
                                next
                                if awayteam.c.x=x and awayteam.c.y=y then dprint "you got caught in the blast! " & damawayteam(awayteam,dam),12,12
                                'Show
                                locate y+1,x+1
                                if player.weapons(sf_what(sf2)).ammomax>0 then
                                    if x=shipfire(sf2).x and y=shipfire(sf2).y then color 15,15
                                    if distance(shipfire(sf2),p2)>0 then color 12,14
                                    if distance(shipfire(sf2),p2)>1 then color 12,0
                                else
                                    if x=shipfire(sf2).x and y=shipfire(sf2).y then color 15,15
                                    if distance(shipfire(sf2),p2)>0 then color 11,9
                                    if distance(shipfire(sf2),p2)>1 then color 9,1
                                endif                                
                                print chr(178);
                                if tmap(x,y).no=3 or tmap(x,y).no=5 or tmap(x,y).no=6 or tmap(x,y).no=10  or tmap(x,y).no=11 or tmap(x,y).no=14 then 
                                    tmap(x,y)=tiles(4)
                                    if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=4
                                    if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-4
                                endif
                                if tmap(x,y).shootable>0 then
                                    tmap(x,y).hp=tmap(x,y).hp-dam
                                    if tmap(x,y).hp<=0 then
                                        if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).turnsinto
                                        if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).turnsinto
                                        tmap(x,y)=tiles(tmap(x,y).turnsinto)
                                    endif
                                endif
                            endif
                        endif
                    next
                next
                sleep 100
                for x=shipfire(sf2).x-5 to shipfire(sf2).x+5
                    for y=shipfire(sf2).y-5 to shipfire(sf2).y+5
                        if x>=0 and y>=0 and x<=60 and y<=20 then
                            if planetmap(x,y,slot)>0 then
                                dtile(x,y,tiles(planetmap(x,y,slot)))
                            else
                                locate y+1,x+1,0
                                color 0,0
                                print " "
                            endif
                        endif
                    next
                next
                
            endif
            if sf_what(sf2)>10 then 
                player.weapons(sf_what(sf2))=makeweapon(0)
                player.killedby="short thrown grenade"
            else
                player.killedby="explosion"
            endif
        endif
        next
        
        deadcounter=0
        locate old.y+1,old.x+1
        print " ";
        for a=1 to lastenemy
            locate enemy(a).c.y+1,enemy(a).c.x+1
            if enemy(a).hp>0 then            
                'changes mood
                if enemy(a).aggr=1 then
                    if rnd_range(1,100)>25*distance(enemy(a).c,awayteam.c) then 
                        if rnd_range(1,6)+rnd_range(1,6)>9+enemy(a).cmmod then
                            if distance(enemy(a).c,awayteam.c)<=awayteam.sight then dprint "The "&enemy(a).sdesc &" suddenly seems agressive",14,14
                            enemy(a).aggr=0
                            for b=1 to lastenemy
                                if a<>b then
                                    if enemy(a).faction=enemy(b).faction and vismask(enemy(b).c.x,enemy(b).c.y)>0 then 
                                        enemy(b).aggr=0
                                        dprint "The "&enemy(b).sdesc &" tries to help his friend!",14,14
                                    endif
                                endif
                            next
                        endif
                    endif
                endif                
                if rnd_range(1,100)<enemy(a).breedson and lastenemy<128 then
                    lastenemy=lastenemy+1
                    enemy(lastenemy)=makemonster(enemy(a).made,awayteam,slot,spawnmask(),lsp)
                    enemy(lastenemy).c=movepoint(enemy(a).c,5)
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "the "&enemy(a).sdesc &" multiplies!"
                endif
                if enemy(a).hp<enemy(a).hpmax then
                    enemy(a).hp=enemy(a).hp+enemy(a).hpreg
                    if enemy(a).hp>enemy(a).hpmax then
                        enemy(a).hp=enemy(a).hpmax
                        if enemy(a).aggr>0 and rnd_range(1,distance(enemy(a).c,awayteam.c))>enemy(a).intel then enemy(a).aggr=enemy(a).aggr-1 
                    endif
                endif
                
                
                if enemy(a).diet=1 then
                    for b=1 to lastenemy
                        if b<>a then
                            if enemy(a).c.x=enemy(b).c.x and enemy(a).c.y=enemy(b).c.y then
                                if enemy(b).hp<=0 and enemy(b).hpmax>0 then
                                    enemy(b).hpmax=enemy(b).hpmax-1
                                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc & " eats of the dead "&enemy(b).sdesc &"."
                                endif
                            endif
                        endif
                    next
                endif            
                if enemy(a).diet=2 and tmap(enemy(a).c.x,enemy(a).c.y).vege>0 then
                    tmap(enemy(a).c.x,enemy(a).c.y).vege=tmap(enemy(a).c.x,enemy(a).c.y).vege-1
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc & " eats some of the plants growing here."
                endif
                if enemy(a).diet=3 and enemy(a).aggr=1 then
                    c=-1
                    for b=1 to lastenemy
                        if b<>a then
                            if enemy(b).hp<=0 then c=b
                        endif
                    next
                    if c=-1 then
                        enemy(a).target=rnd_point
                    else 
                        enemy(a).target=enemy(c).c
                    endif
                endif
                if enemy(a).diet=4 and enemy(a).aggr=1 then
                    c=-1
                    for b=1 to lastlocalitem
                        if item(li(b)).w.x=enemy(a).c.x and item(li(b)).w.y=enemy(a).c.y then 
                            item(li(b)).w.p=a
                            item(li(b)).discovered=0
                            if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The Awayteam picks up the "&item(li(b)).desig
                        endif
                        if item(li(b)).ty=15 and item(li(b)).w.s=0 and item(li(b)).w.p=0 then c=b
                    next
                    if c=-1 then
                        for x=0 to 60
                            for y=0 to 20
                                if tmap(x,y).no=86 then 
                                   enemy(a).target.x=x
                                   enemy(a).target.y=y
                                endif
                             next
                         next
                        if rnd_range(1,6)+rnd_range(1,6)+player.science>3+planets(slot).atmos then dprint "Recieving radio transmission: 'Returning to ship'"
                    else
                        enemy(a).target.x=item(li(c)).w.x
                        enemy(a).target.y=item(li(c)).w.y
                        if rnd_range(1,6)+rnd_range(1,6)+player.science>3+planets(slot).atmos then dprint "Recieving radio transmission: 'Going for ore at "&enemy(a).target.x &":"&enemy(a).target.y &"'"
                    endif
                endif
                
                m(a)=m(a)+enemy(a).move
                tb=planets(slot).grav/10
                if enemy(a).aggr=2 then tb=tb+0.1 
                if awayteam.hp<3 then tb=tb-0.6
                if abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=7 or abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))=8 then tb=tb-0.5
                tb=tb-(awayteam.move/10)-addtalent(-1,23,0)
                tb=tb+player.tactic/10
                if tb>enemy(a).move and enemy(a).move>0 then
                    tb=enemy(a).move-0.1
                endif
                m(a)=m(a)-tb
                if enemy(a).move=-1 then m(a)=0
                for x=0 to 60
                    for y=0 to 20
                        mapmask(x,y)=0
                    next
                next
                mapmask(awayteam.c.x,awayteam.c.y)=-9
                for b=1 to lastenemy
                    if enemy(b).c.x<0 then enemy(b).c.x=0
                    if enemy(b).c.y<0 then enemy(b).c.y=0
                    if enemy(b).c.x>60 then enemy(b).c.x=60
                    if enemy(b).c.y>20 then enemy(b).c.y=20
                    if enemy(b).hp>0 then mapmask(enemy(b).c.x,enemy(b).c.y)=b
                next
                
                if _tiles=0 then
                
                else
                    if planetmap(enemy(a).c.x,enemy(a).c.y,slot)>0 then 
                        dtile(enemy(a).c.x,enemy(a).c.y,tiles(planetmap(enemy(a).c.x,enemy(a).c.y,slot)))
                    else
                        locate enemy(a).c.y+1,enemy(a).c.x+1
                        color 0,0
                        print " ";
                    endif
                endif
                if enemy(a).sleeping>0 then enemy(a).sleeping=enemy(a).sleeping-m(a)
                while m(a)>0.9 and enemy(a).sleeping<=0 and enemy(a).invis<2
                    x=enemy(a).c.x
                    y=enemy(a).c.y
                    mapmask(enemy(a).c.x,enemy(a).c.y)=0
                    ti=abs(planetmap(enemy(a).c.x,enemy(a).c.y,slot))
                    if ti=1 or ti=2 then mapmask(enemy(a).c.x,enemy(a).c.y)=1
                    if ti=7 or ti=8 then mapmask(enemy(a).c.x,enemy(a).c.y)=2
                    if ti>46 and ti<55 then mapmask(x,y)=3
                    if enemy(a).track>0 then 
                        changetile(enemy(a).c.x,enemy(a).c.y,slot,enemy(a).track)
                        tmap(enemy(a).c.x,enemy(a).c.y)=tiles(enemy(a).track)
                    endif
                    if enemy(a).target.x=0 and enemy(a).target.y=0 then
                        p1=rnd_point
                    else
                        p1=enemy(a).target
                    endif
                    enemy(a)=movemonster(enemy(a), p1, mapmask(),slot)
                    mapmask(enemy(a).c.x,enemy(a).c.y)=3
                    m(a)=m(a)-1
                wend
                if enemy(a).hasoxy=0 and planets(slot).atmos=1 then
                    enemy(a).hp=enemy(a).hp-1
                    if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" is struggling for air!"
                endif
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 or player.stuff(3)=2 then
                    locate enemy(a).c.y+1,enemy(a).c.x+1
                    if enemy(a).hp>0 then
                        if player.stuff(3)<>2 then walking=0
                        color enemy(a).col,0                        
                        if enemy(a).invis=0 then 
                            if _tiles=0 then
                                put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                            else
                                print chr(enemy(a).tile);
                            endif
                        endif
                    else 
                        if _tiles=0 then
                            put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(260),trans
                        else
                            color 4,0
                            print "%"
                        endif
                    endif
                endif
            else
                deadcounter=deadcounter+1
            endif
        next
        
        for a=1 to lastlocalitem 'Drop items of dead monsters
            if item(li(a)).w.p>0 and item(li(a)).w.p<9999 and item(li(a)).w.s>=0 then
                if enemy(item(li(a)).w.p).hp<=0 then
                    item(li(a)).w.x=enemy(item(li(a)).w.p).c.x
                    item(li(a)).w.y=enemy(item(li(a)).w.p).c.y
                    item(li(a)).w.p=0
                    item(li(a)).w.m=slot
                    item(li(a)).w.s=0
                endif
            endif
            if item(li(a)).ty=18 and item(li(a)).discovered=1 and item(li(a)).w.p=0 and item(li(a)).w.s>=0 then 'Rover
                p1.x=item(li(a)).w.x
                p1.y=item(li(a)).w.y
                if planetmap(p1.x,p1.y,slot)<0 then
                    locate p1.y+1,p1.x+1
                    color 0,0
                    print " "
                else
                    locate p1.y+1,p1.x+1
                    color tmap(p1.x,p1.y).col,tmap(p1.x,p1.y).bgcol
                    print chr(tmap(p1.x,p1.y).tile);
                endif
                if frac(localturn/10)=0 and item(li(a)).v4=0 then
                    if item(li(a)).vt.x<0 then
                        p1=movepoint(p1,5)
                    else
                        p1=movepoint(p1,nearest(item(li(a)).vt,p1))
                        if p1.x=item(li(a)).vt.x and p1.y=item(li(a)).vt.y then item(li(a)).vt.y=-1 
                    endif
                    if tmap(p1.x,p1.y).walktru<=item(li(a)).v2 then
                        item(li(a)).w.x=p1.x
                        item(li(a)).w.y=p1.y
                        for x=item(li(a)).w.x-item(li(a)).v1-3 to item(li(a)).w.x+item(li(a)).v1+3
                            for y=item(li(a)).w.y-item(li(a)).v1-3 to item(li(a)).w.y+item(li(a)).v1+3
                                if x>=0 and y>=0 and x<=60 and y<=20 then
                                    p2.x=x
                                    p2.y=y
                                    if distance(p1,p2)<=item(li(a)).v1+1 and planetmap(x,y,slot)<0 then
                                        planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                                        item(li(a)).v6=item(li(a)).v6+0.5*item(li(a)).v3
                                    endif
                                endif
                            next
                        next
                    endif
                endif
            endif
        next
        
        
        for a=1 to lastenemy
            if enemy(a).aggr=0 or enemy(a).aggr=2 then
                if distance(enemy(a).c,awayteam.c)<enemy(a).sight then  enemy(a).target=awayteam.c                            
            endif    
            if distance(enemy(a).c,awayteam.c)<enemy(a).range and enemy(a).hp>0 then
                if enemy(a).sleeping=0 and (enemy(a).move=-1 or m(a)>0) then
                    if enemy(a).invis=2 then
                        dprint "A clever "&enemy(a).sdesc &" has been hiding here, waiting for prey!",14,14
                        enemy(a).invis=0
                    endif
                    walking=0
                    
                    locate enemy(a).c.y+1,enemy(a).c.x+1
                    color enemy(a).col,0
                    
                    if enemy(a).invis=0 then 
                        if _tiles=0 then
                            put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                        else
                            print chr(enemy(a).tile)
                        endif
                    endif
                    if (enemy(a).aggr=0 or enemy(a).aggr=2) then 
                        b=1
                        if pathblock(awayteam.c,enemy(a).c,slot)=0 then b=0
                        if b=1 then 
                            pathblock(awayteam.c,enemy(a).c,slot,,enemy(a).scol)
                            awayteam=monsterhit(enemy(a),awayteam)
                            m(a)=m(a)-enemy(a).atcost
                        endif
                    endif
                endif
            endif
            if enemy(a).nearest>0 and m(a)>0 and enemy(a).faction<>enemy(enemy(a).nearest).faction and enemy(a).hp>0 and enemy(enemy(a).nearest).hp>0 then
                enemy(enemy(a).nearest)=monsterhit(enemy(a),enemy(enemy(a).nearest))
                enemy(a).target=enemy(enemy(a).nearest).c
                enemy(enemy(a).nearest).target=enemy(a).c
                if vismask(enemy(a).c.x,enemy(a).c.y)>0 or vismask(enemy(enemy(a).nearest).c.x,enemy(enemy(a).nearest).c.y)>0 then dprint "The "&enemy(a).sdesc &" attacks the "&enemy(enemy(a).nearest).sdesc &"."
                m(a)=m(a)-enemy(a).atcost
            endif
            if enemy(a).made=15 then 'awayteam
                if tmap(enemy(a).c.x,enemy(a).c.y).no=86 then
                    enemy(a).stuff(16)=enemy(a).stuff(16)+1
                    if enemy(a).stuff(16)>1 then
                        tmap(enemy(a).c.x,enemy(a).c.y)=tiles(4)
                        if planetmap(enemy(a).c.x,enemy(a).c.y,slot)>0 then planetmap(enemy(a).c.x,enemy(a).c.y,slot)=4
                        if planetmap(enemy(a).c.x,enemy(a).c.y,slot)<0 then planetmap(enemy(a).c.x,enemy(a).c.y,slot)=-4
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then
                            dprint "The other scoutship launches."
                        else
                            dprint "You see a scoutship starting in the distance."
                        endif
                        enemy(a)=enemy(lastenemy)
                        lastenemy=lastenemy-1
                        
                    endif
                endif
           endif
           for b=1 to lastlocalitem
                if item(li(b)).w.x=enemy(a).c.x and item(li(b)).w.y=enemy(a).c.y and enemy(a).hp>0 and item(li(b)).w.s=0 then
                    if item(li(b)).ty=21 or item(li(b)).ty=22 and item(li(b)).w.p<>9999 then
                        item(li(b)).w.p=9999
                        if item(li(b)).ty=21 then enemy(a).hp=enemy(a).hp-rnd_range(1,item(li(b)).v1)
                        if item(li(b)).ty=22 then enemy(a).sleeping=enemy(a).sleeping+rnd_range(1,item(li(b)).v1)
                        if vismask(enemy(a).c.x,enemy(a).c.y)>0 then 
                            locate item(li(b)).w.y+1,item(li(b)).w.x+1
                            color item(li(b)).col,1
                            print chr(176);
                            dprint "The mine explodes under the "&enemy(a).sdesc &"!"
                            sleep 50
                        endif
                    else
                        if rnd_range(1,6)+enemy(a).pumod>7 and item(li(b)).ty<>23 then
                            item(li(b)).w.p=a
                            item(li(b)).discovered=0
                            if vismask(enemy(a).c.x,enemy(a).c.y)>0 then dprint "The "&enemy(a).sdesc &" picks up the "&item(li(b)).desig &"."
                            'dprint "The "&enemy(a).sdesc &" picks up the "&item(b).desig &"."
                        endif
                    endif
                endif    
           next
        next
        
        
        
        'Display all stuff
        
        ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
        displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
        if _warnings=0 and nightday(awayteam.c.x,awayteam.c.y)=1 and nightday(old.x,old.y)<>1 then dprint "The sun rises"
        if _warnings=0 and nightday(awayteam.c.x,awayteam.c.y)=2 and nightday(old.x,old.y)<>2 then dprint "The sun sets"
        
        
        text=""
        for a=1 to lastlocalitem
            if item(li(a)).w.p=0 and item(li(a)).w.s=0 and item(li(a)).w.x=awayteam.c.x and item(li(a)).w.y=awayteam.c.y and item(li(a)).w.m=slot then 
                if item(li(a)).ty<>99 then 
                    if _autopickup=1 then text=text &item(li(a)).desig &". " 
                    if _autopickup=0 or key="," then
                        text=text &" You pick up the "&item(li(a)).desig &". " 
                        reward(2)=reward(2)+item(li(a)).v5
                        item(li(a)).w.s=-1
                    endif
                    if item(li(a)).ty=18 then 
                        text=text &" You transfer the map data from the rover robot. "
                        item(li(a)).v4=0
                        reward(0)=reward(0)+item(li(a)).v6
                        reward(7)=reward(7)+item(li(a)).v6
                        item(li(a)).v6=0
                    endif
                    if item(li(a)).ty=27 then 
                        text=text &" You gather the resoureces from the mining robot. "&item(li(a)).v1
                        reward(2)=reward(2)+item(li(a)).v1
                        item(li(a)).v1=0
                    endif
                    
                else
                    dprint "An alien artifact!"
                    if _autopickup=0 or key="," then
                        findartifact(awayteam)
                        displayplanetmap(slot)                     
                        displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))                     
                        item(li(a)).w.p=9999
                        li(a)=li(lastlocalitem)
                        lastlocalitem=lastlocalitem-1
                    endif
                endif
                if _autopickup=0 or key=key_pickup then
                    displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                    equipawayteam(player,awayteam,slot)
                    if awayteam.move=2 then allowed=allowed &key_ju
                    if awayteam.move=3 then allowed=allowed &key_te
                endif
            endif
        next
        if text<>"" then dprint text
        
        if old.x<>awayteam.c.x or old.y<>awayteam.c.y or key=key_portal or key=key_i then
            for a=0 to lastportal
                if portal(a).from.m=slot then
                    if awayteam.c.x=portal(a).from.x and awayteam.c.y=portal(a).from.y then
                        if askyn(portal(a).desig &" Enter?(y/n)") then
                            dprint "going through."
                            walking=-1
                            key=""
                            if planetmap(0,0,portal(a).dest.m)=0 then
                                'dprint "Making new map at "&portal(a).dest.m &"("&lastplanet &")"
                                ti=planetmap(awayteam.c.x,awayteam.c.y,slot)
                                planets(portal(a).dest.m)=planets(slot)
                                planets(portal(a).dest.m).weat=0
                                planets(portal(a).dest.m).depth=planets(portal(a).dest.m).depth+1
                                planets(portal(a).dest.m).life=planets(portal(a).dest.m).life+rnd_range(1,3)
                                if rnd_range(1,100)>planets(portal(a).from.m).depth*22 then
                                    makecavemap(portal(a).dest,portal(a).tumod,portal(a).dimod,portal(a).spmap,ti)
                                else
                                    if rnd_range(1,100)<51 then
                                        makecomplex(portal(a).dest,0)
                                        planets(portal(a).dest.m).temp=25
                                        planets(portal(a).dest.m).atmos=3
                                        planets(portal(a).dest.m).flavortext="You enter an ancient underground complex. It is dark, lighting sources have failed long ago. The air is cool and breathable. A thin layer of dust dulls the once shining metal surfaces. Aside all that it looks as if the owners of this facility could return every minute" 
                                    else
                                        makecanyons(portal(a).dest.m,9)
                                        p=rnd_point(portal(a).dest.m,0)
                                        portal(a).dest.x=p.x
                                        portal(a).dest.y=p.y
                                        planets(portal(a).dest.m).flavortext="You enter a huge cave. Deep canyons at the bottom are filled with exotic plants. You hear the cries of unknown beasts." 
                                    endif
                                endif
                                if planets(portal(a).dest.m).depth>7 then 
                                    makefinalmap(portal(a).dest.m)
                                    portal(a).dest.x=30
                                    portal(a).dest.y=2
                                endif
                            endif
                            nextmap=portal(a).dest
                            'dprint " "&portal(a).dest.m
                        endif
                    endif
                endif
                if portal(a).oneway=0 and portal(a).dest.m=slot then
                    if awayteam.c.x=portal(a).dest.x and awayteam.c.y=portal(a).dest.y then
                        if askyn(portal(a).desig &" Enter?(y/n)") then
                            dprint "going through."
                            walking=-1
                            key=""
                            if planetmap(0,0,portal(a).from.m)=0 then makeplanetmap(portal(a).from.m,0,0)
                            nextmap=portal(a).from
                        endif
                    endif
                endif
            next
        endif
        
        if ship_landing>0 and nextmap.m<>0 then ship_landing=1 'Lands immediately if you changed maps
        
        if ship_landing>0 then
            ship_landing=ship_landing-1
            if ship_landing<=0 then
                r=rnd_range(player.pilot,6)+rnd_range(1,6)+player.pilot-(planets(slot).dens+planets(slot).grav*2)
                if vismask(nextlanding.x,nextlanding.y)>0 and nextmap.m=0 then dprint "She is coming in"
                if r<0 then
                    if vismask(nextlanding.x,nextlanding.y)>0 and nextmap.m=0 then dprint "Hard touchdown!",14,14
                    player.hull=player.hull-1
                    player.fuel=player.fuel-2-int(planets(slot).grav)
                    d=rnd_range(1,8)
                    if d=5 then d=9
                    if r<-2 then r=-2
                    for a=1 to r*-1
                        nextlanding=movepoint(nextlanding,d)
                    next
                    if player.hull=0 then
                        dprint ("A Crash landing. you will never be able to start with that thing again",,12)
                        if rnd_range(1,6)+rnd_range(1,6)+player.pilot>10 then
                            dprint ("but your pilot wants to try anyway and succeeds!",,12)
                            player.hull=1
                            gainxp(2)
                        else
                            player.dead=4
                        endif
                        no_key=keyin
                    endif
                else
                    gainxp(2)
                endif
                player.landed.m=slot
                ship.m=slot
                ship.x=nextlanding.x
                ship.y=nextlanding.y
                player.landed.x=ship.x
                player.landed.y=ship.y
            endif
        endif
        
        
        if planetmap(awayteam.c.x,awayteam.c.y,slot)=45 then
            dprint "smoldering lava:" &damawayteam(awayteam,rnd_range(1,6-awayteam.move)),,12
            if awayteam.hp<=0 then player.dead=16 
            player.killedby="lava"
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).survivors>rnd_range(1,44) then
            dprint "you have found a crashed spaceship!"
            specialflag(7)=1
            no_key=keyin
            dprint "there are survivors! You offer to take them to the space station."
            b=rnd_range(1,6)+rnd_range(1,6)-3
            no_key=keyin
            if b>0 then
                if askyn( b &" security personel want to join your crew. (y/n)") then 
                    if b>maxsecurity then b=maxsecurity
                    for a=1 to b
                        addmember(8)
                    next
                endif
            endif
            b=rnd_range(5,7)
            if b>6 then b=6
            c=rnd_range(1,100)
            if c<33 then 
                if askyn("a pilot, skillevel " & b & " wants to join you. (y/n)") then 
                    player.pilot=b
                    addmember(2)
                endif
            endif
            if c>32 and c<66 then 
                if askyn("a gunner, skillevel " & b & " wants to join you. (y/n)") then 
                    player.gunner=b
                    addmember(3)
                endif
            endif
            if c>65 then 
                if askyn("a science officer, skillevel " & b & " wants to join you. (y/n)") then 
                    player.science=b
                    addmember(4)
                endif
            endif
            planetmap(awayteam.c.x,awayteam.c.y,slot)=62 
        endif
        if tmap(awayteam.c.x,awayteam.c.y).resources>rnd_range(1,100) then
            dprint "you plunder the resources of the ship and move on."
            for a=0 to 2
                reward(a)=reward(a)+rnd_range(10,50)+rnd_range(10,50)+500
            next
            planetmap(awayteam.c.x,awayteam.c.y,slot)=62
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).survivors>0 or tmap(awayteam.c.x,awayteam.c.y).resources>0 then 
            tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).turnsinto)
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).no=27 and player.dead=0 then
            tmap(awayteam.c.x,awayteam.c.y).hp=tmap(awayteam.c.x,awayteam.c.y).hp-rnd_range(0,awayteam.hp\5)
            if tmap(awayteam.c.x,awayteam.c.y).hp=1 then dprint "The ice creaks",14,14
            if tmap(awayteam.c.x,awayteam.c.y).hp<=0 then 
                dprint "The ice creaks... and breaks! "&damawayteam(awayteam,rnd_range(1,3)),12,12
                tmap(awayteam.c.x,awayteam.c.y)=tiles(2)
                planetmap(awayteam.c.x,awayteam.c.y,slot)=2
            endif
        endif
        
        if tmap(awayteam.c.x,awayteam.c.y).gives<>0 and player.dead=0 and (awayteam.c.x<>old.x or awayteam.c.y<>old.y)  then
            walking=0
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=1 then
                if specialplanet(1)=slot then specialflag(1)=1
                artifact(rnd_range(1,10),awayteam)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=2 then 
                dprint "'Ah great. Imagining people again are we?' the occupant of this bunker looks like he had a pretty bad time. 'No wait. You are real? I am not imagining you?' He explains to you that he managed to survive for months, alone, after the sandworms had demolished his ship, and eaten his crewmates." 
                if askyn("He is quite a good gunner and wants to join your crew. do you let him? (y/n)") then 
                    player.gunner=6
                    crew(3).hp=7
                    crew(3).hpmax=7
                    crew(3).paymod=0
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=3 then
                dprint "The pirates are holding the executive in this ship!"
                if rnd_range(1,100)<55 then 
                    dprint "He is still alive!",10,10
                    player.questflag(2)=2
                else
                    dprint "They killed him.",12,12
                    player.questflag(2)=3
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=4 or tmap(awayteam.c.x,awayteam.c.y).gives=5 or tmap(awayteam.c.x,awayteam.c.y).gives=6 or tmap(awayteam.c.x,awayteam.c.y).gives=7  then
                dprint "The Local Stock Exchange"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    if tmap(awayteam.c.x,awayteam.c.y).gives=7 and specialflag(20)=0 then
                        for a=1 to 5
                            basis(8).inv(a).v=0
                        next
                    endif
                    if player.lastvisit.s<>tmap(awayteam.c.x,awayteam.c.y).gives+1 then
                        changeprices(tmap(awayteam.c.x,awayteam.c.y).gives+1,(player.turn-player.lastvisit.t)\5)
                    endif 
                    if tmap(awayteam.c.x,awayteam.c.y).gives=7 and specialflag(20)=0 then
                        for a=1 to 5
                            basis(8).inv(a).v=0
                        next
                    endif
                    trading(tmap(awayteam.c.x,awayteam.c.y).gives+1)
                    player.lastvisit.s=tmap(awayteam.c.x,awayteam.c.y).gives+1
                else
                    dprint "they dont want to trade with you"
                endif
            endif
            
            
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=12 then              
                dprint "you found some still working laser drills"
                player.stuff(5)=2
                placeitem(makeitem(15),0,0,0,0,-1)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=13 then              
                dprint "The crew of this ship not only survived the crash landing, they opened a casino here!"
                no_key=keyin
                b=casino(1)
                if b>0 then 
                    if b>1000 then b=1100
                    for a=0 to b step 100
                    p1=movepoint(awayteam.c,5)
                    lastenemy=lastenemy+1
                    enemy(lastenemy)=makemonster(23,awayteam,slot,spawnmask(),lsp,p1.x,p1.y)
                    next
                endif
                specialflag(11)=1
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=15 then
                buysitems("This house is stuffed floor to ceiling with antiquities. Paintings, statues, furniture, jewelery, some is of earth origin, some clearly not.","Do you think you have anything to sell him?",23)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=16 then
                buysitems("There was an explosion in the mine. A lot of the workers have been injured. The medical officer offers to buy any medical supplies you may have.","Do you want to sell your medpacks?",11,1.25)
                specialflag(13)=1
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=17 then
                buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying weapons of any kind, especially without going through the hassle a purchase at one of the stations would cause.'","Do you want to sell weapons?",2,1.15,1)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=18 then
                buysitems("A big warehouse. A shady character is sitting behind a counter. He explains 'I am very interested in buying raw materials we can use to repair ships.'","Do you want to sell Resources?",15,0.95,1)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=19 then
                dprint "This is where the leaders of the planet meet. They express interest in high tech goods, and are willing to offer some automated gadgets they have been building." 
                dprint "They are actually very sophisticated! The technology of these creatures is behind that of humanity in term of energy generation mainly, but everything else they seem to be equal or even surpassing."
                if askyn ("Do you want to trade your tech goods for luxury goods?(y/n)") then
                    b=0
                    for a=0 to 9
                        if player.cargo(a).x=4 then
                            player.cargo(a).x=5
                            player.cargo(a).y=0
                            b=b+1
                        endif
                    next
                    if b=0 then dprint "You don't have any high tech goods to trade"
                    if b>0 then dprint "You trade "& b &" tons of high tech goods for luxury goods."
                    no_key=keyin
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=26 then              
                dprint "A Weapons and Equipment store"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    do
                        cls
                        displayship
                        if slot=pirateplanet(0) then
                            c=shop(5,0.8,"Equipment")   
                        else
                            if slot=specialplanet(14) then
                                c=shop(6,0.9,"Equipment")
                            else
                                c=shop(4,0.9,"Equipment")
                            endif
                        endif
                    loop until c=-1
                else
                    dprint "they dont want to trade with you"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=27 then              
                dprint "A Bar"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    if player.pilot*2>rnd_range(1,100) then
                        player.pilot=-captainskill
                        dprint "Pilot "&crew(2).n &" doesnt want to come out again.",14,14
                    endif
                    if player.gunner*2>rnd_range(1,100) then
                        player.gunner=-captainskill
                        dprint "Gunner "&crew(3).n &" reckons he can make a fortune playing darts and decides to stay.",14,14
                    endif
                    if player.science*2>rnd_range(1,100) then
                        player.science=-captainskill
                        dprint "Science Officer "&crew(4).n &" has discovered an unknown drink. He decides to make a new carreer in barkeeping to study it.",14,14
                    endif
                    if player.doctor*2>rnd_range(1,100) then
                        player.science=-captainskill
                        dprint "Doctor "&crew(2).n &" comes to the conclusion that he is needed more here than on your ship." 
                    endif
                    no_key=keyin
                    hiring(0,rnd_range(0,5),maximum(4,awayteam.hp))
                else
                    dprint "they dont want to serve you"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=28 then              
                dprint "Spaceship fuel for sale"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    refuel()
                else
                    dprint "they deny your request"
                endif
            endif
            
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=29 then              
                dprint "Ships Repair"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    repairhull()
                else
                    dprint "they dont want to repair a ship they shot up themselves"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=30 then              
                dprint "Shipyard"
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    no_key=keyin
                    shipupgrades()
                else
                    dprint "they dont want to upgrade a ship they are going to shoot up themselves"
                endif
            endif
            if tmap(awayteam.c.x,awayteam.c.y).gives=31 then              
                dprint "Shipyard"
                
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                    no_key=keyin
                    shipyard(2)
                else
                    dprint "they dont want to upgrade a ship they are going to shoot up themselves"
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=32 then              
                if askyn("Do you want to challenge him to a duel?") then
                    dprint "He accepts. The Anne Bonny starts and awaits you in orbit."
                    no_key=keyin
                    lastfleet=lastfleet+1
                    fleet(lastfleet)=makequestfleet(1)
                    player=spacecombat(player,fleet(lastfleet),3)
                    if player.dead=0 then 
                        player.money=player.money+100.000
                        tmap(awayteam.c.x,awayteam.c.y).turnsinto=198
                    else
                        player.dead=26
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=33 then specialflag(27)=1              
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=34 then player=buyweapon(1)              
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=35 then shipyard(3) 'Special ship weapons shop              
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=36 then
                if slot<>pirateplanet(0) or player.pirate_agr<=0 then
                
                    dprint "The captain of this scoutship says: 'Got any bio or mapdata? I can sell that stuff at the space station and offer to split the money 50:50"
                    if askyn("Do you want to sell data(y/n)") then
                        dprint "you transfer new map data on "&reward(0)&" km2. you get paid "&cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))&" credits"
                        player.money=player.money+cint((reward(7)/15)*.5*(1+0.1*crew(1).talents(2)))
                        reward(0)=0
                        reward(7)=0
                        dprint "you transfer data on alien lifeforms worth "& cint(reward(1)*.5*(1+0.1*crew(1).talents(2))) &" credits."
                        player.money=player.money+cint(reward(1)*.5*(1+0.1*crew(1).talents(2)))
                        reward(1)=0
                        for a=1 to lastitem
                            if item(a).ty=26 and item(a).w.s=-1 then item(a).v1=0
                        next   
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=40 then
                dprint "A naging feeling in the back of your head you had since you landed on this planet suddenly dissapears."
                specialflag(20)=1
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=41 then
                dprint "A nagging feeling in the back of your head you had since you entered this ship suddenly dissapears."
                player.questflag(11)=2
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=55 then
                if askyn("A tank full of processed ship fuel. Do you want to use it?(y/n)") then 
                    player.fuel=player.fuelmax+player.fuelpod
                    dprint "You refuel your ship."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=56 then
                if askyn("Do you want to repair it?(y/n)") then
                    a=rnd_range(1,6)+rnd_range(1,6)+player.science
                    if a>12 then
                        dprint "You succeed!"
                        tmap(awayteam.c.x,awayteam.c.y).turnsinto=232
                        planets(slot).atmos=5
                    endif
                    if a<6 then 
                        tmap(awayteam.c.x,awayteam.c.y).turnsinto=233
                        dprint "You destroy the console in your attempt to repair it."
                    endif
                    if tmap(awayteam.c.x,awayteam.c.y).turnsinto=231 then dprint "You fail."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=57 then 'repairing reactor
                if askyn("Do you want to repair it?(y/n)") then
                    a=rnd_range(1,6)+rnd_range(1,6)+player.science
                    if a>12 then
                        dprint "You succeed!"
                        tmap(awayteam.c.x,awayteam.c.y).turnsinto=235
                        specialflag(31)=1
                        'hide map
                        'put station 3 in positon
                    endif
                    if a<6 then 
                        tmap(awayteam.c.x,awayteam.c.y).turnsinto=236
                        dprint "You destroy the console in your attempt to repair it."
                    endif
                    if tmap(awayteam.c.x,awayteam.c.y).turnsinto=234 then dprint "You fail."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=58 then 'shutting down reactor
                if askyn("Do you want to shut it down? (y/n)") then
                    for x=0 to 60
                        for y=0 to 20
                            if planetmap(x,y,specialplanet(9))=-18 then planetmap(x,y,specialplanet(9))=-4 
                            if planetmap(x,y,specialplanet(9))=18 then planetmap(x,y,specialplanet(9))=4
                        next
                    next
                    if rnd_range(1,6)+rnd_range(1,6)+player.science<10 then
                        dprint "Something went wrong... this thing is about to blow up!"
                        sf=sf+1
                        if sf>15 then sf=0
                        shipfire(sf)=awayteam.c
                        sf_when(sf)=3
                        sf_what(sf)=10+sf
                        player.weapons(sf_what(sf))=makeweapon(rnd_range(1,5))
                        sf=sf+1 'Sets color to blueish
                    endif
                endif
            endif
                    
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=60 then 'Town hall in settlements
                if askyn("Do you want to trade with the locals?(y/n)") then 
                    '
                    ' Trading
                    '
                    for a=11 to 13
                        if planets(slot).flags(a)<0 then 
                            c=int(baseprice(a-10)*(rnd_range(1,2)+abs(planets(slot).flags(a))))
                            if a=11 then text="The colonists are in dire need of food. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            if a=12 then text="The colonists are in dire need of basic goods. They are willing to pay "&c &" per ton. Do you want to sell? (y/n)"
                            if a=13 then text="The colonists are in dire need of tech goods. They are willing to pay "&c &" per ton.Do you want to sell? (y/n)"
                            if askyn(text) then
                                for b=1 to player.h_maxcargo
                                    if player.cargo(b).x=a-9 then
                                        dprint "You sell a ton of "& basis(0).inv(a-10).n &" for "& c &" Cr."
                                        player.cargo(b).x=1
                                        player.money=player.money+c
                                        planets(slot).flags(a)=0
                                    endif
                                next
                                
                            endif
                        elseif planets(slot).flags(a)>0 then
                            c=int(baseprice(a-10)/(rnd_range(1,2)+abs(planets(slot).flags(a))))
                            if a=11 then text="The colonists have a surplus of food. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=12 then text="The colonists have a surplus of basic goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if a=13 then text="The colonists have a surplus of tech goods. They are willing to sell it for "&c &" cr. per ton. Do you want to buy? (y/n)" 
                            if askyn(text) then
                                d=getnextfreebay()
                                if d>0 then
                                    if player.money>=c then
                                        dprint "You buy a ton of "& basis(0).inv(a-10).n &" for "& c &" Cr."
                                        player.cargo(d).x=a-9
                                        player.cargo(d).y=c
                                        player.money=player.money-c
                                        planets(slot).flags(a)=0
                                    else
                                        dprint "You don't have enough money."
                                    endif
                                else
                                    dprint "You don't have enough room."
                                endif
                            endif
                        endif
                    next
                    if planets(slot).flags(14)>0 then
                        if askyn("The colonists have some equipment they no longer need. Do you want to look at it?(y/n)") then shop(planets(slot).flags(a),.75,"Equipment for sale")
                    endif
                    for a=15 to 20
                        if planets(slot).flags(a)>0 then
                            'selling equipment
                            text=""
                            if planets(slot).flags(a)=1 then text="They need jetpacks and hoverplatforms. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=2 then text="They need long range weapons. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=3 then text="They need armor. They are offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=4 then text="They need melee weapons. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=5 then text="They need mining equipment. They offer to pay 150% of station prices. "
                            if planets(slot).flags(a)=11 then text="They need medical supplies. They offer to pay 150% of station prices. "
                            if text<>"" then buysitems(text,"Do you want to sell?(y/n)",planets(slot).flags(a),1.5)
                        endif
                    next
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=111 then
                dprint "This is a data collection about all the 'enhanced pets' of the ancient aliens. They used the tree beings as scientific advisors, and made a silicium based lifeform they were somehow able to use as a powersource. It doesn't really go into detail about that. Also missing is any information on the aliens themselves."
                player.questflag(1)=1
            endif
            
            b=0
            if tmap(awayteam.c.x,awayteam.c.y).gives=205 then
                'Just don't land here
            endif
            if tmap(awayteam.c.x,awayteam.c.y).gives=206 then
                if planets(slot).flags(3)>0 then
                    if askyn("A grade "&planets(slot).flags(3) &" engine. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(3)<player.engine then
                            dprint "You already have a better engine than this."
                        else
                            if planets(slot).flags(3)<=player.h_maxengine then
                                player.engine=planets(slot).flags(3)
                                planets(slot).flags(3)=0
                                b=1
                            else
                                dprint "This engine is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty engine case."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=207 then
                if planets(slot).flags(4)>0 then
                    if askyn("A grade "&planets(slot).flags(4) &" sensor suite. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(4)<player.sensors then
                            dprint "You already have a better sensors than this."
                        else
                            if planets(slot).flags(4)<=player.h_maxsensors then
                                player.sensors=planets(slot).flags(4)
                                planets(slot).flags(4)=0
                                b=1
                            else
                                dprint "This sensor array is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty sensor case."
                endif
            endif

            if tmap(awayteam.c.x,awayteam.c.y).gives=208 then
                if planets(slot).flags(5)>0 then
                    if askyn("A grade "&planets(slot).flags(5) &" shield generator. Do you want to transfer it to your ship?(y/n)") then
                        if planets(slot).flags(5)<player.shield then
                            dprint "You already have a better shields than this."
                        else
                            if planets(slot).flags(5)<=player.h_maxshield then
                                player.shield=planets(slot).flags(5)
                                planets(slot).flags(5)=0
                                b=1
                            else
                                dprint "This shield generator is too big for your ship"
                            endif
                        endif
                    endif 
                else
                    dprint "An empty shield generator case."
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=210 then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203
                if planets(slot).flags(c)=0 then
                    dprint "An empty weapons turret."
                else
                    if askyn("A "&makeweapon(planets(slot).flags(c)).desig &". Do you want to transfer it to your ship?(y/n)") then
                        d=player.h_maxweaponslot
                        text="Weapon Slot/"
                        for a=1 to d
                            if player.weapons(a).desig="" then
                                text=text & "-Empty-/"
                            else
                                text=text & player.weapons(a).desig & "/"
                            endif
                        next
                        text=text+"Exit"
                        d=d+1            
                        e=menu(text)
                        if e<d then
                            player.weapons(e)=makeweapon(planets(slot).flags(c))
                            b=1
                            planets(slot).flags(c)=0
                        endif
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=211 then
                c=tmap(awayteam.c.x,awayteam.c.y).turnsinto-203
                if planets(slot).flags(c)>1 then
                    if planets(slot).flags(c)=2 then text="Food"
                    if planets(slot).flags(c)=3 then text="Basic goods"
                    if planets(slot).flags(c)=4 then text="Tech goods"
                    if planets(slot).flags(c)=5 then text="Luxury goods"
                    if planets(slot).flags(c)=6 then text="Weapons"
                    if askyn("A cargo crate with "& text &". Do you want to transfer it to your ship?(y/n)") then
                        for a=1 to 10
                            if player.cargo(a).x=1 and b=0 then
                                b=1
                                player.cargo(a).x=planets(slot).flags(c)
                                planets(slot).flags(c)=0
                            endif
                            if b=0 then dprint "Your cargo hold is full."
                        next
                    endif
                else
                    dprint "An empty cargo crate"
                endif
            endif
            
            if b>0 then 
                for a=0 to lastenemy
                    if enemy(a).hp>0 then 
                        enemy(a).aggr=0
                    endif
                next
                if planets(slot).atmos>1 then dprint "You hear alarm sirens!",14,14
                if planets(slot).atmos=1 then dprint "You see a red alert light flashing!",14,14
            endif
            
            for a=0 to lastdrifting
                if slot=drifting(a).m then c=drifting(a).s
            next
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=220 then
                locate 3,awayteam.c.x+1
                color 15,0
                print shiptypes(c)
                textbox(makehullbox(planets(slot).flags(1)),awayteam.c.x+1,5,78-awayteam.c.x)
                if askyn("The bridge. Do you want to abandon your ship and take over this one?(y/n)") then
                    b=0
                    for a=0 to lastenemy
                        if enemy(a).hp>0 then 
                            enemy(a).aggr=1
                            b=b+1
                        endif
                    next
                    if b=0 then
                        if upgradehull(planets(slot).flags(1),player)=-1 then
                            player.hull=planets(slot).flags(2)
                            tmap(ship.x,ship.y)=tiles(127+a)
                            changetile(ship.x,ship.y,slot,127+a)
                            planets(slot).flags(0)=1
                            nextmap.m=-1
                            if player.hull<1 then player.hull=1
                            dprint "You take over the ship."
                            key=key_north
                            walking=1
                            'Weapons...
                            poolandtransferweapons(slot)
                        endif
                        recalcshipsbays
                    else
                        dprint "You better make sure this ship is really abandoned before moving in.",14,14
                    endif
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=886 then
                if askyn("Do you want to install the cryo chamber on your ship?(y/n)") then
                    player.cryo=player.cryo+1
                else
                    tmap(awayteam.c.x,awayteam.c.y).turnsinto=tmap(awayteam.c.x,awayteam.c.y).no
                endif
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=887 then
                dprint "With the forcefield down it is easy to remove the disintegrator canon"
                artifact(4,awayteam)
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=888 then
                dprint "This computer controls the planetary defense system."
                no_key=keyin
                dprint "Your science officer manages to disable it!"
                no_key=keyin
                specialflag(2)=2
            endif
            
            if tmap(awayteam.c.x,awayteam.c.y).gives=999 then
                dprint "This terminal displays information on the status of this sector. The computer is obviously interpreting the human presence as an invasion!"
                no_key=keyin
                dprint "The spaceships are being made ready to repell the invaders!"
                no_key=keyin
                dprint "Your science officer tries to reprogram the computer"
                no_key=keyin
                dprint "He succeeds! you can now use the robot ships to explore this sector and beyond without risking human life!"
                player.questflag(3)=1
                no_key=keyin
            endif
            equipawayteam(player,awayteam,slot)
            tmap(awayteam.c.x,awayteam.c.y)=tiles(tmap(awayteam.c.x,awayteam.c.y).turnsinto)
            planetmap(awayteam.c.x,awayteam.c.y,slot)=tmap(awayteam.c.x,awayteam.c.y).no
            cls
            if awayteam.move=2 then allowed=allowed &key_ju
            if awayteam.move=3 then allowed=allowed &key_te
            displayplanetmap(slot)
            ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
            displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            dprint("")
        endif
        
        
        if planetmap(awayteam.c.x,awayteam.c.y,slot)=17 then
            walking=0
            if rnd_range(1,6)+rnd_range(1,6)+player.science>9 then
                dprint "you find an ancient computer, your Science officer manages to get map data out of it!"
                reward(5)=3
            else
                dprint "you find an ancient computer, but you cant get it to work"
            endif
            planetmap(awayteam.c.x,awayteam.c.y,slot)=16            
        endif
        
        healawayteam(awayteam,0)
        
        if slot=specialplanet(12) then 'Exploding planet warnings
            if planets(specialplanet(12)).death=8 then 
                dprint "Science officer: I wouldn't recommend staying much longer.",15,15
                no_key=keyin
                planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
            endif
            if planets(specialplanet(12)).death=4 then 
                dprint "Science officer: We really should get back to the ship now!",14,14
                no_key=keyin
                planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
            endif
            if planets(specialplanet(12)).death=2 then 
                dprint "Science officer: This planet is about to fall apart! We must leave! NOW!",12,12
                no_key=keyin
                planets(specialplanet(12)).death=planets(specialplanet(12)).death-1
            endif
        endif    
        
        
        if awayteam.c.y=ship.y and awayteam.c.x=ship.x and slot=player.landed.m then 
            walking=0
            dprint "You are at the ship. Press "&key_la &" to launch."
            if awayteam.oxygen<awayteam.oxymax then dprint "Refilling oxygen.",10,10
            awayteam.oxygen=awayteam.oxymax
            if awayteam.jpfuelmax>0 and awayteam.jpfuel<awayteam.jpfuelmax then 
                dprint "Refilling Jetpacks",10,10
                awayteam.jpfuel=awayteam.jpfuelmax
            endif
            displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))        
        endif
        
        if isgardenworld(slot) and rnd_range(1,100)<5 then
            a=rnd_range(1,awayteam.hpmax)
            if crew(a).hp>0 then 
                b=rnd_range(1,6)
                if b=1 then dprint crew(a).n &" remarks: 'What a beautiful world this is!'"
                if b=2 then dprint crew(a).n &" points out a particularly beautiful part of the landscape"
                if b=3 then dprint crew(a).n &" says: 'I guess I'll settle down here when i retire!'"
                if b=4 then dprint crew(a).n &" asks: 'How about some extended R&R here?"
                if b=5 then dprint crew(a).n &" remarks: 'Wondefull'"
                if b=6 then dprint crew(a).n &" starts picking flowers."
            endif
        endif
                
        
        if slot=specialplanet(28) and specialflag(28)=0 then
            if rnd_range(1,6)+rnd_range(1,6)+player.science>15 then
                dprint "Your science officer has figured out that the hallucinations are caused by pollen. You switch to spacesuit air supply."
                oxydep=1
                specialflag(28)=1
            else
                if rnd_range(1,100)<60 then
                    a=rnd_range(1,4)
                    if a=1 then text="Your science officer remarks: "
                    if a=2 then text="Your pilot remarks: "
                    if a=3 then text="Your gunner says: "
                    if a=4 then text="Your find some "
                    for a=0 to rnd_range(10,20)
                        text=text &chr(rnd_range(33,200))
                    next
                    dprint text
                endif
            endif
        endif
                
        if key=key_i or _autoinspect=0 then 'Inspect
            localturn=localturn+1
            awayteam.oxygen=awayteam.oxygen-oxydep
            for a=1 to lastenemy
                m(a)=m(a)+enemy(a).move
            next
            b=0
            if _autoinspect=1 then dprint "You search the area: "&tmap(awayteam.c.x,awayteam.c.y).desc
            if (tmap(awayteam.c.x,awayteam.c.y).no>=128 and tmap(awayteam.c.x,awayteam.c.y).no<=143) or tmap(awayteam.c.x,awayteam.c.y).no=241 then 
                
                'Jump ship
                if tmap(awayteam.c.x,awayteam.c.y).hp=0 then
                    if rnd_range(1,6)+rnd_range(1,6)+maximum(player.pilot-1,player.science)<9 then
                        dprint "This ship is beyond repair"
                        changetile(awayteam.c.x,awayteam.c.y,slot,62)
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                    else
                        tmap(awayteam.c.x,awayteam.c.y).hp=15+rnd_range(1,6)+rnd_range(0,tmap(awayteam.c.x,awayteam.c.y).no-128)
                        If askyn("it will take " &tmap(awayteam.c.x,awayteam.c.y).hp & " hours to repair this ship. Do you want to start now? (y/n)") then 
                            walking=-tmap(awayteam.c.x,awayteam.c.y).hp+1
                            dprint "Starting repair"
                        endif
                    endif
                else
                    walking=0
                    tmap(awayteam.c.x,awayteam.c.y).hp=1
                    dprint "finishing repair"
                endif
            
            
                if tmap(awayteam.c.x,awayteam.c.y).hp=1 then
                    if rnd_range(1,6)+rnd_range(1,6)+maximum(player.pilot-1,player.science)>8 then
                        dprint "The repair was succesfull!"
                        a=player.h_no 'Old hullnumber 
                        if askyn("Do you want to abandon your ship and use this one?") then                            
                            b=tmap(awayteam.c.x,awayteam.c.y).no-127
                            if tmap(awayteam.c.x,awayteam.c.y).no=241 then b=18
                            if upgradehull(b,player) then
                                player.hull=int(player.hull*0.8)
                                tmap(ship.x,ship.y)=tiles(127+a)
                                changetile(ship.x,ship.y,slot,127+a)
                                ship.x=awayteam.c.x
                                ship.y=awayteam.c.y
                                ship.m=slot
                                tmap(ship.x,ship.y)=tiles(4)
                                planetmap(ship.x,ship.y,slot)=4
                                if player.hull<1 then player.hull=1
                            endif
                        endif                    
                    else
                        dprint "You couldn't repair the ship."
                        changetile(awayteam.c.x,awayteam.c.y,slot,62)
                        tmap(awayteam.c.x,awayteam.c.y)=tiles(62)
                    endif
                    
                endif
            endif
            for a=1 to lastenemy
                if b=0 and awayteam.c.x=enemy(a).c.x and awayteam.c.y=enemy(a).c.y then
                    if enemy(a).hpmax>0 and enemy(a).hp<=0 and enemy(a).biomod>0 then
                        if rnd_range(1,100)<enemy(a).disease*2-oxydep*5 then infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                        if enemy(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)>enemy(a).disease/2+7 then dprint "The creature seams to be a host to dangerous "&disease(enemy(a).disease).cause &"."
                        if enemy(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)+oxydep*5<enemy(a).disease then 
                            infect(rnd_range(1,awayteam.hpmax),enemy(a).disease)
                            dprint "This creature is infected with "&disease(enemy(a).disease).ldesc
                        endif
                        if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
                            dprint "Recording biodata: "&enemy(a).ldesc 
                            if enemy(a).lang=8 then dprint "While this beings biochemistry is no doubt remarkable it does not explain it's extraordinarily long lifespan"
                            if enemy(a).hpmax<0 then enemy(a).hpmax=0
                            reward(1)=reward(1)+cint((enemy(a).hpmax*5*enemy(a).biomod*biomod))+maximum(player.science,player.doctor/2+addtalent(4,14,1))*2
                            enemy(a).hpmax=0
                            b=1                    
                        else
                            dprint "No science officer or doctor in the team."
                        endif
                    else
                        if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
                            if enemy(a).hp>0 then dprint "The " &enemy(a).sdesc &" doesn't want to be dissected alive."
                            if enemy(a).biomod>0 then dprint "Nothing left to learn here."
                            if enemy(a).biomod=0 then dprint "There is no bio data to be gained from a dead "&enemy(a).sdesc &"."
                        else
                            dprint "No science officer or doctor in the team."
                        endif
                    endif
                    localturn=localturn+1
                    awayteam.oxygen=awayteam.oxygen-oxydep
                endif
            next            
            if b=0 and tmap(awayteam.c.x,awayteam.c.y).vege>0 and planets(slot).flags(32)<=planets(slot).life+1+addtalent(4,14,3) then
                if (player.science>0 and crew(4).onship=0) or (player.doctor>0 and crew(5).onship=0) then
                        if rnd_range(1,6)+rnd_range(1,6)+maximum(player.science,player.doctor/2)+tmap(awayteam.c.x,awayteam.c.y).vege+addtalent(4,14,1)>9+planets(a).plantsfound then
                            planets(slot).flags(32)=planets(slot).flags(32)+1
                            b=1
                            dprint "you have found "&plantname(tmap(awayteam.c.x,awayteam.c.y))
                            reward(1)=reward(1)+(tmap(awayteam.c.x,awayteam.c.y).vege)*((11-planets(slot).life)/10)+player.science*2+addtalent(4,14,1)
                            if rnd_range(1,80)-player.science-addtalent(4,13,1)<tmap(awayteam.c.x,awayteam.c.y).vege then
                            dprint "The plants in this area have developed a biochemistry you have never seen before. Scientists everywhere will find this very interesting."
                            reward(1)=reward(1)+rnd_range(1,8)*rnd_range(1,8)*tmap(awayteam.c.x,awayteam.c.y).vege*((11-planets(slot).life)/10)+player.science*2+addtalent(4,14,1)
                        endif
                        if rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-oxydep*5 then
                            if rnd_range(1,6)+rnd_range(1,6)+maximum(player.science/2,player.doctor)<9 then infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
                            dprint "This area is contaminated with "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).ldesc
                        endif
                        if tmap(awayteam.c.x,awayteam.c.y).disease>0 and rnd_range(1,6)+rnd_range(1,6)+maximum(player.doctor,player.science/2)>tmap(awayteam.c.x,awayteam.c.y).disease/2+7 then dprint "The plants here seem to be a host to dangerous "&disease(tmap(awayteam.c.x,awayteam.c.y).disease).cause &"."
                        
                        localturn=localturn+1
                        awayteam.oxygen=awayteam.oxygen-oxydep
                        planets(slot).plantsfound=planets(slot).plantsfound+1
                    endif
                    tmap(awayteam.c.x,awayteam.c.y).vege=0
                else
                    dprint "Your science officer is dead."
                endif
            endif
            if b=0 then
                for c=1 to 9
                    if c<>5 then 
                        p=movepoint(awayteam.c,c)
                    else
                        p=awayteam.c
                    endif
                    if tmap(p.x,p.y).turnsoninspect<>0  and rnd_range(1,6)+rnd_range(1,6)+player.science>8 then
                        b=1
                        if tmap(p.x,p.y).turntext<>"" then dprint tmap(p.x,p.y).turntext
                        planetmap(p.x,p.y,slot)=tmap(p.x,p.y).turnsoninspect
                        tmap(p.x,p.y)=tiles(tmap(p.x,p.y).turnsoninspect)
                    endif
                next
            endif
            if b=0 and _autoinspect=1 then 
                dprint "Nothing of interest here."
            else
                ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
                displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            endif
        endif
        
        if player.dead=0 then 
            key=(keyin(allowed,walking))
            if rnd_range(1,100)<disease(awayteam.disease).nac then 
                key=""
                dprint "ZZZZZZZZZZZzzzzzzzz",14,14
            endif
        endif
        
        if disease(awayteam.disease).dam>0 then dprint "Disease:"&damawayteam(awayteam,rnd_range(1,disease(awayteam.disease).dam),1)
        
        if slot=specialplanet(1) and rnd_range(1,100)<33 then
            b=0
            for a=1 to lastenemy
                if enemy(a).made=5 and enemy(a).hp>0 then b=1
            next
            if b=1 then
                locate awayteam.c.y+1,awayteam.c.x+1
                color 15,11
                print "*"
                color 11,0
                sleep 50
                if rnd_range(1,6)+rnd_range(1,6)+2>8 then
                    dprint "Apollo calls down lightning and strikes you, infidel!",,12
                    dprint damawayteam(awayteam,1)
                else
                    dprint "Apollo calls down lightning .... and misses"
                endif
            endif
        endif
        
        if rnd_range(1,100)<tmap(awayteam.c.x,awayteam.c.y).disease*2-oxydep*5 then 
            infect(rnd_range(1,awayteam.hpmax),tmap(awayteam.c.x,awayteam.c.y).disease)
        endif                
        
        if planets(slot).atmos<4 and planets(slot).depth=0 and lastmet>150 and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot)+countasteroidfields(sysfrommap(slot))*2) and rnd_range(1,100)<18-planets(slot).atmos-countgasgiants(sysfrommap(slot)) then 
            b=rnd_range(5,15)
            lastmet=b
            b=b-planets(slot).atmos
            if b>0 then
                dprint "A meteorite streaks across the sky and slams into the planets surface!",14,14
                sf=sf+1
                if sf>15 then sf=0
                sf_when(sf)=1
                sf_what(sf)=10+sf
                r=5
                if rnd_range(1,100)<66 then r=3
                if rnd_range(1,100)<66 then r=2
                
                p2.x=ship.x
                p2.y=ship.y
                do
                    p1=rnd_point
                loop until cint(distance(p2,p1))<>r
                
                shipfire(sf)=p1                
                player.weapons(sf_what(sf))=makeweapon(1)
                player.weapons(sf_what(sf)).ammomax=1 'Sets color to redish
                player.weapons(sf_what(sf)).dam=r 'Sets color to redish
                
                
                for x=0 to 60
                    for y=0 to 20
                        p2.x=x
                        p2.y=y
                        if cint(distance(p2,p1))=r then
                            if planetmap(p2.x,p2.y,slot)<0 then planetmap(p2.x,p2.y,slot)=-8
                            if planetmap(p2.x,p2.y,slot)>0 then planetmap(p2.x,p2.y,slot)=8
                            tmap(p2.x,p2.y)=tiles(8)
                        endif
                    next
                next
                lastlocalitem=lastlocalitem+1
                lastitem=lastitem+1
                li(lastlocalitem)=lastitem
                item(lastitem)=makeitem(96,-3,b\3)
                item(lastitem).w.x=p1.x
                item(lastitem).w.y=p1.y
                item(lastitem).w.m=slot
                if rnd_range(1,100)<=2 then 
                    planetmap(p1.x,p1.y,slot)=-191
                    tmap(p1.x,p1.y)=tiles(191)
                endif
                if planets(slot).temp>100 and rnd_range(1,100)<15 then
                    lavapoint(rnd_range(1,3))=p1
                endif
            else
                dprint "A meteor streaks across the sky"
            endif
        endif
        
        if planets(slot).atmos>6 and rnd_range(1,150)<(planets(slot).dens*planets(slot).weat) and slot<>specialplanet(28) then            
            dprint "its raining sulphuric acid! "&damawayteam(awayteam,1),,12
            player.killedby=" hostile environment"
        endif
        
        if planets(slot).atmos>11 and rnd_range(1,100)<planets(slot).atmos*2 and frac(localturn/10)=0 then
            a=getrnditem(-2,0)
            if a>0 then
                if rnd_range(1,100)>item(a).res then
                    item(a).res=item(a).res-10
                    if item(a).res<0 then
                        dprint "Your "&item(a).desig &" corrodes and is no longer usable.",14,14 
                        destroyitem(a)
                        equipawayteam(player,awayteam,slot)
                        displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                    endif
                endif
            endif
            for a=0 to lastlocalitem
                if item(li(a)).ty<20 and item(li(a)).w.s=0 and rnd_range(1,100)<item(li(a)).res and rnd_range(1,100)<planets(slot).atmos*2 then item(li(a)).w.p=9999
            next
        endif
        
        if specialplanet(5)=slot or specialplanet(8)=slot then
            if awayteam.c.x<>ship.x and awayteam.c.y<>ship.y then
                if rnd_range(1,250)-(awayteam.move)<((planets(slot).atmos-3)*planets(slot).weat) and planets(slot).depth=0 then
                    'for a=1 to rnd_range(1,3)
                    dprint "High speed winds set you of course!",,12
                    awayteam.c=movepoint(awayteam.c,5)
                    ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
                    displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                    'next
                endif
            endif
        endif
        
        if rnd_range(1,100)<planets(slot).grav+planets(slot).depth+planets(slot).temp\100 then
            'Earthquake
            last_ae=last_ae+1
            if last_ae>16 then last_ae=0
            areaeffect(last_ae).c=rnd_point
            areaeffect(last_ae).rad=rnd_range(1,planets(slot).grav*3)*rnd_range(1,planets(slot).grav)
            areaeffect(last_ae).dam=areaeffect(last_ae).rad
            if areaeffect(last_ae).rad>5 then areaeffect(last_ae).rad=5
            areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
            areaeffect(last_ae).typ=1
        endif
        
        if rnd_range(1,100)<planets(slot).atmos/5+(planets(slot).water/10)+planets(slot).weat and planets(slot).atmos>3 and planets(slot).temp<0 and planets(slot).depth=0 then
            'snow
            last_ae=last_ae+1
            if last_ae>16 then last_ae=0
            areaeffect(last_ae).c=rnd_point
            areaeffect(last_ae).rad=rnd_range(1,4)*rnd_range(1,planets(slot).atmos)
            areaeffect(last_ae).dam=0 
            areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
            if areaeffect(last_ae).rad>5 then
               areaeffect(last_ae).dur=areaeffect(last_ae).dur+areaeffect(last_ae).rad-5
               areaeffect(last_ae).rad=5
            endif
            areaeffect(last_ae).typ=2
        endif
        
        for a=0 to last_ae
            if areaeffect(a).typ=1 and areaeffect(a).dur>0 then
                areaeffect(a).dur=areaeffect(a).dur-1
                if areaeffect(a).typ=1 and areaeffect(a).dur=0 then dprint "the ground rumbles",14,14'eartquake
                if areaeffect(a).typ=1 and areaeffect(a).dur=0 and findbest(16,-1)>0 and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14,14
                for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
                    for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                        if x>=0 and y>=0 and x<=60 and y<=20 then
                        p1.x=x
                        p1.y=y
                            if distance(p1,areaeffect(a).c)<areaeffect(a).rad then
                                if show_eq=1 then
                                    locate p1.y+1,p1.x+1
                                    print "."
                                endif
                                'Inside radius, inside map
                                if areaeffect(a).typ=1 then 'eartquake
                                    if areaeffect(a).dur>0 then
                                        if x=awayteam.c.x and y=awayteam.c.y and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then
                                            dprint "A tremor",14,14
                                            if findbest(16,-1)>0 and rnd_range(1,6)+rnd_range(1,6)+player.science>9 then dprint "Originating at "&areaeffect(a).c.x &":"&areaeffect(a).c.y,14,14
                                        endif
                                    else
                                        areaeffect(a).dam=areaeffect(a).dam-distance(p1,areaeffect(a).c)
                                        if areaeffect(a).dam=0 then areaeffect(a).dam=0
                                        tmap(x,y)=earthquake(tmap(x,y),areaeffect(a).dam-distance(p1,areaeffect(a).c))                                                
                                        if planetmap(x,y,slot)>0 then planetmap(x,y,slot)=tmap(x,y).no
                                        if planetmap(x,y,slot)<0 then planetmap(x,y,slot)=-tmap(x,y).no
                                        if rnd_range(1,100)<15-distance(p1,areaeffect(a).c) then lavapoint(rnd_range(1,5))=p1
                                        if rnd_range(1,100)<3 then 
                                            lastlocalitem=lastlocalitem+1
                                            lastitem=lastitem+1
                                            li(lastlocalitem)=lastitem
                                            item(lastitem)=makeitem(96,-3,-3)
                                            item(lastitem).w.x=x
                                            item(lastitem).w.y=y
                                            item(lastitem).w.m=slot
                                        endif
                                                
                                        for b=1 to lastenemy
                                            if enemy(b).c.x=x and enemy(b).c.y=y then enemy(b).hp=enemy(b).hp-areaeffect(a).dam+distance(p1,areaeffect(a).c)
                                        next
                                        if x=awayteam.c.x and y=awayteam.c.y and areaeffect(a).dam>distance(p1,areaeffect(a).c) then 
                                            dprint "An Earthquake! "& damawayteam(awayteam,rnd_range(1,areaeffect(a).dam-distance(p1,areaeffect(a).c))),12,12
                                            player.killedby="Earthquake"
                                        endif
                                        areaeffect(a).dam=areaeffect(a).rad
                                    endif
                                        
                                endif    
                            endif
                        endif
                    next
                next
            endif
            if areaeffect(a).typ=2 and areaeffect(a).dur>0 then
                areaeffect(a).dur=areaeffect(a).dur-1
                for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
                   for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                       if x>=0 and y>=0 and x<=60 and y<=20 then
                            p1.x=x
                            p1.y=y
                            if distance(p1,areaeffect(a).c)<= areaeffect(a).rad then
                                if show_eq=1 then
                                    locate p1.y+1,p1.x+1
                                    color 15,0
                                    print "."
                                endif
                                if tmap(x,y).no=1 or tmap(x,y).no=2 then tmap(x,y).hp=tmap(x,y).hp+10
                                if tmap(x,y).no<>7 and tmap(x,y).no<>8 and tmap(x,y).no>2 and tmap(x,y).no<15 and rnd_range(1,100)<8+planets(slot).atmos then
                                    tmap(x,y)=tiles(145)
                                    changetile(x,y,slot,145)
                                endif
                                If awayteam.c.x=x and awayteam.c.y=y then 
                                    dprint "It is snowing."
                                    vismod=1
                                endif
                            endif
                       endif
                   next
                next
            endif
            if areaeffect(a).typ=3 or areaeffect(a).typ=4 or areaeffect(a).typ=5 then
                areaeffect(a).dur=areaeffect(a).dur-1
                for x=areaeffect(a).c.x-areaeffect(a).rad to areaeffect(a).c.x+areaeffect(a).rad
                   for y=areaeffect(a).c.y-areaeffect(a).rad to areaeffect(a).c.y+areaeffect(a).rad
                       if x>=0 and y>=0 and x<=60 and y<=20 then
                            p1.x=x
                            p1.y=y
                            if distance(p1,areaeffect(a).c)<= areaeffect(a).rad then
                                if areaeffect(a).dur=0 then 
                                    tmap(x,y)=tiles(0)
                                    tmap(x,y)=tiles(abs(planetmap(x,y,slot)))
                                else
                                    tmap(x,y).tile=asc("~")
                                    tmap(x,y).seetru=1
                                    tmap(x,y).desc="steam"
                                    if areaeffect(a).typ=3 then tmap(x,y).col=15
                                    if areaeffect(a).typ=4 then 
                                        tmap(x,y).col=104
                                        tmap(x,y).tohit=34
                                        tmap(x,y).dam=1
                                        tmap(x,y).hitt="Acidic steam!"
                                    endif
                                    if areaeffect(a).typ=4 then 
                                        tmap(x,y).col=179
                                        tmap(x,y).tohit=27
                                        tmap(x,y).dam=1
                                        tmap(x,y).hitt="Ammonium steam!"
                                    endif
                                    if areaeffect(a).typ=5 then 
                                        tmap(x,y).col=219
                                        tmap(x,y).desc="smoke"
                                    endif
                                endif
                            endif
                        endif
                    next
                next
            endif 
        next
        
            
        
        if slot=specialplanet(8) and rnd_range(1,100)<33 then
            locate awayteam.c.y+1,awayteam.c.x+1
            color 15,11
            print "*"
            color 11,0
            dprint "lightning strikes you "& damawayteam(awayteam,1),,12            
            player.killedby="lightning strike"
        endif
        
        if slot=specialplanet(12) and rnd_range(1,100)<33 then
            if sf>15 then sf=0
            shipfire(sf)=rnd_point
            sf_when(sf)=1
            sf_what(sf)=10+sf
            player.weapons(sf_what(sf))=makeweapon(rnd_range(1,5))
            sf=sf+1
        endif
        
        if key=key_equipped then
            a=getitem(-2)
            if a>0 then dprint item(a).ldesc
            key=keyin()
        endif
        
        if key=key_ra then
            dprint "Calling ship."
            p2.x=ship.x
            p2.y=ship.y
            if (pathblock(awayteam.c,p2,slot,1)=-1 or awayteam.stuff(8)=1) and ship.m=slot then
                
                dprint "Your command?"
            
                text=" "
                text=ucase(gettext(pos,csrlin-1,46,text))
                if instr(text,"ROVER")>0 then
                    b=0
                    for a=0 to lastlocalitem
                        if item(li(a)).ty=18 and item(li(a)).w.p=0 and item(li(a)).w.s=0 then b=li(a)
                    next
                    if b>0 then
                        p1.x=item(b).w.x
                        p1.y=item(b).w.y
                        if pathblock(awayteam.c,p1,slot,1)=-1 or (awayteam.stuff(8)=1 and ship.m=slot) then
                            if instr(text,"STOP")>0 then 
                                dprint "Sending stop command to rover"
                                item(b).v4=1
                            endif
                            if instr(text,"START")>0 then 
                                dprint "sending start command to rover."
                                item(b).v4=0
                            endif
                            if instr(text,"TARGET")>0 then 
                                dprint "Get target for rover:"
                                do
                                    displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                                    text=cursor(p1,slot)
                                loop until text=key_enter or text=key_esc
                                if text=key_enter then item(b).vt=p1
                                text=""
                            endif
                            if instr(text,"POSITI")>0 or instr(text,"WHERE")>0 then
                                dprint "Rover is at "& item(b).w.x &":"& item(b).w.y &"."
                            endif
                        else
                            dprint "No radio contact with rover"
                        endif
                    else
                        dprint "No rover to contact"
                    endif
                    text=""
                endif
                if instr(text,"HELP")>0 then dprint "How shall we help you? come to you or fire on something or launch?"
                if instr(text,"SELFDESTERUCT")>0 then dprint "We don't have a selfdestruct device. Guess we could make the reactor go critical, but why would we want to?"
                if instr(text,"SCAN")>0 or instr(text,"ORBITAL")>0 or instr(text,"SATELLI")>0 then
                    if awayteam.stuff(8)=0 then
                        dprint "We don't have a satellite in orbit"
                    else
                        a=rnd_range(0,lastlocalitem)
                        if item(li(a)).ty=15 and item(li(a)).w.p=0 and item(li(a)).w.s=0 then
                            item(li(a)).discovered=1
                            dprint "We have indications that there is an ore deposit at "& item(li(a)).w.x &":"& item(li(a)).w.y
                        else
                            dprint "No new information from orbital scans."
                        endif
                    endif
                endif
                if instr(text,"POSIT")>0 or instr(text,"LOCATI")>0 or instr(text,"WHERE")>0 then
                    dprint "We are at " &ship.x &":" &ship.y
                endif
                if instr(text,"LAUNC")>0 or instr(text,"START")>0 then
                    if askyn("Are you certain? you want us to launch and leave you behind?") then player.dead=4
                endif
                if instr(text,"HELLO")>0 then dprint "Yes?"
                if instr(text,"STATUS")>0 or instr(text,"REPORT")>0 then                                            
                    screenshot(1)
                    shipstatus()
                    screenshot(2)
                    dprint "The ship is fine, like you left her"
                    for a=1 to 5
                        if distance(p2,lavapoint(a))<2 and lavapoint(a).x>0 and lavapoint(a).y>0 then
                            dprint "Lava is coming a bit close though"
                            exit for
                        endif
                    next
                endif
                if instr(text,"GET")>0 or instr(text,"COME")>0 or instr(text,"LAND")>0 or instr(text,"RESCUE")>0 then
                    if (slot=specialplanet(2) and specialflag(2)<2) or (slot=specialplanet(27) and specialflag(27)=0) then
                        if slot=specialplanet(2) then dprint "We can't start untill we disabled the automatic defense system."
                        if slot=specialplanet(27) then dprint "Can't get her up from this surface. She is stuck."
                    else                        
                        p.x=ship.x
                        p.y=ship.y
                        if instr(text,"HERE")>0 then
                            nextlanding.x=awayteam.c.x
                            nextlanding.y=awayteam.c.y
                            player.landed.m=0
                        else
                            dprint "Roger. Where do you want me to land?"
                            nextlanding=awayteam.c
                            do
                                text=cursor(nextlanding,slot)
                            loop until text=key_enter or text=key_esc
                            if text=key_enter then
                                player.landed.m=0
                            else
                                nextlanding.x=p.x
                                nextlanding.y=p.y
                            endif
                        endif
                        if nextlanding.x=ship.x and nextlanding.y=ship.y then
                            dprint "We already are at that position."
                            ship.m=slot
                            ship.x=nextlanding.x
                            ship.y=nextlanding.y
                        
                        else
                            ship_landing=distance(p,nextlanding)/2
                            if ship_landing<1 then ship_landing=1
                            if crew(2).onship=1 then
                                dprint "ETA in "&ship_landing &". See you there."
                            else
                                dprint "ETA in "&ship_landing &". Putting her down there by remote control."
                            endif
                        endif
                    endif
                endif
                if instr(text,"FIR")>0 or instr(text,"NUKE")>0 or instr(text,"SHOOT")>0 then
                    sf=sf+1
                    if sf>15 then sf=0
                    dprint "Roger. Designate target."
                    shipfire(sf)=awayteam.c
                    do
                        displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
                        text=cursor(shipfire(sf),slot)
                    loop until text=key_enter or text=key_esc
                    if text=key_enter then
                        if pathblock(awayteam.c,shipfire(sf),slot,1)=0 then
                            dprint "No line of sight to that target."
                            shipfire(sf).x=-1
                            shipfire(sf).y=-1
                        else
                            sf_when(sf)=(distance(awayteam.c,p2)\10)+1
                            sf_what(sf)=getshipweapon                            
                            if sf_what(sf)<0 then
                                sf_what(sf)=6
                                sf_when(sf)=-1
                            endif
                            if player.weapons(sf_what(sf)).desig="" then sf_when(sf)=-1
                            if player.weapons(sf_what(sf)).ammomax>0 then 
                                player.weapons(sf_what(sf)).ammo=player.weapons(sf_what(sf)).ammo-1
                                if player.weapons(sf_what(sf)).ammo<0 then 
                                    sf_when(sf)=-2
                                    player.weapons(sf_what(sf)).ammo=0
                                endif
                            endif
                            if sf_when(sf)>0 then dprint player.weapons(sf_what(sf)).desig &" fired"
                            if sf_when(sf)=-1 then dprint "Fire order canceled"
                            if sf_when(sf)=-2 then dprint "I am afraid that weapon is out of ammunition"
                        endif
                    endif                            
                endif
            else
                dprint "No contact possible"
            endif
            displayplanetmap(slot)
            displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
        endif
        
        if key=key_oxy then
            if oxydep=0 then
                dprint "Switching to suit oxygen supply."
                oxydep=1
                changemoral(-3,1)
            else                
                
                if planets(slot).atmos>1 and planets(slot).atmos<7 then
                    dprint "Opening helmets."
                    oxydep=(3-planets(slot).dens)/2
                    oxydep=oxydep*(planets(slot).grav/1.8)
                    oxydep=oxydep-awayteam.stuff(4)-(awayteam.move/10)
                    if oxydep<0 then oxydep=0
                else
                    dprint "There is no oxygen in the atmosphere, you can't open your helmet."
                    oxydep=1
                endif
                
            endif
        endif
                
        
        if key=key_ex then
            p2.x=awayteam.c.x
            p2.y=awayteam.c.y
            do
                ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)               
                locate awayteam.c.y+1,awayteam.c.x+1
                color 15,0
                print "@"
                if planetmap(ship.x,ship.y,slot)>0 and slot=player.landed.m then
                    locate ship.y+1,ship.x+1
                    color 14,0
                    print "@"
                endif
                p3=p2
                key=cursor(p2,slot)
                if p3.x<>p2.x or p3.y<>p2.y then
                    if distance(p2,awayteam.c)<=awayteam.sight and planetmap(p2.x,p2.y,slot)>0 then
                        text=tmap(p2.x,p2.y).desc &". "
                        for a=0 to lastportal
                            if p2.x=portal(a).from.x and p2.y=portal(a).from.y and slot=portal(a).from.m then text=text & portal(a).desig &". "
                            if p2.x=portal(a).dest.x and p2.y=portal(a).dest.y and slot=portal(a).dest.m and portal(a).oneway=0 then text= text &portal(a).desig &". "
                        next
                                        
                        for a=1 to lastlocalitem
                            if item(li(a)).w.x=p2.x and item(li(a)).w.y=p2.y and item(li(a)).w.p=0 and item(li(a)).w.s=0 then 
                                text=text & item(li(a)).desig &". " 
                                'if show_all=1 then text=text &"("&item(li(a)).w.x &" "&item(li(a)).w.y &" "&item(li(a)).w.p &" "&localitem(a).w.s &" "&localitem(a).w.m &")"
                            endif
                        next
                        
                        for a=1 to lastenemy
                            if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y and enemy(a).hpmax>0 then
                                if enemy(a).hp>0 then
                                    if enemy(a).c.x=p2.x and enemy(a).c.y=p2.y then
                                        color enemy(a).col,9
                                        text=text &" "& mondis(enemy(a))
                                    else
                                        color enemy(a).col,0
                                    endif
                                    locate enemy(a).c.y+1,enemy(a).c.x+1,0
                                    if _tiles=0 then
                                        put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                                    else
                                        print chr(enemy(a).tile)
                                    endif
                                else
                                    color 12,0
                                    locate enemy(a).c.y+1,enemy(a).c.x+1
                                    if _tiles=0 then
                                         put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(261),trans
                                    else
                                        print "%"
                                    endif
                                    text=text & mondis(enemy(a))
                                    if _debug=1 then text=text &"("&a &" of "&lastenemy &")"
                                endif
                                exit for 'there won't be more than one monster on one tile
                            endif
                        next
                    endif
                    if show_all=1 then text=text &":" &chksrd(p2,slot)
                    if text<>"" then dprint text
                    text=""
                endif
            loop until key=key_enter or key=key_esc or ucase(key)="Q"
            
            displayplanetmap(slot)
            displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            key=keyin(allowed,walking)
        endif
        
        if key=key_ju and awayteam.move>=2 then
            if awayteam.jpfuel>2 then
                awayteam.jpfuel=awayteam.jpfuel-3
                if planets(slot).depth=0 or slot=specialplanet(9) or slot=specialplanet(4) or slot=specialplanet(3) then
                    b=rnd_range(1,4)+rnd_range(1,4)-planets(slot).grav
                    dprint "Direction?"                
                    d=val(keyin("12346789"))
                    if d=4 then d=d+1
                    if b<2 then b=2
                    for a=1 to b 
                        if rnd_range(1,6)+rnd_range(1,6)>7 then d=bestaltdir(d,rnd_range(0,1))
                        awayteam.c=movepoint(awayteam.c,d)
                        ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
                        color 15,0
                        locate awayteam.c.y+1,awayteam.c.x+1,0
                        print "@"
                        sleep 50
                    next
                    awayteam.oxygen=awayteam.oxygen-5
                    if rnd_range(1,6)+rnd_range(1,6)+planets(slot).grav>7 then
                        dprint "Crash Landing! " &damawayteam(awayteam,rnd_range(1,1+planets(slot).grav))
                    else
                        dprint "You land savely"
                    endif
                else
                    dprint "you hit the ceiling pretty fast! "&damawayteam(awayteam,rnd_range(1,1+planets(slot).grav))
                endif
            else
                dprint "Not enough jetpack fuel"
            endif
        endif
        
        if key=key_la then
            if awayteam.c.y=ship.y and awayteam.c.x=ship.x and slot=player.landed.m then 
                if slot=specialplanet(2) or slot=specialplanet(27)  then
                    if slot=specialplanet(27) then
                        if specialflag(27)=0 then 
                            dprint "As you attempt to start you realize that your landing struts have sunk into the surface of the planet. You try to dig free, but the surface closes around them faster than you can dig. You are stuck!"
                        else
                            dprint "You successfully break free of the living planet."
                            nextmap.m=-1
                            'if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                        endif
                    endif
                    if slot=specialplanet(2) then
                        if specialflag(2)=0 then 
                            dprint "As soon as you attempt to start the planetary defense system fires. You won't be able to start until you disable it."
                        else
                            dprint "You start without incident"
                            nextmap.m=-1
                            if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                            exit do
                        endif                    
                    endif
                else
                    nextmap.m=-1
                    if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(10))
                    exit do
                endif
            endif
        endif
    
        if key=key_save then
            if askyn("Do you really want to save the game (y/n?)") then
               
               
               savefrom(0).map=slot
               savefrom(0).ship=ship
               savefrom(0).awayteam=awayteam
               savefrom(0).lastenemy=lastenemy
               for a=1 to lastenemy
                   savefrom(0).enemy(a)=enemy(a)
               next
               savefrom(0).lastlocalitem=lastlocalitem
               player.dead=savegame()   
               'ship.x=-1
            endif
        endif
        
        if key=key_he then
            if awayteam.disease>0 then
                cureawayteam(0)
            else
                if _chosebest=0 then
                    c=findbest(11,-1)
                else 
                    c=getitem
                endif 
                if c>0 then
                    if item(c).ty<>11 then
                        dprint "you can't use that."
                    else
                        if askyn("Do you want to use the "&item(c).desig &"(y/n)?") then
                            item(c).v1=healawayteam(awayteam,item(c).v1)
                            item(c)=item(lastitem)    
                            lastitem=lastitem-1    
                        endif
                    endif
                else
                    dprint "you dont have the means to heal your wounded"
                endif
            endif
        endif
        
        if key=key_drop then
            screenshot(1)
            c=getitem()
            if c>0 then
                dprint "dropping " &item(c).desig 
                item(c).w.x=awayteam.c.x
                item(c).w.y=awayteam.c.y
                item(c).w.m=slot
                item(c).w.s=0
                item(c).w.p=0
                if item(c).ty=24 and tmap(item(c).w.x,item(c).w.y).no=162 then
                    dprint("you reconnect the machine to the pipes. you notice the humming sound.")
                    no_key=keyin
                    item(c).v1=100
                endif
                reward(2)=reward(2)-item(c).v5
                lastlocalitem=lastlocalitem+1
                li(lastlocalitem)=c
                key=keyin(allowed)
                equipawayteam(player,awayteam,slot)
            endif
            screenshot(2)
        endif
        
        
        if key=key_walk then
            key=keyin
            walking=getdirection(key)            
        endif
        
        if key=key_co or key=key_of then
            ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem,slot,walking)
            displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            b=0
            dprint "direction?"
            do
                dkey=keyin
            loop until getdirection(dkey)>0 or dkey=key_esc
            p2=movepoint(awayteam.c,getdirection(dkey))
            if key=key_co and planetmap(p2.x,p2.y,slot)=190 then 
                dprint "You hear a voice in your head: 'Subjugate or be annihilated'"
                b=-1
            endif
            if key=key_co and planetmap(p2.x,p2.y,slot)=191 then dodialog(1)
            for a=1 to lastenemy
                if p2.x=enemy(a).c.x and p2.y=enemy(a).c.y and enemy(a).hp>0 then b=a
            next
            if b=0 then
                if key=key_co then dprint "Nobody there to communicate"
                if key=key_of then dprint "Nobody there to give something to"
            endif
            if b>0 and key=key_co then communicate(awayteam,enemy(b),slot,li(),lastlocalitem,b)
            if b>0 and key=key_of then giveitem(enemy(b),b,li(),lastlocalitem)
        endif
        
        if awayteam.move=3 and  player.teleportload<15 then player.teleportload+=1
        
        if key=key_te and awayteam.move=3 then 
            if planets(slot).teleport=0 then
                awayteam.c=teleport(awayteam.c,slot) 
                displayplanetmap(slot)
                ep_display (awayteam,vismask(),enemy(),lastenemy,li(),lastlocalitem, slot,walking)
                displayawayteam(awayteam, slot, lastenemy, deadcounter, ship,nightday(awayteam.c.x,awayteam.c.y))
            else
                dprint "Something is jamming your teleportation device!",14,14
            endif
        endif
        
        
        awayteam.oxygen=awayteam.oxygen-maximum(oxydep,tmap(awayteam.c.x,awayteam.c.y).oxyuse)
        if (tmap(awayteam.c.x,awayteam.c.y).no=1 or tmap(awayteam.c.x,awayteam.c.y).no=26 or tmap(awayteam.c.x,awayteam.c.y).no=20) and awayteam.hp<=awayteam.nohp*5 then awayteam.oxygen=awayteam.oxygen+tmap(awayteam.c.x,awayteam.c.y).oxyuse
        if tmap(awayteam.c.x,awayteam.c.y).oxyuse<0 then awayteam.oxygen=awayteam.oxygen-tmap(awayteam.c.x,awayteam.c.y).oxyuse
        if awayteam.oxygen>awayteam.oxymax then awayteam.oxygen=awayteam.oxymax
        if awayteam.oxygen<0 then dprint "Asphyixaction:"&damawayteam(awayteam,rnd_range(1,awayteam.hp),1),12,12
        
        
        if planets(slot).temp+rnd_range(0,10)>350 then 'lava
            
            a=rnd_range(1,5)
            if lavapoint(a).x=0 and lavapoint(a).y=0 then
                lavapoint(a).x=rnd_range(1,60)
                lavapoint(a).y=rnd_range(1,20)
            endif
            if rnd_range(1,100)<75 then
                if lavapoint(a).x<>ship.x and lavapoint(a).y<>ship.y then 
                    if planets(slot).depth=0 then
                        if rnd_range(1,100)<50 then
                            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                            tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                        else
                            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-8
                            tmap(lavapoint(a).x,lavapoint(a).y)=tiles(8)
                        endif
                    else
                        planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-47
                        tmap(lavapoint(a).x,lavapoint(a).y)=tiles(47)
                    endif
                endif
            endif
            lavapoint(a)=movepoint(lavapoint(a),5)
            planetmap(lavapoint(a).x,lavapoint(a).y,slot)=-45
            tmap(lavapoint(a).x,lavapoint(a).y)=tiles(45)
            if vismask(lavapoint(a).x,lavapoint(a).y)>0 then
                walking=0
                planetmap(lavapoint(a).x,lavapoint(a).y,slot)=45
                dprint "The ground breaks open, releasing fountains of lava"                
            endif
            if lavapoint(a).x=ship.x and lavapoint(a).y=ship.y then
                player.hull=player.hull-1
                if distance(lavapoint(a),awayteam.c)<awayteam.sight then dprint "Your ship was damaged!"
                if player.hull<=0 then player.dead=15
            endif
        endif
        
        'Spawning tiles
        for x=0 to 60
            for y=0 to 20
                a=rnd_range(1,100)
                if a<tmap(x,y).spawnson and tmap(x,y).spawnblock>=0 then
                    if tmap(x,y).spawnblock>0 then tmap(x,y).spawnblock=tmap(x,y).spawnblock-3
                    b=0
                    for c=1 to lastenemy
                        if enemy(c).made=tmap(x,y).spawnswhat and enemy(c).hp>0 then b=b+1
                    next
                    if b<tmap(x,y).spawnsmax then
                        d=getmonster(enemy(),lastenemy)
                        enemy(d)=makemonster(tmap(x,y).spawnswhat,awayteam,slot,spawnmask(),lsp,x,y,d)
                        if vismask(x,y)>0 then dprint tmap(x,y).spawntext,14,14
                    endif
                endif
                localtemp=planets(slot).temp+rnd_range(0,25)*planets(slot).rot*nightday(x,y)
                if localtemp<=0 and tmap(x,y).no=1 or tmap(x,y).no=2 then
                    tmap(x,y).hp=tmap(x,y).hp-(localtemp/25)
                    if rnd_range(1,100)<tmap(x,y).hp then
                        tmap(x,y)=tiles(27)
                        changetile(x ,y ,slot ,27)
                        if vismask(x,y)>0 then dprint "The water freezes again."
                    endif
                endif
                if localtemp>0 and tmap(x,y).no=27 then
                    tmap(x,y).hp-=localtemp/25
                    if tmap(x,y).hp<0 then 
                        tmap(x,y)=tiles(27)
                        changetile(x ,y ,slot ,27)
                        if vismask(x,y)>0 then dprint "The ice melts."
                    endif
                endif
                if a<tmap(x,y).causeaeon then
                    last_ae=last_ae+1
                    if last_ae>16 then last_ae=0
                    areaeffect(last_ae).c.x=x
                    areaeffect(last_ae).c.y=y
                    areaeffect(last_ae).rad=rnd_range(1,2)
                    areaeffect(last_ae).dam=0 
                    areaeffect(last_ae).dur=rnd_range(1,4)+rnd_range(1,4)
                    areaeffect(last_ae).typ=tmap(x,y).aetype
                endif
                if tmap(x,y).no=245 and rnd_range(1,100)<9+planets(slot).grav then
                    p.x=x
                    p.y=y
                    p=movepoint(p,5)
                    lavapoint(rnd_range(1,5))=p
                endif
            next
        next
        
        if tmap(awayteam.c.x,awayteam.c.y).no=175 or tmap(awayteam.c.x,awayteam.c.y).no=176 or tmap(awayteam.c.x,awayteam.c.y).no=177 then
            dprint "Aaaaaaaaaaaaaaaahhhhhhhhhhhhhhh",12,12
            player.dead=27
        endif
        for a=1 to lastenemy
            if enemy(a).hp<=0 and planets(slot).atmos>12 and rnd_range(1,100)>planets(slot).atmos*2 then enemy(a).hpmax=enemy(a).hpmax-1
            if enemy(a).hp<=0 then enemy(a).hp=enemy(a).hp-1
            if enemy(a).hp<-45-diesize and enemy(a).respawns=1 then enemy(a)=makemonster(enemy(a).made,awayteam,slot,spawnmask(),lsp)
        next
        'clean up item list
        for a=1 to lastlocalitem
            if item(li(a)).w.s<0 then
                li(a)=li(lastlocalitem)
                lastlocalitem=lastlocalitem-1
            endif
        next
        
        
        
        
        ' and the world moves on
        lastmet=lastmet+1
        localturn=localturn+1
        if frac(localturn/10)=0 then 
            player.turn=player.turn+1
            if planetmap(0,0,specialplanet(12))<>0 then planets(specialplanet(12)).death=planets(slot).death-1
            if planets(specialplanet(12)).death<=0 and slot=specialplanet(12) then 
                player.dead=17
            endif
            diseaserun(1)    
            equipawayteam(player,awayteam,slot)
            movefleets()
        endif
        
    loop until awayteam.hp<=0 or nextmap.m<>0 or player.dead<>0
    
    '
    ' END exploring
    
    for a=0 to lastitem
        if item(a).w.p=9999 then 
            item(a)=item(lastitem)
            lastitem=lastitem-1
        endif
    next
    
    b=0
    for a=1 to lastenemy
        if enemy(a).hp>0 then b=b+1
    next
    if b=0 then planets(slot).genozide=1
    

    if awayteam.hp<=0 then 
        reward(2)=0
        reward(1)=0
        if player.dead=0 then player.dead=3
        
        for a=0 to lastdrifting
            if slot=drifting(a).m then player.dead=25
        next
        player.landed.s=planets(slot).depth
        if player.dead=25 then player.landed.s=slot
        dprint "awayteam overdue, no radio contact, emergency launch!",12,12
        if slot=specialplanet(0) then player.dead=8
        if slot=specialplanet(1) then player.dead=9
        if slot=specialplanet(3) or slot=specialplanet(4) then player.dead=10
        if slot=specialplanet(5) then player.dead=11
        if awayteam.oxygen<1 then player.dead=14
        no_key=keyin
    endif
    
    if player.dead=0 and planets(slot).atmos>0 and planets(slot).depth=0 and planets(slot).atmos=player.questflag(10) then 
        a=0
        for x=0 to 60
            for y=0 to 20
                a=a+tmap(x,y).vege
            next
        next
        if a=0 then
            dprint "This planet would suit Omega Bioengineerings Requirements."
            player.questflag(10)=-slot
        endif
    endif
    
    if specialplanet(10)=slot then
        for x=0 to 60
            for y=0 to 20
                if planetmap(x,y,slot)=-60 then planetmap(x,y,slot)=-4
                if planetmap(x,y,slot)=60 then planetmap(x,y,slot)=4
            next
        next
    endif
    if slot=pirateplanet(0) and planets(slot).genozide=1 then
        dprint "Congratulations! You have destroyed the pirates base!",,10
        reward(6)=50000
        piratebase(0)=-1
        pirateplanet(0)=-1
        no_key=keyin
    endif    
    if slot=pirateplanet(0) and awayteam.hp<=0 then player.dead=7
    c=0
    for a=1 to _NoPB
        if slot=pirateplanet(a) then
            for b=1 to lastenemy
                if enemy(b).hp>0 then
                    if enemy(b).made=7 or enemy(b).made=3 then c=c+1
                endif
            next
            if c=0 and awayteam.hp>0 then
                reward(8)=reward(8)+10000
                piratebase(a)=-1
                pirateplanet(a)=-1
            endif
        endif
    next
    
    b=0
    for a=1 to 15
        if slot=savefrom(a).map then b=a
    next
    if b=0 then
        for a=15 to 1
            if savefrom(a).map=0 then b=a
        next
    endif
    if b=0 then
        for a=1 to 14
            savefrom(a)=savefrom(a+1)
        next
        savefrom(15)=savefrom(16) '16 bleibt immer leer
        b=15
    endif
    a=b
    savefrom(a).lastenemy=lastenemy
    savefrom(a).map=slot
    for b=1 to lastenemy
        savefrom(a).enemy(b)=enemy(b)
    next
    savefrom(a).lastlocalitem=lastlocalitem
    if slot=specialplanet(12) and player.dead<>0 then player.dead=17
    
    return nextmap
end function

function grenade(from as cords,map as short) as cords
    dim as cords target,ntarget
    dim as single dx,dy,x,y
    dim as short a,ex,r,t
    dim as string key
    dim p as cords
    target.x=from.x
    target.y=from.y
    x=from.x
    y=from.y
    p=from
    if findbest(17,-1)>0 then
        dprint "Choose target"
        do 
            locate p.y+1,p.x+1
            color 15,0
            print "@"
            key=cursor(ntarget,map)
            if distance(ntarget,from)<5 then
                target.x=ntarget.x
                target.y=ntarget.y
            endif
            if key=key_te or ucase(key)=" " or multikey(SC_ENTER) then ex=1
            if key=key_quit or multikey(SC_ESCAPE) then ex=-1    
        loop until ex<>0
        r=distance(from,target)
        dx=(target.x-from.x)/r
        dy=(target.y-from.y)/r
    else
        dprint "Choose direction"
        key=keyin("12346789"&" "&key_esc)
        if getdirection(key)=0 then
            ex=1
        else
            r=3-planets(map).grav
            if getdirection(key)=1 then
                dx=-.7
                dy=.7
            endif
            if getdirection(key)=2 then
                dx=0
                dy=1
            endif
            if getdirection(key)=3 then
                dx=.7
                dy=.7
            endif
            if getdirection(key)=4 then
                dx=-1
                dy=0
            endif
            if getdirection(key)=6 then
                dx=1
                dy=0
            endif
            if getdirection(key)=7 then
                dx=-.7
                dy=-.7
            endif
            if getdirection(key)=8 then
                dx=0
                dy=-1
            endif
            if getdirection(key)=9 then
                dx=.7
                dy=-.7
            endif
        endif
    endif
    if ex=1 then
        target.x=-1
        target.y=-1
    else
        for a=1 to r
            x=x+dx
            y=y+dy
            t=abs(planetmap(x,y,map))
            if tiles(t).firetru=1 then exit for
        next
        if x<0 then x=0
        if y<0 then y=0
        if x>60 then x=60
        if y>20 then y=20
        target.x=x
        target.y=y
    endif
    return target    
end function

function teleport(from as cords,map as short) as cords
    dim target as cords
    dim ntarget as cords
    dim otarget as cords
    dim ex as short
    dim key as string
    target.x=from.x
    target.y=from.y
    ntarget=target
    do 
        key=cursor(ntarget,map)
        if distance(ntarget,from)<10 then
            target.x=ntarget.x
            target.y=ntarget.y
        endif
        if key=key_te or ucase(key)=" " or multikey(SC_ENTER) then ex=1
        if key=key_quit or multikey(SC_ESCAPE) then ex=-1    
    loop until ex<>0
    if ex=1 then
        if player.teleportload>=10 then 
            from.x=target.x
            from.y=target.y
            player.teleportload=0
        else
            dprint "The teleportation device still needs some time to recharge"
        endif
    endif
    return from
end function

function poolandtransferweapons(m as short) as short
    dim as short e,f,c,g,d
    dim as string text,help,desc
    dim weapons(10) as _weap
    e=1
    ' old weapons
    for f=1 to 5
        if player.weapons(f).desig<>"" then
            weapons(e)=player.weapons(f)
            player.weapons(f)=makeweapon(0)
            e=e+1
        endif
    next
    'new weapons
    for f=6 to 10 
        if planets(m).flags(f)>0 then
            weapons(e)=makeweapon(planets(m).flags(f))
            e=e+1
        endif
        if planets(m).flags(f)=-1 then
            weapons(e)=makeweapon(99)
            e=e+1
        endif
        if planets(m).flags(f)=-2 then
            weapons(e)=makeweapon(98)
            e=e+1
        endif
        if planets(m).flags(f)=-3 then
            weapons(e)=makeweapon(97)
            e=e+1
        endif
    next
    for f=1 to player.h_maxweaponslot
        text="Transfer weapons to slot "&f &":/"
        help="/"
        d=0
        for c=1 to e
            if weapons(c).desig<>"" then
                d=d+1
                text=text &weapons(c).desig &"/"
                help=help &weapons(c).desig & " | | Damage: "&weapons(c).dam &" | Range: "&weapons(c).range &"\"&weapons(c).range*2 &"\" &weapons(c).range*3 &"/"
            endif
        next
        text=text &"Exit"
        help=help &"/"
        if d>1 then 
            g=menu(text,help)
        else
            if d=1 then
                player.weapons(f)=weapons(d)
                weapons(d)=makeweapon(-1)
            endif
        endif    
        if g>0 and g<d then 
            player.weapons(f)=weapons(g)
            weapons(d)=makeweapon(-1)
        endif
    next
    
    if planets(m).flags(3)>player.engine then player.engine=planets(m).flags(3) 
    if planets(m).flags(4)>player.sensors then player.sensors=planets(m).flags(4) 
    if planets(m).flags(5)>player.shield then player.shield=planets(m).flags(5) 
    return 0
end function
            

function movemonster(enemy as _monster, ac as cords, mapmask() as byte,map as short) as _monster
    dim direction as short
    dim dir2 as short
    dim p1 as cords
    dim sp1 as cords
    dim sp2 as cords
    dim sp3 as cords
    dim pa as cords
    dim p(4) as cords
    dim a as short
    dim ti as short
   
    enemy.nearest=0
    p1.x=enemy.c.x
    p1.y=enemy.c.y
    'mapmask(ac.x,ac.y)=-9
    
    if enemy.aggr=0 or enemy.aggr=1 then
        direction=nearest(ac,p1)
    endif
    
    if enemy.aggr=2 then
        direction=nearest(p1,ac)
    endif

   
    '
    ' wirf ne münze mach ne kurve
    '

    if enemy.c.x<2 and direction=4 and enemy.aggr<>0 then
        if rnd_range(1,100)<51 then 
            direction=7
        else
            direction=1
        endif
    endif
    
    if enemy.c.x>58 and direction=6 and enemy.aggr<>0 then
        if rnd_range(1,100)<51 then 
            direction=9
        else
            direction=3
        endif
    endif
    
    if enemy.c.y<2 and direction=8 and enemy.aggr<>0  then
        if rnd_range(1,100)<51 then
            direction=7
        else 
            direction=9
        endif
    endif
    
    if enemy.c.y>18 and direction=2 and enemy.aggr<>0  then
        if rnd_range(1,100)<51 then
            direction=1
        else 
            direction=3
        endif
    endif
    
    p(2)=movepoint(p1,bestaltdir(direction,1))
    p(3)=movepoint(p1,bestaltdir(direction,0))
    p(4)=movepoint(p1,direction)
    
    for a=2 to 4
        ti=abs(planetmap(p(a).x,p(a).y,map))
        
        if mapmask(p(a).x,p(a).y)>0 then
            enemy.nearest=mapmask(p(a).x,p(a).y)
            p(a).x=-1
            p(a).y=-1
        endif
        
        if (tiles(ti).walktru>0 and enemy.stuff(tiles(ti).walktru)=0) then
            p(a).x=-1
            p(a).y=-1
        endif
    next
    if p(2).x>=0 and p(2).y>=0 then dir2=bestaltdir(direction,1)
    if p(3).x>=0 and p(3).y>=0 then dir2=bestaltdir(direction,0)
    if p(4).x>=0 and p(4).y>=0 then dir2=direction
    p1.x=enemy.c.x
    p1.y=enemy.c.y
    
    if dir2>0 then enemy.c=movepoint(enemy.c,dir2)
    if mapmask(enemy.c.x,enemy.c.y)=-9 then
        enemy.c.x=p1.x
        enemy.c.y=p1.y
    endif
    return enemy
end function

function monsterhit(attacker as _monster, defender as _monster) as _monster
    dim mname as string
    dim text as string
    dim a as short
    dim b as short
    dim noa as short
    dim col as short
    if attacker.stuff(1)=1 and attacker.stuff(2)=1 then mname="flying "
    mname=mname & attacker.sdesc    
    text="the"
    if attacker.hpmax>20 then text=text & " giant"
    if attacker.hpmax>10 and attacker.hpmax<21 then text=text & " huge"
    if attacker.hpmax>10 and attacker.weapon>0 then text=text &","
    text=text &" "
    if attacker.weapon>0 then text=text &"vicious "
    if distance(attacker.c,defender.c)<1.5 then
        text=text &mname &" attacks :"
    else
        text=text &mname &" shoots "&attacker.swhat &":"
        col=14
    endif
    noa=attacker.hp\7
    if noa<1 then noa=1
    for a=1 to noa
        if rnd_range(1,6)+rnd_range(1,6)-defender.armor+attacker.weapon>8 then b=1+1
    next
    if b>attacker.weapon+1 then b=attacker.weapon+1 'max damage    
    if defender.made=0 then 
        if b>0 then
            text=text & damawayteam(defender,b,,attacker.disease)
            col=12
        else
            text=text & " no casualties."
            col=11
        endif
        if defender.hp<=0 then player.killedby=attacker.sdesc
        dprint text,,col 
    else
        defender.hp=defender.hp-b 'Monster attacks monster
        if defender.hp<defender.hpmax*0.3 and rnd_range(1,6)+rnd_range(1,6)<defender.intel+defender.diet then defender.aggr=2
    endif
    return defender
end function

function hitmonster(defender as _monster,attacker as _monster,mapmask() as byte,slot as short) as _monster
    dim a as short
    dim b as single
    dim c as short
    dim col as short
    dim noa as short
    dim text as string
    dim wtext as string
    dim mname as string
    if _sound=0 or _sound=2 then FSOUND_PlaySound(FSOUND_FREE, sound(3))
    if defender.stuff(2)=1 then mname="flying "
    mname=mname &defender.sdesc
    noa=attacker.hpmax
    for a=0 to noa
        if crew(a).hp>0 and crew(a).onship=0 and distance(defender.c,attacker.c)<=attacker.secweapran(a)+1.5 then
            if distance(defender.c,attacker.c)>1.5 and rnd_range(1,6)+rnd_range(1,6)-player.tactic*(1+addtalent(3,10,1))+addtalent(3,11,1)+addtalent(a,22,1)+player.gunner+attacker.secweapthi(a)>9 then 
                b=b+attacker.secweap(a)+addtalent(3,11,.1)+addtalent(a,25,.1)
                if a>5 then gainxp(a)
            endif
            if distance(defender.c,attacker.c)<=1.5 and rnd_range(1,6)+rnd_range(1,6)-player.tactic*(1+addtalent(3,10,1))+addtalent(3,11,1)+addtalent(a,21,1)+crew(a).hp>9 then 
                b=b+0.2+maximum(attacker.secweapc(a),attacker.secweap(a))+addtalent(3,11,.1)+addtalent(a,24,.1)
                if a>5 then gainxp(a)
            endif
        endif
    next
    text="You attack the "&defender.sdesc &"."
    if distance(defender.c,attacker.c)>1.5 then b=b+1-int(distance(defender.c,attacker.c))

    b=cint(b)-player.tactic*(1+addtalent(3,10,1))
    if b<0 then b=0
    if b>0 then
       defender.target=attacker.c
       b=b-defender.armor
       if b>0 then
            text=" You hit for " & b &" points of damage." 
            defender.hp=defender.hp-b
            if defender.hp/defender.hpmax<0.8 then wtext ="The " & mname &" is slightly "&defender.dhurt &" "
            if defender.hp/defender.hpmax<0.5 then wtext ="The " & mname &" is "&defender.dhurt &" "
            if defender.hp/defender.hpmax<0.3 then wtext ="The " & mname &" is badly "&defender.dhurt &" "
            text=text &wtext
            col=10
        else
            text=text &" You don't penetrate the "&mname &" armor."
            col=14 
        endif
    else
        text=text &" your fire misses. "
        col=14
    endif
    if defender.hp<=0 then
        text=text &" the "& mname &" "&defender.dkill
        if defender.made=44 then player.questflag(12)=2
        player.alienkills=player.alienkills+1
        if defender.made=15 then player.merchant_agr=player.merchant_agr+rnd_range(1,4)*rnd_range(1,4)
        if defender.made=3 or defender.made=7 then 
            player.merchant_agr=player.merchant_agr-rnd_range(1,4)*rnd_range(1,4)
            player.pirate_agr=player.pirate_agr+rnd_range(1,4)*rnd_range(1,4)
        endif
        if defender.made=28 or defender.made=14 or defender.made=28 or defender.made=39 then 
            player.merchant_agr=player.merchant_agr+rnd_range(1,4)*rnd_range(1,4)
            player.pirate_agr=player.pirate_agr-rnd_range(1,4)*rnd_range(1,4)
        endif
        locate defender.c.y+1,defender.c.x+1
        color 4,12
        print "%"
    else
        if defender.hp=1 and b>0 and defender.aggr<>2 then 
            if rnd_range(1,6)+rnd_range(1,6)<defender.intel+defender.diet then
                defender.aggr=2
                defender.weapon=defender.weapon+1
                text=text &"the " &mname &" is critically hurt and tries to FLEE. "            
                defender=movemonster(defender, attacker.c, mapmask(),slot)   
            endif
        else
            if defender.aggr>0 and defender.hp<defender.hpmax then
                defender.aggr=0
                text=text &" the "&mname &" tries to defend itself."
            endif
        endif
    endif
    dprint text,,col
    return defender
end function

ERRORMESSAGE:
e=err
text="error #"&e &" in "& " "&erl &":" & *ERFN() &" " & *ERMN()
f=freefile
open "error.log" for append as #f
print #f,text 
close #f
locate 10,10
color 12,0
print "ERROR: Please inform the author and send him the file error.log"
print "matthias.mennel@gmail.com"
color 14,0
print text
sleep
print "attempting to save game"
savegame()
print "key to exit"
sleep
