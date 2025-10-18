_:
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
      home.packages = packages pkgs;
    };
in
{
  autix.aspects.dev = {
    description = "Development language servers and toolchain bundle.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
