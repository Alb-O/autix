_: {
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware
      ];
      networking.hostName = "desktop";
      environment.systemPackages = with pkgs; [
        lm_sensors
        inxi
        lshw
        pciutils
        virtualglLib
      ];
    };
}
