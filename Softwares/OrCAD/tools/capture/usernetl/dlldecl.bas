Attribute VB_Name = "Declarations"
Option Explicit

Global Const SignalNameString = 0
Global Const SignalType = 1
Global Const TypeCode = 2
Global Const ReferenceString = 3
Global Const PinNumberString = 4
Global Const PinNameString = 5
Global Const PinIndex = 6
Global Const PartName = 7
Global Const ModuleName = 8
Global Const PinType = 9
Global Const NetNumber = 10
Global Const TimeStamp = 11
Global Const FieldString1 = 12
Global Const FieldString2 = 13
Global Const FieldString3 = 14
Global Const FieldString4 = 15
Global Const FieldString5 = 16
Global Const FieldString6 = 17
Global Const FieldString7 = 18
Global Const FieldString8 = 19
Global Const KeyWord = 20
Global Const PipeLine = 21
Global Const DocumentNumber = 25
Global Const DateString = 26
Global Const Revision = 27
Global Const TitleString = 28
Global Const Organization = 29
Global Const AddressLine1 = 30
Global Const AddressLine2 = 31
Global Const AddressLine3 = 32
Global Const AddressLine4 = 33
Global Const FileName = 34
Global Const PartIndex = 35
Global Const LibraryNameString = 36
Global Const LookupNameString = 37
Global Const NetType = 40
Global Const ExitType = 99

Declare Function InitNetDLL Lib "usernetl" (ByVal szSourceFileName As String, ByVal szDestFileName As String, _
    ByVal szDestFileName2 As String, ByVal hWindow As Long) As Long

Declare Sub NetDLLCleanup Lib "usernetl" ()

Declare Function CLen Lib "usernetl" (ByVal stringa As String) As Long
Declare Function SetIndexByRef Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SetNext Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SetFirst Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SortByNumber Lib "usernetl" () As Long
Declare Function StripPath Lib "usernetl" (ByVal symbol As String) As Long
Declare Function LoadFieldString Lib "usernetl" (ByVal RefDes As String) As Long

Declare Function InsertFileInPM Lib "usernetl" (ByVal FileName As String) As Long

Declare Function LoadPin Lib "usernetl" () As Long
Declare Function LoadFirstPin Lib "usernetl" () As Long
Declare Function SetSignal Lib "usernetl" () As Long
Declare Function LoadInstance Lib "usernetl" () As Long
Declare Function NextInstance Lib "usernetl" () As Long

Declare Function SetAccessType Lib "usernetl" (ByVal stringa As String) As Long

Declare Function MakeInstanceFile Lib "usernetl" () As Long
Declare Function SetTraversal Lib "usernetl" (ByVal stringa As String) As Long
Declare Function RewindInstanceFile Lib "usernetl" () As Long
Declare Function NextAccessType Lib "usernetl" () As Long
Declare Function PreviousNode Lib "usernetl" () As Long
Declare Function NextNode Lib "usernetl" () As Long
Declare Function FirstNode Lib "usernetl" () As Long
Declare Function NextNet Lib "usernetl" () As Long
Declare Function FirstNet Lib "usernetl" () As Long
Declare Function WriteInteger Lib "usernetl" (ByVal file As Long, ByVal theInt As Long) As Long

Declare Function EndNode Lib "usernetl" () As Long
Declare Function ExceptionsFor Lib "usernetl" (ByVal stringa As String, ByVal symbol As String) As Long
Declare Function ConcatFile Lib "usernetl" (ByVal filea As Long, ByVal fileb As Long) As Long

Declare Function NextPin Lib "usernetl" () As Long
Declare Function FirstPin Lib "usernetl" () As Long

Declare Function NextPipe Lib "usernetl" () As Long
Declare Function FirstPipe Lib "usernetl" () As Long
Declare Function NextKeyWord Lib "usernetl" () As Long
Declare Function IsKeyWord Lib "usernetl" () As Long
Declare Function AccessKeyWord Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SetPartIndex Lib "usernetl" (ByVal index As Long) As Long
Declare Function AccessPart Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SymbolLength Lib "usernetl" (ByVal symbolId As Long) As Long
Declare Sub WriteString Lib "usernetl" (ByVal file As Long, ByVal stringa As String)
Declare Function SetNumberWidth Lib "usernetl" (ByVal width As Long) As Long
Declare Function GetSymbolChar Lib "usernetl" (ByVal index As Long, ByVal symbol As String) As Long
Declare Function PutSymbolChar Lib "usernetl" (ByVal index As Long, ByVal ch As Long, ByVal symbol As String) As Long
Declare Function SymbolInCharSet Lib "usernetl" (ByVal symbol As String) As Long
Declare Function SetCharSet Lib "usernetl" (ByVal stringa As String) As Long
Declare Function WriteMap Lib "usernetl" (ByVal file As Long, ByVal index As Long) As Long
Declare Sub SetPinMap Lib "usernetl" (ByVal index As Long, ByVal stringa As String)
Declare Sub CopySymbol Lib "usernetl" (ByVal sourceId As Long, ByVal symbol As String)
Declare Function PadSpaces Lib "usernetl" (ByVal symbol As String, ByVal count As Long) As Long
Declare Function GetStandardSymbol Lib "usernetl" (ByVal symbolId As Long) As Long
Declare Sub WriteCrLf Lib "usernetl" (ByVal file As Long)
Declare Sub WriteSymbol Lib "usernetl" (ByVal file As Long, ByVal symbolId As Long)
Declare Sub SortNets Lib "usernetl" ()
Declare Function GetNamedPartProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetNamedNetProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetNamedPinProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetFirstPartProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetNextPartProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetFirstNetProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetNextNetProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetFirstPinProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long
Declare Function GetNextPinProperty Lib "usernetl" (ByVal PropertName As String, ByVal propvalue As String) As Long

Declare Function GetNetCount Lib "usernetl" () As Long
Declare Sub MakeNetCurrent Lib "usernetl" (ByVal nNet As Long)
Declare Function FirstNetPin Lib "usernetl" () As Long
Declare Function NextNetPin Lib "usernetl" () As Long


Global exittypeval As String

Sub SetSymbol(ByVal symbid As Integer, ByVal symbolval As String)

    If (symbid = ExitType) Then
        If (symbolval = "W") And (exittypeval <> "E") Then exittypeval = "W"
        If (symbolval = "E") Then exittypeval = "E"
        
    End If
    

End Sub


Sub Main(ByVal filenameout As String, ByVal filename2 As String)
    Rem int argc, char *argv[])
    Dim NrNets As Long
    Dim CurrentNetNumber As Long
    Dim NetPin As Long
    
    If InitNetDLL(Command, filenameout, filename2, Form1.hWnd) = 0 Then
    
        NrNets = GetNetCount()
        Call Initialize
        Call WriteHeader
        CurrentNetNumber = 0
        Do
            Call MakeNetCurrent(CurrentNetNumber)
            Call HandleNodeName
            NetPin = FirstNetPin()
            While NetPin <> 0
                Call WriteNet
                NetPin = NextNetPin()
            Wend
            
            Call WriteNetEnding
            CurrentNetNumber = CurrentNetNumber + 1
        Loop While CurrentNetNumber < NrNets
        Call WriteNetListEnd
        Call NetDLLCleanup
    End If
	
	InsertFileInPM (filenameout)
	
	Rem Added to insert file in the Open Capture PM.PCR No.575442

    If exittypeval = "E" Then MsgBox ("Netlister reported errors -- check Session Log")
    If exittypeval = "W" Then MsgBox ("Netlister reported warnings -- check Session Log")

End Sub


