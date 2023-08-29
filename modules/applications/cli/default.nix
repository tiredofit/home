{lib, ...}:

with lib;
{
  imports = [
    ./act.nix
    ./fzf.nix
    ./jq.nix
    ./lazygit.nix
    ./less.nix
    ./lsd.nix
    ./neofetch.nix
    ./ncdu.nix
    ./nmap.nix
    ./tmux.nix
    ./yt-dlp.nix
    ./zoxide.nix
  ];
}
