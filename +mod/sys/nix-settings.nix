{ self, lib, ... }:
let
  nixosModule =
    {
      pkgs,
      config,
      ...
    }:
    {
      nix = {
        optimise.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
        gc = pkgs.lib.optionalAttrs config.nix.enable {
          automatic = true;
          options = "--delete-older-than 7d";
        };
        channel.enable = false;
      };
      nixpkgs = {
        config.allowUnfree = true;
        overlays = lib.attrValues self.overlays;
      };
    };
in
{
  autix.aspects.nix-settings = {
    description = "Shared Nix daemon and nixpkgs defaults.";
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.nix-settings = nixosModule;
}
