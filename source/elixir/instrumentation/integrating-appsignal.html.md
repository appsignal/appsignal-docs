---
title: "Integrating AppSignal in Elixir"
---

It's possible that AppSignal does not provide automatic integration for your
framework of choice, or maybe you're using your own application setup.

When AppSignal does not support something out-of-the-box it's still possible to
to instrument applications. AppSignal needs to be configured and started once
at the beginning of a process. It can be
[configured](/elixir/configuration/index.html) through Mix configuration or by
using environment variables.

## Installation

Make sure the AppSignal for Elixir package is installed in your application
using Mix.

Add it as a dependency to your application and add it as an sub application of
your application.

```elixir
# mix.exs
# Note: Module setup and other functions of the mix.exs file removed
# The contents of the application and deps function may differ in your
# application.

# ...

  def application do
    [
      mod: {MyAwesomeApp, []},
      applications: [:appsignal, ...]
    ]
  end

# ...

  defp deps do
    [
      # ...
      {:appsignal, "~> 1.0"}
    ]
  end

# ...

```

See our [installation guide](/elixir/installation.html) for the full guide.

## Configuration

The AppSignal for Elixir package needs to be configured before it can send data
to AppSignal.com. There are two methods of configuration. Using the mix
configuration and using environment variables.

See the [configuration pages](/elixir/configuration/index.html) for the full
configuration guide.

## Starting AppSignal

In order for AppSignal to instrument your application the AppSignal process
must be started in the Erlang BEAM VM. Make sure to put this line in a location
that is always run in your application.

```elixir
{:ok, _} = Application.ensure_all_started(:appsignal)
```

## Add custom instrumentation

Continue with our guide to [add custom
instrumentation](/elixir/instrumentation/index.html) to your application.
