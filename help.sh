#!/bin/bash

# Help utility function for displaying command usage
# Usage: print_help SCRIPT_NAME FLAGS FLAG_DESCRIPTIONS
print_help() {
    local script_name="$1"
    local -n flags_ref=$2
    local -n descriptions_ref=$3
    
    echo "Usage: $script_name [OPTIONS]"
    echo
    echo "Options:"
    
    # Find the longest flag for proper alignment
    local max_length=0
    for flag in "${!flags_ref[@]}"; do
        if [ ${#flag} -gt $max_length ]; then
            max_length=${#flag}
        fi
    done
    
    # Add some padding
    max_length=$((max_length + 4))
    
    # Print each flag with its description
    for flag in "${!flags_ref[@]}"; do
        printf "  %-${max_length}s %s\n" "$flag" "${descriptions_ref[$flag]}"
    done
    
    echo
    echo "  --help                Show this help message"
    echo
}