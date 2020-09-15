---
title: Compatibility issue with other instrumentation gems
---

## Affected components

- AppSignal for Ruby, all versions, in combination with:
  - http_logger gem 0.6.0 and later
  - Bugsnag gem 6.12.0 and later
  - Datadog gem

## Description

We've switched to using `Module.prepend` in our net/http integration in version `2.10.5` of our gem. However, that version broke compatibility with other libraries that use the method aliasing approach, like New Relic and Bugsnag. We then reverted that change in `2.10.7`.

Our rake integration uses the method aliasing approach, while Bugsnag uses `Module.prepend` in theirs. When using both approaches in the same method, you'll end up with a stack level too deep error.


## Symptoms

Running both AppSignal and Bugsnag 6.12.x or later produces SystemStackErrors when running rake tasks.

## Workaround

- Downgrade the Bugsnag library to `6.11.1`.
- Downgrade other gems that introduce the same problem in newer versions.
- Remove either of the gems until the issue has been resolved.
