{ config, inputs, ... }: {
  imports = [
    ./tools.nix
    #./themes
  ];

  # https://github.com/nix-community/home-manager/issues/2798
  programs = {
    vscode = {
      mutableExtensionsDir = false;
    };
  };
}