---
title: "Delete a Personal Library Playlist Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Delete-a-Personal-Content-Rating-7vxs6
date: 2026-06-03
---
# Delete a Personal Library Playlist Rating

Remove a user’s library playlist rating by using the library playlist’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the playlist. These are the only two ratings supported.

For a particular playlist, the personal ratings for that playlist’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-playlists/p.MoGJYM3CYXW09B
```

**Response:**

```json
No response body.
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.
