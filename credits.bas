declare function credits(i as integer) as string
declare function cords(c as _cords) as string
declare function display_time(t as uinteger,form as byte=0) as string

function display_time(t as uinteger,form as byte=0) as string
    dim as uinteger d,h,m
    dim as string ms,hs
    h=fix(t/60)
    d=fix(h/24)
    h=h-d*24
    m=t-h*60-d*24*60
    if h<10 then
        hs="0"& h
    else
        hs=""& h
    endif
    if m<10 then
        ms="0"&m
    else
        ms=""&m
    endif
    if form=0 then
        if d>0 then
            return "Day: "&d &", "& hs &":"&ms 
        else
            return  hs &":"&ms
        endif
    else
        return d &" days, "& h &" hours and "& m &" minutes"
    endif
end function

function credits(cr as integer) as string
    dim as string t,r,z(12)
    dim as single fra,tenmillion
    dim  as integer b=1000000
    dim as byte c,l,i
    for i=0 to 12
        
    next
    t="" &abs(int(cr))

    for b=1 to len(t)
        z(b)=mid(t,b,1)
    next
    l=len(t)
    t=""
    for b=1 to l
        t=t &z(b)
        if l-b=3 or l-b=6 or l-b=9 or l-b=12 then 
            t=t &","
        endif
    next
    if i<0 then t="-"&t
    return t
end function

function cords(c as _cords) as string
    return "("&c.x &":"& c.y &")"
end function

function round_str(i as double,c as short) as string
    dim as string t
    dim as single j
    dim as short digits
    t=""&round_nr(i,c)
    if instr(t,".")>0 then 
        digits=len(t)-instr(t,".")
    else
        t=t &"."
    endif
    if digits<c then t= t &string(c-digits,"0")
    return t
end function
