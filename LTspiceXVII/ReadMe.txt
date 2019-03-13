NOTE: THE FOLLOWING IS DONE BY THE LTSPICE INSTALLER.
      YOU SHOULD NOT NEED TO DO THIS YOURSELF ANYMORE.

The .dll's teach Windows Explorer how to view LTspice schematics and
symbols.  You can run regsvr32.exe to register them with the OS with
the following commands:

    To Register  :

       C:\> regsvr32.exe    <name.dll>

    To Unregister:

       C:\> regsvr32.exe /u <name.dll>

The above commands must be typed into a command shell "Run as
Administrator".  That means you have to browse with Windows Explorer to
cmd.exe, usually "C:\Windows\system32\cmd.exe", right click on cmd.exe,
and select menu item "Run as Administrator".  You might also need to
set the .dll's as having execute permission, which can be done by
setting the .dll file properties with Widows Explorer's right click
menu on the file name.

Do not move the .dll file location after registering it.

                             ------ Contents ------
    FILE                      DESCRIPTION
ASCx64.dll  Schematic Preview Explorer Support for 64-bit Windows
ASCx86.dll  Schematic Preview Explorer Support for 32-bit Windows
ASYx64.dll  Symbol    Preview Explorer Support for 64-bit Windows
ASYx86.dll  Symbol    Preview Explorer Support for 32-bit Windows




