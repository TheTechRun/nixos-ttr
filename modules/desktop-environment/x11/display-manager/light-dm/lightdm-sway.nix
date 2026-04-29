# /modules/desktop-environment/display-manager/light-dm/lightdm-sway.nix
# This is kept as a reference - original Sway version
{ config, lib, pkgs, ... }:

let
  backgroundImage = pkgs.copyPathToStore ../../slick-greeter/1.jpeg;
in
{
  services = {
    xserver = {
      enable = true;
      
      displayManager = {
        lightdm = {
          enable = true;
          background = backgroundImage;
          greeters.gtk.enable = false;
          
          greeters.slick = {
            enable = true;
            extraConfig = ''
              background=${backgroundImage}
              draw-user-backgrounds=false
              theme-name=Adwaita-dark
              icon-theme-name=Adwaita
              font-name=Sans 11
              xft-antialias=true
              xft-hintstyle=hintfull
              enable-hidpi=auto
            '';
          };
        };
        
        # Configure sessions for both i3 and Sway
        session = [
          {
            name = "i3";
            manage = "window";
            start = ''
              export XDG_SESSION_TYPE=x11
              export XDG_CURRENT_DESKTOP=i3
              export MOZ_ENABLE_WAYLAND=0
              exec ${pkgs.i3}/bin/i3
            '';
          }
          {
            name = "sway";
            manage = "window";
            start = ''
              export XDG_SESSION_TYPE=wayland
              export XDG_CURRENT_DESKTOP=sway
              export SDL_VIDEODRIVER=wayland
              export QT_QPA_PLATFORM=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
              export MOZ_ENABLE_WAYLAND=1
              export _JAVA_AWT_WM_NONREPARENTING=1
              export WAYLAND_DISPLAY=wayland-1
              exec ${pkgs.sway}/bin/sway
            '';
          }
        ];
      };
    };
  };

  # Environment variables that work for both window managers
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Install necessary packages for both window managers
  environment.systemPackages = with pkgs; [
    lightdm
    lightdm-slick-greeter
    i3
    sway
    xwayland  # Important for X11 app compatibility in Sway
  ];
}
