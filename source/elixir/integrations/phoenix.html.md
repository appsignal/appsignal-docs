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

## Getting started

Since version 2.0, the Phoenix integration is moved to a separate library named
`:appsignal_phoenix`, which depends on the main `:appsignal` library. To use
AppSignal in a Phoenix app, add `:appsignal_phoenix` to your dependencies. You
can then remove the `:appsignal` dependency.

``` elixir
defmodule AppsignalPhoenixExample.MixProject do
  # ...

  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      # ...
      {:appsignal_phoenix, "~> 2.0.0"}
    ]
  end

  # ...
end
```

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

## Template rendering

It's possible to instrument how much time it takes each template render,
including subtemplates (partials), in your Phoenix application.

To enable this for AppSignal, add `use Appsignal.Phoenix.View` to the view/0
function in your app's web module, after `use Phoenix.View`:

```elixir
defmodule AppsignalPhoenixExampleWeb do
  # ...

  def view do
    quote do
      use Phoenix.View,
        root: "lib/appsignal_phoenix_example_web/templates",
        namespace: AppsignalPhoenixExampleWeb

      use Appsignal.Phoenix.View

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  # ...
end
```

## Channels

### Channel instrumentation with a channel's handle

Incoming channel requests can be instrumented by wrapping the code in your
`handle_in/3` functions with `Appsignal.Phoenix.Channel.instrument/5`:

```elixir
defmodule AppsignalPhoenixExampleWeb.RoomChannel do
  use Phoenix.Channel

  # ...

  def handle_in("new_msg", %{"body" => body} = params, socket) do
    Appsignal.Phoenix.Channel.instrument(__MODULE__, "new_msg", params, socket, fn ->
      broadcast!(socket, "new_msg", %{body: body})
      {:noreply, socket}
    end)
  end
end
```

Alternatively, you can use function decorators to instrument channels. While
less flexible than the instrumentation function, decorators minimize the amount
of code you have to add to your application's channels.

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


## LiveView

-> **Note**: The LiveView helper functions are available from AppSignal for
Elixir version `1.13.0` onward.

A LiveView action is instrumented by wrapping its contents in a
`Appsignal.Phoenix.LiveView.instrument/4` block.

Given a live view that updates its own state every second, we can add
AppSignal instrumentation by wrapping both the mount/2 and handle_info/2
functions with a `Appsignal.Phoenix.LiveView.instrument`/4 call:

```elixir
defmodule AppsignalPhoenixExampleWeb.ClockLive do
  use Phoenix.LiveView
  import Appsignal.Phoenix.LiveView, only: [instrument: 4]

  def render(assigns) do
    AppsignalPhoenixExampleWeb.ClockView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    # Wrap the contents of the mount/2 function with a call to
    # Appsignal.Phoenix.LiveView.instrument/4

    instrument(__MODULE__, "mount", socket, fn ->
      :timer.send_interval(1000, self(), :tick)
      {:ok, assign(socket, state: Time.utc_now())}
    end)
  end

  def handle_info(:tick, socket) do
    # Wrap the contents of the handle_info/2 function with a call to
    # Appsignal.Phoenix.LiveView.instrument/4:

    instrument(__MODULE__, "tick", socket, fn ->
      {:ok, assign(socket, state: Time.utc_now())}
    end)
  end
end
```

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
[sample_data]:/guides/custom-data/sample-data.html#elixir
