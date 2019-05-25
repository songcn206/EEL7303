#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capReplacePathInCacheUtil.tcl
#/////////////////////////////////////////////////////////////////////////////////


package require Tcl 8.4
package provide capReplacePathInCacheUtil 1.0

namespace eval ::capReplacePathInCacheUtil {
    namespace export replace
}

proc ::capReplacePathInCacheUtil::GetPackageNameFromPart { lObject } {
	
	set packageName ""
	set lName [DboTclHelper_sMakeCString]
	$lObject GetName $lName
	set partName [DboTclHelper_sGetConstCharPtr $lName]
	set partName [string toupper $partName]
	#puts " Part Name in GetPackageFromPart $partName "
	if { [string first {.NORMAL} $partName] != -1 } {
		set packageName [string range $partName 0 [expr [string first {.NORMAL} $partName]-1]]
	}
	if { [string first {.CONVERT} $partName] != -1 } {
		set packageName [string range $partName 0 [expr [string first {.CONVERT} $partName]-1]]
	}
	return $packageName
}

proc ::capReplacePathInCacheUtil::CheckNewLib { lSession lNewSourceLibName lObjectName lSourceLibName lCachedObject } {
	
	set lNullObj NULL
	set lStatus [DboState]
	set lLib [$lSession GetLib $lNewSourceLibName $lStatus]
	set replace 1
	set lName [DboTclHelper_sMakeCString]
	if { $lLib == $lNullObj } {
		set lMessage [concat "Failed For Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Design/Library Not Found " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
		set replace 0
	} else {
		# Check for Package for Cell, Part and Package
		if { [$lCachedObject GetObjectType] == $::DboBaseObject_PACKAGE } {
			set packageObj [DboBaseObjectToDboLibObject $lCachedObject]
			set packageObj [DboLibObjectToDboPackage $packageObj]
			$packageObj GetName $lName
			#puts [concat "Looking For Package "[DboTclHelper_sGetConstCharPtr $lName]]
			set newPackageObj [$lLib GetPackage $lName $lStatus]
			if { $newPackageObj == $lNullObj } {
				set lMessage [concat "Failed For Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Package Not Found " [DboTclHelper_sGetConstCharPtr $lName] "In Libarary " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName] ] 		
				set replace 0
			}
		}
		if { [$lCachedObject GetObjectType] == $::DboBaseObject_PART_CELL } {
			set cellObj [DboBaseObjectToDboLibObject $lCachedObject]
			set cellObj [DboLibObjectToDboCell $cellObj]
			set partIter [$cellObj NewPartsIter $lStatus]
			set partObj [$partIter NextPart $lStatus]
			if { $partObj == $lNullObj } {
				set lMessage [concat "Failed For Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Part In Cell Not Found " [DboTclHelper_sGetConstCharPtr $lObjectName] "In Libarary " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName] ] 		
				set replace 0
			}
			while { $partObj != $lNullObj } {
				set packagename [GetPackageNameFromPart $partObj]
				#puts "Package Name From Part $packagename"
				set lPackageName [DboTclHelper_sMakeCString $packagename]
				#puts [concat "Looking For Package "[DboTclHelper_sGetConstCharPtr $lPackageName]]
				set newPackageObj [$lLib GetPackage $lPackageName $lStatus]
				if { $newPackageObj == $lNullObj } {
						set lMessage [concat "Failed For Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Package Not Found " [DboTclHelper_sGetConstCharPtr $lPackageName] "In Libarary " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName] ] 		
						set replace 0
					}
				set partObj [$partIter NextPart $lStatus]
			} 
			delete_DboCellPartsIter $partIter
		}
		if { [$lCachedObject GetObjectType] == $::DboBaseObject_LIBRARY_PART } {
			set partObj [DboBaseObjectToDboLibObject $lCachedObject]
			set partObj [DboLibObjectToDboGraphicObject $partObj]
			set partObj [DboGraphicObjectToDboSymbol $partObj]
			set partObj [DboSymbolToDboLibPart $partObj]
			set packagename [GetPackageNameFromPart $partObj]
			#puts "Package Name From Part $packagename"
			set lPackageName [DboTclHelper_sMakeCString $packagename]
			#puts [concat "Looking For Package " [DboTclHelper_sGetConstCharPtr $lPackageName]]
			set newPackageObj [$lLib GetPackage $lPackageName $lStatus]
			if { $newPackageObj == $lNullObj } {
				set lMessage [concat "Replaced Failed For Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Package Not Found " [DboTclHelper_sGetConstCharPtr $lPackageName] "In Libarary " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName] ] 		
				set replace 0
			} 
		}
	}
	if { $lLib != $lNullObj } {
		$lSession RemoveLib $lLib
	}
	if { $replace == 0 } {
		DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
	}
	return $replace
}

proc ::capReplacePathInCacheUtil::ReplacePathInCache { pOldPathRootFolder pNewPathRootFolder lSession lDesign IsCache IncludeDesign DoUpdate } {
	
	set lStatus [DboState]
	if { $IsCache } {
		set lCacheObjectsIter [$lDesign NewCachesIter $lStatus]
		set lCachedObject [$lCacheObjectsIter NextCachedObject  $lStatus]
		set lNullObj NULL
	 
		set lObjectName [DboTclHelper_sMakeCString]
		set lSourceLibName [DboTclHelper_sMakeCString]
			
		while { $lCachedObject!= $lNullObj } {
			 
			set lCachedLibObject [DboBaseObjectToDboLibObject $lCachedObject]
	 
			if { $lCachedLibObject != $lNullObj } {
		 
				$lCachedObject GetName $lObjectName
				$lDesign GetSourceLibName $lObjectName $lCachedLibObject $lSourceLibName
		 
				# Display the Object name and the source name in the command window
				set lSourceLibNameStr [DboTclHelper_sGetConstCharPtr $lSourceLibName]
				set strObjectName [DboTclHelper_sGetConstCharPtr $lObjectName]
				#puts "Object:$strObjectName Source Library Name:$lSourceLibNameStr"
		 
				set lSearchResult [string first $pOldPathRootFolder $lSourceLibNameStr]
		 
				#puts "Search Result for $pOldPathRootFolder in Source Library $lSourceLibNameStr : $lSearchResult"
		
				if { $lSearchResult == 0 && [$lCachedLibObject GetObjectType] == $::DboBaseObject_PART_CELL } {
		 
					set lLength [string length $pOldPathRootFolder]
			
					set pResultantPath [string replace $lSourceLibNameStr 0 [expr "$lLength-1"] $pNewPathRootFolder]
				
					set lNewSourceLibName [DboTclHelper_sMakeCString $pResultantPath]
				
					# Check whether to replace the DSN Path
					set replace 1
					set IsDesignPath [string first {.DSN} [string toupper lNewSourceLibName]]
					
					if { $IncludeDesign == 0 } {
						# String contians DSN path . Do not replace
						if { $IsDesignPath != -1 } {
							set replace 0
						}
					} else {
						# Replace .DSN Path
						if { $IsDesignPath != -1 } {
							if { $DoUpdate } {
								$lDesign ReplaceSourceLibName $lObjectName $lCachedLibObject $lSourceLibName $lNewSourceLibName
								$lCachedLibObject SetSourceLibName $lNewSourceLibName
							} else {
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: To Be Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							}
							set replace 0
						}
					}
					if { $replace } {
						#puts [concat "Cell Name Before Check Lib: " [DboTclHelper_sGetConstCharPtr $lObjectName]]
						set checkLib [capReplacePathInCacheUtil::CheckNewLib $lSession $lNewSourceLibName $lObjectName $lSourceLibName $lCachedObject]
						#puts [concat "Cell Name After Check Lib: " [DboTclHelper_sGetConstCharPtr $lObjectName]]
						if { $checkLib } {
							if { $DoUpdate } {
								$lDesign ReplaceSourceLibName $lObjectName $lCachedLibObject $lSourceLibName $lNewSourceLibName
								$lCachedLibObject SetSourceLibName $lNewSourceLibName
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							} else {
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: To Be Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							}
						}	 
					}
				}
			}
			set lCachedObject [$lCacheObjectsIter NextCachedObject  $lStatus]
		}
		delete_DboDesignCachesIter $lCacheObjectsIter
	} else {
		set lCacheObjectsIter [$lDesign NewCachesIter $lStatus]
		set lCachedObject [$lCacheObjectsIter NextCachedObject  $lStatus]
		set lNullObj NULL
	 
		set lObjectName [DboTclHelper_sMakeCString]
		set lSourceLibName [DboTclHelper_sMakeCString]
			
		while { $lCachedObject!= $lNullObj } {
			 
			set lCachedLibObject [DboBaseObjectToDboLibObject $lCachedObject]
	 
			if { $lCachedLibObject != $lNullObj } {
		 
				$lCachedObject GetName $lObjectName
				$lDesign GetSourceLibName $lObjectName $lCachedLibObject $lSourceLibName
		 
				# Display the Object name and the source name in the command window
				set lSourceLibNameStr [DboTclHelper_sGetConstCharPtr $lSourceLibName]
				set strObjectName [DboTclHelper_sGetConstCharPtr $lObjectName]
				#puts "Object:$strObjectName Source Library Name:$lSourceLibNameStr"
		 
				set lSearchResult [string first $pOldPathRootFolder $lSourceLibNameStr]
		 
				#puts "Index for $pOldPathRootFolder in Source Library $lSourceLibNameStr : $lSearchResult"
		
				if { $lSearchResult == 0 && [$lCachedLibObject GetObjectType] != $::DboBaseObject_PART_CELL } {
		 
					set lLength [string length $pOldPathRootFolder]
			
					set pResultantPath [string replace $lSourceLibNameStr 0 [expr "$lLength-1"] $pNewPathRootFolder]
				
					set lNewSourceLibName [DboTclHelper_sMakeCString $pResultantPath]
				
					# Check whether to replace the DSN Path
					set replace 1
					set IsDesignPath [string first {.DSN} [string toupper $lSourceLibNameStr]]
					if { $IncludeDesign == 0 } {
						# String contians DSN path . Do not replace
						if { $IsDesignPath != -1 } {
							set replace 0
						}
					} else {
						# Replace .DSN Path, if path contains .DSN
						if { $IsDesignPath != -1 } {
							if {$DoUpdate} {
								$lDesign ReplaceSourceLibName $lObjectName $lCachedLibObject $lSourceLibName $lNewSourceLibName
								$lCachedLibObject SetSourceLibName $lNewSourceLibName
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							} else {
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: To Be Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							}	
							set replace 0
						}
					}
					if { $replace } {
						#puts [concat "Cell Name Before Check Lib: " [DboTclHelper_sGetConstCharPtr $lObjectName]]
						set checkLib [capReplacePathInCacheUtil::CheckNewLib $lSession $lNewSourceLibName $lObjectName $lSourceLibName $lCachedObject]
						#puts [concat "Cell Name After Check Lib: " [DboTclHelper_sGetConstCharPtr $lObjectName]]
						if { $checkLib } {
							if { $DoUpdate } {
								$lDesign ReplaceSourceLibName $lObjectName $lCachedLibObject $lSourceLibName $lNewSourceLibName
								$lCachedLibObject SetSourceLibName $lNewSourceLibName
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							} else {
								set lMessage [concat "Object " [DboTclHelper_sGetConstCharPtr $lObjectName] " :: Source Library Name " [DboTclHelper_sGetConstCharPtr $lSourceLibName] " :: To Be Replaced With " [DboTclHelper_sGetConstCharPtr $lNewSourceLibName]] 
								DboState_WriteToSessionLog  [DboTclHelper_sMakeCString $lMessage]
							}
						}	 
					}
				}
			}
			set lCachedObject [$lCacheObjectsIter NextCachedObject  $lStatus]
		}
		delete_DboDesignCachesIter $lCacheObjectsIter
	}
	$lStatus -delete
	
}

proc ::capReplacePathInCacheUtil::replace { pOldPathRootFolder pNewPathRootFolder {IncludeDesign 0} {DoUpdate 0} } {    
     
	#puts [concat "Old Path: " $pOldPathRootFolder "New Path: " $pNewPathRootFolder "Replace Also .DSN Path: " $IncludeDesign "Update: " $DoUpdate]
	
	catch {set lDesign [GetActivePMDesign]} lResult
	
    if {[catch {set lDesign [GetActivePMDesign]}] != 0} {
		puts "Design Not Selected in PM. Active Design Not Found"
		return
    }
    
    set lStatus [DboState]
	
	set lSession [DboTclHelper_sCreateSession]	
	set lNullObj NULL
	
	ReplacePathInCache $pOldPathRootFolder $pNewPathRootFolder $lSession $lDesign 1 $IncludeDesign $DoUpdate
	ReplacePathInCache $pOldPathRootFolder $pNewPathRootFolder $lSession $lDesign 0 $IncludeDesign $DoUpdate
    
	set designSession [$lDesign GetOwner]
	
	$lDesign MarkModified NULL
	$designSession MarkAllLibForSave $lDesign
	$designSession SaveDesign $lDesign
	
	DboTclHelper_sDeleteSession $lSession
	 
    $lStatus -delete
     
	DboTclHelper_sReleaseAllCreatedPtrs
	 
    catch {SelectPMItem "Design Cache"}
}

# source {d:\workdata\capture\dbcheck\capReplacePathInCache.tcl}
# capReplacePathInCacheUtil::replace pOldPathRootFolder pNewPathRootFolder [0/1]


