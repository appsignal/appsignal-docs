---
title: "Custom instrumentation for Elixir"
---

In order to find out what specific pieces of code are causing performance
problems it's useful to add custom instrumentation to your application. This
allows us to create better breakdowns of which code runs slowest and what type
of action the most amount of time was spent on.

Custom instrumentation is possible in two ways: using function decorators and
instrumentation helper functions. The function decorators are easiest to use,
but are less flexible than the instrumentation helper functions.

This short guide will help you set up custom instrumentation. More details on
the usage of certain helpers can be found in the Hex docs for the [AppSignal
package](https://hexdocs.pm/appsignal/).

-> **Note**: Make sure you've [integrated
   AppSignal](/elixir/instrumentation/integrating-appsignal.html) before adding
   custom instrumentation to your application if it's not automatically
   integrated by one of our supported
   [integrations](/elixir/integrations/index.html).

-> **Note**: This page only describes how to add performance instrumentation to
   your code. To track errors please read our
   [exception handling](/elixir/instrumentation/exception-handling.html) guide.

## Function decorators

Using the `Appsignal.Instrumentation.Decorators` decorator module, it's
possible quickly add custom instrumentation to your Elixir applications without
a lot of code.

###^decorator Transaction events

In the following example we have a Phoenix controller with an `index/2`
function which calls a slow function. The `slow` function is instrumented using
the AppSignal `transaction_event` decorator which records it as a separate
event in this Phoenix request. It will show up on AppSignal.com in the event
timeline of this transaction sample to provide more insight in where the most
time was spent during the request.

```elixir
# Phoenix controller example
defmodule PhoenixExample.PageController do
  use PhoenixExample.Web, :controller
  # Include this
  use Appsignal.Instrumentation.Decorators

  def index(conn, _params) do
    slow()
    render conn, "index.html"
  end

  # Decorate this function to add custom instrumentation
  @decorate transaction_event()
  defp slow do
    :timer.sleep(1000)
  end
end
```

By default the instrumented functions have no parent group. They are grouped
under the "other" group. A group all unknown event groups are grouped under.

If you want to group certain events together under the same event group (other
group are `phoenix_controller`, `phoenix_render`, `ecto`, etc.) you can also
supply a group name to the `transaction_event` decorator.

```elixir
@decorate transaction_event("github_api")
defp get_data_from_github do
  # Third-party API call
end
```

This will create an event `get_data_from_github.github_api` in the event
timeline. For more information on how event names are used, please read
our [event naming guidelines](/api/event-names.html).

###^decorator Transactions

In the Phoenix example an AppSignal transaction has already been started,
thanks to the first-party support for Phoenix in the AppSignal package. Not all
frameworks and packages are currently supported directly and automatically
start transactions. The same is true for your own pure Elixir applications.

In order to track `transaction_event` decorators we will need to start an
AppSignal transaction beforehand. We can start a transaction with the
`transaction` function decorator.

```elixir
# Pure Elixir example
defmodule FunctionDecoratorsExample do
  # Include this
  use Appsignal.Instrumentation.Decorators

  # No transaction is started beforehand like in Phoenix, so we need to start
  # it ourselves.
  @decorate transaction()
  def call do
    slow()
    # ...
  end

  # Decorate this function to add custom instrumentation
  @decorate transaction_event()
  defp slow do
    :timer.sleep(1000)
  end
end
```

**Note**: When using pure Elixir applications, make sure that the AppSignal
application is started before you start a transaction. For more information,
see how to
[integrate AppSignal](/elixir/instrumentation/integrating-appsignal.html).

###^decorator Namespaces

In order to differentiate between HTTP requests and background jobs we can pass
a namespace to the transaction once we start it.

The following two namespaces are official namespaces supported by AppSignal.

- `http_request` - the default - is called the "web" namespace
- `background_job` - creates the "background" namespace

```elixir
defmodule FunctionDecoratorsExample do
  # Include this
  use Appsignal.Instrumentation.Decorators

  # No namespace argument defaults to `:http_request`
  @decorate transaction()
  def web_function do
    # do stuff
  end

  # The "background" namespace
  @decorate transaction(:background_job)
  def background_function do
    # do stuff
  end
end
```

For more information about what namespaces are, please see our
[namespaces](/application/namespaces.html) documentation.

###^decorator Custom namespaces

You can also create your own namespaces to track transactions in a separate
part of your application such as an administration panel. This will group all
the transactions with this namespace in a separate section on AppSignal.com so
that slow admin controllers don't interfere with the averages of your
application's speed.

```elixir
@decorate transaction(:admin)
def some_function do
  # do stuff
end
```

###^decorator Phoenix channels

There is a custom function decorator for Phoenix channels. This decorator is
meant to be put before the `handle_in/3` function of a `Phoenix.Channel`
module.

```elixir
defmodule FunctionDecoratorsExample.MyChannel do
  # Include this
  use Appsignal.Instrumentation.Decorators

  # Add this channel function decorator
  @decorate channel_action()
  def handle_in("ping", _payload, socket) do
    # your code here..
  end
end
```

Channel events will be displayed under the "background" namespace, showing the
channel module and the action argument that it's used on.

## Instrumentation helper functions

Using the instrumentation helpers it's possible to add custom instrumentation
while retaining a lot of control over what is instrumented.

See also the [appsignal package on hexdocs](https://hexdocs.pm/appsignal) for
code documentation.

###^helper Instrument helper

In the following example we have a Phoenix controller with an `index/2`
function which performs a couple of complex operations. We will add an
instrumentation function to instrument this complex code. The data collected
during the execution of this code will show up on AppSignal.com in the event
timeline of this transaction sample. It will help provide more insight in where
the most time was spent during the request.

For more information on what event names to use in the `instrument/3` and `instrument/4` functions, please read our [event naming guidelines](/api/event-names.html).

```elixir
# Phoenix controller example
defmodule PhoenixExample.PostController do
  use PhoenixExample.Web, :controller
  # Include this
  import Appsignal.Instrumentation.Helpers, only: [instrument: 3]

  def index(conn, _params) do
    # Instrument a block of code
    instrument("query.posts", "Fetching all posts", fn() ->
      # Database queries

      # Instrument a nested block of code
      data = instrument("request.s3", "Fetching related post data", fn() ->
        # Third-party API request
      end)

      instrument("linking.posts", "Linking post data together", fn() ->
        # Linking database data and S3 data
        # Enum.each(data, fn(x) -> "link post to third-party data" end)
      end)

      # etc
    end)

    render conn, "index.html"
  end
end
```

**Note**: On Elixir integration versions before 1.1.1, you'll need to pass the
current transaction to `instrument/4`.

```elixir
# Phoenix controller example
defmodule PhoenixExample.PostController do
  use PhoenixExample.Web, :controller
  # Include instrument/4 instead of instrument/3
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  def index(conn, _params) do
   # Get the current transaction
   transaction = Appsignal.TransactionRegistry.lookup(self())

    # Pass the transaction as the first argument to instrument/4
    instrument(transaction, "query.posts", "Fetching all posts", fn() ->
      # etc
    end)

    render conn, "index.html"
  end
end
```

#### Adding asynchronous events to a transaction

To add asynchronous events to a transaction in another process there are a couple things to keep in mind. These events can not exceed the runtime of the parent transaction. If they finish after a transaction is completed the events will be registered incompletely, as they don't have a end-time. They will also appear to miss some metadata such as an event name, title and body.

A process spawned by a Phoenix controller can't run longer than it takes for the request to complete. If so, a new transaction should be started within that new process instead. For more information on how to start and complete transactions, see our [transactions section](#helper-transactions). These transactions cannot be linked together at this time. To wait for an asynchronous process before completing the transaction you can use something like [`Task.await/2`](https://hexdocs.pm/elixir/Task.html#await/2), see the example below.

To add events to another process' transaction you can pass along the `PID` of a process to the `instrument/4` function. If a transaction exists for that process, the event will be registered on that transaction, otherwise it's ignored.

Make sure to wait for the process in which another event is tracked before completing the transaction.

```elixir
# Phoenix controller example
defmodule PhoenixExample.PostController do
  use PhoenixExample.Web, :controller
  # Include instrument/4 instead of instrument/3
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  def index(conn, _params) do
    parent = self()
    task = Task.async(fn ->
      instrument(parent, "foo.bar", "TEST", fn() ->
        :timer.sleep(1000)
      end)
    end)

    # Do other things while the task is running

    # And wait for the task
    Task.await(task)

    # Then return the request
    text conn, "Done!"
  end
end
```

###^helper Transactions

In the Phoenix example an AppSignal transaction has already been started,
thanks to the first-party support for Phoenix in the AppSignal package. Not all
frameworks and packages are currently supported directly and automatically
start transactions. The same is true for your own pure Elixir applications.

In order to track the instrumentation functions we will need to start an
AppSignal transaction beforehand. We can start a transaction with
`Appsignal.Transaction.start/2`. Once a transaction is started we can add
transaction events that are recorded by
`Appsignal.Instrumentation.Helpers.instrument/4`.

```elixir
# Pure Elixir example
defmodule InstrumentationHelpersExample do
  # Include this
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  def call do
    # Start an AppSignal transaction
    transaction = Appsignal.Transaction.start(
      Appsignal.Transaction.generate_id,
      :http_request
    )
    # Set the action name
    |> Appsignal.Transaction.set_action("InstrumentationExample/instrumented_function")

    instrument(transaction, "query.posts", "Fetching all posts", fn() ->
      # Database queries
    end)

    # Finish and close the transaction
    Appsignal.Transaction.finish(transaction)
    Appsignal.Transaction.complete(transaction)
  end
end
```

**Note**: When using pure Elixir applications, make sure that the AppSignal
application is started before you start a transaction. For more information,
see how to
[integrate AppSignal](/elixir/instrumentation/integrating-appsignal.html).

###^helper Transaction metadata

Now we have recorded a simple transaction, but the transaction sample itself
might not provide enough context to where the issue occurred or in what
scenario. To provide more context to the sample we can add more metadata to a
transaction.

```elixir
transaction = Appsignal.Transaction.start(
  Appsignal.Transaction.generate_id,
  :http_request
)
# Set the action name of the module/controller and function which is instrumented
|> Appsignal.Transaction.set_action("InstrumentationExample#instrumented_function")
# Add extra data to the transaction. See also our Tagging guide.
|> Appsignal.Transaction.set_sample_data(
  "environment", %{request_path: "/hello", method: "GET"}
)
```

There are also helpers available for when the transaction is not available.
When these are used AppSignal will add the metadata to the currently active
transaction if any.

```elixir
Appsignal.Transaction.set_action("InstrumentationExample/instrumented_function")

# And
Appsignal.Transaction.set_sample_data(
  "environment", %{request_path: "/hello", method: "GET"}
)
```

###^helper Namespaces

In order to differentiate between HTTP requests and background jobs we can pass
a namespace to the transaction once we start it.

The following two namespaces are official namespaces supported by AppSignal.

- `http_request` - the default - is called the "web" namespace
- `background_job` - creates the "background" namespace

```elixir
Appsignal.Transaction.start(
  Appsignal.Transaction.generate_id,
  :background_job
)
```

For more information about what namespaces are, please see our
[namespaces](/application/namespaces.html) documentation.

###^helper Custom namespaces

You can also create your own namespaces to track transactions in a separate
part of your application such as an administration panel. This will group all
the transactions with this namespace in a separate section on AppSignal.com so
that slow admin controllers don't interfere with the averages of your
application's speed.

```elixir
Appsignal.Transaction.start(
  Appsignal.Transaction.generate_id,
  :admin
)
```

###^helper Exception handling

To report errors using custom instrumentation please read more in our
[exception handling guide](/elixir/instrumentation/exception-handling.html).

###^helper Example

This example is set up as procedural as possible so any setup doesn't distract
from the order in which to execute things. You may want to wrap certain parts
in separate functions to make it more reusable.

```elixir
defmodule InstrumentationExample do
  # Include this
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  def instrumented_function do
    # Start an AppSignal transaction
    transaction = Appsignal.Transaction.start(
      Appsignal.Transaction.generate_id,
      :http_request
    )
    # Set the action name of the module/controller and function which is instrumented
    |> Appsignal.Transaction.set_action("InstrumentationExample/instrumented_function")
    # Add extra data to the transaction. See also our Tagging guide.
    |> Appsignal.Transaction.set_sample_data(
      "environment", %{request_path: "/hello", method: "GET"}
    )

    try do
      # Instrument specific blocks of code
      instrument(transaction, "complex.function", "Rendering something slow", fn() ->
        :timer.sleep(100)

        # Nest instrumentation
        instrument(transaction, "request.third_party_api", "Slow API call", fn() ->
          :timer.sleep(300)
        end)

        instrument(transaction, "query.custom_database", "Slow query", fn() ->
          :timer.sleep(5000)
        end)

        # Raise an error, not required of course.
        raise("Exception!")
      end)
    rescue
      e ->
        # Report an error in this transaction.
        # It will then be reported as an error instead of a performance issue.
        Appsignal.Transaction.set_error(
          transaction,
          "SomeError",
          "So what went wrong was that I raised an exception earlier..",
          System.stacktrace
        )
    end

    # Finish and close the transaction
    Appsignal.Transaction.finish(transaction)
    Appsignal.Transaction.complete(transaction)
  end
end
```
