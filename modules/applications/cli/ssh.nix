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
      relaxedBlocks = mkOption {
        default = [];
        type = with types; listOf str;
        description = "List of hosts, IPs, or patterns for which to disable host key checking and known hosts.";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      ssh = lib.mkMerge [
        {
          enable = true;
          matchBlocks =
            let
              relaxedBlocksAttrs = listToAttrs (map (pattern: {
                name = pattern;
                value = {
                  checkHostIP = false;
                  extraOptions = {
                    "UserKnownHostsFile" = "/dev/null";
                    "StrictHostKeyChecking" = "no";
                  };
                };
              }) (filter (p: p != "*") cfg.relaxedBlocks));
              defaultBlock = {
                "*" = {
                  checkHostIP = false;
                  serverAliveInterval = mkDefault 60;
                };
              };
            in
              defaultBlock // relaxedBlocksAttrs;
        }
        (lib.optionalAttrs (lib.versionAtLeast (lib.version or "0") "25.11pre") {
          enableDefaultConfig = mkDefault false;
        })
      ];
    };
  };
}
