{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.file-compression;
in
  with lib;
{
  options = {
    host.home.applications.file-compression = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Tools to work with file archives";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          p7zip
          pbzip2
          pigz
          pixz
          unrar
          unzip
          zip
          zstd
        ];
    };

    programs = {
      bash = {
        initExtra = ''
# Get checksum hash of files
get_file_hash() {
    if [ -n "$2" ] ; then
        case "$1" in
            md5)
                md5sum "$2" > "$2".md5
            ;;
            sha1)
                sha1sum "$2" > "$2".sha1
            ;;
            sha256)
                sha256sum "$2" > "$2".sha256
            ;;
            sha384)
                sha384sum "$2" > "$2".sha384
            ;;
            sha512)
                sha512sum "$2" > "$2".sha512
            ;;
            * )
                :
            ;;
        esac
    fi
}

alias hash_md5="get_file_hash md5 "$1""
alias hash_sha1="get_file_hash sha1 "$1""
alias hash_sha256="get_file_hash sha256 "$1""
alias hash_sha384="get_file_hash sha384 "$1""
alias hash_sha512="get_file_hash sha512 "$1""

# Compress a series of files
compress () {
  if [ -f $1 ] ; then
      arg1=$1
      shift
      arg2=$@
      case $arg1 in
          *.bz2)       pbzip2 $arg1 ;;
          *.gz)        pigz $arg1 ;;
          *.tar)       tar cvf $arg1 ;;
          *.tar.bz2)   tar -I pbzip2 cvf $arg1 $arg2 ;;
          *.tar.gz)    tar -I pigz cvf $arg1 $arg2 ;;
          *.tar.xz)    tar -I pixz cvf $arg1 $arg2 ;;
          *.tar.zst)   tar cvfa $arg1 $arg2 ;;
          *.tbz2)      tar -I pbzip2 cvf $arg1 $arg2 ;;
          *.tgz)       tar -I pigz xvf $arg1 $arg2 ;;
          *.zip)       zip $arg1 arg2 ;;
          *.Z)         compress $arg1  ;;
          *.7z)        7z a $arg1 $arg2       ;;
          *.zst*)      zstd $arg1 ;;
          *)           echo "don't know how to compress '$1'..." ;;
      esac
  else
    echo "Usage: 'compress <archive_name> <files/path>"
  fi
}

# Extraction of compressed files
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.bz2)       pbunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        pigz -d $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tar.bz2)   tar -I pbunzip2 xvf $1    ;;
          *.tar.gz)    tar -I pigz xvf $1    ;;
          *.tar.xz)    tar -I pixz $1    ;;
          *.tar.zst)   tar xvfa $1    ;;
          *.tbz2)      tar -I pbunip2 xvf $1    ;;
          *.tgz)       tar -I pigz xvf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.zst*)      zstd -d $1     ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "extract - '$1' is not a valid file!"
  fi
}
        '';
      };
    };
  };
}
