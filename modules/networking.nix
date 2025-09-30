{ lib, ... }:
let
  hmModule = _: {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };
in
{
  autix.home.modules.networking = hmModule;

  flake = {
    nixosModules.networking = {
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };
  };
}
