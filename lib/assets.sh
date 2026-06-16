#!/bin/bash

assets_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    # Configuration variables
    DRY_RUN=false
    USE_GITHUB=false
    REPOSITORY=ssh://git@ssh.git.local.mikosaurus.net/mikosaurus/assets.git
    GITHUB_REPOSITORY=git@github.com/mikosaurus/assets.git

    # Flag definitions
    declare -A FLAGS=(
        ["--dry-run"]="DRY_RUN"
        ["--github"]="USE_GITHUB"
    )

    # Flag descriptions for help
    declare -A FLAG_DESCRIPTIONS=(
        ["--dry-run"]="this will not actually do anything, just pretend :D"
        ["--github"]="use github repository instead of forgejo"
    )

    # Check for help
    if [[ " $* " == *" --help "* ]]; then
        print_help "$0" "Get assets (image files for backgrounds etc)" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    if [ "USE_GITHUB" = true ] ; then
        REPOSITORY=$GITHUB_REPOSITORY
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
            git clone $REPOSITORY ~/.local/share/mks-assets/assets
            git -C $ASSETS_HOME pull
            echo "Assets available in $ASSETS_HOME"
        fi
    else
        if test -d "$ASSETS_HOME"; then
            echo "Cloning assets from $REPOSITORY ..."
            echo "Assets available in $ASSETS_HOME"
        else
            echo "Updating assets with git pull from $REPOSITORY ..."
            echo "Assets available in $ASSETS_HOME"
        fi
    fi

}

