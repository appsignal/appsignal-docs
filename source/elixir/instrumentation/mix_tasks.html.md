# Mix tasks

AppSignal for Elixir doesn't automatically instrument mix tasks, but you can set up manual instrumentation and error handling using [custom instrumentation](https://docs.appsignal.com/elixir/instrumentation/).

## Starting and stopping AppSignal

Since Mix tasks don't automatically start applications, you'll need to explicitly start the `:appsignal` application in your task:

```
Application.ensure_all_started(:appsignal)
```

To make sure AppSignal has enough time to flush data to its agent, call `Appsignal.Nif.stop/0` at the end of your task, which blocks until the extension has had enough time to flush the sent payloads to the agent before stopping.

## Catching errors

To wrap errors in your task to be sent to AppSignal, add a `rescue` block to catch errors from your code. Pass the captured exception to `Appsignal.send_error/1` to report it to AppSignal. Add an `after` clause to your `rescue` block to call `Appsignal.Nif.stop/0`.

``` elixir
defmodule Mix.Tasks.Rescue do
  use Mix.Task

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:appsignal)

    raise "rescue!"
  rescue
    exception ->
      Appsignal.send_error(exception)
      reraise exception, __STACKTRACE__
  after
    Appsignal.Nif.stop
  end
end
```

## Measuring performance

To measure performance in your task, start and stop a transaction manually and add events using the instrumentation helpers, like described in the [custom helper instrumentation](https://docs.appsignal.com/elixir/instrumentation/instrumentation.html#helper-transactions).

```
defmodule Mix.Tasks.Instrument do
  use Mix.Task
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:appsignal)

    transaction =
      Appsignal.Transaction.generate_id()
      |> Appsignal.Transaction.start(:background_job)
      |> Appsignal.Transaction.set_action("Mix.Tasks.Instrument")

    instrument(transaction, "task.instrumented", "Sleeping for 1 second", fn ->
      :timer.sleep(1_000)
    end)

    Appsignal.Transaction.finish(transaction)
    Appsignal.Transaction.complete(transaction)

    Appsignal.Nif.stop()
  end
end
```
