{
  flake.modules.nixos.essential-pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # Text editors
        vim
        nano

        # Git
        git

        # Network tools
        curl
        wget

        # Development tools
        just
        jq

        # The 'just accidently booted into niri with no config' start pack
        firefox
        alacritty
      ];
    };

  flake.modules.homeManager.essential-pkgs =
    { ... }:
    {
      home.packages = [
        # Additional user-space tools can go here
        # These tools are available per-user rather than system-wide
      ];
    };

  # Expose a package bundle for this aspect
  perSystem =
    { pkgs, ... }:
    {
      packages.essential-pkgs-bundle = pkgs.symlinkJoin {
        name = "essential-pkgs";
        paths = with pkgs; [
          vim
          nano
          git
          curl
          wget
          just
          jq
          firefox
          alacritty
        ];
      };
    };
}
