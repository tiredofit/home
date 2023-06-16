{ config, pkgs, ...}:
{
  home = {
    file = { ".config/nano".source = ../../dotfiles/nano; };

    packages = with pkgs;
      [
        nano
      ];
  };

  programs = {
    bash.shellAliases = {

    };
  };
}
