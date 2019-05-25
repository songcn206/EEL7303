#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capRev.tcl
#            Contains OrCAD Capture Design File revision procedures
#            Can be run either from the Capture Command Shell or from a
#            standalone Tcl shell
#     Usage: ::capRev::rev_main design {uprev|downrev} list-file
#            ::capRev::rev_main library {uprev|downrev} list-file
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capRev 1.0

namespace eval ::capRev {
    variable REVISION_ERRNO_ENV_VAR_NOT_FOUND    100
    variable REVISION_ERRNO_DBOPACKAGE_NOT_FOUND 101
    variable REVISION_ERRNO_LIST_FILE_NOT_FOUND  102
    
    namespace export rev_main
}

proc ::capRev::rev_logerror { pCode pString } {
    puts "\[REVISION ERROR:$pCode\] $pString"
}

proc ::capRev::rev_design { pSession pDesignFile pStatus pDoWhat } {    
    set lDesignPath [DboTclHelper_sMakeCString $pDesignFile]
    set lDboDesign [DboSession_GetDesignAndSchematics $pSession $lDesignPath $pStatus]

    if { $lDboDesign == "NULL" } {
        rev_logerror $pStatus "Unable to open $pDesignFile"
    } else {
        if { $pDoWhat == "uprev" } {
            puts -nonewline "Upreving $pDesignFile "
            set lDoConvert [DboLib_ConvertRequired $lDboDesign]
            if { $lDoConvert == 1 } {
                DboSession_MarkAllLibForSave $pSession $lDboDesign
                set lStatus [DboSession_SaveDesign $pSession $lDboDesign]

                if { [DboState_Failed $lStatus] == 1 } {
                    rev_logerror $lStatus "- Error"
                } else {
                    puts "- Success"
                }
            } else {
                puts "- Current"
            }
        } else {
            DboSession_MarkAllLibForSave $pSession $lDboDesign
            puts -nonewline "Downreving $pDesignFile "
            set lStatus [DboSession_SaveDesignAs $pSession $lDboDesign 2 0 $lDesignPath 1]
            if { [DboState_Failed $lStatus] == 1 } {
                rev_logerror $lStatus "- Error"
            } else {
                puts "- Success"
            }
        }
        DboSession_RemoveDesign $pSession $lDboDesign
    }
}

proc ::capRev::rev_library { pSession pLibraryFile pStatus pDoWhat } {    
    set lLibraryPath [DboTclHelper_sMakeCString $pLibraryFile]
    set lDboLibrary [DboSession_GetLibAndSchematics $pSession $lLibraryPath $pStatus]

    if { $lDboLibrary == "NULL" } {
        rev_logerror $pStatus "Unable to open library $pLibraryFile"
    } else {
        if { $pDoWhat == "uprev" } {
            set lDoConvert [DboLib_ConvertRequired $lDboLibrary]
            puts -nonewline "Upreving $pLibraryFile "
            if { $lDoConvert == 1 } {
                DboSession_MarkAllLibForSave $pSession $lDboLibrary
                DboSession_SaveLib $pSession $lDboLibrary

                if { [DboState_Failed $pStatus] == 1 } {
                    rev_logerror $pStatus "- Error"
                } else {
                    puts "- Success"
                }            
            } else {
                puts "- Current"
            }
        } else {
            DboSession_MarkAllLibForSave $pSession $lDboLibrary
            puts -nonewline "Downreving $pLibraryFile "
            set lStatus [DboSession_SaveLibAs $pSession $lDboLibrary 2 0 $lLibraryPath 1]
            if { [DboState_Failed $lStatus] == 1 } {
                rev_logerror $lStatus "- Error"
            } else {
                puts "- Success"
            }
        }
        DboSession_RemoveLib $pSession $lDboLibrary
    }
}

proc ::capRev::get_file_list { pListFile } {
    set lFileName [file normalize $pListFile]

    if { [ catch { open $lFileName r } lFileHandle ] } {
        rev_logerror $capRev::REVISION_ERRNO_LIST_FILE_NOT_FOUND "Unable to open revision file-list $pListFile" 
        return 0
    }

    set lFiles [ read $lFileHandle ]
    close $lFileHandle

    set lRet {}
    foreach lFile $lFiles {
        lappend lRet $lFile
    }
    return $lRet
}

proc ::capRev::rev_main { { pReviseWhat "NONE" } { pDoWhat "NONE" } { pListFile "-" } } {

    if { $pReviseWhat == "NONE" || $pDoWhat == "NONE" || $pListFile == "-" } {
        puts "Usage: capRev::rev_main {design|library} {uprev|downrev} list_file"
        return 0
    }

    set lSession [DboTclHelper_sCreateSession]
    set lStatus [DboState]

    set file_list [get_file_list $pListFile]

    if { $file_list == 0 } {
        return 0
    }

    if { $pReviseWhat == "design" } {
        foreach lDesignFile $file_list {
            rev_design $lSession $lDesignFile $lStatus $pDoWhat
        }
    } else {
        if { $pReviseWhat == "library" } {
            foreach lLibraryFile $file_list {
                rev_library $lSession $lLibraryFile $lStatus $pDoWhat
            }
        }
    }
    delete_DboSession $lSession                
}

