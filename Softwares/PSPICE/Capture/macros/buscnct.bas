SUB BusConnection
  'MACROMENU Place Bus Connections
  'MACROKEY CTRL+B
  'MACRODESCRIPTION Place bus connections (Logmatic AG). 

Begin Dialog LogmaticEntry 16, 35, 236, 89, "Logmatic AG"
	OkButton 186, 44, 40, 14
	CancelButton 186, 64, 40, 14
	Text 8, 8, 100, 8, "Bus-Name:"
	TextBox 8, 20, 100, 12, .BusName
	Text 120, 8, 40, 8, "From Bit:"
	TextBox 120, 20, 20, 12, .LByte
	Text 158, 8, 40, 8, "to Bit:"
	TextBox 158, 20, 20, 12, .HByte
	Text 200, 8, 40, 8, "Spacing:"
	TextBox 200, 20, 10, 12, .Spacing
	GroupBox 8, 40, 82, 44, "Placement of the Bus", .GroupBox1
	OptionGroup .BusConnection
	OptionButton 16, 52, 32, 8, "Left", .OptionLeft
	OptionButton 16, 68, 32, 8, "Right", .OptionRight
	OptionButton 55, 52, 32, 8, "Top", .OptionTop
	OptionButton 55, 68, 32, 8, "Bottom", .OptionBottom
	GroupBox 100, 40, 52, 44, "Bus Entries", .GroupBox2
	OptionGroup .BusEntries
	OptionButton 108, 52, 35, 8, "'/'", .OrientLeft
	OptionButton 108, 68, 35, 8, "'\'", .OrientRight
End Dialog

Dim LogDlg As LogmaticEntry
LogDlg.Spacing = 1

Button = Dialog(LogDlg)
Const MB_OK = 0
Const MB_STOP = 16

IF Button = -1 THEN
	Dim AliasX As Double
	Dim AliasY As Double
	Dim EntryX As Double
	Dim EntryY As Double
	Dim EntryRotate As Integer
	Dim AliasRotate As Integer
	Dim WireEndX As Double
	Dim WireEndY As Double
	Dim BitXOffset As Double
	Dim BitYOffset As Double
	Dim I As Integer
	DialogDef = MB_OK + MB_STOP

	If Val(LogDlg.Spacing) = 0 Then
		NU = MsgBox ("Wrong Value in Spacing",DialogDef,"Error")
		Exit Sub
	ElseIf Val(LogDlg.LByte) > Val(LogDlg.HByte) Or Val(LogDlg.Lbyte) = Val(LogDlg.HByte) Then
		NU = MsgBox ("From Bit must be smaller than to Bit",DialogDef,"Error")
		Exit Sub
	End If

	If LogDlg.BusEntries = 0 And LogDlg.BusConnection = 1 Then
		' Orientation Right and Entry /
		WireEndX = 0.4
		WireEndY = 0.0
		EntryRotate = TRUE
		AliasRotate = FALSE
		EntryX = 0.4
		EntryY = -0.1
		BitXOffset = -0.5
		BitYOffset = 0.1 + (LogDlg.Spacing / 10)
		AliasX = -0.3
		AliasY = 0.0
	ElseIf LogDlg.BusEntries = 1 And LogDlg.BusConnection = 1 Then
		' Orientation Right and Entry \
		WireEndX = 0.4
		WireEndY = 0.0
		EntryRotate = FALSE
		AliasRotate = FALSE
		EntryX = 0.4
		EntryY = 0.1
		BitXOffset = -0.5
		BitYOffset = -0.1 + (LogDlg.Spacing / 10)
		AliasX = -0.3
		AliasY = 0.0
	ElseIf LogDlg.BusEntries = 0 And LogDlg.BusConnection = 0 Then
		' Orientation Left and Entry /
		WireEndX = -0.4
		WireEndY = 0.0
		EntryRotate = TRUE
		AliasRotate = FALSE
		EntryX = -0.1
		EntryY = 0.0
		BitXOffset = 0.4
		BitYOffset = 0.0 + (LogDlg.Spacing / 10)
		AliasX = 0.1
		AliasY = 0.0
	ElseIf LogDlg.BusEntries = 1 And LogDlg.BusConnection = 0 Then
		' Orientation Left and Entry \
		WireEndX = -0.4
		WireEndY = 0.0
		EntryRotate = FALSE
		AliasRotate = FALSE
		EntryX = -0.1
		EntryY = 0.0
		BitXOffset = 0.4
		BitYOffset = 0.0 + (LogDlg.Spacing / 10)
		AliasX = 0.1
		AliasY = 0.0
	ElseIf LogDlg.BusEntries = 0 And LogDlg.BusConnection = 2 Then
		' Orientation Top and Entry /
		WireEndX = 0.0
		WireEndY = -0.4
		EntryRotate = TRUE
		AliasRotate = TRUE
		EntryX = 0.1
		EntryY = -0.4
		BitXOffset = -0.1 + (LogDlg.Spacing / 10)
		BitYOffset = 0.5
		AliasX = 0.0
		AliasY = 0.3
	ElseIf LogDlg.BusEntries = 1 And LogDlg.BusConnection = 2 Then
		' Orientation Top and Entry \
		WireEndX = 0.0
		WireEndY = -0.4
		EntryRotate = FALSE
		AliasRotate = TRUE
		EntryX = 0.0
		EntryY = -0.3
		BitXOffset = 0.0 + (LogDlg.Spacing / 10)
		BitYOffset = 0.4
		AliasX = 0.0
		AliasY = 0.3
	ElseIf LogDlg.BusEntries = 0 And LogDlg.BusConnection = 3 Then
		' Orientation Bottom and Entry /
		WireEndX = 0.0
		WireEndY = 0.4
		EntryRotate = TRUE
		AliasRotate = TRUE
		EntryX = 0.0
		EntryY = 0.1
		BitXOffset = 0.0 + (LogDlg.Spacing / 10)
		BitYOffset = -0.4
		AliasX = 0.0
		AliasY = -0.1
	ElseIf LogDlg.BusEntries = 1 And LogDlg.BusConnection = 3 Then
		' Orientation Bottom and Entry \
		WireEndX = 0.0
		WireEndY = 0.4
		EntryRotate = FALSE
		AliasRotate = TRUE
		EntryX = 0.1
		EntryY = 0.2
		BitXOffset = -0.1 + (LogDlg.Spacing / 10)
		BitYOffset = -0.5
		AliasX = 0.0
		AliasY = -0.1
	End If

	For I = LogDlg.LByte TO LogDlg.HByte
		PlaceWire 0, 0, WireEndX, WireEndY
		PlaceNetAlias AliasX, AliasY, LogDlg.BusName & Str$(I) 
		If AliasRotate = TRUE Then
			SelectObject 0.05, -0.05, FALSE
			Rotate
			GoToRelative -0.05, 0.05
		End If
		PlaceBusEntry EntryX, EntryY, EntryRotate
		GoToRelative BitXOffset, BitYOffset
	NEXT I
END IF

END SUB

