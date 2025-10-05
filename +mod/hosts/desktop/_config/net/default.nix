{ lib, ... }:
{
  networking = {
    hostName = "desktop";
    networkmanager.enable = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;
    useDHCP = lib.mkDefault true;
  };
}
