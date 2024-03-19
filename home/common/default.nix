{ config, inputs, lib, pkgs, specialArgs, ... }:

let
  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;
  inherit (specialArgs) role username windowmanager;
in
with lib;
{
  imports = [
    ./home-manager.nix
    ./locale.nix
    ./nix.nix
    ]
    ++ existing-imports [
    ./role/${role}
    ./role/${role}.nix
    ./user/${username}
    ./user/${username}.nix
    ];

    host = {
      home = {
        applications = {
          bash.enable = mkDefault true;
          bat.enable = mkDefault true;
          btop.enable = mkDefault true;
          diceware.enable = mkDefault true;
          duf.enable = mkDefault true;
          dust.enable = mkDefault true;
          file-compression.enable = mkDefault true;
          fzf.enable = mkDefault true;
          git.enable = mkDefault true;
          gnupg.enable = mkDefault true;
          htop.enable = mkDefault true;
          jq.enable = mkDefault true;
          less.enable = mkDefault true;
          lsd.enable = mkDefault true;
          liquidprompt.enable = mkDefault true;
          mtr.enable = mkDefault true;
          nano.enable = mkDefault true;
          neofetch.enable = mkDefault true;
          ncdu.enable = mkDefault true;
          ranger.enable = mkDefault true;
          ripgrep.enable = mkDefault true;
          secrets.enable = mkDefault true;
          tmux.enable = mkDefault true;
          wget.enable = mkDefault true;
          zoxide.enable = mkDefault true;
        };

        feature = {

        };
        service = {

        };
      };
    };

    home = {
      packages = with pkgs;
        (lib.optionals pkgs.stdenv.isLinux
        [
          psmisc
          strace
        ]);
    };
}

