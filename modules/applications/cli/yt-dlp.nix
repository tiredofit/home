{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.yt-dlp;
in
  with lib;
{
  options = {
    host.home.applications.yt-dlp = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Media downloader from internet sites";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      yt-dlp = {
        enable = true;
      };

      bash = {
        shellAliases = {
          youtube-dl = "yt-dlp" ;                            # YoutubeDL
          ytaudio= "yt-dlp -f 'ba' -x --audio-format mp3" ;  # download youtube videos as mp3
        };
      };
    };
  };
}
