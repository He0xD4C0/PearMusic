---
title: "Get Multiple Personal Playlist Ratings"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Personal-Content-Ratings-7i7bv
date: 2026-06-03
---
# Get Multiple Personal Playlist Ratings

Fetch the user’s ratings for one or more playlists by using the playlists’ identifiers.

## Discussion

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

A rating indicates whether a user likes `(1)` or dislikes `(-1)` the playlist. These are the only two ratings supported.

For a particular playlist, the personal ratings for that playlist’s catalog ID and library ID (if the playlist is in the library) stay synced.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/ratings/playlists?ids=pl.5b0194eaa170401e8986335d7e77aa4e,pl.5ee8333dbe944d9f9151e97d92d1ead9
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/playlists/pl.5b0194eaa170401e8986335d7e77aa4e",
            "id": "pl.5b0194eaa170401e8986335d7e77aa4e",
            "type": "ratings"
        },
        {
            "attributes": {
                "value": 1
            },
            "href": "/v1/me/ratings/playlists/pl.5ee8333dbe944d9f9151e97d92d1ead9",
            "id": "pl.5ee8333dbe944d9f9151e97d92d1ead9",
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
