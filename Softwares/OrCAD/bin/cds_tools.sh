#!/bin/sh

usage_message() {
    echo \
    "    cds_tools.sh [-silent | -err | -warn] [-help] <executable_name>" 1>&2
    echo \
    "    cds_tools.sh [-silent | -err | -warn] [-help] USE_SCRIPT_LOCATION" 1>&2
}

error_message() {
    echo "Error (cds_tools.sh): wrong parameters number" 1>&2
    echo "Usage: " 1>&2
    usage_message
    exit 1
}

help_page() {
    cat <<'END_OF_HELP1' 1>&2
NAME
    cds_tools.sh - return location of Cadence "tools" directory

SYNOPSIS
END_OF_HELP1

    usage_message
    cat <<'END_OF_HELP2' 1>&2
    
DESCRIPTION
    cds_tools.sh finds the correct platform specfic tools directory
    for a given executable. If <instDir>/tools is the correct platform,
    it will return that. If <instDir>/tools is not the correct platform,
    it will return <instDir>/tools.<plat>.

    If an executable name is specified, cds_tools.sh will use cds_root.sh
    to identify installation hierarchy for this executable. If
    USE_SCRIPT_LOCATION is provided, it will use its own location to
    find the installation hierarchy.  With the correct Cadence installation
    hierarchy, cds_tools.sh then identifies the path to the correct platform
    specific tools directory under the installation hierarchy and outputs
    a full rooted path to stdout.

    Example outputs:

    /some/path/IC5251/tools
    /some/path/IC5041/tools.sun4v
    /some/path/ncsim55/tools.ibmrs

  
OPTIONS
    
    -silent     If cds_tools.sh fails, no messages will be printed,
                but script will still return an error exit status
    -err        If cds_tools.sh fails, ERROR message will be printed        
    -warn       If cds_tools.sh fails, WARNING message will be printed        
    -help	Display this help page

REQUIREMENTS
    cds_root.sh    
       
END_OF_HELP2

    exit 1
}


scriptBinDir=`dirname $0`
scriptName=`basename $0`
if [ "$scriptBinDir" = "." ]; then
    scriptBinDir=`pwd`
else
    currentDir=`pwd`
    cd $scriptBinDir 
    scriptBinDir=`pwd`
    cd $currentDir
fi


# one or two arguments allowed only 
if [ "$#" != 1 -a "$#" != 2 ]; then
    error_message    
fi 

# parse command line arguments
while [ $# -gt 0 ]
do
    case $1 in
    "-silent")
        if [ -z "${errorLevelMsg}" ]; then
            errorLevelMsg="SILENT"
        else
            error_message
        fi
        ;;
    "-err")
        if [ -z "${errorLevelMsg}" ]; then
            errorLevelMsg="ERROR"
        else
            error_message
        fi
        ;;
    "-warn")
        if [ -z "${errorLevelMsg}" ]; then
            errorLevelMsg="WARNING"
        else
            error_message
        fi
        ;;
    h|-h|help|-help)
        help_page
        ;;
    *)
        if [ -z "$askedExe" ]; then
            askedExe=$1
        else
            error_message
        fi 
        ;;
    esac
    shift
done
if [ -z "$errorLevelMsg" ]; then
    errorLevelMsg="ERROR"  # default value for error messages is ERROR
fi
# done with argument parsing

# get install dir for given executable name
instDir=`$scriptBinDir/cds_root.sh -silent $askedExe`

if [ -z "${instDir}" ]; then 
    if [ "$errorLevelMsg" != "SILENT" ]; then
        echo "$errorLevelMsg (cds_tools.sh):"\
        "Unable to find the Cadence software" 1>&2 
        echo "Make sure that Cadence software is properly installed" 1>&2
    fi
    exit 1    
fi

# Here is pseudo-code for determining tools directory
#     if <myInstDir>/tools/bin/cds_plat.dat corresponds to native platform,
#         return <myInstDir>/tools
#     else if <myInstDir>/tools.<nativePlat> exists
#         return <myInstDir>/tools.<nativePlat>
#     else if <myInstDir>/tools exists and cds_plat.dat could not be read,
#         return <myInstDir>/tools
#     else
#         return FALSE

nativeCdsPlat=`$scriptBinDir/cds_plat`
fileCdsPlat=`cat $instDir/tools/bin/cds_plat.dat 2>/dev/null`
if [ -z "$fileCdsPlat" ]; then
    fileCdsPlat=`cat \
        $instDir/tools.$nativeCdsPlat/bin/cds_plat.dat 2>/dev/null`    
fi
if [ "${nativeCdsPlat}" != "${fileCdsPlat}" -o ! -d "${instDir}/tools" ]; then
    if [ -d "${instDir}/tools.${nativeCdsPlat}" ]; then
        toolsPath="tools.${nativeCdsPlat}"
    elif [ -d "${instDir}/tools" -a -z "${fileCdsPlat}" ]; then
        toolsPath="tools"
    else
        if [ "$errorLevelMsg" != "SILENT" ]; then
            echo \
            "$errorLevelMsg (cds_tools.sh): Unable to find tools path" 1>&2
            echo "Make sure that Cadence software is properly installed" 1>&2
        fi
        exit 1
    fi
else
    toolsPath="tools"
fi

echo "${instDir}/${toolsPath}"

exit 0
