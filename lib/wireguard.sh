#!/bin/bash

wg_conf() {
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

    # Check for help or no parameters
    if [[ " $* " == *" --help "* ]]; then
        print_help "$0" "Install wireguard and configure it" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    # Check if wireguard is installed
    if ! command -v wg &> /dev/null; then
        if [ "$DRY_RUN" = false ] ; then
            echo "WireGuard is not installed on this system."
            read -p "Would you like to install it? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Installing WireGuard..."
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y wireguard
                elif command -v yum &> /dev/null; then
                    sudo yum install -y wireguard-tools
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S wireguard-tools
                else
                    echo "Package manager not supported. Please install WireGuard manually."
                    exit 1
                fi
            else
                echo "Installation cancelled."
                exit 1
            fi
        else
            echo "Install wireguard?"
        fi
    fi



    # Check if wireguard is installed
    if command -v wg &> /dev/null; then
        if [ -f /etc/wireguard/wg0.conf ]; then
            echo "WireGuard is already installed and configured."
            exit 0
        fi

        # WG_SERVER is a server that you can ssh into. my case is a server with pivpn, 
        # so this is the command that will be used.
        if [ -n "$WG_SERVER" ]; then
            echo "Dry run: $DRY_RUN"
            if [ "$DRY_RUN" = false ] ; then
                MACHINE_NAME="${HOST:-${HOSTNAME:-$(hostname)}}"
                echo "Using: $MACHINE_NAME for wg client name"

                if ssh "$WG_SERVER" "[ -f ~/configs/$MACHINE_NAME.conf ]"; then
                    echo "Config with this hostname already exists. Recreate? (y/n)"
                    read -r answer
                    if [ "$answer" = "y" ]; then
                        ssh -t "$WG_SERVER" "sudo pivpn -a -n $MACHINE_NAME"
                    fi
                else
                    ssh -t "$WG_SERVER" "sudo pivpn -a -n $MACHINE_NAME" 
                fi

                scp "$WG_SERVER:~/configs/$MACHINE_NAME.conf" /tmp/wg0.conf && sudo mv /tmp/wg0.conf /etc/wireguard/wg0.conf
            else
                MACHINE_NAME="${HOST:-${HOSTNAME:-$(hostname)}}"
                echo "Using: $MACHINE_NAME for wg client name"
                echo "ssh \"$WG_SERVER\" \"pivpn -a -n $MACHINE_NAME\""
                echo "scp \"$WG_SERVER:~/configs/$MACHINE_NAME.conf\" /etc/wireguard/wg0.conf"
            fi
        else
            echo "WG_SERVER is not set. Please set it to the server you want to connect to."
            echo "WG_SERVER need to be of format user@host"
        fi
    fi
}
