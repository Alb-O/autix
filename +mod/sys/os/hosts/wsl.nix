{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    extraModules = [ modules.wsl ];
  };
}
