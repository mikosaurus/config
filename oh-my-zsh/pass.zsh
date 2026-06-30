# At new zsh, always do pass git pull to have newest changes
update_pass() {
  pass git pull --quiet
}

if ! command -v nslookup > /dev/null 2>&1; then
    echo "missing nslookup, cannot check if dns server has git server entry"
    return
fi

if [ ! -f ~/.mks/pass.cache ] || \
   [ $(( $(date +%s) - $(date -r ~/.mks/pass.cache +%s) )) -gt 86400 ]; then
  update_pass
  return
fi

if ! nslookup ssh.git.353.no > /dev/null 2>&1; then
  echo "unable to talk to local git server"
else
  mkdir -p ~/.mks
  date > ~/.mks/pass.cache
  update_pass
fi


