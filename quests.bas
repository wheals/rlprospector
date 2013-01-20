function questguy_newloc(i as short) as short
    dim as short j,noperstation(2),s1,s2,s3,debug
    for j=1 to lastquestguy
        if questguy(j).location>=0 then' Is on a big station
            noperstation(questguy(j).location)+=1
        endif
    next
    if debug=1 then dprint "Newloc called:" & noperstation(0) &":"& noperstation(1) &":" &noperstation(2)
    s1=find_high(noperstation(),2,0)
    s3=find_low(noperstation(),2,0)
    s2=3-s1-s3's2 is the one that isn't s1 or s3
    if debug=1 then dprint s1 &":"& s2 &":"& s3
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
    'debug=22
    f=freefile
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
    'if debug=1 then dprint "lines :"&j &" | In->" &questguy(i).want.type &":"& questguy(i).has.type
    if questguy(i).want.type=0 then
        if rnd_range(1,100)<30 then 'standard
            l=rnd_range(1,7)
        else 'Specific
            l=questguy(i).job+7
        endif
        if debug=1 then dprint "adding want from line "&l
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
        IF debug>0 then questguy(i).want.type=debug
        make_questitem(i,q_want)
        questguy(i).want.motivation=rnd_range(0,2)
    endif    
    if questguy(i).has.type=0 then
        if rnd_range(1,100)<30 then 'standard
            l=rnd_range(1,7)
        else 'Specific
            l=questguy(i).job+7
        endif
        if debug=1 then dprint "adding has from line "&l
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
        IF debug>0 then questguy(i).has.type=debug
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
    'if debug=1 then dprint "Out->" &questguy(i).want.type &":"& questguy(i).has.type
    return 0
end function

function make_questitem(i as short,wanthas as short) as short
    dim o as _questitem pointer
    dim as short who,comp
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
    if (*o).type=1 then 'Equipment item
        if wanthas=q_want then
            questguy(i).want.it.ty=rnd_range(2,4) 'What kind of Item
            questguy(i).want.it.v1=rnd_range(1,3)+(*o).motivation*2 'Minimun v1
            questguy(i).want.it.desig=genname(questguy(i).want.it.ty)
        else 'Has
            questguy(i).has.it=rnd_item(33)
        endif
    endif
    
    if (*o).type=2 then 'Heirloom	2
        if wanthas=q_want then
            
            (*o).it=rnd_item(33)
            (*o).it.desig=questguy(i).n &"s "&(*o).it.desig
            (*o).it.v6=i
            (*o).whohasit=get_other_questguy(i)
        else
        endif
            
    endif
    
    if (*o).type=3 then 'Autograph	3
        if wanthas=q_want then
            questguy(i).want.it.ty=57
            questguy(i).want.it.v1=rnd_questguy_byjob(14) 'Negative v1 means that value must be exact
            questguy(i).other=questguy(i).want.it.v1
            
        else
            (*o).it=makeitem(1002,rnd_questguy_byjob(14))
        endif
        
    endif
    
    if (*o).type=4 then'Outstanding Loan	4
        if wanthas=q_want then
            questguy(i).other=get_other_questguy(i)
            questguy(i).loan=rnd_range(1,10)*100
        else
            
        endif
        
    endif
    
    if (*o).type=5 then'Station improvements	5
        if wanthas=q_want then
            questguy(i).other=get_other_questguy(i)
        else
        endif
        
    endif
        
    if (*o).type=6 then'Drug	7
        if wanthas=q_want then
            (*o).it.ty=60
            (*o).it.v1=rnd_range(1,6)
            (*o).it.price=(*o).it.v1*100
            
            (*o).it.desig="Drug "&chr(64+(*o).it.v1)
            (*o).it.desigp="Drugs "
        else
            
            questguy(i).has.it=makeitem(1005,rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=7 then'Souvenir	8
        if wanthas=q_want then
            (*o).it.ty=23
        else
            (*o).it=makeitem(rnd_range(93,94))
        endif
        
    endif
        
    if (*o).type=8 then'Tools	9
        if wanthas=q_want then
        else
            (*o).it=makeitem(1004,rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=9 then'Show Concept	10
        if wanthas=q_want then
        else
            (*o).it=makeitem(1008,rnd_questguy_byjob(14),rnd_range(1,6))
        endif
        
    endif
    
    if (*o).type=10 then'Station Sensor access	11
        if wanthas=q_want then
        else
        endif
    endif
    
    if (*o).type=11 then'Alibi	12
        if wanthas=q_want then
            questguy(i).other=get_other_questguy(i)
        else
        endif
    endif
    
    if (*o).type=12 then'Message	13
        who=get_other_questguy(i)
        questguy(i).other=who
        if wanthas=q_want then
            (*o).it.desig="Message for "&questguy(who).n
        else
        endif
        
    
    endif
    if (*o).type=13 then'Loc of Pirates	14
        if wanthas=q_want then
        else
        endif
        
    
    endif
    if (*o).type=14 then'Loc of Special Planet	15
        if wanthas=q_want then
        else
        endif
        
    endif
    
    if (*o).type=15 then'Loc of Garden World	16
    endif
    
    if (*o).type=16 then'Loc of Person	17
        questguy(i).other=get_other_questguy(i)
    endif
    
    if (*o).type=17 then'Good paiyng Captain	18
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=18 then'Research
        questguy(i).other=rnd_questguy_byjob(15,i)'If no astro
        if questguy(i).other=0 then questguy(i).other=rnd_questguy_byjob(16,i)'xeno
        if questguy(i).other=0 then questguy(i).other=rnd_questguy_byjob(6,i)'Doctor
        if questguy(i).other=0 then questguy(i).other=rnd_questguy_byjob(4,i)'SO
        if questguy(i).other=0 then questguy(i).other=rnd_questguy_byjob(13,i)'SO
        if wanthas=q_want then
        else
            questguy(i).has.it=makeitem(1010,i)
        endif
        
    endif
    
    if (*o).type=19 then'Info on Megacorp	21
        if wanthas=q_want then
            do
                comp=rnd_range(0,3)
            loop until comp<>questguy(i).job-10
            questguy(i).want.it=makeitem(1006,comp)
        else
            if questguy(i).job>=10 and questguy(i).job<=13 then 
                comp=questguy(i).job-10
            else
                comp=rnd_range(0,3)
            endif
            questguy(i).has.it=makeitem(1006,questguy(i).job-10,rnd_range(1,3))
            
        endif
        
    endif
    if (*o).type=20 then'Bio Data	22
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=21 then'Anomaly Data	23
        if wanthas=q_want then
        else
        endif
        
    endif
    
    if (*o).type=22 then'Jury Rig Plans	25
        if wanthas=q_want then
        else
            (*o).it=makeitem(1011)
        endif
        
    endif
    if (*o).type=23 then'Wormhole Info	26
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=24 then'Crime Info	27
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=25 then'Where to Perform	28
        if wanthas=q_want then
        else
        endif
        
    endif
    if (*o).type=26 then'info on has wants loc	29
        if wanthas=q_want then
        else
        endif
        
    endif
    return 0
end function

function get_other_questguy(i as short) as short
    dim as short other,j,h
    dim others(15) as short
    for j=1 to lastquestguy
        if questguy(i).location<>questguy(j).location then
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
    dim as short no
    no=1
    'dim as short fl
    dim e as _monster
    
    update_qg_dialog(i,node())
    
    questguy_message(i) 'Check if player has message for qg before entering dialogue
    
    do
        update_qg_dialog(i,node())
        no=node_menu(no,node(),e,0,i)
    loop until no=0
    return 0
end function

function update_qg_dialog(i as short,node() as _dialognode) as short
    dim as short debug,j,jj,o
    dim deletenode as _dialognode
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
    
    questguy(i).talkedto=1
    if questguy(i).friendly<0 then questguy(i).friendly=0
    if questguy(i).friendly>2 then questguy(i).friendly=2
    select case questguy(i).friendly
    case is=0
        node(1).statement="What do you want?"
    case is=1
        node(1).statement="Hello"
    case is=2
        node(1).statement="Oh! Hello! Happy to meet you!"
    end select
    
    if debug=1 then node(1).statement=questguy(i).has.it.desig &":"& questguy(i).want.it.desig
    node(1).option(1).answer="Who are you?"
    node(1).option(1).no=2
    o=1
    if questguy(i).want.given=0 and questguy(i).want.type<>0 then
        o+=1
        node(1).option(o).answer=questguyquestion(questguy(i).want.type,Q_WANT)
        node(1).option(o).no=3
    endif
    if questguy(i).has.given=0 and questguy(i).has.type<>0 then
        o+=1
        node(1).option(o).answer=questguyquestion(questguy(i).has.type,Q_HAS)
        node(1).option(o).no=4
    endif
    o+=1
    node(1).option(o).answer="Do you know ...?"
    node(1).option(o).no=8
    
    
    if questguy(i).job=1 or (questguy(i).job>=4 and questguy(i).job<=6) or (questguy(i).job>=10 and questguy(i).job<=14) then
        o+=1
        if questguy(i).job=1 then node(1).option(o).answer="Can I get access for the stations sensors?"
        if questguy(i).job=14 then node(1).option(o).answer="Can I have an autograph"
        if questguy(i).job>=4 and questguy(i).job<=6 then node(1).option(o).answer="Do you want to compare notes with our " & questguyjob(questguy(i).job) & "?"
        if questguy(i).job>=10 and questguy(i).job<=13 then node(1).option(o).answer="Do you have any info on your company?"
        node(1).option(o).no=6
        node(6).effekt="GIVEJOBHAS"
        node(6).param(0)=i
    endif
    
    for j=0 to lastitem
        if item(j).w.s=-1 and item(j).ty=62 and item(j).v1=i then
            o+=1
            node(1).option(o).answer="I got your money"
            node(1).option(o).no=18
            node(18).statement="Great! Thank you! Here are your "&questguy(i).want.motivation+1 &"0%."
            node(18).effekt="ABGEBEN"
            node(18).param(0)=j
            node(18).param(1)=i
        endif
    next
    
    
    for j=1 to lastquestguy
        if questguy(j).want.type=qt_heirloom and i=questguy(j).want.whohasit and questguy(j).talkedto>0 then
            o+=1
            node(1).option(o).answer="Do you have something for "&questguy(j).n &"?"
            node(1).option(o).no=14
            node(14).statement="yes, i do have "&questguy(j).want.it.desig
            node(14).option(1).answer="Can I have it?"
            node(14).option(1).no=15
            node(14).option(2).answer="Is there something you want that I can swap for it?"
            node(14).option(2).no=16
            node(15).effekt="SELLOTHER"
            node(15).param(0)=j
            node(15).param(1)=questguy(j).want.motivation+1
        endif
        if questguy(j).want.type=qt_outloan and i=questguy(j).other and questguy(j).talkedto=1 then
            o+=1
            node(1).option(o).answer=questguy(j).n &" says you owe him money"
            node(1).option(o).no=17
            if questguy(i).money>=questguy(j).loan then
                node(17).statement="Yes, I know. Can you give it to him?"
                node(17).effekt="EINTREIBEN"
                node(17).param(0)=j
            else
                node(17).statement="Yes, I know, but I can't afford to pay back right now."
            endif
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
    
    o+=1
    node(1).option(o).answer="Let's have a drink."
    node(1).option(o).no=21
    o+=1
    node(1).option(o).answer="Bye"
    node(1).option(o).no=0
    
    node(2).statement="I am "&questguy(i).n &", a "&questguyjob(questguy(i).job) &"."
    node(2).option(1).no=1
    
    node(3).statement=questguydialog(questguy(i).want.type,questguy(i).want.motivation,Q_WANT)
    node(3).effekt="SELLWANT"
    node(3).param(0)=i
    node(3).param(1)=questguy(i).want.motivation+1
    node(3).option(1).no=1
    if questguy(i).want.type=qt_stationsensor then node(3).param(2)=10*(questguy(i).want.motivation+1)
    if questguy(i).want.type=qt_heirloom then node(3).param(1)=node(3).param(1)+rnd_range(1,3)
    if questguy(i).want.type=qt_autograph then node(3).param(2)=50*(questguy(i).want.motivation+1)
    
    if questguy(i).want.type=qt_biodata then
        node(3).effekt="BUYBIODATA" 
        node(3).param(0)=i
        node(3).param(1)=1+questguy(i).want.motivation
    endif
    if questguy(i).want.type=qt_anomaly then
        node(3).effekt="BUYANOMALY"
        node(3).param(0)=i
        node(3).param(1)=1+questguy(i).want.motivation
    endif
    
    if questguy(i).want.type=qt_message then
        node(4).effekt="GIVEMESSAGE"
        node(4).param(0)=i
    endif
    
    node(4).statement=questguydialog(questguy(i).has.type,questguy(i).has.motivation,Q_HAS)
    if questguy(i).has.type=qt_research or questguy(i).has.type=qt_juryrig or questguy(i).has.type=qt_EI or questguy(i).has.type=qt_drug or questguy(i).has.type=qt_souvenir or questguy(i).has.type=qt_tools or questguy(i).has.type=qt_showconcept then
        node(4).effekt="SELLHAS"
        node(4).param(0)=i
        node(4).param(1)=1+questguy(i).has.motivation
    endif
    if questguy(i).has.type=qt_drug then
        node(4).effekt="SELLHAS"
    endif
    if questguy(i).has.type=qt_tools then
        node(4).effekt="SELLHAS"
        node(4).param(0)=i
    endif
    if questguy(i).has.type=qt_ei then
        node(4).effekt="SELLHAS"
        node(4).param(0)=i
    endif
    if questguy(i).has.type=qt_message then
        node(4).effekt="GIVEMESSAGE"
        node(4).param(0)=i
    endif
    
    node(4).option(1).no=1
    
    'Do you know ....
    node(8).option(1).answer="Never mind"  'We must make the lastseen list nonrandom but factual.
    node(8).option(1).no=1
    jj=1
    for j=1 to lastquestguy
        if j<>i and questguy(i).location<>questguy(j).location then 'He will always know himself
            if questguy(j).talkedto<>0 then
                jj+=1
                node(8).option(jj).answer=questguy(j).n
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
    next
    node(9).statement="Sorry, don't know who that is."
    node(9).option(1).no=1
    node(10).statement="Last I saw that person on one of the small space stations."
    node(10).option(1).no=1
    node(11).statement="Last saw that person on station 1"
    node(11).option(1).no=1
    node(12).statement="Last saw that person on station 2"
    node(12).option(1).no=1
    node(13).statement="Last saw that person on station 3"
    node(13).option(1).no=1
    
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

    return 0
end function


function questguy_message(c as short) as short
    dim as short i,d
    for i=0 to lastitem
        if item(i).ty=58 and item(i).w.s=-1 and item(i).v2=c then
            if askyn("Do you want to deliver the message?(y/n)") then
                d=rnd_range(1,6)*questguy(item(i).v2).want.motivation
                dprint "You get a "&5*d &" Cr. tip"
                player.money+=d
                destroyitem(i)
            endif
        endif
    next
    return 0
end function

    

function has_questguy_want(i as short,byref t as short) as short
    dim as short a,b,c
    'Item
    for a=0 to lastitem
        if item(a).w.s=-1 then
            select case questguy(i).want.type
            case is=qt_EI
                t=qt_EI
                if item(a).ty=questguy(i).want.it.ty and item(a).v1>=questguy(i).want.it.v1 then return a
            case is=qt_heirloom
                t=qt_heirloom
                if item(a).ty=questguy(i).want.it.ty and item(a).v6=i then return a
            case is=qt_autograph
                t=qt_autograph
                if item(a).ty=57 and item(a).ty=questguy(i).want.it.ty and item(a).v1=questguy(i).want.it.v1 then return a
            case is=qt_drug
                t=qt_drug
                if item(a).ty=60 and item(a).v1=questguy(i).want.it.v1 then return a
            case is=qt_souvenir
                t=qt_souvenir
                if item(a).ty=23 then return a
            case is=qt_showconcept
                t=qt_showconcept
                if item(a).ty=63 and (item(a).v1=i or item(a).v1=0) then return a
            case is=qt_stationsensor
                t=qt_stationsensor
                if item(a).ty=64 and (questguy(i).location=-1 or item(a).v1=questguy(i).location) then return a
            case is=qt_message
                t=qt_message
                if item(a).ty=58 and item(a).v2=i then return a
            case is=qt_research
                if item(a).ty=65 and item(a).v1=questguy(i).other then return a
            case is=qt_tools
                t=qt_tools
                if item(a).ty=59 then return a
            case is=qt_megacorp
                t=qt_megacorp
                if player.questflag(21)=1 then return -21
                if player.questflag(22)=1 then return -22
                if player.questflag(23)=1 then return -23
                if player.questflag(24)=1 then return -24
                if item(a).ty=61 and item(a).v1=questguy(i).want.it.v1 then return a
            case is=qt_juryrig
                t=qt_juryrig
                if item(a).ty=66 then return a
            end select
        endif
    next
    
    'Location of character
    for a=1 to lastquestguy
        if questguy(a).talkedto=1 then 'Player knows
            if questguy(i).knows(a)=0 then 'character doesnt
                if questguy(i).want.type=qt_goodpaying and questguy(a).job=2 then
                    t=qt_goodpaying
                    return a
                endif
                if questguy(i).want.type=qt_stationimp and questguy(a).job=17 then
                    t=qt_stationimp
                    return a
                endif
                if questguy(i).want.type=qt_locofperson and questguy(i).other=a then
                    t=qt_locofperson
                    return a
                endif
            else
                if questguy(i).want.type=qt_alibi and a=questguy(i).other then
                    t=qt_alibi
                    return a
                endif
            endif
        endif
    next
    
    'Location of planet
    for a=1 to laststar
        if map(a).discovered=1 and questguy(i).systemsknown(a)=0 then
            for b=1 to 9
                if map(a).planets(b)>0 and map(a).planets(b)<=max_maps then
                    if planets(map(a).planets(b)).discovered<>0 then
                        if questguy(i).want.type=qt_locofpirates then
                            for c=0 to _nopb
                                if piratebase(c)=map(a).planets(b) then
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
        if debug=1 then dprint node(no).effekt
        no=node_menu(no,node(),e,fl)
        if debug=1 then dprint "Next node:"&no
    loop until no=0
    return 0
end function

function node_menu(no as short,node() as _dialognode,e as _monster, fl as short,qgindex as short=0) as short
    dim text as string
    dim as short a,c,flag,debug
    debug=1
    dprint adapt_nodetext(node(no).statement,e,fl,qgindex),11
    if node(no).effekt<>"" then dialog_effekt(node(no).effekt,node(no).param(),e,fl)
    text="You say"
    for a=1 to 16
        if node(no).option(a).answer<>"" then 
            text=text &"/"& adapt_nodetext(node(no).option(a).answer,e,fl,qgindex)
            if debug=1 then text=text &"("& node(no).option(a).no &")"
            flag+=1
        endif
    next
    'if qgindex>0 then text=text &"/Bye."
    if flag>0 then
        do
            c=menu(text,,0,20-flag,1)
        loop until c>=0
        dprint adapt_nodetext(node(no).option(c).answer,e,fl,qgindex),15
        if debug=1 then dprint "you choose "&node(no).option(c).no &":"&c
        return node(no).option(c).no
    else
        return node(no).option(1).no
    endif
end function

function adapt_nodetext(t as string, e as _monster,fl as short,qgindex as short=0) as string
    dim word(128) as string
    dim stword(128) as string
    dim r as string
    dim as string himher(1),hishers(1),heshe(1)
        
    himher(0)="her"
    himher(1)="him"
    hishers(0)="hers"
    hishers(1)="his"
    heshe(0)="he"
    heshe(1)="she"
    dim as short l,i,j
    l=string_towords(stword(),t," ",1)
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
        if word(i)="<FLEET>" then word(i)=""&abs(fl)
        if word(i)="<PLAYER>" then word(i)="captain "&crew(1).n &" of the "&player.desig
        if word(i)="<COORDS>" then 
            if fl>0 then 
                word(i)=fleet(fl).c.x &":"& fleet(fl).c.y
            else
                word(i)=drifting(abs(fl)).x &":"& drifting(abs(fl)).y
            endif
        endif
        if word(i)="<#FL>" then word(i)=""&abs(fl)
        if word(i)="I-<#FL>" then word(i)="IS-"&abs(fl)
        if word(i)="<ITEMW>" and qgindex>0 then word(i)=questguy(qgindex).want.it.desig
        if word(i)="<ITEMH>" and qgindex>0 then word(i)=questguy(qgindex).has.it.desig
        if word(i)="<CHARACTER>" and qgindex>0 then word(i)=questguy(questguy(qgindex).other).n
        if word(i)="<HESHE>" and qgindex>0 then word(i)=heshe(questguy(questguy(qgindex).other).gender)
        if word(i)="<HIMHER>" and qgindex>0 then word(i)=himher(questguy(questguy(qgindex).other).gender)
        if word(i)="<HISHERS>" and qgindex>0 then word(i)=hishers(questguy(questguy(qgindex).other).gender)
        if word(i)="<MONEY>" and qgindex>0 then word(i)=credits(questguy(questguy(qgindex).other).loan)
        if word(i)="<DRUG>" and qgindex>0 then
        endif
        r=r &word(i)
        if len(word(i+1))>1 or ucase(word(i+1))="A" or ucase(word(i+1))="I" then r=r &" "
        
    next
    return r
end function

function dialog_effekt(effekt as string,p() as short,e as _monster, fl as short) as short
    dim as short f,a,i,t,rew,ph,dh
    dim as _items it
    dim as single fuelprice,fuelsell
        
    if effekt="CHANGEMOOD" then e.aggr=p(0)
    if effekt="BUYFUEL" then
        if askyn("Do you want to buy fuel for "&p(0) &" Cr. (y/n)") then
            dprint "How much fuel do you want to buy"
            f=getnumber(0,player.fuelmax-player.fuel,0)
            if f*p(0)>player.money then f=fix(player.money/p(0))
            if f+player.fuel>player.fuelmax then f=player.fuelmax-player.fuel
            player.fuel=player.fuel+f
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
            a=getitem
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
            player.money+=item(p(1)).price*p(2)*(1+crew(1).talents(2)/10)
            
            item(p(1))=item(lastitem)
            lastitem-=1
            
        endif
    endif
    if effekt="GIVEHAS" then
        placeitem(questguy(p(0)).has.it,0,0,0,0,-1)
        questguy(p(0)).has.given+=1
    endif
    
    if effekt="GIVEJOBHAS" then
        select case questguy(p(0)).job
        case is=1
            it=makeitem(1009,questguy(p(0)).location)
            if questguy(p(0)).friendly>1 then
                it.price=0
            else
                it.price=25
            endif
        case is=14
            it=makeitem(1002,p(0))
            if questguy(p(0)).friendly>0 then
                it.price=10
            else
                it.price=0
            endif
        case 4 to 6
            if questguy(p(0)).friendly=2 and questguy(p(0)).flag(0)=0 then
                dprint "Of course!"
                if questguy(p(0)).job=4 then gainxp(4,urn(0,3,15,0))
                if questguy(p(0)).job=5 then gainxp(3,urn(0,1,15,0))
                if questguy(p(0)).job=6 then gainxp(5,urn(0,3,15,0))
                questguy(p(0)).flag(0)=1
                return 0
            else
                dprint "I don't have anything interesting to share."
                return 0
            endif
            
        case else
            it=makeitem(1006,questguy(p(0)).job-9,questguy(p(0)).friendly)
            it.price=150*questguy(p(0)).friendly
        end select
        it.price=it.price*(1-crew(1).talents(2)/10)
        if it.price=0 and it.desig<>"" then
            dprint "Of course! "&questguy(p(0)).n &" hands you a "&it.desig &"."
            placeitem(it,0,0,0,0,-1)
        else
            if askyn("Do you want to pay "&it.price &" Cr. for the "&it.desig &"?(y/n)") then
                if player.money-it.price>=0 then
                    dprint "You buy a "&it.desig &"."
                    placeitem(it,0,0,0,0,-1) 
                    player.money-=it.price
                endif
            endif
        endif
                    
    endif
    
    if effekt="SELLHAS" then
        it=questguy(p(0)).has.it
        p(1)=questguy(p(0)).has.motivation+1
        rew=fix((it.price/p(1))*(10-questguy(p(0)).friendly-crew(0).talents(2))/10)
        dprint it.price &"/"& p(1) &"*"& (10-questguy(p(0)).friendly)/10 &"="& rew
        'dprint "it desig="&it.desig &":"&p(0) &":"&p(1)
        if askyn("Do you want to buy "& it.desig &" for "& rew &" Cr.(y/n)") then
            if player.money>=rew then
                player.money-=rew
                placeitem(questguy(p(0)).has.it,0,0,0,0,-1)
                questguy(p(0)).has.given+=1
            else
                dprint "You don't have enough money"
            endif
        endif
    endif
    
    if effekt="SELLWANT" Then
        i=has_questguy_want(p(0),t)
        
        dprint "T is "&t &"I is "&i
        if i>0 then
            select case t
            case qt_juryrig,qt_EI,qt_heirloom,qt_autograph,qt_megacorp,qt_drug,qt_souvenir,qt_tools,qt_showconcept,qt_stationsensor
                if askyn("Do you want to sell your "&item(i).desig &" for "&item(i).price*p(1)+p(2) &" Cr.(y/n)?") then
                    player.money+=item(i).price*p(1)+p(2)
                    destroyitem(i)
                    questguy(p(0)).want.given+=1
                    if t=qt_drug and questguy(p(0)).want.motivation>0 then questguy(p(0)).want.motivation-=1
                else
                    if item(i).ty=57 then item(i).price=0
                
                endif
            case qt_stationimp,qt_goodpaying,qt_alibi,qt_locofperson
                if questguy(p(0)).want.given=0 then
                    if askyn("Do you want to tell him about "&questguy(i).n &"?(y/n)") then
                        player.money+=50*(questguy(p(0)).want.motivation+1)
                        dprint "Oh, thanks. I will contact him. Here, " &50*(questguy(p(0)).want.motivation+1) &" Cr. for your services"
                        questguy(p(0)).want.given+=1
                    endif
                endif
            case qt_locofpirates,qt_locofspecial,qt_locofgarden
                if askyn("Do you want to tell him about the system at "&map(sysfrommap(t)).c.x &":"& map(sysfrommap(t)).c.y &"?(y/n)") then
                    questguy(p(0)).systemsknown(t)=1
                    if t=qt_locofpirates then
                        dprint "Thank you very much! I will avoid those coordinates from now on."
                        rew=100*(questguy(p(0)).want.motivation+1)
                    else
                        dprint "Oh! thanks! I will have a look at it!"
                        rew=50*(questguy(p(0)).want.motivation+1)
                    endif
                    player.money+=rew
                    dprint "You get "&rew &" Cr. for the information"
                    
                endif
            end select
            
        endif
        if i<0 and t=qt_megacorp then
            i=abs(i)
            if askyn("Do you want to sell your information on "&companyname(i-21) &"?(y/n)") then
                player.questflag(i)+=1
                player.money+=15000
            endif
        endif
    endif
    
    if effekt="GIVEMESSAGE" then
        if askyn("Do you want to deliver the message?(y/n)") then placeitem(makeitem(1003,p(0),questguy(p(0)).other),0,0,0,0,-1)
    endif
    
    if effekt="GIVEAUTOGRAPH" then
        placeitem(makeitem(1002,p(0)),0,0,0,0,-1)
    endif
    
    if effekt="GIVESACC" then
        placeitem(makeitem(1009,p(0)),0,0,0,0,-1)
    endif
    
    if effekt="BUYBIODATA" then
        if reward(1)>0 then
            if askyn("Do you want to sell your biodatat for "& reward(1)*p(1) & "Cr.?(y/n)") then
                player.money+=reward(1)*p(1)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then questguy(p(0)).want.given=1
                reward(1)=0
            endif
        endif
    endif
    
    if effekt="BUYANOMALY" then
        if ano_money>0 then
            if askyn("Do you want to sell your data on anomalies for "& ano_money*p(1) & "Cr.?(y/n)") then
                player.money+=ano_money*p(1)
                questguy(p(0)).want.motivation-=1
                if questguy(p(0)).want.motivation=-1 then questguy(p(0)).want.given=1
                ano_money=0
            endif
        endif
    endif
    
    if effekt="BUYWANT" then
        a=has_questguy_want(p(0),t)
        if a>1 then
            if askyn("Do you want to sell your "&item(a).desig &" to "&questguy(p(0)).n &"(y/n") then
            endif
        endif
    endif
    
    if effekt="SELLOTHER" then
        it=questguy(p(0)).want.it
        if askyn("Do you want to buy the "&it.desig &" for "&it.price*p(1) &"?(y/n)") then
            if player.money>=it.price*p(1) then
                player.money-=it.price*p(1)
                placeitem(it,0,0,0,0,-1)
            endif
        endif
    endif
    
    if effekt="EINTREIBEN" then
        placeitem(makeitem(1007,p(0),questguy(p(0)).loan),0,0,0,0,-1)
        questguy(p(0)).loan=0
    endif
    
    if effekt="ABGEBEN" then
        player.money+=item(p(0)).v2*(questguy(p(1)).want.motivation+1)/10
        destroyitem(p(0))
    endif
    
    if effekt="HAVEDRINK" then
        player.money-=2
        if player.money>=0 then
            p(1)+=1
            select case rnd_range(1,100)-questguy(p(0)).friendly*5-p(1)
            case is<=10
                questguy(p(0)).friendly+=1
                dprint "You really hit it off with "&questguy(p(0)).n &"."
            case is>=90
                questguy(p(0)).friendly-=1
                dprint "The conversation devolves into an argument."
            case else
                dprint "You have a little smalltalk, and enjoy the drink."
            end select
        else
            dprint "You don't have enough money.",14
            player.money+=2
        endif
    endif
    
    if effekt="LEARNSKILL" then 'p0=price p1=skill
        
        if player.money>=p(0) then
            a=showteam(0,0,"Learn "&talent_desig(p(1)))
            if a>=0 then
                if can_learn_skill(a,p(1))=-1 then
                    crew(a).talents(p(1))+=1
                    player.money-=p(0)
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
  
function communicate(awayteam as _monster, e as _monster,mapslot as short,li()as short,lastlocalitem as short,monslot as short) as short
    dim as short roll,a,b
    dim as byte c,o
    dim as string t
    dim it as _items
    dim p as _cords
    roll=rnd_range(1,6)+rnd_range(1,6)+player.science(0)+e.intel+addtalent(4,14,2)
    if e.lang<0 then
        if roll>9 then
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
                if findbest(23,1)<>-1 and rnd_range(1,6)+rnd_range(1,6)<2*e.intel then
                    if item(findbest(23,-1)).v1=3 then 
                        dprint "It says 'That doesnt belong to you, give it back!'"
                        e.cmmod=e.cmmod-rnd_range(1,4)
                    else
                        dprint "It says 'You have pretty things!'"
                        e.cmmod=e.cmmod+1
                    endif
                endif
                if rnd_range(1,100)>(e.intel-addtalent(4,14,1))*6 then
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
                            b=getitem
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
                if maxsecurity>0 then
                    e.hp=0
                    e.hpmax=0
                    addmember(9,0)
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
                If player.fuel>disnbase(player.c) then
                    dprint "How much do you want to charge per ton of fuel?"
                    a=getnumber(0,99,0)
                    if a>0 then
                        if rnd_range(10,50)+rnd_range(5,50)>a-awayteam.hp then
                            player.fuel=player.fuel-disnbase(player.c)
                            player.money=player.money+cint(disnbase(player.c)*a)
                            dprint "You sell fuel for "&cint(disnbase(player.c)*a) &" credits."
                            planets(mapslot).flags(0)=1
                        else
                            dprint "They decide to rather take what they want by force than pay this outragous price."
                            e.aggr=0
                            e.target=awayteam.c
                        endif
                    endif
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
                        if askyn("Do you want to swap your "&item(b).desig &" for a "&it.desig &"?(y/n)") then
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
                    if maxsecurity>0 then
                        e.hp=0
                        e.hpmax=0
                        addmember(10,0)
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
                for a=0 to rnd_range(1,6)+rnd_range(1,6)+rnd_range(1,6)+3
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
                    addmember(14,0)
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
                    addmember(15,0)
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
            a=1
            if a=1 then dprint "He says 'We are fighting pirates over the control of some ancient ruins. Do you want to help?'"
            'if a=2 then dprint "He says ''"
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
                    player.money=player.money+10000
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
        if e.aggr=0 then dprint "Not going to deal with you!"
        if e.aggr=1 then
            if askyn("I have some information on nearby star systems to sell. Do you want to buy it for 50 Cr.?(y/n)") then
                    if player.money>=50 then
                        player.money-=50
                    dprint "He hands you a data crystal"
                    for a=0 to laststar
                        if map(a).discovered=-1 then map(a).discovered=1
                    next
                else
                    dprint "Come back when you have the cash"
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
                        if player.money>=(faction(0).war(1)+faction(0).war(3))*75 then
                            player.money-=(faction(0).war(1)+faction(0).war(3))*75
                            faction(0).war(1)=0
                            faction(0).war(3)=0
                            dprint "All right, they shouldn't bother you anymore."
                        else
                            dprint "You don't have enough money"
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
    dim as byte o,l,a,b,f,add,roll,art
    dim t as string
    t="Who/Merchants/Pirates"
    if c=0 then
        o=1
    else
        o=0
    endif
    if i=0 then
        if civ(c).phil=1 then add=5
        if civ(c).phil=2 then add=3
        if civ(c).phil=3 then add=1
    else
        if civ(c).phil=1 then add=1
        if civ(c).phil=2 then add=3
        if civ(c).phil=3 then add=5
    endif
    if civ(o).contact=1 then 
        t=t &"/" & civ(o).n    
        l=4
    else
        l=3
    endif
    if findbest(23,-1,,205)>0 and civ(c).culture(4)=2 then 
        art=1
        add=add+6/civ(c).phil
    endif
    t=t & "/Exit"
    a=menu(t)
    if a<l then
        b=menu("What/Status/Declare war/Initiate peace talks/Exit")
        if a=1 then f=1
        if a=2 then f=2
        if a=3 then f=6+o
        if art>0 then dprint "The "&civ(c).n &" are obviously impressed by you bearing their artifact."
        roll=rnd_range(1,6)+rnd_range(1,6)+civ(o).contact+add
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
                        if player.shield>0 then player.shield-=1
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
                    if roll2=4 then noa=rnd_range(1,6)+rnd_range(1,6)
                    if roll2=5 then noa=rnd_range(1,3)
                    if roll2=6 then noa=rnd_range(1,2)
                    for a=1 to noa
                        en.ty=9
                        en.mem(a)=makeship(23+roll)
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
                case 91 to 100
                    dprint "Eris says 'You are buff!",15
                    a=rnd_crewmember
                    crew(a).hp-=1
                    crew(a).hpmax-=1
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
                        if player.shield<6 then player.shield+=1
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
                    gainxp(a)
                case 61 to 70
                    dprint "Eris says 'Are you sure you have enough fuel to get home?",15
                    player.fuel+=200
                case 71 to 80
                    dprint "I found this, can you use it?",15
                    findartifact(awayteam,0)
                case 81 to 90
                    dprint "Eris is worried that you might need money",15
                    player.money+=rnd_range(1,1000)
                case 91 to 100
                    dprint "Eris takes a stroll through the cargo hold.",15
                    for a=1 to 5
                        if player.cargo(a).x=1 then player.cargo(a).x=rnd_range(2,6)
                    next
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
    a=getitem()
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
            lastlocalitem=lastlocalitem+1
            item(a).w.p=nr
            item(a).w.s=0
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
        dprint "The worker hides the "&item(a).sdesc &"quickly saying 'Thank you, now if i only had a way to get off this rock'" 
        if rnd_range(1,6)<3 then e.faction=2
        return 0
    endif
     
     
     select case e.intel
        case is>6
            if rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
                dprint "The "&e.sdesc &" accepts the gift."
                e.cmmod=e.cmmod+2
                if rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then e.aggr=1
                lastlocalitem=lastlocalitem+1
                item(a).w.p=nr
                item(a).w.s=0
                li(lastlocalitem)=a
                if e.aggr=1 and rnd_range(1,6)+rnd_range(1,6)<e.intel then
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
            if item(a).ty=13 and rnd_range(1,6)+rnd_range(1,6)<e.intel+e.lang+e.aggr*2 then
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
                if rnd_range(1,6)+rnd_range(1,6)+player.science(0)>10 then
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

function plantname(ti as _tile) as string
    dim s as string
    dim a as byte
    dim pname(7) as string
    dim colors(12) as string
    dim num(5) as string
    
    num(1)="Some"
    num(2)="A few"
    num(3)="Few"
    num(4)="Numerous"
    num(5)="Many"
    
    colors(1)="black"
    colors(2)="white"
    colors(3)="red"
    colors(4)="green"
    colors(5)="blue"
    colors(6)="yellow"
    colors(7)="violet"
    colors(8)="purple"
    colors(9)="orange"
    
    pname(1)="Mosses"
    pname(2)="Ferns"
    pname(3)="Conifers"
    pname(4)="Cycads"
    pname(5)="Gnetophytes"
    pname(6)="Flowering plants"
    pname(7)="Mushrooms"
    
    s=num(rnd_range(1,5))&" interesting " &colors(rnd_range(1,9))&" "&pname(rnd_range(1,7))
    return s
end function


function randomcritterdescription(enemy as _monster, spec as short,weight as short,flies as short,byref pumod as byte,diet as byte,water as short,depth as short) as _monster

dim as string text
dim as string heads(4),eyes(4),mouths(4),necks(4),bodys(4),Legs(8),Feet(4),Arms(4),Hands(4),skin(7),wings(4),horns(4),tails(5)
dim as short a,w1,w2
dim as string species(12)
dim as short limbsbyspec(12),eyesbyspec(12)
dim as short noeyes,nolimbs,add,nolegs,noarms,armor,roll
if water=1 then
    w1=4
    w2=1
endif
if weight<=0 then weight=1
spec=spec+1
species(1)="Avian"
species(2)="Arachnide"
species(3)="Insect"
species(4)="Mammal"
species(5)="Reptile"
species(6)="Snake"
species(7)="Humanoid"
species(8)="Cephalopod"
species(9)="Centipede"
species(10)="Amphibian"
species(11)="Gastropod"
species(12)="Fish"

limbsbyspec(1)=2
limbsbyspec(2)=8
limbsbyspec(3)=6
limbsbyspec(4)=4
limbsbyspec(5)=4
limbsbyspec(6)=0
limbsbyspec(7)=2
limbsbyspec(8)=10
limbsbyspec(9)=50
limbsbyspec(10)=4
limbsbyspec(11)=0
limbsbyspec(12)=6

eyesbyspec(1)=2
eyesbyspec(2)=8
eyesbyspec(3)=4
eyesbyspec(4)=2
eyesbyspec(5)=2
eyesbyspec(6)=2
eyesbyspec(7)=2
eyesbyspec(8)=2
eyesbyspec(9)=6
eyesbyspec(10)=2
eyesbyspec(11)=2
eyesbyspec(12)=2



add=2-rnd_range(1,4)
nolimbs=rnd_range(limbsbyspec(spec),limbsbyspec(spec)+add)
if frac(nolimbs/2)<>0 then nolimbs=nolimbs+1
add=2-rnd_range(1,4)
noeyes=rnd_range(eyesbyspec(spec),eyesbyspec(spec)+add)
noeyes=noeyes-depth
if depth=0 and noeyes<2 then noeyes=2
heads(1)="round"
heads(2)="elongated"
heads(3)="cone shaped"
heads(4)="flat"

horns(1)="short horns"
horns(2)="long horns"
horns(3)="curved horns"
horns(4)="antlers"

eyes(1)="pit eyes"
eyes(2)="compound eyes"
eyes(3)="lens eyes"
eyes(4)="occeli"

mouths(1)="elongated mouth"
mouths(2)="small mouth"
mouths(3)="big mouth"
mouths(4)="trunk"

necks(1)=""
necks(2)="long"
necks(3)="short"
necks(4)="thick"

bodys(1)="wide"
bodys(2)="long"
bodys(3)="thick"
bodys(4)="thin"

arms(1)="long arms"
arms(2)="short arms"
arms(3)="thick arms"
arms(4)="tentacles"

legs(1)="thin legs"
legs(2)="short legs"
legs(3)="tubular legs"
legs(4)="tentacles"
legs(5)="broad fins"
legs(6)="long fins"
legs(7)="legs with webbed feet"
legs(8)="skin sacks for water jets"

skin(1)=" fur"
skin(2)=" scales"
skin(3)=" leathery skin"
skin(4)=" an exoskeleton"
skin(5)=" a chitin shell"
skin(6)=" feathers"
skin(7)=" scales"

wings(4)=" Skin flaps"
wings(3)=" leather wings"
wings(2)=" feathered wings"
wings(1)=" an inflatable skin sack"

tails(1)="prehensile tail"
tails(2)="short tail"
tails(3)="long tail"
tails(4)="spiked tail"
tails(5)="prehensile tail with a stinger"

text="A "&species(spec) &" with a " & heads(rnd_range(1,4)) &" head, with "
if noeyes>0 then text=text & noeyes &" "&eyes(rnd_range(1,4))
if noeyes=0 then text=text &" no eyes"
if rnd_range(1,10)<7+w2 then
    text=text & " and a " &mouths(rnd_range(1,4))
else
    text=text &", "&rnd_range(1,2)*2 &" "& horns(rnd_range(1,4)) & " and a " &mouths(rnd_range(1,4))
    enemy.weapon=enemy.weapon+1
endif
if spec<>8 then
    text=text &". A "&necks(rnd_range(1,4)) &" neck leads to a " & bodys(rnd_range(1,4)) &" body, with " 
else
    text=text &". It has a "& bodys(rnd_range(1,4)) &" body, with " 
endif    
nolegs=rnd_range(1,6)*2
if nolegs>nolimbs then 
    nolegs=nolimbs
    nolimbs=0
else
    nolimbs=nolimbs-nolegs
endif

noarms=rnd_range(1,6)
if nolimbs=0 then noarms=0
if noarms>nolimbs then noarms=nolimbs

if pumod<0 and noarms=0 then noarms=2
pumod=noarms
if noarms>0 then
    text=text & noarms &" "& arms(rnd_range(1,4)) 
else
    text=text &"no arms"
endif

if nolegs>0 then
    text=text & " and " & nolegs &" "&legs(rnd_range(1,4)+w1)
else
    text=text & " and no legs"
endif

armor=rnd_range(1,6)+w2
text=text &". Its whole body is covered in"&skin(armor)&"."
if armor=1 then enemy.col=rnd_range(204,209)
if armor=2 then 
    enemy.col=rnd_range(1,3)
    if enemy.col=1 then enemy.col=78
    if enemy.col=2 then enemy.col=114
    if enemy.col=3 then enemy.col=120
endif
if armor=3 then enemy.col=rnd_range(90,94)
if armor=4 then enemy.col=rnd_range(156,159)
if armor=5 then 
    enemy.col=rnd_range(215,217)
    enemy.armor+=1
endif
if armor=6 then 
    enemy.col=rnd_range(74,77)
    enemy.armor+=2
endif

if armor>6 then armor=6
enemy.ti_no=800+13*(spec-1)
enemy.ti_no+=(armor-1)*2

if rnd_range(1,6)<3 then
    if rnd_range(1,6)<3 then
        roll=rnd_range(1,3)
        if roll>1 then
            text=text &" It has " & roll &" "&tails(rnd_range(1,5))&"s."
        else
            text=text &" It has a "&tails(rnd_range(1,5))&"."
        endif
        enemy.weapon=enemy.weapon+1
    else
        roll=rnd_range(1,5)
        text=text &" It has a "&tails(roll)&"."
        if roll=4 then enemy.weapon=enemy.weapon+1
        if roll=5 then
            enemy.weapon=enemy.weapon+1
            enemy.atcost=enemy.atcost-0.2
        endif
    endif    
endif

text=text &" It weighs appr. "&(weight*rnd_range(1,8)*rnd_range(1,10)) &" Kg."
if flies=1 then 
    if rnd_range(1,100)<66 then 
        text= text &" It flies using "&wings(rnd_range(1,3)) &"."
    else
        text= text &" It flies using "&rnd_range(1,3) & " pairs of "&wings(rnd_range(2,4)) &"."
    endif
endif
if diet=1 then text=text &" It is a predator."
if diet=2 then 
    if rnd_range(1,100)<66 then
        text=text &" It is a herbivore."
    else
        text=text &" It is an omnivore"
    endif
endif
if diet=3 then text=text &" It is a scavenger."
enemy.ldesc=text
return enemy
end function


function give_quest(st as short, byref questroll as short) as short
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
                do
                    bay=getnextfreebay
                    if bay>0 then
                        player.cargo(bay).x=12
                        player.cargo(bay).y=st2
                        car=car-1
                    endif
                loop until getnextfreebay<0 or car=0
                if car>0 then dprint "You don't have enough room for all the cargo, and leave "&car &" tons behind."
                questroll=999
            endif
        endif
        
        if basis(st).company=4 then
            if player.questflag(10)=0 then
                m=rnd_range(2,16)
                if askyn("Omega Bioengineering's scientists want to conduct an experiment. They need a planet with a "&atmdes(m) &" atmosphere, and without plant life for that. They are willing to pay 2500 credits for the position of a possible candidate. Do you want to help in the search (y/n)?") then 
                    player.questflag(10)=m
                    questroll=999
                endif
            else 
                dprint "The company rep reminds you that you have yet to find a planet with an "&atmdes(player.questflag(10))&" atmosphere without life."
            endif
        endif
    else
        'other quests
        a=rnd_range(0,2)
        if a<>st and player.h_maxcargo>0 then
            'Deliver package
            if rnd_range(1,100)<50 or player.questflag(8)<>0 then
                if askyn("The company rep needs some cargo delivered to station "&a+1 &". He is willing to pay 500 credits. Do you accept? (y/n)" ) then
                    bay=getnextfreebay
                    if bay<=0 then 
                        if askyn("Do you want to make room for the cargo (losing "& basis(st).inv(player.cargo(1).x-1).n &")?(y/n)") then bay=1
                    endif
                    if bay>0 then
                        player.cargo(bay).x=12 'type=specialcargo
                        player.cargo(bay).y=a 'Destination
                    endif
                endif
            else
                b=rnd_range(1,16)
                if askyn("The company rep needs a "&shiptypes(b) &" hull towed to station "&a+1 &" for refits. He is willing to pay "& b*50 &" Cr. Do you accept(y/n)?") then
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
                s=getrandomsystem
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
                fleet(lastfleet).mem(1)=makeship(11)
                fleet(lastfleet).flag=5
                fleet(lastfleet).c.x=rnd_range(0,sm_x)            
                fleet(lastfleet).c.y=rnd_range(0,sm_y)            
            endif
            
            if a=3 and player.questflag(5)=2 then
                dprint "The company rep warns you that there are reports about another ship prowling space of the type you destroyed before. The company again pays 15.000 Credits if you bring it down",15
                player.questflag(6)=1
                lastfleet=lastfleet+1
                fleet(lastfleet).ty=5
                fleet(lastfleet).mem(1)=makeship(11)
                fleet(lastfleet).mem(2)=makeship(11)
                fleet(lastfleet).mem(3)=makeship(11)
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
                loadmap(14,lastplanet)
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
            
            if a=5 and player.questflag(16)>0 and player.questflag(15)=0 then'other quests
                dprint "The company rep informs you that there is a special 10000 Cr bounty for bringing down the infamous 'Anne Bonny', a pirate battleship.",15
                player.questflag(15)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(1)
            endif
            
            if a=6 and player.questflag(17)>0 and player.questflag(16)=0 then'other quests
                dprint "The company rep informs you that there is a special 8000 Cr bounty for bringing down a pirate destroyer, called 'The Black Corsair'.",15
                player.questflag(16)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(2)
            endif
            
            if a=7 and (player.questflag(18)>0 or player.questflag(19)>0) and player.questflag(17)=0 then'other quests
                dprint "The company rep informs you that there is a special 5000 Cr bounty for bringing down a pirate cruiser, called 'Hussar'.",15
                player.questflag(17)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(3)
            endif
            
            if a=8 and player.questflag(18)=0 then'other quests
                dprint "The company rep informs you that there is a special 2500 Cr bounty for bringing down a pirate fighter, called 'Adder'.",15
                player.questflag(18)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(4)
            endif
            
            if a=9 and player.questflag(19)=0 then'other quests
                dprint "The company rep informs you that there is a special 2500 Cr bounty for bringing down a pirate fighter, called 'Widow'.",15
                player.questflag(19)=1
                lastfleet=lastfleet+1
                fleet(lastfleet)=makequestfleet(5)
            endif
            
            if a=10 and player.questflag(26)=0 then
                s=getrandomsystem
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

function planetbounty() as short
    dim p as _cords
    
    if planets(specialplanet(2)).visited>0 and planets(specialplanet(2)).flags(21)=0 then
        if askyn("He's interested in the position of the ancient city you found. Do you want to sell the coordinates for 2500 Cr?(y/n)") then
            player.money=player.money+2500
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
            player.money=player.money+2500
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
            player.money=player.money+2500
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
            player.money=player.money+10000
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
            player.money=player.money+1000
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
            player.money=player.money+1000
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
            player.money=player.money+1000
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
            player.money=player.money+1000
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
            player.money=player.money+1000
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


function show_quests() as short
    dim as short a,b,c,d,sys,p
    dim dest(10) as short
    dim as string txt
    cls
    set__color( 15,0)
    txt="{15}Missions: |{11}"
    set__color( 11,0)
    for a=1 to 10
        if player.cargo(a).x=10 or player.cargo(a).x=11 then 
            b+=1
            dest(b)=player.cargo(a).y+1
        endif
    next
    if b>0 then
        set__color( 15,0)
        txt=txt & "Cargo:"
        for a=1 to b
            set__color( 11,0)
            txt=txt & "| Cargo for Station-"&dest(a)
        next
    endif
    if player.questflag(8)>0 and player.towed<0 then print " Deliver a "&shiptypes(-player.towed) &" hull to Station "&player.questflag(8)+1
    
    if player.questflag(7)>0 then 
        sys=sysfrommap(player.questflag(7))
        for d=1 to 9
            if map(sys).planets(d)=player.questflag(7) then p=d
        next
        txt=txt & "|  Map planet in orbit "&p &" in the system at "&map(sys).c.x &":"&map(sys).c.y
    endif
    if player.questflag(9)=1 then txt=txt & "|  Find a working robot factory"
    if player.questflag(10)>0 then txt=txt & "|  Find a planet without life and a "&atmdes(player.questflag(10))&" atmosphere."
    if player.questflag(11)=1 then txt=txt & "|  Find a missing company battleship"
    if player.questflag(2)=1 then txt=txt & "|  Rescue a company executive from pirates"
    if player.questflag(12)=1 then txt=txt & "|  A small green alien told you about a monster in their mushroom caves."
    if player.questflag(26)>0 then 
        sys=player.questflag(26)
        txt=txt & "| Find out what happened to an expedition last reported from "& map(sys).c.x &":"&map(sys).c.y &"."
    endif
    txt=txt & "|"
    set__color( 15,0)
    txt=txt & "|{15}Headhunting:{11}"
    set__color( 11,0)
    if player.questflag(15)=1 then txt=txt & "|  Bring down the pirate battleship 'Anne Bonny'"
    if player.questflag(16)=1 then txt=txt & "|  Bring down the pirate destroyer 'Black Corsair'"
    if player.questflag(17)=1 then txt=txt & "|  Bring down the pirate cruiser 'Hussar'"
    if player.questflag(18)=1 then txt=txt & "|  Bring down the pirate fighter 'Adder'"
    if player.questflag(19)=1 then txt=txt & "|  Bring down the pirate fighter 'Black Widow'"
    if player.questflag(5)=1 then txt=txt & "|  Bring down an unknown alien ship"
    if player.questflag(6)=1 then txt=txt & "|  Bring down an unknown alien ship"
    textbox(txt,2,2,30)
    no_key=keyin
    return 0
end function

            

function checkquestcargo(player as _ship, st as short) as _ship
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
            player.money=player.money+500
            dprint "the local representative pays you for delivering the cargo",10
        endif
        if player.cargo(a).x=12 and player.cargo(a).y=st then
            player.cargo(a).x=1
            player.cargo(a).y=0
            player.money=player.money+200
            b=b+1
        endif
    next
    if player.questflag(8)=st then
        if player.towed<0 then
            dprint "you deliver the " &shiptypes(-player.towed) &" hull and get payed "&abs(player.towed)*50 &" Cr.",10
            player.money=player.money+abs(player.towed)*50
        endif
        player.towed=0
        player.questflag(8)=0
    endif
    if undeliverable>0 then
        if askyn("The Station commander offers to buy your cargo for station "& where & " for 10 Cr per ton(y/n)") then
            for a=1 to 25
                if (player.cargo(a).x=11 or player.cargo(a).x=12) and player.cargo(a).y=where then
                    player.cargo(a).x=1
                    player.cargo(a).y=0
                    player.money=player.money+10
                endif
            next
        endif
    endif
    if b>0 then dprint "You deliver "& b &" tons of cargo for triax traders and get payed "& b*200 &" credits.",10
    return player
end function
