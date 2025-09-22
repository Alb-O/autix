{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware
      ];
      networking.hostName = "desktop";
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    };
}
