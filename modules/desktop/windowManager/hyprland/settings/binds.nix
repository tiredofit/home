{ config, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
with lib;
{
  config = mkIf (config.host.home.feature.gui.isHyprland) {
    wayland.windowManager.hyprland = {
      settings = {
        ### See more in modules/applications/* and modules/desktop/utils/*
        bind = [
          { _args = ["SUPER + F" (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen_state({ internal = 1 , client = 0, action = "toggle" })'')]; }
          { _args = ["SUPER + SHIFT + F" (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')]; }

          # Pin dispatcher, make window appear above everything else on all windows
          { _args = ["SUPER + P" (lib.generators.mkLuaInline ''hl.dsp.window.pin()'')]; }
          { _args = ["SUPER + V" (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')]; }
          { _args = ["SUPER + mouse:274" (lib.generators.mkLuaInline ''hl.dsp.window.close()'')]; }
          { _args = ["SUPER + space" (lib.generators.mkLuaInline ''hl.dsp.window.pseudo()'')]; }

          { _args = ["SUPER + SHIFT + Q" (lib.generators.mkLuaInline ''hl.dsp.window.close()'')]; }
          { _args = ["ALT + Tab" (lib.generators.mkLuaInline ''hl.dsp.window.bring_to_top()'')]; }
          { _args = ["ALT + Tab" (lib.generators.mkLuaInline ''hl.dsp.window.cycle_next({ next = true })'')]; }

          # Move focus with mainMod + arrow keys
          { _args = ["SUPER + left" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "left" })'')]; }
          { _args = ["SUPER + right" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "right" })'')]; }
          { _args = ["SUPER + up" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "up" })'')]; }
          { _args = ["SUPER + down" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "down" })'')]; }

          # Switch workspaces with mainMod + [0-9] (numpad)
          { _args = ["SUPER + KP_End" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 1 })'')]; }
          { _args = ["SUPER + KP_Down" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 2 })'')]; }
          { _args = ["SUPER + KP_Next" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 3 })'')]; }
          { _args = ["SUPER + KP_Left" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 4 })'')]; }
          { _args = ["SUPER + KP_Begin" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 5 })'')]; }
          { _args = ["SUPER + KP_Right" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 6 })'')]; }
          { _args = ["SUPER + KP_Home" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 7 })'')]; }
          { _args = ["SUPER + KP_Up" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 8 })'')]; }
          { _args = ["SUPER + KP_Prior" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 9 })'')]; }

          # Move active window to a workspace with mainMod + SHIFT + [0-9] (numpad)
          { _args = ["SUPER + SHIFT + KP_End" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 1 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Down" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 2 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Next" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 3 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Left" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 4 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Begin" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 5 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Right" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 6 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Home" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 7 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Up" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 8 })'')]; }
          { _args = ["SUPER + SHIFT + KP_Prior" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 9 })'')]; }

          # moving windows to other workspaces (silent) (numpad)
          { _args = ["SUPER + ALT + KP_End" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 1, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Down" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 2, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Next" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 3, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Left" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 4, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Begin" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 5, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Right" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 6, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Home" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 7, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Up" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 8, follow = false })'')]; }
          { _args = ["SUPER + ALT + KP_Prior" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 9, follow = false })'')]; }

          # Switch workspaces with mainMod + [0-9]
          { _args = ["SUPER + 1" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 1 })'')]; }
          { _args = ["SUPER + 2" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 2 })'')]; }
          { _args = ["SUPER + 3" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 3 })'')]; }
          { _args = ["SUPER + 4" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 4 })'')]; }
          { _args = ["SUPER + 5" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 5 })'')]; }
          { _args = ["SUPER + 6" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 6 })'')]; }
          { _args = ["SUPER + 7" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 7 })'')]; }
          { _args = ["SUPER + 8" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 8 })'')]; }
          { _args = ["SUPER + 9" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 9 })'')]; }

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          { _args = ["SUPER + SHIFT + 1" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 1 })'')]; }
          { _args = ["SUPER + SHIFT + 2" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 2 })'')]; }
          { _args = ["SUPER + SHIFT + 3" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 3 })'')]; }
          { _args = ["SUPER + SHIFT + 4" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 4 })'')]; }
          { _args = ["SUPER + SHIFT + 5" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 5 })'')]; }
          { _args = ["SUPER + SHIFT + 6" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 6 })'')]; }
          { _args = ["SUPER + SHIFT + 7" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 7 })'')]; }
          { _args = ["SUPER + SHIFT + 8" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 8 })'')]; }
          { _args = ["SUPER + SHIFT + 9" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 9 })'')]; }

          # moving windows to other workspaces (silent)
          { _args = ["SUPER + ALT + 1" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 1, follow = false })'')]; }
          { _args = ["SUPER + ALT + 2" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 2, follow = false })'')]; }
          { _args = ["SUPER + ALT + 3" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 3, follow = false })'')]; }
          { _args = ["SUPER + ALT + 4" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 4, follow = false })'')]; }
          { _args = ["SUPER + ALT + 5" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 5, follow = false })'')]; }
          { _args = ["SUPER + ALT + 6" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 6, follow = false })'')]; }
          { _args = ["SUPER + ALT + 7" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 7, follow = false })'')]; }
          { _args = ["SUPER + ALT + 8" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 8, follow = false })'')]; }
          { _args = ["SUPER + ALT + 9" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 9, follow = false })'')]; }

          # moving windows around
          { _args = ["SUPER + SHIFT + left" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "l" })'')]; }
          { _args = ["SUPER + SHIFT + right" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "r" })'')]; }
          { _args = ["SUPER + SHIFT + up" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "u" })'')]; }
          { _args = ["SUPER + SHIFT + down" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "d" })'')]; }

          # Turn off animations / game mode
          { _args = ["SUPER + F1" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprland_gamemode")'')]; }

          # Scroll through existing workspaces with mainMod + scroll
          { _args = ["SUPER + mouse_down" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'')]; }
          { _args = ["SUPER + mouse_up" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'')]; }

          # Resize windows with SUPER + CTRL + arrow keys (repeating)
          {_args = ["SUPER + CTRL + left" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -20, y = 0, relative = true })") (lib.generators.mkLuaInline "{repeating=true}")];}
          {_args = ["SUPER + CTRL + right" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 20, y = 0, relative = true })") (lib.generators.mkLuaInline "{repeating=true}")];}
          {_args = ["SUPER + CTRL + up" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -20, relative = true })") (lib.generators.mkLuaInline "{repeating=true}")];}
          {_args = ["SUPER + CTRL + down" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 20, relative = true })") (lib.generators.mkLuaInline "{repeating=true}")];}

          # Move/resize windows with mainMod + LMB/RMB and dragging
          {_args = ["SUPER + mouse:272" (lib.generators.mkLuaInline "hl.dsp.window.drag()") (lib.generators.mkLuaInline "{mouse=true}")];}
          {_args = ["SUPER + mouse:273" (lib.generators.mkLuaInline "hl.dsp.window.resize()") (lib.generators.mkLuaInline "{mouse=true}")];}
        ];
      };
    };
  };
}
