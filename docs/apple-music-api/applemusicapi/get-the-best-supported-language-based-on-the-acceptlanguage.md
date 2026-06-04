---
title: "Get the best supported language for a storefront"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-the-best-supported-language-based-on-the-acceptLanguage
date: 2026-06-03
---
# Get the best supported language for a storefront

Fetch the best supported language for a storefront from a list.

## Discussion

### Example

**Request:**

```
https://api.music.apple.com/v1/language/us/tag?acceptLanguage=en-US
```

**Response:**

```json
{
    “results”: {
        “tag”: “en-US”
    }
}
```
