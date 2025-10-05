_:
let
  wslModule = {
    imports = [ ./_config ];
  };
in
{
  autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    extraModules = [ wslModule ];
  };
}
