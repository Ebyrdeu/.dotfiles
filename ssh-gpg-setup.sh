#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Fedora SSH + GPG quick-setup (lean edition)
# - SSH: ed25519 key, start agent for this session, ssh-add
# - GPG: interactive full generator
# - Git: Link GPG key to .gitconfig for signed commits
# - Delete SSH/GPG keys from menu
# ============================================================

C_RESET='\033[0m'; C_OK='\033[0;32m'; C_WARN='\033[1;33m'; C_ERR='\033[0;31m'; C_HEAD='\033[1;36m'
say()  { printf "%b%s%b\n" "$C_HEAD" "$*" "$C_RESET"; }
ok()   { printf "%b%s%b\n" "$C_OK"   "$*" "$C_RESET"; }
warn() { printf "%b%s%b\n" "$C_WARN" "$*" "$C_RESET"; }
err()  { printf "%b%s%b\n" "$C_ERR"  "$*" "$C_RESET" >&2; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || { err "Missing: $1"; exit 1; }; }

CLIP=""
if command -v wl-copy >/dev/null 2>&1; then
  CLIP="wl-copy"
elif command -v xclip >/dev/null 2>&1; then
  CLIP="xclip -selection clipboard"
fi

ensure_packages() {
  say "Ensuring required packages via DNF..."
  sudo dnf install -y openssh-clients gnupg2 pinentry git

  if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    sudo dnf install -y wl-clipboard
    CLIP="wl-copy"
  else
    sudo dnf install -y xclip
    CLIP="xclip -selection clipboard"
  fi
  ok "Packages OK."
}

setup_ssh() {
  say "SSH setup"
  read -rp "Email for SSH key comment (e.g. you@example.com): " email
  email=${email:-"you@example.com"}

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local keyfile="$HOME/.ssh/id_ed25519"
  if [[ -f "$keyfile" ]]; then
    warn "SSH key already exists at $keyfile — skipping generation."
  else
    ssh-keygen -t ed25519 -C "$email"
    ok "SSH key generated."
  fi

  eval "$(ssh-agent -s)"
  ssh-add "$keyfile" || true
  ssh-keyscan -H github.com gitlab.com 2>/dev/null >> "$HOME/.ssh/known_hosts" || true

  say "Your SSH public key:"
  echo "------------------------------------------------------------"
  cat "$keyfile.pub"
  echo "------------------------------------------------------------"
  if [[ -n "$CLIP" ]]; then
    cat "$keyfile.pub" | eval "$CLIP"
    ok "SSH public key copied to clipboard."
  fi
}

setup_gpg() {
  say "GPG setup (interactive)"
  read -rp "Press Enter to launch gpg --full-generate-key…" _
  gpg --full-generate-key

  read -rp "Export your GPG public key to ~/.keys and print it now? [Y/n]: " ans
  if [[ -z "${ans:-}" || "$ans" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME/.keys"
    read -rp "Email (UID) to export (e.g. you@example.com): " gemail
    gemail=${gemail:-"you@example.com"}
    if gpg --list-keys "$gemail" >/dev/null 2>&1; then
      gpg --armor --export "$gemail" > "$HOME/.keys/${gemail}.asc"
      say "Your GPG public key (saved to ~/.keys/${gemail}.asc):"
      cat "$HOME/.keys/${gemail}.asc"
      if [[ -n "$CLIP" ]]; then
        cat "$HOME/.keys/${gemail}.asc" | eval "$CLIP"
        ok "GPG public key copied to clipboard."
      fi
    else
      warn "No key found for '$gemail'."
    fi
  fi
}

setup_git_gpg() {
  say "Configuring Git to use GPG..."
  gpg --list-secret-keys --keyid-format=LONG

  read -rp "Enter the GPG Key ID you want to use for Git (the part after rsa4096/ or ed25519/): " keyid
  if [[ -z "$keyid" ]]; then
    err "Key ID cannot be empty."
    return
  fi

  git config --global user.signingkey "$keyid"
  git config --global commit.gpgsign true

  # Ensure GPG works with TTY for passphrases
  if ! grep -q "export GPG_TTY" "$HOME/.bashrc"; then
    echo 'export GPG_TTY=$(tty)' >> "$HOME/.bashrc"
    say "Added GPG_TTY to .bashrc. Please restart your terminal later."
  fi

  ok "Git is now configured to sign commits with key $keyid."
}

delete_ssh() {
  local keyfile="$HOME/.ssh/id_ed25519"
  if [[ ! -f "$keyfile" ]]; then
    warn "No SSH key found at $keyfile"
    return
  fi
  read -rp "Are you sure you want to delete SSH key ($keyfile)? [y/N]: " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    rm -f "$keyfile" "$keyfile.pub"
    ok "SSH key deleted."
  else
    warn "Deletion cancelled."
  fi
}

delete_gpg() {
  say "Existing GPG keys:"
  gpg --list-keys --keyid-format LONG || { warn "No GPG keys found."; return; }

  read -rp "Enter the key ID to delete: " keyid
  if [[ -z "$keyid" ]]; then
    warn "No key ID entered."
    return
  fi
  read -rp "Are you sure you want to DELETE GPG key $keyid (public & secret)? [y/N]: " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    gpg --delete-secret-keys "$keyid" || true
    gpg --delete-keys "$keyid" || true
    ok "GPG key $keyid deleted."
  else
    warn "Deletion cancelled."
  fi
}

show_keys() {
  say "SSH public key:"
  if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
    cat "$HOME/.ssh/id_ed25519.pub"
  else
    warn "No SSH key found."
  fi
  echo
  say "GPG public keys:"
  gpg --list-secret-keys --keyid-format=long || warn "No GPG public keys."
  echo
  say "Current Git GPG Config:"
  git config --global --get user.signingkey || echo "No signing key set in Git."
}

menu() {
  echo
  say "Fedora SSH + GPG Quick Setup"
  echo "1) Setup SSH"
  echo "2) Setup GPG"
  echo "3) Setup BOTH"
  echo "4) Show public keys"
  echo "5) Delete SSH key"
  echo "6) Delete GPG key"
  echo "7) Add GPG key to Git config"
  echo "8) Exit"
  read -rp "Choose [1-8]: " c
  case "${c:-}" in
    1) ensure_packages; setup_ssh ;;
    2) ensure_packages; setup_gpg ;;
    3) ensure_packages; setup_ssh; setup_gpg ;;
    4) show_keys ;;
    5) delete_ssh ;;
    6) delete_gpg ;;
    7) setup_git_gpg ;;
    8) exit 0 ;;
    *) warn "Invalid choice"; menu ;;
  esac
}

# ---------- Start ----------
need_cmd sudo
if ! command -v dnf >/dev/null 2>&1; then
    err "This script is modified for Fedora (dnf). Pacman not found."
    exit 1
fi
menu