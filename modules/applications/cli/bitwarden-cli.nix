{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.bitwarden-cli;
in
  with lib;
{
  options = {
    host.home.applications.bitwarden-cli = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Tools to access Bitwarden Vaults.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          bitwarden-cli
          bws
          rbw
        ];
    };
  };
}

