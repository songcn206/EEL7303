

SUB PlaceBusEntryArray
  'MACROMENU PlaceBusEntryArray
  'MACROKEY CTRL+R
  'MACRODESCRIPTION Place an array of bus entries.


Begin Dialog BusEntryArray 16, 35, 256, 89, "Place BusEntry Array"
  Text 8,8,32, 8, "BusName"
  TextBox 8,20, 100, 12, .BusName
  Text 130,8,40,8, "LSB"
  TextBox 130,20,40,12, .LSB
  Text 130,40,40,8, "MSB"
  TextBox 130,52,40,12, .MSB
  GroupBox 8,40,72, 44, "BusDirection", .GroupBox1
  OptionGroup .DirectionGroup
  OptionButton 16, 52, 54, 8, "Down", .OptionDown
  OptionButton 16, 68, 54, 8, "Right", .OptionRight
  OKButton 204, 24, 40, 14
  CancelButton 204, 44, 40, 14
End Dialog

Dim BusDlg As BusEntryArray
Button = Dialog(BusDlg)
'******************************
' OK Selected
'******************************
IF Button = -1 THEN

  ' *** Get offset for bus entry placement ***
  DIM X As Double
  DIM Y As Double
  DIM EntryX As Double
  DIM EntryY As Double
  DIM EntryRotate As Integer
  DIM WireStartX As Double
  DIM WireStartY As Double
  DIM WireEndX As Double
  DIM WireEndY As Double
  IF BusDlg.DirectionGroup = 0 THEN 
    X = 0.0
    Y = 0.1
    EntryX = 0.0
    EntryY = -0.10
    EntryRotate = TRUE
    WireStartX = -0.10
    WireStartY = 0.10
    WireEndX = -0.4
    WireEndY = 0.1
  ELSE
    X = 0.1
    Y = 0.0
    EntryX = 0.0
    EntryY = 0.10
    EntryRotate = FALSE
    WireStartX = 0.0
    WireStartY = 0.0
    WireEndX = 0.0
    WireEndY = 0.4
  END IF

  DIM I As Integer
  DIM MSB As Integer
  DIM LSB As Integer
  LSB = BusDlg.LSB
  MSB = BusDlg.MSB
  FOR I = LSB TO MSB
    PlaceBus 0.0, 0.0, X, Y
    PlaceBusEntry EntryX, EntryY, EntryRotate
    PlaceWire WireStartX, WireStartY, WireEndX, WireEndY
    PlaceNetAlias  0.0, 0.0, BusDlg.BusName & Str$(I)
    ' **** Rotate the alias if placing left ****
    IF BusDlg.DirectionGroup = 1 THEN 
	UnselectAll
	SelectObject 0.05, -0.05, FALSE
	GoToRelative -0.05, 0.05
	Rotate
	Drag -0.10, 0.00, TRUE
	GoToRelative 0.10, 0.00
    END IF
    GoToRelative -WireEndX-EntryX, -WireEndY-EntryY
  NEXT I
END IF

    PlaceNetAlias  0.0, 0.0, BusDlg.BusName & "[" & Str$(LSB) & ".." & Str$(MSB) & "]"

END SUB


