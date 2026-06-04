{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.visual-studio-code;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;

  pkgs-ext = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
  marketplace = pkgs-ext.vscode-marketplace;

  enabledServers = let
    enabledByName = lib.filterAttrs (_: s: s.enable) mcpCfg.servers;
  in if cfg.mcp.servers != []
    then lib.filterAttrs (name: _: builtins.elem name cfg.mcp.servers) enabledByName
    else enabledByName;

  mkVscodeServer = name: scfg:
    if scfg.transport == "http" then
      { type = "http"; url = scfg.url; }
      // lib.optionalAttrs (!scfg.autoStart) { disabled = true; }
    else let
      command = if scfg.runtime == "uvx" then "${pkgs.uv}/bin/uvx"
                else if scfg.runtime == "npx" then "${pkgs.nodejs}/bin/npx"
                else scfg.package;
      args = if scfg.runtime == "uvx" then [ scfg.package ] ++ scfg.args
             else if scfg.runtime == "npx" then [ "-y" scfg.package ] ++ scfg.args
             else scfg.args;
      env = scfg.env
            // lib.mapAttrs (envVar: _: "\${env:${envVar}}") scfg.secretEnv;
    in
      { type = "stdio"; inherit command args; }
      // lib.optionalAttrs (env != {}) { inherit env; }
      // lib.optionalAttrs (!scfg.autoStart) { disabled = true; };

  mcpServers = lib.mapAttrs mkVscodeServer enabledServers;

  allSecretEnv = lib.foldl (acc: scfg: acc // scfg.secretEnv) {} (lib.attrValues enabledServers);

  mcpSessionVars = lib.mapAttrs (envVar: secretKey: "$(cat ${config.sops.secrets.${secretKey}.path})") allSecretEnv;
in with lib; {
  options = {
    host.home.applications.visual-studio-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Integrated Development Environment";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "application/x-shellscript"
            "text/english"
            "text/markdown"
            "text/plain"
            "text/x-c"
            "text/x-c++"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-makefile"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
          ];
        };
      };
      mcp = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Inject MCP server definitions into VSCode (mcp.servers). Non-secret servers are declared directly. Servers with secrets use VSCode env var interpolation (''${env:VAR}) - the actual values are provided via sessionVariables populated by sops-nix at login. Requires host.home.applications.mcp-servers.enable = true.";
        };
        servers = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "github" "homeassistant" ];
          description = "List of MCP servers to include in VSCode's config. Empty = include all enabled servers.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.vscode = {
        enable = true;
        profiles = {
          default = {
            extensions = (with pkgs.vscode-extensions; [
            ]) ++ (with marketplace; [
            ]);
            keybindings = [
            ];
            userSettings = {
              "redhat.telemetry.enabled" = false;
              "telemetry.telemetryLevel" = "off";
              "update.mode" = "none";

              "terminal.integrated.profiles.linux" = {
                 "bash" = {
                   "path" = "/usr/bin/env bash";
                   "args" = ["--login"];
                   "icon" = "terminal-bash";
                 };
              };
            };
            userMcp = mkIf (writeMcp && mcpCfg.enable) {
              servers = mcpServers;
            };
          };
        };
      };

      xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable
        (lib.genAttrs cfg.defaultApplication.mimeTypes (_: "code.desktop"));

      home.sessionVariables = mkIf (writeMcp && allSecretEnv != {}) mcpSessionVars;

      sops.templates."mcp/vscode-env" = mkIf (writeMcp && allSecretEnv != {}) {
        path = "${config.home.homeDirectory}/.config/environment.d/00-mcp-env.conf";
        mode = "0600";
        content = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (envVar: secretKey:
            "${envVar}=${config.sops.placeholder."${secretKey}"}"
          ) allSecretEnv
        );
      };
    }
  ]);
}

