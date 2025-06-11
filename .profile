# This file should be read for login sessions,
# but there is no standard way of doing so in POSIX or X11.
# Supposedly, Bourne shells will read this for login invocations.
#
# This should be kept somewhat up to date with
# ~/.config/environment.d/

# POSIX
export ENV=$HOME/.shrc
export LANG=en_US.UTF-8
export PATH
PATH=$PATH:$HOME/src/google-cloud-sdk/bin
PATH=$HOME/go/bin:$PATH
PATH=$HOME/.cargo/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/bin:$PATH

# Application environment
export ALTERNATE_EDITOR=
export AUR_PAGER=$HOME/bin/dired
export DCONF_PROFILE=$HOME/.config/dconf/profile
export EDITOR=$HOME/bin/med
export GOPROXY=https://proxy.golang.org
export LESSHISTFILE=/dev/null
export PAGER=$HOME/bin/mpager
