On Error Resume Next

Set WshShell = CreateObject( "WScript.Shell" ) 
Set objFSO = CreateObject("Scripting.FileSystemObject")


ConfigFolder = objFSO.GetParentFolderName(Wscript.ScriptFullName)
ToolsFolder = objFSO.GetParentFolderName(ConfigFolder)

DotNet = chr(34) & ToolsFolder & "\capture\crystal\dotnetfx.exe" & chr(34)
VCRedist = chr(34) & ToolsFolder & "\msbase\vcredist_x86.exe" & chr(34)

'########### For Installing Dot Net 2.0 ###############
WshShell.run DotNet & " /q:a /c:"  & chr(34) & "install.exe /q" & chr(34), 0, TRUE

'########### For Installing Crystal Reports ###############
WshShell.run "msiexec.exe /i " & chr(34) & ToolsFolder & "\capture\crystal\Crystal_XII.msi" & chr(34) & " REBOOT=ReallySuppress /qn", 0, TRUE

'########### For Installing VC Redist ###############
WshShell.run VCRedist & " /q", 0, TRUE

'########### For Adding Firewall Exceptions ###########
WshShell.run ConfigFolder & "\addfirewall.vbs -quiet", 0, TRUE

'########### For Removing Interchange Key ###########
WshShell.run ConfigFolder & "\RemoveInterchange.vbs", 0, TRUE