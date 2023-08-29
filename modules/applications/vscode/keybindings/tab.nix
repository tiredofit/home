{ config, ... }: {
  programs = {
    vscode = {
      keybindings = [
        {
            key = "ctrl+1";
            command = "workbench.action.openEditorAtIndex1";
        }
        {
            key = "ctrl+2";
            command = "workbench.action.openEditorAtIndex2";
        }
        {
            key = "ctrl+3";
            command = "workbench.action.openEditorAtIndex3";
        }
        {
            key = "ctrl+4";
            command = "workbench.action.openEditorAtIndex4";
        }
        {
            key = "ctrl+5";
            command = "workbench.action.openEditorAtIndex5";
        }
        {
            key = "ctrl+6";
            command = "workbench.action.openEditorAtIndex6";
        }
        {
            key = "ctrl+7";
            command = "workbench.action.openEditorAtIndex7";
        }
        {
            key = "ctrl+8";
            command = "workbench.action.openEditorAtIndex8";
        }
        {
            key = "ctrl+9";
            command = "workbench.action.openEditorAtIndex9";
        }
      ];
    };
  };
}