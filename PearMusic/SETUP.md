# 开发指南

从零搭建 PearMusic 的开发环境。项目已包含完整的 Xcode 工程。

## 你需要什么

| 依赖 | 用途 | 获取方式 |
|------|------|---------|
| Xcode 16+ | 编译 (Swift 6 语言模式) | [Mac App Store](https://apps.apple.com/app/xcode/id497799835) |
| Apple Developer Program | MusicKit entitlement 签名 | [developer.apple.com](https://developer.apple.com) — $99/年 |
| Apple Music 订阅 | 播放流媒体 | 系统设置 → 订阅 |
| 网易云 IoT 开发者账号 | 歌词 API (免费) | [developer.music.163.com](https://developer.music.163.com) |
| LLM API Key | AI 翻译 (可选) | 任何 OpenAI 兼容 API |

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/He0xD4C0/PearMusic.git
cd PearMusic

# 2. 打开工程
open PearMusic.xcodeproj

# 3. 在 Xcode 中选择目标:
#    - My Mac (macOS)
#    - 任意 iOS 模拟器

# 4. 运行
⌘R
```

首次启动会弹出 Apple Music 授权对话框，点"允许"即可。

## 工程配置

项目已经预配置好了以下内容，一般不需要改动：

### Signing & Capabilities

| 配置项 | 说明 |
|--------|------|
| Team | 需要在 Xcode 中切换为**你的** Apple Developer 团队 |
| Bundle Identifier | `me.pearto.PearMusic`（可以改成你自己的） |
| MusicKit | `com.apple.developer.musickit` — 已加入 entitlements |
| Sandbox | 已启用，含网络和用户文件权限 |
| Hardened Runtime | 已启用 |

> **怎么改 Team**：打开 Xcode → 点左侧 PearMusic 项目 → Signing & Capabilities → Team 下拉框 → 选你的团队。没有付费账号的话这里会报红。

### 部署目标

- macOS 14.0 (Sonoma)
- iOS 17.0

这些是 `@Observable` 宏的最低要求。可以在 Build Settings 里调高，但不能调低。

### Entitlements

`PearMusic/PearMusic.entitlements` 包含：

```xml
com.apple.developer.musickit          ← MusicKit 自动 JWT
com.apple.security.app-sandbox        ← macOS 沙盒
com.apple.security.network.client     ← 网易云 + AI API 网络请求
com.apple.security.network.server     ← 本地回环
com.apple.security.files.user-selected.read-only  ← 读取用户文件
```

## 填入 API 密钥

运行 App 后，点工具栏的齿轮图标打开 **Settings**：

| 字段 | 从哪里来 |
|------|---------|
| NetEase App ID | [网易云 IoT 开放平台](https://developer.music.163.com) 控制台 |
| NetEase Private Key (Base64) | 下载的 PKCS#8 私钥，去掉 PEM 头尾，保留 base64 内容 |
| Device ID | 任意 ≤64 位字母数字，建议用 `uuidgen` 生成 |
| AI API Key | DeepSeek / OpenAI 后台获取 |
| AI Model | 默认 `deepseek-chat`，可改为 `gpt-4o` 等 |
| AI Base URL | API 端点，默认 `https://api.deepseek.com/v1` |

密钥存储在系统 Keychain 中，不会写入明文文件。也可以创建 `Secrets.plist` 做默认值（参考 `Shared/Resources/Secrets.example.plist`）。

## 网易云私钥怎么准备

网易云 IoT 平台下载的密钥文件通常是 PEM 格式：

```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASC...
...很多行 base64...
-----END PRIVATE KEY-----
```

去掉 `-----BEGIN/END-----` 两行，把中间所有 base64 拼接成**一行**，粘贴到 Settings 的 Private Key 字段。这就是 RSA PKCS#8 私钥的 Base64 编码。

## 项目结构

```
项目根目录/
├── PearMusic.xcodeproj/          # Xcode 工程 (直接用这个打开)
├── PearMusic/
│   ├── PearMusic.entitlements    # 权限声明
│   ├── PearMusicApp.swift        # App 入口
│   └── Shared/
│       ├── Models/               # 数据模型
│       ├── Services/             # 业务逻辑层
│       │   ├── MusicKit/         # 权限 / 播放引擎 / 资料库 / 离线下载
│       │   ├── NetEase/          # RSA 签名 / 搜索 / 歌词拉取
│       │   ├── Lyrics/           # LRC 解析 / 状态机 / 歌词同步
│       │   └── AI/               # LLM 客户端 / 翻译管线
│       ├── ViewModels/           # UI 状态管理
│       ├── Views/                # 所有界面组件
│       └── Utilities/            # Keychain / 模糊匹配 / LRC 工具
└── docs/                         # Apple 官方文档备份
```

## 常见问题

### "Signing requires a development team"
你没有 Apple Developer Program 付费账号。MusicKit entitlement 必须由付费证书签名。免费账号只能跑模拟器，但 MusicKit 在模拟器上也有限制。

### ICError -7013 / "not entitled to access account store"
`com.apple.developer.musickit` entitlement 没有生效。检查 Xcode → Signing & Capabilities → 确认 MusicKit 已添加且 Team 正确。

### "Queue was interrupted by another queue"
播放引擎的 Shadow Queue 单曲模式已修复此问题。如果仍然出现，可能是系统播放器被其他 App（如 Apple Music.app）抢占。

### 编译报 "Cannot find 'X' in scope"
SourceKit 索引延迟问题。Clean Build Folder (`⌘⇧K`) 然后重新编译。

### 网易云 API 返回 401
检查 App ID 和私钥是否正确。私钥必须是 PKCS#8 格式的 base64 编码，不能有 PEM 头尾和换行。

### 翻译失败
检查 AI API Key 和 Base URL。确认模型名称正确（DeepSeek 用 `deepseek-chat`，OpenAI 用 `gpt-4o`）。

## 运行测试

目前测试目标未包含具体用例，但 LRC 解析器、RSA 签名、字符串相似度算法都可以独立测试：

```bash
# 在 Xcode 中:
# Product → Test (⌘U)

# 或命令行:
xcodebuild test \
  -project PearMusic.xcodeproj \
  -scheme PearMusic \
  -destination 'platform=macOS'
```
