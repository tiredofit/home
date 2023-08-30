{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.mp3gain;
in
  with lib;
{
  options = {
    host.home.applications.mp3gain = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Loudness adjuster for MP3 and AAC files";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          mp3gain
        ];
    };
  };
}
