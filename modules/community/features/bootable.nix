{

  flake.modules.nixos.bootable =
    { lib, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";

      services.xserver.enable = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      networking.useDHCP = lib.mkDefault true;
    };

}
