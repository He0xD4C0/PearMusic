---
title: "Get Multiple Stations Genres"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Stations-Genres
date: 2026-06-03
---
# Get Multiple Stations Genres

Fetch one or more station genres by using their identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/station-genres?ids=1149486336
```

**Response:**

```json
{
    "data": [
        {
            "id": "1149486336",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486336",
            "attributes": {
                "name": "Pop"
            }
        }
    ]
}
```

## See Also

[`StationGenres`](../applemusicapi/stationgenres.md)

A resource object that represents a station genre.

[`StationGenresResponse`](../applemusicapi/stationgenresresponse.md)

The response to a specific station genres resource request.
