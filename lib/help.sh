#!/bin/bash

# Help utility function for displaying command usage
# Usage: print_help SCRIPT_NAME MAIN_DESCRIPTION FLAGS FLAG_DESCRIPTIONS
print_help() {
    local script_name="$1"
    local main_description="$2"
    local -n flags_ref=$3
    local -n descriptions_ref=$4
    
    echo "$main_description"
    echo
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
    
    # Separate flags into two arrays: without -- and with --
    local non_dashed_flags=()
    local dashed_flags=()
    
    for flag in "${!flags_ref[@]}"; do
        if [[ "$flag" == --* ]]; then
            dashed_flags+=("$flag")
        else
            non_dashed_flags+=("$flag")
        fi
    done
    
    # Sort both arrays
    IFS=$'\n' non_dashed_flags=($(sort <<<"${non_dashed_flags[*]}"))
    IFS=$'\n' dashed_flags=($(sort <<<"${dashed_flags[*]}"))
    
    # Print non-dashed flags first
    for flag in "${non_dashed_flags[@]}"; do
        printf "  %-${max_length}s %s\n" "$flag" "${descriptions_ref[$flag]}"
    done
    
    # Print dashed flags second
    for flag in "${dashed_flags[@]}"; do
        printf "  %-${max_length}s %s\n" "$flag" "${descriptions_ref[$flag]}"
    done
    
    echo
    echo "  --help                Show this help message"
    echo
}
