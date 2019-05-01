#!/bin/sh

# rofi_find does not work well
#-show drun -modi drun,run,window,find:~/.i3/rofi_finder.sh

rofi \
    -show drun -modi drun,run,window,find:~/.i3/rofi_finder.sh \
    -theme glue_pro_blue \
    -font 'ubuntu mono 20' \
    -show-icons -drun-icon-theme -matching fuzzy "$@"
