#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capPortPinMismatch.tcl
#            contains OrCAD Capture Design utlities
#
# You can run the script either in the Capture TCL command window .
#
# Steps for running the script in Capture TCL shell
# 1. source <script path>
#    e.g.  source {D:\SPB166\tools\capture\tclscripts\capDRCFramework\tcl\capProcessDRC.tcl}
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package provide capProcessDRC 1.0


namespace eval ::capProcessDRC {
	variable pageList [list]
}


proc ::capProcessDRC::capProcessPageObjects { drcNamespace pPage } {
	set lStatus [DboState]
	set lNullObj NULL
	
	set startFuncName ::capProcessPageStart
	set PageObjectStartFunc [concat $drcNamespace$startFuncName]
	catch { $PageObjectStartFunc $pPage }  result
	
	#wires
	 set lWiresIter [$pPage NewWiresIter $lStatus]
	 set lWire [$lWiresIter NextWire $lStatus] 
	 while {$lWire !=$lNullObj} {
	 
		set objFuncName ::capProcessWire
		set wireFunc [concat $drcNamespace$objFuncName]
		catch { $wireFunc $lWire }  result
		unset lWire
		set lWire [$lWiresIter NextWire $lStatus] 
		
	 }
	 delete_DboPageWiresIter $lWiresIter
	 $lWiresIter -delete
	 unset lWire
	 
	 #Globals
	 set lGlobalsIter [$pPage NewGlobalsIter $lStatus]
	 set lGlobal [$lGlobalsIter NextGlobal $lStatus]
	 while { $lGlobal!=$lNullObj } { 
	 
		set objFuncName ::capProcessGlobals
		set globalsFunc [concat $drcNamespace$objFuncName]
		catch { $globalsFunc $lGlobal }  result
		unset lGlobal
		set lGlobal [$lGlobalsIter NextGlobal $lStatus]
		
	 }
	delete_DboPageGlobalsIter $lGlobalsIter
	$lGlobalsIter -delete
	unset lGlobal
	
	
	 #Ports
	set lPortsIter [$pPage NewPortsIter $lStatus]
	set lPort [$lPortsIter NextPort $lStatus]
	while {$lPort!=$lNullObj} {
	
		set objFuncName ::capProcessPorts
		set portsFunc [concat $drcNamespace$objFuncName]
		catch { $portsFunc $lPort }  result
		unset lPort
		set lPort [$lPortsIter NextPort $lStatus]
		
	}
	delete_DboPagePortsIter $lPortsIter
	$lPortsIter -delete
	unset lPort

	
	
	#OffPageConnectors
	set lOffPageConnectorsIter [$pPage NewOffPageConnectorsIter $lStatus $::IterDefs_ALL]
	set lOffPageConnector [$lOffPageConnectorsIter NextOffPageConnector $lStatus]
	while {$lOffPageConnector!=$lNullObj} {
	
		set objFuncName ::capProcessOffPageConnector
		set offPageConnectorFunc [concat $drcNamespace$objFuncName]
		catch { $offPageConnectorFunc $lOffPageConnector }  result
		unset lOffPageConnector
		set lOffPageConnector [$lOffPageConnectorsIter NextOffPageConnector $lStatus]
		
	}
	delete_DboPageOffPageConnectorsIter $lOffPageConnectorsIter
	$lOffPageConnectorsIter -delete
	unset lOffPageConnector
	
	
	#TitleBlocks
	set lTitleBlocksIter [$pPage NewTitleBlocksIter $lStatus]
	set lTitle [$lTitleBlocksIter NextTitleBlock $lStatus]
	while {$lTitle!=$lNullObj} {
	
		set objFuncName ::capProcessTitleBlocks
		set titleBlocksFunc [concat $drcNamespace$objFuncName]
		catch { $titleBlocksFunc $lTitle }  result
		unset lTitle
		set lTitle [$lTitleBlocksIter NextTitleBlock $lStatus]
	}
	delete_DboPageTitleBlocksIter $lTitleBlocksIter
	$lTitleBlocksIter -delete
	unset lTitle
		

	#BusEntries
	set lEntriesIter [$pPage NewBusEntriesIter $lStatus]
	set lEntry [$lEntriesIter NextBusEntry $lStatus]
	while {$lEntry != $lNullObj} { 
	
		set objFuncName ::capProcessBusEntries
		set busEntriesFunc [concat $drcNamespace$objFuncName]
		catch { $busEntriesFunc $lEntry }  result
		unset lEntry
		set lEntry [$lEntriesIter NextBusEntry $lStatus]
		
	}
	delete_DboPageBusEntriesIter $lEntriesIter
	$lEntriesIter -delete
	unset lEntry

	
	#PartInsts
	set lPartInstsIter [$pPage NewPartInstsIter $lStatus]
	set lInst [$lPartInstsIter NextPartInst $lStatus]
	while {$lInst!=$lNullObj} {
	
		set objFuncName ::capProcessPartInsts
		set PartInstsFunc [concat $drcNamespace$objFuncName]
		catch { $PartInstsFunc $lInst }  result
		unset lInst
		set lInst [$lPartInstsIter NextPartInst $lStatus]
		  
	}
	delete_DboPagePartInstsIter $lPartInstsIter
	$lPartInstsIter -delete
	unset lInst
	
	set endFuncName ::capProcessPageEnd
	set PageObjectEndFunc [concat $drcNamespace$endFuncName]
	catch { $PageObjectEndFunc $pPage }  result

	$lStatus -delete
	unset lNullObj
}


proc ::capProcessDRC::clearList { pList } {
	set pList [lreplace $pList 0 end]
	return $pList
}

proc ::capProcessDRC::capProcessInstSelectionOccurrence { drcNamespace pInstOcc } {
	set lStatus [DboState]
	set lNullObj NULL
	
	set lSchematic  [$pInstOcc GetSchematic $lStatus]
	set lDesign [$pInstOcc GetOwner]

	set lRootOcc [$lDesign GetRootOccurrence $lStatus]
	
	if { $pInstOcc != $lRootOcc } {
		set lPartInst [$pInstOcc GetPartInst $lStatus] 
		set lOwner [$lPartInst GetOwner]

		set lSearchIndex [lsearch $::capProcessDRC::pageList $lOwner]
		
		if {  $lSearchIndex != -1  }  {
		
			set startFuncName ::capProcessInstOccurenceStart
			set InstOccurenceStartFunc [concat $drcNamespace$startFuncName]
			catch { $InstOccurenceStartFunc $pInstOcc }  result

			set lOffPageOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_OFFPAGES]
			$lOffPageOccIter Sort $lStatus
			set lOffPageOcc [$lOffPageOccIter NextOccurrence $lStatus]
			while { $lOffPageOcc!= $lNullObj} {
				
				set objFuncName ::capProcessOffPageOccurence
				set OffPageOccurenceFunc [concat $drcNamespace$objFuncName]
				catch { $OffPageOccurenceFunc $lOffPageOcc }  result
				unset lOffPageOcc
				set lOffPageOcc [$lOffPageOccIter NextOccurrence $lStatus]
			}
			delete_DboOccurrenceChildrenIter $lOffPageOccIter


			set lPortOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_PORTS]
			$lPortOccIter Sort $lStatus
			set lPortOcc [$lPortOccIter NextOccurrence $lStatus]
			while { $lPortOcc!= $lNullObj} {
				
				set objFuncName ::capProcessPortOccurence
				set PortOccurenceFunc [concat $drcNamespace$objFuncName]
				catch { $PortOccurenceFunc $lPortOcc }  result
				unset lPortOcc
				set lPortOcc [$lPortOccIter NextOccurrence $lStatus]
			}
			delete_DboOccurrenceChildrenIter $lPortOccIter

			

			set lNetOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_NETS]
			$lNetOccIter Sort $lStatus
			set lNetOcc [$lNetOccIter NextOccurrence $lStatus]
			while { $lNetOcc!= $lNullObj} {
				
				set objFuncName ::capProcessNetOccurence
				set NetOccurenceFunc [concat $drcNamespace$objFuncName]
				catch { $NetOccurenceFunc $lNetOcc }  result
				unset lNetOcc
				set lNetOcc [$lNetOccIter NextOccurrence $lStatus]
			}
			delete_DboOccurrenceChildrenIter $lNetOccIter
			
			

			set lTitleBlockOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_TITLEBLOCKS]
			$lTitleBlockOccIter Sort $lStatus
			set lTitleBlockOcc [$lTitleBlockOccIter NextOccurrence $lStatus]
			while { $lTitleBlockOcc!= $lNullObj} {
				
				set objFuncName ::capProcessTitleBlockOccurence
				set TitleBlockOccurenceFunc [concat $drcNamespace$objFuncName]
				catch { $TitleBlockOccurenceFunc $lTitleBlockOcc }  result
				unset lTitleBlockOcc
				set lTitleBlockOcc [$lTitleBlockOccIter NextOccurrence $lStatus]
			}
			delete_DboOccurrenceChildrenIter $lTitleBlockOccIter
		
			set endFuncName ::capProcessInstOccurenceEnd
			set InstOccurenceEndFunc [concat $drcNamespace$endFuncName]
			catch { $InstOccurenceEndFunc $pInstOcc }  result
		}
	}
	
	set lNetOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_NETS]
		$lNetOccIter Sort $lStatus
		set lNetOccObject [$lNetOccIter NextOccurrence $lStatus]
		while { $lNetOccObject!= $lNullObj } {
			set lNetOcc [DboOccurrenceToDboNetOccurrence $lNetOccObject]
			set lSchematicNet [$lNetOcc GetNet $lStatus]
			
			set lDboNetIter [$lSchematicNet NewNetsIter $lStatus]
			set lDboNet [$lDboNetIter NextNet $lStatus]
			
			while { $lDboNet != $lNullObj } {
				
				set lNetOwner [$lDboNet GetOwner]
				set lSearchIndex [lsearch $::capProcessDRC::pageList $lNetOwner]
				if {  $lSearchIndex != -1  }  {
				
					set objFuncName ::capProcessDboNet
					set DboNetFunc [concat $drcNamespace$objFuncName]
					catch { $DboNetFunc $lDboNet }  result
					
				
				}
			
				unset lDboNet
				set lDboNet [$lDboNetIter NextNet $lStatus]
			}
			
			
			unset lNetOccObject
			set lNetOccObject [$lNetOccIter NextOccurrence $lStatus]
		}
	delete_DboOccurrenceChildrenIter $lNetOccIter
	
	set lInstOccIter [$pInstOcc NewChildrenIter $lStatus  $::IterDefs_INSTS]
	$lInstOccIter Sort $lStatus
	set lChildOcc [$lInstOccIter NextOccurrence $lStatus]
	while { $lChildOcc!= $lNullObj} {

		#get the DboInstOccurrence pointer from DboOccurrence pointer
		set lInstOcc [DboOccurrenceToDboInstOccurrence $lChildOcc] 
		
		capProcessDRC::capProcessInstSelectionOccurrence $drcNamespace $lInstOcc
		
		set lChildOcc [$lInstOccIter NextOccurrence $lStatus]
	}
	delete_DboOccurrenceChildrenIter $lInstOccIter
	
	$lStatus -delete
	return 

}

proc ::capProcessDRC::capProcessSelectionOccurences { drcNamespace pDesign } {
	set lStatus [DboState]
	set lRootOcc [$pDesign GetRootOccurrence $lStatus]
	capProcessDRC::capProcessInstSelectionOccurrence $drcNamespace $lRootOcc
	
	unset lRootOcc
	$lStatus -delete
	return
	
}

proc ::capProcessDRC::capProcessSelection { drcNamespace pScope pMode } {

	set lStatus [DboState]
	set lActivePM [GetActivePM]
	if { $pScope == 0 } {
		set lPageIter [COrPMPageIter_sNewPMPageIter $lActivePM $::COrCapPMIter_ALL 0]
	} elseif { $pScope == 1 } {
		set lPageIter [COrPMPageIter_sNewPMPageIter $lActivePM $::COrCapPMIter_SELECTED 0]
	} else {
		#For Future Use
	}
	set lPage [$lPageIter NextPage]
	set lNullObj NULL
	
	set lDesign [GetActivePMDesign]
	if { $lDesign == $lNullObj} {
		return
	}
	
	set ::capProcessDRC::pageList [capProcessDRC::clearList $::capProcessDRC::pageList]
	
	set startFuncName ::capProcessSelectionStart
	set selectionStartFunc [concat $drcNamespace$startFuncName]
	catch { $selectionStartFunc $lDesign }  result

	while { $lPage != $lNullObj} {
	
		if { $pMode == 0 } {
			lappend ::capProcessDRC::pageList $lPage

		} elseif { $pMode == 1} {
			capProcessDRC::capProcessPageObjects $drcNamespace $lPage 
		} else {
			#For future use
		}
		
		set lPage [$lPageIter NextPage]
	}
	delete_COrPMPageIter $lPageIter
	
	if { $pMode == 0 } {
		capProcessDRC::capProcessSelectionOccurences $drcNamespace $lDesign
	}
	
	set endFuncName ::capProcessSelectionEnd
	set selectionEndFunc [concat $drcNamespace$endFuncName]
	catch { $selectionEndFunc $lDesign }  result
	
	return
}

