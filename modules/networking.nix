{ lib, ... }:
{
  flake.modules.nixos.networking = {
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;
  };
}
