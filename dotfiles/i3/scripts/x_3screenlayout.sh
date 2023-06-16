#!/bin/sh

xrandr \
        --output DP-3 --mode 2560x1440 --pos 0x0 --rotate normal \
        --output DP-2 --primary --mode 2560x1440 --pos 2560x0 --rotate normal \
        --output HDMI-1 --mode 2560x1440 --pos 5120x0 --rotate normal \
        --output DP-1 --off \
