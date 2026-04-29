# This remaps Caps as Hyper

{ config, pkgs, ... }:

{
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:hyper";  # This line remaps Caps Lock to Hyper

    displayManager.sessionCommands = ''
      # Debug log
      echo "Executing xmodmap and setxkbmap commands" >> /tmp/xkb_debug.log

      # Try setxkbmap first
      ${pkgs.setxkbmap}/bin/setxkbmap -option caps:hyper

      # Then apply xmodmap
      ${pkgs.xmodmap}/bin/xmodmap ${pkgs.writeText "xmodmap-config" ''
        clear lock
        clear mod3
        keycode 66 = Hyper_L
        add mod3 = Hyper_L
      ''}

      # Log xmodmap result
      ${pkgs.xmodmap}/bin/xmodmap -pke | grep -i hyper >> /tmp/xkb_debug.log 2>&1

      # existing sessionCommands:
      ${pkgs.xrandr}/bin/xrandr --setprovideroutputsource 2 0
      ${pkgs.xhost}/bin/xhost +local:

      # Any other existing sessionCommands...
    '';
  };
}