---
title: "Get Multiple Personal Library Music Video Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-63ybs
date: 2026-06-03
---
# Get Multiple Personal Library Music Video Ratings

Fetch the user’s ratings for one or more library music videos by using the library music videos’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the music video. These are the only two ratings supported.

For a particular music video, the personal ratings for that video’s catalog ID and library ID (if the video is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-music-videos?ids=i.NJv00rkTEaLK51,i.B0VNN8Bf9dYXOV
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-music-videos/i.NJv00rkTEaLK51",
            "id": "i.NJv00rkTEaLK51",
            "type": "ratings"
        },
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-music-videos/i.B0VNN8Bf9dYXOV",
            "id": "i.B0VNN8Bf9dYXOV",
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
