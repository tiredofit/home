{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        act.enable = true;
        android-tools.enable = true;
        calibre.enable = true;
        encfs.enable = true;
        git.enable = true;
        github-client.enable = true;
        hugo.enable = true;
        lazygit.enable = true;
        nextcloud-client.enable = true;
        tea.enable = true;
      };
      feature = {
        gui = {
          enable = true;
          displayServer = "x";
          windowManager = "i3";
        };
      };
      service = {
        decrypt_encfs_workspace.enable = true;
        vscode-server.enable = true;
      };
    };
  };

  sops.secrets = {
    "bashrc.d/toi_remotehosts.sh" = {
      format = "binary";
      sopsFile = ../../secrets/bash-toi_remotehosts.sh;
      mode = "500";
    };
  };
}
