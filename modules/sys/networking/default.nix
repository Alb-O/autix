{ lib, ... }:
let
  hmModule = _: {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };

  nixosModule = _: {
    networking = {
      networkmanager.enable = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
    };
  };
in
{
  flake.aspects.networking = {
    description = "Networking defaults for NetworkManager.";
    homeManager = hmModule;
    nixos = nixosModule;
  };

  flake = {
    nixosModules.networking = nixosModule;
  };
}
