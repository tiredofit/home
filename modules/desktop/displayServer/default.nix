{ lib, ... }: {
  imports = import ../../../lib/import-dir.nix { inherit lib; } ./. { };
}
