#!/bin/zsh
#~/.zprofile
#

mount | grep "${HOME}/mnt/juchap68" >/dev/null || /home/juchap/.opam/default/bin/google-drive-ocamlfuse "${HOME}/mnt/juchap68"&
startx 
