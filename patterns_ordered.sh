#!/bin/bash

_awk_pattern() {
cat << BEGIN
    BEGIN { C_PATTERN=0 }
BEGIN

LAST_INDEX=$((${#PATTERNS[@]} - 1))
for INDEX in ${!PATTERNS[@]};do
[[ ${INDEX} == ${LAST_INDEX} ]] && break
cat << TEMPLATE
    /${PATTERNS[INDEX]}/ {
        if ( C_PATTERN ==  ${INDEX} ) { ++C_PATTERN;next }
    }
TEMPLATE
done

cat << END
    /${PATTERNS[@]: -1}/ {
        if ( C_PATTERN == ${LAST_INDEX} ) { 
            print NR; if ( ${MULTI_MATCH} != 1 ) { exit }
            C_PATTERN=0;next
        }
    }

    {
       if ( ${ALLOW_SPACE} != 1 ) { C_PATTERN=0 }
    }
END
}

# Options List
#####################################################################
# `-m`        - Get all matches within file (Loops over pattern list)
# `-a`        - Allow spaces between patterns
# `-l <LINE>` - Specify line to start file read
#####################################################################

# Argument List: [OPT] ... [FILE] [PATTERN1] ...
# Use `-` as FILE to read from stdin instead
# Prints line of last pattern match
# Use return code to determine if all patterns were matched
patterns_ordered() {
    local LINE_START=0
    local ALLOW_SPACE=0
    local MULTI_MATCH=0
    local OPTIND # getopts var
    # Parse flags
    while getopts "mal:" OPTION; do
    case "$OPTION" in
    m)
        local MULTI_MATCH=1
        ;;
    a)
        local ALLOW_SPACE=1
        ;;
    l)
        if [[ ${OPTARG} =~ [1-9][0-9]* ]];then
            LINE_START=${OPTARG}
        else
            echo "Invalid -l value [${OPTARG}] provided"
            return 1
        fi
        ;;
    *)
        echo "Invalid flag [${OPTARG}] provided"
        return 1
        ;;
    esac
    done
    shift $((OPTIND - 1 ))

    # Set FILE
    local FILE=$1;shift
    if [[ ${FILE} == '-' ]];then
        FILE=
    elif [[ ! -f ${FILE} ]];then
        echo "Invalid file argument"
        return 1
    fi

    # Obtain patterns
    local PATTERNS=()
    for PATTERN in "$@";do
      PATTERNS+=("${PATTERN}")
    done

    # Execute
    local LINE_NUMBERS=($(tail -n +${LINE_START} ${FILE} | awk "$(_awk_pattern)"))
    
    # Finish
    if [[ ! ${LINE_NUMBERS[@]} ]];then
        return 1
    fi
    for LINE_NUMBER in ${LINE_NUMBERS[@]};do
        if [[ ${LINE_START} = 0 ]];then # Starting from the start of the file
            echo ${LINE_NUMBER}
        else # Add line offset into awk NR response
            echo $((LINE_NUMBER + LINE_START - 1))
        fi
    done
}
