#!/bin/bash

yay_conf() {
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
        print_help "$0" "Install yay AUR helper" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    # Check if yay is already installed
    if command -v yay &> /dev/null; then
        echo "yay is already installed ($(yay --version | head -1))"
        return 0
    fi

    # yay requires pacman, so only works on Arch-based distros
    if ! command -v pacman &> /dev/null; then
        echo "yay is an Arch Linux AUR helper and requires pacman."
        return 1
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install yay via git + makepkg"
        echo "[DRY RUN] Would run: sudo pacman -S --needed --noconfirm base-devel git"
        echo "[DRY RUN] Would run: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
    else
        echo "Installing yay..."

        # Ensure base-devel and git are installed
        if ! command -v makepkg &> /dev/null; then
            echo "Installing base-devel (required for building yay)..."
            sudo pacman -S --needed --noconfirm debugedit fakeroot base-devel git
        fi

        # Clone and build yay
        if [ -d "$HOME/yay" ]; then
            echo "yay directory already exists at $HOME/yay, updating..."
            cd "$HOME/yay" && git pull
        else
            git clone https://aur.archlinux.org/yay.git "$HOME/yay"
            cd "$HOME/yay"
        fi

        makepkg -si
        echo "yay installed successfully."
    fi
}
