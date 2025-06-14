#!/bin/bash

# Source the parameter parsing utility
source "$(dirname "$0")/parse_params.sh"

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

# Parse command line arguments
parse_params "$@" FLAGS FLAG_DESCRIPTIONS

if [ -z "${XDG_CONFIG_HOME}" ]; then
    echo "missing XDG_CONFIG_HOME, defauting to ~/.config"
    CONFIG_HOME=~/.config
else
    CONFIG_HOME=${XDG_CONFIG_HOME}
    echo "setting CONFIG_HOME to ${CONFIG_HOME}"
fi

if [ "$DRY_RUN" = false ]; then 
    cp -r ./nvim $CONFIG_HOME
else
    echo "Copying nvim config to $CONFIG_HOME/nvim"
fi

