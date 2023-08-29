{config, lib, pkgs, ...}:

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

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "Dave Conroy";
        ignores = [ "*~" ".direnv" ".env" ".rgignore" ];
        extraConfig = {
          init = { defaultBranch = "main"; };
          pull = { ff = "only"; };
        };
        aliases = {
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
          cleanbr =
            "!git remote prune origin && git co master && git branch --merged | grep -v '*' | xargs -n 1 git branch -d && git co -";
          as = "update-index --assume-unchanged";
          nas = "update-index --no-assume-unchanged";
          al =
            "!git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /'";
          pub = "push -u origin HEAD";
        };
      };

      bash = {
        initExtra = ''
          ghpush() {
              ghpush_show_last_version() {
                  if [ -f "CHANGELOG.md" ] ; then
                      if [ $(cat CHANGELOG.md | wc -c) != "0" ]; then
                          sed -n -e "/##/{:1;p;n;/##/{p;q};b1};p" CHANGELOG.md | head --lines=-2
                      fi
                  fi
              }

              #commit_changelog=$(mktemp)
              #sed -n -e "/##/{:1;p;n;/##/{p;q};b1};p" CHANGELOG.md | head --lines=-2 >$commit_changelog
              #cat $commit_changelog
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
          ga = "git add . " ;                                 # Git Add
          gp = "git push" ;                                   # Git Push
          gc = "git commit -m \"$@\"" ;                         # Git Commit
          gac = "git add . ; git commit -m \"$@\"" ;             # Git Add and Commit
          gacp = "git add . ; git commit -m \"$@\" ; git push" ;   # Git Add Commit and Push
        };
      };
    };
  };
}
