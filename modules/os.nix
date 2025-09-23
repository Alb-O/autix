{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  desktopLinux =
    system: name:
    nixosSystem {
      inherit system;
      modules = with inputs.self.modules.nixos; [
        i18n
        nix-settings
        essential-pkgs
        display-manager
        ssh
        fonts
        albert

        inputs.self.modules.nixos.${name}
        {
          networking.hostName = name;
          nixpkgs.hostPlatform = system;
          system.stateVersion = "24.11";
          security.sudo.wheelNeedsPassword = false;
        }
      ];
    };
in
{
  flake.nixosConfigurations = {
    desktop = desktopLinux "x86_64-linux" "desktop";
  };
}
