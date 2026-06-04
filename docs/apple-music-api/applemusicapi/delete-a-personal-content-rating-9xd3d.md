---
title: "Delete a Personal Music Video Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Delete-a-Personal-Content-Rating-9xd3d
date: 2026-06-03
---
# Delete a Personal Music Video Rating

Remove a user’s music video rating by using the music video’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the music video. These are the only two ratings supported.

For a particular music video, the personal ratings for that video’s catalog ID and library ID (if the video is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/music-videos/639032181
```

**Response:**

```json
No response body.
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.
