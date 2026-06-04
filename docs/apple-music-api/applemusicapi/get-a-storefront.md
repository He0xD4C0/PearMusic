---
title: "Get a Storefront"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Storefront
date: 2026-06-03
---
# Get a Storefront

Fetch a single storefront by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains a single [`Storefronts`](../applemusicapi/storefronts.md) object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

### Example

**Request:**

```
https://api.music.apple.com/v1/storefronts/jp
```

**Response:**

```json
{
    "data": [
        {
            "id": "jp",
            "type": "storefronts",
            "href": "/v1/storefronts/jp",
            "attributes": {
                "defaultLanguageTag": "ja",
                "name": "Japan",
                "explicitContentPolicy": "allowed",
                "supportedLanguageTags": [
                    "ja",
                    "en-US"
                ]
            }
        }
    ]
}
```

## See Also

[`Storefronts`](../applemusicapi/storefronts.md)

A resource object that represents a storefront, an Apple Music and iTunes Store territory that the content is available in.

[`StorefrontsResponse`](../applemusicapi/storefrontsresponse.md)

The response to a storefront request.
