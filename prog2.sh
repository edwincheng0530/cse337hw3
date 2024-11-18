#!bin/bash

SRC_FILE="$1"
DST_FILE="$2"

# If there aren't exactly 2 inputs, error
if [ "$#" -ne 2 ]; then
    echo "data file or output file not found"
    exit 1
fi

# If given SRC_FILE isn't a valid file, error
if [ ! -f "$SRC_FILE" ]; then
    echo "$SRC_FILE not found"
    exit 1
fi

# If given DST_FILE isn't a valid file, make the file
if [ ! -f "$DST_FILE" ]; then
   mkdir -p "$(dirname "$DST_FILE")"
fi

awk '
BEGIN {
    FS="[,;:]"
    max_cols = 0
}
{
    # Update the maximum number of columns if necessary
    if (NF > max_cols) max_cols = NF
    
    # Add each value to its corresponding column sum
    for (i = 1; i <= NF; i++) {
        col_sums[i] += $i
    }
}
END {
    # Print results to output file
    for (i = 1; i <= max_cols; i++) {
        printf "Col %d : %d\n", i, col_sums[i]
    }
}' "$SRC_FILE" > "$DST_FILE"



# TEST CASES
# Test cases can be found in prog2_test_cases/test_cases.txt