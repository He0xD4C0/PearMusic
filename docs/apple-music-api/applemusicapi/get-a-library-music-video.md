---
title: "Get a Library Music Video"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Library-Music-Video
date: 2026-06-03
---
# Get a Library Music Video

Fetch a library music video by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/music-videos/i.V7B9dQLsZ8DZKe
```

**Response:**

```json
{    
    "data": [
        {
            "id": "i.V7B9dQLsZ8DZKe",
            "type": "library-music-videos",
            "href": "/v1/me/library/music-videos/i.V7B9dQLsZ8DZKe",
            "attributes": {
                "name": "We’re Good",
                "trackNumber": 0,
                "playParams": {
                    "id": "i.V7B9dQLsZ8DZKe",
                    "kind": "musicVideo",
                    "isLibrary": true,
                    "reporting": true,
                    "catalogId": "1553279848"
                },
                "artwork": {
                    "width": 1200,
                    "height": 1200,
                    "url": "https://is5-ssl.mzstatic.com/image/thumb/Video124/v4/3f/1e/6f/3f1e6f35-6960-3f0e-0a0c-8701aa2012d4/dj.bcvxpufw.jpg/{w}x{h}bb.jpg"
                },
                "artistName": "Dua Lipa",
                "durationInMillis": 191913,
                "releaseDate": "2021-02-12",
                "genreNames": [
                    "Pop"
                ]
            }
        }
    ]
}
```

## See Also

[`LibraryMusicVideos`](../applemusicapi/librarymusicvideos.md)

A resource object that represents a library music video.

[`LibraryMusicVideosResponse`](../applemusicapi/librarymusicvideosresponse.md)

The response to a library music videos request.
