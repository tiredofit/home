{ config, nix-vscode-extensions, ... }: {
  imports = [
    ./settings
    ./extensions
    ./keybindings
  ];

  programs.vscode = {
    enable = true;
    #package = pkgs.vscodium;
  };
}
