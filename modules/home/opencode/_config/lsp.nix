{
  settings = {
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
}
