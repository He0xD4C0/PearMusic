---
title: "Get a Library Artist's Relationship Directly by Name"
source: https://developer.apple.com/documentation/AppleMusicAPI/Fetch-a-relationship-on-this-resource-by-name-9dsoc
date: 2026-06-03
---
# Get a Library Artist's Relationship Directly by Name

Fetch a library artist’s relationship by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/artists/r.y8mMT7t/albums
```

**Response:**

```json
{
    "data": [
        {
            "id": "l.sticiFl",
            "type": "library-albums",
            "href": "/v1/me/library/albums/l.sticiFl",
            "attributes": {
                "trackCount": 15,
                "genreNames": [
                    "Country"
                ],
                "releaseDate": "2022-02-11",
                "name": "Bronco",
                "artistName": "Orville Peck",
                "artwork": {
                    "width": 1200,
                    "height": 1200,
                    "url": "https://is3-ssl.mzstatic.com/image/thumb/Music116/v4/6d/de/02/6dde02ae-a9fe-f96e-e81f-4f18ad13d2f9/886449873302.jpg/{w}x{h}bb.jpg"
                },
                "dateAdded": "2022-08-06T02:18:57Z",
                "playParams": {
                    "id": "l.sticiFl",
                    "kind": "album",
                    "isLibrary": true
                }
            }
        }
    ],
    "meta": {
        "total": 1
    }
}
```

## See Also

[`LibraryArtists`](../applemusicapi/libraryartists.md)

A resource object that represents an artist present in a user’s library.

[`LibraryArtistsResponse`](../applemusicapi/libraryartistsresponse.md)

The response to a library artists request.
