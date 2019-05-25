#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
#  TCL file: capCheckPackageOnPartWindowClose.tcl
#/////////////////////////////////////////////////////////////////////////////////

namespace eval ::capCheckPackageOnPartWindowClose {
	
	set duplicatePinNumber ""
	set founddup 0
	
	catch {
		RegisterAction "_cdnCheckPackageOnPartWindowClose"  ::capCheckPackageOnPartWindowClose::Process "" ::capCheckPackageOnPartWindowClose::CheckDuplicatePowerPinNumber ""
	}

	proc Process { args } {
		return 1
	}

	proc CheckDuplicatePowerPinNumber { capPackageObject } {
		set lStatus [DboState]
		set lNullObj NULL
		set pDeviceIter [$capPackageObject NewDevicesIter $lStatus]
		set ldevice [$pDeviceIter NextDevice $lStatus]
		set pinNumber [DboTclHelper_sMakeCString]
		set llist [list]
		set duplist [list]
		set ::duplicatePinNumber ""
		set ::founddup 0
		
		while { $ldevice != $lNullObj } {
			set pCell [$ldevice GetCell $lStatus]
			set  pPartsIter [$pCell NewPartsIter $lStatus]
			set pPart [$pPartsIter NextPart $lStatus]
			while { $pPart != $lNullObj } {
				set pinIter [$pPart NewPinsIter $lStatus]
				set symbolpin [$pinIter NextPin $lStatus]
				while { $symbolpin != $lNullObj } {
					$ldevice GetPinNumber [$symbolpin GetPinPosition $lStatus] $pinNumber		
					if { [string length [DboTclHelper_sGetConstCharPtr $pinNumber]]!=0 &&
							[$symbolpin GetPinType $lStatus]==$::DboValue_POWER } {
						if {[lsearch $llist [DboTclHelper_sGetConstCharPtr $pinNumber]]==-1} {
							lappend llist [DboTclHelper_sGetConstCharPtr $pinNumber]
						} else {
							if {[lsearch $duplist [DboTclHelper_sGetConstCharPtr $pinNumber]]==-1} {
								set ::duplicatePinNumber [concat $::duplicatePinNumber "\"[DboTclHelper_sGetConstCharPtr $pinNumber]\""]
								lappend duplist [DboTclHelper_sGetConstCharPtr $pinNumber]
							}
							set ::founddup 1
						}
					}
					set symbolpin [$pinIter NextPin $lStatus]
				}
				delete_DboSymbolPinsIter $pinIter
				
				# Duplicate Power Pin Not Found. Handle case when one Pin is of the Power and other Non-Power
				if {$::founddup!=1} {
					set pinIter [$pPart NewPinsIter $lStatus]
					set symbolpin [$pinIter NextPin $lStatus]
					while { $symbolpin != $lNullObj } {
						$ldevice GetPinNumber [$symbolpin GetPinPosition $lStatus] $pinNumber		
						if { [string length [DboTclHelper_sGetConstCharPtr $pinNumber]]!=0 &&
								[$symbolpin GetPinType $lStatus]!=$::DboValue_POWER } {
							if {[lsearch $llist [DboTclHelper_sGetConstCharPtr $pinNumber]]!=-1} {
								if {[lsearch $duplist [DboTclHelper_sGetConstCharPtr $pinNumber]]==-1} {
									set ::duplicatePinNumber [concat $::duplicatePinNumber "\"[DboTclHelper_sGetConstCharPtr $pinNumber]\""]
									lappend duplist [DboTclHelper_sGetConstCharPtr $pinNumber]
								}
								set ::founddup 1
							}
						}
						set symbolpin [$pinIter NextPin $lStatus]
					}
					delete_DboSymbolPinsIter $pinIter
				}
				set llist ""
				set pPart [$pPartsIter NextPart $lStatus]
			}
			delete_DboCellPartsIter $pPartsIter
			set ldevice [$pDeviceIter NextDevice $lStatus]
		}
		delete_DboPackageDevicesIter $pDeviceIter
		if {$::founddup==1} {
			set message [concat "Following power pin(s) exists twice in a part: $::duplicatePinNumber"]
			capDisplayMessageBox $message "Duplicate Power Pin Number Warning"
		}
		$lStatus -delete
		DboTclHelper_sReleaseAllCreatedPtrs
		return
	}
}