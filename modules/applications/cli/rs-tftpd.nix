{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.rs-tftpd;
in
  with lib;
{
  options = {
    host.home.applications.rs-tftpd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "TFTPD Server";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          rs-tftpd
        ];
    };
  };
}
