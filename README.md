# 我真的就差一步了，是 Apple Developer Program 毁了这个项目

作者已经放弃。这套方案的唯一目的就是解决 Apple Music 那个该死的翻译——我通过接入网易云音乐 + LLM 来解决它。

# 🍐 PearMusic

与 Apple Music 唱唱反调，一个根本不会写程序的人用 Vibe Coding 全程自嗨罢了。

因为 Apple 的版权政策，你无法使用自定义歌词，亦无法接入任何 AI 翻译。Apple Music 的歌词接口是封闭的，第三方 App 连读都读不到，更别说翻译。于是我写了这个，把网易云的歌词和 AI 翻译管线嫁接到 MusicKit 上。

**但是编译需要 Apple Developer Program**（$99/年），因为 `com.apple.developer.musickit` entitlement 必须通过付费证书签名。没有这个，MusicKit 无法生成 JWT，直接 `ICError -7013`。我卡在这里了。

如果你有付费开发者账号，开箱即用。所有的逻辑都是完整的。

包含了 **MusicKit 官方 API 文档**和 **Apple Music API 参考文档**，需要的可以自取。

---

## 它是怎么工作的

```
你点了一首歌
    │
    ▼
MusicKit 播放 (自动 JWT，无需手动配置)
    │
    ▼
网易云 IoT API 搜索匹配 → RSA-SHA256 签名 → 拉取 LRC 歌词
    │
    ├─ 有官方双语？ → 直接显示 🌐 Native
    ├─ 只有原文？   → 触发 AI 翻译管线 🤖 AI
    ├─ 纯音乐？     → 显示 "Instrumental" 🎵
    └─ 没歌词？     → 显示 "Unavailable" ❌
    │
    ▼
Timer 60fps 同步滚动 (O(log n) 二分查找)
```

## 技术栈

纯 Apple 原生，零第三方依赖：

| 组件 | 用了什么 |
|------|---------|
| UI | SwiftUI 5，macOS `NavigationSplitView` / iOS `TabView` |
| 状态管理 | `@Observable` 宏 |
| 音乐播放 | `ApplicationMusicPlayer` (MusicKit for Swift) |
| RSA 签名 | `SecKeyCreateSignature(.rsaSignatureDigestPKCS1v15SHA256)` |
| 网络 | `URLSession` + async/await |
| 密钥存储 | Keychain (`kSecAttrAccessibleAfterFirstUnlock`) |
| AI 翻译 | 任何 OpenAI 兼容 API |
| 最低版本 | macOS 14.0 / iOS 17.0 |

> 为什么用 Security Framework 而不是 CryptoKit？因为 CryptoKit 的 `RSA.Signing.PrivateKey` 在当前 toolchain 不可用。（这句话是AI写的我看不懂不关我事🤷）

## 项目结构

```
PearMusic/
├── PearMusic.xcodeproj/
├── PearMusic/
│   ├── PearMusic.entitlements          # MusicKit 权限
│   ├── PearMusicApp.swift              # @main 入口
│   └── Shared/
│       ├── Models/                     # 数据模型 & 错误类型
│       ├── Services/
│       │   ├── MusicKit/               # 权限、播放引擎、资料库、离线
│       │   ├── NetEase/                # RSA 签名、搜索、歌词拉取
│       │   ├── Lyrics/                 # LRC 解析、状态机、同步器
│       │   └── AI/                     # LLM 客户端、翻译管线
│       ├── ViewModels/                 # @Observable 状态管理
│       ├── Views/                      # 所有 SwiftUI 界面
│       └── Utilities/                  # Keychain、模糊匹配、LRC 工具
└── docs/                               # Apple 官方文档
    ├── musickit/                       # MusicKit API 文档
    └── apple-music-api/                # Apple Music API 文档
```

45 个 Swift 源文件，约 6,500 行。

## 如果你有开发者账号

```bash
git clone https://github.com/He0xD4C0/PearMusic.git
cd PearMusic
open PearMusic.xcodeproj
# 选择 My Mac 或 iOS 模拟器
# ⌘R
```

首次运行后点齿轮图标进 Settings，填入：
- **网易云 App ID + RSA 私钥** — [developer.music.163.com](https://developer.music.163.com) 免费申请
- **AI API Key**（可选）— DeepSeek 或 OpenAI

密钥存在 Keychain 里，不会落盘明文。

## 踩过的坑

- **队列冲突** — `ApplicationMusicPlayer` 只能有一个活跃队列。设置队列后再 `insert()` 会触发 `Queue was interrupted by another queue`。解决方案：Shadow Queue 单曲模式，系统播放器只收单曲，不上插不重建。
- **歌曲监视失效** — `player.queue.currentEntry` 队列冲突后变 nil，导致 `onChange(of: nowPlayingTitle)` 永远不触发。解决方案：`nowPlaying` 从 shadow queue 派生，不依赖系统播放器状态。
- **`@Observable` + `Sendable` 冲突** — `@ObservationTracked` 宏生成的 mutable stored property 不兼容 `Sendable`。6 个 ViewModel 全部移除 `Sendable`。
- **`NSLock` 在 Swift 6 async 不可用** — `lock()`/`unlock()` 报错，改用 `withLock {}`。
- **`@Observable` computed property 不触发 UI 更新** — 跨对象边界的 computed property 不会 dirty-track。解决方案：用 stored property + 4Hz Timer 手动刷新。
- **`CADisplayLink` 跨平台不可用** — macOS 没有 `CADisplayLink`。改用 `Timer.scheduledTimer` 60fps。
- **CryptoKit `RSA.Signing` 不存在** — 当前 toolchain 里没有。改用 Security Framework 的 `SecKeyCreateSignature`。

> AI 写的，不关我事🤷，反正也可以一遍又一遍地把错误代码贴回 AI 让它 AutoCopilot。

## License

MIT
