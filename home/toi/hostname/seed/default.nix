{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        act.enable = true;
        github-client.enable = true;
        hadolint.enable = true;
        lazydocker.enable = true;
        lazygit.enable = true;
        nmap.enable = mkDefault true;
        shellcheck.enable = true;
        shfmt.enable = true;
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
