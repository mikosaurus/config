# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles configuration repository for XDG_CONFIG_HOME, containing configurations for:
- **Neovim**: Full IDE setup with plugins managed by lazy.nvim
- **Tmux**: Terminal multiplexer configuration with plugins
- **Kanata**: Keyboard layout remapping for Nordic keyboards
- **Hyprland**: Wayland compositor configuration (auto-detected)
- **Oh My Zsh**: Custom shell aliases and configurations
- **WireGuard**: VPN configuration management

## Key Commands

### Apply Configurations
```bash
# Apply specific configs (dry run to preview changes)
./config.sh nvim tmux zsh --dry-run

# Apply specific configs
./config.sh nvim tmux zsh

# Apply with kanata service management
./config.sh --reload-kanata
./config.sh --enable-kanata
./config.sh --disable-kanata

# Apply hyprland config (only if hyprctl is available)
./config.sh hyprland

# Setup WireGuard
./config.sh wg
```

### Kanata Service Management
```bash
# Copy kanata config manually
sudo cp ./kanata.kbd /usr/share/kanata/kanata.kbd
systemctl --user daemon-reload
systemctl --user restart kanata.service
```

## Architecture

### Neovim Configuration
- Entry point: `nvim/init.lua` → `lua/miko/init.lua`
- Plugin management: `lua/miko/lazy.lua` using lazy.nvim
- Plugins organized in: `lua/miko/plugins/`
- Key remaps: `lua/miko/remap.lua` and `lua/miko/nbremap.lua`
- Settings: `lua/miko/set.lua`
- Debug configuration: `lua/miko/dapconfig.lua`

### Tmux Configuration
- Main config: `tmux/tmux.conf`
- Uses TPM (Tmux Plugin Manager) for plugin management
- Custom prefix: `C-Space` (with kanata remapping fallback to `C-b`)
- Catppuccin theme with custom status bar

### Kanata Keyboard Layout
- Main config: `kanata/kanata.kbd`
- Home row modifiers (ASDF HJKL→) for ergonomic typing
- Layer switching for navigation, symbols, and numbers
- Nordic keyboard layout adaptations
- Systemd service configuration: `kanata/kanata.service`

### Hyprland Configuration
- Auto-detects Hyprland availability using `command -v hyprctl`
- Copies config to `~/.config/hypr/` only if Hyprland is installed
- Gracefully skips if Hyprland is not available

### Component Libraries
- Modular shell functions in `lib/` directory
- Each component (nvim, tmux, zsh, kanata, hyprland, wireguard) has its own script
- All components support `--dry-run` flag for preview
- Parameter parsing and help utilities are centralized

### Directory Structure
- Configs are applied to `$XDG_CONFIG_HOME` or `~/.config` as fallback
- Oh My Zsh customizations go to `~/.oh-my-zsh/custom/`
- Kanata service files go to systemd user directory
- Component scripts organized in `lib/` for modularity