---
title: "Integrating AppSignal into Phoenix"
---

The AppSignal for Elixir package integrates with Phoenix. To set up the
integration, please follow our [installation guide](/elixir/installation.html).

This page will describe further ways of configuring AppSignal for the [Phoenix
framework][phoenix]. To add more custom instrumentation to your Phoenix
application, read the [Elixir
instrumentation](/elixir/instrumentation/index.html) documentation.

More information can be found in the [AppSignal Hex package
documentation][hex-appsignal].

## Table of Contents

- [Incoming HTTP requests](#incoming-http-requests)
- [Phoenix instrumentation hooks](#phoenix-instrumentation-hooks)
- [Template rendering](#template-rendering)
- [Queries](#queries)
- [Channels](#channels)
  - [Channels instrumentation with a channel's handle](#channel-instrumentation-with-a-channel-39-s-handle)
  - [Channels instrumentation without decorators](#channel-instrumentation-without-decorators)
  - [Adding channel payloads](#adding-channel-payloads)
- [LiveView](#liveview)
- [Instrumentation for custom Plugs](#instrumentation-for-included-plugs)
- [Custom instrumentation](#custom-instrumentation)

## Incoming HTTP requests

To start logging HTTP requests in your Phoenix app, make sure you use the
`Appsignal.Phoenix` module in your `endpoint.ex` file.

```elixir
defmodule AppsignalPhoenixExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :appsignal_phoenix_example
  use Appsignal.Phoenix

  # ...
end
```

This will create a transaction for every HTTP request which is performed on the
endpoint.

## Phoenix instrumentation hooks

-> **Note**: From AppSignal for Elixir package version `1.12.0` onward, manually configuring Phoenix instrumentation hooks is no longer needed and this step can be skipped for apps running Phoenix 1.4.7 and up.

Phoenix comes with instrumentation hooks built-in. To send Phoenix'
default instrumentation events to AppSignal, add the following to your
`config.exs` (adjusting for your app's name!).

```elixir
# config/config.exs
config :my_app, MyAppWeb.Endpoint,
  instrumenters: [Appsignal.Phoenix.Instrumenter]
```

Using the `Appsignal.Phoenix.Instrumenter` it's possible to add custom
instrumentation to your Phoenix applications.

This module can be used as a Phoenix instrumentation module. Adding this module
to the list of Phoenix instrumenters will result in the
`phoenix_controller_call` and `phoenix_controller_render` events to become part
of your request timeline.

For more information on instrumentation please visit the [AppSignal Hex package
documentation](https://hexdocs.pm/appsignal/).

## Template rendering

It's possible to instrument how much time it takes each template render,
including subtemplates (partials), in your Phoenix application.

To enable this for AppSignal you need to register the AppSignal template
renderer, which augment the compiled templates with instrumentation hooks.

Put the following in your `config.exs`.

```elixir
# config/config.exs
config :phoenix, :template_engines,
  eex: Appsignal.Phoenix.Template.EExEngine,
  exs: Appsignal.Phoenix.Template.ExsEngine
```

## Queries

If you're using Ecto 3, attach `Appsignal.Ecto` to Telemetry query events in your application's `start/2` function by calling `:telemetry.attach/4`. In most Phoenix applications, the application's start function is located in a module named `YourAppName.Application`:

``` elixir
defmodule AppsignalPhoenixExample.Application do
  use Application

  def start(_type, _args) do
    children = [
      # ...
    ]

    # Add this :telemetry.attach/4 call:
    :telemetry.attach(
      "appsignal-ecto",
      [:my_app, :repo, :query],
      &Appsignal.Ecto.handle_event/4,
      nil
    )

    opts = [strategy: :one_for_one, name: AppsignalPhoenixExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

For more information on query instrumentation and installation instructions for Telemetry < 0.3.0 and Ecto < 3.0, check out the [AppSignal Ecto documentation](/elixir/integrations/ecto.html).

## Channels

### Channel instrumentation with a channel's handle

Incoming channel requests can be instrumented by adding code to the
`handle_in/3` function of your application. Function decorators are used to
minimize the amount of code you have to add to your application's channels.

```elixir
defmodule SomeApp.MyChannel do
  use Appsignal.Instrumentation.Decorators

  @decorate channel_action()
  def handle_in("ping", _payload, socket) do
    # your code here..
  end
end
```

Channel events will be displayed under the "Background jobs" tab, showing the
channel module and the action argument that you entered.

### Channel instrumentation without decorators

You can also decide not to use function decorators. In that case, use the
`channel_action/3` function directly, passing in a name for the channel action,
the socket, and the actual code that you are executing in the channel handler.

```elixir
defmodule SomeApp.MyChannel do
  import Appsignal.Phoenix.Channel, only: [channel_action: 4]

  def handle_in("ping" = action, _payload, socket) do
    channel_action(__MODULE__, action, socket, fn ->
      # do some heave processing here...
      reply = perform_work()
      {:reply, {:ok, reply}, socket}
    end)
  end
end
```

### Adding channel payloads

Channel payloads aren't included by default, but can be added by using [tagging]:

```elixir
defmodule SomeApp.MyChannel do
  use Appsignal.Instrumentation.Decorators

  @decorate channel_action
  def handle_in("ping", %{"body" => body}, socket) do
    Appsignal.Transaction.set_sample_data("tags", %{body: body})

    # your code here..
  end
end
```

## LiveView

-> **Note**: The LiveView helper functions are available from AppSignal for
Elixir version `1.13.0` onward.


A LiveView action is instrumented by wrapping its contents in a
`Appsignal.Phoenix.LiveView.live_view_action/4` block.

    defmodule AppsignalPhoenixExampleWeb.ClockLive do
      use Phoenix.LiveView

      def render(assigns) do
        AppsignalPhoenixExampleWeb.ClockView.render("index.html", assigns)
      end

      def mount(_session, socket) do
        :timer.send_interval(1000, self(), :tick)
        {:ok, assign(socket, state: Time.utc_now())}
      end


      def handle_info(:tick, socket) do
        {:ok, assign(socket, state: Time.utc_now())}
      end
    end

Given a live view that updates its own state every second, we can add
AppSignal instrumentation by wrapping both the mount/2 and handle_info/2
functions with a `Appsignal.Phoenix.LiveView.live_view_action`/4 call:

    defmodule AppsignalPhoenixExampleWeb.ClockLive do
      use Phoenix.LiveView
      import Appsignal.Phoenix.LiveView, only: [live_view_action: 4]

      def render(assigns) do
        AppsignalPhoenixExampleWeb.ClockView.render("index.html", assigns)
      end

      def mount(_session, socket) do
        live_view_action(__MODULE__, :mount, socket, fn ->
          :timer.send_interval(1000, self(), :tick)
          {:ok, assign(socket, state: Time.utc_now())}
        end)
      end

      def handle_info(:tick, socket) do
        live_view_action(__MODULE__, :mount, socket, fn ->
          {:ok, assign(socket, state: Time.utc_now())}
        end)
      end
    end

Calling one of these functions in your app will now automatically create a
sample that's sent to AppSignal. These are displayed under the `:live_view`
namespace.

## Instrumentation for included Plugs

Exceptions in included Plugs are automatically caught by AppSignal, but
performance samples need to be set up manually using the custom instrumentation
helpers or decorators. See the
[Plug](/elixir/integrations/plug.html#instrumentation-for-included-plugs)
documentation for more information.

## Custom instrumentation

[Add custom instrumentation](/elixir/instrumentation/instrumentation.html) to
keep track of more complex code and get more complete breakdowns of slow
requests.

[phoenix]: http://www.phoenixframework.org/
[hex-appsignal]: https://hexdocs.pm/appsignal/
[hex-phoenix-channels]: https://hexdocs.pm/appsignal/Appsignal.Phoenix.Channel.html
[tagging]:/elixir/instrumentation/tagging.html
