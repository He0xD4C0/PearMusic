---
title: "Add a Personal Music Video Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-a-Personal-Content-Rating-8hke5
date: 2026-06-03
---
# Add a Personal Music Video Rating

Add a user’s music video rating by using the music video’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the music video. These are the only two ratings supported.

For a particular music video, the personal ratings for that music video’s catalog ID and library ID (if in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/music-videos/639032181

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
            "id":"639032181",
            "type":"ratings",
            "href":"/v1/me/ratings/music-videos/639032181",
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
