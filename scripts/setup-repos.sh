#!/bin/bash
set -euo pipefail

echo "=== Setting up repositories ==="

# RPM Fusion
if ! rpm -q rpmfusion-free-release >/dev/null 2>&1 || ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
    echo "Installing RPM Fusion..."
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# DNF setup and plugins-core (needed for config-manager)
sudo dnf -y install dnf-plugins-core

# Enable Fedora Workstation repositories & Google Chrome
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1

# Visual Studio Code repository
if [ ! -f /etc/yum.repos.d/vscode.repo ]; then
    echo "Adding VS Code repository..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
fi

# Copr repositories
# scottames/ghostty
if ! dnf copr list | grep -q "scottames/ghostty"; then
    echo "Enabling scottames/ghostty COPR..."
    sudo dnf copr enable -y scottames/ghostty
fi

# jdxcode/mise
if ! dnf copr list | grep -q "jdxcode/mise"; then
    echo "Enabling jdxcode/mise COPR..."
    sudo dnf copr enable -y jdxcode/mise
fi

# atim/starship
if ! dnf copr list | grep -q "atim/starship"; then
    echo "Enabling atim/starship COPR..."
    sudo dnf copr enable -y atim/starship
fi

echo "=== Repositories setup complete ==="
