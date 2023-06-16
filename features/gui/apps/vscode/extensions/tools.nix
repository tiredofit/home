{ config, inputs, lib, pkgs, ... }: {
  programs = {
    vscode = {
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

        ## Prettify / Formatting
          brettm12345.nixfmt-vscode                 # Nix TODO: Split and force programs to be installed
          eriklynd.json-tools                       # JSON
          esbenp.prettier-vscode                    # JavaScript TypeScript Flow JSX JSON CSS SCSS Less HTML Vue Angular HANDLEBARS Ember Glimmer GraphQL Markdown YAML
          mohsen1.prettify-json                     # JSON
          richie5um2.vscode-sort-json               # JSON
          shakram02.bash-beautify                   # Bash
          yzhang.markdown-all-in-one                # MarkDown

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
    };
  };
}