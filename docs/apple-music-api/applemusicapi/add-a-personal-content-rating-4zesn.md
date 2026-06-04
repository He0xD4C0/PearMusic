---
title: "Add a Personal Album Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-a-Personal-Content-Rating-4zesn
date: 2026-06-03
---
# Add a Personal Album Rating

Add a user’s album rating by using the album’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the album. These are the only two ratings supported.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/albums/1138988512

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
            "id":"1138988512",
            "type":"ratings",
            "href":"/v1/me/ratings/albums/1138988512",
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
