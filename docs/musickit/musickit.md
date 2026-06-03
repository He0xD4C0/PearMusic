---
title: "MusicKit"
source: https://developer.apple.com/documentation/MusicKit
date: 2026-06-03
---
# MusicKit

Integrate your app with Apple Music.

## Overview

Use MusicKit to integrate your app with
[Apple Music API](doc://com.apple.documentation/documentation/AppleMusicAPI),
a web service you use to access information about music items in the
Apple Music catalog. Using MusicKit, you can more easily build apps that tie
into Apple Music.

The framework provides a model layer for accessing music items in Swift,
as well as playback support so you can add music to your app.
Additionally, it provides some related user interface elements,
such as a view to display images that correspond to artwork for a music item,
or a way to present music subscription offers to users who may not have
an active Apple Music subscription.

> Important: Users must grant permission for your app to access
> their music data. Add the
> [NSAppleMusicUsageDescription](doc://com.apple.documentation/documentation/BundleResources/Information-Property-List/NSAppleMusicUsageDescription)
> key to your app’s `Info.plist` file, and include a description of how you
> intend to use the user’s media. If this key isn’t present, the system
> terminates your app when it tries to access the user’s music.

Request permission for your app to use MusicKit with
[`MusicAuthorization`](/documentation/MusicKit/MusicAuthorization).
Check specific capabilities for the current [`MusicSubscription`](/documentation/MusicKit/MusicSubscription)
to ensure your music-related functionality is available to the user.
Find music items using a search term with
[`MusicCatalogSearchRequest`](/documentation/MusicKit/MusicCatalogSearchRequest), or find music items using a filter
with [`MusicCatalogResourceRequest`](/documentation/MusicKit/MusicCatalogResourceRequest).
Play music in your app with one of the two music players that MusicKit offers.
Allow the user to begin a free trial for Apple Music from within your app
by presenting a music subscription offer.

You can load content from an arbitrary Apple Music API endpoint
with [`MusicDataRequest`](/documentation/MusicKit/MusicDataRequest) to take further advantage of
additional functionality available in Apple Music API.

## Topics

### Essentials

[Using Automatic Developer Token Generation for Apple Music API](/documentation/MusicKit/Using-Automatic-Token-Generation-for-Apple-Music-API)

Enable your app’s integration with the MusicKit App Service in
the developer portal.

  [`using_musickit_to_integrate_with_apple_music`](/musickit/using_musickit_to_integrate_with_apple_music.md)

  [`NSAppleMusicUsageDescription`](/bundleresources/information-property-list/nsapplemusicusagedescription.md)

### Music Items

A set of value types represents each kind of music item.

[`Album`](/documentation/MusicKit/Album)

A music item that represents an album.

[`Artist`](/documentation/MusicKit/Artist)

A music item that represents an artist.

[`Curator`](/documentation/MusicKit/Curator)

A music item that represents a curator.

[`Genre`](/documentation/MusicKit/Genre)

A music item that represents a genre.

[`MusicVideo`](/documentation/MusicKit/MusicVideo)

A music item that represents a music video.

[`Playlist`](/documentation/MusicKit/Playlist)

A music item that represents a playlist.

[`RadioShow`](/documentation/MusicKit/RadioShow)

A music item that represents a radio show.

[`RecordLabel`](/documentation/MusicKit/RecordLabel)

A music item that represents a record label.

[`Song`](/documentation/MusicKit/Song)

A music item that represents a song.

[`Station`](/documentation/MusicKit/Station)

A music item that represents a station.

[`Track`](/documentation/MusicKit/Track)

A music item that represents a track.

### Music Item Attributes

A set of structured attributes for music items.

[`ContentRating`](/documentation/MusicKit/ContentRating)

The rating of the content that potentially plays while playing a resource.

[`EditorialNotes`](/documentation/MusicKit/EditorialNotes)

An object that represents editorial notes.

[`PreviewAsset`](/documentation/MusicKit/PreviewAsset)

An object that represents a preview for resources.

### Catalog Search

The catalog search request allows your app to find music items
in the Apple Music catalog.

[`MusicCatalogSearchRequest`](/documentation/MusicKit/MusicCatalogSearchRequest)

A request that your app uses to fetch items from the Apple Music catalog
using a search term.

[`MusicCatalogSearchResponse`](/documentation/MusicKit/MusicCatalogSearchResponse)

An object that contains results for a catalog search request.

[`MusicCatalogSearchable`](/documentation/MusicKit/MusicCatalogSearchable)

A protocol for music items that your app can fetch by
using a catalog search request.

### Resource Loading Using Filters

The catalog resource request allows your app to load items using
a specific filter. Each music item type has its own set of properties
you can use as a filter for a catalog resource request when loading music items
for your app.

[`MusicCatalogResourceRequest`](/documentation/MusicKit/MusicCatalogResourceRequest)

A request that your app uses to fetch items from the Apple Music catalog
using a filter.

[`MusicCatalogResourceResponse`](/documentation/MusicKit/MusicCatalogResourceResponse)

An object that contains results for a catalog resource request.

[`AlbumFilter`](/documentation/MusicKit/AlbumFilter)

Album properties your app uses as a filter for a catalog resource request.

[`ArtistFilter`](/documentation/MusicKit/ArtistFilter)

Artist properties your app uses as a filter for a catalog resource request.

[`CuratorFilter`](/documentation/MusicKit/CuratorFilter)

Curator properties your app uses as a filter for a catalog resource request.

[`GenreFilter`](/documentation/MusicKit/GenreFilter)

Genre properties your app uses as a filter for a catalog resource request.

[`MusicVideoFilter`](/documentation/MusicKit/MusicVideoFilter)

Music video properties your app uses as a filter
for a catalog resource request.

[`PlaylistFilter`](/documentation/MusicKit/PlaylistFilter)

Playlist properties your app uses as a filter
for a catalog resource request.

[`RadioShowFilter`](/documentation/MusicKit/RadioShowFilter)

Radio Show properties your app uses as a filter for a catalog resource request.

[`RecordLabelFilter`](/documentation/MusicKit/RecordLabelFilter)

The set of record label properties your app uses as a filter
for a catalog resource request.

[`SongFilter`](/documentation/MusicKit/SongFilter)

Song properties your app uses as a filter for a catalog resource request.

[`StationFilter`](/documentation/MusicKit/StationFilter)

The set of station properties your app uses as a filter
for a catalog resource request.

[`FilterableMusicItem`](/documentation/MusicKit/FilterableMusicItem)

A declaration of the associated type that contains the set of music item
properties your app uses as a filter for a catalog resource request.

### General Purpose Data Request

[`MusicDataRequest`](/documentation/MusicKit/MusicDataRequest)

A request for loading data from an arbitrary Apple Music API endpoint.

[`MusicDataResponse`](/documentation/MusicKit/MusicDataResponse)

An object containing results for a data request.

### Playback

[`ApplicationMusicPlayer`](/documentation/MusicKit/ApplicationMusicPlayer)

An object your app uses to play music in a way that doesn’t affect
the Music app’s state.

[`SystemMusicPlayer`](/documentation/MusicKit/SystemMusicPlayer)

An object your app uses to play music by controlling the Music app’s state.

[`MusicPlayer`](/documentation/MusicKit/MusicPlayer)

An object your app uses to play music.

[`PlayableMusicItem`](/documentation/MusicKit/PlayableMusicItem)

A set of properties that a music player uses to initiate playback
for a music item.

[`PlayParameters`](/documentation/MusicKit/PlayParameters)

An opaque object that represents parameters to initiate playback
of a playable music item using a music player.

### Artwork

[`Artwork`](/documentation/MusicKit/Artwork)

An object that represents artwork for a music item.

[`ArtworkImage`](/documentation/MusicKit/ArtworkImage)

A view that displays the image for a music item’s artwork.

### Authorization

Before you can use any of the functionality of the framework, you need to
request the user’s informed consent for your app to access their music data.

[`MusicAuthorization`](/documentation/MusicKit/MusicAuthorization)

A type that allows you to request the user’s informed consent
for your app to access their music data.

### Apple Music Subscription

[`MusicSubscription`](/documentation/MusicKit/MusicSubscription)

A representation of the current state of the user’s subscription
to Apple Music.

[`MusicSubscriptionOffer`](/documentation/MusicKit/MusicSubscriptionOffer)

A type for grouping other types for showing subscription offers
for Apple Music.

### Token management

The framework manages tokens for accessing Apple Music API automatically
by default, but you can generate your own developer token by creating
a class that inherits from the token provider type alias.

[`MusicTokenProvider`](/documentation/MusicKit/MusicTokenProvider)

An object that music requests use to access Apple Music API.

[`MusicDeveloperTokenProvider`](/documentation/MusicKit/MusicDeveloperTokenProvider)

A set of methods that music requests use to access Apple Music API.

[`MusicUserTokenProvider`](/documentation/MusicKit/MusicUserTokenProvider)

A class that music requests use to fetch user tokens your app requires
to access Apple Music API.

[`MusicTokenRequestOptions`](/documentation/MusicKit/MusicTokenRequestOptions)

Options that music requests pass into token provider methods to fetch
a required token for accessing Apple Music API.

[`MusicTokenRequestError`](/documentation/MusicKit/MusicTokenRequestError)

An error that the token provider or music requests can throw
upon requesting any token necessary for accessing Apple Music API.

[`DefaultMusicTokenProvider`](/documentation/MusicKit/DefaultMusicTokenProvider)

The default token provider that music requests use to access
Apple Music API.

### Utility

[`MusicItem`](/documentation/MusicKit/MusicItem)

A protocol with basic requirements for music items.

[`MusicItemID`](/documentation/MusicKit/MusicItemID)

An object that represents a unique identifier for a music item.

[`MusicItemCollection`](/documentation/MusicKit/MusicItemCollection)

A collection of music items.

[`MusicPropertyContainer`](/documentation/MusicKit/MusicPropertyContainer)

A protocol for music items that allow loading additional
properties that you can fetch asynchronously.

[`MusicRelationshipProperty`](/documentation/MusicKit/MusicRelationshipProperty)

An identifier for a music item relationship property
from a specific root type to a specific value type
for the element of the resulting collection.

[`MusicExtendedAttributeProperty`](/documentation/MusicKit/MusicExtendedAttributeProperty)

An identifier for a music item extended attribute property
from a specific root type to a specific resulting value type.

[`MusicAttributeProperty`](/documentation/MusicKit/MusicAttributeProperty)

An identifier for a music item attribute property
from a specific root type to a specific resulting value type.

[`PartialMusicAsyncProperty`](/documentation/MusicKit/PartialMusicAsyncProperty)

A partially type-erased identifier for a music item property
that you can fetch asynchronously from a concrete root type
to any resulting value type.

[`PartialMusicProperty`](/documentation/MusicKit/PartialMusicProperty)

A partially type-erased identifier for a music item property
from a concrete root type to any resulting value type.

[`AnyMusicProperty`](/documentation/MusicKit/AnyMusicProperty)

A type-erased identifier for a music item property, from any root type
to any resulting value type.

## See Also

  [`MediaPlayer`](/mediaplayer.md)

  [`AppleMusicAPI`](/applemusicapi.md)
