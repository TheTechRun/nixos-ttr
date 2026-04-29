{ config, lib, pkgs, ... }:

{
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    swayimg
    wl-clipboard
    cliphist
    wdisplays
    waybar
    wofi
    grim
    slurp
    wf-recorder
    xwayland
    wlr-randr
    networkmanagerapplet
    rofi
    screenkey
    fsearch
    lightlocker
    haskellPackages.greenclip
    dunst
    brightnessctl
    pamixer
    playerctl
    swaybg
    foot
    wmenu
    nwg-look
  ];

  # Audio configuration moved to host-specific audio files
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   pulse.enable = true;
  # };
}