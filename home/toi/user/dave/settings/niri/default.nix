{ lib, ... }:

let
  dir = ./.;
  files = builtins.readDir dir;
  ignoreList = [

  ];
  importable = lib.filterAttrs (name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && !(lib.elem name ignoreList))
    || (
      type == "directory"
      && name != "default.nix"
      && !(lib.elem name ignoreList)
      && builtins.pathExists (dir + "/${name}/default.nix")
    )
  ) files;
  imports = lib.mapAttrsToList (name: type:
    if type == "regular"
    then ./${name}
    else ./${name}/default.nix
  ) importable;
in
{
  imports = imports;
}