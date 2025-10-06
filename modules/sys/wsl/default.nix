{ inputs, ... }:
let
  nixosWslModule = inputs.nixos-wsl.nixosModules.default;
in
{
  autix.aspects.wsl = {
    description = "NixOS-WSL integration for Windows Subsystem for Linux.";
    nixos = {
      targets = [ "wsl" ];
      modules = [ nixosWslModule ];
    };
  };
}
