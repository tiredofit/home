{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.claude-code;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;
  claudeConfigPath = "${config.home.homeDirectory}/.claude.json";

  filteredPrettyJson = if writeMcp && cfg.mcp.servers != []
    then builtins.toJSON {
      mcpServers = lib.filterAttrs (name: _: builtins.elem name cfg.mcp.servers)
        (builtins.fromJSON mcpCfg.output.prettyJson).mcpServers;
    }
    else mcpCfg.output.prettyJson;
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
        servers = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "github" "homeassistant" ];
          description = "List of MCP servers to include in Claude Code's config. Empty = include all enabled servers.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs = {
        claude-code = {
          enable = true;
        };
      };

      sops.templates."mcp/claude" = mkIf (writeMcp && mcpCfg.output.useTemplate) { # Secrets path
        path = claudeConfigPath;
        mode = "0600";
        content = filteredPrettyJson;
      };

      home.file.".claude.json" = mkIf (writeMcp && !mcpCfg.output.useTemplate) {
        text = filteredPrettyJson;
      };
    }
  ]);
}
