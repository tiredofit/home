{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.dave.secrets.ssh.sr;
  s = "sp";
  _p = "ir";
  _a = "ir";
  m = "ob";
  t = "ot";
  r = "ic";
  a_ = "s.c";
  p_ = "om";
in
  with lib;
{

  options = {
    host.home.user.dave.secrets.ssh.sr = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable SSH to these hosts with unique Keypair";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "bashrc.d/sr_remotehosts.sh" = {
        format = "binary";
        sopsFile = ../../../../../../sr/secrets/bash-sr_remotehosts.sh;
        mode = "500";
      };
      "ssh/sr-id_ed25519" = {
        format = "binary";
        sopsFile = ../../../../../../sr/user/daveconroy/secrets/ssh/sr-id_ed25519.enc;
        path = config.home.homeDirectory+"/.ssh/keys/sr-id_ed25519";
        mode = "600";
      };
      "ssh/sr-id_ed25519.pub" = {
        format = "binary";
        sopsFile = ../../../../../../sr/user/daveconroy/secrets/ssh/sr-id_ed25519.pub.enc;
        path = config.home.homeDirectory+"/.ssh/keys/sr-id_ed25519.pub";
        mode = "600";
      };
    };

    programs = {
      ssh = {
        enable = mkDefault true;
        matchBlocks = {
          "*.${s}${_p}${_a}${m}${t}${r}${a_}${p_}" = {
            identityFile = config.sops.secrets."ssh/sr-id_ed25519".path;
          };
        };
      };
    };
  };
}
