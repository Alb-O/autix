{
  settings = {
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
  };
}
