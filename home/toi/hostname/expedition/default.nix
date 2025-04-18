{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
in
with lib;
{
  host = {
    home = {
      applications = {
        act.enable = true;
        devenv.enable = true;
        direnv.enable = true;
        github-client.enable = true;
        hadolint.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        nix-development_tools.enable = true;
        nmap.enable = true;
        python.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        yq.enable = true;
        yt-dlp.enable = true;
      };
      user = {
        dave = {
          secrets = {
            act = {
              toi.enable = true;
            };
            github = {
              toi.enable = true;
            };
          };
        };
      };
    };
  };
}
