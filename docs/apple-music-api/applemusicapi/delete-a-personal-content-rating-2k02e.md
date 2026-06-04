---
title: "Delete a Personal Library Song Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Delete-a-Personal-Content-Rating-2k02e
date: 2026-06-03
---
# Delete a Personal Library Song Rating

Remove a user’s library song rating by using the library song’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1`) or dislikes `(-1)` the song. These are the only two ratings supported.

For a particular song, the personal ratings for that song’s catalog ID and library ID (if the song is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-songs/i.7PJNN4mfXlD68R
```

**Response:**

```json
No response body.
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.
