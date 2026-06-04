---
title: "Get Multiple Personal Library Playlist Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-25kr7
date: 2026-06-03
---
# Get Multiple Personal Library Playlist Ratings

Fetch the user’s ratings for one or more library playlists by using the library playlists’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the playlist. These are the only two ratings supported.

For a particular playlist, the personal ratings for that playlist’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/library-playlists?ids=p.MoGJYM3CYXW09B,p.8Wx6vK6IQeP0N2
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-playlists/p.MoGJYM3CYXW09B",
            "id": "p.MoGJYM3CYXW09B",
            "type": "ratings"
        },
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/library-playlists/p.8Wx6vK6IQeP0N2",
            "id": "p.8Wx6vK6IQeP0N2",
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
