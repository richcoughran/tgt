#!/bin/bash

# Usage: ./script.sh /path/to/main/folder
main_dir="${1:-/path/to/your/main/folder}"

# Validate the directory
if [[ ! -d "$main_dir" ]]; then
    echo "Error: '$main_dir' is not a valid directory."
    exit 1
fi

# Loop over immediate subdirectories only
find "$main_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
	echo "Directory: $(basename "$subdir")" >> "$main_dir/list.txt"
	for i in {1..5}; do
		matches=$(grep -rl "Basic_Rating\" V=\"${i}\"" "$subdir" --include="*.cos" | xargs -r -L 1 basename | sed 's/....$//')
		if [[ -n "$matches" ]]; then
			count=$(echo "$matches" | wc -l)
			echo "  ${i} Stars ($count files)" >> "$main_dir/list.txt"
			echo "$matches" | sed 's/^/    /' >> "$main_dir/list.txt"
		fi
	done
	echo "" >> "$main_dir/list.txt"
done
