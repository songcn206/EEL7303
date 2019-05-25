#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCommServerLaunch.tcl
#            Sample Tcl/Tk Communication Server Launcher Framework
#/////////////////////////////////////////////////////////////////////////////////


package require capAppUtils
package provide capCommServerLaunch 1.0

namespace eval capCommServerLaunch {
	variable mForm
}

proc capCommServerLaunch::ui {pForm args} {
    
    set ::capCommServerLaunch::mForm $pForm
    
    variable lLabelFrameButtons [labelframe $pForm.lLabelFrameButtons ]
    
     variable lLabelPort [label $pForm.lLabelPort \
	    -text "Port"]
	    
    set lState "normal"
    
    if {[::capCommServer::IsServerRunning] == 1 } {
	set lState "disabled"
    }
    
    variable lPort [entry $pForm.lPort \
	    -textvariable "::capCommServer::mPort" \
	    -state $lState \
	    -width 10 \
	    ]
    
    variable lBtnStartServer [button $pForm.lBtnStartServer \
	    -command "::capCommServerLaunch::startServer $pForm $args" \
	    -state $lState \
	    -text "Start"]
    
    set lState "normal"
    
    if {[::capCommServer::IsServerRunning] == 0 } {
	set lState "disabled"
    }
    
    variable lBtnStopServer [button $pForm.lBtnStopServer \
	    -command "::capCommServerLaunch::stopServer $pForm $args" \
	    -state $lState \
	    -text "Stop"]
    
    variable lBtnCancel [button $pForm.lBtnCancel \
	    -command "::capCommServerLaunch::cancel $pForm $args" \
	    -text "Cancel"]
    
    
    # Geometry Management

    grid $pForm.lLabelPort -in $pForm -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lPort -in $pForm -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "ew"
    grid $pForm.lLabelFrameButtons -in $pForm -row 2 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky "news"
    grid $pForm.lBtnStartServer -in $pForm.lLabelFrameButtons -row 1 -column 1 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnStopServer -in $pForm.lLabelFrameButtons -row 1 -column 2 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "w"
    grid $pForm.lBtnCancel -in $pForm.lLabelFrameButtons -row 1 -column 3 \
	    -columnspan 1 \
	    -ipadx 1 \
	    -ipady 1 \
	    -padx 2 \
	    -pady 2 \
	    -rowspan 1 \
	    -sticky "e"
    
    # Resize Behavior
    grid rowconfigure $pForm 1 -weight 0 -minsize 21 -pad 0
    grid rowconfigure $pForm 2 -weight 0 -minsize 9 -pad 0
    grid columnconfigure $pForm 1 -weight 0 -minsize 10 -pad 0
    grid columnconfigure $pForm 2 -weight 1 -minsize 10 -pad 0
    grid rowconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 1 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 2 -weight 0 -minsize 12 -pad 0
    grid columnconfigure $pForm.lLabelFrameButtons 3 -weight 0 -minsize 12 -pad 0
}

proc capCommServerLaunch::startServer { args } {
	if {[string is integer -strict $::capCommServer::mPort] != 1} {
		tk_messageBox -type ok -message "Port number must be an integer" -title "Communication Server Message"
		return 
	}
	
	if { [catch {eval ::capCommServer::StartServer }] } {
            puts "ERROR : $::errorInfo"
        }
	 
	destroy [lindex $args 0]
}

proc capCommServerLaunch::stopServer { args } {
	if { [catch {eval ::capCommServer::StopServer }] } {
            puts "ERROR : $::errorInfo"
        }
	 
	destroy [lindex $args 0]
}

proc capCommServerLaunch::cancel { args } {
        destroy [lindex $args 0]
}

proc ::capCommServerLaunch::init {args} {

    set lForm .capCommServer

    if { "" == [info commands $lForm]} {
	capAppUtils::capTopLevel $lForm
	capCommServerLaunch::ui $lForm
	capAppUtils::setWindowSize $lForm 150 80 150 80
	wm title $lForm "Communication Server"
	capAppUtils::autoAdoptWindow $lForm
    }


    if { 0 == [winfo ismapped $lForm]} {
	wm deiconify $lForm
    }

}

proc ::capCommServerLaunch::launch {args} {
    if { [catch {package require capCommServer}] } {
	set lMessage [DboTclHelper_sMakeCString "(::capCommServerLaunch::launch) capCommServer not found"]
       DboState_WriteToSessionLog $lMessage
    } else {
	::capCommServerLaunch::init $args
	}
}
