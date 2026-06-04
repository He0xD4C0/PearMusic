---
title: "Get Multiple Catalog Genres"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Genres
date: 2026-06-03
---
# Get Multiple Catalog Genres

Fetch one or more genres for a specific storefront.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains an array of `Genre` objects. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/genres?ids=14,21
```

**Response:**

```json
{
    "data": [
        {
            "attributes": {
                "name": "Pop"
            },
            "href": "/v1/catalog/us/genres/14",
            "id": "14",
            "type": "genres"
        },
        {
            "attributes": {
                "name": "Rock"
            },
            "href": "/v1/catalog/us/genres/21",
            "id": "21",
            "type": "genres"
        }
    ]
}
```

## See Also

[`Genres`](../applemusicapi/genres.md)

A resource object that represents a music genre.

[`GenresResponse`](../applemusicapi/genresresponse.md)

The response to a genres request.
