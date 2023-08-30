{ config, lib, ... }:
  with lib;
{
  imports =  [
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
