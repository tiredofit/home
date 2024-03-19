{config, lib, ...}:

let
  cfg = config.host.home.applications.ssh;
in
  with lib;
{
  options = {
    host.home.applications.ssh = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Secure Shell Client";
      };
      ignore = {
        "192.168.1.0/24" = mkOption {
          default = false;
          type = with types; bool;
          description = "Ignore 192.168.1.0/24 Known Hosts and Strict HostKeyChecking";
        };
        "192.168.4.0/24" = mkOption {
          default = false;
          type = with types; bool;
          description = "Ignore 192.168..0/24 Known Hosts and Strict HostKeyChecking";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
        matchBlocks =  {
          "192.168.1.*" = mkIf (cfg.ignore."192.168.1.0/24") {
            checkHostIP = false;
            extraOptions = {
              "UserKnownHostsFile" = "/dev/null";
              "StrictHostKeyChecking" = "no";
            };
          };
          "192.168.4.*" = mkIf (cfg.ignore."192.168.4.0/24") {
            checkHostIP = false;
            extraOptions = {
              "UserKnownHostsFile" = "/dev/null";
              "StrictHostKeyChecking" = "no";
            };
          };
        };
      };
    };
  };
}
