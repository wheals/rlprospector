
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
            crew(slot).icon="P"
            crew(slot).typ=6
            crew(slot).talents(29)=1
            crew(slot).paymod=2
        endif  
        
        if slot>1 and rnd_range(1,100)<=33 then n(200,1)=gaintalent(slot)
        if slot=1 and rnd_range(1,100)<=50 then n(200,1)=gaintalent(slot)
    endif     
    return 0
end function    

function hiring(st as short,byref hiringpool as short,hp as short) as short
    dim as short b,c,d,e,officers,maxsec,neodog,robots,w
    dim as short f,g
    dim as string text
    text="Hiring/ Pilot/ Gunner/ Science Officer/ Ships Doctor/ Security/ Squad Leader/ Sniper/ Paramedic/"
    if basis(st).repname="Omega Bioengineering" and player.questflag(1)=3 then neodog=1
    if basis(st).repname="Smith Heavy Industries" and player.questflag(9)=3 then robots=1
    if neodog=1 then text=text & " Neodog/ Neoape/"
    if robots=1 then text=text & " Robot/"
    text=text & " Set Wage/Exit"
    cls        
        do
            officers=1
            if player.pilot>0 then officers=officers+1
            if player.gunner>0 then officers=officers+1
            if player.science>0 then officers=officers+1
            if player.doctor>0 then officers=officers+1
        
            displayship()
            b=menu(text)
                
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
                    if askyn("Pilot, Skill:" & c &" Wage per mission: "& c*c*Wage &" (Current:"&player.pilot &") hire? (y/n)") then
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
                    if askyn("Gunner, Skill:" & c &" Wage per mission: " & c*c*Wage & " (Current:"&player.gunner &") hire? (y/n)") then
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
                    if askyn("Science officer, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current:"&player.science &") hire? (y/n)") then
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
                    if askyn("Ships doctor, Skill:" & c &" Wage per mission: " &c*c*Wage &" (Current:"&player.doctor &") hire? (y/n)") then
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
                if maxsecurity>0 then 
                    if player.money<wage*2 then
                        dprint "Not enough money for first wage."
                    else
                        player.money-=wage*2
                        hiringpool+=addmember(16)
                    endif
                endif
            endif
            
            if b=7 then 'Sniper
                if maxsecurity>0 then 
                    if player.money<wage*2 then
                        dprint "Not enough money for first wage."
                    else
                        player.money-=wage*2
                        hiringpool+=addmember(17)
                    endif
                endif
            endif
            
            if b=8 then 'Paramedic
                if maxsecurity>0 then 
                    if player.money<wage*2 then
                        dprint "Not enough money for first wage."
                    else
                        player.money-=wage*2
                        hiringpool+=addmember(18)
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