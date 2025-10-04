{ lib, inputs, ... }:
let
  wslModule = {
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

    programs.nix-ld.enable = true;
  };
in
{
  flake.nixosModules.wsl = wslModule;

  autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    extraModules = [ wslModule ];
  };
}
