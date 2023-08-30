{ config, ... }: {

  imports = [
    ./docker.nix
    ./editor.nix
    ./formatting.nix
    ./git.nix
    ./minimap.nix
    ./security.nix
    ./telemetry.nix
    ./terminal.nix
  ];
  programs = {
    vscode = {
      userSettings = {
        "files.trimTrailingWhitespace" = true;
        "files.useExperimentalFileWatcher" = true;
        "window.menuBarVisibility" = "compact";
        "window.titleBarStyle" = "native";
        "window.zoomLevel" = 1;
      };
    };
  };
}