#!/bin/bash

# Source utilities
source "$(dirname "$0")/parse_params.sh"
source "$(dirname "$0")/help.sh"

# Configuration variables
DRY_RUN=false

# Flag definitions
declare -A FLAGS=(
    ["--dry-run"]="DRY_RUN"
)

# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["--dry-run"]="this will not actually do anything, just pretend :D"
)

# Check for help or no parameters
if [ $# -eq 0 ] || [[ " $* " == *" --help "* ]]; then
    print_help "$0" "Install wireguard and configure it" FLAGS FLAG_DESCRIPTIONS
    exit 0
fi

# Check if wireguard is installed
if ! command -v wg &> /dev/null; then
    echo "WireGuard is not installed on this system."
    read -p "Would you like to install it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing WireGuard..."
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y wireguard
        elif command -v yum &> /dev/null; then
            sudo yum install -y wireguard-tools
        elif command -v pacman &> /dev/null; then
            sudo pacman -S wireguard-tools
        else
            echo "Package manager not supported. Please install WireGuard manually."
            exit 1
        fi
    else
        echo "Installation cancelled."
        exit 1
    fi
fi
