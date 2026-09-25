{ config, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role;
  dock_left="d/Dell Inc. DELL S3220DGF 63BQF43";
  dock_left_mode="2560x1440@60.0";
  dock_left_position="0,0";
  dock_middle="d/Dell Inc. DELL S3220DGF 9H4VF43";
  dock_middle_mode="2560x1440@119.998";
  dock_middle_position="2560,0";
  dock_right="d/Dell Inc. DELL S3220DGF GSDTF43";
  dock_right_mode="2560x1440@119.99800";
  dock_right_position="5120,0";
  laptop_display="d/Lenovo Group Limited 0x403A";
  laptop_display_mode="1920x1200@60.00";
  laptop_external="HDMI-A-1";
in
  with lib;
{
  host = {
    home = {
      applications = {
        act.enable = false;
        android-studio.enable = false;
        blanket.enable = true;
        calibre.enable = false;
        cryfs.enable = true;
        direnv.enable = true;
        docker-compose.enable = true;
        feishin.enable = true;
        ferdium.service.enable = true;
        file-roller.enable = true;
        flameshot.enable = true;
        github-client.enable = true;
        hadolint.enable = true;
        herdr.enable = true;
        hyprcursor.enable = true;
        lazydocker.enable = false;
        lazygit.enable = true;
        mcp-servers = {
          enable = true;
          secretsFile = ../../user/dave/secrets/mcp/mcp.yaml;
          servers = {
            mcp-nixos.enable = false;
            memory.enable = false;
            playwright.enable = true;
            opnsense.enable = true;
            poznote = {
              enable = true;
              autoStart = true;
              secretUrl = "mcp/poznote_url";
              secretHeaders.Authorization = "mcp/poznote_auth";
            };
          };

        };
        meld.enable = true;
        mqtt-explorer.enable = false;
        neovim.enable = true;
        nix-development_tools.enable = true;
        networkmanager = {
          enable = true;
          systemtray.enable = mkForce false;
        };
        nextcloud-client = {
          enable = true;
          service.enable = true;
        };
        obsidian.enable = true;
        opencode = {
          enable = true;
          mcp.enable = true;
        };
        opencode2 = {
          enable = true;
          mcp.enable = true;
        };
        playwright.enable = true;
        python.enable = true;
        remmina.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        ssh.enable = true;
        steam-run.enable = true;
        szyszka.enable = false;
        tea.enable = true;
        virt-manager.enable = true;
        volatile-migrate.enable = true;
        visual-studio-code = {
          enable = true;
          defaultApplication.enable = true;
          mcp.enable = true;
        };
        yq.enable = true;
        yt-dlp.enable = true;
        zsh.enable = true;
      };
      feature = {
        emulation.windows.enable = true;
        gui = {
          enable = true;
          displayServer = "wayland";
          windowManager = [ "hyprland" ];
          shell.enable = [ "dms" ];
        };
      };
      service = {
        decrypt_cryfs_workspace.enable = true;
        paseo.enable = true;
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
            ssh = {
              toi.enable = true;
              ghtoi.enable = true;
            };
          };
        };
      };
    };
  };
}
