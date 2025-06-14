# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles configuration repository for XDG_CONFIG_HOME, containing configurations for:
- **Neovim**: Full IDE setup with plugins managed by lazy.nvim
- **Tmux**: Terminal multiplexer configuration with plugins
- **Kanata**: Keyboard layout remapping for Nordic keyboards
- **Oh My Zsh**: Custom shell aliases and configurations

## Key Commands

### Apply Configurations
```bash
# Apply all configs (dry run to preview changes)
./apply.sh --dry-run

# Apply all configs
./apply.sh

# Apply with kanata service management
./apply.sh --reload-kanata
./apply.sh --enable-kanata
./apply.sh --disable-kanata
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

### Directory Structure
- Configs are applied to `$XDG_CONFIG_HOME` or `~/.config` as fallback
- Oh My Zsh customizations go to `~/.oh-my-zsh/custom/`
- Kanata service files go to systemd user directory