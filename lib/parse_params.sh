#!/bin/bash

# Reusable parameter parsing function
# Usage: source parse_params.sh && parse_params "$@" FLAGS FLAG_DESCRIPTIONS
parse_params() {
    # Handle case where no parameters are passed
    if [[ $# -lt 3 ]]; then
        return 0
    fi
    
    # The last two arguments are the array names
    local flags_array_name="${@: -2:1}"
    local descriptions_array_name="${@: -1:1}"
    
    local -n flags_ref="$flags_array_name"
    local -n descriptions_ref="$descriptions_array_name"

    
    # Get all arguments except the last two (which are array names)
    local args=("${@:1:$(($#-2))}")
    
    for var in "${args[@]}"; do        
        if [[ -n "${flags_ref[$var]}" ]]; then
            declare -g "${flags_ref[$var]}"=true
        else

            echo "Unknown flag: $var"
            echo "Available flags:"
            local max_length=0
            for flag in "${!descriptions_ref[@]}"; do
                if [ ${#flag} -gt $max_length ]; then
                    max_length=${#flag}
                fi
            done

            max_length=$((max_length + 4))

            # Separate flags into two arrays: without -- and with --
            local non_dashed_flags=()
            local dashed_flags=()
            
            for flag in "${!descriptions_ref[@]}"; do
                if [[ "$flag" == --* ]]; then
                    dashed_flags+=("$flag")
                else
                    non_dashed_flags+=("$flag")
                fi
            done

            echo ""

            # Sort both arrays
            IFS=$'\n' non_dashed_flags=($(sort <<<"${non_dashed_flags[*]}"))
            IFS=$'\n' dashed_flags=($(sort <<<"${dashed_flags[*]}"))

            for flag in "${non_dashed_flags[@]}"; do
                printf "  %-${max_length}s %s\n" "$flag" "${descriptions_ref[$flag]}"
            done

            for flag in "${dashed_flags[@]}"; do
                printf "  %-${max_length}s %s\n" "$flag" "${descriptions_ref[$flag]}"
            done
            exit 1
        fi
    done
}

