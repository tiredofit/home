{ config, lib, pkgs, specialArgs, ...}:
let
  s = "se";
  _p = "lf";
  _a = "de";
  m = "si";
  t = "gn";
  r = ".";
  a_ = "o";
  p_ = "rg";
  username = "daveconroy";
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
    ./${hostname}
    ./${hostname}.nix
    ./${role}
    ./${role}.nix
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
}
