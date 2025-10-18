{ inputs, ... }:
let
  nixosWslModule = inputs.nixos-wsl.nixosModules.default;

  # NixOS configuration for WSL
  nixosModule =
    { lib, ... }:
    {
      imports = [ nixosWslModule ];

      wsl = {
        enable = true;
        startMenuLaunchers = false;
        wslConf.interop.appendWindowsPath = false;
      };

      # Disable unnecessary services for WSL
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub.enable = lib.mkForce false;
      services.openssh.enable = lib.mkForce false;
      services.xserver.enable = lib.mkForce false;
      services.displayManager.enable = lib.mkForce false;

      # Enable nix-ld for binary compatibility
      programs.nix-ld.enable = true;
    };

  # Home Manager configuration for WSL
  hmModule =
    { lib, pkgs, ... }:
    {
      home.packages = [ pkgs.wslu ];

      home.sessionVariables = {
        WSLENV = lib.mkDefault "NIX_PATH/u";
        BROWSER = lib.mkForce "wslview";
      };

      home.shellAliases = {
        open = "wslview";
      };
    };
in
{
  flake-file = {
    inputs = {
      nixos-wsl.url = "github:nix-community/NixOS-WSL";
      nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  autix.aspects.wsl = {
    description = "NixOS-WSL integration for Windows Subsystem for Linux.";
    home = {
      targets = [ "albert-wsl" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "wsl" ];
      modules = [ nixosModule ];
    };
  };
}
