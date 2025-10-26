_:
let
  mkFontBundle =
    pkgs:
    let
      families = {
        mono = {
          name = "JetBrains Mono NL";
          package = pkgs.jetbrains-mono;
          style = "ExtraLight";
          sizes = {
            small = 14;
            normal = 16;
            large = 18;
          };
        };

        sans = {
          name = "Fira Sans";
          package = pkgs.fira-sans;
          style = "Regular";
          sizes = {
            small = 14;
            normal = 16;
            large = 18;
          };
        };

        serif = {
          name = "Crimson Pro";
          package = pkgs.crimson-pro;
          style = "Regular";
          sizes = {
            small = 14;
            normal = 16;
            large = 18;
          };
        };
      };

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        nerd-fonts.jetbrains-mono
        inter
        crimson-pro
        fira-sans
        roboto
      ];

      defaults = {
        monospace = [ families.mono.name ];
        sansSerif = [
          families.sans.name
          "Inter"
        ];
        serif = [ families.serif.name ];
        emoji = [ "Noto Color Emoji" ];
      };

      roles = {
        terminal = {
          family = families.mono;
          size = families.mono.sizes.normal;
        };
        terminalCompact = {
          family = families.mono;
          size = families.mono.sizes.small;
        };
        notifications = {
          family = families.sans;
          size = families.sans.sizes.normal;
        };
        displayManager = {
          family = families.mono;
          size = families.mono.sizes.large;
        };
        ui = {
          family = families.sans;
          size = families.sans.sizes.normal;
        };
      };
    in
    {
      inherit
        families
        packages
        defaults
        roles
        ;
    };

  hmModule =
    { pkgs, ... }:
    let
      bundle = mkFontBundle pkgs;
    in
    {
      home.packages = bundle.packages;
      fonts.fontconfig = {
        enable = true;
        defaultFonts = bundle.defaults;
      };
      _module.args.fontBundle = bundle;
    };

  nixosModule =
    { pkgs, ... }:
    let
      bundle = mkFontBundle pkgs;
    in
    {
      fonts.packages = bundle.packages;
      fonts.fontconfig = {
        enable = true;
        defaultFonts = bundle.defaults;
      };
      _module.args.fontBundle = bundle;
    };
in
{
  flake.aspects.fonts = {
    description = "Shared font bundle and defaults.";
    homeManager = hmModule;
    nixos = nixosModule;
  };
}
