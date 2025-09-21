{ lib, ... }:
{
  flake.modules.nixos.boot = _: {
    boot.loader = {
      # Use Limine as primary bootloader, systemd-boot as fallback
      systemd-boot.enable = lib.mkDefault false;
      limine.enable = lib.mkDefault true;
      limine.extraConfig = lib.mkDefault "timeout: 0";
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    # Filesystem support
    boot.supportedFilesystems = lib.mkDefault [ "ntfs" ];

    # Kernel configuration
    boot.kernelParams = lib.mkDefault [ "usbcore.autosuspend=-1" ];
  };
}
