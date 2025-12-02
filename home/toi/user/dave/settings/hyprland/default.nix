{lib, ...}:
with lib;
{
  imports = [
    ./binds.nix
    ./decorations.nix
    ./displays.nix
    ./input.nix
    ./settings.nix
    ./startup.nix
    ./windowrules.nix
  ];
}
