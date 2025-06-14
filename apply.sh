#!/bin/bash

# Configuration variables
DRY_RUN=false
RELOAD_KANATA=false
ENABLE_KANATA_SERVICE=false
DISABLE_KANATA_SERVICE=false

# Flag definitions
declare -A FLAGS=(
    ["--dry-run"]="DRY_RUN"
    ["--reload-kanata"]="RELOAD_KANATA"
    ["--enable-kanata"]="ENABLE_KANATA_SERVICE"
    ["--disable-kanata"]="DISABLE_KANATA_SERVICE"
)

echo "${FLAGS[--dry-run]}"

# Flag descriptions for help
declare -A FLAG_DESCRIPTIONS=(
    ["--dry-run"]="this will not actually do anything, just pretend :D"
    ["--reload-kanata"]="with this flag, kanata config will be copied and kanata will be restarted"
    ["--enable-kanata"]="enable kanata systemd service"
    ["--disable-kanata"]="disable kanata systemd service"
)

# Parse command line arguments
for var in "$@"
do
    if [[ -n "${FLAGS[$var]}" ]]; then
        declare "${FLAGS[$var]}"=true
    else
        echo "Unknown flag: $var"
        echo "Available flags:"
        for flag in "${!FLAG_DESCRIPTIONS[@]}"; do
            echo "  $flag - ${FLAG_DESCRIPTIONS[$flag]}"
        done
        exit 1
    fi
done

if [ -z "${XDG_CONFIG_HOME}" ]; then
    echo "missing XDG_CONFIG_HOME, defauting to ~/.config"
    CONFIG_HOME=~/.config
else
    CONFIG_HOME=${XDG_CONFIG_HOME}
    echo "setting CONFIG_HOME to ${CONFIG_HOME}"
fi

echo $DRY_RUN
echo $RELOAD_KANATA


# nvim
if [ "$DRY_RUN" = false ]; then 
    cp -r ./nvim $CONFIG_HOME
fi

# tmux
if [ "$DRY_RUN" = false ]; then 
    cp -r ./tmux $CONFIG_HOME
    tmux source-file $CONFIG_HOME/tmux/tmux.conf
fi

# kanata 
# kanata will only copy the file unless the "--reload-kanata" flag
if [ "$DRY_RUN" = false ]; then 
    # cp -r ./kanata $CONFIG_HOME
    # sh ./kanata/cponf.sh
    if [ "$RELOAD_KANATA" = true ]; then 
        sudo cp ./kanata.kbd /usr/share/kanata/kanata.kbd
        cp ./kanata/kanata.service $CONFIG_HOME/systemd/user/kanata.service
        systemctl --user daemon-reload
        systemctl --user restart kanata.service
    fi
    if [ "$ENABLE_KANATA_SERVICE" = true ]; then 
        systemctl --user enable kanata.service
    fi
    if [ "$DISABLE_KANATA_SERVICE" = true ]; then 
        systemctl --user disable kanata.service
    fi
fi

# oh my zsh
# /home/anders/.oh-my-zsh/custom

zshconf=~/.oh-my-zsh/custom
if test -d "$zshconf"; then
    cp oh-my-zsh/* ~/.oh-my-zsh/custom/
else 
    echo "could ot find zsh custom folder"
fi
