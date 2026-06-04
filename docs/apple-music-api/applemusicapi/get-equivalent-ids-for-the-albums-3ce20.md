---
title: "Get Equivalent Catalog Songs by ID"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Equivalent-Ids-for-the-Albums-3ce20
date: 2026-06-03
---
# Get Equivalent Catalog Songs by ID

Fetch the equivalent, available content in the storefront for the provided songs’ identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/jp/songs?filter[equivalents]=1613600188
```

**Response:**

```json
{
    "data": [
        {
            "id": "1633956893",
            "type": "songs",
            "href": "/v1/catalog/jp/songs/1633956893",
            "attributes": {
                "albumName": "Emotional Creature",
                "genreNames": [
                    "オルタナティブ",
                    "ミュージック"
                ],
                "trackNumber": 1,
                "durationInMillis": 221000,
                "releaseDate": "2022-06-09",
                "isrc": "USQE92100257",
                "artwork": {
                    "width": 3000,
                    "height": 3000,
                    "url": "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/47/49/f3/4749f340-ad43-3f73-7e06-24d3f1b27536/4580789485473.png/{w}x{h}bb.jpg",
                    "bgColor": "202020",
                    "textColor1": "aea6f6",
                    "textColor2": "b68ef6",
                    "textColor3": "918bcb",
                    "textColor4": "9878cb"
                },
                "composerName": "Lili Trifilio, Anthony Vaccaro, Jon Alvarado & Matt Henkels",
                "playParams": {
                    "id": "1633956893",
                    "kind": "song"
                },
                "url": "https://music.apple.com/jp/album/entropy/1633956892?i=1633956893",
                "discNumber": 1,
                "hasLyrics": true,
                "isAppleDigitalMaster": true,
                "name": "Entropy",
                "previews": [
                    {
                        "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/8b/8a/b8/8b8ab889-334c-bdd9-6419-2d22aedd883b/mzaf_5194841074403978881.plus.aac.p.m4a"
                    }
                ],
                "artistName": "Beach Bunny"
            },
            "relationships": {
                "albums": {
                    "href": "/v1/catalog/jp/songs/1633956893/albums",
                    "data": [
                        {
                            "id": "1633956892",
                            "type": "albums",
                            "href": "/v1/catalog/jp/albums/1633956892"
                        }
                    ]
                },
                "artists": {
                    "href": "/v1/catalog/jp/songs/1633956893/artists",
                    "data": [
                        {
                            "id": "1147783278",
                            "type": "artists",
                            "href": "/v1/catalog/jp/artists/1147783278"
                        }
                    ]
                }
            }
        }
    ],
    "meta": {
        "filters": {
            "equivalents": {
                "1613600188": [
                    {
                        "id": "1633956893",
                        "type": "songs",
                        "href": "/v1/catalog/jp/songs/1633956893"
                    }
                ]
            }
        }
    }
}
```

## See Also

[`Songs`](../applemusicapi/songs.md)

A resource object that represents a song.

[`SongsResponse`](../applemusicapi/songsresponse.md)

The response to a songs request.
