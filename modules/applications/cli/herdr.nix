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
        default =
          let
            version = "0.9.3";
            src = pkgs.unstable.fetchFromGitHub {
              owner = "herdrdev";
              repo = "herdr";
              tag = "v${version}";
              hash = "sha256-uu452Xe23pSvFk7w7fKPjiaqY5QenUIljao2SFAxpc0=";
            };
          in
          pkgs.unstable.herdr.overrideAttrs (old: {
            inherit version src;
            cargoDeps = pkgs.unstable.rustPlatform.fetchCargoVendor {
              pname = "herdr";
              inherit version src;
              hash = "sha256-+gTWtEheyuI59yf2PqRbcbcFIW+/cYb7zZ2mPv2VN0Y=";
            };
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
