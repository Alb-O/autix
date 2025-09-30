#!/bin/sh
# Quiet, non-interactive Nix installer wrapper (for Nix 2.31.2)
# - QUIET by default; set VERBOSE=1 for progress logs
# - Linux: defaults to single-user (--no-daemon) unless you pass an explicit mode

set -eu

# ---------- tiny logger ----------
VERBOSE="${VERBOSE:-0}"
info() { [ "$VERBOSE" = "1" ] && printf '%s\n' "$*" || true; }
oops() {
  printf '%s: %s\n' "$0" "$*" >&2
  exit 1
}

umask 0022

# ---------- temp dir & cleanup ----------
tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX)" || oops "Can't create temporary directory"
cleanup() {
  # shellcheck disable=SC2164
  rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

# ---------- utils ----------
require_util() {
  command -v "$1" >/dev/null 2>&1 || oops "missing '$1' (needed to $2)"
}

# ---------- platform matrix (Nix 2.31.2) ----------
case "$(uname -s).$(uname -m)" in
  Linux.x86_64)
    hash=d1f67c86eed016214864ba08bfb9529c307aea7e8fafb74853f96fcc3bfd8a60
    path=n1j9ng0120ql98l5a8mi626ka8wvixq4/nix-2.31.2-x86_64-linux.tar.xz
    system=x86_64-linux
    ;;
  Linux.i?86)
    hash=9e8a403421c68683557180444f089861469e12b41d41ee2f9be4c8e731b7d160
    path=zjcwglfyf0fvjb4j86kgijzwhzaqbngc/nix-2.31.2-i686-linux.tar.xz
    system=i686-linux
    ;;
  Linux.aarch64)
    hash=64db528412096d718b4bf8f78f85e5ac2b714b774e5005500dee37d23f560456
    path=0aw1ka8njh94nvjy8596va5bbx4wd2nw/nix-2.31.2-aarch64-linux.tar.xz
    system=aarch64-linux
    ;;
  Linux.armv6l)
    hash=5e088d3f4fe27dd35991b1888c1ea5284edade24965328604968b9a1cc20a94c
    path=2pzkwf2ysf0znsnz5i9gfn6w2gikhlys/nix-2.31.2-armv6l-linux.tar.xz
    system=armv6l-linux
    ;;
  Linux.armv7l)
    hash=4e2c1e8a3172ae71f041b9b647aa8153fb24518272d1a9bc3d9b384ab7ad54a1
    path=nkp9wbvnsxinr9xl7sn0yy96wvc4chn0/nix-2.31.2-armv7l-linux.tar.xz
    system=armv7l-linux
    ;;
  Linux.riscv64)
    hash=79601e08b6389df130b5bf1e0a48590aea044ac18bc61660545cf65843b39251
    path=dhqxgwygm94vd6rdiwscxxz98kh8jal3/nix-2.31.2-riscv64-linux.tar.xz
    system=riscv64-linux
    ;;
  Darwin.x86_64)
    hash=ed8df6a1046dea90ba4068a827bdeaf372d522867c4d2b48cdb37145c200eeba
    path=5zp5bzz45sn9ff2bfhh03cmavvm1r6gs/nix-2.31.2-x86_64-darwin.tar.xz
    system=x86_64-darwin
    ;;
  Darwin.arm64 | Darwin.aarch64)
    hash=3baa0af88a1ef4e2cc82cb64cd384b1805ecc3771b574e97277ae213d52711d8
    path=b7hidzsb4i3gx6s23ig9mp7mwmiljzfk/nix-2.31.2-aarch64-darwin.tar.xz
    system=aarch64-darwin
    ;;
  *) oops "no binary distribution of Nix for your platform" ;;
esac

# ---------- URL handling ----------
if [ "${1:-}" = "--tarball-url-prefix" ]; then
  [ -n "${2:-}" ] || oops "missing argument for --tarball-url-prefix"
  url="${2}/${path}"
  shift 2
else
  url="https://releases.nixos.org/nix/nix-2.31.2/nix-2.31.2-$system.tar.xz"
fi

tarball="$tmpDir/nix-2.31.2-$system.tar.xz"

# ---------- prerequisites ----------
require_util tar "unpack the binary tarball"
if [ "$(uname -s)" != "Darwin" ]; then
  require_util xz "unpack the binary tarball"
fi

# fetch: quiet by default
if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL "$1" -o "$2"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -q "$1" -O "$2"; }
else
  oops "need 'curl' or 'wget' to download the tarball"
fi

info "Downloading $url"
fetch "$url" "$tarball" || oops "failed to download '$url'"

# ---------- sha256 verify ----------
if command -v sha256sum >/dev/null 2>&1; then
  hash2="$(sha256sum -b "$tarball" | cut -c1-64)"
elif command -v shasum >/dev/null 2>&1; then
  hash2="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif command -v openssl >/dev/null 2>&1; then
  hash2="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
  oops "cannot verify SHA-256 (need 'sha256sum', 'shasum', or 'openssl')"
fi
[ "$hash" = "$hash2" ] || oops "SHA-256 mismatch; expected $hash, got $hash2"

# ---------- unpack ----------
unpack="$tmpDir/unpack"
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack tarball"
script=$(echo "$unpack"/*/install)
[ -e "$script" ] || oops "installer 'install' missing from tarball"

# ---------- choose non-interactive defaults ----------
# If caller didn't specify daemon mode on Linux, default to single-user.
set -- "$@" # keep any caller flags
case "$(uname -s)" in
  Linux)
    case " $* " in
      *" --daemon "* | *" --no-daemon "*) : ;; # explicit choice already given
      *) set -- --no-daemon "$@" ;;
    esac
    ;;
esac

# ---------- run installer quietly ----------
export INVOKED_FROM_INSTALL_IN=1

INSTALL_LOG="${INSTALL_LOG:-}"
if [ -n "$INSTALL_LOG" ]; then
  # Log everything but keep stdout/stderr clean
  info "Installer output -> $INSTALL_LOG"
  # Feed a stream of "yes" to avoid any prompt; most paths are non-interactive anyway
  if command -v yes >/dev/null 2>&1; then
    yes | "$script" "$@" >"$INSTALL_LOG" 2>&1
  else
    # fall back to an empty stream (works when no prompts occur)
    "$script" "$@" >"$INSTALL_LOG" 2>&1
  fi
else
  if [ "$VERBOSE" = "1" ]; then
    if command -v yes >/dev/null 2>&1; then
      yes | "$script" "$@"
    else
      "$script" "$@"
    fi
  else
    if command -v yes >/dev/null 2>&1; then
      yes | "$script" "$@" >/dev/null 2>&1
    else
      "$script" "$@" >/dev/null 2>&1
    fi
  fi
fi
