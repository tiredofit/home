{lib, ...}:

with lib;
{
  imports = [
    ./decrypt_cryfs_workspace.nix
    ./decrypt_encfs_workspace.nix
    ./vscode-server.nix
  ];
}
