---
title: "Get a Personal Library Music Video Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Personal-Content-Rating-4bir7
date: 2026-06-03
---
# Get a Personal Library Music Video Rating

Fetch a user’s rating for a library music video by using the music video’s library identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the music video. These are the only two ratings supported.

For a particular music video, the personal ratings for that video’s catalog ID and library ID (if the video is in the library) stay synced.

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
