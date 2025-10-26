{
  imports = [
    ./boot
    ./cpu
    ./fs
    ./gpu
    ./kernel
    ./net
    ./env
    ./fans
  ];
  system.stateVersion = "24.11";
  security.sudo.wheelNeedsPassword = false;
}
