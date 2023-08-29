{ pkgs, config, lib, ...}:
{
  imports = [
  ];

  home = {
    packages = with pkgs;
      [
        gnome.zenity
        pavucontrol      # Pulse Audio Volume Control
        polkit
        polkit_gnome
        xdg-utils
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
      ]);
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
