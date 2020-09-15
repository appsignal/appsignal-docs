---
title: Bugsnag Compatibility
---

## Affected components

- AppSignal for Ruby, in combination with Bugsnag 6.12.0 and later

## Description

We've switched to using `Module.prepend` in our net/http integration in version `2.10.5` of our gem. However, that version broke compatibility with other libraries that use the method aliasing approach, like New Relic and Bugsnag. We then reverted that change in `2.10.7`.

Our rake integration uses the method aliasing approach, while Bugsnag uses `Module.prepend` in theirs. When using both approaches in the same method, you'll end up with a stack level too deep error.


## Symptoms

- Running both AppSignal and Bugsnag 6.12.x or later produces SystemStackErrors when running rake tasks

## Workaround

Downgrade the Bugsnag library to `6.11.1`, which doesn't use `Module.prepend` yet, or remove it altogether.
