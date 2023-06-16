{config, pkgs, lib, ...}:

let
  cfg = config.services.decrypt_encfs_workspace;
  name = "decrypt_encfs_workspace";
in
with lib;
{
 options.services.decrypt_encfs_workspace = {
   enable = mkOption {
     default = true;
     type = with types; bool;
     description = "Decrypt Encfs Workspace";
   };
 };

 config =
   let
     mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
       #set -uo pipefail
       if [ -d $HOME/Nextcloud/TOI/.encfs ] ; then
         if grep -qs "$HOME/Documents/Workspace" /proc/mounts; then
           echo "ERROR Skipping encfs 'workspace' as it's already mounted"
         else
           if [ -f "$XDG_STATE_HOME/secrets/encfs/workspace" ] ; then
             echo "INFO Mounting encfs 'workspace'"
             mkdir -p $HOME/Documents/Workspace
             cat "$XDG_RUNTIME_DIR/secrets/encfs/workspace" | sudo encfs --public -S "$HOME/Nextcloud/TOI/.encfs" "$HOME/Documents/Workspace"
           else
             echo "ERROR Can't mount encfs 'workspace' as 'encfs_workspace' secret doesn't exist"
           fi
         fi
       fi
     '';
   in
   mkIf cfg.enable {
     systemd.user.services.decrypt_encfs_workspace = {
       Unit = {
         Description = "Decrypt encfs 'workspace' upon login";
       };
       Install = {
         WantedBy = [ "default.target" ];
       };
       Service = {
         ExecStart = "${mkStartScript name}";
       };
     };

     sops.secrets = {
       "encfs/workspace" = {
         sopsFile =  ../../home/toi/secrets/encfs_workspace.yaml ;
       };
     };
  };
}
