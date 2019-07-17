---
title: Installing AppSignal in an umbrella application
---

AppSignal works with umbrella applications, but there are some things to keep in mind. The dependency should be added to each nested application inside the umbrella, and the configuration should be added to the umbrella's main configuration file.

This guide goes over the first steps to install AppSignal in your umbrella Elixir and Phoenix projects. For more information and further steps, check out the [main installation guide](/elixir/installation.html).

## Installation

Add the AppSignal dependency to each application that will use it. This includes all Phoenix applications and all backend applications that communicate with the database.

```elixir
defp deps do
  {:appsignal, "~> 1.0"}
end
```

Then, run AppSignal’s installer in the umbrella’s root directory to add the configuration to the umbrella application’s configuration files.

    $ mix appsignal.install YOUR_PUSH_API_KEY

By default, each nested application in an umbrella uses the main umbrella configuration, so the nested apps should all have access to the main configuration.

## Phoenix

The installation for Phoenix in an umbrella application are mostly the same as [setting up AppSignal “regular” Phoenix application](/elixir/integrations/phoenix.html), but there are a few things to keep in mind.

1. `use Appsignal.Phoenix` in your application’s endpoint file. If you have multiple nested Phoenix applications, use the module in each.

    ```elixir
    defmodule AppsignalPhoenixExampleWeb.Endpoint do
      use Phoenix.Endpoint, otp_app: :appsignal_phoenix_example
      use Appsignal.Phoenix

      # ...
    end
    ```

2. Add the instrumentation hooks to the endpoint configuration in your umbrella app’s `config/config.exs` file:

    ```elixir
    config :appsignal_phoenix_example_web, AppsignalExampleWeb.Endpoint,
      instrumenters: [Appsignal.Phoenix.Instrumenter]
    ```

3. Add the template engines to the Phoenix configuration by adding this configuration block to your umbrella app’s `config/config.exs` file:

    ```elixir
    config :phoenix, :template_engines,
      eex: Appsignal.Phoenix.Template.EExEngine,
      exs: Appsignal.Phoenix.Template.ExsEngine
    ```

4. Add the Ecto instrumentation hooks to each application that use Ecto, in the applications' `start/2` functions:

    ```elixir
    defmodule AppsignalExample.Application do

      # ...

      def start(_type, _args) do
        children = [
          AppsignalExample.Repo
        ]

        :telemetry.attach(
          "appsignal-ecto",
          [:appsignal_example, :repo, :query],
          &Appsignal.Ecto.handle_event/4,
          nil
        )

        Supervisor.start_link(children, strategy: :one_for_one, name: AppsignalExample.Supervisor)
      end
    end
    ```

Don’t forget to change `:appsignal_example` to your OTP application name, and make sure it matches your repo’s module name. If your repo module is called `AppsignalExample.Repo`, attach to `[:appsignal_example, :repo, :query]`.

If you have multiple repo modules in your application, make sure to use a unique name for each attachment. Instead of using “appsignal-ecto” for both, use “appsignal-ecto-2” for the second, for example.
