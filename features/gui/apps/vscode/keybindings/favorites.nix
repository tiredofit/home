{ config, ... }: {
  programs = {
    vscode = {
      keybindings = [
        {
            key = "alt+oem_comma";
            command = "workbench.action.showCommands";
        }
        {
            key = "alt+oem_period";
            command = "workbench.action.findInFiles";
            when = "!searchInputBoxFocus";
        }
        {
            key = "alt+p";
            command = "workbench.action.quickOpen";
        }
        {
            key = "alt+e";
            command = "workbench.view.explorer";
        }
        {
            key = "shift+alt+w";
            command = "workbench.action.closeOtherEditors";
        }
      ];
    };
  };
}