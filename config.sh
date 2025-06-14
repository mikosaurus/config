#!/bin/bash

# Source utilities
source "$(dirname "$0")/lib/parse_params.sh"
source "$(dirname "$0")/lib/help.sh"
source "$(dirname "$0")/lib/nvim.sh"
source "$(dirname "$0")/lib/tmux.sh"
source "$(dirname "$0")/lib/kanata.sh"
source "$(dirname "$0")/lib/hyprland.sh"


# Configuration variables
DRY_RUN=false
RELOAD_KANATA=false
ENABLE_KANATA_SERVICE=false
DISABLE_KANATA_SERVICE=false
NVIM=false
TMUX_CONF=false
ZSH=false
WG=false
HYPRLAND=false

# Flag definitions
declare -A FLAGS=(
    ["nvim"]="NVIM"
    ["tmux"]="TMUX_CONF"
    ["zsh"]="ZSH"
    ["wg"]="WG"
    ["hyprland"]="HYPRLAND"
    ["--reload-kanata"]="RELOAD_KANATA"
    ["--enable-kanata"]="ENABLE_KANATA_SERVICE"
    ["--disable-kanata"]="DISABLE_KANATA_SERVICE"
    ["--dry-run"]="DRY_RUN"
)


# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["nvim"]="copy nvim config"
    ["tmux"]="copy and reload tmux config"
    ["zsh"]="copy zsh config, need to restart or open a new zsh for it to take effect"
    ["wg"]="install wireguard and configure it"
    ["hyprland"]="copy hyprland config to ~/.config/hypr (only if hyprctl is available)"
    ["--reload-kanata"]="with this flag, kanata config will be copied and kanata will be restarted"
    ["--enable-kanata"]="enable kanata systemd service"
    ["--disable-kanata"]="disable kanata systemd service"
    ["--dry-run"]="this will not actually do anything, just pretend :D"
)

# Check for help or no parameters
if [ $# -eq 0 ] || [[ " $* " == *" --help "* ]] || [[ " $* " == *" help "* ]]; then
    print_help "$0" "Apply dotfile configurations to your system with optional component selection and service management" FLAGS FLAG_DESCRIPTIONS
    exit 0
fi

# Parse command line arguments
parse_params "$@" FLAGS FLAG_DESCRIPTIONS


if [ "$DRY_RUN" = true ]; then
    echo "Dry run mode enabled. No changes will be made."
fi

if [ -z "${XDG_CONFIG_HOME}" ]; then
    CONFIG_HOME=~/.config
else
    CONFIG_HOME=${XDG_CONFIG_HOME}
fi

# nvim section
if [ "$NVIM" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        nvim_conf --dry-run 
    else
        nvim_conf
    fi 
fi 

# tmux
if [ "$TMUX_CONF" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        tmux_conf --dry-run 
    else
        tmux_conf
    fi
fi

# zsh
if [ "$ZSH" = true ]; then
    if [ "DRY_RUN" = true ]; then
        zsh_conf --dry-run
    else
        zsh_conf
    fi
fi

# kanata section
KANATA_FLAGS=()
if [ "$DRY_RUN" = true ]; then
    KANATA_FLAGS+=("--dry-run")
fi
if [ "$RELOAD_KANATA" = true ]; then
    KANATA_FLAGS+=("--reload-kanata")
fi
if [ "$ENABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--enable-kanata")
fi
if [ "$DISABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--disable-kanata")
fi

if [ ${#KANATA_FLAGS[@]} -gt 0 ]; then
    kanata_conf "${KANATA_FLAGS[@]}"
fi

# hyprland
if [ "$HYPRLAND" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        hyprland_conf --dry-run 
    else
        hyprland_conf
    fi 
fi 
