---
title: "MusicTokenProvider"
source: https://developer.apple.com/documentation/MusicKit/MusicTokenProvider
date: 2026-06-03
---
# MusicTokenProvider

An object that music requests use to access Apple Music API.

```
typealias MusicTokenProvider = MusicUserTokenProvider & MusicDeveloperTokenProvider
```

## Discussion

A token provider for MusicKit needs to be a subclass of
[`MusicUserTokenProvider`](/documentation/MusicKit/MusicUserTokenProvider) which conforms to the
[`MusicDeveloperTokenProvider`](/documentation/MusicKit/MusicDeveloperTokenProvider) protocol.
