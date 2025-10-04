{ lib, ... }:
let
  hmModule = _: {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };

  nixosModule =
    _:
    {
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };
in
{
  autix.aspects.networking = {
    description = "Networking defaults for NetworkManager.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake = {
    nixosModules.networking = nixosModule;
  };
}
