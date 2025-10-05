_:
let
  desktopModule = {
    imports = [
      ./_config
    ];
  };
in
{
  autix.os.hosts.desktop = {
    system = "x86_64-linux";
    profile = "albert-desktop";
    extraModules = [ desktopModule ];
  };
}
