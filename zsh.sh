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

# Check if zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh is not installed."
    read -p "Would you like to install zsh? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing zsh..."
        # Add installation command based on OS
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y zsh
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y zsh
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm zsh
        elif command -v brew >/dev/null 2>&1; then
            brew install zsh
        fi
    else
        echo "Skipping zsh installation"
        exit 1
    fi

fi

# Check if oh my zsh is installed
# oh my zsh
# ~/.oh-my-zsh/custom
zshconf=~/.oh-my-zsh
if ! command -v zsh >/dev/null 2>&1; then
    if test -d "$zshconf"; then
        # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        cp oh-my-zsh/* $zshconf/custom/
    else 
        if command -v curl >/dev/null 2>&1; then
            echo "oh my zsh is not installed."
            read -p "Would you like to install oh-my-zsh? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Installing zsh..."
                # Add installation command based on OS
                if command -v apt-get >/dev/null 2>&1; then
                    sudo apt-get update && sudo apt-get install -y zsh
                elif command -v yum >/dev/null 2>&1; then
                    sudo yum install -y zsh
                elif command -v pacman >/dev/null 2>&1; then
                    sudo pacman -S --noconfirm zsh
                elif command -v brew >/dev/null 2>&1; then
                    brew install zsh
                fi
            else
                echo "Skipping oh-my-zsh installation"
            fi
        else
            echo "Cannot install oh my zsh without curl installed, ensure it is installed then try again"
        fi
    fi
fi
