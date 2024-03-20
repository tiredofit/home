{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.dave.secrets.ssh.generic;
in
  with lib;
{

  options = {
    host.home.user.dave.secrets.ssh.generic = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable SSH to these hosts with unique Keypair";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ssh/generic-id_ed25519" = {
        format = "binary";
        sopsFile = ../../../../../../generic/user/dave/secrets/ssh/generic-id_ed25519.enc;
        path = config.home.homeDirectory+"/.ssh/keys/generic-id_ed25519";
        mode = "600";
      };
      "ssh/generic-id_ed25519.pub" = {
        format = "binary";
        sopsFile = ../../../../../../sd/user/daveconroy/secrets/ssh/sd-id_ed25519.pub.enc;
        path = config.home.homeDirectory+"/.ssh/keys/generic-id_ed25519.pub";
        mode = "600";
      };
    };

    programs = {
      ssh = {
        enable = mkDefault true;
        matchBlocks = {
          "*" = {
            identityFile = config.sops.secrets."ssh/generic-id_ed25519".path;
          };
        };
      };
    };
  };
}
