{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  users.users.example = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  boot.loader.grub.device = "/dev/sda";
}
