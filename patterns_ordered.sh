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
# Returns number of patterns matched where patterns are asserted in order
patterns_ordered() {
    FILE=$1;shift
    PATTERNS=($@)
    cat $FILE | awk "$(_awk_pattern)"
}
