{ config, lib, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        ## See more in modules/applications/* and modules/desktop/utils/*
        bind = [
          "SUPER, F, fullscreen"
          "SUPER, P, pin" # Pin dispatcher, make window appear above everything else on all windows
          "SUPER, Return, exec, kitty"
          "SUPER, V, togglefloating,"
          "SUPER, mouse:274, killactive" # Middle Mouse
          "SUPER, space, pseudo,"

          "SUPER_SHIFT, Q, killactive"
          "SUPER_SHIFT, R, exec, pkill rofi || kitty bash -c $(/nix/store/84d9n102xq8c5j3qlldi9gvglri25ixq-rofi-1.7.5+wayland3/bin/rofi -dmenu -p terminal)"
          "ALT, Tab, bringactivetotop,"
          "ALT, Tab, cyclenext,"
          #"ALT,TAB,workspace,previous"

          # Move focus with mainMod + arrow keys
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "SUPER, KP_End, workspace, 1"
          "SUPER, KP_Down, workspace, 2"
          "SUPER, KP_Next, workspace, 3"
          "SUPER, KP_Left, workspace, 4"
          "SUPER, KP_Begin, workspace, 5"
          "SUPER, KP_Right, workspace, 6"
          "SUPER, KP_Home, workspace, 7"
          "SUPER, KP_Up, workspace, 8"
          "SUPER, KP_Prior, workspace, 9"
          #"SUPER, KP_Insert, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "SUPER_SHIFT, KP_End, movetoworkspace, 1"
          "SUPER_SHIFT, KP_Down, movetoworkspace, 2"
          "SUPER_SHIFT, KP_Next, movetoworkspace, 3"
          "SUPER_SHIFT, KP_Left, movetoworkspace, 4"
          "SUPER_SHIFT, KP_Begin, movetoworkspace, 5"
          "SUPER_SHIFT, KP_Right, movetoworkspace, 6"
          "SUPER_SHIFT, KP_Home, movetoworkspace, 7"
          "SUPER_SHIFT, KP_Up,  movetoworkspace, 8"
          "SUPER_SHIFT, KP_Prior, movetoworkspace, 9"
          #"SUPER_SHIFT, KP_Insert, movetoworkspace, 10"

          # moving windows to other workspaces (silent)
          "SUPER_ALT, KP_End,   movetoworkspacesilent,1"
          "SUPER_ALT, KP_Down,  movetoworkspacesilent,2"
          "SUPER_ALT, KP_Next,  movetoworkspacesilent,3"
          "SUPER_ALT, KP_Left,  movetoworkspacesilent,4"
          "SUPER_ALT, KP_Begin, movetoworkspacesilent,5"
          "SUPER_ALT, KP_Right, movetoworkspacesilent,6"
          "SUPER_ALT, KP_Home,  movetoworkspacesilent,7"
          "SUPER_ALT, KP_Up,    movetoworkspacesilent,8"
          "SUPER_ALT, KP_Prior, movetoworkspacesilent,9"
          #"SUPER_ALT, KP_Insert, movetoworkspacesilent,0"

          # moving windows around
          "SUPER_SHIFT, left, movewindow,l"
          "SUPER_SHIFT, right,movewindow,r"
          "SUPER_SHIFT, up, movewindow,u"
          "SUPER_SHIFT, down, movewindow,d"

           # Turn off animations / game mode
          "WIN, F1, exec,  ~/.config/hypr/gamemode.sh"

          # special workspace
          ## TODO Dynamic Configuration
          "SUPER_SHIFT, grave, movetoworkspace, special"
          "SUPER, grave, togglespecialworkspace, DP-2"

          # Scroll through existing workspaces with mainMod + scroll
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
        ];

        binde = [
          "SUPERCTRL, left, resizeactive,-20 0"
          "SUPERCTRL, right, resizeactive,20 0"
          "SUPERCTRL, up, resizeactive,0 -20"
          "SUPERCTRL, down, resizeactive,0 20"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
      };
    };
  };
}
