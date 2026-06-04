---
title: "Get the user's replay data"
source: https://developer.apple.com/documentation/AppleMusicAPI/Get-the-user's-replay-data
date: 2026-06-03
---
# Get the user's replay data

Fetch the user’s replay data for the latest eligible year.

## Discussion

A successful HTTP request returns music summaries for the most recent year that the user has enough listening history. If unsuccessful, the HTTP status code indicates the error, and the details are in the `errors` array. For more information, see [Handling Requests and Responses](../applemusicapi/handling-requests-and-responses.md).
