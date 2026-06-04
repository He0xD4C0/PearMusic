---
title: "Get a Catalog Record Label"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Record-Label
date: 2026-06-03
---
# Get a Catalog Record Label

Fetch a record label by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/record-labels/1543990853
```

**Response:**

```json
{
    "data": [
        {
            "id": "1543990853",
            "type": "record-labels",
            "href": "/v1/catalog/us/record-labels/1543990853",
            "attributes": {
                "artwork": {
                    "width": 1080,
                    "height": 1080,
                    "url": "https: //is3-ssl.mzstatic.com/image/thumb/Features114/v4/2b/20/be/2b20be3f-6f19-3701-074e-b233964caaa7/QkwtTVMtV1ctTmluamFfVHVuZS1BREFNX0lEPTE1NDM5OTA4NTMucG5n.png/{w}x{h}bb.jpg",
                    "bgColor": "111111",
                    "textColor1": "93c7d9",
                    "textColor2": "89b6c6",
                    "textColor3": "759caa",
                    "textColor4": "6d8f9b"
                },
                "description": {
                    "standard": "Ninja Tune—formed in 1990 by Matt Black and Jon More (Coldcut)—has established itself as one of the world’s leading independent record labels. Now it’s a bona fide global music institution, synonymous with diverse, uncompromising releases and equally visionary artists—from breaking to GRAMMY-nominated acts—committed to pushing the boundaries of music. (From the label)"
                },
                "name": "Ninja Tune",
                "url": "https: //music.apple.com/us/label/ninja-tune/1543990853"
            }
        }
    ]
}
```

## See Also

[`RecordLabels`](../applemusicapi/recordlabels.md)

A resource object that represents a record label.

[`RecordLabelsResponse`](../applemusicapi/recordlabelsresponse.md)

The response to a request for record labels.
