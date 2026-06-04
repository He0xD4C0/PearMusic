---
title: "Add a Personal Library Playlist Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-a-Personal-Content-Rating-91fzd
date: 2026-06-03
---
# Add a Personal Library Playlist Rating

Add a user’s library playlist rating by using the library playlist’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the playlist. These are the only two ratings supported.

For a particular playlist, the personal ratings for that playlist’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-playlists/p.MoGJYM3CYXW09B

{
    "type":"rating",
    "attributes":{
        "value":1
    }
}
```

**Response:**

```json
{
   "data":[
      {
         "id":"p.MoGJYM3CYXW09B",
         "type":"ratings",
         "href":"/v1/me/ratings/library-playlists/p.MoGJYM3CYXW09B",
         "attributes":{
            "value":1
         }
      }
   ]
}
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.

[`RatingsResponse`](../applemusicapi/ratingsresponse.md)

The response to a request for a rating.
