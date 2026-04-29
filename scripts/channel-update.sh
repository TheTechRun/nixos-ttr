#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ~/nixos-config/scripts/channel-update.sh <target-version>

Example:
  ~/nixos-config/scripts/channel-update.sh 25.05

What it does:
  1. Removes the current `nixos` channel
  2. Adds `https://nixos.org/channels/nixos-<target-version>`
  3. Lists channels
  4. Updates channels
  5. Optionally runs `sudo nixos-rebuild switch`

This is meant only for bootstrapping older hosts before the first flake rebuild.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

target_version="${1:-}"

if [[ -z "$target_version" ]]; then
  read -r -p "Target NixOS version (example: 25.05): " target_version
fi

if [[ -z "$target_version" ]]; then
  echo "No target version provided." >&2
  exit 1
fi

channel_url="https://nixos.org/channels/nixos-${target_version}"

echo "Current host version:"
nixos-version || true
echo
echo "Target channel:"
echo "  $channel_url"
echo

read -r -p "Proceed with channel replacement? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

echo
echo "Removing existing nixos channel..."
sudo nix-channel --remove nixos || true

echo
echo "Adding target channel..."
sudo nix-channel --add "$channel_url" nixos

echo
echo "Current channel list:"
sudo nix-channel --list

echo
echo "Updating channels..."
sudo nix-channel --update

echo
read -r -p "Run legacy rebuild now with sudo nixos-rebuild switch? [y/N] " rebuild
if [[ "$rebuild" =~ ^[Yy]$ ]]; then
  cd /etc/nixos
  sudo nixos-rebuild switch
else
  echo "Skipping rebuild."
fi

echo
echo "Done."
