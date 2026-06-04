---
title: "Managing Content Ratings, Alternate Versions, and Equivalencies"
source: https://developer.apple.com/documentation/AppleMusicAPI/managing-content-ratings-alternate-versions-and-equivalencies
date: 2026-06-03
---
# Managing Content Ratings, Alternate Versions, and Equivalencies

Handle multiple and alternate versions of content.

## Discussion

The Music API can fetch multiple, alternate versions of albums, songs, and music videos that are available simultaneously on a specific Storefront. For example, these alternates may represent deluxe, remastered, and reissued versions, as well as separate options for tracks with a clean or explicit rating.

### Content Ratings

In the Music Catalog, some albums, songs, and music videos may have a content rating. The Recording Industry Association of America (RIAA) provides ‘explicit’ ratings. The ‘clean’ value demarcates tracks that have an ‘explicit’-rated equivalent. Apple Music API can attempt to find clean substitutions for explicit content in some contexts, such as an artist’s releases and tracks on a playlist. See below about substituting clean content with equivalents when available.

### Fetch Equivalent Content for a Storefront

Use equivalencies to find the best-available equivalent match for the requested content from a given storefront. A response from a filter equivalencies endpoint returns the best match of an album, song, or music video for the specified storefront.

Albums and tracks are sometimes made available as different versions between storefronts. Use equivalencies to find the best-available version in one storefront for an identifier found in another storefront. For instance, an album could have different identifiers between two separate storefronts. These identifiers represent different versions of the same album. For example, you can filter on equivalents by using an album’s identifier in the US (`us`) storefront to find its equivalent in the Japan (`jp`) storefront.

```other
GET https://api.music.apple.com/v1/catalog/jp/albums?filter[equivalents]=1500951604
```

### Substitute Content with Clean Equivalents When Available

Based on a user’s preference, you may want to only include clean versions of content. In addition to the above equivalencies for albums, songs, and music videos, you can also apply this parameter to the tracks of playlists, as well as artist views. To achieve this, specify a `restrict` parameter in your request that attempts to submit a clean substitution when available.

```other
GET https://api.music.apple.com/v1/catalog/us/albums?filter[equivalents]=1540031620&restrict=explicit
```

> Note:
> When using the explicit restriction, this parameter replaces content with an explicit rating with the best available clean equivalent version. If no suitable replacement is available, the original content is not replaced.
