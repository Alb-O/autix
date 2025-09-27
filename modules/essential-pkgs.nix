_:
let
  essentialPackages =
    pkgs: with pkgs; [
      vim
      nano
      git
      curl
      wget
      just
      jq
      mprocs
      firefox
      alacritty
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

  autix = {
    home.modules."essential-pkgs" = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;

    nixosModules."essential-pkgs" =
      { pkgs, ... }:
      {
        environment.systemPackages = essentialPackages pkgs;
      };
  };

  moduleArgs = {
    autixPackages = {
      essential = essentialPackages;
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.essential-pkgs-bundle = pkgs.symlinkJoin {
        name = "essential-pkgs";
        paths = essentialPackages pkgs;
      };
    };
in
{
  inherit autix flake perSystem;
  _module.args = moduleArgs;
}
