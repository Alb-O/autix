{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  desktopLinux =
    system: name:
    nixosSystem {
      inherit system;
      modules = with inputs.self.modules.nixos; [
        boot
        networking
        i18n
        nix-settings
        essential-pkgs
        graphics
        display-manager
        thermal
        ssh
        fonts

        inputs.self.modules.nixos.${name}
        {
          networking.hostName = name;
          nixpkgs.hostPlatform = system;
          system.stateVersion = "24.11";
        }
      ];
    };
in
{
  flake.nixosConfigurations = {
    desktop = desktopLinux "x86_64-linux" "desktop";
  };
}
