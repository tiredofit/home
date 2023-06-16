{ config, ... }: {
  programs = {
    vscode = {
      userSettings = {
        "git.autofetch" = true;
        "git.ignoreLegacyWarning" = true;
        "git.ignoreMissingGitWarning" = true;
        "git.openRepositoryInParentFolders" = "never";
        "git.showPushSuccessNotification" = true;
        "git.suggestSmartCommit"= false;
      };
    };
  };
}