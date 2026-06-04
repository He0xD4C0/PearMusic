---
title: "Get Catalog Search Hints"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Catalog-Search-Hints
date: 2026-06-03
---
# Get Catalog Search Hints

Fetch the search term results for a hint.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `results` object contains a single `terms` array. This array contains a list of possible valid search queries determined from the search hint. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

These results are autocompletion options for the hint and are potential search terms. For more information, see [`Search for Catalog Resources`](../applemusicapi/search-for-catalog-resources-(by-type.md)).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/search/hints?term=beach+bunny
```

**Response:**

```json
{
    "results": {
        "terms": [
            "beach bunny",
            "oxygen beach bunny",
            "cloud 9 beach bunny"
        ]
    }
}
```

## See Also

[`SearchHintsResponse`](../applemusicapi/searchhintsresponse.md)

The response to a request for search hints.
