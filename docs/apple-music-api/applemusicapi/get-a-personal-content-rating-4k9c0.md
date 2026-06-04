---
title: "Get a Personal Song Rating"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Personal-Content-Rating-4k9c0
date: 2026-06-03
---
# Get a Personal Song Rating

Fetch a user’s rating for a song by using the song’s identifier.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the song. These are the only two ratings supported.

For a particular song, the personal ratings for that song’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/songs/907242702
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/songs/907242702",
            "id": "907242702",
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
