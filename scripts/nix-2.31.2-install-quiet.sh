#!/bin/sh
# Quiet, non-interactive Nix 2.31.2 installer for container/root environments
# - Self-heals nixbld group/users if running as root
# - Defaults to single-user (--no-daemon)
# - Idempotent: exits early if nix is already usable
# - Quiet by default; VERBOSE=1 for logs; INSTALL_LOG=/path to capture output
# - Activates Nix in *current* shell and persists for *future* shells

set -eu

VERBOSE="${VERBOSE:-0}"
INSTALL_LOG="${INSTALL_LOG:-}"
NIX_VERSION="2.31.2"

log() { [ "$VERBOSE" = "1" ] && printf '%s\n' "$*" >&2 || :; }
oops() {
  printf '%s: %s\n' "$0" "$*" >&2
  exit 1
}
have() { command -v "$1" >/dev/null 2>&1; }

umask 0022

# ---------- Early exit if already installed & usable ----------
if have nix; then
  log "nix already on PATH: $(command -v nix)"
  exit 0
fi

# Try common single-user location quickly (avoids re-install on half-configured systems)
if [ -x "${HOME:-/root}/.nix-profile/bin/nix" ]; then
  # activate for this shell if needed
  export USER="${USER:-$(id -un 2>/dev/null || echo root)}"
  if [ -f "${HOME:-/root}/.nix-profile/etc/profile.d/nix.sh" ]; then
    # shellcheck disable=SC1090
    . "${HOME:-/root}/.nix-profile/etc/profile.d/nix.sh" || true
  fi
  if have nix; then
    log "Activated existing Nix from ${HOME:-/root}/.nix-profile"
    exit 0
  fi
fi

# ---------- Temp dir & cleanup ----------
tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX)" || oops "Cannot create temp dir"
cleanup() { rm -rf "$tmpDir"; }
trap cleanup EXIT INT QUIT TERM

# ---------- Platform matrix (Nix 2.31.2) ----------
sys="$(uname -s).$(uname -m)"
case "$sys" in
Linux.x86_64)
  hash=d1f67c86eed016214864ba08bfb9529c307aea7e8fafb74853f96fcc3bfd8a60
  path=n1j9ng0120ql98l5a8mi626ka8wvixq4/nix-${NIX_VERSION}-x86_64-linux.tar.xz
  system=x86_64-linux
  ;;
Linux.aarch64)
  hash=64db528412096d718b4bf8f78f85e5ac2b714b774e5005500dee37d23f560456
  path=0aw1ka8njh94nvjy8596va5bbx4wd2nw/nix-${NIX_VERSION}-aarch64-linux.tar.xz
  system=aarch64-linux
  ;;
Linux.i?86)
  hash=9e8a403421c68683557180444f089861469e12b41d41ee2f9be4c8e731b7d160
  path=zjcwglfyf0fvjb4j86kgijzwhzaqbngc/nix-${NIX_VERSION}-i686-linux.tar.xz
  system=i686-linux
  ;;
Linux.armv6l)
  hash=5e088d3f4fe27dd35991b1888c1ea5284edade24965328604968b9a1cc20a94c
  path=2pzkwf2ysf0znsnz5i9gfn6w2gikhlys/nix-${NIX_VERSION}-armv6l-linux.tar.xz
  system=armv6l-linux
  ;;
Linux.armv7l)
  hash=4e2c1e8a3172ae71f041b9b647aa8153fb24518272d1a9bc3d9b384ab7ad54a1
  path=nkp9wbvnsxinr9xl7sn0yy96wvc4chn0/nix-${NIX_VERSION}-armv7l-linux.tar.xz
  system=armv7l-linux
  ;;
Linux.riscv64)
  hash=79601e08b6389df130b5bf1e0a48590aea044ac18bc61660545cf65843b39251
  path=dhqxgwygm94vd6rdiwscxxz98kh8jal3/nix-${NIX_VERSION}-riscv64-linux.tar.xz
  system=riscv64-linux
  ;;
Darwin.*) oops "This build is tailored for Linux containers; use the standard installer on macOS." ;;
*) oops "Unsupported platform: $sys" ;;
esac

# custom URL prefix remains supported
if [ "${1:-}" = "--tarball-url-prefix" ]; then
  [ -n "${2:-}" ] || oops "missing argument for --tarball-url-prefix"
  url="${2}/${path}"
  shift 2
else
  url="https://releases.nixos.org/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-${system}.tar.xz"
fi

# ---------- Requirements ----------
req() { have "$1" || oops "need '$1' to $2"; }
req tar "unpack the binary tarball"
[ "$(uname -s)" = "Darwin" ] || req xz "unpack the binary tarball"

if have curl; then
  fetch() { curl -fsSL "$1" -o "$2"; }
elif have wget; then
  fetch() { wget -q "$1" -O "$2"; }
else oops "need 'curl' or 'wget' to download"; fi

# ---------- Pre-create nixbld if running as root ----------
if [ "$(id -u)" -eq 0 ]; then
  # Many base images lack group/users; create them to pacify the installer.
  if ! getent group nixbld >/dev/null 2>&1; then
    GID="${NIXBLD_GID:-30000}"
    log "Creating group nixbld (gid ${GID})"
    groupadd -g "$GID" nixbld 2>/dev/null || groupadd nixbld || true
  fi
  # ensure at least some members exist
  if ! getent group nixbld | awk -F: '{print $4}' | grep -q '[^[:space:]]'; then
    COUNT="${NIXBLD_USERS:-10}"
    i=1
    while [ "$i" -le "$COUNT" ]; do
      name="nixbld$i"
      if ! id -u "$name" >/dev/null 2>&1; then
        useradd -r -M -N -s /usr/sbin/nologin -g nixbld -G nixbld "$name" 2>/dev/null || true
      fi
      i=$((i + 1))
    done
    log "Ensured nixbld users exist"
  fi
fi

# ---------- Download, verify, unpack ----------
tarball="$tmpDir/nix-${NIX_VERSION}-${system}.tar.xz"
log "Downloading $url"
fetch "$url" "$tarball" || oops "failed to download '$url'"

if have sha256sum; then
  got="$(sha256sum -b "$tarball" | cut -c1-64)"
elif have shasum; then
  got="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif have openssl; then
  got="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
  oops "cannot verify SHA-256 (install sha256sum/shasum/openssl)"
fi
[ "$got" = "$hash" ] || oops "SHA-256 mismatch (expected $hash, got $got)"

unpack="$tmpDir/unpack"
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack tarball"
script="$(echo "$unpack"/nix-*/install)"
[ -x "$script" ] || oops "installer 'install' missing"

# ---------- Run installer (quiet) ----------
export INVOKED_FROM_INSTALL_IN=1
# Default to single-user unless caller passed explicit daemon flag
case " ${*:-} " in
*" --daemon "* | *" --no-daemon "*) : ;;
*) set -- --no-daemon "$@" ;;
esac

run_installer() {
  if have yes; then yes | "$script" "$@"; else "$script" "$@"; fi
}

if [ -n "$INSTALL_LOG" ]; then
  log "Installer output -> $INSTALL_LOG"
  run_installer "$@" >"$INSTALL_LOG" 2>&1
else
  if [ "$VERBOSE" = "1" ]; then
    run_installer "$@"
  else
    run_installer "$@" >/dev/null 2>&1
  fi
fi

# ---------- Activate in current shell & persist for future shells ----------
export HOME="${HOME:-/root}"
export USER="${USER:-$(id -un 2>/dev/null || echo root)}"

profile_candidates="
$HOME/.nix-profile/etc/profile.d/nix.sh
/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
/nix/var/nix/profiles/default/etc/profile.d/nix.sh
"

# Activate now if possible
activated=0
for f in $profile_candidates; do
  if [ -f "$f" ]; then
    # shellcheck disable=SC1090
    . "$f" || true
    activated=1
    break
  fi
done

# Fallback: prepend single-user bin for this session if still not found
if ! have nix && [ -x "$HOME/.nix-profile/bin/nix" ]; then
  PATH="$HOME/.nix-profile/bin:$PATH"
  export PATH
  activated=1
fi

# Persist for future shells: append a safe stanza once
persist_line='. "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null || true'
append_once() {
  file="$1"
  line="$2"
  [ -f "$file" ] || touch "$file"
  if ! grep -Fq "$line" "$file"; then
    printf '\n# Added by Nix installer (non-interactive)\n%s\n' "$line" >>"$file"
  fi
}

if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  append_once "$HOME/.profile" "$persist_line"
  append_once "$HOME/.bashrc" "$persist_line"
  append_once "$HOME/.bash_profile" "$persist_line"
fi

# ---------- Verify ----------
if ! have nix; then
  oops "Nix not found on PATH after installation; check $INSTALL_LOG (if set)."
fi

if [ "$VERBOSE" = "1" ]; then
  nix --version || true
fi
