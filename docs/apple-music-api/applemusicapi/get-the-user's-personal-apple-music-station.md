---
title: "Get the User's Personal Apple Music Station"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-The-User's-Personal-Apple-Music-Station
date: 2026-06-03
---
# Get the User's Personal Apple Music Station

Fetch the current user’s personal Apple Music station.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/stations?filter[identity]=personal
```

**Response:**

```json
{
    "data": [
        {
            "id": "ra.u-741b035f6f0a85c81abb70ff757aa95f",
            "type": "stations",
            "href": "/v1/catalog/us/stations/ra.u-741b035f6f0a85c81abb70ff757aa95f",
            "attributes": {
                "artwork": {
                    "width": 2400,
                    "height": 2400,
                    "url": "https: //is1-ssl.mzstatic.com/image/thumb/Features124/v4/7b/1d/f0/7b1df048-0017-8ac0-98c9-735f14849606/mza_7507996640781423701.png/{w}x{h}bb.jpg"
                },
                "name": "My Station",
                "mediaKind": "audio",
                "playParams": {
                    "id": "ra.u-741b035f6f0a85c81abb70ff757aa95f",
                    "kind": "radioStation",
                    "format": "tracks",
                    "stationHash": "CgoIByIGCPeqnL8HEAE",
                    "hasDrm": false,
                    "mediaType": 0
                },
                "url": "https: //music.apple.com/us/station/grace-lis-station/ra.u-741b035f6f0a85c81abb70ff757aa95f",
                "isLive": false
            }
        }
    ],
    "meta": {
        "filters": {
            "identity": {
                "personal": [
                    {
                        "id": "ra.u-741b035f6f0a85c81abb70ff757aa95f",
                        "type": "stations",
                        "href": "/v1/catalog/us/stations/ra.u-741b035f6f0a85c81abb70ff757aa95f"
                    }
                ]
            }
        }
    }
}
```

## See Also

[`Stations`](../applemusicapi/stations.md)

A resource object that represents a station.

[`StationsResponse`](../applemusicapi/stationsresponse.md)

The response to a stations request.
