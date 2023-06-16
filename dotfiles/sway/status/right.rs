[theme]
theme = "native"

[icons]
icons = "awesome4"

[[block]]
block = "disk_space"
info_type = "free"
alert_unit = "GB"
alert = 10.0
warning = 15.0
format = " $icon $used.eng(w:2)"
format_alt = " $icon $used / $total "
path = "/"
interval = 60
[[block.click]]
button = "right"
update = true

[[block]]
block = "temperature"
format_alt = " $icon $max max "
format = " $icon $min min, $max max, $average avg "
interval = 10
#chip = "*-isa-*"

[[block]]
block = "memory"
format = " $icon $mem_used($mem_used_percents.eng(w:1)) $mem_avail $mem_used_percents.eng(w:1) "
#format_alt = " $icon_swap $swap_free.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) "
interval = 5
warning_mem = 70
critical_mem = 90

[[block]]
block = "cpu"
interval = 1
format = " $icon $utilization $frequency"
format_alt = " $icon $frequency{ $boost|} "

[[block]]
block = "load"
format = " $icon 1m: $1m.eng(w:4) 5: $5m.eng(w:4) 15: $15m.eng(w:4)"
interval = 5

[[block]]
block = "net"
device = "wlo1"
format = " $speed_down.eng(w:6) $speed_up.eng(w:6) $icon {$ssid $signal_strength | Wired connection}"
#format_alt = " $icon $speed_down $speed_up"
interval = 1
[[block.click]]
button = "left"
cmd = "kitty -e nmtui"

#[[block]]
#block = "networkmanager"
#on_click = "kitty -e nmtui"
#interface_name_exclude = ["br\\-[0-9a-f]{12}", "docker\\d+", "virbr\\d+"]
#interface_name_include = []
#ap_format = "{ssid} {strength}"
#[[block.click]]
#button = "left"
#cmd = "kitty -e nmtui"
