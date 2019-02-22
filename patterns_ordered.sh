#!/bin/bash

_awk_pattern() {
C_PATTERN=0
cat << BEGIN
    BEGIN { C_PATTERN=0 }
BEGIN
for INDEX in ${!PATTERNS[@]};do
cat << TEMPLATE
    /${PATTERNS[INDEX]}/ {
        if ( C_PATTERN ==  $INDEX ) { ++C_PATTERN }
    }
TEMPLATE
done
cat << END
    END { print C_PATTERN }
END
}

# Argument list: [FILE] [PATTERN1] ...
# Prints number of patterns matched where patterns are asserted in order out of total passed
# Use return code to determine if all patterns were matched
patterns_ordered() {
    local FILE=$1;shift
    local PATTERNS=()
    for PATTERN in "$@";do
      PATTERNS+=("${PATTERN}")
    done
    local PATTERN_NUMBER=$(cat ${FILE} | awk "$(_awk_pattern)")
    echo "${PATTERN_NUMBER} out of ${#PATTERNS[@]} matched"
    if [[ ${#PATTERNS[@]} != ${PATTERN_NUMBER} ]];then
        return 1
    fi
}
