#!/bin/bash

ROOT_DIR="${1:-.}"

# Function to check filenames in a directory
check_folder() {
    local folder="$1"
    local base_name
    base_name=$(basename "$folder")

    shopt -s nullglob
    for file in "$folder"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            extension="${filename##*.}"

            if [[ ! "$filename" =~ ^${base_name}_[0-9]{4}\.${extension}$ ]]; then
                echo "Incorrect: $file (Expected prefix: ${base_name}_)"
            fi
        fi
    done
    shopt -u nullglob
}

# Traverse directories, skipping 'metadata'
find "$ROOT_DIR" -type d ! -path "*/CaptureOne*" | while read -r dir; do
    # Check if the folder contains files
    if find "$dir" -maxdepth 1 -type f | grep -q .; then
        check_folder "$dir"
    fi
done
