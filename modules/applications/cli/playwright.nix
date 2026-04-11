{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.playwright;
in
  with lib;
{
  options = {
    host.home.applications.playwright = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Playwright browsers and runtime environment";
      };
      nodeVersion = mkOption {
        default = "24";
        type = types.str;
        description = "Node.js version to use with Playwright";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [
        pkgs.${"nodejs_${cfg.nodeVersion}"}
        pkgs.playwright-driver.browsers
      ];

      sessionVariables = {
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
        PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      };
    };
  };
}