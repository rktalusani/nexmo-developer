---
title: Overview
navigation_weight: 1
description: The Audit API overview.
---

# Audit API Overview

The Nexmo Audit API allows you to track events. These events are activities created by using the API or 
by interacting with the Nexmo Dashboard. The Audit API allows you to monitor your Nexmo account.

## Contents

In this document you can learn about:

* [Concepts](#concepts)
* [**How to Get Started with the Audit API**](#getting-started)
* [Guides](#guides)
* [Building Blocks](#building-blocks)
* [Tutorials](#tutorials)
* [Reference](#reference)

## Concepts

* **Authentication** - interactions with the Audit API are authenticated using Basic Authentication. Basic Authentication allows you to use your `NEXMO_API_KEY` and `NEXMO_API_SECRET` to validate your API requests.

For more information see [authenticating your applications](/concepts/guides/authentication).

* **Audit Event** - Audit Events are activities that occur when a user interacts with the Nexmo API or the Nexmo Dashboard. Audit events are represented by a JSON object. Examples of audit events include user login, logout, and application created. Further information on types of audit events is given in the [Audit Event Guide](/audit/guides/audit-events).

An example event object is 'updating a number' which has `event_type` of `NUMBER_UPDATED`:

``` json
{
  "country":"GB",
  "msisdn":"447700900000",
  "voice-type":"app",
  "voice-value":"aaaaaaaa-bbbb-cccc-dddd-0123456789ab"
}
```

## Getting Started

### Using the API

The [Audit API](/api/audit). With this API you can:

* Retrieve a list of Audit events.
* Retrieve a specific Audit event.

This example shows you how to get started with the Audit API:

```building_blocks
source: '_examples/audit/get-audit-events'
application:
  name: 'Get Audit Events'
```

## Guides

* [Audit events](guides/audit-events): Audit events.

## Building Blocks

* [Get Audit events](/audit/building-blocks/get-audit-events)
* [Get Audit event](/audit/building-blocks/get-audit-event)

## Tutorials

* [Tutorials](/audit/tutorials)

## Reference

* [Audit API Reference](/api/audit)
