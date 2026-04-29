#!/usr/bin/env bash

# Unified flake update script for all hosts
set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 [HOST]"
    echo "Update NixOS flake configuration for specified host or auto-detect current host"
    echo ""
    echo "Arguments:"
    echo "  HOST    Target host (desktop, laptop, server). If not specified, auto-detects current host."
    echo ""
    echo "Available hosts:"
    for host in "$HOME/nixos-config/hosts"/*; do
        if [[ -d "$host" ]]; then
            echo "  - $(basename "$host")"
        fi
    done
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    exit 1
}

# Function to auto-detect current host
detect_host() {
    local hostname=$(hostname)
    local config_dir="$HOME/nixos-config/hosts"
    
    # Check if hostname matches any directory in hosts/
    if [[ -d "$config_dir/$hostname" ]]; then
        echo "$hostname"
        return 0
    fi
    
    # If no exact match, list available hosts and exit
    echo "Error: Could not auto-detect host. Hostname '$hostname' not found in $config_dir"
    echo "Available hosts:"
    for host in "$config_dir"/*; do
        if [[ -d "$host" ]]; then
            echo "  - $(basename "$host")"
        fi
    done
    echo ""
    echo "Please specify a host manually: $0 <host>"
    exit 1
}

# Parse command line arguments
if [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments"
    usage
fi

if [[ $# -eq 1 ]]; then
    case "$1" in
        -h|--help)
            usage
            ;;
        *)
            TARGET_HOST="$1"
            ;;
    esac
else
    # Auto-detect host if no argument provided
    TARGET_HOST=$(detect_host)
fi

# Validate that the target host exists
HOST_DIR="$HOME/nixos-config/hosts/$TARGET_HOST"
if [[ ! -d "$HOST_DIR" ]]; then
    echo "Error: Host '$TARGET_HOST' not found in $HOST_DIR"
    echo "Available hosts:"
    for host in "$HOME/nixos-config/hosts"/*; do
        if [[ -d "$host" ]]; then
            echo "  - $(basename "$host")"
        fi
    done
    exit 1
fi

echo "Updating NixOS flake configuration for host: $TARGET_HOST"

# Change to nixos-config directory
cd "$HOME/nixos-config"

echo "Updating flake inputs..."
nix flake update

echo "Rebuilding NixOS configuration for $TARGET_HOST..."
sudo nixos-rebuild switch --flake ".#$TARGET_HOST"

echo "NixOS update complete for $TARGET_HOST!"