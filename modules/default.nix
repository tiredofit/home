{lib, ...}:

with lib;
{
  imports = [
    ./applications/cli
    ./applications/gui
    ./desktop
    ./feature
    ./roles
    ./service
  ];
}
