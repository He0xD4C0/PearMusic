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
[`MusicAuthorization`](../musickit/musicauthorization.md).
Check specific capabilities for the current [`MusicSubscription`](../musickit/musicsubscription.md)
to ensure your music-related functionality is available to the user.
Find music items using a search term with
[`MusicCatalogSearchRequest`](../musickit/musiccatalogsearchrequest.md), or find music items using a filter
with [`MusicCatalogResourceRequest`](../musickit/musiccatalogresourcerequest.md).
Play music in your app with one of the two music players that MusicKit offers.
Allow the user to begin a free trial for Apple Music from within your app
by presenting a music subscription offer.

You can load content from an arbitrary Apple Music API endpoint
with [`MusicDataRequest`](../musickit/musicdatarequest.md) to take further advantage of
additional functionality available in Apple Music API.

## Topics

### Essentials

[Using Automatic Developer Token Generation for Apple Music API](../musickit/using-automatic-token-generation-for-apple-music-api.md)

Enable your app’s integration with the MusicKit App Service in
the developer portal.

  [`using_musickit_to_integrate_with_apple_music`](../musickit/using_musickit_to_integrate_with_apple_music.md)

  [`NSAppleMusicUsageDescription`](../bundleresources/information-property-list/nsapplemusicusagedescription.md)

### Music Items

A set of value types represents each kind of music item.

[`Album`](../musickit/album.md)

A music item that represents an album.

[`Artist`](../musickit/artist.md)

A music item that represents an artist.

[`Curator`](../musickit/curator.md)

A music item that represents a curator.

[`Genre`](../musickit/genre.md)

A music item that represents a genre.

[`MusicVideo`](../musickit/musicvideo.md)

A music item that represents a music video.

[`Playlist`](../musickit/playlist.md)

A music item that represents a playlist.

[`RadioShow`](../musickit/radioshow.md)

A music item that represents a radio show.

[`RecordLabel`](../musickit/recordlabel.md)

A music item that represents a record label.

[`Song`](../musickit/song.md)

A music item that represents a song.

[`Station`](../musickit/station.md)

A music item that represents a station.

[`Track`](../musickit/track.md)

A music item that represents a track.

### Music Item Attributes

A set of structured attributes for music items.

[`ContentRating`](../musickit/contentrating.md)

The rating of the content that potentially plays while playing a resource.

[`EditorialNotes`](../musickit/editorialnotes.md)

An object that represents editorial notes.

[`PreviewAsset`](../musickit/previewasset.md)

An object that represents a preview for resources.

### Catalog Search

The catalog search request allows your app to find music items
in the Apple Music catalog.

[`MusicCatalogSearchRequest`](../musickit/musiccatalogsearchrequest.md)

A request that your app uses to fetch items from the Apple Music catalog
using a search term.

[`MusicCatalogSearchResponse`](../musickit/musiccatalogsearchresponse.md)

An object that contains results for a catalog search request.

[`MusicCatalogSearchable`](../musickit/musiccatalogsearchable.md)

A protocol for music items that your app can fetch by
using a catalog search request.

### Resource Loading Using Filters

The catalog resource request allows your app to load items using
a specific filter. Each music item type has its own set of properties
you can use as a filter for a catalog resource request when loading music items
for your app.

[`MusicCatalogResourceRequest`](../musickit/musiccatalogresourcerequest.md)

A request that your app uses to fetch items from the Apple Music catalog
using a filter.

[`MusicCatalogResourceResponse`](../musickit/musiccatalogresourceresponse.md)

An object that contains results for a catalog resource request.

[`AlbumFilter`](../musickit/albumfilter.md)

Album properties your app uses as a filter for a catalog resource request.

[`ArtistFilter`](../musickit/artistfilter.md)

Artist properties your app uses as a filter for a catalog resource request.

[`CuratorFilter`](../musickit/curatorfilter.md)

Curator properties your app uses as a filter for a catalog resource request.

[`GenreFilter`](../musickit/genrefilter.md)

Genre properties your app uses as a filter for a catalog resource request.

[`MusicVideoFilter`](../musickit/musicvideofilter.md)

Music video properties your app uses as a filter
for a catalog resource request.

[`PlaylistFilter`](../musickit/playlistfilter.md)

Playlist properties your app uses as a filter
for a catalog resource request.

[`RadioShowFilter`](../musickit/radioshowfilter.md)

Radio Show properties your app uses as a filter for a catalog resource request.

[`RecordLabelFilter`](../musickit/recordlabelfilter.md)

The set of record label properties your app uses as a filter
for a catalog resource request.

[`SongFilter`](../musickit/songfilter.md)

Song properties your app uses as a filter for a catalog resource request.

[`StationFilter`](../musickit/stationfilter.md)

The set of station properties your app uses as a filter
for a catalog resource request.

[`FilterableMusicItem`](../musickit/filterablemusicitem.md)

A declaration of the associated type that contains the set of music item
properties your app uses as a filter for a catalog resource request.

### General Purpose Data Request

[`MusicDataRequest`](../musickit/musicdatarequest.md)

A request for loading data from an arbitrary Apple Music API endpoint.

[`MusicDataResponse`](../musickit/musicdataresponse.md)

An object containing results for a data request.

### Playback

[`ApplicationMusicPlayer`](../musickit/applicationmusicplayer.md)

An object your app uses to play music in a way that doesn’t affect
the Music app’s state.

[`SystemMusicPlayer`](../musickit/systemmusicplayer.md)

An object your app uses to play music by controlling the Music app’s state.

[`MusicPlayer`](../musickit/musicplayer.md)

An object your app uses to play music.

[`PlayableMusicItem`](../musickit/playablemusicitem.md)

A set of properties that a music player uses to initiate playback
for a music item.

[`PlayParameters`](../musickit/playparameters.md)

An opaque object that represents parameters to initiate playback
of a playable music item using a music player.

### Artwork

[`Artwork`](../musickit/artwork.md)

An object that represents artwork for a music item.

[`ArtworkImage`](../musickit/artworkimage.md)

A view that displays the image for a music item’s artwork.

### Authorization

Before you can use any of the functionality of the framework, you need to
request the user’s informed consent for your app to access their music data.

[`MusicAuthorization`](../musickit/musicauthorization.md)

A type that allows you to request the user’s informed consent
for your app to access their music data.

### Apple Music Subscription

[`MusicSubscription`](../musickit/musicsubscription.md)

A representation of the current state of the user’s subscription
to Apple Music.

[`MusicSubscriptionOffer`](../musickit/musicsubscriptionoffer.md)

A type for grouping other types for showing subscription offers
for Apple Music.

### Token management

The framework manages tokens for accessing Apple Music API automatically
by default, but you can generate your own developer token by creating
a class that inherits from the token provider type alias.

[`MusicTokenProvider`](../musickit/musictokenprovider.md)

An object that music requests use to access Apple Music API.

[`MusicDeveloperTokenProvider`](../musickit/musicdevelopertokenprovider.md)

A set of methods that music requests use to access Apple Music API.

[`MusicUserTokenProvider`](../musickit/musicusertokenprovider.md)

A class that music requests use to fetch user tokens your app requires
to access Apple Music API.

[`MusicTokenRequestOptions`](../musickit/musictokenrequestoptions.md)

Options that music requests pass into token provider methods to fetch
a required token for accessing Apple Music API.

[`MusicTokenRequestError`](../musickit/musictokenrequesterror.md)

An error that the token provider or music requests can throw
upon requesting any token necessary for accessing Apple Music API.

[`DefaultMusicTokenProvider`](../musickit/defaultmusictokenprovider.md)

The default token provider that music requests use to access
Apple Music API.

### Utility

[`MusicItem`](../musickit/musicitem.md)

A protocol with basic requirements for music items.

[`MusicItemID`](../musickit/musicitemid.md)

An object that represents a unique identifier for a music item.

[`MusicItemCollection`](../musickit/musicitemcollection.md)

A collection of music items.

[`MusicPropertyContainer`](../musickit/musicpropertycontainer.md)

A protocol for music items that allow loading additional
properties that you can fetch asynchronously.

[`MusicRelationshipProperty`](../musickit/musicrelationshipproperty.md)

An identifier for a music item relationship property
from a specific root type to a specific value type
for the element of the resulting collection.

[`MusicExtendedAttributeProperty`](../musickit/musicextendedattributeproperty.md)

An identifier for a music item extended attribute property
from a specific root type to a specific resulting value type.

[`MusicAttributeProperty`](../musickit/musicattributeproperty.md)

An identifier for a music item attribute property
from a specific root type to a specific resulting value type.

[`PartialMusicAsyncProperty`](../musickit/partialmusicasyncproperty.md)

A partially type-erased identifier for a music item property
that you can fetch asynchronously from a concrete root type
to any resulting value type.

[`PartialMusicProperty`](../musickit/partialmusicproperty.md)

A partially type-erased identifier for a music item property
from a concrete root type to any resulting value type.

[`AnyMusicProperty`](../musickit/anymusicproperty.md)

A type-erased identifier for a music item property, from any root type
to any resulting value type.

## See Also

  [`MediaPlayer`](../mediaplayer.md)

  [`AppleMusicAPI`](../applemusicapi.md)
