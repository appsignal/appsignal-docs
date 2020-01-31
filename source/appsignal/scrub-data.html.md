---
title: "Scrub data"
---

The best way to prevent any data from leaking from your application is to not expose it in the first place, these are the things you can do to keep your data safe.
Find out what we do to keep your data safe on the [security page](/appsignal/security).

Ideally we receive as little metadata for samples as possible, and only data that is needed to debug an exception or performance issue.

To help you with this, we built several systems into the Ruby gem and Elixir packages that allow you to scrub any data you don't want to send over the wire, such as passwords, credit card information and identifiable user information.


## Parameters

The AppSignal integration for each language tries to attach parameter data to samples, these help you debug exceptions or performance issues that are depentent on certain parameters. We recommend to only send parameters that do not contain any identifyable data such as usernames/passwords. To help you with this, we have the following guides:

* [Parameter filtering for Ruby](/ruby/configuration/parameter-filtering.html)
* [Parameter filtering for Elixir](/elixir/configuration/parameter-filtering.html)


## Session data

As with parameters it's possible to filter out session data that might contain sensitive information such as user logins.

* [Session data filtering for Ruby](/ruby/configuration/session-data-filtering.html)
* [Session data filtering for Elixir](/elixir/configuration/session-data-filtering.html)

## Headers

By default AppSignal uses a whitelist for request headers. This list excludes headers that may contain IP addresses and other sensitive information. You can override this default whitelist in the AppSignal configuration. See the pages below for more information.

* [Whitelist request headers for Ruby](/ruby/configuration/options.html#option-request_headers)
* [Whitelist request headers for Elixir](/elixir/configuration/options.html#option-request_headers)

## Tagging

Our tagging system allows you to attach more metadata to samples, besides what we already collect. Things such as the ID of the user making the request or other data that can help you identify who made the request or specific conditions for the request.


* [Tagging for Ruby](/ruby/instrumentation/tagging.html)
* [Tagging for Elixir](/elixir/instrumentation/tagging.html)
* [Tagging for front-end Javascript](/front-end/span.html#span-settags-tags-object)


## (SQL)Queries

By default we parse SQL queries and try and remove any parameters in the query string. We've created an open-source (Rust) package that is used by our integrations. You can find it on [GitHub](https://github.com/appsignal/sql_lexer). If you see any query params in our UI, please open an isse on this repository.

MongoDB queries in the Ruby integration are sanitized by default.
