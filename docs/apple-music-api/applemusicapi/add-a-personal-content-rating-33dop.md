---
title: "Add a Personal Song Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-a-Personal-Content-Rating-33dop
date: 2026-06-03
---
# Add a Personal Song Rating

Add a user’s song rating by using the song’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the song. These are the only two ratings supported.

For a particular song, the personal ratings for that song’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/songs/907242702

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
            "id":"907242702",
            "type":"ratings",
            "href":"/v1/me/ratings/songs/907242702",
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
