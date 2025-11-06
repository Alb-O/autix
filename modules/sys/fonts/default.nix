{ lib, ... }:
let
  inherit (lib) mkOption types;

  mkFontBundle =
    pkgs:
    let
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
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
        fira-sans
        roboto
      ];
    in
    {
      inherit
        mono
        packages
        ;
    };

  hmModule =
    { pkgs
    , config
    , lib
    , ...
    }:
    let
      cfg = config.autix.fonts;
      inherit (lib) mkDefault;
    in
    {
      config = {
        home.packages = cfg.packages;
        autix = {
          fonts = mkDefault (mkFontBundle pkgs);
        };
      };
    };

  nixosModule =
    { pkgs, config, ... }:
    let
      cfg = config.autix.fonts;
      inherit (lib) mkDefault;
    in
    {
      config = {
        fonts.packages = cfg.packages;
        autix = {
          fonts = mkDefault (mkFontBundle pkgs);
        };
      };
    };
  # Top-level options module exported so option normalization happens
  optionsModule = {
    options.autix.fonts = mkOption {
      type = types.attrs;
      default = { };
      description = "autix font bundle available to aspects.";
    };
  };
in
{
  autix.aspects.fonts = {
    description = "Shared font bundle and defaults.";
    home = {
      targets = [ "*" ];
      modules = [
        optionsModule
        hmModule
      ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [
        optionsModule
        nixosModule
      ];
    };
  };
}
