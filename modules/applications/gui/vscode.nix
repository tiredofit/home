{ config, inputs, lib, nix-vscode-extensions, ... }:
let
  cfg = config.host.home.applications.visual-studio-code;
in
  with lib;
{

  options = {
    host.home.applications.visual-studio-code = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Integrated Development Environment";
      };
    defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "application/x-shellscript"
            "text/english"
            "text/markdown"
            "text/plain"
            "text/x-c"
            "text/x-c++"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-makefile"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.vscode =  {
      enable = true;
      extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
        ## Bundles
          lizebang.bash-extension-pack              # Bash shell

        ## Docker
          ms-azuretools.vscode-docker               # Docker containers, images, and volumes

        ## Editor Helpers
          tyriar.sort-lines                         # Sort Lines
          fabiospampinato.vscode-diff               # Show differences between files
          hilleer.yaml-plus-json                    # JSON <> YAML converter
          jinhyuk.replace-curly-quotes              # Replace all ` with '
          nickdemayo.vscode-json-editor             # JSON Editor
          rpinski.shebang-snippets                  # Shebang helpers when typing #!
          shd101wyy.markdown-preview-enhanced       # Better Markdown Preview
          tombonnike.vscode-status-bar-format-toggle # Toggle formatting with a single click
          uyiosa-enabulele.reopenclosedtab          # Reopen last tab
          ziyasal.vscode-open-in-github             # Jump to a source code line in Github, Bitbucket, Gitlab, VisualStudio.com

        ## CI
          github.vscode-github-actions              # Github actions helper

        ## Prettify / Formatting
          brettm12345.nixfmt-vscode                 # Nix TODO: Split and force programs to be installed
          eriklynd.json-tools                       # JSON
          esbenp.prettier-vscode                    # JavaScript TypeScript Flow JSX JSON CSS SCSS Less HTML Vue Angular HANDLEBARS Ember Glimmer GraphQL Markdown YAML
          mohsen1.prettify-json                     # JSON
          richie5um2.vscode-sort-json               # JSON
          shakram02.bash-beautify                   # Bash
          yzhang.markdown-all-in-one                # Markown
          davidanson.vscode-markdownlint            # Markdown

        ## Remote
          ms-vscode-remote.remote-containers        # Access Docker Contaniers remotely
          ms-vscode-remote.remote-ssh               # Open any folder on remote system
          ms-vscode-remote.remote-ssh-edit          # Edit SSH Configuration Files
          ms-vscode.remote-explorer                 # View remote machines for SSH and Tunnels

        ## Source Control
          exelord.git-commits                       # Adds list of last commits in source control tab
          donjayamanne.githistory                   # View git log, file history, compare branches or commits

        ## Syntax Highlighting | File Support | Linting
          bbenoist.nix                              # Nix
          bierner.markdown-mermaid                  # MermaidJS in MarkDown
          dunstontc.vscode-docker-syntax            # DockerFile
          evgeniypeshkov.syntax-highlighter         # C++, C, Python, TypeScript, TypeScriptReact, JavaScript, Go, Rust, Php, Ruby, ShellScript, Bash, OCaml, Lua
          foxundermoon.shell-format                 # Bash
          jtavin.ldif                               # LDAP LDIF
          me-dutour-mathieu.vscode-github-actions   # Github Actions YAML Support
          redhat.vscode-yaml                        # YAML
          timonwong.shellcheck                      # Bash TODO: Split and force shellcheck binary to be installed

        ## Web
          anseki.vscode-color                       # Color Picker
          budparr.language-hugo-vscode              # Hugo Syntax Support
         # eliostruyf.vscode-front-matter            # Front Matter CMS
      ];
      keybindings = [
        ## Favorites
        {
            key = "alt+oem_comma";
            command = "workbench.action.showCommands";
        }
        {
            key = "alt+oem_period";
            command = "workbench.action.findInFiles";
            when = "!searchInputBoxFocus";
        }
        {
            key = "alt+p";
            command = "workbench.action.quickOpen";
        }
        {
            key = "alt+e";
            command = "workbench.view.explorer";
        }
        {
            key = "shift+alt+w";
            command = "workbench.action.closeOtherEditors";
        }
        ## Tabs
                {
            key = "ctrl+1";
            command = "workbench.action.openEditorAtIndex1";
        }
        {
            key = "ctrl+2";
            command = "workbench.action.openEditorAtIndex2";
        }
        {
            key = "ctrl+3";
            command = "workbench.action.openEditorAtIndex3";
        }
        {
            key = "ctrl+4";
            command = "workbench.action.openEditorAtIndex4";
        }
        {
            key = "ctrl+5";
            command = "workbench.action.openEditorAtIndex5";
        }
        {
            key = "ctrl+6";
            command = "workbench.action.openEditorAtIndex6";
        }
        {
            key = "ctrl+7";
            command = "workbench.action.openEditorAtIndex7";
        }
        {
            key = "ctrl+8";
            command = "workbench.action.openEditorAtIndex8";
        }
        {
            key = "ctrl+9";
            command = "workbench.action.openEditorAtIndex9";
        }
        ## Terminal
        {
            key = "ctrl+f";
            command = "-workbench.action.terminal.focusFindWidget";
            when = "terminalFocus || terminalFindWidgetFocused";
        }
        {
            key = "ctrl+f";
            command = "-workbench.action.terminal.focusFind";
            when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
        }
        ## Toggles
        {
            key = "alt+a";
            command = "workbench.action.toggleActivityBarVisibility";
        }
        {
            key = "alt+b";
            command = "workbench.action.toggleSidebarVisibility";
        }
        {
            key = "alt+m";
            command = "workbench.action.toggleMenuBar";
        }
        {
            key = "alt+t";
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminal.active";
        }
      ];
      userSettings = {
         ## Default
        "explorer.confirmDelete" = false;
        "files.trimTrailingWhitespace" = true;
        "files.useExperimentalFileWatcher" = true;
        "window.menuBarVisibility" = "compact";
        "window.titleBarStyle" = "native";
        "window.zoomLevel" = 1;

        ## Docker
        "docker.commands.attach" = "$${containerCommand} exec -it $${containerId} $${shellCommand}" ;
        "docker.containers.description" = ["ContainerName" "Status" ] ;
        "docker.containers.label" = "ContainerName" ;
        "docker.containers.sortBy" = "Label" ;
        "docker.volumes.label" = "VolumeName" ;

        ## Editor
        "editor.bracketPairColorization.enabled" = true;
        "editor.copyWithSyntaxHighlighting" = false ;
        "editor.detectIndentation" = false ;
        "editor.fontFamily" = "Hack Nerd Font";
        "editor.fontLigatures" = true;
        "editor.formatOnPaste" = false ;
        "editor.formatOnSave" = false ;
        "editor.formatOnType" = false ;
        "editor.guides.bracketPairs" = "active";
        "editor.mouseWheelZoom" = true ;
        "editor.overviewRulerBorder" = false;
        "editor.renderControlCharacters" = true ;
        "editor.scrollbar.vertical" = false;
        "editor.tabSize" = 4 ;
        "editor.wordWrap" = "off";
        "workbench.editor.enablePreview" = false;
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "workbench.editor.empty.hint" = "hidden";
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.showTabs" = "multiple";
        "workbench.startupEditor" = "none" ;


        ## Formatting
        "[dockerfile]" = { "editor.defaultFormatter" = "foxundermoon.shell-format" ;};
        "[html]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode" ;};
        "[json]" = { "editor.defaultFormatter" = "vscode.json-language-features" ;};
        "[jsonc]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode" ;};
        "[markdown]" = { "editor.defaultFormatter" = "yzhang.markdown-all-in-one" ;};
        "[shellscript]" = { "editor.defaultFormatter" = "foxundermoon.shell-format" ;};
        "[yaml]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode" ;};
        "markdown.extension.print.imgToBase64" = true;
        "markdown.extension.toc.levels" = "2..6";
        "shellcheck.enableQuickFix" = true;
        "shellcheck.exclude" = [
           "SC1008"
        ];
        "syntax.highlightLanguages" = [
          "c"
          "cpp"
          "go"
          "javascript"
          "lua"
          "ocaml"
          "php"
          "python"
          "ruby"
          "rust"
          "shellscript"
          "typescript"
          "typescriptreact"
        ];

        ## Git
        "git.autofetch" = true;
        "git.ignoreLegacyWarning" = true;
        "git.ignoreMissingGitWarning" = true;
        "git.openRepositoryInParentFolders" = "never";
        "git.showPushSuccessNotification" = true;
        "git.suggestSmartCommit"= false;

        ## MiniMap
        "editor.minimap.enabled" = true;
        "editor.minimap.side" = "right";
        "editor.minimap.showSlider" = "always";
        "editor.minimap.renderCharacters" = false;
        "editor.minimap.maxColumn" = 80;

        ## Security
        "remote.downloadExtensionsLocally" = true;
        "security.workspace.trust.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";

        ## Telemetry
        "redhat.telemetry.enabled" = false;
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";

        ## Terminal
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "terminal.integrated.fontFamily" = "Hack Nerd Font";

        mutableExtensionsDir = false;
      };
    };
    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "code.desktop")
    );
  };
}
