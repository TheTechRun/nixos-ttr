#!/usr/bin/env bash

# Unified flake rebuild script for all hosts
set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 [HOST] [OPTIONS]"
    echo "Rebuild NixOS flake configuration for specified host or auto-detect current host"
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
    echo "  -h, --help       Show this help message"
    echo "  --skip-git       Skip git operations (commit and push)"
    echo "  --no-interactive Skip interactive prompts (uses defaults)"
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
SKIP_GIT=false
NO_INTERACTIVE=false
TARGET_HOST=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        --skip-git)
            SKIP_GIT=true
            shift
            ;;
        --no-interactive)
            NO_INTERACTIVE=true
            shift
            ;;
        -*)
            echo "Error: Unknown option $1"
            usage
            ;;
        *)
            if [[ -n "$TARGET_HOST" ]]; then
                echo "Error: Multiple hosts specified"
                usage
            fi
            TARGET_HOST="$1"
            shift
            ;;
    esac
done

# Auto-detect host if no argument provided
if [[ -z "$TARGET_HOST" ]]; then
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

echo "Building and updating NixOS flake configuration for host: $TARGET_HOST"

# Change to the nixos-config directory
cd ~/nixos-config

# Git operations (unless skipped)
if [[ "$SKIP_GIT" == false ]]; then
    echo "Checking for changes..."
    # Check both tracked and untracked files
    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Changes detected. Committing to git..."
        # Stage all changes, including untracked files
        git add -A

        if [[ "$NO_INTERACTIVE" == true ]]; then
            commit_message="Update NixOS configuration"
        else
            read -p "Enter a commit message (default: 'Update NixOS configuration'): " commit_message
            commit_message=${commit_message:-"Update NixOS configuration"}
        fi
        
        git commit -m "$commit_message"

        echo "Pushing changes to remote repository..."
        if [[ "$NO_INTERACTIVE" == true ]]; then
            echo "Non-interactive mode: skipping force push to master"
            echo "You can manually push with: git push origin master --force"
        else
            read -p "Are you sure you want to force push to master? (y/N): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                git push origin master --force
            else
                echo "Push aborted. You can manually push later with: git push origin master --force"
            fi
        fi
    else
        echo "No changes detected in git."
    fi
else
    echo "Skipping git operations (--skip-git flag specified)"
fi

# Rebuild NixOS
echo "Rebuilding NixOS configuration for $TARGET_HOST..."
sudo nixos-rebuild switch --flake ".#$TARGET_HOST"

echo "NixOS build and update complete for $TARGET_HOST!"