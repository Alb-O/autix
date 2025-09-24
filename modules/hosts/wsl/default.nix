{ lib, inputs, ... }:
{
  flake.modules.nixos.wsl = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

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
  };
}
