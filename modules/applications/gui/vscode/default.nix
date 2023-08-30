{ config, nix-vscode-extensions, ... }: {

  imports = config.host.home.applications.vscode.enable [
    ./settings
    ./extensions
    ./keybindings
  ];

  programs.vscode = config.host.home.applications.vscode.enable {
    enable = true;
  };
}
