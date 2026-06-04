---
title: "Add a Resource to a Library"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-a-Resource-to-a-Library
date: 2026-06-03
---
# Add a Resource to a Library

Add a catalog resource to a user’s iCloud Music Library.

## Discussion

If successful, the HTTP status code is 202 (Accepted) and there is no response body. For requested IDs that can’t be added to a user’s library, Apple Music Library ignores those IDs. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

> Note:
> There may be a delay before a new resource appears in a user’s library.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library?ids[albums]=1577502911
```

**Response:**

```json
No response body
```

## See Also

[`Resource`](../applemusicapi/resource.md)

A resource—such as an album, song, or playlist.
