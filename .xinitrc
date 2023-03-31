#!/bin/zsh
#
#~/.xinitrc
/home/juchap/dwm/dom.sh &
xrdb -I$HOME ~/.Xresources &
#(sleep 3; picom) &
setxkbmap pl &
sleep 1 && feh --bg-scale /home/juchap/dwm/wallpaper.jpg &
sleep 1 && slstatus &
while true ; do
  dwm >/dev/null 2>&1
done

