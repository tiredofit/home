{ config, ... }: {
  programs = {
    vscode = {
      keybindings = [
        {
            key = "alt+a";
            command = "workbench.action.toggleActivityBarVisibility";
        }
        {
            key = "alt+b";
            command = "workbench.action.toggleSidebarVisibility";
        }
        {
            key = "alt+m";
            command = "workbench.action.toggleMenuBar";
        }
        {
            key = "alt+t";
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminal.active";
        }
      ];
    };
  };
}