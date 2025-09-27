{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (
        with pkgs;
        [
          nodejs_22
          gcc
          gnumake
          prettier
          nixfmt-rfc-style
          rustfmt
          go
          gofumpt
          shfmt
          stylua
          typescript-language-server
          vscode-langservers-extracted
          marksman
          tailwindcss-language-server
          rust-analyzer
          nil
        ]
      );
    };

  autix = {
    home.modules."tooling-dev" = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
