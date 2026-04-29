# /home/ttr/nixos-config/modules/desktop/wm/x11/i3.nix
{ config, pkgs, ... }: 

{
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;
    
    desktopManager = {
      xterm.enable = false;
    };
  
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        arandr
        autokey
        autotiling
        arandr
        betterlockscreen 
        dunst
        feh
        dconf-editor
        i3altlayout
        i3status 
        i3lock
        i3blocks
        i3status 
        lxappearance
        libmpdclient
        mpd
        nitrogen
        picom-pijulius
        tdrop
        jumpapp
        wmctrl
        xprintidle #for auto lock in i3
        xprop
        xdotool
        xev
        xhost
        xdg-desktop-portal
        xdg-desktop-portal-gtk 

        # Lockscreen
        xautolock # autolocks
        lightlocker # locks screen for real
        lightdm-slick-greeter
      ];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
