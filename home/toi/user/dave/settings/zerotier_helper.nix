{ config, lib, pkgs, ... }:
with lib; {
  config = {
    home.file = {
      "${config.home.homeDirectory}/.config/scripts/zerotier_helper.sh" = {
        executable = true;
        text = ''
#!/usr/bin/env bash

AUTO_ADD=''${AUTO_ADD:-"true"}

cut_command=${pkgs.coreutils}/bin/cut
grep_command=${pkgs.gnugrep}/bin/grep
notify_command=${pkgs.libnotify}/bin/notify-send
rofi_command=${pkgs.rofi}/bin/rofi
sed_command=${pkgs.gnused}/bin/sed
zerotier_command="sudo ${pkgs.zerotierone}/bin/zerotier-cli"

for cmd in ''${cut_command} ''${grep_command} ''${notify_command} ''${rofi_command} ''${sed_command}; do
  if [ ! -x "''${cmd}" ] ; then
    echo "Required command not found: ''${cmd}" >&2
    exit 1
  fi
done

known_networks_file="''${HOME}/.config/zerotier/known-zt-networks"

if [ ! -d "$(dirname "''${known_networks_file}")" ]; then
  mkdir -p "$(dirname "''${known_networks_file}")"
fi

if [ ! -f "''${known_networks_file}" ] ; then
  touch "''${known_networks_file}"
fi

if [[ "''${1}" == "status" || "''${1}" == "details" ]]; then
  online_regular=0
  online_partial=0
  online_names=()
  while IFS= read -r line; do
    nwid=$(echo "''${line}" | ''${cut_command} -d' ' -f1)
    name=$(echo "''${line}" | ''${cut_command} -d' ' -f2)
    type=$(echo "''${line}" | ''${cut_command} -d' ' -f3)
    if ''${zerotier_command} listnetworks | ''${grep_command} -q "^200.* ''${nwid} "; then
      online_names+=("''${name}")
      if [[ "$type" == "system" || "$type" == "partial" ]]; then
        online_partial=1
      else
        online_regular=1
      fi
    fi
  done < "''${known_networks_file}"
  if [[ "''${1}" == "status" ]]; then
    if [[ "''${online_regular}" -eq 1 ]]; then
      status_text="󰯅"
    elif [[ "''${online_partial}" -eq 1 ]]; then
      status_text="󰞀"
    else
      status_text=""
    fi
    if [[ "''${#online_names[@]}" -eq 0 ]]; then
      tooltip="No networks connected"
    else
      tooltip="Connected: $(IFS=, ; echo "''${online_names[*]}")"
    fi
    printf '{"text":"%s","tooltip":"%s"}\n' "''${status_text}" "''${tooltip}"
    exit 0
  fi
  if [[ "''${1}" == "details" ]]; then
    if [[ ''${#online_names[@]} -eq 0 ]]; then
      echo "none"
    else
      printf '%s\n' "''${online_names[@]}"
    fi
    exit 0
  fi
fi

if [ "''${AUTO_ADD,,}" = "true" ]; then
  ''${zerotier_command} listnetworks | while read line; do
    if echo "''${line}" | ''${grep_command} -q "OK "; then
      nwid=$(echo "''${line}" | ''${cut_command} -d' ' -f3)
      name=$(echo "''${line}" | ''${cut_command} -d' ' -f4)
      ''${grep_command} -q "^''${nwid} " "''${known_networks_file}" || echo "''${nwid} ''${name}" >> "''${known_networks_file}"
    fi
  done
fi

_current=$( ''${zerotier_command} listnetworks | ''${grep_command} "OK " | ''${cut_command} -d' ' -f4 | ''${sed_command} 's/$/ (ON)/' )
_known_off=""

while IFS= read -r line; do
  nwid=$(echo "''${line}" | ''${cut_command} -d' ' -f1)
  name=$(echo "''${line}" | ''${cut_command} -d' ' -f2-)
  if ! ''${zerotier_command} listnetworks | ''${grep_command} -q " ''${nwid} "; then
    _known_off="''${_known_off}''${name} (OFF)
"
  fi
done < "''${known_networks_file}"

_menu="$_current
''${_known_off}"
_menu=$(echo "''${_menu}" | ''${grep_command} -v '^$')

if [ -z "''${_menu}" ]; then
  ''${notify_command} "ZeroTier" "No networks"
  exit 1
fi

_selection=$(echo "''${_menu}" | ''${rofi_command} -dmenu -p "Toggle (ON=leave, OFF=join):" )

if [ -z "''${_selection}" ]; then exit 0; fi

name=$(echo "''${_selection}" | ''${cut_command} -d' ' -f1)
status=$(echo "''${_selection}" | ''${grep_command} -oE '\([A-Z]+\)')

nwid=$(''${grep_command} "^[a-f0-9]\{16\} $name$" "''${known_networks_file}" | ''${cut_command} -d' ' -f1)
if [ -z "''${nwid}" ]; then
    nwid=$( ''${zerotier_command} listnetworks | ''${grep_command} " ''${name} " | ''${cut_command} -d' ' -f3 | head -1 )
fi

if echo "''${status}" | ''${grep_command} -q "ON"; then
    ''${zerotier_command} leave "''${nwid}"
    ''${notify_command} "ZeroTier" "Left ''${name}"
else
    ''${zerotier_command} join "''${nwid}"
fi

        '';
      };
    };
  };
}
