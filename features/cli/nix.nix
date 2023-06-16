{ config, pkgs, lib, ...}:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    package = pkgs.nixFlakes;
  };

  programs = {
    bash = {
      initExtra = ''
        export NIX_CONFIG="access-tokens = github.com=$(cat /$XDG_RUNTIME_DIR/secrets/gh_token)"
      '';
    };
  };

  nixpkgs.config.allowUnfree = true ; # Allow Non Free packages
}
