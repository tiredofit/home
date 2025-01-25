{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.chatbox-ai;
in
  with lib;
{
  options = {
    host.home.applications.chatbox-ai = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "User-friendly Desktop Client App for AI Models/LLMs (GPT, Claude, Gemini, Ollama...)";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pkg-chatbox-ai
        ];
    };
  };
}
