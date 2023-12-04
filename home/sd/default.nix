{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) hostname role username;
  inherit (pkgs.stdenv) isLinux isDarwin;

  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;

  homeDir = if isDarwin then "/Users/" else "/home/";
in
{
  imports = [

  ] ++ existing-imports [
    ./hostname/${hostname}
    ./hostname/${hostname}/${username}.nix
    ./hostname/${hostname}.nix
    ./role/${role}
    ./role/${role}.nix
    ./user/${username}
    ./user/${username}.nix
  ];

  home = {
    homeDirectory = homeDir+username;
    inherit username;
  };
}
