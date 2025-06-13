#!/bin/bash

# params
# --dry-run - this will not actually do anything, just pretend :D
# --reload-kanata - with this flag, kanata config will be copied and kanata will be restarted

DRY_RUN=false
RELOAD_KANATA=false

for var in "$@"
do
    if [ "$var" =  '--dry-run' ]; then
        DRY_RUN=true
    elif [ "$var" = "--reload-kanata" ]; then
        RELOAD_KANATA=true 
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


