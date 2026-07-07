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
      lsp = {
        bash = mkOption {
          default = true;
          type = with types; bool;
          description = "Bash LSP (bashls)";
        };
        docker = mkOption {
          default = true;
          type = with types; bool;
          description = "Docker LSP servers";
        };
        dotnet = mkOption {
          default = true;
          type = with types; bool;
          description = ".NET LSP (dotls)";
        };
        go = mkOption {
          default = true;
          type = with types; bool;
          description = "Go LSP (gopls)";
        };
        html = mkOption {
          default = true;
          type = with types; bool;
          description = "HTML LSP servers (superhtml, html)";
        };
        jq = mkOption {
          default = true;
          type = with types; bool;
          description = "jq LSP (jqls)";
        };
        json = mkOption {
          default = true;
          type = with types; bool;
          description = "JSON LSP (jsonls)";
        };
        lua = mkOption {
          default = true;
          type = with types; bool;
          description = "Lua LSP (lua_ls)";
        };
        markdown = mkOption {
          default = true;
          type = with types; bool;
          description = "Markdown LSP (marksman)";
        };
        nix = mkOption {
          default = true;
          type = with types; bool;
          description = "Nix LSP (nil_ls)";
        };
        phpactor = mkOption {
          default = true;
          type = with types; bool;
          description = "PHP LSP (phpactor)";
        };
        python = mkOption {
          default = true;
          type = with types; bool;
          description = "Python LSP (pyright)";
        };
        sql = mkOption {
          default = true;
          type = with types; bool;
          description = "SQL LSP (sqls)";
        };
        tailwind = mkOption {
          default = true;
          type = with types; bool;
          description = "Tailwind CSS LSP";
        };
        typescript = mkOption {
          default = true;
          type = with types; bool;
          description = "TypeScript/JavaScript LSP (ts_ls)";
        };
        yaml = mkOption {
          default = true;
          type = with types; bool;
          description = "YAML LSP (yamlls)";
        };
      };
      treesitter = {
        nixGrammars = mkOption {
          default = true;
          type = with types; bool;
          description = "Install tree-sitter grammars via nixpkgs";
        };
      };
      formatters = mkOption {
        default = true;
        type = with types; bool;
        description = "Install formatters (prettier, stylua)";
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
        optional cfg.formatters prettier;
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
