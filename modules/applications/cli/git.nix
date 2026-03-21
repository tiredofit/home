{config, lib, pkgs, ...}:
## PERSONALIZE
let
  cfg = config.host.home.applications.git;
in
  with lib;
{
  options = {
    host.home.applications.git = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Revision Control Tool";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellInit = ''
      ghpush() {
          ghpush_show_last_version() {
              if [ -f "CHANGELOG.md" ] ; then
                  if [ $(cat CHANGELOG.md | wc -c) != "0" ]; then
                      sed -n -e "/##/{:1;p;n;/##/{p;q};b1};p" CHANGELOG.md | head --lines=-2
                  fi
              fi
          }

          local _IMAGE_TAG
          _IMAGE_TAG=$(head -n 1 CHANGELOG.md | awk '{print $2'})
          local _git_branch
          _git_branch=$(git rev-parse --abbrev-ref HEAD)
          case $_git_branch in
              "master" | "main" | "develop" )
                  :
              ;;
              * )
                  local _branch
                  _branch="''${_git_branch}-"
              ;;
          esac

          git push
          git tag $_branch$_IMAGE_TAG
          git push origin $_branch$_IMAGE_TAG
      }
    '';

    shellAliases = {
      ga = "git add .";
      gp = "git push";
      gc = "git commit -m \"$@\"";
      gac = "git add . ; git commit -m \"$@\"";
      gacp = "git add . ; git commit -m \"$@\" ; git push";
    };
  in {
    programs = {
      git = {
        enable = true;
        ignores = [ "*~" ".direnv" ".env" ".rgignore" ];
        settings = {
          alias = {
            ci = "commit";
            co = "checkout";
            di = "diff";
            dc = "diff --cached";
            addp = "add -p";
            shoe = "show";
            st = "status";
            unch = "checkout --";
            br = "checkout";
            bra = "branch -a";
            newbr = "checkout -b";
            rmbr = "branch -d";
            mvbr = "branch -m";
            cleanbr = "!git remote prune origin && git co master && git branch --merged | grep -v '*' | xargs -n 1 git branch -d && git co -";
            as = "update-index --assume-unchanged";
            nas = "update-index --no-assume-unchanged";
            al = "!git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /'";
            pub = "push -u origin HEAD";
          };
          init = { defaultBranch = "main"; };
          pull = { ff = "only"; };
        };
      };

      bash = {
        initExtra = shellInit;
        shellAliases = shellAliases;
      };

      zsh = {
        initContent = shellInit;
        shellAliases = shellAliases;
      };
    };
  });
}
