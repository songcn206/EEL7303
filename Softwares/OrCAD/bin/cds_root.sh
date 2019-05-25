#!/bin/sh

usage_message() {
    echo \
    "    cds_root.sh [-silent | -err | -warn] [-help] <executable_name>" 1>&2
    echo \
    "    cds_root.sh [-silent | -err | -warn] [-help] USE_SCRIPT_LOCATION" 1>&2
}

error_message() {
    echo "Error (cds_root.sh): wrong parameters number" 1>&2
    echo "Usage: " 1>&2
    usage_message
    exit 1
}

help_page() {
    cat <<'END_OF_HELP1' 1>&2
NAME
    cds_root.sh - return location of Cadence installation hierarchy

SYNOPSIS
END_OF_HELP1

    usage_message
    cat <<'END_OF_HELP2' 1>&2

DESCRIPTION
    cds_root.sh is a utility that identifies the location of Cadence 
    installation hierarchies. Startup scripts typically use cds_root.sh 
    to find the location of Cadence installation hierarchies before starting 
    applications. cds_root.sh requires an executable name or special keyword 
    'USE_SCRIPT_LOCATION' as argument. If an executable name is specified, 
    cds_root.sh will look through $PATH for it. If the executable is found in 
    $PATH, cds_root.sh will check to see if the executable is located in 
    a recognizable Cadence hierarchy. If so, it will output the full rooted 
    path of hierarchy to stdout.If the 'USE_SCRIPT_LOCATION' keyword is 
    specified to cds_root.sh, the script will use it's own location to 
    determine installation hierarchy path. cds_root.sh will check if this 
    path is in a recognizable Cadence hierarchy and output full rooted path 
    to hierarchy to stdout.
    
OPTIONS
    
    -silent     If cds_root.sh fails, no messages will be printed,
                but script will still return an error exit status
    -err        If cds_root.sh fails, ERROR message will be printed        
    -warn       If cds_root.sh fails, WARNING message will be printed        
    -help	Display this help page
           
       
END_OF_HELP2

    exit 1
}

scriptStartCmd=$0
scriptName=`basename $0`
scriptBinDir=`dirname $0`
cdsRootBinExe="bin/cds_root.sh"
cdsRootToolsBinExe="tools.`$scriptBinDir/cds_plat`/bin/cds_root"

# one or two arguments allowed only 
if [ "$#" != 1 -a "$#" != 2 ]; then
    error_message    
fi 

# parse arguments
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
    "USE_SCRIPT_LOCATION")
        if [ -z "$askedExe" ]; then
            isLocSwitch=1
        else
            error_message
        fi
        ;;
    h|-h|help|-help)
        help_page
        ;;
    *)
        if [ -z "$isLocSwitch" ]; then
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

currentDir=`pwd`
cd $scriptBinDir 
scriptBinDir=`pwd`
cd $currentDir

if [ ! -z "$askedExe" ]; then
    # binary name supplied as an argument
    pathString=$PATH
    pathElement=$PATH
    # look through each location in $PATH for $askedExe 
    while [ ! -z "`echo $pathString | grep ':'`" -o \
              "${pathElement}" != "${pathBackup}" ];
    do
        pathBackup=$pathElement
        # get next location from $PATH (everything before ':') 
        pathElement=`echo $pathString | sed -e 's/\([^:]*\):.*/\1/'`
        # remove this location from our copy of $PATH 
        # (remove everything before ':') 
        pathString=`echo $pathString | sed -e 's/\([^:]*\):\(.*\)/\2/'`
        # replace empty location ($PATH=::) with '.' 
        if [ -z "${pathElement}" ]; then
            pathElement="."
        fi
        
        # if $pathElement is directory, check if asked binary there
        if [ -d $pathElement ]; then
            currentDir=`pwd`; cd $pathElement
            pathElement=`pwd`; cd $currentDir
            if [ -x $pathElement/$askedExe -o \
                 -f $pathElement/$askedExe ]; then
                exePath=$pathElement/$askedExe
                break # we found given executable name in $PATH
            fi
        fi
    done # while
elif [ "$isLocSwitch" = "1" ]; then
    # USE_SCRIPT_LOCATION supplied as an argument
    # start looking for Cadence hierarchy from script location 
    exePath="$scriptBinDir"
fi

# check if hierarchy we found is a Cadence hierarchy
if [ ! -z "$exePath" ]; then 

    while [ "$exePath" != "/" ];
    do
        # go one level up
        exeDir=`dirname $exePath`
        exePath=$exeDir
        # is there marker file?
        if [ -x $exeDir/$cdsRootBinExe -o \
             -x $exeDir/$cdsRootToolsBinExe ]; then
            cdsRootDir=$exeDir
            break  # marker file found, this is a Cadence hierarchy
        fi
    done

    if [ ! -z "$cdsRootDir" ]; then
        echo "$cdsRootDir"
        exit 0  
    fi
fi

# there is no marker file found, it's not Cadence hierarchy
if [ "$errorLevelMsg" != "SILENT" ]; then
    echo "$errorLevelMsg (cds_root.sh):" \
    "can't determine installation root for '$askedExe'" 1>&2
fi

exit 1
