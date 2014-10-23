Declare Function credits(i As Integer) As String
Declare Function cords(c As _cords) As String
Declare Function display_time(t As UInteger,form As Byte=0) As String

Function display_time(t As UInteger,form As Byte=0) As String
    Dim As UInteger d,h,m
    Dim As String ms,hs
    h=Fix(t/60)
    d=Fix(h/24)
    h=h-d*24
    m=t-h*60-d*24*60
    If h<10 Then
        hs="0"& h
    Else
        hs=""& h
    EndIf
    If m<10 Then
        ms="0"&m
    Else
        ms=""&m
    EndIf
    Select Case form
    Case 0
        If d>0 Then
            Return "Day "&d &", "& hs &":"&ms 
        Else
            Return  hs &":"&ms
        EndIf
    Case 1
        Return d &" days, "& h &" hours and "& m &" minutes"
    Case 2
        If d>0 Then
            Return d &" days"
        Else
            Return  hs &":"&ms
        EndIf
    case 3
        If d>0 Then
            Return d &" days, "& h &" hours and "& m &" minutes"
        Else
            Return  hs &":"&ms
        EndIf
    End Select
End Function

Function credits(cr As Integer) As String
    Dim As String t,r,z(12)
    Dim As Single fra,tenmillion
    Dim  As Integer b=1000000
    Dim As Byte c,l,i
    For i=0 To 12
        
    Next
    t="" &Abs(Int(cr))

    For b=1 To Len(t)
        z(b)=Mid(t,b,1)
    Next
    l=Len(t)
    t=""
    For b=1 To l
        t=t &z(b)
        If l-b=3 Or l-b=6 Or l-b=9 Or l-b=12 Then 
            t=t &","
        EndIf
    Next
    If cr<0 Then t="-"&t
    Return t
End Function

Function cords(c As _cords) As String
    Return "("&c.x &":"& c.y &")"
End Function

Function round_str(i As Double,c As Short) As String
    Dim As String t
    Dim As Single j
    Dim As Short digits
    t=""&round_nr(i,c)
    If Instr(t,".")>0 Then 
        digits=Len(t)-Instr(t,".")
    Else
        t=t &"."
    EndIf
    If digits<c Then t= t &String(c-digits,"0")
    Return t
End Function
