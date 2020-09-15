---
title: Compatibility issue with other instrumentation gems
---

## Affected components

- AppSignal for Ruby, all versions, in combination with:
  - http_logger gem 0.6.0 and later
  - Bugsnag gem 6.12.0 and later
  - Datadog gem

## Description

Upon executing a rake task or performing a Net::HTTP request the app will raise a "stack level too deep (SystemStackError)" error. There may also be other scenarios this "SystemStackError" occurs, as it can potentially occur with every type of instrumentation set up by the AppSignal gem and other gems.

This error caused by the AppSignal gem and other gems with instrumentation having different methods of instrumentation that are incompatible. These different methods cause aliased methods, set up by instrumentation gems, to be continuously called until Ruby's stack has been exhausted.

We're looking into solutions for this issue in [appsignal-ruby issue #603](https://github.com/appsignal/appsignal-ruby/issues/603). This issue also contains more information about the cause of the issue and potential solutions. Please report issues with other gems if encountered in this issue.

## Workaround

- Downgrade the Bugsnag library to `6.11.1`.
- Downgrade other gems that introduce the same problem in newer versions.
- Remove either of the gems until the issue has been resolved.
