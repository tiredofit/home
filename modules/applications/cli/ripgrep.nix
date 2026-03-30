{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ripgrep;
in
  with lib;
{
  options = {
    host.home.applications.ripgrep = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File searcher";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellFunctions = ''
      frg() {
        # Open-file search + fzf preview
        # syntax: frg <search terms>
        result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
          ${pkgs.fzf}/bin/fzf --ansi \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --delimiter ':' \
            --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
        file=$(echo "$result" | cut -d: -f1)
        linenumber=$(echo "$result" | cut -d: -f2)
        if [ -n "$file" ]; then
          $EDITOR +"$linenumber" "$file"
        fi
      }

      sir() {
        # search and replace inside files using rg+sed
        # syntax: sir <find> <replace>
        if [ -z "$1" ] || [ -z "$2" ]; then
          echo "Search inside Replace: sir <find_string> <replace_with>"
          return 1
        fi
        for file in $(rg -l "$1"); do
          sed -i "s|$1|$2|g" "$file"
        done
      };
    '';
  in {
    programs = {
      ripgrep = {
        enable = true;
     };

      bash = mkIf config.host.home.applications.bash.enable {
        initExtra = shellFunctions;
      };

      zsh = mkIf config.host.home.applications.zsh.enable {
        initContent = shellFunctions;
      };
    };
  });
}
