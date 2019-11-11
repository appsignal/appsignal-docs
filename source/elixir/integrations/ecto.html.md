# Instrumenting Ecto queries

AppSignal uses Ecto’s Telemetry instrumentation to gain information about queries ran in your app by attaching a handler that gets called whenever a query is executed.

To get this to work, you attach the handler manually when starting your app’s supervisor. In most applications, this is done in your application’s `start/2` function.

``` elixir
def start(_type, _args) do
  children = [
    AppsignalPhoenixExample.Repo,
    AppsignalPhoenixExampleWeb.Endpoint
  ]

  :telemetry.attach(
    "appsignal-ecto",
    [:appsignal_phoenix_example, :repo, :query],
    &Appsignal.Ecto.handle_event/4,
    nil
  )
  
  opts = [strategy: :one_for_one, name: AppsignalPhoenixExample.Supervisor]
  Supervisor.start_link(children, opts)
end
```

In this example, we’ve attached the Telemetry handler to our Phoenix application by calling `:telemetry.attach/4` with the following arguments:

1. `"appsignal-ecto"` is the name of the handler. This should be unique. If you have multiple repos you’d like to have instrumentation for, give each a unique name (like `"appsignal-ecto-1"` and `"appsignal-ecto-2"`).
2. `[:appsignal_phoenix_example, :repo, :query]` is the name of the event to watch. It’s made up of the repo module’s name (`AppsignalPhoenixExample.Repo`), and the event name (`:query`).
3. `&Appsignal.Ecto.handle_event/4` is the function the event will be sent to in the AppSignal integration.
4. We’ll omit the handler configuration by passing `nil` as the fourth argument. 
