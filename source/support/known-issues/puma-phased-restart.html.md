---
title: Puma phased restart
---

## Affected components

- AppSignal for Ruby gem versions: `v2.9.17` (see [workarounds](#workaround)).

## Description

We've added a new plugin to add our [Puma magic dashboard](https://docs.appsignal.com/ruby/integrations/puma.html#minutely-probe) in version `2.9.17` of our gem, which broke phased restarts.


## Symptoms

- Puma phased restart are broken.

## Workaround

Locking to `2.9.16` should fix that issue for now.
