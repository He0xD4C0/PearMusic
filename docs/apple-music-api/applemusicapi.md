---
title: "Apple Music API"
source: https://developer.apple.com/documentation/applemusicapi
date: 2026-06-03
---
# Apple Music API

Integrate streaming music with catalog and personal content.

## Overview

Use Apple Music API to access information about media in the Apple Music Catalog and a user’s personal iCloud Music Library.

- Apple Music Catalog includes all resources available in Apple Music.
- iCloud Music Library contains only those resources the user adds to their personal library. For example, it contains items from Apple Music, songs purchased from iTunes Store, and imports from discs and other apps. This library can include content that’s not in the Apple Music Catalog.

Use this API to retrieve information about albums, songs, artists, playlists, music videos, Apple Music stations, ratings, charts, recommendations, and the user’s most-recently played content. With proper authorization from the user, you can also create or modify playlists and apply ratings to the user’s content.

> Note:
> Use the [`AppleMusicFeed`](../applemusicfeed.md) to access the Apple Music Catalog in bulk.

## Topics

### Essentials

[Generating Developer Tokens](../applemusicapi/generating-developer-tokens.md)

Generate a developer token needed to make requests to Apple Music API.

[User Authentication for MusicKit](../applemusicapi/user-authentication-for-musickit.md)

Authenticate requests for user data using the Music User Token.

[Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md)

Write a request and handle responses from the API.

[Handling Resource Representation and Relationships](../applemusicapi/handling-resource-representation-and-relationships.md)

Fetch resources with extended attributes and included relationships and relationship views.

[Storefronts and Localization](../applemusicapi/storefronts-and-localization.md)

Pick a region-specific geographic location from which to retrieve catalog information, or retrieve information from the user’s personal library.

[Common Objects](../applemusicapi/common-objects.md)

Understand the common JSON objects that framework responses contain.

[Managing Content Ratings, Alternate Versions, and Equivalencies](../applemusicapi/managing-content-ratings-alternate-versions-and-equivalencies.md)

Handle multiple and alternate versions of content.

[Fetching Resources by Page](../applemusicapi/fetching-resources-by-page.md)

Use pagination to fetch the next set of objects.

### Albums, Artists, Songs, and Videos

[Albums](../applemusicapi/albums-api.md)

Get an album’s name, artist, list of tracks, artwork, release date, and recording information, and add new albums to the user’s library.

[Artists](../applemusicapi/artists-api.md)

Get information about an artist, including the content they created and references to them in playlists and radio stations.

[Songs](../applemusicapi/songs-api.md)

Get information about a particular song, including the artist who created it and the album on which it appeared.

[Music Videos](../applemusicapi/music-videos-api.md)

Get information about a music video, including the artist who created it and the associated album, and add new videos to the user’s library.

### Playlists and Stations

[Playlists](../applemusicapi/playlists-api.md)

Get the contents of playlists, add new playlists to the user’s library, and add tracks to an existing playlist.

[Apple Music Stations](../applemusicapi/apple-music-stations.md)

Get information about streaming content offered by Apple Music.

### Search

[Search](../applemusicapi/search.md)

Search for albums, songs, artists, and other information in the user’s personal library or the Apple Music Catalog.

### Ratings, Genres, and Charts

[Ratings](../applemusicapi/ratings-api.md)

Get and set ratings for albums, songs, playlists, music videos, and stations.

[Music Genres](../applemusicapi/music-genres.md)

Get information about the genres of the user’s music or items in the Apple Music Catalog.

[Charts](../applemusicapi/charts-api.md)

Get chart information that shows the popularity of albums, songs, and music videos.

### Activities, Curators, and Record Labels

[Activities](../applemusicapi/activities-api.md)

Get request and response activities associated with the Apple Music Catalog.

[Curators](../applemusicapi/curators-api.md)

Get information about the person who curated a playlist or station.

[Record Labels](../applemusicapi/record-labels-api.md)

Get information on record labels in the Apple Music Catalog.

### Adding a resource to favorites

[`Add resource to favorites`](../applemusicapi/add-resource-to-favorites.md)

Add the user’s resource to favorites.

### Getting a user’s replay data

[`Get the user's replay data`](../applemusicapi/get-the-user's-replay-data.md)

Fetch the user’s replay data for the latest eligible year.

### Recommendations and history

[Recommendations](../applemusicapi/recommendations.md)

Get music recommendations based on the user’s library and purchase history.

[History](../applemusicapi/history.md)

Get historical information about the songs and stations the user played recently.

### Fetching Multiple Resource Types

[`Get Multiple Catalog Resources Using Resource-Typed ID Parameters`](../applemusicapi/get-multiple-catalog-resources-by-resource-typed-ids-parameters.md)

Fetch one or more catalog resources by using their identifiers.

[`Get Multiple Library Resources Using Resource-Typed ID Parameters`](../applemusicapi/get-multiple-library-resources-by-resource-typed-ids-parameters.md)

Fetch one or more library resources by using their identifiers.

## See Also

  [`MediaPlayer`](../mediaplayer.md)

  [`StoreKit`](../storekit.md)
