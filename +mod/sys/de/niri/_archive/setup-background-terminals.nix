pkgs:
let
  kittyWrapped = import ../kitty pkgs;
in
pkgs.writeShellApplication {
  name = "setup-background-terminals";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.niri
    kittyWrapped
  ];
  text = ''
    set -euo pipefail

    readarray -t monitors < <(${pkgs.niri}/bin/niri msg outputs \
      | grep "^Output " \
      | sed 's/.*(\(.*\))/\1/' \
      | sort -u)

    if [ ''${#monitors[@]} -eq 0 ]; then
      echo "setup-background-terminals: no monitors reported by niri; skipping" >&2
      exit 0
    fi

    instance_group="''${KITTY_WRAPPER_INSTANCE_GROUP:-niri-background-panels}"

    if [ -n "''${KITTY_BACKGROUND_CMD:-}" ]; then
      set -- /bin/sh -c "''${KITTY_BACKGROUND_CMD}"
    else
      set -- "''${SHELL:-/bin/sh}" -l
    fi

    for monitor in "''${monitors[@]}"; do
      KITTY_WRAPPER_INSTANCE_GROUP="$instance_group" \
      ${kittyWrapped}/bin/kitty +kitten panel \
        --output-name "$monitor" \
        --focus-policy=exclusive \
        --edge=background \
        --detach \
        -- "$@"
    done

    wait || true
  '';
}
