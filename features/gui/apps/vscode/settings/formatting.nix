{ config, ... }: {
  imports = [
  ];
  programs = {
    vscode = {
      userSettings = {
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
      };
    };
  };
}