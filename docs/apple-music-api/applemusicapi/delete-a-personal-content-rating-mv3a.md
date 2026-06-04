---
title: "Delete a Personal Playlist Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Delete-a-Personal-Content-Rating-mv3a
date: 2026-06-03
---
# Delete a Personal Playlist Rating

Remove a user’s playlist rating by using the playlist’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the playlist. These are the only two ratings supported.

For a particular playlist, the personal ratings for that playlist’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/playlists/pl.5b0194eaa170401e8986335d7e77aa4e
```

**Response:**

```json
No response body.
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.
