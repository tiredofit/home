{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.claude-code;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;
  claudeConfigPath = "${config.home.homeDirectory}/.claude.json";
in
with lib;
{
  options = {
    host.home.applications.claude-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Generative Coding Agent";
      };
      mcp = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Write MCP server configuration for Claude Code";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      claude-code = {
        enable = true;
      };
    };

    sops.templates."mcp/claude" = mkIf (writeMcp && mcpCfg.output.useTemplate) { # Secrets path
      path = claudeConfigPath;
      mode = "0600";
      content = mcpCfg.output.prettyJson;
    };

    home.file.".claude.json" = mkIf (writeMcp && !mcpCfg.output.useTemplate) {
      text = mcpCfg.output.prettyJson;
    };
  };
}
