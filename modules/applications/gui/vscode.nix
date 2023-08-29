{ config, lib, nix-colors, pkgs, ... }:

let
  cfg = config.host.home.applications.visual-studio-code;
in
  with lib;
{

  imports = config.host.home.applications.visual-studio-code.enable [
    ./vscode
  ];

  options = {
    host.home.applications.visual-studio-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Integrated Development Environment";
      };
    };
  };
}
