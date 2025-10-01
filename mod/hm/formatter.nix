{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    {
      options.autix.formatter = {
        formatters = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                command = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "Command to run the formatter (use $FILE placeholder)";
                };
                extensions = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "File extensions this formatter handles";
                };
                package = lib.mkOption {
                  type = lib.types.nullOr lib.types.package;
                  default = null;
                  description = "Package providing this formatter";
                };
              };
            }
          );
          default = { };
          description = "Formatter definitions";
        };

        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional formatter-related packages";
        };
      };

      config = {
        autix.formatter.formatters = {
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
            package = pkgs.nodePackages.prettier;
          };

          nixfmt = {
            command = [
              "nixfmt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".nix" ];
            package = pkgs.nixfmt-rfc-style;
          };

          rustfmt = {
            command = [
              "rustfmt"
              "$FILE"
            ];
            extensions = [ ".rs" ];
            package = pkgs.rustfmt;
          };

          gofmt = {
            command = [
              "gofmt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".go" ];
            package = pkgs.go;
          };

          gofumpt = {
            command = [
              "gofumpt"
              "-w"
              "$FILE"
            ];
            extensions = [ ".go" ];
            package = pkgs.gofumpt;
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
            package = pkgs.shfmt;
          };

          stylua = {
            command = [
              "stylua"
              "--search-parent-directories"
              "$FILE"
            ];
            extensions = [ ".lua" ];
            package = pkgs.stylua;
          };
        };

        # Install all formatter packages that are defined
        home.packages = lib.mkAfter (
          (lib.filter (p: p != null) (
            lib.mapAttrsToList (_name: formatter: formatter.package) config.autix.formatter.formatters
          ))
          ++ config.autix.formatter.packages
        );
      };
    };
in
{
  autix.home.modules.formatter = hmModule;
}
