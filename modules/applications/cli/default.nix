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
    ./ncdu.nix
    ./tmux.nix
    ./zoxide.nix
  ];
}
