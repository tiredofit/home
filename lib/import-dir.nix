{ lib }: dir: { ignore ? [ ] }:
let
  files = builtins.readDir dir;
  isImportable = name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && !lib.elem name ignore)
    || (type == "directory"
      && name != "default.nix"
      && !lib.elem name ignore
      && builtins.pathExists (dir + "/${name}/default.nix"));
  importable = lib.filterAttrs isImportable files;
in
lib.mapAttrsToList (name: type:
  if type == "regular"
  then dir + "/${name}"
  else dir + "/${name}/default.nix"
) importable
