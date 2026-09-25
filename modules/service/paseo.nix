{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.service.paseo;

  fixedPackage =
    let
      base = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.default;
      hp = pkgs.stdenv.hostPlatform;
      prebuildDir =
        if hp.isLinux && hp.isx86_64 then "linux-x64"
        else if hp.isLinux && hp.isAarch64 then "linux-arm64"
        else throw "paseo: unsupported platform for node-pty prebuild";
    in
    base.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        prebuilt="packages/server/node_modules/node-pty/prebuilds/${prebuildDir}"
        if [ ! -f "$prebuilt/pty.node" ]; then
          echo "paseo: expected node-pty addon missing at $prebuilt" >&2
          exit 1
        fi
        mkdir -p "$out/lib/paseo/$prebuilt"
        cp -a "$prebuilt/." "$out/lib/paseo/$prebuilt/"
      '';
    });
in
{
  options.host.home.service.paseo = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable the Paseo daemon";
    };

    package = lib.mkOption {
      default = fixedPackage;
      defaultText = lib.literalExpression "inputs.paseo.packages.\${pkgs.stdenv.hostPlatform.system}.default";
      type = lib.types.package;
      description = "Paseo package to use";
    };

    port = lib.mkOption {
      default = 6767;
      type = lib.types.port;
      description = "Port listen on";
    };

    relay.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable relay based remote access via app.paseo.sh. False runs with --no-relay and accepts direct connections only.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.paseo-daemon = {
      Unit = {
        Description = "Paseo";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        ExecStart =
          "${cfg.package}/bin/paseo-server"
          + lib.optionalString (!cfg.relay.enable) " --no-relay";
        Environment = [
          "PASEO_HOME=${config.home.homeDirectory}/.local/share/paseo"
          "PASEO_LISTEN=127.0.0.1:${toString cfg.port}"
          "PATH=${lib.concatStringsSep ":" [
            "${config.home.homeDirectory}/.nix-profile/bin"
            "${config.home.homeDirectory}/.local/state/nix/profile/bin"
            "/etc/profiles/per-user/${config.home.username}/bin"
            "/run/current-system/sw/bin"
            "/run/wrappers/bin"
          ]}"
        ];
        Restart = "on-failure";
        RestartSec = 5;
        KillSignal = "SIGTERM";
        TimeoutStopSec = 15;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
