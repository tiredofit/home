{ config, inputs, lib, pkgs, ... }:
let
## PERSONALIZE
  cfg = config.host.home.applications.visual-studio-code;
  pkgs-ext = import inputs.nixpkgs {
    inherit (pkgs) system;
    config.allowUnfree = true;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
  marketplace = pkgs-ext.vscode-marketplace;
in with lib; {
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
    programs.vscode = {
      enable = true;
      profiles = {
        default = {
          extensions = (with pkgs.vscode-extensions; [
            # From NixPkgs
            # Older Stable versions
            ## AI
            #github.copilot
            #github.copilot-chat

            ## CI

            ### Docker
            #ms-vscode-remote.remote-containers

            ## Editor Helpers

            ## Prettify / Formatting

            ## Remote
            ms-vscode-remote.remote-ssh                 # Open any folder on remote system
            ms-vscode-remote.remote-ssh-edit

            ## Syntax Highlighting | File Support | Linting
          ]) ++ (with marketplace; [
            # Bleeding Edge versions
            # For extensions not avaialble in https://search.nixos.org/packages?type=packages&query=vscode-extensions

            ## AI
            github.copilot
            github.copilot-chat
            ms-vscode.copilot-mermaid-diagram           # Copilot Mermaid Diagram

            ## CI
            github.vscode-github-actions                # Github actions helper

            ## Code
            golang.go
            ms-vscode.makefile-tools                    # Makefile Tools

            ## Docker
            ms-azuretools.vscode-docker                 # Docker containers, images, and volumes
            ms-azuretools.vscode-containers             # More containers

            ## Editor Helpers
            tyriar.sort-lines                           # Sort Lines
            shd101wyy.markdown-preview-enhanced         # Better Markdown Preview
            fabiospampinato.vscode-diff                 # Show differences between files
            hilleer.yaml-plus-json                      # JSON <> YAML converter
            jinhyuk.replace-curly-quotes                # Replace all ` with '
            nickdemayo.vscode-json-editor               # JSON Editor
            rpinski.shebang-snippets                    # Shebang helpers when typing #!
            tombonnike.vscode-status-bar-format-toggle  # Toggle formatting with a single click
            uyiosa-enabulele.reopenclosedtab            # Reopen last tab
            ziyasal.vscode-open-in-github               # Jump to a source code line in Github, Bitbucket, Gitlab, VisualStudio.com

            ## Language Support
            ### PHP
            laravel.vscode-laravel                      # Official Larvel
            bmewburn.vscode-intelephense-client         # PHP Intelephense
            ryannaddy.laravel-artisan                   # Run artisan commands
            amiralizadeh9480.laravel-extra-intellisense # Extra Intellisense for Laravel
            shufo.vscode-blade-formatter                # Format Blade Files
            absszero.vscode-laravel-goto                # Go to Controllers
            onecentlin.laravel-blade                    # Blade Snippets and Syntax Highlighting
            devsense.composer-php-vscode                # Composer Support

            brettm12345.nixfmt-vscode                   # Nix TODO: Split and force programs to be installed
            davidanson.vscode-markdownlint              # Markdown
            esbenp.prettier-vscode                      # JavaScript TypeScript Flow JSX JSON CSS SCSS Less HTML Vue Angular HANDLEBARS Ember Glimmer GraphQL Markdown YAML
            yzhang.markdown-all-in-one                  # Markown
            richie5um2.vscode-sort-json                 # JSON
            shakram02.bash-beautify                     # Bash

            ## Remote
            #ms-vscode-remote.remote-containers          # Access Docker Contaniers remotely
            #ms-vscode-remote.remote-ssh-edit            # Edit SSH Configuration Files
            ms-vscode.remote-explorer                     # View remote machines for SSH and Tunnels

            ## Syntax Highlighting | File Support | Linting
            dunstontc.vscode-docker-syntax              # DockerFile
            evgeniypeshkov.syntax-highlighter           # C++, C, Python, TypeScript, TypeScriptReact, JavaScript, Go, Rust, Php, Ruby, ShellScript, Bash, OCaml, Lua
            bbenoist.nix                                # Nix
            bierner.markdown-mermaid                    # MermaidJS in MarkDown
            foxundermoon.shell-format                   # Bash
            redhat.vscode-yaml                          # YAML
            timonwong.shellcheck                        # Bash TODO: Split and force shellcheck binary to be installed

            ## Development
            mkhl.direnv
          ]);
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
              when =
                "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
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
            "window.menuBarVisibility" = "compact";
            "window.titleBarStyle" = "native";
            "window.zoomLevel" = 1;

            ## Docker
            "containers.commands.attach" = "$\${containerCommand} exec -it $\${containerId} $\${shellCommand}";
            "containers.containers.description" = [ "ContainerName" "Status" ];
            "containers.containers.label" = "ContainerName";
            "containers.containers.sortBy" = "Label";
            "containers.images.sortBy" = "Label";
            "containers.networks.sortBy" = "Label";
            "containers.volumes.label" = "VolumeName";
            "containers.volumes.sortBy" = "Label";
            "containers.enableComposeLanguageService" = false;

            ## Editor
            "editor.accessibilitySupport" = "off";
            "editor.bracketPairColorization.enabled" = true;
            "editor.copyWithSyntaxHighlighting" = false;
            "editor.detectIndentation" = false;
            "editor.fontFamily" = "Hack Nerd Font";
            "editor.fontLigatures" = true;
            "editor.formatOnPaste" = false;
            "editor.formatOnSave" = false;
            "editor.formatOnType" = false;
            "editor.guides.bracketPairs" = "active";
            "editor.mouseWheelZoom" = true;
            "editor.overviewRulerBorder" = false;
            "editor.renderControlCharacters" = true;
            "editor.scrollbar.vertical" = "auto";
            "editor.tabSize" = 4;
            "editor.wordWrap" = "off";
            "workbench.editor.enablePreview" = false;
            "workbench.editor.enablePreviewFromQuickOpen" = false;
            "workbench.editor.empty.hint" = "hidden";
            "workbench.editor.highlightModifiedTabs" = true;
            "workbench.editor.showTabs" = "multiple";
            "workbench.startupEditor" = "none";
            "docker.extension.enableComposeLanguageServer" = false;

            ## Copilot
            "github.copilot.editor.enableCodeActions" = true;

            ## Formatting
            "[dockerfile]" = {
              "editor.defaultFormatter" = "foxundermoon.shell-format";
            };
            "[html]" = {
               "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
            "[json]" = {
              "editor.defaultFormatter" = "vscode.json-language-features";
            };
            "[jsonc]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
            "[markdown]" = {
              "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
            };
            "[shellscript]" = {
              "editor.defaultFormatter" = "foxundermoon.shell-format";
            };
            "[yaml]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
            "markdown.extension.print.imgToBase64" = true;
            "markdown.extension.toc.levels" = "2..6";
            "markdown.extension.toc.updateOnSave" = false;
            "shellcheck.enableQuickFix" = true;
            "shellcheck.exclude" = [ "SC1008" ];
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
            "git.suggestSmartCommit" = false;

            ## MiniMap
            "editor.minimap.enabled" = true;
            "editor.minimap.side" = "right";
            "editor.minimap.showSlider" = "always";
            "editor.minimap.renderCharacters" = false;
            "editor.minimap.maxColumn" = 80;

            ## Security
            "security.workspace.trust.enabled" = false;
            "security.workspace.trust.untrustedFiles" = "open";

            ## SSH
            "remote.SSH.configFile" = "~/.ssh/vscode_remote_ssh_config";
            "remote.SSH.defaultExtensions" =
              [ # # TODO - Merge this, this is mostly duplicates with exception of remote plugins
                "bbenoist.nix"
                "bierner.markdown-mermaid"
                "brettm12345.nixfmt-vscode"
                "davidanson.vscode-markdownlint"
                "dunstontc.vscode-docker-syntax"
                "esbenp.prettier-vscode"
                "evgeniypeshkov.syntax-highlighter"
                "fabiospampinato.vscode-diff"
                "foxundermoon.shell-format"
                "github.copilot"
                "github.copilot-chat"
                "github.vscode-github-actions"
                "hilleer.yaml-plus-json"
                "jinhyuk.replace-curly-quotes"
                "ms-azuretools.vscode-docker"
                "ms-azuretools.vscode-containers"
                "ms-vscode.copilot-mermaid-diagram"
                "nickdemayo.vscode-json-editor"
                "pinage404.bash-extension-pack"
                "redhat.vscode-yaml"
                "richie5um2.vscode-sort-json"
                "rpinski.shebang-snippets"
                "shakram02.bash-beautify"
                "shd101wyy.markdown-preview-enhanced"
                "timonwong.shellcheck"
                "tombonnike.vscode-status-bar-format-toggle"
                "tyriar.sort-lines"
                "uyiosa-enabulele.reopenclosedtab"
                "yzhang.markdown-all-in-one"
                "ziyasal.vscode-open-in-github"
              ];
            "remote.SSH.enableRemoteCommand" = true;
            "remote.SSH.localServerDownload" = "off";
            "remote.downloadExtensionsLocally" = true;


            ## Telemetry
            "redhat.telemetry.enabled" = false;
            "telemetry.telemetryLevel" = "off";
            "update.mode" = "none";

            ## Terminal
            "terminal.integrated.enableMultiLinePasteWarning" = "never";
            "terminal.integrated.fontFamily" = "Hack Nerd Font";

            "terminal.integrated.profiles.linux" = {
               "bash" = {
                 "path" = "/usr/bin/env bash";
                 "args" = ["--login"];
                 "icon" = "terminal-bash";
               };
            };

            ## Disable File Operations
            "files.exclude" = {
              "**/.git" = true;
              "**/.DS_Store" = true;
              "**/.vscode" = true;
              "**/__pycache__" = true;
              "**/.pytest_cache" = true;
              "**/node_modules" = true;
              "node_modules" = true;
              "venv" = true;
              "*.sublime-*" = true;
              "env*" = true;
            };
            "files.watcherExclude" = {
              "**/.git/objects/**" = true;
              "**/node_modules/**" = true;
              "**/vendor/**" = true;
              "**/build/**" = true;
              "**/dist/**" = true;
              "**/.output/**" = true;
              "**/.nuxt/**" = true;
              "**/.vscode/**" = true;
              "**/.zip/**" =  true;
            };

            "search.exclude" = {
              "**/node_modules" = true;
              "**/bower_components" = true;
              "**/env" = true;
              "**/venv" = true;
            };

            "chat.tools.terminal.autoApprove" = {
              "git commit" = false;
              ".*/" = true;
              "nix" = true;
              "rm" = false;
            };
            #mutableExtensionsDir = false;
            chat.agent.maxRequests = 50;
          };
        };
      };
    };

    xdg = {
      mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable
        (lib.genAttrs cfg.defaultApplication.mimeTypes (_: "code.desktop"));
    };
  };
}

