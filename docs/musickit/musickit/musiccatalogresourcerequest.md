---
title: "MusicCatalogResourceRequest"
source: https://developer.apple.com/documentation/MusicKit/MusicCatalogResourceRequest
date: 2026-06-03
---
# MusicCatalogResourceRequest

A request that your app uses to fetch items from the Apple Music catalog
using a filter.

```
struct MusicCatalogResourceRequest<MusicItemType> where MusicItemType : MusicItem, MusicItemType : Decodable
```
