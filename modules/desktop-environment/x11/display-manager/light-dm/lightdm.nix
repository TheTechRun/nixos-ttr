# /modules/desktop-environment/display-manager/light-dm/lightdm.nix
# Unified LightDM configuration supporting both i3 and Sway
{ config, lib, pkgs, ... }:

let
  backgroundImage = pkgs.copyPathToStore ../../../slick-greeter/1.jpeg;
in
{
  services = {
    # Disable GNOME at the services level (new location)
    desktopManager.gnome.enable = lib.mkForce false;
    
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
        
        # Configure sessions for i3 and Sway (SwayFX)
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
          # COMMENTED OUT - Regular Sway session (uncomment if you want to use regular sway in the future)
          # {
          #   name = "sway";
          #   manage = "window";
          #   start = ''
          #     # Set up runtime directory
          #     if [ -z "$XDG_RUNTIME_DIR" ]; then
          #       export XDG_RUNTIME_DIR="/run/user/$(id -u)"
          #     fi
          #     mkdir -p "$XDG_RUNTIME_DIR"
          #     chmod 700 "$XDG_RUNTIME_DIR"
          #     
          #     export XDG_SESSION_TYPE=wayland
          #     export XDG_CURRENT_DESKTOP=sway
          #     export SDL_VIDEODRIVER=wayland
          #     export QT_QPA_PLATFORM=wayland
          #     export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          #     export MOZ_ENABLE_WAYLAND=1
          #     export _JAVA_AWT_WM_NONREPARENTING=1
          #     export WAYLAND_DISPLAY=wayland-1
          #     exec ${pkgs.sway}/bin/sway
          #   '';
          # }
          # COMMENTED OUT - Custom SwayFX session (conflicts with automatic "sway" session)
          # {
          #   name = "swayfx";
          #   manage = "window";
          #   start = ''
          #     # Set up runtime directory
          #     if [ -z "$XDG_RUNTIME_DIR" ]; then
          #       export XDG_RUNTIME_DIR="/run/user/$(id -u)"
          #     fi
          #     mkdir -p "$XDG_RUNTIME_DIR"
          #     chmod 700 "$XDG_RUNTIME_DIR"
          #     
          #     export XDG_SESSION_TYPE=wayland
          #     export XDG_CURRENT_DESKTOP=sway
          #     export SDL_VIDEODRIVER=wayland
          #     export QT_QPA_PLATFORM=wayland
          #     export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          #     export MOZ_ENABLE_WAYLAND=1
          #     export _JAVA_AWT_WM_NONREPARENTING=1
          #     export WAYLAND_DISPLAY=wayland-1
          #     export WLR_NO_HARDWARE_CURSORS=1
          #     export WLR_RENDERER_ALLOW_SOFTWARE=1
          #     exec ${pkgs.swayfx}/bin/sway
          #   '';
          # }
        ];
      };
    };
  };

  # SET DEFAULT SESSION BELOW -------------------------------------------------------------------------------

  # Uncomment ONE of the following options:
  
  # For i3 as default:
  services.displayManager.defaultSession = "none+i3";

  # For Sway (SwayFX) as default:
  # services.displayManager.defaultSession = "sway";

  # To always show session selection menu (comment out ALL defaultSession lines above)
  # When no defaultSession is set, LightDM will show the session selection menu

  # Environment variables that work for both window managers
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Install necessary packages for window managers
  environment.systemPackages = with pkgs; [
    lightdm
    lightdm-slick-greeter
    i3
    # sway        # REMOVED - Don't install regular sway so automatic session uses swayfx
    swayfx      # SwayFX for the automatic "sway" session
    xwayland    # Important for X11 app compatibility in Sway
  ];
}

# CURRENT STATE:
# - "sway" session: Automatic session created by programs.sway.enable, runs SwayFX ✅
# - "i3" session: Custom session, runs i3 ✅  
# - Custom "swayfx" session: Commented out (was conflicting with automatic "sway")
#
# Result: Clean 2-session setup with both working perfectly
#
# To restart display manager after changes:
# sudo systemctl restart display-manager
