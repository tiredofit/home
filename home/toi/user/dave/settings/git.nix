{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) displayName username ;

  _a = "do";
  _p = "re";
  a_ = ".";
  m = "f";
  p_ = "ca";
  r = "t";
  s = "ti";
  t = "i";

  email = "${username}@${s}${_p}${_a}${m}${t}${r}${a_}${p_}";
in
  with lib;
{
  host = {
    home = {
      applications = {
        git.enable = mkDefault true;
        git.maintenance.enable = mkDefault true;
        git.maintenance.repositories = mkDefault [
          "${config.home.homeDirectory}/src/home"
          "${config.home.homeDirectory}/src/nixos"
          "${config.home.homeDirectory}/src/nix-modules"
        ];
        git.maintenance.searchPaths = mkDefault [
          "${config.home.homeDirectory}/src"
        ];
      };
    };
  };

  programs = {
    git = {
      settings = {
        user = {
          name = displayName;
          email = email;
        };
      };
      ignores = [
        "*.code-workspace"
      ];
    };
  };
}
