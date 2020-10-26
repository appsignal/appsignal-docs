---
title: "Session data filtering"
---

AppSignal gathers session data for HTTP requests by default for supported frameworks. This data may help track down errors or performance issues that were caused by some session data an app is using. Some of this session data may contain sensitive user information though which should not be sent to the AppSignal servers.

Use session data filtering to [filter out specific keys](#filter-session-data) or [disable the feature entirely](#filter-all-session data).

!> ⚠️ Do not send personal data to AppSignal. If session data contains personal data, please use filtering to avoid sending this data to AppSignal.

## Filter session data

An app's session data can be filtered by configuring keys in a _denylist_. This denylist system will filter out all the session data keys configured in this list.

Any session data values that are filtered out by these systems will be replaced with a `[FILTERED]` value. This way the list of session data in the app data on AppSignal.com still includes the session data key, but not the value. Making it easier to see that a value was present, but the potentially sensitive data was filtered out.

-> 📖 Read our guide about [setting up session data filtering](/guides/filter-data/filter-session-data.html) for your app.

## Filter all session data

To filter all session data without individual key filtering, set "skip session data" config option to "true" in the integration configuration.

- [Ruby `skip_session_data` config option documentation](/ruby/configuration/options.html#option-skip_session_data)
- [Elixir `skip_session_data` config option documentation](/elixir/configuration/options.html#option-skip_session_data)

## Recommended keys to filter

A non-exhaustive list of session data keys that may be used by an application. Pick those keys that are relevant for your applications.

- Email addresses
  - `email`
  - `email_address`
- Tokens
  - `token`
  - `api_token`
  - `sign_up_token`
  - `reset_password_token`

## See also

- [Data filtering guide](/guides/filter-data.html) - Filter app data in AppSignal integrations
