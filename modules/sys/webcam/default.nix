_:
let
  packages =
    pkgs: with pkgs; [
      v4l-utils # Video4Linux utilities (v4l2-ctl, etc.)
      usbutils # USB utilities (lsusb)
      ffmpeg
    ];

  hmModule =
    { pkgs, ... }:
    {
      home.packages = packages pkgs;
    };

  nixosModule =
    { pkgs, ... }:
    {
      environment.systemPackages = packages pkgs;
    };
in
{
  autix.aspects.webcam = {
    description = "Webcam and camera support utilities.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
