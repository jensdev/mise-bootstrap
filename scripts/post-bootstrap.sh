#!/bin/bash
set -euo pipefail

echo "=== Running post-bootstrap configuration ==="

# 1. Install Nerd Fonts
echo "Checking Nerd Fonts..."
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"
for font in NerdFontsSymbolsOnly CascadiaCode CascadiaMono CodeNewRoman FiraCode JetBrainsMono Meslo SourceCodePro UbuntuMono VictorMono; do
    if [ ! -d "$FONTS_DIR/$font" ]; then
        echo "Installing font $font..."
        wget -q --show-progress -O "${FONTS_DIR}/${font}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" || {
            echo "Failed to download $font. Skipping."
            continue
        }
        unzip -q "${FONTS_DIR}/${font}.zip" -d "$FONTS_DIR/$font" || {
            echo "Failed to extract $font. Skipping."
            rm -f "${FONTS_DIR}/${font}.zip"
            continue
        }
        rm -f "${FONTS_DIR}/${font}.zip"
        rm -f "$FONTS_DIR/$font"/*Windows*
        echo "Installed $font."
    else
        echo "Font $font is already installed."
    fi
done

# 2. Install Android Studio
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2025.1.4.8/android-studio-2025.1.4.8-linux.tar.gz"
INSTALL_DIR="/opt/android-studio"
SYMLINK_DIR="/usr/local/bin"

if [ -d "$INSTALL_DIR" ]; then
    echo "Android Studio is already installed in $INSTALL_DIR. Skipping."
else
    echo "Downloading Android Studio..."
    DOWNLOAD_DIR=$(mktemp -d)
    wget -q --show-progress -O "${DOWNLOAD_DIR}/android-studio.tar.gz" "$ANDROID_STUDIO_URL" || {
        echo "Failed to download Android Studio."
        rm -rf "$DOWNLOAD_DIR"
    }
    
    if [ -f "${DOWNLOAD_DIR}/android-studio.tar.gz" ]; then
        echo "Installing Android Studio to $INSTALL_DIR..."
        sudo mkdir -p "$INSTALL_DIR"
        sudo tar -xzf "${DOWNLOAD_DIR}/android-studio.tar.gz" -C "$INSTALL_DIR" --strip-components=1
        
        echo "Creating symlink..."
        sudo ln -sf "${INSTALL_DIR}/bin/studio.sh" "${SYMLINK_DIR}/android-studio"
        
        rm -rf "$DOWNLOAD_DIR"
        echo "Android Studio installation complete."
    fi
fi

# 3. Systemd Services & User Group setups
echo "Configuring virtualization (libvirtd)..."
if systemctl list-unit-files | grep -q "libvirtd.service"; then
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt $(whoami)
    sudo usermod -aG kvm $(whoami)
fi

echo "Configuring Docker..."
if systemctl list-unit-files | grep -q "docker.service"; then
    sudo systemctl enable --now docker
    sudo usermod -aG docker $(whoami)
fi

# 4. Flatpak / Flathub setup
echo "Configuring Flatpaks..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

FLATPAKS=(
    "com.slack.Slack"
    "com.spotify.Client"
    "rest.insomnia.Insomnia"
    "io.podman_desktop.PodmanDesktop"
    "it.mijorus.gearlever"
)

for app in "${FLATPAKS[@]}"; do
    if ! flatpak info "$app" >/dev/null 2>&1; then
        echo "Installing flatpak $app..."
        flatpak install flathub "$app" --assumeyes || echo "Failed to install flatpak $app"
    else
        echo "Flatpak $app is already installed."
    fi
done

echo "=== Post-bootstrap configuration complete! ==="
echo "NOTE: Some group changes (docker, libvirt, kvm) require you to log out and back in to take effect."
