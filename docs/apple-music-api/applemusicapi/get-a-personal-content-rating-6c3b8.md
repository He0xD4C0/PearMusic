---
title: "Get a Personal Library Album Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Personal-Content-Rating-6c3b8
date: 2026-06-03
---
# Get a Personal Library Album Rating

Fetch a user’s rating for specific content by using the content’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the album. These are the only two ratings supported.

For a particular album, the personal ratings for that album’s catalog ID and library ID (if the album is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-albums/l.qrRWYhq
```

**Response:**

```json
{
    "data": [
        {
            "id": "l.qrRWYhq",
            "type": "ratings",
            "href": "/v1/me/ratings/library-albums/l.qrRWYhq",
            "attributes": {
                "value": 1
            }
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
