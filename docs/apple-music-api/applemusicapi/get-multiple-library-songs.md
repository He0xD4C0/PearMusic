---
title: "Get Multiple Library Songs"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Library-Songs
date: 2026-06-03
---
# Get Multiple Library Songs

Fetch one or more library songs by using their identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/songs?ids=i.PkdJNdAIrQozOW
```

**Response:**

```json
{    
    "data": [
        {
            "id": "i.PkdJNdAIrQozOW",
            "type": "library-songs",
            "href": "/v1/me/library/songs/i.PkdJNdAIrQozOW",
            "attributes": {
                "discNumber": 1,
                "albumName": "Un Verano Sin Ti",
                "genreNames": [
                    "Latin"
                ],
                "trackNumber": 10,
                "hasLyrics": true,
                "releaseDate": "2022-05-06",
                "durationInMillis": 213061,
                "name": "Efecto",
                "artistName": "Bad Bunny",
                "artwork": {
                    "width": 1200,
                    "height": 1200,
                    "url": "https://is5-ssl.mzstatic.com/image/thumb/Music112/v4/3e/04/eb/3e04ebf6-370f-f59d-ec84-2c2643db92f1/196626945068.jpg/{w}x{h}bb.jpg"
                },
                "playParams": {
                    "id": "i.PkdJNdAIrQozOW",
                    "kind": "song",
                    "isLibrary": true,
                    "reporting": true,
                    "catalogId": "1622045954",
                    "reportingId": "1622045954"
                }
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
