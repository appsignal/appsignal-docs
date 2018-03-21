---
title: Plug actions registered as "unkown"
---

## Affected components

- AppSignal Elixir package versions: `v1.5.0-beta.1` - most recent

## Description

AppSignal groups performance and error samples by "action name". In Phoenix, we use the controller and action name (like `AppsignalPhoenixExampleWeb.UserController#show`). In pure Plug apps, it'd be best to fall back on the route name (like `/users/:id`), like we do for Sinatra apps in Ruby, but we can't currently get that data out of the `Plug.Conn`.

In versions before version 1.5.0-beta.1, `Appsignal.Plug` used the request method and the request path as the action name in plug-only apps. This caused problems for apps with unique URLs, as it creates a separate performance/error incident for each variation of the URL. To fix this, we're using "unknown" as the default action name in Plug apps, and we're allowing users to override that.

## Workaround

To override the "unknown" action name, use `Appsignal.Transaction.set_action/1` from anywhere within the action.

```elixir
get "/users/:id" do
  Appsignal.Transaction.set_action("GET /users/:id")
  send_resp(conn, 200, "Welcome")
end
```
