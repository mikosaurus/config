#!/bin/bash

paru_conf() {
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
        print_help "$0" "Install paru AUR helper" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Parse command line arguments
    parse_params "$@" FLAGS FLAG_DESCRIPTIONS

    # Check if paru is already installed
    if command -v paru &> /dev/null; then
        echo "paru is already installed ($(paru --version))"
        return 0
    fi

    # paru requires pacman, so only works on Arch-based distros
    if ! command -v pacman &> /dev/null; then
        echo "paru is an Arch Linux AUR helper and requires pacman."
        return 1
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install paru via git + makepkg"
        echo "[DRY RUN] Would run: sudo pacman -S --needed --noconfirm base-devel git go"
        echo "[DRY RUN] Would run: git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"
    else
        echo "Installing paru..."

        # Ensure base-devel, git, and go are installed
        if ! command -v makepkg &> /dev/null; then
            echo "Installing build dependencies..."
            sudo pacman -S --needed --noconfirm base-devel git go
        fi

        # Clone and build paru
        if [ -d "$HOME/paru" ]; then
            echo "paru directory already exists at $HOME/paru, updating..."
            cd "$HOME/paru" && git pull
        else
            git clone https://aur.archlinux.org/paru.git "$HOME/paru"
            cd "$HOME/paru"
        fi

        makepkg -si
        echo "paru installed successfully."
    fi
}