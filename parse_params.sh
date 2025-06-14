#!/bin/bash

# Reusable parameter parsing function
# Usage: source parse_params.sh && parse_params "$@" FLAGS FLAG_DESCRIPTIONS
parse_params() {
    # Handle case where no parameters are passed
    if [[ $# -lt 2 ]]; then
        return 0
    fi
    
    local -n flags_ref=$2
    local -n descriptions_ref=$3
    
    # Get all arguments except the last two (which are array names)
    local args=("${@:1:$(($#-2))}")
    
    for var in "${args[@]}"
    do        
        if [[ -n "${flags_ref[$var]}" ]]; then
            declare -g "${flags_ref[$var]}"=true
        else
            echo "Unknown flag: $var"
            echo "Available flags:"
            for flag in "${!descriptions_ref[@]}"; do
                echo "  $flag - ${descriptions_ref[$flag]}"
            done
            exit 1
        fi
    done
}