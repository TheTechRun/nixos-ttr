{ config, lib, pkgs, ... }:

let
  # i3 config as a multi-line string using Nix's indented string syntax
  i3ConfigText = ''
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

  # DESKTOP DESKTOP DESKTOP DESKTOP                          

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

# caps lock (to make Hyper key: setxkbmap -option caps:hyper)
#set $h Mod3

set $b bindsym
set $e exec



#-----------------------------------------------------------------------------
# SOME OTHER COMMANDS
#-----------------------------------------------------------------------------

#workspace_auto_back_and_forth yes
tiling_drag titlebar

# For Hyper keys
#exec_always --no-startup-id xmodmap ~/.Xmodmap

# Select where next tile will go
#$b $s+v split vertical
#$b $s+h split horizontal

#-----------------------------------------------------------------------------
# BAR SETUP
#-----------------------------------------------------------------------------

# POLYBAR
#exec_always --no-startup-id $HOME/.config/polybar/config.ini
#default_border none

#i3bar here:
    bar {
           position top    
           status_command i3blocks -c ~/.config/i3/i3blocks/i3blocks.conf
          # font pango:Noto Sans Brahmi Bold 14
          #font pango:JetBrainsMonoNL Nerd Font Propo Bold 12
          font pango:JetBrainsMono Nerd Font Mono Bold 12
          #font pango:ProFontIIx Nerd Font Mono Bold 11
           # font pango: Literation Nerd Font Mono Bold 12
           tray_output primary
        colors {
#<colorclass>       <border> <background> <text>
separator #444444
background #$secondary
statusline #B1B1B1
focused_workspace #$secondary  #$main #$secondary
active_workspace  #$main #ffffff
  #$main
inactive_workspace  #$main #$secondary  #$main
urgent_workspace #eb709b #eb709b #ffffff
   }
}


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
set $main AAAAAA
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

$e --no-startup-id pyload
$e --no-startup-id autokey
$e --no-startup-id syncthing
#$e --no-startup-id screenkey
#$e --no-startup-id jumpapp

# Web Apps
#$e --no-startup-id $HOME/.config/i3/Web-Apps/ai.sh #a.i.
#$e --no-startup-id $HOME/.config/i3/Web-Apps/messengers.sh

# Scratchpad Apps
$e --no-startup-id bash $HOME/.config/i3/scripts/scratchpad.sh #scratchpad apps
#$e --no-startup-id fsearch
#$e --no-startup-id catfish
#$e --no-startup-id audacious
#$e --no-startup-id alacritty -t Resources -e btm
#$e --no-startup-id terminator -T Resources -e btm
#$e --no-startup-id terminator -l scratchterm 

# Startup Productivity
#exec_always --no-startup-id $HOME/.scripts/TTR-KensingtonExpert/saved-mappings/righty.sh #Kensington Expert Remaps with Scroll  
#exec_always --no-startup-id $HOME/.scripts/TTR-NuleaM512/saved-mappings/righty.sh #Nulea M512 Remaps with Scroll
exec_always --no-startup-id export QT_QPA_PLATFORMTHEME="qt5ct"
#exec_always --no-startup-id i3altlayout
$e --no-startup-id flameshot
$e --no-startup-id nm-applet # Nework Applet
$e --no-startup-id xautolock # autolock
$e --no-startup-id light-locker # lightdm locker
$e --no-startup-id greenclip daemon # Clipboard
$e --no-startup-id dunst -config $HOME/.config/dunst/dunstrc # dunst
#$e --no-startup-id numlockx on # number lock
$e --no-startup-id mega-sync



#OLD
#$e --no-startup-id flatpak run org.ferdium.Ferdium
#$e --no-startup-id chromium
#$e --no-startup-id flatpak run org.telegram.desktop
#$e --no-startup-id mega-sync
#$e --no-startup-id libinput-gestures-setup start # swipe gestures Laptop



# Change Volume or Toggle Mute - i3BLOCKS
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && pkill -RTMIN+10 i3blocks
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && pkill -RTMIN+10 i3blocks
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && pkill -RTMIN+10 i3blocks

# Change Volume or Toggle Mute - POLYBAR
#$b XF86AudioRaiseVolume $e amixer -q -D pulse sset Master 5%#+ && pkill -RTMIN+10 i3blocks 
#$b XF86AudioLowerVolume $e amixer -q -D pulse sset Master #5%- && pkill -RTMIN+10 i3blocks
#$b XF86AudioMute $e amixer -q -D pulse sset Master toggle && pkill -RTMIN+10 i3blocks

# Switch Audio between Thinkpad Dock and PC
$b $a+a $e $HOME/.config/i3/scripts/audio-toggle.sh

# Activate screen layout
$b $s+z $e bash $HOME/.screenlayout/monitors.sh

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
#$b $a+space $e bash $HOME/.scripts/TTR-Scripts/TTR-Rofi/TTR-Rofi.sh #Universal
# Rofi binding
$b $a+space exec $HOME/.scripts/TTR-Scripts/TTR-Rofi/TTR-Rofi.sh
$b $a+z $e rofi -show drun -show-icons #Program lists
$b $a+c $e bash $HOME/.scripts/rofiscripts/clipboard.sh # Clipboard
$b $s+Tab $e rofi -show window show-icons #tab switch open windows
$b $a+x $e $HOME/.scripts/TTR-Scripts/TTR-Rofi/TTR-notes.sh # notes
#$b $s+$a+7 $e $HOME/.scripts/TTR-Scripts/TTR-KensingtonExpert/launch.sh
$b $a+shift+7 $e $HOME/.scripts/TTR-NuleaM512/launch.sh
#$b $s+8 $e bash $HOME/.scripts/TTR-Scripts/TTR-KensingtonExpert/map-keys.sh

bindcode 105 exec bash $HOME/.scripts/TTR-Scripts/rofiscripts/Universal/Terminal_Scripts/N_m3u8DL-RE-with-prompts-MWP.sh
#$b $a+z $e bash $HOME/.config/rofi/launchers/type-ttr/launcher.sh
#$b $a+Tab $e bash $HOME/.config/rofi/launchers/type-ttr/tab-switch.sh #tab switch open windows


#APPLICATIONS  SECTION
# Use "Application Finder" program (or go to $HOME/.local/share/applications for launch commands for other distros)
$b Print $e flameshot gui
#$b Control+Print $e scrot -d 5 $HOME/Pictures/Screenshots/screenshot_%Y-%m-%d-%H-%M-%S.png
$b Control+Print $e scrot -d 5 /mnt/12tb/Pictures-2/Screenshots/screenshot_%Y-%m-%d-%H-%M-%S.png
#$b $s+e $e $HOME/.config/xmouseless/result/bin/xmouseless-wrapped
#$b $s+s $e syncthing
#$b $s+o $e flatpak run com.github.dynobo.normcap
$b $s+o $e normcap

#$b $s+p $e polybar
#$b $s+a $e autokey-gtk
$b $a+p $e pkill picom
for_window [class="i3_spacer"] border none
#$b $s+s $e $HOME/.config/i3/scripts/create_spacer.-alacritty.sh # Blank Tiles
$b $s+Shift+k $e alacritty
$b $s+k $e terminator
#$b $s+j $e joplin-desktop
$b $s+j $e flatpak run net.cozic.joplin_desktop
#$b $s+j $e joplin
$b $s+t $e  codium #text
$b $s+f $e  thunar  $HOME/Greetings #filebrowser
$b $s+n $e $HOME/.scripts/new-file-thunar.sh
$b $s+d $e --no-startup-id terminator -T Debian-DISTROBOX -e "distrobox enter debian" && i3-msg floating toggle


#$b $s+d $e --no-startup-id terminator -T ARCH -e "enter-arch-ttr"

$b $s+v $e vial
#$b $s+t $e terminator && i3-msg floating toggle
#$b $s+v $e  gnome-text-editor #text
# Hyper combinations
#$b $s+p $e ~/.nix-profile/bin/polybar
#$b Control+$a+Delete $e --no-startup-id alacritty -e btm #Bottom resource manager

# SCRIPTS SECTION

$b $s+$a+1 $e bash $HOME/.config/i3-layout-manager/layout_selector.sh #layout selector
$b $s+$a+2 $e bash $HOME/.scripts/TTR-Scripts/TTR-Themer/TTR-i3-Themer.sh # theme switcher
$b $s+$a+4 $e bash $HOME/.config/dunst/toggle_dunst.sh
$b $s+$a+5 $e bash $HOME/.scripts/TTR-Scripts/TTR-Popup/Keyboard/launch.sh #Keyboard Popup
$b $s+$a+6 $e bash $HOME/.scripts/TTR-Scripts/TTR-Popup/Vim/launch.sh # Vim Popup
$b $s+$a+minus $e bash $HOME/.scripts/switch_to_headphones.sh # Switch to headphones
$b $s+$a+plus $e bash $HOME/.scripts/switch_to_speakers.sh # Switch to speakers


# WINDOWS Section
# Use Mouse+$s to drag floating windows to their wanted position
floating_modifier $s

#Kill all except (to remove or add go from . --->|)
$b Control+$a+q [title="^(?!.*SCRATCHTERM|.*RED|.*fsearch|.*catfish|.*Lollypop|.*Ferdium).*"] kill

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

# Scripts Section
$b $s+F4 $e bash $HOME/.config/i3/scripts/workspace-1.sh

$b $s+F5 $e bash $HOME/.scripts/workbench/cf_daily.sh
$b $s+F6 $e bash $HOME/.scripts/TTR-Scripts/TTR-Themer/TTR-i3-Themer.sh
#$b $s+F6 $e bash $HOME/.config/i3/Web-Apps/ai.sh
#$b $s+F7 $e bash $HOME/.config/i3/Web-Apps/messengers.sh
$b $s+F7 $e bash $HOME/.config/i3/scripts/swap.sh 
#$b $s+F9 $e bash $HOME/.config/i3/scripts/swap-to-main.sh

#$b $s+F3 layout tabbed

 # LAYOUTS (F5-F8)
#$b $s+F5 $e bash $HOME/.config/i3-layout-manager/layout_manager.sh BIG_PRODUCTIVITY
#$b $s+F $e bash $HOME/.config/i3-layout-manager/layout_manager.sh CF1
#$b $s+F7 $e bash $HOME/.config/i3-layout-manager/layout_manager.sh BIG_TOP
#$b $s+F8 $e bash $HOME/.config/i3-layout-manager/layout_manager.sh FOUR_EVEN

 #FAVORITES (F9-F12)
#$b $s+F9 $e bash $HOME/.scripts/workbench/big_productivity.sh
#$b $s+F11 $e bash $HOME/.scripts/workbench/subscribers.sh
#$b $s+F12 $e bash $HOME/.scripts/workbench/big_terminals.sh


#----------------------------------------------------------------------------- 
# WORKSPACE SECTION
#------------------------------------------------------------------------------

# Workspace Binds 
# ( xprop | grep WM_CLASS ) for class and instance
# (?i) for case insensitive

# Bind workspaces to monitors
workspace 1 output DP-2
workspace 2 output DP-2
workspace 3 output DP-2
workspace 4 output HDMI-1
workspace 5 output HDMI-1 
workspace 6 output HDMI-1
workspace 7 output DP-1 
workspace 8 output DP-1 
workspace 9 output DP-1 
workspace 10 output DP-1



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
set $ws10 "10"


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
$b $s+0 workspace $ws10



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
$b $s+Shift+0 move container to workspace $ws10; workspace 10


# ( xprop | grep WM_CLASS ) for class and instance
# (?i) for case insensitive

# WORKSPACE 1 
for_window [class="Codium"] move to workspace 1; workspace 1
for_window [title="Joplin"] move window to workspace 1; workspace 1

# WORKSPACE 2 
for_window [class="firefox"] move to workspace 2; workspace 2

# WORKSPACE 3
for_window [class="libreoffice-calc"] move to workspace 3; workspace 3

# WORKSPACE 4
for_window [class="Claude"] move to workspace 4; workspace 4

# WORKSPACE 5
for_window [class="Ferdium"] move to workspace 5; workspace 5


# WORKSPACE 6
$b $s+w $e chromium

# WORKSPACE 7
for_window [class="Chromium"] move to workspace 7; workspace 7

#for_window [class="Thunar"] move to workspace 7; workspace 7

# WORKSPACE 8

# WORKSPACE 9
for_window [class="Gimp-2.10"] move to workspace 9; workspace 9 
for_window [class="Vial"] move to workspace 9; workspace 9
for_window [class="Virt-manger"] move to workspace 9; workspace 9
$b $s+y $e chromium --new-window https://www.youtube.com/feed/subscriptions
for_window [title="(?i)Subscriptions - YouTube - Chromium"] move to workspace 9; workspace 9
  
# WORKSPACE 10
for_window [class="vlc"] move to workspace 10

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

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        $b j resize shrink width 10 px or 10 ppt
        $b k resize grow height 10 px or 10 ppt
        $b l resize shrink height 10 px or 10 ppt
        $b semicolon resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        $b Left resize shrink width 10 px or 10 ppt
        $b Down resize grow height 10 px or 10 ppt
        $b Up resize shrink height 10 px or 10 ppt
        $b Right resize grow width 10 px or 10 ppt

        #resize Windows
        # Left Monitor
        $b F1 $e --no-startup-id "i3-msg resize set 500 500 px; i3-msg move position center"
       $b F2 $e --no-startup-id "i3-msg resize set 800 600 px; i3-msg move position center"
       $b F3 $e --no-startup-id "i3-msg resize set 1600 1000 px; i3-msg move position center"
       $b F4 $e --no-startup-id "i3-msg resize set 1880 1040 px; i3-msg move position center"

        # Middle Monitor
       $b F5 $e --no-startup-id "i3-msg resize set 1900 960 px px; i3-msg move position center" 
       $b F6 $e --no-startup-id "i3-msg resize set 2000 1200 px; i3-msg move position center"
       $b F7 $e --no-startup-id "i3-msg resize set 2200 1250 px; i3-msg move position center"
       $b F8 $e --no-startup-id "i3-msg resize set 2450 1360 px; i3-msg move position center"
        
        
        # Portrait  Monitor
       #$b F9 $e --no-startup-id "i3-msg resize set 700 800 px; i3-msg move position #center"
       #$b F10 $e --no-startup-id "i3-msg resize set 700 1200 px; i3-msg move position #center"
       #$b F11 $e --no-startup-id "i3-msg resize set 800 1400 px; i3-msg move position #center"
       #$b F12 $e --no-startup-id "i3-msg resize set 1040 1880 px; i3-msg move position #center"

        # back to normal: Enter or Escape
        $b Return mode "default"
        $b Escape mode "default"
}

#---------------------------------------------------------------------
# WINDOW RULES
#---------------------------------------------------------------------
for_window [instance="gpick" class="Gpick"] floating enable, resize # colorpicker
#for_window [instance="autokey-gtk" class="Autokey-gtk"] floating enable, resize # autokey
#for_window [instance="autokey" class="Autokey"] floating enable, resize set 700 700, move 65 1080 # autokey
#for_window [instance="nemo"] floating enable, resize set 700 700, move 65 1080
#for_window [class="Alacritty"] floating enable, resize set 700 700, move 65 1080
for_window [class="Gnome-terminal"] floating enable, resize set 700 700, move 65 1080

for_window [class="Tk"] floating enable, resize set 30rrrdffffffff0 80, move 45 1080

#for_window [instance="bitwarden" class="Bitwarden"] floating enable, resize # bitwarden
for_window [class=".protonvpn-app"] floating enable, resize # protonvpn

for_window [title="(?i)VLC media player"] focus
#for_window [title=".scripts"] focus
#for_window [title=".config"] focus

# This  disables floating windows for certain terminators until I can figure out why they keep floating:
for_window [class="Terminator" title="Terminator"] floating disable
for_window [class="Terminator" title="ARCH-DISTROBOX"] floating disable
for_window [class="Terminator" title="DEFAULT"] floating disable
for_window [class="Terminator" title="CF"] floating disable
for_window [class="Audacious" title="Add Files"] floating disable
 
# SCRATCHPAD RULES

# Make the currently focused window a scratchpad
$b $s+plus move scratchpad
#$b $a+plus move scratchpad

# Cycle through Scratchpad Windows
$b $s+minus scratchpad show
#$b $a+minus scratchpad show

# Applications binded to Scratchpad
for_window [class="com.sayonara-player.Sayonara"] move window to scratchpad
#$b $s+m [class="com.sayonara-player.Sayonara"] scratchpad show 
for_window [class="Clementine"] move window to scratchpad
$b $s+m [class="Clementine"] scratchpad show 
for_window [title="FSearch"] move window to scratchpad
$b $s+s [title="FSearch"] scratchpad show 
for_window [class="Catfish"] move window to scratchpad
$b $s+shift+s [class="Catfish"] scratchpad show 
for_window [title="SCRATCHTERM"] move window to scratchpad
$b Menu [title="SCRATCHTERM"] scratchpad show, move position center, resize set 1600 1000 px
for_window [title="Autokey"] move window to scratchpad
$b $s+a [class="Autokey"] scratchpad show, move position center, resize set 1600 1000 px
for_window [title="Bitwarden"] move window to scratchpad
$b $s+b [title="Bitwarden"] scratchpad show 
for_window [title="Resources"] move window to scratchpad
$b Control+$a+Delete [title="Resources"] scratchpad show 
for_window [title="keycheat.png"] move window to scratchpad
#$b $s+g [title="keycheat.png"] scratchpad show, move position center, move to workspace 7, resize set 1600 1000 px 
$b $s+g [title="keycheat.png"] scratchpad show, move position center, resize set 1600 1000 px 
for_window [title="mousecheat.png"] move window to scratchpad
bindcode $s+117 [title="mousecheat.png"] scratchpad show, move position center, resize set 1600 1000 px 



# MORE STARTUP SCRIPTS:
exec_always --no-startup-id  $HOME/.screenlayout/monitors.sh # monitors layouts
$e --no-startup-id $HOME/.config/i3/scripts/workspace-1.sh # Startup programs


#$e --no-startup-id sleep 10 && bash $HOME/.scripts/workbench/big_productivity.sh # Big Productivity Layout & Startup Apps
#$e --no-startup-id sleep 22 && bash $HOME/.scripts/workbench/cf_daily.sh

# Compositor to stop screen tearing
exec_always --no-startup-id picom -b --config $HOME/.config/picom.conf



#-----------------------------------------------------------------------------  
# NOTES 
#------------------------------------------------------------------------------

#to Reload:
# i3-msg reload

# To bind programs to workspaces open a terminal and run:  "xprop | grep WM_CLASS"
#Click on a window and you will get the instance and class name output

# To get window titles open a terminal and run:  "wmctrl -l | grep "one word in the windows title"". Example: wmctrl -l | grep "Chromium"

# To get key names open terminal and type: xev
# ?! in title class or instance makes it case insensitive

# Please see http://i3wm.org/docs/userguide.html for a complete reference!
  #  Mod1: Typically corresponds to the left Alt key.
  #  Mod2: This often corresponds to the Num Lock key.
  #  Mod3: This is usually unused by default.
  #  Mod4: Often corresponds to the Super (Windows) key.
  #  Mod5: Often corresponds to the Menu key or Compose key.



# To make all scripts $eutable, cd to  top directory and run: find . -type f \( -name "*.py" -o -name "*.sh" -o -name "*.pl" \) -$e chmod +x {} + 
  '';
in
{
  # Import the common i3 setup
  imports = [ ./i3.nix ];
  
  # Configure i3 using the configFile option
  services.xserver.windowManager.i3 = {
    configFile = i3ConfigFile;
  };
  
  # Make i3 use our config by adding a setup script
  system.activationScripts.setupI3Config = {
    deps = [];
    text = "${setupI3Config}/bin/setup-i3-config";
  };
  
  # Add any laptop-specific packages
  environment.systemPackages = with pkgs; [
    polybar
  ];
}
