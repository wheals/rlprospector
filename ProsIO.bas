

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


function showteam(from as short, r as short=0,text as string="") as short
    dim as short b,bg,last,a,sit,cl,y,lines,xw
    dim dummy as _monster
    static p as short
    static offset as short
    dim n as string
    dim skills as string
    dim augments as string
    for b=1 to 128
        if crew(b).hpmax>0 then last+=1
    next
    if p=0 then p=1
    no_key=""
    equip_awayteam(player,dummy,0)
    lines=fix((_screeny-_fh2)/(_fh2*4))
    cls
    do
        color 11,0
        if no_key=key_enter then
            if r=0 then
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
                        draw string (10,_screeny-_fh2), "The captain must stay in the awayteam.",,font2,custom,@_col
                    endif
                else
                    locate 22,1
                    color 14,0
                    draw string (10,_screeny-_fh2), "You need to be at the ship to reassign.",,font2,custom,@_col
                endif
            endif
            if r=1 then return p
                
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
        
        screenset 0,1
        cls
        y=0
        for b=1 to lines
            if b=p+offset then
                bg=5
            else
                bg=0
            endif
            if b-offset>0 then  
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
                    if crew(b-offset).onship=1 and crew(b-offset).hp>0 then
                        color 14,bg
                        draw string (34*_fw2,y*_fh2) ," On ship ",,font2,custom,@_col
                    endif
                    if crew(b-offset).onship=0 and crew(b-offset).hp>0 then
                        color 10,bg
                        draw string (34*_fw2,y*_fh2) ," Awayteam ",,font2,custom,@_col
                    endif
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
                        draw string (1*_fw2,y*_fh2), "Suffers from "&trim(disease(crew(b-offset).disease).desig),,font2,custom,@_col
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
            if from=0 then draw string (10,_screeny-_fh2), "enter add/remove from awaytem,"&key_rename &" rename a member, s set Item c clear, esc exit",,font2,custom,@_col
            if from <>0 then draw string (10,_screeny-_fh2), key_rename &" rename a member, s set Item c clear, esc exit",,font2,custom,@_col
        endif
        if r=1 then draw string (10,_screeny-_fh2), "installing augment "&text &": Enter to choose crewmember, esc to quit, a for all",,font2,custom,@_col
        flip
        screenset 1,1
        no_key=keyin(,,1)
        if keyplus(no_key) or getdirection(no_key)=2 then p+=1
        if keyminus(no_key) or getdirection(no_key)=8 then p-=1
        if no_key=key_rename then
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
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gaintalent(slot)
        if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
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
                crew(a).onship=0
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
        crew(a).duration=disease(dis).duration
        if dis>player.disease then player.disease=dis
        dprint "A crew member was infected with "&disease(dis).desig &"!",12
    endif
    return 0
end function

function diseaserun(onship as short) as short
    dim as short a,dam,total,affected,dis,dead,distotal
    dim text as string
    for a=2 to 128
        if crew(a).hpmax>0 and crew(a).hp>0 and crew(a).disease>0 then
            if crew(a).duration>0 then 
                if crew(a).duration=disease(crew(a).disease).duration then dprint "A crewmember gets sick.",14
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
                        if crew(a).onship=onship then dprint "A crewmember dies of disease.",12
                        crew(a)=crew(0)
                        crew(a).disease=0
                    else
                        if crew(a).onship=onship then dprint " A crewmember recovers.",10
                        crew(a).disease=0
                    endif
                endif
            endif
        endif
        if a=2 and crew(a).hp<=0 and player.pilot>0 then 
            player.pilot=captainskill
            dead-=1
            dprint " Your pilot dies of disease!",12
        endif
        if a=3 and crew(a).hp<=0 and player.gunner>0 then 
            player.gunner=captainskill
            dead-=1
            dprint " Your gunner dies of disease!",12
        endif
        if a=4 and crew(a).hp<=0 and player.science>0 then 
            player.science=captainskill
            dead-=1
            dprint " Your science officer dies of disease!",12
        endif
        if a=5 and crew(a).hp<=0 and player.doctor>0 then 
            player.doctor=captainskill
            dprint " Your doctor dies of disease!",12
        endif
        if crew(a).disease>dis then dis=crew(a).disease
    next
    player.disease=dis
    if total=1 then dprint " A crewmember suffer "& total &" damage from disease.",14
    if total>1 then dprint affected &" crewmembers suffer "& total &" damage from disease.",14
    if dead=1 then dprint " A crewmember dies from disease.",12
    if dead>1 then dprint dead &" crewmembers die from disease.",12
    return 0
end function

function damawayteam(byref a as _monster,dam as short, ap as short=0,disease as short=0) as string
    dim text as string
    dim as short ex,b,t,last,armeff,reequip,roll
    dim target(128) as short
    dim stored(128) as short
    dim injured(13) as short
    dim killed(13) as short
    dim desc(13) as string
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
    'ap=1 Ignores Armor
    'ap=2 All on one, carries over
    'ap=3 All on one, no carrying over
    'ap=4 Ignores Armor, Robots immune
    if abs(player.tactic)=2 then dam=dam-player.tactic
    if dam<0 then dam=1
    for b=1 to 128
        if crew(b).hpmax>0 and crew(b).hp>0 and crew(b).onship=0 then
            last+=1
            target(last)=b
            stored(last)=crew(b).hp
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
            if ap=0 or ap=1 or ap=4 then
                roll=rnd_range(1,20)
                if roll>2+a.secarmo(target(t))+crew(target(t)).augment(5)+player.tactic+addtalent(3,10,1)+addtalent(t,20,1) or ap=4 or ap=1 then
                    if not(crew(target(t)).typ=13 and ap=4) then crew(target(t)).hp=crew(target(t)).hp-1
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
    
    if armeff>0 then text=text &armeff &" prevented by armor. "
    
    for b=1 to 13
        if injured(b)>0 then
            if injured(b)>1 then
                text=text &injured(b) &" "&desc(b)&"s injured. "
            else
                text=text &desc(b)&" injured. "
            endif
        endif
    next
    for b=1 to 13
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
    if killed(2)>0 then player.pilot=captainskill
    if killed(3)>0 then player.gunner=captainskill
    if killed(4)>0 then player.science=captainskill
    if killed(5)>0 then player.doctor=captainskill
    if reequip=1 then equip_awayteam(player,a,player.map)
    return trim(text)
end function

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
    draw string(62*_fw1,0*_fh1),"Status ",,font2,custom,@_col
    color 11,0
    draw string(62*_fw1+7*_fw2,0*_fh2),"(",,font2,custom,@_col
    draw string(62*_fw1+10*_fw2,0*_fh2),""&a.hpmax &"/",,font2,custom,@_col 
    if a.hp/a.hpmax<.7 then color 14,0
    if a.hp/a.hpmax<.4 then color 12,0
    draw string(62*_fw1+13*_fw2,0*_fh2) ,""&a.hp,,font2,custom,@_col
    color 11,0
    draw string(62*_fw1+16*_fw2,0*_fh2), ")",,font2,custom,@_col
   
    for y=2 to 6
        for x=1 to 15
            c=c+1
            if crew(c).hpmax>0 and crew(c).onship=0 then
                if crew(c).hp>0  then
                    color 14,0
                    if crew(c).hp=crew(c).hpmax then color 10,0
                    draw string(62*_fw1+(x-1)*_fw2,(y-1)*_fh2),crew(c).icon,,font2,custom,@_col       
                else
                    color 12,0
                    draw string(62*_fw1+(x-1)*_fw2,(y-1)*_fh2), "X",,font2,custom,@_col
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
    
    dim lev(128) as byte
    for a=1 to 128
        if crew(a).hp>0  then
            roll=rnd_range(1,crew(a).xp)
            if roll+crew(a).augment(10)*2>5+crew(a).hp^2 and crew(a).xp>0 then
                lev(a)+=1
            'else
             '   dprint "Rolled "&roll &", needed "&5+crew(a).hp^2,14,14
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
    if elite>1 then text=text &" "&elite &" of your security are now elite."
    if text<>"" then dprint text,10
    displayship()
    return p
end function

function dplanet(p as _planet,orbit as short,scanned as short) as short
    dim a as short
    dim text as string
    draw_border(0)
      
    color 15,0
    draw string(62*_fw1,1*_fh2), "Scanning Results:",,font2,custom,@_col
    color 11,0
    draw string(62*_fw1,2*_fh2), "Planet in orbit " & orbit,,font2,custom,@_col
    draw string(62*_fw1,3*_fh2), scanned &" km2 scanned",,font2,custom,@_col
    draw string(62*_fw1,5*_fh2), p.water &"% Liq. Surface",,font2,custom,@_col
    text=atmdes(p.atmos) &" atmosphere"
    textbox(text,63,(7*_fh2)/_fh1,16,11,0)    
    draw string(62*_fw1,12*_fh2), "Gravity:"&p.grav &"g",,font2,custom,@_col
    color 10,0
    if p.grav<1 then draw string(62*_fw1+13*_fw2,12*_fh2), "(Low)",,font2,custom,@_col
    color 14,0
    if p.grav>1.5 then draw string(62*_fw1+13*_fw2,12*_fh2), "(High)",,font2,custom,@_col
    color 11,0
            
    
    draw string(62*_fw1,13*_fh2), "Avg. Temperature",,font2,custom,@_col
    draw string(62*_fw1,15*_fh2), p.temp &" "&chr(248)&"c",,font2,custom,@_col
    if p.rot>0 then
        draw string(62*_fw1,16*_fh2),"Rot.:"&p.rot*24 &" h",,font2,custom,@_col
    else
        draw string(62*_fw1,16*_fh2),"Rot.: Nil",,font2,custom,@_col
    endif
    draw string(62*_fw1,18*_fh2),"Lifeforms:",,font2,custom,@_col
    draw string(62*_fw1,19*_fh2),p.life*10 &" % probability",,font2,custom,@_col
    return 0
end function

function blink(byval p as _cords) as short
    static c as short
    c+=1
    locate p.y+1,p.x+1
    
    if c>=1000 then
        c=0
        color 11,11
        draw string (p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
    else
        color 11,11
        draw string (p.x*_fw1,p.y*_fh1)," ",,font1,custom,@_col
    endif
    return 0
end function

function cursor(target as _cords,map as short) as string
    dim key as string 
    blink(target)    
    key=keyin
    'dprint ""&planetmap(target.x,target.y,map)
    locate target.y+1,target.x+1
    if map>0 then
        if planetmap(target.x,target.y,map)<0 then
            color 0,0
            draw string (target.x*_fw1,target.y*_fh1)," ",,font1,custom,@_col
        else
            if target.x>=0 and target.y>=0 and target.x<=60 and target.y<=20 then dtile(target.x,target.y,tiles(planetmap(target.x,target.y,map)))
        endif
    else
        color 0,0
        draw string (target.x*_fw1,target.y*_fh1)," ",,font1,custom,@_col
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

function draw_border(xoffset as short) as short
    dim as short fh1,fw1,fw2,a
    if _tiles=0 then
        fh1=16
        Fw1=gfx.font.gettextwidth(FONT1,"W")
        fw2=_fw2
    else
        fh1=_fh1
        fw1=_fw1
        fw2=_fw2
    endif
    color 224,1
    if xoffset>0 then draw string(xoffset*fw2,21*_fh1),chr(195),,Font1,Custom,@_col
    for a=(xoffset+1)*fw2 to 61*_fw1 step fw1
        draw string (a,21*_fh1),chr(196),,Font1,custom,@_col
    next
    for a=0 to _screeny-fh1 step fh1
        draw string (61*_fw1,a),chr(179),,Font1,custom,@_col
    next
    draw string (61*_fw1,21*_fh1),chr(180),,Font1,custom,@_col
    color 11,0
    return 0
end function


sub show_stars(bg as short=0,byref walking as short)
    dim as short a,b,x,y,navcom,mask
    dim as _cords p,p1,p2
    dim range as integer
    dim as single dx,dy,l,x1,y1,vis
    dim m as _monster
    dim vismask(sm_x,sm_y) as byte
    if bg<2 then
        player.osx=player.c.x-30
        player.osy=player.c.y-10
        if player.osx<=0 then player.osx=0
        if player.osy<=0 then player.osy=0
        if player.osx>=sm_x-60 then player.osx=sm_x-60
        if player.osy>=sm_y-20 then player.osy=sm_y-20
    endif
    m.sight=player.sensors+5.5
    m.c=player.c
    makevismask(vismask(),m,-1)
    navcom=findbest(52,-1)
    for x=player.c.x-1 to player.c.x+1
        for y=player.c.y-1 to player.c.y+1
            if x>=0 and y>=0 and x<=sm_x and y<=sm_y then vismask(x,y)=1
        next
    next
    
    if bg>0 then
        for x=0 to 60
            for y=0 to 20
                locate y+1,x+1,0
                color 1,0
                if spacemap(x+player.osx,y+player.osy)=1 and navcom>0 then 
                    if _tiles=0 then
                        put (x*_fw1+1,y*_fh1+1),gtiles(50),pset
                    else
                        draw string (x*_fw1,y*_fh1),".",,FONT1,custom,@_col
                    endif
                endif
                if spacemap(x+player.osx,y+player.osy)>=2 and  spacemap(x+player.osx,y+player.osy)<=5 then 
                    if _tiles=0 then
                        put (x*_fw1+1,y*_fh1+1),gtiles(abs(spacemap(x+player.osx,y+player.osy))+49),pset
                    else                        
                        color rnd_range(48,59),1
                        if spacemap(x+player.osx,y+player.osy)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(48,59),1
                        if spacemap(x+player.osx,y+player.osy)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(96,107),1
                        if spacemap(x+player.osx,y+player.osy)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(144,155),1
                        if spacemap(x+player.osx,y+player.osy)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(192,203),1
                        draw string (x*_fw1,y*_fh1),chr(176),,Font1,custom,@_col
                    endif
                endif
                if abs(spacemap(x+player.osx,y+player.osy))>=6 and abs(spacemap(x+player.osx,y+player.osy))<=17 then
                    if _tiles=0 then 
                        if spacemap(x+player.osx,y+player.osy)>=6 and spacemap(x+player.osx,y+player.osy)<=17  then 
                            put (x*_fw1+1,y*_fh1+1),gtiles(abs(spacemap(x+player.osx,y+player.osy))+49),pset
                        endif
                    else
                        if abs(spacemap(x+player.osx,y+player.osy))=6 then color 9,0
                        if abs(spacemap(x+player.osx,y+player.osy))=7 then color 113,0
                        if abs(spacemap(x+player.osx,y+player.osy))=8 then color 53,0
                        if abs(spacemap(x+player.osx,y+player.osy))>8 then color 3,0
                        if spacemap(x+player.osx,y+player.osy)>=6 and spacemap(x+player.osx,y+player.osy)<=17  then 
                            draw string (x*_fw1,y*_fh1),":",,Font1,custom,@_col
                        else
                            color 1,0
                            'if navcom>0 and spacemap(x+player.osx,y+player.osy)>0 then draw string (x*_fw1,y*_fh1),".",,Font1,custom,@_col
                        endif
                    endif
                endif
            next
        next
        if show_NPCs>0 then
            for a=firstwaypoint to lastwaypoint
                color 11,0
                if a>=firststationw then color 15,0
                if targetlist(a).x-player.osx>=0 and targetlist(a).x-player.osx<=60 and targetlist(a).y-player.osy>=0 and targetlist(a).y-player.osy<=20 then
                    draw string((targetlist(a).x-player.osx)*_fw1,(targetlist(a).y-player.osy)*_fh1),";",,Font1,Custom,@_tcol
                endif
            next
        endif
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
                locate y+1-player.osy,x+1-player.osx,0
                color 1,0
                if abs(spacemap(x,y))=1 and navcom>0 and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5  then
                    if _tiles=1 then
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    else
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(50),pset
                    endif
                endif
                if abs(spacemap(x,y))>=2 and abs(spacemap(x,y))<=5 and vismask(x,y)>0  and distance(p,player.c)<player.sensors+0.5 then 
                    if _tiles=1 then
                        color rnd_range(48,59),1
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(48,59),1
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(96,107),1
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(144,155),1
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then color rnd_range(192,203),1
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),chr(177),,Font1,custom,@_col 
                    else                        
                        put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),pset
                        if spacemap(x,y)=2 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(51),pset
                        if spacemap(x,y)=3 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(52),pset
                        if spacemap(x,y)=4 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(53),pset
                        if spacemap(x,y)=5 and rnd_range(1,6)+rnd_range(1,6)+player.pilot>8 then put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(54),pset
                    endif
                endif
                if abs(spacemap(x,y))>=6 and abs(spacemap(x,y)<=17) and vismask(x,y)>0 and distance(p,player.c)<player.sensors+0.5 then
                    if (spacemap(x,y)>=6 and spacemap(x,y)<=17) or rnd_range(1,6)+rnd_range(1,6)+player.pilot>8  then 
                        if _tiles=0 then
                            put ((x-player.osx)*_tix+1,(y-player.osy)*_tiy+1),gtiles(49+abs(spacemap(x,y))),pset
                        else
                            if abs(spacemap(x,y))>8 then color 3,0
                            if abs(spacemap(x,y))=6 then color 9,0
                            if abs(spacemap(x,y))=7 then color 113,0
                            if abs(spacemap(x,y))=8 then color 53,0
                            draw string (x*_fw1-player.osx*_fw1,y*_fh1-player.osy*_fh1),":",,Font1,custom,@_col
                        endif
                        if spacemap(x,y)<=-6 then ano_money+=15
                        spacemap(x,y)=abs(spacemap(x,y))
                    else
                        color 1,0
                        if navcom>0 then draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),".",,Font1,custom,@_col
                    endif
                endif
            endif
        next
    next


    a=findbest(51,-1)
    if a>0 then
        for b=3 to lastfleet
            x=fleet(b).c.x
            y=fleet(b).c.y
            locate y+1-player.osy,x+1-player.osx,0
            if vismask(x,y)=1 and distance(player.c,fleet(b).c)<player.sensors then
                color 11,0 
                if item(a).v1=1 then
                    color 11,0
                    if _tiles=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),pset
                    else
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
                else
                    
                    if _tiles=0 then
                        put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(86),pset
                        if fleet(b).ty=1 or fleet(b).ty=3 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(67),pset
                        if fleet(b).ty=2 or fleet(b).ty=4 then put ((x-player.osx)*_fw1,(y-player.osy)*_fh1),gtiles(68),pset
                    else
                        if fleet(b).ty=1 or fleet(b).ty=3 then color 10,0
                        if fleet(b).ty=2 or fleet(b).ty=4 then color 12,0
                        if fleet(b).ty=5 then color 5,0
                        if fleet(b).ty=6 then color 8,0
                        if fleet(b).ty=7 then color 8,0
                        draw string ((x-player.osx)*_fw1,(y-player.osy)*_fh1),"s",,Font1,custom,@_col
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
            if drifting(x).s>=20 then color 15,0
            if (a>0 and vismask(p.x,p.y)=1 and distance(player.c,p)<player.sensors) or drifting(x).p>0 then
                if p.x+1-player.osx>0 and p.x+1-player.osx<61 and p.y+1-player.osy>0 and p.y+1-player.osy<21 then 
                    locate p.y+1-player.osy,p.x+1-player.osx
                    if _tiles=0 then
                        put ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),gtiles(87),pset
                    else
                        draw string ((p.x-player.osx)*_fw1,(p.y-player.osy)*_fh1),"s",,Font1,custom,@_col
                    endif
                    if drifting(x).p=0 then walking=0
                    drifting(x).p=1
                endif
            endif
        endif
    next
    if show_NPCs>0 then
        for a=3 to lastfleet
            x=fleet(a).c.x-player.osx
            y=fleet(a).c.y-player.osy
            if x>=0 and x<=60 and y>=0 and y<=20 then
                if fleet(a).ty=1 or fleet(a).ty=3 then color 10,0
                if fleet(a).ty=2 or fleet(a).ty=4 then color 12,0
                if fleet(a).ty=5 then color 5,0
                if fleet(a).ty=6 then color 8,0
                if fleet(a).ty=7 then color 6,0
                draw string (x*_fw1,(y)*_fh1),"s",,Font1,custom,@_col
            endif
            x=targetlist(fleet(a).t).x-player.osx
            y=targetlist(fleet(a).t).y-player.osy
            if x>=0 and x<=60 and y>=0 and y<=20 then
                color 15,0
                draw string (x*_fw1,y*_fh1),"*",,Font1,custom,@_col
            endif
        next
    endif
    if show_civs=1 then
        for a=0 to 1
            x=civ(a).home.x-player.osx
            y=civ(a).home.y-player.osy
            if x>=0 and x<=60 and y>=0 and y<=20 then
                color 11,0
                draw string ((x)*_fw1,(y)*_fh1)," "&a,,Font1,custom,@_col
            endif
        next
    endif
    color 11,0
    for a=1 to lastcom
        if coms(a).c.x>player.osx and coms(a).c.x<player.osx+60 and coms(a).c.y>player.osy and coms(a).c.y<player.osy+20 then
            draw string ((coms(a).c.x-player.osx)*_fw1,(coms(a).c.y-player.osy)*_fh1),trim(coms(a).t),,Font2,custom,@_col
        endif
    next
    
    for a=0 to laststar+wormhole
        if map(a).spec<8 then
            vis=maximum(player.sensors+.5,(map(a).spec)-2)
        else
            vis=0
        endif
            
        if (vismask(map(a).c.x,map(a).c.y)=1 and distance(map(a).c,player.c)<=vis) or map(a).discovered>0 then 
            if map(a).discovered=0 then walking=0
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
    if a=3 then
        bsave player.desig &".bmp",0
    endif
    'a=0 screen in file drucken
    'a=1 screen in scrn speichern
    'a=2 screen aus scrn ausgeben
    return 0
end function

function bioreport(slot as short) as short
    dim a as short
    dim as string t,h
    screenshot(1)
    t="Bio Report for /"
    h="/"
    for a=0 to 16
        if planets(slot).mon_seen(a)>0 or planets(slot).mon_killed(a)>0 or planets(slot).mon_caught(a)>0 then 
            t=t & planets(slot).mon_template(a).sdesc &"/"
            h=h & " | "&planets(slot).mon_template(a).ldesc &" | | Visual  :"
            if planets(slot).mon_seen(a)>0 then
                h=h &" Yes"
            else
                h=h &" No"
            endif
            h=h & " | Killed  : "&planets(slot).mon_killed(a)
            h=h & " | Disected: "&planets(slot).mon_disected(a)
            h=h & " | Caught  : "&planets(slot).mon_caught(a) &" | /"
        endif
    next
    t=t &"Exit"
    do
    loop until menu(t,h)
    screenshot(2)
    return 0
end function

function logbook() as short
    cls
    dim lobk(30,20) as string 'lobk is description
    dim lobn(30,20) as short 'lobn is n to get map(n)
    dim lobc(30,20) as short 'lobc is bg color
    static as _cords curs,curs2
    dim as short x,y,a,b,p,m,lx,ly,dlx
    dim as string key,lobk1,lobk2

    x=0
    y=0
    for a=0 to laststar
        if map(a).desig<>"" then
            if map(a).spec<8 or map(a).discovered>1 then
                lobk(x,y)=trim(map(a).desig)
                if map(a).comment<>"" then lobk(x,y)=lobk(x,y) &" (c)"
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
    b=0
    if y<>0 then ly=y+(lx*21) else ly=(lx*21)-1
    if y=0 and lx>1 then lx-=1
    for a=0 to ly       'tests all lobk() and order them by coordenates
        for b=0 to (ly-1)   'ly is not coord, it is counter for planet check
            'print "testing x and y of system: " &lobk(int(b/21), (b mod 21)) &" b=" &(b mod 21)
            lobk1=mid(lobk(int(b/21), (b mod 21)), 4)
            'this is first lobk(x,y)==> val(mid(lobk(int(y/20)+1,(y mod 20) + 1),4))
            do
                lobk1 = mid(lobk1, 2)
            loop until left(lobk1,1) = "(" or left(lobk1,1) =""
            lobk1 = mid(lobk1, 2)
           
            lobk2 = mid(lobk(int((b+1)/21),((b+1) mod 21)),4)
            do
                lobk2 = mid(lobk2, 2)
            loop until left(lobk2,1) = "(" or left(lobk2,1) =""
            lobk2 = mid(lobk2, 2)
           
            if val(lobk1) > val(lobk2) or ltrim(lobk1)="" then
                swap lobk(int(b/21), (b mod 21)), lobk(int((b+1)/21),((b+1) mod 21))
                swap lobn(int(b/21), (b mod 21)), lobn(int((b+1)/21),((b+1) mod 21))
            endif
            'if first x cord in string lobk is bigger then swap with next item of list
            if val(lobk1) = val(lobk2) then
                'if x cords are equal, test y cords
                do
                    lobk1 = mid(lobk1, 2)
                loop until left(lobk1,1) = ":" or left(lobk1,1) =""
                lobk1 = mid(lobk1, 2)
                'check for y cords in lobk1/2 strings
               
                do
                    lobk2 = mid(lobk2, 2)
                loop until left(lobk2,1) = ":" or left(lobk2,1) =""
                lobk2 = mid(lobk2,2)
                'check for y cords in lobk1/2 strings
               
                if val(lobk1) > val(lobk2) then 'swap to next if x of lobk2 is bigger
                    swap lobk(int(b/21), (b mod 21)), lobk(int((b+1)/21),((b+1) mod 21))
                    swap lobn(int(b/21), (b mod 21)), lobn(int((b+1)/21),((b+1) mod 21))
                endif
            endif
        next
    next
    for a=0 to ly       'tests all lobn for special planets, system comments and planets comments for coloring bg
        'print "test for special planets and change lobc (bg color): system " &map(lobn(int(a/21), (a mod 21))).desig 'debug
        b=0
        if map(lobn(int(a/21), (a mod 21))).comment<>"" then lobc(int(a/21), (a mod 21))=228
        for p=1 to 9 'find number of planet in system's orbits
            m=map(lobn(int(a/21), (a mod 21))).planets(p)
            if m>0 then
                if planets(m).comment<>"" then lobc(int(a/21), (a mod 21))=241
                b+=1
            endif
        next
        'print b 'debug msg
        for p=1 to b
            for b=0 to lastspecial
                'print "test for special planets and change lobc (bg color): system " &map(lobn(int(a/21), (a mod 21))).desig &" system orbit " &p 'debug
                if map(lobn(int(a/21), (a mod 21))).planets(p)>0 then
                    if planetmap(0,0,map(lobn(int(a/21), (a mod 21))).planets(p))<>0 and map(lobn(int(a/21), (a mod 21))).planets(p)=specialplanet(b) then lobc(int(a/21), (a mod 21))=233
                endif
            next
        next
    next
    dlx=0
    dprint "Press " &key_sc &" or enter to choose system. ESC to exit."
   
    do
        cls
        displayship(1)
       
        if curs.x<dlx then dlx-=1 'when curs.x is lower then first display column (dlx) then lower display column
        if curs.x>(dlx+4) then dlx+=1 'increase first display column
        if curs.x=0 then dlx=0
        if curs.x=lx and lx>4 then dlx=lx-4
        if lobk(curs.x+1,curs.y)="" and curs.x>dlx+4 then dlx=lx-4 'when go back from first to last column and the element does not contain text it goes to the column before that, this correct the screen
        if curs.x<dlx or curs.x>(dlx+4) then dlx=curs.x-2 'when lost make display column curs.x center
       
        for x=dlx to (dlx+4)
            for y=0 to 20
                locate y+1,((x-dlx)*12)+1
                if x=curs.x and y=curs.y then
                    color 15,3
                else
                    color 11, 0
                    if lobc(x,y)<>0 then color 11, lobc(x,y)
                endif
                if lobk(x,y)<>"" then
                    draw string (x*12*_fw2,y*_fh2),lobk(x,y),,Font2,custom,@_col
                else
                    draw string (x*12*_fw2,y*_fh2),"       ",,Font2,custom,@_col
                endif
            next
        next
       
        if map(lobn(curs.x,curs.y)).discovered>1 then
            displaysystem(lobn(curs.x,curs.y),1)
        else
            dprint trim(map(lobn(curs.x,curs.y)).desig)&": only long range data."
        endif
        if map(lobn(curs.x,curs.y)).comment<>"" then dprint map(lobn(curs.x,curs.y)).comment
       
        'fill msg area with planets comments, if there are more then shown, then msg there are more.
        p=0
        b=0
        lobk1=""
        if map(lobn(curs.x,curs.y)).comment<>"" then b=1
        do 'print max of 2 planets comments
            p+=1
            m=map(lobn(curs.x,curs.y)).planets(p)
            if m>0 then
                if planets(m).comment<>"" then
                    if b<2 then dprint "Orbit " &p &":" &planets(m).comment &"." 'print when b=0 or b=1
                    if b=2 then lobk1=str(p) &":" &planets(m).comment &"." 'store third planet comments
                    b+=1
                endif
            endif
        loop until p=9 or b=3 'test for 4 planets with comments
        if b>1 and lobk1<>"" then
            if b=2 then dprint "Orbit " &lobk1 endif
            if b=3 then dprint "Orbit " &lobk1 &" .Enter to see more comments."
        elseif b>1 then
            if b=2 then dprint "Orbit " &p endif
            if b=3 then dprint "Orbit " &p &" .Enter to see more comments."
        endif
       
        key=keyin("123456789 " &key_sc &key_esc &key_enter &key_comment)
        'make curs goes arround edges
        a=getdirection(key)
        if a=5 then key=key_enter endif
        if a=1 then
            curs.x=curs.x-1
            curs.y=curs.y+1
            'if diagonal don't wrap on up and down edges
            if curs.y=21 then curs.y=20 endif
        endif
        if a=2 then
            curs.x=curs.x
            curs.y=curs.y+1
        endif
        if a=3 then
            curs.x=curs.x+1
            curs.y=curs.y+1
            'if diagonal don't wrap on up and down edges
            if curs.y=21 then curs.y=20 endif
        endif
        if a=4 then
            curs.x=curs.x-1
            curs.y=curs.y
        endif
        if a=6 then
            curs.x=curs.x+1
            curs.y=curs.y
        endif
        if a=7 then
            curs.x=curs.x-1
            curs.y=curs.y-1
            'if diagonal don't wrap on up and down edges
            if curs.y=-1 then curs.y=0 endif
        endif
        if a=8 then
            curs.x=curs.x
            curs.y=curs.y-1
        endif
        if a=9 then
            curs.x=curs.x+1
            curs.y=curs.y-1
            'if diagonal don't wrap on up and down edges
            if curs.y=-1 then curs.y=0 endif
        endif
        if curs.x<0 or curs.x>lx or curs.y<0 or curs.y>20 then
            if curs.y<0 then
                curs.y=20
                curs.x-=1
            endif
            if curs.y>20 then
                curs.y=0
                curs.x+=1
            endif
        endif
        if curs.x<0 then curs.x=lx endif
        if curs.x>lx then curs.x=0 endif

        if lobk(curs.x,curs.y)=""  and curs.y>0 then
            if a=4 or a=1 or a=7 then curs.x-=1 endif
            if a=6 or a=9 or a=3 or a=8 then 'returning from curs=(0,0) then search for valid system
                'going to last column , same row not valid then go last valid row
                do
                    curs.y-=1
                loop until lobk(curs.x,curs.y)<>"" or curs.y=0
            endif
            if a=2 then curs.x=0: curs.y=0 endif
        endif
       
        if key=key_comment and lobn(curs.x,curs.y)<>0 then
            dprint "Enter comment on system"
            map(lobn(curs.x,curs.y)).comment=gettext(pos,csrlin-1,60,map(lobn(curs.x,curs.y)).comment)
            if map(lobn(curs.x,curs.y)).comment<>"" then lobc(curs.x,curs.y)=228
        endif
       
        if key=key_enter and map(lobn(curs.x,curs.y)).discovered>1 then
            for p=1 to 9
                if map(lobn(curs.x, curs.y)).planets(p)>0 then
                    if planets(map(lobn(curs.x,curs.y)).planets(p)).comment<>"" then dprint "Orbit " &p &":" &planets(map(lobn(curs.x,curs.y)).planets(p)).comment
                endif
            next
            do
                p=getplanet(lobn(curs.x,curs.y),1)
                if p>0 then
                    m=map(lobn(curs.x,curs.y)).planets(p)
                    if m>0 then
                        if planets(m).comment<>"" then dprint planets(m).comment
                        if planetmap(0,0,m)=0 then
                            cls
                            displayship(1)
                            color 15,0
                            draw string (15*_fw1,10*_fh1),"No map data for this planet.",,Font2,custom,@_col
                            no_key=keyin
                        else
                            cls
                            do
                                dplanet(planets(m),p,planets(m).mapped)
                                displayplanetmap(m)
                                no_key=keyin(key_comment &key_report &key_esc)
                                if no_key=key_comment then
                                    dprint "Enter comment on planet"
                                    planets(m).comment=gettext(pos,csrlin-1,60,planets(m).comment)
                                    if planets(m).comment<>"" and map(lobn(curs.x,curs.y)).comment="" then lobc(curs.x,curs.y)=241
                                endif
                                if no_key=key_report then
                                    bioreport(m)
                                endif   
                            loop until no_key<>key_comment or no_key<>key_report
                        endif
                    endif
                endif
            loop until no_key=key_esc or p=-1
            key=""
        endif
    loop until key=key_esc or player.dead<>0
    return 0
end function
'
'function logbook() as short
'    cls
'    dim lobk(5,20) as string
'    dim lobn(5,20) as short
'    static as _cords curs,curs2
'    dim as short x,y,a,p,m,lx
'    dim key as string
'    do
'        x=0
'        y=0
'        for a=0 to laststar
'            if map(a).desig<>"" then
'                if map(a).spec<8 or map(a).discovered>1 then
'                    lobk(x,y)=trim(map(a).desig)
'                    if map(a).comment<>"" then lobk(x,y)=lobk(x,y) &" (c)"
'                    lobn(x,y)=a
'                    y=y+1
'                    if y>20 then
'                        y=0
'                        x=x+1
'                    endif
'                endif
'            endif
'        next
'        lx=x
'        cls
'        displayship(1)
'        for x=0 to 5
'            for y=0 to 20
'                locate y+1,(x*12)+1
'                if x=curs.x and y=curs.y then
'                    color 15,3
'                else
'                    color 11,0
'                endif
'                if lobk(x,y)<>"" then
'                    draw string (x*12*_fw2,y*_fh2),lobk(x,y),,Font2,custom,@_col
'                    else
'                    draw string (x*12*_fw2,y*_fh2),"       ",,Font2,custom,@_col
'                endif
'            next
'        next
'        if map(lobn(curs.x,curs.y)).discovered>1 then 
'            displaysystem(lobn(curs.x,curs.y),1) 
'        else
'            dprint "Only long range data"
'        endif
'        if map(lobn(curs.x,curs.y)).comment<>"" then dprint map(lobn(curs.x,curs.y)).comment
'        key=keyin
'        curs2=movepoint(curs,getdirection(key))
'        if lobn(curs2.x,curs2.y)<>0 then curs=curs2
'        if key=key_comment and lobn(curs.x,curs.y)<>0 then
'            dprint "Enter comment on system"
'            map(lobn(curs.x,curs.y)).comment=gettext(pos,csrlin-1,60,map(lobn(curs.x,curs.y)).comment)
'        endif
'        
'        if key=key_enter and map(lobn(curs.x,curs.y)).discovered>1 then
'            p=getplanet(lobn(curs.x,curs.y),1)
'            if p>0 then
'                m=map(lobn(curs.x,curs.y)).planets(p)
'                if m>0 then
'                    if planets(m).comment<>"" then dprint planets(m).comment
'                    if planetmap(0,0,m)=0 then
'                        cls
'                        displayship(1)
'                        color 15,0
'                        draw string (15*_fw1,10*_fh1),"No map data for this planet.",,Font2,custom,@_col
'                        no_key=keyin
'                    else
'                        cls
'                        do
'                            dplanet(planets(m),p,planets(m).mapped)
'                            displayplanetmap(m)
'                            no_key=keyin(key_comment &key_report &key_esc)
'                            if no_key=key_comment then
'                                dprint "Enter comment on planet"
'                                planets(m).comment=gettext(pos,csrlin-1,60,planets(m).comment)
'                            endif
'                            if no_key=key_report then
'                                bioreport(m)
'                            endif    
'                        loop until no_key<>key_comment or no_key<>key_report
'                    endif
'                endif
'            endif
'            key=""
'        endif
'        if curs.x>lx then curs.x=lx
'        if curs.y>20 then curs.y=20
'    loop until key=key_esc or player.dead<>0
'    return 0
'end function
'

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
            if keyplus(key) or key=key_north then offset=offset-22
            if keyminus(key) or key=key_south then offset=offset+22
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
    dim as short a,ll
    screenshot(1)
    ll=_lines*_fh1/_fh2
    cls
    for a=1 to ll
        locate a,1 
        color dtextcol(a),0
        draw string (0,a*_fh2), displaytext(a),,font2,custom,@_col
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

function showwormholemap() as short
    dim as short x,y,i,x1,x2,i2,y1,y2,d,n,l
    dim p(128) as _cords
    cls
    displayship
    for x=0 to sm_x
        for y=0 to sm_y
            if spacemap(x,y)>0 then
                color 1,0
                locate map(i).c.y+1,map(i).c.x+1
                print "."
            endif
        next
    next
    color 15,0
    
    for i=laststar+1 to laststar+wormhole
        if map(i).planets(2)=1 then
            l=line_in_points(map(i).c,map(map(i).planets(1)).c,p())
            n=distance(map(i).c,map(map(i).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            color 179+n,0
            for i2=1 to l-1
                locate p(i2).y+1,p(i2).x+1
                print "."
            next
        endif
    next
    for i=laststar+1 to laststar+wormhole
        if map(i).discovered<>0 then
            n=distance(map(i).c,map(map(i).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            color 179+n,0
            locate map(i).c.y+1,map(i).c.x+1
            print "o"
            locate map(i).c.y+1,map(i).c.x+2
        endif
    next
    for i=1 to laststar
        if map(i).discovered<>0 then
            color spectraltype(map(i).spec),0
            locate map(i).c.y+1,map(i).c.x+1
            print "*"
        endif
    next
    dprint "Displaying wormhole map"
    no_key=keyin
    return 0
end function


function keyin(byref allowed as string="" , byref walking as short=0,blocked as short=0)as string
    dim key as string
    dim as string text
    static as byte recording
    static as byte seq
    static as string*3 comseq
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
                return ""
            endif
            if key=key_screenshot then 
                screenshot(3)
                dprint "saved screenshot in screenshot.bmp"
                return ""
            endif
            if key=key_messages then 
                messages
                return ""
            endif
            if key=key_configuration then
                configuration
                return ""
            endif
            if key=key_tactics then
                settactics
                return ""
            endif
            if key=key_shipstatus then         
                shipstatus()
                return ""
            endif
            if key=key_logbook then
                logbook
                return ""
            endif

            if key=key_equipment then
                a=getitem(999)
                if a>0 then dprint item(a).ldesc
                key=keyin()
                return ""
            endif

            if key=key_quests then
                showquests
                return ""
            endif
            if key=key_wormholemap then
                showwormholemap
                return ""
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
        if key="$" and dbshow_factionstatus=1 then
            
            for a=0 to 7
                text="Faction "&a
                for b=0 to 7
                    text=text &":"&faction(a).war(b)
                next
                dprint text
            next
            
        
        endif
        if len(allowed)>0 and key<>key_esc and key<>key_enter and getdirection(key)=0 then
            if instr(allowed,key)=0 then key=""
        endif
        if recording=2 then walking=-1
    loop until key<>"" or walking <>0 or just_run=1
    while inkey<>""
    wend
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
    if spacemap(map(a).c.x,map(a).c.y)=6 then bg=1
    for p=1 to 9
        if map(a).planets(p)>0 then
            for n=0 to lastspecial
                color 11,0
                locate 1,1
                if map(a).planets(p)=specialplanet(n) and planets(map(a).planets(p)).mapstat>0 then 
                    bg=233
                endif
                if show_specials<>0 and map(a).planets(p)=specialplanet(show_specials) then
                    locate map(a).c.y-player.osy+2,map(a).c.x-player.osx+2,0
                    color 11
                    
                    draw string((map(a).c.x-player.osx+1)*_fw1,(map(a).c.y-player.osy+1)*_fh1) ,""&n
                endif
            next
            if planets(map(a).planets(p)).colony<>0 then bg=246
        endif
    next
    if map(a).discovered=0 then 
        player.discovered(map(a).spec)=player.discovered(map(a).spec)+1
        map(a).desig=spectralshrt(map(a).spec)&player.discovered(map(a).spec)&"-"&int(disnbase(map(a).c))&"("&map(a).c.x &":"& map(a).c.y &")"
        map(a).discovered=1
    endif
    if _tiles=0 then
        put (x*_tix+1,y*_tiy+1),gtiles(map(a).ti_no),trans
    else        
        color spectraltype(map(a).spec),bg
        locate map(a).c.y+1-player.osy,map(a).c.x+1-player.osx,0
        if map(a).spec<8 then draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"*",,Font1,custom,@_col
        if map(a).spec=8 then     
            color 7,bg
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
        endif
            
        if map(a).spec=9 then 
            n=distance(map(a).c,map(map(a).planets(1)).c)/5
            if n<1 then n=1
            if n>6 then n=6
            color 179+n,bg
            draw string ((map(a).c.x-player.osx)*_fw1,(map(a).c.y-player.osy)*_fh1),"o",,Font1,custom,@_col
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
        draw string (x*_fw1,y*_fh1),"S",,Font1,custom,@_col
    else
        put ((x)*_tix+1,(y)*_tiy+1),gtiles(44),pset
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
        put (x*_tix,y*_tiy),gtiles(gt_no(tiles.ti_no)),pset
    else
        if _showvis=0 and bg>0 and bgcol=0 then 
            bgcol=234
        endif
        color col,bgcol
        
        draw string (x*_fw1,y*_fh1),chr(tiles.tile),,Font1,custom,@_col
    endif
    color 11,0    
end sub

sub displaysystem(in as short,forcebar as byte=0,hi as byte=0)
    dim as short a,b,bg,x,y
    dim as string bl,br
    if _onbar=0 or forcebar=1 then
        y=21
        x=28
        bl=chr(180)
        br=chr(195)
    else
        x=map(in).c.x-12-player.osx
        y=map(in).c.y+1-player.osy
        if x<0 then x=0
        if x*_fw1+21*_fw2>60*_fw1 then x=60*_fw1-21*_fw2
        bl="["
        br="]"
    endif
    drawsysmap(x*_fw1,y*_fh1,in,hi,bl,br)
    color 11,0
end sub

function drawsysmap(x as short, y as short, in as short, hi as short=0,bl as string,br as string) as short
    dim as short a,b,bg,yof
    dim t as string
    color 224,0
    yof=(_fh1-_fh2)/2
    draw string(x,y),bl ,,font1,custom,@_col
    draw string (x+_fw2,y+yof), space(25),,font2,custom,@_col
    draw string(x+25*_fw2,y),br ,,font1,custom,@_col
    color spectraltype(map(in).spec),0
    draw string(x+_fw1,y), "*"&space(2),,font1,custom,@_col
    for a=1 to 9
        bg=0
        for b=0 to lastspecial
            if map(in).planets(a)>0 then
                if map(in).planets(a)=specialplanet(b) and planets(map(in).planets(a)).mapstat<>0 then bg=233
            endif
        next
        if hi=a then bg=11
        t=""
        if map(in).planets(a)<>0 then
            if isgasgiant(map(in).planets(a))<>0 then 
                t="O"
                if a>5 then color 63,bg
                if a<6 then color 162,bg
                if a=1 then color 164,bg
            endif
            if isasteroidfield(map(in).planets(a))<>0 then 
                t=chr(176)
                color 7,bg
            endif
            if isasteroidfield(map(in).planets(a))=0 and isgasgiant(map(in).planets(a))=0 and map(in).planets(a)>0 then 
                t="o"
                if planets(map(in).planets(a)).mapstat=0 then color 7,bg  
                if planets(map(in).planets(a)).mapstat=1 then  
                    if planets(map(in).planets(a)).atmos=1 then color 15,bg      
                    if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then color 101,bg
                    if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then color 210,bg
                    if planets(map(in).planets(a)).atmos>11 then color 10,bg
                endif
                if planets(map(in).planets(a)).mapstat=2 then  
                    if planets(map(in).planets(a)).atmos=1 then color 8,bg      
                    if planets(map(in).planets(a)).atmos>1 and planets(map(in).planets(a)).atmos<7 then color 9,bg
                    if planets(map(in).planets(a)).atmos>6 and planets(map(in).planets(a)).atmos<12 then color 198,bg
                    if planets(map(in).planets(a)).atmos>11 then color 54,bg
                endif
            endif
            draw string(x+_fw2*(a*2+4),y+yof),t,,font2,custom,@_col
        endif
    next
    return 0
end function

function nextplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p+1
        if p>9 then p=1
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function

function prevplan(p as short,in as short) as short
    dim as short oldp
    oldp=p
    do
        p=p-1
        if p<1 then p=9
    loop until map(in).planets(p)<>0 or p=oldp
    return p
end function
'
function getplanet(sys as short,forcebar as byte=0) as short
    dim as short r,p
    dim as string text,key
    dim as _cords p1
    if sys<0 or sys>laststar then
        dprint ("ERROR:System#:"&sys,14)
        return -1
    endif
    map(sys).discovered=2
    p=liplanet
    if p<1 then p=1
    if p>9 then p=9
    if map(sys).planets(p)=0 then p=nextplan(p,sys)
    if lastplanet>0 then
        dprint "Enter to select, arrows to move,ESC to quit"
        if show_mapnr=1 then dprint map(sys).planets(p)&":"&isgasgiant(map(sys).planets(p))
        do
            displaysystem(sys,,p)        
            key=""
            key=keyin
            if keyplus(key) or key=key_east or key=key_north then p=nextplan(p,sys)
            if keyminus(key) or key=key_west or key=key_south then p=prevplan(p,sys)
            if key=key_comment then
                dprint "Enter comment on planet: "
                p1=locEOL
                planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
            endif
            if key="q" or key="Q" or key=key_esc then r=-1
            if (key=key_enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
        loop until r<>0
        liplanet=r
    else
        r=-1
    endif
    return r
end function

'function getplanet(sys as short,forcebar as byte=0) as short
'    dim as short a,r,p,x,xo,yo
'    dim text as string
'    dim key as string
'    dim firstplanet as short
'    dim lastplanet as short
'    dim p1 as _cords
'    if sys<0 or sys>laststar then
'        dprint ("ERROR:System#:"&sys,14)
'        return -1
'    endif
'    for a=1 to 9
'        if map(sys).planets(a)<>0 then
'            lastplanet=a
'            x=x+1
'        endif
'    next
'    for a=9 to 1 step-1
'        if map(sys).planets(a)<>0 then firstplanet=a
'    next
'    p=liplanet
'    if p<1 then p=1
'    if p>9 then p=9
'    if map(sys).planets(p)=0 then
'        do
'            p=p+1
'            if p>9 then p=1
'        loop until map(sys).planets(p)<>0 or lastplanet=0
'    endif
'    if p>9 then p=firstplanet
'    if lastplanet>0 then
'        if _onbar=0 or forcebar=1 then
'            xo=31
'            yo=22
'        else
'            xo=map(sys).c.x-9-player.osx
'            yo=map(sys).c.y+2-player.osy
'            if xo<=4 then xo=4
'            if xo+18>58 then xo=42
'        endif
'        dprint "Enter to select, arrows to move,ESC to quit"
'        if show_mapnr=1 then dprint map(sys).planets(p)&":"&isgasgiant(map(sys).planets(p))
'        do
'            displaysystem(sys)       
'            if keyplus(key) or a=6 then
'                do
'                    p=p+1
'                    if p>9 then p=1
'                loop until map(sys).planets(p)<>0
'            endif
'            if keyminus(key) or a=4 then
'                do
'                    p=p-1
'                    if p<1 then p=9
'                loop until map(sys).planets(p)<>0
'            endif
'            if p<1 then p=lastplanet
'            if p>9 then p=firstplanet
'            x=xo+(p*2)
'            if left(displaytext(25),14)<>"Asteroid field" or left(displaytext(25),15)<>"Planet at orbit" then dprint "System " &map(sys).desig &"."
'            if map(sys).planets(p)>0 then
'                if planets(map(sys).planets(p)).comment="" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if planets(map(sys).planets(p)).mapstat<>0 then
'                            if isgasgiant(map(sys).planets(p))<>0 then
'                                if p>1 and p<7 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                                if p>6 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                                if p=1 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                            else
'                                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then displaytext(25)="Planet at orbit " &p &". " &atmdes(planets(map(sys).planets(p)).atmos) &" atm., " &planets(map(sys).planets(p)).grav &"g grav."
'                            endif
'                        else
'                            displaytext(25)= "Planet at orbit " &p &"."
'                        endif
'                    endif
'                endif
'                if planets(map(sys).planets(p)).comment<>"" then
'                    if isasteroidfield(map(sys).planets(p))=1 then
'                        displaytext(25)= "Asteroid field at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    else
'                        displaytext(25)= "Planet at orbit " &p &": " &planets(map(sys).planets(p)).comment &"."
'                    endif
'                endif
'                dprint ""
'                locate yo,x
'                color 15,3
'                if isgasgiant(map(sys).planets(p))=0 and isasteroidfield(map(sys).planets(p))=0 then print "o"
'                if isgasgiant(map(sys).planets(p))>0 then print "O"
'                if isasteroidfield(map(sys).planets(p))=1 then print chr(176)
'                color 11,0
'            endif
'           
'            if map(sys).planets(p)<0 then
'                if map(sys).planets(p)<0 then
'                    if isgasgiant(map(sys).planets(p))=0 then
'                        displaytext(25)= "Asteroid field at orbit " &p &"."
'                    else
'                        if map(sys).planets(p)=-20001 then displaytext(25)= "Planet at orbit " &p &". A helium-hydrogen gas giant."
'                        if map(sys).planets(p)=-20002 then displaytext(25)= "Planet at orbit " &p &". A methane-ammonia gas giant."
'                        if map(sys).planets(p)=-20003 then displaytext(25)= "Planet at orbit " &p &". A hot jupiter."
'                    endif
'                    dprint ""
'                endif
'                locate yo,x
'                color 15,3
'                if isgasgiant(map(sys).planets(p))=0 then
'                    print chr(176)
'                else
'                    print "O"
'                endif
'                color 11,0
'            endif
'            key=keyin
'            if key=key_comment then
'                dprint "Enter comment on planet: "
'                p1=locEOL
'                planets(map(sys).planets(p)).comment=gettext(p1.x,p1.y,60,planets(map(sys).planets(p)).comment)
'            endif
'            a=Getdirection(key)
'           
'           
'            if key="q" or key="Q" or key=key_esc then r=-1
'            if (key=key_enter or key=key_sc or key=key_la) and map(sys).planets(p)<>0 then r=p
'        loop until r<>0
'        liplanet=r
'    else
'        r=-1
'    endif
'    return r
'end function
'
sub displayawayteam(awayteam as _monster, map as short, lastenemy as short, deadcounter as short, ship as _cords, loctime as short)
        dim a as short
        dim c as short
        dim x as short
        dim y as short
        dim xoffset as short
        dim t as string
        static wg as byte
        static wj as byte
        dim thp as short
        dim as string poi
        dim as byte fw1,fh1
        Fh1=22
        
        xoffset=22
        locate 22,1
        color 15,0
        if awayteam.stuff(8)=1 and player.landed.m=map and planets(map).depth=0 then
            color 15,0
            locate 22,3
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "Pos:"&awayteam.c.x &":"&awayteam.c.y,,Font2,Custom,@_col
        else
            locate 22,1
            color 14,0
            draw string(0*_fw1,21*_fh1+(_fh1-_fh2)/2), "no satellite",,Font2,Custom,@_col
        endif
        locate 22,15
        color 15,0
        if loctime=3 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Night",,Font2,Custom,@_col
        if loctime=0 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2)," Day ",,Font2,Custom,@_col
        if loctime=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dawn ",,Font2,Custom,@_col
        if loctime=2 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),"Dusk ",,Font2,Custom,@_col
        if show_mnr=1 then draw string(15*_fw2,21*_fh1+(_fh1-_fh2)/2),""&map &":"&planets(map).flags(1),,Font2,Custom,@_col
        color 10,0
        locate 22,xoffset
        if awayteam.invis>0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"Camo",,Font2,Custom,@_col
            xoffset=xoffset+5
        endif
        locate 22,xoffset
        if addtalent(-1,24,0)>0 then 
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"Fast",,Font2,Custom,@_col
            xoffset=xoffset+5
        endif
        if _autopickup=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"P",,Font2,Custom,@_col
            xoffset+=1    
        endif
        if _autoinspect=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"I",,Font2,Custom,@_col
            xoffset+=1    
        endif
        if awayteam.helmet=0 then
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"O",,Font2,Custom,@_col
        else
            draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),"C",,Font2,Custom,@_col
        endif
        xoffset+=2
        draw string(xoffset*_fw2,21*_fh1+(_fh1-_fh2)/2),tacdes(player.tactic+3),,Font2,Custom,@_col
        xoffset=xoffset+len(tacdes(player.tactic+3))
        
        draw_border(xoffset)
        
        color 15,0
        if player.landed.m=map then
            if planetmap(ship.x,ship.y,map)>0 or player.stuff(3)=2 then    
                if _tiles=0 then
                    put (ship.x*_tix-(_tiy-_tix)/2,ship.y*_tiy),stiles(5,player.ti_no),trans
                else
                    color _shipcolor,0
                    draw string(ship.x*_fw1,ship.y*_fh1),"@",,Font1,custom,@_col
                endif
            endif
        endif        
        if _tiles=0 then
            put (awayteam.c.x*_fw1,awayteam.c.y*_fh1),gtiles(gt_no(1000)),pset
        else
            color _teamcolor,0
            draw string (awayteam.c.x*_fw1,awayteam.c.y*_fh1),"@",,Font1,custom,@_col
        endif    
        hpdisplay(awayteam)
        color 11,0
        draw string(62*_fw1,6*_fh2), "Visibility:" &awayteam.sight,,Font2,custom,@_col
        if awayteam.move=0 then draw string(62*_fw1,7*_fh2), "Trp.: None",,Font2,custom,@_col
        if awayteam.move=1 then draw string(62*_fw1,7*_fh2), "Trp.: Hoverplt.",,Font2,custom,@_col
        if awayteam.move=2 then draw string(62*_fw1,7*_fh2), "Trp.: Jetpacks",,Font2,custom,@_col
        if awayteam.move=3 then draw string(62*_fw1,7*_fh2), "Trp.: Teleport(T)",,Font2,custom,@_col
        
        draw string(62*_fw1,8*_fh2), "Armor :"&awayteam.armor,,Font2,custom,@_col
        draw string(62*_fw1,9*_fh2),"Firearms :"&awayteam.guns_to,,Font2,custom,@_col
        draw string(62*_fw1,10*_fh2), "Melee :"&awayteam.blades_to,,Font2,custom,@_col
        if player.stuff(3)=2 then
            locate 12,63
            draw string(62*_fw1,11*_fh2),"Alien Scanner",,font2,custom,@_col
            locate 13,63
            draw string(62*_fw1,12*_fh2),lastenemy-deadcounter &" Lifeforms ",,Font2,custom,@_col
        endif
        draw string(62*_fw1,14*_fh2),"Mapped    :"& cint(reward(0)),,Font2,custom,@_col
        draw string(62*_fw1,15*_fh2), "Bio Data  :"& cint(reward(1)),,Font2,custom,@_col
        draw string(62*_fw1,16*_fh2), "Resources :"& cint(reward(2)),,Font2,custom,@_col
        if len(tmap(awayteam.c.x,awayteam.c.y).desc)<18 then
            draw string(62*_fw1,18*_fh2),tmap(awayteam.c.x,awayteam.c.y).desc,,Font2,custom,@_col ';planetmap(awayteam.c.x,awayteam.c.y,map) 
        else 
            dprint tmap(awayteam.c.x,awayteam.c.y).desc '&planetmap(awayteam.c.x,awayteam.c.y,map)
        endif
        
        if awayteam.move=2 then
            draw string(62*_fw1,20*_fh2), key_ju &" for emerg.",,Font2,custom,@_col
            draw string(62*_fw1,21*_fh2), "Jetpackjump",,Font2,custom,@_col
        endif
        if awayteam.move=3 then
            draw string(62*_fw1,20*_fh2), key_te &" activates",,Font2,custom,@_col
            draw string(62*_fw1,21*_fh2),"Transporter",,Font2,custom,@_col
        endif
        if awayteam.move=2 and awayteam.hp>0 then
            color 11,0
            locate 23,63
            draw string(62*_fw1,22*_fh2), "Jetpackfuel:",,Font2,custom,@_col
            color 10,0
            if awayteam.jpfuel<awayteam.jpfuelmax*.5 then color 14,0
            if awayteam.jpfuel<awayteam.jpfuelmax*.3 then color 12,0
            if awayteam.jpfuel<0 then awayteam.jpfuel=0
            draw string(62*_fw1+12*_fw2,22*_fh2), ""&int(awayteam.jpfuel/awayteam.hp),,Font2,custom,@_col
            
        endif
        
        color 11,0
        locate 24,63
        draw string(62*_fw1,23*_fh2),"Oxygen:",,Font2,custom,@_col
        color 10,0
        if awayteam.oxygen<50 then color 14,0
        if awayteam.oxygen<25 then color 12,0
        draw string(62*_fw1+7*_fw2,23*_fh2),""&int(awayteam.oxygen/awayteam.hp),,Font2,custom,@_col
        
        color 11,0
        draw string(62*_fw1,24*_fh2),"Turn:" &player.turn,,Font2,custom,@_col
end sub

function alerts(awayteam as _monster,walking as short) as short
    dim a as short
    static wg as short
    static wj as short
    if awayteam.oxygen=awayteam.oxymax then wg=0
    if awayteam.jpfuel=awayteam.jpfuelmax and awayteam.move=2 then wj=0
    if int(awayteam.oxygen<awayteam.oxymax*.5) and wg=0 then 
        dprint ("Reporting oxygen tanks half empty",14)
        wg=1
        for a=1 to wg
            if _sound=0 or _sound=2 then    
                FSOUND_PlaySound(FSOUND_FREE, sound(1))                
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.25) and wg=1 then 
        dprint ("Oxygen low.",14)
        wg=2
        for a=1 to wg
            if _sound=0 or _sound=2 then
                FSOUND_PlaySound(FSOUND_FREE, sound(1))   
                sleep 350
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)       
    endif
    if int(awayteam.oxygen<awayteam.oxymax*.125) and wg=2 then
        dprint ("Switching to oxygen reserve!",12)
        wg=3
        for a=1 to wg
            if _sound=0 or _sound=2 then 
                FSOUND_PlaySound(FSOUND_FREE, sound(1)) 
                sleep 350
            endif
        next
        walking=0
        if _sound=2 then no_key=keyin(" "&key_enter &key_esc)    
    endif
    if awayteam.jpfuel<awayteam.jpfuelmax then
        if awayteam.jpfuel/awayteam.jpfuelmax<.5 and wj=0 then 
            wj=1
            for a=1 to wj
                if _sound=0 or _sound=2 then    
                    sleep 350
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next  
            walking=0  
            dprint ("Jetpack fuel low",14)
        endif
        if awayteam.jpfuel/awayteam.jpfuelmax<.3 and wj=1 then 
            wj=2
            for a=1 to wj
                if _sound=0 or _sound=2 then    
                    sleep 350
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next   
            walking=0 
            dprint ("Jetpack fuel very low",14)
        endif
        
        if awayteam.jpfuel<5 and wj=2 then 
            wj=3
        for a=1 to wj
                if _sound=0 or _sound=2 then    
                    sleep 350
                    FSOUND_PlaySound(FSOUND_FREE, sound(1))                    
                    if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
                endif
            next    
            dprint ("Switching to jetpack fuel reserve",12)
            walking=0
        endif
    else
        wj=0
    endif
    return walking
end function

sub shipstatus(heading as short=0)
    dim as short c1,c2,c3,c4,c5,c6,c7,c8,sick,offset,mjs
    dim as short a,b,c,lastinv,set,tlen,cx,cy
    dim as string text,key
    dim inv(127) as _items
    dim invn(127) as short
    dim cargo(11) as string
    dim cc(11) as short
    
    color 0,0
    cls
    if heading=0 then textbox("{15}Name: {11}"&player.desig &"{15} Type:{11}" &player.h_desig,1,0,40)
    textbox(shipstatsblock,1,2,40)
    'Weapons
    c=player.h_maxweaponslot
    locate 7,3
    color 15,0
    draw string (3*_fw2,7*_fh2), "Weapons:",,font2,custom,@_col
    color 11,0
    for a=1 to c
        if player.weapons(a).dam>0 then
            color 15,0
            draw string (3*_fw2,(8+b)*_fh2), player.weapons(a).desig ,,font2,custom,@_col
            color 11,0
            if player.weapons(a).ammomax<=0 then draw string (3*_fw2,(8+b+1)*_fh2) ," R:"& player.weapons(a).range &"/" & player.weapons(a).range*2 &"/" & player.weapons(a).range*3 &" D:"&player.weapons(a).dam ,,font2,custom,@_col
            if player.weapons(a).ammomax>0 then draw string (3*_fw2,(8+b+1)*_fh2) ," R:"& player.weapons(a).range &"/" & player.weapons(a).range*2 &"/" & player.weapons(a).range*3 &" D:"&player.weapons(a).dam &" A:"&player.weapons(a).ammomax &"/" &player.weapons(a).ammo &"  ",,font2,custom,@_col
            b=b+2
        else
            locate 8+b,4
            color 15,0
            if player.weapons(a).desig="" then
            draw string (3*_fw2,(8+b+1)*_fh2), "-Empty-",,font2,custom,@_col
        else
            draw string (3*_fw2,(8+b+1)*_fh2), player.weapons(a).desig,,font2,custom,@_col
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
    draw string (3*_fw2,16*_fh2), "Cargo:",,font2,custom,@_col
    color 11,0
    cargo(1)="Empty"
    cargo(2)="Food, bought at"
    cargo(3)="Basic goods, bought at"
    cargo(4)="Tech goods, bought at"
    cargo(5)="Luxury goods, bought at"
    cargo(6)="Weapons, bought at"
    cargo(7)="Narcotics, bought at"
    cargo(8)="Hightech, bought at"
    cargo(9)="Computers, bought at"
    cargo(10)="Mysterious box"
    cargo(11)="TT Contract Cargo"
    for c=1 to 10
        if player.cargo(c).x=1 then cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
        if player.cargo(c).x>9 then cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
            
        if player.cargo(c).x>1 and player.cargo(c).x<=9 then 
            cc(player.cargo(c).x)=cc(player.cargo(c).x)+1  
            cargo(player.cargo(c).x)=cargo(player.cargo(c).x)&" "&player.cargo(c).y &", " 
        endif
    next
    for c=1 to 11
        if cc(c)>0 then 
            if c>1 and c<7 then
                cargo(c)=left(cargo(c),len(cargo(c))-2)&"."
            endif    
            draw string (0,(16+c)*_fh2), cc(c)&" x "&cargo(c),,font2,custom,@_col
        endif
    next
    c=textbox(crewblock,25,2,22)
    c=textbox(listartifacts,55,2,22)
    c=c+5
    if heading=0 then
    lastinv=getitemlist(inv(),invn()) 
    color 15,0
    draw string (55*_fw1,(2+c+a)*_fh2) ,"Equipment("&lastinv & "):",,font2,custom,@_col
    color 11,0
    if heading=0 then  
        do
            for a=0 to _lines-c                
                color 0,0
                draw string (50*_fw1,(3+c+a)*_fh2) ,space(30),,font2,custom,@_col
                color 11,0
                
                if invn(a+offset)>1 then
                    draw string (50*_fw1,(3+c+a)*_fh2) , invn(a+offset)&" "&left(inv(a+offset).desigp,27),,font2,custom,@_col
                else
                    if invn(a+offset)=1 then draw string (50*_fw1,(3+c+a)*_fh2) , invn(a+offset)&" "&left(inv(a+offset).desig,27),,font2,custom,@_col
                endif
            next
            draw string (79*_fw1,_lines*_fh2) , " ",,font2,custom,@_col
            if lastinv>22-c and offset<lastinv then                    
                locate 25,79
                color 14,0
                draw string (79*_fw2,_lines*_fh2) , chr(25),,font2,custom,@_col
            endif
            draw string (79*_fw1,(2+c)*_fh2), " ",,font2,custom,@_col
            if offset>0 then    
                locate 1+c,79
                color 14,0
                draw string (79*_fw1,(2+c)*_fh2), chr(24),,font2,custom,@_col
            endif
            key=keyin(,,1)
            if keyminus(key) or key=key_north then offset=offset-1
            if keyplus(key) or key=key_south then offset=offset+1
            if offset<0 then offset=0
            if offset>33 then offset=33
            loop until key=key_esc or key=" "
        endif
    endif
    cls
end sub

sub displayship(show as byte=0)
    dim  as short a,b,mjs
    static wg as byte
    dim t as string
    dim as string p,g,s,d,carg
    dim as byte fw1,fh1
    Fw1=gfx.font.gettextwidth(FONT1,"W")
    Fh1=22
    
    if player.fuel=player.fuelmax then wg=0
    locate 22,1
    color 15,0
    if findbest(52,-1)>0 then
        draw string (0,21*_fh1), "Pos:"&player.c.x &":"&player.c.y,, font2,custom,@_col
            
    else
        color 14,0
        draw string (0,21*_fh1), "No navcomp",, font2,custom,@_col
    endif
        
    draw_border(11)
    color 15,0
    draw string(62*_fw1,0*_fh1),(player.h_sdesc &" "& player.desig),,Font2,custom,@_col 
    color 11,0
    draw string(62*_fw1,1*_fh2),"HP:"&space(4) &" "&"SP:"&player.shield &" ",,Font2,custom,@_col
    if player.hull<(player.h_maxhull+player.addhull)/2 then color 14,0
    if player.hull<2 then color 12,0
    draw string(62*_fw1+3*_fw2,1*_fh2),""&player.hull,,Font2,custom,@_col
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
    
    draw string(62*_fw1,2*_fh2), "Pi:" & p & "  Gu:" &g &"  Sc:" &s,,Font2,custom,@_col
    draw string(62*_fw1,3*_fh2), "Dr:"&d &"  Security:"&player.security ,,Font2,custom,@_col
    draw string(62*_fw1,4*_fh2), "Sensors:"&player.sensors,,Font2,custom,@_col
    
    for a=1 to 5
        if player.weapons(a).made=88 then mjs+=1
        if player.weapons(a).made=89 then mjs+=2
    next
    draw string(62*_fw1,5*_fh2), "Engine :"&player.engine &" ("&player.engine+2-player.h_maxhull\15+mjs &" MP)",,Font2,custom,@_col
    draw string(62*_fw1,22*_fh2), "Fuel(" &player.fuelmax+player.fuelpod &"):",,Font2,custom,@_col
    color 11,0
    if player.fuel<player.fuelmax*0.5 then 
        if wg=0 then
            wg=1 
            dprint "Fuel low",14
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
            dprint "Fuel very low",12
            if _sound=0 or _sound=2 then 
                 FSOUND_PlaySound(FSOUND_FREE, sound(2))
            endif
            if _sound=2 then no_key=keyin(" "&key_enter &key_esc)
 
        endif
        color 12,0
    endif
    draw string(62*_fw1+11*_fw2,22*_fh2) ,""&fix(player.fuel),,Font2,custom,@_col
    color 11,0
    draw string(62*_fw1,23*_fh2),"Credits:"&player.money &"    ",,Font2,custom,@_col
    draw string(62*_fw1,24*_fh2),"Turns:"&player.turn,,Font2,custom,@_col
    color 15,0
    
    display_ship_weapons()
    
    draw string(62*_fw1,20*_fh2), "Cargo",,font2,custom,@_col
    for a=1 to 10
        carg=""
        if player.cargo(a).x=1 then 
            color 8,1
        else
            color 10,8
        endif
        if player.cargo(a).x=1 then carg= "E"
        if player.cargo(a).x=2 then carg= "F"
        if player.cargo(a).x=3 then carg= "B"
        if player.cargo(a).x=4 then carg= "T"
        if player.cargo(a).x=5 then carg= "L"
        if player.cargo(a).x=6 then carg= "W"
        if player.cargo(a).x=7 then carg= "N"
        if player.cargo(a).x=8 then carg= "H"
        if player.cargo(a).x=9 then carg= "C"
        if player.cargo(a).x=10 then carg= "?"
        if player.cargo(a).x=11 then carg= "t"
        draw string(62*_fw1+(a-1)*_fw2,21*_fh2),carg,,font2,custom,@_col
    next
    if show=1 then
        if _tiles=0 then
            put ((player.c.x-player.osx)*_tix-(_tiy-_tix)/2,(player.c.y-player.osy)*_tiy),stiles(player.di,player.ti_no),trans
        else
            color _shipcolor,0
            draw string ((player.c.x-player.osx)*_fw1,(player.c.y-player.osy)*_fh1),"@",,Font1,custom,@_col
        endif
    endif
    color 11,0
    if player.tractor=0 then player.towed=0
end sub

function display_ship_weapons(m as short=0) as short
    dim as short a,b,bg
    color 15,0
    draw string (62*_fw1,7*_fh2), "Weapons:",,font2,custom,@_col
    color 11,0
    player.tractor=0
    for a=1 to 5
        if m<>0 and a=m then 
            bg=1
        else
            bg=0
        endif
        if player.weapons(a).desig<>"" then
            if player.weapons(a).shutdown=0 then
                color 15,bg
            else
                color 14,bg
            endif
            draw string(63*_fw1,(8+b)*_fh2),space(25),,font2,custom,@_col
            draw string(63*_fw1,(8+b)*_fh2),trim(player.weapons(a).desig),,font2,custom,@_col
            color 11,bg
            draw string(64*_fw1+len(trim(player.weapons(a).desig))*_fw2,(8+b)*_fh2),"D:"&player.weapons(a).dam,,Font2,custom,@_col
            if player.weapons(a).ammomax>0 then 
                draw string(63*_fw1,(8+b+1)*_fh2),space(25),,font2,custom,@_col
                draw string(64*_fw1,(8+b+1)*_fh2), "R:"& player.weapons(a).range &"/"& player.weapons(a).range*2 &"/" & player.weapons(a).range*3 &" A:"&player.weapons(a).ammomax &"/" &player.weapons(a).ammo &" ",,Font2,custom,@_col
            else
                draw string(63*_fw1,(8+b+1)*_fh2),space(25),,font2,custom,@_col
                draw string(64*_fw1,(8+b+1)*_fh2), "R:"& player.weapons(a).range &"/"& player.weapons(a).range*2 &"/" & player.weapons(a).range*3 &" ",,Font2,custom,@_col
            endif
            if player.weapons(a).heat>=0 then
                color 11,bg
                if player.weapons(a).heat>5 then color 14,bg
                if player.weapons(a).heat>10 then color 12,bg
                draw string(63*_fw1,(8+b+2)*_fh2),space(25),,font2,custom,@_col
                if player.weapons(a).shutdown=0 then
                    draw string(64*_fw1,(8+b+2)*_fh2), "Heat:"& player.weapons(a).heat,,Font2,custom,@_col
                else
                    draw string(64*_fw1,(8+b+2)*_fh2), "Heat:"& player.weapons(a).heat &"-Shutdown",,Font2,custom,@_col
                endif
            endif
            if player.weapons(a).ROF<0 then 
                player.tractor=1
                if player.towed>0 and rnd_range(1,6)+rnd_range(1,6)+player.pilot<8+player.weapons(a).ROF then
                    dprint "Your tractor beam breaks down",14
                    player.tractor=0
                    player.towed=0
                    player.weapons(a)=makeweapon(0)
                endif
            endif
        endif
        b=b+3
    next
    return 0
end function

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
            if _tiles=0 then
                put (portal(b).from.x*_tix,portal(b).from.y*_tiy),gtiles(gt_no(portal(b).ti_no)),pset
            else
                color portal(b).col,0
                draw string(portal(b).from.x*_fw1,portal(b).from.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
        if portal(b).oneway=0 and portal(b).dest.m=a and portal(b).discovered=1 then
            if _tiles=0 then
                put (portal(b).dest.x*_tix,portal(b).dest.y*_tiy),gtiles(gt_no(portal(b).ti_no)),pset
            else
                color portal(b).col,0
                draw string(portal(b).dest.x*_fw1,portal(b).dest.y*_fh1),chr(portal(b).tile),,Font1,custom,@_col
            endif
        endif
    next
    for b=1 to lastitem
        if item(b).w.m=a and item(b).w.s=0 and item(b).w.p=0 and item(b).discovered=1 then
            if _tiles=0 then
                if item(a).ty<>15 then
                    put (item(b).w.x*_tix,item(b).w.y*_tiy),gtiles(gt_no(item(b).ti_no)),pset
                else                                
                    put (item(b).w.x*_tix,item(b).w.y*_tiy),gtiles(gt_no(item(b).ti_no)),pset
                endif
            else            
                color item(b).col,item(b).bgcol
                draw string(item(b).w.x*_fw1,item(b).w.y*_fh1),item(b).icon,,Font1,custom,@_col
            endif
        endif
    next
end sub

function gettext(x as short, y as short, ml as short, text as string) as string
    dim as short l,lasttimer
    dim key as string
    dim p as _cords
    l=len(text)
    sleep 150
    if l>ml and text<>"" then
        text=left(text,ml-1)
        l=ml-1
    endif
    do 
            
        key=""
        color 11,0
        draw string (x*_fw2,y*_fh2), text &"_ ",,font2,custom,@_col
        do
            do
                sleep 1
                lasttimer+=1
                if lasttimer>100 then
                    draw string (x*_fw2,y*_fh2), text &"  ",,font2,custom,@_col
                else
                    draw string (x*_fw2,y*_fh2), text &"_ ",,font2,custom,@_col
                endif
                if lasttimer>200 then lasttimer=0
            loop until screenevent(@evkey)
            
            if evkey.type=EVENT_KEY_press then
                if evkey.ascii=asc(key_esc) then key=key_esc
                if evkey.ascii=8 then key=chr(8)
                if evkey.ascii=32 then key=chr(32)
                if evkey.ascii=asc(key_enter) then key=key_enter
                if evkey.ascii>32 and evkey.ascii<123 then key=chr(evkey.ascii)
            endif
        loop until key<>""  
        
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
    dim as short lastspace,tlen,p,wcount,lcount,xw,a
    dim words(1023) as string
    dim addt as string
    addt=text
    'if len(text)<=w then addt(0)=text
    for p=0 to len(text)
        if mid(text,p,1)="{" or mid(text,p,1)="|" then wcount+=1
        words(wcount)=words(wcount)&mid(text,p,1)
        if mid(text,p,1)=" " or mid(text,p,1)="|" or  mid(text,p,1)="}" then wcount+=1
    next
    if words(wcount)<>"|" then 
        wcount+=1
        words(wcount)="|"
    endif
    color fg,bg
    for p=0 to wcount
        if words(p)="|" then 
            draw string((x)*_fw1+xw*_fw2,y*_fh1+lcount*_fh2),space(w-xw),,font2,custom,@_col
            lcount=lcount+1
            xw=0
        endif
        if Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}" then
            color numfromstr(words(p)),bg
        endif
        if words(p)<>"|" and not(Left(trim(words(p)),1)="{" and Right(trim(words(p)),1)="}") then
            if xw+len(words(p))>w then 
                draw string((x)*_fw1+xw*_fw2,y*_fh1+lcount*_fh2),space(w-xw),,font2,custom,@_col
                lcount=lcount+1
                xw=0
            endif
            draw string((x)*_fw1+xw*_fw2,y*_fh1+lcount*_fh2),words(p),,font2,custom,@_col
            xw=xw+len(words(p))
            
        endif
        if lcount*_fh2+y*_fh1>_screeny-_fh1 then
            color 14,0
            draw string(x*_fw1+w*_fw2-_fw2,_screeny-_fh2),chr(25),,font2,custom,@_col
            no_key=keyin
            for a=0 to lcount
                draw string((x)*_fw1,y*_fh1+a*_fh2),space(w),,font2,custom,@_col
            next    
            lcount=0
        endif
    next
    text=addt
    return lcount
end function

function locEOL() as _cords
    'puts cursor at end of last displayline
    dim as short y,x,a,winh,firstline
    dim as _cords p
    winh=fix((_screeny-_fh1*22)/_fh2)-1
    do
        firstline+=1
    loop until firstline*_fh2>=22*_fh1
    
    y=firstline+winh
    for a=firstline+winh to firstline step -1
        if displaytext(a+1)="" then y=a
    next
    x=len(displaytext(y))+1
    p.x=x
    p.y=y
    return p
end function

function scrollup(b as short) as short
    dim as short a,c
    for c=0 to b
        for a=0 to 254
            displaytext(a)=displaytext(a+1)
            dtextcol(a)=dtextcol(a+1)
        next
        displaytext(255)=""
        dtextcol(255)=11
    next
    return 0
end function

function dprint(t as string, col as short=11) as short
    dim as short a,b,c,delay
    dim text as string
    dim wtext as string
    'static offset as short
    dim tlen as short
    'dim addt(64) as string
    dim lastspace as short
    dim key as string
    dim as short winw,winh
    dim firstline as byte
    dim words(4064) as string
    static curline as single
    static lastcalled as double
    static lastmessage as string
    static lastmessagecount as short
    firstline=fix((22*_fh1)/_fh2)
    winw=fix((_fw1*61)/_fw2)
    winh=fix((_screeny-_fh1*22)/_fh2)
    firstline=0
    do
        firstline+=1
    loop until firstline*_fh2>=22*_fh1
    
    if _fh1=_fh2 then
        firstline=22
        winh=_lines-22
    endif
    curline=locEOL.y+1
    for a=0 to len(t)
        if mid(t,a,1)<>"|" then text=text & mid(t,a,1)
    next
    if text<>"" and len(text)<winw-4 then
        if lastmessage=t then
            a=curline-1
            lastmessagecount+=1
            if len(displaytext(a))<winw-4 then
                displaytext(a)=text &"(x"&lastmessagecount &")"
                t=""
            else
                displaytext(a)=text
                displaytext(a+1)="(x"&lastmessagecount &")"
                t=""
            endif
            text=""
        else
            lastmessage=t
            lastmessagecount=1
        endif
    endif
    if lastcalled=0 then lastcalled=timer
    if delay=1 and t<>"" then
        do
        loop until timer>lastcalled+.05
    endif
    lastcalled=timer
    
    'draw string (61*_fw1,firstline*_fh2),"*",,font1,custom,@_col
    'draw string (61*_fw1,(firstline+winh)*_fh2),"*",,font1,custom,@_col
    'find offset
    'if offset=0 then offset=firstline
    
    if text<>"" then
        while displaytext(curline)<>"" 
            curline+=1
        wend
        for a=0 to len(text)
            words(b)=words(b)&mid(text,a,1)
            if mid(text,a,1)=" " then b+=1
        next
        for a=0 to b
            if len(displaytext(curline+tlen))+len(words(a))>=winw then
                displaytext(curline+tlen)=trim(displaytext(curline+tlen))                
                tlen+=1
            endif
            displaytext(curline+tlen)=displaytext(curline+tlen)&words(a)
            dtextcol(curline+tlen)=col
        next
        
        if curline+tlen>firstline+winh then            
            if tlen<winh then
                scrollup(tlen-1)
            else
                do
                    scrollup(winh-2)
                    for b=firstline to firstline+winh
                        color 0,0
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
                        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
                        color dtextcol(b),1
                        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
                        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
                    next
                    color 14,1
                    if displaytext(firstline+winh+1)<>"" then
                        draw string((winw+1)*_fw2,_screeny-_fh2), chr(25),,font2,custom,@_col
                        no_key=keyin
                    endif
                loop until displaytext(_textlines+1)=""
            endif
        else
            if curline=firstline+winh then scrollup(0)
        endif
        while displaytext(_textlines+1)<>""
            scrollup(0)
            wend
    endif
    for b=firstline to firstline+winh
        color 0,0
        'draw string(0,(b-firstline)*_fh2+22*_fh1), space(winw),,font2,custom,@_col
        draw string(0,b*_fh2), space(winw),,font2,custom,@_col
        color dtextcol(b),0
        'draw string(0,(b-firstline)*_fh2+22*_fh1), displaytext(b),,font2,custom,@_col
        draw string(0,b*_fh2), displaytext(b),,font2,custom,@_col
    next
    locate 24,1
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
        key=keyin
        displaytext(_lines-1)=displaytext(_lines-1)&key
        if key <>"" then 
            dprint ""
            if _anykeyno=0 and key<>key_yes then key="N"
        endif
    loop until key="N" or key="n" or key=" " or key=key_esc or key=key_enter or key=key_yes  
    if key=key_yes or key=key_enter then a=-1
    return a
end function

function menu(te as string, he as string="", x as short=2, y as short=2, blocked as short=0, markesc as short=0) as short
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
        draw string(x*_fw1,y*_fh1), lines(0),,font2,custom,@_col
        
        for a=1 to c
            if loca=a then 
                if hfl=1 and loca<c then blen=textbox(helps(a),x+longest+2,2,hw,15,1)
                color 15,5
            else
                color 11,0
            endif
            locate y+a,x
            draw string(x*_fw1,y*_fh1+a*_fh2), lines(a),,font2,custom,@_col
        next
        if player.dead=0 then key=keyin(,,blocked)
        
        if hfl=1 then 
            for a=1 to blen
                color 0,0
                draw string((longest+x+2)*_fw1,y*_fh1+(a-1)*_fh2), space(hw),,font2,custom,@_col
            next
        endif
        if getdirection(key)=8 then loca=loca-1
        if getdirection(key)=2 then loca=loca+1
        if loca<1 then loca=c
        if loca>c then loca=1
        if key=key_enter then e=loca
        if key=key_awayteam then 
            screenshot(1)
            showteam(0)
            screenshot(2)
        endif
        for a=0 to c
            if ucase(key)=shrt(a) and getdirection(key)=0 then loca=a
        next
        if key=key_esc or player.dead<>0 then e=c
    loop until e>0 
    if key=key_esc and markesc=1 then e=-1
    color 0,0        
    for a=0 to c
        locate y+a,x
        draw string(x*_fw1,y*_fh1+a*_fh2), space(59),,font2,custom,@_col
    next
    color 11,0
    while inkey<>""
    wend
    return e
end function

function getrandomsystem(unique as short=0) as short 'Returns a random system. If unique=1 then specialplanets are possible
    dim as short a,b,c,p,u,ad
    dim pot(laststar) as short
    for a=0 to laststar
        if map(a).discovered=0 and map(a).spec<8 then
            if unique=0 then
                ad=0
                for p=1 to 9
                    for u=0 to lastspecial
                        if map(a).planets(p)=specialplanet(u) then ad=1
                    next
                next
            endif
            if ad=0 then
                pot(b)=a
                b=b+1
            endif
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

function getnumber(a as short,b as short, e as short) as short
    dim key as string
    dim buffer as string
    dim c as short
    dim d as short
    dim i as short
    dim p as _cords
    if _altnumber=0 then
        p=locEOL
        c=numfromstr((gettext(p.x,p.y,46,"")))
        if c>b then c=b
        if c<a then c=e
        return c
    else
        
        color 11,1
        for i=1 to 61
            draw string (i*_fw1,21*_fh1),chr(196),,font1,custom,@_col
        next
        color 11,11
        draw string (28*_fw1,21*_fh1),space(5),,font1,custom,@_col
        c=a
        if e>0 then c=e
        do 
            color 11,1
            
            draw string (27*_fw1,22*_fh1),chr(180),,font1,custom,@_col
            color 5,11
            
            draw string (29*_fw1,21*_fh1),"-",,font1,custom,@_col
            print "-"
    
            if c<10 then 
                color 1,11
                print "0" &c
                draw string (30*_fw1,21*_fh1),"0"&c,,font2,custom,@_col
            else
                color 1,11
                draw string (30*_fw1,21*_fh1),""&c,,font2,custom,@_col
            endif
            
            locate 22,32
            color 5,11        
            draw string (32*_fw1,21*_fh1),"+",,font1,custom,@_col
            
            color 11,1
            draw string (33*_fw1,21*_fh1),chr(195),,font1,custom,@_col
            key=keyin(key_up &key_dn &key_rt &key_lt &"1234567890+-"&key_esc &key_enter)
            if keyplus(key) then c=c+1
            if keyminus(key) then c=c-1
            if key=key_enter then d=1
            if key=key_esc then d=2
            buffer=buffer+key
            if len(buffer)>2 then buffer=""
            if val(buffer)<>0 or buffer="0" then c=val(buffer)
            
            if c>b then c=b
            if c<a then c=a
            
        loop until d=1 or d=2
        if d=2 then c=-1
        color 11,0
    endif
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
    dim p(7) as short
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


