{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  linux =
    system: name:
    nixosSystem {
      inherit system;
      modules = [
        inputs.self.modules.nixos.boot
        inputs.self.modules.nixos.networking
        inputs.self.modules.nixos.i18n
        inputs.self.modules.nixos.nix-settings
        inputs.self.modules.nixos.system-packages
        inputs.self.modules.nixos.${name}
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
    example = linux "x86_64-linux" "example";
  };
}
