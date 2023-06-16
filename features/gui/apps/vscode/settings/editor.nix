{ config, ... }: {
  programs = {
    vscode = {
      userSettings = {
        "editor.bracketPairColorization.enabled" = true;
        "editor.copyWithSyntaxHighlighting" = false ;
        "editor.detectIndentation" = false ;
        "editor.fontFamily" = "Hack Nerd Font";
        "editor.fontLigatures" = true;
        "editor.formatOnPaste" = false ;
        "editor.formatOnSave" = false ;
        "editor.formatOnType" = false ;
        "editor.guides.bracketPairs" = "active";
        "editor.mouseWheelZoom" = true ;
        "editor.overviewRulerBorder" = false;
        "editor.renderControlCharacters" = true ;
        "editor.scrollbar.vertical" = false;
        "editor.tabSize" = 4 ;
        "editor.wordWrap" = "off";
        "workbench.editor.enablePreview" = false;
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.showTabs" = true;
        "workbench.editor.untitled.hint" = "hidden";
        "workbench.startupEditor" = "none" ;
      };
    };
  };
}