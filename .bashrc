# This file is executed when Bash is invoked as an interactive non-login shell.
# This file is not ordinarily executed for interactive login shells,
# but see .bash_profile.

# Bash will execute this file if stdin looks like a network connection
# even if it is being invoked non-interactively.
[[ $- != *i* ]] && return

. ~/.shrc

PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local -r exit=$?
    local exit_color=
    if [ "$exit" != 0 ]; then
        exit_color="\[${RED}\]"
    fi
    PS1="\[${RESET}\]\
↪ ${exit_color}${exit}\[${RESET}\]\
 \D{%Y-%m-%d %H:%M:%S}\
 ${TOOLBOX_PATH+⬢}\
\[${GREEN}\]\u\[${RESET}\]\
@\[${GREEN}\]\h\[${RESET}\]\
:\[${GREEN}\]\w\[${RESET}\] \$ "
    # Update terminal window title.
    case "${TERM:-dumb}" in
        xterm*|alacritty) printf '\e]0;%s@%s\7' "$USER" "$HOSTNAME" ;;
    esac
    # Update history file.
    history -a
}

shopt -s globstar
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=-1
HISTTIMEFORMAT='[%F %T %z] '
HISTCONTROL=ignorespace
