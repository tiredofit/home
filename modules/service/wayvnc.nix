{ config, inputs, lib, pkgs, ... }:
with lib;
{
  options = {
    host.home.service.wayvnc = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable WayVNC server";
      };
      service = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Auto start on user session start";
        };
      };
      package = mkOption {
        type = types.package;
        default = pkgs.wayvnc;
        description = "WayVNC package to use.";
      };
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The IP address or unix socket path to listen on.";
      };
      port = mkOption {
        type = types.port;
        default = 5900;
        description = "TCP port to listen on.";
      };
      output = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Output to capture.";
      };
      seat = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Seat by name.";
      };
      keyboard = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Keyboard layout.";
        example = "us";
      };
      logLevel = mkOption {
        type = types.enum [ "error" "warning" "info" "debug" "trace" "quiet" ];
        default = "warning";
        description = "Log level";
      };
      relaxEncryption = mkOption {
        type = types.bool;
        default = false;
        description = "Relax the encryption requirements.";
      };
      secretsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Relative path to the SOPS file containing username and password.";
      };
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = "Additional settings for wayvnc config.";
      };
    };
  };

  config = let
    cfg = config.host.home.service.wayvnc;
    hasSopsModule = config ? sops;
    hasSecrets = cfg.secretsFile != null;
    configPath = "${config.home.homeDirectory}/.config/wayvnc/config";
    # Build command line args for wayvnc
    wayvncArgs = [
      cfg.address
      (toString cfg.port)
    ]
    ++ (optional (cfg.output != null) ["--output" cfg.output])
    ++ (optional (cfg.seat != null) ["--seat" cfg.seat])
    ++ ["--log-level" cfg.logLevel]
    ++ (mapAttrsToList (name: value: ["--${name}" (toString value)]) cfg.settings);
    wayvncCmd = concatStringsSep " " (["${cfg.package}/bin/wayvnc"] ++ wayvncArgs ++ (if hasSopsModule && hasSecrets then ["-C" configPath] else []));
  in mkIf cfg.enable {

    home.packages = [
      cfg.package
    ];

    systemd.user.services.wayvnc = mkIf cfg.service.enable {
      Unit = {
        Description = "VNC Viewer";
        Documentation = "https://github.com/any1/wayvnc";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };

      Service = mkForce {
        ExecStart = wayvncCmd;
        Restart = "always";
        RestartSec = 10;
      };

      Install = mkForce {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    sops.secrets = mkIf (hasSopsModule && hasSecrets) {
      "wayvnc/username" = { sopsFile = cfg.secretsFile; };
      "wayvnc/password" = { sopsFile = cfg.secretsFile; };
    };

    sops.templates."wayvnc/config" = mkIf (hasSopsModule && hasSecrets) {
      name = "wayvnc/config";
      path = configPath;
      mode = "0600";
      content = ''
        enable_auth=true
        username=${config.sops.placeholder."wayvnc/username"}
        password=${config.sops.placeholder."wayvnc/password"}
      '';
    };
  };
}
