---
title: "Get a Catalog Album’s Relationship View Directly by Name"
source: https://developer.apple.com/documentation/AppleMusicAPI/Fetch-a-view-on-this-resource-by-name-2we6l
date: 2026-06-03
---
# Get a Catalog Album’s Relationship View Directly by Name

Fetch related resources for a single album’s relationship view.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/albums/1616728060/view/related-videos
```

**Response:**

```json
{    
     "data": [
        {
            "id": "1606839682",
            "type": "music-videos",
            "href": "/v1/catalog/us/music-videos/1606839682",
            "attributes": {
                "genreNames": [
                    "R&B/Soul"
                ],
                "durationInMillis": 208787,
                "releaseDate": "2022-01-28",
                "isrc": "USUV72200057",
                "artwork": {
                    "width": 3790,
                    "height": 2122,
                    "url": "https://is2-ssl.mzstatic.com/image/thumb/Video116/v4/6f/80/43/6f8043f3-9b94-3ab3-0e1b-0f8dc27f90f9/22UMGIM02496.crop.jpg/{w}x{h}mv.jpg",
                    "bgColor": "02090c",
                    "textColor1": "acf2b2",
                    "textColor2": "7ff1c0",
                    "textColor3": "8ac490",
                    "textColor4": "66c29c"
                },
                "playParams": {
                    "id": "1606839682",
                    "kind": "musicVideo"
                },
                "url": "https://music.apple.com/us/music-video/dfmu/1606839682",
                "has4K": true,
                "hasHDR": false,
                "name": "DFMU",
                "previews": [
                    {
                        "url": "https://video-ssl.itunes.apple.com/itunes-assets/Video126/v4/73/5b/cb/735bcb87-1f91-bb06-d098-eea7866b2cbf/mzvf_2006670849421979318.720w.h264lc.U.p.m4v",
                        "hlsUrl": "https://play.itunes.apple.com/WebObjects/MZPlay.woa/hls/playlist.m3u8?cc=US&a=1606839682&id=375857650&l=en&aec=HD",
                        "artwork": {
                            "width": 3840,
                            "height": 2160,
                            "url": "https://is4-ssl.mzstatic.com/image/thumb/Video116/v4/5d/4d/c8/5d4dc859-83e5-8e15-b372-aee21f417090/Jobe78af989-1373-4828-abea-eb244e0ad9e9-128191833-PreviewImage_preview_image_45000_video_sdr-Time1643335973453.png/{w}x{h}bb.jpg",
                            "bgColor": "000001",
                            "textColor1": "dfd5c6",
                            "textColor2": "d2ac8e",
                            "textColor3": "b2ab9e",
                            "textColor4": "a78972"
                        }
                    }
                ],
                "artistName": "Ella Mai",
                "contentRating": "explicit"
            }
        }
    ]
}
```

## See Also

[`Albums`](../applemusicapi/albums.md)

A resource object that represents an album.

[`AlbumsResponse`](../applemusicapi/albumsresponse.md)

The response to an albums request.
