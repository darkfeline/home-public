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
PATH=$HOME/.nix-profile/bin:$PATH
PATH=$HOME/go/bin:$PATH
PATH=$HOME/.cargo/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/bin:$PATH

# Application environment
export DCONF_PROFILE=$HOME/.config/dconf/profile
export GOPROXY=https://proxy.golang.org

if [ -z "${SSH_AUTH_SOCK:-}" ] && [ -n "${XDG_RUNTIME_DIR:-}" ]; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
fi

# Set remote dbus socket for notifications, etc.
# We need an intermediate variable because sometimes PAM is setup to
# override DBUS_SESSION_BUS_ADDRESS.
if [ -n "${SSH_CONNECTION:-}" ] && [ -n "${REMOTE_DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    export DBUS_SESSION_BUS_ADDRESS=$REMOTE_DBUS_SESSION_BUS_ADDRESS
fi

if [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
