#!/bin/bash

# Source utilities
source "$(dirname "$0")/lib/parse_params.sh"
source "$(dirname "$0")/lib/help.sh"
source "$(dirname "$0")/lib/nvim.sh"
source "$(dirname "$0")/lib/tmux.sh"
source "$(dirname "$0")/lib/kanata.sh"
source "$(dirname "$0")/lib/zsh.sh"
source "$(dirname "$0")/lib/hyprland.sh"
source "$(dirname "$0")/lib/packages.sh"
source "$(dirname "$0")/lib/wezterm.sh"


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
PKG=false
WEZTERM=false
WEZTERM_TYPES=false
ALL=false

# Flag definitions
declare -A FLAGS=(
    ["all"]="ALL"
    ["nvim"]="NVIM"
    ["tmux"]="TMUX_CONF"
    ["zsh"]="ZSH"
    ["wg"]="WG"
    ["hyprland"]="HYPRLAND"
    ["pkg"]="PKG"
    ["wezterm"]="WEZTERM"
    ["--reload-kanata"]="RELOAD_KANATA"
    ["--enable-kanata"]="ENABLE_KANATA_SERVICE"
    ["--disable-kanata"]="DISABLE_KANATA_SERVICE"
    ["--dry-run"]="DRY_RUN"
    ["--wezterm-types"]="WEZTERM_TYPES"
)


# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["all"]="copy all configs"
    ["nvim"]="copy nvim config"
    ["tmux"]="copy and reload tmux config"
    ["zsh"]="copy zsh config, need to restart or open a new zsh for it to take effect"
    ["wg"]="install wireguard and configure it"
    ["hyprland"]="copy hyprland config to ~/.config/hypr (only if hyprctl is available)"
    ["pkg"]="install development packages"
    ["wezterm"]="install and configure wezterm"
    ["--reload-kanata"]="with this flag, kanata config will be copied and kanata will be restarted"
    ["--enable-kanata"]="enable kanata systemd service"
    ["--disable-kanata"]="disable kanata systemd service"
    ["--dry-run"]="this will not actually do anything, just pretend :D"
    ["--wezterm-types"]="install or update wezterm deveoper types"
)

# Check for help or no parameters
if [ $# -eq 0 ] || [[ " $* " == *" --help "* ]] || [[ " $* " == *" help "* ]]; then
    print_help "$0" "Apply dotfile configurations to your system with optional component selection and service management" FLAGS FLAG_DESCRIPTIONS
    exit 0
fi


# Parse command line arguments and collect package arguments
PKG_ARGS=()
FILTERED_ARGS=()
ARGS=("$@")
i=0
skip_next=0

while [ $i -lt ${#ARGS[@]} ]; do
    if [ $skip_next -gt 0 ]; then
        skip_next=$((skip_next - 1))
        i=$((i + 1))
        continue
    fi
    
    if [[ "${ARGS[$i]}" == "pkg" && $((i + 1)) < ${#ARGS[@]} ]]; then
        # Found pkg flag, collect following non-flag arguments
        FILTERED_ARGS+=("${ARGS[$i]}")  # Keep the pkg flag
        j=$((i + 1))
        while [ $j -lt ${#ARGS[@]} ] && [[ ! "${FLAGS[${ARGS[$j]}]}" ]] && [[ ! "${ARGS[$j]}" == --* ]]; do
            PKG_ARGS+=("${ARGS[$j]}")
            skip_next=$((skip_next + 1))
            j=$((j + 1))
        done
    else
        FILTERED_ARGS+=("${ARGS[$i]}")
    fi
    i=$((i + 1))
done

parse_params "${FILTERED_ARGS[@]}" FLAGS FLAG_DESCRIPTIONS

# Check if "all" is set
if [ "$ALL" = true ]; then
    ALL=true
    NVIM=true
    TMUX_CONF=true
    ZSH=true
    WG=true
    HYPRLAND=true
    PACKAGES=true
    WEZTERM=true
fi

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
KANATA_FLAG_COUNT=0
if [ "$DRY_RUN" = true ]; then
    KANATA_FLAGS+=("--dry-run")
fi
if [ "$RELOAD_KANATA" = true ]; then
    KANATA_FLAGS+=("--reload-kanata")
    KANATA_FLAG_COUNT=0
    # Add some padding
    KANATA_FLAG_COUNT=$((KANATA_FLAG_COUNT + 1))
fi
if [ "$ENABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--enable-kanata")
    KANATA_FLAG_COUNT=$((KANATA_FLAG_COUNT + 1))
fi
if [ "$DISABLE_KANATA_SERVICE" = true ]; then
    KANATA_FLAGS+=("--disable-kanata")
    KANATA_FLAG_COUNT=$((KANATA_FLAG_COUNT + 1))
fi

if [ ${KANATA_FLAG_COUNT} -gt 0 ]; then
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

# packages
if [ "$PKG" = true ]; then 
    if [ "$DRY_RUN" = true ] ; then
        packages_conf --dry-run "${PKG_ARGS[@]}"
    else
        packages_conf "${PKG_ARGS[@]}"
    fi 
fi 

# wezterm
if [ "$WEZTERM" = true ]; then 
    WEZTERM_ARGS=""
    [ "$DRY_RUN" = true ] && WEZTERM_ARGS="--dry-run"
    [ "$WEZTERM_TYPES" = true ] && WEZTERM_ARGS="$WEZTERM_ARGS --wezterm-types"
    wezterm_conf $WEZTERM_ARGS
fi 
