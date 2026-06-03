# 🍐 PearMusic

**Apple Music × AI Lyrics** — A native macOS & iOS app that pairs Apple Music streaming with NetEase Cloud Music lyrics and on-the-fly AI translation.

## Architecture

```
┌───────────────┐  ┌──────────────┐  ┌──────────────┐
│ MusicKit Swift │  │ NetEase API  │  │ AI Pipeline  │
│ (auto JWT)     │  │ (RSA sign)   │  │ (LLM trans)  │
└───────┬───────┘  └──────┬───────┘  └──────┬───────┘
        └─────────────────┼─────────────────┘
                 ┌────────┴────────┐
                 │  Lyric Engine    │
                 │  Parser/Sync/FM  │
                 └────────┬────────┘
                 ┌────────┴────────┐
                 │  SwiftUI Views   │
                 └─────────────────┘
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI 5 |
| State | @Observable + Combine |
| Music | MusicKit for Swift (auto JWT, no config) |
| Crypto | CryptoKit (RSA-SHA256 PKCS#1 v1.5) |
| Network | URLSession + async/await |
| Security | Keychain (secrets), UserDefaults (prefs) |
| Lyric Sync | CADisplayLink (60fps) |
| Targets | macOS 14+, iOS 17+ |

## No Developer Token Needed

Unlike the web version (MusicKit JS), the Swift native version uses MusicKit for Swift which automatically derives the JWT developer token from code signing. Users just sign in with their Apple ID — **zero manual configuration**.

## Project Structure

```
Swift/
├── Package.swift
├── Shared/           # Cross-platform business logic
│   ├── Models/       # LyricLine, LyricState, NeteaseModels, AIConfig
│   ├── Services/     # MusicKit, NetEase, Lyrics, AI
│   ├── ViewModels/   # @Observable state management
│   ├── Views/        # SwiftUI components
│   └── Utilities/    # Crypto, string similarity, keychain
├── macOS/            # macOS-specific (sidebar, window management)
├── iOS/              # iOS-specific (compact layout)
└── PearMusicTests/   # Unit tests
```

## Getting Started

### Prerequisites
- Xcode 26+ (or Xcode 15+ for macOS 14/iOS 17)
- Apple ID with Apple Music subscription (for playback)
- NetEase Developer account (for lyrics — [developer.music.163.com](https://developer.music.163.com))
- DeepSeek or OpenAI API key (optional, for AI translation)

### Build & Run
```bash
cd Swift
open Package.swift          # Opens in Xcode
# Select "PearMusicMac" or "PearMusiciOS" scheme
# ⌘R to build and run
```

### Configure NetEase & AI Keys
Open Settings (⌘,) in the app to enter your NetEase RSA keys and AI API key. Credentials are stored securely in Keychain.

## Features

- 🎵 Apple Music streaming (full catalog + library)
- 📝 Synced lyrics from NetEase Cloud Music
- 🌐 Official bilingual translations (when available)
- 🤖 AI translation fallback (DeepSeek/OpenAI)
- ⚡ 60fps CADisplayLink lyric sync
- 🔒 RSA-SHA256 API signing via CryptoKit
- 🖥️ macOS native: media keys, NowPlaying center, system menu bar
- 📱 iOS native: Dynamic Island, lock screen controls

## License

MIT
