#!/bin/bash

# iOS Deployment Target Fix Script
# This script updates the iOS deployment target to 13.0

echo "🔧 Fixing iOS Deployment Target..."

# Navigate to iOS directory
cd ios || exit 1

# Backup project.pbxproj
echo "📦 Backing up project.pbxproj..."
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

# Update deployment target in project.pbxproj
echo "✏️  Updating IPHONEOS_DEPLOYMENT_TARGET to 13.0..."
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*;/IPHONEOS_DEPLOYMENT_TARGET = 13.0;/g' Runner.xcodeproj/project.pbxproj

# Clean pods
echo "🧹 Cleaning old pods..."
rm -rf Pods
rm -f Podfile.lock

# Install pods
echo "📥 Installing pods..."
pod install --repo-update

cd ..

# Clean Flutter
echo "🧹 Cleaning Flutter build..."
flutter clean

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "✅ Done! iOS deployment target updated to 13.0"
echo ""
echo "Next steps:"
echo "  1. Try building for iOS: flutter build ios --release"
echo "  2. Or run on simulator: flutter run"
