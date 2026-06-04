---
title: "Get Multiple Catalog Songs by ISRC"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Catalog-Songs-by-ISRC
date: 2026-06-03
---
# Get Multiple Catalog Songs by ISRC

Fetch one or more songs by using their International Standard Recording Code (ISRC) values.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/songs?filter[isrc]=USQE92100257
```

**Response:**

```json
{
    "data": [
        {
            "id": "1613600188",
            "type": "songs",
            "href": "/v1/catalog/us/songs/1613600188",
            "attributes": {
                "albumName": "Emotional Creature",
                "genreNames": [
                    "Alternative",
                    "Music"
                ],
                "trackNumber": 1,
                "releaseDate": "2022-06-09",
                "durationInMillis": 221000,
                "isrc": "USQE92100257",
                "artwork": {
                    "width": 3000,
                    "height": 3000,
                    "url": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/df/4e/68/df4e6833-9828-51d7-cdeb-71ecf6d3a23d/810090090962.png/{w}x{h}bb.jpg",
                    "bgColor": "202020",
                    "textColor1": "aea6f6",
                    "textColor2": "b68ef6",
                    "textColor3": "918bcb",
                    "textColor4": "9878cb"
                },
                "composerName": "Anthony Vaccaro, Jon Alvarado, Lili Trifilio & Matt Henkels",
                "playParams": {
                    "id": "1613600188",
                    "kind": "song"
                },
                "url": "https://music.apple.com/us/album/entropy/1613600183?i=1613600188",
                "discNumber": 1,
                "isAppleDigitalMaster": true,
                "hasLyrics": true,
                "name": "Entropy",
                "previews": [
                    {
                        "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/72/a3/ab/72a3ab79-0066-f773-6618-7a53adc250b3/mzaf_17921540907592750976.plus.aac.p.m4a"
                    }
                ],
                "artistName": "Beach Bunny"
            },
            "relationships": {
                "albums": {
                    "href": "/v1/catalog/us/songs/1613600188/albums",
                    "data": [
                        {
                            "id": "1613600183",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1613600183"
                        }
                    ]
                },
                "artists": {
                    "href": "/v1/catalog/us/songs/1613600188/artists",
                    "data": [
                        {
                            "id": "1147783278",
                            "type": "artists",
                            "href": "/v1/catalog/us/artists/1147783278"
                        }
                    ]
                }
            }
        }
    ],
    "meta": {
        "filters": {
            "isrc": {
                "USQE92100257": [
                    {
                        "id": "1627197871",
                        "type": "songs",
                        "href": "/v1/catalog/us/songs/1627197871"
                    },
                    {
                        "id": "1633956893",
                        "type": "songs",
                        "href": "/v1/catalog/us/songs/1633956893"
                    },
                    {
                        "id": "1613600188",
                        "type": "songs",
                        "href": "/v1/catalog/us/songs/1613600188"
                    },
                    {
                        "id": "1614583362",
                        "type": "songs",
                        "href": "/v1/catalog/us/songs/1614583362"
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
