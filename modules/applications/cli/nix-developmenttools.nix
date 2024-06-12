{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nix-development_tools;
in
  with lib;
{
  options = {
    host.home.applications.nix-development_tools = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Tools for developing and working with Nix";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            alejandra               # code formatter
            deadnix                 # find and remove unused code in source files
            nix-du                  # determine with gc-roots take space in nix store
            nix-init                # quickly bootstrap a nix package definition from URLs
            nix-melt                # ranger-like flake.lock viewer
            nix-output-monitor      # get additional information while building packages
            nix-tree                # interactively browse dependency graphs of Nix derivations
            nix-update              # swiss-knife for updating nix packages
            nixfmt-classic          # nix code formatter
            nixpkgs-fmt             # nix code formatter for nixpkgs
            nixpkgs-lint            # check nixpkgs for common errors
            nurl                    # generate Nix fetcher calls from repository URLs
            nvd                     # nix package version diffs (e.x. nvd diff /run/current-system result)
            toml2nix                # convert toml to nix expressions
          ];
    };
  };
}
