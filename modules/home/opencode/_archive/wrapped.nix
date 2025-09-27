{ callPackage
, models-dev
, inputs
, lib
, system
, ...
}@pkgs:
let
  # Get the full nixpkgs with all functions
  fullPkgs = inputs.nixpkgs.legacyPackages.${system};
  # Shared LSP packages from this flake
  lspPkgs = import ../../../lib/lsp.nix { pkgs = fullPkgs; };
  # Shared formatter packages from this flake
  fmtPkgs = import ../../../lib/formatters.nix { pkgs = fullPkgs; };
  # Shared clipboard wrapper
  clipboard = import ../../../lib/clipboard.nix { pkgs = fullPkgs; };
  # Build the base opencode package
  opencode-base = callPackage ./opencode-git.nix {
    inherit models-dev;
  };
  config = fullPkgs.runCommand "opencode-config" { } ''
    mkdir -p $out/opencode
    cp ${./config/opencode.json} $out/opencode/opencode.json
  '';

  wm-eval = inputs.wrapper-manager.lib {
    pkgs = fullPkgs;
    inherit lib;
    modules = [
      {
        wrappers.opencode = {
          basePackage = opencode-base;
          # Note: opencode supports the env var 'OPENCODE_CONFIG',
          # but setting this overrides project-specific config files,
          # so we will set XDG_CONFIG_HOME to the store path instead.
          env = {
            XDG_CONFIG_HOME = {
              value = "${config}";
              force = true;
            };
          };
          # Share LSP + formatter packages
          extraPackages =
            lspPkgs
            ++ fmtPkgs
            ++ [
              clipboard
              config
            ];
        };
      }
    ];
  };
in
wm-eval.config.wrappers.opencode.wrapped
