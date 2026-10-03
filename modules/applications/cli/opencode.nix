{ config, lib, pkgs, ... }:

let
  opencode_version = "opencode2";
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
      package = mkOption {
        default = pkgs."pkg-${opencode_version}";
        type = with types; package;
        description = "opencode package to install";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellAliases = {
      oc = opencode_version;
    };
  in {
    home.packages = [
      cfg.package
      pkgs.sqlite
    ];

    programs = {
      bash = {
        shellAliases = shellAliases;
      };
      zsh = {
        shellAliases = shellAliases;
      };
    };

    sops.templates."opencode/config" = mkIf (writeMcp && mcpCfg.output.useTemplate) {
      path = "${config.xdg.configHome}/opencode/opencode.jsonc";
      mode = "0600";
      content = contentJson;
    };

    xdg.configFile."opencode/opencode.jsonc" = mkIf (!(writeMcp && mcpCfg.output.useTemplate)) {
      text = contentJson;
    };
  });
}
