SUB PortOut
  'MACROMENU Place Output Port
  'MACROKEY CTRL+F9
  'MACRODESCRIPTION Place Output Port
DIM PortName As String
PortName = InputBox$("Enter the port name", "Place Output Port", "")
PlacePort 0.0, 0.0, "C:\PROGRAM FILES\ORCAD\CAPTURE\LIBRARY\CAPSYM.OLB", "PORTLEFT-L", PortName
SetProperty "Type", "Output"
END SUB
