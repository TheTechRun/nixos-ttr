# Host Setup Instructions

These are the steps I use when bringing up a new host with this repo.

## 1. Set up GitHub SSH access

If you already have a working SSH key that is added to GitHub, skip this section.

Check whether a key already exists:

```bash
ls -l ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub
```

If you want a fresh key, move the old one aside first instead of deleting it:

```bash
mv ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.old.$(date +%s) 2>/dev/null || true
mv ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519.pub.old.$(date +%s) 2>/dev/null || true
```

Generate a new key:

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Start the agent and add the key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
```

Print the public key and add it to GitHub:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add it here:

https://github.com/settings/ssh/new

## 2. Install bootstrap tools

```bash
nix-shell -p git micro
```

## 3. Clone the repo

```bash
git clone git@github.com:TheTechRun/nixos-ttr.git ~/nixos-config
cd ~/nixos-config
git config --global user.email "you@example.com"
git config --global user.name "user"
git config --global init.defaultBranch master
```

## 4. Rename users if needed

If you do not want to use the default usernames from this repo, run the rename script now before the first flake rebuild.

Example:

```bash
~/nixos-config/scripts/user-rename.sh ttr muffin
```

This updates the repo's user-related text and curated `modules/users/` paths so your host imports and user modules stay consistent.

## 5. Back up host config and copy hardware config

Pick the host first:

```bash
export HOST=desktop
```

Valid values here are:

- `desktop`
- `laptop`
- `server`
- `minimal`

Then back up the current `/etc/nixos` files and copy the generated hardware config into this repo:

```bash
mkdir -p ~/nixos-config/hosts/$HOST/backups
sudo cp /etc/nixos/configuration.nix ~/nixos-config/hosts/$HOST/backups/configuration.nix.backup
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$HOST/backups/hardware-configuration.nix.backup
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$HOST/hardware-configuration.nix
```

## 6. Bootstrap old hosts if needed

This section exists because the first flake rebuild can fail when the machine is still on an older NixOS release. If the installed host is behind the release expected by this repo, update the host release first and then do the flake rebuild.

Check the current host version:

```bash
nixos-version
```

Or:

```bash
cat /etc/os-release
```

You can use the helper script:

```bash
~/nixos-config/scripts/channel-update.sh
```

Or do it manually:

Remove the existing channel:

```bash
sudo nix-channel --remove nixos
```

Add the correct channel:

```bash
sudo nix-channel --add https://nixos.org/channels/nixos-<target-version-here> nixos
```

Check it:

```bash
sudo nix-channel --list
```

Update it:

```bash
sudo nix-channel --update
```

Rebuild once from the current `/etc/nixos` config:

```bash
cd /etc/nixos
sudo nixos-rebuild switch
```

Only do the previous steps in the above section when the host is too old for the first flake rebuild to work cleanly.

## 7. Prepare the repo for the first flake rebuild

Symlink the flake into `/etc/nixos`:

```bash
sudo ln -sf ~/nixos-config/flake.nix /etc/nixos/flake.nix
```

## 8. First flake rebuild

Use the host selected earlier (be sure to be in the same shell that you did the $HOST export, or just do it again):

```bash
sudo nixos-rebuild switch --extra-experimental-features 'nix-command flakes' --flake ~/nixos-config#$HOST
```

Some Examples:

```bash
sudo nixos-rebuild switch --extra-experimental-features 'nix-command flakes' --flake ~/nixos-config#desktop
sudo nixos-rebuild switch --extra-experimental-features 'nix-command flakes' --flake ~/nixos-config#laptop
sudo nixos-rebuild switch --extra-experimental-features 'nix-command flakes' --flake ~/nixos-config#server
```

## 9. Future rebuilds

After the first successful flake rebuild, the normal command is:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#$HOST
```

Or use this script with auto HOST detection and git functionality:

```bash
~/nixos-config/scripts/flake-scripts/rebuild-flake.sh
```

## Note

This setup currently builds a window-manager environment around Scroll, which is a Sway fork.

If you want a different window manager or a full desktop environment instead, change the relevant imports under:

```bash
~/nixos-config/modules/desktop-environment
```