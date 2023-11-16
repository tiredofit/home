{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) username;

  s = "ti";
  _p = "re";
  _a = "do";
  m = "f";
  t = "i";
  r = "t";
  a_ = ".";
  p_ = "ca";

  email = "${username}@${s}${_p}${_a}${m}${t}${r}${a_}${p_}";
in
  with lib;
{
  host = {
    home = {
      applications = {
        git.enable = mkDefault true;
      };
    };
  };

  programs = {
    git = {
      userEmail = email;
    };
  };
}
