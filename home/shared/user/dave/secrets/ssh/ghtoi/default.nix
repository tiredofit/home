{config, lib, pkgs, specialArgs, ...}:

let
  inherit (specialArgs) username;
  cfg = config.host.home.user.dave.secrets.ssh.ghtoi;
  s = "g";
  _p = "i";
  _a = "t";
  m = "h";
  t = "u";
  r = "b";
  a_ = ".";
  p_ = "com";
in
  with lib;
{

  options = {
    host.home.user.dave.secrets.ssh.ghtoi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable SSH to these hosts with unique Keypair";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ssh/ghtoi-id_ed25519" = {
        format = "binary";
        sopsFile = ../../../../../../toi/user/dave/secrets/ssh/ghtoi-id_ed25519.enc;
        path = config.home.homeDirectory+"/.ssh/keys/ghtoi-id_ed25519";
        mode = "600";
      };
      "ssh/ghtoi-id_ed25519.pub" = {
        format = "binary";
        sopsFile = ../../../../../../toi/user/dave/secrets/ssh/ghtoi-id_ed25519.pub.enc;
        path = config.home.homeDirectory+"/.ssh/keys/ghtoi-id_ed25519.pub";
        mode = "600";
      };
    };

    programs = {
      ssh = {
        enable = mkDefault true;
        matchBlocks = {
          "${s}${_p}${_a}${m}${t}${r}${a_}${p_}" = {
            identityFile = config.sops.secrets."ssh/ghtoi-id_ed25519".path;
          };
        };
      };
    };
  };
}
