# Xcode Project Setup

This guide creates a single Multiplatform target that builds for macOS and iOS.

## Step 1: Create Multiplatform Project

1. Open Xcode
2. **File → New → Project…** (⇧⌘N)
3. Select **Multiplatform** tab → **App**
4. Configure:

   | Field | Value |
   |-------|-------|
   | Product Name | `PearMusic` |
   | Team | Your Personal Team |
   | Interface | SwiftUI |
   | Language | Swift |
   | Storage | None (uncheck SwiftData) |

5. Save **into this directory** (`~/CodeBank/PearMusic/`)
6. When prompted "PearMusic already exists", choose **Replace**

## Step 2: Add Source Files

1. In the Project Navigator (left sidebar), select the **PearMusic** group
2. **Delete** the auto-created `ContentView.swift` and `Item.swift` (Move to Trash)
3. **File → Add Files to "PearMusic"…** (⌥⌘A)
4. Select the `Shared` folder → check **"Create groups"**
5. Make sure the **PearMusic target** is checked under "Add to targets"
6. Click **Add**

Also add `PearMusicTests/` and `PearMusicUITests/` if recreated.

## Step 3: MusicKit Entitlement

1. Select the **PearMusic** project (top of navigator)
2. Select the **PearMusic** target → **Signing & Capabilities** tab
3. Click **"+ Capability"** → search "MusicKit" → double-click to add
4. This adds `com.apple.developer.musickit` to entitlements on both platforms

## Step 4: Info.plist

Add to the target's Info.plist (or Info panel):

```
NSAppleMusicUsageDescription = "PearMusic needs access to Apple Music to play songs and show lyrics."
```

## Step 5: Build & Run

- Select **My Mac** or an **iOS Simulator** from the scheme selector
- ⌘R to build and run
- The app opens → click **Sign In with Apple Music** → authorize → play music

## Configuration

Open Settings (gear icon in toolbar) to enter:
- **NetEase API keys** (appId + RSA keys) — required for lyrics
- **AI API key** (DeepSeek/OpenAI) — optional, for AI translation fallback

Keys are stored securely in macOS/iOS Keychain.
