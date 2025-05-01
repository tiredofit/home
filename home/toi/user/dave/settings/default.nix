{lib, ...}:
with lib;
{
  imports = [
    ./firefox.nix
    ./git.nix
    ./hugo.nix
  ];
}
