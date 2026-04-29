{ config, pkgs, callPackage, ... }: 

{

  environment.pathsToLink = [ "/libexec" ];


     # Enable the GNOME Desktop Environment.
       #services.xserver.displayManager.gdm.enable = true;
       services.xserver.displayManager.lightdm.enable = true;
       services.xserver.desktopManager.gnome.enable = true;
 
}
