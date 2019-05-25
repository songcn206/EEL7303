SUB TitlblockProps
  'MACROMENU Set Titleblock Properties
  'MACROKEY Ctrl+F7
  'MACRODESCRIPTION Set standard titleblock properties

Begin Dialog TitleblockProps 16, 35, 256, 132, "Place Titleblock Properties"

  Text 8, 8, 40, 8, "Title"
  TextBox 48, 8, 144, 12, .Title

  Text 8, 28, 40, 8, "Document Num"
  TextBox 48, 28, 144, 12, .DocNum

  Text 8, 48, 40, 8, "Rev Code"
  TextBox 48, 48, 144, 12, .RevCode

  Text 8, 68, 40, 8, "Cage Code"
  TextBox 48, 68, 144, 12, .CageCode

  Text 8, 88, 40, 8, "Page Count"
  TextBox 48, 88, 144, 12, .PageCount

  Text 8, 108, 40, 8, "Page Num"
  TextBox 48, 108, 144, 12, .PageNum

  OKButton 204, 24, 40, 14
  CancelButton 204, 44, 40, 14

End Dialog

'********************************
'  Show the dialog
'********************************
Dim Dlg As TitleblockProps
Status = Dialog(Dlg)

'******************************
' OK Selected -> set properties on titleblock
'******************************
IF Status = -1 THEN
  '*** set the RevCode ***
  IF Len(Dlg.RevCode) > 0 THEN
     SetProperty "RevCode", Dlg.RevCode
  END IF

  '*** set the Title ***
  IF Len(Dlg.Title) > 0 THEN
     SetProperty "Title", Dlg.Title
  END IF

  '*** set the Document Number ***
  IF Len(Dlg.DocNum) > 0 THEN
     SetProperty "Doc", Dlg.DocNum
  END IF

  ' *** Set the Cage Code ***
  IF Len(Dlg.CageCode) > 0 THEN
    SetProperty "CageCode", Dlg.CageCode
  END IF

  '*** Set the Page Number ***
  IF Len(Dlg.PageNum) > 0 THEN
     SetProperty "Page Number", Dlg.PageNum
  END IF

  '*** Set the PageCount ****
  IF Len(Dlg.PageCount) > 0 THEN
     SetProperty "Page Count", Dlg.PageCount
  END IF

END IF

END SUB
