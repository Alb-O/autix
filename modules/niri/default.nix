{ inputs, pkgs, ... }:
{
  flake-file = {
    inputs = {
      niri-flake.url = "github:sodiboo/niri-flake";
      niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.overlays.niri = inputs.niri-flake.overlays.niri;
  flake.modules.nixos.niri = {
    programs.niri.package = pkgs.niri-stable;
    programs.niri.enable = true;
    programs.niri.config = ./config.kdl;
  };
}
