function ask_alliance(who as short) as short
    if alliance(0)=1 then
        if alliance(who)=1 then
            select case battleslost(ft_ancientaliens,who)
            case is>1 
                dprint "So far we have destroyed "& battleslost(ft_ancientaliens,who)&" robot ships."
            case 1
                dprint "So far we have destroyed one robot ship."
            case 0
                dprint "So far we have not managed to destroy a robot ship."
            end select
        else
            if askyn("Do you want to discuss an alliance against the robot ships?(y/n)") then
                form_alliance(who)
            endif
        endif
    endif
    
    return 0
end function


function robot_invasion() as short
    dim as short a,pot(1024),lp,m,ad
    dim c as _cords
    dim d as _driftingship
    for a=1 to lastplanet
        ad=0
        if planets(a).depth=0 then
            if planets(a).colflag(0)>0 then ad=1
            if specialplanet(10)=a then ad=1
            if specialplanet(13)=a then ad=1
            if specialplanet(14)=a then ad=1
            if specialplanet(20)=a then ad=1
            if specialplanet(32)=a then ad=1
            if specialplanet(33)=a then ad=1
            if specialplanet(39)=a then ad=1
            if specialplanet(40)=a then ad=1
            if specialplanet(41)=a then ad=1
            if specialplanet(42)=a then ad=1
            if specialplanet(43)=a then ad=1
            if pirateplanet(0)=a then ad=1
            if pirateplanet(1)=a then ad=1
            if pirateplanet(2)=a then ad=1
            if ad=1 then
                c=rnd_point(a,,305)
                if c.x>0 then ad=0 'Already invaded
            endif
            if ad=1 then
                lp+=1 
                pot(lp)=a
            endif
        endif
    next
    if lp>0 then
        m=pot(rnd_range(1,lp))
        c=rnd_point
        planetmap(c.x,c.y,m)=-305
        'Add ship to enter
        d.m=m
        d.s=18
        d.x=c.x
        d.y=c.y
        make_drifter(d,dominant_terrain(c.x,c.y,m))
        planets(lastplanet)=planets(m)
        select case m
        case specialplanet(10),specialplanet(13),specialplanet(14),specialplanet(20),specialplanet(39),specialplanet(40),specialplanet(41),specialplanet(42),specialplanet(43)
            battleslost(ft_merchant,ft_ancientaliens)+=5
        case pirateplanet(0),pirateplanet(1),pirateplanet(2)
            battleslost(ft_pirate,ft_ancientaliens)+=5
        case specialplanet(7)
            battleslost(ft_civ1,ft_ancientaliens)+=5
        case specialplanet(38)
            battleslost(ft_civ1,ft_ancientaliens)+=5
        end select
        if _debug>0 then dprint "Robot invasion: "&cords(map(sysfrommap(m)).c)
    endif
    return 0
end function

function form_alliance(who as short) as short
    dim as integer playerkills,ancientskills,factionmod,i
    playerkills=battleslost(who,0)
    if who=2 then playerkills+=battleslost(4,0)
    if who=1 then playerkills+=battleslost(3,0)
    ancientskills=battleslost(who,ft_ancientaliens)
    select case who
    case 1 'Companies
        for i=0 to 2
            if basis(i).company=3 then factionmod+=1
        next
        for i=1 to 3
            factionmod+=questguy(i).friendly(0)
        next
    case 2'Pirates
    case 6,7'Alien civs
        if civ(who-7).inte>=2 then factionmod+=civ(who-7).inte
        factionmod=factionmod+(civ(who-7).aggr-2)*3 
        factionmod=factionmod+(civ(who-7).phil-2)*2 
    end select
    
    if faction(who).war(0)=0 then 
        dprint "We stand by your side."
        alliance(who)=1
        factionadd(0,who,-100)
        return 0
    endif
    if ancientskills=0 then 
        dprint "Alliance against what?"
        return 0
    endif
    if playerkills>ancientskills+factionmod then 
        dprint "We have lost less ships to this so called menace than to we have lost to you! We are not interested in an alliance."
        return 0
    endif
    if ancientskills*10+factionmod>faction(who).war(0) then
        dprint "We stand by your side."
        alliance(who)=1
        factionadd(0,who,-100)
    else
        dprint "We don't see them as such a dangerous menace."
    endif
    return 0
end function

function give_bountyquest(employer as short) as short
    dim as short i,q,f
    dim as string empname(1),empwant(1)
    empname(0)="company rep."
    empname(1)="pirate leader"
    empwant(0)="pirate ship"
    empwant(1)="company patrol ship"
    'Find first unused bountyquest
    for i=1 to lastbountyquest
        if bountyquest(i).employer=employer and bountyquest(i).status=0 then
            q=i
            exit for
        endif
    next
    if q=0 then return 0
    f=set_fleet(makequestfleet(bountyquest(q).ship))
    dprint "The "&empname(employer)& " informs you that there is a bounty of "&credits( bountyquest(q).reward) &" on the "&empwant(employer) &" "&fleet(f).mem(1).desig &" "& bountyquestreason(bountyquest(q).reason) &" The ship was last seen at "&cords(fleet(f).c)&"."
    bountyquest(q).status=1
    bountyquest(q).lastseen=fleet(f).c
    bountyquest(q).desig=fleet(f).mem(1).desig
    fleet(f).mem(1).bounty=q
    return 0
end function

function reward_bountyquest(employer as short) as short
    dim as short i
    dim as string empname(1)
    empname(0)="rep."
    empname(1)="pirate king"
    
    for i=1 to lastbountyquest
        if bountyquest(i).employer=employer then
            select case bountyquest(i).status
            case 1
                dprint "The "&empname(employer)&" informs you that the "& bountyquest(i).desig &" is still at large."
            case 2
                dprint "The "&empname(employer)&" congratulates you for destroying the "& bountyquest(i).desig &" and hands you your reward of "& credits( bountyquest(i).reward) &"."
                bountyquest(i).status=4
                if employer=0 then
                    addmoney(bountyquest(i).reward,mt_pirates)
                else
                    addmoney(bountyquest(i).reward,mt_piracy)
                endif
            case 3
                dprint empname(employer)&" informs you that the "& bountyquest(i).desig &" has been brought down by somebody else."
                bountyquest(i).status=4
            end select
        endif
    next
    return 0
end function
function questguy_newloc(i as short) as short
    dim as short j,noperstation(2),s1,s2,s3,debug
    for j=1 to lastquestguy
        if questguy(j).location>=0 then' Is on a big station
            noperstation(questguy(j).location)+=1
        endif
    next
    if debug=1 and _debug=1 then dprint "Newloc called:" & noperstation(0) &":"& noperstation(1) &":" &noperstation(2)
    s1=find_high(noperstation(),2,0)
    s3=find_low(noperstation(),2,0)
    s2=3-s1-s3's2 is the one that isn't s1 or s3
    if debug=1 and _debug=1 then dprint s1 &":"& s2 &":"& s3
    if questguy(i).location=-1 then
        if rnd_range(1,100)<=50 then
            questguy(i).location=s3
        else
            if rnd_range(1,100)<=50 then
                questguy(i).location=s2
            else
                questguy(i).location=s1
            endif
        endif
    else
        if rnd_range(1,100)<=30 then
            questguy(i).location=-1
        else            
            if rnd_range(1,100)<=50 then
                questguy(i).location=s3
            else
                if rnd_range(1,100)<=50 then
                    questguy(i).location=s2
                else
                    questguy(i).location=s1
                endif
            endif
        endif
    endif
    for j=1 to lastquestguy
        if questguy(i).location=questguy(j).location then 
            if questguy(i).location<0 then
                questguy(i).knows(j)=questguy(i).location
            else
                questguy(i).knows(j)=questguy(i).location+1
            endif
        endif
    next
    return 0
end function

function questguy_newquest(i as short) as short
    dim wanttable(25,2) as short
    dim hastable(25,2) as short
    dim as short f,j,l,debug
    dim as string w(5),li
    f=freefile
    debug=5
    open "data/wanthas.csv" for input as #f
    do
        line input #f,li
        j+=1
        w(0)=""
        w(1)=""
        w(2)=""
        w(3)=""
        w(4)=""
        w(5)=""
        string_towords(w(),li,";")
        wanttable(j,0)=val(w(0))
        wanttable(j,1)=val(w(1))
        wanttable(j,2)=val(w(2))
        hastable(j,0)=val(w(0))
        hastable(j,1)=val(w(3))
        hastable(j,2)=val(w(4))
    loop until eof(f)
    close #f
    if questguy(i).want.type=0 then
        if rnd_range(1,100)<30 then 'standard
            l=rnd_range(1,7)
        else 'Specific
            l=questguy(i).job+7
        endif
        if debug=1 and _debug=1 then dprint "adding want from line "&l
        if rnd_range(1,100)<50 then
            questguy(i).want.type=wanttable(l,1)
        else
            questguy(i).want.type=wanttable(l,2)
        endif
        if questguy(i).want.type=0 then
            l=rnd_range(1,7)
            if rnd_range(1,100)<50 then
                questguy(i).want.type=wanttable(l,1)
            else
                questguy(i).want.type=wanttable(l,2)
            endif
        endif
        IF debug>0 and _debug>0 then questguy(i).want.type=debug
        make_questitem(i,q_want)
        questguy(i).want.motivation=rnd_range(0,2)
    endif    
    if questguy(i).has.type=0 then
        if rnd_range(1,100)<30 then 'standard
            l=rnd_range(1,7)
        else 'Specific
            l=questguy(i).job+7
        endif
        if debug=1 and _debug=1 then dprint "adding has from line "&l
        if rnd_range(1,100)<50 then
            questguy(i).has.type=hastable(l,1)
        else
            questguy(i).has.type=hastable(l,2)
        endif
        if questguy(i).has.type=0 then
            l=rnd_range(1,7)
            if rnd_range(1,100)<50 then
                questguy(i).has.type=hastable(l,1)
            else
                questguy(i).has.type=hastable(l,2)
            endif
        endif
        IF debug>0 and _debug>0 then questguy(i).has.type=debug
        make_questitem(i,q_has)
        questguy(i).want.motivation=rnd_range(0,2)
    endif
    if questguy(i).want.type=questguy(i).has.type then
        if rnd_range(1,100)<=50 then
            questguy(i).want.type=0
        else
            
            questguy(i).has.type=0
        endif
    endif
    return 0
end function

function make_questitem(i as short,wanthas as short) as short
    dim o as _questitem pointer
    dim as short who,comp,j,f
    dim as string genname(4)
    genname(2)="gun"
    genname(3)="spacesuit"
    genname(4)="closecombat weapon"
    
    if wanthas=q_want then
        'want
        o=@questguy(i).want
    else
        o=@questguy(i).has
        'has
    endif
    if _Debug=33 then
        f=freefile
        open "MQI.txt" for append as #f
        print #f,"I:"&i &" Wanthas"&wanthas &" Type:"&(*o).type
        close #f
    endif
    if (*o).type=1 then 'Equipment item
        if wanthas=q_want then
            questguy(i).want.it.ty=rnd_range(2,4) 'What kind of Item
            questguy(i).want.it.v1=rnd_range(1,3)+(*o).motivation*2 'Minimun v1
            questguy(i).want.it.desig=genname(questguy(i).want.it.ty)
            if questguy(i).want.it.ty=2 then questguy(i).want.it.ldesc=genname(2) &" with at least "&questguy(i).want.it.v1 &" damage"
            if questguy(i).want.it.ty=3 then questguy(i).want.it.ldesc=genname(3) &" with at least "&questguy(i).want.it.v1 &" armorrating"
            if questguy(i).want.it.ty=4 then 
                questguy(i).want.it.v1=questguy(i).want.it.v1/10
                questguy(i).want.it.ldesc=genname(4) &" with at least "&questguy(i).want.it.v1 &" damage"
            endif
        else 'Has
            select case questguy(i).money
            case is <=100
                questguy(i).has.motivation=2
            case 101 to 500
                questguy(i).has.motivation=1
            case else
                questguy(i).has.motivation=0
            end select
            questguy(i).has.it=rnd_item(RI_WeaponsArmor)
        endif
    endif
       
    if (*o).type=qt_autograph then 'Autograph	3
        if wanthas=q_want then
            questguy(i).want.it.ty=57
            questguy(i).flag(1)=rnd_questguy_byjob(14)
            if questguy(i).flag(1)=i or questguy(i).flag(1)<1 then
                questguy(i).want.type=0
            else
                questguy(i).want.it.v1=questguy(i).flag(1) 
            endif
        else
            questguy(i).flag(1)=rnd_questguy_byjob(14)
            if questguy(i).flag(1)=i or questguy(i).flag(1)<1 then
                questguy(i).has.type=0
            else
                questguy(i).has.it=makeitem(1002,questguy(i).flag(1))
            endif
        endif
        
    endif
    
    if (*o).type=qt_outloan then'Outstanding Loan	4
        if wanthas=q_want then
            select case questguy(i).money
            case is <=100
                questguy(i).has.motivation=0
            case 101 to 500
                questguy(i).has.motivation=1
            case else
                questguy(i).has.motivation=2
            end select
                
            questguy(i).flag(1)=get_other_questguy(i,1)
            if rnd_range(1,100)<33 then questguy(i).knows(questguy(i).flag(1))=questguy(questguy(i).flag(1)).location
            questguy(questguy(i).flag(1)).loan=rnd_range(1,10)*100
        else
            
        endif
        
    endif
    
    if (*o).type=qt_stationimp then'Station improvements	5
        if wanthas=q_want then
            questguy(i).flag(1)=get_other_questguy(i)
        else
        endif
        
    endif
        
    if (*o).type=qt_drug then'Drug	7
        if wanthas=q_want then
            questguy(i).want.it.ty=60
            questguy(i).want.it.v1=rnd_range(1,6)
            questguy(i).want.it.price=(*o).it.v1*100
            
            questguy(i).want.it.desig="Drug "&chr(64+(*o).it.v1)
            questguy(i).want.it.desigp="Drugs "
        else
            
            questguy(i).has.it=makeitem(1005,rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=qt_souvenir then'Souvenir	8
        if wanthas=q_want then
            questguy(i).want.it.ty=23
        else
            questguy(i).has.it=makeitem(rnd_range(93,94))
        endif
        
    endif
        
    if (*o).type=qt_tools then'Tools	9
        if wanthas=q_want then
        else
            questguy(i).has.it=makeitem(1004,rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=qt_showconcept then'Show Concept	10
        if wanthas=q_want then
        else
            questguy(i).flag(5)=rnd_questguy_byjob(14)
            questguy(i).has.it=makeitem(1008,questguy(i).flag(5),rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=qt_stationsensor then'Station Sensor access	11
        if wanthas=q_want then
        else
            if questguy(i).location<0 then
                questguy(i).has.it=makeitem(1009,rnd_range(0,2))
            else
                questguy(i).has.it=makeitem(1009,questguy(i).location)
            endif
        endif
    endif
    
    if (*o).type=qt_travel then'Alibi	12
        do
            questguy(i).flag(12)=rnd_range(0,2)
        loop until questguy(i).flag(12)<>questguy(i).location
        questguy(i).flag(13)=distance(player.c,basis(questguy(i).flag(12)).c)*rnd_range(1,10+(*o).motivation)
        questguy(i).flag(14)=rnd_range(1,15)
    endif
    
    if (*o).type=qt_cargo then'Message	13
        if wanthas=q_has then
            questguy(i).flag(1)=rnd_range(1,4)
            do
                questguy(i).flag(2)=rnd_range(0,2)
            loop until questguy(i).flag(2)<>questguy(i).location
        endif
    endif
    
    if (*o).type=qt_locofpirates then'Loc of Pirates	14
        if wanthas=q_want then
        else
            questguy(i).flag(4)=pirateplanet(rnd_Range(0,_NOPB))
            questguy(i).flag(3)=sysfrommap(questguy(i).flag(4))
        endif
        
    
    endif
    if (*o).type=qt_locofspecial then'Loc of Special Planet	15
        if wanthas=q_want then
            
        else
            questguy(i).flag(4)=rnd_Range(1,lastspecial)
            questguy(i).flag(3)=sysfrommap(specialplanet(questguy(i).flag(4)))
        endif
        
    endif
    
    if (*o).type=qt_locofgarden then'Loc of Garden World	16
        if wanthas=q_want then
        else
            do
                j=get_nonspecialplanet
            loop until planetmap(0,0,j)=0
            questguy(i).flag(4)=j
            questguy(i).flag(3)=sysfrommap(j)
            makeplanetmap(j,3,3)
            makeislands(j,3)
            if planets(j).grav>1.1 then planets(j).grav=rnd_range(7,10)/10
            if planets(j).atmos<3 or planets(j).atmos>5 then planets(j).atmos=rnd_range(3,5)
            if planets(j).temp<-20 or planets(j).temp>55 then planets(j).temp=rnd_range(0,30)
            if planets(j).weat>1 then planets(j).weat=0.5
            if planets(j).water<30 then planets(j).water=35
            if planets(j).rot<0.5 or planets(j).rot>1.5 then planets(j).rot=rnd_range(5,15)/10
        endif
    endif
    
    if (*o).type=qt_locofperson then'Loc of Person	17
        if wanthas=q_want then
            questguy(i).flag(5)=get_other_questguy(i)
        else
            questguy(i).flag(5)=get_other_questguy(i)
            questguy(i).knows(questguy(i).flag(5))=1
        endif
    endif
    
    if (*o).type=qt_goodpaying then'Good paiyng Captain	18
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=qt_research then'Research
        if wanthas=q_want then
            questguy(i).flag(1)=rnd_questguy_byjob(15,i)'If no astro
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=rnd_questguy_byjob(16,i)'xeno
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=rnd_questguy_byjob(6,i)'Doctor
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=rnd_questguy_byjob(4,i)'SO
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=rnd_questguy_byjob(13,i)'OBE MEgacopr
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=rnd_questguy_byjob(17,i)'Engineer
            if questguy(i).flag(1)=0 then questguy(i).flag(1)=get_other_questguy(i)'SO
        else
            questguy(i).has.it=makeitem(1010,i)
        endif
        
    endif
    
    if (*o).type=qt_megacorp then'Info on Megacorp	21
        if wanthas=q_want then
            do
                comp=rnd_range(1,4)
            loop until comp<>questguy(i).job-9 or (questguy(i).job<10 or questguy(i).job>14)
            questguy(i).want.it=makeitem(1006,comp)
            questguy(i).flag(6)=comp
        else
            if questguy(i).job>=10 and questguy(i).job<=13 then 
                comp=questguy(i).job-9
            else
                comp=rnd_range(1,4)
            endif
            questguy(i).has.it=makeitem(1006,comp,rnd_range(1,3))
            
        endif
        
    endif
    if (*o).type=qt_biodata then'Bio Data	22
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=qt_anomaly then'Anomaly Data	23
        if wanthas=q_want then
        else
        endif
        
    endif
    
    if (*o).type=qt_juryrig then'Jury Rig Plans	25
        if wanthas=q_want then
        else
            (*o).it=makeitem(1011)
        endif
        
    endif
    if (*o).type=qt_cursedship then'Wormhole Info	26
        if wanthas=q_want then
        else
            select case rnd_range(1,100)
            case 1 to 66
                questguy(i).flag(9)=rnd_range(5,8)
            case 67 to 85
                questguy(i).flag(9)=rnd_range(9,12)
            case else
                questguy(i).flag(9)=rnd_range(13,16)
            end select
        endif
        
    endif
    
    if _Debug=33 then
        f=freefile
        open "MQI.txt" for append as #f
        print #f,"Done"
        close #f
    endif
    
    return 0
end function

function get_other_questguy(i as short,sameplace as byte=0) as short
    dim as short other,j,h
    dim others(15) as short
    for j=1 to lastquestguy
        if i<>j and (questguy(i).location<>questguy(j).location or sameplace=1) then
            h+=1
            others(h)=j
        endif    
    next
    return others(rnd_range(1,h))
end function

function get_highestrisk_questguy(st as short) as short
    dim as short r,high,j
    for j=1 to lastquestguy
        if questguy(j).location=st then
            if questguy(j).risk>high then
                r=j
                high=questguy(j).risk
            endif
        endif
    next
    return r
end function


function rnd_questguy_byjob(jo as short,self as short=0) as short
    dim as short other,j,h
    dim others(15) as short
    for j=1 to lastquestguy
        if questguy(j).job=jo and (self=0 or j<>self) then
            h+=1
            others(h)=j
        endif    
    next
    return others(rnd_range(1,h))
end function

function questguy_dialog(i as short) as short
    dim node(64) as _dialognode
    dim as short no,l
    no=1
    'dim as short fl
    dim e as _monster
    
    questguy_message(i) 'Check if player has message for qg before entering dialogue
    
    do
        l+=1
        update_questguy_dialog(i,node(),l)
        no=node_menu(no,node(),e,0,i)
    loop until no=0
    return 0
end function

function update_questguy_dialog(i as short,node() as _dialognode,iteration as short) as short
    dim as short debug,j,jj,o
    dim as string himher(1),heshe(1)
    dim deletenode as _dialognode
    debug=2
    himher(1)="him"
    himher(0)="her"
    heshe(1)="he"
    heshe(0)="she"
    for j=1 to 64
        node(j).no=0
        node(j).statement=""
        for jj=0 to 5
            node(j).param(jj)=0
        next
        for jj=0 to 16
            node(j).option(jj).no=0
            node(j).option(jj).answer=""
        next
    next
    
    if questguy(i).talkedto=0 then questguy(i).talkedto=1
    
    if questguy(i).friendly(0)<0 then questguy(i).friendly(0)=0
    if questguy(i).friendly(0)>2 then questguy(i).friendly(0)=2
    node(1).statement=""
    if iteration=1 then
    select case questguy(i).friendly(0)
        case is=0
            node(1).statement=standardphrase(sp_greethostile,rnd_range(0,2))
        case is=1
            node(1).statement=standardphrase(sp_greetneutral,rnd_range(0,2))
        case is=2
            node(1).statement=standardphrase(sp_greetfriendly,rnd_range(0,2))
        end select
    endif
    
    o+=1
    node(1).option(o).answer="Who are you?"
    node(1).option(o).no=2
    
    if questguy(i).want.given=0 and questguy(i).want.type<>0 then
        o+=1
        node(1).option(o).answer="CODB"
        node(1).option(o).no=3
        if questguy(i).want.type=qt_outloan then 
            if has_questguy_want(i,j)>0  then
                select case questguy(i).want.type 
                case qt_outloan
                    node(1).option(o).answer=standardphrase(sp_gotmoney,rnd_range(0,2))
                    node(1).option(o).no=18
                    node(18).statement="Great! Thank you! Here are your "&questguy(i).want.motivation+1 &"0%."
                    node(18).effekt="ABGEBEN"
                    node(18).param(0)=j'Gets destroyed
                    node(18).param(1)=i
                case else
                    node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
                end select
            else
                node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
            endif
        else
            node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
        endif
    endif
    
    if questguy(i).has.given=0 and questguy(i).has.type<>0 then
        o+=1
        node(1).option(o).answer=questguyquestion(questguy(i).has.type,Q_HAS)
        node(1).option(o).no=4
    endif
    
    o+=1
    node(1).option(o).answer="Do you know ...?"
    node(1).option(o).no=8
    
    
    if questguy(i).job=1 or (questguy(i).job>=4 and questguy(i).job<=6)_
        or (questguy(i).job>=10 and questguy(i).job<=13  and questguy(i).has.type<>qt_megacorp)_
        or questguy(i).job=14 then
        o+=1
        if questguy(i).job=1 then node(1).option(o).answer="Can I get access to the stations sensors?"
        if questguy(i).job=14 then node(1).option(o).answer="Can I have an autograph?"
        if questguy(i).job>=4 and questguy(i).job<=6 then node(1).option(o).answer="Do you want to compare notes with our " & questguyjob(questguy(i).job) & "?"
        if questguy(i).job>=10 and questguy(i).job<=13 then node(1).option(o).answer="Do you have any info on your company?"
        node(1).option(o).no=6
        node(6).effekt="GIVEJOBHAS"
        node(6).param(0)=i
    endif
    
    if  questguy(i).flag(7)=0 and (questguy(i).want.type=qt_drug or questguy(i).want.type=qt_anomaly or questguy(i).want.type=qt_biodata) and questguy(i).want.given=1 then
        o+=1
        node(1).option(o).answer="Have you gotten results with your research yet?"
        node(1).option(o).no=23
        node(23).effekt="SELLOTHER"
        node(23).param(1)=1010
        node(23).param(2)=i
        node(23).param(3)=0
        node(23).param(4)=1
    endif
        
    for j=1 to lastquestguy
'        if questguy(j).want.type=qt_heirloom and i=questguy(j).want.whohasit and questguy(j).talkedto>0 then
'            o+=1
'            node(1).option(o).answer="Do you have something for "&questguy(j).n &"?"
'            node(1).option(o).no=14
'            node(14).statement="yes, i do have "&questguy(j).want.it.desig
'            node(14).option(1).answer="Can I have it?"
'            node(14).option(1).no=15
'            node(14).option(2).answer="Is there something you want that I can swap for it?"
'            node(14).option(2).no=16
'            node(15).effekt="SELLOTHER"
'            node(15).param(0)=j
'            node(15).param(1)=questguy(j).want.motivation+1
'        endif
        if i=questguy(j).flag(1) and questguy(j).talkedto=2 then
            select case questguy(j).want.type
            case qt_outloan 
                o+=1
                node(1).option(o).answer=questguy(j).n &" says you owe him money"
                node(1).option(o).no=30+o
                if questguy(i).money>=questguy(j).loan then
                    if questguy(j).loan>0 then
                        node(30+o).statement="Yes, I know. Can you give it to him?"
                        node(30+o).effekt="EINTREIBEN"
                        node(30+o).param(0)=j
                        node(30+o).option(1).no=1
                    else
                        node(30+o).statement="I already paid that back in full!"
                        node(30+o).option(1).no=1
                    endif
                else
                    node(17).statement="Yes, I know, but I can't afford to pay back right now."
                endif
            case qt_research
                if questguy(i).has.type<>qt_research and (questguy(i).want.type<>qt_drug and questguy(i).want.type<>qt_biodata and questguy(i).want.type<>qt_anomaly) then 'Doesn't have a research paper
                    o+=1
                    node(1).option(o).answer=questguy(j).n &" says he could use your help for <HISHERS> research."
                    node(1).option(o).no=30+o
                    node(30+o).statement="I do have some notes on that subject."
                    node(30+o).effekt="SELLOTHER"
                    node(30+o).param(0)=i
                    node(30+o).param(1)=1010 'Make and sell Item 1010
                    node(30+o).param(2)=i 'Make and sell Item 1010
                    node(30+o).param(3)=0 'Make and sell Item 1010
                endif

            end select
            
        endif
    next
    
    if questguy(i).want.type<>0 and questguy(i).has.type<>0 and questguy(i).want.given=0 and questguy(i).has.given=0 then
        o+=1
        node(1).option(o).answer="Maybe we can do a trade?"
        node(1).option(o).no=18
    endif
        
    if findbest(89,-1)>0 then
        o+=1
        node(1).option(o).answer="I have this crystal. Do you want to take a look at it?"
        node(1).option(o).no=22
    endif
    
    if questguy(i).job=14 then 'Entertainer
        o+=1
        node(1).option(o).answer="Maybe you could perform for my crew?"
        node(1).option(o).no=40
        if questguy(i).want.type=qt_showconcept and questguy(i).want.given=0 then 'Show concept
            node(40).statement="I would, but I have nothing new to perform. Nobody would enjoy it."
            node(40).option(1).no=1
        else
            node(40).effekt="CONCERT"
            node(40).param(0)=i
            node(40).param(1)=100-10*questguy(i).friendly(0)
        endif
    endif
    
    o+=1
    node(1).option(o).answer="Let's have a drink."
    node(1).option(o).no=21
    o+=1
    node(1).option(o).answer="Bye" 
    if _debug>0 then node(1).option(o).answer="Bye" & o
    node(1).option(o).no=0
    
    node(2).statement="I am "&questguy(i).n &", "&add_a_or_an(questguyjob(questguy(i).job),0) &"."
    node(2).option(1).no=1
    node(2).effekt="FRIENDLYCHANGE"
    node(2).param(0)=10
    node(2).param(1)=i
    
    'Want side
    node(3).statement=questguydialog(questguy(i).want.type,questguy(i).want.motivation,Q_WANT)
    node(3).effekt="SELLWANT"
    node(3).param(0)=i
    node(3).param(1)=questguy(i).want.motivation+1
    node(3).option(1).no=1
    select case questguy(i).want.type
    case qt_megacorp
        node(3).param(2)=(questguy(i).want.motivation+1)*5
    case qt_stationsensor 
        node(3).param(2)=10*(questguy(i).want.motivation+1)
    case qt_autograph 
        node(24).effekt="KNOWOTHER"
        node(24).param(2)=questguy(i).flag(1)
        node(24).param(3)=50*(questguy(i).want.motivation+1)
        node(3).option(1).answer="Do you know where "&questguy(questguy(i).flag(1)).n &" is?"
        node(3).option(1).no=24
        node(3).option(2).answer="I see what I can do."
        node(3).option(2).no=1
    case qt_outloan
        node(24).effekt="KNOWOTHER"
        node(24).param(2)=questguy(i).flag(1)
        node(3).option(1).answer="Do you know where "&questguy(questguy(i).flag(1)).n &" is?"
        node(3).option(1).no=24
        node(3).option(2).answer="I see what I can do."
        node(3).option(2).no=1
    case qt_travel
        node(3).effekt="PASSENGER"
        questguy(i).flag(15)=player.turn+(rnd_range(15,25)/10)*distance(player.c,basis(questguy(i).flag(2)).c)
    case qt_biodata 
        if reward(1)>0 then
            node(3).effekt="BUYBIODATA" 
            node(3).param(0)=i
            node(3).param(1)=1+questguy(i).want.motivation
        endif
    case qt_anomaly
        if ano_money>0 then
            node(3).effekt="BUYANOMALY"
            node(3).param(0)=i
            node(3).param(1)=1+questguy(i).want.motivation
        endif
    end select
    
    'Has side
    
    if questguy(i).has.given=0 then
        node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)
        node(4).option(1).no=1
        if node(4).statement="" then node(4).statement= questguy(i).has.type &":"& questguy(i).has.motivation
        if questguy(i).has.type=qt_research or questguy(i).has.type=qt_juryrig or _
        questguy(i).has.type=qt_EI or questguy(i).has.type=qt_drug or _ 
        questguy(i).has.type=qt_souvenir or questguy(i).has.type=qt_tools or _
        questguy(i).has.type=qt_showconcept or questguy(i).has.type=qt_stationsensor then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).param(1)=1+questguy(i).has.motivation
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_cargo then
            node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)
            node(4).effekt="GIVECARGO"
            node(4).param(0)=i
            node(4).param(1)=100-10*questguy(i).friendly(0)
        endif
        
        if questguy(i).has.type=qt_travel then
            node(4).effekt="PASSENGER"
            node(4).param(0)=i
            questguy(i).flag(15)=player.turn+(rnd_range(15,25)/10)*distance(player.c,basis(questguy(i).flag(2)).c)
            node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)

        endif
        if questguy(i).has.type=qt_drug then
            node(4).effekt="SELLHAS"
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_tools then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_ei then
            node(4).effekt="SELLHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        if questguy(i).has.type=qt_megacorp then
            node(4).effekt="GIVEJOBHAS"
            node(4).param(0)=i
            node(4).option(1).no=1
        endif
        
        if questguy(i).has.type=qt_cursedship then
            node(4).effekt="BUYSHIP"
            node(4).param(0)=i
            node(4).param(1)=questguy(i).flag(9) 'Hulltype
            node(4).param(2)=questguy(i).has.motivation+2-(2-questguy(i).friendly(0))
        endif
        if questguy(i).has.type=qt_locofgarden or questguy(i).has.type=qt_locofspecial or questguy(i).has.type=qt_locofpirates then
            node(4).effekt="PAYWALL"
            
            if questguy(i).flag(3)=0 and questguy(i).has.type=qt_locofgarden then questguy(i).flag(3)=get_random_system(0,0,0,1)
            node(4).param(0)=questguy(i).flag(3)
            select case questguy(i).has.type
            case is=qt_locofgarden
                node(4).param(1)=6-questguy(i).friendly(0)*3
            case is=qt_locofspecial
                node(4).param(1)=100-questguy(i).friendly(0)*25
            case is=qt_locofpirates
                node(4).param(1)=50-questguy(i).friendly(0)*15
            end select
                
        endif
    endif
    
    'Do you know ....
    node(8).option(1).answer="Never mind"  'We must make the lastseen list nonrandom but factual.
    node(8).option(1).no=1
    jj=1
    for j=1 to lastquestguy
        if j<>i then 'He will always know himself
            if questguy(j).talkedto<>0 then
                jj+=1
                node(8).option(jj).answer=questguy(j).n
                if questguy(i).location=questguy(j).location then 
                    node(8).option(jj).no=14 
                else
                    if questguy(i).knows(j)<>0 then
                        if questguy(i).knows(j)>0 then
                            node(8).option(jj).no=10+questguy(i).knows(j)
                        else
                            node(8).option(jj).no=10
                        endif
                    else
                        node(8).option(jj).no=9
                    endif
                endif
            endif
        endif
    next
    node(9).statement="Sorry, don't know who that is."
    node(9).option(1).no=8
    node(10).statement="Last I saw that person on one of the small space stations."
    node(10).option(1).no=8
    node(11).statement="Last saw that person on station 1"
    node(11).option(1).no=8
    node(12).statement="Last saw that person on station 2"
    node(12).option(1).no=8
    node(13).statement="Last saw that person on station 3"
    node(13).option(1).no=8
    node(14).statement="That person must be around here somewhere."
    node(14).option(1).no=8
    
    node(21).statement="Oh, thanks!"
    node(21).effekt="HAVEDRINK"
    node(21).param(0)=i
    node(21).option(1).no=1
    
    select case questguy(i).job
    case is=13 'Omega
        node(22).statement="Where did you get that from???"
        node(22).option(1).answer="Just found it"
        node(22).option(1).no=23
        node(22).option(2).answer="Tell the whole story"
        node(22).option(2).no=24
    case 4 or 15 'SO or Xenobiologist
        node(22).statement="Interesting, may I look at it?"
        node(22).option(1).answer="Yes"
        node(22).option(1).no=25
        node(25).statement="It seems to still have some of those properties that effect your perception. It's working like an illusion-filter!"
        node(25).option(1).no=1
        node(22).option(2).answer="No"
        node(22).option(2).no=1
    case else
        node(22).statement="Oh, that's pretty! But I don't know what to do with it."
        node(22).option(1).no=1
    end select
    if questguy(i).knows(questguy(i).flag(1))>0 then
        select case questguy(i).knows(questguy(i).flag(1))
        case 1,2,3
            select case rnd_range(1,100)
            case 1 to 33
                node(24).statement="Last I saw that person on Station "&questguy(i).knows(questguy(i).flag(1))&"."
            case 34 to 66
                node(24).statement="I think " & heshe(questguy(questguy(i).flag(1)).gender)& " is on Station "&questguy(i).knows(questguy(i).flag(1))&"."
            case else
                node(24).statement="I met " & questguy(questguy(i).flag(1)).n & " on Station "&questguy(i).knows(questguy(i).flag(1))&" recently."
            end select
        case else
            node(10).statement="Last I saw that person on one of the small space stations."
        end select
    else
        select case rnd_range(1,100)
        case 1 to 33
            node(24).statement="I honestly  don't know."
        case 34 to 66
            node(24).statement="I have no idea."
        case else
            node(24).statement="Sorry I can't help you with that."
        end select
    endif
    node(24).option(1).no=1
    return 0
end function


function questguy_message(c as short) as short
    dim as short i,d
    for i=0 to lastitem
        if item(i).ty=58 and item(i).w.s=-1 and item(i).v2=c then
            if askyn("Do you want to deliver the message?(y/n)") then
                d=rnd_range(1,6)*(1+questguy(item(i).v2).want.motivation)*haggle_("UP")
                dprint "You get a "& d &" Cr. tip"
                addmoney(d,mt_quest2)
                destroyitem(i)
            endif
        endif
    next
    return 0
end function

    

function has_questguy_want(i as short,byref t as short) as short
    dim as short a,b,c
    dim as short il(255),ic(255),cc,v,r,j,set,fl
    dim as string text
    if questguy(i).want.type=qt_megacorp then
        t=qt_megacorp
        if player.questflag(21)=1 and questguy(i).flag(6)=1 then return -21
        if player.questflag(22)=1 and questguy(i).flag(6)=2 then return -22
        if player.questflag(23)=1 and questguy(i).flag(6)=3 then return -23
        if player.questflag(24)=1 and questguy(i).flag(6)=4 then return -24
    endif
    
    'Item
    for a=0 to lastitem
        if item(a).w.s=-1 then
            select case questguy(i).want.type
            case is=qt_EI
                t=qt_EI
                if item(a).ty=questguy(i).want.it.ty and item(a).v1>=questguy(i).want.it.v1 then 
                    set=0
                    for j=1 to cc
                        if item(il(j)).id=item(a).id then 
                            ic(j)+=1
                            set=1
                        endif
                    next
                    if set=0 then
                        cc+=1
                        il(cc)=a
                        ic(cc)+=1
                    endif
                endif
            case is=qt_autograph
                t=qt_autograph
                if item(a).ty=57 and item(a).ty=questguy(i).want.it.ty and item(a).v1=questguy(i).want.it.v1 then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_drug
                t=qt_drug
                if item(a).ty=60 and item(a).v1=questguy(i).want.it.v1 then
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_souvenir
                t=qt_souvenir
                if item(a).ty=23 then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_showconcept
                t=qt_showconcept
                if item(a).ty=63 and (item(a).v1=i or item(a).v1=0) then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_stationsensor
                t=qt_stationsensor
                if item(a).ty=64 and (questguy(i).location=-1 or item(a).v1=questguy(i).location) then   
                    item(a).price=(questguy(i).want.motivation+1)*10
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_outloan
                if item(a).ty=62 and item(a).v1=i then
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_research
                t=qt_research
                if item(a).ty=65 and item(a).v1=questguy(i).flag(1) then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_tools
                t=qt_tools
                if item(a).ty=59 then   
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_megacorp
                t=qt_megacorp
                if item(a).ty=61 and item(a).v1=questguy(i).want.it.v1 then  
                    cc+=1
                    il(cc)=a
                endif
            case is=qt_juryrig
                t=qt_juryrig
                if item(a).ty=66 then  
                    cc+=1
                    il(cc)=a
                endif
            end select
        endif
    next
    
    if cc=1 then
        t=il(cc)
        return il(cc)
    endif
    if cc>1 then
        text="Offer"&cc
        for j=1 to cc
            if ic(j)=1 then
                text=text &"/" &item(il(j)).desig &" (Est. "&credits(item(il(j)).price) &" Cr.)"
            else
                text=text &"/" &ic(j) &" " &item(il(j)).desigp &" (Est. "&credits(item(il(j)).price) &" Cr.)"
            endif
        next
        fl=20-cc
        if fl<0 then fl=0
        cc=menu(bg_parent,text,,0,fl)
        if cc>0 then 
            t=il(cc)
            return il(cc)
        else
            t=0
            return -1
        endif
    endif
        
    'Location of character
    for a=1 to lastquestguy
        if questguy(a).talkedto=1 then 'Player knows
            if questguy(i).knows(a)=0 then 'character doesnt
                if questguy(i).want.type=qt_goodpaying and questguy(a).job=2 then
                    t=qt_goodpaying
                    return a
                endif
                if questguy(i).want.type=qt_stationimp and (questguy(a).job=17 or questguy(a).has.type=qt_stationimp) then
                    t=qt_stationimp
                    return a
                endif
                if questguy(i).want.type=qt_locofperson and questguy(i).flag(1)=a then
                    t=qt_locofperson
                    return a
                endif
            
            endif
        endif
    next
    
    'Location of planet
    for a=0 to laststar
        if map(a).discovered>0 and questguy(i).systemsknown(a)=0 then
            for b=1 to 9
                if map(a).planets(b)>0 and map(a).planets(b)<=max_maps then
                    if planets(map(a).planets(b)).discovered<>0 then
                        if questguy(i).want.type=qt_locofpirates then
                            for c=0 to _nopb
                                if pirateplanet(c)=map(a).planets(b) then
                                    t=qt_locofpirates
                                    return map(a).planets(b)
                                endif
                            next
                        endif
                        if questguy(i).want.type=qt_locofgarden then
                            if isgardenworld(map(a).planets(b)) then
                                t=qt_locofgarden
                                return map(a).planets(b)
                            endif
                        endif
                        if questguy(i).want.type=qt_locofspecial then
                            if is_special(map(a).planets(b)) then
                                t=qt_locofspecial
                                return map(a).planets(b)
                            endif
                        endif
                    endif
                endif
            next
        endif
    next
    
    
    'Info
    
'        
'    qt_showconcept
'    qt_stationsensor
'    qt_message
'    qt_locofpirates
'    qt_locofspecial
'    qt_locofgarden
'    qt_locofperson
'    qt_goodpaying
'    qt_research
'    qt_stationneeds
'    qt_megacorp
'    qt_biodata
'    qt_anomaly
'    qt_murderclients
'    qt_juryrig
'    qt_wormhole
'    qt_crime
'    qt_whereperform
'    qt_haswantsloc
'        if questguy(i).want.it.v1<0 then
'            if item(a).ty=questguy(i).want.it.ty and item(a).v1=abs(questguy(i).want.it.v1) and item(a).w.s=-1 then 
'                if item(a).ty=57 then item(a).price=rnd_range(1,6)*50 'Autograph
'                return a
'            endif
'        else
'            if item(a).ty=questguy(i).want.it.ty and item(a).v1>=questguy(i).want.it.v1 and item(a).w.s=-1 then 
'                t=qt_EI
'                return a
'            endif
'        endif
    'next
    t=-1
    return -1
end function

function dodialog(no as short,e as _monster, fl as short) as short
    dim node(64) as _dialognode
    dim as short last,debug
    last=load_dialog("data/dialog" &no & ".csv",node())
    no=1
    debug=1
    do
        display_ship(0)
        if debug=1 and _debug=1 then dprint node(no).effekt
        no=node_menu(no,node(),e,fl)
        if debug=1 and _debug=1 then dprint "Next node:"&no
    loop until no=0
    return 0
end function

function node_menu(no as short,node() as _dialognode,e as _monster, fl as short,qgindex as short=0) as short
    dim as string text,rh,lh
    dim as short a,c,flag,debug
    debug=1
    if node(no).effekt="PAYWALL" then
        
        lh=left(node(no).statement,instr(node(no).statement,"<->")-1)
        rh=right(node(no).statement,len(node(no).statement)-2-instr(node(no).statement,"<->"))
        dprint lh,15
        if node(no).param(1)>0 and questguy(qgindex).has.given=0 then
            If askyn("I will tell you for "&node(no).param(1)& " Cr. Do you want to pay?(y/n)") then
                if paystuff(node(no).param(2)) then
                    questguy(qgindex).has.given=1
                    if planets(questguy(qgindex).flag(4)).discovered=0 then planets(questguy(qgindex).flag(4)).discovered=1
                    if map(questguy(qgindex).flag(3)).discovered=0 then 
                        map(questguy(qgindex).flag(3)).discovered=1
                        map(questguy(qgindex).flag(3)).desig=spectralshrt(map(questguy(qgindex).flag(3)).spec)&player.discovered(map(questguy(qgindex).flag(3)).spec)&"-"&int(disnbase(map(questguy(qgindex).flag(3)).c))&cords(map(questguy(qgindex).flag(3)).c) 
                    endif
                    if _debug=33 then dprint "Map "&questguy(qgindex).flag(3) &" is now discovered "&cords(map(questguy(qgindex).flag(3)).c)
                else
                    return 0 'Not enough moneys
                endif
            else
                return 0 'Doesnt pay
            endif
        else
            if map(questguy(qgindex).flag(3)).discovered=0 then 
                map(questguy(qgindex).flag(3)).discovered=1
                map(questguy(qgindex).flag(3)).desig=spectralshrt(map(questguy(qgindex).flag(3)).spec)&player.discovered(map(questguy(qgindex).flag(3)).spec)&"-"&int(disnbase(map(questguy(qgindex).flag(3)).c))&cords(map(questguy(qgindex).flag(3)).c)
            endif
            
        endif
    endif
    if debug=1 and _debug=1 then dprint "debug!"
    if node(no).effekt="PAYWALL" then
        dprint adapt_nodetext(rh,e,fl,qgindex),15
    else
        dprint adapt_nodetext(node(no).statement,e,fl,qgindex),15
    endif
    if node(no).effekt<>"" then 
        dialog_effekt(node(no).effekt,node(no).param(),e,fl)
        if node(no).param(5)>0 then return node(no).param(5)
    endif
    text="You say"
    if qgindex>0 and _debug=1 then text=text &questguy(qgindex).talkedto
    for a=1 to 16
        if node(no).option(a).answer<>"" then 
            text=text &"/"& adapt_nodetext(node(no).option(a).answer,e,fl,qgindex)
            if debug=1 and _debug=1 then text=text &"("& node(no).option(a).no &")"
            flag+=1
        endif
    next
    'if qgindex>0 then text=text &"/Bye."
    if flag>0 then
        do
            c=menu(bg_shiptxt,text,,0,20-flag,1)
        loop until c>=0
        dprint adapt_nodetext(node(no).option(c).answer,e,fl,qgindex),15
        if debug=1 and _debug=1 then dprint "you choose "&node(no).option(c).no &":"&c,11
        return node(no).option(c).no
    else
        return node(no).option(1).no
    endif
end function

function adapt_nodetext(t as string, e as _monster,fl as short,qgindex as short=0) as string
    dim word(128) as string
    dim stword(128) as string
    dim r as string
    dim as string himher(1),hishers(1),heshe(1),relative(8)
    relative(0)="brother"
    relative(1)="sister"
    relative(2)="father"
    relative(3)="mother"
    relative(4)="uncle"
    relative(5)="aunt"
    relative(6)="grandmother"
    relative(7)="grandfather"
    himher(0)="her"
    himher(1)="him"
    hishers(0)="hers"
    hishers(1)="his"
    heshe(0)="she"
    heshe(1)="he"
    dim as short l,i,j
    l=string_towords(stword(),t," ",0)
    for i=0 to l
        if instr(stword(i),">")>0 and instr(stword(i),">")<len(stword(i)) then
            word(j)=left(stword(i),instr(stword(i),">"))
            j+=1
            word(j)=right(stword(i),len(stword(i))-instr(stword(i),">"))
            j+=1
        else
            
            word(j)=stword(i)
            j+=1
        endif
    next
    j-=1
    for i=0 to j
        if word(i)="<SPLANET>" then word(i)=lcase(left(spdescr(questguy(qgindex).flag(4)),1))&right(spdescr(questguy(qgindex).flag(4)),len(spdescr(questguy(qgindex).flag(4)))-1)
        if word(i)="<OHIMHER>" then word(i)=himher(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<8HIMHER>" then word(i)=himher(questguy(questguy(qgindex).flag(8)).gender)
        if word(i)="<OHESHE>" then word(i)=heshe(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<OHISHERS>" then word(i)=hishers(questguy(questguy(qgindex).flag(1)).gender)
        if right(word(i),len(word(i))-1)="<CHAR>" then word(i)=questguy(questguy(qgindex).flag(val(word(i)))).n
        if word(i)="<OCHAR>" then word(i)=questguy(questguy(qgindex).flag(5)).n
        if word(i)="<GOAL>" then word(i)="station-"&fleet(fl).con(3)+1
        if word(i)="<FLEET>" then word(i)=""&abs(fl)
        if word(i)="<PLAYER>" then word(i)="captain "&crew(1).n &" of the "&player.desig
        if word(i)="<COORDS>" then 
            if fl>0 then 
                word(i)=fleet(fl).c.x &":"& fleet(fl).c.y
            else
                word(i)=drifting(abs(fl)).x &":"& drifting(abs(fl)).y
            endif
        endif
        if word(i)="<PCORDS>" then word(i)=cords(map(questguy(qgindex).flag(3)).c)&", orbit "& orbitfrommap(questguy(qgindex).flag(4)) & ":"&questguy(qgindex).flag(4) 
        if word(i)="<#FL>" then word(i)=""&abs(fl)
        if word(i)="I-<#FL>" then word(i)="IS-"&abs(fl)
        if word(i)="<ITEMWDESC>" and qgindex>0 then word(i)=questguy(qgindex).want.it.ldesc
        if word(i)="<ITEMW>" and qgindex>0 then word(i)=questguy(qgindex).want.it.desig
        if word(i)="<ITEMH>" and qgindex>0 then word(i)=questguy(qgindex).has.it.desig
        if word(i)="<CHARACTER>" and qgindex>0 then word(i)=questguy(questguy(qgindex).flag(1)).n 
        if word(i)="<HESHE>" and qgindex>0 then word(i)=heshe(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<HIMHER>" and qgindex>0 then word(i)=himher(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<HISHERS>" and qgindex>0 then word(i)=hishers(questguy(questguy(qgindex).flag(1)).gender)
        if word(i)="<MONEY>" and qgindex>0 then word(i)=credits(questguy(questguy(qgindex).flag(1)).loan)
        if word(i)="<DRUG>" and qgindex>0 then
        endif
        if word(i)="<RELATIVE>" and qgindex>0 then word(i)=relative(questguy(qgindex).flag(2))
        if word(i)="<CORP>" and qgindex>0 then word(i)=companyname(questguy(qgindex).flag(6))
        if word(i)="<TONS>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(1)
        if word(i)="<DEST>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(12)+1
        if word(i)="<TIME>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(15)
        if word(i)="<PAY>" and qgindex>0 then word(i)=""&questguy(qgindex).flag(13)
        r=r &word(i)
        if len(word(i+1))>1 or ucase(word(i+1))="A" or ucase(word(i+1))="I" then r=r &" "
        
    next
    return r
end function

function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
    dim as short f,a,i,t,ph,dh,dis,goal,answer,h,hc,c
    dim as integer rew,price
    dim as _items it
    dim as single fuelprice,fuelsell
    dim as string text
    dim as _ship sh
    if effekt="CHANGEMOOD" then e.aggr=p(0)
    
    if effekt="FRIENDLYCHANGE"  then 
        if rnd_range(1,100)<p(0) and questguy(p(1)).friendly(0)<2 then questguy(p(1)).friendly(0)+=1
    endif
    
    if effekt="PASSENGER" then
        if askyn("Do you want to transport "&questguy(p(0)).n &" to station "&questguy(p(0)).flag(12)+1 &" by turn " &questguy(p(0)).flag(15) &" for " &credits(questguy(p(0)).flag(13))& " Cr.? (y/n)") then
            add_passenger(questguy(p(0)).n,30+p(0),questguy(p(0)).flag(13),questguy(p(0)).flag(14),questguy(p(0)).flag(12)+1,questguy(p(0)).flag(15),questguy(p(0)).gender)
            questguy(p(0)).location=-3
        endif
    endif
    
    if effekt="BUYSHIP" then
        sh=gethullspecs(p(1),"data/ships.csv")
        price=sh.h_price*haggle_("down")*((90-p(2)*5)/100)
        textbox(makehullbox(p(1),"data/ships.csv"),2,2,35,11,1)
        
        if askyn("Do you want to buy the "& sh.h_desig &" for "&credits(price)&" Cr.?(y/n)") then
            if buy_ship(p(1),sh.h_desig,price)=-1 then player.cursed=rnd_range(1,p(2))
        endif
    endif
    
    if effekt="CONCERT" then
        if askyn(questguy(p(0)).n &" wants "&credits(p(1))&" to perform for your crew. Do you agree? (y/n)") then
            if paystuff(p(1)) then
                for a=2 to 128
                    if crew(a).hp>0 and rnd_range(1,20)<12+add_talent(1,4,5) then 
                        h=a
                        hc+=1
                        crew(a).morale+=rnd_range(1,4)+add_talent(1,4,1)
                    endif
                next
                dprint "You enjoy a show with your crew."
                if hc>1 then dprint "Some in your crew seem to enjoy it.",c_gre
                if hc=1 then dprint crew(h).n &" seems to enjoy it.",c_gre
            endif
        endif
    endif
    
    if effekt="BUYFUEL" then
        if askyn("Do you want to buy fuel for "&p(0) &" Cr. (y/n)") then
            dprint "How much fuel do you want to buy"
            f=getnumber(0,player.fuelmax-player.fuel,0)
            if f*p(0)>player.money then f=fix(player.money/p(0))
            if f+player.fuel>player.fuelmax then f=player.fuelmax-player.fuel
            player.fuel=player.fuel+f
            if f>0 then dprint "You buy "&f &" tons of fuel for "& credits(f*p(0)) &" Cr."
        endif
    endif
    
    if effekt="SETTARGET" then
        fleet(fl).t=lastwaypoint+1
        if p(0)=2 then
            dprint "X Coordinate:"
            targetlist(fleet(fl).t).x=getnumber(0,sm_x,0)
            dprint "Y Coordinate:"
            targetlist(fleet(fl).t).y=getnumber(0,sm_y,0)
        else
            targetlist(fleet(fl).t).x=player.lastpirate.x
            targetlist(fleet(fl).t).y=player.lastpirate.y
        endif
    endif
    
    if effekt="SELL" then
        if p(0)=1 then
            a=get_item
            if a>0 then
                if item(a).ty=2 or item(a).ty=7 or item(a).ty=4 then
                    item(a).w.p=e.no
                    item(a).w.s=0
                    it=makeitem(96,-1,-3)
                    placeitem(it,0,0,0,0,-1)
                    reward(2)=reward(2)+it.v5
                    dprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
                endif
            endif
        endif
        if p(0)=2 then 'Questitem
            dprint "You sell your "&item(p(1)).desig &" for "& credits(item(p(1)).price*p(2)*(1+crew(1).talents(2)/10)) &" Cr."
            addmoney(item(p(1)).price*p(2)*(1+crew(1).talents(2)/10),mt_trading)
            
            item(p(1))=item(lastitem)
            lastitem-=1
            
        endif
    endif
    if effekt="GIVEHAS" then
        placeitem(questguy(p(0)).has.it,0,0,0,0,-1)
        questguy(p(0)).has.given+=1
        dprint questguy(p(0)).n &" gives you "& add_a_or_an( questguy(p(0)).has.it.desig,0) &"."
    endif
    
    if effekt="GIVEJOBHAS" then
        select case questguy(p(0)).job
        case is=1
            it=makeitem(1009,questguy(p(0)).location)
            if questguy(p(0)).friendly(0)>1 then
                it.price=0
            else
                it.price=25
            endif
        case is=14
            it=makeitem(1002,p(0))
            if questguy(p(0)).friendly(0)>0 then
                it.price=10
            else
                it.price=0
            endif
        case 4 to 6
            if questguy(p(0)).friendly(0)=2 and questguy(p(0)).flag(0)=0 then
                dprint "Of course!"
                if questguy(p(0)).job=4 then dprint gainxp(4,urn(0,3,1,0)),c_gre
                if questguy(p(0)).job=5 then dprint gainxp(3,urn(0,3,1,0)),c_gre
                if questguy(p(0)).job=6 then dprint gainxp(5,urn(0,3,1,0)),c_gre
                questguy(p(0)).flag(0)=1
                return 0
            else
                dprint "I don't have anything interesting to share."
                return 0
            endif
        case else 'Company report
            dprint standardphrase(sp_gotreport,rnd_range(0,2))
            it=makeitem(1006,questguy(p(0)).job-9,questguy(p(0)).friendly(0))
            it.price=50*questguy(p(0)).friendly(0)
        end select
        it.price=it.price*(1-crew(1).talents(2)/10)
        if it.price=0 and it.desig<>"" then
            dprint "Of course! "&questguy(p(0)).n &" hands you "&add_a_or_an(it.desig,0) &"."
            placeitem(it,0,0,0,0,-1)
        else
            if askyn("Do you want to pay "&credits(it.price) &" Cr. for the "&it.desig &"?(y/n)") then
                if paystuff(it.price) then
                    dprint "You buy "&add_a_or_an(it.desig,0) &"."
                    placeitem(it,0,0,0,0,-1) 
                endif
            endif
        endif
                    
    endif
    
    if effekt="SELLHAS" then
        it=questguy(p(0)).has.it
        p(1)=(questguy(p(0)).has.motivation+1)/5
        price=fix(it.price*p(1))'*((10-questguy(p(0)).friendly(0)-crew(1).talents(2))/10)
        if price>0 then
            answer=askyn("Do you want to buy "& add_a_or_an(it.desig,0) &" for "& credits(price) &" Cr.(y/n)")
        else
            answer=askyn("Do you want the "& it.desig &"?(y/n)")
        endif
        if answer then
            if paystuff(price) then
                placeitem(it,0,0,0,0,-1)
                dprint questguy(p(0)).n &" gives you "& add_a_or_an( questguy(p(0)).has.it.desig,0) &"."
                questguy(p(0)).has.given+=1
            endif
        endif
    endif
    
    if effekt="SELLOTHER" then 'p0=who p1=what,p2=mod1,p3=mod2
        it=makeitem(p(1),p(2),p(3))
        if p(1)=1012 then 'Alibi
            if questguy(p(0)).friendly(0)+questguy(p(0)).friendly(p(2))>=3 then
                price=0
            else
                price=100-questguy(p(0)).friendly(p(2))*25-questguy(p(0)).friendly(0)*10
            endif
            if price>0 then
                if questguy(p(0)).friendly(p(2))<2 then text="Yes, but I don't like that person very much. Why would I want to be help?" 
                if questguy(p(0)).friendly(0)<2 then text="Why would I want to be drawn into it?" 
                if questguy(p(0)).friendly(0)<2 and questguy(p(0)).friendly(p(2))<2 then text="Yes, but I neither like you nor the other person very much. Why would I want to be drawn into it?" 
                dprint text,15
            endif
        else
            price=it.price*((10-questguy(p(0)).friendly(0))/10)
        endif
        
        if price>0 then
            answer=askyn("Do you want to buy "& add_a_or_an(it.desig,0) &" for "& credits(price) &" Cr?(y/n)")
        else
            answer=askyn("Do you want the "& it.desig &"?(y/n)")
        endif
        
        if answer then
            if paystuff(price) then
                placeitem(it,0,0,0,0,-1)
                dprint questguy(p(0)).n &" gives you "& add_a_or_an( it.desig,0) &"."
    
                if p(4)=1 then questguy(p(0)).flag(7)=1
            endif
        endif
    endif
    
    if effekt="KNOWOTHER" and p(2)>0 then 
        if questguy(p(2)).talkedto=0 then questguy(p(2)).talkedto=1
    endif
    
    if effekt="GIVECARGO" then
        f=questguy(p(0)).flag(1)
        goal=questguy(p(0)).flag(2)
        price=p(1)
        if price*f>player.money then f=player.money/price
        if f>getfreecargo then f=getfreecargo
        if f>0 then
            if askyn("Do you want to buy "&f &" tons of Cargo for station "&goal+1 &" for "&credits(price)&"Cr. ?(y/n)") then
                if paystuff(f*price) then
                    if f>0 then f=load_quest_cargo(12,f,goal)
                    questguy(p(0)).flag(1)=f
                endif
            endif
        endif
    endif
    
    if effekt="SELLWANT" Then
        questguy(p(0)).talkedto=2
        i=has_questguy_want(p(0),t)
        if _debug>0 then dprint "T is "&t &" I is "&i &" p1 is" &p(1) &" p2 is"&p(2)
        if i>0 then
            select case t
            case qt_stationimp,qt_goodpaying,qt_locofperson
                if questguy(p(0)).want.given=0 then
                    if askyn("Do you want to tell him about "&questguy(i).n &"?(y/n)") then
                        questguy(p(0)).talkedto=3
                        addmoney(50*(questguy(p(0)).want.motivation+1),mt_quest2)
                        dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                        if 50*(questguy(p(0)).want.motivation+1)>0 then dprint "You get a "&credits(50*(questguy(p(0)).want.motivation+1)) &" Tip."
                        if t=qt_stationimp and questguy(p(0)).location>=0 then
                                fleet((questguy(p(0)).location+1)).mem(1).hull+=rnd_range(2,20) 'Improves infrastructure
                        endif
                        questguy(p(0)).want.given+=1
                        if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                    
                    endif
                endif
            case qt_locofpirates,qt_locofspecial,qt_locofgarden
                if askyn("Do you want to tell him about the system at "&map(sysfrommap(i)).c.x &":"& map(sysfrommap(t)).c.y &"?(y/n)") then
                    questguy(p(0)).talkedto=3
                    questguy(p(0)).systemsknown(sysfrommap(i))=1
                    if t=qt_locofpirates then
                        rew=50*(questguy(p(0)).want.motivation+1)*planets(i).discovered*haggle_("up")
                    else
                        rew=10*(questguy(p(0)).want.motivation+1)*planets(i).discovered*haggle_("up")
                    endif
                    dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                    addmoney(rew,mt_quest2)
                    dprint "You get "&rew &" Cr. for the information"
                    if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                    
                endif
            case qt_megacorp
                price=(10+item(i).price)*(item(i).v2+p(1)+p(2))*haggle_("up")
                if askyn("Do you want to sell your "&item(i).desig &" for "& price &" Cr.(y/n)?") then
                    questguy(p(0)).talkedto=3
                    dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                    addmoney(price,mt_quest2)
                    destroyitem(i)
                    questguy(p(0)).want.given+=1
                    if rnd_range(1,100)<60 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                endif
            case else
                price=item(i).price*((p(1)+p(2))/5)*haggle_("up")
                if askyn("Do you want to sell your "&item(i).desig &" for "& price &" Cr.(y/n)?") then
                    if price>questguy(p(0)).money*.6 then
                        if askyn("I only have "&credits(questguy(p(0)).money*.6) &" Cr. Would you accept that? (y/n)") then
                            questguy(p(0)).friendly(0)+=1
                            price=questguy(p(0)).money*.6
                        endif
                    endif
                    if price<questguy(p(0)).money then
                        questguy(p(0)).talkedto=3
                        questguy(p(0)).money-=price
                        dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                        addmoney(price,mt_quest2)
                        destroyitem(i)
                        questguy(p(0)).want.given+=1
                        if rnd_range(1,100)<50 and questguy(p(0)).friendly(0)<2 then questguy(p(0)).friendly(0)+=1 
                        if t=qt_drug and questguy(p(0)).want.motivation>0 then questguy(p(0)).want.motivation-=1
                    endif
                else
                    if item(i).ty=57 or item(i).ty=64 then item(i).price=0
                
                endif
            end select
            return 0
        endif
        if i<-20 and t=qt_megacorp then
            i=abs(i)
            if askyn("Do you want to sell your information on "&companyname(i-21) &"?(y/n)") then
                questguy(p(0)).talkedto=3
                dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
                player.questflag(i)+=1
                addmoney(15000,mt_blackmail)
            endif
        endif
    endif
    
    if effekt="GIVEMESSAGE" then
        if askyn("Do you want to deliver the message?(y/n)") then placeitem(makeitem(1003,p(0),questguy(p(0)).flag(1)),0,0,0,0,-1)
        'dprint questguyquestion(questguy(p(0)).want.type,Q_ANSWER)  
    endif
    
    if effekt="GIVEAUTOGRAPH" then
        placeitem(makeitem(1002,p(0)),0,0,0,0,-1)
    endif
    
    if effekt="GIVESACC" then
        placeitem(makeitem(1009,p(0)),0,0,0,0,-1)
    endif
        
    if effekt="BUYBIODATA" then
        questguy(p(0)).talkedto=2
        if reward(1)>0 then
            if askyn("Do you want to sell your biodata for "& reward(1)*p(1) & " Cr.?(y/n)") then
                addmoney(reward(1)*p(1),mt_bio)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then 
                    questguy(p(0)).want.given=1
                    questguy(p(0)).talkedto=3
                endif
                reward(1)=0
                dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
            endif
        endif
    endif
    
    if effekt="BUYANOMALY" then
        questguy(p(0)).talkedto=2
        if ano_money>0 then
            if askyn("Do you want to sell your data on anomalies for "& ano_money*p(1) & " Cr.?(y/n)") then
                addmoney(ano_money*p(1),mt_ano)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then 
                    questguy(p(0)).want.given=1
                    questguy(p(0)).talkedto=3
                endif
                ano_money=0
                dprint adapt_nodetext(questguydialog(questguy(p(0)).want.type,questguy(p(0)).want.motivation,Q_ANSWER),e,fl,p(0)),15  
            endif
        endif
    endif
    
    if effekt="BUYOTHERWANT" then
        it=questguy(p(0)).want.it
        price=it.price*(p(1)/10)*haggle_("down")
        if askyn("Do you want to buy the "&it.desig &" for "&credits(price) &"?(y/n)") then
            if paystuff(price) then placeitem(it,0,0,0,0,-1)
        endif
    endif
    
    if effekt="EINTREIBEN" then
        placeitem(makeitem(1007,p(0),questguy(questguy(p(0)).flag(1)).loan),0,0,0,0,-1)
        questguy(p(0)).loan=0
    endif
    
    if effekt="ABGEBEN" then
        price=item(p(0)).v2*(questguy(p(1)).want.motivation+1)/10
        dprint questguy(p(1)).n &" gives you "& credits(price) &" Cr.",c_gre
        addmoney(price,mt_quest2)
        destroyitem(p(0))
        questguy(p(1)).want.given=1
    endif
    
    if effekt="HAVEDRINK" then
        if paystuff(2) then
            p(1)+=1
            select case rnd_range(1,100)-questguy(p(0)).friendly(0)*5-p(1)
            case is<=10
                questguy(p(0)).friendly(0)+=1
                dprint "You really hit it off with "&questguy(p(0)).n &"."
            case is>=90
                questguy(p(0)).friendly(0)-=1
                dprint "The conversation devolves into an argument."
            case else
                dprint "You have a little smalltalk, and enjoy the drink."
            end select
        endif
    endif
    
    if effekt="LEARNSKILL" then 'p0=price p1=skill
        
        if player.money>=p(0) then
            a=showteam(0,0,"Learn "&talent_desig(p(1)))
            if a>=0 then
                if can_learn_skill(a,p(1))=-1 then
                    crew(a).talents(p(1))+=1
                    paystuff(p(0))
                endif
            else
                dprint crew(a).n &" can't learn " &talent_desig(p(1)),c_yel
            endif
        else
            dprint "You don't have enough money",14
            
        endif
    endif
    
    if effekt="PIRATETHREAT" then
        for i=1 to 15
            dh+=fleet(fl).mem(i).hull
        next
        ph=player.hull
        if rnd_range(1,ph+dh)+dh>rnd_range(1,ph+dh)+ph then
            'defend
            dprint "Ha! We are going to defend ourselves!"&ph,c_yel
            if rnd_range(1,100)>25+faction(0).war(1) then
                if askyn("Do you really want to attack?(y/n)") then 
                    i=1
                else
                    dprint "Wannabe pirate scum.... Click"
                    i=0
                    factionadd(0,fleet(fl).ty,1)
                endif
            else
                i=1
            endif
            if i=1 then
                factionadd(0,fleet(fl).ty,3)
                playerfightfleet(fl)
            endif
        else
            'Drop cargo
            dprint "Ok, we don't want any trouble.",c_gre
            factionadd(0,fleet(fl).ty,2)
            for i=1 to lastgood
                basis(10).inv(i).v=0
                basis(10).inv(i).p=0
            next
            fleet(fl)=unload_f(fleet(fl),10)
            trading(10)
            fleet(fl)=load_f(fleet(fl),10)
        endif
    endif
    
    if effekt="ESCORT" then
        if rnd_range(1,20)<5+patrolmod+fleet(a).con(4)+crew(1).talents(4) then
            factionadd(0,fleet(fl).ty,-1)
            price=3+player.h_maxweaponslot
            dis=merc_dis(fl,goal)
            fleet(fl).con(2)=cint(price*dis*(1+crew(1).talents(2)/10))
            if askyn("Of course a little extra protection would be nice. Our goal is Station-" &goal+1 & ". How about " & fleet(fl).con(2) & " Cr. Pirate bounties are yours too?(y/n)") then
                fleet(fl).con(1)=1
                fleet(fl).con(3)=goal
                if fleet(fl).con(4)>0 then dprint "Glad to see you again, btw. Let's hope this goes as smoothly as the last time"
            else
                fleet(fl).con(2)=0
            endif
        else
            dprint "No thanks."
            fleet(fl).con(4)-=1
        endif
    endif
    
    if effekt="FUELPRICE" then
        fl=abs(fl)
        fuelprice=round_nr(basis(nearest_base(player.c)).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
        if fuelprice<1 then fuelprice=1
        if planets(drifting(fl).m).flags(26)=9 then fuelprice=fuelprice*3 
        fuelsell=fuelprice/2
        
        dprint "We buy for " &credits(fuelsell) & " Cr. and sell for " & credits(fuelprice) & " Cr."
    endif
    
    if effekt="STATIONEVENT" then
        fl=abs(fl)
        fuelprice=round_nr(basis(nearest_base(player.c)).inv(9).p/30+disnbase(player.c)/15-count_gas_giants_area(player.c,3)/2,2)
        if fuelprice<1 then fuelprice=1
        if planets(drifting(fl).m).flags(26)=9 then fuelprice=fuelprice*3 
        fuelsell=fuelprice/2
        
        select case planets(drifting(fl).m).flags(26)
        
        case is=1
            dprint "There is a alien lifeform lose on the station, and advises you to stay clear of dark corners."
        Case is=4
            dprint "There is a mushroom infestation on the station! Please dock and help us! We will pay you if you can destroy them!"
        case is=5 
            dprint "Please help us! The station is under attack from pirates!"
        case is=6
            dprint "We got a little problem. The station has been hit by an asteroid and is currently leaking. Better wear your spacesuits if you come on board."
        case is=9 
            dprint "There is a fuel shortage and the prices have been increased to "&fuelprice &" for buying and "&fuelsell & " a ton for selling"
        case is=10
            dprint "There is a party of civilized aliens on board!"
        case is=12
            dprint "There is a tribble infestation on the station!"
        case else
            dprint "Business is going very well, thank you for asking!."
        end select
        
    endif
    
    return 0
end function


function dirdesc(f as _cords,t as _cords) as string
    dim d as string
    dim as single dx,dy
    dx=(f.x-t.x)
    dy=(f.y-t.y)
    if dy<-2 then d=d &"south"
    if dy>2 then d=d &"north"
    if dx<-2 then d=d &"east"
    if dx>2 then d=d &"west"
    if d="" then 
        d="nearby"
    else
        d=d &" from here."
    endif
    return d
end function
  
function communicate(e as _monster,mapslot as short,li()as short,lastlocalitem as short,monslot as short) as short
    dim as short roll,a,b
    dim as byte c,o
    dim as string t
    dim it as _items
    dim p as _cords
    
    if e.lang<0 then
        if skill_test(player.science(location)+e.intel+add_talent(4,14,2),st_average,"Science Officer:") then
            dprint "You have established communication with the " & e.sdesc &"."
            e.lang=-e.lang
            e.cmmod=e.cmmod+1
            if e.lang=30 then e.aggr=0
            if e.lang=31 then e.aggr=0
        else
            if player.science(0)<>captainskill or crew(4).onship=0 then
                dprint "Your science officer cant make any sense out of the " &e.sdesc &"s sounds and actions."
                e.cmmod=e.cmmod-1
            else
                dprint "No science officer in the team."
            endif
        endif
    endif
    if e.lang=1 then
        select case e.intel
        case is>4
            if e.aggr=0 then rndsentence(e)
            if e.aggr=1 then
                if findbest(23,1)<>-1 and rnd_range(1,6)+ rnd_range(1,6)<2*e.intel then
                    if item(findbest(23,-1)).v1=3 then 
                        dprint "It says 'That doesnt belong to you, give it back!'"
                        e.cmmod=e.cmmod-rnd_range(1,4)
                    else
                        dprint "It says 'You have pretty things!'"
                        e.cmmod=e.cmmod+1
                    endif
                endif
                if rnd_range(1,100)>(e.intel-add_talent(4,14,1))*6 then
                    rndsentence(e)
                else
                    select case rnd_range(1,100)
                    case is<22
                        'Tell about caves
                        roll=-1
                        for a=0 to lastportal
                            if portal(a).from.m=mapslot then roll=a
                        next
                        
                        if roll=-1 then
                            dprint "It says 'I dont know of any tunnels'"
                        else
                            p.x=portal(roll).from.x
                            p.y=portal(roll).from.y
                            dprint "It says 'There is a tunnel  "&dirdesc(e.c,p) &"'"
                        endif
                    case 22  to 44
                        'Tell about item
                        if lastlocalitem>0 then
                            roll=rnd_range(1,lastlocalitem)
                            if item(li(roll)).w.s=0 and item(li(roll)).w.p=0 then
                                p.x=item(li(roll)).w.x
                                p.y=item(li(roll)).w.y
                                if item(li(roll)).ty=15 then
                                    dprint "It says 'There are sparkling stones at "& dirdesc(e.c,p) &"'"
                                else
                                    dprint "It says 'There is something strange at "& dirdesc(e.c,p) &"'"
                                endif
                            else
                                dprint "It says 'An animal here owns someting shiny'"
                            endif
                        else
                            dprint "It says 'this is a boring place'"
                        endif
                    case 45 to 55
                        if askyn("It says 'do you want to trade?'(y/n)") then
                            dprint "What do you want to offer to the "&e.sdesc &"?"
                            b=get_item
                            if b>0 then
                                item(b).w.s=0
                                item(b).w.p=monslot
                                reward(2)=reward(2)-item(b).v5
                                lastlocalitem=lastlocalitem+1
                                li(lastlocalitem)=b
                                it=makeitem(94)
                                placeitem(it,0,0,0,0,-1)
                                dprint "It takes the "&item(b).desig &" and hands you "&it.desig &"."   
                                e.cmmod=e.cmmod+2
                            else
                                dprint "It seems dissapointed."
                                e.cmmod=e.cmmod-1
                            endif
                        else
                            dprint("It seems dissapointed.")
                            e.cmmod=e.cmmod-1
                        endif
                    case 56 to 66
                        if askyn("It says 'do you want to play with me?'(y/n)") then
                            dprint "You play with the alien."
                            e.cmmod+=2
                            if rnd_range(1,100)<66 then
                                dprint "it says 'That was fun! Here take this gift!'"
                                it=makeitem(94)
                                placeitem(it,0,0,0,0,-1)
                                dprint "It hands you "&it.desig &"."   
                            else
                                if rnd_range(1,100)<55 then
                                    b=getrnditem(-2,rnd_range(2,13))
                                    if b>0 then
                                        if item(b).ty<>3 then
                                            dprint "It suddenly has your "&item(b).desig &" and starts running away!"
                                            e.aggr=2
                                            item(b).w.s=0
                                            item(b).w.p=monslot
                                            reward(2)=reward(2)-item(b).v5
                                            lastlocalitem=lastlocalitem+1
                                            li(lastlocalitem)=b
                                        endif
                                    endif
                                endif
                            endif
                        else
                            dprint "It asks incredulous 'You dont enjoy to play?"
                        endif
                    
                    case else
                        dprint "It says 'You are not from around here'"
                    end select
                    
                endif
            endif
            if e.aggr=2 then 
                if rnd_range(1,100)>e.intel*9 then 
                    rndsentence(e)
                else
                    dprint "It says 'take this, and let me live!"
                    e.aggr=1
                    if rnd_range(1,100)<66 then
                        it=makeitem(94)
                    else
                        it=makeitem(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                    dprint "It hands you "&it.desig &"."   
                
                        
                endif  
            endif
        case else 
            if e.aggr=0 then dprint "It says 'You food!'"
            if e.aggr=1 then
                b=findbest(13,-1)
                if b>0 then 
                    if askyn("It says 'Got food?'. Do you want to give it a an anastaethic?") then
                        dprint "The "&e.sdesc &" eats the "& item(b).desig
                        e.sleeping=e.sleeping+item(b).v1
                        if e.sleeping>0 then dprint "And falls asleep!"
                        destroyitem(b)
                    endif
                else
                    dprint "It says 'Got food?'"
                endif
            endif
            if e.aggr=2 then dprint "It says 'Me not food!'"
        end select
    endif
    if e.lang=2 then
        if e.aggr=0 then dprint "He growls:'Get off our world warmonger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then dprint "The Citizen says: 'You are an offworlder, aren't you? You should visit Mr. Grey, he collects native art.'"
            if a=4 then dprint "The Citizen says: 'We are independent and neutral. Has served us good in the past years.' "
            if a=5 then dprint "The Citizen says: 'When we settled here we found alien ruins. In an underground vault was a cache with weapons and armor. we don't need it. We sell it.' "
            if a=6 then dprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    if e.lang=3 then 
        dprint "The Robot says 'Annihilate alien invaders!'"
    endif
    if e.lang=4 then
        if (e.aggr=0 or e.aggr=2) and rnd_range(1,100)<50 then
            dprint "Apollo thunders 'Worship me!'"
        else
            dodialog(2,e,0)
        endif
    endif
    if e.lang=5 then
        if e.aggr=0 then dprint "'Surrender or be destroyed!'"
        if e.aggr=1 then dprint "'Found any good ore deposits on this planet?'"
        if e.aggr=2 then dprint "'The company will hear about this attack!'"
    endif
    if e.lang=6 then
        if e.aggr=0 then dprint "It says: 'Die red-helmet-friend!"
        if e.aggr=1 then dodialog(6,e,0)
        if e.aggr=2 then dprint "It says: 'I surrender!" 
    endif
    if e.lang=7 then
        if e.aggr=0 then dprint "It says: 'Die blue-helmet-friend!"
        if e.aggr=1 then dodialog(7,e,0)
        if e.aggr=2 then dprint "It says: 'I surrender!"
    endif 
    if e.lang=8 then
        if e.aggr=0 or e.aggr=2 then dprint "It says: 'We haven't harmed you yet you wish to destroy us?'"
        if e.aggr=1 then dodialog(8,e,0)
    endif
    if e.lang=9 then
        if e.aggr=0 then dprint "They snarl and growl."
        if e.aggr=1 then 
            a=rnd_range(1,6)
            if a=1 then dprint "They ask if you got good booty lately."
            if a=2 then dprint "They ask if you know of any merchant routes."
            if a=3 then dprint "They ask if you know of any good bars here."
            if a=4 then dprint "They ask if you read the review of the new Plasma rifle."
            if a=5 then dprint "They ask if you know how the drinks in space stations are."
            if a=6 then dprint "'Have you already visited the base at "&map(piratebase(rnd_range(0,_NoPB))).c.x &":"&map(piratebase(rnd_range(0,_NoPB))).c.y &"?'"
        endif
        if e.aggr=2 then dprint "They yell 'We are going to get you!' as they retreat."
    endif
    if e.lang=10 then
        if e.aggr=0 then dprint "It says: 'Die alien!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It says: 'We are using the best technology that we can use'"
            if a=2 then dprint "It says: 'Have you found our space probe?'"
            if a=3 then dprint "It says: 'Has your kind solved the technological problems our species is facing?'"
            if a=4 then dprint "It says: 'Do you always have to turn around when you want to see what is behind you?'"
            if a=5 then dprint "It says: 'I think our only hope is to find exploitable resources on other planets.'"
            if a=6 then dprint "It says: 'Our leaders would be very interested in trading for advanced power sources and production methods'"
        endif        
        if e.aggr=2 then dprint "It says: 'I surrender.'"
    endif
    if e.lang=11 then
        if e.aggr=0 then dprint "It says: 'Warriors fight!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Workers work, warriors fight and scientists research. Breeders breed.'"
            if a=2 then dprint "It says: 'Does your species have warriors too?'"
            if a=3 then dprint "It says: 'Does your species have workers too?'"
            if a=4 then dprint "It says: 'Does your species have scientists too?'"
            if a=5 then dprint "It says: 'Does your species have breeders too?'"
            if a=6 then dprint "It says: 'We are working on our first faster than light ship. It is called 'feeler'"
            if a=7 then dprint "It says: 'We are looking forward to trade with your kind'"
            if a=8 then dprint "It says: 'We are looking forward to exchange knowledge with your kind'"
        endif        
        if e.aggr=2 then dprint "It says: 'We will work and fight and research for you!'"
    endif
    if e.lang=12 then
        if e.aggr=0 then dprint "It says: 'The time for negotiations is over!'"
        if e.aggr=2 then dprint "It says: 'We surrender for now.'"
        if e.aggr=1 then
            dprint "It says: 'I am a warrior. I would be interested in joining your crew to learn about your kind and other worlds'"
            if askyn("Do you want to let the insect warrior join your crew?(y/n)") then
                if max_security>0 then
                    e.hp=0
                    e.hpmax=0
                    add_member(9,0)
                else
                    dprint "You don't have enough room for the insect warrior"
                endif
            else
                dprint "It seems dissapointed but says it understands."
            endif
        endif
    endif
    if e.lang=13 then
        if e.aggr=0 then dprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then dprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Do you like our research station?'"
            if a=2 then dprint "It says: 'We do pick up signals from 3 gigantic artificial structures in space. Are they yours?'"
            if a=3 then dprint "It says: 'You should visit our main world. It's in the third orbit of this system.'"
            if a=4 then dprint "It says: 'FTL technology is still very new for our kind. We hope you come in peace and we can learn a lot from you'"
            if a=5 then dprint "It says: 'This is a research station. There are no warriors here."
            if a=6 then dprint "It says: 'Some of my colleagues thought the answer to the xixrit paradox would be that we were the first to advance this far in technology. I knew they were wrong! Ha!'"
            if a=7 then dprint "It says: 'How far away is your home planet?'"
            if a=8 then dprint "It says: 'Economics isn't my specialty but i am certain we can work out a way to trade goods & services with your species.'"
        endif
    endif
    if e.lang=14 then
        if specialflag(20)=0 then
            if e.aggr=0 then dprint "He says with a monotone voice: 'Leave now or be destroyed!'"
            if e.aggr=2 then dprint "He says with a monotone voice: 'Don't kill me!'"
            if e.aggr=1 then
                a=rnd_range(1,8)
                if a=1 then dprint "The colonist says: 'We need to buy supplies. our powerplant is broken.'"
                if a=2 then dprint "The colonist looks at you with a puzzled expression on his face. 'Have you been to the cave?'"
                if a=3 then dprint "The colonist just stares at you."
                if a=4 then dprint "The colonist just stares at you."
                if a=5 then dprint "The colonist looks as if what you just said made no sense."
                if a=6 then dprint "The colonist asks: 'Are you bringing supplies?.'"
                if a=7 then dprint "The colonist in a monotone voice: 'Unload your cargo and then leave. Everything is alright here.'"
                if a=8 then dprint "The colonist in a monotone voice: 'Everything is alright here. We don't need your help.'"
            endif
        else
            if e.aggr=0 then dprint "He screams: 'THE VOICES ARE GONE! DID YOU MAKE THE VOICES GO??'"
            if e.aggr=2 then dprint "The colonists runs away crying."
            if e.aggr=1 then
                a=rnd_range(1,7)
                if a=1 then dprint "The colonist says: 'It started slow, and when we realized what was happening it was too late'"
                if a=2 then dprint "The colonist says: 'Thank you for freeing us from this influence!'"
                if a=3 then dprint "The colonist says: 'Now we can start developing our colony again! Thank you!'."
                if a=4 then dprint "The colonist says: 'If you want to know what the crystals goals were: no idea.'"
                if a=5 then dprint "The colonist says: 'I wonder if there are other beings like that out there'."
                if a=6 then dprint "The colonist says: 'Thank you! You guys are heroes!'"
                if a=7 then dprint "The colonist says: 'A lot of hard work ahead for us now.'"
            endif
        endif
    endif
    if e.lang=15 then dprint "You hear a voice in your head: 'Subjugate or be annihilated.'"
    if e.lang=16 then
        if e.aggr=0 then dprint "The crewmember yells: 'Repell the intruders!'"
        if e.aggr=2 then dprint "The crewmember yells: 'Help! Help!'"
        if e.aggr=1 then
            if planets(mapslot).flags(0)=0 then
            if askyn("The crewmember says: 'are you willing to sell us enough fuel to return to the nearest station?' (y/n)") then
                factionadd(0,2,(rnd_range(1,4)+rnd_range(1,4))*-1)
                If player.fuel>=2*disnbase(player.c) then
                    dprint "How much do you want to charge per ton of fuel?"
                    a=getnumber(0,99,0)
                    if a>0 then
                        if rnd_range(10,50)+rnd_range(5,50)>a-awayteam.hp then
                            player.fuel=player.fuel-disnbase(player.c)
                            addmoney(cint(disnbase(player.c)*a),mt_trading)
                            dprint "You sell fuel for "&cint(disnbase(player.c)*a) &" credits."
                            planets(mapslot).flags(0)=1
                        else
                            dprint "They decide to rather take what they want by force than pay this outragous price."
                            e.aggr=0
                            e.target=awayteam.c
                        endif
                    endif
                elseif player.fuel>=disnbase(player.c) then
                    dprint "You don't have enough fuel for both yourself and the other ship."
                else
                    dprint "You don't have enough fuel yourself... that's actually quite alarming."
                endif
            else
                dprint "you have doomed us!"
            endif
            endif
            if planets(mapslot).flags(0)=1 then
                dprint "The crewmember is busy starting the ship up again. 'Thank you so much for saving our lives!'"
            endif
        endif
    endif 
    if e.lang=17 then
        if e.aggr=0 then dprint "It says: 'We may not be warriors but we do know how to defend ourselfs!'"
        if e.aggr=2 then dprint "It says: 'We are no warriors! Cease hostilities!'"
        if e.aggr=1 then
            a=rnd_range(1,7)
            if a=1 then dprint "It says: 'Warriors fight, breeders breed, sientists research.'"
            if a=2 then dprint "It says: 'We left our home 500 timeunits ago. It will take us 800 more timeunits to reach our goal.'"
            if a=3 then dprint "It says: 'We hope conditions for a colony are favourable at our destination.'"
            if a=4 then dprint "It says: '12 breeders have died since we left home.'"
            if a=5 then dprint "It says: 'I am proud to be one of the few of our species to go on this great adventure! though i will not see the end of it.'"
            if a=6 or a=7 then dprint "It says: 'The system we want to colonize is at "&map(sysfrommap(specialplanet(0))).c.x &":"&map(sysfrommap(specialplanet(0))).c.y &"'"
        endif
    endif    
    
    if e.lang=18 then
        if e.aggr=0 then dprint "He growls:'Get off our world warmonger!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'You have chosen the right time of the year to visit our colony!'"
            if a=3 then dprint "The Citizen says: 'You are an offworlder, aren't you? We don't get visitors often'"
            if a=4 then dprint "The Citizen says: 'We only settled here recently.' "
            if a=5 then dprint "The Citizen says: 'Did you bring supplies?' "
            if a=6 then dprint "The Citizen says: 'I used to do spaceship security. But that's a really dangerous job! Life is a lot safer here.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=19 then
        if e.aggr=0 then dprint "He growls:'Flee or be shredded!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It says: 'Is there a lot of water on your world?'"
            if a=2 then dprint "It says 'You have a very low number of arms, maybe we should lend you some'"
            if a=3 then dprint "It says: 'Traveling among the stars, must be exciting!'"
            if a=4 then dprint "It says: 'Our religious leaders have a creation myth. It states that we were made by gods for the purpose of exploring dangerous places for them."
            if a=5 then 
                b=findbest(103,-1)
                if b>0 then
                    if askyn("It says: 'Oh! you have a ceremonial robe? I would be interested in a trade'(y/n)") then
                        it=makeitem(94)
                        if askyn("Do you want to swap your "&item(b).desig &" for "&add_a_or_an(it.desig,0) &"?(y/n)") then
                            placeitem(it,0,0,0,0,-1)
                            dprint "Thank you very much! We don't know how to make these."
                            item(b).w.s=0
                            item(b).w.p=monslot
                        endif
                        
                    else
                        dprint "I understand. If I had one I too wouldn't want to part with it."
                    endif
                    
                else
                    dprint "It says: 'If you find any ceremonial robes, I am willing to buy them!"
                endif
            endif
            if a>5 then 
                dprint "It says: 'I can help you! I would love to travel with you! May I?'"
                if askyn("Do you want to let the cephalopod join your crew?(y/n)") then
                    if max_security>0 then
                        e.hp=0
                        e.hpmax=0
                        add_member(10,0)
                    else
                        dprint "You don't have enough room for the cephalopod"
                    endif
                else
                    dprint "It seems dissapointed but says it understands."
                endif
            endif
        endif
        if e.aggr=2 then dprint "He sobs: 'Take whatever you want! Just leave us in peace!"
    endif
    
    if e.lang=20 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if player.questflag(12)=0 or player.questflag(12)=1 then 
                dprint "We love mushrooms. The best mushrooms grow in the caves. But there is a monster there."
                player.questflag(12)=1
            endif
            if player.questflag(12)=2 then 
                dprint "'Thank you very much for killing the monster! Take this as a reward!' It hands you a huge heap of random art pieces."
                player.questflag(12)=3
                for a=0 to rnd_range(1,6)+ rnd_range(1,6)+ rnd_range(1,6)+3
                    placeitem(makeitem(93),0,0,0,0,-1)
                next
            endif
            if player.questflag(12)=3 then dprint "Thank you very much for killing the monster!"
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=21 then
        if e.aggr=0 then dprint "It howls: 'We will defeat you!"
        if e.aggr=1 then
            a=rnd_range(1,8)
            if a=1 then dprint "It says: 'Interesting! Talking bipeds! They seem to rely on other producers much like the primitve life on our world does.'"
            if a=2 then dprint "It says: 'We had a discussion about experimenting with fire, but we deemed it too dangerous.'" 
            if a=3 then 
                if askyn("It says: 'Do you want to exchange scientific knowledge?(y/n)'") then
                    dprint "These creatures seem to be incredibly smart! While they have gaps in the practical application they seem to be at least comparable to humanitys science. You find nothing you could teach them."
                else
                    dprint "it seems dissapointed"
                endif
            endif
            if a=4 then dprint "It says: 'A lot of our knowledge was never tested. It's origins are lost in the mists of time.'"
            if a=5 then dprint "It says: 'There is a legend that our kind was artificially created as pets for a species that has dissapeared.'"
            if a>=6 then 
                if askyn("It says: 'I'd love to see other worlds! I would volunteer to serve as a science officer for you.' Do you accept(y/n)") then
                    add_member(14,0)
                    e.hp=0
                    e.hpmax=0
                else
                    dprint "It seems dissapointed."
                endif
            endif
        endif
        if e.aggr=2 then dprint "It sobs: 'We don't want a war with your kind!"
    endif
    
    if e.lang=22 then
        if e.aggr=0 then dprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=2 then dprint "Ted Rofes, the shipsdoctor doesn't want to chat with you anymore"
        if e.aggr=1 then
            a=rnd_range(1,12)
            if a=1 then dprint "Ted Rofes, the shipsdoctor tells how he crashlanded on this planet."
            if a=2 then dprint "Ted Rofes, the shipsdoctor explains that the tree creatures are very smart. 'I have learned a lot on this planet.'"
            if a=3 then dprint "Ted Rofes, the shipsdoctor says 'The rest of the crew wanted to 'defend' themselves against the tree creatures. I warned them but they didn't hear.'"
            if a=4 then dprint "Ted Rofes, the shipsdoctor explains that he would be dead without the aid of the tree creatures."
            if a=5 then dprint "Ted Rofes, the shipsdoctor explains that the tree creatures seem to be connected to the ancient alien ruins somehow."
            if a=6 then dprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens are their creators.'"
            if a=7 then dprint "Ted Rofes, the shipsdoctor says 'The tree creatures assume the ancient aliens have had a very complex nerval system, with several nodes distributed about their body, making them very suspectible to telepathy.'"
            if a=8 then dprint "Ted Rofes, the shipsdoctor says 'There is a cave here that leads to an underground complex of the ancient aliens. I haven't fully explored it. When I found it an ancient robot almost killed me.'"
            if a=9 then dprint "Ted Rofes, the shipsdoctor says 'Staying here was interesting, but I would like to get back on a ship. I am a doctor, not a tourist.'"
            if a>9 then
                if askyn("Ted Rofes asks if you would let him join your crew 'you seem more reasonable than my old captain' (y/n)") then
                    add_member(15,0)
                    e.hp=0
                    e.hpmax=0
                endif        
            endif
        endif
    endif
    
    
    if e.lang=23 then
        if e.aggr=0 then dprint "He growls:'Get off our world war monger!'"
        if e.aggr=1 then
            a=rnd_range(1,9)
            if a=1 then dprint "The Citizen welcomes you to the colony"
            if a=2 then dprint "The Citizen says: 'The soil, the weather, the plants, everything on this world is perfect for growing crops! As if someone made it for that!'"
            if a=3 then dprint "The Citizen says: 'The only problem we have are the burrowers: Huge insects that hide in the soil and eat whatever comes their way.'"
            if a=4 then dprint "The Citizen says: 'Burrowers aside, this world is a paradise.' "
            if a=5 then dprint "The Citizen says: 'We have got more food than we could ever need' "
            if a=6 then dprint "The Citizen says: 'There is a bounty of 10 Cr. per dead burrower' "
            if a=7 then dprint "The Citizen says: 'Pssst... I am hunting burrowers! Its a bounty of 10 Cr. per dead burrower' "
            if a=8 then dprint "The Citizen says: 'The crops are great this year, but they are always great here.' "
            if a=9 then dprint "The Citizen says: 'If you killed a burrower you can get your bounty at the town hall.' "
        endif
        if e.aggr=2 then dprint "He sobs: 'Why did you do this? We only wanted to live in peace!"
    endif
    
    if e.lang=24 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This planet belongs to eridiani explorations.'"
            if a=5 then dprint "They say 'This planet belongs to eridiani explorations.'"
            if a=6 then dprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=25 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This is Smith Heavy Industries property.'"
            if a=5 then dprint "They say 'This planet belongs to Smith Heavy Industries.'"
            if a=6 then dprint "They say 'They look at you suspicously'"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!"
    endif
    
    
    if e.lang=26 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This Ship belongs to Triax Traders.'"
            if a=5 then dprint "They say 'You need a Triax Traders authorization.'"
            if a=6 then dprint "They say 'They look at you suspicously"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=27 then
        if e.aggr=0 then dprint "They say 'ARRRRRRRGHHHHHHHH!'"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "They say 'Can you show me some sort of ID?'"
            if a=2 then dprint "They say 'What are you doing here?'"
            if a=3 then dprint "They say 'I don't think you are supposed to be here.'"
            if a=4 then dprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=5 then dprint "They say 'This planet belongs to Omega Bionegineering.'"
            if a=6 then dprint "They look at you suspicously"
        endif
        if e.aggr=2 then dprint "They say 'I surrender!'"
    endif
    
    
    if e.lang=28 then
        if e.aggr=0 then dprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "He says in a sarcastic tone 'You sure you want to talk to a hardened criminal like me?'"
            if a=2 then dprint "He says 'We are being held here against our will'"
            if a=3 then dprint "He says 'The food is bad, the work is worse, and sometimes the guards take out their frustration on us.'"
            if a=4 then dprint "He says 'This can't be legal! Forcing us to live like this!'"
            if a=5 then dprint "He says 'I know, i made a mistake, but I don't think they can treat us like this!'."
            if a=6 then dprint "He says 'Don't owe SHI money, or you'll end up here too!'"
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    if e.lang=29 then
        if e.aggr=0 then dprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,5)
            if a=1 then dprint "He says 'The possibilites are remarkable for a scientist here.'"
            if a=2 then dprint "He says 'You wouldn't understand what we are doing here, or why'"
            if a=3 then dprint "He says 'This will change exploration and warfare forever!'"
            if a=4 then dprint "He says 'You are not an industrial spy, are you?'"
            if a=5 then dprint "He says 'Can't make an omlette without breaking a few eggs'"
            'if a=3 then dprint "He says 'The food is bad, the work is worse, and sometimes the guards take out their frustration on us.'"
            'if a=4 then dprint "He says 'This can't be legal! Forcing us to live like this!'"
            'if a=5 then dprint "He says 'I know, i made a mistake, but I don't think they can treat us like this!'."
            'if a=6 then dprint "He says 'Don't owe SHI money, or you'll end up here too!'"
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    if e.lang=30 then
        if e.aggr=0 then dprint "It signals with its feelers that it wants to eat you."
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=2 then dprint "It signals with its feelers you are the first who is trying to talk to it."
            if a=3 then dprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=4 then dprint "It signals with its feelers if you want to talk peace, you better talk to one of the mothers. It's just a warrior."
            if a=5 then dprint "It signals with its feelers that it's just a warrior, ordered to repel the invading bipeds."
            if a=6 then dprint "It signals with its feelers that it doesn't like eating bipeds, they taste funny."
        endif
        if e.aggr=2 then dprint "It signals with its feelers that it would rather go away."
    endif
        
    if e.lang=31 then
        if e.aggr=0 then dprint "It signals with its feelers that it wants to eat you."
        if e.aggr=1 then
            a=rnd_range(1,4)
            if a=1 then dprint "It signals with its feelers that it's a mother, and has ordered her children to repel the invading bipeds."
            if a=2 then dprint "It signals with its feelers you are the first who is trying to talk to it."
            if a=3 then dprint "It signals with its feelers that it's a mother, and has ordered her children to repel the invading bipeds."
            if a=4 then 
                if player.questflag(25)=0 then
                    if askyn("Do you want to try and negotiate peace between the burrowers and the settlers? (y/n)") then
                        player.questflag(25)=1
                        dprint "It signals it's terms with its feelers: No underground construction, and humans have to ask the mothers if they want to build a new farm."
                    endif
                else
                    dprint "It signals with its feelers cooperating with the bipeds is working out ok."
                endif
            endif
        endif
        if e.aggr=2 then dprint "It signals with its feelers that it would rather go away."
    endif
    
    if e.lang=32 or e.lang=33 then
        if e.lang=32 then
            c=0
            o=1
        else
            c=1
            o=0
        endif
        if e.aggr=0 then dprint "Your invasion will not be successful"
        if e.aggr=2 then dprint "Please let us live in peace!"
        civ(c).contact=1
        if e.aggr=1 then
            b=findbest(23,-1,,205)
            if b>0 and civ(c).culture(4)=2 then
                if askyn("I will pay you 10000 Cr. for the symbol of our ancient leader! Do you accept(y/n)") then
                    addmoney(10000,mt_quest)
                    item(b).w.s=0
                    item(b).w.p=monslot
                else
                    dprint "It is dissapointed."
                endif
            endif
            dprint "Do you want to talk about (t)hem, (o)ther species, (f)oreign politics or (n)othing ?(t/o/f/n)"
            t=ucase(keyin("tofnTOFN"))
            if t="N" then return 0
            if t="T" then
                if rnd_range(1,100)<66 then
                    a=rnd_range(1,6)
                    if a=1 then dprint "It says: 'We call ourselves the "&civ(c).n &"'"
                    if a=2 then 
                        if civ(c).inte=1 then dprint "It says' A new space faring species! I hope you brought many scientific secrets!"
                        if civ(c).inte=2 then 
                            if civ(c).aggr=1 then dprint "It says' A new space faring species! I wonder if you have interesting things for us to buy!"
                            if civ(c).aggr=2 then dprint "It says' A new space faring species! May we enter fruitfull trading relations soon!"
                            if civ(c).aggr=3 then dprint "It says' A new space faring species! We have many interesting things to sell! You sure will find something!"
                        endif
                        if civ(c).inte=3 then
                            if civ(c).aggr=1 then dprint "It says 'Beware! We will defend our territory!"
                            if civ(c).aggr=2 then dprint "It says 'I hope your species does not plan to interfere with our plans of expansion."
                            if civ(c).aggr=3 then dprint "It says 'Since the ancients passed on we, the "&civ(0).n &", have been dominant in this part of space.'"
                        endif
                    endif
                    if a=3 then dprint "It says 'We, the "&civ(c).n &", have invented FTL travel "&civ(c).tech*100 &" cycles ago. How long have you known the secret?"
                    if a=4 then
                        if civ(c).phil=1 then dprint "It says 'I believe strongly in the right of the individual. How about you?"
                        if civ(c).phil=2 then dprint "It says 'We, the "&civ(c).n &", strive for a balance between common good and individual freedom. How about your species?"
                        if civ(c).phil=3 then dprint "It says 'We, the "&civ(c).n &", think the foremost reason for existence is for the species to survive and prosper. How about your species?"
                    endif
                    if a=5 then 
                        if civ(c).inte=1 then dprint "It says' A new space faring species! I hope you brought many scientific secrets!"
                        if civ(c).inte=2 then 
                            if civ(c).aggr=1 then dprint "It says' A new space faring species! I wonder if you have interesting things for us to buy!"
                            if civ(c).aggr=2 then dprint "It says' A new space faring species! May we enter fruitfull trading relations soon!"
                            if civ(c).aggr=3 then dprint "It says' A new space faring species! We have many interesting things to sell! You sure will find something!"
                        endif
                        if civ(c).inte=3 then
                            if civ(c).aggr=1 then dprint "It says 'Beware! We will defend our territory!"
                            if civ(c).aggr=2 then dprint "It says 'I hope your species does not plan to interfere with our plans of expansion."
                            if civ(c).aggr=3 then dprint "It says 'Since the ancients passed on we, the "&civ(0).n &", have been dominant in this part of space.'"
                        endif
                    endif
                    if a=6 then 
                        if civ(c).aggr=1 then dprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and stable.'"
                        if civ(c).aggr=2 then dprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and stable.'"
                        if civ(c).aggr=3 then dprint "It says 'our population is "&civ(c).popu &" billion "&civ(c).n &"s and increasing.'"
                    endif
                else
                    talk_culture(c)
                endif
            endif
            if t="O" then
                a=rnd_range(1,6)
                if a=1 then
                    if civ(o).phil=civ(c).phil then 
                        dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" have a similiar outlook to us concerning life."
                    else
                        if civ(o).phil>civ(c).phil then
                            dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" don't value freedom like we do."
                        else
                            dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" aren't very well organized."
                        endif
                    endif
                endif
                if a=2 then
                    if civ(o).tech=civ(c).tech then 
                        dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" are on the same level technlogically as we are."
                    else
                        if civ(o).tech>civ(c).tech then
                            dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" know secrets we do not know yet."
                        else
                            dprint "There is another space faring civilisation in this sector. The "&civ(o).n &" are more primitive than us."
                        endif
                    endif
                endif
                if a=3 then
                    if civ(o).aggr=1 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " like to keep close to home."
                    if civ(o).aggr=2 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are interested in exploring new systems"
                    if civ(o).aggr=3 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are very expansionist"
                endif
                if a=4 then
                    if civ(o).inte=1 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are prolific merchants."
                    if civ(o).inte=2 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " very interested in science"
                    if civ(o).inte=3 then dprint "There is another space faring civilisation in this sector. The "&civ(o).n & " are very warlike"
                endif
                if a=5 then dprint "There is another space faring civilisation in this sector, the "&civ(o).n &"."
            endif
            if t="F" then
                foreignpolicy(c,1)
            endif
        endif
        if e.lang=34 then
            if e.aggr=0 or e.aggr=2 then
                dprint "It says 'You are evil, you hurt the masters'"
            else
                dprint "It says 'I like the masters, do you like the masters too?'"
            endif
            
        endif
    endif
    
    
    if e.lang=34 then
        if e.aggr=0 then dprint "ARRRRRRRGHHHHHHHH!"
        if e.aggr=1 then
            a=rnd_range(1,6)
            if a=1 then dprint "He says 'Welcome to our station!'"
            if a=2 then dprint "He says 'Feels good to stretch your legs a little, doesn't it?'"
            if a=3 then dprint "He says 'Remember to visit the bar!'"
            if a=4 then dprint "He says 'We cater to transport ships mainly. They come by here quite often'"
            if a=5 then dprint "He says 'I make some money flying in fuel from a nearby gas giant'"
            if a=6 then dprint "He says 'I hope you enjoy your stay here.'"
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    if e.lang=35 then
        if e.aggr=0 then dprint "To think that I went through all this just to have to fight this rabble."
        if e.aggr=1 then
            if rnd_range(1,100)<10 then
                dprint "Hey, I was once just like you, and now I am off to retire! Good luck out there! Here, have a few credits if you ever get into a rough spot."
                player.money+=rnd_range(10,100)
            else
                a=rnd_range(1,6)
                if a=1 then dprint "He pats your back, saying he is sure that you will make it too."
                if a=2 then dprint "He pats your back, advises you to be carefull when dealing with aliens."
                if a=3 then dprint "He pats your back, saying you should stay out of trouble."
                if a>=4 then
                    b=specialplanet(rnd_range(0,lastspecial))
                    dprint "He tells you that there is an interesting world at " &map(sysfrommap(b)).c.x &":"& map(sysfrommap(b)).c.y & "."
                endif
            endif
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    if e.lang=36 then
        if e.aggr=0 then dprint "The Scientist says: 'I am not going to deal with you, criminal!'"
        if e.aggr=1 then
            if askyn("I have some information on nearby star systems to sell. Do you want to buy it for 50 Cr.?(y/n)") then
                if paystuff(50) then
                    dprint "He hands you a data crystal"
                    for a=0 to laststar
                        if map(a).discovered=-1 then map(a).discovered=1
                    next
                endif
            endif
        endif
        if e.aggr=2 then dprint "I surrender!"
    endif
    
    if e.lang=37 then
        if e.aggr=0 then dprint "I am not going to deal with you!"
        if e.aggr=2 then dprint "I surrender!"
        if e.aggr=1 then
            if askyn("If you got problem with the megacorps, i could take a look at your record, and see what I can do. (y/n)") then
                if faction(0).war(1)+faction(0).war(3)>0 then
                    if askyn("Ok, I could do something there for "& (faction(0).war(1)+faction(0).war(3))*75 &" Cr. (y/n)") then
                        if paystuff(faction(0).war(1)+faction(0).war(3))*75 then
                            faction(0).war(1)=0
                            faction(0).war(3)=0
                            dprint "All right, they shouldn't bother you anymore."
                        endif
                    endif
                else
                    dprint "I don't think you have any problems."
                endif
            else
                dprint "Ok, feel free to see me anytime"
            endif
        endif
    endif
    
    if e.lang=38 then
        if e.aggr=0 then dprint "Drop your weapons and surrender!"
        if e.aggr=2 then dprint "Help!"
        if e.aggr=1 then 
            select case rnd_range(1,5)
            case 1
                dprint "Just protecting the station sir."
            case 2
                dprint "I hope you are enjoying a safe and secure stay."
            case 3
                dprint "If I can help you with anything let me know."
            case 4
                dprint "I can tell you, this job beats ship security hands down."
            case 5
                dprint "Make sure to visit our numerous shops!"
            end select
        end if
    end if
    
    if e.lang=39 then
        if e.aggr=0 then dprint "Drop your weapons and surrender!"
        if e.aggr=2 then dprint "Help!"
        if e.aggr=1 then 
            select case rnd_range(1,5)
            case 1
                dprint "Just protecting the company office sir."
            case 2
                dprint "I hope you are enjoying a safe and secure stay."
            case 3
                dprint "Please use our offices in an orderly manner."
            case 4
                dprint "Company security. What is your business?"
            case 5
                dprint "Company security coming through. Step aside!"
            end select
        end if
    end if
    
    
    return 0
end function

function talk_culture(c as short) as short
    dim as short a,nwh,b,d
    dim as _cords p
    dim as string t(6,6)
    d=999
    if c=0 then p=map(sysfrommap(specialplanet(7))).c
    if c=1 then p=map(sysfrommap(specialplanet(46))).c
    for a=laststar+1 to laststar+wormhole
        if distance(map(a).c,p)<d then
            nwh=a
            d=distance(map(a).c,p)
        endif
    next
    
    t(0,0)="Reproduction works remarkably similiar to your species here."
    t(0,1)="Our young are born in batches of 6 to 10. They immediately start fighting each other. Rarely more than 2 survive until adulthood."
    t(0,2)="Twin births are the norm for our species. Each parent adopts one, and contact in later life between the twins is discouraged."
    t(0,3)="The females of our species lay eggs, in common hatcheries. The children get raised by the community. Usually nobody takes a particular interest into who's kid is who's"
    t(0,4)="The males of our species are barely sentient, and have only one function. Raising children is done by the female, with help from society"
    t(0,5)="Our species has 3 sexes. Male, Female, and a sterile 'incubator'. In more primitive times their main job was to defend the young. Now they make up our military and police force."
    t(0,6)="After pregnancy our females change gender."
    
    t(1,0)="Our families and education of the young is actually pretty similiar to yours"
    t(1,1)="Our young mature very fast, and have an urge to leave their parents as soon as possible"
    t(1,2)="In our families there is always a constant power struggle. Young like to challenge the leader"
    t(1,3)="Our young need to go through a rite of passage before they are accepted among society"
    t(1,4)="Our society is based on extended families and clans. You are who you are related to"
    t(1,5)="Educating our young in as many fields as possisble is one of the main goals of our society. We pool resources to accomplish that."
    t(1,6)="We have come to the conclusion that the education of the young is too important to be left to the whims of indiviuals. Young are educated by experts, as soon as they no longer require their parents for survival."
    
    t(2,0)="Our concept of art is very similiar to yours. Maybe we could engage in trade on the matter."
    t(2,1)="We value art as a form of individual expression. There are no 'professionals' or an 'industry'"
    t(2,2)="Art is a waste of resources. Growing civilisations need it. We have outgrown that phase centuries ago."
    t(2,3)="We base the value of art on its educational value."
    t(2,4)="Our language will be rather hard for you to learn:' - the alien presents a little blue bug - 'Part of the meaning is conveyed by this animal changing it's set__color(. Its a chameleon, and trained to react to the users touches."
    t(2,5)="We are most impressed with feats of the body. Our most import areas of art are sport, dance, and general acrobatics. We get very little out of a film, picture or books other than for education"
    t(2,6)="The value of Art is its contribution to the survival of the species. It can do so by reminding individuals that they are nothing without the group."
    
    t(3,0)="Some of us follow a monotheistic religion. Most of us think its just ancient superstition"
    t(3,1)="There are many religions among us. Most are a form of ancestor worship. But it is all superstition, and  tradition."
    t(3,2)="Our species worshipped the ancient civilisation that once lived here. Imagine our shock, when we started to explore the stars and found out that god is real!"
    t(3,3)="This concept of God is foreign to us. We believe in a force, that inhabits all living things. It gets released upon death. Sentient beings can control this force. They can also hinder it in having unwanted effects on society."
    t(3,4)="We have discovered that our species has a genetic flaw, which can cause a sudden failure of the circulatory system. We now have the technology to repair it, but earlier this sudden dropping dead was the main focus of our religious practices. It was held that god considers your job complete, and takes you back."
    t(3,5)="On our homeworld there was an ancient robot factory. Most religious rituals have evolved around it."
    t(3,6)="Our species evolved from a primitive form that migrated between two different habitats. Our religions are mainly about 'finding ones way', propably for that reason. Many of us still have 2 houses, in different parts of the planet, and live in each for half a year. Poor people try to do it too, by swapping homes."
    
    t(4,0)="Much like you we try only to interfere with free markets if they fail at allocating goods efficiently"
    t(4,1)="You could call our economic system industrial feudalism: The power of individuals is measured in their wealth. There is no authority regulating them."
    t(4,2)="There is a legend about a leader of our people. He perished 2000 years ago, taking the symbol of his power with him."
    t(4,3)="We had a very agressive colonisation phase in our past. Some laws still survive from that day, concerning the conquest of undiscovered land. It has led to many of us trying to make independent expeditions to the stars. Discovering a planet means you own it."
    t(4,4)="There is a semi intelligent species on our world. We feed and clothe them, in exchange for their labor."
    t(4,5)="The thing we are most proud of, you will have noticed upon landing: we have built a space lift. A space station in geostationary orbit, connected by a tether to the ground. It was constructed during the beginning of our exploration of our system, and is still useful."
    t(4,6)="Central government decides, and distributes goods according to their needs."
   
    t(5,0)="The most usual ways to dispose of our dead is to bury them. Incineration is also popular."
    t(5,1)="They say 'the sun made us, the sun will take us away' thats why we used to burn our dead. These days we shoot them into the sun."
    t(5,2)="Our tradition is to eat those that have died. Usually only the closest family gets a piece though."
    t(5,3)="The dead are mummified, and put into the walls of the house to watch over the living."
    t(5,4)="All of us have a plant symbiote or parasite. We could remove it, but it has several beneficial effects. Natural death triggers its growth into a treelike plant. It uses the body of the dead as first nourishment. Family members usually nurture it. It is only displaced when the death occured at a very inconvenient spot. Most citizens try to avoid that."
    t(5,5)="Our dead are returned to the circle of life: there is a special profession who cuts them into tiny pieces and feeds them to scavenging animals."
    t(5,6)="We used to set our dead adrift at sea, later we used space. Since the discovery of the wormhole at " &map(nwh).c.x &":"&map(nwh).c.y &" that is where their last journey starts."
    
    t(6,0)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(3))).c.x &":"& map(sysfrommap(specialplanet(3))).c.y &". No ship that has landed there has so far returned"
    t(6,1)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(3))).c.x &":"& map(sysfrommap(specialplanet(3))).c.y &". No ship that has landed there has so far returned"
    t(6,2)="We have found a friendly race of highly intelligent centipedes at "& map(sysfrommap(specialplanet(16))).c.x &":"& map(sysfrommap(specialplanet(16))).c.y &"."
    t(6,3)="We have found a living planet at "& map(sysfrommap(specialplanet(27))).c.x &":"& map(sysfrommap(specialplanet(27))).c.y &" It is very dangerous, especially if you land there."
    t(6,4)="We have discovered a wormhole at " &map(nwh).c.x &":"&map(nwh).c.y &"."
    t(6,5)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(2))).c.x &":"& map(sysfrommap(specialplanet(2))).c.y &". No ship that has landed there has so far returned"
    t(6,6)="Our expeditions have found a city of the ancients at "& map(sysfrommap(specialplanet(4))).c.x &":"& map(sysfrommap(specialplanet(4))).c.y &". No ship that has landed there has so far returned"
    a=rnd_range(1,6)
    dprint t(a,civ(c).culture(a))
    return 0
end function


function foreignpolicy(c as short, i as byte) as short
    dim as byte o,l,a,b,f,ad,roll,art
    dim t as string
    t="Who/Merchants/Pirates"
    if c=0 then
        o=1
    else
        o=0
    endif
    if i=0 then
        if civ(c).phil=1 then ad=5
        if civ(c).phil=2 then ad=3
        if civ(c).phil=3 then ad=1
    else
        if civ(c).phil=1 then ad=1
        if civ(c).phil=2 then ad=3
        if civ(c).phil=3 then ad=5
    endif
    if civ(o).contact=1 then 
        t=t &"/" & civ(o).n    
        l=4
    else
        l=3
    endif
    if findbest(23,-1,,205)>0 and civ(c).culture(4)=2 then 
        art=1
        ad=ad+6/civ(c).phil
    endif
    t=t & "/Exit"
    a=menu(bg_parent,t)
    if a<l then
        b=menu(bg_parent,"What/Status/Declare war/Initiate peace talks/Exit")
        if a=1 then f=1
        if a=2 then f=2
        if a=3 then f=6+o
        if art>0 then dprint "The "&civ(c).n &" are obviously impressed by you bearing their artifact."
        roll=rnd_range(1,6)+ rnd_range(1,6)+civ(o).contact+ad
        if b=1 then
            select case faction(c+6).war(f)>=90 
            case is >90
                dprint "We are currently at war with them"
            case 50 to 90
                dprint "There are serious tensions with them"
            case else
                dprint "There are no problems between us and them"
            end select
        endif
        if b=2 then
            dprint "You try to convince the "&civ(c).n &" to declare war"
            if faction(c+6).war(f)>50 then roll=roll+1
            if roll>9 then 
                factionadd(c+6,f,5)
                dprint "They seem to consider your arguments"
            endif
            if roll<4 then
                factionadd(c+6,0,3)
                dprint "They dont think that you are in a position to tell them that."
            endif
            if roll>=4 and roll<=9 then dprint "Your argument falls on deaf ears"
        endif
        if b=3 then
            dprint "You try to convince the "&civ(c).n &" to initiate peace talks"
            if faction(c+6).war(f)<30 then roll=roll-1
            if roll>9 then 
                factionadd(c+6,f,-5)
                dprint "They seem to consider your arguments"
            endif
            if roll<4 then
                factionadd(c+6,0,3)
                dprint "They dont think that you are in a position to tell them that."
            endif
            if roll>=4 and roll<=9 then dprint "Your argument falls on deaf ears"
        endif
            
    endif
    return 0
end function

function eris_does() as short
    dim as short roll,roll2,a,noa,b
    dim en as _fleet
    dim weap as _weap
    dim awayteam as _monster
    if rnd_range(1,100)<33 then
        if planets(specialplanet(1)).visited<>0 then
            if askyn("Eris asks: 'Do you know where apollo is?' Do you want to tell her (y/n)") then
                for a=3 to lastfleet
                    if fleet(a).ty=10 then
                        fleet(a).t=4068
                        b=sysfrommap(specialplanet(1))
                        targetlist(4068).x=map(b).c.x
                        targetlist(4068).y=map(b).c.y
                    endif
                next
                return 0
            endif
            roll=rnd_range(1,66)
            select case roll
                case roll<=33
                    dprint "Eris decides to punish you for your insolence"
                case roll>=66 
                    dprint "Eris decides to show you how she could reward you for the information"
                case else
                    dprint "Eris doesn't seem to care"
            end select
            
        else
            roll=rnd_range(1,100)
        endif
        select case roll
        case roll<=33 'Eris does bad stuff
            select case rnd_range(1,100)
                case 0 to 10
                    select case rnd_range(1,100)
                    case 0 to 33
                        dprint "Eris looks at your engine",15
                        if player.engine>1 then player.engine-=1
                    case 34 to 66
                        dprint "Eris looks at your sensors",15
                        if player.engine>0 then player.sensors-=1
                    case else
                        dprint "Eris looks at your shields",15
                        if player.shieldmax>0 then player.shieldmax-=1
                    end select
                case 11 to 20
                    dprint "Eris examines your hull",15
                    if player.hull>0 then player.hull-=1
                    player.h_maxhull-=1
                case 21 to 30
                    a=rnd_crewmember
                    for b=1 to 12
                        crew(a).augment(b)=0
                    next
                    dprint  "Eris looks at "&crew(a).n &" 'Oh you are ugly!'",15
                case 31 to 40
                    roll2=rnd_range(1,6)
                    dprint "Eris yells 'Fight for my amusement'",15
                    no_key=keyin
                    noa=1
                    if roll2=4 then noa=rnd_range(1,6) +rnd_range(1,6)
                    if roll2=5 then noa=rnd_range(1,3)
                    if roll2=6 then noa=rnd_range(1,2)
                    for a=1 to noa
                        en.ty=9
                        en.mem(a)=make_ship(23+roll)
                    next
                    spacecombat(en,rnd_range(1,11))
                case 41 to 50
                    dprint "Eris shows you that you have a fuel leak",15
                    player.fuel-=rnd_range(1,100)
                    if player.fuel<15 then player.fuel=15
                case 51 to 60
                    dprint "Eris informs you that it is not nice to point guns at people",15
                    player.weapons(1)=weap
                case 61 to 70
                    dprint "Eris asks 'Have you got some change?",15
                    player.money-=rnd_range(10,1000)
                    if player.money<0 then player.money=0
                case 71 to 80
                    dprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x>1 then player.cargo(a).x=1
                    next
                case 81 to 90
                    dprint "Eris thinks your ship is too big",15
                    upgradehull(rnd_range(1,4),player,1)
                case 91 to 95
                    dprint "Eris says 'You are buff!",15
                    a=rnd_crewmember
                    crew(a).hp-=1
                    crew(a).hpmax-=1
                case else
                    dprint "Eris curses your ship!",15
                    player.cursed=1
            end select
        case roll>=66 'Eris does good stuff
            select case rnd_range(1,100)
                case 0 to 10
                    select case rnd_range(1,100)
                    case 0 to 33
                        dprint "Eris looks at your engine",15
                        if player.engine<6 then player.engine+=1
                    case 34 to 66
                        dprint "Eris looks at your sensors",15
                        if player.engine<6 then player.sensors+=1
                    case else
                        dprint "Eris looks at your shields",15
                        if player.shieldmax<6 then player.shieldmax+=1
                    end select
                case 11 to 20
                    dprint "Eris examines your hull",15
                    player.hull+=5
                    player.h_maxhull+=5
                case 21 to 30
                    dprint "Eris takes a look at your cargo hold",15
                    player.h_maxcargo+=1
                    player.cargo(player.h_maxcargo).x=1
                case 31 to 40
                    a=rnd_crewmember
                    dprint "Eris looks at "&crew(a).n &" 'my, my are you fragile!",15
                    crew(a).hp+=1
                    crew(a).hpmax+=1
                case 41 to 50
                    dprint "Eris looks at "&crew(a).n &" and starts laughing",15
                    a=rnd_crewmember
                    dprint gaintalent(a)
                case 51 to 60
                    dprint "Eris looks at "&crew(a).n &" and starts laughing",15
                    a=rnd_crewmember
                    dprint gainxp(a),c_gre
                case 61 to 70
                    dprint "Eris says 'Are you sure you have enough fuel to get home?",15
                    player.fuel+=200
                case 71 to 80
                    dprint "I found this, can you use it?",15
                    findartifact(0)
                case 81 to 90
                    dprint "Eris is worried that you might need money",15
                    player.money+=rnd_range(1,1000)
                case 91 to 95
                    dprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x=1 then player.cargo(a).x=rnd_range(2,6)
                    next
                case else
                    dprint "Eris declares all curses lifted!",15
                    player.cursed=0
            end select
        case else 'Just does stuff
            select case rnd_range(1,100)
                case 0 to 10
                    dprint "Eris says: 'I don't want to deal with you right now, why don't you just go over there?",15
                    select case rnd_range(1,100)
                    case 0 to 66
                        player.c=movepoint(player.c,5)
                    case 67 to 90
                        player.c=map(rnd_range(1,wormhole+laststar)).c
                    case else
                        player.c.x=rnd_range(0,sm_x)
                        player.c.y=rnd_range(0,sm_y)
                    end select
                case 11 to 20
                    dprint "Eris says: 'You have very interesting diplomatic relations.",15
                    faction(0).war(rnd_range(1,5))+=10-rnd_range(1,20)
                case 21 to 30
                    dprint "Eris asks: 'Where is Apollo?",15
                case 31 to 40
                    dprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x>1 then player.cargo(a).x=rnd_range(1,5)
                    next
                case 41 to 50
                    dprint "Is that your space station, there?",15
                    basis(rnd_range(0,2)).c.x=rnd_range(0,sm_x)
                    basis(rnd_range(0,2)).c.y=rnd_range(0,sm_y)
                case 51 to 60
                    dprint "Eris screws around with time",15
                    player.turn=player.turn+5-rnd_range(1,10)
                case 61 to 70
                    dprint "Eris snaps with her fingers",15
                    drifting(rnd_range(1,lastdrifting)).x=player.c.x
                    drifting(rnd_range(1,lastdrifting)).y=player.c.y
                case 71 to 80
                    dprint "Eris seems bored",15
                case 81 to 90
                    dprint "Eris is looking at the stars",15
                    map(rnd_range(0,laststar)).c=rnd_point
                    map(rnd_range(0,laststar)).c=rnd_point
                case 91 to 100
                    eris_doesnt_like_your_ship
            end select
        end select
    else
        dprint "Eris doesn't seem to be interested in you.",15
        if rnd_range(1,100)<66 then
            select case rnd_range(1,100)
            case 0 to 66
                player.c=movepoint(player.c,5)
            case 67 to 90
                player.c=map(rnd_range(1,wormhole+laststar)).c
            case else
                player.c.x=rnd_range(0,sm_x)
                player.c.y=rnd_range(0,sm_y)
            end select
        endif
    endif
    return 0
end function

function eris_doesnt_like_your_ship() as short
    dim as short tier,roll,tierchance(4),newtier,n,a
    tier=cint(player.h_no/4)
    for a=1 to 4
        tierchance(a)=90-(a-tier)^2*15
        if tierchance(a)<0 then tierchance(a)=0
        tierchance(0)+=tierchance(a)
    next
    roll=rnd_range(0,tierchance(0))
    select case roll
    case 0 to tierchance(1)
        newtier=0
    case tierchance(1)+1 to tierchance(2)
        newtier=1
    case tierchance(2)+1 to tierchance(3)
        newtier=2
    case tierchance(3)+1 to tierchance(4)
        newtier=3
    case else
        dprint "Eris likes your ship"
        return 0
    end select
    n=rnd_range(1,4)+newtier*4
    if n=player.h_no then
        dprint "Eris likes your ship"
    else
        dprint "Eris doesn't like your ship"
        upgradehull(n,player,1)
    endif
    return 0
end function

function eris_finds_apollo() as short
    dim as short x,y,a
    
    if planetmap(0,0,specialplanet(1))=0 then makeplanetmap(specialplanet(1),3,3)
    specialflag(1)=1
    for x=0 to 60
        for y=0 to 20
            if abs(planetmap(x,y,specialplanet(1)))=56 then planetmap(x,y,specialplanet(1))=57
        next
    next
    planets_flavortext(specialplanet(1))=""

    for a=3 to lastfleet
        if fleet(a).ty=10 then 
            fleet(a)=fleet(lastfleet)
            lastfleet-=1
        endif
    next
    return 0
end function


function giveitem(e as _monster,nr as short, li() as short, byref lastlocalitem as short) as short
    dim as short a
    dim it as _items
    dprint "What do you want to offer the "&e.sdesc &"."
    a=get_item()
    if a>0 then
     if (e.lang=6 or e.lang=7) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
         item(a).w.p=nr
         item(a).w.s=0
         it=makeitem(96,-1,-3)
         placeitem(it,0,0,0,0,-1)
         reward(2)=reward(2)+it.v5
         dprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
         return 0
     endif
     if e.allied>0 and item(a).price>10 then
        dprint "The "&e.sdesc &" accepts the gift."
        factionadd(0,e.allied,-5)
        lastlocalitem=lastlocalitem+1
        item(a).w.p=nr
        item(a).w.s=0
        li(lastlocalitem)=a
    endif
         
    if e.lang=4 then
        if item(a).price>1000 then       
            item(a).w.p=nr
            item(a).w.s=0     
            lastlocalitem+=1
            li(lastlocalitem)=a
            dprint "Apollo accepts your tribute"
            e.aggr=1
        else
            dprint "'You can't soothe me with such worthless trinkets!'"
        endif
    endif
     
    if (e.lang=28) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
        lastlocalitem=lastlocalitem+1
        item(a).w.p=nr
        item(a).w.s=0
        li(lastlocalitem)=a     
        dprint "The worker hides the "&item(a).desig &"quickly saying 'Thank you, now if i only had a way to get off this rock'" 
        if rnd_range(1,6)<3 then e.faction=2
        return 0
    endif
     
     
     select case e.intel
        case is>6
            if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" accepts the gift."
                e.cmmod=e.cmmod+2
                if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then e.aggr=1
                lastlocalitem=lastlocalitem+1
                item(a).w.p=nr
                item(a).w.s=0
                li(lastlocalitem)=a
                if e.aggr=1 and rnd_range(1,6) +rnd_range(1,6)<e.intel then
                    dprint "The "&e.sdesc &" gives you something in return."
                    if rnd_range(1,100)<66 then
                        it=makeitem(94)
                    else
                        it=makeitem(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                endif
            else
               dprint "The "&e.sdesc &" doesnt want the "& item(a).desig
            endif
        case else
            if item(a).ty=13 and rnd_range(1,6) +rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" eats the "& item(a).desig
                e.sleeping=e.sleeping+item(a).v1
                if e.sleeping>0 then dprint "And falls asleep!"
                item(a)=item(lastitem)
                lastitem=lastitem-1
            else
                dprint "The "&e.sdesc &" doesnt want the "& item(a).desig
            endif
        end select
    endif
        
    return 0
end function


  
function rndsentence(e as _monster) as short
    dim as short aggr,intel
    dim s as string
    dim r as short
    aggr=e.aggr
    intel=e.intel
    if aggr=0 then
    r=rnd_range(1,8)
        if r=1 then dprint "It says: 'Die monster from another world!'"
        if r=2 then dprint "It says: 'You look tasty!'"
        if r=3 then dprint "It says: 'The metal gods of old demand your death!'"
        if r=4 then dprint "It says: 'Intruder! Flee or be destroyed'"
        if r=5 then dprint "It says: 'Your magic is powerfull but my arms are strong!'"
        if r=6 then dprint "It says: 'The time for talking is over!'"
        if r=7 then dprint "It says: 'I am going to kill you!'"
        if r=8 then dprint "It says: 'Resistance is useless!'"
    endif
    if aggr=1 then
    r=rnd_range(1,11)
        if r=1 then dodialog(902,e,0)
        if r=2 then dprint "It says: 'You are not from around, are you?'"
        if r=3 then dprint "It says: 'Do you have a gift for me?'"
        if r=4 then dprint "It says: 'I always wondered if there were other beings out there.'"
        if r=5 then dprint "It says: 'You can't be from another world! Faster than light travel is impossible!'"
        if r=6 then dprint "It says: 'I haven't seen a creature like you before!'"
        if r=7 then dprint "It says: 'Are you here for the festival?'"
        if r=8 then dprint "It says: 'You can have my food if you want.'"
        if r=9 then dprint "It says: 'I always wondered if there were other beings like us up there.'"
        if r=10 then 
            if askyn("It says: 'I pay you 5000 zrongs if you tell me all your technological secrets.' Do you agree? (y/n)") then
                placeitem(makeitem(88),0,0,0,0,-1)
                s="it hands you a bag of local currency while you"
                if skill_test(player.science(location),st_hard-e.intel,"Science:") then
                    r=rnd_range(1,6)
                    if r=1 then s=s &" teach it some basic newtonian physics."
                    if r=2 then s=s &" teach it some basic chemistry."
                    if r=3 then s=s &" teach it some basic biology."
                    if r=4 then s=s &" teach it some basic astronomy."
                    if r=5 then s=s &" teach it some how to make fire."
                    if r=6 then s=s &" teach it some how to make wheels."
                else 
                    s=s &" fail to teach it anything because you just can't find the terms it would understand."
                endif
                dprint s
            endif
        endif
        if r=11 then dodialog(901,e,0)
    endif
    if aggr=2 then
    r=rnd_range(1,7)
        if r=1 then dprint "It says: 'Help! Help! It's an alien invasion!'"
        if r=2 then dprint "It says: 'Don't kill me!'"
        if r=3 then dprint "It says: 'Don't point those things at me!'"
        if r=4 then dprint "It says: 'Don't eat me!'"
        if r=5 then dprint "It says: 'I surrender!'"
        if r=6 then dprint "It says: 'Have mercy!'"
        if r=7 then dprint "It says: 'Gods! Save me from the evil aliens!'"
    endif
    return 0
end function

function getunusedplanet() as short
    dim as short a,b,c,potential
    for a=0 to laststar
        for b=1 to 9
            potential=map(a).planets(b)
            if potential>0 then
                if planetmap(0,0,potential)=0 then
                    for c=0 to lastspecial
                        if potential=specialplanet(c) then potential=0
                    next
                    if potential>0 then return potential
                endif
            else
            endif
        next
    next
    return -1
end function

function give_quest(st as short) as short
    dim as short a,b,bay, s,pl,car,st2,m,o,m2,o2,x,y
    dim as _cords p
    static stqroll as short
    if st<>player.lastvisit.s then stqroll=rnd_range(0,2)
    do
        st2=rnd_range(0,2)
    loop until st2<>st
    a=stqroll
    if questroll>8 then
        'standard quest by office
        if basis(st).company=1 then
            do
                m=rnd_range(0,laststar)
                o=rnd_range(1,9)
            loop until map(m).planets(o)>0
            if player.questflag(7)=0 then
                if askyn("The company rep offers you a contract to deliver complete maps of a newly discovered planet in orbit " & o &" around a star at "&map(m).c.x &":" &map(m).c.y &". They will pay 1000 cr. Do you accept?(y/n)") then
                    m=map(m).planets(o)
                    player.questflag(7)=m 
                    questroll=999'save m in .... a quest?
                endif
            else
                for m=0 to laststar
                    for o=1 to 9
                        if map(m).planets(o)=player.questflag(7) then 
                            m2=m
                            o2=o
                        endif
                    next
                next
                dprint "The company rep reminds you that you still have a contract open to map a planet at "&map(m2).c.x &":" &map(m2).c.y &" orbit " & o2 &"."
            endif
        endif
        
        if basis(st).company=2 then
            if player.questflag(9)=0 then
                if askyn("The rep says:'We have learned that there are still working robot factories found on some planets on this sector. We would like to send a team of scientists to one of these. Would you be willing to find a suitable target for 5000 credits?('(y/n)") then 
                    player.questflag(9)=1
                    questroll=999
                endif
            else
                dprint "The company rep reminds you that you have yet to locate a factory of the ancients"
            endif    
        endif
        
        if basis(st).company=3 then
            car=rnd_range(3,4)
            dprint "The company rep offers you a contract to deliver "&car &" tons of cargo to station " &st2+1 &"."
            if askyn(" They will pay 200 cr per ton. Do you accept?(y/n)") then
                if getnextfreebay<0 then 
                    dprint "You have no room.",c_red
                    return questroll
                endif
                load_quest_cargo(12,car,st2)
                questroll=999
            endif
        endif
        
        if basis(st).company=4 then
            if player.questflag(10)=0 then
                m=rnd_range(2,16)
                if askyn("Omega Bioengineering's scientists want to conduct an experiment. They need a planet with "&add_a_or_an(atmdes(m),0) &" atmosphere, and without plant life for that. They are willing to pay 2500 credits for the position of a possible candidate. Do you want to help in the search (y/n)?") then 
                    player.questflag(10)=m
                    questroll=999
                endif
            else 
                dprint "The company rep reminds you that you have yet to find a planet with "&add_a_or_an(atmdes(player.questflag(10)),0)&" atmosphere without life."
            endif
        endif
    else
        'other quests
        a=rnd_range(0,2)
        if a<>st and player.h_maxcargo>0 then
            'Deliver package
            if rnd_range(1,100)<50 or player.questflag(8)<>0 then
                if askyn("The company rep needs some cargo delivered to station "&a+1 &". He is willing to pay 200 credits. Do you accept? (y/n)" ) then
                    bay=getnextfreebay
                    if bay<=0 then 
                        if askyn("Do you want to make room for the cargo (losing "& goodsname(player.cargo(1).x-1) &")?(y/n)") then bay=1
                    endif
                    if bay>0 then
                        player.cargo(bay).x=12 'type=specialcargo
                        player.cargo(bay).y=a 'Destination
                    endif
                endif
            else
                b=rnd_range(1,16)
                if askyn("The company rep needs "&add_a_or_an(shiptypes(b),0) &" hull towed to station "&a+1 &" for refits. He is willing to pay "& b*50 &" Cr. Do you accept(y/n)?") then
                    if player.tractor=0 then
                        dprint "You need a tractor beam for this job.",14
                    else
                        player.towed=-b
                        player.questflag(8)=a
                    endif
                endif
            endif
        else
            
            if st<>player.lastvisit.s then stqroll=rnd_range(1,10)
            a=stqroll
            
            if a=1 and player.questflag(2)=0 then
                dprint "The company rep informs you that one of the local executives has been abducted by pirates. They demand ransom, but it is company policy to not give in to such demands. There is a bounty of 10.000 CR on the pirates, and a bonus of 5000 CR to bring back the exec alive.",15
                no_key=keyin
                player.questflag(2)=1
                s=get_random_system
                if s=-1 then s=rnd_range(0,laststar)
                pl=getrandomplanet(s)
                if pl<0 then pl=rnd_range(1,9)
                makeplanetmap(pl,3,map(s).spec)
                for a=1 to rnd_range(1,3)
                    planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-65
                next
                planetmap(rnd_range(0,60),rnd_range(0,20),pl)=-66
            endif
            
            if a=2 and player.questflag(5)=0 then
                dprint "The company rep warns you about a ship that has reportedly been preying on pirates and merchants alike. 'It's fast, it's dangerous, and a confirmed kill is worth 15.000 credits to my company.",15
                player.questflag(5)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=make_ship(11)
                fleet(lastfleet).flag=5
                fleet(lastfleet).c.x=rnd_range(0,sm_x)            
                fleet(lastfleet).c.y=rnd_range(0,sm_y)            
            endif
            
            if a=3 and player.questflag(5)=2 then
                dprint "The company rep warns you that there are reports about another ship prowling space of the type you destroyed before. The company again pays 15.000 Credits if you bring it down",15
                player.questflag(6)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=make_ship(11)
                fleet(lastfleet).mem(2)=make_ship(11)
                fleet(lastfleet).mem(3)=make_ship(11)
                fleet(lastfleet).flag=6
                fleet(lastfleet).c.x=rnd_range(0,sm_x)     
                fleet(lastfleet).c.y=rnd_range(0,sm_y)     
            endif
            
            if a=4 and player.questflag(11)=0 and lastdrifting<128 then
                player.questflag(11)=1
                x=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.x
                y=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.y
                if x<0 then x=0
                if y<0 then y=0
                if x>sm_x then x=sm_x
                if y>sm_y then y=sm_y
                dprint "The company rep tells you about a battleship that has gone missing. It's last known position was " & x &":" &y & ". There is a 5000 Credit reward for finding out what happened to it.",15
                lastdrifting=lastdrifting+1
                m=lastdrifting
                drifting(m).s=14
                drifting(m).x=x
                drifting(m).y=y
                drifting(m).m=lastplanet+1
                lastplanet=lastplanet+1
                load_map(14,lastplanet)
                make_drifter(drifting(m))
                p=rnd_point(lastplanet,0)
                planetmap(p.x,p.y,lastplanet)=-226
                player.questflag(11)=1
                m=lastplanet
                planets(m).darkness=0
                planets(m).depth=1
                planets(m).atmos=6
        
                planets(m).mon_template(0)=makemonster(29,m)
                planets(m).mon_noamin(0)=10
                planets(m).mon_noamax(0)=20
                planets_flavortext(m)="No hum from the engines is heard as you enter the Battleship. Emergency lighting bathes the corridors in red light, and the air smells stale."
            endif
            
            if a>=5 and a<=10 then give_bountyquest(0)
            
            if a=10 and player.questflag(26)=0 then
                s=get_random_system
                pl=getrandomplanet(s)
                if pl>0 then
                    dprint "We haven't heard in a while from a ship that last reported from " & map(s).c.x &":"&map(s).c.y & ". We offer you 500 Cr. if you can find out what hapened to them."
                    player.questflag(26)=pl
                    placeitem(Makeitem(81,1),rnd_range(0,60),rnd_range(0,20),pl)
                endif
            endif
            questroll=999
        endif
    endif
return questroll
end function

function find_passage_quest(m as short, start as _cords, goal as _cords) as short
    if find_passage(m,start,goal)>0 then
        dprint "Thank you for finding the passage. Here is your reward."
    else
    
    endif
    return 0
end function

function headhunt_quest(i as short) as short
    dim as string questtxt
    dim as _fleet f
    select case i
    case 1
    end select
    return 0
end function

function Find_Passage(m as short, start as _cords, goal as _cords) as short
    dim p(61*21) as _cords
    dim map(60,20) as short
    dim as short i,j,l,x,y,r
    for x=0 to 60
        for y=0 to 20
            if planetmap(x,y,m)>0 then
                if tiles(planetmap(x,y,m)).walktru>0 then map(x,y)=255 
            else
                map(x,y)=255
            endif
        next
    next
    l=a_star(p(),start,goal,map(),60,20,1)
    r=-1
    for i=0 to i
        if planetmap(p(i).x,p(i).y,m)<0 then 
            r=0
        else
            if tiles(planetmap(p(i).x,p(i).y,m)).walktru<>0 then r=0
        endif
    next
    if r=-1 then r=i
    return r
end function

function planet_bounty() as short
    dim p as _cords
    
    if planets(specialplanet(2)).visited>0 and planets(specialplanet(2)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            addmoney(2500,mt_quest2)
            planets(specialplanet(2)).flags(21)=1
            planets(specialplanet(2)).mon_template(8)=makemonster(7,specialplanet(2))
            planets(specialplanet(2)).mon_noamin(8)=10
            planets(specialplanet(2)).mon_noamax(8)=15
            p=rnd_point(specialplanet(2),0)
            planetmap(p.x,p.y,specialplanet(2))=-67
        endif
    endif
    
    if planets(specialplanet(3)).visited>0 and planets(specialplanet(3)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            addmoney(2500,mt_quest2)
            planets(specialplanet(3)).flags(21)=1
            planets(specialplanet(3)).mon_template(8)=makemonster(7,specialplanet(3))
            planets(specialplanet(3)).mon_noamin(8)=10
            planets(specialplanet(3)).mon_noamax(8)=15
            p=rnd_point(specialplanet(3),0)
            planetmap(p.x,p.y,specialplanet(3))=-67
        endif
    endif
    
    if planets(specialplanet(4)).visited>0 and planets(specialplanet(4)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            addmoney(2500,mt_quest2)
            planets(specialplanet(4)).flags(21)=1
            planets(specialplanet(4)).mon_template(8)=makemonster(7,specialplanet(4))
            planets(specialplanet(4)).mon_noamin(8)=10
            planets(specialplanet(4)).mon_noamax(8)=15
            p=rnd_point(specialplanet(4),0)
            planetmap(p.x,p.y,specialplanet(4))=-67
        endif
    endif
    
    if planets(specialplanet(16)).visited>0 and planets(specialplanet(16)).flags(21)=0 then
        if askyn("He's interested in the position of Eden. Do you want to sell the coordinates for 10000 Cr?(y/n)") then
            addmoney(10000,mt_quest2)
            planets(specialplanet(16)).flags(21)=1
            planets(specialplanet(16)).mon_template(8)=makemonster(7,specialplanet(16))
            planets(specialplanet(16)).mon_noamin(8)=10
            planets(specialplanet(16)).mon_noamax(8)=15
            p=rnd_point(specialplanet(16),0)
            planetmap(p.x,p.y,specialplanet(16))=-67
        endif
    endif
    
    if planets(specialplanet(21)).visited>0 and planets(specialplanet(21)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            addmoney(1000,mt_quest2)
            planets(specialplanet(21)).flags(21)=1
            planets(specialplanet(21)).mon_template(8)=makemonster(7,specialplanet(21))
            planets(specialplanet(21)).mon_noamin(8)=10
            planets(specialplanet(21)).mon_noamax(8)=15
            p=rnd_point(specialplanet(21),0)
            planetmap(p.x,p.y,specialplanet(21))=-67
        endif
    endif
    
    if planets(specialplanet(22)).visited>0 and planets(specialplanet(22)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            addmoney(1000,mt_quest2)
            planets(specialplanet(22)).flags(21)=1
            planets(specialplanet(22)).mon_template(8)=makemonster(7,specialplanet(22))
            planets(specialplanet(22)).mon_noamin(8)=10
            planets(specialplanet(22)).mon_noamax(8)=15
            p=rnd_point(specialplanet(22),0)
            planetmap(p.x,p.y,specialplanet(22))=-67
        endif
    endif
    
    if planets(specialplanet(23)).visited>0 and planets(specialplanet(23)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            addmoney(1000,mt_quest2)
            planets(specialplanet(23)).flags(21)=1
            planets(specialplanet(23)).mon_template(8)=makemonster(7,specialplanet(23))
            planets(specialplanet(23)).mon_noamin(8)=10
            planets(specialplanet(23)).mon_noamax(8)=15
            p=rnd_point(specialplanet(23),0)
            planetmap(p.x,p.y,specialplanet(23))=-67
        endif
    endif
    
    if planets(specialplanet(24)).visited>0 and planets(specialplanet(24)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            addmoney(1000,mt_quest2)
            planets(specialplanet(24)).flags(21)=1
            planets(specialplanet(24)).mon_template(8)=makemonster(7,specialplanet(24))
            planets(specialplanet(24)).mon_noamin(8)=10
            planets(specialplanet(24)).mon_noamax(8)=15
            p=rnd_point(specialplanet(24),0)
            planetmap(p.x,p.y,specialplanet(24))=-67
        endif
    endif
    
    if planets(specialplanet(25)).visited>0 and planets(specialplanet(25)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient refueling platform you found. Do you want to sell the coordinates for 1000 Cr?(y/n)") then
            addmoney(1000,mt_quest2)
            planets(specialplanet(25)).flags(21)=1
            planets(specialplanet(25)).mon_template(8)=makemonster(7,specialplanet(25))
            planets(specialplanet(25)).mon_noamin(8)=10
            planets(specialplanet(25)).mon_noamax(8)=15
            p=rnd_point(specialplanet(25),0)
            planetmap(p.x,p.y,specialplanet(25))=-67
        endif
    endif
    
    
    return 0
end function



function load_quest_cargo(t as short,car as short,dest as short) as short
    dim as short bay
    do
        bay=getnextfreebay
        if bay>0 then
            player.cargo(bay).x=t
            player.cargo(bay).y=dest
            car=car-1
        endif
    loop until getnextfreebay<0 or car=0
    if car>0 then dprint "You don't have enough room and leave "&car &" tons behind.",c_yel
    return car
end function


function check_questcargo(st as short) as short
    dim as short a,b,undeliverable,where
    for a=1 to 25
        if player.cargo(a).x=11 or player.cargo(a).x=12 then 
            if basis(player.cargo(a).y).c.x=-1 then 
                undeliverable+=1
                where=player.cargo(a).y
            endif
        endif
        if player.cargo(a).x=11 and player.cargo(a).y=st then
            player.cargo(a).x=1
            player.cargo(a).y=0
            addmoney(500,mt_quest)
            dprint "the local representative pays you 500 Cr. for delivering the cargo",10
        endif
        if player.cargo(a).x=12 and player.cargo(a).y=st then
            player.cargo(a).x=1
            player.cargo(a).y=0
            addmoney(200,mt_quest)
            b=b+1
        endif
    next
    if player.questflag(8)=st then
        if player.towed<0 then
            dprint "you deliver the " &shiptypes(-player.towed) &" hull and get paid "&abs(player.towed)*50 &" Cr.",10
            addmoney(abs(player.towed)*50,mt_quest)
        endif
        player.towed=0
        player.questflag(8)=0
    endif
    if undeliverable>0 then
        if askyn("The Station commander offers to buy your cargo for station "& where & " for 10 Cr. per ton(y/n)") then
            for a=1 to 25
                if (player.cargo(a).x=11 or player.cargo(a).x=12) and player.cargo(a).y=where then
                    player.cargo(a).x=1
                    player.cargo(a).y=0
                    addmoney(10,mt_quest)
                endif
            next
        endif
    endif
    if b>1 then dprint "You deliver "& b &" tons of cargo for triax traders and get paid "& b*200 &" credits.",10
    if b=1 then dprint "You deliver 1 ton of cargo for triax traders and get paid "& b*200 &" credits.",10
    return 0
end function
