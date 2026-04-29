# Core development tools and utilities
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    nodejs_24   # Node.js
    deno        # Deno runtime
    cargo-tauri # Tauri framework
    
    # Git and version control
    git         # Also in kak.nix but core enough to be here
    lazygit     # Git TUI
    
    # Docker
    docker-compose
    lazydocker  # Docker TUI
    
    # rust
    # rustup # removed because conflicts with rust-analyzer in ./lsp.nix

    # System utilities
    bottom      # System monitor
    fastfetch   # System info
    neofetch    # System info
    
    # File utilities
    file        # File type detection
    tree        # Directory tree
    unrar       # RAR extraction
    
    # Network utilities
    openssl     # SSL/TLS toolkit
    
    # Text processing
    glow        # Markdown viewer
    
    # Terminal utilities
    tmux        # Terminal multiplexer
    figlet      # ASCII art text
    cmatrix     # Matrix effect
    
    # Build tools
    devbox      # Development environments
    
    # Other
    bubblewrap #unpriviledged sandboxing tool for codex (bwrap)
    cargo-tauri
    deno        # Deno runtime
    devbox      # Development environments
    distrobox
    nodejs_24   # Node.js slim npm
    # rustup
    xmlstarlet

  ];
}