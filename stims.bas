type _stim
    flag as byte
    delta as short
    time as short
    value as short
    low as short
    declare function tick() as short
    declare function effect() as short
    declare function set(v1 as short) as short
end type

function _stim.set(v1 as short) as short
    value=v1
    low=-v1/2
    if low<-10 then low=-10
    delta=-1
    time=0
    return 0
end function

function _stim.tick() as short
    if time>=0 then
        if time=abs(effect) or effect=0 then 
            time=0
            value+=delta
            if effect=low then delta=1
            if effect=0 and delta=1 then 
                time=-1
                return 0
            endif 
        endif
        time+=1
    endif
    return 0
end function

function _stim.effect() as short
    if value>19 then return 19
    if value<-10 then return -10
    return value
end function

type _stims
    stim(25) as _stim
    laststim as byte
    declare function add(i as short,awhp as short) as short
    declare function tick() as short
    declare function effect() as short
    declare function clear() as short
end type

function _stims.add(i as short,awhp as short) as short
    dim as single ratio,value
    if awhp=0 then return -1
    if laststim>24 then return -1
    laststim+=1
    ratio=item(i).v2/awhp
    if ratio>1 then ratio=1
    item(i).v2-=awhp
    if ratio<0 then
        value=item(i).v1*ratio
        item(i).v2=0
        if value<item(i).v1/2 then value=item(i).v1/2
    else
        value=item(i).v1
    endif
    stim(laststim).set(value)
    return 0
end function

function _stims.tick() as short
    dim as short i,flag
    if laststim<=0 then return 0
    for i=1 to laststim
        stim(i).tick
    next
    if laststim<=1 then return 0
    do
        flag=0
        for i=1 to laststim-1
            if stim(i).time=-1 then 
                flag=1
                stim(i)=stim(i+1)
                laststim-=1
            endif
        next
    loop until flag=0 or laststim<=1
    return 0
end function

function _stims.effect() as short
    dim as short eff,i
    for i=1 to laststim
        eff+=stim(i).effect
    next
    if eff<-10 then eff=-10
    if eff>19 then eff=19
    if _debug=2008 then dprint "EFF:"&eff
    return eff
end function

function _stims.clear() as short
    dim as short i
    for i=1 to laststim
        stim(i)=stim(0)
    next
    return 0
end function
 

dim shared stims as _stims

'
'#include "fbgfx.bi"
'screen 17
'
'dim i as short
'dim as _stims stim=23,stim2=23
'do 
'    i+=1
'    stim.tick
'    pset (i,stim.effect+50) 
'    locate 1,5
'    print stim.effect;"DELTA";stim.delta;"VALUE";stim.value;"LOW:"&stim.low
'    sleep 10
'loop until stim.time=-1
'sleep
'
'i=0
'do  
'    i+=1
'    stim2.tick
'    pset (i,stim2.effect+75) 
'loop until stim2.time=-1
'sleep