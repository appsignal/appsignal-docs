---
title: Upgrading from AppSignal for Elixir 1.x to 2.x
---

Upgrading to AppSignal for Elixir requires some manual changes. This guide
covers upgrading from a Phoenix application running AppSignal for Elixir 1.x to
2.x, but is also applicable to Plug applications, or pure Elixir applications.

## Dependencies

In the original install guide, users were encouraged to depend on version `~>
1.0` of the `:appsignal` dependency. This makes sure existing apps always use
the latest version without automatically upgrading to version 2.0. This means
you'll have to upgrade the dependency manually for existing apps.

For version 2.x, we've chosen to split the integration up into three parts to
keep dependencies to a minimum. We now have a separate library for Phoenix,
Plug and pure Elixir apps, named `appsignal_phoenix`, `appsignal_plug` and
`appsignal`, respectively.

To upgrade a Phoenix app from AppSignal for Elixir 1.x to 2.x, remove the
existing dependency on `:appsignal`, and replace it with a dependency on
`:appsignal_phoenix`.

```elixir
defp deps do
  {:appsignal_phoenix, "~> 2.0"}
end
```

Like before, we recommend to use a pessimistic version constraint to always get
the latest compatible version, but not upgrade to 3.x automatically.

## Configuration

The next step is to update your AppSignal configuration, as 2.x requires the
`:otp_app` option to be set. If you've configured your app using the
`config/appsignal.exs` configuration file, add the `:otp_app` option to match
the name of your application.

```
# config/appsignal.exs
config :appsignal, :config,
  otp_app: :appsignal_phoenix_example, # <- Add this
  name: "AppsignalPhoenixExample",
  push_api_key: "your-push-api-key",
  env: Mix.env,
  active: true
```

!> **NOTE:** For umbrella Phoenix apps, use the base `:otp_name`, without the
"_web" suffix.

If you use OS environment variables to configure your app, add
`APPSIGNAL_OTP_APP` to configure the same option:

```
export APPSIGNAL_OTP_APP="appsignal_phoenix_example"
export APPSIGNAL_PUSH_API_KEY="your-push-api-key"
export APPSIGNAL_APP_NAME="AppsignalPhoenixExample"
export APPSIGNAL_APP_ENV="prod"
```

## Instrumentation hooks

Older versions of AppSignal for Elixir, relied on
`Appsignal.Phoenix.Instrumenter` being configured in `config/config.exs` to
instrument parts of your Phoenix application. Since 1.12.0, AppSignal for
Elixir uses Phoenix's Telemetry integration instead.

If you haven't already, you can remove the custom
`Appsignal.Phoenix.Instrumenter` instrumenter from your `config/config.exs`
while upgrading to 2.x.

## Template rendering

Instead of the custom `:template_engines` from 1.x, AppSignal for Elixir 2.x
uses the new `Appsignal.View` module to gain insights into your template
rendering.

To upgrade, remove the `:template_engines` from `config/config.exs` and add `use
Appsignal.Phoenix.View` to the view/0 function in your app's web module, after
`use Phoenix.View`:

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

## Queries

Lastly, query instrumentation is automatic in 2.x, so you can remove the
`:telemetry.attach/4` call in your application module.

## Custom integrations

If you use `Appsignal.Transaction.set_action/1` to override action names for actions in your Plug or Phoenix app, switch to the newly added `Appsignal.Plug.put_name/2` which adds the new name to the conn. You'll have to make sure you call `put_name/2` on the conn that's returned in the action:

```elixir
defmodule AppsignalPlugExample do
  use Plug.Router
  use Appsignal.Plug
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> Appsignal.Plug.put_name("AppsignalPlugExample#index")
    |> send_resp(200, "Welcome")
  end
end
```

For pure Elixir apps, you can use `Appsignal.Span.set_name/2` to set the name directly on the current span:

```elixir
Appsignal.Span.set_name(Appsignal.Tracer.current_span(), "AppsignalElixirExample#index")
```

## Extra sample data

In 2.0, we handle sample data through adding tags or custom data, as explained in [the tagging guide](/elixir/instrumentation/tagging.html). To tag a sample with extra data, use the "tags" key:

```elixir
Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "tags", %{locale: "en"})
```

To add custom data as a map, add use the "custom_data" key:

```elixir
Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "custom_data", %{foo: "bar"})
```

-> **Note**: The "params", "session_data" or "environment" will be overwritten at the end of the request in Plug and Phoenix applications. We recommend using "custom_data" instead.

## Custom instrumentation

If you added custom instrumentation in your app you used `Appsignal.TransactionRegistry` in the past. In 2.x this is no longer necessary, you can instrument without using the registry. Please check out the [custom instrumentation documentation](/elixir/instrumentation/instrumentation.html) for more information about custom instrumentation in 2.x.

## Deprecated functions

2.x removed internal functions from the API that were no longer needed to
function.

First off, the `Appsignal.Plug` module was moved to the separate
`:appsignal_plug` package, and the `Appsignal.Phoenix.*` modules were
moved to `:appsignal_phoenix`.

Aside from that, the following modules and functions were removed:

### Removed modules

- `Appsignal.Backtrace`
- `Appsignal.ErrorHandler`
- `Appsignal.ErrorLoggerHandler`
- `Appsignal.LoggerHandler `
- `Appsignal.Transaction `
- `Appsignal.Transaction.ETS`
- `Appsignal.Transaction.Receiver `
- `Appsignal.Transaction.Registry`
- `Appsignal.Phoenix.Instrumenter `
- `Appsignal.Phoenix.Plug`
- `Appsignal.Phoenix.TemplateInstrumenter`

### Removed functions

- `Appsignal.Demo.create_transaction_error_request/0`
- `Appsignal.Demo.create_transaction_performance_request/0`
- `Appsignal.Ecto.log/1`
- `Appsignal.Error.metadata/1`
- `Appsignal.Error.normalize/2`
- `Appsignal.Instrumentation.Helpers.instrument/4`
- `Appsignal.Instrumentation.Helpers.instrument/5`
- `Appsignal.Instrumentation.Helpers.instrument/6`
- `Appsignal.Utils.MapFilter.filter_parameters/1`
- `Appsignal.Utils.MapFilter.filter_session_data/1`
- `Appsignal.Utils.MapFilter.filter_values/2`
- `Appsignal.Utils.MapFilter.get_filter_parameters/0`
- `Appsignal.Utils.MapFilter.get_filter_session_data/0`
- `Appsignal.plug?/0`
- `Appsignal.phoenix?/0`
- `Appsignal.live_view?/0`
- `Appsignal.add_report_handler/0`
- `Appsignal.remove_report_handler/0`
- `Appsignal.send_error/5`
- `Appsignal.send_error/6`
- `Appsignal.send_error/7`
- `Appsignal.Plug.handle_error/4`
- `Appsignal.Plug.finish_with_conn/2`
- `Appsignal.Plug.try_set_action/2`
- `Appsignal.Plug.extract_error_metadata/1`
- `Appsignal.Plug.extract_action/1`
- `Appsignal.Plug.extract_sample_data/1`
- `Appsignal.Plug.extract_request_headers/1`
- `Appsignal.Plug.extract_meta_data/1`
- `Appsignal.Phoenix.extract_error_metadata/3`
- `Appsignal.Phoenix.submit_http_error/5`
- `Appsignal.Phoenix.Channel.channel_action/5`
- `Appsignal.Phoenix.Channel.set_metadata/2`
- `Appsignal.Phoenix.Channel.handle_event/4`

## Welcome to 2.x!

This should cover upgrading most Phoenix applications to 2.x. If you have any questions, or would like assistance upgrading to the new version, please don't hesitate to [contact support](mailto:support@appsignal.com).
