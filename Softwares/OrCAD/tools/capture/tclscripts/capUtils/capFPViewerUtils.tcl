#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - capFPViewerUtils.tcl
#  This file contains OrCAD Capture Footprint Viewer Utility Functions

package require Tcl 8.4
package provide capFPViewerUtils 1.0

namespace eval ::capFPViewerUtils {
    
    namespace export getPsmPath
    namespace export addToPsmPath
    namespace export setPsmPath
    
    namespace export getPadPath
    namespace export addToPadPath
    namespace export setPadPath

    variable ENV_FILE_NAME    "env"
    variable ENV_FOLDER_NAME  "pcbenv"
    variable ENV_FILE_DATA    ""
    variable ENV_KEY_HOME     "HOME"
    variable ENV_FILE_PATH    ""

    variable KEY_PSMPATH      "psmpath"
    variable KEY_PADPATH      "padpath"
    variable DEFVAL_PSMPATH   "\$psmpath"
    variable DEFVAL_PADPATH   "\$padpath"

    variable INITED 0

    variable ERR_FILE_OPEN_FAILED  2001
    variable ERR_INSUFFICIENT_PERM 2002
    variable ERR_INSUFFICIENT_WRITE_PERM 2003

    variable PASS_THRU_DATA [list ""]
    variable DATA_DICTIONARY
    array set DATA_DICTIONARY {}

    variable ERROR_TABLE
    
    array set ERROR_TABLE {
        2001 "Unable to open file"
        2002 "Insufficient privileges on file"
        2003 "Insufficient write privileges on file"
    }

    proc getEnvFilePath {} {
        
        if { "" == $::capFPViewerUtils::ENV_FILE_PATH } {
            set lHome $::env($::capFPViewerUtils::ENV_KEY_HOME)
            
            if { 1 == [string match -nocase "Unknown" $lHome] } {
                set lHomeDrive $::env(HOMEDRIVE)
                set lHomePath $::env(HOMEPATH)        
                regsub -all "\\\\" $lHomePath "/" lHomePath
                
                set lHome ""
                append lHome $lHomeDrive $lHomePath 
            }
        
            set ::capFPViewerUtils::ENV_FILE_PATH [file join $lHome $::capFPViewerUtils::ENV_FOLDER_NAME $::capFPViewerUtils::ENV_FILE_NAME]
        }
        
        return $::capFPViewerUtils::ENV_FILE_PATH
    }
    
    proc logError { pErr pArgs } {
        set lMessage "\["
        append lMessage $pErr "\] " "$::capFPViewerUtils::ERROR_TABLE($pErr) "
        foreach lArg $pArgs {
            append lMessage $lArg " "
        }
        puts "$lMessage"
    }
    
    proc createDefaultFile {} {
        set lEnvFile [getEnvFilePath]
        set lEnvFileDir [file dirname $lEnvFile]
        set lStatus 1
        if { 0 == [file isdirectory $lEnvFileDir] } {
            if { [catch { file mkdir $lEnvFileDir }] } {
                logError $::capFPViewerUtils::ERR_INSUFFICIENT_WRITE_PERM [list $lEnvFileDir]
                set lStatus 0
            } else {
                set lStatus 1
            }
        }
        
        if { 1 == $lStatus } {
            if { [catch { open $lEnvFile a } lFileHandle ] } {
                logError $::capFPViewerUtils::ERR_FILE_OPEN_FAILED [list $lEnvFile ]
                set lStatus 0
            } else {
                writeDefaultEntries $lFileHandle
                close $lFileHandle
            }
        }
        
        return $lStatus
    }
    
    proc savePCBEnv {} {
        set lEnvFilePath [getEnvFilePath]
        storeFile $lEnvFilePath
    }
    
    proc initPCBEnv {} {
        if { 0 == $::capFPViewerUtils::INITED } {
            set lEnvFilePath [getEnvFilePath]
            set lStatus 1
            
            if { 0 == [file exists $lEnvFilePath] } {
                set lStatus [createDefaultFile]
            } elseif { 0 == [file readable $lEnvFilePath] } {
                logError $::capFPViewerUtils::ERR_INSUFFICIENT_PERM [list $lEnvFilePath]
                set lStatus 0 
            }
            
            if { 1 == $lStatus } {
                loadFile $lEnvFilePath
            }
        }
    }

    proc loadFile { pFile } {
        if {[catch {open $pFile r} lFileHandle]} {
            return
        }
    
        set lData [read $lFileHandle]
    
        close $lFileHandle
    
        set lLines [split $lData "\n"]
    
        foreach lLine $lLines {
            set lLine [string trim $lLine]
            set lProcessed 0
            if { "#" != [lindex $lLine 0] } {
                if { 1 == [regexp ".*=.*" $lLine] } {
                    set lParts [split $lLine "="]    
    
                    # extract the variable name
                    set lKey [string trim [lindex $lParts 0]]
                    regsub -nocase "^set " $lKey "" lKey                
                    
                    # extract the variable value
                    set lValue [string trim [lindex $lParts 1]]
                   
                    # install key/value pair in dictionary
                    set ::capFPViewerUtils::DATA_DICTIONARY($lKey) $lValue
                    set lProcessed 1
                } 
            }
            
            if { 0 == $lProcessed && 0 != [string length $lLine] } {
                lappend ::capFPViewerUtils::PASS_THRU_DATA $lLine
            }
        }
    }
    
    proc storeFile { pFile } {
        if {[catch {open $pFile w} lFileHandle]} {
            logError $::capFPViewerUtils::ERR_FILE_OPEN_FAILED [list $pFile]
        }
    
        foreach lData $::capFPViewerUtils::PASS_THRU_DATA {
            set lData [string trim $lData]
            if { 0 != [string length $lData] } {
                puts $lFileHandle $lData
            }
        }
    
        foreach lArrayData [array names ::capFPViewerUtils::DATA_DICTIONARY] {
            puts $lFileHandle "set $lArrayData = $::capFPViewerUtils::DATA_DICTIONARY($lArrayData)"
        }
    
        close $lFileHandle
    }
    
    proc writeDefaultEntries { pFileHandle } {
        puts $pFileHandle "source \$TELENV"
        
        puts $pFileHandle "### User Preferences section"
        puts $pFileHandle "### This section is computer generated."
        puts $pFileHandle "### Please do not modify to the end of the file."
        puts $pFileHandle "### Place your hand edits above this section."
        puts $pFileHandle "###"
        puts $pFileHandle "set $::capFPViewerUtils::KEY_PSMPATH = $::capFPViewerUtils::DEFVAL_PSMPATH"
        puts $pFileHandle "set $::capFPViewerUtils::KEY_PADPATH = $::capFPViewerUtils::DEFVAL_PADPATH"
    }

    proc addToEntry { pEntryName pEntryValue } {
        set lValues [::capFPViewerUtils::getEntry $pEntryName]
        append lValues " " $pEntryValue
        setEntry $pEntryName $lValues
    }
    
    proc setEntry { pEntryName pEntryValue } {
        set ::capFPViewerUtils::DATA_DICTIONARY($pEntryName) $pEntryValue
    }
    
    proc getEntry { pEntryName } {
        set lRet {}
        
        if { [info exists ::capFPViewerUtils::DATA_DICTIONARY($pEntryName)] } {
            set lRet $::capFPViewerUtils::DATA_DICTIONARY($pEntryName)
        }
        return $lRet
    }
    
    # Initialize PCB env file
    initPCBEnv
}

proc ::capFPViewerUtils::getPsmPath {} {
    return [getEntry $::capFPViewerUtils::KEY_PSMPATH]
}

proc ::capFPViewerUtils::setPsmPath { pPath } {
    setEntry $::capFPViewerUtils::KEY_PSMPATH $pPath
    savePCBEnv
}

proc ::capFPViewerUtils::getPadPath {} {
    return [getEntry $::capFPViewerUtils::KEY_PADPATH]
}

proc ::capFPViewerUtils::setPadPath { pPath } {
    setEntry $::capFPViewerUtils::KEY_PADPATH $pPath
    savePCBEnv
}

proc ::capFPViewerUtils::addToPadPath { pPath } {
    addToEntry $::capFPViewerUtils::KEY_PADPATH $pPath
    savePCBEnv
}

proc ::capFPViewerUtils::addToPsmPath { pPath } {
    addToEntry $::capFPViewerUtils::KEY_PSMPATH $pPath
    savePCBEnv
}

# end of file

