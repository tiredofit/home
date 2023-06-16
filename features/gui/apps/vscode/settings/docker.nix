{ config, ... }: {
  imports = [
    ./editor.nix
    ./git.nix
    ./minimap.nix
    ./terminal.nix
  ];
  programs = {
    vscode = {
      userSettings = {
       "docker.commands.attach" = "$${containerCommand} exec -it $${containerId} $${shellCommand}" ;
       "docker.containers.description" = ["ContainerName" "Status" ] ;
       "docker.containers.label" = "ContainerName" ;
       "docker.containers.sortBy" = "Label" ;
       "docker.volumes.label" = "VolumeName" ;
      };
    };
  };
}