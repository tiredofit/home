{ config, ... }: {

  programs = {
    vscode = {
      userSettings = {
        "redhat.telemetry.enabled" = false;
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "update.mode" = "none";
      };
    };
  };
}