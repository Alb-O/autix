{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    {
      # defaults will be provided by the options module when available
      config = {
        autix.lsp.servers = with pkgs; {
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
            package = nodePackages.typescript-language-server;
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
            package = vscode-langservers-extracted;
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
            package = vscode-langservers-extracted;
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
            package = vscode-langservers-extracted;
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
            package = vscode-langservers-extracted;
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
            package = marksman;
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
            package = tailwindcss-language-server;
          };

          rust = {
            command = [ "rust-analyzer" ];
            extensions = [ ".rs" ];
            package = rust-analyzer;
          };

          nix = {
            command = [ "nixd" ];
            extensions = [ ".nix" ];
            package = nixd;
          };

          package-version-server = {
            command = [ "package-version-server" ];
            extensions = [
              ".json"
              ".lock"
            ];
            package = package-version-server;
          };
        };

        # Install all LSP packages that are defined
        home.packages =
          (lib.filter (p: p != null) (
            lib.mapAttrsToList (_name: server: server.package) config.autix.lsp.servers
          ))
          ++ config.autix.lsp.packages;
      };
    };
  optionsModule = {
    options.autix.lsp = {
      servers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              command = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "Command to start the LSP server";
              };
              extensions = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "File extensions this LSP handles";
              };
              package = lib.mkOption {
                type = lib.types.nullOr lib.types.package;
                default = null;
                description = "Package providing this LSP server";
              };
            };
          }
        );
        default = { };
        description = "LSP server definitions";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Additional LSP-related packages";
      };
    };
  };
in
{
  flake.aspects.lsp = {
    description = "Shared Language Server Protocol tooling.";
    homeManager.imports = [

      optionsModule

      hmModule

    ];
  };
}
