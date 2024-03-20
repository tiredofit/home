{lib, ...}:

with lib;
{
  imports = [
    ./act
    ./github
    ./ssh
  ];
}
