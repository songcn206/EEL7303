#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2009 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - capinit.tcl
#             Modify the procedure capGetTclTkHome to point to your Tcl/Tk
#             installation

# Uncomment the body of this procedure if you want alteration in search precedence
#proc cdnTclScriptSearchPrecedence {} {
     # The string has to be in the specified format. You can alter the positions 
	 # but not the string values. Nore the last comma in the string
	 #return {CDS_SITE,CWD,HOME,CDS_INST,DEFAULT_INST,}
#}

proc capGetCdnDefaultScriptsDir {} {
    return [file join [file dirname [info nameofexecutable]] tclscripts]
}


proc capGetTclTkHome {} {
    # Replace the string <Tcl/Tk_install_root> in the following line
    # with the Tcl/Tk installation path on your machine
    # and uncomment the following line

    # return [file normalize {<Tcl/Tk_install_root>}]
}

proc capLoadTk { pTclTkInstallPath } {
    set lTkPath [file join $pTclTkInstallPath bin tk84.dll]
    load $lTkPath

    # the following line is optional
    # add this if you do not want the default Tk . window
    # to be visible
    wm withdraw .
}

proc capTclTkInitialize {} {
    set lTclTkHome [capGetTclTkHome]
    if { $lTclTkHome != "" } {
        if { [file isdirectory $lTclTkHome] == 1 } { 
            set lTclTkLibPath [file join $lTclTkHome lib]
            if { [file isdirectory $lTclTkLibPath] == 1 } {
                lappend ::auto_path $lTclTkLibPath
                set lPackagesPath [file join $lTclTkLibPath tcl8.4]
                if { [file isdirectory $lPackagesPath] == 1 } {
                    lappend ::auto_path $lPackagesPath
                }
                # uncomment the following line to load Tk
                # capLoadTk $lTclTkHome
            }
        }
    }
}

capTclTkInitialize

interp alias {} ? {} set errorInfo

# end of file

