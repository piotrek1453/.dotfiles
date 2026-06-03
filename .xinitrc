#!/bin/zsh
#
#~/.xinitrc
udiskie &
/home/juchap/.dwm/dom.sh &
xrdb -I$HOME ~/.Xresources &
sleep 1 && feh --bg-scale /home/juchap/.dwm/wallpaper.jpg &
sleep 1 && slstatus &
sleep 1 && flameshot &
setxkbmap pl &
while true ; do
  dwm >/dev/null 2>&1
done

