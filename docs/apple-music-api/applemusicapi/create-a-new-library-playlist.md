---
title: "Create a New Library Playlist"
source: https://developer.apple.com/documentation/AppleMusicAPI/Create-a-New-Library-Playlist
date: 2026-06-03
---
# Create a New Library Playlist

Create a new playlist in a user’s library.

## Discussion

If successful, the HTTP status code is 201 (Created) and a new resource created as a result. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

> Note:
> There may be a delay before a new resource appears in a user’s library.

You can include an optional `tracks` relationship in this request.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlists

{
  "attributes": {
    "description": "string",
    "name": "string",
    "isPublic": true
  },
  "relationships": {
    "tracks": {
      "data": [
        {
          "id": "string",
          "type": "library-music-videos"
        }
      ]
    },
    "parent": {
      "data": [
        {
          "id": "string",
          "type": "library-playlist-folders"
        }
      ]
    }
  }
}
```

**Response:**

```json
{    "data": [
        {
            "id": "p.RB1AAkGsv74Zkl",
            "type": "library-playlists",
            "href": "/v1/me/library/playlists/p.RB1AAkGsv74Zkl",
            "attributes": {
                "hasCatalog": false,
                "description": {
                    "standard": "My library playlist"
                },
                "name": "New Playlist",
                "canEdit": true,
                "isPublic": false,
                "playParams": {
                    "id": "p.RB1AAkGsv74Zkl",
                    "kind": "playlist",
                    "isLibrary": true
                },
                "dateAdded": "2021-09-30T13: 28: 29Z"
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
