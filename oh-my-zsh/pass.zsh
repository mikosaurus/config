# At new zsh, always do pass git pull to have newest changes
if command -v pass > /dev/null 2>&1; then
    pass git pull --quiet
fi
