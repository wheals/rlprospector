'
' Calculate and display Highscore and post-mortem
'

function death_message() as short
    dim as string text
    dim as short b,a,wx,tx
    text=""
    
    if not fileexists(player.desig &".bmp") then screenshot(3)
    cls
    background(rnd_range(1,_last_title_pic)&".bmp")
    color 12,0
    if player.fuel<=0 then player.dead=1
    if player.dead=1 then text="You ran out of fuel. Slowly your life support fails while you wait for your end beneath the eternal stars"
    if player.dead=2 then text="The station impounds your ship for outstanding depts. You start a new career as cook at the stations bistro"
    if player.dead=3 then text="Your awayteam was obliterated. your Bones are being picked clean by alien scavengers under a strange sun"
    if player.dead=4 then text="After a few months stranded on an alien world you decide to stop sending distress signals, and try to start a colony with your crew. All works really well untill one day that really big animal shows up..."
    if player.dead=5 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by pirates"
    if player.dead=6 then text="Farewell Captain!"
    if player.dead=7 then text="You didn't think the pirates base would be the size of a city, much less a whole planet. The last thing you see is the muzzle of a pirate gaussgun pointed at you."
    'if player.dead=8 then text= "You think you can see a malicious grin beneath the leaves as the prehensile vines snap your neck"
    if player.dead=9 then text="Apollo convinces you with bare fists and lightningbolts that he in fact is a god"
    if player.dead=10 then text="The robots defending the city are old, but still very well armed and armored. Their long gone masters would have been pleased to learn how easily they repelled the intruders."
    if player.dead=11 then text="The Sandworm swallows the last of your awayteam with one gulp"
    if player.dead=12 then text="Explosions start rocking your ship as the interstellar gas starts ripping holes into the hull. You try to make a quick run out but you aren't fast enough." 
    if player.dead=13 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the merchants escort ships"
    if player.dead=14 then text="You run out of oxygen on an airless world. Your death comes quick"
    if player.dead=15 then text="With horror you watch as the ground cracks open beneath the " &player.desig &" and your ship disappears in a sea of molten lava"
    if player.dead=16 then text="Trying to cross the lava field proved to be too much for your crew"
    if player.dead=17 then text="The world around you dissolves into an orgy of flying rock, bright light and fire. Then all is black."
    if player.dead=18 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed while trying to "&space(41)&"ignore the station commanders wishes"
    if player.dead=19 then text="Your pilot crashes the ship into the asteroid. You feel very alone as you drift in your spacesuit among the debris, hoping for someone to pick up your weak distress signal."
    if player.dead=20 then text="When the monster destroys your ship your only hope is to leave the wreck in your spacesuit. With dread you watch it gobble up the debris while totally ignoring the people it just doomed to freezing among the asteroids."    
    if player.dead=21 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an ancient alien ship"
    if player.dead=22 then text="A creaking hull shows that your pilot underestimated the pressure and gravity of this gas giant. Heat rises as you fall deeper and deeper into the atmosphere with ground to hit below. Your ship gets crushed. You are long dead when it eventually gets torn apart by winds and evaporated by the rising heat."
    if player.dead=23 then text="The creatures living here tore your ship to pieces. The winds will do the same with you floating through the storms of the gas giant like a leaf in a hurricane."
    if player.dead=24 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by the" &space(41)& "strange forces inside the wormhole"
    if player.dead=25 then text="The inhabitants of the ship overpower you. Now two ships will drift through the void till the end of time."
    if player.dead=26 then text="The weapons of the Anne Bonny fire one last time before your proud ship gets turned into a cloud of hot gas."
    if player.dead=27 then text="Within seconds the refueling platform and your ship are high above you. Jetpacks won't suffice to fight against the gas giants gravity. You plunge into your fiery death."
    if player.dead=28 then text="The last thing you remember is the doctor giving you an injection. Your corpse will be disposed of."
    if player.dead=29 then text="A huge wall of light and fire appears on the horizon. Within the blink of an eye it rushes over you, dispersing your ashes in the wind."
    if player.dead=30 then text="High gravity shakes your ship. Suddenly an energy discharge out of nowhere evaporates your ship!"
    if player.dead=31 then text="Hardly damaged the unknown vessel continues it's way across the stars, ignoring the burning wreckage of your ship."
    if player.dead=32 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=33 then text="White."&space(41)&"then all black"&space(41)&"your ship got destroyed by an alien vessel"
    if player.dead=98 then 
        endstory=es_part1
        textbox (endstory,2,2,_screenx/_fw2-5)
    endif
    if player.dead=99 then text="Till next time!"
    if text<>"" then
        color 11,0
        #ifdef _windows
        gfx.font.loadttf("graphics/plasma01.ttf", TITLEFONT, 32, 128, _screeny/15)
        #endif
        b=0
        tx=_screenx/_fw1-10
        while len(text)>tx
            a=40
            do 
                a=a-1
            loop until mid(text,a,1)=" "        
            draw string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(_screeny/15)),left(text,a),,TITLEFONT,custom,@_tcol
            text=mid(text,a,(len(text)-a+1))
            b=b+1
        wend
        draw string (5*_fw1,(_lines*_fh1)/2-(4*_fh1)+b*(_screeny/15)),text,,TITLEFONT,custom,@_tcol
        
    endif
    
    no_key=""
    no_key=keyin
    if player.dead<99 then 
        if askyn("Do you want to see the last messages again?(y/n)") then messages
        highsc()
    endif

    return 0
end function


function mercper() as short
    dim as single per
    if player.tradingmoney>0 and player.money>0 then per=100*(player.tradingmoney/player.money)
    if per>100 then per=100        
    return int( per)
end function

function explper() as short
    dim as single per
    dim as integer a,b,tp,xx,yy,expl, exps,expp,total
    for a=0 to laststar
        if map(a).discovered>0 then
            exps=exps+1
            for b=1 to 9
                if map(a).planets(b)>0 then
                    tp+=1
                    if planets(map(a).planets(b)).mapstat<>0 then expp=expp+1
                    for xx=0 to 60
                        for yy=0 to 20
                            if planetmap(xx,yy,map(a).planets(b))>0 then expl=expl+1
                            total=total+1
                        next
                    next
                endif
            next
        endif
    next
    if expl>0 and total>0 then
        per=((expl/total)*100)
        if per>100 then per=100
    endif
    return int(per)
end function


sub postmortem
    dim as byte localdebug=0
    dim as short a,b,c,f
    dim as short ll,tp,exps,expp
    dim st as string
    dim per(3) as double
    dim discovered(lastspecial) as short
    dim descr(lastspecial) as string
    dim flagst(16) as string
    dim xx as short
    dim yy as short
    dim old_g as short
    dim expl as integer
    dim total as integer
    dim lines(127) as string
    dim inv(255) as _items
    dim invn(255) as short
    dim text as string
    dim as short set,lastinv    
    if _savescumming=1 then kill("savegames/"&player.desig &".sav")
    old_g=_tiles
    _tiles=1
    'count ioncanons
    for a=0 to 5
        if player.weapons(a).made=66 then b=b+1
    next
    if b>0 then 
        artflag(4)=b
        flagst(4)=b &flagst(4)
        if b>1 then flagst(4)=flagst(4) & "s"
    endif
    if player.cryo>0 then
        artflag(8)=1
        flagst(8)=player.cryo &flagst(8)
        if player.cryo>1 then flagst(8)=flagst(8)+"s"
    endif
    'count cryochambers
    st=player.h_desig
    
    cls
    locate 1,20 
    color 15,0 
    #ifdef _windows
    gfx.font.loadttf("graphics/plasma01.ttf", TITLEFONT, 32, 128, _screeny/_lines*1.5)
    #endif
    draw string (10,10), st & " " &player.desig & " MISSION SUMMARY: " &score() &" pts",,titlefont,custom,@_col
    color 11,0
    a=1+cint(textbox(moneytext,10,2,_screenx/_fw2-20,11)*_fh2/_fh1)
    b=1+cint((textbox(explorationtext ,1,2+a,(_screenx/_fw2)/2-3,11)+a+3)*_fh2/_fh1)
    c=1+cint((textbox(listartifacts ,(_screenx/_fw1)/2+1,2+a,(_screenx/_fw2)/2-2,11)+a+3)*_fh2/_fh1)
    if c>b then
        textbox(missiontype,_screenx/(_fw1*2)-15,c+1,30,15)
    else
        textbox(missiontype,_screenx/(_fw1*2)-15,b+1,30,15)
    endif
    if localdebug=1 then
        f=freefile
        open "screnstats.txt" for output as #f
        print #f,a;" ";b;" ";c;" ";_screenx/(_fw1*2)-15
        close #f
    endif
    'sleep 800,1
    if askyn("Do you want to see a list of remarkable planets you discovered?(y/n)") then
        cls
        textbox(uniques,1,2,_screeny/_fw2-2)
        
    endif
        
    if askyn("Save mission summary to file?(y/n)") then
        f=freefile
        open "data/template.html" for input as f
        ll=0
        while not eof(f)
            ll+=1
            line input #f,lines(ll)
        wend
        close f
        dprint "saving to "&player.desig &".html"
        f=freefile
        open player.desig &".html" for output as f
        for a=1 to ll
            if lcase(lines(a))="missionsummary" then lines(a)=UCASE(st & " " &player.desig & " MISSION SUMMARY: " &score() &" pts")
            if lcase(lines(a))="screenshot" then lines(a)="<img src="&chr(34)&player.desig &".bmp"&chr(34)&">"
            if lcase(lines(a))="death" then lines(a)=getdeath
            if lcase(lines(a))="endstory" then 
                lines(a)="<b>Epilogue</b><br>" &texttofile(endstory)
            endif
            if lcase(lines(a))="missiontype" then lines(a)=texttofile(missiontype)
            if lcase(lines(a))="moneytext" then lines(a)=texttofile(moneytext)
            if lcase(lines(a))="explorationtext" then lines(a)=texttofile(explorationtext)
            if lcase(lines(a))="uniques" then lines(a)=texttofile(uniques)
            if lcase(lines(a))="accomplishments" then
                lines(a)=""
                if player.science=6 then print #f,"Found and recruited the best science officer in the sector"    
                if player.gunner=6 then print #f,"Found and recruited the best gunner in the sector"
                if player.pilot=6 then print #f,"Found and recruited the best pilot in the sector";
                print #f,""
                if player.questflag(1)=4 then print #f,"Destroyed the infamous Anne Bonny."
                if player.questflag(2)=4 then print #f,"Brought the kidnappers to justice."
                if player.questflag(4)=4 then print #f,"Destroyed the Black Corsair."
                if player.questflag(5)=4 then print #f,"Managed to defeat a mysterious ship."
                if specialflag(20)=1 then print #f,,"Managed to free a colony of an opressive crystal intelligence."
                if player.questflag(3)=2 then print #f,"Secured the use of alien robot ships."
            endif
            if lcase(lines(a))="items" then
                lines(a)=""
                print #f,"<b>Equipment:</b><br>"
                lastinv=getitemlist(inv(),invn())
                for b=0 to lastinv
                    if invn(b)>1 then
                        print #f,trim(invn(b)&" "&inv(b).desigp) &"<br>"
                    else
                        print #f,trim(inv(b).desig)&"<br>"
                    endif
                next
            endif
            print #f,lines(a)
        next
        close f
        dprint "saved"
    else
        kill player.desig &".bmp"
    endif
    _tiles=old_g
end sub

sub highsc()
    
    dim highscore(11) as _table
    dim in as integer=1
    dim key as string
    dim rank as integer
    dim offset as integer
    dim off2 as integer
    dim store as _table
    dim f as integer
    dim a as integer
    dim s as integer
    dim as short xo,yo
    'open highscore table
    f=freefile
    open "highscore" for binary as f
    for a=1 to 10
        get #f,,highscore(a)
    next        
    close f
    
    'edit highscore table
    rank=1
    if player.desig<>"" then
        
        postmortem
        if player.score=0 then 
            s=score()
        else
            s=player.score
        endif
        
        for a=1 to 10
            if highscore(a).points>s then rank=rank+1
        next
        if rank<10 then
            for a=9 to rank step -1
                highscore(a+1)=highscore(a)
            next
        endif
        if rank<11 then
            highscore(rank).points=s
            highscore(rank).desig=player.desig &", "& ltrim(player.h_desig) &", " &credits(player.money) &" Cr."            
            highscore(rank).death=getdeath
        endif
    else
        rank=-1
    endif
    'display highscore table
    offset=rank
    color 11,0

    cls
    
    background(rnd_range(1,_last_title_pic)&".bmp")
    yo=(_screeny-22*_fh2)/2
    xo=(_screenx-80*_fw2)/2
    color 0,0
    for a=yo/2-_fh2 to _screeny-yo/2+_fh2 step _fh2-1
        draw string (xo,a),space(80),,font2,custom,@_col
    next
    color 15,0
    #ifdef _windows
    gfx.font.loadttf("graphics/plasma01.ttf", TITLEFONT, 32, 128, _screeny/15)
    #endif
    draw string (2*_fw2+xo,yo/2),"10 MOST SUCCESSFUL MISSIONS",,Titlefont,custom,@_col
    
    for a=1 to 10
        if a=rank then 
            color 15,0
        else
            color 11,0
        endif
        draw string (5*_fw2+xo,yo+(a*2)*_fh2), a & ".) " & trim(highscore(a+off2).desig) & ", "& highscore(a+off2).points &" pts.:",,font2,custom,@_col
        locate (a*2)+2,2 
        if a=rank then
            color 14,0
        else
            color 7,0
        endif
        draw string (2*_fw2+xo,yo+(a*2+1)*_fh2), trim(highscore(a+off2).death),,font2,custom,@_col
    next
    color 11,0
    locate 24,5,0
    if rank>10 then draw string (2*_fw2+xo,_screeny-yo), highscore(10).points &" Points required to enter highscore. you scored "&s &" Points",,font2,custom,@_col
    locate 25,20,0 
    draw string (2*_fw2+xo,_screeny-yo/2), "Esc to continue",,font2,custom,@_col
    no_key=keyin(key_esc)
    'save highscore table
    f=freefile
    
    
    'open highscore table
    in=1
    open "highscore" for binary as f
      for a=1 to 10  
        put #f,,highscore(a)
        
      next
    close f
    cls
end sub

function score() as integer
    dim s as integer
    dim a as short
    dim b as short
    dim c as short
    s=s+player.hull
    s=s+player.shieldmax
    s=s+player.money-player.piratekills
    s=s+player.turn
    s=s+player.pilot*100
    s=s+player.gunner*100
    s=s+player.science*100
    s=s+player.sensors
    s=s+player.engine
    s=s+player.fuel
    s=s+player.piratekills*1.5
    for a=0 to 5
        s=s+player.weapons(a).dam
        s=S+player.weapons(a).range
    next
    for a=0 to 30
        if map(a).discovered=1 then s=s+100
    next
    for a=0 to 255
        if planetmap(0,0,a)<>0 then
            for b=0 to 60
                for c=0 to 20
                    if planetmap(b,c,a)>0 then s=s+1
                next
            next
        endif
    next
    for a=0 to lastitem
        if item(a).w.s<0 then s=s+item(a).price\100
    next
    s=s-player.deadredshirts*100
    return s
end function

function getdeath() as string
    dim as string death,key 
    dim as short a,st
    if player.dead=1 then death="Captain forgot to refuel his spaceship"    
    if player.dead=2 then death="Captain became a cook after running out of money"
    if player.dead=3 or player.dead=25 then 
        key=left(player.killedby,1)
        if instr("AEIOU",ucase(key)) then
            player.killedby=lcase("n "&player.killedby)
        else
            player.killedby=lcase(" "&player.killedby)
        endif
        if player.dead=3 then
            if player.landed.s>0 then 
                player.killedby=player.killedby & " under "
            else
                player.killedby=player.killedby & " on "
            endif
        endif
        
        if player.dead=25 then
            for a=1 to lastdrifting
                if player.landed.s=drifting(a).m then st=drifting(a).s
            next
            death="Captain got killed by a"&player.killedby &" on a "&shiptypes(st)
        else
            death="Captain got killed by a" &player.killedby &"an unknown world"
        endif
    endif
    if player.dead=4 then death="Captain started his own Colony"
    if player.dead=5 then death="Got blasted into atoms by spacepirates"
    if player.dead=6 then death="Got sucked into a wierd Q-particle Wormhole"
    if player.dead=7 then death="Got killed in a valiant attempt to take out the pirates"
    if player.dead=8 then death="Got eaten by a plant monster"
    if player.dead=9 then death="Started the new following of apollo"
    if player.dead=10 then death="Ended as a red spot on a wall in an ancient city"
    if player.dead=11 then death="Got ripped apart by ravenous Sandworms"
    if player.dead=12 then death="Ship lost due to navigational error in gascloud"
    if player.dead=13 or player.dead=18 then death="Got blasted into atoms while trying to be a pirate"
    if player.dead=14 then death="Died of asphyxication while exploring too far"
    if player.dead=15 then death="Lost his ship while exploring a planet"
    if player.dead=16 then death="Got fried extra crispy while bathing in lava"
    if player.dead=17 then death="Dove into a sun on a doomed planet"
    if player.dead=19 then death="Underestimated the dangers of asteroid mining"
    if player.dead=20 then death="Got gobbled up by a space monster"
    if player.dead=21 then death="Got destroyed by an alien scoutship"
    if player.dead=22 then death="Suffered an accident while refueling at a gas giant"
    if player.dead=23 then death="Got eaten by gas giant inhabitants"
    if player.dead=24 then death="Lost in a worm hole"
    'player dead 25 is taken
    if player.dead=26 then death="Lost a duel against the infamous Anne Bonny"
    if player.dead=27 then death="Attempted to land on a gas giant without his spaceship"
    if player.dead=28 then death="Underestimated the risks of surgical body augmentation"
    if player.dead=29 then death="Got caught in a huge explosion"
    if player.dead=30 then death="Lost while exploring an anomaly"
    if player.dead=31 then death="Destroyed battling an ancient alien ship"
    if player.dead=32 then death="Died in battle with the "&civ(0).n 
    if player.dead=33 then death="Died in battle with the "&civ(1).n
    if player.dead=98 then death="Captain got filthy rich as a prospector"
    death=death &" after "&player.turn &" Turns"
    return death
end function
