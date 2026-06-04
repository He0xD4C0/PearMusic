---
title: "Create a New Library Playlist Folder"
source: https://developer.apple.com/documentation/AppleMusicAPI/Create-a-New-Library-Playlist-Folder
date: 2026-06-03
---
# Create a New Library Playlist Folder

Create a new playlist folder in a user’s library.

## Discussion

If successful, the HTTP status code is 201 (Created) and a new resource created as a result. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

> Note:
> There may be a delay before a new resource appears in a user’s library.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlist-folders

{
  "attributes": {
    "name": "string"
  },
  "relationships": {
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
{
    "data": [
        {
            "id": "p.WmzVVDOUO9pDBk",
            "type": "library-playlist-folders",
            "href": "/v1/me/library/playlist-folders/p.WmzVVDOUO9pDBk",
            "attributes": {
                "name": "Chill",
                "dateAdded": "2022-03-19T06:07:33Z"
            }
        }
    ],
    "meta": {
        "total": 1
    }
}
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
