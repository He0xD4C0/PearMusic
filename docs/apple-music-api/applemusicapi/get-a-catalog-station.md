---
title: "Get a Catalog Station"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Catalog-Station
date: 2026-06-03
---
# Get a Catalog Station

Fetch a station by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/stations/ra.1498157166
```

**Response:**

```json
{
    "data": [
        {
            "id": "ra.1498157166",
            "type": "stations",
            "href": "/v1/catalog/us/stations/ra.1498157166",
            "attributes": {
                "artwork": {
                    "width": 4320,
                    "height": 1080,
                    "url": "https: //is5-ssl.mzstatic.com/image/thumb/Features114/v4/89/e2/66/89e266ee-454e-87e7-e108-dea53c54da6a/U0MtTVMtV1ctQU1fQ291bnRyeS5wbmc.png/{w}x{h}sr.jpg",
                    "bgColor": "f4f4f4",
                    "textColor1": "000000",
                    "textColor2": "142234",
                    "textColor3": "3a412d",
                    "textColor4": "364354"
                },
                "mediaKind": "audio",
                "isLive": true,
                "name": "Apple Music Country",
                "playParams": {
                    "id": "ra.1498157166",
                    "kind": "radioStation",
                    "format": "stream",
                    "stationHash": "CgkIBRoF7qCwygUQBA",
                    "hasDrm": true,
                    "mediaType": 0
                },
                "supportedDrms": [
                    "fairplay",
                    "playready",
                    "widevine"
                ],
                "editorialNotes": {
                    "name": "Apple Music Country",
                    "short": "Where it sounds like home.",
                    "tagline": "Where it sounds like home."
                },
                "url": "https: //music.apple.com/us/station/apple-music-country/ra.1498157166"
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
