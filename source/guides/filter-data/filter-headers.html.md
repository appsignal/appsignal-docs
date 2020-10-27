---
title: "Request header collection"
---

AppSignal collects headers for HTTP requests by default for supported frameworks. This data may help track down errors or performance issues that were caused by requests header data a client is sending.

To comply with [GDPR](/appsignal/gdpr.html) rules, collecting no user identifiable data, AppSignal collects a very limited amount of headers by default.

To even further limit the request headers or collect more than the default list of headers, configure AppSignal which headers to collect.

-> 🔍 Read more about request header filtering and what types of headers to set up filtering for in our [request headers filtering topic](/application/header-filtering.html).

!> ⚠️ Do not send personal data to AppSignal. If request headers contains personal data, please use filtering to avoid sending this data to AppSignal.

## Configure headers

An app's session data can be filtered by configuring keys in an _allowlist_. This allowlist system will filter out all the session data keys not in this list.

All headers that are filtered out by these systems are not collected, neither the header name or value.

### Example

For example, an application with this AppSignal config:

```yaml
request_headers: ["Request-Method"]
```

Will only sent the `Request-Method` header to AppSignal.com, and no other request headers.

## Ruby

In the Ruby integration, AppSignal automatically stores the configured request headers for Rails apps and other frameworks. It has a built-in list of request headers to collect by default, that can be customized with the [`request_headers`][ruby request headers] config option.

- [Default list of request headers][ruby request headers]

To configure which request headers to collect for each request, add the following configuration to your `config/appsignal.yml` file in the environment group you want it to apply. The [`request_headers`][ruby request headers] value is an Array of Strings.

[ruby request headers]: /ruby/configuration/options.html#option-filter_session_data

```yaml
# Example: config/appsignal.yml
production:
  request_headers: # Example list of headers
    - PATH_INFO
    - REQUEST_METHOD
    - REQUEST_URI
    - SERVER_NAME
    - SERVER_PORT
    - SERVER_PROTOCOL
```

## Elixir

In the Elixir integration, AppSignal automatically stores the configured request headers for Phoenix apps and other frameworks. It has a built-in list of request headers to collect by default, that can be customized with the [`request_headers`][elixir request headers] config option.

- [Default list of request headers][elixir request headers]

To configure which request headers to collect for each request, add the following configuration to your `config/appsignal.exs` file in the environment group you want it to apply. The [`request_headers`][elixir request headers] value is a List of Strings.

[elixir request headers]: /elixir/configuration/options.html#option-filter_session_data

```yaml
# Example: config/appsignal.exs
config :appsignal, :config,
  request_headers: ~w(
    path-info request-method request-uri server-name server-port server-protocol
  ) # Example list of headers
```

## Next steps

- [Filtering session data](/guides/filter-data/filter-session-data.html) - the previous step in this guide
- [Filtering app data](/guides/filter-data/) - the start of this guide
- [Getting started guides](/guides/) - Guides overview

[header filtering]: /application/header-filtering.html
[disabled entirely]: /application/header-filtering.html#filter-all-request-headers
