#!/bin/bash

wezterm_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    # Configuration variables
    DRY_RUN=false
    WEZTERM_TYPES=false

    # Flag definitions
    declare -A FLAGS=(
        ["--dry-run"]="DRY_RUN"
        ["--wezterm-types"]="WEZTERM_TYPES"
    )

    # Flag descriptions for help
    declare -A FLAG_DESCRIPTIONS=(
        ["--dry-run"]="this will not actually do anything, just pretend :D"
        ["--wezterm-types"]="install or update wezterm deveoper types"
    )

    # Check for help
    if [[ " $* " == *" --help "* ]]; then
        print_help "$0" "Copy zsh config, need to restart or open a new zsh for it to take effect" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    if [ -z "${XDG_CONFIG_HOME}" ]; then
        CONFIG_HOME=~/.config
    else
        CONFIG_HOME=${XDG_CONFIG_HOME}
    fi

    # Check if wezterm is installed
    if ! command -v wezterm >/dev/null 2>&1; then
        echo "Wezterm is not installed."
        read -p "Would you like to install it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v apt >/dev/null 2>&1; then
                curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
                echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
                sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
                sudo apt update
                sudo apt install wezterm
            elif command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm -needed wezterm
            elif command -v brew >/dev/null 2>&1; then
                brew install wezterm
            fi
        else
            echo "Skipping wezterm installation"
            exit 1
        fi
    fi

    # Check if wezterm is installed
    if command -v wezterm >/dev/null 2>&1; then
        if [ -z "${XDG_CONFIG_HOME}" ]; then
            CONFIG_HOME=~/.config
        else
            CONFIG_HOME=${XDG_CONFIG_HOME}
        fi

        if [ "$DRY_RUN" = false ]; then 
            mkdir -p "$CONFIG_HOME"
            cp -r $ROOT_DIR/wezterm $CONFIG_HOME
            echo "Copying wezterm config to $CONFIG_HOME/wezterm"

            ASSETS_HOME=~/.local/share/mks-assets/assets
            if ! test -d "$ASSETS_HOME"; then
                echo "!!! Note that assets are not available. run config.sh assets to fetch !!!"
            fi
        else
            echo "Copying wezterm config to $CONFIG_HOME/wezterm"
        fi
    fi

    # wezterm
    if [ "$WEZTERM_TYPES" = true ]; then 
        # Check if wezterm is installed
        if command -v wezterm >/dev/null 2>&1; then
            if [ -z "${XDG_CONFIG_HOME}" ]; then
                CONFIG_HOME=~/.config
            else
                CONFIG_HOME=${XDG_CONFIG_HOME}
            fi

            if [ "$DRY_RUN" = false ]; then 
                if ! test -d "$HOME/.local/share/nvim/types/wezterm-types"; then
                    echo "Adding lua lsp types for wezterm"
                    mkdir -p ~/.local/share/nvim/types
                    git clone https://github.com/justinsgithub/wezterm-types ~/.local/share/nvim/types/wezterm-types
                else
                    echo "Updating types with git pull"
                    git -C ~/.local/share/nvim/types/wezterm-types pull
                fi
            else
                if ! test -d "$HOME/.local/share/nvim/types/wezterm-types"; then
                    echo "Adding lua lsp types for wezterm"
                else
                    echo "Updating types with git pull"
                fi
            fi
        fi
    fi 
}

