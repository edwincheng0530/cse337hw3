#!bin/bash

SRC_FILE="$1"
DIC_FILE="$2"

# If there aren't exactly 2 inputs, error
if [ "$#" -ne 2 ]; then
    echo "input file and dictionary missing"
    exit 1
fi

# If given SRC_FILE isn't a .txt file, error
if [ ! -f "$SRC_FILE" ] && [[ "$SRC_FILE" == *.txt ]]; then
    echo "$SRC_FILE is not a file"
    exit 1
fi

# If given DIC_FILE isn't a .txt file, error
if [ ! -f "$DIC_FILE" ] && [[ "$DIC_FILE" == *.txt ]]; then
    echo "$DIC_FILE is not a file"
    exit 1
fi

# Find only matching part of regex for each line
grep -o '\b[a-zA-Z]\{4\}\b' "$SRC_FILE" | while read word; do
    # Convert to lowercase for case-insensitive comparison against dictionary
    word_lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')
    
    # Check if the word exists in the dictionary
    if ! grep -qw "$word_lower" "$DIC_FILE"; then
        echo "Misspelled word: $word"
    fi
done


# TEST CASES
# Test cases can be found in prog5_test_cases/test_cases.txt