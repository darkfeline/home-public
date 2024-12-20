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

if shopt -q progcomp; then
    # Load standard completions if available and not already loaded.
    # This would usually be sourced by /etc/profile and/or
    # /etc/bash.bashrc, which means it may not be loaded for login
    # sessions that don't start a login shell, like graphical
    # sessions.
    #
    # This should also load everything under /etc/bash_completion.d.
    #
    # I don't know about /etc/bash_completion, but at least on Debian
    # it seems to only source the same file as below, so it's probably
    # just an alias for convenience.
    if [[ ! -v BASH_COMPLETION_VERSINFO \
              && -f /usr/share/bash-completion/bash_completion ]]
    then
        . /usr/share/bash-completion/bash_completion
    fi
fi
