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

### Ruby

In a Rails controller we use a `before_action` callback to call a method before the request is handled by Rails. In this method we call the `Appsignal.set_namespace` helper method to configure the namespace for this request. This also works if the `AdminController` is subclassed by other controllers. All sub-controllers will be part of the "admin" namespace.

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

-> 🔁 Restart or deploy the changes for the namespace changes to be reported for the app.

#### A note on helper location

The `set_namespace` helpers used in this guide can be called in any action that starts an AppSignal transaction. We recommend calling this as early in the request or background job as possible, so the transaction is configured with the given namespace before any error occurs. Otherwise, if an error occurs—or anything else that stops the process—the transaction is sent to AppSignal before the `set_namespace` code is called and it is reported under the default namespace instead.

### Elixir

In a Phoenix controller we use a `plug` to call a function before the request is handled by Phoenix. In this function we call the `Appsignal.Transaction.set_namespace` helper to configure the namespace for this request.

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

-> 🔁 Restart or deploy the changes for the namespace changes to be reported for the app.

#### A note on helper location

The `set_namespace` helpers used in this guide can be called in any action that starts an AppSignal transaction. We recommend calling this as early in the request or background job as possible, so the transaction is configured with the given namespace before any error occurs. Otherwise, if an error occurs—or anything else that stops the process—the transaction is sent to AppSignal before the `set_namespace` code is called and it is reported under the default namespace instead.

### Node.js

In Node.js applications AppSignal works with spans to track metadata such as which namespace a span belongs to. The namespace can only be set on the "root span", or the first span that's created without any parent spans. When creating this root span, pass in the `namespace` option as a key with a `String` value that is the desired namespace name.

```js
const tracer = appsignal.tracer();
const span = tracer.createSpan({
  namespace: "custom-namespace", // a custom namespace for this span (defaults to `web`)
});
```

For more information, [read more about how spans work in Node.js](/nodejs/tracing/tracer.html).

-> 🔁 Restart or deploy the changes for the namespace changes to be reported for the app.

### JavaScript

In front-end JavaScript applications AppSignal works with spans to track metadata such as which namespace a span belongs to. The namespace can only be set on the "root span", or the first span that's created without any parent spans. When creating this root span, pass in the `namespace` option as a key with a `String` value that is the desired namespace name.

```js
const span = appsignal.createSpan()
span.setNamespace("admin") // a custom namespace for this span (defaults to `frontend`)
```

For more information, [read more about how spans work in Front-end JavaScript](front-end/span.html).

-> 🔁 Restart or deploy the changes for the namespace changes to be reported for the app.

## Next steps

- [Filtering app data][filtering] - Next guide
- [Read more about namespaces][namespaces] - More detailed information about namespaces
- [Ignoring namespaces][ignoring namespaces] - Ignore data from an entire namespace

---

- [Reporting deploys to AppSignal to track improvements](/guides/deploy-markers.html) - previous guide
- [Getting started guides](/guides/) - Guides overview

[namespaces]: /application/namespaces.html
[ignoring namespaces]: /application/namespaces.html#ignoring-namespaces
[filtering]: /guides/filter-data.html
