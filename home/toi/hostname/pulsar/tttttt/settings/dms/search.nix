{ config, lib, ... }:
with lib; {
  config.host.home.feature.gui.shell.dms.search.config = {
    worker_count = mkDefault 4;
    index_paths = [
      {
        path = "/var/data";
        max_depth = 8;
        exclude_dirs = [ ".trash" "temp" ];
      }
      {
        path = "~/src";
        max_depth = 6;
        exclude_dirs = [ "node_modules" ".git" "target" "dist" ];
      }
    ];
  };
}
