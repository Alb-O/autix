{ self, lib, ... }:
let
  nixosModule =
    { pkgs
    , config
    , ...
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
  flake.aspects.nix-settings = {
    description = "Shared Nix daemon and nixpkgs defaults.";
    nixos = nixosModule;
  };
}
