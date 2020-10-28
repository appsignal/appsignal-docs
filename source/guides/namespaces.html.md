---
title: "Grouping with namespaces"
---

By default AppSignal uses three [namespaces]: "web" for web requests, "frontend" for front-end JavaScript and "background" for background jobs. These namespaces are used to group actions for which errors and performance measurements are tracked.

Apps can have more than three of these namespaces, like an Administration panel, API, scheduled tasks, etc. In this guide we will go through the steps needed to report actions in custom namespaces.

-> 🔍 Want to know more about what namespaces can be used for? Check out this list: [what can you do with namespaces?](/application/namespaces.html#what-can-you-do-with-namespaces)

<figure>
  <img src="/assets/images/screenshots/app_graphs_namespaces.png">
  <figcaption>Example graphs with multiple namespaces, splitting out a GraphQL API and the "web" namespace. On the left a drop down with the namespace filter.</figcaption>
</figure>

## Configuring namespaces

Namespaces are set up from within the app code. With small helpers the namespace of an action can be customized. In this guide we will split up requests in an "admin" namespace and "critical" namespace for background jobs. Check the guide for the language your app uses below.

-> 💡 Only letters and underscores are accepted for namespace names.

### Ruby

In a Rails controller we use a `before_action` callback to call a method before the request is handled by Rails. In this method we call the [`Appsignal.set_namespace` helper method][ruby helper] to configure the namespace for this request. This also works if the `AdminController` is subclassed by other controllers. All sub-controllers will be part of the "admin" namespace.

```ruby
# In a Rails controller
# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  before_action :set_appsignal_namespace

  def set_appsignal_namespace
    # Configures all actions in this controller to report
    # in the "admin" namespace
    Appsignal.set_namespace("admin")
  end

  # Any other controller actions
end
```

In a Sidekiq background worker we'll need to call `Appsignal.set_namespace` as one of the first things in the worker to make sure it's set before any errors occur.

```ruby
# In a Sidekiq worker
# app/workers/critical_worker.rb
class CriticalWorker
  include Sidekiq::Worker

  def perform
    # Configures this worker's jobs to report in the "critical" namespace
    Appsignal.set_namespace("critical")

    # The actual worker code
  end
end
```

It's also possible to configure the namespace when creating the transaction. The second argument of[`Appsignal::Transaction.initialize`][transaction_initialize] accepts the namespace value.

```ruby
# When creating a new transaction
transaction = Appsignal::Transaction.create(
  SecureRandom.uuid, # Random transaction ID
  "admin", # Namespace
  Appsignal::Transaction::GenericRequest.new({}) # Default environment object
)

# When changing the namespace later on for a transaction
transaction.set_namespace("slow_admin")
```

#### A note on helper location

The `set_namespace` helpers used in this guide can be called in any action that starts an AppSignal transaction. We recommend calling this as early in the request or background job as possible, so the transaction is configured with the given namespace before any error occurs. Otherwise, if an error occurs—or anything else that stops the process—the transaction is sent to AppSignal before the `set_namespace` code is called and it is reported under the default namespace instead.

####^ruby Read more

- [`Appsignal.set_namespace` helper method documentation][ruby helper]

[ruby helper]: https://www.rubydoc.info/gems/appsignal/Appsignal/Helpers/Instrumentation#set_namespace-instance_method

### Elixir

In a Phoenix controller we use a `plug` to call a function before the request is handled by Phoenix. In this function we call the [`Appsignal.Transaction.set_namespace` helper][elixir helper] to configure the namespace for this request.

```elixir
# In a Phoenix controller
defmodule AppsignalPhoenixExampleWeb.AdminController do
  use AppsignalPhoenixExampleWeb, :controller

  plug :set_appsignal_namespace

  defp set_appsignal_namespace(conn, _params) do
    # Configures all actions in this controller to report
    # in the "admin" namespace
    Appsignal.Transaction.set_namespace(:admin)
    conn
  end

  # ...
end
```

In a background job call the `Appsignal.Transaction.set_namespace` at the beginning of the function, before any other code. This ensures that it's configured before any error can occur in the job.

```elixir
defmodule MyApp.CriticalJob do
  def run do
    # Configures this worker's jobs to report in the "critical" namespace
    Appsignal.Transaction.set_namespace(:critical)

    # The actual worker code
  end
end
```

It's also possible to configure the namespace when creating a transaction. Please see the documentation for [decorators][elixir namespace_decorator] or [instrumentation helpers][elixir namespace_helper] on how to configure a namespace.

####^elixir A note on helper location

The `set_namespace` helpers used in this guide can be called in any action that starts an AppSignal transaction. We recommend calling this as early in the request or background job as possible, so the transaction is configured with the given namespace before any error occurs. Otherwise, if an error occurs—or anything else that stops the process—the transaction is sent to AppSignal before the `set_namespace` code is called and it is reported under the default namespace instead.

####^elixir Read more

- [`Appsignal.Transaction.set_namespace` helper method documentation][elixir helper]
- [Elixir namespace decorator][elixir namespace_decorator]
- [Elixir namespace instrumentation helper][elixir namespace_helper]

[elixir helper]: https://hexdocs.pm/appsignal/Appsignal.Transaction.html?#set_namespace/1
[elixir namespace_decorator]: /elixir/instrumentation/instrumentation.html#decorator-namespaces
[elixir namespace_helper]: /elixir/instrumentation/instrumentation.html#helper-namespaces

### Node.js

In Node.js applications AppSignal works with Spans to track metadata such as which namespace a Span belongs to. The namespace can only be set on the "root span", or the first span that's created without any parent spans. All children of this Span will inherit the namespace of the parent Span. When creating this root span, pass in the `namespace` option as a key with a `String` value that is the desired namespace name.

In a scenario where the Node.js `http` integration is not used and you need to create your own `RootSpan` (for example, in a worker or CLI tool), a `RootSpan` can be given a custom namespace like this:

```js
const tracer = appsignal.tracer();
const span = tracer.createSpan({
  namespace: "custom-namespace" // a custom namespace for this span (defaults to `web`)
});
```

For more information, [read more about how Spans work in Node.js](/nodejs/tracing/tracer.html).

### JavaScript

In front-end JavaScript applications AppSignal works with spans to track metadata such as which namespace a span belongs to. The namespace can only be set on the "root span", or the first span that's created without any parent spans. When creating this root span, pass in the `namespace` option as a key with a `String` value that is the desired namespace name.

```js
const span = appsignal.createSpan()
span.setNamespace("admin") // a custom namespace for this span (defaults to `frontend`)
```

For more information, [read more about how spans work in Front-end JavaScript](front-end/span.html).

## Deploy

After the app has been configured with the namespace helpers, commit your changes and deploy the app. When the app starts/restarts, AppSignal will report the actions under the new namespace. Data from older deploys, grouping actions under their original namespaces, is not moved to the new namespace location.

Are namespaces not being reported or incorrectly? [Contact us][contact] and we will help you out!

## Next steps

- [Filtering app data][filtering] - Next guide
- [Read more about namespaces][namespaces] - More detailed information about namespaces
- [Ignoring namespaces][ignoring namespaces] - Ignore data from an entire namespace

---

- [Reporting deploys to AppSignal to track improvements](/guides/deploy-markers.html) - previous guide
- [Getting started guides](/guides/) - Guides overview

[namespaces]: /application/namespaces.html
[ignoring namespaces]: /guides/filter-data/ignore-namespaces.html
[filtering]: /guides/filter-data/
[contact]: mailto:support@appsignal.com
