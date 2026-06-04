---
title: "Get Multiple Library Resources Using Resource-Typed ID Parameters"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Library-Resources-by-resource-typed-ids-parameters
date: 2026-06-03
---
# Get Multiple Library Resources Using Resource-Typed ID Parameters

Fetch one or more library resources by using their identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library?ids[library-songs]=i.gelNOzPuL41Lxo
```

**Response:**

```json
{
    "data": [
        {
            "id": "i.gelNOzPuL41Lxo",
            "type": "library-songs",
            "href": "/v1/me/library/songs/i.gelNOzPuL41Lxo",
            "attributes": {
                "artwork": {
                    "width": 1200,
                    "height": 1200,
                    "url": "https: //is3-ssl.mzstatic.com/image/thumb/Music115/v4/2d/f3/c9/2df3c9fd-e0eb-257c-c035-b04f05a66580/21UMGIM36691.rgb.jpg/{w}x{h}bb.jpeg",
                    "hasP3": false
                },
                "artistName": "Billie Eilish",
                "discNumber": 1,
                "genreNames": [
                    "Alternative"
                ],
                "durationInMillis": 298899,
                "releaseDate": "2021-07-30",
                "name": "Happier Than Ever",
                "hasLyrics": true,
                "albumName": "Happier Than Ever",
                "playParams": {
                    "id": "i.gelNOzPuL41Lxo",
                    "kind": "song",
                    "isLibrary": true,
                    "reporting": true,
                    "catalogId": "1564531202"
                },
                "trackNumber": 15,
                "contentRating": "explicit"
            }
        }
    ]
}
```

## See Also

[`Resource`](../applemusicapi/resource.md)

A resource—such as an album, song, or playlist.
