---
title: Get audit events with filtering
navigation_weight: 3
---

# Get audit events with filtering

In this building block you see how to get a list of audit events with filtering.

## Parameters

You can filter the list of event objects returned by using query parameters. The parameters than can be specified are shown in the following table:

Query Parameter | Description
--- | ---
`event_type` | The type of the audit event, for example: `APP_CREATE`, `NUMBER_ASSIGN`, and so on. You can specify a comma-delimited list of [event types](/audit/guides/audit-events#audit-event-types) here.
`search_text` | JSON compatible search string. Look for specific text in an audit event.
`date_from` | Retrieve audit events from this date (in ISO-8601 format).
`date_to` | Retrieve audit events to this date (in ISO-8601 format).
`admin_email` | Email of a Nexmo admin that triggered an event.
`user_email` | Email of a user that triggered an event.
`account_id` | Nexmo API key.
`only_by_admin` | Nexmo Admin events only. Set to true, false or empty.
`page` | Page number starting with page 1.
`size` | Number of elements per page (between 1 and 100, default 30).

## Example

Replace the following variables in the example code:

Key | Description
-- | --
`NEXMO_API_KEY` | Your Nexmo API key.
`NEXMO_API_SECRET` | Your Nexmo API secret.

```building_blocks
source: '_examples/audit/get-events-with-filtering'
application:
  name: 'Get Events with filtering'
```

## Try it out

Run the command in a shell. The call will retrieve a list of audit events with filtering applied.