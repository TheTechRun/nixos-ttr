#!/usr/bin/env bash

# RUN THIS SCRIPT AS root
echo "=== UID/GID Change Helper ==="
echo "This script will change a user's UID and group's GID on the current system."
echo "WARNING: Do NOT run this as the user you are changing."
echo ""

read -rp "Username to modify: " TARGET_USER

if ! id "$TARGET_USER" &>/dev/null; then
    echo "Error: User '$TARGET_USER' does not exist."
    exit 1
fi

CURRENT_UID=$(id -u "$TARGET_USER")
CURRENT_GID=$(getent group "$TARGET_USER" | cut -d: -f3)

echo ""
echo "Current UID of '$TARGET_USER': $CURRENT_UID"
echo "Current GID of group '$TARGET_USER': $CURRENT_GID"
echo ""

read -rp "New UID: " NEW_UID
read -rp "New GID: " NEW_GID

echo ""
read -rp "Set a new password for '$TARGET_USER'? (y/N): " SET_PASS

echo ""
echo "Summary of changes:"
echo "  User  '$TARGET_USER': UID $CURRENT_UID -> $NEW_UID"
echo "  Group '$TARGET_USER': GID $CURRENT_GID -> $NEW_GID"
[[ "$SET_PASS" == "y" || "$SET_PASS" == "Y" ]] && echo "  Password: will be set"
echo ""
read -rp "Proceed? (y/N): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Changing GID of group '$TARGET_USER' to $NEW_GID..."
groupmod -g "$NEW_GID" "$TARGET_USER"

echo "Changing UID of user '$TARGET_USER' to $NEW_UID..."
usermod -u "$NEW_UID" "$TARGET_USER"

echo ""
echo "Fixing file ownership (this may take a while)..."
find / -xdev -user "$CURRENT_UID" -exec chown "$NEW_UID" {} \; 2>/dev/null
find / -xdev -group "$CURRENT_GID" -exec chgrp "$NEW_GID" {} \; 2>/dev/null

UID_MAP="/var/lib/nixos/uid-map"
GID_MAP="/var/lib/nixos/gid-map"
if [[ -f "$UID_MAP" ]]; then
    echo "Updating NixOS uid-map ($CURRENT_UID -> $NEW_UID)..."
    sed -i "s/\"${TARGET_USER}\":${CURRENT_UID}/\"${TARGET_USER}\":${NEW_UID}/" "$UID_MAP"
fi
if [[ -f "$GID_MAP" ]]; then
    echo "Updating NixOS gid-map ($CURRENT_GID -> $NEW_GID)..."
    sed -i "s/\"${TARGET_USER}\":${CURRENT_GID}/\"${TARGET_USER}\":${NEW_GID}/" "$GID_MAP"
fi

if [[ "$SET_PASS" == "y" || "$SET_PASS" == "Y" ]]; then
    echo "Setting password for '$TARGET_USER'..."
    passwd "$TARGET_USER"
fi

echo ""
echo "Done. Log out and back in for the session to reflect the new UID/GID."