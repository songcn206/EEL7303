#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capAdvancedSave.tcl
#            contains Custom DRC Framework
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capAutoLoad\capCustomDRC.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require orPrmJSON
package require orPrmStreamer
package require orPrmDebug
package require orPrmUtils
package require orPrmWebComp

package provide capAdvancedSave 1.0

namespace eval ::capAdvancedSave {
	set gScriptDir [file dirname [info script]]
	set gRootDir [file join $::capAdvancedSave::gScriptDir ..]
	set gWidgetId 0
	set gSaveMode 0
	set gStrFullProjectPath ""
	set gMFCObj ""
	set gIsMFCMode 0

}


proc ::capAdvancedSave::capLaunchWidget {} {

	# Get the launce mode ( MFC or HTML5)
	set lLaunchMode [GetOptionString "capMFCSaveDialog"]
	set lObj NULL
	if { $lLaunchMode == "1" } {
		set lObj [CDesignSaveAsDlg]
		CDesignSaveAsDlg -this $lObj
		set ::capAdvancedSave::gMFCObj $lObj
		set ::capAdvancedSave::gIsMFCMode  1
		
	} else {
		set lModalId [orPrm::GetNextId]
		set ::capAdvancedSave::gWidgetId $lModalId
		set res [correctUNCPath [file join $::capAdvancedSave::gRootDir hybrid AdvancedSave.html]]
		set actualDialogId [orPrm::CreateModalDialog $lModalId $res "Save Project As" 380 232 0]
		
	}

	#Setting the parameters
	capAdvancedSave::capGetLastDestinationPath
	capAdvancedSave::capGetDestinationFileName
	capAdvancedSave::capGetLastCopyFlag
	capAdvancedSave::capGetLastRenameFlag
	capAdvancedSave::capGetLastDSNCopyFlag
	
	# Displaying Dialog
	if { $lLaunchMode == "1" } {
		$lObj ShowSaveAsDialog
	}
}

proc ::capAdvancedSave::capGetLastDestinationPath {} {
	
	if { $::capAdvancedSave::gIsMFCMode == 1 } {
		set lString [::capAdvancedSave::capGetSaveAsDestinationPath]
		$::capAdvancedSave::gMFCObj SetDestinationDirectory [DboTclHelper_sMakeCString $lString]
	}
}

proc capAdvancedSave::capGetDestinationFileName {} {
	
	if { $::capAdvancedSave::gIsMFCMode == 1 } {
		set lString [::capAdvancedSave::capGetSaveAsDestinationfileName]
		$::capAdvancedSave::gMFCObj SetProjectName [DboTclHelper_sMakeCString $lString]
	}
}

proc ::capAdvancedSave::capGetLastCopyFlag {} {
	if { $::capAdvancedSave::gIsMFCMode == 1 } {
		$::capAdvancedSave::gMFCObj SetCopyDSNFlag [capAdvancedSave::capGetDSNCopyFlag]
	}
}

proc ::capAdvancedSave::capGetLastRenameFlag {} {
	if { $::capAdvancedSave::gIsMFCMode == 1 } {
		$::capAdvancedSave::gMFCObj SetRenameFlag [capAdvancedSave::capGetRenameFlag]
	}
}

proc ::capAdvancedSave::capGetLastDSNCopyFlag {} {
	if { $::capAdvancedSave::gIsMFCMode == 1 } {
		set lFlagValue [capAdvancedSave::capGetCopyMode]
		
		set lHexCRWR [expr 0x0001]
		set lHexCAWR [expr 0x0002]
		set lHexCROR [expr 0x0004]
		set lHexCAOR [expr 0x0008]
		
		if { [expr {$lFlagValue & $lHexCRWR}] > 0 && [expr {$lFlagValue & $lHexCAWR}] > 0 } {
			$::capAdvancedSave::gMFCObj SetCopyWithinFolderFlag 1
		}
	
		if { [expr {$lFlagValue & $lHexCROR}] > 0  && [expr {$lFlagValue & $lHexCAOR}] > 0} {
			$::capAdvancedSave::gMFCObj SetCopyOutsideFolderFlag 1
		}
	}
}

proc ::capAdvancedSave::capAdvancedSetSaveMode { pMode } {
	set ::capAdvancedSave::gSaveMode $pMode
}

proc ::capAdvancedSave::capAdvancedGetSaveMode {} {
	return $::capAdvancedSave::gSaveMode
}

proc ::capAdvancedSave::capAdvancedSetProjectPath { pPath } {
	set ::capAdvancedSave::gStrFullProjectPath $pPath
}

proc ::capAdvancedSave::capAdvancedGetProjectPath {} {
	return $::capAdvancedSave::gStrFullProjectPath
}

proc ::capAdvancedSave::capSetAdvanceSaveOptionString {} {
	SetOptionString capAdvancedSave "True"
}

proc ::capAdvancedSave::capUnsetAdvancedSaveOptionString {} {
	SetOptionString capAdvancedSave "False"
}

proc ::capAdvancedSave::capGetFileName {} {
	set lName [DboTclHelper_sMakeCString $::capAdvancedSave::gStrFullProjectPath]
	set lArchiveFileName [capGetArchiveFileName $lName]
	set lArchiveFileNameString [DboTclHelper_sGetConstCharPtr $lArchiveFileName]
	return $lArchiveFileNameString
	
}

proc ::capAdvancedSave::capCompareTwoPath { pPath1 pPath2 } {
	set lPath1 [DboTclHelper_sMakeCString $pPath1]
	set lPath2 [DboTclHelper_sMakeCString $pPath2]
	set lresult [capComparePath $lPath1 $lPath2]
	set lTrue "0"
	set lFalse "1"
	if { $lresult == 0 } {
		return $lTrue
	} else {
		return $lFalse
	}
}

proc ::capAdvancedSave::capCloseWidget {} {
	
	if { $::capAdvancedSave::gIsMFCMode == 0 } {
		orPrm::DestroyWidget $::capAdvancedSave::gWidgetId
	}
}

proc ::capAdvancedSave::capHelpAdvancedSave {} {
	orCommonTclUtil_ShowHelp "cap_ug" "proj_saveas"
}

proc ::capAdvancedSave::capGetCopyMode {} {
	set lCopyMode [GetOptionString "FMM_COPY_MODE"]
	if { $lCopyMode == "" } {
		set lHexCopyAll [expr 0x0001 | 0x0002 | 0x0010]
		SetOptionString "FMM_COPY_MODE" $lHexCopyAll
		return $lHexCopyAll
	}
	return $lCopyMode
}

proc ::capAdvancedSave::capGetDSNCopyFlag {} {
    set lCopyFlag [GetOptionString "capCopyDsnFlag"]
    if {$lCopyFlag==""} {
	set lCopyFlag 1
    }
    return $lCopyFlag
}


proc ::capAdvancedSave::capGetRenameFlag {} {
    set lRenameFlag [GetOptionString "capMatchDsnAsProject"]
    if {$lRenameFlag==""} {
	set lRenameFlag 1
    }
    return $lRenameFlag
}

proc ::capAdvancedSave::capGetSaveAsDestinationPath {} {
	set lSaveAsDir [GetOptionString "capLastSaveAsDestinationDir"]
    if {$lSaveAsDir==""} {
		return ""
    }
	
    return $lSaveAsDir
}

proc ::capAdvancedSave::capGetSaveAsDestinationfileName {} {

    set lProjectPath [DboTclHelper_sGetConstCharPtr [capGetProjectPath]]
    set lProjectName [file tail $lProjectPath]
   
    return $lProjectName
}

proc ::capAdvancedSave::capValidatePath { pPath pFile } {
	
	if { $pFile != "" } {
	
		if { [string first > $pFile] != -1} {
			return 0
		}
		
		if { [string first < $pFile] != -1} {
			return 0
		}
		
		if { [string first ? $pFile] != -1} {
			return 0
		}
		
		if { [string first | $pFile] != -1} {
			return 0
		}
		
		if { [string first * $pFile] != -1} {
			return 0
		}
		
		if { [string first \" $pFile] != -1} {
			return 0
		}
		
		if { [string first / $pFile] != -1} {
			return 0
		}
		
		if { [string first \\ $pFile] != -1} {
			return 0
		}
	}
	
	set lProjectPath [DboTclHelper_sGetConstCharPtr [capGetProjectPath]]
	set lProjectPath [file normalize $lProjectPath]
	set lProjectPath [string tolower $lProjectPath]
	
	if { $pPath != "" } {
		set pPath [file normalize $pPath]
		set pPath [string tolower $pPath]

	        set lcurrentPath "$pPath/$pFile"
	        if { [string first // $lcurrentPath] == 0 } {
		    set lcurrentPath [string map {/// //} $lcurrentPath]
		    set lcurrentPath [string range $lcurrentPath 2 [string length $lcurrentPath]]
		    set lcurrentPath [string map {// /} $lcurrentPath]
		    set lcurrentPath "//$lcurrentPath"
		    
		} else {
		    set lcurrentPath [string map {// /} $lcurrentPath]
		}

		
		if { $lProjectPath == $lcurrentPath } {
			return -1;
		}

		set lflag [ file exists $pPath ]
		
		if { $lflag == 0} {
			if { [catch { file mkdir $pPath } fid] } {
				return 1
			}
		} else {
		
			set lflag [ file writable $pPath]
			if { $lflag == 0 } {
				return 1
			}
			
		}
	}
	
	if { $pPath == "" } {
	
		set pPath [file dirname $lProjectPath]
		
		set lflag [ file writable $pPath]
			if { $lflag == 0 } {
				return 1
			}

		set lcurrentPath "$pPath/$pFile"
	        if { [string first // $lcurrentPath] == 0 } {
		    set lcurrentPath [string map {/// //} $lcurrentPath]
		    set lcurrentPath [string range $lcurrentPath 2 [string length $lcurrentPath]]
		    set lcurrentPath [string map {// /} $lcurrentPath]
		    set lcurrentPath "//$lcurrentPath"
		    
		} else {
		    set lcurrentPath [string map {// /} $lcurrentPath]
		}

		
		if { $lProjectPath == $lcurrentPath } {
			return -1;
		}
		
	}
	
	return $lcurrentPath;
	
}

proc ::capAdvancedSave::capOnSaveAsOrArchive { pState pPath pFile pCRWR pCAWR pCROR pCAOR pCMD pIsCompress pCompressFile pCopyDsn pRenameDsn} {

	capAdvancedSave::capCloseWidget

	set lState [DboTclHelper_sMakeInt]
	set lState $pState

	
	set pPath [string trimright $pPath]
	set pPath [string trimleft $pPath]
	
	set pFile [string trimright $pFile]
	set pFile [string trimleft $pFile]
	
	
	set lHexCRWR [expr 0x0000]
	set lHexCAWR [expr 0x0000]
	set lHexCROR [expr 0x0000]
	set lHexCAOR [expr 0x0000]
	set lHexCMD  [expr 0x0000]
	
	if { $pCRWR == 1 } {
		set lHexCRWR [expr 0x0001]
	} 
	
	if { $pCAWR == 1 } {
		set lHexCAWR [expr 0x0002]
	}
	
	if { $pCROR == 1 } {
		set lHexCROR [expr 0x0004]
	}
	
	if { $pCAOR == 1 } {
		set lHexCAOR [expr 0x0008]
	}
	
	if { $pCMD == 1 } {
		set lHexCMD [expr 0x0010]
	}
	
	set lHexCopyAll [expr $lHexCRWR | $lHexCAWR | $lHexCROR | $lHexCAOR | $lHexCMD ]
	
	SetOptionString "FMM_COPY_MODE" $lHexCopyAll
	SetOptionString "capCopyDsnFlag" $pCopyDsn
	SetOptionString "capMatchDsnAsProject" $pRenameDsn

	
	SetOptionString "capLastSaveAsDestinationDir" $pPath
	
	set pCompressFile [string trimright $pCompressFile]
	set pCompressFile [string trimleft $pCompressFile]

	if { $pState == 1 } {
	    capSaveCompleteProject $pPath $pFile $pCopyDsn $pRenameDsn
	} elseif { $pState == 2 } {
	    capSaveCompleteProject $pPath "" $pCopyDsn $pRenameDsn
	}

}

proc ::capAdvancedSave::capOnSaveFile { pMode } {
	capAdvancedSave::capAdvancedSetSaveMode $pMode
	
	set lProjectPath [capGetProjectPath]
	
	# capGetProjectPath returns empty when the opj was non-existent earlier and then it gets created while opening the design
	# In this case, the project needs to be saved first to set the project state correct
	if { [DboTclHelper_sGetConstCharPtr $lProjectPath] == "" } {
		catch {SelectPMItem "Design Resources"; Menu "File::Save"}
		set lProjectPath [capGetProjectPath]
	}
	
	capAdvancedSave::capAdvancedSetProjectPath $lProjectPath
	capAdvancedSave::capLaunchWidget
}

proc ::capAdvancedSave::capOpenFileChooser {} {
	set lPath [capOpenFileSaveAsDialog 0]
	set lPathString [DboTclHelper_sGetConstCharPtr $lPath]
	return $lPathString
}

proc ::capAdvancedSave::capOpenDirectoryChooser { pCurrentPath } {
	set pCurrentPath [file normalize $pCurrentPath]
	set lPath [capOpenArchiveDialog $pCurrentPath]
	set lPathString [DboTclHelper_sGetConstCharPtr $lPath]
	return $lPathString
	
}

proc ::capAdvancedSave::capOnArchive { pMode pProjectPath } {
	capAdvancedSave::capAdvancedSetSaveMode $pMode
	capAdvancedSave::capAdvancedSetProjectPath  $pProjectPath
	capAdvancedSave::capLaunchWidget
}

proc ::capAdvancedSave::normalizeSize { pWidgetId pDeltaX pDeltaY } {
    set lWidth [orPrm::GetWidth $pWidgetId]
    set lHeight [orPrm::GetHeight $pWidgetId]

    orPrm::SetSize $pWidgetId [expr ($lWidth + $pDeltaX)] [expr ($lHeight + $pDeltaY)]
}

