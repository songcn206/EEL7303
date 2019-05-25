On Error Resume Next

Set args = WScript.Arguments

quiet = args.Item(0)

'Set WshShell = CreateObject( "WScript.Shell" ) 
set wShell=CreateObject("Wscript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

Set SystemSet = GetObject("winmgmts:").InstancesOf ("Win32_OperatingSystem")
for each System in SystemSet
	version = System.Version
next

cdsroot = objFSO.GetParentFolderName(Wscript.ScriptFullName)
cdsroot = cdsroot & "\"

Set objFile = objFSO.OpenTextFile(cdsroot & "firewall_list.txt", ForReading)
Const ForReading = 1

eShell=wShell.ExpandEnvironmentStrings("%WiNDIR%")
fShell=wShell.ExpandEnvironmentStrings("%temp%")

if quiet <> "-quiet" then

	nResult = msgbox ("Click OK to create firewall exceptions for OrCAD 16.6 Lite or Cancel to exit.", 65, "Firewall Exceptions Addition")

	if nResult = 2 then
		WScript.Quit
	end if
end if

Dim arrFileLines()
i = 0
Do Until objFile.AtEndOfStream
Redim Preserve arrFileLines(i)
arrFileLines(i) = objFile.ReadLine
i = i + 1
Loop
objFile.Close

'Then you can iterate it like this
For Each strLine in arrFileLines

 ReplaceTest strLine
Next
if quiet <> "-quiet" then
	msgbox "Firewall exceptions added."
end if

Function ReplaceTest(str1)

  ' Make replacement.
  ReplaceTest = str1

  'ReplaceTest contains the complete path to exe
  lastslashPos = instrRev(ReplaceTest, "\")
  'FileName contains actual file name with extension like capture.exe
  FileName = Mid (ReplaceTest,lastslashPos+1)
  OnlyFileName = Split (FileName,".exe")
  for each x in OnlyFileName
  	if x <> "" then
	  if version > "6" then
	 	'msgbox eShell & "\system32\netsh.exe advfirewall firewall add rule name=" & chr(34) & x & " (Release 16.6 Lite)" & chr(34) & " dir=in profile=any action=allow enable=yes program=" & chr(34) & ReplaceTest & chr(34) & " description=" & chr(34) & ReplaceTest & chr(34), 0
	 	wShell.run eShell & "\system32\netsh.exe advfirewall firewall add rule name=" & chr(34) & x & " (Release 16.6 Lite)" & chr(34) & " dir=in profile=any action=allow enable=yes program=" & chr(34) & ReplaceTest & chr(34) & " description=" & chr(34) & ReplaceTest & chr(34), 0, TRUE
	  else
	 	'msgbox eShell & "\system32\netsh.exe firewall add allowedprogram name=" & chr(34) & x & " (Release 16.6 Lite)" & chr(34) & " profile=ALL mode=enable program=" & chr(34) & ReplaceTest & chr(34), 0, TRUE
	 	wShell.run eShell & "\system32\netsh.exe firewall add allowedprogram name=" & chr(34) & x & " (Release 16.6 Lite)" & chr(34) & " profile=ALL mode=enable program=" & chr(34) & ReplaceTest & chr(34), 0, TRUE
	  end if
	end if
  next

End Function
