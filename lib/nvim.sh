#!/bin/bash

nvim_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    # Configuration variables
    DRY_RUN=false
    UPDATE=false

    # Flag definitions
    declare -A FLAGS=(
        ["--dry-run"]="DRY_RUN"
        ["--update"]="UPDATE"
    )

    # Flag descriptions for help
    declare -A FLAG_DESCRIPTIONS=(
        ["--dry-run"]="this will not actually do anything, just pretend :D"
        ["--update"]="update nvim if it is installed in /opt/nvim"
    )

    # Check for help
    if [[ " $* " == *" --help "* ]]; then
        print_help "$0" "Copy nvim config to your system" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS


    # Check if neovim is installed
    if ! command -v nvim &> /dev/null; then
        echo "Neovim is not installed."
        read -p "Would you like to install it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing neovim..."
            if command -v apt &> /dev/null; then
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
                sudo rm -rf /opt/nvim
                sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
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

    if command -v nvim &> /dev/null; then
        if [ "$UPDATE" = true ]; then 
            if [ $(which nvim) != "/opt/nvim/bin/nvim" ]; then
                echo "Current nvim installation is somewhere else, clean up or update manually"
            else
                if command -v apt &> /dev/null; then
                    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
                    sudo rm -rf /opt/nvim
                    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
                fi
            fi
        fi
    fi

    if [ -z "${XDG_CONFIG_HOME}" ]; then
        CONFIG_HOME=~/.config
    else
        CONFIG_HOME=${XDG_CONFIG_HOME}
    fi

    if [ "$DRY_RUN" = false ]; then 
        mkdir -p "$CONFIG_HOME"
        cp -r $ROOT_DIR/nvim $CONFIG_HOME
        echo "Copying nvim config to $CONFIG_HOME/nvim"
    else
        echo "Copying nvim config to $CONFIG_HOME/nvim"
    fi
}
