{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        direnv.enable = true;
        neovim = {
          enable = true;
          lsp = {
            phpactor = false;
            dotnet = false;
            docker = false;
            go = false;
            typescript = false;
            tailwind = false;
          };
          treesitter.nixGrammars = false;
          formatters = false;
        };
        opencode = {
          enable = true;
          mcp.enable = true;
        };
        python.enable = true;
        zellij.enable = true;
      };
      service = {
        vscode-server.enable = false;
      };
    };
  };
}
