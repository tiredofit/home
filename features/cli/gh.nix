{ config, pkgs, ...}:
{
  programs = {
    gh = {
      enable = true;
      extensions = [
        pkgs.gh-eco
      ];
      settings = {
        prompt = "enabled";

        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    bash.initExtra = ''
      export GITHUB_TOKEN=$(cat /$XDG_RUNTIME_DIR/secrets/gh_token)
    '';
  };

  sops.secrets.gh_token = {
    sopsFile = ../../home/common/secrets/gh.yaml ;
    path = "%r/gh-token" ;
  };
}
