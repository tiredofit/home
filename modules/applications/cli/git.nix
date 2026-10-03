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
      maintenance = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Scheduled git maintenance (gc/repack) for repositories.";
        };
        repositories = mkOption {
          default = [ ];
          type = with types; listOf str;
          description = "Extra repos to maintain. Missing dirs are skipped at runtime.";
        };
        searchPaths = mkOption {
          default = [ ];
          type = with types; listOf str;
          description = "Top level folders to scan for git checkouts. Scanned at runtime and missing dirs skipped.";
        };
        searchSchedule = mkOption {
          default = "Sun 03:00";
          type = with types; either str (listOf str);
          description = "schedule for the search path scan timer. String or list eg Mon,Thu 03:00.";
        };
        searchDepth = mkOption {
          default = 4;
          type = with types; int;
          description = "What level of subdirectories to stop at when looking for .git dirs.";
        };
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
          _IMAGE_TAG=$(head -n 1 CHANGELOG.md | awk '{print $2}')
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
        maintenance = mkIf cfg.maintenance.enable {
          enable = true;
          repositories = cfg.maintenance.repositories;
        };
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
        signing.format = null;
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

    systemd.user.services.git-maintenance-walk =
      mkIf (cfg.maintenance.enable && cfg.maintenance.searchPaths != [ ]) {
        Unit.Description = "git maintenance over search path checkouts";
        Service = {
          Type = "oneshot";
          ExecStart = let
            walker = pkgs.writeShellScript "git-maintenance-walk" ''
              set -u
              bases=(${lib.concatMapStringsSep " " lib.escapeShellArg cfg.maintenance.searchPaths})
              for base in "''${bases[@]}"; do
                [ -d "$base" ] || continue
                ${pkgs.findutils}/bin/find "$base" -maxdepth ${toString cfg.maintenance.searchDepth} -type d -name .git -print0 \
                  | while IFS= read -r -d "" gitdir; do
                      repo="''${gitdir%/.git}"
                      [ -d "$repo" ] || continue
                      ${pkgs.git}/bin/git -C "$repo" maintenance run --schedule=daily || true
                    done
              done
            '';
          in "${walker}";
        };
      };

    systemd.user.timers.git-maintenance-walk =
      mkIf (cfg.maintenance.enable && cfg.maintenance.searchPaths != [ ]) {
        Unit.Description = "Scheduled git maintenance over search path checkouts";
        Timer = {
          OnCalendar = cfg.maintenance.searchSchedule;
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
  });
}
