---
title: "Get All Library Artists"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-All-Library-Artists
date: 2026-06-03
---
# Get All Library Artists

Fetch all the library artists in alphabetical order.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/artists
```

**Response:**

```json
{    
    "next": "/v1/me/library/artists?offset=2",
    "data": [
        {
            "id": "r.y8mMT7t",
            "type": "library-artists",
            "href": "/v1/me/library/artists/r.y8mMT7t",
            "attributes": {
                "name": "Orville Peck"
            }
        },
        {
            "id": "r.SvEnrEf",
            "type": "library-artists",
            "href": "/v1/me/library/artists/r.SvEnrEf",
            "attributes": {
                "name": "Florence + the Machine"
            }
        }
    ],
    "meta": {
        "total": 10
    }
}
```

## See Also

[`LibraryArtists`](../applemusicapi/libraryartists.md)

A resource object that represents an artist present in a user’s library.

[`LibraryArtistsResponse`](../applemusicapi/libraryartistsresponse.md)

The response to a library artists request.
