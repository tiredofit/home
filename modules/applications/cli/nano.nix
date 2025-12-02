{config, lib, pkgs, ...}:
# PERSONALIZE
let
  cfg = config.host.home.applications.nano;
in
  with lib;
{
  options = {
    host.home.applications.nano = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Text editor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        unstable.nano
      ];
    };

    xdg.configFile = {
      "nano/nanorc".text = ''
        set minibar
        set linenumbers
        set positionlog

        set mouse
        set indicator

        set tabsize 4
        set tabstospaces

        set softwrap
        set atblanks

        set autoindent
        set smarthome

        ## Default Settings
          syntax default
          comment "#"

          ### Spaces in front of tabs.
          color ,red " +	+"

          ### Nano's release motto, then name plus version.
          color italic,lime "\<[Nn]ano [1-6]\.[0-9][-.[:alnum:]]* "[^"]+""
          color brightred "\<(GNU )?[Nn]ano [1-6]\.[0-9][-.[:alnum:]]*\>"

          ### Dates
          color latte "\<[12][0-9]{3}\.(0[1-9]|1[012])\.(0[1-9]|[12][0-9]|3[01])\>"

          ### Email addresses.
          color magenta "<[[:alnum:].%_+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}>"

          ### URLs.
          color lightblue "\<https?://\S+\.\S+[^])>[:space:],.]"

          ### Bracketed captions in certain config files.
          color brightgreen "^\[[^][]+\]$"

          ### Comments.
          color cyan "^[[:blank:]]*#.*"

          ### Control codes.
          color orange "[[:cntrl:]]"

        ## Bash
          syntax "bash" "\.sh$" "\.bash$" "/.bash_profile$" "(\.|/)profile$" "\rc$" "(\.|/)control$" "etc/cont.init.d/" "etc/services.available/" "assets/functions" "assets/defaults"
          header "^#!.*/(ba|k|pdk)?sh[-0-9_]*"

          ### Control
          color magenta "\<(if|else|for|function|case|esac|in|select|until|while|do|elif|then|set|\.|done|fi)\>"

          ### Brackets and redirects
          color yellow "[(){}[;|<>]"
          color yellow "\]"

          ### Builtins
          color red "\<(source|alias|bg|bind|break|builtin|cd|command|compgen|complete|continue|dirs|disown|echo|enable|eval|exec|exit|fc|fg|getopts|hash|help|history|jobs|kill|let|logout|popd|printf|pushd|pwd|return|set|shift|shopt|suspend|test|times|trap|type|ulimit|umask|unalias|wait)\>"

          ### Unix Commands
          color red "\<(arch|awk|bash|bunzip2|bzcat|bzcmp|bzdiff|bzegrep|bzfgrep|bzgrep|bzip2|bzip2recover|bzless|bzmore|cat|chattr|chgrp|chmod|chown|chvt|cp|date|dd|deallocvt|df|dir|dircolors|dmesg|dnsdomainname|domainname|du|dumpkeys|echo|ed|egrep|false|fgconsole|fgrep|fuser|gawk|getkeycodes|gocr|grep|groups|gunzip|gzexe|gzip|hostname|igawk|install|kbd_mode|kbdrate|killall|last|lastb|link|ln|loadkeys|loadunimap|login|ls|lsattr|lsmod|lsmod.old|mapscrn|mesg|mkdir|mkfifo|mknod|mktemp|more|mount|mv|nano|netstat|nisdomainname|openvt|pgawk|pidof|ping|ps|pstree|pwd|rbash|readlink|red|resizecons|rm|rmdir|run-parts|sash|sed|setfont|setkeycodes|setleds|setmetamode|setserial|sh|showkey|shred|sleep|ssed|stat|stty|su|sync|tar|tempfile|touch|true|umount|uname|unicode_start|unicode_stop|unlink|utmpdump|uuidgen|vdir|wall|wc|ypdomainname|zcat|zcmp|zdiff|zegrep|zfgrep|zforce|zgrep|zless|zmore|znew|zsh)\>"

          ### More Unix Commands
          color red "\<(aclocal|aconnect|aplay|apm|apmsleep|apropos|ar|arecord|as|as86|autoconf|autoheader|automake|awk|basename|bc|bison|c\+\+|cal|cat|cc|cdda2wav|cdparanoia|cdrdao|cd-read|cdrecord|chfn|chgrp|chmod|chown|chroot|chsh|clear|cmp|co|col|comm|cp|cpio|cpp|cut|dc|dd|df|diff|diff3|dir|dircolors|directomatic|dirname|du|env|expr|fbset|file|find|flex|flex\+\+|fmt|free|ftp|funzip|fuser|g\+\+|gawk|gc|gcc|gdb|getent|getopt|gettext|gettextize|gimp|gimp-remote|gimptool|gmake|gs|head|hexdump|id|install|join|kill|killall|ld|ld86|ldd|less|lex|ln|locate|lockfile|logname|lp|lpr|ls|lynx|m4|make|man|mkdir|mknod|msgfmt|mv|namei|nasm|nawk|nc|nice|nl|nm|nm86|nmap|nohup|nop|od|passwd|patch|pcregrep|pcretest|perl|perror|pidof|pr|printf|procmail|prune|ps2ascii|ps2epsi|ps2frag|ps2pdf|ps2ps|psbook|psmerge|psnup|psresize|psselect|pstops|rcs|rev|rm|scp|sed|seq|setterm|shred|size|size86|skill|slogin|snice|sort|sox|split|ssh|ssh-add|ssh-agent|ssh-keygen|ssh-keyscan|stat|strings|strip|sudo|suidperl|sum|tac|tail|tee|test|tr|uniq|unlink|unzip|updatedb|updmap|uptime|users|vmstat|w|wc|wget|whatis|whereis|which|who|whoami|write|xargs|yacc|yes|zip|zsoelim)\>"

          ### Strings
          color blue "\"(\\.|[^\"])*\""
          color blue "'(\\.|[^\'])*'"

          ### Variables
          # NOTE: Keep this section below the Strings section, such that Variables are highlighted inside strings.
          color cyan start="[$@%]" end="([[:alnum:]]|_)*"

          ### Comments
          color green "#.*$"

        ## Conf files
          syntax "Conf" "\.c[o]?nf$"
          ### Possible errors and parameters
          ### Strings
          icolor white ""(\\.|[^"])*""
          ### Comments
          icolor brightblue "^[[:space:]]*#.*$"
          icolor cyan "^[[:space:]]*##.*$"
          ### Trailing spaces
          color ,green "[[:space:]]+$"

        ## CSS
          syntax "CSS" "\.(css|scss|less)$"
          color brightred     "."
          color brightyellow  start="\{" end="\}"
          color brightwhite   start=":" end="[;^\{]"
          color brightblue    ":active|:focus|:hover|:link|:visited|:link|:after|:before|$"
          color brightblue    start="\/\*" end="\*\/"
          color green         ";|:|\{|\}"
          ### Trailing spaces
          color ,green "[[:space:]]+$"

        ## CSV
          syntax "CSV" "\.csv$"
          color brightmagenta "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color brightcyan "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color brightblue "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color brightyellow "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color brightgreen "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color brightred "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?([^,]*,?))?"
          color cyan "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?"
          color magenta "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?"
          color blue "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,)?([^,]*,)?([^,]*,)?([^,]*,)?"
          color yellow "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,)?([^,]*,)?([^,]*,)?"
          color green "^("([^"]*"")*[^"]*",?)("([^"]*"")*[^"]*",?)|^([^,]*,)?([^,]*,)?"
          color red "^("([^"]*"")*[^"]*",?)|^([^,]*,?))?

        ## Dockerfile | Containerfile
          syntax "Containerfile" "Dockerfile" "Dockerfile[^/]*$"

          ### Keywords
          icolor red "^(FROM|MAINTAINER|RUN|CMD|LABEL|EXPOSE|ARG|ENV|ADD|COPY|ENTRYPOINT|VOLUME|USER|WORKDIR|ONBUILD)[[:space:]]"

          ### Brackets & parenthesis
          color brightgreen "(\(|\)|\[|\])"

          ### Double ampersand
          color brightmagenta "&&"

          ### Comments
          icolor cyan "^[[:space:]]*#.*$"

          ### Blank space at EOL
          color ,green "[[:space:]]+$"

          ### Strings, single-quoted
          color brightwhite "'([^']|(\\'))*'" "%[qw]\{[^}]*\}" "%[qw]\([^)]*\)" "%[qw]<[^>]*>" "%[qw]\[[^]]*\]" "%[qw]\$[^$]*\$" "%[qw]\^[^^]*\^" "%[qw]![^!]*!"

          ### Strings, double-quoted
          color brightwhite ""([^"]|(\\"))*"" "%[QW]?\{[^}]*\}" "%[QW]?\([^)]*\)" "%[QW]?<[^>]*>" "%[QW]?\[[^]]*\]" "%[QW]?\$[^$]*\$" "%[QW]?\^[^^]*\^" "%[QW]?![^!]*!"

          ### Single and double quotes
          color brightyellow "('|\")"

        ## .dotenv
          syntax "dotenv" "\.env" "\.env\..+"
          color green "(\(|\)|\$|=)"
          color brightyellow ""(\\.|[^"])*"" "'(\\.|[^'])*'"
          color cyan "(^|[[:space:]])#.*$"
          color ,green "[[:space:]]+$"

        ## hosts
          syntax "/etc/hosts" "hosts"
          ### IPv4
          color yellow "^[0-9\.]+\s"

          ### IPv6
          icolor green "^[0-9a-f:]+\s"

          ### interpunction
          color normal "[.:]"

          ### comments
          color brightblack "^#.*"

        ## Git
          syntax "git-config" "git(config|modules)$|\.git/config$"

          color brightcyan "\<(true|false)\>"
          color cyan "^[[:space:]]*[^=]*="
          color brightmagenta "^[[:space:]]*\[.*\]$"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color brightblack "(^|[[:space:]])#([^{].*)?$"
          color ,green "[[:space:]]+$"
          color ,red "	+"

        ## GoLang
          syntax "GO" "\.go$"
          comment "//"

          color brightblue "[A-Za-z_][A-Za-z0-9_]*[[:space:]]*[()]"
          color brightblue "\<(append|cap|close|complex|copy|delete|imag|len)\>"
          color brightblue "\<(make|new|panic|print|println|protect|real|recover)\>"
          color green     "\<(u?int(8|16|32|64)?|float(32|64)|complex(64|128))\>"
          color green     "\<(uintptr|byte|rune|string|interface|bool|map|chan|error)\>"
          color cyan  "\<(package|import|const|var|type|struct|func|go|defer|nil|iota)\>"
          color cyan  "\<(for|range|if|else|case|default|switch|return)\>"
          color brightred     "\<(go|goto|break|continue)\>"
          color brightcyan "\<(true|false)\>"
          color red "[-+/*=<>!~%&|^]|:="
          color blue   "\<([0-9]+|0x[0-9a-fA-F]*)\>|'.'"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color magenta   "\\[abfnrtv'\"\\]"
          color magenta   "\\([0-7]{3}|x[A-Fa-f0-9]{2}|u[A-Fa-f0-9]{4}|U[A-Fa-f0-9]{8})"
          color yellow   "`[^`]*`"
          color brightblack "(^|[[:space:]])//.*"
          color brightblack start="^\s*/\*" end="\*/"
          color brightwhite,cyan "TODO:?"
          color ,green "[[:space:]]+$"
          color ,red "	+ +| +	+"

        ## html
          syntax "HTML" "\.html?(.j2)?(.twig)?$"
          magic "HTML document"
          comment "<!--|-->"

          ### Emphasis tags
          color brightwhite start="<([biu]|em|strong)[^>]*>" end="</([biu]|em|strong)>"

          ### Tags
          color cyan start="<" end=">"

          ### Attributes
          color brightblue "[[:space:]](abbr|accept(-charset)?|accesskey|action|[av]?link|alt|archive|axis|background|(bg)?color|border)="
          color brightblue "[[:space:]](cell(padding|spacing)|char(off|set)?|checked|cite|class(id)?|compact|code(base|tag)?|cols(pan)?)="
          color brightblue "[[:space:]](content(editable)?|contextmenu|coords|data|datetime|declare|defer|dir|enctype)="
          color brightblue "[[:space:]](for|frame(border)?|headers|height|hidden|href(lang)?|hspace|http-equiv|id|ismap)="
          color brightblue "[[:space:]](label|lang|longdesc|margin(height|width)|maxlength|media|method|multiple)="
          color brightblue "[[:space:]](name|nohref|noresize|noshade|object|on(click|focus|load|mouseover|keypress)|profile|readonly|rel|rev)="
          color brightblue "[[:space:]](rows(pan)?|rules|scheme|scope|scrolling|shape|size|span|src|standby|start|style|summary|pattern)="
          color brightblue "[[:space:]](tabindex|target|text|title|type|usemap|v?align|value(type)?|vspace|width|xmlns|xml:space)="
          color brightblue "[[:space:]](required|disabled|selected)[[:space:]=>]"

          ### Strings
          color yellow ""(\\.|[^"])*""

          ### Named character references and entities
          color red "&#?[[:alnum:]]*;"

          ### Template strings (not in the HTML spec, but very commonly used)
          color magenta "\{[^\}]*\}\}?"
          color brightgreen "[[:space:]]((end)?if|(end)?for|in|not|(end)?block)[[:space:]]"

          ### Comments
          color green start="<!--" end="-->"

          ### Trailing spaces
          color ,green "[[:space:]]+$"

          ### Reminders
          color brightwhite,yellow "(FIXME|TODO|XXX)"

        ## JavaScript
          syntax "JavaScript" "\.(js)$"
          header "^#!.*\/(env +)node"
          comment "//"

          ### Default
          color white "^.+$"

          ### Decimal, cotal and hexadecimal numbers
          color yellow "\<[-+]?([1-9][0-9]*|0[0-7]*|0x[0-9a-fA-F]+)([uU][lL]?|[lL][uU]?)?\>"

          ### Floating point number with at least one digit before decimal point
          color yellow "\<[-+]?([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([EePp][+-]?[0-9]+)?[fFlL]?"
          color yellow "\<[-+]?([0-9]+[EePp][+-]?[0-9]+)[fFlL]?"

          ### Keywords
          color green "\<(break|case|catch|continue|default|delete|do|else|finally)\>"
          color green "\<(for|function|if|in|instanceof|new|null|return|switch)\>"
          color green "\<(switch|this|throw|try|typeof|undefined|var|void|while|with)\>"
          color green "\<(import|as|from|export)\>"
          color green "\<(const|let|class|extends|of|get|set|await|async|yield)\>"

          ### Type specifiers
          color red "\<(Array|Boolean|Date|Enumerator|Error|Function|Math)\>"
          color red "\<(WeakMap|Map|WeakSet|Set|Symbol|Promise)\>"
          color red "\<(Number|Object|RegExp|String)\>"
          color red "\<(true|false)\>"

          ### String
          color brightyellow "L?\"(\\"|[^"])*\""
          color brightyellow "L?'(\'|[^'])*'"
          color brightcyan "L?`(\`|[^`])*`"
          color brightwhite,blue start="\$\{" end="\}"

          ### Trailing spaces
          color ,green "[[:space:]]+$"

          ### Escapes
          color red "\\[0-7][0-7]?[0-7]?|\\x[0-9a-fA-F]+|\\[bfnrt'"\?\\]"

          ### Comments
          color brightblue start="^\s*/\*" end="\*/"
          color brightblue "^\s*//.*$"

        ## json
          syntax "JSON" "\.json$"
          header "^\{$"
          ### You can't add a comment to JSON.
          comment ""

          color blue   "\<[-]?[1-9][0-9]*([Ee][+-]?[0-9]+)?\>"  "\<[-]?[0](\.[0-9]+)?\>"
          color cyan  "\<null\>"
          color brightcyan "\<(true|false)\>"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color brightyellow "\"(\\"|[^"])*\"[[:space:]]*:"  "'(\'|[^'])*'[[:space:]]*:"
          color magenta   "\\u[0-9a-fA-F]{4}|\\[bfnrt'"/\\]"
          color ,green "[[:space:]]+$"
          color ,red "	+ +| +	+"

        ## Makefile
          syntax "Makefile" "([Mm]akefile|\.ma?k)$"
          header "^#!.*/(env +)?[bg]?make( |$)"
          magic "makefile script"
          comment "#"

          color cyan  "\<(ifeq|ifdef|ifneq|ifndef|else|endif)\>"
          color cyan  "^(export|include|override)\>"
          color brightmagenta  "^[^:=	]+:"
          color brightmagenta  "^[^:+	]+\+"
          color red "[=,%]" "\+=|\?=|:=|&&|\|\|"
          color brightblue "\$\((abspath|addprefix|addsuffix|and|basename|call|dir)[[:space:]]"
          color brightblue "\$\((error|eval|filter|filter-out|findstring|firstword)[[:space:]]"
          color brightblue "\$\((flavor|foreach|if|info|join|lastword|notdir|or)[[:space:]]"
          color brightblue "\$\((origin|patsubst|realpath|shell|sort|strip|suffix)[[:space:]]"
          color brightblue "\$\((value|warning|wildcard|word|wordlist|words)[[:space:]]"
          color black    "[()$]"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color brightyellow "\$+(\{[^} ]+\}|\([^) ]+\))"
          color brightyellow "\$[@^<*?%|+]|\$\([@^<*?%+-][DF]\)"
          color magenta   "\$\$|\\.?"
          color brightblack "(^|[[:space:]])#([^{].*)?$"
          color brightblack  "^	@#.*"

          ### Show trailing whitespace
          color ,green "[[:space:]]+$"

        ## Markdown
          syntax "Markdown" "\.(md|mkd|mkdn|markdown)$"
          ### Tables (Github extension)
          color cyan ".*[ :]\|[ :].*"
          ### quotes
          color brightblack  start="^>" end="^$"
          color brightblack  "^>.*"
          ### Emphasis
          color green "(^|[[:space:]])(_[^ ][^_]*_|\*[^ ][^*]*\*)"
          ### Strong emphasis
          color brightgreen "(^|[[:space:]])(__[^ ][^_]*__|\*\*[^ ][^*]*\*\*)"
          ### strike-through
          color red "(^|[[:space:]])~~[^ ][^~]*~~"
          ### horizontal rules
          color brightmagenta "^(---+|===+|___+|\*\*\*+)\s*$"
          ### headlines
          color brightmagenta  "^#{1,6}.*"
          ### lists
          color blue   "^[[:space:]]*[\*+-] |^[[:space:]]*[0-9]+\. "
          ### leading whitespace
          color black    "^[[:space:]]+"
          ### misc
          color magenta   "\(([CcRr]|[Tt][Mm])\)" "\.{3}" "(^|[[:space:]])\-\-($|[[:space:]])"
          ### links
          color brightblue "\[[^]]+\]"
          color brightblue "\[([^][]|\[[^]]*\])*\]\([^)]+\)"
          ### images
          color magenta "!\[[^][]*\](\([^)]+\)|\[[^]]+\])"
          ### urls
          color brightyellow "https?://[^ )>]+"
          ### code
          color yellow   "`[^`]*`|^ {4}[^-+*].*"
          ### code blocks
          color yellow start="^```[^$]" end="^```$"
          color yellow "^```$"

          ### Trailing spaces
          color ,green "[[:space:]]+$"

        ## Nginx
          syntax "Nginx" "nginx.*\.conf$" "\.nginx$" ".*\/sites\-available\/.*$" ".*\/sites\-enabled\/.*$"
          header "^(server|upstream)[^{]*\{$"

          color brightmagenta  "\<(events|server|http|location|upstream)[[:space:]]*\{"
          color cyan "(^|[[:space:]{;])(access_log|add_after_body|add_before_body|add_header|addition_types|aio|alias|allow|ancient_browser|ancient_browser_value|auth_basic|auth_basic_user_file|autoindex|autoindex_exact_size|autoindex_localtime|break|charset|charset_map|charset_types|chunked_transfer_encoding|client_body_buffer_size|client_body_in_file_only|client_body_in_single_buffer|client_body_temp_path|client_body_timeout|client_header_buffer_size|client_header_timeout|client_max_body_size|connection_pool_size|create_full_put_path|daemon|dav_access|dav_methods|default_type|deny|directio|directio_alignment|disable_symlinks|empty_gif|env|error_log|error_page|expires|fastcgi_buffer_size|fastcgi_buffers|fastcgi_busy_buffers_size|fastcgi_cache|fastcgi_cache_bypass|fastcgi_cache_key|fastcgi_cache_lock|fastcgi_cache_lock_timeout|fastcgi_cache_min_uses|fastcgi_cache_path|fastcgi_cache_use_stale|fastcgi_cache_valid|fastcgi_connect_timeout|fastcgi_hide_header|fastcgi_ignore_client_abort|fastcgi_ignore_headers|fastcgi_index|fastcgi_intercept_errors|fastcgi_keep_conn|fastcgi_max_temp_file_size|fastcgi_next_upstream|fastcgi_no_cache|fastcgi_param|fastcgi_pass|fastcgi_pass_header|fastcgi_read_timeout|fastcgi_send_timeout|fastcgi_split_path_info|fastcgi_store|fastcgi_store_access|fastcgi_temp_file_write_size|fastcgi_temp_path|flv|geo|geoip_city|geoip_country|gzip|gzip_buffers|gzip_comp_level|gzip_disable|gzip_http_version|gzip_min_length|gzip_proxied|gzip_static|gzip_types|gzip_vary|if|if_modified_since|ignore_invalid_headers|image_filter|image_filter_buffer|image_filter_jpeg_quality|image_filter_sharpen|image_filter_transparency|include|index|internal|ip_hash|keepalive|keepalive_disable|keepalive_requests|keepalive_timeout|large_client_header_buffers|limit_conn|limit_conn_log_level|limit_conn_zone|limit_except|limit_rate|limit_rate_after|limit_req|limit_req_log_level|limit_req_zone|limit_zone|lingering_close|lingering_time|lingering_timeout|listen|location|log_format|log_not_found|log_subrequest|map|map_hash_bucket_size|map_hash_max_size|master_process|max_ranges|memcached_buffer_size|memcached_connect_timeout|memcached_next_upstream|memcached_pass|memcached_read_timeout|memcached_send_timeout|merge_slashes|min_delete_depth|modern_browser|modern_browser_value|mp4|mp4_buffer_size|mp4_max_buffer_size|msie_padding|msie_refresh|open_file_cache|open_file_cache_errors|open_file_cache_min_uses|open_file_cache_valid|open_log_file_cache|optimize_server_names|override_charset|pcre_jit|perl|perl_modules|perl_require|perl_set|pid|port_in_redirect|postpone_output|proxy_buffer_size|proxy_buffering|proxy_buffers|proxy_busy_buffers_size|proxy_cache|proxy_cache_bypass|proxy_cache_key|proxy_cache_lock|proxy_cache_lock_timeout|proxy_cache_min_uses|proxy_cache_path|proxy_cache_use_stale|proxy_cache_valid|proxy_connect_timeout|proxy_cookie_domain|proxy_cookie_path|proxy_hide_header|proxy_http_version|proxy_ignore_client_abort|proxy_ignore_headers|proxy_intercept_errors|proxy_max_temp_file_size|proxy_next_upstream|proxy_no_cache|proxy_pass|proxy_pass_header|proxy_read_timeout|proxy_redirect|proxy_send_timeout|proxy_set_header|proxy_ssl_session_reuse|proxy_store|proxy_store_access|proxy_temp_file_write_size|proxy_temp_path|proxy_cache_methods|proxy_pass_request_body|proxy_pass_request_headers|proxy_cache_convert_head|proxy_cache_lock_age|proxy_cache_max_range_offset|proxy_send_lowat|proxy_set_body|proxy_socket_keepalive|proxy_ssl_trusted_certificate|random_index|read_ahead|real_ip_header|recursive_error_pages|request_pool_size|reset_timedout_connection|resolver|resolver_timeout|return|rewrite|root|satisfy|satisfy_any|secure_link_secret|send_lowat|send_timeout|sendfile|sendfile_max_chunk|server|server|server_name|server_name_in_redirect|server_names_hash_bucket_size|server_names_hash_max_size|server_tokens|set|set_real_ip_from|source_charset|split_clients|ssi|ssi_silent_errors|ssi_types|ssl|ssl_certificate|ssl_certificate_key|ssl_ciphers|ssl_client_certificate|ssl_crl|ssl_dhparam|ssl_engine|ssl_prefer_server_ciphers|ssl_protocols|ssl_session_cache|ssl_session_timeout|ssl_verify_client|ssl_verify_depth|ssl_ecdh_curve|ssl_session_tickets|ssl_stapling|ssl_stapling_verify|ssl_stapling_file|ssl_stapling_responder|ssl_buffer_size|ssl_early_data|ssl_password_file|ssl_session_ticket_key|ssl_trusted_certificate|sub_filter|sub_filter_once|sub_filter_types|tcp_nodelay|tcp_nopush|timer_resolution|try_files|types|types_hash_bucket_size|types_hash_max_size|underscores_in_headers|uninitialized_variable_warn|upstream|user|userid|userid_domain|userid_expires|userid_name|userid_p3p|userid_path|userid_service|valid_referers|variables_hash_bucket_size|variables_hash_max_size|worker_priority|worker_processes|worker_rlimit_core|worker_rlimit_nofile|working_directory|xml_entities|xslt_stylesheet|xslt_types)([[:space:]]|$)"
          color brightcyan  "\<(on|off)\>"
          color brightyellow "\$[A-Za-z][A-Za-z0-9_]*"
          color red "[*]"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color yellow   start="'$" end="';$"
          color brightblue "(^|[[:space:]])#([^{].*)?$"
          color ,green "[[:space:]]+$"
          color ,red "	+ +| +	+"

        ## PHP
          syntax "PHP" "\.php[2345s~]?$|\.module$"
          magic "PHP script"
          comment "//"
          color white start="<\?(php|=)?" end="\?>"
          ### Constructs
          color brightblue "(class|extends|goto) ([a-zA-Z0-9_]*)"
          color brightblue "[^a-z0-9_-]{1}(var|class|function|echo|case|break|default|exit|switch|if|else|elseif|endif|foreach|endforeach|@|while|public|private|protected|return|true|false|null|TRUE|FALSE|NULL|const|static|extends|as|array|require|include|require_once|include_once|define|do|continue|declare|goto|print|in|namespace|use)[^a-z0-9_-]{1}"
          color brightblue "[a-zA-Z0-9_]+:"
          ### Variables
          color green "\$[a-zA-Z_0-9$]*|[=!<>]"
          color green "\->[a-zA-Z_0-9$]*|[=!<>]"
          ### Functions
          color brightblue "([a-zA-Z0-9_-]*)\("
          ### Special values
          color brightmagenta "[^a-z0-9_-]{1}(true|false|null|TRUE|FALSE|NULL)$"
          color brightmagenta "[^a-z0-9_-]{1}(true|false|null|TRUE|FALSE|NULL)[^a-z0-9_-]{1}"
          ### Special Characters
          color yellow "[.,{}();]"
          color cyan "\["
          color cyan "\]"
          ### Numbers
          color magenta "[+-]*([0-9]\.)*[0-9]+([eE][+-]?([0-9]\.)*[0-9])*"
          color magenta "0x[0-9a-zA-Z]*"
          ### Special Variables
          color brightblue "(\$this|parent::|self::|\$this->)"
          color magenta ";"
          ### Comparison operators
          color yellow "(<|>)"
          ### Assignment operator
          color brightblue "="
          ### Bitwise Operations
          color magenta "(&|\||\^)"
          color magenta "(<<|>>)"
          ### Comparison operators
          color yellow "(==|===|!=|<>|!==|<=|>=|<=>)"
          ### Logical Operators
          color yellow "( and | or | xor |!|&&|\|\|)"
          ### And/Or/SRO/etc
          color cyan "(\;\;|\|\||::|=>|->)"
          ### Double quoted STRINGS!
          color red "(\"[^\"]*\")"
          ### Heredoc (typically ends with a semicolon).
          color red start="<<<['\"]?[A-Z][A-Z0-9_]*['\"]?" end="^[A-Z][A-Z0-9_]*;"
          ### Inline Variables
          color white "\{\$[^}]*\}"
          ### Single quoted string
          color red "('[^']*')"
          ### Online Comments
          color brightyellow "^(#.*|//.*)$"
          color brightyellow "[	| ](#.*|//.*)$"
          ### PHP Tags
          color red "(<\?(php)?|\?>)"
          ### General HTML
          color red start="\?>" end="<\?(php|=)?"
          ### trailing whitespace
          color ,green "[[:space:]]+$"
          ### multi-line comments
          color brightyellow start="/\*" end="\*/"
          ### Nowdoc
          color red start="<<<'[A-Z][A-Z0-9_]*'" end="^[A-Z][A-Z0-9_]*;"

        ## SQL
          syntax "SQL" "\.sql$" "sqliterc$"

          icolor cyan "\<(ALL|ASC|AS|ALTER|AND|ADD|AUTO_INCREMENT)\>"
          icolor cyan "\<(BETWEEN|BINARY|BOTH|BY|BOOLEAN)\>"
          icolor cyan "\<(CHANGE|CHECK|COLUMNS|COLUMN|CROSS|CREATE)\>"
          icolor cyan "\<(DATABASES|DATABASE|DATA|DELAYED|DESCRIBE|DESC|DISTINCT|DELETE|DROP|DEFAULT)\>"
          icolor cyan "\<(ENCLOSED|ESCAPED|EXISTS|EXPLAIN)\>"
          icolor cyan "\<(FIELDS|FIELD|FLUSH|FOR|FOREIGN|FUNCTION|FROM)\>"
          icolor cyan "\<(GROUP|GRANT|HAVING)\>"
          icolor cyan "\<(IGNORE|INDEX|INFILE|INSERT|INNER|INTO|IDENTIFIED|IN|IS|IF)\>"
          icolor cyan "\<(JOIN|KEYS|KILL|KEY)\>"
          icolor cyan "\<(LEADING|LIKE|LIMIT|LINES|LOAD|LOCAL|LOCK|LOW_PRIORITY|LEFT|LANGUAGE)\>"
          icolor cyan "\<(MODIFY|NATURAL|NOT|NULL|NEXTVAL)\>"
          icolor cyan "\<(OPTIMIZE|OPTION|OPTIONALLY|ORDER|OUTFILE|OR|OUTER|ON)\>"
          icolor cyan "\<(PROCEDURE|PROCEDURAL|PRIMARY)\>"
          icolor cyan "\<(READ|REFERENCES|REGEXP|RENAME|REPLACE|RETURN|REVOKE|RLIKE|RIGHT)\>"
          icolor cyan "\<(SHOW|SONAME|STATUS|STRAIGHT_JOIN|SELECT|SETVAL|SET)\>"
          icolor cyan "\<(TABLES|TERMINATED|TO|TRAILING|TRUNCATE|TABLE|TEMPORARY|TRIGGER|TRUSTED)\>"
          icolor cyan "\<(UNIQUE|UNLOCK|USE|USING|UPDATE|VALUES|VARIABLES|VIEW)\>"
          icolor cyan "\<(WITH|WRITE|WHERE|ZEROFILL|TYPE|XOR)\>"
          color green     "\<(VARCHAR|TINYINT|TEXT|DATE|SMALLINT|MEDIUMINT|INT|INTEGER|BIGINT|FLOAT|DOUBLE|DECIMAL|DATETIME|TIMESTAMP|TIME|YEAR|UNSIGNED|CHAR|TINYBLOB|TINYTEXT|BLOB|MEDIUMBLOB|MEDIUMTEXT|LONGBLOB|LONGTEXT|ENUM|BOOL|BINARY|VARBINARY)\>"

          ### SQLite meta commands
          icolor cyan "\.\<(databases|dump|echo|exit|explain|header(s)?|help)\>"
          icolor cyan "\.\<(import|indices|mode|nullvalue|output|prompt|quit|read)\>"
          icolor cyan "\.\<(schema|separator|show|tables|timeout|width)\>"
          color brightcyan  "\<(ON|OFF)\>"

          color blue   "\<([0-9]+)\>"
          color yellow ""(\\.|[^"])*"|'(\\.|[^'])*'"
          color yellow   "`(\\.|[^\\`])*`"
          color brightblack  "\-\-.*$"
          color ,green "[[:space:]]+$"
          color ,red "	+ +| +	+"

        ## TOML
          syntax "toml" "\.toml$"
          comment "#"

          ### Booleans
          color magenta "true|false"

          ### Numbers
          color green "[+-]?[[:space:]]*[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?"
          color green "[0-9]+(_[0-9]+)*"

          ### Tables / unwrapped keys
          color brightgreen "[a-zA-Z0-9_]*(\.[a-zA-Z0-9_]+)*"

          ### Invalid Table names
          color ,red "^[[:space:]]*\[\]"
          color ,red "^[[:space:]]*\[[a-zA-Z0-9_]\.\]"
          color ,red "^[[:space:]]*\[.*\.\..*\]"
          color ,red "^[[:space:]]*\[\..*?\]"

          ### Strings
          color brightyellow ""(\.|[^"])*"" "'(\.|[^'])*'"
          color yellow start="\"\"\"" end="\"\"\""

          ### Comments
          color brightblue "#.*"

          ### Keyless value
          color ,red "^[[:space:]]*=.*"

          ### Trailing whitespace
          color ,green "[[:space:]]+$"

        ## xml
          syntax "XML" ".*\.([jrs]?html?|xml|sgml?|rng|vue|mei|musicxml)$"
          header "<\?xml.*version=.*\?>"
          magic "(XML|SGML) (sub)?document"
          comment "<!--|-->"

          color white "^.+$"
          color green  start="<" end=">"
          color cyan   "<[^> ]+"
          color cyan   ">"
          color yellow start="<!DOCTYPE" end="[/]?>"
          color yellow start="<!--" end="-->"
          color red    "&[^;]*;"

          ### Trailing spaces
          color ,green "[[:space:]]+$"

        ## YAML
          syntax "yaml" "\.ya?ml$"
          #comment "#"
          header "^---" "%YAML"

          ### Values
          color green "(:|^|\s)+\S+"

          ### Keys
          color red "(^|\s+).*+\s*:(\s|$)"

          ### Special values
          color yellow "[:-]\s+(true|false|null)\s*$"
          color yellow "[:-]\s+[0-9]+\.?[0-9]*(\s*($|#))"
          color yellow "(^| )!!(binary|bool|float|int|map|null|omap|seq|set|str) "

          ### Separator
          color brightwhite "^\s+-"
          color brightwhite ":(\s|\t|$)"

          ### Comments
          color brightblue "(^|[[:space:]])#.*$"

          ### Trailing whitespace
          color ,red "[[:space:]]+$"

        include "~/.config/nano/*.nanorc"
      '';
      "nano/blank.nanorc".text = ''
        ## Intentionally blank nanorc file to allow 'include "~/.config/nano/*.nanorc"' statement
      '';
    };
  };
}
