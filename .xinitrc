#!/bin/bash
# This file is executed by xinit, which is usually invoked via startx.
# Thus, login profile setup does not belong here.

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -merge ~/.Xresources
xset b off

# Need to start ibus early because it's wiping input device
# configuration, I think.
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
ibus-daemon -dr

xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

redshift -ox
# redshift forks itself
redshift &
(
    # Double fork
    xbindkeys &
) &

autorandr -c
rm -f ~/.local/state/mir-flags/enable-touchpad # Always start disabled
inputplug -0 -c ~/bin/inputplug-script
exec awesome
