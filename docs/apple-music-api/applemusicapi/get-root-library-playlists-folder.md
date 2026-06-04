---
title: "Get Root Library Playlists Folder"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-Root-Library-Playlists-Folder
date: 2026-06-03
---
# Get Root Library Playlists Folder

Fetch the root library playlists folder for the user.

## Discussion

If successful, the HTTP status code is 200 (OK) and the `data` array contains the requested resource object. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlist-folders?filter[identity]=playlistsroot
```

**Response:**

```json
{
    "data": [

    ],
    "meta": {
        "filters": {
            "identity": {
                "playlistsroot": [
                    {
                        "id": "p.playlistsroot",
                        "type": "library-playlist-folders",
                        "href": "/v1/me/library/playlist-folders/p.playlistsroot"
                    }
                ]
            }
        }
    }
}
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
