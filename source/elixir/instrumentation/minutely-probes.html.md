---
title: "Minutely probes"
---

Minutely probes are a mechanism to periodically send [custom metrics](/metrics/custom.html) to AppSignal. This is a system that is included in the AppSignal Elixir package by default. At the start of every minute the minutely probes are triggered to collect metrics and then snoozed until the next minute.

By default the AppSignal Elixir package enables a probe for the ErlangVM.

-> **Note**: We recommend using AppSignal Elixir package `1.10.1` and up when using this feature.

## Usage

The minutely probes allow the AppSignal Elixir package to collect [custom metrics](/metrics/custom.html) by default for the ErlangVM and app-specific metrics by [creating your own probe](#creating-probes).

### Multiple instances

Once activated, the minutely probes system runs on every instance of an app. This means that if a probe report metrics without some kind of differentiating tag, global metrics may be overwritten by instance-level metrics.

To remedy this, we suggest [tagging](/metrics/custom.html#metric-tags) your metrics with the hostname or something else unique for each instance. For example, the ErlangVM Probe tags metrics with the hostname by default.

Alternatively you can [disable minutely probes](/elixir/configuration/options.html#option-enable_minutely_probes) for all but one instance, on which the minutely probes process is run. We suggest using the [`APPSIGNAL_ENABLE_MINUTELY_PROBES`](/elixir/configuration/options.html#option-enable_minutely_probes) environment variable to only enable it on the instance of your choosing.

## Configuration

The minutely probes are configured using the [`enable_minutely_probes`](/elixir/configuration/options.html#option-enable_minutely_probes) config option. The default value is `true`.

## Creating probes

If you want to track more [custom metrics](/metrics/custom.html) from your app than our default probes do, you can add your own probe(s).

An AppSignal minutely probe can be an [Anonymous function](#anonymous-function), or a [Module based function](#module-based-function).

### Anonymous function

The simplest probe type to register. If you have no dependencies for your probe this is the preferred method.

```elixir
Appsignal.Probes.register(:my_probe, fn ->
  Appsignal.set_gauge("database_size", 10)
end)
```

### Module based function

A module based function can be useful if you have a more complex probe, or a probe that has dependencies.

```elixir
# lib/my_app/probes/my_probe.ex
defmodule MyApp.MyProbe do
  def call do
    Appsignal.set_gauge("database_size", 10)
  end
end
```

Now you can register this probe in the start function of your OTP app.

```elixir
Appsignal.Probes.register(:my_probe, &MyApp.MyProbe.call/0)
```

## Registering probes

Probes can be registered with the `register` method on the `Appsignal.Probes` module.
This method accepts two arguments.

- `key` - This is the key/name of the probe. This will be used to identify the probe in case an error occurs while executing the probe (which will be logged to the [appsignal.log file](/support/debugging.html#logs)) and to [override an existing probe](#overriding-default-probes).
- `probe` - This is one of the [supported probe types](#creating-probes) that should be called every minute to collect metrics.

To add a probe, register it in your application's `start/2` function, just before the supervisor is started.

In a Phoenix app this will look like this:

```elixir
# lib/my_app/application.ex
def start(_type, _args) do
  children = [
    MyApp.Repo,
    MyAppWeb.Endpoint,
  ]

  Appsignal.Probes.register(:my_probe, &MyProbe.call/0)

  opts = [strategy: :one_for_one, name: Weekmenu.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Overriding default probes

AppSignal ships with default probes for certain [integrations](/elixir/integrations/). If for any reason this probe does not function properly or requires some additional configuration for your use case, you can override the default probe by registering a new probe with the same key.

```elixir
# lib/my_app/application.ex

Appsignal.Probes.register(:erlang, fn() ->
  # Do things
end)
```

Overriding probes will log a debug message in the [appsignal.log file](/support/debugging.html#logs) which can help to detect if a probe is correctly overridden.
