{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  linux =
    system: name:
    nixosSystem {
      inherit system;
      modules = [
        inputs.self.modules.nixos.nixos
        (import ../../hosts/${name}/configuration.nix)
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
