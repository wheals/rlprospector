'
' debugging flags 0=off 1 =on
'

using FB
randomize timer

const __VERSION__="0.2.2a"

Const Show_NPCs=0'shows pirates and mercs
Const Show_specials=0 'special planets already discovered
Const show_portals=0 'Shows .... portals!
Const Show_pirates=0 'pirate system already discovered
Const make_files=0'outputs statistics to txt files
Const show_all=0
const show_items=0 'shows entire maps
const alien_scanner=0
const start_teleport=0'player has alien scanner
Const show_critters=0 
Const enable_donplanet=0 'D key on planet tirggers displayplanetmap
Const all_resources_are=0 
const show_allitems=0 
const easy_fights=0
const show_eventp=0
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
const just_run=0
const show_eq=0 'Show earthquakes
const dbshow_factionstatus=0
const lstcomit=56
const lstcomty=20 'Last common item
const laststar=90
const lastspecial=46
const _debug=0
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
const max_maps=2047
const _clearmap=0
const _testspacecombat=0
const add_tile_each_map=0
dim shared as byte _tix=24
dim shared as byte _tiy=24
dim shared _debugflag(1) as byte

dim shared as integer fmod_error
dim shared as byte _NoPB=2
dim shared as byte wormhole=8
dim shared as short countpatrol,makepat

dim shared as ushort _screenx=800
dim shared as ushort _screeny=0
dim shared as byte _teamcolor=15
dim shared as byte _shipcolor=14
dim shared as byte _chosebest=1
dim shared as byte _showspacemap=1
dim shared as byte _sound=1
dim shared as byte _diagonals=1
dim shared as byte _savescreenshots=1
dim shared as byte _startrandom=0
dim shared as byte _autosave=1
dim shared as byte _autopickup=1
dim shared as byte _hpdisplay=1
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
dim shared as byte _textlines
dim shared as byte _onbar=1
dim shared as byte _altnumber=1
dim shared as byte _customfonts=1 
dim shared as byte _transitems=0
dim shared as byte _narrowscreen=0
dim shared as byte _mwx=30
dim shared as byte gt_mwx=30
dim shared as byte _showrolls=0
dim shared as byte captainskill=-5
dim shared as byte wage=10

dim shared as byte com_cheat=0


dim shared as string*3 key_manual="?"
dim shared as string*3 key_messages="m"
dim shared as string*3 key_screenshot="*"
dim shared as string*3 key_configuration="="
dim shared as string*3 key_autoinspect="I"
dim shared as string*3 key_autopickup="P"
dim shared as string*3 key_shipstatus="@"
dim shared as string*3 key_equipment="E"
dim shared as string*3 key_tactics="T"
dim shared as string*3 key_awayteam="A"
dim shared as string*3 key_quests="Q"
dim shared as string*3 key_tow="t"

dim shared as string*3 key_la="l"
dim shared as string*3 key_tala="k"
dim shared as string*3 key_sc="s"
dim shared as string*3 key_save="s"
dim shared as string*3 key_quit="q"
dim shared as string*3 key_D="D"
dim shared as string*3 key_G="G"
dim shared as string*3 key_report="R"
dim shared as string*3 key_rename="r"
dim shared as string*3 key_dock="d"
dim shared as string*3 key_comment="c"
dim shared as string*3 key_probe="p"

dim shared as string*3 key_i="i"
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
dim shared as string*3 key_drop="d"
dim shared as string*3 key_oxy="O"
dim shared as string*3 key_close="C"

dim shared as string*3 key_sh="s"
dim shared as string*3 key_ac="a"
dim shared as string*3 key_ru="r"
dim shared as string*3 key_dr="d"

dim shared as string*3 key_nw="7"
dim shared as string*3 key_north="8"
dim shared as string*3 key_ne="9"
dim shared as string*3 key_west="4"
dim shared as string*3 key_east="6"
dim shared as string*3 key_sw="3"
dim shared as string*3 key_south="2"
dim shared as string*3 key_se="3"
dim shared as string*3 key_wait="5"
dim shared as string*3 key_layfire="0"
dim shared as string*3 key_portal="<"
dim shared as string*3 key_logbook="L"
dim shared as string*3 key_togglehpdisplay="#h"
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
dim shared uid as uinteger

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
    id as short 
    ti_no as uinteger
    uid as uinteger
    w as _cords
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
    vt as _cords'rover target
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
    heat as byte
    heatadd as byte
    heatsink as byte
    oldloadout as byte
    loadout as byte
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

type _ship
    c as _cords
    map as short
    osx as short
    osy as short
    lastpirate as _cords
    landed as _cords
    turn as integer
    money as integer
    desig as string *24
    icon as string *1
    ti_no as uinteger
    di as byte
    sensors as short
    pilot as short
    gunner as short
    science as short
    doctor as short
    security as short
    disease as byte
    engine as short
    manjets as short
    weapons(25) as _weap    
    hull as short
    hulltype as short
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
    addhull as short
    shieldedcargo as short
    dead as short
    killedby as string*64
    shiptype as short
    target as _cords
    ECM as byte
    stuff(5) as single
    cargo(25) as _cords
    piratekills as uinteger
    tradingmoney as integer
    lastvisit as _visit
    cryo as short
    alienkills as uinteger
    deadredshirts as uinteger
    score as uinteger
    questflag(31) as short
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
    no as ubyte
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
    track as short
    range as short
    weapon as short
    armor as short
    respawns as byte
    breedson as byte
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
    flavortext as string*512
    comment as string*60
    mapstat as byte
end type

type _ae
    c as _cords
    rad as byte
    dam as byte
    dur as byte
    typ as byte
end type

type _planetsave
    awayteam as _monster
    enemy(129) as _monster
    lastenemy as short
    lastlocalitem as short
    ship as _cords
    map as short
end type

type _fleet
    ty as short 'Type: 1=patrol 2=merchant 3=pirate
    c as _cords'Coordinates
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
    c as _cords
    discovered as short
    inv(8) as _goods
    'different companys for each station
    repname as string*32
    company as byte
    spy as byte
    mapmod as single
    biomod as single
    resmod as single
    pirmod as single
    lastsighting as short
    lastsightingdis as short
    lastsightingturn as short
    lastattacked as short
end type

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
'  As Uinteger Ptr Palette   '/* Current RGB color values for each palette index */
'  As Uinteger Ptr device_palette   '/* Current RGB color values of visible device palette */
'  As Byte Ptr color_association   '/* Palette color index associations for CGA/EGA emulation */
'  As Byte Ptr dirty               '/* Dirty lines buffer */
'  As Any Ptr driver      '/* Gfx driver in use */
'  As Integer w
'  As Integer h         '/* Current mode width and height */
'  As Integer depth      '/* Current mode depth */
'  As Integer color_mask      '/* Color bit mask for colordepth emulation */
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

dim shared mouse as _cords
dim shared apwaypoints(1024) as _cords
dim shared lastapwp as short
dim shared currapwp as short

dim shared talent_desig(29) as string
dim shared evkey as EVENT
dim shared reward(9) as single
dim shared ano_money as short

dim shared baseprice(8) as short
dim shared avgprice(8) as single

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
dim shared map(laststar+wormhole+1) as _stars
dim shared basis(12) as _station
dim shared companystats(4) as _company
dim shared companyname(4) as string
dim shared shares(2048) as _share
dim shared lastshare as short
dim shared spacemap(sm_x,sm_y) as short
dim shared combatmap(60,20) as byte
dim shared planetmap(60,20,max_maps) as short
dim shared planets(max_maps) as _planet
dim shared civ(3) as _civilisation
dim shared retirementassets(16) as ubyte
for a=0 to max_maps
    planets(a).darkness=5
next
dim shared item(25000) as _items
dim shared lastitem as integer
dim shared _last_title_pic as byte=11
dim shared shopitem(20,23) as _items
dim shared makew(20,5) as byte

dim shared tiles(512) as _tile
dim shared gtiles(2048) as any ptr
dim shared stiles(9,64) as any ptr
dim shared gt_no(4096) as integer
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
dim shared portal(255) as _transfer
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
dim as _cords p1,p2,p3
dim shared pwa(128) as _cords'Points working array
dim dummy as _monster
dim dummycords as _cords
dim text as string
dim as short astcou,gascou,pl
dim shared spectralshrt(9) as string
dim shared tacdes(5) as string
dim shared shop_order(2) as short

dim shared lastprobe as short
dim shared probe(100) as _cords 'm=Item,

dim shared as FB.IMAGE ptr TITLEFONT
dim shared as any ptr FONT1,FONT2
dim shared as ubyte _FH1,_FH2,_FW1,_FW2,_fohi1,_fohi2

dim shared endstory as string

dim shared combon(9) as _company_bonus

' SUB DECLARATION

' prospector .bas
declare function startnewgame() as short
declare function fromsavegame(key as string) as string
declare function wormhole_ani(target as _cords) as short
declare function targetlanding(mapslot as short,test as short=0) as short
declare function landing(mapslot as short,lx as short=0,ly as short=0, test as short=0) as short
declare function scanning() as short
declare function rescue() as short
declare function asteroidmining(slot as short) as short
declare function gasgiantfueling(t as short,orbit as short,sys as short) as short
declare function driftingship(a as short) as short
declare function moverover(pl as short) as short
declare function rnd_crewmember(onship as short=0) as short
declare function alerts(awayteam as _monster,walking as short) as short
declare function launch_probe() as short
declare function move_probes() as short
declare function retirement() as short


declare function show_dotmap(x1 as short, y1 as short) as short
declare function show_minimap(xx as short,yy as short) as short
declare function lb_filter(lobk() as string, lobn() as short, lobc() as short,lobp() as _Cords ,last as short) as short

declare function calcosx(x as short) as short

declare function ep_portal(awayteam as _monster,byref walking as short) as _cords
declare function ep_pickupitem(key as string, awayteam as _monster,byref lastlocalitem as short,li() as short) as short
declare function ep_shipfire(shipfire() as _shipfire,vismask() as byte,enemy() as _monster,byref lastenemy as short, byref awayteam as _monster) as short
declare function ep_checkmove(byref awayteam as _monster,byref old as _cords,key as string,byref walking as short) as short
declare function ep_examine(awayteam as _monster,ship as _cords,vismask() as byte, li() as short,enemy() as _monster,lastenemy as short,lastlocalitem as short, byref walking as short) as short
declare function ep_helmet(awayteam as _monster) as short
declare function ep_closedoor(awateam as _monster) as short
declare function ep_radio(awayteam as _monster,byref ship as _cords, byref nextlanding as _cords,byref ship_landing as short, li() as short,lastlocalitem as short,enemy() as _monster,lastenemy as short,shipfire() as _shipfire,lavapoint() as _cords, byref sf as single) as short
declare function ep_grenade(awayteam as _monster, shipfire() as _shipfire, byref sf as single,li() as short ,byref lastlocalitem as short) as short
declare function ep_fire(awayteam as _monster, enemy() as _monster,lastenemy as short,vismask() as byte,mapmask() as byte,byref walking as short,key as string,byref autofire_target as _cords) as short
declare function ep_playerhitmonster(awayteam as _monster,old as _cords, enemy() as _monster, lastenemy as short,vismask() as byte,mapmask() as byte) as short
declare function ep_monstermove(awayteam as _monster, enemy() as _monster, m() as single, byref lastenemy as short, li() as short,byref lastlocalitem as short,spawnmask() as _cords, lsp as short, vismask() as byte, mapmask() as byte,nightday() as byte, byref walking as short) as short
declare function ep_items(awayteam as _monster, li() as short, byref lastlocalitem as short,enemy() as _monster,lastenemy as short, localturn as short,vismask()as byte) as short
declare function ep_updatemasks(spawnmask() as _cords,mapmask() as byte,nightday() as byte, byref dawn as single, byref dawn2 as single) as short
declare function ep_tileeffects(awayteam as _monster,areaeffect() as _ae, byref last_ae as short,lavapoint() as _cords, nightday() as byte, localtemp() as single,vismask() as byte) as short
declare function ep_landship(byref ship_landing as short,nextlanding as _cords,ship as _cords,nextmap as _cords,vismask() as byte,enemy() as _monster,lastenemy as short) as short
declare function ep_areaeffects(awayteam as _monster,areaeffect() as _ae,byref last_ae as short,lavapoint() as _cords,enemy() as _monster, lastenemy as short, li() as short,byref lastlocalitem as short) as short
declare function ep_atship(awayteam as _monster,ship as _cords,walking as short) as short
declare function ep_planeteffect(awayteam as _monster, ship as _cords, enemy() as _monster, lastenemy as short,li() as short,byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single,lavapoint() as _cords,vismask() as byte,localturn as short) as short
declare function ep_jumppackjump(awayteam as _monster) as short
declare function ep_inspect(awayteam as _monster,byref ship as _cords, enemy() as _monster, lastenemy as short, li() as short,byref  lastlocalitem as short,byref localturn as short,byref walking as short) as short
declare function ep_launch(awayteam as _monster, byref ship as _cords,byref nextmap as _cords) as short
declare function ep_lava(awayteam as _monster,lavapoint() as _cords,ship as _cords, vismask() as byte, byref walking as short) as short
declare function ep_communicateoffer(key as string, awayteam as _monster,enemy() as _monster,lastenemy as short, li() as short, byref lastlocalitem as short) as short
declare function ep_spawning(enemy() as _monster,lastenemy as short,spawnmask() as _cords,lsp as short, diesize as short,vismask() as byte) as short
declare function ep_dropitem(awayteam as _monster, li() as short,byref lastlocalitem as short) as short
declare function ep_crater(slot as short,ship as _cords,awayteam as _monster,li() as short, byref lastlocalitem as short,shipfire() as _shipfire, byref sf as single) as short
declare function ep_fireeffect(p2 as _cords,slot as short, c as short, range as short,enemy() as _monster, lastenemy as short, awayteam as _monster, mapmask() as byte, first as short=0,last as short=0) as short
declare function ep_heatmap(awayteam as _monster, enemy() as _monster,lastenemy as short,lavapoint() as _cords,lastlavapoint as short) as short
declare Function fuzzyMatch( Byref correct As String, Byref match As String ) As single
declare function place_shop_order(sh as short) as short
declare Function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer

declare function titlemenu() as short

declare function teleport(awaytam as _cords, map as short) as _cords
declare function movemonster(enemy as _monster, ac as _cords, mapmask() as byte,tmap() as _tile) as _monster
declare function hitmonster(defender as _monster,attacker as _monster,mapmask() as byte, first as short=-1, last as short=-1) as _monster
declare function monsterhit(defender as _monster, attacker as _monster) as _monster
declare function spacecombat(defender as _ship,atts as _fleet, ter as short) as _ship
declare function spacestation(st as short) as _ship
declare function buyweapon(st as short) as _ship
declare function explore_space() as short
declare function explore_planet(awayteam as _monster, from as _cords, orbit as short) as _cords
declare function alienbomb(awayteam as _monster,c as short,slot as short, enemy() as _monster,lastenemy as short, li() as short, byref lastlocalitem as short) as short

declare function grenade(from as _cords,map as short) as _cords
declare function poolandtransferweapons(s1 as _ship,s2 as _ship) as short
declare function clear_gamestate() as short
declare function planetflags_toship(m as short) as _ship

' fileIO.bas
declare function count_lines(file as string) as short
declare function delete_custom(pir as short) as short
declare function loadkey(byval t as string) as string
declare function checkfilestructure() as short
declare function loadsounds() as short
declare function loadfonts() as short
declare function saveconfig(oldtiles as short) as short
declare function loadconfig() as short
declare function background(fn as string) as short
declare function savebones(ship as _cords, team as _cords,t as short) as short
declare function loadbones() as short
declare function getbonesfile() as string
declare function configuration() as short
declare function loadmap(m as short,slot as short) as short
declare function texttofile(text as string) as string
declare function loadkeyset() as short
declare function load_dialog(fn as string, n() as _dialognode) as short

' prosIO.bas
declare function draw_border(xoffset as short) as short
declare function skillcheck(targetnumber as short,skill as short, modifier as short) as short
declare function showteam(from as short, r as short=0,text as string="") as short
declare function gainxp(slot as short) as short
declare function gaintalent(slot as short) as string
declare function addtalent(cr as short, ta as short, value as single) as single
declare function removemember(n as short, f as short) as short
declare function changemoral(value as short, where as short) as short
declare function isgardenworld(m as short) as short

declare function show_wormholemap(j as short=0) as short

declare function keybindings() as short

declare sub shipstatus(heading as short=0)
declare sub show_stars(bg as short=0,byref walking as short)
declare sub displaystar(a as short)
declare function displayplanetmap(a as short,xos as short) as short
declare sub displaystation(a as short)
declare sub displayship(show as byte=0)
declare function display_ship_weapons(m as short=0) as short
declare sub displaysystem(in as short,forcebar as byte=0,hi as byte=0)
declare sub displayawayteam(awayteam as _monster, map as short, lastenemy as short, deadcounter as short, ship as _cords,loctime as short)
declare sub dtile (x as short,y as short, tiles as _tile,bgcol as short=0)
declare function locEOL() as _cords
declare function drawsysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
declare function nextplan(p as short,in as short) as short
declare function prevplan(p as short,in as short) as short

declare function hpdisplay(a as _monster) as short
declare function infect(a as short, dis as short) as short
declare function diseaserun(a as short) as short
declare function settactics() as short
declare function makevismask(vismask()as byte,byval a as _monster,m as short) as short
declare function vis_test(a as _cords,p as _cords,test as short) as short

declare function makestuffstring(l as short) as string
declare function levelup(p as _ship) as _ship
declare function maxsecurity() as short
declare function get_freecrewslot() as short
declare function addmember(a as short) as short
declare function cureawayteam(where as short) as short
declare function healawayteam(byref a as _monster,heal as short) as short
declare function damawayteam(byref a as _monster,dam as short,ap as short=0,dis as short=0) as string
declare function dplanet(p as _planet,orbit as short, scanned as short) as short
declare function dprint(text as string, col as short=11) as short
declare function scrollup(b as short) as short
declare function blink(byval p as _cords, osx as short) as short
declare function cursor(target as _cords,map as short, osx as short) as string
declare function menu(text as string,help as string="", x as short=2, y as short=2,blocked as short=0,markesc as short=0) as short
declare function move_ship(key as string,byref walking as short) as _ship

declare function getplanet(sys as short, forcebar as byte=0) as short
declare function getsystem(player as _ship) as short
declare function getrandomsystem(unique as short=1) as short
declare function getrandomplanet(s as short) as short
declare function sysfrommap(a as short)as short
declare function orbitfrommap(a as short) as short

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
declare function load_font(fontdir as string,byref fh as ubyte) as ubyte ptr     
declare function load_tiles() as short
declare function make_alienship(slot as short, t as short) as short
declare function makecivfleet(slot as short) as _fleet
declare function civfleetdescription(f as _fleet) as string
declare function string_towords(word() as string, s as string, break as string, punct as short=0) as short
declare function com_display(defender as _ship, attacker() as _ship, lastenemy as short, marked as short, senac as short,e_track_p() as _cords,e_track_v()as short,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_gettarget(defender as _ship, wn as short, attacker() as _ship,lastenemy as short,senac as short,marked as short,e_track_p() as _cords,e_track_v() as short,e_last as short,mines_p() as _cords,mines_v() as short,mines_last as short) as short
declare function com_getweapon() as short
declare function com_fire(target as _ship,attacker as _ship,byref w as _weap, gunner as short, range as short, senac as short) as _ship
declare function com_sinkheat(s as _ship,manjets as short) as short
declare function com_hit(target as _ship, w as _weap,dambonus as short, range as short, senac as short) as _ship
declare function com_criticalhit(t as _ship, roll as short) as _ship
declare function com_flee(defender as _ship,attacker() as _ship,lastenemy as short) as short
declare function com_wstring(w as _weap, range as short) as string
declare function com_testweap(w as _weap, p1 as _cords,attacker() as _ship,lastenemy as short,mines_p() as _cords,mines_last as short) as short
declare function com_remove(attacker() as _ship, t as short, lastenemy as short) as short
declare function com_dropmine(defender as _ship,mines_p() as _cords,mines_v() as short,byref mines_last as short) as short
declare function com_detonatemine(d as short,mines_p() as _cords, mines_v() as short, byref mines_last as short, defender as _ship, attacker() as _ship, byref lastenemy as short) as short
declare function com_damship(byref t as _ship, dam as short, col as short) as _ship
declare function com_mindist(s as _ship) as short
declare function com_regshields(s as _ship) as short 
declare function com_shipbox(s as _ship, di as short) as string

declare function chr850(c as short) as string
declare function keyin(allowed as string ="", byref walking as short=0,blocked as short=0)as string
declare function screenshot(a as short) as short
declare function logbook(byref walking as short) as short
declare function auto_pilot(start as _cords, ende as _cords, diff as short,byref walking as short) as short
declare function bioreport(slot as short) as short
declare function messages() as short
declare function storescreen(as short) as short
declare function alienname(flag as short) as string
declare function communicate(awayteam as _monster, e as _monster, mapslot as short,li() as short,lastlocalitem as short,monslot as short) as short
declare function artifact(c as short,awayteam as _monster) as short
'declare function getshipweapon() as short
declare function getmonster(enemy() as _monster, byref lastenemy as short) as short
declare function findartifact(awayteam as _monster,v5 as short) as short
    
declare function ep_display(awayteam as _monster, vismask()as byte, enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short, byref walking as short) as short
declare function earthquake(t as _tile,dam as short)as _tile
declare function ep_gives(awayteam as _monster,vismask() as byte, byref nextmap as _cords, shipfire() as _shipfire,enemy() as _monster,byref lastenemy as short,li() as short, byref lastlocalitem as short,spawnmask() as _cords,lsp as short,key as string,byref walking as short, byref ship as _cords) as short
declare function numfromstr(t as string) as short

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

declare sub makefinalmap(m as short)
declare sub makecomplex(byref enter as _cords, down as short,blocked as byte=0)
declare sub makecomplex2(slot as short,gc1 as _cords, gc2 as _cords, roundedcorners1 as short,roundedcorners2 as short,nocol1 as short,nocol2 as short,doorchance as short,loopchance as short,loopdoor as short,adddoor as short,addloop as short,nosmallrooms as short,culdesacruns as short, t as short)
declare sub makecomplex3(slot as short,cn as short, rc as short,collums as short,t as short)
declare sub makecomplex4(slot as short,rn as short,tileset as short)
declare sub makeplatform(slot as short,platforms as short,rooms as short,translate as short, adddoors as short=0)
declare sub makelabyrinth(slot as short)
declare sub invisiblelabyrinth(tmap() as _tile,xoff as short ,yoff as short, _x as short=10, _y as short=10)
declare sub makeroots(slot as short)
declare sub makeplanetmap(a as short,orbit as short, spect as short)
declare function modsurface(a as short,o as short) as short
declare sub makecavemap(enter as _cords,tumod as short,dimod as short, spemap as short, froti as short,blocked as short=1)
declare sub togglingfilter(slot as short, high as short=1, low as short=2)  
declare function makespecialplanet(a as short) as short
declare function makedrifter(d as _driftingship,bg as short=0,broken as short=0) as short
declare function make_civilisation(slot as short, m as short) as short
declare function makeice(a as short, o as short) as short
declare sub makecanyons(a as short, o as short)
declare function makegeyseroasis(slot as short) as short
declare sub makecraters(a as short, o as short)
declare sub makemossworld(a as short,o as short)
declare sub makeislands(a as short, o as short)
declare sub makeoceanworld(a as short,o as short)
declare function adaptmap(slot as short,enemy()as _monster,byref lastenemy as short) as short
declare function addpyramid(p as _cords,slot as short) as short
declare function floodfill4(map() as short,x as short,y as short) as short
declare function add_door(map() as short) as short
declare function add_door2(map() as short) as short
declare function remove_doors(map() as short) as short
declare function addcastle(dest as _cords,slot as short) as short


declare sub makemudsshop(slot as short, x1 as short, y1 as short) 
declare sub planet_event(slot as short)
declare function station_event(m as short) as short
declare function makewhplanet() as short
declare sub makeoutpost (slot as short,x1 as short=0, y1 as short=0)
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

declare function ss_sighting(i as short) as short
declare function makeweapon(a as short) as _weap
declare function makeship(a as short) as _ship
declare function makemonster(a as short, map as short, forcearms as byte=0) as _monster
'awayteam as _monster, map as short, spawnmask() as _cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster    
declare function makecorp(a as short) as _station
declare function collidefleets() as short
declare function movefleets() as short
declare function makefleet(f as _fleet) as _fleet
declare function makepatrol() as _fleet
declare function makemerchantfleet() as _fleet
declare function makepiratefleet(modifier as short=0) as _fleet
declare function updatetargetlist()as short
declare function bestpilotinfleet(f as _fleet) as short
declare function addfleets(target as _fleet, source as _fleet) as _fleet    
declare function piratecrunch(f as _fleet) as _fleet
declare function clearfleetlist() as short
declare function countfleet(ty as short) as short
declare function meetfleet(f as short)as short
declare function debug_printfleet(f as _fleet) as string
declare function fleetbattle(red as _fleet,blue as _fleet,a as short,b as short) as short
declare function getship(f as _fleet) as short

declare function makequestfleet(a as short) as _fleet
declare function makealienfleet() as _fleet
declare function setmonster(enemy as _monster,map as short,spawnmask()as _cords,lsp as short,vismask() as byte ,x as short=0,y as short=0,mslot as short=0,its as short=0) as _monster    
declare function make_aliencolony(slot as short,map as short, popu as short) as short



'highscore
declare function mercper() as short
declare function explper() as short
declare function moneytext() as string
declare function explorationtext() as string
declare function missiontype() as string
declare sub highsc()
declare sub postmortem
declare function score() as integer
declare function getdeath() as string

'cargotrade
declare function pay_bonuses(st as short) as short
declare function checkpassenger(st as short) as short
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
declare function rerollshops() as short
declare function hiring(st as short, byref hiringpool as short, hp as short) as short
declare function shipupgrades(st as short) as short
declare function shipyard(pir as short=1) as short
declare function ship_design(pir as short) as short
declare function custom_ships(pir as short) as short
declare function repairhull() as short
declare function refuel(price as short=1) as short
declare function casino(staked as short=0, st as short=0) as short
declare function upgradehull(t as short,byref s as _ship, forced as short=0) as short
declare function gethullspecs(t as short,file as string) as _ship
declare function makehullbox(t as short, file as string) as string
declare function company(st as short,byref questroll as short) as short
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
declare function changeprices(st as short,etime as short) as short
declare function getfreecargo() as short
declare function getnextfreebay() as short
declare function nextemptyc() as short
declare function stationgoods(st as short) as string
declare function cargobay(st as short) as string
declare function getinvbytype(t as short) as short
declare function removeinvbytype(t as short, am as short) as short
declare function getitemlist(inv() as _items, invn()as short, ty as short=0) as short
declare function sickbay(st as short=0) as short

'Items
declare function checkitemfilter(t as short,f as short) as short
declare function itemfilter() as short
declare function equip_awayteam(player as _ship,awayteam as _monster, m as short) as short
declare function removeequip() as short
declare function lowest_by_id(id as short) as short
declare function findbest(t as short,p as short=0, m as short=0,id as short=0) as short
declare function makeitem(a as short,mod1 as short=0,mod2 as short=0,prefmin as short=0) as _items
declare function modify_item(i as _items) as _items
declare function placeitem(i as _items,x as short=0,y as short=0,m as short=0,p as short=0,s as short=0) as short
declare function getitem(fr as short=999,ty as short=999,forceselect as byte=0,ty2 as short=0) as short
declare function buysitems(desc as string,ques as string, ty as short, per as single=1,agrmod as short=0) as short
declare function giveitem(e as _monster,nr as short, li() as short, byref lastlocalitem as short) as short
declare function changetile(x as short,y as short,m as short,t as short) as short
declare function textbox(text as string,x as short,y as short,w as short, fg as short=11, bg as short=0) as short
declare function destroyitem(b as short) as short
declare function destroy_all_items_at(ty as short, wh as short) as short
declare function calc_resrev() as short
declare function count_by_id(id as short) as short
declare function findworst(t as short,p as short=0, m as short=0) as short
declare function rnd_item(t as short) as _items
declare function getrnditem(fr as short,ty as short) as short
declare function better_item(i1 as _items,i2 as _items) as short
declare function listartifacts() as string

'math
declare function find_high(list() as short,last as short) as short
declare function countdeadofficers(max as short) as short
declare function nearestbase(c as _cords) as short
declare function sub0(a as single,b as single) as single
declare function disnbase(c as _cords) as single
declare function dispbase(c as _cords) as single
declare function rnd_point(m as short=0,w as short=0, t as short=0)as _cords
declare function rndrectwall(r as _rect,d as short=5) as _cords
declare function fillmap(map() as short,tile as short) as short
declare function fill_rect(r as _rect,t1 as short, t2 as short,map() as short) as short
declare function chksrd(p as _cords, slot as short) as short
declare function findrect(tile as short,map()as short, er as short=0, fi as short=60) as _rect
declare function content(r as _rect,tile as short,map()as short) as integer
declare function distance(first as _cords, last as _cords) as single
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

declare function find_passage_quest(m as short, start as _cords, goal as _cords) as short
declare function Find_Passage(m as short, start as _cords, goal as _cords) as short
declare function adapt_nodetext(t as string, e as _monster,fl as short) as string
declare function dodialog(no as short,e as _monster, fl as short) as short
declare function node_menu(no as short,node() as _dialognode, e as _monster, fl as short) as short
declare function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
declare function plantname(ti as _tile) as string
declare function randomcritterdescription(enemy as _monster, spec as short,weight as short,flies as short,byref pumod as byte,diet as byte,water as short,depth as short) as _monster
declare function givequest(st as short, byref questroll as short) as short
declare function checkquestcargo(player as _ship, st as short) as _ship
declare function getunusedplanet() as short
declare function dirdesc(start as _cords,goal as _cords) as string
declare function rndsentence(e as _monster) as short
declare function showquests() as short
declare function planetbounty() as short
declare function eris_does() as short
declare function eris_doesnt_like_your_ship() as short
declare function eris_finds_apollo() as short

declare function low_morale_message() as short
declare function es_part1() as string
declare function Crewblock() as string
declare function shipstatsblock() as string
declare function uniques() as string
declare function talk_culture(c as short) as short
declare function foreignpolicy(c as short, i as byte) as short

declare function hasassets() as short
declare function sellassetts () as string
declare function es_title(byref pmoney as single) as string
declare function es_living(byref pmoney as single) as string

#IFDEF _WINDOWS
using ext
#ENDIF

declare Function _tcol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _tcol( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    dim c as uinteger
    c=color
    if src=0 then 
        return dest
    else 
        return loword(c)
    endif
end function

declare Function _col( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _col( ByVal src As UInteger, byVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    if src=0 then 
        return hiword(color)
    else 
        return loword(color)
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
    
