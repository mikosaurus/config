#!/bin/bash

assets_conf() {
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

    ASSETS_HOME=~/.local/share/mks-assets/assets

    if [ "$DRY_RUN" = false ]; then 
        if test -d "$ASSETS_HOME"; then
            git -C $ASSETS_HOME pull
            echo "Cloning assets..."
            echo "Assets available in $ASSETS_HOME"
        else
            echo "Updating assets with git pull..."
            git clone git@github.com:mikosaurus/assets.git ~/.local/share/mks-assets/assets
            git -C $ASSETS_HOME pull
            echo "Assets available in $ASSETS_HOME"
        fi
    else
        if test -d "$ASSETS_HOME"; then
            echo "Cloning assets..."
            echo "Assets available in $ASSETS_HOME"
        else
            echo "Updating assets with git pull..."
            echo "Assets available in $ASSETS_HOME"
        fi
    fi

}

