_:
let
  hmModule =
    { lib, pkgs, ... }:
    let
      nh = pkgs.writeShellScriptBin "nh" ''
            set -euo pipefail
            usage() {
              cat >&2 <<'EOF'
        nh — nohup helper

        Usage:
          nh [--help|-h]
          nh <cmd> [args...]          Start <cmd> under nohup and log output
          nh tail <cmd>               Tail the latest log for <cmd>
          nh log <cmd>                Print the latest log path for <cmd>
          nh ps [cmd]                 List tracked PIDs (all or for <cmd>)
          nh kill <cmd>|<pid>         Send SIGTERM to PID(s) for <cmd> or a PID
          nh clean [cmd]              Remove stale PID files (all or for <cmd>)
          nh prune-logs <days> [cmd]  Delete logs older than <days> (all or for <cmd>)

        Logs:
          $XDG_STATE_HOME/nh/<cmd>/YYYYMMDD.out (fallback: $HOME/.local/state)
        EOF
            }

            if [ "$#" -lt 1 ]; then
              usage
              exit 2
            fi

            state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"

            # help flag
            if [ "''${1-}" = "-h" ] || [ "''${1-}" = "--help" ]; then
              usage
              exit 0
            fi

            # helper: compute latest log path for a command
            latest_log() {
              local cmd="$1"
              local outdir="$state_home/nh/$cmd"
              local latest
              latest=$(${pkgs.coreutils}/bin/ls -1 "$outdir"/*.out 2>/dev/null | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/tail -n 1 || true)
              [ -n "$latest" ] && printf '%s' "$latest" || return 1
            }

            if [ "$1" = "tail" ] || [ "$1" = "t" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "nh: missing <cmd> for tail" >&2
                usage
                exit 2
              fi
              cmd="$1"; shift || true
              outdir="$state_home/nh/$cmd"
              latest=""
              latest=$(latest_log "$cmd" || true)
              if [ -z "$latest" ]; then
                echo "nh: no logs for '$cmd' in $outdir" >&2
                exit 1
              fi
              echo "nh: tailing $latest" >&2
              exec ${pkgs.coreutils}/bin/tail -n 100 -f "$latest"
            fi

            # log subcommand (print latest log path)
            if [ "$1" = "log" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "nh: missing <cmd> for log" >&2
                usage
                exit 2
              fi
              cmd="$1"; shift || true
              outdir="$state_home/nh/$cmd"
              latest=""
              latest=$(latest_log "$cmd" || true)
              if [ -z "$latest" ]; then
                echo "nh: no logs for '$cmd' in $outdir" >&2
                exit 1
              fi
              printf '%s\n' "$latest"
              exit 0
            fi

            # ps subcommand (list managed PIDs)
            if [ "$1" = "ps" ]; then
              shift || true
              list_one() {
                local cmd="$1"
                local pdir="$state_home/nh/$cmd/pids"
                if [ ! -d "$pdir" ]; then
                  return 0
                fi
                for pf in "$pdir"/*; do
                  [ -f "$pf" ] || continue
                  pid=$(${pkgs.coreutils}/bin/basename "$pf")
                  if kill -0 "$pid" 2>/dev/null; then
                    status="running"
                  else
                    status="dead"
                  fi
                  started=""
                  [ -f "$pf" ] && started=$(${pkgs.coreutils}/bin/date -r "$pf" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || true)
                  printf '%-6s  %-8s  %s\n' "$pid" "$status" "$cmd"
                done
              }
              if [ "$#" -ge 1 ]; then
                list_one "$1"
              else
                nh_root="$state_home/nh"
                [ -d "$nh_root" ] || exit 0
                for d in "$nh_root"/*; do
                  [ -d "$d" ] || continue
                  list_one "$(${pkgs.coreutils}/bin/basename "$d")"
                done
              fi
              exit 0
            fi

            # clean subcommand (remove stale pid files)
            if [ "$1" = "clean" ]; then
              shift || true
              clean_one() {
                local cmd="$1"
                local pdir="$state_home/nh/$cmd/pids"
                local cmddir="$state_home/nh/$cmd"
                local cleaned=0
                if [ -d "$pdir" ]; then
                  for pf in "$pdir"/*; do
                    [ -f "$pf" ] || continue
                    pid=$(${pkgs.coreutils}/bin/basename "$pf")
                    if ! kill -0 "$pid" 2>/dev/null; then
                      ${pkgs.coreutils}/bin/rm -f "$pf" || true
                      cleaned=$((cleaned+1))
                    fi
                  done
                  ${pkgs.coreutils}/bin/rmdir --ignore-fail-on-non-empty "$pdir" 2>/dev/null || true
                fi
                # Remove the command directory if it's empty
                ${pkgs.coreutils}/bin/rmdir --ignore-fail-on-non-empty "$cmddir" 2>/dev/null || true
                echo "nh: cleaned $cleaned stale pid files for '$cmd'" >&2
              }
              if [ "$#" -ge 1 ]; then
                cmd="$1"; shift || true
                clean_one "$cmd"
              else
                nh_root="$state_home/nh"
                [ -d "$nh_root" ] || exit 0
                for d in "$nh_root"/*; do
                  [ -d "$d" ] || continue
                  clean_one "$(${pkgs.coreutils}/bin/basename "$d")"
                done
              fi
              exit 0
            fi

            # prune-logs subcommand (delete logs older than <days>)
            if [ "$1" = "prune-logs" ]; then
              shift || true
              if [ "$#" -lt 1 ]; then
                echo "nh: missing <days> for prune-logs" >&2
                usage
                exit 2
              fi
              days="$1"; shift || true
              prune_one() {
                local cmd="$1"
                local outdir="$state_home/nh/$cmd"
                if [ -d "$outdir" ]; then
                  ${pkgs.findutils}/bin/find "$outdir" -maxdepth 1 -type f -name '*.out' -mtime "+$days" -print -delete 2>/dev/null || true
                fi
              }
              if [ "$#" -ge 1 ]; then
                prune_one "$1"
              else
                nh_root="$state_home/nh"
                [ -d "$nh_root" ] || exit 0
                for d in "$nh_root"/*; do
                  [ -d "$d" ] || continue
                  prune_one "$(${pkgs.coreutils}/bin/basename "$d")"
                done
              fi
              exit 0
            fi

            # kill subcommand (by pid or command name)
            if [ "$1" = "kill" ]; then
              shift || true
              if [ "$#" -lt 1 ]; then
                echo "nh: missing <cmd>|<pid> for kill" >&2
                usage
                exit 2
              fi
              target="$1"; shift || true
              case "$target" in
                *[!0-9]*)
                  cmd="$target"
                  pdir="$state_home/nh/$cmd/pids"
                  if [ ! -d "$pdir" ]; then
                    echo "nh: no PIDs tracked for '$cmd'" >&2
                    exit 1
                  fi
                  killed=0
                  for pf in "$pdir"/*; do
                    [ -f "$pf" ] || continue
                    pid=$(${pkgs.coreutils}/bin/basename "$pf")
                    if kill -0 "$pid" 2>/dev/null; then
                      if kill "$pid" 2>/dev/null; then
                        echo "nh: sent SIGTERM to $pid ($cmd)"
                        killed=$((killed+1))
                      fi
                    fi
                  done
                  if [ "$killed" -le 0 ]; then
                    echo "nh: no running PIDs for '$cmd'" >&2
                    exit 1
                  fi
                  exit 0
                  ;;
                *)
                  pid="$target"
                  if kill -0 "$pid" 2>/dev/null; then
                    if kill "$pid" 2>/dev/null; then
                      echo "nh: sent SIGTERM to $pid"
                      exit 0
                    else
                      echo "nh: failed to signal $pid" >&2
                      exit 1
                    fi
                  else
                    echo "nh: PID $pid not running" >&2
                    exit 1
                  fi
                  ;;
              esac
            fi

            # default: run a command under nohup with logs and pid tracking
            cmd="$1"; shift || true
            case "$cmd" in (-*) echo "nh: invalid command '$cmd' (starts with '-')" >&2; usage; exit 2 ;; esac
            if [ -x "$cmd" ]; then :; elif command -v "$cmd" >/dev/null 2>&1; then cmd=$(command -v "$cmd"); else
              echo "nh: not executable: $cmd" >&2
              if command -v "$cmd" >/dev/null 2>&1; then :; else echo "nh: command not found: $cmd" >&2; fi
              exit 127
            fi
            cmd_name=$(${pkgs.coreutils}/bin/basename "$cmd")
            outdir="$state_home/nh/$cmd_name"
            mkdir -p "$outdir" "$outdir/pids"
            ts=$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)
            outfile="$outdir/$ts.out"
            (
              nohup "$cmd" "$@" >"$outfile" 2>&1 & echo $! >"$outdir/pids/$!" && disown || true
            )
            pid=$(cat "$outdir/pids"/* | ${pkgs.coreutils}/bin/tail -n1)
            echo "nh: started '$cmd' [pid $pid], log: $outfile"
      '';
    in
    {
      home.packages = lib.mkAfter [ nh ];
    };

  autix = {
    home.modules.nh = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
