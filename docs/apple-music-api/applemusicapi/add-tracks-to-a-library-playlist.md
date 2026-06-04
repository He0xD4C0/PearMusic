---
title: "Add Tracks to a Library Playlist"
source: https://developer.apple.com/documentation/AppleMusicAPI/Add-Tracks-to-a-Library-Playlist
date: 2026-06-03
---
# Add Tracks to a Library Playlist

Add new tracks to the end of a library playlist.

## Discussion

If successful, the HTTP status code is 204 and the tracks added as a result. If unsuccessful, the HTTP status code indicates the error and the details are in the `errors` array.

This endpoint requires a music user token. For more information, see [User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md).

> Note:
> There may be a delay before a new resource appears in a user’s library.

You can include an optional `tracks` relationship in this request.

### Example

**Request:**

```
https://api.music.apple.com/v1/me/library/playlists/p.RB1AARBIv74Zkl/tracks
```

**Response:**

```json
No response body
```

## See Also

[`LibraryPlaylists`](../applemusicapi/libraryplaylists.md)

A resource object that represents a library playlist.

[`LibraryPlaylistsResponse`](../applemusicapi/libraryplaylistsresponse.md)

The response to a library playlists request.
