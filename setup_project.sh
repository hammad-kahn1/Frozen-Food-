#!/bin/bash

echo "🚀 Starting Frozen Food D2C Setup..."

# 1. Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Error: Flutter is not installed or not in your PATH."
    echo "Please install Flutter from https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed."

# 2. Get Dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# 3. Run Code Generation (Freezed / JSON Serializable)
echo "⚙️ Running build_runner for code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null
then
    echo "⚠️ Firebase CLI is not installed. You will need it to configure the backend."
    echo "Install it using: npm install -g firebase-tools"
else
    echo "🔥 Firebase CLI detected. Make sure to run 'flutterfire configure' to connect your project."
fi

# 5. Setup Assets folder
echo "📁 Creating assets directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/lottie

echo "🎉 Setup Script Completed! "
echo "Next Steps:"
echo "1. Run 'flutterfire configure' to link your Google Cloud / Firebase project."
echo "2. Add your actual images to the 'assets/' folder."
echo "3. Run the app with 'flutter run'."
