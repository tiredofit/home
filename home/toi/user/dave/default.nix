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
{
  programs = {
    git = {
      userEmail = email;
    };
  };
}
