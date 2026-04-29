# Dual Boot Setup: NixOS + Windows with systemd-boot

This guide explains how to add Windows to your systemd-boot menu when you have separate EFI partitions for Windows and NixOS.

## Prerequisites

- Windows already installed
- NixOS already installed with systemd-boot
- Both systems using UEFI boot mode
- Separate EFI partitions (common with dual boot setups)

## Problem Description

When Windows and NixOS use separate EFI partitions, systemd-boot can't directly access the Windows bootloader because it can only read files from its own EFI partition. This results in Windows appearing in the boot menu but failing to boot with BCD errors.

## Solution Overview

1. Create a Windows boot module for NixOS
2. Copy Windows boot files from Windows EFI partition to NixOS EFI partition
3. Configure systemd-boot to use the copied files
4. Set appropriate boot timeout

## Step-by-Step Instructions

### Step 1: Identify Your EFI Partitions

First, identify which partitions are your EFI partitions:

```bash
sudo fdisk -l
```

Look for partitions with "EFI System" type. You'll typically see:
- A smaller EFI partition (100M) - usually Windows
- A larger EFI partition (600M) - usually NixOS

Check which one is currently mounted:
```bash
mount | grep -i efi
```

### Step 2: Create Windows Boot Module

Create the Windows boot module:

```bash
mkdir -p ~/nixos-config/modules/system/boot/
```

Create `~/nixos-config/modules/system/boot/windows-boot.nix`:

```nix
# Windows Boot Entry Module
# Adds Windows to systemd-boot menu
{ config, lib, pkgs, ... }:

{
  # Add Windows entry to systemd-boot
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows 11
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # Optional: Set Windows as default (uncomment if desired)
  # boot.loader.systemd-boot.default = "windows.conf";
  
  # Optional: Set boot timeout for menu selection
  boot.loader.timeout = 15;
}
```

### Step 3: Add Module to Host Configuration

Add the import to your host's `configuration.nix` (e.g., `hosts/laptop/configuration.nix`):

```nix
imports = [
  # ... other imports ...
  ../../modules/system/boot/windows-boot.nix
  # ... more imports ...
];
```

### Step 4: Copy Windows Boot Files

This is the critical step that makes dual boot work with separate EFI partitions.

Mount the Windows EFI partition (adjust partition names as needed):
```bash
sudo mkdir -p /tmp/win-efi
sudo mount /dev/nvme0n1p1 /tmp/win-efi  # Windows EFI partition
```

Check what's available on the Windows EFI partition:
```bash
sudo ls -la /tmp/win-efi/EFI/
sudo find /tmp/win-efi -name '*.efi' -type f
```

Copy the complete Microsoft Boot directory (including BCD and all config files):
```bash
sudo cp -r /tmp/win-efi/EFI/Microsoft/ /boot/EFI/
```

Verify the copy was successful:
```bash
sudo ls -la /boot/EFI/Microsoft/Boot/
```

You should see files like:
- `bootmgfw.efi` (main Windows bootloader)
- `BCD` (Boot Configuration Data - critical!)
- `bootmgr.efi` 
- Other boot configuration files

Unmount the Windows EFI partition:
```bash
sudo umount /tmp/win-efi
```

### Step 5: Rebuild NixOS

Rebuild your NixOS system to apply the changes:

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#laptop  # or your host name
```

### Step 6: Test the Setup

Reboot your system. You should now see:
- Your NixOS generations
- Windows 11 option
- 15-second timeout for selection

Select Windows 11 and verify it boots successfully.

## Troubleshooting

### Windows Shows But Won't Boot

**Error**: `File: \EFI\Microsoft\Boot\BCD Status: 0x000000f`

**Cause**: Missing or incomplete Windows boot files

**Solution**: Make sure you copied the complete Microsoft directory, not just individual `.efi` files. The BCD file is essential.

### Wrong EFI Partition

**Error**: Windows bootloader not found

**Solution**: 
1. Double-check which EFI partition contains Windows: `sudo mount /dev/nvme0n1p1 /tmp/win-efi && sudo ls /tmp/win-efi/EFI/`
2. Make sure you're copying from the correct source partition

### Multiple Windows Entries

If you see both "Windows 11" and "Windows Boot Manager":
- This is normal after copying files
- Both should work, but you can comment out one in the boot module if desired
- The "Windows 11" entry is your custom one; "Windows Boot Manager" may be auto-detected

## Important Notes

### Why This Approach Works

- **systemd-boot limitation**: Can only access files on its own EFI partition
- **Separate EFI partitions**: Common in dual boot setups for isolation
- **File copying solution**: Makes Windows boot files available to systemd-boot
- **BCD importance**: Contains critical boot configuration data

### Maintenance

- **Windows updates**: May require re-copying boot files if Windows updates its bootloader
- **NixOS rebuilds**: Your Windows entry will persist across NixOS rebuilds
- **Backup**: Consider backing up working boot configurations

### Alternative Approaches

This guide uses the file copying method because:
- ✅ Works reliably with separate EFI partitions
- ✅ Integrates cleanly with NixOS configuration management
- ✅ No need to modify UEFI boot order
- ❌ Requires manual file copying (one-time setup)

Other approaches like using GRUB with os-prober or chainloading have their own trade-offs.

## File Structure After Setup

Your EFI partition should contain:
```
/boot/EFI/
├── BOOT/
│   └── BOOTX64.EFI
├── Microsoft/
│   └── Boot/
│       ├── BCD           # Critical Windows boot config
│       ├── bootmgfw.efi  # Windows bootloader
│       ├── bootmgr.efi
│       └── ... (other Windows boot files)
├── nixos/
│   └── ... (NixOS boot files)
└── systemd/
    └── systemd-bootx64.efi
```

## Success Criteria

✅ Windows 11 appears in systemd-boot menu  
✅ Windows boots successfully when selected  
✅ Boot timeout allows enough time for selection  
✅ Both Windows and NixOS boot reliably  

---

**Last Updated**: July 2025  
**Tested On**: NixOS with systemd-boot, Windows 11, UEFI systems
