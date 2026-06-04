---
title: "Get a Catalog Station's Relationship Directly by Name"
source: https://developer.apple.com/documentation/AppleMusicAPI/Fetch-a-relationship-on-this-resource-by-name-38wmf
date: 2026-06-03
---
# Get a Catalog Station's Relationship Directly by Name

Fetch a station’s relationship using its identifier.

## Discussion

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/stations/ra.1582049480/radio-show
```

**Response:**

```json
{    
     "data": [
        {
            "id": "1496850205",
            "type": "apple-curators",
            "href": "/v1/catalog/us/apple-curators/1496850205",
            "attributes": {
                "kind": "Show",
                "name": "Easy Hits Radio with Sabi",
                "showHostName": "Sabi",
                "editorialNotes": {
                    "name": "Easy Hits Radio with Sabi",
                    "standard": "Sometimes all it takes to turn a day around is the warm ring of a familiar tune. On Apple Music, we created a show just for that. From Fleetwood Mac's “Dreams” to John Legend's “All of Me,” Easy Hits Radio is your home for the lighter side of pop.",
                    "short": "Low-key songs to help you unwind.",
                    "tagline": "Sabi"
                },
                "artwork": {
                    "width": 1080,
                    "height": 1080,
                    "url": "https://is2-ssl.mzstatic.com/image/thumb/Features124/v4/91/1a/d8/911ad8da-6d42-6b06-e883-19ff6c7f3ba1/QkwtTVMtV1ctRWFzeUhpdHNSYWRpb19BREFNX0lEPTE0OTY4NTAyMDVfbmV3bG9nby5wbmc.png/{w}x{h}bb.jpg",
                    "bgColor": "f4f4f4",
                    "textColor1": "090909",
                    "textColor2": "131212",
                    "textColor3": "2a2a2a",
                    "textColor4": "353434"
                },
                "shortName": "Easy Hits Radio",
                "url": "https://music.apple.com/us/curator/easy-hits-radio-with-sabi/1496850205"
            }
        }
    ]
}
```

## See Also

[`Stations`](../applemusicapi/stations.md)

A resource object that represents a station.

[`StationsResponse`](../applemusicapi/stationsresponse.md)

The response to a stations request.
