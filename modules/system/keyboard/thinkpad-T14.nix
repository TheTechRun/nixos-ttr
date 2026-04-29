# ThinkPad-specific keyboard configuration
# Remaps Print Screen key to Menu button
{ config, pkgs, ... }:

{
  # Console keyboard configuration
  console = {
    useXkbConfig = true;
  };

  # X11 keyboard configuration
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
      # No XKB options needed since we're using xmodmap for key remapping
      options = "";
    };
  };

  # Key remapping packages
  environment.systemPackages = with pkgs; [
    xmodmap
    xev  # For debugging key codes if needed
  ];

  # Print Screen -> Menu key remapping
  services.xserver.displayManager.sessionCommands = ''
    # Remap Print Screen (keycode 107) to Menu key
    ${pkgs.xmodmap}/bin/xmodmap -e "keycode 107 = Menu"
  '';

  # For Wayland environments (Hyprland/Sway compatibility)
  # The xmodmap command above works through XWayland
  
  # Alternative approach using XKB custom rules (more permanent)
  # Uncomment if you prefer this method over xmodmap:
  # environment.etc."X11/xkb/symbols/thinkpad" = {
  #   text = ''
  #     partial modifier_keys
  #     xkb_symbols "printscreen_menu" {
  #         key <PRSC> { [ Menu ] };
  #     };
  #   '';
  # };
}