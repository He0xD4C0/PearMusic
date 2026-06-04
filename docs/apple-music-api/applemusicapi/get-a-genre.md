---
title: "Get a Catalog Genre"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Genre
date: 2026-06-03
---
# Get a Catalog Genre

Fetch a genre by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains a single `Genre` object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/genres/14
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
        }
    ]
}
```

## See Also

[`Genres`](../applemusicapi/genres.md)

A resource object that represents a music genre.

[`GenresResponse`](../applemusicapi/genresresponse.md)

The response to a genres request.
