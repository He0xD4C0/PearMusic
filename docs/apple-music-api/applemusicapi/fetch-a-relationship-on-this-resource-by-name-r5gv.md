---
title: "Get a Library Playlist Folder’s Relationship Directly by Name"
source: https://developer.apple.com/documentation/AppleMusicAPI/Fetch-a-relationship-on-this-resource-by-name-r5gv
date: 2026-06-03
---
# Get a Library Playlist Folder’s Relationship Directly by Name

Fetch a library playlist folder’s relationship by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlist-folders/p.WmzVVDOUO9pDBk/children
```

**Response:**

```json
{    
    "data": [
        {
            "id": "p.RB1AA8bCv74Zkl",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.RB1AA8bCv74Zkl",
            "attributes": {
                "description": {
                    "standard": ""
                },
                "dateAdded": "2021-12-03T19: 06: 29Z",
                "hasCatalog": true,
                "isPublic": false,
                "playParams": {
                    "id": "p.RB1AA8bCv74Zkl",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.u-jV8990gT3bLqrj"
                },
                "name": "Chill JPop",
                "canEdit": true
            }
        },
        {
            "id": "p.eoGxpgbtxAPJG6",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.eoGxpgbtxAPJG6",
            "attributes": {
                "description": {
                    "standard": ""
                },
                "dateAdded": "2021-09-02T18: 43: 15Z",
                "hasCatalog": true,
                "isPublic": true,
                "playParams": {
                    "id": "p.eoGxpgbtxAPJG6",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.u-WabZ6rRCYW2vBE"
                },
                "name": "Chill Tracks Instrumental",
                "canEdit": true
            }
        },
        {
            "id": "p.4Y0JJrJuMWkD60",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.4Y0JJrJuMWkD60",
            "attributes": {
                "description": {
                    "standard": ""
                },
                "dateAdded": "2022-03-10T02: 26: 39Z",
                "hasCatalog": true,
                "isPublic": false,
                "playParams": {
                    "id": "p.4Y0JJrJuMWkD60",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.u-kv9llBlC6XZWBv"
                },
                "name": "Chill Tracks w/ Vocals",
                "canEdit": true
            }
        }
    ],
    "meta": {
        "total": 3
    }
}
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
