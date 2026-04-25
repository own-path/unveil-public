#!/bin/sh
## [un]veil — one-command installer (POSIX sh)
##
## Usage:
##   curl -fsSL https://raw.githubusercontent.com/own-path/unveil-public/main/install.sh | sh
##
## What it does:
##   1. Detects your platform (Darwin arm64/x64, Linux x64)
##   2. Downloads the matching release archive from GitHub
##   3. Verifies cosign signature if `cosign` is on PATH (skipped with warning otherwise)
##   4. Extracts to ~/.local/share/unveil/<version>/
##   5. Symlinks binaries into ~/.local/bin/
##   6. Prints PATH instructions if ~/.local/bin is not on PATH
##
## Never invokes sudo. All paths are under $HOME.

set -eu

REPO="${UNVEIL_REPO:-own-path/unveil-public}"
BIN_DIR="${UNVEIL_BIN_DIR:-$HOME/.local/bin}"
SHARE_DIR="${UNVEIL_SHARE_DIR:-$HOME/.local/share/unveil}"

# ─── Output helpers ───────────────────────────────────────────────────────────

if [ -t 1 ]; then
  BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m'); RED=$(printf '\033[31m'); RESET=$(printf '\033[0m')
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi

info()    { printf '%s→%s %s\n' "$BOLD" "$RESET" "$*"; }
success() { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn()    { printf '%s!%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
die()     { printf '%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

# ─── Platform detection ───────────────────────────────────────────────────────

detect_platform() {
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64) arch=x64 ;;
    arm64|aarch64) arch=arm64 ;;
    *) die "Unsupported architecture: $arch" ;;
  esac
  case "$os" in
    darwin) printf 'darwin-%s\n' "$arch" ;;
    linux)
      [ "$arch" = "x64" ] || die "Unsupported Linux arch: $arch (only linux-x64 is installer-supported)"
      printf 'linux-x64\n'
      ;;
    *) die "Unsupported OS: $os" ;;
  esac
}

# ─── Downloaders (curl or wget) ───────────────────────────────────────────────

http_get() {
  # http_get URL DEST
  url=$1; dest=$2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$dest" "$url"
  else
    die "Need curl or wget on PATH."
  fi
}

http_get_str() {
  url=$1
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
  else
    wget -qO- "$url"
  fi
}

latest_version() {
  http_get_str "https://api.github.com/repos/${REPO}/releases/latest" \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  printf '\n%s[un]veil installer%s\n\n' "$BOLD" "$RESET"

  platform=$(detect_platform)
  info "Platform: $platform"

  if [ -n "${UNVEIL_VERSION:-}" ]; then
    version=$UNVEIL_VERSION
  else
    info "Fetching latest release..."
    version=$(latest_version)
  fi
  [ -n "$version" ] || die "Could not determine latest version. Set UNVEIL_VERSION=... to override."
  info "Version:  $version"

  archive="unveil-${version}-${platform}.tar.gz"
  base_url="https://github.com/${REPO}/releases/download/${version}"

  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT INT TERM

  info "Downloading $archive..."
  http_get "${base_url}/${archive}" "$tmp/$archive"

  # ── cosign verification (optional) ────────────────────────────────────────
  if command -v cosign >/dev/null 2>&1; then
    info "Fetching cosign signature + certificate..."
    if http_get "${base_url}/${archive}.sig" "$tmp/${archive}.sig" \
       && http_get "${base_url}/${archive}.pem" "$tmp/${archive}.pem"; then
      info "Verifying signature with cosign..."
      if COSIGN_EXPERIMENTAL=1 cosign verify-blob \
           --signature "$tmp/${archive}.sig" \
           --certificate "$tmp/${archive}.pem" \
           --certificate-identity-regexp '.*' \
           --certificate-oidc-issuer-regexp '.*' \
           "$tmp/$archive" >/dev/null 2>&1; then
        success "Signature verified."
      else
        die "cosign signature verification FAILED — aborting install."
      fi
    else
      warn "Could not fetch .sig/.pem — skipping verification."
    fi
  else
    warn "cosign not on PATH — skipping signature verification."
    warn "Install cosign (https://docs.sigstore.dev/cosign/installation) for verified installs."
  fi

  info "Extracting to ${SHARE_DIR}/${version}/..."
  install_root="${SHARE_DIR}/${version}"
  mkdir -p "$install_root"
  tar -xzf "$tmp/$archive" -C "$install_root" --strip-components=1

  mkdir -p "$BIN_DIR"
  linked=0
  for name in unveil unveil-ipc unveil-session unveil-gateway unveil-ui unveil-worker; do
    src="${install_root}/${name}"
    if [ -f "$src" ]; then
      chmod +x "$src" 2>/dev/null || true
      ln -sf "$src" "${BIN_DIR}/${name}"
      linked=$((linked + 1))
    fi
  done
  [ "$linked" -gt 0 ] || die "No binaries found in archive at $install_root"

  success "Installed $linked binaries to $BIN_DIR (symlinks → $install_root)"

  # ── PATH advisory ────────────────────────────────────────────────────────
  case ":${PATH}:" in
    *":${BIN_DIR}:"*) success "$BIN_DIR is already on your PATH." ;;
    *)
      warn "$BIN_DIR is not on your PATH."
      printf '\n  Add this to your shell rc (~/.bashrc, ~/.zshrc, etc.):\n\n'
      printf '    %sexport PATH="$HOME/.local/bin:$PATH"%s\n\n' "$BOLD" "$RESET"
      ;;
  esac

  printf '\n'
  success "[un]veil $version installed. Run ${BOLD}unveil${RESET} to start."
  printf '   For optional ML tools:  %sunveil setup ml%s\n\n' "$BOLD" "$RESET"
}

main "$@"
