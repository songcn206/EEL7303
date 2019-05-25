#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capSessionUtil.tcl
#            contains OrCAD Capture active session utility
#/////////////////////////////////////////////////////////////////////////////////


package require Tcl 8.4
package provide capSessionUtil 1.0

namespace eval ::capSessionUtil {
    namespace export enumerateOpenLibsAndDesigns
}

proc ::capSessionUtil::enumerateOpenLibsAndDesigns { args } {    
     
    set lSession $::DboSession_s_pDboSession
    DboSession -this $lSession
    
    set lStatus [DboState]
    set lName [DboTclHelper_sMakeCString]

    set lMessageStr [DboTclHelper_sMakeCString "Open Designs -->"]
    DboState_WriteToSessionLog $lMessageStr
                
     set lDesignsIter [$lSession NewDesignsIter $lStatus]
     set lDesign [$lDesignsIter NextDesign  $lStatus]
     set lNullObj NULL
     while { $lDesign!= $lNullObj} {
        $lDesign GetName $lName
        DboState_WriteToSessionLog  $lName
         set lDesign [$lDesignsIter NextDesign  $lStatus]
     }
     delete_DboSessionDesignsIter $lDesignsIter
     
    set lMessageStr [DboTclHelper_sMakeCString "Open Libraries -->"]
    DboState_WriteToSessionLog $lMessageStr
                
     set lLibsIter [$lSession NewLibsIter $lStatus]
     set lLib [$lLibsIter NextLib  $lStatus]
     set lNullObj NULL
     while { $lLib!= $lNullObj} {
        $lLib GetName $lName
        DboState_WriteToSessionLog  $lName
        set lLib [$lLibsIter NextLib  $lStatus]
     }
     delete_DboSessionLibsIter $lLibsIter
    
    $lStatus -delete
}

# source D:/WorkData/Capture/dbcheck/capSessionUtil.tcl
# capSessionUtil::enumerateOpenLibsAndDesigns


