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
      activation = {
        config-greenclip = ''
          if [ ! -d $HOME/.cache/greenclip/images.cache ]; then
              echo "Creating Greenclip Cache Directry"
              mkdir -p $HOME/.cache/greenclip/images.cache
              chown -R $USER $HOME/.cache/greenclip
          fi
        '';
      };
      packages = with pkgs;
        [
          haskellPackages.greenclip
        ];
    };

    xdg.configFile."greenclip.toml".text = ''
      [greenclip]
        blacklisted_applications = []
        enable_image_support = true
        history_file = "${config.home.homeDirectory}/.cache/greenclip/greenclip.history"
        image_cache_directory = "${config.home.homeDirectory}/.cache/greenclip/images.cache"
        max_history_length = 50
        max_selection_size_bytes = 0
        static_history = [""]
        trim_space_from_selection = true
        use_primary_selection_as_input = false
    '';
  };
}
