_:
let
  nixosModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nfs-utils
        cifs-utils
      ];
    };
in
{
  autix.aspects.netshare = {
    description = "NFS/CIFS client tooling.";
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.netshare = nixosModule;
}
