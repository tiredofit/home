{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        act
      ];
  };

  programs = {
    bash.initExtra = ''
      alias act="act --secret-file $XDG_RUNTIME_DIR/secrets/act/docker"
    '';
  };

  sops.secrets = {
    "act/docker" = { sopsFile = ../../home/common/secrets/act.yaml ; };
  };
}
