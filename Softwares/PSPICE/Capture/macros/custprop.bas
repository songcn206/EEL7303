SUB PropAdd
  'MACROMENU Add Custom Properties
  'MACROKEY SHIFT+P
  'MACRODESCRIPTION Add Custom Properties

' This macro will change all the User to add custom Properties for all selected
' parts on a page.
'

' Creates the dialog box
Begin Dialog Visi 0, 0, 180, 145, "Custom Part Property Macro"
	OkButton 23, 130, 35, 13
	CancelButton 63, 130, 35, 13

	GroupBox 3, 13, 170, 110, "Custom Properties", .Group1
	Text 10, 30, 50, 10, "Property Name"
	Text 90, 30, 50, 10, "Value"
	TextBox 10, 40, 60, 12, .Cust1
	TextBox 90, 40, 60, 12, .Value1

	TextBox 10, 55, 60, 12, .Cust2
	TextBox 90, 55, 60, 12, .Value2

	TextBox 10, 70, 60, 12, .Cust3
	TextBox 90, 70, 60, 12, .Value3

	TextBox 10, 85, 60, 12, .Cust4
	TextBox 90, 85, 60, 12, .Value4

	TextBox 10, 100, 60, 12, .Cust5
	TextBox 90, 100, 60, 12, .Value5

End Dialog

Dim VisiDlg As Visi


Button = Dialog(VisiDlg)

IF Button = -1 THEN

	' Makes the appropriate properties visible or invisible
	IF Len(VisiDlg.Cust1) > 0 THEN
		SetProperty VisiDlg.Cust1, VisiDlg.Value1
	END IF

	IF Len(VisiDlg.Cust2) > 0 THEN
		SetProperty VisiDlg.Cust2, VisiDlg.Value2
	END IF

	IF Len(VisiDlg.cust3) > 0 THEN
		SetProperty VisiDlg.Cust3, VisiDlg.Value3
	END IF

	IF Len(VisiDlg.cust4) > 0 THEN
		SetProperty VisiDlg.Cust4, VisiDlg.Value4
	END IF

	IF Len(VisiDlg.cust5) > 0 THEN
		SetProperty VisiDlg.Cust5, VisiDlg.Value5
	END IF

END IF
END SUB
