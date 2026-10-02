#!/bin/bash
set -e

export PATH="$PATH:$HOME/flutter/bin"

echo "📦 Installing dependencies..."
flutter pub get

echo "⚙️ Running code generation..."
dart run build_runner build --delete-conflicting-outputs

echo "🏗 Building Flutter Web..."
flutter build web \
  -t lib/main_development.dart \
  --web-renderer canvaskit \
  --release

echo "✅ Build complete! Output in build/web/"
