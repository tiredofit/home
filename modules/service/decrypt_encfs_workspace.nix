{config, lib, pkgs, ...}:

let
  cfg = config.host.home.service.decrypt_encfs_workspace;
  name = "decrypt_encfs_workspace";
in
with lib;
{
 options.host.home.service.decrypt_encfs_workspace = {
   enable = mkOption {
     default = false;
     type = with types; bool;
     description = "Decrypt Encfs Workspace";
   };
 };

 config =
   let
     mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
       #set -uo pipefail
       if [ -d $HOME/Nextcloud/TOI/.encfs ] ; then
         if ${pkgs.gnugrep}/bin/grep -qs "$HOME/Documents/Workspace" /proc/mounts; then
           echo "WARN Skipping encfs 'workspace' as it's already mounted"
         else
           if [ -f "$XDG_RUNTIME_DIR/secrets/encfs/workspace" ] ; then
             echo "INFO Mounting encfs 'workspace'"
             ${pkgs.coreutils}/bin/mkdir -p $HOME/Documents/Workspace
             ${pkgs.coreutils}/bin/cat "$XDG_RUNTIME_DIR/secrets/encfs/workspace" | /run/wrappers/bin/sudo ${pkgs.encfs}/bin/encfs --public -S -f "$HOME/Nextcloud/TOI/.encfs" "$HOME/Documents/Workspace"
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
         After = [ "sops-nix.service" ];
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
         path = "%r/secrets/encfs/workspace";
       };
     };
  };
}
