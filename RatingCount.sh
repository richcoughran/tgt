#!/bin/bash

# Usage: ./script.sh /path/to/main/folder
main_dir="${1:-/path/to/your/main/folder}"

# Validate the directory
if [[ ! -d "$main_dir" ]]; then
    echo "Error: '$main_dir' is not a valid directory."
    exit 1
fi

# Loop over immediate subdirectories only
find "$main_dir" -mindepth 2 -maxdepth 2 -type d | while read -r subdir; do
    # Count .cos files with Basic_Rating="5"
    count_5=$(grep -rl 'Basic_Rating" V="5"' "$subdir" --include="*.cos" 2>/dev/null | wc -l)

    # Count .cos files with Basic_Rating="4"
    count_4=$(grep -rl 'Basic_Rating" V="4"' "$subdir" --include="*.cos" 2>/dev/null | wc -l)

    if [[ $count_5 -gt 0 || $count_4 -gt 0 ]]; then
        echo "Folder: $(basename "$subdir")"
        echo "  5-star images: $count_5"
        echo "  4-star images: $count_4"
    fi
done
