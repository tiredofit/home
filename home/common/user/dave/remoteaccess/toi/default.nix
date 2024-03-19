{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.remoteaccess.toi;
  s = "ti";
  _p = "re";
  _a = "do";
  m = "f";
  t = "i";
  r = "t";
  a_ = ".";
  p_ = "ca";
in
  with lib;
{

  options = {
    host.home.user.remoteaccess.toi = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Enable SSH to these hosts with unique Keypair";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "bashrc.d/toi_remotehosts.sh" = {
        format = "binary";
        sopsFile = ../../../../../toi/secrets/bash-toi_remotehosts.sh;
        mode = "500";
      };
      "ssh/toi-id_ed25519" = {
        format = "binary";
        sopsFile = ../../../../../toi/user/dave/secrets/ssh/toi-id_ed25519.enc;
        path = config.home.homeDirectory+"/.ssh/keys/toi-id_ed25519";
        mode = "600";
      };
      "ssh/toi-id_ed25519.pub" = {
        format = "binary";
        sopsFile = ../../../../../toi/user/dave/secrets/ssh/toi-id_ed25519.pub.enc;
        path = config.home.homeDirectory+"/.ssh/keys/toi-id_ed25519.pub";
        mode = "600";
      };
    };

    programs = {
      ssh = {
        enable = mkDefault true;
        matchBlocks = {
          "*.${s}${_p}${_a}${m}${t}${r}${a_}${p_}" = {
            identityFile = config.sops.secrets."ssh/toi-id_ed25519".path;
          };
        };
      };
    };
  };
}
