{config, lib, pkgs, ...}:

let
  cfg = config.host.home.service.decrypt_cryfs_workspace;
  name = "decrypt_cryfs_workspace";
in
with lib;
{
 options.host.home.service.decrypt_cryfs_workspace = {
   enable = mkOption {
     default = false;
     type = with types; bool;
     description = "Decrypt cryfs Workspace";
   };
 };

 config =
   let
     mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
       #set -uo pipefail
       if [ -d $HOME/Nextcloud/TOI/.cryfs ] ; then
         if ${pkgs.gnugrep}/bin/grep -qs "$HOME/Documents/Workspace" /proc/mounts; then
           echo "WARN Skipping cryfs 'workspace' as it's already mounted"
         else
           if [ -f "$XDG_RUNTIME_DIR/secrets/cryfs/workspace" ] ; then
             echo "INFO Mounting cryfs 'workspace'"
             ${pkgs.coreutils}/bin/mkdir -p $HOME/Documents/Workspace
             ${pkgs.coreutils}/bin/cat "$XDG_RUNTIME_DIR/secrets/cryfs/workspace" | ${pkgs.cryfs}/bin/cryfs --create-missing-basedir --create-missing-mountpoint "$HOME/Nextcloud/TOI/.cryfs/Documents" "$HOME/Documents/Workspace" -f
           else
             echo "ERROR Can't mount cryfs 'workspace' as 'cryfs_workspace' secret doesn't exist"
           fi
         fi
       fi
     '';
   in
   mkIf cfg.enable {
     systemd.user.services.decrypt_cryfs_workspace = {
       Unit = {
         Description = "Decrypt cryfs 'workspace' upon login";
         After = [ "sops-nix.service" ];
       };
       Install = {
         WantedBy = [ "default.target" ];
       };
       Service = {
         ExecStart = "${mkStartScript name}";
         Restart = "on-failure";
       };
     };

     sops.secrets = {
       "cryfs/workspace" = {
         sopsFile =  ../../home/toi/user/dave/secrets/cryfs/cryfs_dave_workspace.yaml ;
         path = "%r/secrets/cryfs/workspace";
       };
     };
  };
}
