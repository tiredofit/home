{ config, inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  colorscheme = inputs.nix-colors.colorSchemes.dracula;
}
