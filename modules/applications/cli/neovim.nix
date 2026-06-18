{config, inputs, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.neovim;
in
  with lib;
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  options = {
    host.home.applications.neovim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Editor";
      };
    };
  };

  config = mkIf cfg.enable (let
    aliases = {
      vi = "nvim";
    };
  in {
    home = {
      packages = with pkgs;
        [
          prettier
        ];
    };
    
    host.home.applications = {
      ast-grep.enable = mkDefault true;
      fd.enable = mkDefault true;
      fzf.enable = mkDefault true;
      ripgrep.enable = mkDefault true;
    };
    
    programs = {
      bash = {
        shellAliases = aliases;
      };
      zsh = {
        shellAliases = aliases;
      };

      nixvim = {
        enable = true;
        package = pkgs.neovim-unwrapped;
        vimAlias = true;
        nixpkgs = {
          source = inputs.nixpkgs;
          useGlobalPackages = true;
        };
      };
    };
  });
}
