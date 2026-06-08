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
            context7.enable = true;
            everything.enable = true;
            fetch.enable = true;
            filesystem = {
              enable = true;
              args = [ "/home/dave/src/" ];
            };
            git = {
              enable = true;
              args = [ "--repository" "/home/dave/src/nfra/" ];
            };
            github = {
              enable = true;
              secretEnv = { GITHUB_PERSONAL_ACCESS_TOKEN = "mcp/github_token"; };
            };
            homeassistant = {
              enable = true;
              secretEnv = {
                HOMEASSISTANT_URL = "mcp/homeassistant_url";
                HOMEASSISTANT_TOKEN = "mcp/homeassistant_token";
              };
            };
            mcp-nixos.enable = true;
            memory.enable = true;
            mqtt = {
              enable = true;
              #secretEnv = {
              #  MQTT_HOST = "mcp/mqtt_host";
              #  MQTT_PORT = "mcp/mqtt_port";
              #  MQTT_USERNAME = "mcp/mqtt_username";
              #  MQTT_PASSWORD = "mcp/mqtt_password";
              #};
              #env = {
              #  MQTT_HOST  = "192.168.1.1";
              #  MQTT_PORT  = "1883";
              #};
            };
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
