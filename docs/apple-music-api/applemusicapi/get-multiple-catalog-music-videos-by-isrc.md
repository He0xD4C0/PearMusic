---
title: "Get Multiple Catalog Music Videos by ISRC"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Catalog-Music-Videos-by-ISRC
date: 2026-06-03
---
# Get Multiple Catalog Music Videos by ISRC

Fetch one or more music videos by using their International Standard Recording Code (ISRC) values.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/music-videos?filter[isrc]=GB1302001140
```

**Response:**

```json
{
    "data": [
        {
            "id": "1553279848",
            "type": "music-videos",
            "href": "/v1/catalog/us/music-videos/1553279848",
            "attributes": {
                "previews": [
                    {
                        "url": "https: //video-ssl.itunes.apple.com/itunes-assets/Video114/v4/c8/14/3c/c8143cb4-e58a-8075-44b0-602f43d7646f/mzvf_2953199973497507158.720w.h264lc.U.p.m4v",
                        "hlsUrl": "https: //play.itunes.apple.com/WebObjects/MZPlay.woa/hls/playlist.m3u8?cc=US&a=1553279848&id=231169237&l=en&aec=HD",
                        "artwork": {
                            "width": 1560,
                            "url": "https: //is3-ssl.mzstatic.com/image/thumb/Video124/v4/26/6b/fe/266bfe0f-9d0c-e992-ae86-ce97cb251e40/Job80599ed4-a39e-455a-9f99-5bdc54c44284-109334076-PreviewImage_preview_image_43000_video_sdr-Time1613053183818.png/{w}x{h}bb.jpeg",
                            "height": 1080,
                            "textColor3": "353c3d",
                            "textColor2": "181e1f",
                            "textColor4": "3b4445",
                            "textColor1": "101414",
                            "bgColor": "cadee0",
                            "hasP3": false
                        }
                    }
                ],
                "artwork": {
                    "width": 640,
                    "url": "https: //is1-ssl.mzstatic.com/image/thumb/Video124/v4/3f/1e/6f/3f1e6f35-6960-3f0e-0a0c-8701aa2012d4/dj.bcvxpufw.jpg/{w}x{h}mv.jpeg",
                    "height": 360,
                    "textColor3": "6b98c7",
                    "textColor2": "7cb0ea",
                    "textColor4": "638dbb",
                    "textColor1": "86bff9",
                    "bgColor": "000000",
                    "hasP3": false
                },
                "artistName": "Dua Lipa",
                "url": "https: //music.apple.com/us/music-video/were-good/1553279848",
                "genreNames": [
                    "Pop"
                ],
                "has4K": false,
                "durationInMillis": 191913,
                "releaseDate": "2021-02-12",
                "name": "We’re Good",
                "isrc": "GB1302001140",
                "playParams": {
                    "id": "1553279848",
                    "kind": "musicVideo"
                },
                "hasHDR": false
            },
            "relationships": {
                "artists": {
                    "href": "/v1/catalog/us/music-videos/1553279848/artists",
                    "data": [
                        {
                            "id": "1031397873",
                            "type": "artists",
                            "href": "/v1/catalog/us/artists/1031397873"
                        }
                    ]
                },
                "albums": {
                    "href": "/v1/catalog/us/music-videos/1553279848/albums",
                    "data": []
                }
            }
        }
    ],
    "meta": {
        "filters": {
            "isrc": {
                "GB1302001140": [
                    {
                        "id": "1552406856",
                        "type": "music-videos",
                        "href": "/v1/catalog/us/music-videos/1552406856"
                    },
                    {
                        "id": "1553279848",
                        "type": "music-videos",
                        "href": "/v1/catalog/us/music-videos/1553279848"
                    }
                ]
            }
        }
    }
}
```

## See Also

[`MusicVideos`](../applemusicapi/musicvideos.md)

A resource object that represents a music video.

[`MusicVideosResponse`](../applemusicapi/musicvideosresponse.md)

The response to a music videos request.
