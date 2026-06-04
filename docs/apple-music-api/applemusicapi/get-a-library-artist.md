---
title: "Get a Library Artist"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Library-Artist
date: 2026-06-03
---
# Get a Library Artist

Fetch a library artist by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/artists/r.y8mMT7t
```

**Response:**

```json
{    
    "data": [
        {
            "id": "r.y8mMT7t",
            "type": "library-artists",
            "href": "/v1/me/library/artists/r.y8mMT7t",
            "attributes": {
                "name": "Orville Peck"
            }
        }
    ]
}
```

## See Also

[`LibraryArtists`](../applemusicapi/libraryartists.md)

A resource object that represents an artist present in a user’s library.

[`LibraryArtistsResponse`](../applemusicapi/libraryartistsresponse.md)

The response to a library artists request.
