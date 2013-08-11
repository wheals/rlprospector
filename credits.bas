declare function credits(i as single) as string
declare function cords(c as _cords) as string

function credits(i as single) as string
    dim as string t,r,z(12)
    dim as single fra
    dim  as integer b=1000000
    dim as byte c,l
    t=t &abs(int(i))
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
