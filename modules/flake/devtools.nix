{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "autix-devshell";
        packages = with pkgs; [
          # Nix tools
          nixd # Nix language server
          nil # Alternative Nix language server
          nixfmt-rfc-style # Nix formatter (used by treefmt)
          deadnix # Dead code elimination for Nix (used by treefmt)
          statix # Lints and suggestions for Nix (used by treefmt)

          # Development utilities
          git
          just # Already in essential-pkgs, but useful in devshell
          jq

          # Flake management
          nix-output-monitor # Better nix build output
        ];

        shellHook = ''
          echo "autix development environment"
          echo "Tools:"
          echo "  nixd, nil: Nix language servers"
          echo "  nix fmt: Format with treefmt"
          echo "  nix run .#format-all: Manual formatting"
          echo "  nix run .#lint-check: Check formatting"
          echo "  nix run .#write-flake: Regenerate flake.nix"
        '';
      };

      packages = {
        format-nix = pkgs.writeShellScriptBin "format-nix" ''
          echo "Use 'nix fmt' for treefmt formatting"
          echo "Or 'nix run .#format-all' for verbose output"
        '';

        lint-nix = pkgs.writeShellScriptBin "lint-nix" ''
          echo "Use 'nix fmt' for integrated linting"
          echo "Or 'nix run .#lint-check' to check without changes"
        '';
      };
    };
}
