# This file is executed when Bash is invoked as an interactive non-login shell.
# This file is not ordinarily executed for interactive login shells,
# but see .bash_profile.

# Bash will execute this file if stdin looks like a network connection
# even if it is being invoked non-interactively.
[[ $- != *i* ]] && return

# Set this as early as possible to avoid losing history.
shopt -s histappend

. ~/.shrc

shopt -s globstar
HISTSIZE=10000
HISTFILESIZE=-1
HISTTIMEFORMAT='[%F %T %z] '
HISTCONTROL=ignorespace

[[ -f ~/src/bash-preexec/bash-preexec.sh ]] && . ~/src/bash-preexec/bash-preexec.sh

__mir_prompt_prefix=
if [[ -n ${bash_preexec_imported:-${__bp_imported:-}} ]]; then
    # bash-preexec overrides ignorespace
    # https://github.com/rcaloras/bash-preexec/issues/115
    __mir_prompt_prefix="\[${BOLD}${YELLOW}\]I\[${RESET}\]${__mir_prompt_prefix:- }"

    # atuin setup
    __mir_atuin_args=("--disable-up-arrow")
    if command -v atuin &>/dev/null; then
        if [[ ! :$SHELLOPTS: =~ :(vi|emacs): ]]; then
            # Disable bind warnings when line editing is not available
            __mir_atuin_args+=("--disable-ctrl-r")
        fi
        eval "$(atuin init bash "${__mir_atuin_args[@]}")"
        __mir_prompt_prefix="\[${BOLD}${GREEN}\]A\[${RESET}\]${__mir_prompt_prefix:- }"
    fi
    unset __mir_atuin_args

    preexec_functions+=(__mir_set_start_time)
    precmd_functions+=(__mir_prompt_command)
else
    PROMPT_COMMAND=__mir_prompt_command
fi

__mir_set_start_time() {
    __mir_start_time=$EPOCHSECONDS
}

__mir_prompt_command() {
    local -r exit=$?
    local exit_color="\[${CYAN}\]"
    if [ "$exit" != 0 ]; then
        exit_color="\[${RED}\]"
    fi
    PS1="\[${RESET}\]\
${__mir_prompt_prefix}\
${__mir_start_time:+$(( EPOCHSECONDS - __mir_start_time ))s }\
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
