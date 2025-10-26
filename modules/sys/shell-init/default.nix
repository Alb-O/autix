_:
let
  nixosModule =
    { pkgs, ... }:
    {
      environment.interactiveShellInit = ''
        if [ -z "''${XDG_STATE_HOME:-}" ]; then
          export XDG_STATE_HOME="$HOME/.local/state"
        fi
        export HISTFILE="$XDG_STATE_HOME/bash/history"
        mkdir -p "$(dirname "$HISTFILE")"
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
in
{
  flake.aspects.shell-init = {
    description = "Ensure login shells hand over to fish with XDG-aware history.";
    nixos = nixosModule;
  };
}
