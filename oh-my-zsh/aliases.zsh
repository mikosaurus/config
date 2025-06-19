alias config="~/github.com/mikosaurus/config/config.sh $1"
alias k="kubectl"
alias kube-use-context-home-k3s="kubectl config use-context home-k3s"
alias vpn-up="sudo wg-quick up wg0"
alias vpn-down="sudo wg-quick down wg0"

alias mks="cd ~/github.com/mikosaurus"
alias misc="cd ~/github.com/mikosaurus/misc"
alias notes="cd ~/github.com/mikosaurus/misc/notes"

alias mikopi="ssh pi@mikopi.local.mikosaurus.net"

alias home="cd $HOME"

alias start-clean-postgres="docker run --rm --name dummy-psql -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -d postgres:15"
alias psql-clean-postgres="psql -h 127.0.0.1 -U postgres -d postgres -W"

alias vim="nvim"

alias kanata-service-stop="systemctl --user stop kanata.service"
alias kanata-service-start="systemctl --user start kanata.service"
alias kanata-service-restart="systemctl --user restart kanata.service"
alias kanata-service-enable="systemctl --user enable kanata.service"
alias kanata-service-disable="systemctl --user disable kanata.service"
alias kanata-service-reload="systemctl --user daemon-reload"

alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

clip() {
    $1 | xclip -sel clip
}

