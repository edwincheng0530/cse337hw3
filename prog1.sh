#!bin/bash

SRC_DIR="$1"
DST_DIR="$2"

if [ "$#" -ne 2 ]; then
    echo "src and dest dirs are missing"
    exit 1
fi

if [ ! -d "$SRC_DIR" ]; then
    echo "$SRC_DIR does not exist"
    exit 1
fi

if [ ! -d "$DST_DIR" ]; then
    mkdir -p "$DST_DIR"
fi

function process_directory() {
    local directory="$1"
    local num_c_files=$(find "$directory" -maxdepth 1 -name "*.c" -type f | wc -l)
    
    local bool_three_files=false
    if [ "$num_c_files" -gt 3 ]; then
        ls "$directory"/*.c
        read -p "Do you want to move all these .c files?" input
        if [[ "$input" == "Y" ]] || [[ "$input" == "y" ]]; then
            bool_three_files=true
        fi
    fi

    for file in "$directory"/*; do
        filename=$(basename "$file")
        
        if [ -d "$file" ]; then
            # Recurse into subdirectory
            process_directory "$file"  
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


num_c_files=$(find "$SRC_DIR" -maxdepth 1 -name "*.c" -type f | wc -l)
bool_three_files=false
if [ "$num_c_files" -gt 3 ]; then
    ls "$file"/*.c
    read -p "Do you want to move all these .c files?" input
    if [[ "$input" == "Y" ]] || [[ "$input" == "y" ]]; then
        bool_three_files=true
    fi
fi
for file in "$SRC_DIR"/*; do
    filename=$(basename "$file")
    if [ -d "$file" ]; then
        process_directory "$file"
    elif [ -f "$file" ] && [[ "$file" == *.c ]]; then
        if [[ "$num_c_files" -le 3 ]] || [[ "$bool_three_files" == true ]]; then
            mv $file "$DST_DIR/$filename"
        fi
    fi
done