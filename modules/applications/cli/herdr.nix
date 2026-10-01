{ config, lib, pkgs, options, ... }:

let
  cfg = config.host.home.applications.herdr;
  hasUpstreamModule = options.programs ? herdr;
in
with lib;
{
  options = {
    host.home.applications.herdr = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Agent multiplexer";
      };
      package = mkOption {
        default = pkgs.unstable.herdr.overrideAttrs (old: {
          env.RUSTFLAGS = (old.env.RUSTFLAGS or "") + " -C link-arg=-Wl,--no-eh-frame-hdr";
        });
        type = with types; package;
        description = "Package to install";
      };
      settings = mkOption {
        default = { };
        type = with types; attrs;
        description = "$XDG_CONFIG_HOME/herdr/config.toml";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf hasUpstreamModule {
      programs.herdr = {
        enable = true;
        package = cfg.package;
        settings = cfg.settings;
      };
    })
    (mkIf (!hasUpstreamModule) {
      home.packages = [
        cfg.package
      ];
    })
  ]);
}
