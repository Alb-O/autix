{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware/desktop.nix
        ./_hardware/gpu/nvidia.nix
        ./_hardware/thermal/fancontrol.nix
      ];
      networking.hostName = "desktop";
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    };
}
