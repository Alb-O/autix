set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

user := env_var_or_default('USER', 'unknown')
hostname := env_var_or_default('HOSTNAME', 'unknown')
home_default := `nix eval --json path:.#homeConfigurations --apply builtins.attrNames 2>/dev/null | jq -r '.[0]'`


default:
    @just --list


# ================================
# SYSTEM - NixOS configuration
# ================================

system-rebuild host="desktop":
    echo "Rebuilding system for host: {{host}}"; \
    sudo -E nixos-rebuild switch --flake path:.#{{host}}

system-test host="desktop":
    sudo -E nixos-rebuild test --flake path:.#{{host}}

system-build host="desktop":
    sudo -E nixos-rebuild build --flake path:.#{{host}}

system-rebuild-verbose host="desktop":
    sudo -E nixos-rebuild switch --flake path:.#{{host}} --show-trace --verbose

system-generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

system-boot-generation gen:
    sudo nixos-rebuild switch --rollback --generation {{gen}}

system-iso host="desktop":
    nix build path:.#nixosConfigurations.{{host}}.config.system.build.isoImage

system-wsl:
    nix build path:.#nixosConfigurations.wsl.config.system.build.toplevel


# =====================================
# HOME - Home Manager configuration
# =====================================

home-switch target=home_default:
    TARGET="{{target}}"; \
    if ! nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
      | jq -e --arg t "$TARGET" '.[] | select(. == $t)' >/dev/null; then \
      echo "Unknown home target '$TARGET'. Available:" >&2; \
      nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
        | jq -r '.[]' | sed 's/^/  /' >&2; \
      exit 1; \
    fi; \
    nix run github:nix-community/home-manager/master -- switch --flake "path:.#${TARGET}" --impure

home-build target=home_default:
    TARGET="{{target}}"; \
    if ! nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
      | jq -e --arg t "$TARGET" '.[] | select(. == $t)' >/dev/null; then \
      echo "Unknown home target '$TARGET'. Available:" >&2; \
      nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
        | jq -r '.[]' | sed 's/^/  /' >&2; \
      exit 1; \
    fi; \
    nix run github:nix-community/home-manager/master -- build --flake "path:.#${TARGET}" --impure

home-switch-wsl:
    just home-switch target=albert-wsl


# ================================
# SHARED - Dev helpers
# ================================

fmt:
    nix run .#fmt

update:
    nix flake update

update-input input:
    nix flake update {{input}}

show:
    nix flake show path:.

dev:
    nix develop

clean:
    rm -rf result result-* || true; \
    [ -d hm ] && (cd hm && rm -rf result result-*) || true

gc:
    sudo nix-collect-garbage -d; \
    nix-collect-garbage -d


# ================================
# Aliases
# ================================
alias rebuild := system-rebuild
alias switch := home-switch
