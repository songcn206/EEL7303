On Error Resume Next


Set WshShell = WScript.CreateObject("WScript.Shell")
reg1 = "HKEY_LOCAL_MACHINE\SOFTWARE\Cadence Design Systems\Interchange\16.6.0\ProductConfiguration\Shared\"
reg2 = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Cadence Design Systems\Interchange\16.6.0\ProductConfiguration\Shared\"


WshShell.RegDelete reg1
WshShell.RegDelete reg2