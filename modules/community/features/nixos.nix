{ inputs, ... }:
{
  flake.modules.nixos.nixos.imports = [
    inputs.self.modules.nixos.bootable
    inputs.self.modules.nixos.nix-settings
  ];
}
