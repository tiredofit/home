{ config, lib, pkgs, ... }:
with lib; {
  config = {
    home.file = {
      "${config.home.homeDirectory}/.config/scripts/zerotier_helper.sh" = {
        executable = true;
        text = ''
#!/usr/bin/env bash

AUTO_ADD=''${AUTO_ADD:-"true"}

cut=${pkgs.coreutils}/bin/cut
grep=${pkgs.gnugrep}/bin/grep
notify=${pkgs.libnotify}/bin/notify-send
rofi=${pkgs.rofi}/bin/rofi
sed=${pkgs.gnused}/bin/sed
zerotier="sudo ${pkgs.zerotierone}/bin/zerotier-cli"

for cmd in ''${cut} ''${grep} ''${notify} ''${rofi} ''${sed}; do
  if [ ! -x "''${cmd}" ] ; then
    echo "Required command not found: ''${cmd}" >&2
    exit 1
  fi
done



known_networks_file="''${HOME}/.config/zerotier/known-zt-networks"

if [ ! -d "$(dirname "''${known_networks_file}")" ]; then

  # ------------------ Kill-switch helpers ------------------
  killswitch_state_file="''${HOME}/.config/zerotier/zt_killswitch_enabled"

  enable_killswitch() {
    sudo iptables -N ZT_KILLSWITCH 2>/dev/null || true
    sudo iptables -F ZT_KILLSWITCH
    sudo iptables -I OUTPUT -j ZT_KILLSWITCH
    sudo iptables -A ZT_KILLSWITCH -o lo -j ACCEPT
    sudo iptables -A ZT_KILLSWITCH -o zt+ -j ACCEPT
    sudo iptables -A ZT_KILLSWITCH -j DROP
    touch "''${killswitch_state_file}"
    ''${notify} "ZeroTier" "Killswitch enabled"
  }

  disable_killswitch() {
    sudo iptables -D OUTPUT -j ZT_KILLSWITCH 2>/dev/null || true
    sudo iptables -F ZT_KILLSWITCH 2>/dev/null || true
    sudo iptables -X ZT_KILLSWITCH 2>/dev/null || true
    rm -f "''${killswitch_state_file}" 2>/dev/null || true
    ''${notify} "ZeroTier" "Killswitch disabled"
  }

  killswitch_status() {
    if [ -f "''${killswitch_state_file}" ]; then echo "enabled"; else echo "disabled"; fi
  }

  monitor_killswitch_loop() {
    prev_default_active=0
    if check_default_route_active; then prev_default_active=1; fi
    while true; do
      sleep 3
      if check_default_route_active; then
        if [ "$prev_default_active" -eq 0 ]; then
          disable_killswitch
        fi
        prev_default_active=1
      else
        if [ "$prev_default_active" -eq 1 ]; then
          enable_killswitch
        fi
        prev_default_active=0
      fi
    done
  }

  # CLI entry for killswitch management
  if [[ "''${1}" == "killswitch" ]]; then
    case "''${2}" in
      enable)
        enable_killswitch
        ;;
      disable)
        disable_killswitch
        ;;
      status)
        killswitch_status
        ;;
      monitor)
        monitor_killswitch_loop
        ;;
      *)
        echo "Usage: $0 killswitch {enable|disable|status|monitor}"
        ;;
    esac
    exit 0
  fi

  mkdir -p "$(dirname "''${known_networks_file}")"
fi

if [ ! -f "''${known_networks_file}" ] ; then
  touch "''${known_networks_file}"
fi

# helper: check if any connected network has allowDefault enabled
check_allow_default_any() {
  while IFS= read -r line; do
    nwid=$(echo "''${line}" | ''${cut} -d' ' -f3)
    if ''${zerotier} get "''${nwid}" allowDefault 2>/dev/null | ''${grep} -E -q "true|1"; then
      return 0
    fi
  done < <( ''${zerotier} listnetworks | ''${grep} "OK " )
  return 1
}

# helper: check whether default-route is active (0.0.0.0/1 or 128.0.0.0/1 via a zt interface)
check_default_route_active() {
  if ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E -q " dev zt[[:alnum:]]*"; then
    return 0
  fi
  return 1
}

if [[ "''${1}" == "status" || "''${1}" == "details" ]]; then
  online_regular=0
  online_partial=0
  online_names=()
  while IFS= read -r line; do
    nwid=$(echo "''${line}" | ''${cut} -d' ' -f1)
    name=$(echo "''${line}" | ''${cut} -d' ' -f2)
    type=$(echo "''${line}" | ''${cut} -d' ' -f3)
    if ''${zerotier} listnetworks | ''${grep} -q "^200.* ''${nwid} "; then
      online_names+=("''${name}")
      if [[ "$type" == "system" || "$type" == "partial" ]]; then
        online_partial=1
      else
        online_regular=1
      fi
    fi
  done < "''${known_networks_file}"
  if [[ "''${1}" == "status" ]]; then
    # determine whether any connected network has allowDefault enabled (match true or 1)
    allow_default_any=0
    while IFS= read -r l; do
      nwid_check=$(echo "''${l}" | ''${cut} -d' ' -f3)
      if ''${zerotier} get "''${nwid_check}" allowDefault 2>/dev/null | ''${grep} -E -q "true|1"; then
        allow_default_any=1
        break
      fi
    done < <( ''${zerotier} listnetworks | ''${grep} "OK " )

    # determine whether default-route is currently active via helper (any zt dev)
    default_route_active=0
    if check_default_route_active; then
      default_route_active=1
    fi

    if [[ "''${online_regular}" -eq 1 ]]; then
      status_text="󰯅"
    elif [[ "''${online_partial}" -eq 1 ]]; then
      status_text="󰞀"
    else
      status_text=""
    fi

    # if default-route is active, show distinct icon regardless of partial/full online state
    if [[ "''${default_route_active}" -eq 1 ]]; then
      status_text=""
    fi
    if [[ "''${#online_names[@]}" -eq 0 ]]; then
      tooltip="No networks connected"
    else
      # if default route active, show which network is routing and the gateway
      if [[ "''${default_route_active}" -eq 1 ]]; then
        routing_name=""
        routing_via=""
        while read line; do
          nwid_r=$(echo "''${line}" | ''${cut} -d' ' -f3)
          name_r=$(echo "''${line}" | ''${cut} -d' ' -f4)
          dev_r=$(echo "''${line}" | ''${cut} -d' ' -f8)
          via_r=$(ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E " dev ''${dev_r}" | ''${cut} -d' ' -f3 | ''${sed} -n '1p')
          if [ -n "''${via_r}" ]; then
            routing_name="''${name_r}"
            routing_via="''${via_r}"
            break
          fi
        done < <( ''${zerotier} listnetworks | ''${grep} "OK " )
        if [ -n "''${routing_name}" ]; then
          tooltip="ROUTING: ''${routing_name} via ''${routing_via}"
        else
          tooltip="Connected: $(IFS=, ; echo "''${online_names[*]}")"
        fi
      else
        tooltip="Connected: $(IFS=, ; echo "''${online_names[*]}")"
      fi
    fi
    printf '{"text":"%s","tooltip":"%s"}\n' "''${status_text}" "''${tooltip}"
    exit 0
  fi
  if [[ "''${1}" == "details" ]]; then
    if [[ ''${#online_names[@]} -eq 0 ]]; then
      echo "none"
      exit 0
    fi

    # Concise per-network summary for waybar/rofi: name · ip · default:on/off · active:on/off
    ''${zerotier} listnetworks | ''${grep} "OK " | while read line; do
      nwid=$(echo "''${line}" | ''${cut} -d' ' -f3)
      name=$(echo "''${line}" | ''${cut} -d' ' -f4)
      dev=$(echo "''${line}" | ''${cut} -d' ' -f8)
      ips=$(echo "''${line}" | ''${cut} -d' ' -f9-)
      if ''${zerotier} get "''${nwid}" allowDefault 2>/dev/null | ''${grep} -E -q "true|1"; then
        default_on="on"
      else
        default_on="off"
      fi
      if ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E -q " dev ''${dev}"; then
        active_on="on"
      else
        active_on="off"
      fi
      printf '%s\n' "''${name} · ''${ips} · default:''${default_on} · active:''${active_on}"
    done
    exit 0
  fi
fi

if [ "''${AUTO_ADD,,}" = "true" ]; then
  ''${zerotier} listnetworks | while read line; do
    if echo "''${line}" | ''${grep} -q "OK "; then
      nwid=$(echo "''${line}" | ''${cut} -d' ' -f3)
      name=$(echo "''${line}" | ''${cut} -d' ' -f4)
      ''${grep} -q "^''${nwid} " "''${known_networks_file}" || echo "''${nwid} ''${name}" >> "''${known_networks_file}"
    fi
  done
fi

_current=$(
    ''${zerotier} listnetworks | ''${grep} "OK " | while read line; do
      nwid=$(echo "''${line}" | ''${cut} -d' ' -f3)
      name=$(echo "''${line}" | ''${cut} -d' ' -f4)
      dev=$(echo "''${line}" | ''${cut} -d' ' -f8)
      ips=$(echo "''${line}" | ''${cut} -d' ' -f9-)
      if ''${zerotier} get "''${nwid}" allowDefault 2>/dev/null | ''${grep} -E -q "true|1"; then
        default_on="on"
      else
        default_on="off"
      fi
      if ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E -q " dev ''${dev}"; then
        active_on="on"
        via=$(ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E " dev ''${dev}" | ''${cut} -d' ' -f3 | ''${sed} -n '1p')
        if [ -n "''${via}" ]; then
          # shorten via IP if needed
          short_via=$(echo "''${via}" | ''${sed} -E 's/^(.{1,24}).*/\1/')
          via_text=" · via:''${short_via}"
        else
          via_text=""
        fi
      else
        active_on="off"
        via_text=""
      fi
      # single-line menu entry: name (ON) · ips · default:on/off · route:on/off [ via <ip>]
      echo "''${name} (ON) · ''${ips} · default:''${default_on} · route:''${active_on}''${via_text}"
    done
)
_known_off=""
while IFS= read -r line; do
  nwid=$(echo "''${line}" | ''${cut} -d' ' -f1)
  name=$(echo "''${line}" | ''${cut} -d' ' -f2-)
  if ! ''${zerotier} listnetworks | ''${grep} -q " ''${nwid} "; then
    _known_off="''${_known_off}''${name} (OFF)
"
  fi
done < "''${known_networks_file}"

_menu="$_current
''${_known_off}"
_menu=$(echo "''${_menu}" | ''${grep} -v '^$')

if [ -z "''${_menu}" ]; then
  ''${notify} "ZeroTier" "No networks"
  exit 1
fi

_selection=$(echo "''${_menu}" | ''${rofi} -dmenu -theme-str 'window { width: 700px; }' -p "Toggle (ON=leave, OFF=join):" )

if [ -z "''${_selection}" ]; then exit 0; fi

name=$(echo "''${_selection}" | ''${cut} -d' ' -f1)
status=$(echo "''${_selection}" | ''${grep} -oE '\([A-Z]+\)')

nwid=$(awk -v n="$name" '$2 == n {print $1; exit}' "''${known_networks_file}")
if [ -z "''${nwid}" ]; then
  nwid=$( ''${zerotier} listnetworks | ''${grep} " ''${name} " | ''${cut} -d' ' -f3 | head -1 )
fi

if echo "''${status}" | ''${grep} -q "ON"; then
    # Offer actions for an ON network: leave or toggle default-route capability
    action=$(echo -e "Leave\nToggle default route" | ''${rofi} -dmenu -theme-str 'window { width: 60%; }' -p "Action:")
    if [ -z "''${action}" ]; then exit 0; fi
    if [ "''${action}" = "Leave" ]; then
      ''${zerotier} leave "''${nwid}"
      ''${notify} "ZeroTier" "Left ''${name}"
    elif [ "''${action}" = "Toggle default route" ]; then
      current=0
      if ''${zerotier} get "''${nwid}" allowDefault 2>/dev/null | ''${grep} -E -q "true|1"; then
        current=1
      fi
      if [[ "''${current}" -eq 1 ]]; then
        ''${zerotier} set "''${nwid}" allowDefault=0
        ''${notify} "ZeroTier" "Default route disabled for ''${name}"
      else
        ''${zerotier} set "''${nwid}" allowDefault=1
        ''${notify} "ZeroTier" "Default route enabled for ''${name}"
      fi
    fi
else
    # Secondary join menu - join only, join+enable, join+enable+wait
    action=$(echo -e "Join only\nJoin and enable default route\nJoin, enable and wait for active" | ''${rofi} -dmenu -theme-str 'window { width: 60%; }' -p "Join action:")
    if [ -z "''${action}" ]; then exit 0; fi

    ''${notify} "ZeroTier" "Joining ''${name}"
    ''${zerotier} join "''${nwid}"

    # wait for network to become OK (up to 15s)
    i=0
    ok=0
    while [ $i -lt 15 ]; do
      if ''${zerotier} listnetworks | ''${grep} -q "^200.* ''${nwid} "; then
        ok=1
        break
      fi
      i=$((i+1))
      sleep 1
    done

    if [ "''${ok}" -ne 1 ]; then
      ''${notify} "ZeroTier" "Join timed out for ''${name}"
    else
      # enable default route if requested
      if echo "''${action}" | ''${grep} -q "enable"; then
        ''${zerotier} set "''${nwid}" allowDefault=1
        ''${notify} "ZeroTier" "Enabled default route for ''${name}"
      fi

      # optionally wait for default route to be active via a zt dev
      if echo "''${action}" | ''${grep} -q "wait"; then
        j=0
        active=0
        while [ $j -lt 15 ]; do
          if ip route | ''${grep} -E "0\.0\.0\.0/1|128\.0\.0.0/1" | ''${grep} -E -q " dev zt[[:alnum:]]*"; then
            active=1
            break
          fi
          j=$((j+1))
          sleep 1
        done
        if [ "''${active}" -eq 1 ]; then
          ''${notify} "ZeroTier" "Default route active for ''${name}"
        else
          ''${notify} "ZeroTier" "Default route not active after wait"
        fi
      fi
    fi
fi
        '';
      };
    };
  };
}
