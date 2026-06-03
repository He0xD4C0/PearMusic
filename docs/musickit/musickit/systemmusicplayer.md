---
title: "SystemMusicPlayer"
source: https://developer.apple.com/documentation/MusicKit/SystemMusicPlayer
date: 2026-06-03
---
# SystemMusicPlayer

An object your app uses to play music by controlling the Music app’s state.

```
class SystemMusicPlayer
```

## Overview

The system music player employs the Music app on your behalf.
When your app accesses the system music player for the first time,
it assumes the current Music app state and controls it as your app runs.
The shared state includes the following:

- Repeat mode (see ``doc://com.apple.MusicKit/documentation/MusicKit/MusicPlayer/RepeatMode``)
- Shuffle mode (see ``doc://com.apple.MusicKit/documentation/MusicKit/MusicPlayer/ShuffleMode``)
- Playback status (see ``MusicPlayer/PlaybackStatus``)

The system music player doesn’t share other aspects of the Music app’s
state. Music that’s playing continues to play when your app moves
to the background.
