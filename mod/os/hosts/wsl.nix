{ ... }:
{
  config.autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    layers = [ "base" "locale" "user" "wsl" ];
  };
}
