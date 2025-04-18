#!/bin/bash

# The Quetzalcoatl Project — System Rebranding Script for Arch Linux
# Make sure to run as root!

NEW_NAME="The Quetzalcoatl Project"
NEW_ID="quetzalcoatl"

# 1. Backup critical files
echo "[*] Backing up original branding files..."
cp /etc/os-release /etc/os-release.bak
cp /etc/issue /etc/issue.bak
cp /etc/lsb-release /etc/lsb-release.bak 2>/dev/null
cp /etc/motd /etc/motd.bak 2>/dev/null

# 2. Update /etc/os-release
echo "[*] Rewriting /etc/os-release..."
cat <<EOF > /etc/os-release
NAME="$NEW_NAME"
PRETTY_NAME="$NEW_NAME"
ID=$NEW_ID
ID_LIKE=arch
ANSI_COLOR="1;36"
HOME_URL="https://quetzalcoatl.project"
SUPPORT_URL="https://quetzalcoatl.project/support"
BUG_REPORT_URL="https://quetzalcoatl.project/issues"
EOF

# 3. Update /etc/issue and /etc/motd
echo "[*] Updating /etc/issue and /etc/motd..."
echo "$NEW_NAME \\n \\l" > /etc/issue
echo "$NEW_NAME" > /etc/motd

# 4. Neofetch config (for user and system)
echo "[*] Customizing Neofetch..."
NEOFETCH_CONFIG="/etc/neofetch/config.conf"
if [ -f "$NEOFETCH_CONFIG" ]; then
    sed -i "s/Arch Linux/$NEW_NAME/g" "$NEOFETCH_CONFIG"
fi

# If the user has a neofetch config
if [ -f "$HOME/.config/neofetch/config.conf" ]; then
    sed -i "s/Arch Linux/$NEW_NAME/g" "$HOME/.config/neofetch/config.conf"
fi

# 5. GRUB Branding (Optional)
if [ -f /etc/default/grub ]; then
    echo "[*] Updating GRUB menu entry (cosmetic only)..."
    sed -i "s/Arch Linux/$NEW_NAME/g" /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# 6. Hostname (Optional)
read -p "Do you want to change the hostname to 'quetzalcoatl'? (y/n): " change_hostname
if [[ $change_hostname == "y" ]]; then
    echo "quetzalcoatl" > /etc/hostname
    echo "127.0.1.1       quetzalcoatl.localdomain quetzalcoatl" >> /etc/hosts
fi

# 7. Pacman hook branding (Optional easter egg)
echo "[*] Adding a custom pacman hook..."
mkdir -p /etc/pacman.d/hooks
cat <<EOF > /etc/pacman.d/hooks/quetzalcoatl.hook
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Blessing package under The Quetzalcoatl Project...
When = PostTransaction
Exec = /usr/bin/echo '🌩️  Quetzalcoatl approves this package 🌈'
EOF

echo "[+] Branding complete. Reboot to see changes in effect."
