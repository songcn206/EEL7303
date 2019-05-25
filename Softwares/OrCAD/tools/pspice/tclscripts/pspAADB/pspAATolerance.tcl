#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: pspAATolerance.tcl
#            contains OrCAD PSpiceAA commands to demonstrate enablement of advanced analysis to simulation design 
# 	     basically means no device level prps are present
# 	     1) tolerance parameters when design is opened in the tool
# 	     2) to be able to add device level parameters
# 		a) add device directly
# 		b) add device level through instance
#
#/////////////////////////////////////////////////////////////////////////////////

package require PspAATcl 16.6.0
package provide PspAATolerancing 1.0

namespace eval ::PspAATolerancing {
}

proc ::PspAATolerancing::init { } {
	PSAAReader_openDesign
}

proc ::PspAATolerancing::setAAInstParam { pInstName pParamName pParamValue pPostol pNegtol } {
	PSAAReader_setAAInstParam $pInstName $pParamName $pParamValue $pPostol $pNegtol 
}

proc ::PspAATolerancing::setAADevParam { pDevName pParamName pParamValue } {
	PSAAReader_setAADevParam $pDevName $pParamName $pParamValue 
}

proc ::PspAATolerancing::setAAInstDevParam { pInstName pParamName pParamValue } {
	##Add device level parameters through instance, it will be added to device attached to parameter
	PSAAReader_setAAInstDevParam $pInstName $pParamName $pParamValue 
}

proc ::PspAATolerancing::save { } {
	PSAAReader_save
}

