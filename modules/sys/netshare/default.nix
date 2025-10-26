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
  flake.aspects.netshare = {
    description = "NFS/CIFS client tooling.";
    nixos = nixosModule;
  };
}
