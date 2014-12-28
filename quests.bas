function ask_alliance(who as short) as short
    if alliance(0)=1 then
        if alliance(who)=1 then
            dprint "Our progress in battling the robot ships: "
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
            if piratebase(0)=a then ad=1
            if piratebase(1)=a then ad=1
            if piratebase(2)=a then ad=1
            if ad=1 then
                c=rnd_point(a,,305)
                if c.x>0 then 
                    do
                        c=movepoint(c,5)
                    loop until abs(planetmap(c.x,c.y,a))<>305
                    add_landed_alienship(c,a)
                    planetmap(c.x,c.y,a)=-305
                    ad=0 'Already invaded
                endif
            endif
            if ad=1 then
                lp+=1 
                pot(lp)=a
            endif
        endif
    next
    if _debug>0 then lp=1
    if lp>0 then
        m=pot(rnd_range(1,lp))
        if _debug>0 then m=awayteam.slot
        
        c=rnd_point
        for a=1 to rnd_range(1,3)
            add_landed_alienship(c,m)
            planetmap(c.x,c.y,m)=-305
            do
                c=movepoint(c,5)
            loop until abs(planetmap(c.x,c.y,m))<>305            
            if _debug>0 then dprint "ASP"&cords(c)&m
        next
        select case m
        case specialplanet(10),specialplanet(13),specialplanet(14),specialplanet(20),specialplanet(39),specialplanet(40),specialplanet(41),specialplanet(42),specialplanet(43)
            battleslost(ft_merchant,ft_ancientaliens)+=5
        case piratebase(0),piratebase(1),piratebase(2)
            battleslost(ft_pirate,ft_ancientaliens)+=5
        case specialplanet(7)
            battleslost(ft_civ1,ft_ancientaliens)+=5
        case specialplanet(38)
            battleslost(ft_civ2,ft_ancientaliens)+=5
        end select
    endif
    return 0
end function

function add_landed_alienship(c as _cords,m as short) as short
    dim d as _driftingship
    dim c1 as _cords
    if m<0 or m>max_maps then 
        dprint "out of bounds:"&m
        return 0
    end if
        
    if c.x<0 or c.x>60 or c.y<0 or c.y>20 then 
        dprint "out of bounds:"&cords(c),14
        return 0
    end if
    planetmap(c.x,c.y,m)=-305
    'Add ship to enter
    d.m=m
    d.s=18
    d.x=c.x
    d.y=c.y
    add_stranded_ship(18,d,m,0)
    planets(lastplanet)=planets(m)
    planets(lastplanet).depth=1
    planets(lastplanet).wallset=rnd_range(12,13)
    c1=rnd_point(201,lastplanet)
    planetmap(c.x,c.y,lastplanet)=-306
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
        if civ(who-6).inte>=2 then factionmod+=civ(who-6).inte
        factionmod=factionmod+(civ(who-6).aggr-2)*3 
        factionmod=factionmod+(civ(who-6).phil-2)*2 
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

function _patrolquest.generate(p as short,maxdis as short,danger as short) as short
    dim as short i,j,f,d,r
    status=1
    lastcord=p
    cord(1)=player.c
    for i=2 to p
        if rnd_range(1,100)<danger then
            if employer=pirate then
                if rnd_range(1,100)<50 then
                    cord(i)=basis(rnd_range(0,2)).c
                else
                    r=rnd_range(1,3)
                    cord(i).x=drifting(r).x
                    cord(i).y=drifting(r).y
                endif
            else
                r=piratebase(rnd_range(0,2))
                if r>0 then
                    cord(i)=map(sysfrommap(r)).c
                else
                    do
                        cord(i).x=rnd_range(0,sm_x)
                        cord(i).y=rnd_range(0,sm_y)
                        d=distance(cord(1),cord(i))
                    loop until d>=maxdis/2 and d<=maxdis
                endif
            endif
        else
            do
                select case rnd_range(1,100)
                case 1 to 40
                    cord(i)=targetlist(rnd_range(1,lastwaypoint))
                case 1 to 80
                    cord(i)=map(rnd_range(1,laststar+wormhole)).c
                case else
                    cord(i).x=rnd_range(0,sm_x)
                    cord(i).y=rnd_range(0,sm_y)
                end select
                d=distance(cord(1),cord(i))
            loop until d>=maxdis/2 and d<=maxdis
            if rnd_range(1,100)<danger then
                lastfleet+=1
                if employer=pirate then
                    f=set_fleet(makepatrol)
                else
                    f=set_fleet(makepiratefleet)
                endif
                fleet(f).c=cord(i)
                'Add enemy fleet at cord(i)
            endif
        endif
    next
    for i=1 to lastcord
        for j=1 to lastcord
            if i<>j and cord(i).x=cord(j).x and cord(i).y=cord(j).y then
                cord(i).m=1
            endif
        next
    next
    
    return 0
end function


function _patrolquest.check() as short 'sets the cord flag if arrived at patrol point, returns -1 if all points were met
    dim as short i,complete
    complete=-1
    for i=2 to lastcord
        if cord(i).x=player.c.x and cord(i).y=player.c.y then
            if cord(i).m=0 then dprint "Reached patrol target "&cords(cord(i)) &"."
            cord(i).m=1
        endif
        if cord(i).m=0 then complete=0
    next
    return complete
end function

function _patrolquest.reward() as short
    dim as short i,sum
    for i=1 to lastcord-1
        sum+=distance(cord(i),cord(i+1))
    next
    sum=sum*(lastcord^2)
    return sum
end function

function _patrolquest.show() as string
    dim text as string
    dim as short i,first
    if status=1 then
        if check=0 then
            text=text &"Fly a patrol to "
            for i=2 to lastcord
                if cord(i).m=0 then
                    if first=1 then
                        if i<lastcord then
                            text=text &", "
                        else 
                            text=text &" and "
                        endif
                    endif
                    text=text &cords(cord(i))
                    first=1
                endif
            next
            text=text &". |Then return to "&cords(cord(1)) &" to report."
        else
            text=text &"Return to "&cords(cord(1)) &" to report."
        endif
    endif
    return text
end function

function _patrolquest.pay() as short
    if status=1 and check=-1 and player.c.x=cord(1).x and player.c.y=cord(1).y then
        if employer=pirate then
            dprint "The pirate leader gives you "&credits(reward) &" Cr. for completing the patrol."
        else
            dprint "The company rep gives you "&credits(reward) &" Cr. for completing the patrol."
        endif
        addmoney(reward,mt_quest)
        status=0
    endif
    return 0
end function


function give_patrolquest(employer as short) as short
    dim as string empname(1)
    empname(0)="company rep."
    empname(1)="pirate leader"
    dim as short j,i
    j=-1
    for i=12 to 0 step -1
        if patrolquest(i).status=0 then j=i 
    next
    if j>-1 then
        if askyn("We could use some help with an easy patrol. Are you interested?(y/n)") then
            patrolquest(j).employer=employer
            patrolquest(j).generate(rnd_range(4,7),rnd_range(15,20),player.turn/(250*60)+10)'!
            dprint patrolquest(j).show &" Upon completion you will get paid "&Credits(patrolquest(j).reward) &" Cr."
            questroll=999
        endif
    endif
    if _debug=1111 and j>-1 then
        for i=0 to 12
            dprint i &"Status:"&patrolquest(i).status
        next
    endif
    return 0
end function

function reward_patrolquest() as short
    dim as string empname(1)
    empname(0)="company rep."
    empname(1)="pirate leader"
    dim as short a
    for a=0 to 12
        patrolquest(a).pay
    next
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
    questroll=0
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
    for j=3 to lastquestguy
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
    
    if questguy(i).location=questguy(i).flag(12) and questguy(i).want.type=qt_travel then questguy(i).want.type=0 
    
    for j=3 to lastquestguy
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
    debug=qt_travel
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
        do
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
        loop until make_questitem(i,q_want)=0
        questguy(i).want.motivation=rnd_range(0,2)
    endif    
    if questguy(i).has.type=0 then
        do
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
        loop until make_questitem(i,q_has)=0
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
            questguy(i).has.price=questguy(i).has.it.price
        endif
    endif
       
    if (*o).type=qt_autograph then 'Autograph	2
        if wanthas=q_want then
            questguy(i).want.it.ty=57
            questguy(i).flag(1)=rnd_questguy_byjob(14)
            if questguy(i).flag(1)=i or questguy(i).flag(1)<1 then
                questguy(i).want.type=0
            else
                questguy(i).want.it.v1=questguy(i).flag(1) 
                questguy(i).want.price=rnd_range(1,10)
            endif
        else
            questguy(i).flag(1)=rnd_questguy_byjob(14)
            if questguy(i).flag(1)=i or questguy(i).flag(1)<1 then
                questguy(i).has.type=0
            else
                questguy(i).has.it=make_item(1002,questguy(i).flag(1))
                questguy(i).has.price=rnd_range(1,10)
            endif
        endif
        
    endif
    
    if (*o).type=qt_outloan then'Outstanding Loan	3
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
                if questguy(i).flag(1)>0 then
                if rnd_range(1,100)<33 or questguy(i).location=questguy(j).location then questguy(i).knows(questguy(i).flag(1))=questguy(questguy(i).flag(1)).location
                questguy(questguy(i).flag(1)).loan=rnd_range(1,10)*100
                questguy(i).want.price=questguy(questguy(i).flag(1)).loan
            else
                questguy(i).want.type=0
            endif
        else
            
        endif
        
    endif
    
    if (*o).type=qt_stationimp then'Station improvements	4
        if wanthas=q_want then
            questguy(i).flag(1)=get_other_questguy(i)
            questguy(i).want.price=rnd_range(1,60)*(1+questguy(i).want.motivation)
        else
        endif
        
    endif
        
    if (*o).type=qt_drug then'Drug	5
        if wanthas=q_want then
            questguy(i).want.it=make_item(1005,rnd_range(1,6))
        else
            questguy(i).has.it=make_item(1005,rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=qt_souvenir then'Souvenir	6
        if wanthas=q_want then
            questguy(i).want.it.ty=23
        else
            questguy(i).has.it=make_item(rnd_range(93,94))
            questguy(i).has.price=questguy(i).has.it.price
        endif
        
    endif
        
    if (*o).type=qt_tools then'Tools	7
        if wanthas=q_want then
        else
            questguy(i).has.it=make_item(1004,rnd_range(1,6))
            questguy(i).has.price=questguy(i).has.it.price
        endif
        
    endif
    
    if (*o).type=qt_showconcept then'Show Concept	8
        if wanthas=q_want then
            questguy(i).want.price=(5-questguy(i).want.motivation)*100
        else
            questguy(i).flag(5)=rnd_questguy_byjob(14,i)
            if questguy(i).flag(5)<0 then return -1
            questguy(i).has.it=make_item(1008,questguy(i).flag(5),rnd_range(1,6))
            questguy(i).has.price=rnd_range(10,100)
        endif
        
    endif
    
    if (*o).type=qt_stationsensor then'Station Sensor access	9
            questguy(i).want.price=(5-questguy(i).want.motivation)*10
        if wanthas=q_want then
        else
            if questguy(i).location<0 then
                questguy(i).has.it=make_item(1009,rnd_range(0,2))
            else
                questguy(i).has.it=make_item(1009,questguy(i).location)
            endif
            questguy(i).has.price=rnd_range(1,10)
        endif
    endif
    
    if (*o).type=qt_travel then'Travel	
        do
            questguy(i).flag(12)=rnd_range(0,2)
        loop until questguy(i).flag(12)<>questguy(i).location
        questguy(i).flag(13)=distance(player.c,basis(questguy(i).flag(12)).c)*rnd_range(1,3+(*o).motivation)
        questguy(i).flag(14)=rnd_range(5,15)
    endif
    
    if (*o).type=qt_cargo then'Cargo	11
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
            questguy(i).flag(4)=piratebase(rnd_Range(0,_NOPB))
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
    
    if (*o).type=qt_research then'Research
        if wanthas=q_want then
            questguy(i).flag(1)=rnd_questguy_byjob(15,i)'If no astro
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=rnd_questguy_byjob(16,i)'xeno
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=rnd_questguy_byjob(6,i)'Doctor
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=rnd_questguy_byjob(4,i)'SO
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=rnd_questguy_byjob(13,i)'OBE MEgacopr
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=rnd_questguy_byjob(17,i)'Engineer
            if questguy(i).flag(1)<=0 then questguy(i).flag(1)=get_other_questguy(i)'SO
        else
            questguy(i).has.it=make_item(1010,i)
        endif
        
    endif
    
    if (*o).type=qt_megacorp then'Info on Megacorp	21
        if wanthas=q_want then
            do
                comp=rnd_range(1,4)
            loop until comp<>questguy(i).job-9 or (questguy(i).job<10 or questguy(i).job>14)
            questguy(i).want.it=make_item(1006,comp)
            questguy(i).flag(6)=comp
        else
            if questguy(i).job>=10 and questguy(i).job<=13 then 
                comp=questguy(i).job-9
            else
                comp=rnd_range(1,4)
            endif
            questguy(i).has.it=make_item(1006,comp,rnd_range(1,3))
            
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
            (*o).it=make_item(1011)
        endif
        
    endif
    if (*o).type=qt_cursedship then'Cursed ship	26
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
    
    if questguy(i).flag(1)<0 then questguy(i).want.type=0
    
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
    if h=0 then return -1
    return others(rnd_range(1,h))
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
                    dprint gain_talent(a),c_gre
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


function giveitem(e as _monster,nr as short) as short
    dim as short a
    dim it as _items
    dprint "What do you want to offer the "&e.sdesc &"?"
    a=get_item()
    if a>0 then
     if (e.lang=6 or e.lang=7) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
         item(a).w.p=nr
         item(a).w.s=0
         it=make_item(96,-1,-3)
         placeitem(it,0,0,0,0,-1)
         reward(2)=reward(2)+it.v5
         dprint "The reptile gladly accepts the weapon 'This will help us in eradicating the other side' and hands you some "&it.desig
         return 0
     endif
     if e.allied>0 then
         if item(a).price>100 then
            dprint "The "&e.sdesc &" accepts the gift."
            factionadd(0,e.allied,-5)
            item(a).w.p=nr
            item(a).w.s=0
            if e.aggr=2 and rnd_range(1,6)+rnd_range(1,6)<e.intel then 
                e.aggr=1
            endif
            return 0
        else
            dprint "The "&e.desc &" doesn't want the "&item(a).desig &"."
        endif
    endif
         
    if e.lang=4 then
        if item(a).price>1000 then       
            item(a).w.p=nr
            item(a).w.s=0     
            dprint "Apollo accepts your tribute"
            e.aggr=1
        else
            dprint "'You can't soothe me with such worthless trinkets!'"
        endif
    endif
     
    if (e.lang=28) and (item(a).ty=2 or item(a).ty=7 or item(a).ty=4) then
        item(a).w.p=nr
        item(a).w.s=0
        dprint "The worker hides the "&item(a).desig &"quickly saying 'Thank you, now if i only had a way to get off this rock'" 
        if rnd_range(1,6)<3 then e.faction=2
        return 0
    endif
     
     if (e.lang=40) then
        item(a).w.p=nr
        item(a).w.s=0
        dprint "Thank you so much! I am sure I can find a use for this!"
        return 0
    endif
    select case e.intel
        case is>6
            if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" accepts the gift."
                e.cmmod=e.cmmod+2
                if rnd_range(1,6)+ rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then e.aggr=1
                item(a).w.p=nr
                item(a).w.s=0
                if e.aggr=1 and rnd_range(1,6) +rnd_range(1,6)<e.intel then
                    dprint "The "&e.sdesc &" gives you something in return."
                    if rnd_range(1,100)<66 then
                        it=make_item(94)
                    else
                        it=make_item(96,-3,-3)
                        reward(2)=reward(2)+it.v5
                    endif
                    placeitem(it,0,0,0,0,-1)
                endif
            else
               dprint "The "&e.sdesc &" doesn't want the "& item(a).desig &"."
            endif
        case else
            if item(a).ty=13 and rnd_range(1,6) +rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" eats the "& item(a).desig &"."
                e.sleeping=e.sleeping+item(a).v1
                if e.sleeping>0 then dprint "And falls asleep!"
                item(a)=item(lastitem)
                lastitem=lastitem-1
            else
                dprint "The "&e.sdesc &" doesn't want the "& item(a).desig & "."
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
        if r=1 then do_dialog(902,e,0)
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
                placeitem(make_item(88),0,0,0,0,-1)
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
        if r=11 then do_dialog(901,e,0)
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
    dim as short a,b,bay, s,pl,car,st2,m,o,m2,o2,x,y,i,j,f
    dim as _cords p
    static stqroll as short
    if st<>player.lastvisit.s then stqroll=rnd_range(1,20)
    do
        st2=rnd_range(0,2)
    loop until st2<>st
    
    if _debug=1111 then questroll=14
    
    if questroll>16 then
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
        do
            a=rnd_range(0,2)
        loop until a<>st
        if _debug=1111 then stqroll=14
        select case stqroll
        case 1 to 3
            if askyn("The company rep needs some cargo delivered to station "&a+1 &". He is willing to pay 200 credits. Do you accept? (y/n)" ) then
                bay=getnextfreebay
                if bay<=0 then 
                    if askyn("Do you want to make room for the cargo ?(y/n)") then 
                        sellgoods(10)
                        bay=getnextfreebay
                    endif
                endif
                if bay>0 then
                    player.cargo(bay).x=12 'type=specialcargo
                    player.cargo(bay).y=a 'Destination
                endif
            endif
        
        case 4
            b=rnd_range(1,16)
            if askyn("The company rep needs "&add_a_or_an(shiptypes(b),0) &" hull towed to station "&a+1 &" for refits. He is willing to pay "& b*50 &" Cr. Do you accept(y/n)?") then
                if player.tractor=0 then
                    dprint "You need a tractor beam for this job.",14
                else
                    player.towed=-b
                    player.questflag(8)=a
                endif
            endif
        
        case 5
            if player.questflag(2)=0 then
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
            
        case 6
            if player.questflag(5)=0 and player.turn>3*30*24*60 then
                dprint "The company rep warns you about a ship that has reportedly been preying on pirates and merchants alike. 'It's fast, it's dangerous, and a confirmed kill is worth 15.000 credits to my company.",15
                player.questflag(5)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=make_ship(11)
                fleet(lastfleet).flag=5
                fleet(lastfleet).c=map(sysfrommap(specialplanet(29))).c            
            endif
            
        case 7
            if player.questflag(5)=2 then
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
            
        case 8
            if player.questflag(11)=0 and lastdrifting<128 then
                player.questflag(11)=1
                x=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.x
                y=5-rnd_range(1,10)+map(sysfrommap(specialplanet(27))).c.y
                if x<0 then x=0
                if y<0 then y=0
                if x>sm_x then x=sm_x
                if y>sm_y then y=sm_y
                lastdrifting=lastdrifting+1
                m=lastdrifting
                drifting(m).s=14
                drifting(m).x=x
                drifting(m).y=y
                
                dprint "The company rep tells you about a battleship that has gone missing. It's last known position was " & x &":" &y & ". There is a 5000 Credit reward for finding out what happened to it.",15
                drifting(m).x=drifting(m).x+rnd_range(1,8)-rnd_range(1,8)
                drifting(m).y=drifting(m).y+rnd_range(1,8)-rnd_range(1,8)
                if drifting(m).x<0 then drifting(m).x=0
                if drifting(m).x<sm_x then drifting(m).x=sm_x
                if drifting(m).y<0 then drifting(m).y=0
                if drifting(m).y<sm_y then drifting(m).y=sm_y
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
                planets(m).mon_noamin(0)=5
                planets(m).mon_noamax(0)=15
                planets_flavortext(m)="No hum from the engines is heard as you enter the Battleship. Emergency lighting bathes the corridors in red light, and the air smells stale."
            endif
            
        case 9 to 14
            give_bountyquest(0)
        
        case 15 to 17
            if player.questflag(26)=0 then
                s=get_random_system
                pl=getrandomplanet(s)
                if pl>0 then
                    dprint "We haven't heard in a while from a ship that last reported from " & map(s).c.x &":"&map(s).c.y & ". We offer you 500 Cr. if you can find out what hapened to them."
                    player.questflag(26)=pl
                    placeitem(make_item(81,1),rnd_range(0,60),rnd_range(0,20),pl)
                endif
            endif
        case 18
            'Escort
            if askyn("There is an important delivery for station "&a+1 &". We are looking to enhance security. Would you be interested in flying escort? (y/n)") then
                f=set_fleet(makemerchantfleet)
                fleet(f).c=player.c
                fleet(f).con(1)=1
                fleet(f).con(3)=a
                fleet(f).con(2)=distance(player.c,basis(st).c)*50
                dprint "The captain will pay you "&fleet(f).con(2) & " Cr. when you reach the target."
            endif
        
        case else
            give_patrolquest(0)
        end select
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
            player.towed=0
            player.questflag(8)=0
        endif
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
