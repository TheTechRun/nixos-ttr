{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bash
    bashmount
    bat
    bitwarden-cli
    chafa
    coreutils
    dust
    dmidecode
    eza
    fasd
    fastfetch
    figlet
    htop

    # Core packages
    wgo
    lynx
    uutils-coreutils-noprefix
    
    # File operations (critical for fzf integration)
    fd
    findutils
    fzf
    ripgrep
    
    # Git integration (powerline git module)
    git
    
    # Text processing (grep functionality)
    gawk
    glow
    gnugrep
    gnused
    highlight
    
    # System utilities (used by various plugins)
    file
    killall
    lsof
    moreutils
    plocate
    rename
    trash-cli
    unixtools.top
    util-linux
    which
    
    # Process management (used by some plugins)
    ps
    
    # Terminal utilities
    lf
    less
    man
    ncurses
    python313Packages.shtab
    starship
    timg
    tmux
    viu
    zsh
    
    # Build tools (some plugins need these)
    gcc
    gnumake
    pkg-config
   
    # Archive handling
    gnutar
    gzip
    p7zip
    unzip
    zip
    
    # Character encoding
    libiconv
    
    # Additional development tools
    jq
    xmlstarlet
    yq
    
    # Optional but useful for development
    netcat
    perl
    strace
  ];
}