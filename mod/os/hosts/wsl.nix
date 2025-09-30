{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    paths = [
      [ "base" "locale" "wsl" ]
      [ "base" "user" ]
    ];
    extraModules = [ modules.wsl ];
  };
}
