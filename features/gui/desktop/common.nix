{ pkgs, config, lib, ...}:
{
  imports = [
    ../mime-default-apps.nix
  ];

  home = {
    packages = with pkgs;
      [
        gnome.zenity
        lxappearance
        pavucontrol      # Pulse Audio Volume Control
        polkit
        polkit_gnome
        xdg-utils
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
  };

  programs = {
    bash = {
      sessionVariables = {
        GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Zukitwo";
      package = pkgs.zuki-themes;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Quintom_Snow";
    package = pkgs.quintom-cursor-theme;
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
