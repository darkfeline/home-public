;; Basics
(xbindkey '(mod4 control shift l) "xset s activate")
(xbindkey '(mod4 Return) "alacritty")
(xbindkey '(mod4 p) "rofi -show run")

;; Keyboard functions
(xbindkey 'XF86MonBrightnessUp "xbacklight -inc 8")
(xbindkey 'XF86MonBrightnessDown "xbacklight -dec 8")

;; Media keys
(xbindkey 'XF86AudioLowerVolume "volman -d")
(xbindkey 'XF86AudioRaiseVolume "volman -u")
(xbindkey 'XF86AudioMute "volman -m")
(xbindkey 'XF86AudioNext "mpc next; mpd-notify")
(xbindkey 'XF86AudioPrev "mpc prev; mpd-notify")
(xbindkey 'XF86AudioPlay "mpc toggle; mpd-notify")
(xbindkey 'XF86AudioStop "mpc stop; mpd-notify")
(xbindkey '(shift XF86AudioNext) "mpc del 0; mpd-notify")
(xbindkey '(shift XF86AudioPrev) "mpc seek 0%; mpd-notify")
(xbindkey '(shift XF86AudioPlay) "mpc single; mpd-notify")

;; Extra
(xbindkey '(release mod4 Print) "cd ~/Downloads && scrot -z -s")
(xbindkey '(mod4 r) "pkill -x -USR1 redshift")
(xbindkey '(mod4 i) "backlight-toggle")
