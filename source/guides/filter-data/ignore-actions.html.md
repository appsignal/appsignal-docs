---
title: "Ignore actions"
---

In an app there may be certain actions that you don't want to report to AppSignal. The most common use case is a web endpoint that your load balancer uses to check if your app is still responding or your entire administration panel. This causes a lot of traffic but is not a crucial endpoint to have AppSignal monitor. In fact, it may even distort averages in a [namespace](/application/namespaces.html) and make graph data unusable.

-> 💡 Ignoring actions will **ignore error and performance data** from those actions. [Custom metrics data](/metrics/custom.html) recorded in an action will still be reported.

## Ignoring actions

These actions can be ignored by customizing the configuration for AppSignal integrations in apps. The "ignore actions" configuration option will allow you to configure a list of action names, as reported to AppSignal. Any action in this list will be ignored, meaning the data of these actions will not be sent to the AppSignal servers, and will not count towards your [organization's billing plan](https://appsignal.com/plans).

The "ignore actions" config option is configured differently per integration language. See the list of integrations below for the one your app uses.

-> 💡 If you're unsure of the action names to configure in the app configuration, find the action name to ignore in your app on AppSignal.com, and copy it into the AppSignal configuration.

## Ruby

To ignore actions in Ruby, add the following to your AppSignal configuration file. The [`ignore_actions`][ruby ignore_actions] value is an Array of Strings.

The below example is for a Rails app.

```yaml
# Example: config/appsignal.yml
production:
  ignore_actions:
  - "UptimeController#healthcheck"
  - "AdminController#index"
  - "Admin::UsersController#show"
  - "Admin::UsersController#edit"
  - "MyBackgroundWorker#perform"
  # Other config
```

If you use Sinatra or any other framework, use the HTTP method and path you used to specify your route, for example:

```yaml
default: &defaults
  ignore_actions:
    - "GET /healthcheck"
    - "GET /pages/:id"
    - "POST /pages/create"
```

[ruby ignore_actions]: /ruby/configuration/options.html#option-ignore_actions

## Elixir

To ignore actions in Elixir, add the following to your AppSignal configuration file. The [`ignore_actions`][elixir ignore_actions] value is a List of Strings.

```elixir
# Example: config/appsignal.exs
config :appsignal, :config,
  ignore_actions: ["AppsignalPhoenixExampleWeb.UptimeController#healthcheck", "AppsignalPhoenixExampleWeb.AdminController#index"]
```

[elixir ignore_actions]: /elixir/configuration/options.html#option-ignore_actions

## Node.js

To ignore actions in Node.js, add the following to your AppSignal configuration file. The [`ignoreActions`][nodejs ignore_actions] value is an Array of Strings.

The name of a `Span` maps to an "action name" on AppSignal.com. An action name is used to identify the location of a certain sample error and performance issues. You can see a list of these in the "Action name" column of the _Issue list_ under [Performance](https://appsignal.com/redirect-to/app?to=performance) in the sidebar.

```js
const appsignal = new Appsignal({
  # Other config
  ignoreActions: ["GET /pages/:id", "GET /healthcheck", "GET /admin"]
})
```

[nodejs ignore_actions]: /nodejs/configuration/options.html#option-ignoreActions

## Next steps

- [Ignore errors](/guides/filter-data/ignore-errors.html) - the previous step in this guide
- [Filtering app data](/guides/filter-data/) - the start of this guide
- [Getting started guides](/guides/) - Guides overview

[notifications]: /application/notification-settings.html
