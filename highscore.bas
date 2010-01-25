
sub postmortem
    dim a as short
    dim b as short
    dim c as short
    dim f as short
    dim exps as short
    dim expp as short
    dim tp as short
    dim st as string
    dim per(3) as double
    dim discovered(lastspecial) as short
    dim descr(lastspecial) as string
    dim flagst(14) as string
    dim xx as short
    dim yy as short
    dim old_g as short
    dim ext as integer
    dim total as integer
    dim lines(26) as string
    dim inv(255) as _items
    dim invn(255) as short
    dim as short set,lastinv    
    kill("savegames\"&player.desig &".sav")
    flagst(1)="Fuel System"
    flagst(2)="Disintegrator"
    flagst(3)="Scanner"
    flagst(4)=" Ion canon"
    flagst(5)="Bodyarmor"
    flagst(6)="Engine"
    flagst(7)="Sensors"
    flagst(8)=" Cryochamber"
    flagst(9)="Teleportation device"
    flagst(10)=""
    flagst(11)=""
    flagst(12)="Cloaking device"
    flagst(13)="Wormhole shield"
    flagst(14)="Wormhole navigation device"
    old_g=_tiles
    _tiles=1
    'count ioncanons
    for a=0 to 5
        if player.weapons(a).desig="Disintegrator" then b=b+1
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
    
    descr(0)="A world covered in jungle"
    descr(1)="The home of an alien claiming to be a god"
    descr(2)="An alien city with working defense systems"
    descr(3)="An ancient city"
    descr(4)="Another ancient city"
    descr(5)="A world without water and huge sandworms"
    descr(6)="A world with invisible beasts"
    descr(7)="A lost scoutship"
    descr(8)="A world with very violent weather"
    descr(9)="An alien base still in good condition"
    descr(10)="An independent colony"
    descr(11)="A casino trying to cheat"
    descr(12)="A dying world"
    descr(13)="A mining station in distress"
    descr(14)="The blackmarket"
    descr(15)="A pirate gunrunner operation" 
    descr(16)="A planet with immortal beings" 
    descr(17)="A civilisation upon entering the space age"
    descr(18)="The home planet of a civilization about to explore the stars"
    descr(19)="The outpost of an advanced civilication"
    descr(20)="A creepy colony"
    descr(26)="A crystal planet"
    descr(27)="A living planet"
    descr(28)="A planet with highly hallucinogenic plant life"
    descr(29)="A very boring planet"
    descr(30)="The last outpost of an ancient race"
    descr(31)="An asteroid base of an ancient race"
    descr(32)="An asteroid base"
    descr(33)="Another asteroid base"
    descr(34)="A world devastated by war"
    descr(35)="A world of peaceful cephalopods"
    descr(36)="A tribe of small green people in trouble"
    descr(37)="An invisible labyrinth"
    descr(39)="A very fertile world plagued by burrowing monsters"
    descr(40)="A world under controll of Eridiani Explorations"
    descr(41)="A world under controll of Smith Heavy Industries"
    descr(42)="A world under controll of Triax Traders"
    descr(43)="A world under controll of Omega Bioengineering"
    descr(44)="The ruins of an ancient war"
    st=player.h_desig
    
    cls
    locate 1,20 
    color 15,0 
    print st & " " &player.desig & " MISSION SUMMARY: " &score() &" pts"
    locate 3,3
    color 11,0
    if player.money-500>0 then
        print "Made a profit of ";
        color 10,0
        print player.money-500 ;
        color 11,0
        print " credits in " &player.turn & " turns."
    endif
    if player.money-500=0 then
        print "Didnt earn any money in " &player.turn & " Turns"
    endif
    if player.money-500<0 then
        print "Made a loss of ";
        color 12,0
        print abs(player.money-500);
        color 11,0
        print " credits in " &player.turn & " turns."
    endif 
    locate 4,3
    
    if player.tradingmoney<0 then
        print "Made a loss of ";
        color 12,0
        print abs(player.tradingmoney);
        color 11,0
        print " Credits while attempting to be a merchant"
    endif
    if player.tradingmoney=0 then
        print "Didnt try to be a merchant"
    endif
    if player.tradingmoney>0 then
        print "Earned ";
        color 10,0
        print  player.tradingmoney;
        color 11,0
        print " Credits in trading goods. (";
        color 14,0
        if player.tradingmoney>0 and player.money>0 then per(1)=100*(player.tradingmoney/player.money)
        if per(1)>100 then per(1)=100        
        print int(per(1));
        color 11,0
        print "%)"
    endif
    locate 5,3
    
    if player.piratekills>0 then
        color 10,0
        print player.piratekills;
        color 11,0
        print " Credits were from bountys for destroyed pirate ships (";
        color 14,0
        if player.piratekills>0 and player.money>0 then per(2)=100*(player.piratekills/player.money)
        if per(2)>100 then per(2)=100
        print int(per(2));
        color 11,0
        print "%)"
    else
        print "No Pirates were destroyed"
    endif
    
    locate 6,3        
    if pirateplanet(0)=-1 then
        print "Destroyed the Pirates base of operation! ";
    endif
    b=0
    for a=1 to _NoPB
        if pirateplanet(a)=-1 then b=b+1
    next
    if b=0 then print
    if b=1 then 
        print "Destroyed a pirate outpost."
    endif
    if b>1 then 
        print "Destroyed " & b &" pirate outposts."
    endif
        
    if player.money-500>0 then
        locate 7,3
        if player.merchant_agr<=0 then print "Made all money with honest hard work"
        if player.merchant_agr>0 and player.pirate_agr<50 then print "Found piracy not to be worth the hassle"
        if player.pirate_agr<=0 and player.merchant_agr>50 then print "Made a name as a bloodthirsty pirate"
    endif
    
    
    for a=0 to laststar
        if map(a).discovered>0 then
            exps=exps+1
            for b=1 to 9
                if map(a).planets(b)>0 then
                    tp+=1
                    if planetmap(0,0,map(a).planets(b))<>0 then expp=expp+1
                    for xx=0 to 60
                        for yy=0 to 20
                            if planetmap(xx,yy,map(a).planets(b))>0 then ext=ext+1
                            total=total+1
                        next
                    next
                endif
            next
        endif
    next
    for c=0 to lastspecial
        if specialplanet(c)>=0 and specialplanet(c)<=lastspecial then
            if planets(specialplanet(c)).visited<>0 then discovered(c)=1         
        endif
    next
    locate 8,3
    print "Discovered " & exps & " Systems and mapped " & expp & " of " &tp &" Planets. (";
    color 14,0
    if ext>0 and total>0 then
        per(3)=((ext/total)*100)
        if per(3)>100 then per(3)=100
        print int(per(3)) &"%";
    endif
    color 11,0
    print ") ";
    print "Defeated ";
    if player.alienkills=0 then print "no Aliens"
    if player.alienkills=1 then print player.alienkills &" Alien."
    if player.alienkills>1 then print player.alienkills &" Aliens."
    locate 9,3
    if player.deadredshirts=0 then 
        print "No casualties among the crew."
    else
        print player.deadredshirts &" casualties among the crew."
    endif
    locate 11,3
    print "Discovered";
    b=0
    for a=0 to 25
        if discovered(a)=1 then b=b+1
    next
    color 11,0
    if b=0 then 
        locate 12,15
        print " no remarkable planets."
    endif
    if b>0 then
        locate 12,15
        print b &" remarkable planets."
    endif
    c=0
    color 11,0
    locate 11,58
    print "Alien Artifacts:"
    color 14,0
    for a=1 to 9
        if artflag(a)>0 then
            c=c+1
            locate 11+c,58
            print flagst(a)
        endif
    next
    if c=0 then
        locate 13,59
        print "None"
    endif
    if c>b then
        locate c+15,0
    else
        locate b+15,0
    endif
    per(0)=100-per(1)-per(2)
    print
    color 11,0
    print "Mission type: ";
    color 14,0
    if player.pirate_agr<=0 and player.merchant_agr>50 then 
        print "Bloodthristy pirate scum!"
    else
        if per(0)>per(1) and per(0)>per(2) then print "Explorer"
        if per(1)>per(2) and per(1)>per(0) then print "Merchant"
        if per(2)>per(0) and per(2)>per(1) then print "Pirate Killer"
    endif
    'sleep 800,1
    for a=1 to 25
        for b=1 to 80
            lines(a)=lines(a) &chr(screen(a,b))
        next
    next
    if askyn("Do you want to see a list of unique planets you discovered?(y/n)") then
        cls
        b=0
        c=0
        x=1
        y=2
        color 15,0
        print "Remarkable Planets:"
        print ""
        for a=0 to lastspecial
            if discovered(a)=1 then
               locate y,x
               if isgasgiant(specialplanet(a))=0 then
                    color 14,0
                    b=b+1    
                    if a<>20 then
                        print #f,descr(a)
                    else
                        if specialflag(a)=1 then 
                            print "A colony under the control of an alien lifeform"
                        else
                            print descr(20)
                        endif
                    endif
               else
                    c=c+1
               endif
               y=y+1
               if y>lastspecial/2 then
                   y=2
                   x=40
                endif
            endif
        next
        if c>0 then
            y=y+1
            if y>lastspecial/2 then
                   y=2
                   x=40
            endif
            locate y,x
            if c=1 then
                print "A refuel platform of an ancient civilication"
            else
                print c &" refuel platforms of an ancient civilication"
            endif
            b=b+1
        endif
    endif
        
    if askyn("Save mission summary to file?(y/n)") then
        
        f=freefile
        open player.desig &".txt" for output as f
        dprint "saving to "&player.desig &".txt"
        for b=1 to 25
            lines(b)=rtrim(lines(b))
            lines(b+1)=rtrim(lines(b+1))
            if lines(b)<>"" then print #f,lines(b)
            if lines(b)="" and lines(b+1)<>"" then print #f,lines(b)
        next
        cls
        shipstatus(1)
        for a=1 to 25
            lines(a)=""
            for b=1 to 80
                lines(a)=lines(a) &chr(screen(a,b))
            next
        next
        for b=1 to 25
            lines(b)=rtrim(lines(b))
            lines(b+1)=rtrim(lines(b+1))
            if lines(b)<>"" then print #f,lines(b)
            if lines(b)="" and lines(b+1)<>"" then print #f,lines(b)
        next
    b=0
    c=0
    print #f,""
    print #f,"Remarkable Planets:"
    print #f,""
    for a=0 to lastspecial
        if discovered(a)=1 then
            if isgasgiant(specialplanet(a))=0 then
                color 14,0
                b=b+1    
                locate 12+b,5
                if a<>20 then
                    print #f,descr(a)
                else
                    if specialflag(a)=1 then 
                    print #f,"A planet under the control of an alien lifeform"
                    else
                        print #f,descr(20)
                    endif
                endif
            else
                c=c+1
            endif            
        endif
    next
    if c>0 then
        b=b+1
        locate 14+b,5
        if c=1 then 
            print #f,"A refuel platform of an ancient civilication"
        else
             print #f,c &" refuel platforms of an ancient civilication"
        endif
    endif
        print #f,""
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
        print #f,""
        print #f,getdeath
        print #f,""
        print #f,"Equipment:"
        
        lastinv=getitemlist(inv(),invn())
        for a=0 to lastinv
            color 11,0
            locate 2+a,53
            if invn(a)>1 then
                print #f,trim(invn(a)&" "&inv(a).desigp)
            else
                print #f,trim(inv(a).desig)
            endif
        next
        print #f,""
        print #f,"End mission summary"
        dprint "saved"
        close f
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
            highscore(rank).desig=player.desig &", "& ltrim(player.h_desig) &", " &player.money &" Cr."            
            highscore(rank).death=getdeath
        endif
    else
        rank=-1
    endif
    'display highscore table
    offset=rank
    color 11,0

    cls
    color 15,0
    locate 1,20 
    print "MOST SUCCESSFUL MISSIONS"
    
    for a=1 to 10
        locate (a*2)+1,5
        if a=rank then 
            color 15,0
        else
            color 11,0
        endif
        print a & ".) " & highscore(a+off2).desig & ", "& highscore(a+off2).points &" pts.:"
        locate (a*2)+2,2 
        if a=rank then
            color 14,0
        else
            color 7,0
        endif
        print highscore(a+off2).death
    next
    color 11,0
    locate 24,5,0
    if rank>10 then print highscore(10).points &" Points required to enter highscore. you scored "&s &" Points"
    locate 25,20,0 
    print "Esc to continue";
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
            for a=0 to lastdrifting
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
    if player.dead=17 then death="Dived into a sun on a doomed planet"
    if player.dead=19 then death="Underestimated the dangers of asteroid mining"
    if player.dead=20 then death="Got gobbled up by a space monster"
    if player.dead=21 then death="Got destroyed by an alien scoutship"
    if player.dead=22 then death="Sufferd a accident while refueling at a gas giant"
    if player.dead=23 then death="Got eaten by gas giant inhabitants"
    if player.dead=24 then death="Lost in a worm hole"
    'player dead 25 is taken
    if player.dead=26 then death="Lost a duel against the infamous Anne Bonny"
    if player.dead=27 then death="Attempted to land on a gas giant without his spaceship"
    if player.dead=28 then death="Underestimated the risks of surgical body augmentation"
    if player.dead=29 then death="Got caught in a huge explosion"
    if player.dead=98 then death="Captain got filthy rich as a prospector"
    death=death &" after "&player.turn &" Turns"
    return death
end function
