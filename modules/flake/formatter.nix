{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;
      treefmt = {
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
        settings.global.excludes = [
          "flake.lock"
          ".envrc"
          ".leaderrc"
          "**/.gitignore"
          "*.example"
        ];
      };

      # Convenience packages for manual formatting/linting
      packages = {
        format-all = pkgs.writeShellScriptBin "format-all" ''
          echo "Formatting with treefmt..."
          ${config.treefmt.build.wrapper}/bin/treefmt
          echo "Formatting complete."
        '';

        lint-check = pkgs.writeShellScriptBin "lint-check" ''
          echo "Checking formatting with treefmt..."
          ${config.treefmt.build.wrapper}/bin/treefmt --fail-on-change
          echo "All files properly formatted."
        '';
      };
    };
}
