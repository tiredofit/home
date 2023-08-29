{lib, ...}:

with lib;
{
  imports = [
    ./act.nix
    ./btop.nix
    ./fzf.nix
    ./htop.nix
    ./jq.nix
    ./lazygit.nix
    ./less.nix
    ./liquidprompt.nix
    ./lsd.nix
    ./neofetch.nix
    ./ncdu.nix
    ./nmap.nix
    ./tmux.nix
    ./yt-dlp.nix
    ./zoxide.nix
  ];
}
