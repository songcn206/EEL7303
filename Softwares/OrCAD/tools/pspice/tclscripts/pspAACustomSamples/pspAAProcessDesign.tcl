#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAAProcessDesign.tcl
#            contains OrCAD PSpiceAA sample to pre process the design before analysis is run
#		 for example user defined parameters can be toleranced
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl 
package require PspAATcl 16.6.0
package provide PspAACustomDesignReader 1.0


namespace eval ::PspAACustomDesignReader {
	variable mCurInstance
}

proc ::PspAACustomDesignReader::pspDesignTrue { args } {
	return 1;
}

proc ::PspAACustomDesignReader::processDesignStart { } {
	PSAAReader_openDesign

	PSAAReader_enableAAInst_TclEval "R1"
}

proc ::PspAACustomDesignReader::processDesignEnd { } {
	
}

proc ::PspAACustomDesignReader::processPostInst { } {
	
}

proc ::PspAACustomDesignReader::processInst { pInstName } {

	set ::PspAACustomDesignReader::mCurInstance $pInstName

	set instTypeC [string first C $::PspAACustomDesignReader::mCurInstance]
	if {$instTypeC==0} {
		PSAAReader_setAAInstParam_Tol $::PspAACustomDesignReader::mCurInstance "MY_CVAL" "10%" "10%"
	}	

	set instTypeR [string first R $::PspAACustomDesignReader::mCurInstance]
	if {$instTypeR==0} {
		set my_rval1 1
		set my_rval2 1
		PSAAReader_setPSpiceInstParam $::PspAACustomDesignReader::mCurInstance "my_rval1" $my_rval1
		PSAAReader_setPSpiceInstParam $::PspAACustomDesignReader::mCurInstance "my_rval2" $my_rval2
		set pos_tol [expr $my_rval1 + $my_rval2]
		set neg_tol $pos_tol
		PSAAReader_setAAInstParam_Tol $::PspAACustomDesignReader::mCurInstance "MY_RVAL" $pos_tol% $neg_tol%
	}
}


RegisterAction "_cdnPspAAProcessDesignStart" "::PspAACustomDesignReader::pspDesignTrue" "" "::PspAACustomDesignReader::processDesignStart" ""
RegisterAction "_cdnPspAAProcessInst" "::PspAACustomDesignReader::pspDesignTrue" "" "::PspAACustomDesignReader::processInst" ""
RegisterAction "_cdnPspAAProcessPostInst" "::PspAACustomDesignReader::pspDesignTrue" "" "::PspAACustomDesignReader::processPostInst" ""
RegisterAction "_cdnPspAAProcessDesignEnd" "::PspAACustomDesignReader::pspDesignTrue" "" "::PspAACustomDesignReader::processDesignEnd" ""



