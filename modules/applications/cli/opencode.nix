{ config, lib, pkgs, ... }:

let
  opencode_version = "opencode2";
  cfg = config.host.home.applications.opencode;
  mcpCfg = config.host.home.applications.mcp-servers;
  writeMcp = cfg.enable && cfg.mcp.enable && mcpCfg.enable;

  uvx = "${pkgs.uv}/bin/uvx";
  npx = "${pkgs.nodejs}/bin/npx";

  enabledServers = let
    byEnable = lib.filterAttrs (_: s: s.enable) mcpCfg.servers;
  in if cfg.mcp.servers != []
    then lib.filterAttrs (name: _: builtins.elem name cfg.mcp.servers) byEnable
    else byEnable;

  ovOf = name: cfg.mcp.overrides.${name} or {
    disabled = null; oauth = null; codemode = null;
    cwd = null; protocol = null; timeout = null;
  };

  mkCommandArgs = scfg:
    if scfg.runtime == "uvx" then
      {
        cmd = uvx;
        args = (if scfg.bin != null
          then [ "--from" scfg.package scfg.bin ]
          else [ scfg.package ]) ++ scfg.args;
      }
    else if scfg.runtime == "npx" then {
      cmd = npx;
      args = [ "-y" scfg.package ] ++ scfg.args;
    } else {
      cmd = scfg.package;
      args = scfg.args;
    };

  mkV2Server = name: scfg:
    let
      ov = ovOf name;
      effectiveDisabled = if ov.disabled != null then ov.disabled else !scfg.autoStart;
      headersTpl = scfg.headers
        // lib.mapAttrs (_h: key: config.sops.placeholder."${key}") scfg.secretHeaders;
      hasHeaders = headersTpl != {};
      effectiveOauth =
        if ov.oauth != null then ov.oauth
        else if hasHeaders then false
        else null;
      timeoutTpl =
        if ov.timeout == null then null
        else lib.filterAttrs (_: v: v != null) {
          inherit (ov.timeout) startup catalog execution;
        };
      common = { disabled = effectiveDisabled; }
        // lib.optionalAttrs (effectiveOauth != null) { oauth = effectiveOauth; }
        // lib.optionalAttrs (ov.codemode != null) { codemode = ov.codemode; }
        // lib.optionalAttrs (ov.protocol != null) { protocol = ov.protocol; }
        // lib.optionalAttrs (timeoutTpl != null && timeoutTpl != {}) { timeout = timeoutTpl; };
    in
    if scfg.transport == "http" then {
      type = "remote";
      url = if scfg.secretUrl != null then config.sops.placeholder."${scfg.secretUrl}" else scfg.url;
    } // common // lib.optionalAttrs hasHeaders {
      headers = headersTpl;
    } else let
      ca = mkCommandArgs scfg;
      envTpl = scfg.env
        // lib.mapAttrs (_envVar: key: config.sops.placeholder."${key}") scfg.secretEnv;
    in {
      type = "local";
      command = [ ca.cmd ] ++ ca.args;
    } // common // lib.optionalAttrs (envTpl != {}) {
      environment = envTpl;
    } // lib.optionalAttrs (ov.cwd != null) {
      cwd = ov.cwd;
    };

  globalTimeoutTpl =
    if cfg.mcp.timeout == null then {}
    else lib.filterAttrs (_: v: v != null) {
      inherit (cfg.mcp.timeout) startup catalog execution;
    };

  mcpAttrset = {
    servers = lib.mapAttrs mkV2Server enabledServers;
  } // lib.optionalAttrs (globalTimeoutTpl != {}) { timeout = globalTimeoutTpl; };
  mcpJson = builtins.readFile ((pkgs.formats.json {}).generate "opencode-mcp.json" mcpAttrset);

  managedAttrs =
    {
      "$schema" = "https://opencode.ai/config.json";
      shell = "/run/current-system/sw/bin/bash";
    }
    // lib.optionalAttrs (cfg.model != null) { inherit (cfg) model; }
    // lib.optionalAttrs (cfg.share != null) { inherit (cfg) share; }
    // lib.optionalAttrs (cfg.defaultAgent != null) { default_agent = cfg.defaultAgent; }
    // lib.optionalAttrs (cfg.permissions != []) { inherit (cfg) permissions; }
    // lib.optionalAttrs (cfg.agents != {}) { inherit (cfg) agents; }
    // lib.optionalAttrs (cfg.snapshots != null) { inherit (cfg) snapshots; }
    // lib.optionalAttrs (cfg.formatter != null) { inherit (cfg) formatter; }
    // lib.optionalAttrs (cfg.skills != []) { inherit (cfg) skills; }
    // lib.optionalAttrs (cfg.commands != {}) { inherit (cfg) commands; }
    // lib.optionalAttrs (cfg.compaction != null) {
      compaction = lib.filterAttrs (_: v: v != null) {
        inherit (cfg.compaction) auto buffer;
        keep = lib.optionalAttrs (cfg.compaction.keepTokens != null) {
          tokens = cfg.compaction.keepTokens;
        };
      };
    }
    // cfg.extraConfig;
  headJson = builtins.toJSON managedAttrs;
  headInner = builtins.substring 1 (builtins.stringLength headJson - 2) headJson;
  contentJson =
    if writeMcp then ''
      {
        ${headInner},
        "mcp": ${mcpJson}
      }
    ''
    else headJson;
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
        servers = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "poznote" "playwright" ];
          description = "Subset of enabled mcp-servers to include. Empty = include all enabled servers.";
        };
        timeout = mkOption {
          type = with types; nullOr (submodule {
            options = {
              startup = mkOption { type = nullOr int; default = null; description = "Default transport connection timeout (ms). V2 default 30000."; };
              catalog = mkOption { type = nullOr int; default = null; description = "Default listing timeout (ms). V2 default 30000."; };
              execution = mkOption { type = nullOr int; default = null; description = "Default tool execution timeout (ms). V2 default 12h."; };
            };
          });
          default = null;
          description = "Global V2 mcp.timeout defaults. Null leaves unset.";
        };
        overrides = mkOption {
          type = with types; attrsOf (submodule {
            options = {
              disabled = mkOption { type = nullOr bool; default = null; description = "Kill-switch. Null (default) derives !autoStart from the shared definition."; };
              oauth = mkOption { type = nullOr bool; default = null; description = "Remote OAuth. Null (default) disables it when headers are set, otherwise leaves V2 discovery on."; };
              codemode = mkOption { type = nullOr bool; default = null; description = "false exposes tools directly instead of through Code Mode. Null leaves unset (V2 default true)."; };
              cwd = mkOption { type = nullOr str; default = null; description = "Working directory for local servers."; };
              protocol = mkOption { type = nullOr (enum [ "legacy" "auto" "2026-07-28" ]); default = null; description = "MCP protocol version. Null leaves unset (V2 default legacy)."; };
              timeout = mkOption {
                type = nullOr (submodule {
                  options = {
                    startup = mkOption { type = nullOr int; default = null; description = "Transport connection timeout (ms)."; };
                    catalog = mkOption { type = nullOr int; default = null; description = "Listing timeout (ms)."; };
                    execution = mkOption { type = nullOr int; default = null; description = "Tool execution timeout (ms)."; };
                  };
                });
                default = null;
                description = "Per-server timeout overrides. Null leaves unset.";
              };
            };
          });
          default = {};
          example = { poznote = { protocol = "auto"; }; };
          description = "Per-server V2 knobs keyed by mcp-servers name. Only set values are emitted.";
        };
      };
      package = mkOption {
        default = pkgs."pkg-${opencode_version}";
        type = with types; package;
        description = "opencode package to install";
      };
      model = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Default V2 model (provider/model). Null leaves unset.";
        example = "allthewater/dripdrop-7-7-7";
      };
      share = mkOption {
        type = with types; nullOr (enum [ "manual" "auto" "disabled" ]);
        default = null;
        description = "V2 session sharing policy. Null leaves unset.";
      };
      defaultAgent = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Primary agent used when a session does not select one explicitly.";
        example = "build";
      };
      permissions = mkOption {
        type = with types; listOf (submodule {
          options = {
            action = mkOption { type = str; description = "Tool action, eg shell, edit, websearch, or <server>_*. V1 bash is now shell."; };
            resource = mkOption { type = str; default = "*"; description = "Resource glob the rule matches."; };
            effect = mkOption { type = enum [ "allow" "deny" "ask" ]; description = "allow, deny, or ask."; };
          };
        });
        default = [];
        description = "Ordered permissions array. First match wins use deny rules and extraConfig.policies for provider gating.";
        example = [{ action = "shell"; resource = "git push *"; effect = "ask"; }];
      };
      agents = mkOption {
        type = with types; attrsOf (submodule {
          options = {
            description = mkOption { type = nullOr str; default = null; description = "Human-readable description."; };
            mode = mkOption { type = nullOr (enum [ "primary" "subagent" "all" ]); default = null; description = "Agent mode. Null leaves unset."; };
            system = mkOption { type = nullOr str; default = null; description = "System instructions (V1 prompt)."; };
            model = mkOption { type = nullOr str; default = null; description = "provider/model#variant, eg llmoverlord/hallucinator-7-7-7#high."; };
            disabled = mkOption { type = nullOr bool; default = null; description = "Set true to disable a built in agent."; };
            permissions = mkOption {
              type = listOf (submodule {
                options = {
                  action = mkOption { type = str; description = "Tool action."; };
                  resource = mkOption { type = str; default = "*"; description = "Resource glob."; };
                  effect = mkOption { type = enum [ "allow" "deny" "ask" ]; description = "allow, deny, or ask."; };
                };
              });
              default = [];
              description = "Per agent permission overrides.";
            };
          };
        });
        default = {};
        description = "Override built-ins or define specialized agents.";
        example = { reviewer = { system = "Focus on correctness."; mode = "subagent"; }; };
      };
      snapshots = mkOption {
        type = with types; nullOr bool;
        default = null;
        description = "Filesystem snapshots for undo/revert. Null leaves unset.";
      };
      formatter = mkOption {
        type = with types; nullOr bool;
        default = null;
        description = "Format files after write/edit. true enables built ins. Null leaves unset.";
      };
      skills = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Extra skill directories or URLs (V2 skills array).";
        example = [ "./team-skills" ];
      };
      commands = mkOption {
        type = with types; attrsOf (submodule {
          options = {
            description = mkOption { type = nullOr str; default = null; description = "Command description."; };
            template = mkOption { type = str; description = "Prompt template."; };
            agent = mkOption { type = nullOr str; default = null; description = "Agent to run as."; };
            model = mkOption { type = nullOr str; default = null; description = "provider/model#variant override."; };
            subagent = mkOption { type = nullOr bool; default = null; description = "Run delegated in background. Null leaves unset."; };
          };
        });
        default = {};
        description = "Reusable slash commands (V2 commands map).";
      };
      compaction = mkOption {
        type = with types; nullOr (submodule {
          options = {
            auto = mkOption { type = nullOr bool; default = null; description = "Automatic compaction. Null leaves unset."; };
            keepTokens = mkOption { type = nullOr int; default = null; description = "Retained-context budget -> compaction.keep.tokens."; };
            buffer = mkOption { type = nullOr int; default = null; description = "Reserve -> compaction.buffer."; };
          };
        });
        default = null;
        description = "Automatic context compaction budget.";
      };
      extraConfig = mkOption {
        type = with types; attrs;
        default = {};
        description = "Rest of the schema (providers, policies, websearch, network, etc.). Merged last; managed keys are rejected.";
        example = { websearch = { provider = "random"; }; };
      };
    };
  };

  config = mkIf cfg.enable (let
    shellAliases = {
      oc = opencode_version;
      opencode = opencode_version;
    };

  in {
    assertions = [
      {
        assertion = !(cfg.extraConfig ? mcp);
        message = "opencode.extraConfig must not contain 'mcp' (managed via mcp-servers).";
      }
      {
        assertion =
          !(cfg.extraConfig ? shell)
          && !(cfg.extraConfig ? "$schema")
          && !(cfg.extraConfig ? model)
          && !(cfg.extraConfig ? share)
          && !(cfg.extraConfig ? default_agent)
          && !(cfg.extraConfig ? permissions)
          && !(cfg.extraConfig ? agents)
          && !(cfg.extraConfig ? snapshots)
          && !(cfg.extraConfig ? formatter)
          && !(cfg.extraConfig ? skills)
          && !(cfg.extraConfig ? commands)
          && !(cfg.extraConfig ? compaction);
        message = "opencode.extraConfig must not duplicate first-class keys: $schema, shell, model, share, default_agent, permissions, agents, snapshots, formatter, skills, commands, compaction.";
      }
    ];

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
