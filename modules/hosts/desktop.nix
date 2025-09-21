{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [ ./_hardware/desktop.nix ];
      networking.hostName = "desktop";
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    };
}
