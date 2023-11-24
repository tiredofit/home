{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) username;

  s = "se";
  _p = "lf";
  _a = "de";
  m = "si";
  t = "gn";
  r = ".";
  a_ = "o";
  p_ = "rg";

  email = "${username}@${s}${_p}${_a}${m}${t}${r}${a_}${p_}";
in
{
  programs = {
    git = {
      userEmail = email;
    };
  };
}
