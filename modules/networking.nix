{ lib, ... }:
let
  hmModule = _: {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };
in
{
  config = {
    flake.modules.nixos.networking = {
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };

    flake.modules.homeManager.networking = hmModule;
    autix.home.modules.networking = hmModule;
  };
}
