---
title: "Get Multiple Personal Library Songs Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-1bod7
date: 2026-06-03
---
# Get Multiple Personal Library Songs Ratings

Fetch the user’s ratings for one or more library songs by using the library songs’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the song. These are the only two ratings supported.

For a particular song, the personal rating for that song’s catalog ID and library ID (if the song is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-songs?ids=i.7PJNN4mfXlD68R,i.xrXvO5vFv0VrNA
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-songs/i.7PJNN4mfXlD68R",
            "id": "i.7PJNN4mfXlD68R",
            "type": "ratings"
        },
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-songs/i.xrXvO5vFv0VrNA",
            "id": "i.xrXvO5vFv0VrNA",
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
