set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

user := env_var_or_default('USER', 'unknown')
hostname := env_var_or_default('HOSTNAME', 'unknown')
home_default := `nix eval --json path:.#homeConfigurations --apply builtins.attrNames 2>/dev/null | jq -r '.[0]'`


# Lists available recipes
default:
    @just --list


# ================================
# SYSTEM - NixOS configuration
# ================================

# Rebuilds and switches NixOS system for specified host
system-rebuild host="desktop":
    sudo -E nixos-rebuild switch --flake path:.#{{host}}

# Tests NixOS system build for specified host
system-test host="desktop":
    sudo -E nixos-rebuild test --flake path:.#{{host}}

# Builds NixOS system for specified host
system-build host="desktop":
    sudo -E nixos-rebuild build --flake path:.#{{host}}

# Rebuilds NixOS system with verbose output for specified host
system-rebuild-verbose host="desktop":
    sudo -E nixos-rebuild switch --flake path:.#{{host}} --show-trace --verbose

# Lists NixOS system generations
system-generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Boots to a specific NixOS system generation
system-boot-generation gen:
    sudo nixos-rebuild switch --rollback --generation {{gen}}

# Builds ISO image for specified host
system-iso host="desktop":
    nix build path:.#nixosConfigurations.{{host}}.config.system.build.isoImage

# Builds WSL toplevel for WSL host
system-wsl:
    nix build path:.#nixosConfigurations.wsl.config.system.build.toplevel


# =====================================
# HOME - Home Manager configuration
# =====================================

# Switches Home Manager configuration for specified target
home-switch target=home_default:
    TARGET="{{target}}"; \
    if ! nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
      | jq -e --arg t "$TARGET" '.[] | select(. == $t)' >/dev/null; then \
      echo "Unknown home target '$TARGET'. Available:" >&2; \
      nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
        | jq -r '.[]' | sed 's/^/  /' >&2; \
      exit 1; \
    fi; \
    if command -v home-manager >/dev/null 2>&1; then \
      home-manager switch --flake "path:.#${TARGET}" --impure; \
    else \
      nix run .#home-manager -- switch --flake "path:.#${TARGET}" --impure; \
    fi

# Builds Home Manager configuration for specified target
home-build target=home_default:
    TARGET="{{target}}"; \
    if ! nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
      | jq -e --arg t "$TARGET" '.[] | select(. == $t)' >/dev/null; then \
      echo "Unknown home target '$TARGET'. Available:" >&2; \
      nix eval --json path:.#homeConfigurations --apply builtins.attrNames \
        | jq -r '.[]' | sed 's/^/  /' >&2; \
      exit 1; \
    fi; \
    if command -v home-manager >/dev/null 2>&1; then \
      home-manager build --flake "path:.#${TARGET}" --impure; \
    else \
      nix run .#home-manager -- build --flake "path:.#${TARGET}" --impure; \
    fi

# Switches to WSL-specific Home Manager configuration
home-switch-wsl:
    just home-switch albert-wsl


# ================================
# SHARED - Dev helpers
# ================================

# Formats source tree with treefmt
fmt:
    nix run .#fmt

# Regenerates derived files (README, etc.) and formats the tree
regen:
    nix run .#write-files
    nix fmt

# Full QA: regenerate, format, then run flake checks without mutating the lock file
check:
    just regen
    nix flake check --no-update-lock-file

# Regenerates flake.nix via flake-file
write-flake:
    nix run .#write-flake

# Updates all flake inputs
update:
    nix flake update

# Updates a specific flake input
update-input input:
    nix flake update {{input}}

# Shows flake outputs and configurations
show:
    nix flake show path:.

# Enters development shell
dev:
    nix develop

# Cleans build artifacts and result directories
clean:
    rm -rf result result-* || true; \
    [ -d hm ] && (cd hm && rm -rf result result-*) || true

# Runs garbage collection for Nix store
gc:
    sudo nix-collect-garbage -d; \
    nix-collect-garbage -d


# ================================
# GIT-SPARTA - Submodule tooling
# ================================

# Run git-sparta with arbitrary arguments
sparta-run *ARGS:
    nix run .#git-sparta -- {{ARGS}}

# Build the git-sparta package
sparta-build:
    nix build .#git-sparta

# Interactive sparse pattern search for a tag (defaults to current repo)
sparta-tags tag repo="." yes="false" theme="":
    args=(generate-sparse-list "{{tag}}")
    if [ "{{repo}}" != "." ]; then args+=("--repo" "{{repo}}"); fi
    if [ "{{yes}}" = "true" ]; then args+=("--yes"); fi
    if [ -n "{{theme}}" ]; then args+=(--theme "{{theme}}"); fi
    nix run .#git-sparta -- "${args[@]}"

# Configure a sparse-tagged submodule
sparta-setup config="." yes="false" theme="":
    args=(setup-submodule)
    if [ "{{config}}" != "." ]; then args+=("--config-dir" "{{config}}"); fi
    if [ "{{yes}}" = "true" ]; then args+=("--yes"); fi
    if [ -n "{{theme}}" ]; then args+=(--theme "{{theme}}"); fi
    nix run .#git-sparta -- "${args[@]}"

# Tear down a sparse-tagged submodule
sparta-teardown config="." yes="false" theme="":
    args=(teardown-submodule)
    if [ "{{config}}" != "." ]; then args+=("--config-dir" "{{config}}"); fi
    if [ "{{yes}}" = "true" ]; then args+=("--yes"); fi
    if [ -n "{{theme}}" ]; then args+=(--theme "{{theme}}"); fi
    nix run .#git-sparta -- "${args[@]}"


# ================================
# Aliases
# ================================
# Aliases for common commands
alias rebuild := system-rebuild
alias switch := home-switch
