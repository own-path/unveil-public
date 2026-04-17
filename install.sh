#!/usr/bin/env bash
## [un]veil — one-command installer
##
## Usage:
##   curl -fsSL https://raw.githubusercontent.com/own-path/unveil/main/install.sh | bash
##
## What it does:
##   1. Detects your platform (macOS arm64/x64, Linux x64/arm64)
##   2. Downloads the latest release archive from GitHub
##   3. Extracts binaries to ~/.local/bin
##   4. Sets up Python ML environment (optional)
##   5. Prints PATH instructions if needed

set -euo pipefail

REPO="${UNVEIL_REPO:-own-path/unveil}"   # Public repo with releases
INSTALL_DIR="${UNVEIL_INSTALL_DIR:-$HOME/.local/bin}"
UNVEIL_HOME="${UNVEIL_HOME:-$HOME/.unveil}"

# ─── Colours ──────────────────────────────────────────────────────────────────

bold=""  green=""  yellow=""  red=""  reset=""
if [ -t 1 ]; then
  bold="\033[1m"
  green="\033[32m"
  yellow="\033[33m"
  red="\033[31m"
  reset="\033[0m"
fi

info()    { echo -e "${bold}→${reset} $*"; }
success() { echo -e "${green}✓${reset} $*"; }
warn()    { echo -e "${yellow}!${reset} $*"; }
die()     { echo -e "${red}error:${reset} $*" >&2; exit 1; }

# ─── Platform detection ───────────────────────────────────────────────────────

detect_platform() {
  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$arch" in
    x86_64)  arch="x64"   ;;
    aarch64) arch="arm64" ;;
    arm64)   arch="arm64" ;;
    *)       die "Unsupported architecture: $arch" ;;
  esac

  case "$os" in
    linux)  echo "linux-${arch}"  ;;
    darwin) echo "darwin-${arch}" ;;
    *)      die "Unsupported OS: $os" ;;
  esac
}

# ─── Latest release lookup ────────────────────────────────────────────────────

latest_version() {
  if command -v curl &>/dev/null; then
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/'
  elif command -v wget &>/dev/null; then
    wget -qO- "https://api.github.com/repos/${REPO}/releases/latest" \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/'
  else
    die "Neither curl nor wget is available. Please install one and try again."
  fi
}

# ─── Download helper ──────────────────────────────────────────────────────────

download() {
  local url="$1" dest="$2"
  if command -v curl &>/dev/null; then
    curl -fsSL --progress-bar "$url" -o "$dest"
  else
    wget -q --show-progress "$url" -O "$dest"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  echo ""
  echo -e "${bold}[un]veil installer${reset}"
  echo ""

  local platform version archive_name url tmp_dir

  platform="$(detect_platform)"
  info "Platform: $platform"

  # Allow pinning a version via env var
  if [ -n "${UNVEIL_VERSION:-}" ]; then
    version="$UNVEIL_VERSION"
  else
    info "Fetching latest release..."
    version="$(latest_version)"
  fi

  [ -z "$version" ] && die "Could not determine latest version. Set UNVEIL_VERSION=x.y.z to override."
  info "Version:  $version"

  archive_name="unveil-${version}-${platform}.tar.gz"
  url="https://github.com/${REPO}/releases/download/${version}/${archive_name}"

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  info "Downloading $archive_name..."
  download "$url" "$tmp_dir/$archive_name"

  info "Extracting..."
  tar -xzf "$tmp_dir/$archive_name" -C "$tmp_dir"

  # The archive contains a platform/ subdirectory
  local extracted="$tmp_dir/$platform"
  [ -d "$extracted" ] || die "Expected directory '$platform' in archive — got something else."

  mkdir -p "$INSTALL_DIR"

  for bin in unveil unveil-session unveil-ipc unveil-ui veil veil-session veil-ipc veil-ui; do
    if [ -f "$extracted/$bin" ]; then
      cp "$extracted/$bin" "$INSTALL_DIR/$bin"
      chmod +x "$INSTALL_DIR/$bin"
    fi
  done

  success "Installed to $INSTALL_DIR"

  # ── Python setup (optional) ───────────────────────────────────────────────

  if command -v python3 &>/dev/null; then
    echo ""
    echo -e "${bold}Python ML dependencies${reset}"
    info "Setting up Python venv at $UNVEIL_HOME/.venv..."
    mkdir -p "$UNVEIL_HOME"

    if [ -f "$extracted/requirements.txt" ]; then
      python3 -m venv "$UNVEIL_HOME/.venv"
      "$UNVEIL_HOME/.venv/bin/pip" install --quiet --upgrade pip
      "$UNVEIL_HOME/.venv/bin/pip" install --quiet -r "$extracted/requirements.txt"
      success "Python environment ready at $UNVEIL_HOME/.venv"
    else
      warn "requirements.txt not found in archive — skipping Python setup."
      warn "Run: veil setup   after install to set up ML deps."
    fi
  else
    warn "python3 not found — skipping ML dependency setup."
    warn "Install Python 3.10+ and run: veil setup"
  fi

  # ── PATH check ────────────────────────────────────────────────────────────

  echo ""
  if echo ":${PATH}:" | grep -q ":${INSTALL_DIR}:"; then
    success "$INSTALL_DIR is already in your PATH."
  else
    warn "$INSTALL_DIR is not in your PATH."
    echo ""
    echo "  Add this to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    echo ""
    echo -e "    ${bold}export PATH=\"\$HOME/.local/bin:\$PATH\"${reset}"
    echo ""
    echo "  Then reload your shell:"
    echo ""
    echo -e "    ${bold}source ~/.zshrc${reset}   # or ~/.bashrc"
    echo ""
  fi

  echo ""
  success "[un]veil $version installed. Run ${bold}unveil${reset} to start."
  echo ""
}

main "$@"
