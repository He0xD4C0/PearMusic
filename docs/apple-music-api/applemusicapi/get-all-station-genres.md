---
title: "Get All Station Genres"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-All-Station-Genres
date: 2026-06-03
---
# Get All Station Genres

Fetch all station genres for a given storefront.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/station-genres
```

**Response:**

```json
{
    "data": [
        {
            "id": "1149486245",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486245",
            "attributes": {
                "name": "Electronic"
            }
        },
        {
            "id": "1149486314",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486314",
            "attributes": {
                "name": "Latin"
            }
        },
        {
            "id": "1149486325",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486325",
            "attributes": {
                "name": "Metal"
            }
        },
        {
            "id": "1149486238",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486238",
            "attributes": {
                "name": "Dance"
            }
        },
        {
            "id": "1149486299",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486299",
            "attributes": {
                "name": "Jazz"
            }
        },
        {
            "id": "1149486336",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486336",
            "attributes": {
                "name": "Pop"
            }
        },
        {
            "id": "1149486287",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486287",
            "attributes": {
                "name": "Hip-Hop/R&B"
            }
        },
        {
            "id": "1149486381",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486381",
            "attributes": {
                "name": "Workout"
            }
        },
        {
            "id": "1149486231",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486231",
            "attributes": {
                "name": "Country"
            }
        },
        {
            "id": "1184713285",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1184713285",
            "attributes": {
                "name": "Holiday"
            }
        },
        {
            "id": "1149484144",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149484144",
            "attributes": {
                "name": "Alternative & Indie"
            }
        },
        {
            "id": "1149486361",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486361",
            "attributes": {
                "name": "Reggae"
            }
        },
        {
            "id": "1149486377",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486377",
            "attributes": {
                "name": "Singer/Songwriter"
            }
        },
        {
            "id": "1149486281",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486281",
            "attributes": {
                "name": "From Around the World"
            }
        },
        {
            "id": "1149486223",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486223",
            "attributes": {
                "name": "Christian"
            }
        },
        {
            "id": "1154291546",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1154291546",
            "attributes": {
                "name": "Hits by Decade"
            }
        },
        {
            "id": "1149486227",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486227",
            "attributes": {
                "name": "Classical"
            }
        },
        {
            "id": "1149486306",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486306",
            "attributes": {
                "name": "Kids & Family"
            }
        },
        {
            "id": "1149486365",
            "type": "station-genres",
            "href": "/v1/catalog/us/station-genres/1149486365",
            "attributes": {
                "name": "Rock"
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
