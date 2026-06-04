---
title: "Get Multiple Personal Library Album Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-5px7a
date: 2026-06-03
---
# Get Multiple Personal Library Album Ratings

Fetch the user’s ratings for one or more pieces of content by using the contents’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the album. These are the only two ratings supported.

For a particular album, the personal ratings for that album’s catalog ID and library ID (if the album is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-albums?ids=l.qrRWYhq,l.hRrflgc
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
