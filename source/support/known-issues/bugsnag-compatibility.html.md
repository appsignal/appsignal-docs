---
title: Bugsnag Compatibility
---

## Affected components

- AppSignal for Ruby gem versions: `v2.9.17` - `v2.11.0` (see [workarounds](#workaround))

## Description

We've switched to using `Module.prepend` in our net/http integration in version `2.10.5` of our gem. However, that version broke compatibility with other libraries that use the method aliasing approach, like New Relic and Bugsnag. We then reverted that change in `2.10.7`.

Our rake integration uses the method aliasing approach, while Bugsnag uses `Module.prepend` in theirs. When using both approaches in the same method, you'll end up with a stack level too deep error.


## Symptoms

- It produces system stack errors when running rake tasks

## Workaround

Downgrade the Bugsnag to `6.11.x`, which doesn't use `Module.prepend` yet, or removing it altogether.
