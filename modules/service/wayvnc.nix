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
    configPath = if hasSopsModule
      then config.sops.templates."wayvnc/config".path
      else "${config.home.homeDirectory}/.config/wayvnc/config";
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
        ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config ${configPath} --log-level=${cfg.logLevel}";
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

    sops.templates."wayvnc/config" = mkIf hasSopsModule {
      name = "wayvnc/config";
      path = "${config.home.homeDirectory}/.config/wayvnc/config";
      content = ''
        address=${cfg.address}
        port=${toString cfg.port}
        ${optionalString hasSecrets ''
          enable_auth=true
          ${if cfg.relaxEncryption then "relax_encryption=true" else "relax_encryption=false"}
          username=${config.sops.placeholder."wayvnc/username"}
          password=${config.sops.placeholder."wayvnc/password"}
        ''}
        ${optionalString (cfg.output != null) "output=${cfg.output}"}
        ${optionalString (cfg.seat != null) "seat=${cfg.seat}"}
        ${concatStringsSep "\n" (mapAttrsToList (name: value: "${name}=${toString value}") cfg.settings)}
      '';
    };

    home.file."${config.home.homeDirectory}/.config/wayvnc/config" = mkIf (!hasSopsModule) {
      text = ''
        address=${cfg.address}
        port=${toString cfg.port}
        relax_encryption=${toString cfg.relaxEncryption}
        ${optionalString (cfg.output != null) "output=${cfg.output}"}
        ${optionalString (cfg.seat != null) "seat=${cfg.seat}"}
        ${concatStringsSep "\n" (mapAttrsToList (name: value: "${name}=${toString value}") cfg.settings)}
      '';
    };
  };
}
