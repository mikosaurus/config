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

### WireGuard Configuration
- Automated WireGuard installation and setup
- Client configuration management via SSH
- Cross-platform package manager support

## Usage

### Quick Setup
```bash
# Apply configurations (preview changes first)
./config.sh --dry-run --nvim --tmux --reload-kanata

# Apply configurations
./config.sh --nvim --tmux --zsh --reload-kanata

# Setup WireGuard configuration
./config.sh --wg

# Print help message 
./config.sh --help
```

### Individual Component Setup
```bash
# Setup individual components with dry-run option
./lib/nvim.sh --dry-run
./lib/tmux.sh --dry-run  
./lib/zsh.sh --dry-run
./lib/wireguard.sh --dry-run

# Setup components
./lib/nvim.sh
./lib/tmux.sh
./lib/zsh.sh
./lib/wireguard.sh

# Kanata service management
./config.sh --reload-kanata
./config.sh --enable-kanata  
./config.sh --disable-kanata
```

### Manual Kanata Service Management
```bash
# Copy config and restart service
sudo cp ./kanata.kbd /usr/share/kanata/kanata.kbd
systemctl --user daemon-reload  
systemctl --user restart kanata.service
```

## Directory Structure
```
├── config.sh              # Main configuration script
├── lib/                    # Modular component scripts
│   ├── nvim.sh            # Neovim setup
│   ├── tmux.sh            # Tmux setup  
│   ├── zsh.sh             # Zsh/Oh My Zsh setup
│   ├── kanata.sh          # Kanata keyboard setup
│   ├── wireguard.sh       # WireGuard VPN setup
│   ├── help.sh            # Help utilities
│   └── parse_params.sh    # Parameter parsing utilities
├── nvim/                   # Neovim configuration
├── tmux/                   # Tmux configuration
├── kanata/                 # Kanata keyboard layout
├── oh-my-zsh/             # Zsh customizations
└── CLAUDE.md              # AI assistant instructions
```

**Deployment locations:**
- Configs applied to `$XDG_CONFIG_HOME` or `~/.config` as fallback
- Oh My Zsh customizations go to `~/.oh-my-zsh/custom/`
- Kanata service files go to systemd user directory


