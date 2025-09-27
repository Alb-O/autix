{ lib, ... }:
let
  hmModule = _: {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };

  autix = {
    home.modules.networking = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;

    nixosModules.networking = {
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };
  };
in
{
  inherit autix flake;
}
