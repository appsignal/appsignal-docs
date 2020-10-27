---
title: "Request header collection"
---

AppSignal collects headers for HTTP requests by default for supported frameworks. This data may help track down errors or performance issues that were caused by requests header data a client is sending.

To comply with [GDPR](/appsignal/gdpr.html) rules, collecting no user identifiable data, AppSignal collects a very limited amount of headers by default.

To even further limit the request headers or collect more than the default list of headers, configure AppSignal which headers to collect.

!> ⚠️ Do not send personal data to AppSignal. If request headers contains personal data, please use filtering to avoid sending this data to AppSignal.

## Configure headers

An app's session data can be filtered by configuring keys in an _allowlist_. This allowlist system will filter out all the session data keys not in this list.

All headers that are filtered out by these systems are not collected, neither the header name or value.

-> 📖 Read our guide about [setting up request header collection and filtering](/guides/filter-data/filter-headers.html) for your app.

## Filter all request headers

To filter all request headers without individual header filtering, configure the allowlist to an empty list in the integration configuration. Without any header names in the list, it will not collect any request headers.

- [Ruby `request_headers` config option documentation](/ruby/configuration/options.html#option-request_headers)
- [Elixir `request_headers` config option documentation](/elixir/configuration/options.html#option-request_headers)

## Recommended headers to filter

A non-exhaustive list of request header names that may be used by an application. Do not include these headers, and those like it, in the integrations "request headers" allowlist unless absolutely necessary.

- Any personal identifiable headers:
    - IP Addresses
        - `Forwarded`
    - Browser type and versions headers
        - `User-Agent`
      - Referrer
        - `Referer`
    - Passwords and tokens
        - `Authorization`
        - `Proxy-Authorization`
        - Any custom API token headers.

## See also

- [Data filtering guide](/guides/filter-data.html) - Filter app data in AppSignal integrations
