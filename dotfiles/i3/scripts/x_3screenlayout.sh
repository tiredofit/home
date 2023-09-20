#!/bin/sh

#xrandr \
#        --output DP-3 --mode 2560x1440 --pos 0x0 --rotate normal \
#        --output DP-2 --primary --mode 2560x1440 --pos 2560x0 --rotate normal \
#        --output HDMI-1 --mode 2560x1440 --pos 5120x0 --rotate normal \
#        --output DP-1 --off \

xrandr \
        --output DisplayPort-2 --mode 2560x1440@120.02 --pos 0x0 --rotate normal \
        --output DisplayPort-1 --primary --mode 2560x1440@120.02 --pos 2560x0 --rotate normal \
        --output HDMI-A-0 --mode 2560x1440 --pos 5120x120.03 --rotate normal \
        --output DP-1 --off \
