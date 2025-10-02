_:
{
  flake.nixosModules.netshare =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nfs-utils
        cifs-utils
      ];
    };
}
