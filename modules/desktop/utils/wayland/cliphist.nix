{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cliphist;
in
  with lib;
{
  options = {
    host.home.applications.cliphist = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland clipboard history";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cliphist
          ## 24.11 TODO Remove this overlay
          #(cliphist.overrideAttrs (_old: {
          #  src = pkgs.fetchFromGitHub {
          #    owner = "sentriz";
          #    repo = "cliphist";
          #    rev = "c49dcd26168f704324d90d23b9381f39c30572bd";
          #    sha256 = "sha256-2mn55DeF8Yxq5jwQAjAcvZAwAg+pZ4BkEitP6S2N0HY=";
          #  };
          #  vendorHash = "sha256-M5n7/QWQ5POWE4hSCMa0+GOVhEDCOILYqkSYIGoy/l0=";
          #}))
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "wl-paste --type text --watch cliphist store"  # Stores only text data
          "wl-paste --type image --watch cliphist store" # Stores only image data
        ];
      };
    };
  };
}
