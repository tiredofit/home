{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.volatile-migrate;

  volatileMigrateBin = pkgs.writeShellScriptBin "volatile-migrate" ''
set -euo pipefail

NO_BACKUP=false
DELETE_BACKUP=false
DRY_RUN=false
FORCE=false

LOG_DIR=''${XDG_DATA_HOME:-$HOME/.local/share}/volatile-migrate
LOG_FILE=$LOG_DIR/volatile-migrate.log

log_op() {
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  mkdir -p "$LOG_DIR"
  echo "[$ts] $*" >> "$LOG_FILE"
}

maybe_sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

find_volatile_mount() {
  local path="$1"
  local parent
  parent="$(dirname "$path")"
  while [ "$parent" != "/" ]; do
    if mountpoint -q "$parent/.volatile" 2>/dev/null; then
      echo "$parent/.volatile"
      return 0
    fi
    parent="$(dirname "$parent")"
  done
  return 1
}

discover_migrations() {
  while IFS=' ' read -r device mountpoint fstype rest; do
    case "$mountpoint" in
      */.volatile)
        local parent="''${mountpoint%/.volatile}"

        find "$mountpoint" -maxdepth 4 -mindepth 1 2>/dev/null | while read -r vol_path; do
          local rel="''${vol_path#$mountpoint/}"

          case "$rel" in .volatile/*|.volatile) continue ;; esac

          local orig="$parent/$rel"

          if [ -L "$orig" ] 2>/dev/null; then
            local link_target
            link_target="$(readlink "$orig")"
            if [ "$link_target" = "$vol_path" ]; then
              local backup="''${orig}.volatile-backup"
              local has_backup="no"
              [ -e "$backup" ] && has_backup="yes"
              printf "%s\t%s\t%s\n" "$orig" "$vol_path" "$has_backup"
            fi
          fi
        done
        ;;
    esac
  done < /proc/mounts
}

user_filter() {
  [ "$(id -u)" = "0" ] && { cat; return 0; }
  local home
  home="$(eval echo ~$(whoami) 2>/dev/null)"
  [ -z "$home" ] && { cat; return 0; }
  while IFS=$'\t' read -r orig vol has_backup; do
    case "$orig" in
      "$home"/*|"$home") printf "%s\t%s\t%s\n" "$orig" "$vol" "$has_backup" ;;
    esac
  done
}

cmd_help() {
  cat <<'EOHELP'
Usage: volatile-migrate <command> [options] [paths...]

Commands:
  migrate [--no-backup] <path> [...]   Migrate directories to volatile storage
  revert <path> [...]                  Revert specific migrated paths
  list                                 Discover and show all migrated paths
  restore [--delete-backup] [--force]  Revert all discovered migrations
  clean-backups [--dry-run] [--force]  List and remove backup cruft

Options:
  --no-backup            Skip creating .volatile-backup when migrating
  --delete-backup        Remove .volatile-backup after successful revert
  --dry-run              Show what would be done without doing it
  --force                Skip confirmation prompts
  -h, --help             Show this help

Examples:
  volatile-migrate migrate /home/dave/.npm
  volatile-migrate migrate --no-backup /home/dave/.cache
  volatile-migrate list
  volatile-migrate restore --delete-backup
  volatile-migrate clean-backups --dry-run
EOHELP
}

migrate_one() {
  local src="$1"

  [ -e "$src" ] || { echo "not found: $src"; return 1; }
  [ -L "$src" ] && { echo "already a symlink: $src"; return 1; }
  src="$(readlink -f "$src")"

  local volatile
  volatile="$(find_volatile_mount "$src")" || {
    echo "no .volatile mountpoint in parent chain of $src"; return 1;
  }

  local parent
  parent="$(dirname "$src")"
  local vol_mount_parent
  vol_mount_parent="$(dirname "$volatile")"
  local rel="''${src#$vol_mount_parent/}"
  local target="$volatile/$rel"

  maybe_sudo mkdir -p "$(dirname "$target")"
  maybe_sudo cp -a --reflink=auto "$src" "$target"
  maybe_sudo chown --reference="$src" "$target" 2>/dev/null || true
  maybe_sudo chmod --reference="$src" "$target" 2>/dev/null || true

  if [ "$NO_BACKUP" != "true" ]; then
    local backup="''${src}.volatile-backup"
    maybe_sudo mv "$src" "$backup"
    echo "backup at $backup"
  else
    maybe_sudo rm -rf "$src"
  fi

  maybe_sudo ln -s "$target" "$src"
  log_op "migrate  $src → $target  (backup: $([ "$NO_BACKUP" = "true" ] && echo "no" || echo "yes"))"
  echo "migrated $src → $target"
}

revert_one() {
  local src="$1"

  [ -L "$src" ] || { echo "not a symlink: $src"; return 1; }

  local target
  target="$(readlink "$src")"
  case "$target" in
    */.volatile/*) ;;
    *) echo "not a volatile-migrated path: $src → $target"; return 1 ;;
  esac
  [ -e "$target" ] || { echo "volatile target missing: $target"; return 1; }

  echo "reverting $src → $target"
  maybe_sudo rm "$src"
  maybe_sudo cp -a --reflink=auto "$target" "$src"
  maybe_sudo chown --reference="$target" "$src" 2>/dev/null || true
  maybe_sudo chmod --reference="$target" "$src" 2>/dev/null || true

  log_op "revert   $src ← $target"
  local backup="''${src}.volatile-backup"
  if [ -e "$backup" ]; then
    echo "backup at $backup (use 'volatile-migrate clean-backups' to remove)"
  fi
  echo "reverted $src"
}

cmd_list() {
  local entries
  entries=$(discover_migrations | user_filter) || true

  if [ -z "$entries" ]; then
    echo "No migrated paths found."
    return 0
  fi

  local count=0
  while IFS=$'\t' read -r orig vol has_backup; do
    [ -z "$orig" ] && continue
    local badge=""
    [ "$has_backup" = "yes" ] && badge=" [backup]"
    printf "%-50s → %s%s\n" "$orig" "$vol" "$badge"
    count=$((count + 1))
  done <<< "$entries"

  if [ "$count" -eq 0 ]; then
    echo "No migrated paths found."
  fi
}

cmd_restore() {
  local tmp
  tmp="$(mktemp)"
  trap "rm -f '$tmp'" EXIT

  discover_migrations | user_filter > "$tmp" || true

  if [ ! -s "$tmp" ]; then
    echo "No migrated paths found."
    return 0
  fi

  echo "Paths to revert:"
  while IFS=$'\t' read -r orig vol _; do
    printf "  %s → %s\n" "$orig" "$vol"
  done < "$tmp"

  if [ "$FORCE" != "true" ]; then
    echo ""
    read -r -p "Revert all listed paths? [y/N] " reply
    case "$reply" in
      y|Y|yes|YES) ;;
      *) echo "Aborted."; return 1 ;;
    esac
  fi

  while IFS=$'\t' read -r orig _ _; do
    log_op "restore  $orig (batch revert)"
    revert_one "$orig"
    if [ "$DELETE_BACKUP" = "true" ]; then
      local backup="''${orig}.volatile-backup"
      if [ -e "$backup" ]; then
        echo "removing backup: $backup"
        maybe_sudo rm -rf "$backup"
      fi
    fi
  done < "$tmp"
}

cmd_clean_backups() {
  local tmp
  tmp="$(mktemp)"
  trap "rm -f '$tmp'" EXIT

  discover_migrations | user_filter | while IFS=$'\t' read -r orig _ has_backup; do
    [ "$has_backup" = "yes" ] || continue
    echo "''${orig}.volatile-backup"
  done > "$tmp" || true

  if [ ! -s "$tmp" ]; then
    echo "No backups found."
    return 0
  fi

  echo "Found backups:"
  while IFS= read -r path; do
    local size
    size=$(du -sh "$path" 2>/dev/null | cut -f1)
    printf "  %-70s %s\n" "$path" "$size"
  done < "$tmp"

  if [ "$DRY_RUN" = "true" ]; then
    echo "(dry run, nothing deleted)"
    return 0
  fi

  if [ "$FORCE" != "true" ]; then
    echo ""
    read -r -p "Delete all listed backups? [y/N] " reply
    case "$reply" in
      y|Y|yes|YES) ;;
      *) echo "Aborted."; return 1 ;;
    esac
  fi

  while IFS= read -r path; do
    echo "removing $path"
    log_op "clean    $path"
    maybe_sudo rm -rf "$path"
  done < "$tmp"
}

# ---- dispatch ----

args=()
for arg in "$@"; do
  case "$arg" in
    -h|--help) cmd_help; exit 0 ;;
    *) args+=("$arg") ;;
  esac
done
set -- "''${args[@]}"

cmd="''${1:-}"

case "$cmd" in
  help)
    cmd_help ;;
  list)
    cmd_list ;;
  migrate)
    shift
    NO_BACKUP=false
    paths=()
    for arg in "$@"; do
      case "$arg" in
        --no-backup) NO_BACKUP=true ;;
        *) paths+=("$arg") ;;
      esac
    done
    [ "''${#paths[@]}" -eq 0 ] && { cmd_help; exit 1; }
    for p in "''${paths[@]}"; do migrate_one "$p"; done
    ;;
  revert)
    shift
    [ $# -eq 0 ] && { cmd_help; exit 1; }
    for p in "$@"; do revert_one "$p"; done
    ;;
  restore)
    shift
    DELETE_BACKUP=false
    FORCE=false
    for arg in "$@"; do
      case "$arg" in
        --delete-backup) DELETE_BACKUP=true ;;
        --force) FORCE=true ;;
        *) echo "unknown option: $arg"; exit 1 ;;
      esac
    done
    cmd_restore
    ;;
  clean-backups)
    shift
    DRY_RUN=false
    FORCE=false
    for arg in "$@"; do
      case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --force) FORCE=true ;;
        *) echo "unknown option: $arg"; exit 1 ;;
      esac
    done
    cmd_clean_backups
    ;;
  *)
    if [ -z "$cmd" ]; then
      cmd_help
      exit 1
    fi
    NO_BACKUP=false
    paths=()
    for arg in "$@"; do
      case "$arg" in
        --no-backup) NO_BACKUP=true ;;
        *) paths+=("$arg") ;;
      esac
    done
    [ "''${#paths[@]}" -eq 0 ] && { cmd_help; exit 1; }
    for p in "''${paths[@]}"; do migrate_one "$p"; done
    ;;
esac
  '';
in
  with lib;
{
  options = {
    host.home.applications.volatile-migrate = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "volatile-migrate CLI for managing btrfs volatile subvolume migrations";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ volatileMigrateBin ];
  };
}
