{ lib, ... }:
let
  inherit (lib) mkOption types;

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
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.autix.fonts;
    in
    {
      options.autix.fonts = mkOption {
        type = types.attrs;
        default = mkFontBundle pkgs;
        description = "autix font bundle available to home aspects.";
      };

      config = {
        home.packages = lib.mkAfter cfg.packages;

        fonts.fontconfig = {
          enable = true;
          defaultFonts = cfg.defaults;
        };
      };
    };
in
{
  autix.home.modules.fonts = hmModule;

  flake.nixosModules.fonts =
    { pkgs, config, ... }:
    let
      cfg = config.autix.fonts;
    in
    {
      options.autix.fonts = mkOption {
        type = types.attrs;
        default = mkFontBundle pkgs;
        description = "autix font bundle available to NixOS aspects.";
      };

      config = {
        fonts.packages = cfg.packages;

        fonts.fontconfig = {
          enable = true;
          defaultFonts = cfg.defaults;
        };
      };
    };
}
