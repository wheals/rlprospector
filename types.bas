'
' debugging flags 0=off 1 =on
'
Const Show_NPCs=0 'shows pirates and mercs
Const Show_specials=41 'special planets already discovered
Const show_portals=0 'Shows .... portals!
Const Show_pirates=0 'pirate system already discovered
Const make_files=0 'outputs statistics to txt files
Const show_all=1
const show_items=0 'shows entire maps
const alien_scanner=0'player has alien scanner
Const show_critters=0 
Const enable_donplanet=0 'D key on planet tirggers displayplanetmap
Const all_resources_are=0 
const show_allitems=0 
const easy_fights=0

const toggling_filter=0
const fuel_usage=0 
const just_run=0
const show_eq=0 'Show earthquakes
const lstcomit=56
const lstcomty=20 'Last common item
const laststar=90
const lastspecial=43
const _debug=0
const xk=chr(255) 
const key_up = xk + "H"
const key_dn = xk + "P"
const key_rt= xk + "M"
const key_lt = xk + "K"
const key_esc = Chr(27)
const key_enter = Chr(13)
const key_space = Chr(32)
const lastflag=20
const sm_x=75
const sm_y=35

dim shared as integer fmod_error
dim shared as byte _NoPB=2
dim shared as byte wormhole=8
dim shared as short countpatrol,makepat

dim shared as byte _chosebest=1
dim shared as byte _showspacemap=0
dim shared as byte _sound=1
dim shared as byte _diagonals=1
dim shared as byte _savescreenshots=1
dim shared as byte _startrandom=0
dim shared as byte _autosave=1
dim shared as byte _autopickup=1
dim shared as byte _autosell=0
dim shared as byte _minsafe=1
dim shared as byte _anykeyno=1
dim shared as byte _restart=1
dim shared as byte _tiles=1
dim shared as byte _autoinspect=1
dim shared as byte _warnings=0
dim shared as byte _volume=9
dim shared as byte _easy=0
dim shared as byte _resolution=2
dim shared as byte _showvis=0
dim shared as byte _lines=25
dim shared as byte _onbar=1

dim shared as byte captainskill=-5
dim shared as byte wage=10

dim shared as string*1 key_manual="?"
dim shared as string*1 key_messages="m"
dim shared as string*1 key_screenshot="*"
dim shared as string*1 key_configuration="="
dim shared as string*1 key_autoinspect="I"
dim shared as string*1 key_autopickup="P"
dim shared as string*1 key_shipstatus="@"
dim shared as string*1 key_equipment="E"
dim shared as string*1 key_tactics="T"
dim shared as string*1 key_awayteam="A"
dim shared as string*1 key_quests="Q"
dim shared as string*1 key_tow="t"

dim shared as string*1 key_la="l"
dim shared as string*1 key_sc="s"
dim shared as string*1 key_do="d"
dim shared as string*1 key_save="s"
dim shared as string*1 key_quit="q"
dim shared as string*1 key_D="D"
dim shared as string*1 key_G="G"
dim shared as string*1 key_report="R"
dim shared as string*1 key_rename="r"
dim shared as string*1 key_dock="d"
dim shared as string*1 key_comment="c"

dim shared as string*1 key_i="i"
dim shared as string*1 key_ex="x"
dim shared as string*1 key_ra="r"
dim shared as string*1 key_te="t"
dim shared as string*1 key_ju="j"
dim shared as string*1 key_co="c"
dim shared as string*1 key_of="o"
dim shared as string*1 key_gr="g"
dim shared as string*1 key_fi="f"
dim shared as string*1 key_he="h"
dim shared as string*1 key_walk="w"
dim shared as string*1 key_pickup=","
dim shared as string*1 key_drop="d"
dim shared as string*1 key_oxy="O"
dim shared as string*1 key_close="C"

dim shared as string*1 key_sh="s"
dim shared as string*1 key_ac="a"
dim shared as string*1 key_ru="r"
dim shared as string*1 key_dr="d"

dim shared as string*1 key_nw="7"
dim shared as string*1 key_north="8"
dim shared as string*1 key_ne="9"
dim shared as string*1 key_west="4"
dim shared as string*1 key_east="6"
dim shared as string*1 key_sw="1"
dim shared as string*1 key_south="2"
dim shared as string*1 key_se="3"
dim shared as string*1 key_wait="5"
dim shared as string*1 key_portal="<"
dim shared as string*1 key_logbook="L"
dim shared as string*1 key_yes="y"
dim shared as string*1 no_key
dim shared uid as uinteger
using FB
randomize timer

type cords
    x as short
    y as short
end type

type gamecords
    s as short '
    p as short '
    m as short
    x as short
    y as short
end type

type _driftingship
    s as short '
    p as short '
    m as short
    x as short
    y as short
    start as cords
end type

type _rect
    x as short
    y as short
    h as short
    w as short
    wd(16) as byte
end type

type _visit
    s as short 
    t as integer
end type

type _transfer
    from as gamecords
    dest as gamecords
    tile as short
    col as short
    oneway as short
    discovered as short
    desig as string*64
    tumod as short 'the higher the more tunnels
    dimod as short 'the higher the more digloops
    spmap as short 'make specialmap if non0
    froti as short 'from what tile
end type

type _items
    id as short 
    uid as uinteger
    w as gamecords
    icon as string*1
    col as short
    bgcol as short
    discovered as short
    scanmod as single
    desig as string*31
    desigp as string*31
    ldesc as string*255
    sdesc as string*31
    price as integer
    ty as short
    v1 as single
    v2 as single
    v3 as single
    v4 as single
    v5 as single 'Only for rewards
    v6 as single 'Rover mapdata
    vt as cords 'rover target
    res as ubyte
end type
    
type _weap
    desig as string*15
    dam as short
    range as single
    ammo as short
    ammomax as short
    ROF as byte
    ECMmod as byte
    p as short
    made as byte
    col as byte
end type

type _ship
    c as cords
    osx as short
    osy as short
    landed as gamecords
    turn as integer
    money as integer
    desig as string *24
    icon as string *1
    sensors as short
    pilot as short
    gunner as short
    science as short
    doctor as short
    security as short
    'seclevel(128) as short
    disease as byte
    'skillmarks(5) as ushort
    engine as short
    weapons(25) as _weap    
    hull as integer
    hulltype as integer
    fuelmax as single
    fuel as single
    fueluse as single
    shieldmax as integer
    shield as integer
    tactic as integer
    h_no as short
    h_desig as string*24
    h_price as ushort
    h_maxhull as short
    h_maxengine as short
    h_maxshield as short
    h_maxsensors as short
    h_maxcargo as short
    h_maxcrew as short
    h_maxweaponslot as short
    h_maxfuel as single
    h_sdesc as string*5
    h_desc as string*255
    fuelpod as short
    crewpod as short
    dead as short
    killedby as string*64
    shiptype as short
    target as cords
    ECM as byte
    stuff(5) as single
    cargo(10) as cords
    piratekills as uinteger
    tradingmoney as integer
    lastvisit as _visit
    cryo as short
    alienkills as uinteger
    deadredshirts as uinteger
    score as uinteger
    pirate_agr as single
    merchant_agr as single
    questflag(31) as ushort
    discovered(9) as byte
    towed as byte
    tractor as byte
    teleportload as byte
    col as short
    bcol as short
    mcol as short
end type

type _monster
    made as ubyte
    slot as byte
    hpmax as single
    hp as single
    hpreg as single
    disease as byte
    flags(128) as byte
    secarmo(128) as single
    secweap(128) as single
    guns_to as single
    secweapc(128) as single
    blades_to as single
    secweapran(128) as single
    secweapthi(128) as single
    nohp as ubyte 'Number of Hover platforms
    nojp as ubyte 'Number of jetpacks
    light as ubyte 'Lightsource
    dark as ubyte
    sight as single
    biomod as single
    diet as byte
    intel as short
    lang as short
    faction as short
    desc as string*127
    sdesc as string*64
    ldesc as string*512
    dhurt as string*16
    dkill as string*16
    swhat as string*64
    scol as ubyte
    invis as byte
    aggr as byte
    tile as short
    sprite as short
    col as ubyte
    dcol as ubyte
    move as single
    track as short
    range as short
    weapon as short
    armor as short
    respawns as byte
    breedson as byte
    nearest as ubyte
    cmmod as byte 'Change Mood mod
    pumod as byte 'Pick up mod
    oxymax as single
    oxygen as single
    oxydep as single
    helmet as byte
    sleeping as single
    jpfuel as single
    jpfuelmax as single
    jpfueluse as single
    c as cords
    target as cords
    hasoxy as byte
    atcost as single
    stuff(16) as single
    items(8) as byte
    itemch(8) as byte
end type

type _stars
    c as cords
    spec as byte
    discovered as byte
    planets(1 to 9) as short
    desig as string*12
    comment as string*60
end type

type _planet
    p as short
    map as short
    orbit as short
    darkness as ubyte
    water as short
    atmos as short
    dens as short
    grav as single
    temp as single
    life as short
    minerals as short
    weat as single
    depth as single
    death as short
    genozide as byte
    teleport as byte
    plantsfound as short
    pla_template(16) as byte
    mon_template(16) as _monster
    mon_noamin(16) as byte
    mon_noamax(16) as byte
    mon_killed(16) as byte
    mon_caught(16) as byte
    mon_seen(16) as byte
    colony as byte
    colonystats(14) as byte
    vault as _rect
    discovered as short
    visited as integer
    mapped as integer
    mapmod as single
    rot as single
    flags(32) as byte
    flavortext as string*512
    comment as string*60
end type

type _ae
    c as cords
    rad as byte
    dam as byte
    dur as byte
    typ as byte
end type

type _planetsave
    awayteam as _monster
    enemy(129) as _monster
    item(129) as short
    lastenemy as short
    lastlocalitem as short
    ship as gamecords
    map as short
end type

type _fleet
    ty as short 'Type: 1=patrol 2=merchant 3=pirate
    c as cords 'Coordinates
    t as short 'Number of coordinates of target in targetlist
    aggr as short ' ???? legacy
    last as short ' ???? legacy
    del as short
    flag as short
    con(15) as short ' Old ship storage
    mem(15) as _ship 'Actual ship storage
end type

type _goods
    n as string*16
    p as single
    v as single
    test as single
    test2 as single
end type

type _station 
    c as cords
    discovered as short
    inv(5) as _goods
    'different companys for each station
    repname as string*32
    company as byte
    spy as byte
    mapmod as single
    biomod as single
    resmod as single
    pirmod as single
end type

type _comment
    c as cords
    t as string*32
    l as short
end type

type _table
    points as integer
    desig as string *80
    death as string *80
end type

type _tile
    no as short
    tile as short
    desc as string
    bgcol as short
    col as short
    stopwalking as byte
    oxyuse as byte
    locked as byte
    seetru as short
    walktru as short
    firetru as short
    shootable as short 'shooting at it will damage it
    dr as short 'damage reduction
    hp as short 
    dam as short
    range as short
    tohit as short
    hitt as string
    misst as string
    deadt as string
    turnsinto as short
    succt as string
    failt as string
    killt as string
    spawnson as short
    spawnswhat as short
    spawnsmax as short
    spawnblock as short '=0 spawns forever, >0 each spawn =-3, <0 spawning blocked
    spawntext as string
    survivors as short
    resources as short
    gives as short
    vege as byte
    disease as byte
    turnsoninspect as short
    turntext as string
    causeaeon as byte
    aetype as byte
    hides as byte
    repairable as byte
    onclose as short
    onopen as short
    turnsonleave as short
    turnsonleavetext as string
end type

type _disease
    no as ubyte
    desig as string
    ldesc as string
    cause as string
    duration as ubyte
    fatality as ubyte
    causeknown as byte
    cureknown as byte
    att as byte
    dam as byte
    hal as byte
    bli as byte
    nac as byte
    oxy as byte
    wounds as byte
end type

type _crewmember
    icon as string*1
    n as string*20
    typ as byte
    paymod as byte
    hpmax as byte
    hp as byte
    disease as byte
    incubation as ubyte
    duration as ubyte
    onship as byte
    jp as byte
    equips as byte
    weap as single
    blad as single
    tohi as single
    armo as single
    pref_ccweap as uinteger
    pref_lrweap as uinteger
    pref_armor as uinteger
    talents(26) as byte
    augment(9) as byte
    xp as short
    morale as short
end type

type _share
    company as byte
    bought as uinteger
    lastpayed as uinteger
end type

type _company
    profit as integer
    capital as integer
    rate as integer
end type


'
'
'reward slots
'0 mapsinkm2
'1 Bio
'2 ressources
'3 Pirate ships
'4 
'5 artifact transfer
'6 Pirate base
'7 mapsincredits
'8 Pirate outpost

dim shared __VERSION__ as string
__VERSION__="0.1.9"

dim shared talent_desig(26) as string
dim shared evkey as EVENT
dim shared reward(9) as single

dim shared baseprice(5) as short
dim shared avgprice(5) as single

dim shared spectraltype(9) as short
dim shared spectralname(9) as string 
dim shared scount(9) as short
dim as short a,b,c,d,e,f,g
dim shared x as short
dim shared y as short
dim as single x1,y1,x2,y2

dim shared flag(20) as short
dim shared artflag(20) as short
dim key as string
dim shared zeit as integer
dim shared savefrom(16) as _planetsave
dim shared stationroll as short
dim shared player as _ship
dim shared map(laststar+wormhole) as _stars
dim shared basis(10) as _station
dim shared companystats(4) as _company
dim shared companyname(4) as string
dim shared shares(2047) as _share
dim shared lastshare as short
dim shared spacemap(sm_x,sm_y) as short
dim shared combatmap(60,20) as byte
dim shared planetmap(60,20,2047) as short
dim shared planets(2047) as _planet
for a=0 to 2047
    planets(a).darkness=5
next
dim shared item(25000) as _items
dim shared shopitem(20,21) as _items
dim shared lastitem as integer

dim shared tiles(512) as _tile
dim shared gtiles(512) as any ptr
dim shared scr as any ptr

dim shared dprintline as byte
dim shared bestaltdir(9,1) as byte
dim shared piratebase(_NoPB) as short
dim shared pirateplanet(_NoPB) as short
dim shared specialplanet(lastspecial) as short
dim shared specialplanettext(lastspecial,1) as string
dim shared specialflag(lastspecial) as byte
dim shared atmdes(16) as string
dim shared sound(11) as integer ptr
dim shared displaytext(64) as string
dim shared dtextcol(64) as short
for a=0 to 30
    dtextcol(a)=11
next

dim shared patrolmod as short
dim shared fleet(255) as _fleet
dim shared targetlist(9) as cords
dim shared drifting(128) as _driftingship
dim shared crew(128) as _crewmember
dim shared shiptypes(19) as string
dim shared disease(17) as _disease
dim shared awayteamcomp(4) as byte
dim shared fightmatrix(5,5) as byte
dim shared empty_ship as _ship
dim shared empty_fleet as _fleet

empty_fleet.del=1

dim shared coms(255) as _comment
dim shared portal(255) as _transfer
dim shared lastportal as short
dim shared lastplanet as short
dim shared lastcom as short
dim shared lastwaypoint as short
dim shared lastfleet as short
dim shared lastdrifting as short=16
dim shared liplanet as short 'last input planet


dim shared tmap(60,20) as _tile
dim as cords p1,p2,p3
dim shared pwa(128) as cords 'Points working array
dim dummy as _monster
dim dummycords as gamecords
dim text as string
dim as short astcou,gascou,pl
dim shared spectralshrt(9) as string
dim shared tacdes(5) as string


' SUB DECLARATION

' prospector .bas

declare sub landing(mapslot as short,lx as short=0,ly as short=0, test as short=0)
declare sub scanning()
declare sub rescue()
declare sub asteroidmining(byref slot as short)
declare sub gasgiantfueling(t as short,orbit as short,sys as short)
declare sub driftingship(a as short)
declare sub moverover(pl as short)

declare function teleport(awaytam as cords, map as short) as cords
declare function movemonster(enemy as _monster, ac as cords, mapmask() as byte,map as short) as _monster
declare function hitmonster(defender as _monster,attacker as _monster, mapmask() as byte,slot as short) as _monster
declare function monsterhit(defender as _monster, attacker as _monster) as _monster
declare function spacecombat(defender as _ship,atts as _fleet, ter as short) as _ship
declare function spacestation(st as short) as _ship
declare function buyweapon(sh as short=0) as _ship
declare function exploreplanet(awayteam as _monster, from as gamecords, orbit as short) as gamecords
declare function grenade(from as cords,map as short) as cords
declare function poolandtransferweapons(map as short) as short

' fileIO.bas
declare function loadconfig() as short
declare function background(fn as string) as short
declare function configuration() as short
declare function loadmap(m as short,slot as short) as short

' prosIO.bas
declare function skillcheck(targetnumber as short,skill as short, modifier as short) as short
declare function showteam(from as short, r as short=0) as short
declare function gainxp(slot as short) as short
declare function gaintalent(slot as short) as string
declare function addtalent(cr as short, ta as short, value as single) as single
declare function removemember(n as short, f as short) as short
declare function changemoral(value as short, where as short) as short
declare function isgardenworld(m as short) as short


declare sub shipstatus(heading as short=0)
declare sub show_stars(bg as short=0)
declare sub displaystar(a as short)
declare sub displayplanetmap(a as short)
declare sub displaystation(a as short)
declare sub displayship(show as byte=0)
declare sub displaysystem(sys as _stars,forcebar as byte=0)
declare sub displayawayteam(awayteam as _monster, map as short, lastenemy as short, deadcounter as short, ship as gamecords,loctime as short)
declare sub dtile (x as short,y as short, tiles as _tile,bgcol as short=0)

declare function hpdisplay(a as _monster) as short
declare function infect(a as short, dis as short) as short
declare function diseaserun(a as short) as short
declare function settactics() as short
declare function makevismask(vismask()as byte,byval a as _monster,m as short) as short
declare function makestuffstring(l as short) as string
declare function levelup(p as _ship) as _ship
declare function maxsecurity() as short
declare function addmember(a as short) as short
declare function cureawayteam(where as short) as short
declare function healawayteam(byref a as _monster,heal as short) as short
declare function damawayteam(byref a as _monster,dam as short,ap as short=0,dis as short=0) as string
declare function dplanet(p as _planet,orbit as short, scanned as short) as short
declare function dprint(text as string, delay as short =5, col as short=11) as short
declare function blink(byval p as cords) as short
declare function cursor(target as cords,map as short) as string
declare function menu(text as string,help as string="", x as short=2, y as short=2,blocked as short=0) as short
declare function move_ship(key as string) as _ship

declare function getplanet(sys as short, forcebar as byte=0) as short
declare function getsystem(player as _ship) as short
declare function getrandomsystem(unique as short=1) as short
declare function getrandomplanet(s as short) as short
declare function sysfrommap(a as short)as short

declare function askyn(q as string,col as short=11) as short
declare function randomname() as string
declare function getclass(a as short=0) as string
declare function isgasgiant(m as short) as short
declare function countgasgiants(sys as short) as short
declare function isasteroidfield(m as short) as short
declare function countasteroidfields(sys as short) as short
declare function checkcomplex(map as short,fl as short) as integer
declare function getnumber(a as short,b as short, e as short) as short
declare function gettext(x as short, y as short, ml as short, text as string) as string
declare function getdirection(key as string) as short
declare function keyplus(key as string) as short
declare function keyminus(key as string) as short
declare function paystuff(price as integer) as integer
declare function shop(sh as short,i as short, t as string) as short
declare function mondis(enemy as _monster) as string
declare function getfilename() as string
declare function savegame()as short
declare function loadgame(filename as string) as short
declare function copytile (byval a as short) as _tile


declare function com_display(defender as _ship, attacker() as _ship, lastenemy as short, marked as short, senac as short,e_track_p() as cords,e_track_v()as short,e_last as short,mines_p() as cords,mines_v() as short,mines_last as short) as short
declare function com_gettarget(defender as _ship, wn as short, attacker() as _ship,lastenemy as short,senac as short,marked as short,e_track_p() as cords,e_track_v() as short,e_last as short,mines_p() as cords,mines_v() as short,mines_last as short) as short
declare function com_fire(target as _ship,w as _weap, gunner as short, range as short, senac as short) as _ship
declare function com_hit(target as _ship, w as _weap, range as short, senac as short) as _ship
declare function com_criticalhit(t as _ship, roll as short) as _ship
declare function com_flee(defender as _ship,lastenemy as short) as short
declare function com_wstring(w as _weap, range as short) as string
declare function com_testweap(w as _weap, p1 as cords,attacker() as _ship,lastenemy as short,mines_p() as cords ,mines_last as short) as short
declare function com_remove(attacker() as _ship, t as short, lastenemy as short) as short
declare function com_dropmine(defender as _ship,mines_p() as cords,mines_v() as short,byref mines_last as short) as short
declare function com_detonatemine(d as short,mines_p() as cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship, byref lastenemy as short) as short
declare function com_damship(byref t as _ship, dam as short, col as short) as _ship

declare function chr850(c as short) as string
declare function keyin(allowed as string ="", byref walking as short=0,blocked as short=0)as string
declare function screenshot(a as short) as short
declare function logbook() as short
declare function bioreport(slot as short) as short
declare function messages() as short
declare function storescreen(as short) as short
declare function alienname(flag as short) as string
declare function communicate(awayteam as _monster, e as _monster, mapslot as short,li() as short,lastlocalitem as short,monslot as short) as short
declare function artifact(c as short,awayteam as _monster) as short
declare function getshipweapon() as short
declare function getmonster(enemy() as _monster, byref lastenemy as short) as short
declare function findartifact(awayteam as _monster) as short
    
declare function ep_display(awayteam as _monster, vismask()as byte, enemys() as _monster, byref lastenemy as short, li()as short,byref lastlocalitem as short,byref map as short,byref walking as short) as short
declare function earthquake(t as _tile,dam as short)as _tile

'planets
declare sub makeclouds()
declare sub makefinalmap(m as short)
declare sub makecomplex(byref enter as gamecords, down as short)
declare sub makecomplex2(slot as short,gc1 as gamecords, gc2 as gamecords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short)
declare sub makecomplex3(slot as short,cn as short, rc as short,collums as short,t as short)
declare sub makecomplex4(slot as short,rn as short,tileset as short)
declare sub makeplatform(slot as short,platforms as short,rooms as short,translate as short, adddoors as short=0)
declare sub makelabyrinth(slot as short)
declare sub invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=10, _y as short=10)
declare sub makeroots(slot as short)
declare sub makeplanetmap(a as short,orbit as short, spect as short)
declare sub makecavemap(enter as gamecords,tumod as short,dimod as short, spemap as short, froti as short)
declare sub togglingfilter(slot as short, high as short=1, low as short=2)  
declare sub makespecialplanet(a as short)
declare sub makedrifter(d as _driftingship,bg as short=0)
declare sub makeice(a as short, o as short)
declare sub makecanyons(a as short, o as short)
declare sub makecraters(a as short, o as short)
declare sub makemossworld(a as short,o as short)
declare sub makeislands(a as short, o as short)
declare sub makeoceanworld(a as short,o as short)
declare sub adaptmap(slot as short,enemy()as _monster,byref lastenemy as short)
declare sub makeoutpost (slot as short,x1 as short=0, y1 as short=0)
declare function makesettlement(p as cords,slot as short, typ as short) as short
declare function makevault(r as _rect,slot as short,nsp as cords, typ as short) as short
declare function rndwallpoint(r as _rect, w as byte) as cords
declare function rndwall(r as _rect) as short
declare function digger(byval p as cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
declare function flood_fill(x as short,y as short,map()as short, flag as short=0) as short
declare function findsmartest(start as short, iq as short, enemy() as _monster, lastenemy as short) as short
declare function makeroad(byval s as cords,byval e as cords, a as short) as short
declare function addportal(from as gamecords, dest as gamecords, twoway as short, tile as short,desig as string, col as short) as short
declare function deleteportal(f as short=0, d as short=0) as short
declare function checkvalid(x as short,y as short, map() as short) as short
declare function floodfill3(x as short,y as short,map() as short) as short
declare function checkdoor(x as short,y as short, map() as short) as short
declare function checkbord(x as short,y as short, map() as short) as short


'pirates
declare function makeweapon(a as short) as _weap
declare function makeship(a as short) as _ship
declare function makemonster(a as short, map as short) as _monster
'awayteam as _monster, map as short, spawnmask() as cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster    
declare function makecorp(a as short) as _station

'highscore
declare sub highsc()
declare sub postmortem
declare function score() as integer
declare function getdeath() as string

'cargotrade
declare function pirateupgrade() as short
declare function findcompany(c as short) as short
declare function drawroulettetable() as short
declare function towingmodules() as short
declare function getshares(company as short) as short
declare function sellshares(company as short,n as short) as short
declare function buyshares(company as short,n as short) as short
declare function cropstock() as short
declare function portfolio(x as short,y as short) as short
declare function dividend() as short
declare function getsharetype() as short
declare function rerollshops() as short
declare function hiring(st as short, byref hiringpool as short, hp as short) as short
declare function shipupgrades() as short
declare function shipyard(pir as short=1) as short
declare function repairhull() as short
declare function refuel() as short
declare function casino(staked as short=0, st as short=0) as short
declare function upgradehull(t as short,byref s as _ship) as short
declare function gethullspecs(t as short) as _ship
declare function makehullbox(t as short) as string
declare function company(st as short,byref questroll as short) as short
declare function merctrade(f as _fleet) as _fleet
declare function unload_f(f as _fleet, st as short) as _fleet
declare function unload_s(s as _ship, st as short) as _ship
declare function load_f(f as _fleet, st as short) as _fleet
declare function load_s(s as _ship,goods as short, st as short) as short
declare sub trading(st as short) 
declare sub buygoods(st as short)
declare sub sellgoods(st as short)
declare sub recalcshipsbays()
declare function stockmarket(st as short) as short
declare function displaywares(st as short) as short
declare function changeprices(st as short,etime as short) as short
declare function getfreecargo() as short
declare function getnextfreebay() as short
declare function nextemptyc() as short
declare function stationgoods(st as short) as string
declare function cargobay(st as short) as string
declare function getinvbytype(t as short) as short
declare function removeinvbytype(t as short, am as short) as short
declare function getitemlist(inv() as _items, invn()as short, ty as short=0) as short

'Items
declare function equipawayteam(player as _ship,awayteam as _monster, m as short) as short
declare function removeequip() as short
declare function findbest(t as short,p as short=0, m as short=0) as short
declare function makeitem(a as short,mod1 as short=0,mod2 as short=0) as _items
declare function placeitem(i as _items,x as short=0,y as short=0,m as short=0,p as short=0,s as short=0) as short
declare function getitem(fr as short=999,ty as short=999) as short
declare function buysitems(desc as string,ques as string, ty as short, per as single=1,agrmod as short=0) as short
declare function giveitem(e as _monster,nr as short, li() as short, byref lastlocalitem as short) as short
declare function changetile(x as short,y as short,m as short,t as short) as short
declare function textbox(text as string,x as short,y as short,w as short, fg as short=11, bg as short=0) as short
declare function destroyitem(b as short) as short
declare function findworst(t as short,p as short=0, m as short=0) as short
declare function rnd_item(t as short) as _items
declare function getrnditem(fr as short,ty as short) as short

'math
declare function nearestbase(c as cords) as short
declare function sub0(a as single,b as single) as single
declare function disnbase(c as cords) as single
declare function dispbase(c as cords) as single
declare function rnd_point(m as short=0,w as short=0, t as short=0)as cords
declare function rndrectwall(r as _rect,d as short=5) as cords
declare function fillmap(map() as short,tile as short) as short
declare function fill_rect(r as _rect,t1 as short, t2 as short,map() as short) as short
declare function chksrd(p as cords, slot as short) as short
declare function findrect(tile as short,map()as short, er as short=0, fi as short=60) as _rect
declare function content(r as _rect,tile as short,map()as short) as integer
declare function distance(first as cords, last as cords) as single
declare Function rnd_range (first As short, last As short) As short
declare function movepoint(byval c as cords, a as short, eo as short=0,showstats as short=0) as cords
declare function pathblock(byval c as cords,byval b as cords,mapslot as short,blocktype as short=1,col as short=0) as short
declare function nearest(c as cords,b as cords) as single
declare function farthest(c as cords,b as cords) as single
declare function distributepoints(result() as cords, ps() as cords, last as short) as single
declare function getany(possible() as short)as short
declare function maximum(a as double,b as double) as double
declare function minimum(a as double,b as double) as double

'quest
declare function dodialog(no as short) as short
declare function plantname(ti as _tile) as string
declare function randomcritterdescription(spec as short,weight as short,flies as short, byref pumod as byte,diet as byte, water as short,depth as short) as string
declare function givequest(st as short, byref questroll as short) as short
declare function checkquestcargo(player as _ship, st as short) as _ship
declare function getunusedplanet() as short
declare function dirdesc(start as cords,goal as cords) as string
declare function rndsentence(aggr as short, intel as short) as string
declare function showquests() as short
declare function planetbounty() as short

