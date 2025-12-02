{ config, lib, pkgs, ... }:
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
          "SUPER, F, fullscreenstate, 1, 1"
          "SUPER_SHIFT, F, fullscreen"
          "SUPER, P, pin" # Pin dispatcher, make window appear above everything else on all windows
          # See Terminal for the bind for SUPER, RETURN
          "SUPER, V, togglefloating,"
          "SUPER, mouse:274, killactive" # Middle Mouse
          "SUPER, space, pseudo,"

          "SUPER_SHIFT, Q, killactive"
          "ALT, Tab, bringactivetotop,"
          "ALT, Tab, cyclenext,"
          #"ALT,TAB,workspace,previous"

          # Move focus with mainMod + arrow keys
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9] (numpad)
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

          # Move active window to a workspace with mainMod + SHIFT + [0-9] (numpad)
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

          # moving windows to other workspaces (silent) (numpad)
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

          # Switch workspaces with mainMod + [0-9]
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          #"SUPER, KP_Insert, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "SUPER_SHIFT, 1, movetoworkspace, 1"
          "SUPER_SHIFT, 2, movetoworkspace, 2"
          "SUPER_SHIFT, 3, movetoworkspace, 3"
          "SUPER_SHIFT, 4, movetoworkspace, 4"
          "SUPER_SHIFT, 5, movetoworkspace, 5"
          "SUPER_SHIFT, 6, movetoworkspace, 6"
          "SUPER_SHIFT, 7, movetoworkspace, 7"
          "SUPER_SHIFT, 8, movetoworkspace, 8"
          "SUPER_SHIFT, 9, movetoworkspace, 9"
          #"SUPER_SHIFT, KP_Insert, movetoworkspace, 10"

          # moving windows to other workspaces (silent)
          "SUPER_ALT, 1,  movetoworkspacesilent,1"
          "SUPER_ALT, 2,  movetoworkspacesilent,2"
          "SUPER_ALT, 3,  movetoworkspacesilent,3"
          "SUPER_ALT, 4,  movetoworkspacesilent,4"
          "SUPER_ALT, 5,  movetoworkspacesilent,5"
          "SUPER_ALT, 6,  movetoworkspacesilent,6"
          "SUPER_ALT, 7,  movetoworkspacesilent,7"
          "SUPER_ALT, 8,  movetoworkspacesilent,8"
          "SUPER_ALT, 9,  movetoworkspacesilent,9"
          #"SUPER_ALT, KP_Insert, movetoworkspacesilent,0"


          # moving windows around
          "SUPER_SHIFT, left, movewindow,l"
          "SUPER_SHIFT, right,movewindow,r"
          "SUPER_SHIFT, up, movewindow,u"
          "SUPER_SHIFT, down, movewindow,d"

           # Turn off animations / game mode
          "WIN, F1, exec,  hyprland_gamemode"

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
