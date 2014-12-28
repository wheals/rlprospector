'
' debugging flags 0=off 1 =on
'

Using FB
Using cards

Randomize Timer

#Include "version.bas"
dim shared as string*5 __lastsavegamechange__="R 197" 'Do not forget to change this when savegames are changed! 

Const c_red=12
Const c_gre=10
Const c_yel=14

Const st_veryeasy=8
Const st_easy=11
Const st_average=14
Const st_hard=17
Const st_veryhard=20

Const show_energy=0

Const show_dangerous=0
Const Show_NPCs=0'shows pirates and mercs
Const Show_specials=0'27'13''1'12''5'38 'special planets already discovered
Const Show_all_specials=0'013'0'1'12'13'5'38 'special planets already discovered
Const show_portals=0 'Shows .... portals!
Const Show_pirates=0 'pirate system already discovered
Const make_files=0'outputs statistics to txt files
Const show_all=0
Const show_space=0
Const show_items=0 'shows entire maps
Const alien_scanner=0
Const start_teleport=0'player has alien scanner
Const show_critters=0
Const enable_donplanet=0 'D key on planet triggers displayplanetmap
Const all_resources_are=0
Const show_allitems=0
Const easy_fights=0
Const show_eventp=0 'Show eventplanets
Const show_mapnr=0
Const show_enemyships=0
Const show_mnr=0
Const show_wormholes=0
Const rev_map=0
Const no_enemys=0
Const more_mets=0
Const show_civs=0
Const toggling_filter=0
Const fuel_usage=0
Const run_until=0
Dim Shared As Short just_run
Const show_eq=0 'Show earthquakes
Const dbshow_factionstatus=0
Const lstcomit=56
Const lstcomty=20 'Last common item
Const lastspecial=46
Const _debug_bones=0
Const _test_disease=0
Const addpyramids=0
Const com_log=0
Const startingmoney=500
Const _spawnoff=0
Const show_moral=0
Const makemoodlog=0
Const xk=Chr(255)
Const key__up = xk & "H"
Const key__dn = xk & "P"
Const key__rt= xk & "M"
Const key__lt = xk & "K"
Const key__esc = Chr(27)
Const key__enter = Chr(13)
Const key__space = Chr(32)
Const lastflag=20
Const max_maps=4096
Const _clearmap=0
Const _testspacecombat=0
Const add_tile_each_map=0
Const lastquestguy=15

dim shared as ubyte laststar=90
Dim Shared As UByte sm_x=75
Dim Shared As UByte sm_y=50
Dim Shared As ubyte wormhole=8

'PNG Stuff
Declare Function savepng( _
ByRef filename As String = "screenshot.png", _
ByVal image As Any Ptr = 0, _
ByVal save_alpha As Integer = 0) As Integer

Const PNG_HEADER As String = !"\137PNG\r\n\26\n"
Const IHDR_CRC0 As UInteger = &ha8a1ae0a 'crc32(0, @"IHDR", 4)
Const PLTE_CRC0 As UInteger = &h4ba88955 'crc32(0, @"PLTE", 4)
Const IDAT_CRC0 As UInteger = &h35af061e 'crc32(0, @"IDAT", 4)
Const IEND_CRC0 As UInteger = &hae426082 'crc32(0, @"IEND", 4)

Type struct_ihdr Field = 1
    Width As UInteger
    height As UInteger
    bitdepth As UByte
    colortype As UByte
    compression As UByte
    filter As UByte
    interlace As UByte
End Type
Const IHDR_SIZE As UInteger = Sizeof( struct_ihdr )

'Done with png stuff
Dim Shared As Byte someonemoved
Dim Shared As Byte _tix=24
Dim Shared As Byte _tiy=24
Dim Shared _debugflag(1) As Byte
Dim Shared As Byte debugvacuum=0
Dim Shared As Integer fmod_error
Dim Shared As Byte _NoPB=2
Dim Shared As Short countpatrol,makepat,unattendedtribbles

Dim Shared As UShort _screenx=800
Dim Shared As UShort _screeny=0
Dim Shared As Byte _teamcolor=15
Dim Shared As Byte _shipcolor=14
Dim Shared As Byte _showspacemap=1

Dim Shared As Byte _hpdisplay=1


Dim Shared As Byte _autoinspect=1
dim shared species(12) as string
Dim Shared As Byte _volume=2
Dim Shared As Byte _resolution=2
Dim Shared As Byte _lines=25
Dim Shared As Byte _textlines
Dim Shared As Byte _narrowscreen=0
Dim Shared As Byte _mwx=30
Dim Shared As Byte gt_mwx=40
Dim Shared As Byte _showrolls=0
Dim Shared As Byte captainskill=-5
Dim Shared As Byte wage=10

Dim Shared As Byte com_cheat=0
Dim Shared As Short sidebar
Dim Shared As String*3 key_testspacecombat="\Cy"
Dim Shared As String*3 key_manual="?"
Dim Shared As String*3 key_messages="m"
Dim Shared As String*3 key_configuration="="
Dim Shared As String*3 key_autoinspect="I"
Dim Shared As String*3 key_autopickup="P"
Dim Shared As String*3 key_shipstatus="@"
Dim Shared As String*3 key_equipment="E"
Dim Shared As String*3 key_tactics="T"
Dim Shared As String*3 key_awayteam="A"
Dim Shared As String*3 key_quest="Q"
Dim Shared As String*3 key_tow="t"
Dim Shared As String*3 key_autoexplore="#"
Dim Shared As String*3 key_standing="\Cs"

Dim Shared As String*3 key_la="l"
Dim Shared As String*3 key_tala="\Cl"
Dim Shared As String*3 key_sc="s"
Dim Shared As String*3 key_save="S"
Dim Shared As String*3 key_quit="q"
'dim shared as string*3 key_D="D"
'dim shared as string*3 key_G="G"
Dim Shared As String*3 key_report="R"
Dim Shared As String*3 key_rename="C\r"
Dim Shared As String*3 key_dock="d"
Dim Shared As String*3 key_comment="c"
Dim Shared As String*3 key_dropshield="s"
Dim Shared As String*3 key_inspect="i"
Dim Shared As String*3 key_ex="x"
Dim Shared As String*3 key_ra="r"
Dim Shared As String*3 key_te="t"
Dim Shared As String*3 key_ju="j"
Dim Shared As String*3 key_co="c"
Dim Shared As String*3 key_of="o"
Dim Shared As String*3 key_gr="g"
Dim Shared As String*3 key_fi="f"
Dim Shared As String*3 key_autofire="F"
Dim Shared As String*3 key_he="h"
Dim Shared As String*3 key_walk="w"
Dim Shared As String*3 key_pickup=","
Dim Shared As String*3 key_drop="D"
Dim Shared As String*3 key_oxy="O"
Dim Shared As String*3 key_close="C"
Dim Shared As Byte _autopickup
Dim Shared As String*3 key_ac="a"
Dim Shared As String*3 key_ru="R"

Dim Shared As String*3 key_nw="7"
Dim Shared As String*3 key_north="8"
Dim Shared As String*3 key_ne="9"
Dim Shared As String*3 key_west="4"
Dim Shared As String*3 key_east="6"
Dim Shared As String*3 key_sw="1"
Dim Shared As String*3 key_south="2"
Dim Shared As String*3 key_se="3"
Dim Shared As String*3 key_wait="5"
Dim Shared As String*3 key_layfire="0"
Dim Shared As String*3 key_portal="<"
Dim Shared As String*3 key_logbook="L"
Dim Shared As String*3 key_togglehpdisplay="\Ch"
Dim Shared As String*3 key_yes="y"
Dim Shared As String*3 key_wormholemap="W"
Dim Shared As String*3 key_togglemanjets="M"
Dim Shared As String*3 key_cheat="�"
Dim Shared As String*3 key_pageup="�"
Dim Shared As String*3 key_pagedown="�"
Dim Shared As String*3 no_key
Dim Shared As String*3 key_mfile="�"
Dim Shared As String*3 key_filter="f"
Dim Shared As String*3 key_extended="#"
Dim Shared As String*3 key_accounting="\Ca"
dim shared as string*3 key_optequip="e"
dim shared optoxy as byte
Dim Shared gamerunning As Byte
Dim Shared uid As UInteger
Dim Shared ranoutoffuel As Short
Dim Shared walking As Short
Dim Shared itemcat(11) As String
Dim Shared shopname(4) As String

Type _cords
    s As Short '
    p As Short '
    m As Short
    x As Short
    y As Short
    z As Short
    'function set(x as short=0,y as short=0,z as short=0,m as short=0, p as short=0, s as short=0) as short
End Type

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


type _index
    dim as short maxl=128
    dim as short maxv=1024
    vindex(60,20,128) as short
    last(60,20) as short
    value(1024) as short
    cordindex(1024) as _cords
    vlast as short
    declare function index(x as short,y as short,i as short) as short
    declare function add(v as short,c as _cords) as short
    declare function remove(v as short,c as _cords) as short
    declare function move(v as short,oc as _cords,nc as _cords) as short
    declare function del() as short
end type


dim shared itemindex as _index
dim shared portalindex as _index

Type _energycounter
    e As Integer
    Declare Function add_action(v As Integer) As Integer
    Declare Function tick() As Integer
End Type

Function _energycounter.add_action(v As Integer) As Integer
    if v<0 then v=1 'If this thing get's a 0 it is propably supposed to be a 0, negative numbers propably not
    e+=v
    Return 0
End Function

Function _energycounter.tick() As Integer
    If e>0 Then
        e-=1
        Return 0
    Else
        e=0
        Return -1
    End If
End Function

Type _driftingship extends _cords
    g_tile As _cords
    start As _cords
End Type

Type _rect
    x As Short
    y As Short
    h As Short
    w As Short
    wd(16) As Byte
End Type

Type _visit
    s As Short
    t As Integer
End Type

Type _transfer
    from As _cords
    dest As _cords
    tile As Short
    col As Short
    ti_no As UInteger
    oneway As Short
    discovered As Short
    desig As String*64
    tumod As Short 'the higher the more tunnels
    dimod As Short 'the higher the more digloops
    spmap As Short 'make specialmap if non0
    froti As Short 'from what tile
End Type



Type _items
    id As UInteger
    ti_no As UShort
    uid As UInteger
    w As _cords
    ICON As String*1
    col As Short
    bgcol As Short
    discovered As Short
    scanmod As Single
    desig As String*64
    desigp As String*64
    ldesc As String*255
    price As Integer
    declare function describe() as string
    ty As Short
    v1 As Single
    v2 As Single
    v3 As Single
    v4 As Single
    v5 As Single 'Only for rewards
    v6 As Single 'Rover mapdata
    vt As _cords'rover target
    res As UByte
End Type

function _items.describe() as string
    dim t as string
    select case ty
    case 1
        return ldesc &"||Capacity:"&v2 &" passengers."
    case 2,4
        t=ldesc &"|"
        if v1>0 then t=t & "|Damage: "&v1
        if v4>0 then t=t & "|Nonlethal : "&v4
        if v3<>0 then t=t & "|Accuracy: "&v3
        if v2>0 then t=t & "|Range: "&v2
        return t
    case 3,103
        t=ldesc &"|"
        if v4>0 then t=t &"| !This suit is damaged! |"
        t=t &"||Armor: "&v1 &"|Oxygen: "&v3
        if v2>0 then t=t &"|Camo rating "&v2
        return t
    case 17
        t=ldesc
        t=t &"||Range: "&v1+5
        if v2>0 then t=t &"|Twin barrels"
    case 18
        t=ldesc
        t=t &"||Sensor range: "&v1 &"|Speed: "&v4
        return t
    case 30
        t=ldesc &"|This pack contains "&v2 &" dosages."
        return t
    case 88
        t="An alien device used for teleportation. It has a range of "&v1 &". "
        if v2<v4 then t=t &"||It is currently recharging. ("&int(v2) &")"
        if v2=v4 then t=t &"||Fully charged ("&int(v2)&")"
        return t
    case 56
        t="A system for the automatic retrieval of fuel from gas giants. It can hold up to " &v3 &" tons of fuel. ||HP: "&v1 &"|Volume: "&v3
        return t
    case else
        return ldesc
    end select
end function


Type _weap
    desig As String*30
    dam As Short
    range As Single
    ammo As Short
    ammomax As Short
    ROF As Byte
    ECMmod As Byte
    p As Short
    made As Byte
    col As Byte
    heat As Short
    heatadd As Byte
    heatsink As Byte
    reload As Byte
    reloading As Byte
    shutdown As Byte
End Type

Type _ammotype
    made As Byte
    desig As String*32
    tohit As Byte
    todam As Byte
    toran As Byte
    toheat As Byte
    price As Byte
    size As Byte
End Type

Type _faction
    war(8) As Short
    alli As Short
End Type

Enum shipequipment
    se_navcom
    se_ECM
    se_CargoShielding
    se_shipdetection
    se_fuelsystem
End Enum

Type _ship
    c As _cords
    e As _energycounter
    map As Short
    osx As Short
    osy As Short
    lastpirate As _cords
    landed As _cords
    turn As UInteger
    money As Integer
    aggr As Short
    desig As String *32
    ICON As String *1
    ti_no As UInteger
    di As Byte
    turnrate As Byte
    senac As Byte
    shieldshut As Byte
    cursed As Byte
    Declare Function diop() As Byte
    sensors As Short
    engine As Short
    Declare Function add_move_cost(mjs As Short) As Short
    Declare Function movepoints(mjs As Short) As Short
    Declare Function pilot(onship As Short) As Short
    Declare Function gunner(onship As Short) As Short
    Declare Function science(onship As Short) As Short
    Declare Function doctor(onship As Short) As Short
    declare function ammo() as short

    pipilot As Short
    pigunner As Short
    piscience As Short
    pidoctor As Short
    security As Short
    disease As Byte

    manjets As Short
    weapons(25) As _weap
    Declare Function useammo(test as short) As Short
    hull As Short
    hulltype As Short

    armortype As Byte=1
    loadout As Byte=1
    reloading As Byte=10
    bunking As Byte=1
    tribbleinfested as ubyte
    
    fuelmax As Single
    fuel As Single
    fueluse As Single
    shieldmax As Integer
    shieldside(7) As Byte
    tactic As Integer
    h_no As Short
    h_desig As String*24
    h_price As UShort
    h_maxhull As Short
    h_maxengine As Short
    h_maxshield As Short
    h_maxsensors As Short
    h_maxcargo As Short
    h_maxcrew As Short
    h_maxweaponslot As Short
    h_maxfuel As Single
    h_sdesc As String*5
    h_desc As String*255
    fuelpod As Short
    crewpod As Short
    addhull As Short

    dead As Short
    killedby As String*64
    shiptype As Short
    target As _cords
    equipment(4) As Short
    stuff(5) As Single
    cargo(25) As _cords
    st As Byte
    bounty As Byte
    'tradingmoney as integer
    lastvisit As _visit
    cryo As Short
    alienkills As UInteger
    deadredshirts As UInteger
    score As UInteger
    questflag(31) As Short
    discovered(10) As Byte
    towed As Byte
    Declare Function tractor() As Byte
    col As Short
    bcol As Short
    mcol As Short
End Type


Dim Shared foundsomething As Integer
dim shared nextlanding as _cords
Function _ship.tractor() As Byte
    Dim As Byte i,t
    For i=0 To 25
        If weapons(i).rof<0 And weapons(i).rof<t Then t=weapons(i).rof
    Next
    Return Abs(t)
End Function

Function _ship.useammo(test as short) As Short
    Dim As Short i,most,where
    For i=0 To 25
        If weapons(i).ammo>most Then
            most=weapons(i).ammo
            where=i
        EndIf
    Next
    If weapons(where).ammo>0 Then
        if test=1 then weapons(where).ammo-=1
        Return -1
    Else
        Return 0
    EndIf
End Function

function _ship.ammo() as short
    dim as short i,a
    for i=0 to 25
        a+=weapons(i).ammo
    next
    return a
end function

Dim Shared alliance(7) As Byte

dim shared logfile as short
dim shared autofire_target As _cords
    

if _debug=2704 then
    logfile=freefile
    open "exploreplanet.log" for append as logfile
    print #logfile,"Start"
endif

Function _ship.diop() As Byte
    If this.di=1 Then Return 9
    If this.di=2 Then Return 8
    If this.di=3 Then Return 7
    If this.di=4 Then Return 6
    If this.di=6 Then Return 4
    If this.di=7 Then Return 3
    If this.di=8 Then Return 2
    If this.di=9 Then Return 1
End Function

Type _target
    targets as _index
    i as short
    ti as short
    t as _cords
    declare function sort(center as _cords, rollover as short) as short
    declare function add(newtarget as _cords,newtvalue as short) as short
    declare function plusminus(key as string) as _cords
    declare function move(key as string,rollover as byte) as _cords
end type

dim shared target as _target
target.t.x=-1

Type _monster
    e As _energycounter
    speed As Byte
    movetype As Byte
    atcost As Byte
    teleportrange as byte
    teleportload as byte
    Declare Function add_move_cost(modifier as short=0) As Short
    c As _cords
    made As UByte
    slot As short
    no As UByte
    hpmax As Single
    hp As Single
    hpnonlethal As Single 'stores nonleathal damage done to critter
    hpreg As Single
    disease As Byte
    attacked As short
    secarmo(128) As Single
    secweap(128) As Single
    guns_to As Single
    secweapc(128) As Single
    blades_to As Single
    secweapran(128) As Single
    secweapthi(128) As Single
    nohp As UByte 'Number of Hover platforms
    nojp As UByte 'Number of jetpacks
    light As UByte 'Lightsource
    dark As UByte
    sight As Single
    union
        leak as single
        biomod As Single
    end union
    stunres As Byte
    union
        diet As Byte
        optoxy as byte
    end union
    tasty As Byte
    pretty As Byte
    intel As Short
    union
        lang As Short
        robots as short
    end union
    nocturnal As Byte
    union
        faction As Short
        groundpen as short
    end union
    allied As Short
    enemy As Short
    aggr As Byte
    killedby As short

    desc As String*127
    sdesc As String*64
    ldesc As String*512
    dhurt As String*16
    dkill As String*16
    swhat As String*64
    scol As UByte
    invis As Byte

    tile As Short
    ti_no As UInteger
    sprite As Short
    col As UByte
    dcol As UByte

    'move as single
    Union
        track As Short
        carried As Short
    End Union
    range As Short
    weapon As Short
    specialattack as short
    armor As Short
    respawns As Byte
    breedson As Byte
    regrate As Byte
    reg As Byte
    nearestenemy As Short
    denemy as single
    nearestfriend As Short
    dfriend as single
    nearestdead As Short
    ddead as single
    pickup as byte
    nearestitem As Short
    ditem as single
    cmshow As Byte
    cmmod As Byte 'Change Mood mod
    pumod As Byte 'Pick up mod
    oxymax As Single
    oxygen As Single
    oxydep As Single
    helmet As Byte
    sleeping As Single
    jpfuel As Single
    jpfuelmax As Single
    jpfueluse As Single
    target As _cords
    hasoxy As Byte
    stuff(16) As Single
    items(8) As Short
    itemch(8) As Short
End Type

enum specialattacks
    SA_none
    SA_Corrodes
end enum

Type _stars
    c As _cords
    spec As Byte
    ti_no As UInteger
    discovered As Byte
    planets(1 To 9) As Short
    desig As String*12
    comment As String*60
End Type

Type _planet
    p As Short
    map As Short
    orbit As Short
    darkness As Byte
    water As Short
    atmos As Short
    dens As Short
    grav As Single
    temp As Single
    life As Short
    highestlife As Single
    minerals As Short
    weat As Single
    depth As Byte
    death As Short
    genozide As Byte
    teleport As Byte
    plantsfound As Short
    pla_template(16) As Byte
    mon_template(16) As _monster
    mon_noamin(16) As Byte
    mon_noamax(16) As Byte
    mon_killed(16) As UByte
    mon_disected(16) As UByte
    mon_caught(16) As UByte
    mon_seen(16) As UByte
    colony As Byte
    colonystats(14) As Byte
    vault(8) As _rect
    discovered As Short
    visited As Integer
    mapped As Integer
    mapmod As Single
    rot As Single
    flags(32) As Byte
    weapon(5) As _weap
    comment As String*60
    mapstat As Byte
    colflag(16) As Byte
    wallset As Byte
End Type


'Flag 28=techgoods delivered to star creatures
Type _ae
    c As _cords
    rad As Byte
    dam As Byte
    dur As Byte
    typ As Byte
End Type

Type _planetsave
    awayteam As _monster
    enemy(256) As _monster
    lastenemy As Short
    lastlocalitem As Short
    ship As _cords
    map As Short
End Type

Type _fleet
    ty As Short 'Type: 1=patrol 2=merchant 3=pirate
    e As _energycounter
    c As _cords'Coordinates
    t As Short 'Number of coordinates of target in targetlist
    fuel As Integer
    del As Short
    flag As Short
    fighting As Short
    Declare Function speed() As Short
    Declare Function count() As Short
    Declare Function add_move_cost() As Short
    con(15) As Short ' Old ship storage con(0)=Nicety of pirates con(1)=Escorting,con(2)=lastbattle
    mem(15) As _ship 'Actual ship storage
End Type

Function _fleet.add_move_cost() As Short
    e.add_action(10-speed)
    Return 0
End Function

Function _fleet.speed() As Short
    Dim As Short i,v
    v=9
    For i=1 To 15
        If mem(i).hull>0 And mem(i).movepoints(0)<v Then v=mem(i).movepoints(0)
    Next
    If v<=0 Then v=1
    Return v
End Function


Function _fleet.count() As Short
    Dim As Short i,c
    For i=1 To 15
        If mem(i).hull>0 Then c+=1
    Next
    Return c
End Function

Type _goods
    'n as string*16
    p As Single
    v As Single
    'test as single
    'test2 as single
End Type
reDim Shared vismask(sm_x,sm_y) As Byte
Dim Shared As String goodsname(9)

Const lastgood=9

Type _basis
    c As _cords
    discovered As Short
    inv(lastgood) As _goods
    'different companys for each station
    repname As String*32
    company As Byte
    spy As Byte
    shop(17) As Byte
    pricelevel As Single=1
    mapmod As Single
    biomod As Single
    resmod As Single
    pirmod As Single
    lastsighting As Short
    lastsightingdis As Short
    lastsightingturn As Short
    lastfight As Short
    docked As Short
End Type

Dim Shared goods_prices(9,12,12) As Single
Dim Shared wsinv(20) As _weap

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
Type _comment
    c As _cords
    t As String*32
    l As Short
End Type



Type _table
    points As Integer
    desig As String *80
    death As String *80
End Type

Type _tile
    no As Short

    tile As Short
    ti_no As UInteger
    bgcol As Short
    col As Short

    desc As String*512
    stopwalking As Byte
    oxyuse As Byte
    locked As Byte
    movecost As UByte
    seetru As Short
    walktru As Short
    firetru As Short
    shootable As Short 'shooting at it will damage it
    dr As Short 'damage reduction
    hp As Short
    dam As Short
    range As Short
    tohit As Short
    hitt As String*512
    misst As String*512
    deadt As String*512
    turnsinto As Short
    succt As String*512
    failt As String*512
    killt As String*512
    spawnson As Short
    spawnswhat As Short
    spawnsmax As Short
    spawnblock As Short '=0 spawns forever, >0 each spawn =-3, <0 spawning blocked
    spawntext As String*512
    survivors As Short
    resources As Short
    gives As Short
    vege As Byte
    disease As Byte
    turnsoninspect As Short
    turnroll As Byte
    turntext As String*512
    causeaeon As Byte
    aetype As Byte
    hides As Byte
    repairable As Byte
    onclose As Short
    onopen As Short
    turnsonleave As Short
    turnsonleavetext As String*512
End Type

Type _disease
    no As UByte
    desig As String
    ldesc As String
    cause As String
    incubation As UByte
    duration As UByte
    fatality As UByte
    contagio As UByte
    causeknown As Byte
    cureknown As Byte
    att As Byte
    hal As Byte
    bli As Byte
    nac As Byte
    oxy As Byte
    wounds As Byte
End Type

Type _crewmember
    ICON As String*1
    n As String*20
    typ As Byte
    paymod As Byte
    hpmax As Byte
    hp As Byte
    disease As Byte
    incubation As UByte
    duration As UByte
    onship As Byte
    oldonship As Byte
    jp As Byte
    equips As Byte
    weap As Single
    blad As Single
    tohi As Single
    armo As Single
    atcost As Byte
    speed As Byte 'Unused as of now
    pref_ccweap As UInteger
    pref_lrweap As UInteger
    pref_armor As UInteger
    talents(29) As Byte
    augment(16) As Byte
    xp As Short
    morale As Short
    target As Short
    Time As integer
    bonus As Short
    price As Short
    baseskill(3) As Short
    story(10) As Byte
End Type
Declare Function best_crew(skill As Short,no As Short) As Short

Function _ship.pilot(onship As Short) As Short
    If pipilot<>0 Then Return pipilot
    Return best_crew(0,1)
End Function

Function _ship.gunner(onship As Short) As Short
    If pigunner<>0 Then Return pigunner
    Return best_crew(1,h_maxweaponslot)
End Function

Function _ship.science(onship As Short) As Short
    If piscience<>0 Then Return piscience
    Return best_crew(2,h_maxsensors)
End Function

Function _ship.doctor(onship As Short) As Short
    If pidoctor<>0 Then Return pidoctor
    Return best_crew(3,12)
End Function

Function _ship.movepoints(mjs As Short) As Short
    Dim mps As Short
    mps=CInt(this.engine*2-this.hull*0.15)
    If engine>0 Then mps=mps+1+mjs*3
    If mps<=0 Then mps=1
    If mps>9 Then mps=9
    Return mps
End Function

Function _ship.add_move_cost(mjs As Short) As Short
    e.add_action(10-movepoints(mjs))
    Return 0
End Function

Type _share
    company As Byte
    bought As UInteger
    lastpayed As UInteger
End Type

Type _company
    profit As Integer
    capital As Integer
    rate As Integer
    shares As Short
End Type

Type _company_bonus
    Base As UInteger
    Value As UInteger
    rank As UInteger
End Type

Type _shipfire
    what As Short
    when As Short
    where As _cords
    tile As String*1
    stun As Byte
End Type

Type _dialogoption
    no As UShort
    answer As String
End Type

Type _dialognode
    no As UShort
    statement As String
    effekt As String
    param(5) As Short
    Option(16) As _dialogoption
End Type

Type _civilisation
    n As String*16
    home As _cords
    ship(1) As _ship
    item(1) As _items
    spec As _monster
    knownstations(2) As Byte
    contact As Byte
    popu As Byte
    aggr As Byte
    inte As Byte
    tech As Byte
    phil As Byte
    wars(2) As Short '0 other civ, 1 pirates, 2 Merchants
    prefweap As Byte
    culture(6) As Byte '0 birth 1 Childhood 2 Adult 3 Death 4 Religion 5 Art 6 story about a unique
End Type

Type FONTTYPE
  As Integer w
  As Any Ptr dataptr
End Type

Type _pfcords
    x As Short
    y As Short
    c As UInteger
    i As Byte
End Type


Type vector
        x As Integer
        y As Integer
        Declare Constructor(x As Integer, y As Integer)
End Type

Constructor vector (x As Integer, y As Integer)
        this.x = x
        this.y = y
End Constructor

Type _sym_matrix

        xm As Integer
        vmax As Integer
        vmin As Integer
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
        If v>this.vmax And this.vmax<>0 Then v=this.vmax
        If v<this.vmin Then v=this.vmin
        this.item[i]=v
        Return 0
End Function

Function _sym_matrix.get_val(x As Integer,y As Integer) As Integer
        Dim i As Integer
        i=this.get_ind(x,y)
        Return this.item[i]
End Function

Property _sym_matrix.Val(xy As vector) As Integer
        Return this.get_val(xy.x,xy.y)
End Property

Property _sym_matrix.Val(xy As vector,v As Integer)
        this.set_val(xy.x,xy.y,v)
End Property

Type _bountyquest
    status As Byte '1 given, 2 ship destroyed by player, 3 ship destroyed by other, 4 reward given
    employer As Byte
    ship As Short
    reward As Short
    desig As String *32
    reason As Byte
    lastseen As _cords
End Type

Type _patrolquest
    status As Byte
    employer As Byte
    Enum emp
        corporate
        pirate
    End Enum
    cord(12) As _cords
    lastcord As Byte
    Declare Function generate(p As Short,maxdis As Short,danger As Short) As Short
    Declare Function check() As Short
    Declare Function reward() As Short
    Declare Function show() As String
    Declare Function pay() As Short
End Type

Dim Shared patrolquest(16) As _patrolquest

Type _questitem
    generic As Byte 'If new is generated, and last one was generic, next one is specific
    motivation As Byte
    Type As Byte
    price As Integer'Relative price of the QI for the QG
    given As Byte
    'id as integer
    it As _items
End Type

Type _questguy
    gender As Byte
    n As String*25
    job As Short
    location As Short
    talkedto As Short'1 Knows, 2 asked want
    lastseen As Short
    knows(lastquestguy) As Byte
    systemsknown(255) As Byte
    money As Short
    risk As Short
    friendly(lastquestguy) As Short
    loan As Short
    want As _questitem
    has As _questitem
    flag(15) As Short '0=Compared notes 1=Other 3=System 4=System,6=Corp,10 Skill known
End Type

Enum movetypes
    mt_walk
    mt_hover
    mt_fly
    mt_flyandhover
    mt_teleport
    mt_climb 'Can move across mountains, but not water (For spiders)
    mt_dig 'Can move through walls, but not water (For worms)
    mt_ethereal 'Can move through anything
    mt_fly2
End Enum


Dim Shared bg_parent As Byte

Enum backgrounds
    bg_title
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
End Enum

Enum locat
    lc_awayteam
    lc_onship
End Enum
Dim Shared location As Byte

Enum dockingdifficulty
    dd_station
    dd_smallstation
    dd_drifter
    dd_aliendrifter
    dd_comsat
    dd_asteroidmining
End Enum

Enum shops
    sh_shipyard'0
    sh_modules'1
    sh_Explorers'2
    sh_Cheap'3
    sh_Spacenstuff'4
    sh_YeOlde'5
    sh_used'6
    sh_usedships'7
    sh_mudds'8
    sh_bots'9
    sh_blackmarket'10
    sh_colonyI'11
    sh_aliens1'12
    sh_aliens2'13
    sh_sickbay'14
    sh_shipequip'15
    sh_giftshop'16
End Enum

type _shops
    station as short=-1
    x as short
    y as short 
    m as short
    shoptype as short
    shoporder as short
end type

Enum ShipYards
    sy_civil
    sy_military
    sy_pirates
    sy_blackmarket
End Enum

Dim Shared shipyardname(sy_blackmarket) As String

Enum moduleshops
    ms_energy
    ms_projectile
    ms_modules
End Enum

Dim Shared moduleshopname(ms_modules) As String


Enum RndItem
    RI_transport'0
    RI_rangedweapon'1
    RI_ccweapon'2
    RI_armor'3
    RI_Medpacks'4
    RI_KODrops'5
    RI_Stims
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
    RI_Nonlethal
End Enum

Enum ShipType
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
End Enum

Dim Shared piratenames(st_last) As String
Dim Shared piratekills(st_last) As Integer
Dim Shared questroll As Short
Enum SHIELDDIR
    sd_front
    sd_frontright
    sd_right
    sd_rearright
    sd_rear
    sd_rearleft
    sd_left
    sd_frontleft
End Enum

Enum QUEST
    Q_WANT
    Q_HAS
    Q_ANSWER
End Enum

Enum questtype
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
    qt_research'15
    qt_megacorp'16
    qt_biodata'17
    qt_anomaly'18
    qt_juryrig'19
    qt_cursedship'20
End Enum

Enum moneytype
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
End Enum

Dim Shared income(mt_last) As Integer

Enum config
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
    con_easy
    con_minsafe
    con_startrandom
    con_autosave
    con_savescumming
    con_restart
    con_end
End Enum


Dim Shared As String configname(con_end-1)
Dim Shared As String configdesc(con_end-1)
Dim Shared As Byte configflag(con_end-1)

Dim Shared As Byte startingweapon

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
configdesc(con_transitem)="/ Transparent Items:"
configdesc(con_gtmwx)="/ Main window width(tile mode):"
configdesc(con_savescumming)="/ Savescumming:"
configdesc(con_sysmaptiles)="/ Use tiles for system map:"
configdesc(con_customfonts)="/ Customfonts:"
configdesc(con_damscream)="/ Damage scream:"

Dim Shared battleslost(8,8) As Integer
Enum fleettype
    ft_player
    ft_merchant
    ft_pirate
    ft_patrol
    ft_pirate2
    ft_ancientaliens
    ft_civ1
    ft_civ2
    ft_monster
End Enum
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

Dim Shared adislastenemy As Short, adisdeadcounter As Short,adisloctime As Short,adisloctemp As Single
Dim Shared As Short lastbountyquest=16
Dim Shared bountyquest(lastbountyquest) As _bountyquest
Dim Shared questguy(lastquestguy) As _questguy
Dim Shared questguyjob(18) As String
Dim Shared questguydialog(22,2,2) As String
Dim Shared questguyquestion(22,1) As String
Enum stphrase
    sp_greetfriendly
    sp_greetneutral
    sp_greethostile
    sp_gotalibi
    sp_gotmoney
    sp_cantpayback
    sp_notenoughmoney
    sp_gotreport
    sp_last
End Enum

Enum slse
    slse_arena
    slse_zoo
    slse_slaves
End Enum

Enum rwrd
    rwrd_mapdata
    rwrd_biodata
    rwrd_resources
    rwrd_pirates
    rwrd_artifacts
    rwrd_5
    rwrd_piratebase
    rwrd_6
    rwrd_pirateoutpost
    rwrd_tasty
    rwrd_pretty
End Enum

Dim Shared standardphrase(sp_last-1,2) As String
Dim Shared talent_desc(29) As String


Dim Shared palette_(255) As UInteger
Dim Shared _swidth As Byte=35'Length of line in a shop
Dim Shared apwaypoints(1024) As _cords
Dim Shared lastapwp As Short
Dim Shared currapwp As Short
Dim Shared apdiff As Short

Dim Shared talent_desig(29) As String
Dim Shared evkey As Event
'dim shared video as SDL_Surface ptr
Dim Shared reward(11) As Single
Dim Shared ano_money As Short

Dim Shared baseprice(9) As Short
Dim Shared avgprice(9) As Single

Dim Shared spectraltype(10) As Short
Dim Shared spectralname(10) As String
Dim Shared scount(10) As Short
Dim Shared spectralshrt(10) As String

Dim As Short a,b,c,d,e,f,g
Dim Shared x As Short
Dim Shared y As Short
Dim As Single x1,y1,x2,y2

Dim Shared flag(20) As Short
Const lastartifact=25
Dim Shared artflag(lastartifact) As Short
Dim Key As String
Dim Shared zeit As Integer
Dim Shared savefrom(16) As _planetsave
Dim Shared stationroll As Short
Dim Shared player As _ship
Dim Shared awayteam As _monster
reDim Shared map(laststar+wormhole+1) As _stars
Dim Shared basis(12) As _basis
Dim Shared companystats(5) As _company
Dim Shared companyname(5) As String
Dim Shared companynameshort(5) As String
Dim Shared shares(2048) As _share
Dim Shared lastshare As Short
reDim Shared spacemap(sm_x,sm_y) As Short
Dim Shared combatmap(60,20) As Byte
Dim Shared planetmap(60,20,max_maps) As Short
Dim Shared planets(max_maps) As _planet
Dim Shared planets_flavortext(max_maps) As String
Dim Shared civ(3) As _civilisation
Dim Shared retirementassets(16) As UByte
For a=0 To max_maps
    planets(a).darkness=5
Next
Dim Shared item(25000) As _items
Dim Shared lastitem As Integer=-1
Dim Shared _last_title_pic As Byte=14

dim shared lastshop as short
dim shared shoplist(2048) as _shops
Dim Shared shopitem(20,2048) As _items

Dim Shared makew(20,5) As Byte

Dim Shared tiles(512) As _tile
Dim Shared gtiles(2048) As Any Ptr
Dim Shared stiles(9,68) As Any Ptr
Dim Shared shtiles(7,4) As Any Ptr
Dim Shared gt_no(4096) As Integer
Dim Shared scr As Any Ptr

Dim Shared dprintline As Byte
Dim Shared bestaltdir(9,1) As Byte
Dim Shared piratebase(_NoPB) As Short 'Mapnumber of piratebase
Dim Shared specialplanet(lastspecial) As Short
Dim Shared specialplanettext(lastspecial,1) As String
Dim Shared spdescr(lastspecial) As String
Dim Shared specialflag(lastspecial) As Byte
Dim Shared atmdes(16) As String
#IfDef _FBSOUND
Dim Shared Sound(12) As Integer
#Else
Dim Shared Sound(12) As Integer Ptr
#EndIf
Dim Shared displaytext(255) As String
Dim Shared dtextcol(255) As Short

Dim Shared patrolmod As Short
Dim Shared fleet(255) As _fleet
Dim Shared targetlist(4068) As _cords
Dim Shared drifting(128) As _driftingship
Dim Shared crew(255) As _crewmember
Dim Shared shiptypes(20) As String
Dim Shared disease(17) As _disease
Dim Shared awayteamcomp(4) As Byte
Dim Shared faction(8) As _faction
Dim Shared empty_ship As _ship
Dim Shared empty_fleet As _fleet

empty_fleet.del=1
declare function factionadd(a as short,b as short,ad as short) as short
Dim Shared coms(255) As _comment
reDim Shared portal(4096) As _transfer
Dim Shared lastportal As Short
Dim Shared lastplanet As Short
Dim Shared lastcom As Short
Dim Shared As Byte pf_stp=1
Dim Shared lastwaypoint As Short
Dim Shared firstwaypoint As Short
Dim Shared firststationw As Short
Dim Shared lastfleet As Short
Dim Shared alienattacks As Integer
Dim Shared lastdrifting As Short=16
Dim Shared liplanet As Short 'last input planet
Dim Shared whtravelled As Short
Dim Shared whplanet As Short
Dim Shared tmap(60,20) As _tile
Dim Shared vacuum(60,20) As Byte
Dim As _cords p1,p2,p3
Dim Shared pwa(1024) As _cords'Points working array
Dim dummy As _monster
Dim dummycords As _cords
Dim text As String
Dim As Short astcou,gascou,pl
Dim Shared tacdes(6) As String
Dim Shared pcards As cards.cardobj
Dim Shared lastprobe As Short
Dim Shared probe(100) As _cords 'm=Item,

'dim shared as FB.image ptr TITLEFONT
Dim Shared As Any Ptr TITLEFONT
Dim Shared As Any Ptr FONT1,FONT2
Dim Shared As UByte _FH1,_FH2,_FW1,_FW2,_fohi1,_fohi2,_TFH

Dim Shared endstory As String
Dim Shared crew_desig(18) As String
Dim Shared combon(9) As _company_bonus

Dim Shared ammotypename(4) As String

Dim Shared cagedmonster(128) As _monster
Dim Shared lastcagedmonster As UByte

Dim Shared As String bountyquestreason(6)

Type _handrank
    rank As Short
    high(5) As Short
End Type

Type _cardcount
    rank As Short
    no As Short
    Pos As Short
End Type

Type _pokerplayer
    Name As String*16
    risk As Short
    bet As Byte
    fold As Byte
    pot As Byte
    rank As Byte
    money As Short
    card(5) As Integer
    ci As Byte
    in As Byte
    Declare Function firstempty() As Short
    win As _handrank
    qg As Short 'Which questguy is this?
End Type

Type _pokerrules
    bet As Byte
    limit As Byte
    closed As Byte
    Swap As Byte
End Type

Dim Shared pixelsize As Integer

declare function add_shop (shoptype as short,c as _cords, station as short) as short
declare function get_shop_index (shoptype as short,c as _cords,station as short) as short

Declare Function make_shipequip(a As Short) As _items
Declare Function roman(i As Integer) As String

Declare Function shares_value() As Short
Declare Function planet_artifacts_table() As String
Declare Function acomp_table() As String
Declare Function uid_pos(uid As UInteger) As Integer

Declare Function sort_items(List() As _items) As Short
Declare Function items_table() As String
Declare Function artifacts_html(artflags() As Short) As String
Declare Function postmort_html(text As String) As Short
Declare Function ship_table() As String
Declare Function uniques_html(unflags() As Byte) As String
Declare Function exploration_text_html() As String
Declare Function html_color(c As String,indent As Short=0,wid As Short=0) As String
Declare Function crew_html(c As _crewmember) As String
Declare Function skill_text(c As _crewmember) As String
Declare Function augment_text(c As _crewmember) As String
Declare Function crew_table() As String
Declare Function count_crew(crew() As _crewmember) As Short
Declare Function income_expenses_html() As String
Declare Function play_poker(st As Short) As Short
Declare Function card_shuffle(card() As Integer) As Short
declare function gen_shop(i as short, shoptype as short) as short

Declare Function font_load_bmp(ByRef _filename As String) As UByte Ptr

Declare Function player_eval(p() As _pokerplayer,i As Short,rules As _pokerrules) As Short
Declare Function change_captain_appearance(x As Short,y As Short) As Short
Declare Function captain_sprite() As Short
declare function ep_dropdeaditem(mi as short) as short
declare function find_working_teleporter() as short
Declare Function draw_poker_table(p() As _pokerplayer,reveal As Short=0, winner As Short=0,r As _pokerrules) As Short
Declare Function better_hand(h1 As _handrank,h2 As _handrank) As Short
Declare Function poker_eval(c() As Integer, acehigh As Short,knowall As Short) As _handrank
Declare Function ace_highlo_eval(c() As Integer,knowall As Short) As _handrank
Declare Function sort_cards(card() As Integer,all As Short=0) As Short
Declare Function poker_next(i As Short,p() As _pokerplayer) As Short
Declare Function poker_winner(p() As _pokerplayer) As Short
Declare Function highest_pot(p() As _pokerplayer) As Short
Declare Function display_portals(slot As Short,osx As Short) As Short
Declare Function save_keyset() As Short

declare function trouble_with_tribbles() as short

Dim Shared bonesflag As Short
Dim Shared farthestexpedition As Integer
Dim Shared enemy(255) As _monster
Dim Shared lastenemy As Short
Declare Function findbest_jetpack() As Short

' SUB DECLARATION
Declare Function add_a_or_an(t As String,beginning As Short) As String

' prospector .bas
Declare Function player_energylimits() As Short
Declare Function get_planet_cords(ByRef p As _cords,mapslot As Short,shteam As Byte=0) As String
Declare Function planet_cursor(p As _cords,mapslot As Short,ByRef osx As Short,shteam As Byte) As String

Declare Function start_new_game() As Short
Declare Function from_savegame(a As Short) As Short
Declare Function wormhole_travel() As Short

Declare Function wormhole_ani(target As _cords) As Short
declare function landing_landingpads(cords() as _cords, last as short,mapslot as short) as short

Declare Function target_landing(mapslot As Short,Test As Short=0) As Short
Declare Function landing(mapslot As Short,lx As Short=0,ly As Short=0, Test As Short=0) As Short
Declare Function scanning() As Short
Declare Function rescue() As Short
Declare Function asteroid_mining(slot As Short) As Short
Declare Function gasgiant_fueling(t As Short,orbit As Short,sys As Short) As Short
Declare Function dock_drifting_ship(a As Short) As Short
Declare Function move_rover(pl As Short) As Short
declare function captain_perks(slot as short) as short

Declare Function rnd_crewmember(onship As Short=0) As Short
Declare Function haggle_(way As String) As Single
Declare Function botsanddrones_shop(si as short) As Short
declare function make_shop_menu(sh as short,pmod as single,inv() as _items,c as short,byref order as short,byref ex as short,t as string,desc as string) as short

Declare Function display_monsters(osx As Short) As Short
Declare Function alerts() As Short
Declare Function launch_probe() As Short
Declare Function move_probes() As Short
Declare Function retirement() As Short
Declare Function no_spacesuit(who() As Short,ByRef alle As Short=0) As Short
Declare Function add_questguys() As Short
Declare Function give_patrolquest(employer As Short) As Short
Declare Function reward_patrolquest() As Short

declare function com_explosion_ani(x as short,y as short) as short
Declare Function com_radio(defender As _ship, attacker() As _ship, e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short)  As Short
Declare Function draw_shield(ship As _ship,osx As Short) As Short
Declare Function crew_menu(crew() As _crewmember, from As Short, r As Short=0,text As String="") As Short
declare function ep_rovermove(a as short,slot as short) as short

Declare Function load_palette() As Short
Declare Function open_file(filename As String) As Short
Declare Function death_text() As String

Declare Function merc_dis(fl As Short,ByRef goal As Short) As Short
Declare Function check_tasty_pretty_cargo() As Short
Declare Function update_tmap(slot As Short) As Short

Declare Function show_dotmap(x1 As Short, y1 As Short) As Short
Declare Function show_minimap(xx As Short,yy As Short) As Short
Declare Function lb_filter(lobk() As String, lobn() As Short, lobc() As Short,lobp() As _Cords ,last As Short) As Short

Declare Function remove_no_spacesuit(who() As Short,last As Short) As Short
Declare Function questguy_newloc(i As Short) As Short

Declare Function update_questguy_dialog(i As Short,node() As _dialognode,iteration As Short) As Short
Declare Function count_gas_giants_area(c As _cords,r As Short) As Short
Declare Function questguy_dialog(i As Short) As Short
Declare Function change_armor(st As Short) As Short
Declare Function urn(min As Short, max As Short,mult As Short,bonus As Short) As Short
Declare Function rarest_good() As Short
Declare Function display_stock() As Short
declare function repair_spacesuit(v as short=-1) as short

declare function gets_entry(x as short,y as short, slot as short) as short
Declare Function ep_friendfoe(i As Short,j As Short) As Short
Declare Function calcosx(x As Short,wrap As Byte) As Short
Declare Function rg_icechunk() As Short 
Declare Function ep_monsterupdate(i As Short, spawnmask() as _cords,lsp as short,mapmask() As Byte,nightday() As Byte,message() As Byte) As Short
Declare Function ep_nearest(i As Short) As Short
Declare Function ep_changemood(i As Short,message() As Byte) As Short
Declare Function ep_needs_spacesuit(slot As Short,c As _cords,ByRef reason As String="") As Short
Declare Function ep_display_clouds(cloudmap() As Byte) As Short

Declare Function ep_autoexplore(slot As Short) As Short
Declare Function ep_planetroute(route() As _cords,move As Short,start As _cords, target As _cords,rollover As Short) As Short
Declare Function ep_autoexploreroute(astarpath() As _cords,start As _cords,move As Short, slot As Short, rover As Short=0) As Short
Declare Function ep_roverreveal(i As Integer) As Short

Declare Function ep_portal() As _cords
Declare Function ep_pickupitem(Key As String) As Short
Declare Function ep_shipfire(shipfire() As _shipfire) As Short
Declare Function ep_checkmove(ByRef old As _cords,Key As String) As Short
Declare Function ep_examine() As Short
Declare Function ep_helmet() As Short
Declare Function ep_closedoor() As Short
Declare Function ep_radio(ByRef nextlanding As _cords,ByRef ship_landing As Short, shipfire() As _shipfire,lavapoint() As _cords, ByRef sf As Single, nightday() As Byte,localtemp() As Single) As Short
Declare Function ep_grenade(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare Function ep_fire(mapmask() As Byte,Key As String,ByRef autofire_target As _cords) As Short
Declare Function ep_playerhitmonster(old As _cords, mapmask() As Byte) As Short
Declare Function ep_monstermove(spawnmask() As _cords, lsp As Short,  mapmask() As Byte,nightday() As Byte) As Short
Declare Function ep_items(localturn As Short) As Short
Declare Function ep_updatemasks(watermap() as byte,localtemp() as single, cloudmap() as byte, spawnmask() As _cords,mapmask() As Byte,nightday() As Byte, ByRef dawn As Single, ByRef dawn2 As Single) As Short
Declare Function ep_tileeffects(areaeffect() As _ae, ByRef last_ae As Short,lavapoint() As _cords, nightday() As Byte, localtemp() As Single,cloudmap() As Byte) As Short
Declare Function ep_landship(ByRef ship_landing As Short,nextlanding As _cords,nextmap As _cords) As Short
Declare Function ep_areaeffects(areaeffect() As _ae,ByRef last_ae As Short,lavapoint() As _cords, cloudmap() As Byte) As Short
Declare Function ep_atship() As Short
Declare Function ep_planeteffect(shipfire() As _shipfire, ByRef sf As Single,lavapoint() As _cords,localturn As Short,cloudmap() As Byte) As Short
Declare Function ep_jumppackjump() As Short
Declare Function ep_inspect(ByRef localturn As Short) As Short
Declare Function ep_launch(ByRef nextmap As _cords) As Short
Declare Function ep_lava(lavapoint() As _cords) As Short
Declare Function ep_communicateoffer(Key As String) As Short
Declare Function ep_spawning(spawnmask() As _cords,lsp As Short, diesize As Short,nightday() As Byte) As Short
Declare Function ep_dropitem() As Short
Declare Function ep_crater(shipfire() As _shipfire, ByRef sf As Single) As Short
Declare Function ep_fireeffect(p2 As _cords,slot As Short, c As Short, range As Short, mapmask() As Byte, first As Short=0,last As Short=0) As Short
Declare Function ep_heatmap(lavapoint() As _cords,lastlavapoint As Short) As Short
Declare Function fuzzyMatch( ByRef correct As String, ByRef match As String ) As Single
Declare Function place_shop_order(sh As Short) As Short
Declare Function lev_minimum( a As Integer, b As Integer, c As Integer ) As Integer

Declare Function addmoney(amount As Integer,mt As Byte) As Short
Declare Function count_and_make_weapons(st As Short) As Short

Declare Function income_expenses() As String
declare function civ_adapt_tiles(slot as short) as short

Declare Function teleport(awaytam As _cords, map As Short) As _cords
Declare Function move_monster(i As short, target As _cords,towards as byte,rollover as byte,mapmask() As Byte) As short
Declare Function hitmonster(defender As _monster,attacker As _monster,mapmask() As Byte, first As Short=-1, last As Short=-1) As _monster
Declare Function monsterhit(defender As _monster, attacker As _monster,vis As Byte) As _monster
Declare Function spacecombat(atts As _fleet, ter As Short) As Short
Declare Function spacestation(st As Short) As _ship
Declare Function buy_weapon(st As Short) As Short
Declare Function update_world(location As Short) As Short
Declare Function robot_invasion() As Short
declare function add_landed_alienship(c as _cords,m as short) as short
Declare Function explore_space() As Short
Declare Function explore_planet(from As _cords, orbit As Short) As _cords
Declare Function alienbomb(c As Short,slot As Short) As Short
Declare Function tohit_gun(a As Short) As Short
Declare Function tohit_close(a As Short) As Short
Declare Function missing_ammo() As Short
Declare Function max_hull(s As _ship) As Short
Declare Function change_loadout() As Short
Declare Function grenade(from As _cords,map As Short) As _cords
Declare Function poolandtransferweapons(s1 As _ship,s2 As _ship) As Short
Declare Function clear_gamestate() As Short
Declare Function planetflags_toship(m As Short) As _ship
Declare Function can_learn_skill(ci As Short,si As Short) As Short
Declare Function form_alliance(who As Short) As Short
Declare Function ask_alliance(who As Short) As Short
declare function explore_space_messages() as short

Declare Function colonize_planet(st As Short) As Short
Declare Function get_com_colon_candidate(st As Short) As Short
Declare Function score_planet(i As Short,st As Short) As Short
Declare Function score_system(s As Short,st As Short) As Short

declare function calc_sight() as short

Declare Function get_highestrisk_questguy(st As Short) As Short
Declare Function questguy_newquest(i As Short) As Short
Declare Function make_questitem(i As Short,wanthas As Short) As Short
Declare Function get_other_questguy(i As Short,sameplace As Byte=0) As Short
Declare Function rnd_questguy_byjob(jo As Short,self As Short=0) As Short

' fileIO.bas
Declare Function load_dialog_quests() As Short
Declare Function character_name(ByRef gender As Byte) As String
Declare Function count_lines(file As String) As Short
Declare Function delete_custom(pir As Short) As Short
Declare Function load_key(ByVal t As String,ByRef n As String="") As String
Declare Function check_filestructure() As Short
Declare Function load_sounds() As Short
Declare Function load_fonts() As Short
Declare Function save_config(oldtiles As Short) As Short
Declare Function load_config() As Short
Declare Function background(fn As String) As Short
Declare Function save_bones(t As Short) As Short
Declare Function load_bones() As Short
Declare Function getbonesfile() As String
Declare Function configuration() As Short
Declare Function load_map(m As Short,slot As Short) As Short
Declare Function texttofile(text As String) As String
Declare Function load_keyset() As Short
Declare Function load_dialog(fn As String, n() As _dialognode) As Short
Declare Function get_biodata(e As _monster) As Integer
Declare Function is_passenger(i As Short) As Short
Declare Function add_passenger(n As String,typ As Short, price As Short, bonus As Short, target As Short, ttime As integer, gender As Short) As Short

Declare Function gen_fname(fname() As String) As Short
Declare Function cargo_text() As String
Declare Function weapon_text(w As _weap) As String

Declare Function bunk_multi() As Single
' prosIO.bas
Declare Function draw_border(xoffset As Short) As Short
Declare Function showteam(from As Short, r As Short=0,text As String="") As Short
Declare Function gainxp(slot As Short,v As Short=1) As String
Declare Function gain_talent(slot As Short,talent as short=0) As String
Declare Function add_talent(cr As Short, ta As Short, Value As Single) As Single
Declare Function remove_member(n As Short, f As Short) As Short
Declare Function changemoral(Value As Short, where As Short) As Short
Declare Function is_gardenworld(m As Short) As Short
Declare Function show_wormholemap(j As Short=0) As Short
Declare Function list_inventory() As String
Declare Function equipment_value() As Integer

Declare Function keybindings(allowed As String="") As Short

Declare Function join_fight(f As Short) As Short

Declare Function shipstatus(heading As Short=0) As Short
Declare Function display_stars(bg As Short=0) As Short
Declare Function display_star(a As Short,fbg As Byte=0) As Short
Declare Function display_planetmap(slot As Short,xos As Short,bg As Byte) As Short
Declare Function display_station(a As Short) As Short
Declare Function display_ship(show As Byte=0) As Short
Declare Function add_stations() As Short

Declare Function display_ship_weapons(m As Short=0) As Short
Declare Function display_system(in As Short,forcebar As Byte=0,hi As Byte=0) As Short
Declare Function display_awayteam(showshipandteam As Byte=1,osx As Short=555) As Short
Declare Function dtile (x As Short,y As Short, tiles As _tile,visible As Byte) As Short
Declare Function locEOL() As _cords
Declare Function display_sysmap(x As Short, y As Short, in As Short, hi As Short=0,bl As String,br As String) As Short
Declare Function nextplan(p As Short,in As Short) As Short
Declare Function prevplan(p As Short,in As Short) As Short
Declare Function questguy_message(c As Short) As Short
Declare Function get_invbay_bytype(t As Short) As Short

Declare Function hpdisplay(a As _monster) As Short
Declare Function infect(a As Short, dis As Short) As Short
Declare Function diseaserun(a As Short) As Short
Declare Function settactics() As Short
Declare Function make_vismask(c As _cords,sight As Short,m As Short,ad as short=0,groundpen as short=0) As Short
Declare Function vis_test(a As _cords,p As _cords,Test As Short) As Short
Declare Function ap_astar(start As _cords,ende As _cords,diff As Short) As Short
Declare Function has_questguy_want(i As Short,ByRef t As Short) As Short
declare function sell_towed() as short

declare function corrode_item() as short

Declare Function caged_monster_text() As String
Declare Function sell_alien(sh As Short) As Short
Declare Function skill_test(bonus As Short,targetnumber As Short,echo As String="") As Short
Declare Function vege_per(slot As Short) As Single
declare function set_globals() as short
declare function wear_armor(a as short,b as short) as short
Declare Function add_ano(p1 As _cords,p2 As _cords,ano As Short=0) As Short
Declare Function makestuffstring(l As Short) As String
Declare Function levelup(p As _ship,from As Short) As _ship
Declare Function max_security() As Short
Declare Function get_freecrewslot() As Short
Declare Function add_member(a As Short,skill As Short) As Short
Declare Function cure_awayteam(where As Short) As Short
Declare Function heal_awayteam(ByRef a As _monster,heal As Short) As Short
declare function dam_awayteam_list(target() as short, stored() as short, ap as short, all as short) as short
Declare Function dam_awayteam(dam As Short,ap As Short=0,dis As Short=0,all as short=0) As String
Declare Function dplanet(p As _planet,orbit As Short, scanned As Short,slot As Short) As Short
Declare Function dprint(text As String, col As Short=11) As Short
Declare Function scrollup(b As Short) As Short
Declare Function blink(ByVal p As _cords, osx As Short) As Short
Declare Function Cursor(target As _cords,map As Short, osx As Short,osy As Short=0,radius As Short=0) As String
Declare Function Menu(bg As Byte,text As String,help As String="", x As Short=2, y As Short=2,blocked As Short=0,markesc As Short=0,st As Short=-1) As Short
Declare Function move_ship(Key As String) As _ship
Declare Function total_bunks() As Short
Declare Function getplanet(sys As Short, forcebar As Byte=0) As Short
Declare Function get_system() As Short
Declare Function get_random_system(unique As Short=0,gascloud As Short=0, disweight As Short=0,hasgarden As Short=0) As Short
Declare Function getrandomplanet(s As Short) As Short
Declare Function sysfrommap(a As Short)As Short
Declare Function orbitfrommap(a As Short) As Short
declare function add_stranded_ship(s as short,p as _cords, a as short,working as short) as short
declare function repair_spacesuits() as short

Declare Function get_colony_building(map As Short) As _cords
Declare Function grow_colony(map As Short) As Short
Declare Function isbuilding(x As Short,y As Short,map As Short) As Short
Declare Function closest_building(p As _cords,map As Short) As _Cords
Declare Function grow_colonies() As Short
Declare Function count_tiles(i As Short,map As Short) As Short
Declare Function remove_building(map As Short) As Short
Declare Function count_diet(slot As Short,diet As Short) As Short

Declare Function merchant() As Single

Declare Function sort_by_distance(c As _cords,p() As _cords,l() As Short,last As Short) As Short
Declare Function wormhole_navigation() As Short

Declare Function random_pirate_system() As Short
Declare Function askyn(q As String,col As Short=11,sure As Short=0) As Short
Declare Function randomname() As String
Declare Function is_gasgiant(m As Short) As Short
Declare Function countgasgiants(sys As Short) As Short
Declare Function is_asteroidfield(m As Short) As Short
Declare Function countasteroidfields(sys As Short) As Short
Declare Function checkcomplex(map As Short,fl As Short) As Integer
Declare Function getnumber(a As Integer,b As Integer, e As Integer) As Integer

Declare Function gettext(x As Short, y As Short, ml As Short, text As String,pixel As Short=0) As String
Declare Function getdirection(Key As String) As Short
Declare Function keyplus(Key As String) As Short
Declare Function keyminus(Key As String) As Short
Declare Function paystuff(price As Integer) As Integer
Declare Function shop(sh As Short,pmod As Single, shopn As String, qty as byte=0) As Short
Declare Function monster_description(enemy As _monster) As String
Declare Function getfilename() As String
Declare Function savegame(crash as short=0)As Short
Declare Function load_game(filename As String) As Short
Declare Function refuel_f(f As _fleet, st As Short) As _fleet
Declare Function load_font(fontdir As String,ByRef fh As UByte) As UByte Ptr

Declare Function load_tiles() As Short
Declare Function make_alienship(slot As Short, t As Short) As Short
Declare Function makecivfleet(slot As Short) As _fleet
Declare Function civfleetdescription(f As _fleet) As String
Declare Function string_towords(word() As String, s As String, break As String, punct As Short=0) As Short
Declare Function set_fleet(fl As _fleet)As Short
declare function com_playerfire(t as short,w as short,attacker() as _ship,mines_p() as _cords ,mines_v() as short,mines_last as short) as short

Declare Function com_vismask(c As _cords) As Short
Declare Function com_display(defender As _ship, attacker() As _ship, e_track_p() As _cords,e_track_v()As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare Function com_gettarget(defender As _ship, wn As Short, attacker() As _ship,marked As Short,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,e_last As Short,mines_p() As _cords,mines_v() As Short,mines_last As Short) As Short
Declare Function com_getweapon(echo as byte=1) As Short
Declare Function com_fire(ByRef target As _ship,ByRef attacker As _ship,ByRef w As Short, gunner As Short, range As Short) As _ship
Declare Function com_sinkheat(s As _ship,manjets As Short) As Short
Declare Function com_hit(target As _ship, w As _weap,damage As Short, range As Short,attn As String,side As Short) As _ship
Declare Function com_side(target As _ship,c As _cords) As Short
Declare Function com_criticalhit(t As _ship, roll As Short) As _ship
Declare Function com_flee(defender As _ship,attacker() As _ship) As Short
Declare Function com_wstring(w As _weap, range As Short) As String
Declare Function com_testweap(w As _weap, p1 As _cords,attacker() As _ship,mines_p() As _cords,mines_last As Short, echo As Short=0) As Short
Declare Function com_remove(attacker() As _ship, t As Short,flag As Short=0) As Short
Declare Function com_dropmine(defender As _ship,mines_p() As _cords,mines_v() As Short,ByRef mines_last As Short,attacker() As _ship) As Short
Declare Function com_detonatemine(d As Short,mines_p() As _cords, mines_v() As Short, ByRef mines_last As Short, defender As _ship, attacker() As _ship) As Short
Declare Function com_damship(ByRef t As _ship, dam As Short, col As Short) As _ship
Declare Function com_mindist(s As _ship) As Short
Declare Function com_regshields(s As _ship) As Short
Declare Function com_shipbox(s As _ship, di As Short) As String
Declare Function com_NPCMove(defender As _ship,attacker() As _ship,e_track_p() As _cords,e_track_v() As Short,e_map() As Byte,ByRef e_last As Short) As Short
Declare Function com_NPCFire(defender As _ship,attacker() As _ship) As Short
Declare Function com_findtarget(defender As _ship,attacker() As _ship) As Short
Declare Function com_evaltarget(attacker As _ship,defender As _ship) As Short
Declare Function com_turn(dircur As Byte,dirdest As Byte,turnrate As Byte) As Short
Declare Function com_direction(dest As _cords,target As _cords) As Short
Declare Function com_shipfromtarget(target As _cords,defender As _ship,attacker() As _ship) As Short
Declare Function com_NPCfireweapon(ByRef defender As _ship, ByRef attacker As _ship,b As Short) As Short
Declare Function com_victory(attacker() As _ship) As Short
Declare Function com_add_e_track(ship As _ship,e_track_p() As _cords,e_track_v() As Short, e_map() As Byte,e_last As Short) As Short

declare function display_item(i as integer,osx as short,slot as short) as short
declare function display_portal(b as short,slot as short,osx as short) as short

Declare Function get_rumor(i As Short=18) As String
Declare Function show_standing() As Short

Declare Function date_string() As String
Declare Function com_targetlist(defender As _ship, attacker() As _ship, mines_p() As _cords,mines_v() As Short, mines_last As Short) As _target
Declare Function load_quest_cargo(t As Short,car As Short,dest As Short) As Short

Declare Function keyin(allowed As String ="", blocked As Short=0)As String
Declare Function screenshot(a As Short) As Short
Declare Function logbook() As Short
Declare Function auto_pilot(start As _cords, ende As _cords, diff As Short) As Short
Declare Function bioreport(slot As Short) As Short
Declare Function messages() As Short
Declare Function storescreen(As Short) As Short
Declare Function alienname(flag As Short) As String
Declare Function communicate(byref e As _monster, mapslot As Short,monslot As Short) As Short
Declare Function artifact(c As Short) As Short
'declare function getshipweapon() as short
Declare Function getmonster() As Short
Declare Function findartifact(v5 As Short) As Short
Declare Function scrap_component() As Short

Declare Function ep_planetmenu(entrycords as _cords,slot As Short,shipfire() As _shipfire, spawnmask() As _cords, lsp As Short,loctemp As Single) As _cords
Declare Function ep_display(osx As Short=555,nightday as short=0) As Short
Declare Function earthquake(t As _tile,dam As Short)As _tile
Declare Function ep_gives(awayteam As _monster, ByRef nextmap As _cords, shipfire() As _shipfire, spawnmask() As _cords,lsp As Short,Key As String,loctemp As Single) As Short
Declare Function numfromstr(t As String) As Short
Declare Function explored_percentage_string() As String

'Star Map generation
Declare Function make_spacemap() As Short
Declare Function make_clouds() As Short
Declare Function add_drifters() As Short
Declare Function add_special_planets() As Short
Declare Function add_easy_planets(start As _cords) As Short
Declare Function add_stars() As Short
Declare Function add_company_shop(slot As Short,mt As Short) As Short

Declare Function add_wormholes() As Short
Declare Function add_event_planets() As Short
Declare Function add_caves() As Short
Declare Function add_piratebase() As Short
Declare Function distribute_stars() As Short

declare function empty_cages() as short
Declare Function makefinalmap(m As Short) As Short
Declare Function makecomplex(ByRef enter As _cords, down As Short,blocked As Byte=0) As Short
Declare Function makecomplex2(slot As Short,gc1 As _cords, gc2 As _cords, roundedcorners1 As Short,roundedcorners2 As Short,nocol1 As Short,nocol2 As Short,doorchance As Short,loopchance As Short,loopdoor As Short,adddoor As Short,addloop As Short,nosmallrooms As Short,culdesacruns As Short, t As Short) As Short
Declare Function makecomplex3(slot As Short,cn As Short, rc As Short,collums As Short,t As Short) As Short
Declare Function makecomplex4(slot As Short,rn As Short,tileset As Short) As Short
Declare Function makeplatform(slot As Short,platforms As Short,rooms As Short,translate As Short, adddoors As Short=0) As Short
Declare Function makelabyrinth(slot As Short) As Short
Declare Function invisiblelabyrinth(xoff As Short ,yoff As Short, _x As Short=10, _y As Short=10) As Short
Declare Function makeroots(slot As Short) As Short
Declare Function makeplanetmap(a As Short,orbit As Short, spect As Short) As Short
Declare Function modsurface(a As Short,o As Short) As Short
Declare Function makecavemap(enter As _cords,tumod As Short,dimod As Short, spemap As Short, froti As Short,blocked As Short=1) As Short
Declare Function togglingfilter(slot As Short, high As Short=1, low As Short=2)  As Short
Declare Function make_special_planet(a As Short) As Short
Declare Function make_drifter(d As _driftingship,bg As Short=0,broken As Short=0, f As Short=0) As Short
Declare Function make_civilisation(slot As Short, m As Short) As Short
Declare Function makeice(a As Short, o As Short) As Short
Declare Function makecanyons(a As Short, o As Short) As Short
Declare Function makegeyseroasis(slot As Short) As Short
Declare Function makecraters(a As Short, o As Short) As Short
Declare Function makemossworld(a As Short,o As Short) As Short
Declare Function makeislands(a As Short, o As Short) As Short
Declare Function makeoceanworld(a As Short,o As Short) As Short
Declare Function adaptmap(slot As Short) As Short
Declare Function addpyramid(p As _cords,slot As Short) As Short
Declare Function floodfill4(map() As Short,x As Short,y As Short) As Short
Declare Function add_door(map() As Short) As Short
Declare Function add_door2(map() As Short) As Short
Declare Function remove_doors(map() As Short) As Short
Declare Function addcastle(dest As _cords,slot As Short) As Short
Declare Function make_mine(slot As Short) As Short

Declare Function makemudsshop(slot As Short, x1 As Short, y1 As Short) As Short
Declare Function make_eventplanet(slot As Short,cl as byte=0) As Short
Declare Function station_event(m As Short) As Short
Declare Function makewhplanet() As Short
Declare Function makeoutpost (slot As Short,x1 As Short=0, y1 As Short=0) As Short
Declare Function makesettlement(p As _cords,slot As Short, typ As Short) As Short
Declare Function make_vault(r As _rect,slot As Short,nsp As _cords, typ As Short,ind As Short,entr as _cords) As Short
Declare Function rndwallpoint(r As _rect, w As Byte) As _cords
Declare Function rndwall(r As _rect) As Short
Declare Function digger(ByVal p As _cords,map() As Short,d As Byte,ti As Short=2,stopti As Short=0) As Short
Declare Function flood_fill(x As Short,y As Short,map()As Short, flag As Short=0) As Short
Declare Function flood_fill2(x As Short,y As Short, xm As Short, ym As Short, map() As Byte) As Short
Declare Function findsmartest(slot As Short) As Short
Declare Function makeroad(ByVal s As _cords,ByVal e As _cords, a As Short) As Short
Declare Function addportal(from As _cords, dest As _cords, twoway As Short, tile As Short,desig As String, col As Short) As Short
Declare Function deleteportal(f As Short=0, d As Short=0,x as short=-1,y as short=-1) As Short
Declare Function checkvalid(x As Short,y As Short, map() As Short) As Short
Declare Function floodfill3(x As Short,y As Short,map() As Short) As Short
Declare Function checkdoor(x As Short,y As Short, map() As Short) As Short
Declare Function checkbord(x As Short,y As Short, map() As Short) As Short
Declare Function playerfightfleet(f As Short) As Short
Declare Function is_drifter(m As Short) As Short
Declare Function is_special(m As Short) As Short
Declare Function get_nonspecialplanet(disc As Short=0) As Short
Declare Function gen_traderoutes() As Short
Declare Function clean_station_event() As Short

'pirates
Declare Function friendly_pirates(f As Short) As Short
Declare Function ss_sighting(i As Short) As Short
Declare Function make_weapon(a As Short) As _weap
Declare Function make_ship(a As Short) As _ship
Declare Function makemonster(a As Short, map As Short, forcearms As Byte=0) As _monster
'awayteam as _monster, map as short, spawnmask() as _cords,lsp as short,x as short=0,y as short=0, mslot as short=0) as _monster
Declare Function makecorp(a As Short) As _basis
Declare Function collide_fleets() As Short
Declare Function move_fleets() As Short
Declare Function make_fleet() As _fleet
Declare Function makepatrol() As _fleet
Declare Function makemerchantfleet() As _fleet
Declare Function makepiratefleet(modifier As Short=0) As _fleet
Declare Function update_targetlist()As Short
Declare Function bestpilotinfleet(f As _fleet) As Short
Declare Function add_fleets(target As _fleet, source As _fleet) As _fleet
Declare Function piratecrunch(f As _fleet) As _fleet
Declare Function clearfleetlist() As Short
Declare Function countfleet(ty As Short) As Short
Declare Function meet_fleet(f As Short)As Short
Declare Function debug_printfleet(f As _fleet) As String
Declare Function fleet_battle(ByRef red As _fleet,ByRef blue As _fleet) As Short
Declare Function getship(f As _fleet) As Short
Declare Function furthest(List() As _cords,last As Short, a As _cords,b As _cords) As Short

Declare Function makequestfleet(a As Short) As _fleet
Declare Function makealienfleet() As _fleet
Declare Function setmonster(enemy As _monster,map As Short,spawnmask()As _cords,lsp As Short,x As Short=0,y As Short=0,mslot As Short=0,its As Short=0) As _monster
Declare Function make_aliencolony(slot As Short,map As Short, popu As Short) As Short

Declare Function resolve_fight(f2 As Short) As Short
Declare Function decide_if_fight(f1 As Short,f2 As Short) As Short

Declare Function weapon_string() As String
Declare Function crew_text(c As _crewmember) As String

'highscore
Declare Function space_mapbmp() As Short


Declare Function explper() As Short
Declare Function money_text() As String
Declare Function exploration_text() As String
Declare Function mission_type() As String
Declare Function high_score(text As String) As Short
Declare Function post_mortemII(text As String) As Short
Declare Function score() As Integer
Declare Function get_death() As String

'cargotrade
Declare Function mudds_shop(si as short) As Short
Declare Function girlfriends(st As Short) As Short
Declare Function pay_bonuses(st As Short) As Short
Declare Function check_passenger(st As Short) As Short
Declare Function pirateupgrade() As Short
Declare Function customize_item() As Short
Declare Function findcompany(c As Short) As Short
Declare Function drawroulettetable() As Short
Declare Function towingmodules() As Short
Declare Function getshares(company As Short) As Short
Declare Function sellshares(company As Short,n As Short) As Short
Declare Function buyshares(company As Short,n As Short) As Short
Declare Function cropstock() As Short
Declare Function portfolio(x As Short,y As Short) As Short
Declare Function dividend() As Short
Declare Function getsharetype() As Short
Declare Function reroll_shops() As Short
Declare Function find_crew_type(t As Short) As Short
Declare Function used_ships(si as short,si2 as short) As Short

Declare Function hiring(st As Short, ByRef hiringpool As Short, hp As Short) As Short
Declare Function sort_crew() As Short
Declare Function shipupgrades(st As Short) As Short
Declare Function starting_turret() As _weap
Declare Function shipyard(where As Byte) As Short
Declare Function ship_inspection(price As Short) As Short

Declare Function buy_ship(st As Short,ds As String,pr As Short) As Short
Declare Function make_weap_helptext(w As _weap) As String

Declare Function ship_design(where As Byte) As Short
Declare Function custom_ships(where As Byte) As Short
Declare Function repair_hull(pricemod As Single=1) As Short
Declare Function refuel(st As Short,price As Single) As Short
Declare Function casino(staked As Short=0, st As Short=0) As Short
Declare Function play_slot_machine() As Short
Declare Function showprices(st As Short) As Short

Declare Function upgradehull(t As Short,ByRef s As _ship, forced As Short=0) As Short
Declare Function gethullspecs(t As Short,file As String) As _ship
Declare Function makehullbox(t As Short, file As String) As String
Declare Function company(st As Short) As Short
Declare Function merctrade(ByRef f As _fleet) As Short

Declare Function unload_f(f As _fleet, st As Short) As _fleet
Declare Function unload_s(s As _ship, st As Short) As _ship
Declare Function load_f(f As _fleet, st As Short) As _fleet
Declare Function load_s(s As _ship,goods As Short, st As Short) As Short
Declare Function trading(st As Short) As Short
Declare Function buygoods(st As Short) As Short
Declare Function sellgoods(st As Short) As Short
Declare Function recalcshipsbays() As Short
Declare Function stockmarket(st As Short) As Short
Declare Function displaywares(st As Short) As Short
Declare Function change_prices(st As Short,etime As Short) As Short
Declare Function getfreecargo() As Short
Declare Function getnextfreebay() As Short
Declare Function nextemptyc() As Short
Declare Function station_goods(st As Short,tb As Byte) As String
Declare Function cargobay(text As String,st As Short,sell As Byte=0) As String
Declare Function getinvbytype(t As Short) As Short
Declare Function removeinvbytype(t As Short, am As Short) As Short
Declare Function get_item_list(inv() As _items, invn()As Short, ty As Short=0,ty2 As Short=0,ty3 As Short=0,ty4 As Short=0,noequip As Short=0) As Short
Declare Function display_item_list(inv() As _items, invn() As Short, marked As Short, l As Short,x As Short,y As Short) As Short
Declare Function make_locallist(slot As Short) As Short

Declare Function sick_bay(si as short, st As Short=0,obe As Short=0) As Short
Declare Function first_unused(i As Short) As Short
Declare Function item_assigned(i As Short) As Short
Declare Function scroll_bar(Offset As Short,linetot As Short,lineshow As Short,winhigh As Short, x As Short,y As Short,col As Short) As Short
Declare Function next_item(c As Integer) As Integer
'Items
Declare Function check_item_filter(t As Short,f As Short) As Short
Declare Function item_filter() As Short
Declare Function equip_awayteam(m As Short) As Short
Declare Function removeequip() As Short
Declare Function lowest_by_id(id As Short) As Short
Declare Function findbest(t As Short,p As Short=0, m As Short=0,id As Short=0) As Short
Declare Function make_item(a As Short,mod1 As Short=0,mod2 As Short=0,prefmin As Short=0,nomod As Byte=0) As _items
Declare Function modify_item(i As _items, nomod As Byte) As _items
Declare Function placeitem(i As _items,x As Short=0,y As Short=0,m As Short=0,p As Short=0,s As Short=0) As Short
Declare Function get_item(ty As Short=0,ty2 As Short=0,ByRef num As Short=0,noequip As Short=0) As Short
Declare Function buysitems(desc As String,ques As String, ty As Short, per As Single=1,agrmod As Short=0) As Short
Declare Function giveitem(e As _monster,nr As Short) As Short
Declare Function changetile(x As Short,y As Short,m As Short,t As Short) As Short
Declare Function textbox(text As String,x As Short,y As Short,w As Short, fg As Short=11, bg As Short=0,pixel As Byte=0,ByRef op As Short=0,ByRef Offset As Short=0) As Short
Declare Function destroyitem(b As Short) As Short
Declare Function destroy_all_items_at(ty As Short, wh As Short) As Short
Declare Function calc_resrev() As Short
Declare Function count_items(i As _items) As Short
Declare Function findworst(t As Short,p As Short=0, m As Short=0) As Short
Declare Function rnd_item(t As Short) As _items
Declare Function getrnditem(fr As Short,ty As Short) As Short
Declare Function better_item(i1 As _items,i2 As _items) As Short
Declare Function list_artifacts(artflags() As Short) As String
Declare Function gen_shops() As Short

'math
Declare Function round_str(i As Double,c As Short) As String
Declare Function round_nr(i As Single,c As Short) As Single
Declare Function C_to_F(c As Single) As Single
Declare Function find_high(List() As Short,last As Short, start As Short=1) As Short
Declare Function find_low(List() As Short,last As Short,start As Short=1) As Short
Declare Function countdeadofficers(max As Short) As Short
Declare Function nearest_base(c As _cords) As Short
Declare Function sub0(a As Single,b As Single) As Single
Declare Function disnbase(c As _cords,weight As Short=2) As Single
Declare Function dispbase(c As _cords) As Single
Declare Function rnd_point(m As Short=-1,w As Short=-1, t As Short=-1,vege As Short=-1)As _cords
Declare Function rndrectwall(r As _rect,d As Short=5) As _cords
Declare Function fillmap(map() As Short,tile As Short) As Short
Declare Function fill_rect(r As _rect,t1 As Short, t2 As Short,map() As Short) As Short
Declare Function chksrd(p As _cords, slot As Short) As Short
Declare Function findrect(tile As Short,map()As Short, er As Short=0, fi As Short=60) As _rect
Declare Function content(r As _rect,tile As Short,map()As Short) As Integer
Declare Function distance(first As _cords, last As _cords,rollover As Byte=1) As Single
Declare Function rnd_range (first As Short, last As Short) As Short
Declare Function movepoint(ByVal c As _cords, a As Short, eo As Short=0,showstats As Short=0) As _cords
Declare Function pathblock(ByVal c As _cords,ByVal b As _cords,mapslot As Short,blocktype As Short=1,col As Short=0, delay As Short=100,rollover As Byte=0) As Short
Declare Function line_in_points(b As _cords,c As _cords,p() As _cords, rollover as short=1) As Short

Declare Function nearest(ByVal c As _cords, ByVal b As _cords,rollover As Byte=0) As Single
Declare Function farthest(c As _cords,b As _cords) As Single
Declare Function distributepoints(result() As _cords, ps() As _cords, last As Short) As Single
Declare Function getany(possible() As Short)As Short
Declare Function maximum(a As Double,b As Double) As Double
Declare Function minimum(a As Double,b As Double) As Double
Declare Function dominant_terrain(x As Short,y As Short,m As Short) As _cords
declare function get_hull(t as short) as _ship

Declare Function checkandadd(queue() As _pfcords,map() As Byte,in As Short) As Short
Declare Function add_p(queue() As _pfcords,p As _pfcords) As Short
Declare Function check(queue() As _pfcords, p As _pfcords) As Short
Declare Function nearlowest(p As _pfcords,queue() As _pfcords) As _pfcords
Declare Function gen_waypoints(queue() As _pfcords,start As _pfcords,goal As _pfcords,map() As Byte) As Short
Declare Function space_radio() As Short
'quest
Declare Function crew_bio(i As Short) As String
Declare Function find_passage_quest(m As Short, start As _cords, goal As _cords) As Short
Declare Function Find_Passage(m As Short, start As _cords, goal As _cords) As Short
Declare Function adapt_nodetext(t As String, e As _monster,fl As Short,qgindex As Short=0) As String
Declare Function do_dialog(no As Short,e As _monster, fl As Short) As Short
Declare Function node_menu(no As Short,node() As _dialognode, e As _monster, fl As Short,qgindex As Short=0) As Short
Declare Function dialog_effekt(effekt As String,p() As Short,e As _monster, fl As Short) As Short
Declare Function plant_name(ti As _tile) As String
Declare Function randomcritterdescription(enemy As _monster, spec As Short,weight As Short,movetype As Short,ByRef pumod As Byte,diet As Byte,water As Short,depth As Short) As _monster
Declare Function give_quest(st As Short) As Short
Declare Function bounty_quest_text() As String
Declare Function gen_bountyquests() As Short

Declare Function check_questcargo(st As Short) As Short
Declare Function reward_bountyquest(employer As Short) As Short

Declare Function getunusedplanet() As Short
Declare Function dirdesc(start As _cords,goal As _cords) As String
Declare Function rndsentence(e As _monster) As Short
Declare Function show_quests() As Short
Declare Function planet_bounty() As Short
Declare Function eris_does() As Short
Declare Function eris_doesnt_like_your_ship() As Short
Declare Function eris_finds_apollo() As Short

Declare Function low_morale_message() As Short
Declare Function es_part1() As String
Declare Function Crewblock() As String
Declare Function shipstatsblock() As String
Declare Function make_unflags(unflags() As Byte) As Short
Declare Function uniques(unflags() As Byte) As String
Declare Function talk_culture(c As Short) As Short
Declare Function foreignpolicy(c As Short, i As Byte) As Short
Declare Function first_lc(t As String) As String
Declare Function first_uc(t As String) As String


Declare Function text_to_html(text As String) As String

Declare Function hasassets() As Short
Declare Function sellassetts () As String
Declare Function es_title(ByRef pmoney As Single) As String
Declare Function es_living(ByRef pmoney As Single) As String
Declare Function system_text(a As Short) As String

Dim Shared As UInteger _fgcolor_,_bgcolor_

Declare Function set__color(fg As Short,bg As Short,visible As Byte=1) As Short
Declare Function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _tcol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    Dim c As UInteger
    c=Color
    If src=0 Then
        Return dest
    Else
        Return _fgcolor_
    EndIf
End Function

Declare Function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _col( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    If src=0 Then
        Return _bgcolor_
    Else
        Return _fgcolor_
    EndIf
End Function

Declare Function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger

Function _icol( ByVal src As UInteger, ByVal dest As UInteger, ByVal param As Any Ptr ) As UInteger
    'Itemcolor
    If src=0 Then
        Return Hiword(Color)
    Else
        Return Loword(Color)
    EndIf
End Function

#Define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#Define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#Define RGBA_B( c ) ( CUInt( c )        And 255 )

Function set__color(fg As Short,bg As Short,visible As Byte=1) As Short
    Dim As UInteger r,g,b
    If fg>255 Or bg>255 Or fg<0 Or bg<0 Then Return 0
    If visible=1 Then
        Color palette_(fg),palette_(bg)
    Else
        Color palette_(fg)/2,palette_(bg)/2
    EndIf
    _fgcolor_=palette_(fg)
    _bgcolor_=palette_(bg)
    If visible=0 Then
        r=RGBA_R(_fgcolor_)
        g=RGBA_G(_fgcolor_)
        b=RGBA_B(_fgcolor_)
        _fgcolor_=Rgb(r/2,g/2,b/2)

        r=RGBA_R(_bgcolor_)
        g=RGBA_G(_bgcolor_)
        b=RGBA_B(_bgcolor_)
        _bgcolor_=Rgb(r/2,g/2,b/2)
    EndIf
    Return 0
End Function

Function _monster.add_move_cost(modifier as short=0) As Short
    Dim As Short cost
    cost=(20-speed)*planets(player.map).grav
    cost+=tmap(c.x,c.y).movecost
    cost+=modifier
    If made=0 And player.tactic=2 Then cost-=1 '
    If cost<=0 Then cost=1
    e.add_action(cost)
    Return 0
End Function


function _index.del() as short
    erase vindex,last,value
    vlast=0
    return 0
end function

function _index.index(x as short,y as short,i as short) as short
    return value(vindex(x,y,i))
end function

function _index.add(v as short,c as _cords) as short
    last(c.x,c.y)+=1
    if last(c.x,c.y)>maxl then return -1
    vlast+=1
    if vlast>maxv then return -2
    vindex(c.x,c.y,last(c.x,c.y))=vlast
    cordindex(vlast).x=c.x
    cordindex(vlast).y=c.y
    value(vlast)=v
    return 0
end function

function _index.remove(v as short, c as _cords) as short
    dim as short j,j2
    for j=1 to last(c.x,c.y)
        if index(c.x,c.y,j)=v then
            value(vindex(c.x,c.y,j))=value(vlast)
            cordindex(vindex(c.x,c.y,j))=cordindex(vlast)
            vlast-=1
            vindex(c.x,c.y,j)=vindex(c.x,c.y,last(c.x,c.y))
            last(c.x,c.y)-=1
            exit for
        endif
    next
    return 0
end function

function _index.move(v as short,oc as _cords,nc as _cords) as short
    if _debug>0 then dprint last(oc.x,oc.y) &":"&last(nc.x,nc.y)
    remove(v,oc)
    add(v,nc)
    if _debug>0 then dprint last(oc.x,oc.y) &":"&last(nc.x,nc.y)
    return 0
end function

Type _commandstring
    t As String
    comdead As Byte
    comalive As Byte
    comportal As Byte
    comitem As Byte
    page As Byte
    lastpage As Byte
    Declare Function Reset() As Short
    Declare Function display(wl As Short) As Short
    Declare Function nextpage() As Short
End Type

Function _commandstring.nextpage() As Short
    page+=1
    If page>lastpage Then page=0
    Return 0
End Function

Function _commandstring.Reset() As Short
    t=""
    comdead=0
    comalive=0
    comportal=0
    comitem=0
    page=0
    Return 0
End Function


Function _commandstring.display(wl As Short) As Short
    Dim As String ws(40)
    Dim As Short last,b,start,room,needed
    If t="" Then Return 0
    last=string_towords(ws(),t,";")
    room=_lines-wl
    needed=last
    lastpage=needed/room
    If lastpage>1 Then
        start=(last/lastpage)*page
        last=(last/lastpage)*(page+1)
    EndIf
    If last>40 Then last=40
    If start>last Then start=last-room
    If start<0 Then start=0
    For b=start To last
        set__color(15,0)
        Draw String(sidebar,(b+wl-start)*_fh2),ws(b),,Font2,custom,@_col
    Next
    Return 0
End Function

dim shared lastteleportdevice as integer
dim shared teleportdevices(1024) as integer
Dim Shared comstr As _commandstring
