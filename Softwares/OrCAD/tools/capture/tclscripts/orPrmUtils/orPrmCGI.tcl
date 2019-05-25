package require orPrmDebug
package provide orPrmCGI 1.0

namespace eval orPrmCGI {
    variable nDebugLevels
    array set nDebugLevels {
        CALL 1
        GENERIC 1
        INIT 1
        EXIT 1
        REQUEST 1
    }

    set nTYPE_HTML   0
    set nTYPE_TEXT   1
    set nTYPE_BINARY 2
    set nTYPE_JSON   3

    variable nModuleName "PRIME_CGI_BASE"

    orPrmDebug::setDebugLevels $nModuleName ::orPrmCGI::nDebugLevels
    orPrmDebug::enableDebug $nModuleName 1
}

proc orPrmCGI::startContent { pType {pTitle "OrCAD Web App"}} {
    variable nModuleName
    fDbg $nModuleName GENERIC
    set lType ""
    set lHeader ""
    switch $pType $::orPrmCGI::nTYPE_HTML {
        set lType "Content-type: text/html; charset=iso-8859-1\n\n"
        set lHeader "<html><head><title> $pTitle </title></head>"
    } $::orPrmCGI::nTYPE_TEXT { 
        set lType "Content-type: text/plain; charset=iso-8859-1\n\n"
        set lHeader ""
    } $::orPrmCGI::nTYPE_BINARY {
        set lType "Content-type: binary\n\n"
        set lHeader ""
    } $::orPrmCGI::nTYPE_JSON {
        set lType "Content-type: application/json; charset=iso-8859-1\n\n"
        set lHeader ""
    }
    puts -nonewline $lType 
    puts -nonewline $lHeader
}

proc orPrmCGI::endContent { pType } {
    variable nModuleName
    fDbg $nModuleName GENERIC

    set lTrailer ""
    switch $pType $::orPrmCGI::nTYPE_HTML {
        set lTrailer "</html>"
    } $::orPrmCGI::nTYPE_TEXT { 
        set lTrailer ""
    } $::orPrmCGI::nTYPE_BINARY {
        set lTrailer ""
    } $::orPrmCGI::nTYPE_JSON {
        set lTrailer ""
    }
    puts $lTrailer
}

proc orPrmCGI::processRequest { pInput pQuery } {
    variable nModuleName
    fDbg $nModuleName REQUEST

    set pInput [string trim $pInput "\""]
    upvar 1 $pQuery lQuery
    set lPairs [split $pInput "&"]
    foreach lPair $lPairs {
        set lNameValueList [split $lPair "="]
        set lName [lindex $lNameValueList 0]
        set lValue [lindex $lNameValueList 1]
        set lQuery($lName) $lValue

        fDbg $nModuleName REQUEST "Name: $lName, Value: $lValue"
    }
}

proc orPrmCGI::parseRequest {} {
    variable nModuleName
    fDbg $nModuleName REQUEST

    set lRet ""
    global env _cgi _cgi_uservar
    if {1 == [info exists env(REQUEST_METHOD)]} {
        if { $env(REQUEST_METHOD) == "GET" } {
            set input $env(QUERY_STRING)
            fDbg $nModuleName REQUEST $input
        } else {
            set input [read stdin $env(CONTENT_LENGTH)]
            fDbg $nModuleName REQUEST "POST DATA: $input"
        }
        #if script blows up later, enable access to the original input.
        set _cgi(input) $input
        set lRet $input
    }
    return $lRet
}


