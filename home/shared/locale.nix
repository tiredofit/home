{ config, lib, ... }:
with lib;
{
  home = {
    language = {
      base = mkDefault "en_US.UTF-8";
      address = mkDefault "en_US.UTF-8";
      collate = mkDefault "en_US.UTF-8";
      ctype = mkDefault "en_US.UTF-8";
      measurement = mkDefault "en_US.UTF-8";
      messages = mkDefault "en_US.UTF-8";
      monetary = mkDefault "en_US.UTF-8";
      name = mkDefault "en_US.UTF-8";
      numeric = mkDefault "en_US.UTF-8";
      paper = mkDefault "en_US.UTF-8";
      time = mkDefault "en_US.UTF-8";
    };
  };
}
