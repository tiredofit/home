{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.remoteaccess.sd;
  s = "se";
  _p = "lf";
  _a = "de";
  m = "si";
  t = "gn";
  r = ".";
  a_ = "o";
  p_ = "rg";
in
  with lib;
{

  options = {
    host.home.user.remoteaccess.sd = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Enable SSH to these hosts with unique Keypair";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "bashrc.d/sd_remotehosts.sh" = {
        format = "binary";
        sopsFile = ../../../../../sd/secrets/bash-sd_remotehosts.sh;
        mode = "500";
      };
      "ssh/sd-id_ed25519" = {
        format = "binary";
        sopsFile = ../../../../../sd/user/daveconroy/secrets/ssh/sd-id_ed25519.enc;
        path = config.home.homeDirectory+"/.ssh/keys/sd-id_ed25519";
        mode = "600";
      };
      "ssh/sd-id_ed25519.pub" = {
        format = "binary";
        sopsFile = ../../../../../sd/user/daveconroy/secrets/ssh/sd-id_ed25519.pub.enc;
        path = config.home.homeDirectory+"/.ssh/keys/sd-id_ed25519.pub";
        mode = "600";
      };
    };

    programs = {
      ssh = {
        enable = mkDefault true;
        matchBlocks = {
          "*.${s}${_p}${_a}${m}${t}${r}${a_}${p_}" = {
            identityFile = config.sops.secrets."ssh/sd-id_ed25519".path;
          };
        };
      };
    };
  };
}
