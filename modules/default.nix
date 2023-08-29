{lib, ...}:

with lib;
{
  imports = [
    ./applications/cli
    ./applications/gui
    ./desktop
    ./features
    ./roles
    ./services
  ];
}
