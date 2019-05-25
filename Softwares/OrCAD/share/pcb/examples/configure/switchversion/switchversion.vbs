' Create a short-cut to the switchversion on the desktop to 

Set oWS = WScript.CreateObject("WScript.Shell")
   strDesktop = oWS.SpecialFolders("Desktop")
   ' sLinkFile sets the short-cut name, leave the backslash 
   sLinkFile = "\SPB_16.2"
   Set oLink = oWS.CreateShortcut(strDesktop & sLinkFile & ".LNK")
   
   ' replace %CDSROOT% with absolute location of your latest switchversion
   oLink.TargetPath = "%CDSROOT%\tools\bin\switchversion.exe"
	' change this line to set the release name
   	oLink.Arguments = "-rel ""SPB 16.2"""
   	oLink.Description = "SPB16.2"
   ' next 3 lines are commented out and are not needed
   '	oLink.IconLocation = "%CDSROOT%\tools\bin\switchversion.exe, 1"
   '	oLink.WindowStyle = "1"
   '	oLink.WorkingDirectory = "C:\"
   oLink.Save

