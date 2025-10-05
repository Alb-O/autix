{ inputs, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = inputs.zed-flake.packages.${pkgs.system}.default;
      };
    };
in
{
  flake-file = {
    inputs = {
      zed-flake.url = "github:zed-industries/zed";
      zed-flake.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.zed = {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter.";
    overlays.zed = inputs.zed-flake.overlays.default;
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
      substituters = [
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      trustedPublicKeys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}
