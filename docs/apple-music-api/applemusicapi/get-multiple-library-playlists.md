---
title: "Get Multiple Library Playlists"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Multiple-Library-Playlists
date: 2026-06-03
---
# Get Multiple Library Playlists

Fetch one or more library playlists by using their identifiers.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlists
```

**Response:**

```json
{
    "next": "/v1/me/library/playlists?offset=25",
    "data": [
        {
            "id": "p.JL6884DCbMXbx2",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.JL6884DCbMXbx2",
            "attributes": {
                "playParams": {
                    "id": "p.JL6884DCbMXbx2",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "A-team"
            }
        },
        {
            "id": "p.mmRll1dIl68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRll1dIl68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRll1dIl68lJ3",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Acapella"
            }
        },
        {
            "id": "p.mmRll4xCl68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRll4xCl68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRll4xCl68lJ3",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "ahalahaaala"
            }
        },
        {
            "id": "p.b16GGBDFbmMbZ1",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.b16GGBDFbmMbZ1",
            "attributes": {
                "playParams": {
                    "id": "p.b16GGBDFbmMbZ1",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Ball is life"
            }
        },
        {
            "id": "p.ldvAAJgi8mV82J",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAAJgi8mV82J",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAAJgi8mV82J",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Banger EDM"
            }
        },
        {
            "id": "p.mmRll4Dil68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRll4Dil68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRll4Dil68lJ3",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "description": {
                    "standard": ""
                },
                "name": "BP"
            }
        },
        {
            "id": "p.ldvAlgxh8mV82J",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAlgxh8mV82J",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAlgxh8mV82J",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "description": {
                    "standard": ""
                },
                "name": "Bros"
            }
        },
        {
            "id": "p.b16GGVGIbmMbZ1",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.b16GGVGIbmMbZ1",
            "attributes": {
                "playParams": {
                    "id": "p.b16GGVGIbmMbZ1",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "California King Bed"
            }
        },
        {
            "id": "p.eoGxxavFkPRkoD",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.eoGxxavFkPRkoD",
            "attributes": {
                "playParams": {
                    "id": "p.eoGxxavFkPRkoD",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Charlie Shotton"
            }
        },
        {
            "id": "p.ldvAL1Xh8mV82J",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAL1Xh8mV82J",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAL1Xh8mV82J",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-15T16: 07: 45Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "ChilLAX"
            }
        },
        {
            "id": "p.ldvAAKYs8mV82J",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAAKYs8mV82J",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAAKYs8mV82J",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Chilltronic"
            }
        },
        {
            "id": "p.GE5rOQZuPmxPZA",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.GE5rOQZuPmxPZA",
            "attributes": {
                "playParams": {
                    "id": "p.GE5rOQZuPmxPZA",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": false,
                "dateAdded": "2016-04-17T06: 15: 52Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Purchased Music"
            }
        },
        {
            "id": "p.eoGxxMxHkPRkoD",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.eoGxxMxHkPRkoD",
            "attributes": {
                "playParams": {
                    "id": "p.eoGxxMxHkPRkoD",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Clusterfuck"
            }
        },
        {
            "id": "p.mmRl3Boil68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRl3Boil68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRl3Boil68lJ3",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "D^2"
            }
        },
        {
            "id": "p.mmRlvRdHl68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRlvRdHl68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRlvRdHl68lJ3",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2020-01-17T05: 10: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "D^3"
            }
        },
        {
            "id": "p.ldvAA61h8mV82J",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAA61h8mV82J",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAA61h8mV82J",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Deep House"
            }
        },
        {
            "id": "p.eoGxxYEFkPRkoD",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.eoGxxYEFkPRkoD",
            "attributes": {
                "playParams": {
                    "id": "p.eoGxxYEFkPRkoD",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Df"
            }
        },
        {
            "id": "p.DV7rrqVhRYlRkE",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.DV7rrqVhRYlRkE",
            "attributes": {
                "playParams": {
                    "id": "p.DV7rrqVhRYlRkE",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "E~D~M"
            }
        },
        {
            "id": "p.RB1Ae4VC14X1bg",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.RB1Ae4VC14X1bg",
            "attributes": {
                "playParams": {
                    "id": "p.RB1Ae4VC14X1bg",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2020-01-17T05: 10: 46Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "E~D~M1"
            }
        },
        {
            "id": "p.RB1AAbkc14X1bg",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.RB1AAbkc14X1bg",
            "attributes": {
                "playParams": {
                    "id": "p.RB1AAbkc14X1bg",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Eighteeeeens"
            }
        },
        {
            "id": "p.b16Ge6ktbmMbZ1",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.b16Ge6ktbmMbZ1",
            "attributes": {
                "playParams": {
                    "id": "p.b16Ge6ktbmMbZ1",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2020-01-17T05: 10: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "Eighteeeeens1"
            }
        },
        {
            "id": "p.RB1AJrJc14X1bg",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.RB1AJrJc14X1bg",
            "attributes": {
                "playParams": {
                    "id": "p.RB1AJrJc14X1bg",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.u-jV89DqDTdL9dN7"
                },
                "canEdit": true,
                "dateAdded": "2021-06-19T02: 37: 56Z",
                "hasCatalog": true,
                "isPublic": true,
                "description": {
                    "standard": ""
                },
                "name": "End of Covid"
            }
        },
        {
            "id": "p.eoGxx8eHkPRkoD",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.eoGxx8eHkPRkoD",
            "attributes": {
                "playParams": {
                    "id": "p.eoGxx8eHkPRkoD",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "canEdit": true,
                "dateAdded": "2019-10-14T07: 14: 47Z",
                "hasCatalog": false,
                "isPublic": false,
                "name": "FAAALLLllliinnnnggg"
            }
        },
        {
            "id": "p.GE5rdm3cPmxPZA",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.GE5rdm3cPmxPZA",
            "attributes": {
                "artwork": {
                    "width": null,
                    "height": null,
                    "url": "https: //is2-ssl.mzstatic.com/image/thumb/Features124/v4/c7/65/0e/c7650e0f-1403-bf84-4631-b43fcf5c0e65/source/{w}x{h}cc.jpeg"
                },
                "playParams": {
                    "id": "p.GE5rdm3cPmxPZA",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.pm-20e9f373919da080f53d220d517f74d7",
                    "versionHash": "c3a49729-d5de-41a9-8a5e-4e13cdad31b1"
                },
                "canEdit": false,
                "dateAdded": "2020-10-29T19: 24: 28Z",
                "hasCatalog": true,
                "isPublic": false,
                "description": {
                    "standard": "The songs you love. The more you use Apple Music, the better the mix. Refreshed every Tuesday."
                },
                "name": "Favorites Mix"
            }
        },
        {
            "id": "p.mmRl3MAIl68lJ3",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.mmRl3MAIl68lJ3",
            "attributes": {
                "playParams": {
                    "id": "p.mmRl3MAIl68lJ3",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.u-KVXBD71IZWlZPA"
                },
                "canEdit": true,
                "dateAdded": "2019-10-11T15: 07: 31Z",
                "hasCatalog": true,
                "isPublic": false,
                "name": "Fire"
            }
        }
    ],
    "meta": {
        "total": 115
    }
}
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
