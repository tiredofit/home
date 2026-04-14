{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.playwright;
in
with lib;
{
  options.host.home.applications.playwright = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Playwright browsers and runtime environment";
    };

    nodeVersion = mkOption {
      type = types.str;
      default = "24";
      description = "Node.js version to use with Playwright";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.${"nodejs_${cfg.nodeVersion}"}
      pkgs.playwright-driver.browsers
      pkgs.playwright-mcp
    ];

    home.sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };

    programs.zsh.sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };
  };
}
