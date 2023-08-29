{ config, lib, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        act
      ];
  };

  programs = {
    bash.initExtra = ''
      if [ -f "$XDG_RUNTIME_DIR"/secrets/act/docker ] ; then
          alias act="act --secret-file $XDG_RUNTIME_DIR/secrets/act/docker"
      fi
      '';
  };

  sops.secrets = {
    "act/docker" = { sopsFile = ../../home/common/secrets/act.yaml ; };
  };
}
