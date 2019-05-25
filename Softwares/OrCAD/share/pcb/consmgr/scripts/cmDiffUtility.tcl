#################################################################################
#			Cadence Design Systems					#
#										#
#			Command: displayDiffUI					#
#			Tcl File: cmDiffUtility.tcl				#
#										#
#			Author: Cadence Design Systems				#
#				Aditya Chandra					#
#			Email:  support@cadence.com				#
#				aditya@cadence.com				#
#			Creation Date: 06/22/2011				#
#										#
#################################################################################
#										#
#	Copyright 2012 Cadence Design Systems, Inc.  All rights reserved.	#
#	Use of this code is restricted and is subject to the terms of the	#
#	existing license and/or services agreement between you and Cadence.	#
#	If you do not have an existing agreement with Cadence for the use	#
#	of this code, you may not use it.					#
#										#
#################################################################################
#										#
#	06/22/2011: Cadence Constraints Differencing Utility			#
#	Revision history:							#
#	0.1 	Original file					June 22, 2011	#
#	0.7 	Support for more type of design files 		July 26, 2012	#
#		added along with improved error messages.			#
#	0.8 	Handled bugs reported by Sarbjit 		July 27, 2012	#
#	0.9 	Feedback on usability from Sarbjit handled.	July 28, 2012	#
#	1.0 	Corrected the "view" switch while running 	August 03, 2012	#
#		comparison between BE and FE.					#
#	1.1 	In case of Schematic & DCF file selection 	August 30, 2012	#
#		convert the files to Physical mode and then compare.		#
#										#
#################################################################################

set versionString "v1.1 - August 30, 2012"
set fileOne 0
set fileTwo 0
set lastPath ""
set genDCFFileList 0

set isTk [ info exists tk_version ]
if { $isTk == 1 } {
	catch { 
		wm withdraw .
		console show
	}
}

package require Tk

proc displayDiffUI { } {
	global versionString
	global fileOne
	global fileTwo
	global lastPath
	global genDCFFileList
	
	toplevel .diffUI
	wm title .diffUI "Cadence Constraints Differencing Utility - $versionString"
	
	label .diffUI.label_empty1 	-text " "
	label .diffUI.label_empty2 	-text " "
	label .diffUI.label_empty3 	-text " "
	label .diffUI.label_title 	-text "Select the Constraints Files for Comparison"
	
	label .diffUI.label_first_file              	-text "First File:" -justify left -height 2
	entry .diffUI.entry_first_file              	-width 70 -relief sunken -bd 2 -textvariable firstFile
	button .diffUI.button_browse_first_file    	-text "..." 

	label .diffUI.label_second_file         	-text "Second File:" -justify left -height 2
	entry .diffUI.entry_second_file         	-width 70 -relief sunken -bd 2 -textvariable secondFile
	button .diffUI.button_browse_second_file	-text "..." 

	button .diffUI.button_compare           	-text "Compare Files" -state disabled
	button .diffUI.button_close			-text "Close" -command exit

	grid  .diffUI.label_empty1			-row 0 -column 0
	
	grid  .diffUI.label_title			-row 1 -column 1 -columnspan 10

	grid .diffUI.label_first_file			-row 2 -column 1 -sticky w 
	grid .diffUI.entry_first_file			-row 2 -column 3 -sticky w -columnspan 6 
	grid .diffUI.button_browse_first_file		-row 2 -column 9 -sticky w -padx 4
	
	grid .diffUI.label_second_file			-row 3 -column 1 -sticky w 
	grid .diffUI.entry_second_file			-row 3 -column 3 -sticky w -columnspan 6 
	grid .diffUI.button_browse_second_file		-row 3 -column 9 -sticky w -padx 4
	
	grid  .diffUI.label_empty2			-row 4 -column 0
	
	grid .diffUI.button_compare			-row 5 -column 8 -sticky e
	grid .diffUI.button_close			-row 5 -column 9 -sticky w 
	
	grid  .diffUI.label_empty3			-row 6 -column 10
	
	set fileOne 0
	set fileTwo 0
	set extOne 0
	set extTwo 0
	
	bind .diffUI.button_browse_first_file <ButtonRelease> {
		set fileOne 0
		set initialDir "./"
		if { $firstFile != "" } {
			if { [file isdirectory $firstFile] == 1 } {
				set initialDir $firstFile
			} else {
				set initialDir [file dirname $firstFile]
			}
		} elseif { $secondFile != "" } {
			if { [file isdirectory $secondFile] == 1 } {
				set initialDir $secondFile
			} else {
				set initialDir [file dirname $secondFile]
			}
		} elseif { $lastPath != "" } {
			set initialDir $lastPath 
		}
		
		set types { {"Constraints Files" {.dcf .tcf} } {"Design Files" {.brd .sip .mcm} } {"Schematic Projects" {.cpm} } {"All files" *} }
		set firstFile [tk_getOpenFile -filetypes $types -parent .diffUI -initialdir $initialDir]
		
		if { $firstFile != "" } {
			set lastPath [file dirname $firstFile]
		}
		
		set extOne [file extension $firstFile]
		if { $extOne == ".cpm" } {
			set cpmFileName $firstFile
			set cdsLibName [file join [file dirname $cpmFileName] cds.lib]
			set desName [exec -- cpmaccess -read $cpmFileName global design_name ]
			set libName [exec -- cpmaccess -read $cpmFileName global design_library ]
			set viewName "tbl_1"
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName sch_1 ]
				set viewName "sch_1"
			}
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName constraints ]
				set viewName "constraints"
			}
			
			set fileOne 0
			catch { set fileOne [ exec -- libaccess $cdsLibName -path $libName $desName $viewName $desName.dcf ] }
			if { $fileOne == 0 || [file exists $fileOne] == 0 } {
				tk_messageBox -message "Can not find the constraints file ($fileOne) in the schematic project: $cpmFileName.\nPlease select another schematic project." \
					-title "Cadence Constraints Differencing Utility" -icon error -type ok
			} else {
				set phyFileOne "${fileOne}_phys"
				catch { exec -- cmfeedback -renamePhysical $fileOne $phyFileOne }
				if { [file exists $phyFileOne] == 1 } {
					set fileOne $phyFileOne
				}
			}
		} elseif { $extOne == ".brd" || $extOne == ".sip" || $extOne == ".mcm" } {
			set brdFileName $firstFile
			set fileOne [file rootname $brdFileName].dcf
			if { [file exists $fileOne] == 0 } {
				
				processingMessage
				catch { exec -- techfile -w \"$brdFileName\" \"$fileOne\" }
				destroy .diffUI.proMsg
				
				if { $genDCFFileList == 0 } {
					set genDCFFileList [list $fileOne]
				} else {
					set genDCFFileList [lappend genDCFFileList $fileOne]
				}
				
				if { [file exists $fileOne] == 0 } {
					tk_messageBox -message "Can not generate the constraints file for the design: $brdFileName.\nPlease select another design file." \
						-title "Cadence Constraints Differencing Utility" -icon error -type ok
				}
			} else {
				tk_messageBox -message "Existing constraints file $fileOne will be used for the comparison." \
					-title "Cadence Constraints Differencing Utility" -icon warning -type ok		
			}
		} elseif { $extOne == ".dcf" } {
			set fileOne $firstFile
			set phyFileOne "${fileOne}_phys"
			catch { exec -- cmfeedback -renamePhysical $fileOne $phyFileOne }
			if { [file exists $phyFileOne] == 1 } {
				set fileOne $phyFileOne
			}
		} elseif { $extOne == ".tcf" } {
			set fileOne $firstFile
		}
		
		if { $fileOne != 0 && $fileTwo != 0 } {
			.diffUI.button_compare  configure -state normal
		} else {
			.diffUI.button_compare  configure -state disabled
		}
	}

	bind .diffUI.entry_first_file <FocusOut> {
		set fileOne 0
		set extOne [file extension $firstFile]
		if { $extOne == ".cpm" } {
			set cpmFileName $firstFile
			set cdsLibName [file join [file dirname $cpmFileName] cds.lib]
			set desName [exec -- cpmaccess -read $cpmFileName global design_name ]
			set libName [exec -- cpmaccess -read $cpmFileName global design_library ]
			set viewName "tbl_1"
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName sch_1 ]
				set viewName "sch_1"
			}
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName constraints ]
				set viewName "constraints"
			}
			
			set fileOne 0
			catch { set fileOne [ exec -- libaccess $cdsLibName -path $libName $desName $viewName $desName.dcf ] }
			if { $fileOne == 0 || [file exists $fileOne] == 0 } {
				tk_messageBox -message "Can not find the constraints file ($fileOne) in the schematic project: $cpmFileName.\nPlease select another schematic project." \
					-title "Cadence Constraints Differencing Utility" -icon error -type ok
			} else {
				set phyFileOne "${fileOne}_phys"
				catch { exec -- cmfeedback -renamePhysical $fileOne $phyFileOne }
				if { [file exists $phyFileOne] == 1 } {
					set fileOne $phyFileOne
				}
			}
		} elseif { $extOne == ".brd" || $extOne == ".sip" || $extOne == ".mcm" } {
			set brdFileName $firstFile
			set fileOne [file rootname $brdFileName].dcf
			if { [file exists $fileOne] == 0 } {
				
				processingMessage
				catch { exec -- techfile -w \"$brdFileName\" \"$fileOne\" }
				destroy .diffUI.proMsg
				
				if { $genDCFFileList == 0 } {
					set genDCFFileList [list $fileOne]
				} else {
					set genDCFFileList [lappend genDCFFileList $fileOne]
				}
				
				if { [file exists $fileOne] == 0 } {
					tk_messageBox -message "Can not generate the constraints file for the design: $brdFileName.\nPlease select another design file." \
						-title "Cadence Constraints Differencing Utility" -icon error -type ok
				}
			} else {
				if { [lsearch $genDCFFileList $fileOne] == -1 } {
					tk_messageBox -message "Existing constraints file $fileOne will be used for the comparison." \
						-title "Cadence Constraints Differencing Utility" -icon warning -type ok
				}
			}
		} elseif { $extOne == ".dcf" } {
			set fileOne $firstFile
			set phyFileOne "${fileOne}_phys"
			catch { exec -- cmfeedback -renamePhysical $fileOne $phyFileOne }
			if { [file exists $phyFileOne] == 1 } {
				set fileOne $phyFileOne
			}
		} elseif { $extOne == ".tcf" } {
			set fileOne $firstFile
		}
		
		if { $fileOne != 0 && $fileTwo != 0 } {
			.diffUI.button_compare  configure -state normal
		} else {
			.diffUI.button_compare  configure -state disabled
		}
	}
	
	bind .diffUI.button_browse_second_file <ButtonRelease> {
		set fileTwo 0
		set initialDir "./"
		if { $secondFile != "" } {
			if { [file isdirectory $secondFile] == 1 } {
				set initialDir $secondFile
			} else {
				set initialDir [file dirname $secondFile]
			}
		} elseif { $firstFile != "" } {
			if { [file isdirectory $firstFile] == 1 } {
				set initialDir $firstFile
			} else {
				set initialDir [file dirname $firstFile]
			}
		} elseif { $lastPath != "" } {
			set initialDir $lastPath 
		}
		
		set types { {"Constraints Files" {.dcf .tcf} } {"Design Files" {.brd .sip .mcm} } {"Schematic Projects" {.cpm} } {"All files" *} }
		set secondFile [tk_getOpenFile -filetypes $types -parent .diffUI -initialdir $initialDir]
		
		if { $secondFile != "" } {
			set lastPath [file dirname $secondFile]
		}
		
		set extTwo [file extension $secondFile]
		if { $extTwo == ".cpm" } {
			set cpmFileName $secondFile
			set cdsLibName [file join [file dirname $cpmFileName] cds.lib]
			set desName [exec -- cpmaccess -read $cpmFileName global design_name ]
			set libName [exec -- cpmaccess -read $cpmFileName global design_library ]
			set viewName "tbl_1"
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName sch_1 ]
				set viewName "sch_1"
			}
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName constraints ]
				set viewName "constraints"
			}
			
			set fileTwo 0
			catch { set fileTwo [ exec -- libaccess $cdsLibName -path $libName $desName $viewName $desName.dcf ] }
			if { $fileTwo == 0 || [file exists $fileTwo] == 0 } {
				tk_messageBox -message "Can not find the constraints file ($fileTwo) in the schematic project: $cpmFileName.\nPlease select another schematic project." \
					-title "Cadence Constraints Differencing Utility" -icon error -type ok
			} else {
				set phyFileTwo "${fileTwo}_phys"
				catch { exec -- cmfeedback -renamePhysical $fileTwo $phyFileTwo }
				if { [file exists $phyFileTwo] == 1 } {
					set fileTwo $phyFileTwo
				}
			}
		} elseif { $extTwo == ".brd" || $extTwo == ".sip" || $extTwo == ".mcm" } {
			set brdFileName $secondFile
			set fileTwo [file rootname $brdFileName].dcf
			if { [file exists $fileTwo] == 0 } {
				
				processingMessage
				catch { exec -- techfile -w \"$brdFileName\" \"$fileTwo\" }
				destroy .diffUI.proMsg
				
				if { $genDCFFileList == 0 } {
					set genDCFFileList [list $fileTwo]
				} else {
					set genDCFFileList [lappend genDCFFileList $fileTwo]
				}
				
				if { [file exists $fileTwo] == 0 } {
					tk_messageBox -message "Can not generate the constraints file for the design: $brdFileName.\nPlease select another design file." \
						-title "Cadence Constraints Differencing Utility" -icon error -type ok
				}
			} else {
				tk_messageBox -message "Existing constraints file $fileTwo will be used for the comparison." \
					-title "Cadence Constraints Differencing Utility" -icon warning -type ok	
			}
		} elseif { $extTwo == ".dcf" } {
			set fileTwo $secondFile
			set phyFileTwo "${fileTwo}_phys"
			catch { exec -- cmfeedback -renamePhysical $fileTwo $phyFileTwo }
			if { [file exists $phyFileTwo] == 1 } {
				set fileTwo $phyFileTwo
			}
		} elseif { $extTwo == ".tcf" } {
			set fileTwo $secondFile
		}
		
		if { $fileOne != 0 && $fileTwo != 0 } {
			.diffUI.button_compare  configure -state normal
		} else {
			.diffUI.button_compare  configure -state disabled
		}
	}
	
	bind .diffUI.entry_second_file <FocusOut> {
		set fileTwo 0
		set extTwo [file extension $secondFile]
		if { $extTwo == ".cpm" } {
			set cpmFileName $secondFile
			set cdsLibName [file join [file dirname $cpmFileName] cds.lib]
			set desName [exec -- cpmaccess -read $cpmFileName global design_name ]
			set libName [exec -- cpmaccess -read $cpmFileName global design_library ]
			set viewName "tbl_1"
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName sch_1 ]
				set viewName "sch_1"
			}
			catch {
				set viewPath [ exec -- libaccess $cdsLibName -path $libName $desName constraints ]
				set viewName "constraints"
			}
			
			set fileTwo 0
			catch { set fileTwo [ exec -- libaccess $cdsLibName -path $libName $desName $viewName $desName.dcf ] }
			if { $fileTwo == 0 || [file exists $fileTwo] == 0 } {
				tk_messageBox -message "Can not find the constraints file ($fileTwo) in the schematic project: $cpmFileName.\nPlease select another schematic project." \
					-title "Cadence Constraints Differencing Utility" -icon error -type ok
			} else {
				set phyFileTwo "${fileTwo}_phys"
				catch { exec -- cmfeedback -renamePhysical $fileTwo $phyFileTwo }
				if { [file exists $phyFileTwo] == 1 } {
					set fileTwo $phyFileTwo
				}
			}
		} elseif { $extTwo == ".brd" || $extTwo == ".sip" || $extTwo == ".mcm" } {
			set brdFileName $secondFile
			set fileTwo [file rootname $brdFileName].dcf
			if { [file exists $fileTwo] == 0 } {
				
				processingMessage
				catch { exec -- techfile -w \"$brdFileName\" \"$fileTwo\" }
				destroy .diffUI.proMsg
				
				if { $genDCFFileList == 0 } {
					set genDCFFileList [list $fileTwo]
				} else {
					set genDCFFileList [lappend genDCFFileList $fileTwo]
				}
				
				if { [file exists $fileTwo] == 0 } {
					tk_messageBox -message "Can not generate the constraints file for the design: $brdFileName.\nPlease select another design file." \
						-title "Cadence Constraints Differencing Utility" -icon error -type ok
				}
			} else {
				if { [lsearch $genDCFFileList $fileTwo] == -1 } {
					tk_messageBox -message "Existing constraints file $fileTwo will be used for the comparison." \
						-title "Cadence Constraints Differencing Utility" -icon warning -type ok
				}
			}
		} elseif { $extTwo == ".dcf" } {
			set fileTwo $secondFile
			set phyFileTwo "${fileTwo}_phys"
			catch { exec -- cmfeedback -renamePhysical $fileTwo $phyFileTwo }
			if { [file exists $phyFileTwo] == 1 } {
				set fileTwo $phyFileTwo
			}
		} elseif { $extTwo == ".tcf" } {
			set fileTwo $secondFile
		}
		
		if { $fileOne != 0 && $fileTwo != 0 } {
			.diffUI.button_compare  configure -state normal
		} else {
			.diffUI.button_compare  configure -state disabled
		}
	}
	
	bind .diffUI.button_compare <ButtonRelease> {
		if { $fileOne != 0 && $fileTwo != 0 } {
			set view other
			set direction in
			if { $extOne == ".cpm" } {
				if { $extTwo == ".brd" || $extTwo == ".sip" || $extTwo == ".mcm" } {
					set view physical
				}
			} elseif { $extOne == ".brd" || $extOne == ".sip" || $extOne == ".mcm" } {
				if { $extTwo == ".cpm" } {
					set view logical
					set direction out
				}
			}
			
#			comparingMessage
			catch { exec -- cmfeedback -diff3 -Rx $view $direction $fileOne $fileTwo }
#			destroy .diffUI.comMsg
			exit
		}
	}
}

proc processingMessage { } {
	toplevel .diffUI.proMsg
	wm title .diffUI.proMsg "Cadence Constraints Differencing Utility"
	
	label .diffUI.proMsg.label_empty1 	-text " 		"
	label .diffUI.proMsg.label_title	-text "Generating Constraints data from the Design data file..."
	label .diffUI.proMsg.label_empty2 	-text " 		"
	
	grid  .diffUI.proMsg.label_empty1	-row 1 -column 0 -columnspan 10
	grid  .diffUI.proMsg.label_title	-row 2 -column 1 -columnspan 10
	grid  .diffUI.proMsg.label_empty2	-row 3 -column 0 -columnspan 10
	
	wm deiconify .diffUI.proMsg 
	wm geometry .diffUI.proMsg 500x100
	update
}

proc comparingMessage { } {
	toplevel .diffUI.comMsg
	wm title .diffUI.comMsg "Cadence Constraints Differencing Utility"
	
	label .diffUI.comMsg.label_empty1 	-text " 		"
	label .diffUI.comMsg.label_title	-text "Comparing the two databases for Constraints differences..."
	label .diffUI.comMsg.label_empty2 	-text " 		"
	
	grid  .diffUI.comMsg.label_empty1	-row 1 -column 0 -columnspan 10
	grid  .diffUI.comMsg.label_title	-row 2 -column 1 -columnspan 10
	grid  .diffUI.comMsg.label_empty2	-row 3 -column 0 -columnspan 10
	
	wm deiconify .diffUI.comMsg 
	wm geometry .diffUI.comMsg 500x100
	update
}

catch { console hide }
displayDiffUI
