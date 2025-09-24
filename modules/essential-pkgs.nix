_:
let
  essentialPackages =
    pkgs: with pkgs; [
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
      mprocs

      # The 'just accidently booted into niri with no config' start pack
      firefox
      alacritty

      # xdg-terminal
      (pkgs.writeShellApplication {
        name = "xdg-terminal";
        text = ''
          set -euo pipefail

          term="''${TERMINAL:-}"
          if [[ -n "$term" ]]; then
            exec "$term" "$@"
          fi

          for cmd in kitty wezterm alacritty foot gnome-terminal konsole xterm; do
            if command -v "$cmd" >/dev/null 2>&1; then
              exec "$cmd" "$@"
            fi
          done

          echo "xdg-terminal: no terminal emulator found (set $TERMINAL)" >&2
          exit 1
        '';
      })

      # wget wrapper with HSTS file location changed
      (pkgs.writeShellApplication {
        name = "wget";
        text = ''
          data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
          exec -a "$0" "${pkgs.wget}/bin/wget" --hsts-file="$data_home/wget-hsts" "$@"
        '';
      })
    ];

  hmModule =
    { pkgs, lib, ... }:
    {
      home.packages = lib.mkDefault (essentialPackages pkgs);
    };
in
{
  config = {
    flake.nixosModules."essential-pkgs" =
      { pkgs, ... }:
      {
        environment.systemPackages = essentialPackages pkgs;
      };

    flake.modules.homeManager."essential-pkgs" = hmModule;
    autix.home.modules."essential-pkgs" = hmModule;
    _module.args.autixPackages = {
      essential = essentialPackages;
    };
    perSystem =
      { pkgs, ... }:
      {
        packages.essential-pkgs-bundle = pkgs.symlinkJoin {
          name = "essential-pkgs";
          paths = essentialPackages pkgs;
        };
      };
  };
}
