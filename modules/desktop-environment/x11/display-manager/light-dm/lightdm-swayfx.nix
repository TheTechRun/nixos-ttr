# /modules/desktop-environment/display-manager/light-dm/lightdm-swayfx.nix
# Clean LightDM configuration with only i3 and SwayFX sessions
{ config, lib, pkgs, ... }:

let
  backgroundImage = pkgs.copyPathToStore ../../slick-greeter/1.jpeg;
  
  # SwayFX startup script with better error handling
  swayfxStartScript = pkgs.writeShellScript "swayfx-start" ''
    # Set up runtime directory
    if [ -z "$XDG_RUNTIME_DIR" ]; then
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    fi
    
    # Ensure runtime directory exists
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # Set up environment for SwayFX
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export WAYLAND_DISPLAY=wayland-1
    
    # SwayFX specific optimizations with fallbacks
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    export WLR_DRM_NO_ATOMIC=1
    export WLR_RENDERER=vulkan,gles2,pixman
    
    # Additional stability fixes
    export WLR_DRM_DEVICES=/dev/dri/card0
    export MESA_LOADER_DRIVER_OVERRIDE=i965
    
    # Log output for debugging
    exec ${pkgs.swayfx}/bin/sway 2>&1 | tee /tmp/swayfx.log
  '';

  # Safe SwayFX startup script (software rendering only)
  swayfxSafeStartScript = pkgs.writeShellScript "swayfx-safe-start" ''
    # Set up runtime directory
    if [ -z "$XDG_RUNTIME_DIR" ]; then
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    fi
    
    # Ensure runtime directory exists
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # Set up environment for SwayFX (safe mode)
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export WAYLAND_DISPLAY=wayland-1
    
    # Force software rendering for compatibility
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    export WLR_RENDERER=pixman
    export LIBGL_ALWAYS_SOFTWARE=1
    export WLR_DRM_NO_ATOMIC=1
    export WLR_DRM_NO_MODIFIERS=1
    
    # Log output for debugging
    exec ${pkgs.swayfx}/bin/sway 2>&1 | tee /tmp/swayfx-safe.log
  '';
in
{
  services = {
    xserver = {
      enable = true;
      
      # Explicitly disable all desktop environments
      desktopManager = {
        xfce.enable = lib.mkForce false;
        gnome.enable = lib.mkForce false;
        plasma5.enable = lib.mkForce false;
        mate.enable = lib.mkForce false;
        cinnamon.enable = lib.mkForce false;
        lxqt.enable = lib.mkForce false;
        enlightenment.enable = lib.mkForce false;
        pantheon.enable = lib.mkForce false;
      };
      
      # Disable window managers we don't want
      windowManager = {
        # Keep only what we need
        i3.enable = false;  # We'll define our own i3 session
        qtile.enable = lib.mkForce false;
        xmonad.enable = lib.mkForce false;
        openbox.enable = lib.mkForce false;
        herbstluftwm.enable = lib.mkForce false;
        dwm.enable = lib.mkForce false;
        awesome.enable = lib.mkForce false;
        bspwm.enable = lib.mkForce false;
        spectrwm.enable = lib.mkForce false;
        cwm.enable = lib.mkForce false;
        jwm.enable = lib.mkForce false;
        wmderland.enable = lib.mkForce false;
      };
      
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
        
        # ONLY define the sessions we want
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
            name = "swayfx-safe";
            manage = "window";
            start = "${swayfxSafeStartScript}";
          }
          {
            name = "swayfx-debug";
            manage = "window";
            start = ''
              # Set up runtime directory
              if [ -z "$XDG_RUNTIME_DIR" ]; then
                export XDG_RUNTIME_DIR="/run/user/$(id -u)"
              fi
              mkdir -p "$XDG_RUNTIME_DIR"
              chmod 700 "$XDG_RUNTIME_DIR"
              
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
              export WLR_DEBUG=1
              exec ${pkgs.swayfx}/bin/sway --debug 2>&1 | tee /tmp/swayfx-debug.log
            '';
          }
          {
            name = "sway-vanilla";
            manage = "window";
            start = ''
              # Set up runtime directory
              if [ -z "$XDG_RUNTIME_DIR" ]; then
                export XDG_RUNTIME_DIR="/run/user/$(id -u)"
              fi
              mkdir -p "$XDG_RUNTIME_DIR"
              chmod 700 "$XDG_RUNTIME_DIR"
              
              export XDG_SESSION_TYPE=wayland
              export XDG_CURRENT_DESKTOP=sway
              export SDL_VIDEODRIVER=wayland
              export QT_QPA_PLATFORM=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
              export MOZ_ENABLE_WAYLAND=1
              export _JAVA_AWT_WM_NONREPARENTING=1
              export WAYLAND_DISPLAY=wayland-1
              exec ${pkgs.sway}/bin/sway 2>&1 | tee /tmp/sway-vanilla.log
            '';
          }
        ];
      };
    };
  };

  # SET DEFAULT SESSION BELOW -------------------------------------------------------------------------------

  # For i3 as default:
  services.displayManager.defaultSession = "none+i3";

  # For SwayFX as default:
  # services.displayManager.defaultSession = "none+swayfx";

  # For SwayFX safe mode:
  # services.displayManager.defaultSession = "none+swayfx-safe";

  # Environment variables that work for both window managers
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Install only necessary packages - NO desktop environment packages
  environment.systemPackages = with pkgs; [
    lightdm
    lightdm-slick-greeter
    i3
    sway          # Regular sway for fallback
    swayfx        # SwayFX with effects
    xwayland
    # Essential Wayland tools
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
    # Debug tools
    glxinfo
    vulkan-tools
    mesa-demos
  ];

  # Explicitly prevent desktop environment packages from being installed
  environment.pathsToLink = lib.mkForce [
    "/bin"
    "/share/applications"
    "/share/icons"
    "/share/pixmaps"
    "/share/man"
    "/share/info"
  ];

  # Hide unwanted .desktop files by creating empty ones with NoDisplay=true
  environment.etc = {
    "xdg/applications/exo-file-manager.desktop".text = ''
      [Desktop Entry]
      Name=Thunar
      NoDisplay=true
      Hidden=true
    '';
    "xdg/applications/thunar.desktop".text = ''
      [Desktop Entry]
      Name=Thunar
      NoDisplay=true
      Hidden=true
    '';
    "xdg/applications/caja.desktop".text = ''
      [Desktop Entry]
      Name=Caja
      NoDisplay=true
      Hidden=true
    '';
    "xdg/applications/xfce4-session-logout.desktop".text = ''
      [Desktop Entry]
      Name=XFCE Logout
      NoDisplay=true
      Hidden=true
    '';
  };

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
    noto-fonts-cjk-sans
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

# Clean LightDM Sessions - Only i3 and SwayFX variants should appear!
# 
# Debug Steps if SwayFX crashes:
# 1. Check logs: journalctl -f
# 2. Try "swayfx-safe" session (software rendering)
# 3. Try "sway-vanilla" session (regular sway)
# 4. Check log files in /tmp/swayfx*.log
# 5. Run: glxinfo | grep -i opengl
# 6. Run: lspci | grep -i vga
#
# To remove XFCE entries from home-manager:
# Remove these from home.packages in home-ttr.nix:
# - xfce.thunar
# - mate.caja-with-extensions
