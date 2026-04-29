{ config, pkgs, callPackage, ... }: 

{

  environment.pathsToLink = [ "/libexec" ];


    services.xserver.displayManager.lightdm.enable = true;

    services.xserver.desktopManager.cinnamon.enable = true;
        
       # Enable the X11 windowing system
  services.xserver = {
    enable = true;

    };
 
}
