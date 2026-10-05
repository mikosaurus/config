#!/bin/bash

sddm_conf() {
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
        print_help "$0" "Install sddm and make it the graphical login screen" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    local install_cmd
    if command -v zypper &> /dev/null; then
        install_cmd="sudo zypper install -y sddm-qt6"
    elif command -v pacman &> /dev/null; then
        install_cmd="sudo pacman -S --needed sddm"
    else
        echo "Could not detect package manager. Please install sddm manually."
        return 1
    fi

    # Another enabled display manager would fight sddm over the login screen
    local other
    for other in gdm lightdm lxdm greetd; do
        if systemctl is-enabled --quiet "$other.service" 2>/dev/null; then
            echo "$other is already enabled as display manager, disable it first: sudo systemctl disable $other.service"
            return 1
        fi
    done

    # openSUSE selects the display manager through update-alternatives
    local suse_dm=/usr/lib/X11/displaymanagers/sddm

    if [ "$DRY_RUN" = true ]; then
        command -v sddm &> /dev/null || echo "[DRY RUN] Would run: $install_cmd"
        echo "[DRY RUN] Would run: sudo systemctl set-default graphical.target"
        if command -v zypper &> /dev/null; then
            echo "[DRY RUN] Would run: sudo update-alternatives --set default-displaymanager $suse_dm"
        fi
        echo "[DRY RUN] Would run: sudo systemctl enable sddm.service"
        return 0
    fi

    if command -v sddm &> /dev/null; then
        echo "sddm is already installed"
    else
        echo "Installing sddm..."
        $install_cmd || return 1
    fi

    sudo systemctl set-default graphical.target
    if [ -e "$suse_dm" ]; then
        sudo update-alternatives --set default-displaymanager "$suse_dm"
    fi
    sudo systemctl enable sddm.service

    echo "sddm enabled. Reboot to get the login screen, then pick the Hyprland session."
}
