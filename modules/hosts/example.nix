{
  flake.modules.nixos.example = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    boot.loader.grub.device = "/dev/sda";
  };
}
