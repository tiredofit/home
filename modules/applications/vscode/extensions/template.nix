{ config, inputs, lib, pkgs, ... }: {
{
  programs = {
    vscode = {
      extensions = (with pkgs.vscode-extensions; [
        #extension
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "1.4.1";
          sha256 = "sha256-31OGOtjcrBQgbGIDojtnsAnLLa/EsQprBMTTtngzejI=";
        }
      ];
    };
  };
}