# /modules/desktop-environment/display-manager/light-dm/lightdm-swayfx-advanced.nix
# Advanced LightDM configuration with SwayFX optimizations
{ config, lib, pkgs, ... }:

let
  backgroundImage = pkgs.copyPathToStore ../../slick-greeter/1.jpeg;
  
  # SwayFX startup script with optimizations
  swayfxStartScript = pkgs.writeShellScript "swayfx-start" ''
    # Set up environment for SwayFX
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export WAYLAND_DISPLAY=wayland-1
    
    # SwayFX specific optimizations
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    export WLR_DRM_NO_ATOMIC=1
    
    # NVIDIA specific (uncomment if using NVIDIA)
    # export WLR_NO_HARDWARE_CURSORS=1
    # export LIBVA_DRIVER_NAME=nvidia
    # export XDG_SESSION_TYPE=wayland
    # export GBM_BACKEND=nvidia-drm
    # export __GLX_VENDOR_LIBRARY_NAME=nvidia
    
    # Start SwayFX
    exec ${pkgs.swayfx-latest}/bin/sway
  '';
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
              show-a11y=false
              show-keyboard=false
              show-clock=true
              clock-format=%H:%M
              show-hostname=false
              show-power=true
              show-session=true
            '';
          };
        };
        
        # Configure sessions for i3 and SwayFX
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
            name = "swayfx";
            manage = "window";
            start = "${swayfxStartScript}";
          }
          {
            name = "swayfx-debug";
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
              export WLR_NO_HARDWARE_CURSORS=1
              export WLR_RENDERER_ALLOW_SOFTWARE=1
              export SWAY_DEBUG=1
              exec ${pkgs.swayfx-latest}/bin/sway --debug
            '';
          }
        ];
      };
    };
  };

  # SET DEFAULT SESSION BELOW -------------------------------------------------------------------------------

  # Uncomment ONE of the following options:
  
  # For i3 as default:
  # services.displayManager.defaultSession = "none+i3";

  # For SwayFX as default:
  # services.displayManager.defaultSession = "none+swayfx";

  # For SwayFX debug mode:
  # services.displayManager.defaultSession = "none+swayfx-debug";

  # To always show session selection menu (comment out ALL defaultSession lines above)
  # When no defaultSession is set, LightDM will show the session selection menu

  # Environment variables that work for both window managers
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Add SwayFX specific variables globally if needed
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Install necessary packages for both window managers
  environment.systemPackages = with pkgs; [
    lightdm
    lightdm-slick-greeter
    i3
    swayfx-latest
    xwayland
    # Additional SwayFX utilities
    wlr-randr
    wl-clipboard
    grim
    slurp
    swaylock
    swayidle
    swaybg
    waybar
    wofi
    mako
    brightnessctl
    playerctl
    pamixer
  ];

  # Enable graphics acceleration for SwayFX effects
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # XDG Portal configuration for SwayFX
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gtk"];
      sway.default = lib.mkForce ["wlr" "gtk"];
    };
  };

  # Security and polkit for SwayFX
  security.polkit.enable = true;

  # Font configuration for better SwayFX experience
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dejavu_fonts
    source-code-pro
  ];

  # Enable realtime scheduling for better SwayFX performance
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # System optimization for SwayFX
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };
}

# To restart display manager after changes:
# sudo systemctl restart display-manager

# SwayFX Configuration Examples:
# Add these to your ~/.config/sway/config for SwayFX features:
#
# # Basic SwayFX features
# corner_radius 10
# blur enable
# blur_xray enable
# blur_passes 2
# blur_radius 5
# shadows enable
# shadow_blur_radius 20
# shadow_color #0000007F
# default_dim_inactive 0.1
#
# # Advanced effects
# for_window [app_id=".*"] opacity 0.95
# for_window [class=".*"] opacity 0.95
#
# # Layer effects for waybar
# layer_effects "waybar" {
#     blur enable
#     shadows enable
#     corner_radius 10
# }
#
# # Workspace effects
# workspace_layout tabbed
# default_border pixel 2
# default_floating_border pixel 2
# gaps inner 10
# gaps outer 5
#
# # Window rules with effects
# for_window [app_id="firefox"] opacity 0.9
# for_window [app_id="Alacritty"] opacity 0.85
# for_window [class="discord"] opacity 0.9
