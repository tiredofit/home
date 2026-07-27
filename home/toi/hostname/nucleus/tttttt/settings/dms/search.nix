{ config, lib, ... }:
with lib; {
  config.host.home.feature.gui.shell.dms.search.config = {
    worker_count = mkDefault 8;
    index_paths = [
      {
        path = "/mnt/data";
        max_depth = 10;
        exclude_dirs = [ ".trash" ];
      }
      {
        path = "~/src";
        max_depth = 6;
        exclude_dirs = [ "node_modules" ".git" "target" "dist" ];
      }
    ];
  };
}
