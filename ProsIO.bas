

function earthquake(t as _tile,dam as short)as _tile
    dim roll as short
    if t.shootable=1 then
        t.hp=t.hp-dam
        if t.hp<=0 then t=tiles(t.turnsinto)
    endif
    if t.no<41 and t.no<>1 and t.no<>2 and t.no<>26 and t.no<>20 and t.no<>21 then
        if t.no=6 or t.no=5 then t=tiles(3)
        if t.no=7 or t.no=8 and rnd_range(1,100)<33+dam then t=tiles(4)
        if t.no=20 and rnd_range(1,100)<33+dam then t=tiles(rnd_range(1,2))
        if rnd_range(1,100)<15 and t.no<>18 then t=tiles(47)
    endif
    return t
end function


function ep_display(awayteam as _monster, vismask()as byte, enemy() as _monster,byref lastenemy as short, li()as short,byref lastlocalitem as short,byref slot as short, byref walking as short) as short
    dim as short a,b,x,y
    dim as cords p
    if disease(awayteam.disease).bli>0 then 
        x=awayteam.c.x
        y=awayteam.c.y
        vismask(x,y)=1
        dtile(x,y,tmap(x,y),vismask(x,y))
        return 0
    endif
    ' Stuff on ground    
    
        makevismask(vismask(),awayteam,slot)        
        for x=awayteam.c.x-2-awayteam.sight to awayteam.c.x+2+awayteam.sight 
            for y=awayteam.c.y-2-awayteam.sight to awayteam.c.y+2+awayteam.sight
                if x>=0 and x<=60 and y>=0 and y<=20 then
                    p.x=x
                    p.y=y
                    'if awayteam.sight>cint(distance(awayteam.c,p)) then
                    if planetmap(x,y,slot)>0 then dtile(x,y,tmap(x,y))
                endif
            next
        next
        
                                                
        makevismask(vismask(),awayteam,slot)        
        for x=awayteam.c.x-2-awayteam.sight to awayteam.c.x+2+awayteam.sight 
            for y=awayteam.c.y-2-awayteam.sight to awayteam.c.y+2+awayteam.sight
                if x>=0 and x<=60 and y>=0 and y<=20 then
                    p.x=x
                    p.y=y
                    'if awayteam.sight>cint(distance(awayteam.c,p)) then
                    if vismask(x,y)>0 and awayteam.sight>cint(distance(awayteam.c,p)) then 
                        if planetmap(x,y,slot)<0 then 
                            planetmap(x,y,slot)=planetmap(x,y,slot)*-1
                            reward(0)=reward(0)+1
                            reward(7)=reward(7)+planets(slot).mapmod
                            if tiles(planetmap(x,y,slot)).stopwalking>0 then walking=0
                            if player.questflag(9)=1 and planetmap(x,y,slot)=100 then player.questflag(9)=2
                        endif
                        if rnd_range(1,100)<disease(awayteam.disease).hal or (slot=specialplanet(28) and specialflag(28)=0) then
                            dtile(x,y,tiles(rnd_range(1,255)))
                            planetmap(x,y,slot)=planetmap(x,y,slot)*-1 
                        else
                            dtile(x,y,tmap(x,y),vismask(x,y))
                        endif
                    endif
                endif
            next
        next
        
        for a=0 to lastportal
            if portal(a).from.m=slot then
                p.x=portal(a).from.x
                p.y=portal(a).from.y
                if (vismask(portal(a).from.x,portal(a).from.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or portal(a).discovered=1 then
                    if portal(a).discovered=0 then walking=0
                    portal(a).discovered=1
                    locate portal(a).from.y+1,portal(a).from.x+1,0
                    color portal(a).col,0
                    print chr(portal(a).tile)
                        
                endif
            endif
            if portal(a).oneway=0 then
                if portal(a).dest.m=slot then
                    p.x=portal(a).dest.x
                    p.y=portal(a).dest.y
                    if (vismask(portal(a).dest.x,portal(a).dest.y)>0 and awayteam.sight>cint(distance(awayteam.c,p))) or portal(a).discovered=1 then
                        locate portal(a).dest.y+1,portal(a).dest.x+1,0
                        color portal(a).col,0
                        print chr(portal(a).tile)
                        if portal(a).discovered=0 then walking=0
                        portal(a).discovered=1                        
                    endif    
                endif
            endif
        next
        
        for a=1 to lastlocalitem
            if item(li(a)).w.m=slot and item(li(a)).w.s=0 and item(li(a)).w.p=0 then
                p.x=item(li(a)).w.x
                p.y=item(li(a)).w.y
                if (vismask(item(li(a)).w.x,item(li(a)).w.y)>0 and tiles(abs(planetmap(p.x,p.y,slot))).hides=0 and awayteam.sight>cint(distance(awayteam.c,p))) or item(li(a)).discovered=1 then
                    if item(li(a)).discovered=0 then walking=0
                    item(li(a)).discovered=1
                    if tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).walktru>0 and item(li(a)).bgcol=0 then
                        color item(li(a)).col,tiles(abs(planetmap(item(li(a)).w.x,item(li(a)).w.y,slot))).col
                    else
                        color item(li(a)).col,item(li(a)).bgcol
                    
                    endif
                        
                    locate item(li(a)).w.y+1,item(li(a)).w.x+1
                    if _tiles=0 then
                        if item(li(a)).ty<>15 then
                            put (item(li(a)).w.x*8,item(li(a)).w.y*16),gtiles(item(li(a)).ty+200),trans
                        else                                
                            put (item(li(a)).w.x*8,item(li(a)).w.y*16),gtiles(item(li(a)).v2+250),trans
                        endif
                    else
                        print item(li(a)).icon
                    endif
                 endif
            endif
        next
        
        for a=1 to lastenemy
            if enemy(a).hp<=0 then
                p=enemy(a).c
                if p.x>=0 and p.x<=60 and p.y>=0 and p.y<=20 then
                    if vismask(p.x,p.y)>0 and awayteam.sight>cint(distance(awayteam.c,p)) then
                        locate p.y+1,p.x+1
                        color 12,0
                        if _tiles=0 then
                            if enemy(a).hpmax>0 then put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(270),trans
                        else
                            if enemy(a).hpmax>0 then print "%"
                        endif
                    endif
                endif
            endif
        next
        
        for a=1 to lastenemy
            if enemy(a).hp>0 then
                p=enemy(a).c
                if p.x>=0 and p.x<=60 and p.y>=0 and p.y<=20 then                
                    if vismask(p.x,p.y)>0 and awayteam.sight>cint(distance(awayteam.c,p)) then
                        locate p.y+1,p.x+1
                        color enemy(a).col,0
                        if enemy(a).invis=0 then
                            if _tiles=0 then
                                put (enemy(a).c.x*8,enemy(a).c.y*16),gtiles(enemy(a).sprite),trans
                            else
                                print chr(enemy(a).tile)
                            endif
                            walking=0
                            
                        endif
                    endif
                endif
            endif                    
        next
        
    return 0
end function

function maxsecurity() as short
    dim as short b,total
    total=player.h_maxcrew+player.crewpod+player.cryo-5
    for b=6 to 128
        if crew(b).hp>0 then total-=1
    next
    return total
end function

function skillcheck(targetnumber as short,skill as short, modifier as short) as short
    'skill
    '1 Pilot
    '2 Gunner
    '3 Science
    '4 Doctor
    dim as short skillvalue
    if rnd_range(1,6)+rnd_range(1,6)+skillvalue+modifier>targetnumber then
        return -1
    else
        return 0
    endif
end function

function addtalent(cr as short, ta as short, value as single) as single
    dim total as short
    if cr>0 then
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 then return value*crew(cr).talents(ta)
    else
        value=0
        for cr=1 to 128
            if crew(cr).hp>0 and crew(cr).onship=0 and crew(cr).talents(ta)>0 then 
                total+=1
                value=value+crew(cr).talents(ta)
            endif
        next
        if total=0 then return 0
        value=value/total
        return value
    endif
    return 0
end function
    
function changemoral(value as short, where as short) as short
    dim a as short
    for a=2 to 128
        if crew(a).hp>0 and crew(a).onship=where then crew(a).morale=crew(a).morale+value
    next
    return 0
end function


function showteam(from as short) as short
    dim as short b,p,offset,bg,last,a
    dim n as string
    dim skills as string
    for b=1 to 128
        if crew(b).hpmax>0 then last+=1
    next
    p=1
    do
        color 11,0
            
        cls
        
        if no_key=key_enter then
            if from=0 then
                if p>1 then
                    if crew(p).onship=0 then 
                        crew(p).onship=1
                    else
                        crew(p).onship=0
                    endif
                else
                    locate 22,1
                    color 14,0
                    print "The captain must stay in the awayteam."
                    locate 1,1
                endif
            else
                locate 22,1
                color 14,0
                print "You need to be at the ship to reassign."
                locate 1,1
            endif
        endif
        
        for b=1 to 8
            if b=p+offset then
                bg=5
            else
                bg=0
            endif
            if b-offset>0 then  
                if crew(b-offset).hpmax>0 then
                    skills=""
                    for a=1 to 25
                        if crew(b-offset).talents(a)>0 then 
                            if skills<>"" then 
                                skills=skills &", "&talent_desig(a)&"("&crew(b-offset).talents(a)&")"
                            else
                                skills=talent_desig(a)&"("&crew(b-offset).talents(a)&")"
                            endif
                        endif
                    next
                    if skills<>"" then skills=skills &" "
                    color 15,bg
                    if b-offset>9 then
                        print b-offset;" ";
                    else
                        print " ";b-offset;" ";
                    endif
                    if crew(b-offset).hp>0 then
                        if b-offset>5 then
                            color 10,bg
                            print crew(b-offset).icon;
                        else
                            if b-offset=1 then print "Captain";
                            if b-offset=2 then print "Pilot  ";
                            if b-offset=3 then print "Gunner ";
                            if b-offset=4 then print "Science";
                            if b-offset=5 then print "Doctor ";
                        endif
                    else
                        color 12,0
                        print "X";
                    endif
                    
                    color 15,bg
                    if crew(b-offset).hp=0 then color 12,bg
                    if crew(b-offset).hp<crew(b-offset).hpmax then color 14,bg
                    if crew(b-offset).hp=crew(b-offset).hpmax then color 10,bg
                    print " ";crew(b-offset).hpmax;
                    color 15,bg
                    print "/";
                    if crew(b-offset).hp=0 then color 12,bg
                    if crew(b-offset).hp<crew(b-offset).hpmax then color 14,bg
                    if crew(b-offset).hp=crew(b-offset).hpmax then color 10,bg
                    print crew(b-offset).hp;
                    color 15,bg
                    print " ";crew(b-offset).n;
                    if crew(b-offset).onship=1 and crew(b-offset).hp>0 then
                        color 14,bg
                        print "  On ship ";
                    endif
                    if crew(b-offset).onship=0 and crew(b-offset).hp>0 then
                        color 10,bg
                        print " Awayteam ";
                    endif
                    if crew(b-offset).hp<=0 then
                        color 12,bg
                        print " Dead ";
                    endif
                    color 15,bg
                    if crew(b-offset).xp>=0 then 
                        print " XP:" &crew(b-offset).xp;
                    else
                        print " XP: -";
                    endif
                    print space(70-pos)
                    color 15,bg
                    print "   ";
                    if crew(b-offset).armo>0 then 
                        color 15,bg
                        print " ";trim(item(crew(b-offset).armo).desig);", ";
                    else
                        color 14,bg
                        print " None,";
                    endif
                    if crew(b-offset).weap>0 then 
                        color 15,bg
                        print " ";trim(item(crew(b-offset).weap).desig);", ";
                    else
                        color 14,bg
                        print " None,";
                    endif
                    if crew(b-offset).blad>0 then 
                        color 15,bg
                        print " ";trim(item(crew(b-offset).blad).desig);" ";
                    else
                        color 14,bg
                        print " None";
                    endif
                    color 11,bg
                    if crew(b-offset).jp>0 then print " Jetpack";
                    print space(70-pos)
                    
                    color 15,bg
                    print "   ";
                    print skills;
                    if crew(b-offset).disease>0 then
                        color 14,bg
                        print "Suffers from "&trim(disease(crew(b-offset).disease).desig);
                    endif
                    print space(70-pos)
                    
                    color 11,bg
                endif
            endif
        next
        color 11,0
        locate 25,1
        print key_rename &" to rename a member, enter to add/remove from awaytem";
        no_key=keyin
        if keyplus(no_key) or no_key="2" then p+=1
        if keyminus(no_key) or no_key="8" then p-=1
        if no_key=key_rename then
            if p<6 then
                n=gettext(18,(p-1+offset)*3,16,n)
            else
                n=gettext(12,(p-1+offset)*3,16,n)
            endif
            if n<>"" then crew(p).n=n
            n=""
        endif
        if p<1 then p=1
        if p>last then p=last
        if p+offset>8 then offset=8-p
        if p+offset<1 then offset=1-p
        
    loop until no_key=key_esc or no_key=" "
    return 0
end function

function removemember(n as short, f as short) as short
    dim as short a,s,todo
    
    if f=0 then s=6
    if f=1 then s=2
    for a=128 to s step-1
        if crew(a).hp>0 and todo<n then
            crew(a).hp=0
            todo+=1
        endif
    next
    return 0
end function


function addmember(a as short) as short
    dim as short slot,b,f,c,cc
    dim _del as _crewmember
    dim as string n(200,1)
    dim as short ln(1)
    f=freefile
    open "data\crewnames.txt" for input as #f
    do
        ln(cc)+=1
        line input #f,n(ln(cc),cc)
        if n(ln(cc),cc)="####" then
            ln(0)-=1
            cc=1
        endif
        
    loop until eof(f) or ln(0)>=199 or ln(1)>=199
    close #f
    'find empty slot
    for b=128 to 6 step -1
        if crew(b).hp<=0 then slot=b
    next
    if a<6 then slot=a
    if slot>0 then
        
        crew(slot)=_del
        if rnd_range(1,100)<80 then
            crew(slot).n=n((rnd_range(1,ln(1))),1)&" "&n((rnd_range(1,ln(0))),0)
        else
            crew(slot).n=n((rnd_range(1,ln(1))),1)&" "&CHR(rnd_range(65,87))&". "&n((rnd_range(1,ln(0))),0)
        endif
        crew(slot).morale=100+(Wage-10)^3*(5/100)
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gaintalent(slot)
        if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).talents(rnd_range(1,25))=1
        'crew(slot).disease=rnd_range(1,17)
        if a=1 then 'captain
            crew(slot).hpmax=6
            crew(slot).hp=6
            crew(slot).icon="C"
            crew(slot).typ=1
        endif
        if a=2 then 'Pilot
            crew(slot).hpmax=player.pilot+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="P"
            crew(slot).typ=2
            crew(slot).paymod=player.pilot*player.pilot
        endif
        if a=3 then 'Gunner
            crew(slot).hpmax=player.gunner+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="G"
            crew(slot).typ=3
            crew(slot).paymod=player.gunner*player.gunner
        endif
        if a=4 then 'SO
            crew(slot).hpmax=player.science+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="S"
            crew(slot).typ=4
            crew(slot).paymod=player.science^2
        endif
        if a=5 then 'doctor
            crew(slot).hpmax=player.doctor+1
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="D"
            crew(slot).typ=5
            crew(slot).paymod=player.doctor^2
        endif
        if a=6 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=6
            crew(slot).paymod=1
            'crew(slot).disease=rnd_range(1,16)
        endif    
        if a=7 then 'vet
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=7
            crew(slot).paymod=1
        endif
        if a=8 then 'elite
            crew(slot).hpmax=4
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="@"
            crew(slot).typ=8
            crew(slot).paymod=1
        endif
        if a=9 then 'insect warrior
            crew(slot).hpmax=5
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="I"
            crew(slot).typ=9
            crew(slot).paymod=1
            crew(slot).n=ucase(chr(rnd_range(97,122)))
            crew(slot).xp=-1
            for c=0 to rnd_range(1,6)+3
                crew(slot).n=crew(slot).n &chr(rnd_range(97,122))
            next
            crew(slot).morale=25000
        endif
        if a=10 then 'cephalopod
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="Q"
            crew(slot).typ=10
            crew(slot).paymod=0
            crew(slot).xp=-1
            crew(slot).n=ucase(chr(rnd_range(97,122)))
            for c=0 to rnd_range(1,6)+3
                crew(slot).n=crew(slot).n &chr(rnd_range(97,122))
            next
            crew(slot).morale=25000
        endif
        if a=11 then
            crew(slot).equips=1
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="d"
            crew(slot).typ=11
            crew(slot).paymod=0
            crew(slot).n="Neodog"
            crew(slot).xp=-1
            crew(slot).morale=25000
        endif
        if a=12 then
            crew(slot).equips=0
            crew(slot).hpmax=3
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="a"
            crew(slot).typ=12
            crew(slot).paymod=0
            crew(slot).n="Neoape"
            crew(slot).xp=-1
            crew(slot).morale=25000
        endif
        if a=13 then
            crew(slot).equips=1
            crew(slot).hpmax=6
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="R"
            crew(slot).typ=13
            crew(slot).paymod=0
            crew(slot).n="Robot"
            crew(slot).xp=-1
            crew(slot).morale=25000
        endif
    endif     
    return 0
end function    

function cureawayteam(where as short) as short
    dim as short bonus,pack,cured,sick,a
    dim as string text
    if where=0 then 'On planet=0 On Ship=1
        if _chosebest=0 then
            pack=findbest(19,-1)
        else
            pack=getitem()
            if item(pack).ty<>19 then
                dprint "You can't use that",14,14
                pack=-1
            endif
        endif
        if pack>0 then
            dprint "Using "&item(pack).desig &".",10,10
            bonus=item(pack).v1
            destroyitem(pack)
        else
            bonus=-3
        endif
    else
        bonus=findbest(21,-1)+3
    endif
    
    for a=0 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and (crew(a).onship=where or where=1) then
            if crew(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+bonus+player.doctor+addtalent(5,16,1)>5+crew(a).disease/2 then
                crew(a).disease=0
                crew(a).onship=0
                cured+=1
            endif
            if crew(a).disease>0 then sick+=1
        endif
    next
    if cured>1 then dprint cured &" members of your crew where cured.",10,10
    if cured=1 then dprint cured &" member of your crew was cured.",10,10
    if cured=0 and sick>0 then dprint "No members of your crew where cured.",14,14
    if sick>0 then dprint sick &" are still sick.",14,14
    return 0
end function


function healawayteam(byref a as _monster,heal as short) as short
    dim as short b,c,ex,fac,h
    static reg as single
    static doc as single
    for b=1 to a.hpmax
        if crew(b).hp>0 and crew(b).hp<crew(b).hpmax then ex=ex+1
        diseaserun(b)
    next
    fac=findbest(24,-1)
    
    if fac>0 then
        if item(fac).v1>0 then reg=reg+0.1
    endif
    if player.doctor>0 and crew(5).onship=0 then
       doc=doc+player.doctor/25+addtalent(5,17,.1)
    endif
    if heal>0 then heal=heal+player.doctor+addtalent(5,18,3)
    if reg>=1 then 
        heal=heal+reg
        reg=0
        h=1
    endif
    if doc>=1 then
        if rnd_range(1,6)+rnd_range(1,6)+player.doctor>10 then
            heal=heal+doc
            h=1
        endif
        doc=0
    endif
    do
    ex=0
        for b=1 to a.hpmax
            if heal>0 and crew(b).hp<crew(b).hpmax and crew(b).hp>0 then
                heal=heal-1
                if h=1 then h=2
                crew(b).hp=crew(b).hp+1
                ex=ex+1
            endif
        next
    loop until heal=0 or ex=0
    if player.doctor>0 and crew(5).onship=0 and h=2 then
        dprint "The doctor fixes some cuts and bruises"
    endif
    if fac>0 and h=2 then 
        dprint "the nanobots heal your wounded"
        item(fac).v1=item(fac).v1-1
    endif
    hpdisplay(a)
    return heal
end function

function infect(a as short,dis as short) as short
    dim as short roll
    roll=rnd_range(1,6)+rnd_range(1,6)+player.doctor
    if roll<maximum(3,dis) and crew(a).hp>0 and crew(a).hpmax>0 then
        crew(a).disease=dis
        crew(a).duration=disease(dis).duration
        if dis>player.disease then player.disease=dis
        dprint "A crew member was infected with "&disease(dis).desig &"!",12,12
    endif
    return 0
end function

function diseaserun(onship as short) as short
    dim as short a,dam,total,affected,dis,dead,distotal
    dim text as string
    for a=2 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and crew(a).disease>0 then
            if crew(a).duration>0 then 
                if crew(a).duration=disease(crew(a).disease).duration then dprint "A crewmember gets sick.",14,14
                crew(a).duration-=1
                if crew(a).duration=0 then crew(a).disease=0
                if crew(a).duration>0 then
                    dam=rnd_range(0,abs(disease(crew(a).disease).dam))
                    if dam>0 then
                        crew(a).hp=crew(a).hp-dam
                        if crew(a).hp<=0 then 
                            crew(a).hp=0
                            crew(a).disease=0
                            dead+=1
                        endif
                        total=total+dam
                        affected+=1
                    endif
                endif
                if crew(a).duration=0 then
                    if rnd_range(1,100)<disease(crew(a).disease).fatality then
                        if crew(a).onship=onship then dprint "A crewmember dies of disease.",12,12
                        crew(a)=crew(0)
                        crew(a).disease=0
                    else
                        if crew(a).onship=onship then dprint " A crewmember recovers.",10,10
                        crew(a).disease=0
                    endif
                endif
            endif
        endif
        if a=2 and crew(a).hp<=0 and player.pilot>0 then 
            player.pilot=captainskill
            dead-=1
            dprint " Your pilot dies of disease!",12,12
        endif
        if a=3 and crew(a).hp<=0 and player.gunner>0 then 
            player.gunner=captainskill
            dead-=1
            dprint " Your gunner dies of disease!",12,12
        endif
        if a=4 and crew(a).hp<=0 and player.science>0 then 
            player.science=captainskill
            dead-=1
            dprint " Your science officer dies of disease!",12,12
        endif
        if a=5 and crew(a).hp<=0 and player.doctor>0 then 
            player.doctor=captainskill
            dprint " Your doctor dies of disease!",12,12
        endif
        if crew(a).disease>dis then dis=crew(a).disease
    next
    player.disease=dis
    if total=1 then dprint " A crewmember suffer "& total &" damage from disease.",14,14
    if total>1 then dprint affected &" crewmembers suffer "& total &" damage from disease.",14,14
    if dead=1 then dprint " A crewmember dies from disease.",12,12
    if dead>1 then dprint dead &" crewmembers die from disease.",12,12
    return 0
end function

function damawayteam(byref a as _monster,dam as short, ap as short=0,disease as short=0) as string
    dim text as string
    dim as short ex,b,t,last,armeff,reequip
    dim target(128) as short
    dim stored(128) as short
    dim injured(12) as short
    dim killed(12) as short
    dim desc(12) as string
    desc(1)="Captain"
    desc(2)="Pilot"
    desc(3)="Gunner"
    desc(4)="Science officer"
    desc(5)="Ships doctor"
    desc(6)="Sec. member"
    desc(7)="Sec. member"
    desc(8)="Sec. member"
    desc(9)="Insect warrior"
    desc(10)="Cephalopod"
    desc(11)="Neodog"
    desc(12)="Neoape"
    'ap=1 Ignores Armor
    'ap=2 All on one, carries over
    'ap=3 All on one, no carrying over
    if abs(player.tactic)=2 and dam>2 then dam=dam-player.tactic
    if dam<0 then dam=1
    for b=1 to 128
        if crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0 then
            last+=1
            target(last)=b
            stored(last)=crew(b).hp
        endif
    next    
    do
        t=rnd_range(1,last)
        if crew(target(t)).hp>0 then
            if ap=2 then
                dam=dam-crew(target(t)).hp
                crew(target(t)).hp=dam
            endif
            if ap=3 then
                crew(target(t)).hp=crew(target(t)).hp-dam
                dam=0
            endif
            if ap=0 or ap=1 then
                if rnd_range(1,20)>2+a.secarmo(target(t))+player.tactic*(1+addtalent(3,10,1))+addtalent(t,20,1) or ap=1 then
                    crew(target(t)).hp=crew(target(t)).hp-1
                    dam=dam-1
                else
                    armeff+=1
                endif
            endif
        endif
        ex=1
        for b=1 to last
            if crew(target(b)).hp>0 then ex=0
        next 
    loop until dam<=0 or ex=1
    for b=1 to last
        if stored(b)>crew(target(b)).hp then
            if crew(target(b)).hp<=0 then
                killed(crew(target(b)).typ)+=1
                reequip=1
            else
                injured(crew(target(b)).typ)+=1
            endif
        endif
    next
    
    for b=1 to 8
        if injured(b)>0 then
            if injured(b)>1 then
                text=text &injured(b) &" "&desc(b)&"s injured. "
            else
                text=text &desc(b)&" injured. "
            endif
        endif
    next
    for b=1 to 8
        player.deadredshirts=player.deadredshirts+killed(b)
        if killed(b)>0 then
            if killed(b)>1 then
                text=text &killed(b) &" "&desc(b)&"s killed. "
            else
                text=text &desc(b)&" killed. "
            endif
            changemoral(-3*killed(b),0)
        endif
    next
    if armeff>0 then text=text &armeff &" prevented by armor"
    hpdisplay(a)
    if killed(2)>0 then player.pilot=captainskill
    if killed(3)>0 then player.gunner=captainskill
    if killed(4)>0 then player.science=captainskill
    if killed(5)>0 then player.doctor=captainskill
    if reequip=1 then equipawayteam(player,a,-1)
    return trim(text)
end function


''function damawayteam(byref a as _monster,dam as short, ap as short=0,disease as short=0) as string
'    dim as short b,c,r1,lastunhit,hit,last,hurt,killed,hp,y,x
'    dim unhit(128) as short
'    dim atstore(128) as short
'    dim text as string
'    dim as short capfla,pilfla,gunfla,scifla,armeff
'    
'    
'    for b=1 to 128
'        if crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0 then
'            last=+1
'            atstore(last)=b
'        endif
'    next
'    if abs(player.tactic)=2 and dam>2 then dam=dam-player.tactic
'    do
'        lastunhit=0
'        for b=1 to last
'            if crew(b).hp>0 then
'                lastunhit=lastunhit+1
'                unhit(lastunhit)=b
'            endif
'        next
'        
'        if lastunhit>0 then
'            hit=rnd_range(1,last)
'            
'            r1=unhit(rnd_range(1,lastunhit))
'            if ap=0 then dam=dam-1
'            if ap=1 then dam=dam-1
'            if ap=1 then crew(r1).hp-=1                
'            if ap=2 then dam=dam-crew(r1).hp
'            if ap=3 then dam=0
'            if rnd_range(1,12)>2+a.secarmo(r1)+player.tactic then
'                if ap=0 then crew(r1).hp-=1
'                if ap=2 then crew(r1).hp=0
'                if ap=3 then crew(r1).hp=0
'                if dis>0 and rnd_range(1,100)<dis*2 then infect(r1,dis)
'            else
'                armeff=armeff+1
'            endif
'        endif
'    loop until dam=0 or lastunhit=0
'    if armeff>0 then text=text &"(" & armeff &" damage prevented by armor) "
'    
'    if atstore(1)>0 and crew(1).hp=0 then
'        text=text &"The captain is down!"
'        a.hp=a.hp-1
'    endif
'    if atstore(1)>crew(1).hp and crew(1).hp>0 then text=text &"Captain wounded! "
'    if atstore(2)>0 and crew(2).hp=0 then 
'        text=text &"Pilot killed! "
'        player.pilot=-5
'        a.hp=a.hp-1
'        player.deadredshirts=player.deadredshirts+1
'    endif
'    if atstore(2)>crew(2).hp and crew(2).hp>0 then text=text &"Pilot wounded! "
'    
'    if atstore(3)>0 and crew(3).hp=0 then 
'        text=text &"Gunner killed! "
'        player.gunner=-5
'        a.hp=a.hp-1
'        player.deadredshirts=player.deadredshirts+1
'    endif
'    if atstore(3)>crew(3).hp and crew(3).hp>0 then text=text &"gunner wounded! "
'    
'    if atstore(4)>0 and crew(4).hp=0 then 
'        text=text &"Science officer killed! "
'        player.science=-5
'        a.hp=a.hp-1
'        player.deadredshirts=player.deadredshirts+1
'    endif
'    if atstore(4)>crew(4).hp and crew(4).hp>0 then text=text &"Science officer wounded! "
'    if atstore(5)>0 and crew(5).hp=0 then 
'        text=text &"Ship doctor killed! "
'        player.doctor=-5
'        a.hp=a.hp-1
'        player.deadredshirts=player.deadredshirts+1
'    endif
'    if atstore(5)>crew(5).hp and crew(5).hp then text=text &"Ships doctor wounded! "
'    
'    for b=6 to a.hpmax
'        if atstore(b)>0 and crew(b).hp=0 then killed=killed+1
'        if atstore(b)>crew(b).hp and crew(b).hp>0 then hurt=hurt+1
'    next
'    player.deadredshirts=player.deadredshirts+killed
'    if hurt>0 then  text=text & hurt &" wounded "
'    if killed>0 then 
'        text=text & killed &" killed "
'        equipawayteam(player,a,-1)
'    endif
'    text=trim(text)
'    text=text &"!"
'    
'    hpdisplay(a)
'    return text
'end function
'
function hpdisplay(a as _monster) as short
    dim as short hp,b,c,x,y
    hp=0
    a.hpmax=0
    a.hp=0
    for b=1 to 128
        if crew(b).hpmax>0 and crew(b).onship=0 then a.hpmax+=1
        if crew(b).hp>0 and crew(b).onship=0  then a.hp+=1
        if crew(b).hp>0 and crew(b).onship=0 then hp=hp+1
    next
    
    color 15,0
    locate 1,63
    print "Status ";
    color 11,0
    print "(";
    print using "##:";a.hpmax;
    if a.hp/a.hpmax<.7 then color 14,0
    if a.hp/a.hpmax<.4 then color 12,0
    print using "##";a.hp;
    color 11,0
    print ")"
   
    for y=2 to 6
        locate y,63
        for x=1 to 15
            c=c+1
            if crew(c).hpmax>0 and crew(c).onship=0 then
                if crew(c).hp>0  then
                    color 14,0
                    if crew(c).hp=crew(c).hpmax then color 10,0
                    print crew(c).icon;       
                else
                    color 12,0
                    print "X";
                endif
            endif
        next
    next
    return 0
end function

function gainxp(slot as short) as short
    if crew(slot).hp>0 and crew(slot).xp>=0 then crew(slot).xp+=1
    return 0
end function
    
function gaintalent(slot as short) as string
    dim text as string
    dim roll as short
    ' roll for talent
    roll=rnd_range(1,25)
    ' check if can have it
    if roll<=6 and slot=1 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
        if roll=1 then
            captainskill=captainskill+1
        endif
        'haggler
        'confident
        'charming
        'gambler
        'merchant
    endif
    
    if roll>=7 and roll<=9 and slot=2 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>=10 and roll<=12 and slot=3 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>=13 and roll<=15 and slot=3 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>=16 and roll<=18 and slot=4 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>18 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    if roll=19 then crew(slot).hpmax+=1
    return text
end function


function levelup(p as _ship) as _ship
    dim a as short
    dim vet as short
    dim elite as short
    dim text as string
    dim roll as short
    dim secret as short
    dim target as short
    dim _del as _crewmember
    
    dim lev(128) as byte
    for a=1 to 128
        if crew(a).hp>0  then
            roll=rnd_range(1,crew(a).xp)
            if roll>5+crew(a).hp^2 and crew(a).xp>0 then
                lev(a)+=1
            'else
             '   dprint "Rolled "&roll &", needed "&5+crew(a).hp^2,14,14
            endif
            if a>1 then
                if rnd_range(1,100)>crew(a).morale+addtalent(1,4,10) then
                    if a=2 then 
                        text =text &" Pilot "&crew(a).n &" retired."
                        player.pilot=captainskill
                    endif
                    if a=3 then 
                        text =text &" Gunner "&crew(a).n &" retired."
                        player.gunner=captainskill
                    endif
                    if a=4 then 
                        text =text &" Science Officer "&crew(a).n &" retired."
                        player.science=captainskill
                    endif
                    if a=5 then 
                        text =text &" Doctor "&crew(a).n &" retired."
                        player.doctor=captainskill
                    endif
                    if a>5 then secret+=1
                    crew(a).hp=0
                    lev(a)=0
                endif
            endif
        endif
    next
    if secret>1 then text=text &" " & secret &" of your security personal retired."
    if text<>"" then dprint text,10,10
    text=""
    if lev(1)=1 then
        if rnd_range(1,100)<crew(1).xp*4 then
            'add talent
            text=text &gaintalent(1)
            crew(1).xp=0
        endif
    endif
    if p.pilot>0 and p.pilot<=5 and lev(2)=1 then
        p.pilot+=1
        crew(2).hpmax+=1
        text=text &" Your pilot is now skill "&p.pilot &"."
        if rnd_range(1,100)<crew(2).xp*3 then text=text &gaintalent(2)
        crew(2).xp=0
    endif
    if p.gunner>0 and p.gunner<=5 and lev(3)=1 then
        p.gunner+=1
        crew(3).hpmax+=1
        text=text &" Your gunner is now skill "&p.gunner &"."
        if rnd_range(1,100)<crew(3).xp*3 then text=text &gaintalent(3)
        crew(3).xp=0
    endif
    if p.science>0 and p.science<=5 and lev(4)=1 then
        p.science+=1
        crew(4).hpmax+=1
        text=text &" Your science officer is now skill "&p.science &"."
        if rnd_range(1,100)<crew(4).xp*3 then text=text &gaintalent(4)
        crew(4).xp=0
    endif
    if p.doctor>0 and p.doctor<=5 and lev(5)=1 then
        p.doctor+=1
        crew(5).hpmax+=1
        text=text &" Your doctor is now skill "&p.doctor &"."
        if rnd_range(1,100)<crew(5).xp*3 then text=text &gaintalent(5)
        crew(5).xp=0
    endif
    for a=6 to 128
        if crew(a).hp>0 and lev(a)=1 and crew(a).typ>=6 and crew(a).typ<=7 then
            crew(a).hpmax+=1
            crew(a).typ+=1
            if rnd_range(1,100)<crew(a).xp*3 then text=text &gaintalent(a)
            crew(a).xp=0
            if crew(a).typ=7 then 
                vet+=1
            endif
            if crew(a).typ=8 then
                elite+=1
            endif
        endif
    next
    if vet=1 then
        for a=6 to 128
            if lev(a)=1 and crew(a).typ=7 then text=text &crew(a).n &" is now a veteran."
        next
    endif
    if elite=1 then
        for a=6 to 128
            if lev(a)=1 and crew(a).typ=8 then text=text &crew(a).n &" is now elite."
        next
    endif
    if vet>1 then text=text &" "&vet &" of your security are now veterans."
    if elite>1 then text=text &" "&elite &" of your security are now veterans."
    if text<>"" then dprint text,10,10
    displayship()
    '    'dprint "P:"&p.skillmarks(1) &" G:" &p.skillmarks(2) & " S:"&p.skillmarks(3)
'    if p.pilot>0 then
'        roll=rnd_range(1,100)\(p.pilot+1)
'        target=33
'        if p.pilot<6 and p.skillmarks(1)>0 then
'            if roll<p.pilot then
'                dprint "your pilot retired",14,14
'                p.pilot=-5
'                roll=0
'                crew(2).hpmax=0
'                crew(2).hp=0
'            endif
'            if roll+p.skillmarks(1)>target and roll>1 then
'                p.pilot=p.pilot+1
'                dprint "your pilot is now skill level "&p.pilot,10,10 
'                addmember(2)
'            endif
'        endif
'    endif
'    
'    if p.gunner>0 then
'        roll=rnd_range(1,100)\(p.gunner+1)
'        target=33
'        if p.gunner<6 and p.skillmarks(2)>0 then
'            if roll<p.gunner then
'                dprint "your gunner retired",14,14
'                p.gunner=-5
'                crew(3).hpmax=0
'                crew(3).hp=0
'                roll=0
'            endif
'            if roll+p.skillmarks(2)>target and roll>1 then
'                p.gunner=p.gunner+1
'                dprint "your gunner is now skill level "&p.gunner,10,10 
'                addmember(3)
'            endif
'        endif
'    endif
'    
'    if p.science>0 then
'        roll=rnd_range(1,100)\(p.science+1)
'        target=33
'        if p.science<6 and p.skillmarks(3)>0 then
'            if roll<p.science then
'                dprint "your science officer retired",14,14
'                p.science=-5
'                crew(4).hpmax=0
'                crew(4).hp=0
'                roll=0
'            endif
'            if roll+p.skillmarks(3)>target and roll>1 then
'                p.science=p.science+1
'                dprint "your science officer is now skill level "&p.science,10,10 
'                addmember(4)
'            endif
'        endif
'    endif
'    if p.doctor>0 then
'        roll=rnd_range(1,100)\(p.doctor+1)
'        target=33
'        if p.doctor<6 and p.skillmarks(4)>0 then
'            if roll<p.doctor then
'                dprint "your ships doctor retired",14,14
'                p.doctor=-5
'                crew(5).hpmax=0
'                crew(5).hp=0
'                roll=0
'            endif
'            if roll+p.skillmarks(4)>target and roll>1 then
'                p.doctor+=1
'                dprint "your ships doctor is now skill level "&p.doctor,10,10 
'                addmember(5)
'            endif
'        endif
'    endif
'    if p.security>0 then
'        for a=6 to 6+p.security
'            roll=rnd_range(1,100)+p.skillmarks(5)
'            if roll>25*crew(a).hpmax then
'                if crew(a).hpmax<5 and p.skillmarks(5)>0 then
'                    crew(a).hpmax+=1
'                    crew(a).hp=crew(a).hpmax
'                    if crew(a).hp=4 then 
'                        elite=elite+1
'                        p.skillmarks(5)=p.skillmarks(5)-20
'                    endif
'                    if crew(a).hp=3 then 
'                        vet=vet+1
'                        p.skillmarks(5)=p.skillmarks(5)-10
'                    endif
'                endif
'            endif
'        next
'      
'        if elite=1 then text= "one of your security force is now elite "
'        if vet=1 then text=text & " one of your security force is now a veteran " 
'        if elite>1 then text=elite &" of your security force are now elite "
'        if vet>1 then text=text &vet &" of your security force are now veterans " 
'        if text<>"" then dprint text,10,10
'    endif
'    for a=1 to 5
'        p.skillmarks(a)=0
'    next
    
    
    return p
end function

function dplanet(p as _planet,orbit as short,scanned as short) as short
    dim a as short
    dim text as string
    locate 22,1,0
    color 11,1
    for a=1 to 61
        locate 22,a,0
        print CHR(196)
    next
    for a=1 to 25
        locate a,62,0,0
        print CHR(179);
    next
    locate 22,62,0
    print chr(180)    
    color 15,0
    locate 1,63
    print "Scanning Results:"
    color 11,0
    locate 2,63 
    print "Planet in orbit " & orbit
    locate 3,63
    print scanned &" km2 scanned"
    locate 5,63 
    print p.water &"% Liq. Surface"
    text=atmdes(p.atmos) &" atmosphere"
    locate 7,63
    if len(text)<17 then 
        print text
    else
        textbox(text,63,7,16,11,0)    
    endif
    locate 12,63
    print "Gravity:"&p.grav &" g"
    locate 14,63
    print "Avg. Temperature"
    locate 16,63
    print using "####.#";p.temp;
    print " "&chr(248)&"c"
    locate 18,63
    print "Rot.:";
    if p.rot>0 then
        print using "####.#";p.rot*24;
        print " h"
    else
        print " Nil"
    endif
    locate 20,63
    print "Lifeforms:"
    locate 21,64
    print p.life*10 &" % probability"
    return 0
end function

function blink(byval p as cords) as short
    locate p.y+1,p.x+1
    
    if timer>zeit then
        zeit=timer+0.5
        color 11,11
        print " ";
    else
        color 11,11
        print " ";
    endif
    return 0
end function

function cursor(target as cords,map as short) as string
    dim key as string 
    
    blink(target)    
    key=keyin
    'dprint ""&planetmap(target.x,target.y,map)
    locate target.y+1,target.x+1
    if planetmap(target.x,target.y,map)<0 then
        color 0,0
        print " "
    else
        dtile(target.x,target.y,tiles(planetmap(target.x,target.y,map)))
    endif
    target=movepoint(target,getdirection(key))
    return key
end function


function mondis(enemy as _monster) as string
    dim text as string
    if enemy.hp<=0 then text=text &"A dead "
    text=text &enemy.ldesc
    if enemy.hpmax=enemy.hp then
        text=text &" unhurt"
    else
        if enemy.hp>0 then
            if enemy.hp<2 then
                text=text &" badly hurt"
            else
                text=text &" hurt"
            endif
        endif
    endif
    if enemy.stuff(9)=0 then
    if rnd_range(1,6)+rnd_range(1,6)+player.science>9 then enemy.stuff(10)=1
    if rnd_range(1,6)+rnd_range(1,6)+player.science>10 then enemy.stuff(11)=1
    if rnd_range(1,6)+rnd_range(1,6)+player.science>11 then enemy.stuff(12)=1
    enemy.stuff(9)=enemy.stuff(10)+enemy.stuff(11)+enemy.stuff(12)
    endif
    if enemy.stuff(10)=1 then text=text &"(" &enemy.hpmax &"/" &enemy.hp &")"
    if enemy.stuff(11)=1 then text=text &" W:" &enemy.weapon
    if enemy.stuff(12)=1 then text=text &" A:" &enemy.armor
    if enemy.hp>0 and enemy.aggr=0 then text=text &". it is attacking!"
    return text
end function

sub show_stars(bg as short=0)
    dim as short a,x,y,navcom,mask
    dim as cords p,p1,p2
    dim range as integer
    dim as single dx,dy,l,x1,y1,vis
    dim m as _monster
    dim vismask(sm_x,sm_y) as byte
    player.osx=player.c.x-30
    player.osy=player.c.y-10
    if player.osx<=0 then player.osx=0
    if player.osy<=0 then player.osy=0
    if player.osx>=sm_x-60 then player.osx=sm_x-60
    if player.osy>=sm_y-20 then player.osy=sm_y-20
    m.sight=player.sensors+5.5
    m.c=player.c
    makevismask(vismask(),m,-1)
    navcom=findbest(52,-1)
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then vismask(x,y)=1
        next
    next
    
    if bg=1 then
        for x=0 to 60
            for y=0 to 20
                locate y+1,x+1,0
                color 1,0
                if spacemap(x+player.osx,y+player.osy)=1 and navcom>0 then 
                    if _tiles=0 then
                        put (x*8+1,y*16+1),gtiles(11),pset
                    else
                        print ".";
                    endif
                endif
                if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then 
                    if _tiles=0 then
                        put (x*8+1,y*16+1),gtiles(9),pset
                    else                        
                        color rnd_range(48,59),1
                        if spacemap(x+player.osx,y+player.osy)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(48,59),1
                        if spacemap(x+player.osx,y+player.osy)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(96,107),1
                        if spacemap(x+player.osx,y+player.osy)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(144,155),1
                        if spacemap(x+player.osx,y+player.osy)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(192,203),1
                        print chr(176); 
                    endif
                endif
            next
        next
    endif
    color 1,0
    for x=player.c.x-10 to player.c.x+10
        for y=player.c.y-10 to player.c.y+10
            if x-player.osx>=0 and y-player.osy>=0 and x-player.osx<=60 and y-player.osy<=20 and x>=0 and y>=0 and x<=sm_x and y<=sm_y then
                p.x=x
                p.y=y
                if vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then 
                    if spacemap(x,y)=0 and navcom>0 then spacemap(x,y)=1
                    if spacemap(x,y)=-2 then spacemap(x,y)=2
                    if spacemap(x,y)=-3 then spacemap(x,y)=3
                    if spacemap(x,y)=-4 then spacemap(x,y)=4
                    if spacemap(x,y)=-5 then spacemap(x,y)=5
                endif
                    
                'locate y+1-player.osy,x+1-player.osx,0
                'if vismask(x,y)>0 then print "1";
                
                locate y+1-player.osy,x+1-player.osx,0
                color 1,0
                if abs(spacemap(x,y))=1 and navcom>0 and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5  then
                    if _tiles=1 then
                        print ".";
                    else
                        put ((x-player.osx)*8+1,(y-player.osy)*16+1),gtiles(11),pset
                    endif
                endif
                if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5  and vismask(x,y)>0  and distance(p,player.c)<player.sensors+0.5 then 
                    if _tiles=1 then
                        color rnd_range(48,59),1
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(48,59),1
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(96,107),1
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(144,155),1
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(192,203),1
                        print chr(176); 
                    else                        
                        put ((x-player.osx)*8+1,(y-player.osy)*16+1),gtiles(9),pset
                    endif
                endif
            endif
        next
    next


    a=findbest(51,-1)
    if a>0 then
        for x=1 to lastfleet
            locate fleet(x).c.y+1-player.osy,fleet(x).c.x+1-player.osx,0
            if vismask(fleet(x).c.x,fleet(x).c.y)=1 and distance(player.c,fleet(x).c)<player.sensors then
                color 11,0 
                if item(a).v1=1 then
                    color 11,0 
                    print "s"
                else
                    if fleet(x).ty=1 or fleet(x).ty=3 then color 10,0
                    if fleet(x).ty=2 or fleet(x).ty=4 then color 12,0
                    print "s"
                endif
            else
                color 1,0
                if navcom>0 then 
                   if spacemap(fleet(x).c.x,fleet(x).c.y)=1 then print ".";
                else
                   if spacemap(fleet(x).c.x,fleet(x).c.y)>=2 and spacemap(fleet(x).c.x,fleet(x).c.y)<=5 then
                       color rnd_range(9,14),1
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(48,59),1
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(96,107),1
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(144,155),1
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(192,203),1
                        print chr(176); 
                   else
                        print " ";
                   endif
                endif
            endif
        next
    endif
    for x=0 to lastdrifting
        if drifting(x).x<0 then drifting(x).x=0
        if drifting(x).y<0 then drifting(x).y=0
        if drifting(x).x>sm_x then drifting(x).x=sm_x
        if drifting(x).y>sm_y then drifting(x).y=sm_y
        p.x=drifting(x).x
        p.y=drifting(x).y
        
        if planets(drifting(x).m).flags(0)=0 then
            color 7,0
            if (a>0 and vismask(p.x,p.y)=1 and distance(player.c,p)<player.sensors) or drifting(x).p>0 then
                if p.x+1-player.osx>0 and p.x+1-player.osx<61 and p.y+1-player.osy>0 and p.y+1-player.osy<21 then 
                    locate p.y+1-player.osy,p.x+1-player.osx
                    print "s"
                    drifting(x).p=1
                endif
            endif
        endif
    next
    
    color 11,0
    for a=1 to lastcom
        if coms(a).c.x>player.osx and coms(a).c.x<player.osx+60-len(coms(a).t) and coms(a).c.y>player.osy and coms(a).c.y<player.osy+20 then
            locate coms(a).c.y+1-player.osy,coms(a).c.x+1-player.osx
            print coms(a).t 
        endif
    next
    
    for a=0 to laststar+wormhole
        if map(a).spec<>8 then
            vis=maximum(player.sensors+.5,(map(a).spec)-2)
        else
            vis=0
        endif
            
        if (vismask(map(a).c.x,map(a).c.y)=1 and distance(map(a).c,player.c)<=vis) or map(a).discovered>0 then 
             displaystar(a)
        endif
    next
    
    for a=0 to 2
        if basis(a).discovered>0 then displaystation(a)
    next
    
end sub

function settactics() as short
    dim as short a
    dim text as string
    screenshot(1)
    text="Tactics:/"
    for a=1 to 5
        if a=player.tactic+3 then
            text=text &" *"&tacdes(a)&"   "
        else
            text=text &"  "&tacdes(a)&"   "
        endif
        text=text &"/"
    next
    text=text &"Exit"
    a=menu(text,,,,1)
    if a<6 then 
        player.tactic=a-3
    endif
    screenshot(2)
    return 0
end function

function screenshot(a as short) as short
    static scrn(80,25,2) as integer
    dim as short x,y,f,b
    dim as integer bg,fg,col
    dim as string fname
    dim row as wstring*80
    'a=0 screen in file drucken
    'a=1 screen in scrn speichern
    'a=2 screen aus scrn ausgeben
    if _tiles=0 then
        if a=0 then dprint "Screenshots in graphics mode not possible."
        if a=1 then get(0,0)-(600,300),scr
        if a=2 then put (0,0),scr,pset
    else        
        if a=0 or a=1 then
            for x=1 to 80
                for y=1 to 25
                    scrn(x,y,0)=screen(y,x)
                    col = Screen(y,x,1)
                    scrn(x,y,1) = col And &HFF
                    scrn(x,y,2) = (col Shr 8) And &HFF
                next
            next
        endif
        
        if a=0 then
            'find filename
            do
                b=b+1
                fname="scrn"& b &".txt"
            loop until not(fileexists(fname)) or b>255
            f=freefile
            open fname for output as #f
            for y=1 to 25
                row=""
                for x=1 to 80
                    
                        row=row &chr850(scrn(x,y,0))
                    
                next
                print #f,row
            next
            close #f
            dprint "screenshot saved as "&fname
        endif
        
        if a=2 then
            for y=1 to 25
                for x=1 to 80
                    fg=scrn(x,y,1)
                    bg=scrn(x,y,2)
                    locate y,x,0
                    color fg,bg
                    print chr(scrn(x,y,0));
                next
            next
        endif
    endif
    color 11,0
    return 0
end function

function awayteamsetup() as short
    dim as short a
    dim text as string
    do
        text="Awayteam Setup:/"
        if crew(2).onship=0 then 
            text=text &" * Pilot/"
        else
            text=text &"   Pilot/"
        endif
        if crew(3).onship=0 then
            text=text &" * Gunner/"
        else
            text=text &"   Gunner/"
        endif
        if crew(4).onship=0 then
            text=text &" * Science officer/"
        else
            text=text &"   Science officer/"
        endif
        if crew(5).onship=0 then
            text=text &" * Ships doctor/"
        else
            text=text &"   Ships doctor/"
        endif
        text=text &"Exit"
        a=menu(text)
        if a<5 then
            if crew(a+1).onship=1 then
                crew(a+1).onship=0 
            else
                crew(a+1).onship=1
            endif
        endif        
    loop until a=5
    return 0
end function

function logbook() as short
    cls
    dim lobk(5,20) as string
    dim lobn(5,20) as short
    static curs as cords
    dim as short x,y,a,p,m,lx
    dim key as string
    for a=0 to laststar
        if map(a).desig<>"" then
            if map(a).spec<8 or map(a).discovered>1 then
                lobk(x,y)=trim(map(a).desig)
                lobn(x,y)=a
                y=y+1
                if y>20 then
                    y=0
                    x=x+1
                endif
            endif
        endif
    next
    lx=x
    do
        cls
        displayship(1)
        for x=0 to 5
            for y=0 to 20
                locate y+1,(x*12)+1
                if x=curs.x and y=curs.y then
                    color 15,3
                else
                    color 11,0
                endif
                if lobk(x,y)<>"" then
                    print lobk(x,y)
                else
                    print "  "
                endif
            next
        next
        if map(lobn(curs.x,curs.y)).discovered>1 then 
            displaysystem(map(lobn(curs.x,curs.y))) 
        else
            dprint "Only long range data"
        endif
        key=keyin
        if key=key_enter and map(lobn(curs.x,curs.y)).discovered>1 then
            p=getplanet(lobn(curs.x,curs.y))
            m=map(lobn(curs.x,curs.y)).planets(p)
            if m>0 then
                if planetmap(0,0,m)=0 then
                    cls
                    displayship(1)
                    locate 10,15
                    color 15,0
                    print"No map data for this planet"
                    no_key=keyin
                else
                    cls
                    dplanet(planets(m),p,planets(m).mapped)
                    displayplanetmap(m)
                    no_key=keyin
                endif
            endif
        endif
                
        curs=movepoint(curs,getdirection(key))
        if curs.x>lx then curs.x=lx
        if curs.y>20 then curs.y=20
    loop until key=key_esc or player.dead<>0
    return 0
end function


function manual() as short
    dim as integer f,offset,c,a,lastspace
    dim lines(512) as string
    dim col(512) as short
    dim as string key,text
    dim evkey as EVENT
    screenshot(1)
    cls
    f=freefile
    if (open ("readme.txt" for input as #f))=0 then
        do
            line input #f,lines(c)
            while len(lines(c))>80
                text=lines(c)
                lastspace=80
                do 
                    lastspace=lastspace-1
                loop until mid(text,lastspace,1)=" "
                lines(c)=left(text,lastspace)
                lines(c+1)=mid(text,lastspace+1,(len(text)-lastspace+1))
                c=c+1
            wend
            c=c+1
            
        loop until eof(f) or c>512
        close #f
        for a=1 to c
            col(a)=11
            if left(lines(a),2)="==" then
                col(a)=7
                col(a-1)=14
            endif
            'if left(lines(a),1)="*" then col(a)=14
        next
        do
            key=""
            cls
            color 11,0
            for a=1 to 24
                locate a,1
                color col(a+offset),0
                print lines(a+offset);
            next
            locate 25,15
            color 14,0
            print "Arrow down and up to browse, esc to exit";
            key=keyin("12346789 ",,1)
            if keyplus(key) or key="8" then offset=offset-22
            if keyminus(key) or key="2" then offset=offset+22
            if offset<0 then offset=0
            if offset>488 then offset=488
        loop until key=key_esc or key=" "
    else
        locate 10,10 
        print "Couldnt open readme.txt"
    endif
    cls
    while inkey<>""
    wend
    screenshot(2)
    return 0
end function

function messages() as short
    dim a as short
    screenshot(1)
    cls
    for a=1 to 25
        locate a,1 
        color dtextcol(a),0
        print displaytext(a);
    next
    do
        screenevent(@evkey)
    loop until evkey.type<>1
    sleep 100
    no_key=keyin(,,1)
    cls
    screenshot(2)
    return 0
end function

function keyin(byref allowed as string="" , byref walking as short=0,blocked as short=0)as string
    dim key as string
    dim as short a,b,i,tog1,tog2,tog3,tog4,ctr,f,it
    if walking<>0 then sleep 50
    flip
    
    do 
     do        
      If (ScreenEvent(@evkey)) Then
          Select Case evkey.type
          Case EVENT_KEY_PRESS
             select case evkey.scancode
              case sc_down
                 key = key_south
              case sc_up
                 key = key_north
              case sc_left
                 key = key_west
              case sc_right
                 key = key_east
              case sc_home
                 key = key_nw
              case sc_pageup
                 key = key_ne
              case sc_end
                 key = key_sw
              case sc_pagedown
                 key = key_se
              case sc_escape
                 key=key_esc
              case sc_enter
                 key=key_enter
              case else
                 key = chr(evkey.ascii)
              end select
           end select
           if evkey.type=13 then key=key_quit
          end if
         sleep 1
        loop until key<>"" or walking<>0 or (allowed="" and player.dead<>0) or just_run=1
        
        
        if key<>"" then walking=0 
        if blocked=0 then
            if key=key_manual then 
                manual
            endif
            if key=key_screenshot then 
                screenshot(0)
            endif
            if key=key_messages then 
                messages
            endif
            if key=key_configuration then
                configuration
            endif
            if key=key_tactics then
                settactics
            endif
            if key=key_shipstatus then         
                screenshot(1)
                shipstatus()
                screenshot(2)
            endif
            if key=key_logbook then
                screenshot(1)
                logbook
                screenshot(2)
            endif
            if key=key_weapons then
                it=getitem
                if it>0 then dprint item(it).ldesc
            endif
            if key=key_quests then
                screenshot(1)
                showquests
                screenshot(2)
            endif
        endif
        if key=key_autoinspect then
            select case _autoinspect
                case is =0
                    _autoinspect=1
                    dprint "Autoinspect Off"
                case is =1
                    _autoinspect=0
                    dprint "Autoinspect On"                
            end select
            key=""     
        endif
        if key=key_autopickup then
            select case _autopickup
                case is =0
                    _autopickup=1
                    dprint "Autopickup Off"
                case is =1
                    _autopickup=0
                    dprint "Autopickup On"                
            end select
            key=""     
        endif                
        if key=key_quit then 
            if askyn("do you really want to quit? (y/n)") then player.dead=6
        endif
        
        if key="P" and show_npcs then
            dprint "Pirateagression:" &player.pirate_agr &" " &"Merchantagression:"&player.merchant_agr
            input "pirateagr:";player.pirate_agr
            key=""
        endif
        if just_run=1 then 
            if key="S" then
                cls 
                for a=1 to lastfleet
                    print debug_printfleet(fleet(a))
                next
                no_key=keyin
            endif
            key=""
            player.c.x=1
        endif
        if len(allowed)>0 and key<>key_esc and key<>key_enter and getdirection(key)=0 then
            if instr(allowed,key)=0 then key=""
        endif
    loop until key<>"" or walking <>0 or just_run=1
    while inkey<>""
    wend
    screenset 0,1
    return key
end function

function keyplus(key as string) as short
    dim r as short
    if key=key_up or key=key_lt or key="+" then r=-1
    return r
end function

function keyminus(key as string) as short
    dim r as short
    if key=key_dn or key=key_rt or key="-" then r=-1
    return r
end function

sub displaystar(a as short)
    dim bg as short
    dim n as short
    dim p as short
    dim as short x,y
    x=map(a).c.x-player.osx
    y=map(a).c.y-player.osy
    if x<0 or y<0 or x>60 or y>20 then return
    bg=0
    if spacemap(map(a).c.x,map(a).c.y)>=2 then bg=5
    for p=1 to 9
        if map(a).planets(p)>0 then
            for n=0 to lastspecial
                color 11,0
                locate 1,1
                if map(a).planets(p)=specialplanet(n) and planetmap(0,0,map(a).planets(p))<>0 then 
                    bg=1
                endif
                if show_specials=1 and map(a).planets(p)=specialplanet(n) then
                    locate map(a).c.y-player.osy+2,map(a).c.x-player.osx+2,0
                    color 11
                    print ""&n
                endif
            next
        endif
    next
    if map(a).discovered=0 then 
        player.discovered(map(a).spec)=player.discovered(map(a).spec)+1
        map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        map(a).discovered=1
    endif
    if _tiles=0 then
        put ((map(a).c.x-player.osx)*8+1,(map(a).c.y-player.osy)*16+1),gtiles(map(a).spec+1),trans
    else        
        color spectraltype(map(a).spec),bg
        locate map(a).c.y+1-player.osy,map(a).c.x+1-player.osx,0
        if map(a).spec<8 then print "*"
        if map(a).spec=8 and map(a).discovered=2 then     
            color 7,bg
            print "o"
        endif
            
        if map(a).spec=9 then 
            n=distance(map(a).c,map(map(a).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            color 179+n,bg
            print "o"
        endif
    endif
end sub

sub displaystation(a as short)
    dim as short x,y
    basis(a).discovered=1
    x=basis(a).c.x-player.osx
    y=basis(a).c.y-player.osy
    if x<0 or y<0 or x>60 or y>20 then return
    color 15,0
    if _tiles=1 then
        locate basis(a).c.y+1-player.osy,basis(a).c.x+1-player.osx,0
        print "S"
    else
        put ((basis(a).c.x-player.osx)*8+1,(basis(a).c.y-player.osy)*16+1),gtiles(10),pset
    endif
end sub

sub dtile(x as short,y as short, tiles as _tile,bg as short=0)
    dim as short col,bgcol
    locate y+1,x+1,0
    col=tiles.col
    bgcol=tiles.bgcol
    'if tiles.walktru=5 then bgcol=1
    if tiles.col<0 and tiles.bgcol<0 then
        col=col*-1
        bgcol=bgcol*-1
        col=rnd_range(col,bgcol)    
        bgcol=0
    endif
    if _tiles=0 then
        put (x*8,y*16),gtiles(tiles.no+19),pset
    else
        if _showvis=0 and bg>0 and bgcol=0 then 
            bgcol=234
        endif
        color col,bgcol
        print chr(tiles.tile)
    endif
    color 11,0    
end sub

sub displaysystem(sys as _stars)
    dim as short a,b,bg
    locate 22,28
    color 11,1
    print chr(180)
    locate 22,29
    color spectraltype(sys.spec),0
    print "*"&space(2);
    sys.discovered=2 
                
    for b=1 to 9
        
        'print isgasgiant(sys.planets(b))&sys.planets(b);
        color 0,0
        print " ";
        if sys.planets(b)=0 then
            print " ";
        endif
        bg=0
        for a=0 to lastspecial
            if sys.planets(b)>0 then
                if sys.planets(b)=specialplanet(a) and planetmap(0,0,sys.planets(b))<>0 then bg=1
            endif
        next
        if sys.planets(b)>0 and isgasgiant(sys.planets(b))=0 and isasteroidfield(sys.planets(b))=0 then
            if planets(sys.planets(b)).visited>0 then  
                if planets(sys.planets(b)).atmos=1 then color 15,bg      
                if planets(sys.planets(b)).atmos>1 and planets(sys.planets(b)).atmos<7 then color 101,bg
                if planets(sys.planets(b)).atmos>6 and planets(sys.planets(b)).atmos<12 then color 210,bg
                if planets(sys.planets(b)).atmos>11 then color 10,bg
            else
                if planets(sys.planets(b)).atmos=1 then color 8,bg      
                if planets(sys.planets(b)).atmos>1 and planets(sys.planets(b)).atmos<7 then color 9,bg
                if planets(sys.planets(b)).atmos>6 and planets(sys.planets(b)).atmos<12 then color 198,bg
                if planets(sys.planets(b)).atmos>11 then color 54,bg
            endif
            if planetmap(0,0,sys.planets(b))=0 then color 7,bg
            print "o";
         endif
         
         if isgasgiant(sys.planets(b))<>0 then
            if b>5 then
                color 63,bg
                print "O";
            endif
            if b>1 and b<6 then
                color 162,bg
                print "O";
            endif
            if b=1 then
                color 144,bg
                print "O";
            endif
        endif
        
        if (isgasgiant(sys.planets(b))=0 and sys.planets(b)<0) or isasteroidfield(sys.planets(b))=1 then
            color 7,0
            print chr(176);
        endif
    next
        
    color 11,1
    print chr(195)
    color 11,0
end sub

sub displayawayteam(awayteam as _monster, map as short, lastenemy as short, deadcounter as short, ship as gamecords, loctime as short)
        dim a as short
        dim c as short
        dim x as short
        dim y as short
        dim t as string
        static wg as byte
        static wj as byte
        dim thp as short
        dim as string poi
        if awayteam.oxygen=200 then wg=0
        if awayteam.stuff(8)=1 and player.landed.m=map and planets(map).depth=0 then
            color 15,0
            locate 22,3
            print "Pos:";
            print using "##:##";awayteam.c.x,awayteam.c.y
        else
            locate 22,1
            color 14,0
            print "no satellite"
        endif
        locate 22,15
        color 15,0
        if loctime=3 then print "Night"
        if loctime=0 then print " Day "
        if loctime=1 then print "Dawn "
        if loctime=2 then print "Dusk "
        color 11,1
        locate 22,20
        print chr(195)
        for a=21 to 61
            locate 22,a,0
            print CHR(196)
        next
        for a=1 to 25
            locate a,62,0,0
            print CHR(179);
        next
        locate 22,62,0
        print chr(180)
        color 15,0
        if player.landed.m=map then
            if planetmap(ship.x,ship.y,map)>0 or player.stuff(3)=2 then    
                if _tiles=0 then
                    put (ship.x*8,ship.y*16),gtiles(12),trans
                else
                    if map=specialplanet(28) and specialflag(28)=0 then
                        color 14,0
                        locate rnd_range(1,21), rnd_range(1,61)
                        print "@"
                    else
                        color 14,0
                        locate ship.y+1, ship.x+1
                        print "@"
                    endif
                endif
            endif
        endif        
        if _tiles=0 then
            put (awayteam.c.x*8,awayteam.c.y*16),gtiles(13),trans
        else
            locate awayteam.c.y+1,awayteam.c.x+1
            color 15,0
            print "@" 
        endif    
        hpdisplay(awayteam)
        color 11,0
        locate 7,63
        print "Visibility:" &awayteam.sight
        locate 8,63
        if awayteam.move=0 then print "Trp.: None"
        if awayteam.move=1 then print "Trp.: Hoverplt."
        if awayteam.move=2 then print "Trp.: Jetpacks"
        if awayteam.move=3 then print "Trp.: Teleport(T)"
        
        locate 9,63
        print "Armor :";
        print using "###";awayteam.stuff(2)
        locate 10,63
        print "Firearms :";
        print using "###.#";awayteam.guns_to
        locate 11,63
        print "Melee :";
        print using "###.#";awayteam.blades_to
        if player.stuff(3)=2 then
            locate 12,63
            print "Alien Scanner"
            locate 13,63
            print lastenemy-deadcounter &" Lifeforms "
        endif
        locate 15,63
        print "Mapped    :"& cint(reward(0))
        locate 16,63
        print "Bio Data  :"& cint(reward(1))
        locate 17,63
        print "Resources :"& cint(reward(2))
        locate 19,63
        print space(17);
        locate 19,63
        if len(tiles(abs(planetmap(awayteam.c.x,awayteam.c.y,map))).desc)<18 then
            print tiles(abs(planetmap(awayteam.c.x,awayteam.c.y,map))).desc ';planetmap(awayteam.c.x,awayteam.c.y,map) 
        else 
            dprint tiles(abs(planetmap(awayteam.c.x,awayteam.c.y,map))).desc '&planetmap(awayteam.c.x,awayteam.c.y,map)
        endif
        
        if awayteam.move=2 then
            locate 21,63
            print key_ju &" for emerg."
            locate 22,63
            print "Jetpackjump"
        endif
        if awayteam.move=3 then
            locate 21,63
            print key_te &" activates"
            locate 22,63
            print "Transporter"
        endif
        if awayteam.jpfuelmax>0 then
            color 11,0
            locate 23,63
            print "Jetpackfuel:";
            color 10,0
            if awayteam.jpfuel<10 then color 14,0
            if awayteam.jpfuel<5 then color 12,0
            if awayteam.jpfuel<0 then awayteam.jpfuel=0
            print using "##";awayteam.jpfuel
            if awayteam.jpfuel<awayteam.jpfuelmax then
                if int(awayteam.jpfuel/awayteam.jpfuelmax)<.5 and wj=0 then 
                    wj=1
                    for a=1 to wj
                        if _sound=0 or _sound=2 then    
                            sleep 1150
                            FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                        endif
                    next    
                    dprint ("Jetpack fuel low",14,14)
                endif
                if int(awayteam.jpfuel/awayteam.jpfuelmax)<.3 and wj=1 then 
                    wj=2
                    for a=1 to wj
                        if _sound=0 or _sound=2 then    
                            sleep 1150
                            FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                        endif
                    next    
                    dprint ("Jetpack fuel very low",14,14)
                endif
            else
                wj=0
            endif
        endif
        color 11,0
        locate 24,63
        print "Oxygen:";
        color 10,0
        if awayteam.oxygen<50 then color 14,0
        if awayteam.oxygen<25 then color 12,0
        print using "###";awayteam.oxygen
        if int(awayteam.oxygen<100) and wg=0 then 
            dprint ("Reporting oxygen tanks half empty",14,14)
            wg=1
            for a=1 to wg
                if _sound=0 or _sound=2 then    
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                
                endif
            next
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
        endif
        if int(awayteam.oxygen<50) and wg=1 then 
            dprint ("Oxygen low.",14,14)
            wg=2
            for a=1 to wg
                if _sound=0 or _sound=2 then
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))   
                    sleep 350
                endif
            next
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)       
        endif
        if int(awayteam.oxygen<25) and wg=2 then
            dprint ("Switching to oxygen reserve!",12,12)
            wg=3
            for a=1 to wg
                if _sound=0 or _sound=2 then 
                    FSOUND_PlaySound(FSOUND_FREE, sound(1)) 
                    sleep 350
                endif
            next
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)    
        endif
        color 11,0
        locate 25,63
        print "Turn:" &player.turn;
end sub

sub shipstatus(heading as short=0)
    dim as short c1,c2,c3,c4,c5,sick,offset
    dim as short a,b,c,lastinv,set,tlen
    dim as string text,key
    dim inv(55) as _items
    dim invn(55) as short
    dim cargo(8) as string
    dim cc(8) as short
    color 0,0
    cls
    if heading=0 then
        color 15,0
        locate 1,2
        print "Name: ";
        color 11,0
        print player.desig &"   ";
        color 15,0
        print "Type: ";
        color 11,0
        print player.h_desig
    endif
    locate 3,3
    color 15,0
    print "Hullpoints(max";
    color 11,0
    print player.h_maxhull;
    color 15,0
    print "):";
    color 11,0
    if player.hull<player.h_maxhull/2 then color 14,0
    if player.hull<2 then color 12,0
    print player.hull
    locate 4,3
    color 15,0
    print "Shieldgenerator(max";
    color 11,0
    print player.shieldmax;
    color 15,0
    print "):";
    color 11,0
    if player.shield<player.shieldmax/2 then color 14,0
    print player.shield
    locate 5,3
    color 15,0
    print "Engine:";
    color 11,0
    print player.engine;
    color 15,0
    print "("&player.engine+2-player.h_maxhull\15 &" MP) Sensors:";    
    color 11,0 
    print player.sensors
    'Weapons
    c=player.h_maxweaponslot
    locate 7,3
    color 15,0
    print "Weapons:"
    color 11,0
    for a=1 to c
        if player.weapons(a).dam>0 then
            locate 8+b,3
            color 15,0
            print player.weapons(a).desig 
            color 11,0
            locate 8+b+1,3
            print " R:"& player.weapons(a).range &"/" & player.weapons(a).range*2 &"/" & player.weapons(a).range*3 &" D:"&player.weapons(a).dam ;
            if player.weapons(a).ammomax>0 then print " A:"&player.weapons(a).ammomax &"/" &player.weapons(a).ammo &"  "
            b=b+2
        else
            locate 8+b,4
            color 15,0
            if player.weapons(a).desig="" then
            print "-Empty-"
        else
            print player.weapons(a).desig
            endif
            b=b+1
        endif
    next
    'Cargo
    b=b-1
    text=cargobay(0)
    text=mid(text,6) 'first "SELL" out
    a=0
    locate 17,3
    color 15,0
    print "Cargo:"
    color 11,0
    cargo(1)="Empty"
    cargo(2)="Food, bought at"
    cargo(3)="Basic goods, bought at"
    cargo(4)="Tech goods, bought at"
    cargo(5)="Luxury goods, bought at"
    cargo(6)="Weapons, bought at"
    cargo(7)="Mysterious box"
    cargo(8)="TT Contract Cargo"
    for c=1 to 10
        if player.cargo(c).x=1 then cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
        if player.cargo(c).x=7 then cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
            
        if player.cargo(c).x>1 and player.cargo(c).x<7 then 
            cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
            cargo(player.cargo(c).x)=cargo(player.cargo(c).x)&" "&player.cargo(c).y &", " 
        endif
    next
    for c=1 to 7
        if cc(c)>0 then 
            if c>1 and c<7 then
                cargo(c)=left(cargo(c),len(cargo(c))-2)&"."
            endif    
            print cc(c)&" x "&cargo(c)
        endif
    next
    locate 3,31
    color 15,0 
    print "Crew Summary"
    locate 5,31
    print "Pilot          :";
    if player.pilot >0 then
        color 11,0
        print player.pilot
    else 
        color 12,0
        print " - "
    endif
    locate 6,31
    color 15,0
    print "Gunner         :";
    if player.gunner>0 then
        color 11,0
        print player.gunner
    else 
        color 12,0
        print " - "
    endif
    locate 7,31
    color 15,0
    print "Science officer:";
    if player.science>0 then
        color 11,0
        print player.science
    else 
        color 12,0
        print " - "
    endif
    locate 8,31
    color 15,0
    print "Ship doctor    :";
    if player.doctor>0 then
        color 11,0
        print player.doctor
    else 
        color 12,0
        print " - "
    endif
    locate 10,31
    color 15,0
    print "Total bunks  :";
    color 11,0
    print player.h_maxcrew+player.crewpod
    locate 11,31
    color 15,0
    print "Cryo chambers:";
    color 11,0
    print player.cryo
    
    for a=6 to 128
       if crew(a).typ=6 then c1=c1+1
       if crew(a).typ=7 then c2=c2+1
       if crew(a).typ=8 then c3=c3+1
       if crew(a).typ=9 then c4=c4+1
       if crew(a).typ=10 then c5=c5+1
       if crew(a).disease>0 then sick+=1
    next
    locate 12,31
    color 15,0
    print "Security:";
    color 11,0
    player.security=c1+c2+c3+c4+c5
    print c1+c2+c3+c4+c5
    color 15,0
    locate 14,33
    print "Elite    :";
    color 11,0
    print c3
    color 15,0
    locate 15,33
    print "Veterans :";
    color 11,0
    print c2
    locate 16,33
    color 15,0
    print "Green    :";
    color 11,0
    print c1
    if c4>0 then
    locate 17,33
        color 15,0
        print "Insectw. :";
        color 11,0
        print c4
    endif
    if c5>0 then
        locate 17,33
        if c4>0 then locate 18,33
        color 15,0
        print "Cephalop.:";
        color 11,0
        print c5
    endif
    if sick>0 then
        locate 19,33
        color 14,0
        print "Sick :"&sick
    endif
    locate 1,55
    color 15,0    
    if heading=0 then
    lastinv=getitemlist(inv(),invn())     
    print "Equipment(";lastinv;"):"
    color 11,0
    if heading=0 then  
        do
            for a=0 to 22                
                locate 2+a,50
                color 0,0
                print space(30);
                color 11,0
                locate 2+a,50
                
                if invn(a+offset)>1 then
                    print invn(a+offset)&" "&inv(a+offset).desigp;
                else
                    if invn(a+offset)=1 then print invn(a+offset)&" "&inv(a+offset).desig;
                endif
            next
            locate 25,79
            color 0,0
            print " ";
            if lastinv>22 and offset<lastinv then                    
                locate 25,79
                color 14,0
                print chr(25);
            endif
            locate 1,79
            color 0,0
            print " ";
            if offset>0 then    
                locate 1,79
                color 14,0
                print chr(24);
            endif
            key=keyin(,,1)
            if keyminus(key) or key="8" then offset=offset-1
            if keyplus(key) or key="2" then offset=offset+1
            if offset<0 then offset=0
            if offset>33 then offset=33
            loop until key=key_esc or key=" "
        endif
    endif
end sub

sub displayship(show as byte=0)
    dim  as short a,b
    static wg as byte
    dim t as string
    dim as string p,g,s,d
    if player.fuel=player.fuelmax then wg=0
    locate 22,1
    color 15,0
    if findbest(52,-1)>0 then
        print "Pos:";
        locate 22,5
        print using "##:##";player.c.x,player.c.y    
    else
        locate 22,1
        color 14,0
        print "No Navcomp"
    endif
        
    color 11,1
    locate 22,11
    print chr(195)
    for a=12 to 61
        locate 22,a,0
        print CHR(196)
    next
    for a=1 to 25
        locate a,62,0,0
        print CHR(179);
    next
    locate 22,62,0
    print chr(180)
    color 15,0
    locate 1,63
    print player.h_sdesc &" "& player.desig 
    color 11,0
    locate 2,63
    print "HP:"&space(4) &" "&"SP:"&player.shield &" "
    if player.hull<player.h_maxhull/2 then color 14,0
    if player.hull<2 then color 12,0
    locate 2,66
    print player.hull
    color 11,0
    p=""&player.pilot
    g=""&player.gunner
    s=""&player.science
    d=""&player.doctor
    if player.pilot<0 then p="-"
    if player.gunner<0 then g="-"
    if player.science<0 then s="-"
    if player.doctor<0 then d="-"
    player.security=0
    for a=6 to 128
       if crew(a).hpmax>=1 then player.security+=1
    next
    
    locate 3,63
    print "Pi:" & p & "  Gu:" &g &"  Sc:" &s
    locate 4,63
    print "Dr:"&d &"  Security:"&player.security
    locate 5,63
    print "Sensors:"&player.sensors
    locate 6,63
    print "Engine :"&player.engine &" ("&player.engine+2-player.h_maxhull\15 &" MP)"
    locate 23,63
    print "Fuel(" &player.fuelmax+player.fuelpod &"):"
    color 11,0
    if player.fuel<player.fuelmax*0.5 then 
        if wg=0 then
            wg=1 
            dprint "Fuel low",0,14
            if _sound=0 or _sound=2 then 
                 FSOUND_PlaySound(FSOUND_FREE, sound(2))                                       
            endif    
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
        endif
        color 14,0
        
    endif
            
    if player.fuel<player.fuelmax*0.2 then
        if wg=1 then
            wg=2
            dprint "Fuel very low",0,12
            if _sound=0 or _sound=2 then 
                 FSOUND_PlaySound(FSOUND_FREE, sound(2))
            endif
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
 
        endif
        color 12,0
    endif
    locate 23,74
    print using "###";player.fuel
    color 11,0
    locate 24,63
    if player.money<1000000 then
        print using "Credits:######";player.money
    else
        print "Credits:";player.money
    endif
    locate 25,63
    print using "Turns:######";player.turn; 
    color 15,0
    locate 7,63
    print "Weapons:"
    color 11,0
    player.tractor=0
    for a=1 to 5
        if player.weapons(a).desig<>"" then
            locate 8+b,63
            color 15,0
            print trim(player.weapons(a).desig);
            color 11,0
            print " D:"&player.weapons(a).dam
            locate 8+b+1,63
            print "R:"& player.weapons(a).range &"/"& player.weapons(a).range*2 &"/" & player.weapons(a).range*3 ;
            if player.weapons(a).ammomax>0 then print " A:"&player.weapons(a).ammomax &"/" &player.weapons(a).ammo &" ";
            if player.weapons(a).desig="Tractor Beam" then 
                player.tractor=1
                if player.towed>0 and rnd_range(1,6)+rnd_range(1,6)+player.pilot<9 then
                    dprint "Your tractor beam breaks down",14,14
                    player.tractor=0
                    player.towed=0
                    player.weapons(a)=makeweapon(0)
                endif
            endif
        else
            locate 8+b,63
            print spc(15)
            locate 8+b+1,63
            print spc(15)
        endif
        b=b+2
    next
    locate 21,63
    print "Cargo"
    for a=1 to 10
        locate 22,62+a
        if player.cargo(a).x=1 then 
            color 8,1
            print "E"
        else
            color 10,8
        endif
        if player.cargo(a).x=2 then print "F"
        if player.cargo(a).x=3 then print "B"
        if player.cargo(a).x=4 then print "T"
        if player.cargo(a).x=5 then print "L"
        if player.cargo(a).x=6 then print "W"
        if player.cargo(a).x=7 then print "?"
        if player.cargo(a).x=8 then print "C"
    next
    if show=1 then
        if _tiles=0 then
            put ((player.c.x-player.osx)*8,(player.c.y-player.osy)*16),gtiles(12),trans
        else
            color 15,0
            locate player.c.y+1-player.osy,player.c.x+1-player.osx
            print "@"
        endif
    endif
    color 11,0
    if player.tractor=0 then player.towed=0
end sub

sub displayplanetmap(a as short)
    dim x as short
    dim y as short
    dim b as short
    for x=60 to 0 step-1
        for y=0 to 20
            if planetmap(x,y,a)>0 then
                dtile(x,y,tiles(planetmap(x,y,a)))
            endif
        next
    next
    for b=0 to lastportal
        if portal(b).from.m=a and portal(b).discovered=1 then
            locate portal(b).from.y+1,portal(b).from.x+1,0
            color portal(b).col,0
            print chr(portal(b).tile)            
        endif
        if portal(b).oneway=0 and portal(b).dest.m=a and portal(b).discovered=1 then
            locate portal(b).dest.y+1,portal(b).dest.x+1,0
            color portal(b).col,0
            print chr(portal(b).tile)
        endif
    next
    for b=1 to lastitem
        if item(b).w.m=a and item(b).w.s=0 and item(b).w.p=0 and item(b).discovered=1 then
            if _tiles=0 then
                if item(a).ty<>15 then
                    put (item(a).w.x*8,item(a).w.y*16),gtiles(item(a).ty+200),trans
                else                                
                    put (item(a).w.x*8,item(a).w.y*16),gtiles(item(a).v2+250),trans
                endif
            else            
                locate item(b).w.y+1,item(b).w.x+1
                color item(b).col,item(b).bgcol
                print item(b).icon
            endif
        endif
    next
end sub

function gettext(x as short, y as short, ml as short, text as string) as string
    dim l as short
    dim key as string
    dim p as cords
    l=len(text)
    flip
    screenset 0,0
    sleep 150
    if l>ml and text<>"" then
        text=left(text,ml-1)
        l=ml-1
    endif
    do 
        key=""
        color 11,0
        locate y+1,x+1
        print text;
        color 11,11
        print " ";
        color 11,0      
        do
            sleep 50
            do
                sleep 1
            loop until screenevent(@evkey)
            if evkey.type=EVENT_KEY_press then
                if evkey.ascii=asc(key_esc) then key=key_esc
                if evkey.ascii=8 then key=chr(8)
                if evkey.ascii=32 then key=chr(32)
                if evkey.ascii=asc(key_enter) then key=key_enter
                if evkey.ascii>64 and evkey.ascii<123 then key=chr(evkey.ascii)
            endif
        loop until key<>""  
        color 11,0
        locate y+1,x+1
        print text;
        color 0,0
        print " ";
        color 11,0
        if key=chr(8) and l>=1 then
           l=l-1
           text=left(text,len(text)-1)
           if text=chr(8) then text=""
        endif
        if l<ml and key<>key_enter and key<>chr(8) and key<>key_esc then
            text=text &key
            l=l+1
        endif
        if l>ml then 
            l=ml
            text=left(text,ml)
        endif
        
    loop until key=key_enter or key=key_esc
    if key=key_esc or l<1 then
        color 0,0
        locate y+1,x+1
        print space(len(text));
        text=""
    endif
    if len(text)=0 then text=""
    if text=key_enter or text=key_esc or text=chr(8) then text=""
    while inkey<>""
    wend
    return text
end function

function textbox(text as string,x as short,y as short,w as short, fg as short=11, bg as short=0) as short
    dim as short lastspace,tlen,a,p,wcount,lcount
    dim words(1023) as string
    dim addt(24) as string
    addt(24)=text
    'if len(text)<=w then addt(0)=text
    for p=0 to len(text)
        words(wcount)=words(wcount)&mid(text,p,1)
        if mid(text,p,1)=" " or mid(text,p,1)="|" then wcount=wcount+1
    next
    for p=0 to wcount
        if words(p)="|" then 
            lcount=lcount+1
            p=p+1
        endif
        if len(addt(lcount)&words(p))>w then lcount=lcount+1
        addt(lcount)=addt(lcount)&words(p)
    next
    for a=0 to lcount
        addt(a)=addt(a)&space(w-len(addt(a)))
        locate y+1+a,x
        color fg,bg
        print addt(a)
    next
    text=addt(24)
    return lcount
end function


function dprint(t as string, delay as short=5, col as short=11) as short

    dim as short a,b
    dim text as string
    dim wtext as string
    dim offset as short
    dim tlen as short
    dim addt(8) as string
    dim lastspace as short
    dim key as string

    'find offset
    offset=23
    for a=23 to 26
        if displaytext(a)<>"" then offset=offset+1
    next
    for a=0 to len(t)
        if mid(t,a,1)<>"|" then text=text & mid(t,a,1)
    next
    if text<>"" then
    while len(text)>60
        lastspace=60
        do 
            lastspace=lastspace-1
        loop until mid(text,lastspace,1)=" "        
        if tlen>8 then tlen=8
        addt(tlen)=left(text,lastspace)
        text=mid(text,lastspace+1,(len(text)-lastspace+1))
        tlen=tlen+1
    wend
    addt(tlen)=text
    if offset+tlen>63 then offset=63-tlen
        
    for a=offset to offset+tlen
        displaytext(a)=addt(a-offset)
        dtextcol(a)=col
    next
    endif
    
    
    a=0
    do
        for b=23 to 25
            locate b,1,0
            color 0,0
            print space(60);
            locate b,1,0
            color dtextcol(b),0
            print displaytext(b);
        next
        if displaytext(25)<>"" then
        for b=0 to 29
           displaytext(b)=displaytext(b+1)
           dtextcol(b)=dtextcol(b+1)
        next
        displaytext(30)=""
        a=a+1
        if a=3 then 
            locate 25,55,0
            color 15,0
            print "[MORE]";
            no_key=keyin
            a=0
        endif
        endif
        
    loop until displaytext(25)=""
    color 11,0
    return 0
end function    


function askyn(q as string,col as short=11) as short
    dim a as short
    dim key as string*1
    dprint (q,col)
    while screenevent(@evkey)
    wend
    do
        key=ucase(keyin)
        displaytext(24)=displaytext(24)&key
        if key <>"" then 
            dprint ""
            if _anykeyno=0 and key<>"Y" then key="N"
        endif
    loop until key="N" or key=" " or key=key_esc or key=key_enter or key="Y"  
    if key="Y" or key=key_enter then a=-1
    return a
end function

function menu(te as string, he as string="", x as short=2, y as short=2, blocked as short=0) as short
    ' 0= headline 1=first entry
    dim as short blen
    dim as string text,help
    dim lines(25) as string
    dim helps(25) as string
    dim shrt(25) as string
    dim as string key,delhelp
    dim a as short
    dim b as short
    dim c as short
    static loca as short
    dim e as short
    dim l as short
    dim hfl as short
    dim hw as short
    dim lastspace as short
    dim tlen as short
    dim longest as short
    
    text=te
    help=he
    b=len(text)
    if loca=0 then loca=1
    c=0
    text=text &"/"
    do
        tlen=instr(text,"/")
        lines(c)=left(text,tlen-1)
        text=mid(text,tlen+1)
        c=c+1
    loop until len(text)<=0
    c=c-1
    if help<>"" then
        help=help &"/"
        hfl=1
        e=0
        b=len(help)
        do
            tlen=instr(help,"/")
            helps(e)=left(help,tlen-1)
            'if len(helps(e))>len(delhelp) then delhelp=space(len(helps(e)))
            help=mid(help,tlen+1)
            e=e+1
        loop until len(help)<=0
        e=0
    endif
    
    if loca>c then loca=c
    for a=0 to c
        shrt(a)=ucase(left(lines(a),1))
        if getdirection(shrt(a))>0 or val(shrt(a))>0 then shrt(a)=""
        if len(lines(a))>longest then longest=len(lines(a))
    next
    for a=0 to c
        lines(a)=lines(a)&space(longest-len(lines(a)))
    next
    hw=58-2-longest
    e=0
    do        
        locate y,x
        color 15,0
        print lines(0)
        
        for a=1 to c
            if loca=a then 
                if hfl=1 and loca<c then blen=textbox(helps(a),x+longest+2,2,hw,15,1)
                color 15,5
            else
                color 11,0
            endif
            locate y+a,x
            print lines(a)
        next
        key=keyin(,,blocked)
        
        if hfl=1 then 
            for a=2 to 2+blen
                locate 1+a,longest+x+2
                color 0,0
                print space(hw)
            next
        endif
        if getdirection(key)=8 then loca=loca-1
        if getdirection(key)=2 then loca=loca+1
        if loca<1 then loca=c
        if loca>c then loca=1
        if key=key_enter then e=loca
        if key=key_awayteam then 
            screenshot(1)
            showteam(1)
            screenshot(2)
        endif
        for a=0 to c
            if ucase(key)=shrt(a) and getdirection(key)=0 then loca=a
        next
        if key=key_esc or player.dead<>0 then e=c
    loop until e>0 
    color 0,0        
    for a=0 to c
        locate y+a,x
        print space(59)
    next
    color 11,0
    while inkey<>""
    wend
    return e
end function

function getrandomsystem() as short
    dim a as short
    dim b as short
    dim c as short
    dim pot(laststar) as short
    for a=0 to laststar
        if map(a).discovered=0 and map(a).spec<8 then
            pot(b)=a
            b=b+1
        endif
    next
    b=b-1
    if b>0 then 
        c=pot(rnd_range(0,b))
    else 
        c=-1
    endif
    return c
end function 


function getrandomplanet(s as short) as short
    dim pot(9) as short
    dim as short a,b,c
    if s>=0 and s<=laststar then
        for a=1 to 9
            if map(s).planets(a)>0 then
                pot(b)=map(s).planets(a)
                b=b+1
            endif
        next
        b=b-1
        if b=-1 then 
            c=-1
        else 
            c=pot(rnd_range(0,b))
        endif
    else
        c=-1
    endif
    return c
end function

function getdirection(key as string) as short
    dim d as short
    if key=key_south then return 2
    if key=key_north then return 8
    if key=key_east then return 6
    if key=key_west then return 4
    if key=key_nw then return 7
    if key=key_ne then return 9
    if key=key_se then return 3
    if key=key_sw then return 1
    if key=key_up then return 8
    if key=key_dn then return 2
    if key=key_rt then return 6
    if key=key_lt then return 4
    return 0
end function

function getsystem(player as _ship) as short
    dim a as short
    dim b as short
    b=-1
    for a=0 to laststar
        if player.c.x=map(a).c.x and player.c.y=map(a).c.y then b=a
    next
    return b
end function

function getplanet(sys as short) as short
    dim a as short
    dim text as string
    dim key as string
    dim r as short 
    dim p as short
    dim x as short
    dim firstplanet as short
    dim lastplanet as short
    if sys<0 or sys>laststar then
        dprint ("ERROR:System#:"&sys,14,14)
        return -1
    endif
    for a=1 to 9
        if map(sys).planets(a)<>0 then 
            lastplanet=a
            x=x+1
        endif
    next
    for a=9 to 1 step-1
        if map(sys).planets(a)<>0 then firstplanet=a
    next
    p=liplanet
    if p<1 then p=1
    if p>9 then p=9
    if map(sys).planets(p)=0 then 
        do
            p=p+1
            if p>9 then p=1
        loop until map(sys).planets(p)<>0 or lastplanet=0
    endif
    if p>9 then p=firstplanet
    if lastplanet>0 then
        dprint "Enter to select, arrows to move,ESC to quit"
    do
        displaysystem(map(sys))        
        if keyplus(key) or a=6 then 
            do
                p=p+1
                if p>9 then p=1
            loop until map(sys).planets(p)<>0
        endif
        if keyminus(key) or a=4 then 
            do
                p=p-1
                if p<1 then p=9
            loop until map(sys).planets(p)<>0
        endif
        if p<1 then p=lastplanet
        if p>9 then p=firstplanet
        x=31+(p*2)
        if map(sys).planets(p)>0 then
            locate 22,x
            color 15,3
            if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then print "o"
            if isgasgiant(map(sys).planets(p))>0 then print "O"
            if isasteroidfield(map(sys).planets(p))=1 then print chr(176)
            color 11,0
        endif
        
        if map(sys).planets(p)<0 then
            locate 22,x
            color 15,3
            if isgasgiant(map(sys).planets(p))=0 then
                print chr(176)
            else
                print "O"
            endif
            color 11,0
        endif
        key=keyin
        a=Getdirection(key)
        
        
        if key="q" or key="Q" or key=key_esc then r=-1
        if (key=key_enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
    loop until r<>0
    liplanet=r
    else
    r=-1
    endif
    return r
end function

function isgardenworld(m as short) as short
    if planets(m).grav>1.1 then return 0
    if planets(m).atmos<3 or planets(m).atmos>5 then return 0
    if planets(m).temp<-20 or planets(m).temp>55 then return 0
    if planets(m).weat>1 then return 0
    if planets(m).water<30 then return 0
    if planets(m).rot<0.5 or planets(m).rot>1.5 then return 0
    return -1
end function


function isgasgiant(m as short) as short
    if m<-20000 then return 1
    if m=specialplanet(21) then return 21
    if m=specialplanet(22) then return 22
    if m=specialplanet(23) then return 23
    if m=specialplanet(24) then return 24
    if m=specialplanet(25) then return 25
    return 0
end function

function isasteroidfield(m as short) as short
    if m=specialplanet(31) then return 1 
    if m=specialplanet(32) then return 1 
    if m=specialplanet(33) then return 1 
    return 0
end function

function countasteroidfields(sys as short) as short
    dim as short a,b
    for a=1 to 9
        if map(sys).planets(a)<0 and isgasgiant(map(sys).planets(a))=0 then b=b+1
    next
    return b
end function


function countgasgiants(sys as short) as short
    dim as short a,b
    for a=1 to 9
        if isgasgiant(map(sys).planets(a))>0 then b=b+1
    next
    return b
end function

function checkcomplex(map as short,fl as short) as integer
    dim result as integer
    dim maps(36) as short
    dim as short nextmap,lastmap,foundport,a,b,done
    maps(0)=map
    do
    ' Suche portal auf maps(lastmap)
        lastmap=nextmap
        nextmap+=1
        for a=1 to lastportal
            if portal(a).from.m=maps(lastmap) then maps(nextmap)=portal(a).dest.m
        next
    loop until maps(nextmap)=0
    
    for a=1 to lastmap
        if maps(a)>0 and planets(maps(a)).genozide=0 then result+=1
    next
    return result
end function


function getnumber(a as short,b as short, e as short) as short
    dim key as string
    dim buffer as string
    dim c as short
    dim d as short
    dim i as short
    color 11,1
    for i=1 to 61
        locate 22,i
        print CHR(196)
    next
    color 11,11
    locate 22,28
    print space(5)
    c=a
    if e>0 then c=e
    do 
        locate 22,27
        color 11,1
        print chr(180)
        locate 22,28
        color 5,11
        print "-"

        if c<10 then 
            locate 22,30
            color 1,11
            print "0" &c
        else
            locate 22,29
            color 1,11
            print c
        endif
        
        locate 22,32
        color 5,11
        print "+"
        
        locate 22,33
        color 11,1
        print chr(195)
        key=keyin(key_up &key_dn &key_rt &key_lt &"1234567890+-"&key_esc &key_enter)
        if keyplus(key) then c=c+1
        if keyminus(key) then c=c-1
        if key=key_enter then d=1
        if key=key_esc then d=2
        buffer=buffer+key
        if len(buffer)>2 then buffer=""
        if val(buffer)<>0 then c=val(buffer)
        
        if c>b then c=b
        if c<a then c=a
        
    loop until d=1 or d=2
    if d=2 then c=-1
    color 11,0
    return c
end function    

function getclass(a as short=0) as string
    dim cl as string
    if a=0 then
        if player.hulltype<=50 then cl="HC"
        if player.hulltype<=40 then cl="C"
        if player.hulltype<=30 then cl="LC"
        if player.hulltype<=20 then cl="HS"
        if player.hulltype<=10 then cl="S"
    else        
        if player.hulltype<=50 then cl="Heavy Cruiser"
        if player.hulltype<=40 then cl="Cruiser"
        if player.hulltype<=30 then cl="Light Cruiser"
        if player.hulltype<=20 then cl="Heavy Scout"
        if player.hulltype<=10 then cl="Scout"
    endif
    return cl
end function

function getmonster(enemy() as _monster, byref lastenemy as short) as short
    dim as short d,e,c
    d=0
    for c=1 to lastenemy 'find dead that doesnt respawn
        if enemy(c).respawns=0 and enemy(c).hp<=0 then d=c
    next
    if d=0 then
        lastenemy=lastenemy+1
        d=lastenemy                            
        if d>128 then 
            lastenemy=128
            e=0
            do 
                e=e+1
                d=rnd_range(1,25)
            loop until enemy(d).hp<=0 or e=50
        endif
    endif
    return d
end function

function getshipweapon() as short
    dim as short a,b,c
    dim p(5) as short
    dim t as string
    t="Chose weapon/"
    for a=1 to 5
        if player.weapons(a).dam>0 then
            b=b+1
            p(b)=a
            t=t &player.weapons(a).desig & "/"
        endif
    next
    b=b+1
    p(b)=-1
    t=t &"Cancel"
    c=b-1
    if b>1 then c=p(menu(t))
    return c
end function


function sysfrommap(a as short)as short
    '
    ' returns the systems number of a special planet
    '
    dim planet as short
    dim as short b,c,d
    for b=0 to laststar
        for c=1 to 9
            if map(b).planets(c)=a then planet=b
        next
    next
    return planet
end function

function changetile(x as short,y as short,m as short,t as short) as short
    if planetmap(x,y,m)<0 then 
        planetmap(x,y,m)=abs(t)*-1
    else
        planetmap(x,y,m)=abs(t)
    endif
    return 0
end function

function copytile (byval a as short) as _tile
    dim r as _tile
    if a<0 then a=-a
    r.no=tiles(a).no 
    r.tile=tiles(a).tile
    r.desc=tiles(a).desc 
    r.bgcol=tiles(a).bgcol  
    r.col=tiles(a).col  
    r.seetru=tiles(a).seetru 
    r.walktru=tiles(a).walktru 
    r.firetru=tiles(a).firetru 
    r.shootable=tiles(a).shootable
    r.dr=tiles(a).dr
    r.hp=tiles(a).hp
    r.turnsinto=tiles(a).turnsinto
    r.succt=tiles(a).succt
    r.failt=tiles(a).failt
    r.spawnson=tiles(a).spawnson
    r.spawnswhat=tiles(a).spawnswhat
    r.spawnsmax=tiles(a).spawnsmax
    r.gives=tiles(a).gives
    return r
end function
    
function chr850(c as short) as string
    dim c2 as short
    c2=c
    if _savescreenshots=1 then
        if c>127 then c2=43
        if c=179 or c=186 then c2=124 '|
        if c=196 or c=205 then c2=45 '_
        if c=180 or c=195 then c2=43 '+
    endif
    return chr(c2)
end function


