#!/bin/zsh
#
#~/.xinitrc
/home/juchap/dwm/dom.sh &
xrdb -I$HOME ~/.Xresources &
#(sleep 3; picom) &
setxkbmap pl &
sleep 1 && feh --bg-scale /home/juchap/dwm/wallpaper.jpg &
sleep 1 && slstatus &
sleep 1 && google-drive-ocamlfuse /home/juchap/mnt/juchap68 &
while true ; do
  dwm >/dev/null 2>&1
done
#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#  for f in /etc/X11/xinit/xinitrc.d/*; do
#    [ -x "$f" ] && . "$f"
#  done
#  unset f
#fi
#exec dwm
