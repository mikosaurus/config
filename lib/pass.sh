#!/bin/bash

pass_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    # Configuration variables
    DRY_RUN=false
    USE_GITHUB=false
    REPOSITORY=ssh://git@ssh.git.local.mikosaurus.net/mikosaurus/pass.git
    GITHUB_REPOSITORY=git@github.com/mikosaurus/pass.git
    PASSWORD_STORE_PATH=~/.password-store

    # Check if pass is installed
    if ! command -v pass &> /dev/null; then
        echo "pass is not installed."
        read -p "Would you like to install it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing pass..."
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y pass
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --needed resolvconf pass
            else
                echo "Could not detect package manager. Please install pass manually."
                exit 1
            fi
        else
            echo "Skipping pass installation."
            exit 0
        fi
    fi

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
        print_help "$0" "Install pass and setup .password-store repository" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    REPO=$REPOSITORY
    if [ "$USE_GITHUB" = true ] ; then
        REPO=$GITHUB_REPOSITORY
    fi


    if [ "$DRY_RUN" = false ] ; then
        git clone $REPOSITORY $PASSWORD_STORE_PATH
    else
        echo "Cloning pass repo..."
    fi
}

