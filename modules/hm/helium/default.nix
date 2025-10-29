{ inputs, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.helium-browser.packages."${pkgs.system}".helium
      ];
    };
in
{
  flake-file = {
    inputs.helium-browser = {
      url = "github:ominit/helium-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.helium =
    _:
    {
      description = "Helium Browser Flake";
      home = {
        targets = [ "albert-desktop" ];
        modules = [ hmModule ];
      };
    };
}
