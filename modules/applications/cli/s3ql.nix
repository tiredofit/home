{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.s3ql;
in
  with lib;
{
  options = {
    host.home.applications.s3ql = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Filesystem based on S3 Buckets";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          s3ql
        ];
    };
  };
}
