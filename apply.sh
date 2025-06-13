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
# cp -r ./nvim $CONFIG_HOME

# tmux
# cp -r ./tmux $CONFIG_HOME
# tmux source-file $CONFIG_HOME/tmux/tmux.conf

# kanata 
# kanata will only copy the file unless the "--reload-kanata" flag


