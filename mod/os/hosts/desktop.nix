{ ... }:
{
  config.autix.os.hosts.desktop = {
    system = "x86_64-linux";
    profile = "albert-desktop";
    layers = [ "base" "locale" "graphical" "user" ];
  };
}
