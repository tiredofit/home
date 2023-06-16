{ config, ...}:
{
  programs = {
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    bash = {
      sessionVariables = {
        GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      };
    };
  };
}
