---
title: "Using Automatic Developer Token Generation for Apple Music API"
source: https://developer.apple.com/documentation/MusicKit/Using-Automatic-Token-Generation-for-Apple-Music-API
date: 2026-06-03
---
# Using Automatic Developer Token Generation for Apple Music API

Enable your app’s integration with the MusicKit App Service in
the developer portal.

## Overview

MusicKit accelerates the way you integrate your app with Apple Music API
by automatically generating the developer token on behalf of your app.
It then includes the developer token in requests that it issues to
Apple Music API for your app.

To benefit from this automatic behavior, just enable the MusicKit App Service
in the developer portal for your app. The MusicKit App Service is a runtime
service that automatically associates with your app’s bundle identifier.

### Enable the MusicKit App Service

1. In Safari, visit the [Certificates, Identifiers, and Profiles](https://developer.apple.com/account/resources)
   section of the developer web site.
1. In the Identifiers subsection, open the App ID for your app
   and begin editing its configuration, or create a new one.
1. On the Register an App ID page, select the Explicit option
   for the bundle ID of your app.
1. Click or tap the App Services tab, and select the Enabled checkbox for MusicKit.
   ![Enable MusicKit App Service](Enable-MusicKit-App-Service)
1. Complete the App ID creation process, or save the changes.

Be sure to set the bundle identifier of your app target to the same
value you use for your App ID in these steps.
