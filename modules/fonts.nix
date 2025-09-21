{
  flake.modules.nixos.fonts =
    { pkgs, ... }:
    let
      fontDefs = rec {
        mono = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
          size = {
            small = 11;
            normal = 13;
            large = 15;
          };
        };

        sansSerif = {
          name = "Fira Sans";
          package = pkgs.fira-sans;
          size = {
            small = 11;
            normal = 12;
            large = 14;
          };
        };

        serif = {
          name = "Crimson Pro";
          package = pkgs.crimson-pro;
          size = {
            small = 12;
            normal = 13;
            large = 15;
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
        ];

        defaultFonts = {
          monospace = [ mono.name ];
          sansSerif = [
            sansSerif.name
            "Inter"
          ];
          serif = [ serif.name ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    in
    {
      fonts.packages = fontDefs.packages;

      fonts.fontconfig = {
        enable = true;
        defaultFonts = fontDefs.defaultFonts;
      };
    };
}
