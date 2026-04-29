# audio.nix - MAKE SURE TO SET THE ONE NOT BEING USED TO FALSE
{ config, pkgs, ... }:

{
  # Enable sound (Depracated)
  #sound.enable = true;
  
  # Use PipeWire (better for Wayland/Sway)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Use Pulse Audio
  # services.pulseaudio.enable = true; 
  
  # Install related packages
  environment.systemPackages = with pkgs; [
    pamixer       # Command-line mixer
    pavucontrol   # GUI mixer
    pulseaudio    # Command line utilities
  ];
}