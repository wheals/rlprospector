'
' debugging flags 0=off 1 =on
'

using FB
using cards

randomize timer

const __VERSION__="0.3"

const c_red=12
const c_gre=10
const c_yel=14

const st_veryeasy=8
const st_easy=10
const st_average=12
const st_hard=14
const st_veryhard=16

const show_dangerous=0
Const Show_NPCs=0'shows pirates and mercs
Const Show_specials=0'13'5'38 'special planets already discovered
Const Show_all_specials=0'38 'special planets already discovered
Const show_portals=0 'Shows .... portals!
Const Show_pirates=0 'pirate system already discovered
Const make_files=0'outputs statistics to txt files
Const show_all=0
const show_items=0 'shows entire maps
const alien_scanner=0
const start_teleport=1'player has alien scanner
Const show_critters=0 
Const enable_donplanet=0 'D key on planet tirggers displayplanetmap
Const all_resources_are=0 
const show_allitems=0 
const easy_fights=0
const show_eventp=0 'Show eventplanets
const show_mapnr=0
const show_enemyships=0
const show_mnr=0
const show_wormholes=0
const rev_map=0
const no_enemys=0
const more_mets=0
const all_drifters_are=0
const show_civs=0
const toggling_filter=0
const fuel_usage=0 
const run_until=0
dim shared as short just_run
const show_eq=0 'Show earthquakes
const dbshow_factionstatus=0
const lstcomit=56
const lstcomty=20 'Last common item
const laststar=90
const lastspecial=46
const _debug_bones=0
const _test_disease=0
const make_vault=0
const addpyramids=0
const com_log=0
const startingmoney=500
const _spawnoff=0
const show_moral=0
const makemoodlog=0
const xk=chr(255) 
const key__up = xk & "H"
const key__dn = xk & "P"
const key__rt= xk & "M"
const key__lt = xk & "K"
const key__esc = Chr(27)
const key__enter = Chr(13)
const key__space = Chr(32)
const lastflag=20
dim shared as ubyte sm_x=75
dim shared as ubyte sm_y=50
const max_maps=2047
const _clearmap=0
const _testspacecombat=0
const add_tile_each_map=0
const lastquestguy=15

'PNG Stuff 
declare function savepng( _
byref filename as string = "screenshot.png", _
byval image as any ptr = 0, _
byval save_alpha as integer = 0) as integer

const PNG_HEADER as string = !"\137PNG\r\n\26\n"
const IHDR_CRC0 as uinteger = &ha8a1ae0a 'crc32(0, @"IHDR", 4)
const PLTE_CRC0 as uinteger = &h4ba88955 'crc32(0, @"PLTE", 4)
const IDAT_CRC0 as uinteger = &h35af061e 'crc32(0, @"IDAT", 4)
const IEND_CRC0 as uinteger = &hae426082 'crc32(0, @"IEND", 4)

type struct_ihdr field = 1
    width as uinteger
    height as uinteger
    bitdepth as ubyte
    colortype as ubyte
    compression as ubyte
    filter as ubyte
    interlace as ubyte
end type
const IHDR_SIZE as uinteger = sizeof( struct_ihdr )

'Done with png stuff

dim shared as byte _tix=24
dim shared as byte _tiy=24
dim shared _debugflag(1) as byte
dim shared as byte debugvacuum=0
dim shared as integer fmod_error
dim shared as byte _NoPB=2
dim shared as byte wormhole=8
dim shared as short countpatrol,makepat

dim shared as ushort _screenx=800
dim shared as ushort _screeny=0
dim shared as byte _teamcolor=15
dim shared as byte _shipcolor=14
dim shared as byte _showspacemap=1

dim shared as byte _hpdisplay=1


dim shared as byte _autoinspect=1

dim shared as byte _volume=9
dim shared as byte _resolution=2
dim shared as byte _lines=25
dim shared as byte _textlines
dim shared as byte _narrowscreen=0
dim shared as byte _mwx=30
dim shared as byte gt_mwx=40
dim shared as byte _showrolls=0
dim shared as byte captainskill=-5
dim shared as byte wage=10

dim shared as byte com_cheat=0
dim shared as short sidebar
dim shared as string*3 key_testspacecombat="\Cy"
dim shared as string*3 key_manual="?"
dim shared as string*3 key_messages="m"
dim shared as string*3 key_configuration="="
dim shared as string*3 key_autoinspect="I"
dim shared as string*3 key_autopickup="P"
dim shared as string*3 key_shipstatus="@"
dim shared as string*3 key_equipment="E"
dim shared as string*3 key_tactics="T"
dim shared as string*3 key_awayteam="A"
dim shared as string*3 key_quest="Q"
dim shared as string*3 key_tow="t"
dim shared as string*3 key_autoexplore="#"
dim shared as string*3 key_standing="\Cs"

dim shared as string*3 key_la="l"
dim shared as string*3 key_tala="\Cl"
dim shared as string*3 key_sc="s"
dim shared as string*3 key_save="S"
dim shared as string*3 key_quit="q"
'dim shared as string*3 key_D="D"
'dim shared as string*3 key_G="G"
dim shared as string*3 key_report="R"
dim shared as string*3 key_rename="C\r"
dim shared as string*3 key_dock="d"
dim shared as string*3 key_comment="c"
dim shared as string*3 key_dropshield="s"
dim shared as string*3 key_inspect="i"
dim shared as string*3 key_ex="x"
dim shared as string*3 key_ra="r"
dim shared as string*3 key_te="t"
dim shared as string*3 key_ju="j"
dim shared as string*3 key_co="c"
dim shared as string*3 key_of="o"
dim shared as string*3 key_gr="g"
dim shared as string*3 key_fi="f"
dim shared as string*3 key_autofire="F"
dim shared as string*3 key_he="h"
dim shared as string*3 key_walk="w"
dim shared as string*3 key_pickup=","
dim shared as string*3 key_drop="D"
dim shared as string*3 key_oxy="O"
dim shared as string*3 key_close="C"
dim shared as byte _autopickup
dim shared as string*3 key_ac="a"
dim shared as string*3 key_ru="R"

dim shared as string*3 key_nw="7"
dim shared as string*3 key_north="8"
dim shared as string*3 key_ne="9"
dim shared as string*3 key_west="4"
dim shared as string*3 key_east="6"
dim shared as string*3 key_sw="1"
dim shared as string*3 key_south="2"
dim shared as string*3 key_se="3"
dim shared as string*3 key_wait="5"
dim shared as string*3 key_layfire="0"
dim shared as string*3 key_portal="<"
dim shared as string*3 key_logbook="L"
dim shared as string*3 key_togglehpdisplay="\Ch"
dim shared as string*3 key_yes="y"
dim shared as string*3 key_wormholemap="W"
dim shared as string*3 key_togglemanjets="M"
dim shared as string*3 key_cheat="ü"
dim shared as string*3 key_pageup="ä"
dim shared as string*3 key_pagedown="ö"
dim shared as string*3 no_key
dim shared as string*3 key_mfile="ä"
dim shared as string*3 key_filter="f"
dim shared as string*3 key_extended="#"
dim shared as string*3 key_accounting="\Ca"
dim shared gamerunning as byte
dim shared uid as uinteger
dim shared ranoutoffuel as short
dim shared walking as short
dim shared itemcat(11) as string
dim shared shopname(4) as string

type _cords
    s as short '
    p as short '
    m as short
    x as short
    y as short
    z as short
    'function set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
end type

'declare function _cords.set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
'    if x<>0 then this.x=x
'    if y<>0 then this.y=y
'    if z<>0 then this.z=z
'    if m<>0 then this.s=s
'    if p<>0 then this.p=p
'    if s<>0 then this.m=m
'    return 0
'end function
'
type _driftingship
    s as short '
    p as short '
    m as short
    x as short
    y as short
    g_tile as _cords
    start as _cords
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
    from as _cords
    dest as _cords
    tile as short
    col as short
    ti_no as uinteger
    oneway as short
    discovered as short
    desig as string*64
    tumod as short 'the higher the more tunnels
    dimod as short 'the higher the more digloops
    spmap as short 'make specialmap if non0
    froti as short 'from what tile
end type



type _items
    id as uinteger 
    ti_no as ushort
    uid as uinteger
    w as _cords
    icon as string*1
    col as short
    bgcol as short
    discovered as short
    scanmod as single
    desig as string*64
    desigp as string*64
    ldesc as string*255
    price as integer
    ty as short
    v1 as single
    v2 as single
    v3 as single
    v4 as single
    v5 as single 'Only for rewards
    v6 as single 'Rover mapdata
    vt as _cords'rover target
    res as ubyte
end type
    
type _weap
    desig as string*30
    dam as short
    range as single
    ammo as short
    ammomax as short
    ROF as byte
    ECMmod as byte
    p as short
    made as byte
    col as byte
    heat as short
    heatadd as byte
    heatsink as byte
    reload as byte
    reloading as byte
    shutdown as byte
end type

type _ammotype
    made as byte
    desig as string*32
    tohit as byte
    todam as byte
    toran as byte
    toheat as byte
    price as byte
    size as byte
end type

type _faction
    war(7) as short
    alli as short
end type

enum shipequipment
    se_navcom
    se_ECM
    se_CargoShielding
    se_shipdetection
    se_fuelsystem
end enum

type _ship
    c as _cords
    map as short
    osx as short
    osy as short
    lastpirate as _cords
    landed as _cords
    turn as integer
    money as integer
    aggr as short
    energy as short
    desig as string *32
    icon as string *1
    ti_no as uinteger
    di as byte
    turnrate as byte
    senac as byte
    cursed as byte
    declare function diop() as byte
    sensors as short
    engine as short
    declare function movepoints(mjs as short) as short
    declare function pilot(onship as short) as short
    declare function gunner(onship as short) as short
    declare function science(onship as short) as short
    declare function doctor(onship as short) as short
    pipilot as short
    pigunner as short
    piscience as short
    pidoctor as short
    security as short
    disease as byte
    
    manjets as short
    weapons(25) as _weap  
    declare function useammo() as short
    hull as short
    hulltype as short
    
    armortype as byte=1
    loadout as byte=1
    reloading as byte=10
    bunking as byte=1
    
    fuelmax as single
    fuel as single
    fueluse as single
    shieldmax as integer
    shieldside(7) as byte
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
    addhull as short
    
    dead as short
    killedby as string*64
    shiptype as short
    target as _cords
    equipment(4) as short
    stuff(5) as single
    cargo(25) as _cords
    st as byte
    bounty as byte
    'tradingmoney as integer
    lastvisit as _visit
    cryo as short
    alienkills as uinteger
    deadredshirts as uinteger
    score as uinteger
    questflag(31) as short
    discovered(10) as byte
    towed as byte
    tractor as byte
    teleportload as byte
    col as short
    bcol as short
    mcol as short
end type


dim shared foundsomething as integer

function _ship.useammo() as short
    dim as short i,most,where
    for i=0 to 25
        if weapons(i).ammo>most then 
            most=weapons(i).ammo
            where=i
        endif
    next
    if weapons(where).ammo>0 then
        weapons(where).ammo-=1
        return -1
    else
        return 0
    endif
end function
            
dim shared alliance(7) as byte

function _ship.diop() as byte
    if this.di=1 then return 9
    if this.di=2 then return 8
    if this.di=3 then return 7
    if this.di=4 then return 6
    if this.di=6 then return 4
    if this.di=7 then return 3
    if this.di=8 then return 2
    if this.di=9 then return 1
end function

type _monster
    made as ubyte
    slot as byte
    no as ubyte
    hpmax as single
    hp as single
    hpnonlethal as single 'stores nonleathal damage done to critter
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
    stunres as byte
    diet as byte
    intel as short
    lang as short
    nocturnal as byte
    
    faction as short
    allied as short
    enemy as short
    aggr as byte
    killedby as byte
    
    desc as string*127
    sdesc as string*64
    ldesc as string*512
    dhurt as string*16
    dkill as string*16
    swhat as string*64
    scol as ubyte
    invis as byte
    
    tile as short
    ti_no as uinteger
    sprite as short
    col as ubyte
    dcol as ubyte
    
    move as single
    union 
        track as short
        carried as short
    end union
    range as short
    weapon as short
    armor as short
    respawns as byte
    breedson as byte
    regrate as byte
    reg as byte
    nearest as ubyte
    cmshow as byte
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
    c as _cords
    target as _cords
    hasoxy as byte
    atcost as single
    lastaction as byte
    stuff(16) as single
    items(8) as short
    itemch(8) as short
end type

type _stars
    c as _cords
    spec as byte
    ti_no as uinteger
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
    highestlife as single
    minerals as short
    weat as single
    depth as byte
    death as short
    genozide as byte
    teleport as byte
    plantsfound as short
    pla_template(16) as byte
    mon_template(16) as _monster
    mon_noamin(16) as byte
    mon_noamax(16) as byte
    mon_killed(16) as byte
    mon_disected(16) as byte
    mon_caught(16) as byte
    mon_seen(16) as byte
    colony as byte
    colonystats(14) as byte
    vault(8) as _rect
    discovered as short
    visited as integer
    mapped as integer
    mapmod as single
    rot as single
    flags(32) as byte
    weapon(5) as _weap
    comment as string*60
    mapstat as byte
    colflag(16) as byte
end type


'Flag 28=techgoods delivered to star creatures
type _ae
    c as _cords
    rad as byte
    dam as byte
    dur as byte
    typ as byte
end type

type _planetsave
    awayteam as _monster
    enemy(256) as _monster
    lastenemy as short
    lastlocalitem as short
    ship as _cords
    map as short
end type

type _fleet
    ty as short 'Type: 1=patrol 2=merchant 3=pirate
    c as _cords'Coordinates
    t as short 'Number of coordinates of target in targetlist
    fuel as integer
    del as short
    flag as short
    fighting as short
    declare function count() as short
    con(15) as short ' Old ship storage con(0)=Nicety of pirates con(1)=Escorting
    mem(15) as _ship 'Actual ship storage
end type

function _fleet.count() as short
    dim as short i,c
    for i=1 to 15
        if mem(i).hull>0 then c+=1
    next
    return c
end function

type _goods
    'n as string*16
    p as single
    v as single
    'test as single
    'test2 as single
end type
dim shared vismask(sm_x,sm_y) as byte
dim shared as string goodsname(9)

const lastgood=9

type _basis 
    c as _cords
    discovered as short
    inv(lastgood) as _goods
    'different companys for each station
    repname as string*32
    company as byte
    spy as byte
    shop(8) as byte
    pricelevel as single=1
    mapmod as single
    biomod as single
    resmod as single
    pirmod as single
    lastsighting as short
    lastsightingdis as short
    lastsightingturn as short
    lastfight as short
    docked as short
end type

dim shared goods_prices(9,12,12) as single
dim shared wsinv(20) as _weap
    
'type _fuel
'    declare function changeprice() as short
'    declare function adddemand(volume as short) as short
'    declare function addsupply(volume as short) as short
'    declare function init(ty as byte) as short
'    tanksize as short
'    content as short
'    demand as short
'    supply as short
'    price as single
'end type
'
'function _fuel.changeprice() as short
'    if demand>supply then price+=.1
'    if demand<supply then price-=.1
'    return 0
'end function
'
'function _fuel.init(ty as byte) as short
'    
'    if ty=1 then 
'        price=1.5
'        tanksize=500
'    endif
'    if ty=2 then 
'        price=1
'        tanksize=2500
'    endif
'    content=tanksize/2
'    return 0
'end function
'
'function _fuel.addsupply(volume as short) as short
'    dim rest as short
'    content+=volume
'    if content>tanksize then
'        rest=content-tanksize
'    else
'        rest=0
'    endif
'    supply+=volume-rest
'    return rest
'end function
'
'function _fuel.adddemand(volume as short) as short
'    dim rest as short
'    content-=volume
'    if content<0 then
'        rest=volume-content
'        content=0
'    endif
'    demand+=volume-rest
'    return rest
'end function
'
'dim shared fuel(48) as _fuel
'dim shared lastfuel as byte
type _comment
    c as _cords
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
    ti_no as uinteger
    bgcol as short
    col as short
    
    desc as string*512
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
    hitt as string*512
    misst as string*512
    deadt as string*512
    turnsinto as short
    succt as string*512
    failt as string*512
    killt as string*512
    spawnson as short
    spawnswhat as short
    spawnsmax as short
    spawnblock as short '=0 spawns forever, >0 each spawn =-3, <0 spawning blocked
    spawntext as string*512
    survivors as short
    resources as short
    gives as short
    vege as byte
    disease as byte
    turnsoninspect as short
    turnroll as byte
    turntext as string*512
    causeaeon as byte
    aetype as byte
    hides as byte
    repairable as byte
    onclose as short
    onopen as short
    turnsonleave as short
    turnsonleavetext as string*512
end type

type _disease
    no as ubyte
    desig as string
    ldesc as string
    cause as string
    incubation as ubyte
    duration as ubyte
    fatality as ubyte
    contagio as ubyte
    causeknown as byte
    cureknown as byte
    att as byte
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
    oldonship as byte
    jp as byte
    equips as byte
    weap as single
    blad as single
    tohi as single
    armo as single
    pref_ccweap as uinteger
    pref_lrweap as uinteger
    pref_armor as uinteger
    talents(29) as byte
    augment(16) as byte
    xp as short
    morale as short
    target as short
    time as short
    bonus as short
    price as short
    baseskill(3) as short
    story(10) as byte
end type
declare function best_crew(skill as short,no as short) as short

function _ship.pilot(onship as short) as short
    if pipilot<>0 then return pipilot
    return best_crew(0,1)
end function

function _ship.gunner(onship as short) as short
    if pigunner<>0 then return pigunner
    return best_crew(1,h_maxweaponslot)
end function

function _ship.science(onship as short) as short
    if piscience<>0 then return piscience
    return best_crew(2,h_maxsensors)
end function    

function _ship.doctor(onship as short) as short
    if pidoctor<>0 then return pidoctor
    return best_crew(3,12)
end function

function _ship.movepoints(mjs as short) as short
    dim mps as short
    mps=cint(this.engine*2-this.hull*0.15)
    if engine>0 then mps=mps+1+mjs*3
    if mps<=0 then mps=1
    if mps>9 then mps=9
    return mps
end function

type _share
    company as byte
    bought as uinteger
    lastpayed as uinteger
end type

type _company
    profit as integer
    capital as integer
    rate as integer
    shares as short
end type

type _company_bonus
    base as uinteger
    value as uinteger
    rank as uinteger
end type

type _shipfire
    what as short
    when as short
    where as _cords
    tile as string*1
    stun as byte
end type

type _dialogoption
    no as ushort
    answer as string
end type

type _dialognode
    no as ushort
    statement as string
    effekt as string
    param(5) as short
    option(16) as _dialogoption
end type

type _civilisation
    n as string
    home as _cords
    ship(1) as _ship
    item(1) as _items
    spec as _monster
    knownstations(2) as byte
    contact as byte
    popu as byte
    aggr as byte
    inte as byte
    tech as byte
    phil as byte
    wars(2) as short '0 other civ, 1 pirates, 2 Merchants
    prefweap as byte
    culture(6) as byte '0 birth 1 Childhood 2 Adult 3 Death 4 Religion 5 Art 6 story about a unique
end type

Type FONTTYPE
  As Integer w
  As Any Ptr dataptr
End Type

type _pfcords
    x as short
    y as short
    c as uinteger
    i as byte
end type


Type vector
        x As Integer
        y As Integer
        declare Constructor(x as Integer, y as Integer)
End Type

Constructor vector (x as Integer, y as Integer)
        this.x = x
        this.y = y
End Constructor

Type _sym_matrix
       
        xm As Integer
        vmax as integer
        vmin as integer
        item As Integer Ptr
       
        Declare Function get_ind(x As Integer,y As Integer) As Integer
        Declare Function set_val(x As Integer,y As Integer, v As Integer) As Integer
        Declare Function get_val(x As Integer,y As Integer) As Integer
        Declare Property Val(xy As vector) As Integer
        Declare Property Val(xy As vector,v As Integer)

        Declare Constructor (ByVal size As Integer)
        Declare Destructor ()
End Type

Constructor _sym_matrix (ByVal size As Integer)
        xm = size
        item = New Integer[size * size]
End Constructor

Destructor _sym_matrix
        Delete[] item
End Destructor

Function _sym_matrix.get_ind(x As Integer, y As Integer) As Integer
        Dim i As Integer
        With This
                x+=1
                y+=1
                If x>xm Then x=xm
                If y>xm Then y=xm
                If x<1 Then x=1
                If y<1 Then y=1
                If x>y Then Swap x,y
                i=x+y*(y-1)/2
        End With
        Return i
End Function

Function _sym_matrix.set_val(x As Integer,y As Integer,v As Integer) As Integer
        Dim i As Integer
        i=this.get_ind(x,y)
        if v>this.vmax and this.vmax<>0 then v=this.vmax
        if v<this.vmin then v=this.vmin
        this.item[i]=v
        Return 0
End Function

Function _sym_matrix.get_val(x As Integer,y As Integer) As Integer
        Dim i As Integer
        i=this.get_ind(x,y)
        Return this.item[i]
End Function

Property _sym_matrix.val(xy As vector) As Integer
        Return this.get_val(xy.x,xy.y)
End Property

Property _sym_matrix.val(xy As vector,v As Integer)
        this.set_val(xy.x,xy.y,v)
End Property

type _bountyquest
    status as byte '1 given, 2 ship destroyed by player, 3 ship destroyed by other, 4 reward given
    employer as byte
    ship as short
    reward as short
    desig as string *32
    reason as byte
    lastseen as _cords
end type

type _questitem
    generic as byte 'If new is generated, and last one was generic, next one is specific
    motivation as byte
    type as byte
    whohasit as byte
    given as byte
    'id as integer
    it as _items
end type

type _questguy
    gender as byte
    n as string*25
    job as short
    location as short
    talkedto as short'1 Knows, 2 asked want
    lastseen as short
    knows(lastquestguy) as byte
    systemsknown(laststar) as byte
    money as short
    risk as short
    friendly(lastquestguy) as short
    loan as short
    want as _questitem
    has as _questitem
    flag(15) as short '0=Compared notes 1=Other 3=System 4=System,6=Corp
end type

dim shared bg_parent as byte

enum backgrounds
    bg_noflip
    bg_ship
    bg_shiptxt
    bg_shipstars
    bg_shipstarstxt
    bg_awayteam
    bg_awayteamtxt
    bg_logbook
    bg_randompic
    bg_randompictxt
    bg_stock
    bg_roulette
    bg_trading
end enum

enum locat
    lc_awayteam
    lc_onship
end enum
dim shared location as byte

enum dockingdifficulty
    dd_station
    dd_smallstation
    dd_drifter
    dd_aliendrifter
    dd_comsat
    dd_asteroidmining
end enum

enum shops
    sh_shipyard
    sh_modules
    sh_equipment
    sh_used
    sh_mudds
    sh_bots
end enum

enum ShipYards
    sy_civil
    sy_military
    sy_pirates
    sy_blackmarket
end enum

dim shared shipyardname(sy_blackmarket) as string

enum moduleshops
    ms_energy
    ms_projectile
    ms_modules
end enum

dim shared moduleshopname(ms_modules) as string


enum RndItem
    RI_transport'0
    RI_rangedweapon'1
    RI_ccweapon'2
    RI_armor'3
    RI_Medpacks'4
    RI_KODrops'5
    RI_WEAPONS'6
    RI_ALLBUTWEAPONS'7
    RI_Mining'8
    RI_Kits'9
    RI_ROBOTS'10
    RI_Rovers'11
    RI_Infirmary'12
    RI_LandingGear'13
    RI_ALLDRONESPROBES'14
    RI_StrandedShip'15
    RI_Artefact'16
    RI_SPACEBOTS
    RI_Probes'
    RI_Drones'18
    RI_GasProbes
    RI_Miningbots'20
    RI_Shipequipment
    RI_Lamps'22
    RI_Tanks
    RI_AllButWeaponsAndMeds'24
    RI_StandardShop
    RI_ShopAliens'26
    RI_ShopSpace
    RI_ShopExplorationGear'28
    RI_ShopWeapons
    RI_WeaponsArmor
    RI_Cage
    RI_WeakWeapons
    RI_WeakStuff
    
end enum

enum ShipType
    ST_first
    ST_PFighter                  
    ST_PCruiser                  
    ST_PDestroyer                
    ST_PBattleship               
    ST_lighttransport                 
    ST_heavytransport                 
    ST_merchantman                 
    ST_armedmerchant                 
    ST_CFighter                         
    ST_CEscort                          
    ST_Cbattleship                         
    ST_AnneBonny                      
    ST_BlackCorsair
    st_hussar
    st_blackwidow
    st_adder
    ST_civ1
    ST_civ2
    ST_AlienScoutShip              
    ST_spacespider                  
    ST_livingsphere                   
    ST_symbioticcloud                 
    ST_hydrogenworm                   
    ST_livingplasma                   
    ST_starjellyfish                   
    ST_cloudshark                      
    ST_Gasbubble   
    ST_cloud
    ST_Floater     
    st_spacestation
    st_last
end enum

dim shared piratenames(st_last) as string
dim shared piratekills(st_last) as integer
dim shared questroll as short
enum SHIELDDIR
    sd_front
    sd_frontright
    sd_right
    sd_rearright
    sd_rear
    sd_rearleft
    sd_left
    sd_frontleft
end enum

enum QUEST
    Q_WANT
    Q_HAS
    Q_ANSWER
end enum

enum questtype
    qt_empty'0
    qt_EI'1
    qt_autograph'2
    qt_outloan'3
    qt_stationimp'4
    qt_drug'5
    qt_souvenir'6
    qt_tools'7
    qt_showconcept'8
    qt_stationsensor'9
    qt_travel'10 Needs Debugging
    qt_cargo'11 Needs Debugging
    qt_locofpirates'12
    qt_locofspecial'13
    qt_locofgarden'14
    qt_locofperson'15
    qt_goodpaying'16
    qt_research'17
    qt_megacorp'18
    qt_biodata'19
    qt_anomaly'20
    qt_juryrig'21
    qt_cursedship'22
end enum

enum moneytype
    mt_startcash
    mt_bonus
    mt_quest
    mt_pirates
    mt_ress
    mt_bio
    mt_map
    mt_ano
    mt_trading
    mt_towed
    mt_escorting
    mt_artifacts
    mt_blackmail
    mt_piracy
    mt_gambling
    mt_quest2
    mt_last
end enum

dim shared income(mt_last) as integer

enum config
    con_empty
    con_res
    con_tiles
    con_gtmwx
    con_classic
    con_showvis
    con_captainsprite
    con_transitem
    con_onbar
    con_sysmaptiles
    con_customfonts
    con_chosebest
    con_autosale
    con_showrolls
    con_sound
    con_warnings
    con_damscream
    con_volume
    con_anykeyno
    con_diagonals
    con_altnum
    con_easy
    con_minsafe
    con_startrandom
    con_autosave
    con_savescumming
    con_restart
    con_end
end enum


dim shared as string configname(con_end-1)    
dim shared as string configdesc(con_end-1)
dim shared as byte configflag(con_end-1)

dim shared as byte startingweapon

configname(con_tiles)="tiles"
configname(con_gtmwx)="gtmwx"
configname(con_classic)="classic"
configname(con_showvis)="showvis"
configname(con_transitem)="transitem"
configname(con_onbar)="onbar"
configname(con_captainsprite)="captainsprite"
configname(con_sysmaptiles)="sysmaptiles"
configname(con_customfonts)="customfonts"
configname(con_chosebest)="chosebest"
configname(con_autosale)="autosale"
configname(con_sound)="sound"
configname(con_showrolls)="rolls"
configname(con_warnings)="warnings"
configname(con_damscream)="damscream"
configname(con_volume)="volume"
configname(con_anykeyno)="anykeyno"
configname(con_diagonals)="digonals"
configname(con_altnum)="altnum"
configname(con_easy)="easy"
configname(con_minsafe)="minsafe"
configname(con_startrandom)="startrandom"
configname(con_autosave)="autosave"
configname(con_savescumming)="savescumming"
configname(con_restart)="restart"

configdesc(con_showrolls)="/ Show rolls:"
configdesc(con_chosebest)="/ Always chose best item:"
configdesc(con_sound)="/ Sound effects:"
configdesc(con_diagonals)="/ Automatically chose diagonal:"
configdesc(con_autosale)="/ Always sell all:"
configdesc(con_startrandom)="/ Start with random ship:"
configdesc(con_autosave)="/ Autosave on entering station:" 
configdesc(con_minsafe)="/ Minimum safe distance to pirate planets:"
configdesc(con_anykeyno)="/ Any key counts as no on yes-no questions:" 
configdesc(con_restart)="/ Return to start menu on death:" 
configdesc(con_warnings)="/ Navigational Warnings(Gasclouds & 1HP landings):" 
configdesc(con_tiles)="/ Graphic tiles:" 
configdesc(con_easy)="/ Easy start:" 
configdesc(con_volume)="/ Volume (0-4):"
configdesc(con_res)="/ Resolution:"
configdesc(con_showvis)="/ Underlay for visible tiles:"
configdesc(con_onbar)="/ Starmap on bar:"
configdesc(con_classic)="/ Classic look:"
configdesc(con_altnum)="/ Alternative Numberinput:"
configdesc(con_transitem)="/ Transparent Items:"
configdesc(con_gtmwx)="/ Main window width(tile mode):"
configdesc(con_savescumming)="/ Savescumming:"
configdesc(con_sysmaptiles)="/ Use tiles for system map:"
configdesc(con_customfonts)="/ Customfonts:"
configdesc(con_damscream)="/ Damage scream:"

dim shared battleslost(8,8) as integer
enum fleettype
    ft_player
    ft_merchant
    ft_pirate
    ft_patrol
    ft_pirate2
    ft_ancientaliens
    ft_civ1
    ft_civ2
    ft_monster
end enum
'type MODE
'  As Integer mode_num      '/* Current mode number */
'  As Byte Ptr ptr page      '/* Pages memory */
'  As Integer num_pages      '/* Number of requested pages */
'  As Integer work_page      '/* Current work page number */
'  As Byte Ptr framebuffer   '/* Our current visible framebuffer */
'  As Byte Ptr ptr Line      '/* Line pointers into current active framebuffer */
'  As Integer pitch      '/* Width of a framebuffer line in bytes */
'  As Integer target_pitch   '/* Width of current target buffer line in bytes */
'  As Any Ptr last_target   '/* Last target buffer set */
'  As Integer max_h      '/* Max registered height of target buffer */
'  As Integer bpp      '/* Bytes per pixel */
'  As Uinteger Ptr Palette   '/* Current RGB set__color( values for each palette index */
'  As Uinteger Ptr device_palette   '/* Current RGB set__color( values of visible device palette */
'  As Byte Ptr color_association   '/* Palette set__color( index associations for CGA/EGA emulation */
'  As Byte Ptr dirty               '/* Dirty lines buffer */
'  As Any Ptr driver      '/* Gfx driver in use */
'  As Integer w
'  As Integer h         '/* Current mode width and height */
'  As Integer depth      '/* Current mode depth */
'  As Integer color_mask      '/* set__color( bit mask for colordepth emulation */
'  As Any Ptr default_palette   '/* Default palette for current mode */
'  As Integer scanline_size   '/* Vertical size of a single scanline in pixels */
'  As Uinteger fg_color
'  As Uinteger bg_color      '/* Current foreground and background colors */
'  As Single last_x
'  As Single last_y      '/* Last pen position */
'  As Integer cursor_x
'  As Integer cursor_y      '/* Current graphical text cursor position (in chars, 0 based) */
'  As fonttype Ptr font      '/* Current font */
'  As Integer view_x
'  As Integer view_y
'  As Integer view_w
'  As Integer view_h      '/* VIEW coordinates */
'  As Single win_x
'  As Single win_y
'  As Single win_w
'  As Single win_h      '/* WINDOW coordinates */
'  As Integer text_w
'  As Integer text_h      '/* Graphical text console size in characters */
'  As Byte Ptr Key      '/* Keyboard states */
'  As Integer refresh_rate   '/* Driver refresh rate */
'  As Integer flags      '/* Status flags */
'End Type

'Extern fb_mode As MODE Ptr

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

dim shared adislastenemy as short, adisdeadcounter as short,adisloctime as short,adisloctemp as single
dim shared as short lastbountyquest=16
dim shared bountyquest(lastbountyquest) as _bountyquest
dim shared questguy(lastquestguy) as _questguy
dim shared questguyjob(18) as string
dim shared questguydialog(22,2,2) as string
dim shared questguyquestion(22,1) as string
enum stphrase
    sp_greetfriendly
    sp_greetneutral
    sp_greethostile
    sp_gotalibi
    sp_gotmoney
    sp_cantpayback
    sp_notenoughmoney
    sp_last
end enum

enum slse
    slse_arena
    slse_zoo
    slse_slaves
end enum

dim shared standardphrase(sp_last-1,2) as string
dim shared talent_desc(29) as string
    
dim shared comstr as string

dim shared palette_(255) as uinteger
dim shared _swidth as byte=35'Length of line in a shop
dim shared apwaypoints(1024) as _cords
dim shared lastapwp as short
dim shared currapwp as short
dim shared apdiff as short

dim shared talent_desig(29) as string
dim shared evkey as event
'dim shared video as SDL_Surface ptr
dim shared reward(9) as single
dim shared ano_money as short

dim shared baseprice(9) as short
dim shared avgprice(9) as single

dim shared spectraltype(10) as short
dim shared spectralname(10) as string 
dim shared scount(10) as short
dim shared spectralshrt(10) as string

dim as short a,b,c,d,e,f,g
dim shared x as short
dim shared y as short
dim as single x1,y1,x2,y2

dim shared flag(20) as short
const lastartifact=25
dim shared artflag(lastartifact) as short
dim key as string
dim shared zeit as integer
dim shared savefrom(16) as _planetsave
dim shared stationroll as short
dim shared player as _ship
dim shared awayteam as _monster
dim shared map(laststar+wormhole+1) as _stars
dim shared basis(12) as _basis
dim shared companystats(5) as _company
dim shared companyname(5) as string
dim shared companynameshort(5) as string
dim shared shares(2048) as _share
dim shared lastshare as short
dim shared spacemap(sm_x,sm_y) as short
dim shared combatmap(60,20) as byte
dim shared planetmap(60,20,max_maps) as short
dim shared planets(max_maps) as _planet
dim shared planets_flavortext(max_maps) as string
dim shared civ(3) as _civilisation
dim shared retirementassets(16) as ubyte
for a=0 to max_maps
    planets(a).darkness=5
next
dim shared item(25000) as _items
dim shared lastitem as integer=-1
dim shared _last_title_pic as byte=14
dim shared shopitem(20,29) as _items
dim shared makew(20,5) as byte

dim shared tiles(512) as _tile
dim shared gtiles(2048) as any ptr
dim shared stiles(9,68) as any ptr
dim shared shtiles(7,4) as any ptr
dim shared gt_no(4096) as integer
dim shared scr as any ptr

dim shared dprintline as byte
dim shared bestaltdir(9,1) as byte
dim shared piratebase(_NoPB) as short
dim shared pirateplanet(_NoPB) as short
dim shared specialplanet(lastspecial) as short
dim shared specialplanettext(lastspecial,1) as string
dim shared spdescr(lastspecial) as string
dim shared specialflag(lastspecial) as byte
dim shared atmdes(16) as string
dim shared sound(12) as integer ptr
dim shared usedship(8) as _cords
dim shared displaytext(255) as string
dim shared dtextcol(255) as short

dim shared patrolmod as short
dim shared fleet(255) as _fleet
dim shared targetlist(4068) as _cords
dim shared drifting(128) as _driftingship
dim shared crew(128) as _crewmember
dim shared shiptypes(20) as string
dim shared disease(17) as _disease
dim shared awayteamcomp(4) as byte
dim shared faction(7) as _faction
dim shared empty_ship as _ship
dim shared empty_fleet as _fleet

empty_fleet.del=1

dim shared coms(255) as _comment
dim shared portal(1024) as _transfer
dim shared lastportal as short
dim shared lastplanet as short
dim shared lastcom as short
dim shared as byte pf_stp=1
dim shared lastwaypoint as short
dim shared firstwaypoint as short
dim shared firststationw as short
dim shared lastfleet as short
dim shared alienattacks as integer
dim shared lastdrifting as short=16
dim shared liplanet as short 'last input planet
dim shared whtravelled as short
dim shared whplanet as short
dim shared tmap(60,20) as _tile
dim shared vacuum(60,20) as byte
dim as _cords p1,p2,p3
dim shared pwa(128) as _cords'Points working array
dim dummy as _monster
dim dummycords as _cords
dim text as string
dim as short astcou,gascou,pl
dim shared tacdes(6) as string
dim shared shop_order(2) as short
dim shared pcards as cards.cardobj
dim shared lastprobe as short
dim shared probe(100) as _cords 'm=Item,

'dim shared as FB.image ptr TITLEFONT
dim shared as any ptr TITLEFONT
dim shared as any ptr FONT1,FONT2
dim shared as ubyte _FH1,_FH2,_FW1,_FW2,_fohi1,_fohi2

dim shared endstory as string
dim shared crew_desig(16) as string
dim shared combon(9) as _company_bonus

dim shared ammotypename(4) as string

dim shared cagedmonster(128) as _monster
dim shared lastcagedmonster as ubyte

dim shared as string bountyquestreason(6)

type _handrank
    rank as short
    high(5) as short
end type

type _cardcount
    rank as short
    no as short
    pos as short
end type

type _pokerplayer
    name as string*16
    risk as short 
    bet as byte
    fold as byte
    pot as byte
    rank as byte
    money as short
    card(5) as integer
    ci as byte
    in as byte
    declare function firstempty() as short
    win as _handrank
    
end type

type _pokerrules
    bet as byte
    limit as byte
    closed as byte
    swap as byte
end type

declare function make_shipequip(a as short) as _items
declare function roman(i as integer) as string

declare function shares_value() as short
declare function planet_artifacts_table() as string
declare function acomp_table() as string

declare function sort_items(list() as _items) as short
declare function items_table() as string
declare function artifacts_html(artflags() as short) as string
declare function postmort_html() as short
declare function ship_table() as string
declare function uniques_html(unflags() as byte) as string
declare function exploration_text_html() as string
declare function html_color(c as string,indent as short=0,wid as short=0) as string
declare function crew_html(c as _crewmember) as string
declare function skill_text(c as _crewmember) as string
declare function augment_text(c as _crewmember) as string
declare function crew_table() as string
declare function count_crew(crew() as _crewmember) as short
declare function income_expenses_html() as string
declare function play_poker(st as short) as short
declare function card_shuffle(card() as integer) as short

declare function player_eval(p() as _pokerplayer,i as short) as short

declare function draw_poker_table(p() as _pokerplayer,reveal as short=0, winner as short=0,r as _pokerrules) as short
declare function better_hand(h1 as _handrank,h2 as _handrank) as short
declare function poker_eval(c() as integer, acehigh as short,knowall as short) as _handrank
declare function ace_highlo_eval(c() as integer,knowall as short) as _handrank
declare function sort_cards(card() as integer,all as short=0) as short
declare function poker_next(i as short,p() as _pokerplayer) as short
declare function poker_winner(p() as _pokerplayer) as short
declare function highest_pot(p() as _pokerplayer) as short

declare function save_keyset() as short

dim shared bonesflag as short
dim shared farthestexpedition as integer

declare function findbest_jetpack() as short

' SUB DECLARATION
declare function add_a_or_an(t as string,beginning as short) as string

' prospector .bas
declare function player_energylimits() as short
declare function get_planet_cords(byref p as _cords,mapslot as short,shteam as byte=0) as string
declare function planet_cursor(p as _cords,mapslot as short,byref osx as short,shteam as byte) as string

declare function start_new_game() as short
declare function from_savegame(key as string) as string
declare function wormhole_travel() as short

declare function wormhole_ani(target as _cords) as short
declare function target_landing(mapslot as short,test as short=0) as short
declare function landing(mapslot as short,lx as short=0,ly as short=0, test as short=0) as short
declare function scanning() as short
declare function rescue() as short
declare function asteroid_mining(slot as short) as short
declare function gasgiant_fueling(t as short,orbit as short,sys as short) as short
declare function dock_drifting_ship(a as short) as short
declare function move_rover(pl as short,li()as short,lastlocalitem as short) as short
declare function rnd_crewmember(onship as short=0) as short
declare function haggle_(way as string) as single
declare function botsanddrones_shop() as short
declare function display_monsters(enemy() as _monster,lastenemy as short) as short
declare function alerts() as short
declare function launch_probe() as short
declare function move_probes() as short
declare function retirement() as short
declare function no_spacesuit(who() as short,byref alle as short=0) as short
declare function add_questguys() as short
declare function com_radio(defender as _ship, attacker() as _ship, e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short)  as short
declare function draw_shield(ship as _ship,osx as short) as short
declare function crew_menu(crew() as _crewmember, from as short, r as short=0,text as string="") as short

declare function load_palette() as short
declare function open_file(filename as string) as short
declare function death_text() as string

declare function merc_dis(fl as short,byref goal as short) as short

declare function show_dotmap(x1 as short, y1 as short) as short
declare function show_minimap(xx as short,yy as short) as short
declare function lb_filter(lobk() as string, lobn() as short, lobc() as short,lobp() as _Cords ,last as short) as short

declare function dam_no_spacesuit(dam as short) as short
declare function remove_no_spacesuit(who() as short,last as short) as short
declare function questguy_newloc(i as short) as short

declare function update_questguy_dialog(i as short,node() as _dialognode,iteration as short) as short
declare function count_gas_giants_area(c as _cords,r as short) as short
declare function questguy_dialog(i as short) as short
declare function change_armor(st as short) as short
declare function urn(min as short, max as short,mult as short,bonus as short) as short
declare function rarest_good() as short
declare function display_stock() as short

declare function calcosx(x as short,wrap as byte) as short
declare function rg_icechunk() as short
declare function ep_needs_spacesuit(slot as short,c as _cords) as short
declare function ep_display_clouds(cloudmap() as byte) as short
declare function ep_autoexploreroute(astarpath() as _cords,start as _cords,move as short, slot as short,li() as short,lastlocalitem as short) as short
declare function ep_roverreveal(i as integer) as short
declare function ep_portal() as _cords
declare function ep_pickupitem(key as string ,byref lastlocalitem as short,li() as short,enemy() as _monster,byref lastenemy as short) as short
declare function ep_shipfire(shipfire() as _shipfire,enemy() as _monster,byref lastenemy as short) as short
declare function ep_checkmove(byref old as _cords,key as string) as short
declare function ep_examine(li() as short,enemy() as _monster,lastenemy as short,lastlocalitem as short) as short
declare function ep_helmet() as short
declare function ep_closedoor() as short
declare function ep_radio(byref nextlanding as _cords,byref ship_landing as short, li() as short,lastlocalitem as short,enemy() as _monster,lastenemy as short,shipfire() as _shipfire,lavapoint() as _cords, byref sf as single, nightday() as byte,localtemp() as single) as short
declare function ep_grenade(shipfire() as _shipfire, byref sf as single,enemy() as _monster,lastenemy as short,li() as short ,byref lastlocalitem as short) as short
declare function ep_fire(enemy() as _monster,lastenemy as short,mapmask() as byte,key as string,byref autofire_target as _cords) as short
declare function ep_playerhitmonster(old as _cords, enemy() as _monster, lastenemy as short,mapmask() as byte) as short
declare function ep_monstermove(enemy() as _monster, m() as single, byref lastenemy as short, li() as short,byref lastlocalitem as short,spawnmask() as _cords, lsp as short,  mapmask() as byte,nightday() as byte) as short
declare function ep_items(li() as short, byref lastlocalitem as short,enemy() as _monster,lastenemy as short, localturn as short) as short
declare function ep_updatemasks(spawnmask() as _cords,mapmask() as byte,nightday() as byte, byref dawn as single, byref dawn2 as single) as short
declare function ep_tileeffects(areaeffect() as _ae, byref last_ae as short,lavapoint() as _cords, nightday() as byte, localtemp() as single,cloudmap() as byte) as short
declare function ep_landship(byref ship_landing as short,nextlanding as _cords,nextmap as _cords,vismask() as byte,enemy() as _monster,lastenemy as short) as short
declare function ep_areaeffects(areaeffect() as _ae,byref last_ae as short,lavapoint() as _cords,enemy() as _monster, lastenemy as short, li() as short,byref lastlocalitem as short,cloudmap() as byte) as short
declare function ep_atship() as short
declare function ep_planeteffect(enemy() as _monster, lastenemy as short,li() as short,byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single,lavapoint() as _cords,localturn as short,cloudmap() as byte) as short
declare function ep_jumppackjump() as short
declare function ep_inspect(enemy() as _monster, lastenemy as short, li() as short,byref  lastlocalitem as short,byref localturn as short) as short
declare function ep_launch(byref nextmap as _cords) as short
declare function ep_lava(lavapoint() as _cords) as short
declare function ep_communicateoffer(key as string, enemy() as _monster,lastenemy as short, li() as short, byref lastlocalitem as short) as short
declare function ep_spawning(enemy() as _monster,lastenemy as short,spawnmask() as _cords,lsp as short, diesize as short,nightday() as byte) as short
declare function ep_dropitem(li() as short,byref lastlocalitem as short,enemy() as _monster,byref lastenemy as short,vismask() as byte) as short
declare function ep_crater(li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single) as short
declare function ep_fireeffect(p2 as _cords,slot as short, c as short, range as short,enemy() as _monster, lastenemy as short, mapmask() as byte, first as short=0,last as short=0) as short
declare function ep_heatmap(enemy() as _monster,lastenemy as short,lavapoint() as _cords,lastlavapoint as short) as short
declare Function fuzzyMatch( Byref correct As String, Byref match As String ) As single
declare function place_shop_order(sh as short) as short
declare Function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer
declare function ep_autoexplore(slot as short,li() as short,lastlocalitem as short) as short
declare function titlemenu() as short
declare function ep_planetroute(route() as _cords,move as short,start as _cords, target as _cords,rollover as short) as short

declare function addmoney(amount as integer,mt as byte) as short
declare function count_and_makeweapons(st as short) as short

declare function income_expenses() as string

declare function teleport(awaytam as _cords, map as short) as _cords
declare function movemonster(enemy as _monster, ac as _cords, mapmask() as byte,tmap() as _tile) as _monster
declare function hitmonster(defender as _monster,attacker as _monster,mapmask() as byte, first as short=-1, last as short=-1) as _monster
declare function monsterhit(defender as _monster, attacker as _monster,vis as byte) as _monster
declare function spacecombat(atts as _fleet, ter as short) as short
declare function spacestation(st as short) as _ship
declare function buy_weapon(st as short) as short
declare function buy_engine() as short

declare function explore_space() as short
declare function explore_planet(from as _cords, orbit as short) as _cords
declare function alienbomb(c as short,slot as short, enemy() as _monster,lastenemy as short, li() as short, byref lastlocalitem as short) as short
declare function tohit_gun(a as short) as short
declare function tohit_close(a as short) as short
declare function missing_ammo() as short
declare function max_hull(s as _ship) as short
declare function change_loadout() as short

declare function grenade(from as _cords,map as short,enemy() as _monster,lastenemy as short,li() as short, lastlocalitem as short) as _cords
declare function poolandtransferweapons(s1 as _ship,s2 as _ship) as short
declare function clear_gamestate() as short
declare function planetflags_toship(m as short) as _ship
declare function can_learn_skill(ci as short,si as short) as short
declare function form_alliance(who as short) as short
declare function colonize_planet(st as short) as short
declare function get_com_colon_candidate(st as short) as short
declare function score_planet(i as short,st as short) as short
declare function score_system(s as short,st as short) as short



declare function get_highestrisk_questguy(st as short) as short
declare function questguy_newquest(i as short) as short
declare function make_questitem(i as short,wanthas as short) as short
declare function get_other_questguy(i as short,sameplace as byte=0) as short
declare function rnd_questguy_byjob(jo as short,self as short=0) as short
declare function headhunt_quest(i as short) as short

' fileIO.bas
declare function load_dialog_quests() as short
declare function character_name(byref gender as byte) as string
declare function count_lines(file as string) as short
declare function delete_custom(pir as short) as short
declare function loadkey(byval t as string) as string
declare function check_filestructure() as short
declare function load_sounds() as short
declare function load_fonts() as short
declare function save_config(oldtiles as short) as short
declare function load_config() as short
declare function background(fn as string) as short
declare function save_bones(t as short) as short
declare function load_bones() as short
declare function getbonesfile() as string
declare function configuration() as short
declare function load_map(m as short,slot as short) as short
declare function texttofile(text as string) as string
declare function load_keyset() as short
declare function load_dialog(fn as string, n() as _dialognode) as short
declare function get_biodata(e as _monster) as integer
declare function add_passenger(n as string,typ as short, price as short, bonus as short, target as short, ttime as short, gender as short) as short

declare function gen_fname(fname() as string) as short
declare function cargo_text() as string
declare function weapon_text(w as _weap) as string

declare function bunk_multi() as single
' prosIO.bas
declare function draw_border(xoffset as short) as short
declare function showteam(from as short, r as short=0,text as string="") as short
declare function gainxp(slot as short,v as short=1) as string
declare function gaintalent(slot as short) as string
declare function add_talent(cr as short, ta as short, value as single) as single
declare function remove_member(n as short, f as short) as short
declare function changemoral(value as short, where as short) as short
declare function isgardenworld(m as short) as short
declare function show_wormholemap(j as short=0) as short
declare function list_inventory() as string
declare function equipment_value() as integer

declare function keybindings(allowed as string="") as short

declare function join_fight(f as short) as short

declare function shipstatus(heading as short=0) as short
declare function display_stars(bg as short=0) as short
declare function display_star(a as short,fbg as byte=0) as short
declare function display_planetmap(a as short,xos as short,bg as byte) as short
declare function display_station(a as short) as short
declare function display_ship(show as byte=0) as short
declare function display_comstring(wl as short) as short
declare function add_stations() as short

declare function display_ship_weapons(m as short=0) as short
declare function display_system(in as short,forcebar as byte=0,hi as byte=0) as short
declare function display_awayteam(showshipandteam as byte=1,osx as short=555) as short
declare function dtile (x as short,y as short, tiles as _tile,visible as byte) as short
declare function locEOL() as _cords
declare function display_sysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
declare function nextplan(p as short,in as short) as short
declare function prevplan(p as short,in as short) as short
declare function questguy_message(c as short) as short
declare function get_invbay_bytype(t as short) as short

declare function hpdisplay(a as _monster) as short
declare function infect(a as short, dis as short) as short
declare function diseaserun(a as short) as short
declare function settactics() as short
declare function make_vismask(c as _cords,sight as short,m as short) as short
declare function vis_test(a as _cords,p as _cords,test as short) as short
declare function ap_astar(start as _cords,ende as _cords,diff as short) as short
declare function has_questguy_want(i as short,byref t as short) as short

declare function caged_monster_text() as string
declare function sell_alien(sh as short) as short
declare function skill_test(bonus as short,targetnumber as short,echo as string="") as short
declare function vege_per(slot as short) as single

declare function space_next_to_wall() as short
declare function add_ano(p1 as _cords,p2 as _cords,ano as short=0) as short
declare function makestuffstring(l as short) as string
declare function levelup(p as _ship,from as short) as _ship
declare function max_security() as short
declare function get_freecrewslot() as short
declare function add_member(a as short,skill as short) as short
declare function cureawayteam(where as short) as short
declare function healawayteam(byref a as _monster,heal as short) as short
declare function damawayteam(dam as short,ap as short=0,dis as short=0) as string
declare function dplanet(p as _planet,orbit as short, scanned as short,slot as short) as short
declare function dprint(text as string, col as short=11) as short
declare function scrollup(b as short) as short
declare function blink(byval p as _cords, osx as short) as short
declare function cursor(target as _cords,map as short, osx as short,osy as short=0,radius as short=0) as string
declare function menu(bg as byte,text as string,help as string="", x as short=2, y as short=2,blocked as short=0,markesc as short=0,st as short=-1) as short
declare function move_ship(key as string) as _ship
declare function total_bunks() as short
declare function getplanet(sys as short, forcebar as byte=0) as short
declare function get_system() as short
declare function get_random_system(unique as short=0,gascloud as short=0, disweight as short=0,hasgarden as short=0) as short
declare function getrandomplanet(s as short) as short
declare function sysfrommap(a as short)as short
declare function orbitfrommap(a as short) as short

declare function get_colony_building(map as short) as _cords
declare function grow_colony(map as short) as short
declare function isbuilding(x as short,y as short,map as short) as short
declare function closest_building(p as _cords,map as short) as _Cords
declare function grow_colonies() as short
declare function count_tiles(i as short,map as short) as short
declare function remove_building(map as short) as short
declare function count_diet(slot as short,diet as short) as short

declare function merchant() as single

declare function sort_by_distance(c as _cords,p() as _cords,l() as short,last as short) as short
declare function wormhole_navigation() as short


declare function askyn(q as string,col as short=11,sure as short=0) as short
declare function randomname() as string
declare function isgasgiant(m as short) as short
declare function countgasgiants(sys as short) as short
declare function isasteroidfield(m as short) as short
declare function countasteroidfields(sys as short) as short
declare function checkcomplex(map as short,fl as short) as integer
declare function getnumber(a as short,b as short, e as short) as short
declare function gettext(x as short, y as short, ml as short, text as string,pixel as short=0) as string
declare function getdirection(key as string) as short
declare function keyplus(key as string) as short
declare function keyminus(key as string) as short
declare function paystuff(price as integer) as integer
declare function shop(sh as short,pmod as single, shopn as string) as short
declare function mondis(enemy as _monster) as string
declare function getfilename() as string
declare function savegame()as short
declare function load_game(filename as string) as short
declare function copytile (byval a as short) as _tile
declare function refuel_f(f as _fleet, st as short) as _fleet
declare function load_font(fontdir as string,byref fh as ubyte) as ubyte ptr     
declare function load_tiles() as short
declare function make_alienship(slot as short, t as short) as short
declare function makecivfleet(slot as short) as _fleet
declare function civfleetdescription(f as _fleet) as string
declare function string_towords(word() as string, s as string, break as string, punct as short=0) as short
declare function set_fleet(fl as _fleet) as short

declare function com_vismask(c as _cords) as short
declare function com_display(defender as _ship, attacker() as _ship, marked as short, e_track_p() as _cords,e_track_v()as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_gettarget(defender as _ship, wn as short, attacker() as _ship,marked as short,e_track_p() as _cords,e_track_v() as short,e_map() as byte,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_getweapon() as short
declare function com_fire(byref target as _ship,byref attacker as _ship,byref w as _weap, gunner as short, range as short) as _ship
declare function com_sinkheat(s as _ship,manjets as short) as short
declare function com_hit(target as _ship, w as _weap,damage as short, range as short,attn as string,side as short) as _ship
declare function com_side(target as _ship,c as _cords) as short
declare function com_criticalhit(t as _ship, roll as short) as _ship
declare function com_flee(defender as _ship,attacker() as _ship) as short
declare function com_wstring(w as _weap, range as short) as string
declare function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,mines_p() as _cords,mines_last as short, echo as short=0) as short
declare function com_remove(attacker() as _ship, t as short,flag as short=0) as short
declare function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short,attacker() as _ship) as short
declare function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship) as short
declare function com_damship(byref t as _ship, dam as short, col as short) as _ship
declare function com_mindist(s as _ship) as short
declare function com_regshields(s as _ship) as short 
declare function com_shipbox(s as _ship, di as short) as string
declare function com_NPCMove(defender as _ship,attacker() as _ship,e_track_p() as _cords,e_track_v() as short,e_map() as byte,byref e_last as short) as short
declare function com_NPCFire(defender as _ship,attacker() as _ship) as short
declare function com_findtarget(defender as _ship,attacker() as _ship) as short
declare function com_evaltarget(attacker as _ship,defender as _ship) as short
declare function com_turn(dircur as byte,dirdest as byte,turnrate as byte) as short
declare function com_direction(dest as _cords,target as _cords) as short
declare function com_shipfromtarget(target as _cords,defender as _ship,attacker() as _ship) as short
declare function com_NPCfireweapon(byref defender as _ship, byref attacker as _ship,b as short) as short
declare function com_victory(attacker() as _ship) as short
declare function com_add_e_track(ship as _ship,e_track_p() as _cords,e_track_v() as short, e_map() as byte,e_last as short) as short

declare function show_standing() as short

declare function date_string() as string
declare function com_targetlist(list_c() as _cords, list_e() as short, defender as _ship, attacker() as _ship, mines_p() as _cords,mines_v() as short, mines_last as short) as short
declare function load_quest_cargo(t as short,car as short,dest as short) as short

declare function keyin(allowed as string ="", blocked as short=0)as string
declare function screenshot(a as short) as short
declare function logbook() as short
declare function auto_pilot(start as _cords, ende as _cords, diff as short) as short
declare function bioreport(slot as short) as short
declare function messages() as short
declare function storescreen(as short) as short
declare function alienname(flag as short) as string
declare function communicate(e as _monster, mapslot as short,li() as short,lastlocalitem as short,monslot as short) as short
declare function artifact(c as short) as short
'declare function getshipweapon() as short
declare function getmonster(enemy() as _monster, byref lastenemy as short) as short
declare function findartifact(v5 as short) as short
    
declare function ep_display(enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short,osx as short=555) as short
declare function earthquake(t as _tile,dam as short)as _tile
declare function ep_gives(awayteam as _monster, byref nextmap as _cords, shipfire() as _shipfire,enemy() as _monster,byref lastenemy as short,li() as short, byref lastlocalitem as short,spawnmask() as _cords,lsp as short,key as string,loctemp as single) as short
declare function numfromstr(t as string) as short
declare function explored_percentage_string() as string

'Star Map generation
declare function make_spacemap() as short
declare function make_clouds() as short
declare function add_drifters() as short
declare function add_special_planets() as short
declare function add_easy_planets(start as _cords) as short
declare function add_stars() as short
declare function add_wormholes() as short
declare function add_event_planets() as short
declare function add_caves() as short
declare function add_piratebase() as short
declare function distribute_stars() as short

declare function makefinalmap(m as short) as short
declare function makecomplex(byref enter as _cords, down as short,blocked as byte=0) as short
declare function makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short) as short
declare function makecomplex3(slot as short,cn as short, rc as short,collums as short,t as short) as short
declare function makecomplex4(slot as short,rn as short,tileset as short) as short
declare function makeplatform(slot as short,platforms as short,rooms as short,translate as short, adddoors as short=0) as short
declare function makelabyrinth(slot as short) as short
declare function invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=10, _y as short=10) as short
declare function makeroots(slot as short) as short
declare function makeplanetmap(a as short,orbit as short, spect as short) as short
declare function modsurface(a as short,o as short) as short
declare function makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short,blocked as short=1) as short
declare function togglingfilter(slot as short, high as short=1, low as short=2)  as short 
declare function make_special_planet(a as short) as short
declare function make_drifter(d as _driftingship,bg as short=0,broken as short=0, f as short=0) as short
declare function make_civilisation(slot as short, m as short) as short
declare function makeice(a as short, o as short) as short
declare function makecanyons(a as short, o as short) as short
declare function makegeyseroasis(slot as short) as short
declare function makecraters(a as short, o as short) as short
declare function makemossworld(a as short,o as short) as short
declare function makeislands(a as short, o as short) as short
declare function makeoceanworld(a as short,o as short) as short
declare function adaptmap(slot as short,enemy()as _monster,byref lastenemy as short) as short
declare function addpyramid(p as _cords,slot as short) as short
declare function floodfill4(map() as short,x as short,y as short) as short
declare function add_door(map() as short) as short
declare function add_door2(map() as short) as short
declare function remove_doors(map() as short) as short
declare function addcastle(dest as _cords,slot as short) as short


declare function makemudsshop(slot as short, x1 as short, y1 as short) as short
declare function make_eventplanet(slot as short) as short
declare function station_event(m as short) as short
declare function makewhplanet() as short
declare function makeoutpost (slot as short,x1 as short=0, y1 as short=0) as short
declare function makesettlement(p as _cords,slot as short, typ as short) as short
declare function makevault(r as _rect,slot as short,nsp as _cords, typ as short,ind as short) as short
declare function rndwallpoint(r as _rect, w as byte) as _cords
declare function rndwall(r as _rect) as short
declare function digger(byval p as _cords,map() as short,d as byte,ti as short=2,stopti as short=0) as short
declare function flood_fill(x as short,y as short,map()as short, flag as short=0) as short
declare function flood_fill2(x as short,y as short, xm as short, ym as short, map() as byte) as short
declare function findsmartest(slot as short) as short
declare function makeroad(byval s as _cords,byval e as _cords, a as short) as short
declare function addportal(from as _cords, dest as _cords, twoway as short, tile as short,desig as string, col as short) as short
declare function deleteportal(f as short=0, d as short=0) as short
declare function checkvalid(x as short,y as short, map() as short) as short
declare function floodfill3(x as short,y as short,map() as short) as short
declare function checkdoor(x as short,y as short, map() as short) as short
declare function checkbord(x as short,y as short, map() as short) as short
declare function playerfightfleet(f as short) as short
declare function is_drifter(m as short) as short
declare function is_special(m as short) as short
declare function get_nonspecialplanet(disc as short=0) as short
declare function gen_traderoutes() as short
declare function clean_station_event() as short

'pirates
declare function friendly_pirates(f as short) as short
declare function ss_sighting(i as short) as short
declare function makeweapon(a as short) as _weap
declare function make_ship(a as short) as _ship
declare function makemonster(a as short, map as short, forcearms as byte=0) as _monster
'awayteam as _monster, map as short, spawnmask() as _cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster    
declare function makecorp(a as short) as _basis
declare function collide_fleets() as short
declare function move_fleets() as short
declare function make_fleet() as _fleet
declare function makepatrol() as _fleet
declare function makemerchantfleet() as _fleet
declare function makepiratefleet(modifier as short=0) as _fleet
declare function update_targetlist()as short
declare function bestpilotinfleet(f as _fleet) as short
declare function add_fleets(target as _fleet, source as _fleet) as _fleet    
declare function piratecrunch(f as _fleet) as _fleet
declare function clearfleetlist() as short
declare function countfleet(ty as short) as short
declare function meet_fleet(f as short)as short
declare function debug_printfleet(f as _fleet) as string
declare function fleet_battle(byref red as _fleet,byref blue as _fleet) as short
declare function getship(f as _fleet) as short
declare function furthest(list() as _cords,last as short, a as _cords,b as _cords) as short

declare function makequestfleet(a as short) as _fleet
declare function makealienfleet() as _fleet
declare function setmonster(enemy as _monster,map as short,spawnmask()as _cords,lsp as short,x as short=0,y as short=0,mslot as short=0,its as short=0) as _monster    
declare function make_aliencolony(slot as short,map as short, popu as short) as short

declare function resolve_fight(f2 as short) as short
declare function decide_if_fight(f1 as short,f2 as short) as short

declare function weapon_string() as string
declare function crew_text(c as _crewmember) as string

'highscore
declare function space_mapbmp() as short


declare function explper() as short
declare function money_text() as string
declare function exploration_text() as string
declare function mission_type() as string
declare function high_score() as short
declare function post_mortem() as short
declare function post_mortemII() as short
declare function score() as integer
declare function get_death() as string

'cargotrade
declare function mudds_shop() as short
declare function girlfriends(st as short) as short
declare function pay_bonuses(st as short) as short
declare function check_passenger(st as short) as short
declare function pirateupgrade() as short
declare function customize_item() as short 
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
declare function reroll_shops() as short
declare function find_crew_type(t as short) as short
declare function used_ships() as short

declare function hiring(st as short, byref hiringpool as short, hp as short) as short
declare function sort_crew() as short
declare function shipupgrades(st as short) as short
declare function starting_turret() as _weap
declare function shipyard(where as byte) as short
declare function ship_inspection(price as short) as short

declare function buy_ship(st as short,ds as string,pr as short) as short
declare function make_weap_helptext(w as _weap) as string

declare function ship_design(where as byte) as short
declare function custom_ships(where as byte) as short
declare function repair_hull(pricemod as single=1) as short
declare function refuel(st as short,price as single) as short
declare function casino(staked as short=0, st as short=0) as short
declare function play_slot_machine() as short
declare function showprices(st as short) as short

declare function upgradehull(t as short,byref s as _ship, forced as short=0) as short
declare function gethullspecs(t as short,file as string) as _ship
declare function makehullbox(t as short, file as string) as string
declare function company(st as short) as short
declare function merctrade(byref f as _fleet) as short

declare function unload_f(f as _fleet, st as short) as _fleet
declare function unload_s(s as _ship, st as short) as _ship
declare function load_f(f as _fleet, st as short) as _fleet
declare function load_s(s as _ship,goods as short, st as short) as short
declare function trading(st as short) as short
declare function buygoods(st as short) as short
declare function sellgoods(st as short) as short
declare function recalcshipsbays() as short
declare function stockmarket(st as short) as short
declare function displaywares(st as short) as short
declare function change_prices(st as short,etime as short) as short
declare function getfreecargo() as short
declare function getnextfreebay() as short
declare function nextemptyc() as short
declare function station_goods(st as short,tb as byte) as string
declare function cargobay(text as string,st as short,sell as byte=0) as string
declare function getinvbytype(t as short) as short
declare function removeinvbytype(t as short, am as short) as short
declare function get_item_list(inv() as _items, invn()as short, ty as short=0,ty2 as short=0,ty3 as short=0,ty4 as short=0) as short
declare function display_item_list(inv() as _items, invn() as short, marked as short, l as short,x as short,y as short) as short
declare function make_localitemlist(li() as short,slot as short) as short

declare function sick_bay(st as short=0,obe as short=0) as short
declare function first_unused(i as short) as short
declare function item_assigned(i as short) as short
declare function scroll_bar(offset as short,linetot as short,lineshow as short,winhigh as short, x as short,y as short,col as short) as short

'Items
declare function check_item_filter(t as short,f as short) as short
declare function item_filter() as short
declare function equip_awayteam(m as short) as short
declare function removeequip() as short
declare function lowest_by_id(id as short) as short
declare function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
declare function makeitem(a as short,mod1 as short=0,mod2 as short=0,prefmin as short=0,nomod as byte=0) as _items
declare function modify_item(i as _items) as _items
declare function placeitem(i as _items,x as short=0,y as short=0,m as short=0,p as short=0,s as short=0) as short
declare function get_item(ty as short=0,ty2 as short=0) as short
declare function buysitems(desc as string,ques as string, ty as short, per as single=1,agrmod as short=0) as short
declare function giveitem(e as _monster,nr as short, li() as short, byref lastlocalitem as short) as short
declare function changetile(x as short,y as short,m as short,t as short) as short
declare function textbox(text as string,x as short,y as short,w as short, fg as short=11, bg as short=0,pixel as byte=0,byref op as short=0,byref offset as short=0) as short
declare function destroyitem(b as short) as short
declare function destroy_all_items_at(ty as short, wh as short) as short
declare function calc_resrev() as short
declare function count_items(i as _items) as short
declare function findworst(t as short,p as short=0, m as short=0) as short
declare function rnd_item(t as short) as _items
declare function getrnditem(fr as short,ty as short) as short
declare function better_item(i1 as _items,i2 as _items) as short
declare function list_artifacts(artflags() as short) as string
declare function gen_shops() as short

'math
declare function round_str(i as double,c as short) as string
declare function round_nr(i as single,c as short) as single
declare function C_to_F(c as single) as single
declare function find_high(list() as short,last as short, start as short=1) as short
declare function find_low(list() as short,last as short,start as short=1) as short
declare function countdeadofficers(max as short) as short
declare function nearest_base(c as _cords) as short
declare function sub0(a as single,b as single) as single
declare function disnbase(c as _cords,weight as short=2) as single
declare function dispbase(c as _cords) as single
declare function rnd_point(m as short=-1,w as short=-1, t as short=-1,vege as short=-1)as _cords
declare function rndrectwall(r as _rect,d as short=5) as _cords
declare function fillmap(map() as short,tile as short) as short
declare function fill_rect(r as _rect,t1 as short, t2 as short,map() as short) as short
declare function chksrd(p as _cords, slot as short) as short
declare function findrect(tile as short,map()as short, er as short=0, fi as short=60) as _rect
declare function content(r as _rect,tile as short,map()as short) as integer
declare function distance(first as _cords, last as _cords,rollover as byte=0) as single
declare Function rnd_range (first As short, last As short) As short
declare function movepoint(byval c as _cords, a as short, eo as short=0,showstats as short=0) as _cords
declare function pathblock(byval c as _cords,byval b as _cords,mapslot as short,blocktype as short=1,col as short=0, delay as short=100,rollover as byte=0) as short
declare function line_in_points(b as _cords,c as _cords,p() as _cords) as short

declare function nearest(byval c as _cords, byval b as _cords,rollover as byte=0) as single
declare function farthest(c as _cords,b as _cords) as single
declare function distributepoints(result() as _cords, ps() as _cords, last as short) as single
declare function getany(possible() as short)as short
declare function maximum(a as double,b as double) as double
declare function minimum(a as double,b as double) as double
declare function dominant_terrain(x as short,y as short,m as short) as short

declare function checkandadd(queue() as _pfcords,map() as byte,in as short) as short
declare function add_p(queue() as _pfcords,p as _pfcords) as short
declare function check(queue() as _pfcords, p as _pfcords) as short
declare function nearlowest(p as _pfcords,queue() as _pfcords) as _pfcords
declare function gen_waypoints(queue() as _pfcords,start as _pfcords,goal as _pfcords,map() as byte) as short
declare function space_radio() as short
'quest
declare function crew_bio(i as short) as string
declare function find_passage_quest(m as short, start as _cords, goal as _cords) as short
declare function Find_Passage(m as short, start as _cords, goal as _cords) as short
declare function adapt_nodetext(t as string, e as _monster,fl as short,qgindex as short=0) as string
declare function dodialog(no as short,e as _monster, fl as short) as short
declare function node_menu(no as short,node() as _dialognode, e as _monster, fl as short,qgindex as short=0) as short
declare function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
declare function plant_name(ti as _tile) as string
declare function randomcritterdescription(enemy as _monster, spec as short,weight as short,flies as short,byref pumod as byte,diet as byte,water as short,depth as short) as _monster
declare function give_quest(st as short) as short
declare function bounty_quest_text() as string
declare function gen_bountyquests() as short

declare function check_questcargo(st as short) as short
declare function reward_bountyquest(employer as short) as short

declare function getunusedplanet() as short
declare function dirdesc(start as _cords,goal as _cords) as string
declare function rndsentence(e as _monster) as short
declare function show_quests() as short
declare function planet_bounty() as short
declare function eris_does() as short
declare function eris_doesnt_like_your_ship() as short
declare function eris_finds_apollo() as short

declare function low_morale_message() as short
declare function es_part1() as string
declare function Crewblock() as string
declare function shipstatsblock() as string
declare function make_unflags(unflags() as byte) as short
declare function uniques(unflags() as byte) as string
declare function talk_culture(c as short) as short
declare function foreignpolicy(c as short, i as byte) as short
declare function first_lc(t as string) as string

declare function text_to_html(text as string) as string

declare function hasassets() as short
declare function sellassetts () as string
declare function es_title(byref pmoney as single) as string
declare function es_living(byref pmoney as single) as string
declare function system_text(a as short) as string
#IFDEF _WINDOWS
using ext
#ENDIF

declare function set__color(fg as short,bg as short,visible as byte=1) as short
dim shared as uinteger _fgcolor_,_bgcolor_ 
declare Function _tcol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _tcol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    dim c as uinteger
    c=color
    if src=0 then 
        return dest
    else 
        return _fgcolor_
    endif
end function

declare Function _col( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _col( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    if src=0 then 
        return _bgcolor_
    else 
        return _fgcolor_
    endif
end function

declare Function _icol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _icol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    'Itemcolor
    if src=0 then 
        return hiword(color)
    else 
        return loword(color)
    endif
end function

declare function factionadd(a as short,b as short, add as short) as short
    
#define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CUInt( c )        And 255 )

function set__color(fg as short,bg as short,visible as byte=1) as short
    dim as uinteger r,g,b
    if fg>255 or bg>255 or fg<0 or bg<0 then return 0
    if visible=1 then
        color palette_(fg),palette_(bg)
    else
        color palette_(fg)/2,palette_(bg)/2
    endif
    _fgcolor_=palette_(fg)
    _bgcolor_=palette_(bg)
    if visible=0 then
        r=RGBA_R(_fgcolor_)
        g=RGBA_G(_fgcolor_)
        b=RGBA_B(_fgcolor_)
        _fgcolor_=RGB(r/2,g/2,b/2)
        
        r=RGBA_R(_bgcolor_)
        g=RGBA_G(_bgcolor_)
        b=RGBA_B(_bgcolor_)
        _bgcolor_=RGB(r/2,g/2,b/2)
    endif
    return 0
end function

