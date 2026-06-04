---
title: "Get Catalog Search Suggestions"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Catalog-Search-Suggesions
date: 2026-06-03
---
# Get Catalog Search Suggestions

Fetch the search suggestions for a provided term input.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `results` object contains a single `terms` array. This array contains a list of possible valid search queries determined from the search hint. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/search/suggestions?term=beach+bunny&kinds=terms
```

**Response:**

```json
{
    "results": {
        "suggestions": [
            {
                "kind": "terms",
                "searchTerm": "beach bunny",
                "displayTerm": "beach bunny"
            },
            {
                "kind": "terms",
                "searchTerm": "oxygen beach bunny",
                "displayTerm": "oxygen beach bunny"
            },
            {
                "kind": "terms",
                "searchTerm": "cloud 9 beach bunny",
                "displayTerm": "cloud 9 beach bunny"
            }
        ]
    }
}
```

## See Also

[`SearchSuggestionsResponse`](../applemusicapi/searchsuggestionsresponse.md)

The response to a request for search suggestions.
