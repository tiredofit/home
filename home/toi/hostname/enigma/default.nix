{ config, lib, pkgs, ...}:
{
  host = {
    home = {
      applications = {
        direnv.enable = true;
        mcp-servers = {
          enable = true;
          secretsFile = ../../user/dave/secrets/mcp/mcp.yaml;
          servers = {
            homeassistant = {
              enable = true;
              secretEnv = {
                HOMEASSISTANT_URL = "mcp/homeassistant_url";
                HOMEASSISTANT_TOKEN = "mcp/homeassistant_token";
              };
            };
            opnsense.enable = true;
            zigbee2mqtt.enable = true;

          };
        };
        mp3gain.enable = true;
        opencode = {
          enable = true;
          mcp.enable = true;
        };
        python.enable = true;
        zellij.enable = true;
      };
      service = {
        vscode-server.enable = false;
      };
    };
  };
}
