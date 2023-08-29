{lib, ...}:

with lib;
{
  imports = [
    ./decrypt_encfs_workspace.nix
    ./vscode-server.nix
  ];
}
