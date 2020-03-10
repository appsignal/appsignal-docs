---
title: "Customizing data collection"
---

By default AppSignal gathers relevant data for errors and performance measurements to help you find the cause of the issue. Sometimes you need more information, app specific data or a custom request header your app uses.

You can configure AppSignal to gather more, or less, information than it does by default by tagging your transactions and configuring the request headers, parameter filtering, etc. Ideally we receive as little metadata for samples as possible, and only data that is needed to debug an exception or performance issue.


## Table of Contents

- [Ignore actions](#ignore-actions)
- [Ignore errors](#ignore-errors)
- [Request headers](#request-headers)
- [Parameters](#parameters)
- [Session data](#session-data)
- [Tagging](#tagging)
- [Namespaces](#namespaces)
- [Queries](#queries)

## Ignore actions

Noisy actions (web endpoints, background jobs, scheduled tasks) sometimes do more harm than good. To filter out these actions it's possible to ignore them in AppSignal by updating the AppSignal configuration in an app.

By configuring the `ignore_actions` option it's possible to not record any data for the configured actions, requests, background jobs, etc.

- [Ruby gem `ignore_actions` config option](/ruby/configuration/ignore-actions.html)
- [Elixir package `ignore_actions` config option](/elixir/configuration/ignore-actions.html)

## Ignore errors

By configuring the `ignore_errors` option it's possible to ignore errors matching the exact name of an error for the entire app.

- [Ruby gem `ignore_errors` config option](/ruby/configuration/ignore-errors.html)
- [Elixir package `ignore_errors` config option](/elixir/configuration/ignore-errors.html)

## Request headers

By default AppSignal does not gather all request headers from a request. We only include non user identifiable request headers. This is so you and AppSignal are [GDPR compliant by default](/appsignal/gdpr.html#allowed-request-headers-only). If you are missing some headers you really need for your app you can customize which request headers are collected in [Ruby](/ruby/configuration/options.html#option-request_headers) and [Elixir](/elixir/configuration/options.html#option-request_headers).

## Parameters

If you use any framework with automatic parameter filtering, AppSignal will use the parameter filtering of the framework to filter the parameters. This can be further customized with our parameter filtering in [Ruby](/ruby/configuration/parameter-filtering.html) and [Elixir](/elixir/configuration/parameter-filtering.html).

## Session data

AppSignal gathers session data for requests by default. This may help you track down errors or performance issues that were caused by some session data your app is using. However, your app's session data may contain sensitive user information which you do not want to the AppSignal servers.

The session data can be filtered by the data's key name with our session data filtering for [Ruby](/ruby/configuration/session-data-filtering.html) and [Elixir](/elixir/configuration/session-data-filtering.html). It's also possible to disable session data collection entirely for [Ruby](/ruby/configuration/session-data-filtering.html#skip-sending-session-data) and [Elixir](/elixir/configuration/session-data-filtering.html#skip-sending-session-data).

## Tagging

Our tagging system allows you to attach more metadata to samples, besides what we already collect. Things such as the ID of the user making the request or other data that can help you identify who made the request or specific conditions for the request.


* [Tagging for Ruby](/ruby/instrumentation/tagging.html)
* [Tagging for Elixir](/elixir/instrumentation/tagging.html)
* [Tagging for front-end JavaScript](/front-end/span.html#span-settags-tags-object)


## Namespaces

Namespaces allow grouping of [actions](/appsignal/terminology.html#actions). By default AppSignal uses the "web", "background" and "frontend" namespaces to group [transactions](/appsignal/terminology.html#transactions). It's possible to create a custom namespace such as "admin", "api" to group controllers in the same namespace.

The grouped actions in the namespace can be configured with their own notification defaults, allowing a critical namespace to always notify about errors, while the "web" namespace does not. It's also possible to configure the AppSignal integration to ignore a namespace to ignore all transactional data from all actions in it.

Read more about namespaces in the [namespaces section](/application/namespaces.html).

## Queries

By default we parse SQL queries and try and remove any parameters in the query string. We've created an open-source (Rust) package that is used by our integrations. You can find [the sql_lexer project on GitHub](https://github.com/appsignal/sql_lexer). If you see any query params in our UI, please open an issue in that repository.

MongoDB queries in the Ruby integration are sanitized by default.
