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
    ".ssh/id_ed25519" = {
      format = "binary";
      sopsFile = ../../user/dave/secrets/ssh/id_ed25519.enc;
      mode = "600";
    };
    ".ssh/id_ed25519.pub" = {
      format = "binary";
      sopsFile = ../../user/dave/secrets/ssh/id_ed25519.pub.enc;
      mode = "600";
    };
  };
}
