---
title: "Get Multiple Personal Music Video Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-74o7x
date: 2026-06-03
---
# Get Multiple Personal Music Video Ratings

Fetch the user’s ratings for one or more music videos by using the music videos’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the music video. These are the only two ratings supported.

For a particular music video, the personal ratings for that music video’s catalog ID and library ID (if in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/music-videos?ids=639032181,870852283
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/music-videos/639032181",
            "id": "639032181",
            "type": "ratings"
        },
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/music-videos/870852283",
            "id": "870852283",
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
