{ config, inputs, pkgs, ...}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    packages = with pkgs;
      [
        age
        gnupg
        pinentry.out
        ssh-to-age
        ssh-to-pgp
        sops
      ];
  };

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  systemd.user.services.sops-nix.Unit.After = [ "sops-nix.service" ];
}
