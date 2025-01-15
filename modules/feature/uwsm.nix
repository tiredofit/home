{config, lib, pkgs, ...}:
let
  cfg = config.host.home.feature.uwsm;
  uwsmPrefix =
    if config.host.home.feature.uwsm.enable
    then "uwsm app -- "
    else "";
in
  with lib;
{
  options = {
    host.home.feature.uwsm = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Prefixing statements with uwsm ";
      };
      prefix = mkOption {
        default = "${uwsmPrefix}";
        type = with types; str;
        description = "UWSM Prefix";
      };
    };
  };
}
