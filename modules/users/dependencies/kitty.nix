# Kitty terminal dependencies
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core kitty
    kitty
    
    # Shell enhancements (for better kitty experience)
    tmux        # Terminal multiplexer
    zsh         # Enhanced shell
    starship    # Shell prompt
    python313Packages.shtab       # Shell completions
    
    # Process monitoring (useful in terminal)
    htop        # Better process monitor
    unixtools.top         # Process monitor
    
    # Terminal utilities
    tree        # Directory tree viewer
    lsof        # List open files
  ];
}
