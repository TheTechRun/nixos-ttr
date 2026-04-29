{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core  packages
    wgo
    lynx
    uutils-coreutils-noprefix
    
    # File operations (critical for fzf integration)
    fd          # File finder (fd-find) - needed by fzf and file operations
    ripgrep     # Modern grep replacement (already in main config but here for clarity)
    fzf         # Fuzzy finder (already in main config but here for clarity)
    findutils   # Find utilities
    
    # Git integration (powerline git module)
    git         # Git integration for powerline git module
    
    # Text processing (grep functionality)
    gnugrep     # GNU grep with better regex support
    gnused      # GNU sed for text processing
    gawk         # Text processing
    
    # System utilities (used by various plugins)
    which       # Command location utility
    file        # File type detection
    util-linux  # Linux utilities
    
    # Process management (used by some plugins)
    ps          # Process listing
    
    # Terminal utilities
    less        # Pager for viewing files
    man         # Manual pages
    ncurses     # Terminal UI library
    
    # Build tools (some plugins need these)
    gnumake     # Make utility for building
    gcc         # C compiler
    pkg-config  # Package configuration
    
    # Network utilities (for plugin updates/downloads)
    curl        # HTTP client for downloading/updating
    wget        # Alternative downloader
    
    # Archive handling
    unzip       # Archive extraction
    gnutar         # Archive tool
    gzip        # Compression
    
    # Character encoding
    libiconv    # Character encoding conversion
    
    # Additional development tools
    jq          # JSON processor
    yq          # YAML processor
    xmlstarlet  # XML processor
    
    # Optional but useful for development
    strace      # System call tracer
    netcat      # Network utility
    perl        # Perl interpreter (sometimes needed by plugins)
  ];
}