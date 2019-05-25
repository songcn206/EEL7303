Attribute VB_Name = "Module1"
Option Explicit
Global OptionSortNets As Boolean
Global OptionP As Boolean

Sub Initialize()
    Dim Workstring As String * 255
    Dim result As Long
    Call WriteString(0, "Initializing")
    
    WriteCrLf (0)

    Call SetPinMap(0, "Input          ")
    Call SetPinMap(1, "BiDirectional  ")
    Call SetPinMap(2, "Output         ")
    Call SetPinMap(3, "Open Collector ")
    Call SetPinMap(4, "Passive        ")
    Call SetPinMap(5, "Hi-Z           ")
    Call SetPinMap(6, "Open Emitter   ")
    Call SetPinMap(7, "Power          ")

    SetCharSet ("0123456789")
    SetNumberWidth (5)

    Call WriteString(1, "Wire List")
    WriteCrLf (1)
    WriteCrLf (1)

    Call CopySymbol(TitleString, Workstring)
    result = PadSpaces(Workstring, 46)
    Call WriteString(1, Workstring)
    Call WriteString(1, "Revised: ")
    Call WriteSymbol(1, DateString)
    WriteCrLf (1)
    Call CopySymbol(DocumentNumber, Workstring)
    result = PadSpaces(Workstring, 46)
    Call WriteString(1, Workstring)
    Call WriteString(1, "Revision: ")
    Call WriteSymbol(1, Revision)
    WriteCrLf (1)
    Call WriteSymbol(1, Organization)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine1)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine2)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine3)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine4)
    WriteCrLf (1)
    WriteCrLf (1)

Rem     sw_L = 1
Rem     sw_P = SwitchIsSet("P")
Rem     sw_N = SwitchIsSet("N")
    If OptionSortNets = True Then
       SortNets
    End If
  

End Sub
Sub WriteHeader()

    Dim PartNameStr As String
    Dim ReferenceStr As String
    Dim ModuleNameStr As String
    Dim result As Long
    Dim nlen As Long
    
    PartNameStr = String(255, vbNullChar)
    ReferenceStr = String(255, vbNullChar)
    ModuleNameStr = String(255, vbNullChar)
    
    Call WriteString(1, "<<< Component List >>>")
    WriteCrLf (1)

    While (LoadInstance())
        Call CopySymbol(PartName, PartNameStr)
        result = PadSpaces(PartNameStr, 29)
        nlen = CLen(PartNameStr)
        If nlen > 29 Then
            Call WriteString(0, "WARNING: Name is too long '")
            Call WriteSymbol(0, PartName)
            Call WriteString(0, "', truncated to ")
            Call WriteString(0, PartNameStr)
            WriteCrLf (0)

            Call SetSymbol(ExitType, "W")
            
        End If
        Call WriteString(1, PartNameStr)
        Call WriteString(1, " ")

        Call CopySymbol(ReferenceString, ReferenceStr)
        result = PadSpaces(ReferenceStr, 9)
        nlen = CLen(ReferenceStr)
        If nlen > 9 Then
            Call WriteString(0, "WARNING: Reference is too long '")
            Call WriteSymbol(0, ReferenceString)
            Call WriteString(0, "', truncated to ")
            Call WriteString(0, ReferenceStr)
            WriteCrLf (0)

            Call SetSymbol(ExitType, "W")
            
        End If
        
        Call WriteString(1, ReferenceStr)
        Call WriteString(1, " ")

        
        Call CopySymbol(ModuleName, ModuleNameStr)
        nlen = CLen(ModuleNameStr)
        If nlen > 0 Then
            Call WriteString(1, ModuleNameStr)
        Else
            Call WriteString(1, PartNameStr)
        End If
        WriteCrLf (1)
    Wend

    WriteCrLf (1)
    Call WriteString(1, "<<< Wire List >>>")
    WriteCrLf (1)
    WriteCrLf (1)
    Call WriteString(1, "  NODE  REFERENCE    PIN #   PIN NAME  ")
    Call WriteString(1, "         PIN TYPE       PART VALUE")
    WriteCrLf (1)
    WriteCrLf (1)

End Sub

Sub HandleNodeName()

    Dim I As Long
    Dim result As Long

    Call WriteString(1, "[")
    Call WriteSymbol(1, NetNumber)
    Call WriteString(1, "] ")

    I = GetStandardSymbol(TypeCode)
    If I = Asc("L") Then
        Rem SetNumberWidth (1)
        Call WriteSymbol(1, SignalNameString)
        Rem /*
        Rem ** Not needed for Capture. All local labels are already uniquely named.
        Rem **
        Rem ** WriteString(1, " (")
        Rem ** if (sw_A == 0) {
        Rem **     WriteString(1, "local to sheet ")
        Rem ** }
        Rem ** WriteSymbol(1, SheetNumber)
        Rem ** WriteString(1, ")")
        Rem */

        SetNumberWidth (5)
    End If
    If I = Asc("P") Then
        Call WriteSymbol(1, SignalNameString)
    ElseIf I = Asc("S") Then
        Call WriteSymbol(1, SignalNameString)
    ElseIf I = Asc("N") Then
        Call WriteString(1, "X")
        Call WriteSymbol(1, NetNumber)
    ElseIf I = Asc("U") Then
        Call WriteString(1, "X")
        Call WriteSymbol(1, NetNumber)
    End If
    WriteCrLf (1)
End Sub

Sub WriteNet()

    Dim I As Long
    Dim result As Long
    Dim ReferenceStr As String * 255
    Dim PinNumberStr As String * 255
    Dim PinNameStr As String * 255
    Dim nlen As Long
    Rem Dim sw_p As Long

    Rem sw_p = 0
    Call WriteString(1, "        ")

    Call CopySymbol(ReferenceString, ReferenceStr)
    result = PadSpaces(ReferenceStr, 9)
    Call WriteString(1, ReferenceStr)
    Call WriteString(1, "       ")

    Rem  don't check for legal characters unless /P is set
    Call CopySymbol(PinNumberString, PinNumberStr)
    Rem If sw_p = 1 Then
    If OptionP = True Then
        I = SymbolInCharSet(PinNumberStr)
    Else
         I = 1
    End If

    If I = 0 Then
        Call WriteString(1, "        ")
    Else
        result = PadSpaces(PinNumberStr, 7)
        nlen = SymbolLength(PinNumberString)
        If nlen > 7 Then
            Call WriteString(0, "WARNING: Name is too long '")
            Call WriteSymbol(0, PinNumberString)
            Call WriteString(0, "', truncated to ")
            Call WriteString(0, PinNumberStr)
            WriteCrLf (0)
    
            Call SetSymbol(ExitType, "W")
            
        End If
        Call WriteString(1, PinNumberStr)
        Call WriteString(1, " ")
    End If
        


    Call CopySymbol(PinNameString, PinNameStr)
    result = PadSpaces(PinNameStr, 15)
    nlen = SymbolLength(PinNameString)
    If nlen > 15 Then
        Call WriteString(0, "WARNING: Name is too long '")
        Call WriteSymbol(0, PinNameString)
        Call WriteString(0, "', truncated to ")
        Call WriteString(0, PinNameStr)
        WriteCrLf (0)

        Call SetSymbol(ExitType, "W")
        
    End If
    Call WriteString(1, PinNameStr)
    Call WriteString(1, " ")

    I = GetStandardSymbol(PinType)
    result = WriteMap(1, I)

    Call WriteSymbol(1, PartName)
    WriteCrLf (1)
End Sub


Sub WriteNetEnding()
   WriteCrLf (1)
End Sub

Sub WriteNetListEnd()
    Dim result As Long
    Call WriteString(0, "Done")
    WriteCrLf (0)
End Sub
