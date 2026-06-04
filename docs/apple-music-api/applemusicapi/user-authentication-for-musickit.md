---
title: "User Authentication for MusicKit"
source: https://developer.apple.com/documentation/AppleMusicAPI/user-authentication-for-musickit
date: 2026-06-03
---
# User Authentication for MusicKit

Authenticate requests for user data using the Music User Token.

## Discussion

Apple Music API requires the inclusion of a Music User Token for any requests for data specific to an Apple Music subscriber, such as to fetch content from the user’s library. The way to configure your requests to Apple Music API with a valid Music User Token depends on the platform for your app.

### Automatic Music User Token Management

MusicKit automatically manages Music User Token for Apple platforms and for web apps. If you’re developing an app for Apple platforms (iOS, tvOS, watchOS, or macOS), use [`MusicKit`](../musickit.md) for Swift to integrate with Apple Music. The framework automatically decorates requests to Apple Music API with a valid Music User Token.

Similarly, if you’re developing a web app, [MusicKit on the Web](https://developer.apple.com/musickit/web/?path=/story/user-authorization--page) automatically decorates requests to Apple Music API with a valid Music User Token.

### Manual Music User Token Management for Android

Automatic Music User Token management is not available for Android. If you’re developing an app for Android, please refer to the authentication section of the [MusicKit for Android](https://developer.apple.com/musickit/android/)’s documentation to learn more about how to retrieve a Music User Token.

Once you’ve successfully retrieved a Music User Token, make sure to include it in your HTTP requests to Apple Music API with the `Music-User-Token` header.

Below is an example of issuing a personalized request to Apple Music API using `curl.`

```swift
curl -v -H 'Authorization: Bearer [developer token]' -H 'Music-User-Token: [music user token]' "https://api.music.apple.com/v1/me/library/songs"
```

For more information about requests, responses, and error handling, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).
