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

  systemd.user.services.sops-nix.Unit.After = [ "sops-nix.service" ];

  sops.defaultSopsFile = ../../secrets/example.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.secrets.example_key = {};
  sops.secrets.flake = {
    format = "binary";
    sopsFile = ../../secrets/flake.yaml;
  };

  #sops.secrets.remotehosts = {
  #  format = "binary";
  #  sopsFile = ../../secrets/remotehosts;
  #};
}
