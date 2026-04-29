#!/usr/bin/env bash

# Android Device Testing Script for NixOS
# Tests fastboot and adb connectivity with Motorola devices

echo "=== Android Device Testing Script ==="
echo ""

# Check if android-tools are available
echo "1. Checking android-tools installation..."
if command -v fastboot &> /dev/null && command -v adb &> /dev/null; then
    echo "✓ android-tools found"
    echo "  - ADB version: $(adb version | head -1)"
    echo "  - Fastboot version: $(fastboot --version 2>&1 | head -1)"
else
    echo "✗ android-tools not found - please rebuild your NixOS configuration"
    exit 1
fi

echo ""

# Check if user is in adbusers group
echo "2. Checking user group membership..."
if groups | grep -q "adbusers"; then
    echo "✓ User is in adbusers group"
else
    echo "✗ User is not in adbusers group - this may cause permission issues"
fi

echo ""

# Check for connected devices
echo "3. Checking for connected Android devices..."
echo "ADB devices:"
adb devices
echo ""
echo "Fastboot devices:"
fastboot devices

echo ""

# Check udev rules
echo "4. Checking udev rules..."
if [ -f /etc/udev/rules.d/*android* ] || [ -d /nix/store/*android-udev-rules* ]; then
    echo "✓ Android udev rules appear to be installed"
else
    echo "? Android udev rules status unclear"
fi

echo ""

# USB device listing for Motorola
echo "5. Looking for Motorola devices in USB..."
lsusb | grep -i motorola || echo "No Motorola devices found via lsusb"

echo ""

# Instructions
echo "=== Instructions ==="
echo "1. Connect your Motorola device"
echo "2. Enable Developer Options and USB Debugging"
echo "3. For fastboot: boot into bootloader mode (usually Power + Volume Down)"
echo "4. Run 'fastboot devices' to check if device is detected"
echo "5. If not working, try unplugging/replugging the device"
echo "6. You may need to accept USB debugging prompt on the device"

echo ""
echo "=== Troubleshooting ==="
echo "If fastboot still doesn't see your device:"
echo "1. Check 'lsusb' output when device is connected"
echo "2. Look for Motorola vendor ID (22b8) or Google vendor ID (18d1)"
echo "3. You may need to add specific product IDs to the udev rules"
echo "4. Try running as root temporarily to test permissions: 'sudo fastboot devices'"
