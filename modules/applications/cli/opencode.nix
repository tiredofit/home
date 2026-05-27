{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.opencode;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;
  opencodeConfigPath = "${config.xdg.configHome}/opencode/mcp.json";
in
with lib;
{
  options = {
    host.home.applications.opencode = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Generative Coding Agent";
      };
      mcp = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Write MCP server configuration for opencode";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        opencode
      ];
    };

    sops.templates."mcp/opencode" = mkIf (writeMcp && mcpCfg.output.useTemplate) { # Secrets Path
      path = opencodeConfigPath;
      mode = "0600";
      content = mcpCfg.output.prettyJson;
    };

    xdg.configFile."opencode/mcp.json" = mkIf (writeMcp && !mcpCfg.output.useTemplate) {
      text = mcpCfg.output.prettyJson;
    };
  };
}
