---
title: "Get a Catalog Curator"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Catalog-Curator
date: 2026-06-03
---
# Get a Catalog Curator

Fetch a curator by using the curator’s identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains a single `Curator` object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/curators/1107687517
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "artwork": {
                    "bgColor": "ffffff",
                    "height": 1080,
                    "textColor1": "000000",
                    "textColor2": "2d2d2d",
                    "textColor3": "333333",
                    "textColor4": "575757",
                    "url": "https://example.mzstatic.com/image/thumb/Features30/v4/8a/d7/80/8ad7800c-06cd-db72-91c7-55ff8bec0346/source/{w}x{h}bb.jpeg",
                    "width": 1080
                },
                "editorialNotes": {
                    "short": "LargeUp is the global platform for Caribbean music, arts and culture. ",
                    "standard": "LargeUp, the global platform for Caribbean music, arts and culture. Since 2009, LargeUp.com has captured the vibrant sounds, styles, flavors, destinations and activities of the islands, spotlighting the best in reggae, dancehall, soca, reggaeton and kompa."
                },
                "name": "LargeUp",
                "url": "https://itunes.apple.com/us/curator/largeup/id1107687517"
            },
            "href": "/v1/catalog/us/curators/1107687517",
            "id": "1107687517",
            "relationships": {
                "playlists": {
                    "data": [],
                    "href": "/v1/catalog/us/curators/1107687517/playlists"
                }
            },
            "type": "curators"
        }
    ]
}
```

## See Also

[`Curators`](../applemusicapi/curators.md)

A resource object that represents a curator.

[`CuratorsResponse`](../applemusicapi/curatorsresponse.md)

The response to a request for curators.
