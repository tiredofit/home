{ config, lib, pkgs, ... }:

let cfg = config.host.home.applications.docker-compose;
in
with lib;
{
  options = {
    host.home.applications.docker-compose = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Companion tool for Docker containerization";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        unstable.docker-compose
      ];
    };

    programs = {
      bash = {
        initExtra = ''
          ### Docker
          if [ -n "$XDG_CONFIG_HOME" ] ; then
            export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
          else
            export DOCKER_CONFIG="$HOME/.config/docker"
          fi

          export docker_bin_location="$(which docker)"
          export DOCKER_TIMEOUT=''${DOCKER_TIMEOUT:-"120"}

          # Figure out if we need to use sudo for docker commands
          if id -nG "$USER" | grep -qw "docker" || [ $(id -u) = "0" ]; then
            dsudo=""
          else
            dsudo='sudo'
          fi

          alias dex="$dsudo $docker_bin_location exec -it"                                                           # Execute interactive container, e.g., $dex base /bin/bash
          alias di="$dsudo $docker_bin_location images"                                                              # Get images
          alias dki="$dsudo $docker_bin_location run -it -P"                                                         # Run interactive container, e.g., $dki base /bin/bash
          alias dpsa="$dsudo docker_ps -a"                                                                           # Get process included stop container
          db() { $dsudo $docker_bin_location build -t="$1" .; }                                                      # Build Docker Image from Current Directory
          dri() { $dsudo $docker_bin_location rmi -f $($dsudo $docker_bin_location images -q); }                     # Forcefully Remove all images
          drm() { $dsudo $docker_bin_location rm $($dsudo $docker_bin_location ps -a -q); }                          # Remove all containers
          drmf() { $dsudo $docker_bin_location stop $($dsudo $docker_bin_location ps -a -q) -timeout $DOCKER_TIMEOUT && $dsudo $docker_bin_location rm $($dsudo $docker_bin_location ps -a -q) ; } # Stop and remove all containers
          dstop() { $dsudo $docker_bin_location stop $($dsudo $docker_bin_location ps -a -q) -t $DOCKER_TIMEOUT; }   # Stop all containers

          # Get RAM Usage of a Container
          docker_mem() {
              if [ -f /sys/fs/cgroup/memory/docker/"$1"/memory.usage_in_bytes ]; then
                  echo $(($(cat /sys/fs/cgroup/memory/docker/"$1"/memory.usage_in_bytes) / 1024 / 1024)) 'MB'
              else
                  echo 'n/a'
              fi
          }
          alias dmem='docker_mem'

          # Get IP Address of a Container
          docker_ip() {
              ip=$($dsudo $docker_bin_location inspect --format="{{.NetworkSettings.IPAddress}}" "$1" 2>/dev/null)
              if (($? >= 1)); then
                  # Container doesn't exist
                  ip='n/a'
              fi
              echo $ip
          }
          alias dip='docker_ip'

          # Enhanced version of 'docker ps' which outputs two extra columns IP and RAM
          docker_ps() {
            tmp=$($dsudo $docker_bin_location ps "$@")
            headings=$(echo "$tmp" | head --lines=1)
            max_len=$(echo "$tmp" | wc --max-line-length)
            dps=$(echo "$tmp" | tail --lines=+2)
            printf "%-''${max_len}s %-15s %10s\n" "$headings" IP RAM

            if [[ -n "$dps" ]]; then
              while read -r line; do
                container_short_hash=$(echo "$line" | cut -d' ' -f1)
                container_long_hash=$($dsudo $docker_bin_location inspect --format="{{.Id}}" "$container_short_hash")
                container_name=$(echo "$line" | rev | cut -d' ' -f1 | rev)
                if [ -n "$container_long_hash" ]; then
                  ram=$(docker_mem "$container_long_hash")
                  ip=$(docker_ip "$container_name")
                  printf "%-''${max_len}s %-15s %10s\n" "$line" "$ip" "$ram"
                fi
              done <<<"$dps"
            fi
          }
          alias dps='docker_ps'

          #  List the volumes for a given container
          docker_vol() {
            vols=$($dsudo $docker_bin_location inspect --format="{{.HostConfig.Binds}}" "$1")
            vols=''${vols:1:-1}
            for vol in $vols; do
              echo "$vol"
            done
          }
          alias dvol='docker_vol'

          if command -v "fzf" &>/dev/null; then
            # bash into running container
            alias dbash='c_name=$($dsudo $docker_bin_location ps --format "table {{.Names}}\t{{.Image}}\t{{ .ID}}\t{{.RunningFor}}" | ${pkgs.gnused}/bin/sed "/NAMES/d" | sort | fzf --tac |  ${pkgs.gawk}/bin/awk '"'"'{print $1;}'"'"') ; echo -e "\e[41m**\e[0m Entering $c_name from $(cat /etc/hostname)" ; $dsudo $docker_bin_location exec -e COLUMNS=$( tput cols ) -e LINES=$( tput lines ) -it $c_name bash'

            # view logs
            alias dlog='c_name=$($dsudo $docker_bin_location ps --format "table {{.Names}}\t{{.Image}}\t{{ .ID}}\t{{.RunningFor}}" | ${pkgs.gnused}/bin/sed "/NAMES/d" | sort | fzf --tac |  ${pkgs.gnused}/bin/awk '"'"'{print $1;}'"'"') ; echo -e "\e[41m**\e[0m Viewing $c_name from $(cat /etc/hostname)" ; $dsudo $docker_bin_location logs $c_name $1'

            # sh into running container
            alias dsh='c_name=$($dsudo $docker_bin_location ps --format "table {{.Names}}\t{{.Image}}\t{{ .ID}}\t{{.RunningFor}}" | ${pkgs.gnused}/bin/sed "/NAMES/d" | sort | fzf --tac |  ${pkgs.gnused}/bin/awk '"'"'{print $1;}'"'"') ; echo -e "\e[41m**\e[0m Entering $c_name from $(cat /etc/hostname)" ; $dsudo $docker_bin_location exec -e COLUMNS=$( tput cols ) -e LINES=$( tput lines ) -it $c_name sh'

            # Remove running container
            alias drm='$dsudo $docker_bin_location rm $( $dsudo $docker_bin_location ps --format "table {{.Names}}\t{{.Image}}\t{{ .ID}}\t{{.RunningFor}}" | ${pkgs.gnused}/bin/sed "/NAMES/d" | sort | fzf --tac |  ${pkgs.gawk}/bin/awk '"'"'{print $1;}'"'"' )'
          fi

          alias dpull='$dsudo $docker_bin_location pull'                                                                                                                                                                 # $docker_bin_location Pull

          docker_compose_bin_location="$(which docker-compose)"
          export DOCKER_COMPOSE_TIMEOUT=''${DOCKER_TIMEOUT:-"120"}

          docker-compose() {
           if [ "$2" != "--help" ] ; then
             case "$1" in
               "down" )
                 arg=$(echo "$@" | ${pkgs.gnused}/bin/sed "s|^$1||g")
                 $dsudo $docker_compose_bin_location down --timeout $DOCKER_COMPOSE_TIMEOUT $arg
               ;;
               "restart" )
                 arg=$(echo "$@" | ${pkgs.gnused}/bin/sed "s|^$1||g")
                 $dsudo $docker_compose_bin_location restart --timeout $DOCKER_COMPOSE_TIMEOUT $arg
               ;;
               "stop" )
                 arg=$(echo "$@" | ${pkgs.gnused}/bin/sed "s|^$1||g")
                 $dsudo $docker_compose_bin_location stop --timeout $DOCKER_COMPOSE_TIMEOUT $arg
               ;;
               "up" )
                 arg=$(echo "$@" | ${pkgs.gnused}/bin/sed "s|^$1||g")
                 $dsudo $docker_compose_bin_location up $arg
               ;;
               * )
                 $dsudo $docker_compose_bin_location ''${@}
               ;;
            esac
           fi
          }

          alias dcpull='$dsudo docker-compose pull'                                                                                                 # Docker Compose Pull
          alias dcu='$dsudo $docker_compose_bin_location up'                                                                                        # Docker Compose Up
          alias dcud='$dsudo $docker_compose_bin_location up -d'                                                                                    # Docker Compose Daemonize
          alias dcd='$dsudo $docker_compose_bin_location down --timeout $DOCKER_COMPOSE_TIMEOUT'                                                    # Docker Compose Down
          alias dcl='$dsudo $docker_compose_bin_location logs -f'                                                                                   # Docker Compose Logs
          alias dcrecycle='$dsudo $docker_compose_bin_location down --timeout $DOCKER_COMPOSE_TIMEOUT ; $dsudo $docker_compose_bin_location up -d'  # Docker Compose Restart
        '';

        sessionVariables = {
          DOCKER_BUILDKIT = 0; # Stop using the new buildx
        };
      };
    };
  };
}
