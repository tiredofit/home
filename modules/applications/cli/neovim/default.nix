{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.neovim;
in
  with lib;
{
  options = {
    host.home.applications.neovim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Text editor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          #neovim
        ];
    };

    programs = {
      neovim = {
        enable = true;
	vimAlias = true;
          vimAlias = true;
          plugins = with pkgs.vimPlugins; [
            undotree
            vim-polyglot
            targets-vim
            vim-commentary
            vim-repeat
            vim-sensible
            vim-surround
            vim-tmux-navigator
            vim-visual-multi
	  ];
	};
    };
  };
}
