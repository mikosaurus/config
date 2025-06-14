#!/bin/bash

# Source utilities
source "$(dirname "$0")/lib/parse_params.sh"
source "$(dirname "$0")/lib/help.sh"

# Configuration variables
DRY_RUN=false
RELOAD_KANATA=false
ENABLE_KANATA_SERVICE=false
DISABLE_KANATA_SERVICE=false
NVIM=false
TMUX=false
ZSH=false
WG=false

# Flag definitions
declare -A FLAGS=(
    ["--dry-run"]="DRY_RUN"
    ["--reload-kanata"]="RELOAD_KANATA"
    ["--enable-kanata"]="ENABLE_KANATA_SERVICE"
    ["--disable-kanata"]="DISABLE_KANATA_SERVICE"
    ["--nvim"]="NVIM"
    ["--tmux"]="TMUX"
    ["--zsh"]="ZSH"
    ["--wg"]="WG"
)


# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["--dry-run"]="this will not actually do anything, just pretend :D"
    ["--reload-kanata"]="with this flag, kanata config will be copied and kanata will be restarted"
    ["--enable-kanata"]="enable kanata systemd service"
    ["--disable-kanata"]="disable kanata systemd service"
    ["--nvim"]="copy nvim config"
    ["--tmux"]="copy and reload tmux config"
    ["--zsh"]="copy zsh config, need to restart or open a new zsh for it to take effect"
    ["--wg"]="install wireguard and configure it"
)


# Check for help or no parameters
if [ $# -eq 0 ] || [[ " $* " == *" --help "* ]]; then
    print_help "$0" "Apply dotfile configurations to your system with optional component selection and service management" FLAGS FLAG_DESCRIPTIONS
    exit 0
fi

# Parse command line arguments
parse_params "$@" FLAGS FLAG_DESCRIPTIONS

if [ "$DRY_RUN" = true ]; then
    echo "Dry run mode enabled. No changes will be made."
fi

if [ -z "${XDG_CONFIG_HOME}" ]; then
    CONFIG_HOME=~/.config
else
    CONFIG_HOME=${XDG_CONFIG_HOME}
fi

# nvim section
if [ "$NVIM" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        ./lib/nvim.sh --dry-run 
    else
        ./lib/nvim.sh
    fi 
fi 

# tmux
if [ "$TMUX" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        ./lib/tmux.sh --dry-run 
    else
        ./lib/tmux.sh
    fi
fi

# zsh
if [ "ZSH" = true ]; then
    if [ "DRY_RUN" = true ]; then
        ./lib/zsh.sh --dry-run
    else
        ./lib/zsh.sh
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
    # ./lib/.oh-my-.sh/custom
    zshconf=./lib/.oh-my-.sh
    if ! command -v zsh >/dev/null 2>&1; then
        if test -d "$zshconf"; then
            # sh -c "$(curl -fsSL https./lib//raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            cp oh-my-zs./lib/* $.shconf/custom/
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
fi

# kanata section
KANATA_FLAGS=()
if [ "$DRY_RUN" = true ]; then
    KANATA_FLAGS+=("--dry-run")
fi
if [ "$RELOAD_KANATA" = true ]; then
    KANATA_FLAGS+=("--reload-kanata")
fi
if [ "$ENABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--enable-kanata")
fi
if [ "$DISABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--disable-kanata")
fi

if [ ${#KANATA_FLAGS[@]} -gt 0 ]; then
    ./lib/kanata.sh "${KANATA_FLAGS[@]}"
fi 
