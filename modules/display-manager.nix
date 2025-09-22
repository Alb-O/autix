_: {
  flake.modules.nixos.display-manager =
    { pkgs, ... }:
    let
      fonts = {
        mono = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
          size = {
            small = 11;
            normal = 13;
            large = 15;
          };
        };
      };
    in
    {
      environment.systemPackages = [
        pkgs.inxi
        pkgs.lshw
        pkgs.pciutils
        pkgs.virtualglLib
      ];

      services.displayManager = {
        enable = true;
        ly = {
          enable = true;
          settings = {
            animation = "matrix";
          };
        };
      };

      services.kmscon = {
        enable = true;
        fonts = [
          {
            inherit (fonts.mono) name;
            inherit (fonts.mono) package;
          }
        ];
        extraConfig = "font-size=${toString fonts.mono.size.large}";
      };

      programs.dconf.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
