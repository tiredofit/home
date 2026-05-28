{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.opencode;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;
  jsonFormat = pkgs.formats.json {};
  baseConfigJson = builtins.readFile (jsonFormat.generate "opencode-base.json"
    (builtins.listToAttrs [
      { name = "$schema"; value = "https://opencode.ai/config.json"; }
      { name = "shell"; value = "/run/current-system/sw/bin/bash"; }
    ])
  );
  contentJson = if writeMcp then mcpCfg.output.opencodeFullConfigJson else baseConfigJson;
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
    home.packages = with pkgs; [ opencode ];

    sops.templates."opencode/config" = mkIf (writeMcp && mcpCfg.output.useTemplate) {
      path = "${config.xdg.configHome}/opencode/opencode.jsonc";
      mode = "0600";
      content = contentJson;
    };

    xdg.configFile."opencode/opencode.jsonc" = mkIf (!(writeMcp && mcpCfg.output.useTemplate)) {
      text = contentJson;
    };
  };
}
