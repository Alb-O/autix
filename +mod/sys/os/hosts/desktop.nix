{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.hosts.desktop = {
    system = "x86_64-linux";
    profile = "albert-desktop";
    extraModules = [ modules.desktop ];
  };
}
