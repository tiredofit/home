{ config, ... }: {

  programs = {
    vscode = {
      userSettings = {
        "remote.downloadExtensionsLocally" = true;
        "security.workspace.trust.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "shellcheck.enableQuickFix" = true;
      };
    };
  };
}