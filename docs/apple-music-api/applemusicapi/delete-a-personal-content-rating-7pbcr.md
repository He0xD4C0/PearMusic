---
title: "Delete a Personal Station Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Delete-a-Personal-Content-Rating-7pbcr
date: 2026-06-03
---
# Delete a Personal Station Rating

Remove a user’s station rating by using the station’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the station. These are the only two ratings supported.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/stations/ra.840950253
```

**Response:**

```json
No response body.
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.
