{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.host.home.applications.mcp-servers;
  hasSops = config ? sops;

  serverOpts = { name, config, ... }: {
    options = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable MCP server ${name}";
      };
      runtime = mkOption {
        type = types.enum [ "npx" "uvx" "bin" ];
        description = "npx = npm package, uvx = PyPI package, bin = absolute nix store path";
      };
      package = mkOption {
        type = types.str;
        description = "PyPI/npm package name, or absolute binary path for bin runtime";
      };
      args = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra arguments passed after the package name";
      };
      env = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Non-secret environment variables";
      };
      secretEnv = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Mapping of env var name -> sops secret key within secretsFile. Prefix all keys with 'mcp/'";
        example = "{ SUPER_SECRET_TOKEN = "mcp/super_secret_token" }";
      };
      autoStart = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto Start MCP servers on launch";
      };
      transport = mkOption {
        type = types.enum [ "local" "http" ];
        default = "local";
        description = "Transport type: local = stdio via command, http = HTTP endpoint";
      };
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Endpoint URL for http transport (required when transport = 'http')";
      };
      secretsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Per-server secrets file override. Falls back to the global secretsFile if null.";
      };
    };
  };

in
{
  options.host.home.applications.mcp-servers = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Enable MCP server definitions";
    };
    secretsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a secrets file containing all MCP API keys";
    };
    servers = mkOption {
      type = types.attrsOf (types.submodule serverOpts);
      default = {};
      description = "Declarative MCP server definitions";
    };
    output = {  # computed outputs; set by this module, not intended to be overridden
      useTemplate = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the sops template path is active";
      };
      prettyJson = mkOption {
        type = types.str;
        default = "";
        description = "Pretty-printed MCP JSON (with placeholders if secrets present)";
      };
      opencodeMcpJson = mkOption {
        type = types.str;
        default = "";
        description = "OpenCode-format MCP JSON (mcp section only)";
      };
      opencodeFullConfigJson = mkOption {
        type = types.str;
        default = "";
        description = "Full opencode.jsonc with MCP servers (with placeholders if secrets present)";
      };
    };
  };

  config = mkIf cfg.enable (let
    uvx = "${pkgs.uv}/bin/uvx";
    npx = "${pkgs.nodejs}/bin/npx";

    enabledServers = filterAttrs (_: s: s.enable) cfg.servers;

    # Resolve the effective secrets file for a server: per-server > global > null
    effectiveSecretsFile = scfg:
      if scfg.secretsFile != null then scfg.secretsFile
      else cfg.secretsFile;

    # Flat list of { key, sopsFile } for every secret across all enabled servers that have a resolvable file. Used to register sops.secrets entries.
    serverSecretPairs = concatMap (scfg:
      let ef = effectiveSecretsFile scfg;
      in optionals (ef != null && scfg.secretEnv != {})
           (map (key: { inherit key; sopsFile = ef; }) (attrValues scfg.secretEnv))
    ) (attrValues enabledServers);

    useTemplate = hasSops && serverSecretPairs != [];

    mkCommandArgs = _name: scfg:
      if scfg.runtime == "uvx" then {
        cmd = uvx;
        args = [ scfg.package ] ++ scfg.args;
      } else if scfg.runtime == "npx" then {
        cmd = npx;
        args = [ "-y" scfg.package ] ++ scfg.args;
      } else {
        cmd = scfg.package;
        args = scfg.args;
      };

    mkServerEntry = name: scfg:
      if scfg.transport == "http" then
        { command = "${pkgs.curl}/bin/curl"; args = [ scfg.url ]; type = "http"; }
        // optionalAttrs (!scfg.autoStart) { disabled = true; }
      else let
        ca = mkCommandArgs name scfg;

        envAttrs =
          scfg.env
          // mapAttrs
               (_envVar: secretKey: config.sops.placeholder."${secretKey}")
               scfg.secretEnv;
      in
        { command = ca.cmd; args = ca.args; }
        // optionalAttrs (envAttrs != {}) { env = envAttrs; }
        // optionalAttrs (!scfg.autoStart) { disabled = true; };

    mkOpendocServerEntry = name: scfg:
      if scfg.transport == "http" then {
        type = "remote";
        url = scfg.url;
        enabled = scfg.autoStart;
      } else let
        ca = mkCommandArgs name scfg;
        envAttrs =
          scfg.env
          // mapAttrs
               (_envVar: secretKey: config.sops.placeholder."${secretKey}")
               scfg.secretEnv;
      in {
        type = "local";
        command = [ ca.cmd ] ++ ca.args;
        enabled = scfg.autoStart;
      } // optionalAttrs (envAttrs != {}) {
        environment = envAttrs;
      };

    mcpAttrset = { mcpServers = mapAttrs mkServerEntry enabledServers; };
    jsonFormat = pkgs.formats.json {};
    prettyJson = builtins.readFile (jsonFormat.generate "mcp-config.json" mcpAttrset);

    opencodeMcpAttrset = mapAttrs mkOpendocServerEntry enabledServers;
    opencodeMcpJson = builtins.readFile (jsonFormat.generate "opencode-mcp.json" opencodeMcpAttrset);

    opencodeFullConfigJson = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "shell": "/run/current-system/sw/bin/bash",
        "mcp": ${opencodeMcpJson}
      }
    '';

  in {
    host.home.applications.mcp-servers = {
      output.useTemplate = useTemplate;
      output.prettyJson = prettyJson;
      output.opencodeMcpJson = opencodeMcpJson;
      output.opencodeFullConfigJson = opencodeFullConfigJson;

      servers = {
        context7 = { runtime = mkDefault "npx"; package = mkDefault "@upstash/context7-mcp"; };
        everything = { runtime = mkDefault "npx"; package = mkDefault "@modelcontextprotocol/server-everything"; };
        fetch = { runtime = mkDefault "uvx"; package = mkDefault "mcp-server-fetch"; };
        filesystem = { runtime = mkDefault "npx"; package = mkDefault "@modelcontextprotocol/server-filesystem"; args = [ ]; };
        git = { runtime = mkDefault "uvx"; package = mkDefault "mcp-server-git"; args = [ ]; };
        github = { runtime = mkDefault "npx"; package = mkDefault "@modelcontextprotocol/server-github"; secretEnv = mkDefault { GITHUB_PERSONAL_ACCESS_TOKEN = "mcp/github_token"; }; };
        homeassistant = { runtime = mkDefault "uvx"; package = mkDefault "ha-mcp"; secretEnv = mkDefault { HOMEASSISTANT_URL = "mcp/homeassistant_url"; HOMEASSISTANT_TOKEN = "mcp/homeassistant_token"; }; };
        mcp-nixos = { runtime = mkDefault "uvx"; package = mkDefault "mcp-nixos"; };
        memory = { runtime = mkDefault "npx"; package = mkDefault "@modelcontextprotocol/server-memory"; };
        mqtt = { runtime = mkDefault "uvx"; package = mkDefault "mqtt-mcp"; };
        opnsense = { runtime = mkDefault "uvx"; package = mkDefault "opnsense-mcp-server"; secretEnv = mkDefault { OPNSENSE_URL = "mcp/opnsense_url"; OPNSENSE_API_KEY = "mcp/opnsense_api_key"; OPNSENSE_API_SECRET = "mcp/opnsense_api_secret"; OPNSENSE_VERIFY_SSL = "mcp/opnsense_verify_ssl"; OPNSENSE_ALLOW_WRITES = "mcp/opnsense_allow_writes";};};
        n8n = { runtime = mkDefault "npx"; package = mkDefault "n8n-mcp"; secretEnv = mkDefault { N8N_API_URL = "mcp/n8n_url"; N8N_API_KEY = "mcp/n8n_key"; };};
        playwright = { runtime = mkDefault "npx"; package = mkDefault "@playwright/mcp@latest"; };
        sequential-thinking = { runtime = mkDefault "npx"; package = mkDefault "@modelcontextprotocol/server-sequential-thinking"; };
        zigbee2mqtt = { transport = mkDefault "http"; url = mkDefault "http://127.0.0.1:4747/mcp"; };
      };
    };

    home.packages = with pkgs; [
      uv       # uvx
      nodejs   # npx
    ];

    # Auto-register every sops key referenced across all enabled servers, each against its resolved secrets file (per-server or global).
    sops.secrets = mkIf (hasSops && serverSecretPairs != []) (
      listToAttrs (map
        ({ key, sopsFile }: nameValuePair key { inherit sopsFile; })
        serverSecretPairs)
    );
  });
}
