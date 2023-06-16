{ config, ... }: {

  programs = {
    vscode = {
      userSettings = {
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "terminal.integrated.fontFamily" = "Hack Nerd Font";
      };
    };
  };
}