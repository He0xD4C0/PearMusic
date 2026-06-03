---
title: "ApplicationMusicPlayer"
source: https://developer.apple.com/documentation/MusicKit/ApplicationMusicPlayer
date: 2026-06-03
---
# ApplicationMusicPlayer

An object your app uses to play music in a way that doesn’t affect
the Music app’s state.

```
class ApplicationMusicPlayer
```

## Overview

The application music player plays music specifically for your app,
and doesn’t affect the Music app’s state.

If your app includes a background audio mode in your `Info.plist` file,
the application music player continues playing the current music item
when your app moves to the background.
