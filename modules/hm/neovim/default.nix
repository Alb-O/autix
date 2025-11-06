{ inputs, ... }:
let
  hmModule =
    { lib, pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      };
    };
in
{
  flake-file = {
    inputs.neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.neovim = {
    description = "Neovim editor configuration and plugins.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
