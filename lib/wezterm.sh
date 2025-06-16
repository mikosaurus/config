#!/bin/bash

wezterm_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

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

    if ! command -v wezterm >/dev/null 2>&1; then
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
}

