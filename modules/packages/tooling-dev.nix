{ lib, ... }:
let
  packages =
    pkgs: with pkgs; [
      gcc
      go
      gofumpt
      gnumake
      marksman
      nil
      nodejs_22
      nixfmt-rfc-style
      prettier
      rust-analyzer
      rustfmt
      shfmt
      stylua
      tailwindcss-language-server
      typescript-language-server
      vscode-langservers-extracted
    ];

  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (packages pkgs);
    };

  moduleArgs = {
    autixPackages = {
      tooling = {
        dev = packages;
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.tooling-dev-bundle = pkgs.symlinkJoin {
        name = "autix-tooling-dev";
        paths = packages pkgs;
      };
    };
in
{
  autix.home.modules."tooling-dev" = hmModule;

  inherit perSystem;

  _module.args = moduleArgs;
}
