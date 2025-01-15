{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) displays display_center display_left display_right role;

  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;

  gameMode = pkgs.writeShellScriptBin "gamemode" ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
      hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0"
      exit
    else
      hyprctl --batch "\
          keyword animations:enabled 1;\
          keyword decoration:drop_shadow 1;\
          keyword decoration:blur 1;\
          keyword general:gaps_in 1;\
          keyword general:gaps_out 1;\
          keyword general:border_size 1;\
          keyword decoration:rounding 1"
    fi
    hyprctl reload
  '';

  script_displayhelper_hyprland = pkgs.writeShellScriptBin "displayhelper_hyprland" ''

_get_display_name() {
    ${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg desc "$(echo "''${1}" | sed "s|^d/||g")" '.[] | select(.description | test("^(d/)?\($desc)")) | .name'
}
if [ -z "''${1}" ]; then exit 1; fi

case "''${#}" in
    1)
        cat <<EOF > ''${HOME}/.config/hypr/display.conf
workspace=1,,default:true,persistent:true
workspace=2,persistent:true
workspace=3,persistent:true
workspace=4,persistent:true
workspace=5,persistent:true
workspace=6,persistent:true
workspace=7,persistent:true
workspace=8,persistent:true
workspace=9,persistent:true
EOF
    ;;
    2)
        cat <<EOF > ''${HOME}/.config/hypr/display.conf
\$_monitor1=$(_get_display_name "''${1}")
\$_monitor2=$(_get_display_name "''${2}")
workspace=2,monitor:\$_monitor1,,default:true,persistent:true
workspace=5,monitor:\$_monitor1,persistent:true
workspace=8,monitor:\$_monitor1,persistent:true
workspace=3,monitor:\$_monitor2,,default:true,persistent:true
workspace=6,monitor:\$_monitor2,persistent:true
workspace=9,monitor:\$_monitor2,persistent:true
EOF
    ;;
    3 | *)
        cat <<EOF > ''${HOME}/.config/hypr/display.conf
\$_monitor1=$(_get_display_name "''${1}")
\$_monitor2=$(_get_display_name "''${2}")
\$_monitor3=$(_get_display_name "''${3}")
workspace=2,monitor:\$_monitor1,,default:true,persistent:true
workspace=5,monitor:\$_monitor1,persistent:true
workspace=8,monitor:\$_monitor1,persistent:true
workspace=3,monitor:\$_monitor2,,default:true,persistent:true
workspace=6,monitor:\$_monitor2,persistent:true
workspace=9,monitor:\$_monitor2,persistent:true
workspace=1,monitor:\$_monitor3,,default:true,persistent:true
workspace=4,monitor:\$_monitor3,persistent:true
workspace=7,monitor:\$_monitor3,persistent:true
EOF
    ;;
esac
  '';
in

with lib;
{
  imports = [
    #inputs.hyprland.homeManagerModules.default
    ./binds.nix
    ./decorations.nix
    ./displays.nix
    ./input.nix
    ./settings.nix
    ./startup.nix
    ./windowrules.nix
  ];

  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    home = {
      packages = with pkgs;
        [
          gameMode
          #hyprland-share-picker     # If this works outside of Hyprland modularize
          script_displayhelper_hyprland
        ];
    };

    host = {
      home = {
        applications = {
          hyprcursor.enable = mkDefault true;
          hyprdim.enable = mkDefault true;
          hypridle.enable = mkDefault true;
          hyprlock.enable = true;
          hyprpaper.enable = mkDefault true;
          hyprpicker.enable = mkDefault true;
          hyprpolkitagent.enable = mkDefault true;
          hyprsunset.enable = mkDefault true;
          hyprkeys.enable = mkDefault true;
          playerctl.enable = mkDefault true;
          satty.enable = mkDefault true;
          rofi.enable = mkDefault true;
        };
        feature = {
          uwsm.enable = mkDefault true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env = [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DEKSTOP,Hyprland"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "MOZ_ENABLE_WAYLAND,1"
          "GDK_BACKEND,wayland,x11,*"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_SESSION_TYPE,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "NIXOS_OZONE_WL,1"
        ];
      };
      xwayland.enable = mkDefault true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common = {
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        #"org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
      };
      extraPortals = [
        #pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
