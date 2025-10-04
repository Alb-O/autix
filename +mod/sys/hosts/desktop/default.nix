_:
let
  desktopModule = {
    imports = [
      ./_conf
    ];
  };
in
{
  flake.nixosModules.desktop = desktopModule;

  autix.os.hosts.desktop = {
    system = "x86_64-linux";
    profile = "albert-desktop";
    extraModules = [ desktopModule ];
  };
}
