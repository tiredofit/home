{ config, lib, pkgs, specialArgs, ...}:
let
  s = "ti";
  _p = "re";
  _a = "do";
  m = "f";
  t = "i";
  r = "t";
  a_ = ".";
  p_ = "ca";
  username = "dave";
  email = "${username}@${s}${_p}${_a}${m}${t}${r}${a_}${p_}";

  inherit (specialArgs) hostname role;
  inherit (pkgs.stdenv) isLinux isDarwin;
  homeDir = if isDarwin then "/Users/" else "/home/";
  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;
in
{
  imports = [

  ] ++ existing-imports [
    ./hostname/${hostname}
    ./hostname/${hostname}.nix
    ./role/${role}
    ./role/${role}.nix
  ];

  home = {
    homeDirectory = homeDir+username;
    inherit username;

    packages = with pkgs;
    [

    ]
    ++ lib.optionals ( role == "workstation" || role == "server" )
    [

    ];
  };

  programs = {
    git = {
      userEmail = email;
    };
  };

  sops.secrets = {
    "bashrc.d/toi_remotehosts.sh" = {
      format = "binary";
      sopsFile = ./secrets/bash-toi_remotehosts.sh;
      mode = "500";
    };
  };
}
