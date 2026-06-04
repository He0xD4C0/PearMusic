---
title: "Get a Library Song's Relationship Directly by Name"
source: https://developer.apple.com/documentation/AppleMusicAPI/Fetch-a-relationship-on-this-resource-by-name-9xvg6
date: 2026-06-03
---
# Get a Library Song's Relationship Directly by Name

Fetch a library song’s relationship by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/songs/i.PkdJNdAIrQozOW/albums
```

**Response:**

```json
{    
    "data": [
        {
            "id": "l.fsnYeFy",
            "type": "library-albums",
            "href": "/v1/me/library/albums/l.fsnYeFy",
            "attributes": {
                "trackCount": 1,
                "genreNames": [
                    "Latin"
                ],
                "releaseDate": "2022-05-06",
                "name": "Un Verano Sin Ti",
                "artistName": "Bad Bunny",
                "artwork": {
                    "width": 1200,
                    "height": 1200,
                    "url": "https://is5-ssl.mzstatic.com/image/thumb/Music112/v4/3e/04/eb/3e04ebf6-370f-f59d-ec84-2c2643db92f1/196626945068.jpg/{w}x{h}bb.jpg"
                },
                "playParams": {
                    "id": "l.fsnYeFy",
                    "kind": "album",
                    "isLibrary": true
                },
                "dateAdded": "2022-08-06T02:51:42Z"
            }
        }
    ]
}
```

## See Also

[`LibrarySongs`](../applemusicapi/librarysongs.md)

A resource object that represents a library song.

[`LibrarySongsResponse`](../applemusicapi/librarysongsresponse.md)

The response to a library songs request.
