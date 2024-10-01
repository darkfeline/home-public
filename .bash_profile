# This file is executed when Bash is invoked as an interactive login shell,
# or as a non-interactive shell with the --login option.
#
# Note that Bash will also source /etc/profile before and in addition
# to this file (but not .profile).
. ~/.profile
# Bash does not read .bashrc when it is invoked as an interactive
# login shell, so we must do it ourselves.
[[ $- == *i* ]] && . ~/.bashrc
