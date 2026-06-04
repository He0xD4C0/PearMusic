---
title: "Get a Personal Album Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Personal-Content-Rating-1q2mb
date: 2026-06-03
---
# Get a Personal Album Rating

Fetch a user’s rating for an album by using the user’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the album. These are the only two ratings supported.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/albums/1138988512
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/albums/1138988512",
            "id": "1138988512",
            "type": "ratings"
        }
    ]
}
```

## See Also

[`Ratings`](../applemusicapi/ratings.md)

An object that represents a rating for a resource.

[`RatingRequest`](../applemusicapi/ratingrequest.md)

A request containing the data for a rating.

[`RatingsResponse`](../applemusicapi/ratingsresponse.md)

The response to a request for a rating.
