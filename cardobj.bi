/'****************************************************************************
*
* Name: cardobj.bi
*
* Synopsis: Card object file.
*           
*
* Description: The card object handles all the displaying of the cards as well
*              defining the card numbers, suits and values.               
*              
*               
*
* Copyright 2010, Richard D. Clark
*
*                          The Wide Open License (WOL)
*
* Permission to use, copy, modify, distribute and sell this software and its
* documentation for any purpose is hereby granted without fee, provided that
* the above copyright notice and this license appear in all source copies. 
* THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF
* ANY KIND. See http://www.dspguru.com/wol.htm for more information.
*
*****************************************************************************'/
Namespace cards

'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
   #Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf

Const pGray = RGB(128, 128, 128)
Const pWhite = RGB(255, 255, 255)
Const cardobjver = "0.1.3"

'' A function that creates an image buffer with the same
'' dimensions as a BMP image, and loads a file into it.
'' Code by counting_pine
Function bmp_load( ByRef filename As String ) As Any Ptr
	Dim As Integer filenum,bmpwidth,bmpheight
  	Dim As Any Ptr img

   '' open BMP file
   filenum = FreeFile()
   If Open( filename For Binary Access Read As #filenum ) <> 0 Then 
   	Return NULL
   Else
   	'' retrieve BMP dimensions
      Get #filenum, 19, bmpwidth
      Get #filenum, 23, bmpheight
    	Close #filenum
   	'' create image with BMP dimensions
    img = ImageCreate( bmpwidth, Abs(bmpheight) )
   	If img = NULL Then 
        color rgb(255,255,255),rgb(0,0,0)
        print "Error imagecreate"
   		Return NULL
   	Else
   		'' load BMP file into image buffer
   		If BLoad( filename, img ) <> 0 Then 
    			color rgb(255,255,255),rgb(0,0,0)
                print BLoad( filename, img )
                ImageDestroy( img )
    			print "Error loading image"
                Return NULL
    		Else
    			Return img
    		EndIf
   	EndIf
   EndIf
End Function

'Returns a random integer range.
Function Rand(lowerbound As Integer, upperbound As Integer) As Integer
	Return Int((upperbound - lowerbound + 1) * Rnd + lowerbound)
End Function


'Card back ids.
Enum cardback
   bNone = 0
   bRed
   bBlue
   bPink 
End Enum

'Plcaeholder ids.
Enum cardplace
   pNone = 0
   pGreen
   pRed
End Enum

'Card ids
Enum cardid
   cNone = 0
   cClubAce
   cClubTwo
   cClubThree
   cClubFour
   cClubFive
   cClubSix
   cClubSeven
   cClubEight
   cClubNine
   cClubTen
   cClubJack
   cClubQueen
   cClubKing
   cDiamAce
   cDiamTwo
   cDiamThree
   cDiamFour
   cDiamFive
   cDiamSix
   cDiamSeven
   cDiamEight
   cDiamNine
   cDiamTen
   cDiamJack
   cDiamQueen
   cDiamKing
   cHearAce
   cHearTwo
   cHearThree
   cHearFour
   cHearFive
   cHearSix
   cHearSeven
   cHearEight
   cHearNine
   cHearTen
   cHearJack
   cHearQueen
   cHearKing
   cSpadAce
   cSpadTwo
   cSpadThree
   cSpadFour
   cSpadFive
   cSpadSix
   cSpadSeven
   cSpadEight
   cSpadNine
   cSpadTen
   cSpadJack
   cSpadQueen
   cSpadKing
End Enum

'Card Suits
Enum cardsuit
   sNone = 0
   sClub
   sDiamond
   sHeart
   sSpade
End Enum

'Card face
Enum cardface
   fNone = 0
   fAce
   fTwo
   fThree
   fFour
   fFive
   fSix
   fSeven
   fEight
   fNine
   fTen
   fJack
   fQueen
   fKing
End Enum

'Card object.
Type cardobj
	Private:
	_cards As Any Ptr
	_cardwidth As Integer
	_cardheight As Integer
    _cardval (cClubAce To cSpadKing) As Integer
	Declare Sub _ClearCards ()
	Public:
	Declare Constructor ()
	Declare Destructor ()
	Declare Property CardWidth() As Integer
	Declare Property CardHeight() As Integer
	Declare property SetCardValue (cid As cardid, cv As Integer)
	Declare Sub DrawCardBack (x As Integer, y As Integer, cb As cardback)
	Declare Sub DrawCardFront (x As Integer, y As Integer, cid As short)
	Declare Sub DrawPlaceholder (x As Integer, y As Integer, border As UInteger = pWhite, backg As UInteger = pGray)
	Declare Sub DrawPlaceholder (x As Integer, y As Integer, pl As cardplace)
	Declare Sub ClearCards ()
	Declare Sub Shuffle (d() As cardid)
	Declare Function Version () As String
	Declare Function LoadCards (cardfront As String) As Integer
	Declare Function CSuit (cid As integer) As integer
	Declare Function CFace (cid As cardid) As cardface
	Declare Function CRank (cid As cardid) As Integer
	Declare Function CValue (cid As cardid) As Integer
	Declare Function FacesEqual(c1 As cardid, c2 As cardid) As Integer
	Declare Function SuitsEqual(c1 As cardid, c2 As cardid) As Integer
	Declare Function RankEqual(c1 As cardid, c2 As cardid) As Integer
	Declare Function FaceofCard (cid As cardid) As String
	Declare Function FaceString (cf As cardface) As String
	Declare Function SuitofCard (cid As cardid) As String
	Declare Function SuitString (cs As cardsuit) As String
End Type

'Clear card images.
Sub cardobj._ClearCards ()
	If _cards <> NULL Then
		ImageDestroy _cards
	EndIf
	_cards = NULL
End Sub

'Set the image pointers to null.
Constructor cardobj ()
	_cards = NULL
	_cardwidth = 43
	_cardheight = 64
	For i As Integer = cClubAce To cSpadking
	   _cardVal(i) = CRank(i)
	Next
End Constructor

'Release the card images.
Destructor cardobj ()
   _ClearCards
End Destructor

'Returns the width of card graphic.
Property cardobj.CardWidth() As Integer
   Return _cardwidth
End Property

'Returns the height of card graphic.
Property cardobj.CardHeight() As Integer
   Return _cardheight
End Property

'Sets the value of card cid to value cv.
Property cardobj.SetCardValue (cid As cardid, cv As Integer)
   If cid >= LBound(_cardval) And cid <= UBound(_cardval) Then
      _cardval(cid) = cv
   EndIf
End Property

'Returns the version number.
Function cardobj.Version () As String
   Return cardobjver
End Function

'Draws the card backs.
Sub cardobj.DrawCardBack (x As Integer, y As Integer, cb As cardback)
	Dim tp As Any Ptr = ImageCreate(_cardwidth, _cardheight)
   Dim As Integer x1, y1, x2, y2 
   
	If (_cards <> NULL) And (tp <> NULL) Then
		Select Case cb
		   Case bRed
		      x1 = _cardwidth * 2: x2 = x1 + (_cardwidth - 1)
		      y1 = _cardheight * 4: y2 = y1 + (_cardHeight - 1)
				Get _cards, (x1, y1) - (x2, y2), tp
				Put (x, y), tp, Trans
		   Case bBlue
		      x1 = _cardwidth * 3: x2 = x1 + (_cardwidth - 1)
		      y1 = _cardheight * 4: y2 = y1 + (_cardHeight - 1)
				Get _cards, (x1, y1) - (x2, y2), tp
				Put (x, y), tp, Trans
		   Case bPink
		      x1 = _cardwidth * 4: x2 = x1 + (_cardwidth - 1)
		      y1 = _cardheight * 4: y2 = y1 + (_cardHeight - 1)
				Get _cards, (x1, y1) - (x2, y2), tp
				Put (x, y), tp, Trans
		End Select
	End If
	If tp <> NULL Then
	   'Deallocate temp image.
	   ImageDestroy tp
	End If
End Sub

'Draws the card fronts.
Sub cardobj.DrawCardFront (x As Integer, y As Integer, cid As short)
	Dim tp As Any Ptr = ImageCreate(_cardwidth, _cardheight)
   Dim As Integer x1, y1, x2, y2
   dim as short x3,y3,i
    for y3=0 to 3
        for x3=0 to 12
            i+=1
            if i=cid then
                x1=_cardwidth*x3
                y1=_cardheight*y3
                x2=x1+_cardwidth-1
                y2=y1+_cardheight-1
                get _cards,(x1,y1)-(x2,y2),tp
                put (x,y),tp,trans
            endif
        next
    next
'    
'	If (_cards <> NULL) And (tp <> NULL) Then
'		Select Case cid
'		   Case cClubAce
'		      x1 = _cardwidth * 0: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubTwo
'		      x1 = _cardwidth * 1: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubThree
'		      x1 = _cardwidth * 2: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubFour
'		      x1 = _cardwidth * 3: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubFive
'		      x1 = _cardwidth * 4: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubSix
'		      x1 = _cardwidth * 5: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubSeven
'		      x1 = _cardwidth * 6: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubEight
'		      x1 = _cardwidth * 7: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubNine
'		      x1 = _cardwidth * 8: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubTen
'		      x1 = _cardwidth * 9: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubJack
'		      x1 = _cardwidth * 10: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubQueen
'		      x1 = _cardwidth * 11: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cClubKing
'		      x1 = _cardwidth * 12: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 0: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamAce
'		      x1 = _cardwidth * 0: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamTwo
'		      x1 = _cardwidth * 1: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamThree
'		      x1 = _cardwidth * 2: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamFour
'		      x1 = _cardwidth * 3: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamFive
'		      x1 = _cardwidth * 4: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamSix
'		      x1 = _cardwidth * 5: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamSeven
'		      x1 = _cardwidth * 6: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamEight
'		      x1 = _cardwidth * 7: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamNine
'		      x1 = _cardwidth * 8: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamTen
'		      x1 = _cardwidth * 9: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamJack
'		      x1 = _cardwidth * 10: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamQueen
'		      x1 = _cardwidth * 11: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cDiamKing
'		      x1 = _cardwidth * 12: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 1: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearAce
'		      x1 = _cardwidth * 0: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearTwo
'		      x1 = _cardwidth * 1: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearThree
'		      x1 = _cardwidth * 2: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearFour
'		      x1 = _cardwidth * 3: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearFive
'		      x1 = _cardwidth * 4: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearSix
'		      x1 = _cardwidth * 5: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearSeven
'		      x1 = _cardwidth * 6: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearEight
'		      x1 = _cardwidth * 7: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearNine
'		      x1 = _cardwidth * 8: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearTen
'		      x1 = _cardwidth * 9: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearJack
'		      x1 = _cardwidth * 10: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearQueen
'		      x1 = _cardwidth * 11: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cHearKing
'		      x1 = _cardwidth * 12: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 2: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadAce
'		      x1 = _cardwidth * 0: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadTwo
'		      x1 = _cardwidth * 1: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadThree
'		      x1 = _cardwidth * 2: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadFour
'		      x1 = _cardwidth * 3: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadFive
'		      x1 = _cardwidth * 4: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadSix
'		      x1 = _cardwidth * 5: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadSeven
'		      x1 = _cardwidth * 6: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadEight
'		      x1 = _cardwidth * 7: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadNine
'		      x1 = _cardwidth * 8: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadTen
'		      x1 = _cardwidth * 9: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadJack
'		      x1 = _cardwidth * 10: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadQueen
'		      x1 = _cardwidth * 11: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		   Case cSpadKing
'		      x1 = _cardwidth * 12: x2 = x1 + (_cardwidth - 1)
'		      y1 = _cardheight * 3: y2 = y1 + (_cardHeight - 1)
'				Get _cards, (x1, y1) - (x2, y2), tp
'				Put (x, y), tp, Trans
'		End Select
'	End If
	If tp <> NULL Then
	   'Deallocate temp image.
	   ImageDestroy tp
	End If
End Sub

'Draws a placeholder for the cards.
Sub cardobj.DrawPlaceholder (x As Integer, y As Integer, border As UInteger = pWhite, backg As UInteger = pGray)
   'Draw the background.
   Line (x + 1, y + 1)-(x + (_cardwidth - 2), y + (_cardheight - 2)), backg, BF
   Line (x + 1, y + 1)-(x + (_cardwidth - 2), y + (_cardheight - 2)), border, B
End Sub

'Draws a graphic placeholder.
Sub cardobj.DrawPlaceholder (x As Integer, y As Integer, pl As cardplace)
	Dim tp As Any Ptr = ImageCreate(_cardwidth, _cardheight)
   Dim As Integer x1, y1, x2, y2 
   
	If (_cards <> NULL) And (tp <> NULL) Then
		Select Case pl
		   Case pGreen
		      x1 = _cardwidth * 5: x2 = x1 + (_cardwidth - 1)
		      y1 = _cardheight * 4: y2 = y1 + (_cardHeight - 1)
				Get _cards, (x1, y1) - (x2, y2), tp
				Put (x, y), tp, Trans
		   Case pRed
		      x1 = _cardwidth * 6: x2 = x1 + (_cardwidth - 1)
		      y1 = _cardheight * 4: y2 = y1 + (_cardHeight - 1)
				Get _cards, (x1, y1) - (x2, y2), tp
				Put (x, y), tp, Trans
		End Select
	End If
	If tp <> NULL Then
	   'Deallocate temp image.
	   ImageDestroy tp
	End If
End Sub

'Deallocates images.
Sub cardobj.ClearCards ()
   _ClearCards
End Sub

'Shuffle cards using Fisher-Yates algorithm.
Sub cardobj.Shuffle (d() As cardid)
   Dim As Integer dlow, dhigh, idx
   
   'Shuffle deck.
   dlow = 1
   dhigh = UBound(d)
   For i As Integer = dhigh To dlow Step - 1
      idx = Rand(dlow, i)
      Swap d(idx), d(i)
   Next
   
End Sub

'Load the card images.
Function cardobj.LoadCards (cards As String) As Integer
	Dim ret As Integer = TRUE
	
   If Len(cards) > 0 Then
	   _cards = bmp_load(cards)
	   If _cards = NULL Then
		   ret = FALSE
	   EndIf
   End If
   
	Return ret
End Function

'Returns the suit of the card based on the card id.
Function cardobj.CSuit (cid As integer) As integer
   Dim ret As cardsuit = sNone

   Select Case cid
      Case 1 To 13
         ret = sClub
      Case 14 To 26
         ret = sDiamond 
      Case 27 To 39
         ret = sHeart 
      Case 40 To 52
         ret = sSpade
   End Select
   
   Return ret
End Function
	
'Returns the face of the card based on the card id.
Function cardobj.CFace (cid As cardid) As cardface
   Dim ret As cardface = fNone
   
   Select Case cid
      Case cClubAce, cDiamAce, cHearAce, cSpadAce
         ret = fAce
      Case cClubTwo, cDiamTwo, cHearTwo, cSpadTwo
         ret = fTwo
      Case cClubThree, cDiamThree, cHearThree, cSpadThree
         ret = fThree
      Case cClubFour, cDiamFour, cHearFour, cSpadFour   
         ret = fFour
      Case cClubFive, cDiamFive, cHearFive, cSpadFive
         ret = fFive
      Case cClubSix, cDiamSix, cHearSix, cSpadSix
         ret = fSix
      Case cClubSeven, cDiamSeven, cHearSeven, cSpadSeven
         ret = fSeven
      Case cClubEight, cDiamEight, cHearEight, cSpadEight
         ret = fEight
      Case cClubNine, cDiamNine, cHearNine, cSpadNine
         ret = fNine
      Case cClubTen, cDiamTen, cHearTen, cSpadTen
         ret = fTen
      Case cClubJack, cDiamJack, cHearJack, cSpadJack
         ret = fJack
      Case cClubQueen, cDiamQueen, cHearQueen, cSpadQueen
         ret = fQueen
      Case cClubKing, cDiamKing, cHearKing, cSpadKing
         ret = fKing
   End Select
   
   Return ret
End Function

'Returns the rank value of the card based on the card id.
Function cardobj.CRank (cid As cardid) As Integer
   Dim ret As Integer = 0
   
   Select Case As Const cid
      Case cClubAce, cDiamAce, cHearAce, cSpadAce
         ret = 1
      Case cClubTwo, cDiamTwo, cHearTwo, cSpadTwo
         ret = 2
      Case cClubThree, cDiamThree, cHearThree, cSpadThree
         ret = 3
      Case cClubFour, cDiamFour, cHearFour, cSpadFour   
         ret = 4
      Case cClubFive, cDiamFive, cHearFive, cSpadFive
         ret = 5
      Case cClubSix, cDiamSix, cHearSix, cSpadSix
         ret = 6
      Case cClubSeven, cDiamSeven, cHearSeven, cSpadSeven
         ret = 7
      Case cClubEight, cDiamEight, cHearEight, cSpadEight
         ret = 8
      Case cClubNine, cDiamNine, cHearNine, cSpadNine
         ret = 9
      Case cClubTen, cDiamTen, cHearTen, cSpadTen
         ret = 10
      Case cClubJack, cDiamJack, cHearJack, cSpadJack
         ret = 11
      Case cClubQueen, cDiamQueen, cHearQueen, cSpadQueen
         ret = 12
      Case cClubKing, cDiamKing, cHearKing, cSpadKing
         ret = 13
   End Select
   
   Return ret
End Function

'Returns the point valie of a card.
Function cardobj.CValue (cid As cardid) As Integer
   Dim ret As Integer = cNone
   
   If cid >= LBound(_cardval) And cid <= UBound(_cardval) Then
      ret = _cardval(cid)
   EndIf
   
   Return ret
End Function

'Returns true if card1 has the same face value as card2.
Function cardobj.FacesEqual(c1 As cardid, c2 As cardid) As Integer
   Return (cFace(c1) = cFace(c2))
End Function

'Returns true if card1 has the same suit as card2.
Function cardobj.SuitsEqual(c1 As cardid, c2 As cardid) As Integer
   Return (cSuit(c1) = cSuit(c2))
End Function

'Returns true if card1 has the same suit as card2.
Function cardobj.RankEqual(c1 As cardid, c2 As cardid) As Integer
   Return (cRank(c1) = cRank(c2))
End Function

'Returns the face name if the face id.
Function cardobj.FaceString (cf As cardface) As String
   Dim ret As String = ""

   Select Case cf
      Case fAce
         ret = "Ace"
      Case fTwo
         ret = "Two"
      Case fThree
         ret = "Three"
      Case fFour
         ret = "Four"
      Case fFive
         ret = "Five"
      Case fSix
         ret = "Six"
      Case fSeven
         ret = "Seven"
      Case fEight
         ret = "Eight"
      Case fNine
         ret = "Nine"
      Case fTen
         ret = "Ten"
      Case fJack
         ret = "Jack"
      Case fQueen
         ret = "Queen"
      Case fKing
         ret = "King"
    End Select
   
   Return ret
End Function

'Returns the face of a card as s string.
Function cardobj.FaceofCard (cid As cardid) As String
   Dim ret As String = ""
   Dim fid As cardface

   fid = CFace(cid)
   ret = FaceString(fid)
   
   Return ret
End Function

'Returns the suit as a string.
Function cardobj.SuitString (cs As cardsuit) As String
   Dim ret As String = ""
   
   Select Case cs
      Case sClub
         ret = "C"
      Case sDiamond
         ret = "D"
      Case sHeart
         ret = "H"
      Case sSpade
         ret = "S"
   End Select
   
   Return ret
End Function

'Returns the suit of a card as a string.
Function cardobj.SuitofCard (cid As cardid) As String
   Dim ret As String = ""
   Dim sid As cardsuit

   sid = CSuit(cid)
   ret = SuitString(sid)
   
   Return ret
End Function


End Namespace

