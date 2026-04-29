{config, inputs, lib, pkgs, ...}:
let
  cfg = config.host.home.feature.theming;
in
  with lib;
{
  options = {
    host.home.feature.theming = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable theming";
      };

      stylix = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "Enable Stylix for unified, wallpaper-driven theming across all apps";
        };

        polarity = mkOption {
          default = "dark";
          type = types.enum [ "either" "light" "dark" ];
          description = "Force a light or dark palette, or let Stylix choose automatically";
        };

        image = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Wallpaper image. Used as the desktop background and to auto-generate the colour scheme";
          example = "literalExpression ''./dotfiles/backgrounds/waves.jpg''";
        };

        scheme = mkOption {
          type = types.nullOr (types.oneOf [ types.path types.str (types.attrsOf types.anything) ]);
          default = null;
          description = "Base16 colour scheme override. When null, the scheme is derived automatically from the wallpaper image. Accepts a path to a YAML file, raw YAML string, or an attribute set";
        };

        autoEnable = mkOption {
          default = true;
          type = types.bool;
          description = "Auto-enable Stylix targets for all supported applications. Set to false to opt-in per application via stylix.targets.<name>.enable";
        };

        cursor = {
          package = mkOption {
            type = types.nullOr types.package;
            default = pkgs.bibata-cursors;
            description = "Package providing the cursor theme";
          };
          name = mkOption {
            type = types.nullOr types.str;
            default = "Bibata-Modern-Classic";
            description = "Cursor theme name within the package";
          };
          size = mkOption {
            type = types.nullOr types.int;
            default = 24;
            description = "Cursor size";
          };
        };

        fonts = {
          sansSerif = {
            package = mkOption { type = types.package; default = pkgs.noto-fonts; description = "Sans-serif font package"; };
            name    = mkOption { type = types.str;     default = "Noto Sans";     description = "Sans-serif font name";    };
          };
          serif = {
            package = mkOption { type = types.package; default = pkgs.noto-fonts; description = "Serif font package"; };
            name    = mkOption { type = types.str;     default = "Noto Serif";    description = "Serif font name";    };
          };
          monospace = {
            package = mkOption { type = types.package; default = pkgs.nerd-fonts.jetbrains-mono; description = "Monospace font package"; };
            name    = mkOption { type = types.str;     default = "JetBrainsMono Nerd Font"; description = "Monospace font name"; };
          };
          sizes = {
            applications = mkOption { type = types.int; default = 11; description = "Application font size (pt)"; };
            desktop      = mkOption { type = types.int; default = 10; description = "Desktop / bar font size (pt)"; };
            terminal     = mkOption { type = types.int; default = 13; description = "Terminal font size (pt)"; };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nwg-look
      ];
    };

    # Wire stylix options when enabled. The manual GTK/cursor/icon config in
    # user settings/themes.nix is conditionalized on stylix being disabled so
    # there is no conflict.
    stylix = mkIf cfg.stylix.enable {
      enable        = true;
      polarity      = cfg.stylix.polarity;
      autoEnable    = cfg.stylix.autoEnable;

      image         = mkIf (cfg.stylix.image != null) cfg.stylix.image;
      base16Scheme  = mkIf (cfg.stylix.scheme != null) cfg.stylix.scheme;

      cursor = {
        package = cfg.stylix.cursor.package;
        name    = cfg.stylix.cursor.name;
        size    = cfg.stylix.cursor.size;
      };

      fonts = {
        sansSerif  = { inherit (cfg.stylix.fonts.sansSerif)  package name; };
        serif      = { inherit (cfg.stylix.fonts.serif)      package name; };
        monospace  = { inherit (cfg.stylix.fonts.monospace)  package name; };
        sizes = {
          applications = cfg.stylix.fonts.sizes.applications;
          desktop      = cfg.stylix.fonts.sizes.desktop;
          terminal     = cfg.stylix.fonts.sizes.terminal;
        };
      };

      # gtk target is handled by stylix itself; disable the icons target since
      # we manage that manually with Papirus until a preferred icon set is added
      targets.gtk.enable = mkDefault true;
    };

    # Only enable gtk module directly when stylix is NOT managing it
    gtk = mkIf (!cfg.stylix.enable) {
      enable = mkDefault true;
    };
  };
}
