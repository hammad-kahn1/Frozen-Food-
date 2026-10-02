#!/bin/bash
set -e

echo "🚀 Installing Flutter SDK for Vercel..."

# Download Flutter SDK
FLUTTER_VERSION="3.24.3"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

curl -Lo flutter.tar.xz "$FLUTTER_URL"
tar xf flutter.tar.xz -C $HOME
rm flutter.tar.xz

export PATH="$PATH:$HOME/flutter/bin"

echo "✅ Flutter installed!"
flutter --version
