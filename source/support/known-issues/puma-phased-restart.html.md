---
title: Puma phased restarts
---

## Affected components

- AppSignal for Ruby gem version `v2.9.17` and later (see [workarounds](#workaround)).

## Description

We've added a new plugin to add our [Puma magic dashboard](https://docs.appsignal.com/ruby/integrations/puma.html#minutely-probe) in version `2.9.17` of our gem, which broke phased restarts.

See issue [#575](https://github.com/appsignal/appsignal-ruby/issues/575) on the appsignal-ruby repo for more details on the specific error.

## Symptoms

The AppSignal integration stops, but is not restarted when using Puma phased restarts.

## Workaround

- Downgrade the AppSignal gem to `2.9.16` until the issue has been resolved.
- Do not use Puma's phased restart feature until the issue has been resolved.
