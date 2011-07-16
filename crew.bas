function gainxp(slot as short) as short
    if crew(slot).hp>0 and crew(slot).xp>=0 then crew(slot).xp+=1
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
                dprint "You can't use that",14
                pack=-1
            endif
        endif
        if pack>0 then
            dprint "Using "&item(pack).desig &".",10
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
            if crew(a).disease>0 and rnd_range(1,6)+rnd_range(1,6)+bonus+player.doctor+addtalent(5,17,1)>5+crew(a).disease/2 then
                crew(a).disease=0
                crew(a).onship=crew(a).oldonship
                crew(a).oldonship=0
                cured+=1
            endif
            if crew(a).disease>0 then sick+=1
        endif
    next
    if cured>1 then dprint cured &" members of your crew where cured.",10
    if cured=1 then dprint cured &" member of your crew was cured.",10
    if cured=0 and sick>0 then dprint "No members of your crew where cured.",14
    if sick>0 then dprint sick &" are still sick.",14
    if cured>0 then gainxp(5)
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
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 and ta=10 then
            if player.tactic>0 then return crew(cr).talents(ta)
            if player.tactic<0 then return -crew(cr).talents(ta)
            return 0
        endif
        if crew(cr).hp>0 and crew(cr).talents(ta)>0 then return value*crew(cr).talents(ta)
    else
        value=0
        for cr=1 to 128
            if crew(cr).hp>0 and crew(cr).onship=0 then 
                total+=1
                value=value+crew(cr).talents(ta)
                if ta=24 then value=value+crew(cr).augment(4)/5
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



function healawayteam(byref a as _monster,heal as short) as short
    dim as short b,c,ex,fac,h
    static reg as single
    static doc as single
    for b=1 to a.hpmax
        if crew(b).hp>0 and crew(b).hp<crew(b).hpmax then ex=ex+1
        diseaserun(b)
        if crew(b).hp>0 and crew(b).onship=0 then doc+=crew(b).talents(29)/50 'Paramedics
    next
    fac=findbest(24,-1)
    
    if fac>0 then
        if item(fac).v1>0 then reg=reg+0.1
    endif
    if player.doctor>0 and crew(5).onship=0 then
       doc=doc+player.doctor/25+addtalent(5,17,.1)
    endif
    if heal>0 then heal=heal+player.doctor+addtalent(5,19,3)
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
        gainxp(5)
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
        crew(a).oldonship=crew(a).onship
        crew(a).duration=disease(dis).duration
        crew(a).incubation=disease(dis).incubation
        if dis>player.disease then player.disease=dis
    endif
    return 0
end function

function diseaserun(onship as short) as short
    dim as short a,b,dam,total,affected,dis,distotal
    dim text as string
    for a=2 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and crew(a).disease>0 then
            if crew(a).incubation>0 then 
                dprint a &":"&crew(a).incubation
                crew(a).incubation-=1
                if crew(a).incubation=0 then dprint crew(a).n &" "& disease(crew(a).disease).desig &".",14
            else
                if crew(a).duration>0 then 
                    crew(a).duration-=1 
                    if rnd_range(1,100)<disease(crew(a).disease).contagio then
                        b=rnd_crewmember
                        if crew(a).onship=crew(b).onship then 
                            crew(b).disease=crew(a).disease
                            crew(b).oldonship=crew(b).onship
                            crew(b).duration=disease(crew(a).disease).duration
                            crew(b).incubation=disease(crew(a).disease).incubation
                        endif
                    endif
                    if crew(a).duration=0 then
                        crew(a).disease=0
                        if rnd_range(1,100)+player.doctor*5<disease(crew(a).disease).fatality then
                            if crew(a).onship=onship and a=2 then 
                                dprint "Your pilot dies from disease.",12
                                player.pilot=captainskill
                            endif
                            if crew(a).onship=onship and a=3 then 
                                dprint "Your gunner dies from disease.",12
                                player.gunner=captainskill
                            endif
                            if crew(a).onship=onship and a=4 then 
                                dprint "Your science offcier dies from disease.",12
                                player.science=captainskill
                            endif
                            if crew(a).onship=onship and a=5 then
                                dprint "Your doctor dies from disease.",12
                                player.doctor=captainskill
                            endif
                            if crew(a).onship=onship and a>5 then dprint crew(a).n &" dies from disease.",12
                            crew(a)=crew(0)
                            crew(a).disease=0
                            
                        else
                            if crew(a).onship=onship then dprint crew(a).n &" recovers.",10
                            crew(a).onship=crew(a).oldonship
                            crew(a).disease=0
                        endif
                    endif
                endif
            endif
        endif
        if crew(a).disease>dis then dis=crew(a).disease
    next
    player.disease=dis
    return 0
end function

function damawayteam(byref a as _monster,dam as short, ap as short=0,disease as short=0) as string
    dim text as string
    dim as integer ex,b,t,last,last2,armeff,reequip,roll,cc
    dim as short local_debug=0
    dim target(128) as integer
    dim stored(128) as integer
    dim injured(16) as integer
    dim killed(16) as integer
    dim desc(16) as string
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
    desc(13)="Robot"
    desc(14)="Squad Leader"
    desc(15)="Sniper"
    desc(16)="Paramedic"
    'ap=1 Ignores Armor
    'ap=2 All on one, carries over
    'ap=3 All on one, no carrying over
    'ap=4 Ignores Armor, Robots immune
    
    if local_debug=1 then text=text & "in:"&dam
    
    if abs(player.tactic)=2 then dam=dam-player.tactic
    if dam<0 then dam=1
    for b=1 to 128
        if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
            last+=1
            target(last)=b
            stored(b)=crew(b).hp
        endif
    next
    if dam>a.armor/(2*last) then
        dam=dam-a.armor/(2*last)
        armeff=int(a.armor/(2*last))
    else
        armeff=dam-1
        dam=1
    endif
    if last>128 then last=128
    cc=0
    do
        cc+=1
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
            if ap=0 or ap=1 or ap=4 then
                roll=rnd_range(1,25)
                if local_debug=1 then text=text &":" &roll &":"&a.secarmo(target(t))+crew(target(t)).augment(5)+player.tactic+addtalent(3,10,1)+addtalent(t,20,1)
                if roll>2+a.secarmo(target(t))+crew(target(t)).augment(5)+player.tactic+addtalent(3,10,1)+addtalent(t,20,1) or ap=4 or ap=1 or roll=25 then
                    if not(crew(target(t)).typ=13 and ap=4) then crew(target(t)).hp=crew(target(t)).hp-1
                    dam=dam-1
                else
                    armeff+=1
                endif
            endif
        endif
        last=0
        for b=1 to 128
            if (crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0) then
                last+=1
                target(last)=b
            endif
        next
    loop until dam<=0 or ex=1 or cc>9999
    dam=0
    for b=1 to 128
        if crew(b).onship=0 and crew(b).hpmax>0 then
            if stored(b)>crew(b).hp then
                if crew(b).hp<=0 then
                    killed(crew(b).typ)+=1
                    reequip=1
                else
                    injured(crew(b).typ)+=1
                endif
            endif
        endif
    next
    if armeff>0 then text=text &armeff &" prevented by armor. "
    
    for b=1 to 16
        if injured(b)>0 then
            if injured(b)>1 then
                text=text &injured(b) &" "&desc(b)&"s injured. "
            else
                text=text &desc(b)&" injured. "
            endif
        endif
    next
    for b=1 to 16
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
    hpdisplay(a)
    sleep 50
    if killed(2)>0 then player.pilot=captainskill
    if killed(3)>0 then player.gunner=captainskill
    if killed(4)>0 then player.science=captainskill
    if killed(5)>0 then player.doctor=captainskill
    if reequip=1 then equip_awayteam(player,a,player.map)
    if local_debug=1 then text=text & " Out:"&dam
    return trim(text)
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
    
    if roll>=10 and roll<=13 and slot=3 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>=14 and roll<=16 and slot=4 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>=17 and roll<=19 and slot=5 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    
    if roll>19 then
        crew(slot).talents(roll)+=1
        text=text &crew(slot).n &" is now "& talent_desig(roll) &"("&crew(slot).talents(roll)&"). "
    endif
    if roll=20 then 
        crew(slot).hpmax+=1
        crew(slot).hp+=1
    endif
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
    dim rolls(128) as short
    dim lev(128) as byte
    for a=1 to 128
        if _showrolls=1 then crew(a).xp+=10
        if crew(a).hp>0  then
            roll=rnd_range(1,crew(a).xp)
            if roll+crew(a).augment(10)*2>5+crew(a).hp^2 and crew(a).xp>0 then
                lev(a)+=1
                rolls(a)=crew(a).augment(10)*2+roll
            endif
            if a>1 then
                if rnd_range(1,100)>10+crew(a).morale+addtalent(1,4,10) and crew(a).hp>0 and crew(a).augment(11)=0 then
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
                    crew(a)=_del
                    lev(a)=0
                endif
            endif
        endif
    next
    if secret>1 then text=text &" " & secret &" of your security personal retired."
    if text<>"" then dprint text,10
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
    if _showrolls=1 then text=text &"Pilot Rolled "&rolls(2) &", needed"& 5+crew(2).hp^2
    
    if p.gunner>0 and p.gunner<=5 and lev(3)=1 then
        p.gunner+=1
        crew(3).hpmax+=1
        text=text &" Your gunner is now skill "&p.gunner &"."
        if rnd_range(1,100)<crew(3).xp*3 then text=text &gaintalent(3)
        crew(3).xp=0
    endif
    if _showrolls=1 then text=text &"Gunner rolled "&rolls(3) &", needed"& 5+crew(3).hp^2
    if p.science>0 and p.science<=5 and lev(4)=1 then
        p.science+=1
        crew(4).hpmax+=1
        text=text &" Your science officer is now skill "&p.science &"."
        if rnd_range(1,100)<crew(4).xp*3 then text=text &gaintalent(4)
        crew(4).xp=0
    endif
    if _showrolls=1 then text=text &"Science Officer Rolled "&rolls(4) &", needed"& 5+crew(4).hp^2
    if p.doctor>0 and p.doctor<=5 and lev(5)=1 then
        p.doctor+=1
        crew(5).hpmax+=1
        text=text &" Your doctor is now skill "&p.doctor &"."
        if rnd_range(1,100)<crew(5).xp*3 then text=text &gaintalent(5)
        crew(5).xp=0
    endif
    if _showrolls=1 then text=text &"Doctor rolled "&rolls(5) &", needed"& 5+crew(5).hp^2
    for a=6 to 128
        if _showrolls=1 then text=text &crew(a).n &"Rolled "&rolls(a) &", needed"& 5+crew(a).hp^2
    
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
    if elite>1 then text=text &" "&elite &" of your security are now elite."
    if text<>"" then dprint text,10
    displayship()
    return p
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

function rnd_crewmember(onship as short=0) as short
    dim pot(128) as short
    dim as short p,a
    for a=0 to 128
        if crew(a).hp>0 and crew(a).onship=onship then 
            p+=1
            pot(p)=a
        endif
    next
    return pot(rnd_range(1,p))
end function

function get_freecrewslot() as short
    dim as short b,slot
    for b=128 to 6 step -1
        if crew(b).hp<=0 then slot=b
    next
    return slot
end function

function addmember(a as short) as short
    dim as short slot,b,f,c,cc
    dim _del as _crewmember
    dim as string n(200,1)
    dim as short ln(1)
    f=freefile
    open "data/crewnames.txt" for input as #f
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
    slot=get_freecrewslot
    if a<6 then slot=a
    if slot>0 then
        
        crew(slot)=_del
        if rnd_range(1,100)<80 then
            crew(slot).n=n((rnd_range(1,ln(1))),1)&" "&n((rnd_range(1,ln(0))),0)
        else
            crew(slot).n=n((rnd_range(1,ln(1))),1)&" "&CHR(rnd_range(65,87))&". "&n((rnd_range(1,ln(0))),0)
        endif
        crew(slot).morale=100+(Wage-10)^3*(5/100)
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
            crew(slot).n=alienname(2)
            crew(slot).morale=25000
            crew(slot).augment(7)=1
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
            crew(slot).augment(8)=1
        endif
        
        if a=14 then 'SO
            player.science=3
            crew(4).hpmax=player.science+1
            crew(4).hp=crew(4).hpmax
            crew(4).icon="T"
            crew(4).typ=4
            crew(4).paymod=0
            crew(4).n=alienname(1)
            crew(4).xp=0
            crew(4).disease=0
        endif
        
        if a=15 then
            player.doctor=6
            crew(5).typ=5
            crew(5).icon="D"
            crew(5).paymod=1
            crew(5).hpmax=7
            crew(5).hp=7
            crew(5).n="Ted Rofes"
            crew(5).xp=0
        endif
        
        
        if a=16 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="L"
            crew(slot).typ=6
            crew(slot).talents(27)=1
            crew(slot).paymod=2
        endif  
        
        if a=17 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="N"
            crew(slot).typ=6
            crew(slot).talents(28)=1
            crew(slot).paymod=2
        endif  
        
        if a=18 then 'green
            crew(slot).hpmax=2
            crew(slot).hp=crew(slot).hpmax
            crew(slot).icon="M"
            crew(slot).typ=6
            crew(slot).talents(29)=1
            crew(slot).paymod=2
        endif  
        
        'crew(slot).morale=rnd_range(1,5)
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gaintalent(slot)
        if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
    endif     
    return 0
end function    

function hiring(st as short,byref hiringpool as short,hp as short) as short
    dim as short b,c,d,e,officers,maxsec,neodog,robots,w
    dim as short f,g
    dim as string text,help
    screenset 1,1
    text="Hiring/ Pilot/ Gunner/ Science Officer/ Ships Doctor/ Security/ Squad Leader/ Sniper/ Paramedic/"
    help="Nil/Responsible for steering your ship/Fires your weapons and coordinates security team attacks/Operates sensors and collects biodata/Heals injuries and sickness/Your basic grunt/Coordinates the attacks of up to 5 security team members/An excellent marksman/Not worth much in combat, but assists the ships doctor"
    if basis(st).repname="Omega Bioengineering" and player.questflag(1)=3 then neodog=1
    if basis(st).repname="Smith Heavy Industries" and player.questflag(9)=3 then robots=1
    if neodog=1 then 
        text=text & " Neodog/ Neoape/"
        help=help &"/A genetically engeniered lifeform with the basis of a dog/A genetically engeniered lifeform with the basis of a ape"
    endif
    if robots=1 then 
        text=text & " Robot/"
        help=help &"/Smith Heavy Industries managed to replicate the old ones robots. They aren't as tough as the originals, but formidable killing machines nonetheless"
    endif
    text=text & " Set Wage/Exit"
    help=help & " /Set base wage for your crew"
    cls        
        do
            officers=1
            if player.pilot>0 then officers=officers+1
            if player.gunner>0 then officers=officers+1
            if player.science>0 then officers=officers+1
            if player.doctor>0 then officers=officers+1
        
            displayship()
            b=menu(text,help)
                
            d=rnd_range(1,100)
            c=5
            if d<90 then c=4
            if d<75 then c=3
            if d<60 then c=2
            if d<40 then c=1
            if c<1 then c=1
            e=((player.pilot+player.gunner+player.science+player.doctor)/4)+1
            if e<=0 then e=2
            if c>e then c=e+rnd_range(0,2)-1
            if c<=0 then c=2
            if b<5 and hiringpool>0 then
                if b=1 then
                    if askyn("Pilot, Skill:" & c &" Wage per mission: "& c*c*Wage &" (Current skill:"&player.pilot &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.pilot=c
                            hiringpool+=addmember(2)
                        else
                            dprint "Not enough money for first wage."
                        endif
                    endif
                endif
                if b=2 then
                    if askyn("Gunner, Skill:" & c &" Wage per mission: " & c*c*Wage & " (Current skill:"&player.gunner &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.gunner=c
                            hiringpool+=addmember(3)
                        else
                            dprint "Not enough money for first wage."
                        endif
                    endif
                endif
                if b=3 then
                    if askyn("Science officer, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.science &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.science=c
                            hiringpool+=addmember(4)
                        else
                           dprint "Not enough money for first wage."
                        endif
                    endif
                endif
                if b=4 then
                    if askyn("Ships doctor, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current skill:"&player.doctor &") hire? (y/n)") then
                        if player.money>=c*c*Wage then
                            player.money=player.money-c*c*Wage 
                            player.doctor=c
                            hiringpool+=addmember(5)
                        else
                           dprint "Not enough money for first wage."
                        endif
                    endif
                endif
                hiringpool=hiringpool-1
            else
                if b<5 then dprint "Nobody availiable for the position. try again later."
            endif
            if b=5 then
                maxsec=maxsecurity()
                dprint "No. of security personel to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
                c=getnumber(0,maxsec,0)
                if c>0 then
                if player.money<c*Wage then
                    dprint "Not enough money for first wage."
                else
                    for d=1 to c
                        hiringpool+=addmember(6)
                    next
                    player.money=player.money-c*Wage
                endif
                endif
            endif
            
            if b=6 then 'Squad leader
                maxsec=maxsecurity()
                dprint "No. of squad leaders to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
                c=getnumber(0,maxsec,0)
                if maxsec>0 then 
                    if player.money<wage*2*c then
                        dprint "Not enough money for first wage."
                    else
                        for d=1 to c
                            player.money-=wage*2
                            hiringpool+=addmember(16)
                        next
                    endif
                endif
            endif
            
            if b=7 then 'Sniper
                maxsec=maxsecurity()
                dprint "No. of snipers to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
                c=getnumber(0,maxsec,0)
                if maxsec>0 then 
                    if player.money<wage*2*c then
                        dprint "Not enough money for first wage."
                    else
                        for d=1 to c
                            player.money-=wage*2
                            hiringpool+=addmember(17)
                        next
                    endif
                endif
            endif
            
            if b=8 then 'Paramedic
                maxsec=maxsecurity()
                dprint "No. of paramedics to hire. (Max: "& minimum(maxsec,fix(player.money/wage))&")"
                c=getnumber(0,maxsec,0)
                if maxsec>0 then 
                    if player.money<wage*2*c then
                        dprint "Not enough money for first wage."
                    else
                        for d=1 to c
                            player.money-=wage*2
                            hiringpool+=addmember(18)
                        next
                    endif
                endif
            endif
            
            
            if neodog=1 then
                if b=9 then
                    maxsec=maxsecurity()
                    dprint "How many Neodogs do you want to buy? (Max: "& minimum(maxsec,fix(player.money/50))&")"
                    c=getnumber(0,maxsec,0)
                    if c>0 then
                        if player.money<c*50 then
                            dprint "Not enough Credits."
                        else
                            dprint "you buy "&c &" Neodogs."
                            for d=1 to c
                                addmember(11)
                            next
                            player.money=player.money-c*50
                        endif
                    endif
                endif
                
                if b=10 then
                    maxsec=maxsecurity()
                    dprint "How many Neoapes do you want to buy? (Max: "& minimum(maxsec,fix(player.money/75))&")"
                    c=getnumber(0,maxsec,0)
                    if c>0 then
                        if player.money<c*75 then
                            dprint "Not enough Credits."
                        else
                            dprint "you buy "&c &" Neoapes."
                            for d=1 to c
                                addmember(12)
                            next
                            player.money=player.money-c*75
                        endif
                    endif
                endif
            endif
            
            if b=9 and robots=1 then
                maxsec=maxsecurity()
                dprint "How many Robots do you want to buy? (Max: "& minimum(maxsec,fix(player.money/150))&")"
                c=getnumber(0,maxsec,0)
                if c>0 then
                    if player.money<c*150 then
                        dprint "Not enough Credits."
                    else
                        dprint "you buy "&c &" Robots."
                        for d=1 to c
                            addmember(13)
                        next
                        player.money=player.money-c*150
                    endif
                endif
            endif
            
            if (neodog=0 and robots=0 and b=9) or (neodog=1 and b=11) or (robots=1 and b=10) then
                dprint "Set standard wage from "&Wage &" to:"
                w=getnumber(1,20,Wage)
                if w>0 then Wage=w
                f=0
                for g=2 to 128
                    if Crew(g).paymod>0 and crew(g).hpmax>0 and crew(g).hp>0 then f=f+Wage*Crew(g).paymod
                next
                dprint "Set to " &Wage &"Cr. Your crew now gets a total of "&f &" Cr. in wages"        
            endif
        loop until (neodog=0 and robots=0 and b=10) or (neodog=1 and b=12) or (robots=1 and b=11)
    return 0
end function


function showteam(from as short, r as short=0,text as string="") as short
    dim as short b,bg,last,a,sit,cl,y,lines,xw
    dim dummy as _monster
    static p as short
    static offset as short
    dim n as string
    dim skills as string
    dim augments as string
    dim message as string
    dim onoff(2) as string
    dim debug as byte
    debug=0
    onoff(0)="On "
    onoff(1)=" - "
    onoff(2)="Off"
    for b=1 to 128
        if crew(b).hpmax>0 then last+=1
    next
    if p=0 then p=1
    no_key=""
    equip_awayteam(player,dummy,0)
    lines=fix((_screeny)/(_fh2*4))
    lines-=1
    cls
    do
        color 11,0
        screenset 0,1
        cls
        message=""
        if no_key=key_enter then
            if r=0 then
                if from=0 then
                    if p>1 then
                        if crew(p).disease=0 then
                            if crew(p).onship=0 then 
                                crew(p).onship=1
                            else
                                crew(p).onship=0
                            endif
                        else
                            draw string (10,_screeny-_fh2*2), "Is sick and must stay on board.",,font2,custom,@_col
                        endif
                    else
                        locate 22,1
                        color 14,0
                        draw string (10,_screeny-_fh2*2), "The captain must stay in the awayteam.",,font2,custom,@_col
                    endif
                else
                    locate 22,1
                    color 14,0
                    draw string (10,_screeny-_fh2*2), "You need to be at the ship to reassign.",,font2,custom,@_col
                endif
            endif
            if r=1 then return p
                
        endif
        
        
        if no_key="e" then
            select case crew(p).equips
                case 0
                    crew(p).equips=2
                case 2
                    crew(p).equips=0
            end select
            equip_awayteam(player,dummy,0)
        endif
        
        if no_key="a" and r=1 then return -1'Install augment in all
        
        
        if no_key="s" then
            sit=getitem()
            if sit>0 then
                for cl=1 to 128
                    if crew(cl).pref_lrweap=item(sit).uid then crew(cl).pref_lrweap=0
                    if crew(cl).pref_ccweap=item(sit).uid then crew(cl).pref_ccweap=0
                    if crew(cl).pref_armor=item(sit).uid then crew(cl).pref_armor=0
                next
                if item(sit).ty=2 then 
                    crew(p).pref_lrweap=item(sit).uid
                endif
                if item(sit).ty=4 then 
                    crew(p).pref_ccweap=item(sit).uid
                endif
                if item(sit).ty=3 then 
                    crew(p).pref_armor=item(sit).uid
                endif
                equip_awayteam(player,dummy,0)
            endif
        endif
        
        if no_key="c" then
            crew(p).pref_lrweap=0
            crew(p).pref_ccweap=0
            crew(p).pref_armor=0
            equip_awayteam(player,dummy,0)
        
        endif
        
        y=0
        b=1
        for b=1 to lines
            if b=p+offset then
                bg=5
            else
                bg=0
            endif
            if b-offset>0 and b-offset<=128 then  
                if crew(b-offset).hpmax>0 then
                    skills=""
                    augments=""
                    color 0,bg
                    draw string (0,y*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+1)*_fh2), space(80),,font2,custom,@_col
                    draw string (0,(y+2)*_fh2), space(80),,font2,custom,@_col
                    for a=1 to 25
                        if crew(b-offset).talents(a)>0 then 
                            if skills<>"" then 
                                skills=skills &", "&talent_desig(a)&"("&crew(b-offset).talents(a)&")"
                            else
                                skills=talent_desig(a)&"("&crew(b-offset).talents(a)&")"
                            endif
                        endif
                    next
                    
                    if crew(b-offset).augment(1)=1 then augments=augments &"Targeting "
                    if crew(b-offset).augment(1)=2 then augments=augments &"Targeting II "
                    if crew(b-offset).augment(1)=3 then augments=augments &"Targeting III "
                    if crew(b-offset).augment(2)=1 then augments=augments &"Muscle Enh. "
                    if crew(b-offset).augment(2)=2 then augments=augments &"Muscle Enh. II "
                    if crew(b-offset).augment(2)=3 then augments=augments &"Muscle Enh. III "
                    if crew(b-offset).augment(3)>0 then augments=augments &"Imp. Lungs "
                    if crew(b-offset).augment(4)>0 then augments=augments &"Speed Enh. "
                    if crew(b-offset).augment(5)=1 then augments=augments &"Exosceleton "
                    if crew(b-offset).augment(5)=2 then augments=augments &"Exosceleton II "
                    if crew(b-offset).augment(5)=3 then augments=augments &"Exosceleton III "
                    if crew(b-offset).augment(6)=1 then augments=augments &"Improved Metabolism "
                    if crew(b-offset).augment(6)=2 then augments=augments &"Improved Metabolism II "
                    if crew(b-offset).augment(6)=3 then augments=augments &"Improved Metabolism III "
                    if crew(b-offset).augment(7)>0 then augments=augments &"FloatLegs "
                    if crew(b-offset).augment(8)>0 then augments=augments &"Jetpack "
                    if crew(b-offset).augment(9)>0 then augments=augments &"Chameleon Skin "
                    if crew(b-offset).augment(10)>0 then augments=augments &"Neural Computer "
                    if crew(b-offset).augment(11)>0 then augments=augments &"Loyality Chip "
                    if crew(b-offset).augment(12)>0 then augments=augments &"Synthetic Nerves "
                    'if show_moral=1 then augments=augments &":"&crew(b-offset).morale
                    if skills<>"" then skills=skills &" "
                    color 15,bg
                    if b-offset>9 then
                        draw string (0,y*_fh2), b-offset & " ",,font2,custom,@_col
                    else
                        draw string (0,y*_fh2), " " & b-offset & " ",,font2,custom,@_col
                    endif
                    if crew(b-offset).hp>0 then
                        if b-offset>5 then
                            color 10,bg
                            draw string (3*_fw2,y*_fh2), crew(b-offset).icon,,font2,custom,@_col
                            color 15,bg
                            if crew(b-offset).talents(27)>0 then draw string (5*_fw2,y*_fh2), "Squ.Ld",,font2,custom,@_col
                            if crew(b-offset).talents(28)>0 then draw string (5*_fw2,y*_fh2), "Sniper",,font2,custom,@_col
                            if crew(b-offset).talents(29)>0 then draw string (5*_fw2,y*_fh2), "Paramd",,font2,custom,@_col
                        else
                            if b-offset=1 then draw string (3*_fw2,y*_fh2), "Captain",,font2,custom,@_col
                            if b-offset=2 then draw string (3*_fw2,y*_fh2), "Pilot  ",,font2,custom,@_col
                            if b-offset=3 then draw string (3*_fw2,y*_fh2), "Gunner ",,font2,custom,@_col
                            if b-offset=4 then draw string (3*_fw2,y*_fh2), "Science",,font2,custom,@_col
                            if b-offset=5 then draw string (3*_fw2,y*_fh2), "Doctor ",,font2,custom,@_col
                        endif
                    else
                        color 12,0
                        draw string (3*_fw2,y*_fh2), "X",,font2,custom,@_col
                    endif
                    
                    color 15,bg
                    if crew(b-offset).hp=0 then color 12,bg
                    if crew(b-offset).hp<crew(b-offset).hpmax then color 14,bg
                    if crew(b-offset).hp=crew(b-offset).hpmax then color 10,bg
                    draw string (10*_fw2,y*_fh2), " "&crew(b-offset).hpmax,,font2,custom,@_col
                    color 15,bg
                    draw string (12*_fw2,y*_fh2), "/",,font2,custom,@_col
                    if crew(b-offset).hp=0 then color 12,bg
                    if crew(b-offset).hp<crew(b-offset).hpmax then color 14,bg
                    if crew(b-offset).hp=crew(b-offset).hpmax then color 10,bg
                    draw string (13*_fw2,y*_fh2), ""&crew(b-offset).hp,,font2,custom,@_col
                    color 15,bg
                    draw string (15*_fw2,y*_fh2), " "&crew(b-offset).n,,font2,custom,@_col
                    if (crew(b-offset).onship=1 or crew(b-offset).disease>0) and crew(b-offset).hp>0 then
                        color 14,bg
                        draw string (34*_fw2,y*_fh2) ," On ship ",,font2,custom,@_col
                    endif
                    if crew(b-offset).onship=0 and crew(b-offset).hp>0 then
                        color 10,bg
                        draw string (34*_fw2,y*_fh2) ," Awayteam ",,font2,custom,@_col
                    endif
                    if debug=1 then draw string (40*_fw2,y*_fh2),""&crew(b-offset).oldonship,,font2,custom,@_col
                    if crew(b-offset).hp<=0 then
                        color 12,bg
                        draw string (34*_fw2,y*_fh2) ," Dead ",,font2,custom,@_col
                    endif
                    color 15,bg
                    if crew(b-offset).xp>=0 then 
                        draw string (55*_fw2,y*_fh2)," XP:" &crew(b-offset).xp,,font2,custom,@_col
                    else
                        draw string (55*_fw2,y*_fh2), " XP: -",,font2,custom,@_col
                    endif
                    draw string(45*_fw2,(y+2)*_fh2),"Auto Equip:" & onoff(crew(b-offset).equips),,font2,custom,@_col
                    'print space(70-pos)
                    color 15,bg
                    
                    y+=1
                    xw=4
                    if crew(b-offset).armo>0 then 
                        color 15,bg
                        if crew(b-offset).pref_armor>0 then
                            draw string (xw*_fw2,y*_fh2) ,"*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2),trim(item(crew(b-offset).armo).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).armo).desig))+3
                    else
                        color 14,bg
                        draw string (xw*_fw2,y*_fh2), " None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).weap>0 then 
                        color 15,bg
                        if crew(b-offset).pref_lrweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2) ," ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2) , trim(item(crew(b-offset).weap).desig)&", ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).weap).desig))+3
                    else
                        color 14,bg
                        draw string (xw*_fw2,y*_fh2) ," None,",,font2,custom,@_col
                        xw=xw+7
                    endif
                    if crew(b-offset).blad>0 then 
                        color 15,bg
                        if crew(b-offset).pref_ccweap>0 then
                            draw string (xw*_fw2,y*_fh2), "*",,font2,custom,@_col
                        else
                            draw string (xw*_fw2,y*_fh2), " ",,font2,custom,@_col
                        endif
                        xw+=1
                        draw string (xw*_fw2,y*_fh2), trim(item(crew(b-offset).blad).desig)&" ",,font2,custom,@_col
                        xw=xw+len(trim(item(crew(b-offset).blad).desig))+3
                    else
                        color 14,bg
                        draw string (xw*_fw2,y*_fh2) ," None",,font2,custom,@_col
                        xw=xw+7
                    endif
                    color 11,bg
                    if crew(b-offset).jp>0 then draw string (xw*_fw2,y*_fh2) ," Jetpack",,font2,custom,@_col
                    'print space(70-pos)
                    
                    y+=1
                    
                    color 15,bg
                    draw string (1*_fw2,y*_fh2), skills,,font2,custom,@_col
                    draw string ((4+len(skills))*_fw2,y*_fh2), augments,,font2,custom,@_col
                    if crew(b-offset).disease>0 then
                        color 14,bg
                        y+=1
                        draw string (1*_fw2,y*_fh2), "Suffers from "&trim(disease(crew(b-offset).disease).ldesc),,font2,custom,@_col
                    endif
                    'print space(70-pos)
                    
                    y+=1
                    
                    color 11,bg
                endif
            endif
        next
        color 11,0
        locate 25,1
        if r=0 then 
            if from=0 then draw string (10,_screeny-_fh2), "enter add/remove from awaytem,"&key_rename &" rename a member, s set Item c clear, e toggle autoequip, esc exit",,font2,custom,@_col
            if from <>0 then draw string (10,_screeny-_fh2), key_rename &" rename a member, s set Item, c clear, e toggle autoequip, esc exit",,font2,custom,@_col
        endif
        if r=1 then draw string (10,_screeny-_fh2), "installing augment "&text &": Enter to choose crewmember, esc to quit, a for all",,font2,custom,@_col
        'flip
        screenset 0,1
        no_key=keyin(,,1)
        if keyplus(no_key) or getdirection(no_key)=2 then p+=1
        if keyminus(no_key) or getdirection(no_key)=8 then p-=1
        if no_key=key_rename then
            screenset 1,1
            if p<6 then
                n=gettext(16,(p-1+offset)*3,16,n)
            else
                n=gettext(10,(p-1+offset)*3,16,n)
            endif
            if n<>"" then crew(p).n=n
            n=""
        endif
        if p<1 then p=1
        if p>last then p=last
        if p+offset>lines then offset=lines-p
        if p+offset<1 then offset=1-p
    loop until no_key=key_esc or no_key=" "
    cls
    return 0
end function