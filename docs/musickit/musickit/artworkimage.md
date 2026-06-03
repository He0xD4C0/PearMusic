---
title: "ArtworkImage"
source: https://developer.apple.com/documentation/MusicKit/ArtworkImage
date: 2026-06-03
---
# ArtworkImage

A view that displays the image for a music item’s artwork.

```
@MainActor @preconcurrency struct ArtworkImage
```

## Overview

You can create an artwork image with an instance of
[`Artwork`](/musickit/artwork.md).

While the artwork’s image data is loading, [`ArtworkImage`](/documentation/MusicKit/ArtworkImage)
automatically displays a placeholder with a solid color that matches the
[`backgroundColor`](/musickit/artwork/backgroundcolor.md)
property of the artwork to render.
