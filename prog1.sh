#!bin/bash

SRC_DIR="$1"
DST_DIR="$2"

# If there aren't exactly 2 inputs, error
if [ "$#" -ne 2 ]; then
    echo "src and dest dirs are missing"
    exit 1
fi

# If given SRC_DIR isn't a directory, error
if [ ! -d "$SRC_DIR" ]; then
    echo "$SRC_DIR does not exist"
    exit 1
fi

# If given DST_DIR isn't a directory, make the directory
if [ ! -d "$DST_DIR" ]; then
    mkdir -p "$DST_DIR"
fi

# Process each directory found (recursive)
function process_directory() {
    local directory="$1"
    # Obtain number of c files present in current directory
    local num_c_files=$(find "$directory" -maxdepth 1 -name "*.c" -type f | wc -l)
    
    local bool_three_files=false
    # If number of .c files > 3, ask user if they want to copy
    if [ "$num_c_files" -gt 3 ]; then
        ls "$directory"/*.c
        read -p "Do you want to move all these .c files?" input
        if [[ "$input" == "Y" ]] || [[ "$input" == "y" ]]; then
            bool_three_files=true
        fi
    fi

    # Loop through contents in directory
    for file in "$directory"/*; do
        filename=$(basename "$file")
        
        # If it is a directory, process directory recursively
        if [ -d "$file" ]; then
            process_directory "$file"  
        # If it is a file, check that it is a .c file and copy path into new directory
        elif [ -f "$file" ] && [[ "$file" == *.c ]]; then
            if [[ "$num_c_files" -le 3 ]] || [[ "$bool_three_files" == true ]]; then
                relative_path="${file#$SRC_DIR}"
                new_path="$DST_DIR/$relative_path"
                mkdir -p "$(dirname "$new_path")"
                mv "$file" "$new_path"
            fi
        fi
    done
}

# Find number of .c files in orinal SRC_DIR directory
num_c_files=$(find "$SRC_DIR" -maxdepth 1 -name "*.c" -type f | wc -l)
bool_three_files=false
# If number of .c files > 3, prompt user to move files
if [ "$num_c_files" -gt 3 ]; then
    ls "$SRC_DIR"/*.c
    read -p "Do you want to move all these .c files?" input
    if [[ "$input" == "Y" ]] || [[ "$input" == "y" ]]; then
        bool_three_files=true
    fi
fi

# Loop through initial SRC_DIR directory
for file in "$SRC_DIR"/*; do
    filename=$(basename "$file")
    # If content is a directory, call process_directory
    if [ -d "$file" ]; then
        process_directory "$file"
    # If content is a file, check that it is a .c file and copy path into new directory
    elif [ -f "$file" ] && [[ "$file" == *.c ]]; then
        if [[ "$num_c_files" -le 3 ]] || [[ "$bool_three_files" == true ]]; then
            mv $file "$DST_DIR/$filename"
        fi
    fi
done


# TEST CASES
# Test cases can be found in prog1_test_cases/test_cases.txt