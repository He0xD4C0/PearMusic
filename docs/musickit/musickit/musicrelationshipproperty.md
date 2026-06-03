---
title: "MusicRelationshipProperty"
source: https://developer.apple.com/documentation/MusicKit/MusicRelationshipProperty
date: 2026-06-03
---
# MusicRelationshipProperty

An identifier for a music item relationship property
from a specific root type to a specific value type
for the element of the resulting collection.

```
class MusicRelationshipProperty<Root, RelatedMusicItemType> where RelatedMusicItemType : MusicItem, RelatedMusicItemType : Decodable
```
