{ inputs, lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      home.packages =
        with pkgs;
        lib.mkAfter [
          sops
          inputs.sops-nix.packages.${pkgs.system}.default
        ];
    };

  nixosModule = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
  };
in
{
  flake-file = {
    inputs = {
      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.sops-nix = {
    description = "Atomic secret provisioning for NixOS based on sops.";
    overlays.sops-nix = inputs.sops-nix.overlays.default;
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
