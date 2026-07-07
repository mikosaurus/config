#!/bin/bash

tailscale_conf() {
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    DRY_RUN=false

    declare -A FLAGS=(
        ["--dry-run"]="DRY_RUN"
    )

    declare -A FLAG_DESCRIPTIONS=(
        ["--dry-run"]="this will not actually do anything, just pretend :D"
    )

    if [[ " $* " == *" --help "* ]]; then
        print_help "tailscale_conf" "Install tailscale and start the login process" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    if command -v tailscale &> /dev/null; then
        echo "tailscale is already installed"
    else
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would install tailscale via official install script"
        else
            echo "Installing tailscale..."
            curl -fsSL https://tailscale.com/install.sh | sh
        fi
    fi
}
