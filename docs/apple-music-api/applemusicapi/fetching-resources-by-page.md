---
title: "Fetching Resources by Page"
source: https://developer.apple.com/documentation/AppleMusicAPI/fetching-resources-by-page
date: 2026-06-03
---
# Fetching Resources by Page

Use pagination to fetch the next set of objects.

## Discussion

Some `GET` requests support pagination of the objects or an object’s relationships and relationship views. Specify a `limit` parameter to restrict the number of resources returned. If you don’t supply a limit, the API supplies a default one. If you reach the limit to the number of resource objects in a response, the response contains a subset of the resource objects matching your criteria. In this case you must make more requests to get the rest of the objects.

See the corresponding resource’s object model for the default fetch limit. If there are more resource objects than permitted by the fetch limit, the response contains a `next` member whose value is a subpath to use in the next request. The subpath contains the `offset` parameter that specifies the next page. Similarly, a `Relationship` object may contain a `next` member that you can use to fetch more objects in a relationship.

For example, you may fetch all objects of a resource type, but specify the amount in the response by using the limit parameter.

```other
GET https://api.music.apple.com/v1/storefronts?limit=2
```

If there are more objects to fetch, the response contains a `next` member.

```other
{
   "data":[
      {
          "attributes":{
             "defaultLanguageTag":"en-gb",
             "name":"Anguilla",
             "supportedLanguageTags":[
             "en-gb"
             ]
          },
          "href":"/v1/storefronts/ai",
          "id":"ai",
          "type":"storefronts"
      },
      {
          "attributes":{
             "defaultLanguageTag":"en-gb",
             "name":"Antigua and Barbuda",
             "supportedLanguageTags":[
             "en-gb"
             ]
          },
          "href":"/v1/storefronts/ag",
          "id":"ag",
          "type":"storefronts"
      }
   ],
   "next":"/v1/storefronts?offset=2"
}
```

Pass the `next` subpath, and optionally, use the `limit` parameter again, in the next request.

```other
GET https://api.music.apple.com/v1/storefronts?offset=2&limit=2
```

Continue requesting the resource objects until the `next` member no longer appears in the response.
