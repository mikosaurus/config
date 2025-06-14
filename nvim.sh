#!/bin/bash

# Source utilities
source "$(dirname "$0")/parse_params.sh"
source "$(dirname "$0")/help.sh"


# Configuration variables
DRY_RUN=false

# Check if neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "Neovim is not installed."
    read -p "Would you like to install it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing neovim..."
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y neovim
        elif command -v pacman &> /dev/null; then
            sudo pacman -S neovim
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y neovim
        elif command -v brew &> /dev/null; then
            brew install neovim
        else
            echo "Could not detect package manager. Please install neovim manually."
            exit 1
        fi
    else
        echo "Skipping neovim installation."
        exit 0
    fi
fi

# Flag definitions
declare -A FLAGS=(
    ["--dry-run"]="DRY_RUN"
)

# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["--dry-run"]="this will not actually do anything, just pretend :D"
)

# Check for help
if [[ " $* " == *" --help "* ]]; then
    print_help "$0" FLAGS FLAG_DESCRIPTIONS
    exit 0
fi

# Parse command line arguments
parse_params "$@" FLAGS FLAG_DESCRIPTIONS

if [ -z "${XDG_CONFIG_HOME}" ]; then
    CONFIG_HOME=~/.config
else
    CONFIG_HOME=${XDG_CONFIG_HOME}
fi

if [ "$DRY_RUN" = false ]; then 
    mkdir -p "$CONFIG_HOME"
    cp -r ./nvim $CONFIG_HOME
else
    echo "Copying nvim config to $CONFIG_HOME/nvim"
fi

