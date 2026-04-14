{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.visual-studio-code;
in
  with lib;
  {
    config = mkIf cfg.enable (let
      pkgs-ext = import inputs.nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
          #inputs.nix-vscode-extensions.overlays.release
        ];
      };

      marketplace = pkgs-ext.vscode-marketplace;
      marketplace-release = pkgs-ext.vscode-marketplace-release;

      profileBlocks = {
        global = {
          # Nixpkgs-sourced extensions
          nixpkgs = with pkgs.vscode-extensions; [
            # Remote
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
          ];

          # Marketplace
          # For extensions not avaialble in https://search.nixos.org/packages?type=packages&query=vscode-extensions
          marketplace-release = with marketplace-release; [
          ];

          marketplace = with marketplace; [
            # Bleeding Edge
            ## Github
            github.vscode-github-actions                # Github actions helper
            ziyasal.vscode-open-in-github               # Jump to a source code line in Github, Bitbucket, Gitlab, VisualStudio.com

            ## Development
            mkhl.direnv

            ## Editor Helpers
            shd101wyy.markdown-preview-enhanced         # Better Markdown Preview
            nickdemayo.vscode-json-editor               # JSON Editor
            hilleer.yaml-plus-json                      # JSON <> YAML converter
            tyriar.sort-lines                           # Sort Lines
            fabiospampinato.vscode-diff                 # Show differences between files
            uyiosa-enabulele.reopenclosedtab            # Reopen last tab
            jinhyuk.replace-curly-quotes                # Replace all ` with '
            tombonnike.vscode-status-bar-format-toggle  # Toggle formatting with a single click

            ## Language Support
            esbenp.prettier-vscode                      # JavaScript TypeScript Flow JSX JSON CSS SCSS Less HTML Vue Angular HANDLEBARS Ember Glimmer GraphQL Markdown YAML
            richie5um2.vscode-sort-json                 # JSON
            davidanson.vscode-markdownlint              # Markdown
            yzhang.markdown-all-in-one                  # Markdown

            ## Remote
            #ms-vscode-remote.remote-containers          # Access Docker Contaniers remotely
            #ms-vscode-remote.remote-ssh-edit            # Edit SSH Configuration Files
            ms-vscode.remote-explorer                     # View remote machines for SSH and Tunnels

            ## Syntax Highlighting | File Support | Linting
            evgeniypeshkov.syntax-highlighter           # C++, C, Python, TypeScript, TypeScriptReact, JavaScript, Go, Rust, Php, Ruby, ShellScript, Bash, OCaml, Lua
            bierner.markdown-mermaid                    # MermaidJS in MarkDown
            redhat.vscode-yaml                          # YAML
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
            "explorer.confirmDelete" = false;

            ## Editor
            "editor" = {
              "detectIndentation" = true;
              "mouseMiddleClickAction" = "openLink";
              "experimentalGpuAcceleration" = "off";
              "accessibilitySupport" = "off";
              "bracketPairColorization.enabled" = true;
              "copyWithSyntaxHighlighting" = false;
              #"detectIndentation" = false;
              "fontFamily" = "Hack Nerd Font";
              "fontLigatures" = true;
              "formatOnPaste" = false;
              "formatOnSave" = false;
              "formatOnType" = false;
              "guides.bracketPairs" = "active";
              "minimap" = {
                "enabled" = true;
                "side" = "right";
                "showSlider" = "always";
                "renderCharacters" = false;
                "maxColumn" = 80;
              };

              "mouseWheelZoom" = true;
              "overviewRulerBorder" = false;
              "renderControlCharacters" = true;
              "scrollbar.vertical" = "auto";
              "tabSize" = 4;
              "wordWrap" = "off";
            };

            "workbench" = {
              "browser" = {
                "openLocalhostLinks" = true; # interesting
                "enableChatTools" = true;    # interesting
              };
              "editor" = {
               "enablePreview" = false;
               "enablePreviewFromQuickOpen" = false;
               "empty.hint" = "hidden";
               "highlightModifiedTabs" = true;
               "showTabs" = "multiple";
              };
              "startupEditor" = "none";
            };

            "window" = {
              "menuBarVisibility" = "compact";
              "titleBarStyle" = "native";
              "zoomLevel" = 1;
            };

            "files" = {
              ## Disable File Operations
              "exclude" = {
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
              "watcherExclude" = {
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
              "trimTrailingWhitespace" = true;
            };

            "search" = {
              "exclude" = {
                "**/node_modules" = true;
                "**/bower_components" = true;
                "**/env" = true;
                "**/venv" = true;
              };
              "simpleDialog.enable" = true ; # Try this
            };

            ## Formatting
            "[html]" = {
               "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "[json]" = {
              "editor.defaultFormatter" = "vscode.json-language-features";
            };
            "[jsonc]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "[markdown]" = {
              "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
            };
            "[yaml]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };

            ## Git
            "git" = {
              "autofetch" = true;
              "ignoreLegacyWarning" = true;
              "ignoreMissingGitWarning" = true;
              "openRepositoryInParentFolders" = "never";
              "showPushSuccessNotification" = true;
              "suggestSmartCommit" = false;
            };

            "markdown" = {
              "extension" = {
                 "print.imgToBase64" = true;
                 "toc" = {
                   "levels" = "2..6";
                   "updateOnSave" = false;
                 };
              };
            };

            "sortLines" = {
              "filterBlankLines" = true;
              "ignoreUnselectedLastLine" = true;
            };

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

            ## Security
            "security" = {
              "workspace" = {
                "trust" = {
                  "enabled" = false;
                  "untrustedFiles" = "open";
                };
              };
            };

            "remote" = {
              "downloadExtensionsLocally" = false;
              "SSH" = {
                "configFile" = "~/.ssh/vscode_remote_ssh_config";
                "defaultExtensions" = [
                  ## AI
                  #"github.copilot"
                  #"github.copilot-chat"

                  ## Docker
                  "ms-azuretools.vscode-docker"
                  "ms-azuretools.vscode-containers"
                  "dunstontc.vscode-docker-syntax"

                  ## Github
                  "github.vscode-github-actions"

                  ## Editor Helpers
                  "fabiospampinato.vscode-diff"
                  "rpinski.shebang-snippets"
                  "shd101wyy.markdown-preview-enhanced"
                  "tombonnike.vscode-status-bar-format-toggle"
                  "tyriar.sort-lines"
                  "uyiosa-enabulele.reopenclosedtab"

                  ## Linters | Prettifiers
                  "davidanson.vscode-markdownlint"
                  "esbenp.prettier-vscode"
                  "evgeniypeshkov.syntax-highlighter"
                  "hilleer.yaml-plus-json"
                  "jinhyuk.replace-curly-quotes"
                  "nickdemayo.vscode-json-editor"
                  "pinage404.bash-extension-pack"
                  "redhat.vscode-yaml"
                  "richie5um2.vscode-sort-json"
                  "shakram02.bash-beautify"
                  "yzhang.markdown-all-in-one"
                ];
                "enableRemoteCommand" = false;
                "localServerDownload" = "always";
              };
            };

            ## Telemetry
            "redhat.telemetry.enabled" = mkForce false;
            "telemetry" = {
              "feedback.enabled" = mkForce false;
              "editStats.enabled" = mkForce false;
            };
            "update.mode" = mkForce "none";

            ## Terminal
            "terminal" = {
              "integrated" = {
                "enableImages" = true;
                "enableMultiLinePasteWarning" = "never";
                "fontFamily" = "Hack Nerd Font";
                "profiles" = {
                  "linux" = {
                    "bash" = {
                      "path" = "/usr/bin/env bash";
                      #"args" = ["--login"];
                      "icon" = "terminal-bash";
                    };
                    "zsh" = {
                      "path" = "/usr/bin/env zsh";
                      "args" = ["--login"];
                      "icon" = "terminal-zsh";
                    };
                  };
                };
              };
            };

            #mutableExtensionsDir = false;
          };
        };

        blank = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace-release = with marketplace-release; [
          ];
          marketplace = with marketplace; [
          ];
          keybindings = [
          ];
          userSettings = {
          };
        };

        ai = {
          nixpkgs = with pkgs.vscode-extensions; [
            github.copilot-chat                          # Github CoPilot
          ];
          marketplace = with marketplace; [
            anthropic.claude-code                        # Claude Code
            #github.copilot-chat                          # Github CoPilot
            #ms-vscode.copilot-mermaid-diagram           # Copilot Mermaid Diagram
          ];
          marketplace-release = with marketplace-release; [
          ];
          keybindings = [
          ];
          userSettings = {
            ## Copilot
            "chat" = {
              "agent" = {
                "thinkingStyle" = "fixedScrolling";
                "maxRequests" = 50;
              };
              "tools" = {
                "terminal" = {
                  "autoApprove" = {
                    "git commit" = false;
                    ".*/" = true;
                    "nix" = true;
                    "rm" = false;
                  };
                };
              };
              "viewSessions" = {
                "orientation" = "stacked";
              };
            };
            "github.copilot.editor.enableCodeActions" = true;
          };
        };

        docker = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace-release = with marketplace-release; [
          ];
          marketplace = with marketplace; [
            ms-azuretools.vscode-docker                 # Docker containers, images, and volumes
            ms-azuretools.vscode-containers
          ];
          keybindings = [
          ];
          userSettings = {
            "containers" = {
              "commands" = {
                "attach" = "$\${containerCommand} exec -it $\${containerId} $\${shellCommand}";
              };
              "containers" = {
                "description" = [ "ContainerName" "Status" ];
                "label" = "ContainerName";
                "sortBy" = "Label";
              };
              "images" = {
                "sortBy" = "Label";
              };
              "networks" = {
                "sortBy" = "Label";
              };
              "volumes" = {
                "label" = "VolumeName";
                "sortBy" = "Label";
              };
              "enableComposeLanguageService" = false;
            };
            "docker" = {
                "extension" = {
                  "enableComposeLanguageServer" = false;
                };
            };

            ## Formatting
            "[dockerfile]" = {
              "editor.defaultFormatter" = "foxundermoon.shell-format";
            };
          };
        };

        go = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace-release = with marketplace-release; [
          ];
          marketplace = with marketplace; [
            golang.go
            ms-vscode.makefile-tools                    # Makefile Tools
          ];
          keybindings = [
          ];
          userSettings = {
          };
        };

        php = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace = with marketplace; [
            laravel.vscode-laravel                      # Official Larvel
            bmewburn.vscode-intelephense-client         # PHP Intelephense
            ryannaddy.laravel-artisan                   # Run artisan commands
            amiralizadeh9480.laravel-extra-intellisense # Extra Intellisense for Laravel
            shufo.vscode-blade-formatter                # Format Blade Files
            absszero.vscode-laravel-goto                # Go to Controllers
            onecentlin.laravel-blade                    # Blade Snippets and Syntax Highlighting
            devsense.composer-php-vscode                # Composer Support
          ];
          marketplace-release = with marketplace-release; [
          ];
          keybindings = [
          ];
          userSettings = {
          };
        };

        nix = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace = with marketplace; [
            ## Language Support
            brettm12345.nixfmt-vscode                   # Nix TODO: Split and force programs to be installed
            bbenoist.nix                                # Nix
          ];
          marketplace-release = with marketplace-release; [
          ];
          keybindings = [
          ];
          userSettings = {
          };
        };

        shell = {
          nixpkgs = with pkgs.vscode-extensions; [
          ];
          marketplace = with marketplace; [
            ## Editor Helpers
            rpinski.shebang-snippets                    # Shebang helpers when typing #!

            ## Syntax Highlighting | File Support | Linting
            dunstontc.vscode-docker-syntax              # DockerFile
            foxundermoon.shell-format                   # Bash
            shakram02.bash-beautify                     # Bash
            timonwong.shellcheck                        # Bash TODO: Split and force shellcheck binary to be installed
          ];
          marketplace-release = with marketplace-release; [
          ];
          keybindings = [
          ];
          userSettings = {
            ## Formatting
            "[shellscript]" = {
              "editor.defaultFormatter" = "foxundermoon.shell-format";
            };

            "shellcheck" = {
              "enableQuickFix" = true;
              "exclude" = [
                "SC1008"
              ];
            };
          };
        };
      };

    in {
      programs.vscode = {
        enable = true;
        profiles = {
          default = {
            extensions = (with pkgs.vscode-extensions;
                            profileBlocks.global.nixpkgs ++
                            profileBlocks.ai.nixpkgs ++
                            profileBlocks.docker.nixpkgs ++
                            profileBlocks.go.nixpkgs ++
                            profileBlocks.nix.nixpkgs ++
                            profileBlocks.php.nixpkgs ++
                            profileBlocks.shell.nixpkgs
                          )
                          ++
                          (with marketplace-release;
                            profileBlocks.global.marketplace-release ++
                            profileBlocks.ai.marketplace-release ++
                            profileBlocks.docker.marketplace-release ++
                            profileBlocks.go.marketplace-release ++
                            profileBlocks.nix.marketplace-release ++
                            profileBlocks.php.marketplace-release ++
                            profileBlocks.shell.marketplace-release
                          )
                          ++
                          (with marketplace;
                            profileBlocks.global.marketplace ++
                            profileBlocks.ai.marketplace ++
                            profileBlocks.docker.marketplace ++
                            profileBlocks.go.marketplace ++
                            profileBlocks.nix.marketplace ++
                            profileBlocks.php.marketplace ++
                            profileBlocks.shell.marketplace
                          )
                        ;
            keybindings = profileBlocks.global.keybindings ++
                          profileBlocks.ai.keybindings ++
                          profileBlocks.docker.keybindings ++
                          profileBlocks.go.keybindings ++
                          profileBlocks.nix.keybindings ++
                          profileBlocks.php.keybindings ++
                          profileBlocks.shell.keybindings
                        ;
            userSettings = profileBlocks.global.userSettings
                           // profileBlocks.ai.userSettings
                           // profileBlocks.docker.userSettings
                           // profileBlocks.go.userSettings
                           // profileBlocks.nix.userSettings
                           // profileBlocks.php.userSettings
                           // profileBlocks.shell.userSettings
                         ;
          };
          docker = {
            extensions =  (with pkgs.vscode-extensions;
                            profileBlocks.global.nixpkgs ++
                            profileBlocks.docker.nixpkgs
                          )
                          ++
                          (with marketplace-release;
                            profileBlocks.global.marketplace-release ++
                            profileBlocks.docker.marketplace-release
                          )
                          ++
                          (with marketplace;
                            profileBlocks.global.marketplace ++
                            profileBlocks.docker.marketplace
                          )
                        ;
            keybindings = profileBlocks.global.keybindings
                          ++ profileBlocks.go.keybindings
                          ++ profileBlocks.docker.keybindings
                        ;
            userSettings = profileBlocks.global.userSettings
                           // profileBlocks.docker.userSettings
                         ;
          };
        };
      };
    });
  }
