---
title: "Get a Library Playlist"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-a-Library-Playlist
date: 2026-06-03
---
# Get a Library Playlist

Fetch a library playlist by using its identifier.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlists/p.ldvAAZ3C3Qmop9
```

**Response:**

```json
{
    "data": [
        {
            "id": "p.ldvAAZ3C3Qmop9",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.ldvAAZ3C3Qmop9",
            "attributes": {
                "playParams": {
                    "id": "p.ldvAAZ3C3Qmop9",
                    "kind": "playlist",
                    "isLibrary": true,
                    "globalId": "pl.cb4d1c09a2df4230a78d0395fe1f8fde"
                },
                "canEdit": false,
                "name": "Piano Chill",
                "description": {
                    "standard": "Discover the liberating power of the piano with pieces chosen by Dirk Maassen."
                },
                "dateAdded": "2021-09-30T00: 55: 48Z",
                "artwork": {
                    "width": null,
                    "height": null,
                    "url": "https: //is3-ssl.mzstatic.com/image/thumb/Features125/v4/dc/47/7c/dc477c6f-9029-bd1c-8e89-87b04042a55b/U0MtTVMtV1ctUGlhbm9fQ2hpbGwtQURBTV9JRD0xMDcyODMxMzA0LnBuZw.png/{w}x{h}SC.DN01.jpeg"
                },
                "isPublic": false,
                "hasCatalog": true
            }
        }
    ]
}
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
