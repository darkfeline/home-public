alias a="animanager"
alias aa="animanager add"
aar() {
    animanager add "$@"
    animanager register "$@"
}
alias areg="animanager register"
alias as="animanager search"
at() (
    x=$1
    shift 1
    systemd-run --user --on-active="${x}" --timer-property=AccuracySec=100ms "${@}"
)
alias auc="autorandr -c"
alias aw="animanager watch"
alias awb="animanager watchable"
alias ec="emacsclient"
alias ecnw="emacsclient -nw"
alias engi="env | grep -i"
alias g="git"
alias gati="gapi-tokeninfo"
alias gga="go generate ./..."
alias ggua="go get -u ./..."
alias gia="go install ./..."
alias gmt="go mod tidy"
alias gta="go test ./..."
alias jrn="journalctl"
alias jrnu="journalctl --user"
alias la="ls -A"
alias ll="ls -Al"
alias mkd="mkdir -pv"
mkdc() {
    mkdir -pv $1
    cd $1
}
alias netctl="sudo netctl"
alias pac="sudo pacman"
alias path='printf "%s\n" "$PATH" | sed "s/:/\n/g"'
alias psef="ps -ef"
alias psefg="ps -ef | grep"
alias s="sudo"
alias tpr="tput reset"

# systemctl aliases
defalias_sys() {
    eval "alias sys$1=\"systemctl $2\""
    eval "alias sysu$1=\"systemctl --user $2\""
}
defalias_sys "" ""
defalias_sys d "disable"
defalias_sys dn "disable --now"
defalias_sys dr "daemon-reload"
defalias_sys e "enable"
defalias_sys en "enable --now"
defalias_sys r "restart"
unset -f defalias_sys

# Local Variables:
# sh-shell: sh
# End: