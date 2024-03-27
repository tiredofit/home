{lib, ...}:

with lib;
{
  imports = [
    ./agnostic
    ./x
    ./wayland
  ];
}
