# Add all ssh keys on the machine we are working on
# Dynamically find all SSH private keys and add them to keychain
if [ -d ~/.ssh ]; then
    SSH_KEYS=($(find ~/.ssh -name "*.pub" -exec basename {} .pub \;))
    for key in ${SSH_KEYS[@]}; do
        eval `keychain --eval --agents ssh "$key"`
    done
fi

