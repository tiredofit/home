{ config, lib, ... }:
with lib; {
  config.host.home.feature.gui.dms.search.config = {
    worker_count = mkDefault 8;
    index_paths = [
      {
        path = "~/Documents";
        max_depth = 6;
        exclude_dirs = [ "node_modules" "venv" "target" ];
      }
      {
        path = "~/src";
        max_depth = 10;
        exclude_dirs = [ "node_modules" ".git" "target" "dist" ];
      }
      {
        path = "/mnt/data";
        max_depth = 4;
        exclude_dirs = [ ];
      }
    ];
  };
}
