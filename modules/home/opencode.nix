_:
let
  hmModule = _: {
    programs.opencode = {
      enable = true;
      settings = {
        theme = "system";
        formatter = {
          prettier = {
            command = [
              "prettier"
              "--log-level=silent"
              "--write"
              "$FILE"
            ];
            extensions = [
              ".js"
              ".cjs"
              ".mjs"
              ".ts"
              ".tsx"
              ".jsx"
              ".json"
              ".css"
              ".scss"
              ".html"
              ".md"
              ".mdx"
            ];
          };
          nixfmt = {
            command = [
              "nixfmt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".nix" ];
          };
          rustfmt = {
            command = [
              "rustfmt"
              "$FILE"
            ];
            extensions = [ ".rs" ];
          };
          gofmt = {
            command = [
              "gofmt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".go" ];
          };
          gofumpt = {
            command = [
              "gofumpt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".go" ];
          };
          shfmt = {
            command = [
              "shfmt"
              "-w"
              "-i"
              "2"
              "-ci"
              "-bn"
              "$FILE"
            ];
            extensions = [
              ".sh"
              ".bash"
              ".zsh"
            ];
          };
          stylua = {
            command = [
              "stylua"
              "--search-parent-directories"
              "$FILE"
            ];
            extensions = [ ".lua" ];
          };
        };
        lsp = {
          typescript = {
            command = [
              "typescript-language-server"
              "--stdio"
            ];
            extensions = [
              ".ts"
              ".tsx"
              ".js"
              ".jsx"
              ".mjs"
              ".cjs"
              ".mts"
              ".cts"
            ];
          };
          eslint = {
            command = [
              "vscode-eslint-language-server"
              "--stdio"
            ];
            extensions = [
              ".ts"
              ".tsx"
              ".js"
              ".jsx"
              ".mjs"
              ".cjs"
              ".mts"
              ".cts"
              ".vue"
            ];
          };
          html = {
            command = [
              "vscode-html-language-server"
              "--stdio"
            ];
            extensions = [
              ".html"
              ".htm"
            ];
          };
          css = {
            command = [
              "vscode-css-language-server"
              "--stdio"
            ];
            extensions = [
              ".css"
              ".scss"
            ];
          };
          json = {
            command = [
              "vscode-json-language-server"
              "--stdio"
            ];
            extensions = [
              ".json"
              ".jsonc"
            ];
          };
          markdown = {
            command = [
              "marksman"
              "server"
            ];
            extensions = [
              ".md"
              ".mdx"
            ];
          };
          tailwindcss = {
            command = [
              "tailwindcss-language-server"
              "--stdio"
            ];
            extensions = [
              ".html"
              ".css"
              ".scss"
              ".ts"
              ".tsx"
              ".js"
              ".jsx"
              ".svelte"
            ];
          };
          rust = {
            command = [ "rust-analyzer" ];
            extensions = [ ".rs" ];
          };
          nix = {
            command = [ "nil" ];
            extensions = [ ".nix" ];
          };
        };
      };
    };
  };
in
{
  config = {
    flake.modules.homeManager.opencode = hmModule;
    autix.home.modules.opencode = hmModule;
  };
}
