{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.visual-studio-code;
  pkgs-ext = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
  marketplace = pkgs-ext.vscode-marketplace;
in with lib; {
  options = {
    host.home.applications.visual-studio-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Integrated Development Environment";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "application/x-shellscript"
            "text/english"
            "text/markdown"
            "text/plain"
            "text/x-c"
            "text/x-c++"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-makefile"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles = {
        default = {
          extensions = (with pkgs.vscode-extensions; [
          ]) ++ (with marketplace; [
            # Bleeding Edge versions
            # For extensions not avaialble in https://search.nixos.org/packages?type=packages&query=vscode-extensions
          ]);
          keybindings = [
          ];
          userSettings = {
            ## Telemetry
            "redhat.telemetry.enabled" = false;
            "telemetry.telemetryLevel" = "off";
            "update.mode" = "none";

            ## Terminal
            "terminal.integrated.profiles.linux" = {
               "bash" = {
                 "path" = "/usr/bin/env bash";
                 "args" = ["--login"];
                 "icon" = "terminal-bash";
               };
            };
          };
        };
      };
    };

    xdg = {
      mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable
        (lib.genAttrs cfg.defaultApplication.mimeTypes (_: "code.desktop"));
    };
  };
}

