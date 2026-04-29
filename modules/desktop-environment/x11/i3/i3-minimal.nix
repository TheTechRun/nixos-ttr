# modules/desktop/wm/x11/i3/i3-minimal.nix
{ config, pkgs, lib, ... }:

let
  # i3 config as a multi-line string using Nix's indented string syntax
  i3ConfigText = 
''
#  ____             __ _                          _   _           
# / ___|___  _ __  / _(_) __ _ _   _ _ __ ___  __| | | |__  _   _ 
#| |   / _ \| '_ \| |_| |/ _` | | | | '__/ _ \/ _` | | '_ \| | | |
#| |__| (_) | | | |  _| | (_| | |_| | | |  __/ (_| | | |_) | |_| |
# \____\___/|_| |_|_| |_|\__, |\__,_|_|  \___|\__,_| |_.__/ \__, |
#                        |___/                              |___/ 
# _____ _____ ____  
#|_   _|_   _|  _ \ 
#  | |   | | | |_) |
#  | |   | | |  _ < 
#  |_|   |_| |_| \_\

  # LAPTOP LAPTOP LAPTOP LAPTOP                        

#to Reload from terminal:
# i3-msg reload

# SEE NOTES AT END OF THIS FILE

#-----------------------------------------------------------------------------
# VARIABLES SETUP
#-----------------------------------------------------------------------------

# Set home directory here
set $HOME /home/ttr/

# windows key 
set $s Mod4 

 #alt
set $a Mod1 

set $b bindsym
set $e exec



#-----------------------------------------------------------------------------
# SOME OTHER COMMANDS
#-----------------------------------------------------------------------------

#workspace_auto_back_and_forth yes
tiling_drag titlebar


# Select where next tile will go
#$b $s+v split vertical
#$b $s+h split horizontal

#-----------------------------------------------------------------------------
# BAR SETUP
#-----------------------------------------------------------------------------

# POLYBAR
exec --no-startup-id polybar

#default_border none

#i3bar here:
#    bar {
#           position top    
#           status_command i3blocks -c ~/.config/i3/i3blocks/i3blocks.conf
#          # font pango:Noto Sans Brahmi Bold 14
#          #font pango:JetBrainsMonoNL Nerd Font Propo Bold 12
#          font pango:JetBrainsMono Nerd Font Mono Bold 12
#          #font pango:ProFontIIx Nerd Font Mono Bold 11
#           # font pango: Literation Nerd Font Mono Bold 12
#           tray_output primary
#        colors {
##<colorclass>       <border> <background> <text>
#separator #444444
#background #$secondary
#statusline #B1B1B1
#focused_workspace #$secondary  #$main #$secondary
#active_workspace  #$main #ffffff
#  #$main
#inactive_workspace  #$main #$secondary  #$main
#urgent_workspace #eb709b #eb709b #ffffff
#   }
#}


#---------------------------------------------------------------------
# WINDOWS THEME SETUP
#---------------------------------------------------------------------

# GAPS & Wallpaper
gaps inner 10
gaps outer 5
exec_always --no-startup-id sleep 3 && nitrogen --restore # wallpapers


# Screenshot GAPS & Wallpaper
#gaps inner 20
#gaps outer 20
#exec_always --no-startup-id sleep 3 && nitrogen --set-zoom-fill $HOME/Pictures/Wallpapers/Other/AAAAAA.jpeg


# Window Title Font
  font pango:JetBrainsMonoNL Nerd Font Propo Bold 12
#font pango:JetBrainsMono Nerd Font Mono Bold 12
#font pango:ProFontIIx Nerd Font Mono-Regular Bold 14
#font pango:Noto Sans Brahmi Bold 10
#font pango:JetBrainsMono Nerd Font Mono Bold 14
#font pango:DejaVu Sans Mono Bold 14       


# Colors
set $main CC0000
set $secondary 1E1E1E
set $focusedtitletext 000000
set $unfocusedtitletext ffffff


# CHANGE WINDOW BORDER COLORS

# class        border  background  text  indicator child_border

client.focused  #$focusedtitletext  #$main #$focusedtitletext  #$secondary  #$secondary 

client.focused_inactive #$main #$secondary #$unfocusedtitletext #$main #$main

client.unfocused #$secondary #$secondary #$unfocusedtitletext #$main #$main

client.urgent #$main #$main #$unfocusedtitletext #$main #$main

client.placeholder  #$secondary #$main  #$secondary  #$secondary  #$secondary 


#---------------------------------------------------------------------
# STARTUP SECTION
#---------------------------------------------------------------------

# Startup Apps


# Scratchpad Apps
$e --no-startup-id bash $HOME/.config/i3/scripts/scratchpad.sh #scratchpad apps
#$e --no-startup-id fsearch
#$e --no-startup-id catfish
#$e --no-startup-id alacritty -t Resources -e btm
#$e --no-startup-id terminator 

# Startup Productivity
$e --no-startup-id flameshot
$e --no-startup-id bitwarden-desktop
$e --no-startup-id nm-applet # Nework Applet
$e --no-startup-id xautolock # autolock
$e --no-startup-id light-locker # lightdm locker
$e --no-startup-id greenclip daemon # Clipboard
$e --no-startup-id dunst -config $HOME/.config/dunst/dunstrc # dunst


#---------------------------------------------------------------------
# LOCKSCREEN SECTION
#-----------------------------------------------------l----------------

#Light DM Lock 
 $b $s+l $e light-locker-command -l
#$b $s+l $e light-locker-command -l
#$b Ctrl+$a+l $e light-locker-command -l
#$b Ctrl+$a+l dm-tool switch-to-greeter
exec_always --no-startup-id xautolock -time 10 -locker "light-locker-command -l"
             


#---------------------------------------------------------------------
# KEYBIND SECTION
#---------------------------------------------------------------------


# ROFI Section (Run rofi -dump-config > $HOME/.config/rofi/config.rasi to get first config file)

#$b $a+space $e rofi -show drun


#APPLICATIONS  SECTION

#$b $s+p $e polybar
$b $a+p $e pkill picom
$b $s+Shift+k $e terminator
$b $s+t $e  codium #text
$b $s+f $e  thunar 
$b $s+n $e $HOME/.scripts/new-file-thunar.sh
#$b $s+t $e terminator





# WINDOWS Section
# Use Mouse+$s to drag floating windows to their wanted position
floating_modifier $s

# kill focused window
$b $s+q kill

# kill all WINDOWS
$b Control+shift+q $e $HOME/.scripts/closeallapps.sh

# FOCUS ON WINDOW
# Cursor keys:
$b $s+Up focus up
$b $s+Down focus down
$b $s+Left focus left
$b $s+Right focus right

#bindcode $s+112 focus up 
#bindcode $s+117 focus down  



# MOVE FOCUSED WINDOW
# Cursor keys:
$b $s+Shift+Up move up
$b $s+Shift+Down move down
$b $s+Shift+Left move left
$b $s+Shift+Right move right



# enter fullscreen mode for the focused container
$b $s+Return fullscreen

# change focus between tiling / floating windows
$b $s+space focus mode_toggle

#---------------------------------------------------------------------
# LAYOUT SECTION
#---------------------------------------------------------------------

  #CONTAINER LAYOUTS (F1-F4)
# change container layout (stacked, tabbed, toggle split)
$b $s+F1 layout stacking
$b $s+F2 layout toggle split
$b $s+F3 floating toggle  


#----------------------------------------------------------------------------- 
# WORKSPACE SECTION
#------------------------------------------------------------------------------


# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws0 "0"


# switch to workspace
$b $s+1 workspace $ws1 
$b $s+2 workspace $ws2 
$b $s+3 workspace $ws3 
$b $s+4 workspace $ws4
$b $s+5 workspace $ws5
$b $s+6 workspace $ws6
$b $s+7 workspace $ws7
$b $s+8 workspace $ws8
$b $s+9 workspace $ws9
$b $s+0 workspace $ws0



# move focused container to workspace
$b $s+Shift+1 move container to workspace $ws1; workspace 1
$b $s+Shift+2 move container to workspace $ws2; workspace 2
$b $s+Shift+3 move container to workspace $ws3; workspace 3
$b $s+Shift+4 move container to workspace $ws4; workspace 4
$b $s+Shift+5 move container to workspace $ws5; workspace 5
$b $s+Shift+6 move container to workspace $ws6; workspace 6
$b $s+Shift+7 move container to workspace $ws7; workspace 7
$b $s+Shift+8 move container to workspace $ws8; workspace 8
$b $s+Shift+9 move container to workspace $ws9; workspace 9
$b $s+Shift+0 move container to workspace $ws0; workspace 0


# Workspace Binds 
# ( xprop | grep WM_CLASS ) for class and instance
# (?i) for case insensitive

# Workspace 1 - web browsers
#for_window [title="(?i)new tab - Chromium"] move to workspace 1
$b $s+w $e chromium

# Workspace 2 - text
for_window [class="VSCodium"] move to workspace 2; workspace 2; focus
assign [class="xed"] $ws2 #text
#$b $a+t $e xed #text

# WORKSPACE 3 - files
for_window [class="Thunar"] move to workspace 3; workspace 3; focus




# WORKSPACE 0 - Scrap Paper

# reload the configuration file
$b $s+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
$b $s+Shift+r restart
# exit i3 (logs you out of your X session)
$b $s+Shift+e $e "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
$b $s+r mode "resize"
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window's width.
        # Pressing right will grow the window's width.
        # Pressing up will shrink the window's height.
        # Pressing down will grow the window's height.
        $b j resize shrink width 50 px or 50 ppt
        $b k resize grow height 50 px or 50 ppt
        $b l resize shrink height 50 px or 50 ppt
        $b semicolon resize grow width 50 px or 50 ppt

        # same bindings, but for the arrow keys
        $b Left resize shrink width 50 px or 50 ppt
        $b Down resize grow height 50 px or 50 ppt
        $b Up resize shrink height 50 px or 50 ppt
        $b Right resize grow width 50 px or 50 ppt


        # back to normal: Enter or Escape
        $b Return mode "default"
        $b Escape mode "default"
}

#---------------------------------------------------------------------
# WINDOW RULES
#---------------------------------------------------------------------

#for_window [instance="bitwarden" class="Bitwarden"] floating enable, resize # bitwarden


# This  disables floating windows for certain terminators until I can figure out why they keep floating:
# This  disables floating windows for certain terminators until I can figure out why they keep floating:
for_window [class="Terminator" title="Terminator"] floating disable
for_window [class="Terminator" title="ARCH-DISTROBOX"] floating disable
for_window [class="Terminator" title="ARCH-TERMINAL"] floating disable
for_window [class="Terminator" title="SSH-TERMINAL"] floating disable
for_window [class="Terminator" title="DEFAULT"] floating disable
for_window [class="Terminator" title="CF"] floating disable
for_window [class="Audacious" title="Add Files"] floating disable

# SCRATCHPAD SECTION

# Make the currently focused window a scratchpad
$b $s+plus move scratchpad
#$b $a+plus move scratchpad

# Cycle through Scratchpad Windows
$b $s+minus scratchpad show
#$b $a+minus scratchpad show

# Applications binded to Scratchpad
for_window [title="FSearch"] move window to scratchpad, move position center, resize set 1600 1000 px
$b $s+s [title="FSearch"] scratchpad show, move position center, resize set 1600 1000 px
for_window [class="Bitwarden"] move window to scratchpad, move position center, resize set 1600 1000 px
$b $s+b [class="Bitwarden"] scratchpad show, move position center, resize set 1600 1000 px

'';

  # Create a file containing the i3 config
  i3ConfigFile = pkgs.writeText "i3-config" i3ConfigText;
  
  # Create a script that will symlink our NixOS i3 config to the user's config
  setupI3Config = pkgs.writeShellScriptBin "setup-i3-config" ''
    mkdir -p /home/ttr/.config/i3
    # Backup existing config if it's not a symlink
    if [ -f /home/ttr/.config/i3/config ] && [ ! -L /home/ttr/.config/i3/config ]; then
      mv /home/ttr/.config/i3/config /home/ttr/.config/i3/config.backup-$(date +%Y%m%d%H%M%S)
    fi
    # Create symlink from the NixOS-generated config
    ln -sf ${i3ConfigFile} /home/ttr/.config/i3/config
    chown -h ttr:ttr /home/ttr/.config/i3/config
  '';
in
{
  # i3 service configuration (from i3-with-hosts.nix)
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
        betterlockscreen
        dconf-editor
        dmenu
        dunst
        feh
        flameshot
        haskellPackages.greenclip
        i3altlayout
        i3blocks
        i3lock
        i3status
        jumpapp
        libmpdclient
        lightlocker
        lightdm-slick-greeter
        lxappearance
        mpd
        nitrogen
        pamixer
        picom
        picom-pijulius
        playerctl
        #polybar
        rofi
        tdrop
        wmctrl
        xautolock
        xclip
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdotool
        setxkbmap
        xev
        xhost
        xmodmap
        xprop
        xprintidle
      ];
      # Use our custom config file
      configFile = i3ConfigFile;
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  # Make i3 use our config by adding a setup script
  system.activationScripts.setupI3Config = {
    deps = [];
    text = "${setupI3Config}/bin/setup-i3-config";
  };
  
  # Add any minimal-specific packages
  environment.systemPackages = with pkgs; [
    polybar
  ];
}
