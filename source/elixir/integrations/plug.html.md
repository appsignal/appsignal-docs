---
title: "Integrating AppSignal into Plug"
---

-> **Note**: Support for custom namespaces was added in version 1.3.0 of the
   AppSignal for Elixir package.

The AppSignal for Elixir package integrates with Plug. To set up the
integration, please follow our [installation guide](/elixir/installation.html).

This page describes how to set up AppSignal in a Plug application, and how to
add instrumentation for events within requests. For more information about
custom instrumentation, read the [Elixir
instrumentation](/elixir/instrumentation/index.html) documentation.

More information can be found in the [AppSignal Hex package
documentation][hex-appsignal].

## Table of Contents

- [Incoming HTTP requests](#incoming-http-requests)
- [Custom instrumentation](#custom-instrumentation)
- [Instrumentation for included Plugs](#instrumentation-for-included-plugs)

## Incoming HTTP requests

We'll start out with a small Plug app that accepts `GET` requests to `/` and
returns a welcome message. To start logging HTTP requests in this app, we'll
use the `Appsignal.Plug` module.

The Plug integration [doesn’t automatically extract the request’s action
name](https://docs.appsignal.com/support/known-issues/plug-actions-registered-as-unknown.html).
Call `Appsignal.Transaction.set_action/1` in your action to set the action name
for your requests to prevent your requests to be categorised as “unknown”.

``` elixir
defmodule AppsignalPlugExample do
  use Plug.Router
  use Appsignal.Plug # <- Add this

  plug :match
  plug :dispatch

  get "/" do
    Appsignal.Transaction.set_action("GET /") # <- Set the action name

    send_resp(conn, 200, "Welcome")
  end
end
```

This will create a transaction for every HTTP request which is performed on the 
endpoint.

## Custom instrumentation

Although `Appsignal.Plug` will start transactions for you, it won't instrument
events in your app just yet. To do that, we need to add some custom
instrumentation.

This example app looks like the one we used before, but it has a slow function
(aptly named `slow/0`) we'd like to add instrumentation for. To do that, we need
to

1. `use Appsignal.Instrumentation.Decorators` to allow us to use AppSignal's
   instrumentation decorators
2. Decorate the function we want to instrument with the `transaction_event/0`
   decorator

``` elixir
defmodule AppsignalPlugExample do
  use Plug.Router
  use Appsignal.Instrumentation.Decorators # <-- 1

  plug :match
  plug :dispatch

  get "/" do
    slow()
    send_resp(conn, 200, "Welcome")
  end

  @decorate transaction_event() # <-- 2
  defp slow do
    :timer.sleep(1000)
  end

  use Appsignal.Plug
end
```

This will add an event for the `slow/0` function to the current transaction
whenever it's called. For more information about custom instrumentation, read
the [Elixir instrumentation](/elixir/instrumentation/index.html) documentation.

## Instrumentation for included Plugs

Exceptions in included Plugs are automatically caught by AppSignal, but
performance samples need to be set up manually using the custom instrumentation
helpers or decorators.

### Plug instrumentation with decorators

To add instrumentation to Plugs, use the `Appsignal.Instrumentation.Decorators`
module, and decorate your Plug's `call/2` function using the
`transaction_event/0-1` function.

``` elixir
defmodule SlowPlugWithDecorators do
  import Plug.Conn
  # use Appsignal's decorators
  use Appsignal.Instrumentation.Decorators

  def init(opts), do: opts

  # Decorate the call/2 function to add custom instrumentation
  @decorate transaction_event()
  def call(conn, _) do
    :timer.sleep(1000)
    conn
  end
end
```

See the
[`transaction_event`](https://docs.appsignal.com/elixir/instrumentation/instrumentation.html#decorator-transaction-events)
documentation for more information.

### Plug instrumentation without decorators

Instead of using the decorators, you can use the `instrument/3` method to
decorate a block of code directly.

``` elixir
defmodule SlowPlugWithInstrumentationHelpers do
  import Plug.Conn
  # Import the instrument-function
  import Appsignal.Instrumentation.Helpers, only: [instrument: 3]

  def init(opts), do: opts

  def call(conn, _) do
    # Wrap the contents of the call/2 function in an instrumentation block
    instrument("timer.sleep", "Sleeping", fn() ->
      :timer.sleep(1000)
      conn
    end)
  end
end
```

See the [instrumentation
helpers](https://docs.appsignal.com/elixir/instrumentation/instrumentation.html#instrumentation-helper-functions)
documentation for more information.

[hex-appsignal]: https://hexdocs.pm/appsignal/
