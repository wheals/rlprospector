declare function credits(i as integer) as string

function credits(i as integer) as string
    dim as string t,r,z(12)
    dim as single fra
    dim  as integer b=1000000
    dim as byte c,l
    t=t &i
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
    return t
end function
