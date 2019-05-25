		SwitchVersion Configuration

This paper will instruct you to extend the capabilities of the switchversion 
program. This shows you how to:
1) Create 1-click shortcuts for setting the current release.
2) Set your own environment variables when switching releases.

First a little about the tools you will use.

A) Visual Basic (switchversion.vbs) script
    - this handy little script will create a short-cut. 
    - a single quote (') indicates that the line is commented out (ignored).
    - The 2 quotes ("") is a method to insert 1 quote in a string. In
      this case we wish to output "SPB 16.2" so we need to do ""SPB 16.2"".
      The -reg option wants Cadence release number which happens to include 
      a space so we need to quote it.

B) A registry file (.reg)
    - This file updates the user environment variable section of the registry.
    - You can include multiple variables, the example has 1, additional
      variables can be added to the file.
    - Do NOT use it to change the PATH variable.
    - If you variable values include non-Ascii characters you will want to
      set the variable values in the registry via regedit then export the
      appropriate section of the hive.

CAUTION:
    Your Window's system may restrict or warn when running vbs or reg scripts. 
    If you are restricted, consult your IT department. You do not need to 
    use the vbs script since shortcuts can be created and copied manually. 
    The reg script is required if you need to set addition environment variables
    when switching releases.

    Always use the switchversion from the latest Cadence SPB release. Do not 
    encode CDSROOT into shortcuts to access switchversion. Instead use a
    hardcoded path.

TIP:
   Switchversion has a file association option (e.g. double clicking on a .brd 
   file will open Allegro) available staring in 16.2. This creates associations
   based upon the CDSROOT variable which means when you switch to a different
   release via switchversion the file association will also switch to the
   selected release. It also permits you set command line options when
   associating programs which Vista removed from its file association UI.

========================================================================
1) Create 1-click shortcuts for setting the current release.

   By creating a Windows shortcut you can change releases by just 
   double-clicking on created short-cut. The shortcut can be created
   by running the switchversion.vbs program (double click on vbs file).

   Before running the script you will want to edit it.
   a) RMB on the script and select Edit.
   b) Change TargetPath to the absolute location of the 16.2 switchversion.
      Only the 16.2 (ow newer) switchversion has the ability to do shortcuts.
      You cannot use CDSROOT variable.
   c) Save the shortcut.
   d) Double click on the shortcut. A shortcut to the 16.2 release should
      appear on your desktop

   To create shorts to additional releases:
   a) Copy the shortcut you just created.
   b) Rename the shortcut to the next releases (lets say SPB_15.7)
   c) RMB on the shortcut and select Properties.
   d) Select Shortcut tab in the dialog.
   e) Under Target field change the "SPB 16.2" to "SPB 15.7" (may need to scroll
      to the right on the text fillin line.
   f) click Ok

   Alternatively you can create a new vbs script.

   Repeat creating a shortcut for each Allegro version you access. You can
   then distribute these shortcuts to your users. The assumption in
   the distribution case is all your user's root the Cadence install hierarchy
   the same.


========================================================================
2) Set your own environment variables when switching releases.

   Using the switch version help look at that "-reg" option. This allows you 
   to set additional env variables via the standard Microsoft registry 
   hive method. This document assumes that you will be setting and updating
   your own environment variables in the "User" section of the registry.
   
   The variable.reg file provided in this directory shows a registry file that 
   will set the CDS_SITE variable to C:\temp in the User section of the 
   registry. You can also set System level variables but this is not 
   recommended since Microsoft views this as a security risk.

   Create a .reg file for each release supported. In each file set the
   environment variable values that are applicable for that release.

   In the shortcuts created in section 1 add to the end of the Target fillin:
	-reg "<path to the release's .reg file>"
   You should double quote the file path if the path contains spaces.

   Two alternatives:
	- You can set your shortcut's "Start in" directory option to the location
	  where you store your .reg files. The -reg option value should be
	  updated to reference the relative path to the release's .reg file.
	  The "Start in" for the shortcut will not effect the "Start in" location
	  of the Cadence tools.
	- You can set the path to your .reg directory as its own environment
	  variable. Use the variable in place of the directory path in the
	  shortcut. Surround variable name with (%) character to cause variable 
	  expansion.

   Distribute the switchversion shortcuts to your users. You can leave the
   switchversion .reg files in a network location or distribute them to
   your users. The recommendation is local reg files if your user's install
   Cadence tools locally, a network location if they access Cadence tools
   from a network location.


   EXPERT ISSUES:

   If you need to set your environment variables using non-Ascii characters then
   editing the .reg file will not work. You should set the environment
   variable via Microsoft's environment UI and then export .reg file from the 
   registry. To export the .reg file do the following:

   - Start regedit (Start menu, select Run, type in regedit

   - In regedit do
        Select HKEY_CURRENT_USER/Environment in left window.
        In the right window you should see all your User environment variables.
        Do a RMB Export
        Save to a .reg filename 
	Close regedit

  - Edit the file you saved in regedit. DO NOT DOUBLE CLICK ON THE FILE!
    Instead do a RMB Edit.
      - Delete all of the entries leaving just the environment variable(s) you 
	want.
      - Save the file

      Note: if you use non-ascii characters the value of the variable will
      not be readable in your text editor. 

