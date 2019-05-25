Attribute VB_Name = "pcbiil"
Option Explicit
Dim signalnamestr As String * 255
Dim legal As Long
Dim new_type As Long
Dim currpin As Long
Dim pinnumberstr As String * 255

Sub Initialize()
    Dim str As String * 255
    Call WriteString(0, "Creating Netlist...")
    WriteCrLf (0)

    Call WriteString(1, "( { OrCAD/PCB II Netlist Format")
    WriteCrLf (1)
    Call CopySymbol(TitleString, str)
    Call PadSpaces(str, 46)
    Call WriteString(1, str)
    Call WriteString(1, "Revised: ")
    Call WriteSymbol(1, DateString)
    WriteCrLf (1)
    Call CopySymbol(DocumentNumber, str)
    Call PadSpaces(str, 46)
    Call WriteString(1, str)
    Call WriteString(1, "Revision: ")
    Call WriteSymbol(1, Revision)
    Call WriteCrLf(1)
    Call WriteSymbol(1, Organization)
    Call WriteCrLf(1)
    Call WriteSymbol(1, AddressLine1)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine2)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine3)
    WriteCrLf (1)
    Call WriteSymbol(1, AddressLine4)
    WriteCrLf (1)
    WriteCrLf (1)
    Call WriteString(1, "Time Stamp - }")
    WriteCrLf (1)

    SetCharSet ("~`!@#$%^&*_-+=[]|\\':/><.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    SetNumberWidth (5)

    Rem sw_L = 1


End Sub
Sub WriteHeader()

    Rem    Call CreatePartDataBase
End Sub
Sub ValidateNodeInfo()

    Call CopySymbol(SignalNameString, signalnamestr)
    
    Rem  globals type, legal, and len are set */
    new_type = GetStandardSymbol(TypeCode)
    legal = SymbolInCharSet(signalnamestr)
    If legal <> 1 Then
        new_type = Asc("N")
    End If

End Sub



Sub HandleNodeName()

    Call ValidateNodeInfo

    If legal <> 1 Then
        Rem illegal character in the node name */
        Call WriteString(0, "WARNING: Name contains illegal characters '")
        Call WriteString(0, signalnamestr)
        Call WriteString(0, "', changed to X")
        Call WriteSymbol(0, NetNumber)
        WriteCrLf (0)

        Rem Call SetSymbol(ExitType, "W")
    End If
    
End Sub
Sub WriteNet()
    Rem Call RecordNode
End Sub

Sub WriteNetEnding()

End Sub



Sub SetCurrentPinNumber()

    Dim I As Long
    Dim nlen As Long
    Dim ch As Byte


    SetCharSet ("0123456789")

    currpin = 0
    Call CopySymbol(PinNumberString, pinnumberstr)

    I = SymbolInCharSet(pinnumberstr)
    If I = 1 Then
        nlen = SymbolLength(PinNumberString)
        I = 0
        Do
            ch = GetSymbolChar(I, pinnumberstr)
            currpin = (currpin * 10) + (ch - 48)
            I = I + 1
        Loop While I < nlen
    End If

    SetCharSet ("~`!@#$%^&*_-+=[]|\\':/><.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

End Sub



Sub WriteNetListEnd()

    Dim net As Long
    Dim nlen As Long
    Dim str As String * 255
    Dim tstr As String * 255
    Dim modulenamestr As String * 255
    Dim partnamestr As String * 255
    Dim referencestr As String * 255
    Dim prevpin As Long
    
    net = 0
    SetFirst ("ALL")
    Do
        Call CopySymbol(ReferenceString, str)
        LoadFieldString (str)

        Call WriteString(1, " ( ")
        Call CopySymbol(TimeStamp, tstr)
        Rem need !!! FToUpper (tstr)
        Call WriteString(1, tstr)
        Call WriteString(1, " ")

        Call CopySymbol(ModuleName, modulenamestr)
        Call CopySymbol(PartName, partnamestr)
        Call CopySymbol(ReferenceString, referencestr)

        nlen = SymbolLength(ModuleName)
        If nlen > 0 Then
            Call WriteString(1, modulenamestr)
        Else
            Call WriteString(1, partnamestr)
        End If
        
        Call WriteString(1, " ")

        Call WriteString(1, referencestr)
        Call WriteString(1, " ")
        Call WriteString(1, partnamestr)
        WriteCrLf (1)

        prevpin = 0
        Do
            Rem write out any pins between the previous one and the current one */
            Call SetCurrentPinNumber
            prevpin = prevpin + 1
            If currpin > prevpin Then
                If currpin <> 0 Then
                    SetNumberWidth (1)

                    While currpin > prevpin
                        Call WriteString(1, "  ( ")

                        Call WriteInteger(1, prevpin)
                        Call WriteString(1, " ?")
                        net = net + 1
                        Call WriteInteger(1, net)
                        Call WriteString(1, " )")
                        WriteCrLf (1)
                        prevpin = prevpin + 1
                    Wend

                    SetNumberWidth (5)
                End If
            End If
            prevpin = currpin

            Call ValidateNodeInfo

            Call WriteString(1, "  ( ")
            Call CopySymbol(PinNumberString, pinnumberstr)
            Call WriteString(1, pinnumberstr)
            Call WriteString(1, " ")

            If new_type = Asc("L") Then
                Call WriteString(1, signalnamestr)
            ElseIf new_type = Asc("P") Then
                Call WriteString(1, signalnamestr)
            ElseIf new_type = Asc("S") Then
                Call WriteString(1, signalnamestr)
            ElseIf new_type = Asc("N") Then
                Call WriteString(1, "X")
                Call WriteSymbol(1, NetNumber)
            ElseIf new_type = Asc("U") Then
                Call WriteString(1, "?")
                net = net + 1
                SetNumberWidth (1)
                Call WriteInteger(1, net)
                SetNumberWidth (5)
            End If
            Call WriteString(1, " )")
            WriteCrLf (1)
        Loop While SetNext("NODES") = 1

        Call WriteString(1, " )")
        WriteCrLf (1)

    Loop While SetNext("ALL") = 1

    Call WriteString(1, ")")
    WriteCrLf (1)

    Call WriteString(0, "Done")
    WriteCrLf (0)
End Sub
