---
title: "Relationship"
source: https://developer.apple.com/documentation/AppleMusicAPI/Relationship
date: 2026-06-03
---
# Relationship

A to-one or to-many relationship from one resource object to others.

```
object Relationship
```

## Discussion

A to-one relationship contains a single object in the `data` array.

The rules that apply to the members of this object are:

- Must contain one of these members: `href`, `data`, or `meta`.
- If a to-many relationship, may contain the `next` member.

## Topics

### Related Objects

[`Relationship.Meta`](../applemusicapi/relationship/meta-data.dictionary.md)

Information about the request or response.
