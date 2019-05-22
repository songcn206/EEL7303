SUB PortIn
  'MACROMENU Place Input Port
  'MACROKEY CTRL+F8
  'MACRODESCRIPTION Place Input Port
DIM PortName As String
PortName = InputBox$("Enter the port name", "Place Input Port", "")
PlacePort 0.0, 0.0, "C:\PROGRAM FILES\ORCAD\CAPTURE\LIBRARY\CAPSYM.OLB", "PORTRIGHT-R", PortName
SetProperty "Type", "Input"

' ***********************************
' reposition port name display to right 
' ***********************************
DIM Size As Integer
Size = Len(PortName)
DIM Offset As Double
Offset = 0.95 - (Size/20)
SelectObject -.10, 0.0, FALSE
Drag Offset, 0.00, TRUE

END SUB
