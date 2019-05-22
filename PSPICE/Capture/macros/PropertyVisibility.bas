SUB PropVis
  'MACROMENU Property Visibility
  'MACROKEY SHIFT+V
  'MACRODESCRIPTION Change visibility of properties

' This macro will change the visibility of User Properties for all parts on a page.
' Properties will be made visible where they have been placed in the library.
'
' ***WARNING***  If you make the same property visible more than one time,
' *** that property will be duplicated!!!  You can reverse the effects of this by
' *** making that property invisible until all occurances of it are gone.

' Sets up the drop-box choices
Dim MyList$ (2)
MyList (0) = "Visible"
MyList (1) = "Invisible"
MyList (2) = "No Change"

' Creates the dialog box
Begin Dialog Visi 0, 0, 160, 145, "Part Property Visibility Macro"
	OkButton 23, 130, 35, 13
	CancelButton 63, 130, 35, 13

	Text 10, 5, 60, 9, "PCB Footprint"
	DropListBox 90, 5, 60, 50, MyList$( ), .PCBFootprint

	Text 10, 20, 60, 9, "Part Reference"
	DropListBox 90, 20, 60, 50, MyList$( ), .PartReference

	Text 10, 35, 60, 9, "Value"
	DropListBox 90, 35, 60, 50, MyList$( ), .PartValue

	GroupBox 3, 53, 154, 70, "Custom Properties", .Group1
	TextBox 10, 70, 60, 12, .Cust1
	DropListBox 90, 70, 60, 50, MyList$( ), .Custom1

	TextBox 10, 85, 60, 12, .Cust2
	DropListBox 90, 85, 60, 50, MyList$( ), .Custom2

	TextBox 10, 100, 60, 12, .Cust3
	DropListBox 90, 100, 60, 50, MyList$( ), .Custom3

End Dialog

Dim VisiDlg As Visi  

' Set the default choice to "No Change"
VisiDlg.PCBFootprint = 2
VisiDlg.PartReference = 2
VisiDlg.PartValue = 2
VisiDlg.Custom1 = 2
VisiDlg.Custom2 = 2
VisiDlg.Custom3 = 2

' Add your own custom user-property names in place of "custom1", "custom2"
' and "custom3" to have them appear in the Custom Properties section
VisiDlg.Cust1 = "custom1"
VisiDlg.Cust2 = "custom2"
VisiDlg.cust3 = "custom3"

Button = Dialog(VisiDlg)

IF Button = -1 THEN

	FindParts "*", FALSE

' Makes the appropriate properties visible or invisible
	If VisiDlg.PCBFootprint = 0 THEN
		DisplayProperty "PCB Footprint", "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.PCBFootprint = 1 THEN
		RemoveDisplayProperty "PCB Footprint", "", 0, FALSE, FALSE, 48, 0
	END IF

	If VisiDlg.PartReference = 0 THEN
		DisplayProperty "Part Reference", "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.PartReference = 1 THEN
		RemoveDisplayProperty "Part Reference", "", 0, FALSE, FALSE, 48, 0
	END IF

	If VisiDlg.PartValue = 0 THEN
		DisplayProperty "Value", "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.PartValue = 1 THEN
		RemoveDisplayProperty "Value", "", 0, FALSE, FALSE, 48, 0
	END IF

	If VisiDlg.Custom1 = 0 THEN
		DisplayProperty VisiDlg.Cust1, "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.Custom1 = 1 THEN
		RemoveDisplayProperty VisiDlg.Cust1, "", 0, FALSE, FALSE, 48, 0
	END IF

	If VisiDlg.Custom2 = 0 THEN
		DisplayProperty VisiDlg.Cust2, "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.Custom2 = 1 THEN
		RemoveDisplayProperty VisiDlg.Cust2, "", 0, FALSE, FALSE, 48, 0
	END IF

	If VisiDlg.Custom3 = 0 THEN
		DisplayProperty VisiDlg.Cust3, "", 0, FALSE, FALSE, 48, 0
	ElseIf VisiDlg.Custom3 = 1 THEN
		RemoveDisplayProperty VisiDlg.Cust3, "", 0, FALSE, FALSE, 48, 0

	End If

END IF
END SUB
