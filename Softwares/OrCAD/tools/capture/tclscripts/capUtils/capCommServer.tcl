#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCommServer.tcl
#            contains OrCAD Capture Communication utilities through TCL socket interface
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capCommServer 1.0

namespace eval ::capCommServer {
	namespace export StartServer
	namespace export StopServer
	
	variable mSocketChannel
	
	variable mPort
}

proc ::capCommServer::init { } {
	set ::capCommServer::mSocketChannel 0
	set ::capCommServer::mPort 9020
}

::capCommServer::init 


proc ::capCommServer::IsServerRunning { } {
	if {$::capCommServer::mSocketChannel == 0 } {
		return 0
	} 
	return 1
}

proc ::capCommServer::StartServer {  } {
	if {[::capCommServer::IsServerRunning] == 0 } {
	
		set ::capCommServer::mSocketChannel [socket -server ::capCommServer::DoServerAccept $::capCommServer::mPort] 
		
		set lMessage [concat "(::capCommServer::StartServer) Server started on port " $::capCommServer::mPort]
	 	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
	} else {
	
		set lMessage [concat "(::capCommServer::StartServer) Server is already running on port " $::capCommServer::mPort]
	 	set lMessageStr [DboTclHelper_sMakeCString $lMessage]
		DboState_WriteToSessionLog $lMessageStr
		return
	}
}

proc ::capCommServer::DoServerAccept {sock addr port} {
		#puts "request received"
		fconfigure $sock -buffering line
		fileevent $sock readable [list ::capCommServer::DoServerProc $sock]
		}

proc ::capCommServer::DoServerProc {sock} {
		if {[eof $sock] || [catch {gets $sock pObj}]} {
			close $sock
		} else {
			lappend pObj $sock
			CapCommHandleRemoteRequest $pObj
			#puts "request forwarded"
		}
	}
	
proc ::capCommServer::StopServer { } {
	if {[::capCommServer::IsServerRunning] == 1 } {
		close $::capCommServer::mSocketChannel
		set ::capCommServer::mSocketChannel 0
		
		set lMessageStr [DboTclHelper_sMakeCString "(::capCommServer::StopServer) Server stopped successfully"]
		DboState_WriteToSessionLog $lMessageStr
	} else {
		set lMessageStr [DboTclHelper_sMakeCString "(::capCommServer::StopServer) Server was not running"]
		DboState_WriteToSessionLog $lMessageStr
		return
	}
}

proc ::capCommServer::capTrue { args } {
	return 1
}

proc ::capCommServer::ClientRequestHandler { pObj } {
	set lMessage [concat "(::capCommServer::ClientRequestHandler)" $pObj]
	 set lMessageStr [DboTclHelper_sMakeCString $lMessage]
	 DboState_WriteToSessionLog $lMessageStr

	# get the procedure to exceute
	set lProcName [lindex $pObj 0]
	set lArguments [lindex $pObj 1]
	set lSock [lindex $pObj 2]
	
	set lProcStat [catch {set lReturnValue [$lProcName $lArguments]}]
	
	if {$lProcStat != 0} { 
		set lReturnValue [list "Server method failed"]
	}
	
	catch {puts $lSock $lReturnValue}
}

RegisterAction "_cdnOrTclRemoteRequestHandler" "::capCommServer::capTrue" "" "::capCommServer::ClientRequestHandler" ""
RegisterAction "_cdnOrAtCaptureExit" "::capCommServer::capTrue" "" "::capCommServer::StopServer" ""
