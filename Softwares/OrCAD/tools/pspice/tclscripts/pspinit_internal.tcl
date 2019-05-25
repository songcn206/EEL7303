#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2012 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////

#  TCL file - pspinit_internal.tcl

variable thisScript [file normalize [info script]]

if { [catch {source [file normalize [file join [file dirname $::thisScript] pspCommonInit.tcl]]}] } {
    puts $::errorInfo
}

# end of file


