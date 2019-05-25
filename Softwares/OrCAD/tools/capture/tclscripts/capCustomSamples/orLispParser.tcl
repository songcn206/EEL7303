#/////////////////////////////////////////////////////////////////////////////////
#  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
#            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
#            SUPPORT FOR THIS PROGRAM
#      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
#            BEFORE RUNNING THIS PROGRAM
# 	Usage: ::orLispParser::parseLisp <filename example d:/temp/foo.lisp>
# 		 The "process<Entity of lisp file>" functions will be automatically called
#		 Put application specific code in the "process" functions
#		 Example in the following file, all the data returned is being printed
#
# Steps for running in Standalone TCL Shell
# 1. load <orCommonTcl.dll path> orCommonTcl
# 2. load <orParserTcl.dll path> orParser
# 3. source <script path>, 
# 	e.g. source orLispParser.tcl
# 4. ::orLispParser::parseLisp <filename>
# 	e.g. ::orLispParser::parseLisp d:/temp/bipolar.prp
#
#/////////////////////////////////////////////////////////////////////////////////

package require Tcl 8.4
package require OrCommonTcl 
package require orParser 1.0
package provide orLispParser 1.0

namespace eval ::orLispParser {
	namespace export processElement
	namespace export processElementEnd
	
	namespace export processElementLeaf	
}

proc ::orLispParser::processElement { pElemName pElemVal } {
	puts -nonewline "element"
	puts -nonewline " "
	puts -nonewline $pElemName
	puts -nonewline " "
	puts $pElemVal  
}

proc ::orLispParser::processElementEnd { } {
	puts "ElementEnd"
}

proc ::orLispParser::processElementLeaf { pElemLeafName pElemLeafVal } {
	puts -nonewline "elementleaf"
	puts -nonewline " "
	puts -nonewline $pElemLeafName
	puts -nonewline " "
	puts $pElemLeafVal  
}

proc ::orLispParser::parseLisp { filename } {
	::orParseLisp $filename
}



