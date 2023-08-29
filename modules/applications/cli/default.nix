{lib, ...}:

with lib;
{
  imports = [
    ./act.nix
    ./jq.nix
    ./lazygit.nix
    ./less.nix
    ./lsd.nix
    ./ncdu.nix
  ];
}
