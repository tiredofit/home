{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.yt-dlp;

  ytdl-helper-script = pkgs.writeShellScriptBin "ytdl-helper-script" ''
    output_path="/tmp/!YTDL"
    mkdir -p "$output_path"
    echo "$(date) $@" >> /tmp/ytdl.log
    ${pkgs.yt-dlp}/bin/yt-dlp -P "$output_path" $@
  '';
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
    home = {
      packages = with pkgs;
        [
          ytdl-helper-script
        ];
    };

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
