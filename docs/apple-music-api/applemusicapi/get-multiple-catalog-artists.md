---
title: "Get Multiple Catalog Artists"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Catalog-Artists
date: 2026-06-03
---
# Get Multiple Catalog Artists

Fetch one or more artists by using their identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/catalog/us/artists?ids=1147783278
```

**Response:**

```json
{
    "data": [
        {
            "id": "1147783278",
            "type": "artists",
            "href": "/v1/catalog/us/artists/1147783278",
            "attributes": {
                "genreNames": [
                    "Alternative"
                ],
                "name": "Beach Bunny",
                "artwork": {
                    "width": 2011,
                    "height": 2011,
                    "url": "https://is4-ssl.mzstatic.com/image/thumb/Music122/v4/ee/38/80/ee3880eb-e996-8b35-887f-c71c8ad800ac/pr_source.png/{w}x{h}bb.jpg",
                    "bgColor": "19160f",
                    "textColor1": "f3949b",
                    "textColor2": "b08ff2",
                    "textColor3": "c77b7f",
                    "textColor4": "9277c5"
                },
                "url": "https://music.apple.com/us/artist/beach-bunny/1147783278"
            },
            "relationships": {
                "albums": {
                    "href": "/v1/catalog/us/artists/1147783278/albums",
                    "data": [
                        {
                            "id": "1482041821",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1482041821"
                        },
                        {
                            "id": "1613600183",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1613600183"
                        },
                        {
                            "id": "1476463573",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1476463573"
                        },
                        {
                            "id": "1476463541",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1476463541"
                        },
                        {
                            "id": "1537898980",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1537898980"
                        },
                        {
                            "id": "1147798746",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1147798746"
                        },
                        {
                            "id": "1147782780",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1147782780"
                        },
                        {
                            "id": "1445627459",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1445627459"
                        },
                        {
                            "id": "1589473324",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1589473324"
                        },
                        {
                            "id": "1509311498",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1509311498"
                        },
                        {
                            "id": "1562419539",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1562419539"
                        },
                        {
                            "id": "1243697430",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1243697430"
                        },
                        {
                            "id": "1590556925",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1590556925"
                        },
                        {
                            "id": "1596358408",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1596358408"
                        }
                    ]
                }
            }
        }
    ]
}
```

## See Also

[`Artists`](../applemusicapi/artists.md)

A resource object that represents the artist of an album where an artist can be one or more people.

[`ArtistsResponse`](../applemusicapi/artistsresponse.md)

The response to an artists request.
