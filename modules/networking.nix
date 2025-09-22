{ lib, ... }:
{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager.enable = lib.mkDefault true;
      # Keep a permissive default firewall that aspects can extend later.
      firewall.enable = lib.mkDefault true;
    };
  };

  flake.modules.homeManager.networking = {
    home.sessionVariables = {
      BROWSER = lib.mkDefault "firefox";
    };
  };
}
