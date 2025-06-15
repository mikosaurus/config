#!/bin/bash

packages_conf() {
    # Source utilities
    source "$(dirname "$0")/lib/parse_params.sh"
    source "$(dirname "$0")/lib/help.sh"

    # Configuration variables
    DRY_RUN=false

    # Package definitions with installation methods
    declare -A PACKAGES=(
        ["node"]="apt:nodejs pacman:nodejs curl:nvm"
        ["npm"]="apt:npm pacman:npm curl:nvm"
        ["nvm"]="curl:nvm"
        ["go"]="apt:golang-go pacman:go curl:go"
        ["gopls"]="go:gopls"
    )

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
        print_help "packages_conf" "Install development packages" FLAGS FLAG_DESCRIPTIONS
        exit 0
    fi

    # Separate flags from package names
    local package_args=()
    local flag_args=()
    
    for arg in "$@"; do
        if [[ "$arg" == --* ]]; then
            flag_args+=("$arg")
        elif [[ -n "${FLAGS[$arg]}" ]]; then
            flag_args+=("$arg")
        else
            package_args+=("$arg")
        fi
    done

    # Parse command line arguments (flags only)
    if [ ${#flag_args[@]} -gt 0 ]; then
        parse_params "${flag_args[@]}" FLAGS FLAG_DESCRIPTIONS
    fi

    # Detect package manager
    detect_package_manager() {
        if command -v apt &> /dev/null; then
            echo "apt"
        elif command -v pacman &> /dev/null; then
            if command -v paru &> /dev/null; then
                echo "paru"
            else
                echo "pacman"
            fi
        else
            echo "unknown"
        fi
    }

    # Install via apt
    install_apt() {
        local package=$1
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would run: sudo apt update && sudo apt install -y $package"
        else
            echo "Installing $package via apt..."
            sudo apt update && sudo apt install -y "$package"
        fi
    }

    # Install via pacman
    install_pacman() {
        local package=$1
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would run: sudo pacman -S --noconfirm --needed $package"
        else
            echo "Installing $package via pacman..."
            sudo pacman -S --needed "$package"
        fi
    }

    # Install via paru
    install_paru() {
        local package=$1
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would run: paru -S --noconfirm --needed $package"
        else
            echo "Installing $package via paru..."
            paru -S --needed "$package"
        fi
    }

    # Install via go
    install_go() {
        local package=$1
        if ! command -v go &> /dev/null; then
            echo "Go is not installed. Please install Go first."
            return 1
        fi
        
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would run: go install golang.org/x/tools/gopls@latest"
        else
            echo "Installing $package via go install..."
            go install "golang.org/x/tools/$package@latest"
        fi
    }

    # Install via curl (for special cases)
    install_curl() {
        local package=$1
        case $package in
            "nvm")
                if [ "$DRY_RUN" = true ]; then
                    echo "[DRY RUN] Would install NVM via curl script"
                else
                    echo "Installing NVM via curl..."
                    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
                    export NVM_DIR="$HOME/.nvm"
                    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                    echo "NVM installed. Run 'source ~/.bashrc' or restart your shell to use it."
                    echo "Then run 'nvm install node' to install the latest Node.js"
                fi
                ;;
            "go")
                if [ "$DRY_RUN" = true ]; then
                    echo "[DRY RUN] Would install Go via official installer"
                else
                    echo "Installing Go via official installer..."
                    local go_version="1.21.5"
                    local go_os="linux"
                    local go_arch="amd64"
                    
                    # Detect architecture
                    case $(uname -m) in
                        x86_64) go_arch="amd64" ;;
                        aarch64|arm64) go_arch="arm64" ;;
                        armv6l) go_arch="armv6l" ;;
                        *) echo "Unsupported architecture: $(uname -m)"; return 1 ;;
                    esac
                    
                    local go_tar="go${go_version}.${go_os}-${go_arch}.tar.gz"
                    
                    wget -O "/tmp/$go_tar" "https://golang.org/dl/$go_tar"
                    sudo rm -rf /usr/local/go
                    sudo tar -C /usr/local -xzf "/tmp/$go_tar"
                    rm "/tmp/$go_tar"
                    
                    echo "Go installed to /usr/local/go"
                    echo "Add the following to your shell profile:"
                    echo "export PATH=\$PATH:/usr/local/go/bin"
                fi
                ;;
            *)
                echo "Unknown curl package: $package"
                return 1
                ;;
        esac
    }

    # Check if package is already installed
    is_installed() {
        local package=$1
        case $package in
            "node") command -v node &> /dev/null ;;
            "npm") command -v npm &> /dev/null ;;
            "nvm") [ -s "$HOME/.nvm/nvm.sh" ] ;;
            "go") command -v go &> /dev/null ;;
            "gopls") command -v gopls &> /dev/null ;;
            *) false ;;
        esac
    }

    # Install a single package
    install_package() {
        local package=$1
        local pkg_manager=$(detect_package_manager)
        
        if is_installed "$package"; then
            echo "$package is already installed"
            return 0
        fi
        
        if [[ -z "${PACKAGES[$package]}" ]]; then
            echo "Unknown package: $package"
            return 1
        fi
        
        local install_methods="${PACKAGES[$package]}"
        local installed=false
        
        # Try each installation method
        for method in $install_methods; do
            local method_type="${method%%:*}"
            local method_package="${method##*:}"
            
            case $method_type in
                "apt")
                    if [[ "$pkg_manager" == "apt" ]]; then
                        install_apt "$method_package"
                        installed=true
                        break
                    fi
                    ;;
                "pacman")
                    if [[ "$pkg_manager" == "pacman" ]]; then
                        install_pacman "$method_package"
                        installed=true
                        break
                    fi
                    ;;
                "paru")
                    if [[ "$pkg_manager" == "paru" ]]; then
                        install_paru "$method_package"
                        installed=true
                        break
                    fi
                    ;;
                "curl")
                    install_curl "$method_package"
                    installed=true
                    break
                    ;;
                "go")
                    install_go "$method_package"
                    installed=true
                    break
                    ;;
            esac
        done
        
        if [[ "$installed" == false ]]; then
            echo "Could not install $package with available package managers"
            return 1
        fi
    }

    # Default packages to install
    local packages_to_install=("node" "npm" "nvm" "go" "gopls")
    
    # Allow custom package list from package arguments
    if [ ${#package_args[@]} -gt 0 ]; then
        packages_to_install=("${package_args[@]}")
    fi
    
    echo "Installing development packages..."
    echo "Package manager detected: $(detect_package_manager)"
    echo
    
    for package in "${packages_to_install[@]}"; do
        install_package "$package"
        echo
    done
    
    echo "Package installation complete!"
}
