---
title: "Configure parameter filtering"
---

In most apps at least some of the data that might be posted to the app is
sensitive information that should not leave the network. We support two ways of
filtering parameters from being sent to AppSignal.

## Phoenix's filter_parameters configuration

You can use Phoenix's parameter filtering, which is used to keep sensitive
information from the logs. AppSignal will also follow these filtering rules.

```elixir
# config/config.exs
config :phoenix,
  :filter_parameters, ["password", "secret"]
```

If `:filter_parameters` is not set, Phoenix will default to `["password"]`. This
means that a Phoenix app will not send any passwords to AppSignal without any
configuration.

## AppSignal's built-in filtering

If you're not using Phoenix, or want to filter parameters without changing the
Phoenix.Logger's configuration, you can set up filtered parameters in the
AppSignal configuration file.

```elixir
# config/config.exs
config :appsignal, :config,
  filter_parameters: ["password", "secret"]
```

## Skip sending session data

If you don't want to send your session data to AppSignal you can add this to the
AppSignal configuration file:

```elixir
# config/config.exs
config :appsignal, :config,
  skip_session_data: true
```
