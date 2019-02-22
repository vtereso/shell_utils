**NOTE:** My local environment is using a `mbp` so these serve the purpose of simplifying Bash 3.X, but should be portable for other shells as well.

# Utilities
- `patterns_ordered.sh`
    - This utility accepts a parameters list as follows: `[FILE] [PATTERN1] ...` and prints the number of patterns matched out of the total. The return code will indicate if all patterns were matched.
    - Assertions are made in order to ensure that patterns appear logically within a file. The patterns passed in are regex expressions within the `awk` utility.

