---
title: "Storefronts and Localization"
source: https://developer.apple.com/documentation/AppleMusicAPI/storefronts-and-localization
date: 2026-06-03
---
# Storefronts and Localization

Pick a region-specific geographic location from which to retrieve catalog information, or retrieve information from the user’s personal library.

## Discussion

Apple Music is a worldwide service that operates in many countries, regions, and languages. Content varies from one geographic region to another, so each request must contain a *storefront object*. Storefront defines the desired region and the supported languages for that region. For most requests, you specify the storefront associated with the current user, but you may also specify other storefronts as needed. For example, you might specify a storefront that better matches the user’s preferred language.

Each storefront has a default language, and may support one or more additional languages. For example, the United States storefront includes American English as the default language, but also includes Mexican Spanish as an additional supported language. Apple Music automatically localizes responses using the storefront’s default language, but you can localize to a different language using the `l query` parameter. The value of that parameter must be one of the values in the `supportedLanguageTags` attribute of the storefront object. For example, the following request asks the US storefront to return an album in the Mexican Spanish (`es-MX`) localization.

```other
GET https://api.music.apple.com/v1/catalog/us/albums/310730204?l=es-MX
```

## Topics

### Requesting a Catalog Storefront

[`Get a Storefront`](../applemusicapi/get-a-storefront.md)

Fetch a single storefront by using its identifier.

[`Get Multiple Storefronts`](../applemusicapi/get-multiple-storefronts.md)

Fetch one or more storefronts by using their identifiers.

[`Get All Storefronts`](../applemusicapi/get-all-storefronts.md)

Fetch all the storefronts in alphabetical order.

### Localization

[`Get the best supported language for a storefront`](../applemusicapi/get-the-best-supported-language-based-on-the-acceptlanguage.md)

Fetch the best supported language for a storefront from a list.

### Handling the Response

[`Storefronts`](../applemusicapi/storefronts.md)

A resource object that represents a storefront, an Apple Music and iTunes Store territory that the content is available in.
