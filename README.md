**NOTE:** My local environment is a `mbp` so these serve the purpose of simplifying the default Bash 3.X shell, but should be portable for other shells as well.

# Utilities
- `patterns_ordered.sh`
    ```
    Options List
    `-m`        - Get all matches within file (Loops over pattern list)
    `-a`        - Allow spaces between patterns
    `-l <LINE>` - Specify line to start file read
    ```
    - Usage: `[OPT] [FILE] [PATTERN1] ...`
    - Specify `-` as `[FILE]` for stdin 
    - Return code 0 will indicate if all patterns were matched
    - Patterns are regex expressions as permitted within the `awk` utility.

