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
        return 0
    fi

    echo "Setting up Hyprland configuration..."
    
    # Create hypr config directory
    mkdir -p "$hypr_config_dir"
    
    # Copy hyprland config files if they exist
    if [ -d "$(dirname "$0")/hyprland" ]; then
        cp -r "$(dirname "$0")/hyprland/"* "$hypr_config_dir/"
        echo "Hyprland config copied to $hypr_config_dir"
    else
        echo "No hyprland config directory found to copy"
    fi
}