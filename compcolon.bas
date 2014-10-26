function colonize_planet(st as short) as short
    dim as short planet,debug,d
    dim as _cords p
    
    planet=get_com_colon_candidate(st)
    if planet>0 and score_planet(planet,st)+rnd_range(1,100)>500 then
        planets(planet).colflag(0)=basis(st).company
        p=rnd_point()
        planetmap(p.x,p.y,planet)=298+basis(st).company
        d=rnd_range(1,4)*2
        p=movepoint(p,d)
        if d=2 or d=8 then 
        planetmap(p.x,p.y,planet)=31
        else
        planetmap(p.x,p.y,planet)=32
        endif
        p=movepoint(p,d)
        planetmap(p.x,p.y,planet)=68
        if debug=1 and _debug=1 then dprint "Built colony at "& map(sysfrommap(planet)).c.x &":"&map(sysfrommap(planet)).c.y
    endif
    return 0
end function

function count_tiles(i as short,map as short) as short
    dim as short x,y,r
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,map))=i then r+=1
        next
    next
    return r
end function

function grow_colonies() as short
    dim  as short i,j
    for i=0 to laststar
        for j=1 to 9
            if map(i).planets(j)>0 then
                if planets(map(i).planets(j)).colflag(0)>0 then grow_colony(map(i).planets(j))
                if rnd_range(1,20)<3+planets(map(i).planets(j)).minerals then planets(map(i).planets(j)).flags(22)+=rnd_range(1,3+planets(map(i).planets(j)).minerals)
                if rnd_range(1,20)<planets(map(i).planets(j)).flags(22) then planets(map(i).planets(j)).flags(22)=0
            endif
        next
    next
    return 0
end function

function grow_colony(map as short) as short
    dim as _cords p,p2 
    dim as short dx,dy,list(16),build,comp,roll,debug
    debug=0
    comp=planets(map).colflag(0)
    list(2)=68 'Landing Pad
    list(3)=16 'Housing
    
    list(4)=262 'Mudds
    
    list(5)=69 'Recruiting
    list(6)=70 'Repair
    list(7)=71 'Fuel
    
    list(8)=70 'Ship Wepons
    list(9)=71 'Ship Yard
    list(10)=72 'Ship Yard2
    
    list(11)=74 'Trading Post
    list(12)=294 'Art trader
    list(13)=266 'Casino
    
    list(14)=261 'Hospital
    list(15)=294 'Art trader
    list(16)=268 'Zoo
    
    p=get_colony_building(map)
    p2=closest_building(p,map)
    planets(map).colflag(1)+=count_tiles(16,map)*10
    planets(map).colflag(1)+=count_tiles(68,map)*5
    planets(map).colflag(1)+=rnd_range(1,60)
    roll=rnd_range(1,100)
    if debug=1 and _debug=1 then dprint roll &":"& planets(map).colflag(1)
    if roll<planets(map).colflag(1) then
        if rnd_range(1,100)<66 then
            if planets(map).colflag(4)=0 then
                build=4
            else
                if planets(map).colflag(2)*2<planets(map).colflag(3) then
                    build=2 'Landing
                else
                    build=3 'House
                endif
            endif
        else
            select case comp
            case is=1 'Eridiani Explorations
                build=rnd_range(5,7)
            case is=2 'Smith Heavy Industries
                build=rnd_range(8,10)
            case is=3 'Triax Traders
                build=rnd_range(11,14)
            case is=4 'Omega Bioengineering
                build=rnd_range(14,16)
            end select
            
            if build>6 and planets(map).colflag(build)>0 then build=0
            if build>0 then 
                if p.x=-1 and p.y=-1 then 
                    dprint "No site found"
                    return 0
                end if
                
                planetmap(p.x,p.y,map)=list(build)
                planets(map).colflag(build)+=1
            endif
            dx=abs(p.x-p2.x)
            dy=abs(p.y-p2.y)
'            if dx>dy then
'                if p.x>p2.x then
'                    p.x-=1
'                    p2.x+=1
'                else
'                    p.x+=1
'                    p2.x-=1
'                endif
'            else
'                if p.y>p2.y then
'                    p.y-=1
'                    p2.y+=1
'                else
'                    p.y+=1
'                    p2.y-=1
'                endif
'            endif
            if p2.x>=0 and p2.y>=0 and p.x>=0 and p.y>=0 and p2.y<=20 and p.y<=20 and p2.x<=60 and p.x<=60 then
                makeroad(p,p2,map)
            endif
        endif
        planets(map).colflag(1)=0
    else
        if rnd_range(1,100)>planets(map).colflag(1) then
            remove_building(map)
        planets(map).colflag(1)+=5
        endif
    endif
    return 0
end function

function get_colony_building(map as short) as _cords
    dim p(255) as _cords
    dim as short x,y,x1,y1,i
    dim cand(60,20) as short
    p(255).x=-1
    p(255).y=-1
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                for x1=x-2 to x+2
                    for y1=y-2 to y+2
                        if x1>=0 and x1<=60 and y1>=0 and y1<=20 then
                            if x1=x-2 or x1=x+2 or y1=y-2 or y1=y+2 then
                                cand(x1,y1)=1
                            else
                                cand(x1,y1)=0
                            endif
                        endif
                    next
                next
            endif
        next
    next
    for x=0 to 60
        for y=0 to 20
            if cand(x,y)=1 and tiles(abs(planetmap(x,y,map))).walktru=0 and i<255 then 
                i+=1
                p(i).x=x
                p(i).y=y
            endif
        next
    next
    if i=0 then        
        for x=0 to 60
            for y=0 to 20
                if cand(x,y)=1 then 
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            next
        next
    endif
    
    if i=0 then return p(255)
    
    return p(rnd_range(1,i))
end function

function remove_building(map as short) as short
    dim as _cords p(255),c
    dim as short i,j
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then 
                if abs(planetmap(x,y,map))>=299 then
                    p(255).x=x
                    p(255).y=y
                else
                    i+=1
                    p(i).x=x
                    p(i).y=y
                endif
            endif
        next
    next
    if i>0 then 
        j=rnd_range(1,i)
     else
         j=255
         planets(map).colflag(0)=-1
     endif
     planetmap(p(j).x,p(j).y,map)=76
     return 0
 end function
 
         

function closest_building(p as _cords,map as short) as _Cords
    dim as short x,y,i,j
    dim as single d
    dim as _cords points(1281),result
    for x=0 to 60
        for y=0 to 20
            if isbuilding(x,y,map)=-1 then
                i+=1
                points(i).x=x
                points(i).y=y
            endif
        next
    next
    d=9999
    for j=1 to i
        if distance(p,points(j))<d and (points(j).x<>p.x or points(j).y<>p.y) then
            d=distance(p,points(j))
            result=points(j)
        endif
    next
    return result
end function

function isbuilding(x as short,y as short,map as short) as short
    
    
    if abs(planetmap(x,y,map))=16 then return -1
    if abs(planetmap(x,y,map))=68 then return -1
    if abs(planetmap(x,y,map))=69 then return -1
    if abs(planetmap(x,y,map))=70 then return -1
    if abs(planetmap(x,y,map))=71 then return -1
    if abs(planetmap(x,y,map))=72 then return -1
    if abs(planetmap(x,y,map))=74 then return -1
    if abs(planetmap(x,y,map))=98 then return -1
    if abs(planetmap(x,y,map))=237 then return -1
    if abs(planetmap(x,y,map))=238 then return -1
    if abs(planetmap(x,y,map))=261 then return -1
    if abs(planetmap(x,y,map))=262 then return -1
    if abs(planetmap(x,y,map))=266 then return -1
    if abs(planetmap(x,y,map))=268 then return -1
    if abs(planetmap(x,y,map))=294 then return -1
    if abs(planetmap(x,y,map))=299 then return -1
    if abs(planetmap(x,y,map))=300 then return -1
    if abs(planetmap(x,y,map))=301 then return -1
    if abs(planetmap(x,y,map))=302 then return -1
    return 0
end function


function get_com_colon_candidate(st as short) as short
    dim as short a,b,c,i,lastcandidate,sys,pla,plascore,block
    dim as short candidate(laststar),sysscore(laststar)
    for a=0 to laststar
        block=-1
        for b=1 to 9
            if map(a).planets(b)>0 then
                for c=0 to _NOPB
                    if map(a).planets(b)=piratebase(c) then block=1
                next
                if is_special(map(a).planets(b))=-1 then block=1
                if planets(map(a).planets(b)).colflag(0)<>0 then block=1
                if planets(map(a).planets(b)).mapstat<>0 and block=-1 then block=0
            endif
            
        next
        if block=0 then
            i+=1
            candidate(i)=a
        endif
    next
    lastcandidate=i
    for i=1 to lastcandidate
        sysscore(i)=score_system(candidate(i),st)
        if sysscore(i)>sysscore(0) then
            sysscore(0)=sysscore(i)
            candidate(0)=candidate(i)
        endif
    next
    sys=candidate(0)
    pla=-1
    for i=1 to 9
        if score_planet(map(sys).planets(i),st)>plascore then
            plascore=score_planet(map(sys).planets(i),st)
            pla=map(sys).planets(i)
        endif
    next
    
    return pla
end function

function score_system(s as short,st as short) as short
    dim as short sscore,i 
    sscore=(1000-distance(map(s).c,basis(st).c)^2)/1000
    for i=1 to 9 
        sscore+=score_planet(map(s).planets(i),st)
    next
    return sscore
end function 

function score_planet(i as short,st as short) as short
    dim pscore as short
    if i>0 then
        if is_special(i) then 
            pscore-=100
        else
            if is_gardenworld(i) then pscore+=1000
            if basis(st).company=1 or basis(st).company=3 then 
                if is_gardenworld(i) then pscore+=1000
            endif
            if basis(st).company=2 then pscore+=planets(i).minerals*100
            if basis(st).company=4 then pscore+=planets(i).life*50
        endif
    else
        pscore=-10
    endif
    return pscore
end function
