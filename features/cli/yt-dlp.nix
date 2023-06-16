{ config, ...}:
{
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
}
