#!/bin/bash

kanata_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"


    RELOAD_KANATA=false
    ENABLE_KANATA_SERVICE=false
    DISABLE_KANATA_SERVICE=false

    # Flag definitions
    declare -A FLAGS=(
        ["--dry-run"]="DRY_RUN"
        ["--reload-kanata"]="RELOAD_KANATA"
        ["--enable-kanata"]="ENABLE_KANATA_SERVICE"
        ["--disable-kanata"]="DISABLE_KANATA_SERVICE"
    )

    # Flag descriptions for help
    declare -A FLAG_DESCRIPTIONS=(
        ["--dry-run"]="this will not actually do anything, just pretend :D"
        ["--reload-kanata"]="with this flag, kanata config will be copied and kanata will be restarted"
        ["--enable-kanata"]="enable kanata systemd service"
        ["--disable-kanata"]="disable kanata systemd service"
    )

    # Check for help
    if [[ " $* " == *" --help "* ]]; then
        print_help "$0" "Manage kanata keyboard layout configuration and systemd service" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    # kanata 
    if ! command -v kanata >/dev/null 2>&1; then
        echo "kanata not available, install it before retrying kanata at:"
        echo "https://github.com/jtroo/kanata/releases"
        exit 0
    fi

    if [ "$RELOAD_KANATA" = true ]; then 
        if [ "$DRY_RUN" = false ]; then 
            sudo cp $ROOT_DIR/kanata.kbd /usr/share/kanata/kanata.kbd
            # Check if systemd is available
            if command -v systemctl >/dev/null 2>&1; then
                cp $ROOT_DIR/kanata/kanata.service $CONFIG_HOME/systemd/user/kanata.service
                systemctl --user daemon-reload
                systemctl --user restart kanata.service
            else
                echo "systemctl not found - systemd services not supported on this system"
            fi
        else
            echo "Copying kanata.kbd to /usr/share/kanata/kanata.kbd"
            if command -v systemctl >/dev/null 2>&1; then
                echo "Copying kanata.service to $CONFIG_HOME/systemd/user/kanata.service"
            else
                echo "systemctl not found - skipping systemd service setup"
            fi
        fi
    fi

    if [ "$ENABLE_KANATA_SERVICE" = true ]; then 
        if [ "$DRY_RUN" = false ]; then 
            if command -v systemctl >/dev/null 2>&1; then
                systemctl --user enable kanata.service
            else
                echo "systemctl not found - cannot enable service"
            fi
        fi
    fi

    if [ "$DISABLE_KANATA_SERVICE" = true ]; then 
        if [ "$DRY_RUN" = false ]; then 
            if command -v systemctl >/dev/null 2>&1; then
                systemctl --user disable kanata.service
            else
                echo "systemctl not found - cannot disable service"
            fi
        fi
    fi
}
