{config, inputs, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.neovim;
in
  with lib;
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

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
    programs = {
      nixvim = {
        enable = true;
        package = pkgs.neovim-unwrapped;
        vimAlias = true;

        #extraPlugins = with pkgs.vimPlugins; [
         #catppuccin-nvim luasnip
        #];
        opts = {
          number = true;
          shiftwidth = 4;
          relativenumber = false;
          termguicolors = true;
        };
        plugins = {
          airline.enable = true;
          barbar.enable = true;
          nix.enable = true;
          dashboard.enable = true;
          cursorline.enable = false;
          gitsigns.enable = true;
          markdown-preview.enable = true;
          nvim-tree.enable = true;
          treesitter = {
            enable = true;
            nixGrammars = false;
            ensureInstalled = [ ];
          };
          surround.enable = true;
          fugitive.enable = true;
          gitgutter.enable = true;
          which-key.enable = true;
          todo-comments.enable = true;
          nvim-colorizer.enable = true;
          #lualine = {
          #  enable = true;
          #  theme = "catppuccin";
          #};
          telescope = {
            enable = true;
            extensions.fzf-native = {
              enable = true;
              settings = {
                fuzzy = true;
              };
            };
          };
          comment.enable = true;
          lsp = {
            enable = true;
            servers.bashls.enable = true;
            servers.html.enable = true;
          };
          trouble.enable = true;
          lspkind.enable = true;
        };
      };
    };
  };
}
