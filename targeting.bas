function _target.add(newtarget as _cords, newtvalue as short) as short
    return targets.add(newtvalue,newtarget)
end function

function _target.sort(center as _cords,rollover as short) as short
    dim as short i,j,flag
    do
    for i=1 to targets.vlast
        for j=1 to targets.vlast
            flag=0
            if i<>j then
                if distance(targets.cordindex(i),center,rollover)<distance(center,targets.cordindex(j),rollover) then
                    swap targets.cordindex(i),targets.cordindex(j)
                    swap targets.value(i),targets.value(j)
                    flag=1
                endif
            endif
        next
    next
    loop until flag=0
    return 0
end function

function _target.plusminus(key as string) as _cords
    if key="+" then ti+=1
    if key="-" then ti-=1
    if ti<1 then ti=targets.vlast
    if ti>targets.vlast then ti=1
    t=targets.cordindex(ti)
    return t
end function

function _target.move(key as string, rollover as byte) as _cords
    if key=key_north then t.y-=1
    if key=key_south then t.y+=1
    if key=key_west then  t.x-=1
    if key=key_east then  t.x+=1
    if key=key_nw then 
        t.x-=1
        t.y-=1
    endif
    if key=key_sw then 
        t.x-=1
        t.y+=1
    endif
    if key=key_ne then 
        t.x+=1
        t.y-=1
    endif
    if key=key_se then 
        t.x+=1
        t.y+=1
    endif
    if t.y<0 then t.y=0
    if t.y>20 then t.y=20
    if rollover=0 then
        if t.x<0 then t.x=0
        if t.x>60 then t.x=60
    else
        if t.x<0 then t.x=60
        if t.x>60 then t.x=0
    endif
    return t
end function