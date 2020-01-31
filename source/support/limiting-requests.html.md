---
title: "Limiting requests"
---

Our pricing is based on the request count your application processes. This includes web requests and background jobs. We feel it's the most fair way of determining how much value your application generates.

However, not all requests are equal. For example load balancer health checks that occur every 10 seconds provide no value, but are needed to keep your app up-and-running.

We have created a number of (config) options to reduce(ignore) the request count for these kinds of requests.

!> **Warning**: Exceptions that occur in ignored actions/namespaces **will not** be sent to AppSignal.

Custom metrics **will** be sent if they ere emitted in an ignored action/namespace.

Be careful when deciding on what to ignore. Ignoring the `admin` namespace might sound like a good idea, but could backfire when half your team can't work because of an error you didn't know is happening.


## Ignore actions

The most specific option is to ignore a certain action (e.g. `HealtheckController#show`), we recommend to only ignore actions that provide little value or are mostly static, such as:

* Healtchecks
* Product tour pages or other static pages


More documentation about ignoring actions:

* [Ignore actions for Ruby](/ruby/configuration/ignore-actions.html)
* [Ignore actions for Elixir](/elixir/configuration/ignore-actions.html)


## Ignore namespaces

When you have a large amount of actions you'd like to ignore, we recommend setting a custom namespace for these actions and ignore the namespace instead. This keeps the config clean.

* [Documentation on setting namespaces](/application/namespaces.html)
* [Setting/ignoring namespaces for Ruby](/ruby/instrumentation/namespaces.html)
* [Setting/ignoring namespaces for Elixir](/elixir/instrumentation/namespaces.html)

