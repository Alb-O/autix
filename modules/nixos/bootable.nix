{
  flake.modules.nixos.bootable =
    { lib, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";

      networking.useDHCP = lib.mkDefault true;
    };
}
