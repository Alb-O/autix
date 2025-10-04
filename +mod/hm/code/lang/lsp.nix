{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    {
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

      config = {
        autix.lsp.servers = {
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
            package = pkgs.nodePackages.typescript-language-server;
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
            package = pkgs.vscode-langservers-extracted;
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
            package = pkgs.vscode-langservers-extracted;
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
            package = pkgs.vscode-langservers-extracted;
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
            package = pkgs.vscode-langservers-extracted;
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
            package = pkgs.marksman;
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
            package = pkgs.tailwindcss-language-server;
          };

          rust = {
            command = [ "rust-analyzer" ];
            extensions = [ ".rs" ];
            package = pkgs.rust-analyzer;
          };

          nix = {
            command = [ "nixd" ];
            extensions = [ ".nix" ];
            package = pkgs.nixd;
          };
        };

        # Install all LSP packages that are defined
        home.packages = lib.mkAfter (
          (lib.filter (p: p != null) (
            lib.mapAttrsToList (_name: server: server.package) config.autix.lsp.servers
          ))
          ++ config.autix.lsp.packages
        );
      };
    };
in
{
  autix.aspects.lsp = {
    description = "Shared Language Server Protocol tooling.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
