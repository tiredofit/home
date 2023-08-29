{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.greenclip;
in
  with lib;
{
  options = {
    host.home.applications.greenclip = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Clipboard Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          greenclip
        ];
    };

    xdg.configFile."greenclip.toml".text = ''
      [greenclip]
        blacklisted_applications = []
        enable_image_support = true
        history_file = "${config.home.homeDirectory}/.cache/greenclip.history"
        image_cache_directory = "/tmp/greenclip"
        max_history_length = 50
        max_selection_size_bytes = 0
        static_history = [""]
        trim_space_from_selection = true
        use_primary_selection_as_input = false
    '';
  };
}
