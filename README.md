# Dot files for XDG_CONFIG_HOME

Personal dotfiles configuration repository for XDG_CONFIG_HOME, containing configurations for Neovim, Tmux, Kanata keyboard remapping, and Oh My Zsh customizations.

### Neovim Configuration
- Full IDE setup with plugins managed by lazy.nvim
- Custom key remaps and settings
- Debug configuration (DAP)
- Entry point: `nvim/init.lua` → `lua/miko/init.lua`

### Tmux Configuration  
- Terminal multiplexer with TPM plugin management
- Custom prefix: `C-Space` (with kanata fallback to `C-b`)
- Catppuccin theme with custom status bar
- Config: `tmux/tmux.conf`

### Kanata Keyboard Layout
- Home row modifiers (ASDF HJKL→) for ergonomic typing
- Layer switching for navigation, symbols, and numbers
- Nordic keyboard layout adaptations
- Systemd service configuration included

### Oh My Zsh Customizations
- Custom shell aliases and configurations
- Applied to `~/.oh-my-zsh/custom/`

## Usage

### Quick Setup
```bash
# Apply configurations (preview changes first)
./apply.sh --dry-run --nvim --tmux --reload-kanata

# Apply configurations
# Use flags form nvim, tmux and kanata
./apply.sh --nvim --tmux --reload-kanata

# Print a help message 
./apply.sh --help
```

### Individual Component Setup
```bash
# Setup Neovim (checks for installation)
./nvim.sh

# Setup Tmux (checks for installation) 
./tmux.sh

# Setup Kanata with service management
./apply.sh --reload-kanata
./apply.sh --enable-kanata
./apply.sh --disable-kanata
```

### Manual Kanata Service Management
```bash
# Copy config and restart service
sudo cp ./kanata.kbd /usr/share/kanata/kanata.kbd
systemctl --user daemon-reload  
systemctl --user restart kanata.service
```

## Directory Structure
- Configs applied to `$XDG_CONFIG_HOME` or `~/.config` as fallback
- Oh My Zsh customizations go to `~/.oh-my-zsh/custom/`
- Kanata service files go to systemd user directory


