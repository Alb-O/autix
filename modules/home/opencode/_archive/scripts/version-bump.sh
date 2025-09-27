#!/usr/bin/env bash
set -euo pipefail

# Resolve flake repo root (kakoune/) from this script location
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# Prefer git, fallback to walking up to directory containing flake.nix
if git -C "$here" rev-parse --show-toplevel >/dev/null 2>&1; then
  root_dir=$(git -C "$here" rev-parse --show-toplevel)
else
  root_dir="$here"
  while [[ "$root_dir" != "/" && ! -f "$root_dir/flake.nix" ]]; do
    root_dir=$(dirname "$root_dir")
  done
fi

# Paths inside kakoune flake
pkg_file="$root_dir/nix/packages/cli/opencode/opencode-git.nix"
models_dev_file="$root_dir/nix/packages/cli/opencode/models-dev/default.nix"

version="${1:-latest}"

if [[ "$version" == "latest" ]]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required to detect the latest version. Install jq or pass an explicit version." >&2
    exit 1
  fi
  echo "Fetching latest opencode release tag…" >&2
  tag=$(curl -fsSL https://api.github.com/repos/sst/opencode/releases/latest | jq -r .tag_name)
  if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "Failed to get latest tag from GitHub." >&2
    exit 1
  fi
  version="${tag#v}"
fi

echo "Bumping OpenCode to v$version" >&2

# Reset version + hashes to placeholders
tmp=$(mktemp)
awk -v ver="$version" '
  BEGIN{placed_src=placed_vendor=placed_node=0}
  {
    if ($0 ~ /version = "/ && !done_ver) { sub(/version = ".*";/, "version = \"" ver "\";"); done_ver=1 }
    if ($0 ~ /owner = "sst";/) { in_src=1 }
    if (in_src && $0 ~ /hash = "sha256-/) { sub(/hash = "sha256-[^"]*";/, "hash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";"); in_src=0; placed_src=1 }
    if ($0 ~ /vendorHash = "sha256-/) { sub(/vendorHash = "sha256-[^"]*";/, "vendorHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";"); placed_vendor=1 }
    if ($0 ~ /outputHash = "sha256-/) { sub(/outputHash = "sha256-[^"]*";/, "outputHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";"); placed_node=1 }
    print
  }
  END{
    if (!done_ver) exit 2
  }
' "$pkg_file" >"$tmp"
mv "$tmp" "$pkg_file"

echo "Attempting to prefill hashes by building…" >&2

cd "$root_dir"

tries=0
max_tries=6
while ((tries < max_tries)); do
  tries=$((tries + 1))
  echo "Build attempt $tries…" >&2
  set +e
  # Build the unwrapped package (closest to the raw source) so
  # fixed-output hash mismatches are surfaced and can be patched.
  out=$(nix build --impure --expr "with import <nixpkgs> {}; callPackage $root_dir/nix/packages/cli/opencode/opencode-git.nix { models-dev = callPackage $root_dir/nix/packages/cli/opencode/models-dev {}; }" 2>&1)
  code=$?
  set -e

  if [[ $code -eq 0 ]]; then
    echo "Build succeeded; hashes are up to date." >&2
    break
  fi

  # Extract the hash from the error message
  got=$(echo "$out" | sed -n "s/.*got: *\(sha256-[A-Za-z0-9\/+]*=\).*/\1/p" | head -n1)

  if [[ -n "$got" ]]; then
    # Determine which hash to update based on the derivation name in the error message
    # Look for the specific derivation mentioned in the "hash mismatch" error line
    if echo "$out" | grep "hash mismatch.*opencode-node_modules-" >/dev/null; then
      sed -i "0,/outputHash = \"sha256-[^\"]*\"/s|outputHash = \"sha256-[^\"]*\"|outputHash = \"$got\"|" "$pkg_file"
      echo "Successfully updated nodeModules.outputHash -> $got" >&2
      continue
    elif echo "$out" | grep "hash mismatch.*source\.drv" >/dev/null; then
      sed -i "0,/hash = \"sha256-[^\"]*\"/s|hash = \"sha256-[^\"]*\"|hash = \"$got\"|" "$pkg_file"
      echo "Successfully updated src.hash -> $got" >&2
      continue
    elif echo "$out" | grep "hash mismatch.*go-modules\.drv" >/dev/null; then
      sed -i "0,/vendorHash = \"sha256-[^\"]*\"/s|vendorHash = \"sha256-[^\"]*\"|vendorHash = \"$got\"|" "$pkg_file"
      echo "Successfully updated vendorHash -> $got" >&2
      continue
    elif echo "$out" | grep -q "hash mismatch.*api\.json\.drv"; then
      # Update models.dev API fixed-output sha in models-dev.nix
      sed -i "0,/sha256 = \"sha256-[^\"]*\"/s|sha256 = \"sha256-[^\"]*\"|sha256 = \"$got\"|" "$models_dev_file"
      echo "Successfully updated models-dev sha256 -> $got" >&2
      continue
    fi
  fi

  echo "$out" >&2
  echo "Build failed for a reason other than fixed-output hash mismatch." >&2
  exit $code
done

if ((tries == max_tries)); then
  echo "Gave up after $max_tries attempts; please check $pkg_file." >&2
  exit 1
fi

echo "Done. You can now build or run opencode." >&2
