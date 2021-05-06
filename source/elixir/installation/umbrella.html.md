---
title: Installing AppSignal in an umbrella application
---

AppSignal works with umbrella applications, but there are some things to keep in mind. The dependency should be added to each nested application inside the umbrella, and the configuration should be added to the umbrella's main configuration file.

This guide goes over the first steps to install AppSignal in your umbrella Elixir and Phoenix projects. For more information and further steps, check out the [main installation guide](/elixir/installation.html).

## Installation

Add the AppSignal dependency to each application that will use it. This includes all Phoenix applications and all backend applications that communicate with the database.

```elixir
defp deps do
  {:appsignal, "~> 2.0"}
end
```

Then, run AppSignal’s installer in the umbrella’s root directory to add the configuration to the umbrella application’s configuration files.

    $ mix appsignal.install YOUR_PUSH_API_KEY

By default, each nested application in an umbrella uses the main umbrella configuration, so the nested apps should all have access to the main configuration.

## Phoenix

The installation for Phoenix in an umbrella application are mostly the same as
[setting up AppSignal “regular” Phoenix
application](/elixir/integrations/phoenix.html). One thing to keep in mind is
to `use Appsignal.Phoenix` in your application’s endpoint file. If you have
multiple nested Phoenix applications, use the module in each.

-> If you include `use Plug.Builder` or any other module that redefines the `call/2` function, make sure to place the `use Appsignal.Phoenix` line after that.

```elixir
defmodule AppsignalPhoenixExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :appsignal_phoenix_example
  use Appsignal.Phoenix

  # ...
end
```
