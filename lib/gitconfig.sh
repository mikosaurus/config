
#!/bin/bash

git_conf() {
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
        print_help "$0" "Copy gitconfig file to home folder" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS


    if [ "$DRY_RUN" = false ]; then 
        cp  $ROOT_DIR/gitconfig/.gitconfig $HOME/.gitconfig 
        echo "Copying gitconfig to $HOME/.gitconfig"
    else
        echo "Copying gitconfig to $HOME/.gitconfig"
    fi

}

