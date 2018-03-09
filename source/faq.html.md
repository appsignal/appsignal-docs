---
title: "Frequently Asked Questions"
---

- AppSignal libraries
  - [What programming languages does AppSignal support?](#what-programming-languages-does-appsignal-support)
  - [Filtering data](#filtering-data)
      - [How to ignore actions from your app?](#how-to-ignore-actions-from-your-app)
      - [How to ignore errors in your app?](#how-to-ignore-errors-in-your-app)
      - [How to filter data that's being send to AppSignal?](#how-to-filter-data-thats-being-send-to-appsignal)
  - [How to add additional instrumentation to my app?](#how-to-add-additional-instrumentation-to-my-app)
  - [How to run multiple applications on one host?](#how-to-run-multiple-applications-on-one-host)
  - [What Operating Systems does AppSignal support?](#what-operating-systems-does-appsignal-support)
  - [How to debug an issue with the AppSignal integration?](#how-to-debug-an-issue-with-the-appsignal-integration)
- User account
  - [How to enable two-factor authentication (2FA) for the AppSignal app?](#how-to-enable-two-factor-authentication-2fa-for-the-appsignal-app)

## AppSignal libraries

### What programming languages does AppSignal support?

AppSignal supports the [Ruby](https://www.ruby-lang.org/en/) and [Elixir](https://elixir-lang.org/) programming languages. We have a [Front-end error catching beta](/front-end/error-handling.html) for JavaScript.

### Filtering data

#### How to ignore actions from your app?

By configuring the `ignore_actions` option for the [Ruby gem](/ruby/configuration/ignore-actions.html) and [Elixir package](/elixir/configuration/ignore-actions.html) it's possible to not record any data for the configured actions, requests, background jobs, etc.

#### How to ignore errors in your app?

By configuring the `ignore_actions` option for the [Ruby gem](/ruby/configuration/ignore-errors.html) and [Elixir package](/elixir/configuration/ignore-errors.html) you can ignore errors matching the exact name of an error.

#### How to filter data that's being send to AppSignal?

- Filter parameters and background job arguments for the [Ruby gem](/ruby/configuration/ignore-errors.html) and [Elixir package](/elixir/configuration/ignore-errors.html).
- Skip sending session data from requests for the [Ruby gem](/ruby/configuration/options.html#appsignal_skip_session_data-skip_session_data) and [Elixir package](/elixir/configuration/options.html#appsignal_skip_session_data-skip_session_data).

### How to add additional instrumentation to my app?

Add additional instrumentation to your app to gain more insights in how your application is performing by measuring the duration of separate events. Read how in the documentation for our [Ruby gem](/ruby/instrumentation/instrumentation.html) and [Elixir package](/elixir/instrumentation/instrumentation.html).

### How to run multiple applications on one host?

By default AppSignal is configured to assume one application runs on one host. If you run more than one application on a host, some odd behavior may occur, such as data being reported for a different app.

To configure AppSignal for multiple applications on one host the AppSignal working directory needs to be configured. Read more about how to configure the working directory on our [applications documentation page](https://docs.appsignal.com/application/#running-multiple-applications-on-one-host).

### What Operating Systems does AppSignal support?

Please see our [Operating Systems](/support/operating-systems.html) page for the full list of support Operating Systems and what packages it requires.

### How to debug an issue with the AppSignal integration?

Please see our [debugging guide](/support/debugging.html) for a complete guide to debug issues with the AppSignal integration.

Also check our [known issues](/support/known-issues.html) page for issues that may be present in your version of the AppSignal integration.

## User account

### How to enable two-factor authentication (2FA) for the AppSignal app?

Please see our [two-factor authentication](/user-account/two-factor-authentication.html) page for more information.
