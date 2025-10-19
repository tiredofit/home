{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.obs-studio;
in
  with lib;
{
  options = {
    host.home.applications.obs-studio = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Video recording and live streaming";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-mute-filter
        wlrobs
      ];
    };
  };
}
