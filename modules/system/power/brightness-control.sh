#!/usr/bin/env bash
# Deprecated x11 only
# brightness-control.sh - ThinkPad T14 brightness control script

# Function to set brightness via xrandr (works for now)
set_brightness_xrandr() {
    local brightness=$1
    xrandr --output eDP-1 --brightness "$brightness"
    echo "Brightness set to $brightness via xrandr"
}

# Function to get current xrandr brightness
get_brightness_xrandr() {
    xrandr --verbose | grep -A 10 "eDP-1" | grep "Brightness:" | cut -d: -f2 | tr -d ' '
}

# Function to add/subtract brightness (using bash arithmetic)
adjust_brightness() {
    local current=$(get_brightness_xrandr)
    local adjustment=$1
    
    # Convert to integer math (multiply by 100, do math, divide by 100)
    local current_int=$(echo "$current * 100" | awk '{print int($1)}')
    local adjustment_int=$(echo "$adjustment * 100" | awk '{print int($1)}')
    local new_int=$((current_int + adjustment_int))
    
    # Convert back to decimal
    local new=$(echo "scale=2; $new_int / 100" | awk '{print $1/100}')
    
    # Clamp between 0.1 and 1.0
    if (( $(echo "$new > 1.0" | awk '{print ($1 > 1.0)}') )); then
        new="1.0"
    elif (( $(echo "$new < 0.1" | awk '{print ($1 < 0.1)}') )); then
        new="0.1"
    fi
    
    set_brightness_xrandr "$new"
}

# Main script
case "$1" in
    "up")
        adjust_brightness 0.1
        ;;
    "down")
        adjust_brightness -0.1
        ;;
    "set")
        if [ -n "$2" ]; then
            set_brightness_xrandr "$2"
        else
            echo "Usage: $0 set <brightness_value>"
            echo "Example: $0 set 0.8"
        fi
        ;;
    "get")
        echo "Current brightness: $(get_brightness_xrandr)"
        ;;
    *)
        echo "Usage: $0 {up|down|set <value>|get}"
        echo "Examples:"
        echo "  $0 up       # Increase brightness"
        echo "  $0 down     # Decrease brightness"
        echo "  $0 set 0.8  # Set to 80%"
        echo "  $0 get      # Show current brightness"
        ;;
esac