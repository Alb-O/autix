{ lib, ... }:
{
  # The nixos-wsl module is provided through the wsl aspect
  # No need to import it here - it's automatically included for the "wsl" target

  wsl = {
    enable = true;
    defaultUser = "albert";
    startMenuLaunchers = false;
    wslConf.interop.appendWindowsPath = false;
  };

  networking.hostName = "wsl";

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  services.openssh.enable = lib.mkForce false;
  services.xserver.enable = lib.mkForce false;
  services.displayManager.enable = lib.mkForce false;

  programs.nix-ld.enable = true;
}
