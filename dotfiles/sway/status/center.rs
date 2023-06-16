[theme] 
theme = "native"

[icons]
icons = "awesome4"

[[block]]
block = "custom"
command = "${HOME}/.config/scripts/timewarrior.sh statusbar"
interval=60
[[block.click]]
button = "left"
cmd = "${HOME}/.config/scripts/timewarrior.sh click"

[[block]]
block = "time"
timezone = "US/Pacific"
interval = 1
[block.format]
full = " $icon $timestamp.datetime(f:'%a %Y-%m-%d %H:%M:%S', l:en_US)"
[[block.click]]
button = "left"
cmd = "zenity --calendar"

#[[block]]
#block = "custom"
#command = "echo " # assumes fontawesome icons
#on_click = "~/.config/rofi/bin/menu_powermenu"
#interval = "once"

[[block]]
block = "hueshift"
hue_shifter = "redshift"
step = 500
click_temp = 3000
max_temp=6500
min_temp=1000

[[block]]
block = "notify"
format = " $icon {($notification_count.eng(w:1)) |}"

[[block]]
block = "sound"
step_width = 1
max_vol = 100
name = "alsa_output.pci-0000_2d_00.4.analog-stereo"
#format = " $icon { $volume|} "
##toggle_mute = "left"
format = " $icon { $volume|} "
[block.mappings]
"alsa_output.pci-0000_2d_00.4.analog-stereo" = "Speakers"
"alsa_output.usb-0b0e_Jabra_SPEAK_510_USB_745C4BA487C2021900-00.analog-stereo" = "Conference"
