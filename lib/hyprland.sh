#!/bin/bash

hyprland_conf() {
    local dry_run=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    # Check if Hyprland is available
    if ! command -v hyprctl >/dev/null 2>&1; then
        echo "Hyprland not found on system, skipping hyprland config"
        return 0
    fi

    local hypr_config_dir="${CONFIG_HOME}/hypr"
    
    if [ "$dry_run" = true ]; then
        echo "[DRY RUN] Would create directory: $hypr_config_dir"
        echo "[DRY RUN] Would copy hyprland config files to: $hypr_config_dir"
        echo "[DRY RUN] Would copy waybar config to: ${CONFIG_HOME}/waybar"
        echo "[DRY RUN] Would copy rofi config to: ${CONFIG_HOME}/rofi"
        return 0
    fi

    echo "Setting up Hyprland configuration..."
    
    # Create hypr config directory
    mkdir -p "$hypr_config_dir"
    
    # Copy hyprland config files if they exist
    if [ -d "$ROOT_DIR/hyprland" ]; then
        cp -r "$ROOT_DIR/hyprland/"* "$hypr_config_dir/"
        # hyprland.lua takes over from hyprland.conf on Hyprland 0.55+, older versions ignore it
        if [ -f "$hypr_config_dir/hyprland.conf" ]; then
            echo "Note: $hypr_config_dir/hyprland.conf still exists, but is ignored now that hyprland.lua is present"
        fi
        echo "Hyprland config copied to $hypr_config_dir"
    else
        echo "No hyprland config directory found to copy"
    fi

    # Desktop components that hyprland.lua starts or binds to
    local component
    for component in waybar rofi; do
        if [ -d "$ROOT_DIR/$component" ]; then
            mkdir -p "${CONFIG_HOME}/$component"
            cp -r "$ROOT_DIR/$component/"* "${CONFIG_HOME}/$component/"
            echo "$component config copied to ${CONFIG_HOME}/$component"
        fi
    done

    # hyprpaper picks its wallpaper(s) from this directory
    mkdir -p "$hypr_config_dir/wallpapers"
    if [ -z "$(ls -A "$hypr_config_dir/wallpapers")" ]; then
        echo "Note: no wallpaper yet, put an image in $hypr_config_dir/wallpapers"
    fi

    local missing=()
    for component in waybar rofi hyprpaper hyprlock hypridle mako; do
        command -v "$component" >/dev/null 2>&1 || missing+=("$component")
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Note: not installed: ${missing[*]} (install with: ./config.sh pkg desktop)"
    fi

    # Reload waybar if it is running
    pkill -SIGUSR2 waybar 2>/dev/null || true
}
