{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.librewolf;
in
  with lib;
{
  options = {
    host.home.applications.librewolf = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "LibreWolf is a privacy enhanced Firefox fork";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          unstable.firefoxpwa
        ];
    };

    programs = {
      librewolf = {
        enable = true;
        package = if pkgs.stdenv.isLinux then pkgs.unstable.librewolf else pkgs.unstable.firefox-bin;
        nativeMessagingHosts = with pkgs; [
          pkgs.unstable.firefoxpwa
        ];
      };
    };
  };
}
