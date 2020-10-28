---
title: "Ignore namespaces"
---

In a previous guide we've discussed [setting up custom namespaces](/guides/namespaces.html) in an app. These namespaces can be used to group parts of an app together, but it can also be used to ignore these namespaces entirely. This may be easier than to [ignore a lot of individual actions](/guides/filter-data/ignore-actions.html).

-> 💡 Ignoring namespaces will **ignore error and performance data** from all actions in namespaces. [Custom metrics data](/metrics/custom.html) recorded in any of the namespace actions will still be reported.

## Ignoring namespaces

Namespaces can be ignored by customizing the configuration for AppSignal integrations in apps. The "ignore namespaces" configuration option will allow you to configure a list of namespaces, as reported to AppSignal. Any namespaces in this list will be ignored, meaning the data from these actions will not be sent to the AppSignal servers, and will not count towards your [organization's billing plan](https://appsignal.com/plans).

The "ignore namespaces" config option is configured differently per integration language. See the list of integrations below for the one your app uses.

-> 💡 If you're unsure of the namespaces to configure in the app configuration, find the namespace name to ignore in your app on AppSignal.com in the namespaces filtering drop down, and copy it into the AppSignal configuration.

## Ruby

To ignore namespaces in Ruby, add the following to your AppSignal configuration file. The [`ignore_namespaces`][ruby ignore_namespaces] value is an Array of Strings.

```yaml
# Example: config/appsignal.yml
production:
  ignore_namespaces:
  - "http_request" # "web" namespace on AppSignal
  - "background_job" # "background" namespace on AppSignal
  - "admin"
  - "private"
  # Other config
```

For more information about this config option, see the [`ignore_namespaces` config option][ruby ignore_namespaces] documentation.

[ruby ignore_namespaces]: /ruby/configuration/options.html#option-ignore_namespaces

## Elixir

To ignore namespaces in Elixir, add the following to your AppSignal configuration file. The [`ignore_namespaces`][elixir ignore_namespaces] value is a List of Strings.

```elixir
# Example: config/appsignal.exs
use Mix.Config

config :appsignal, :config,
  ignore_namespaces: [
    "http_request", # "web" namespace on AppSignal
    "background_job", # "background" namespace on AppSignal
    "admin",
    "private"
  ]
```

For more information about this config option, see the [`ignore_namespaces` config option][elixir ignore_namespaces] documentation.

[elixir ignore_namespaces]: /elixir/configuration/options.html#option-ignore_namespaces

## Node.js

To ignore namespaces in Node.js, add the following to your AppSignal configuration file. The [`ignoreNamespaces`][nodejs ignore_namespaces] value is an Array of Strings.

```js
// Example: appsignal.js
const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  // Other config
  ignoreNamespaces: [
    "web",
    "background",
    "admin",
    "private"
  ]
});
```

For more information about this config option, see the [`ignoreNamespaces` config option][nodejs ignore_namespaces] documentation.

[nodejs ignore_namespaces]: /nodejs/configuration/options.html#option-ignoreNamespaces

## Next steps

- [Ignore namespaces](/guides/filter-data/ignore-namespaces.html) - the next step in this guide

---

- [Ignore errors](/guides/filter-data/ignore-errors.html) - the previous step in this guide
- [Filtering app data](/guides/filter-data/) - the start of this guide
- [Getting started guides](/guides/) - Guides overview

[notifications]: /application/notification-settings.html
